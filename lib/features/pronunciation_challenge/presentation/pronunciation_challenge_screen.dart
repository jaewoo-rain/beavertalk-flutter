import 'dart:async';
import '../../../theme/app_color_tokens.dart';
import 'dart:io' show File;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/app_scaffold.dart';
import '../../../components/atoms/button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../data/camera_service.dart';
import '../data/challenge_recorder.dart';
import '../data/curated_word_source.dart';
import '../data/stt_service.dart';
import '../domain/challenge_engine.dart';
import '../domain/game_config.dart';
import 'challenge_controller.dart';
import 'challenge_painter.dart';

/// Screen phases (which overlay panel is shown over the live game canvas).
enum _Phase { start, loading, countdown, playing, paused, result, blocked }

/// Background of the 9:16 game stage.
///
/// The challenge renders **light-on-dark in both themes**: the panel scrim is a
/// fixed `0xD1080A0C`, and the painter's HUD, belt and card text are hard-coded
/// white. So the stage cannot follow `backgroundNormalNormal` — in Light that
/// resolves to `#F1F1F5`, and the white HUD vanished onto a white canvas
/// whenever the camera was off (denied permission, web, or before consent).
/// Pinned to the Dark token's value, so the dark appearance is unchanged.
const Color _kStageBackground = Color(0xFF181A20);

/// Ink for text drawn on the always-dark panel scrim.
///
/// Same root cause as [_kStageBackground]: these panels sit on a fixed dark
/// scrim, so their text must be statically light. Bound to `labelStrong` /
/// `labelNormal` / `labelDisabled` it turned near-black in Light and the whole
/// start panel became unreadable. Opacities mirror those three label tiers.
/// (Same reasoning as `CallToggleButton`, which already picks `staticWhite`
/// over `labelStrong` for exactly this reason.)
Color _stageInk(BuildContext context) => context.c.staticWhite;

/// Secondary tier of [_stageInk] — stands in for `labelNormal`.
Color _stageInkNormal(BuildContext context) =>
    context.c.staticWhite.withValues(alpha: 0.72);

/// Muted tier of [_stageInk] — stands in for `labelDisabled`.
Color _stageInkMuted(BuildContext context) =>
    context.c.staticWhite.withValues(alpha: 0.45);

/// Pronunciation Challenge — a Ticker + CustomPainter mini-game.
///
/// PHASE 2/3: live Korean STT (server Google Speech-to-Text over a single mic
/// PCM capture streamed via WebSocket) is the primary input, with tap-to-pass
/// kept as a fallback when STT is unavailable (web / denied mic / STT server
/// unreachable). A front-camera selfie backdrop sits behind the canvas when
/// available; the result panel shares and saves the recorded clip.
///
/// Everything degrades gracefully: with no mic, camera, model, or on web, the
/// game is still fully playable via tap on the solid [_kStageBackground] and
/// never crashes on missing hardware.
class PronunciationChallengeScreen extends ConsumerStatefulWidget {
  /// Creates the challenge screen.
  const PronunciationChallengeScreen({super.key});

  @override
  ConsumerState<PronunciationChallengeScreen> createState() =>
      _PronunciationChallengeScreenState();
}

class _PronunciationChallengeScreenState
    extends ConsumerState<PronunciationChallengeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final ChallengeController _controller;
  final SttService _stt = SttService();
  final ChallengeCameraService _camera = ChallengeCameraService();
  final ChallengeRecorder _recorder = ChallengeRecorder();

  _Phase _phase = _Phase.start;
  int _countdown = 3;
  Timer? _countdownTimer;

  /// Whether STT is driving input this round (false → tap fallback active).
  bool _sttActive = false;

  /// Whether the player opted to screen-record this run (start-panel toggle).
  ///
  /// On by default where recording exists at all; forced off elsewhere.
  ///
  /// The clip is what this mode produces and both share and save hang off it,
  /// so off-by-default left most runs with nothing. On iOS and web there is no
  /// capture, so the flag stays false and the toggle is not offered.
  bool _recordEnabled = ChallengeRecorder.isSupported;

  /// Path of the recorded gameplay MP4, when a run was captured. Shared from
  /// the result panel in place of the score-card image.
  String? _videoPath;

  /// Whether STT was actively driving input right before the app was
  /// backgrounded, so [_onAppResumed] knows whether to try restarting it.
  bool _sttActiveBeforePause = false;

  /// The word the round will open with, shown during the countdown.
  String? _firstWord;

  /// Guards the one-time [didChangeDependencies] setup (needs route args, which
  /// aren't available in [initState]).
  bool _setup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Re-arm tap fallback if STT flips to unavailable mid-round.
    _stt.status.addListener(_onSttStatusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_setup) return;
    _setup = true;

    // Learned sentences for this call are passed as route arguments
    // (`analysis.dart`). When present the game draws from them and matches whole
    // spoken sentences; otherwise it falls back to the default word list and
    // per-word matching, so direct entry still works.
    final args = ModalRoute.of(context)?.settings.arguments;
    final sentences = args is List<String>
        ? args.where((s) => s.trim().isNotEmpty).toList(growable: false)
        : const <String>[];
    final useSentences = sentences.isNotEmpty;

    final engine = ChallengeEngine(
      wordSource: CuratedWordSource(items: useSentences ? sentences : null),
    );
    _controller = ChallengeController(vsync: this, engine: engine);
    if (useSentences) {
      _stt.sentenceMode = true;
      _stt.onTranscript = engine.tryPassSentence;
      // Hint the recognizer with the sentences actually on the cards. Left at
      // the default noun list it pulls a spoken sentence toward those nouns.
      _stt.hints = sentences;
    } else {
      _stt.onToken = engine.tryPassToken;
    }
    _controller.addListener(_onFrame);
    // Ticker runs continuously so the belt animates behind every panel.
    _controller.startTicker();
  }

  /// Detects STT going dark mid-round (e.g. the pump watchdog tripping after
  /// repeated recognizer failures) and re-arms tap input.
  void _onSttStatusChanged() {
    if (_sttActive && _stt.status.value == SttStatus.unavailable) {
      setState(() => _sttActive = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        unawaited(_onAppPaused());
        break;
      case AppLifecycleState.resumed:
        unawaited(_onAppResumed());
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Backgrounded: the OS can invalidate the `CameraController` at any time,
  /// and the mic stream would go silent anyway — release both cleanly rather
  /// than let them fail mid-operation.
  Future<void> _onAppPaused() async {
    // Leaving the app pauses the round. Without this the clock kept running
    // in the background and the player came back to a finished game — the
    // web's equivalent was a hidden tab (기능 변형 note).
    if (_phase == _Phase.playing) {
      _controller.pauseClock();
      if (mounted) setState(() => _phase = _Phase.paused);
    }
    await _camera.pause();
    _sttActiveBeforePause = _sttActive;
    if (_sttActive) {
      await _stt.stopListening();
      if (mounted) setState(() => _sttActive = false);
    }
  }

  /// Foregrounded: rebuild the camera preview (standard `camera` package
  /// pause/resume pattern) and, if we were mid-round on STT input, try to
  /// resume it — treating a failure to restart as an STT failure so tap
  /// input takes back over.
  Future<void> _onAppResumed() async {
    await _camera.init();
    if (!mounted) return;
    if (_phase == _Phase.playing && _sttActiveBeforePause) {
      final resumed = await _stt.startListening();
      if (mounted) setState(() => _sttActive = resumed);
    } else {
      setState(() {});
    }
    _sttActiveBeforePause = false;
  }

  /// Detects the running→ended transition to reveal the result panel.
  void _onFrame() {
    if (_phase == _Phase.playing && !_controller.engine.running) {
      _countdownTimer?.cancel();
      unawaited(_stt.stopListening());
      _sttActive = false;
      // Finalize the clip (if any) before showing the result panel so the
      // Share button can offer the MP4.
      if (_recorder.isRecording) {
        _recorder.stop().then((path) {
          if (mounted) setState(() => _videoPath = path);
        });
      }
      setState(() => _phase = _Phase.result);
    }
  }

  /// Start: initialize camera (backdrop) + STT (marks the platform capable; the
  /// STT WebSocket opens during the countdown, see [_beginCountdown]), then
  /// count down and play. Both inits are best-effort and degrade gracefully.
  Future<void> _onStart() async {
    setState(() => _phase = _Phase.loading);
    // Camera + STT init concurrently. Neither can throw (both return bool).
    final results = await Future.wait<bool>(<Future<bool>>[
      _camera.init(),
      _stt.init(),
    ]);
    final sttReady = results[1];
    if (!mounted) return;
    // Neither capture came up — that is the blocked case, and it has its own
    // screen with the one action that can fix it.
    if (!results[0] && !sttReady) {
      setState(() => _phase = _Phase.blocked);
      return;
    }
    _beginCountdown(sttReady: sttReady);
  }

  void _beginCountdown({required bool sttReady, bool resuming = false}) {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = 3;
      _firstWord = resuming ? null : _controller.engine.peekFirstWord();
    });
    // Open the recognizer NOW, in parallel with the count, and hand the pending
    // future to [_startPlaying].
    //
    // The old order connected *after* `engine.start()`, so the handshake ran on
    // the clock: a cold backend spent the first seconds of a 30-second round
    // shaking hands, and if it outran the timeout the whole round silently fell
    // back to tap. The web avoids this by calling `prepareStt()` before the
    // game starts — "게임이 시작될 땐 이미 인식이 살아 있어야 한다". The 3·2·1
    // (2.4s) is exactly the cover that was going unused.
    final Future<bool> pendingStt =
        sttReady ? _stt.startListening() : Future<bool>.value(false);
    // Mirror the web game's 800ms cadence (lines 399–404).
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      _countdown--;
      if (_countdown <= 0) {
        t.cancel();
        _startPlaying(pendingStt: pendingStt, resuming: resuming);
      } else {
        setState(() {});
      }
    });
  }

  Future<void> _startPlaying(
      {required Future<bool> pendingStt, bool resuming = false}) async {
    // Best-effort screen capture; started just before the engine so the whole
    // run is in-frame. Never blocks or fails the game.
    if (_recordEnabled && !_recorder.isRecording) {
      _videoPath = null;
      await _recorder.start();
      if (!mounted) return;
    }
    // A resume picks the same round back up; only a fresh run resets it.
    if (!resuming) _controller.engine.start();
    setState(() => _phase = _Phase.playing);
    // Usually already settled by now (the countdown covered it). Resolves to
    // false when the mic was denied at capture time or the socket never came
    // up — either way the tap fallback is what stays armed.
    _sttActive = await pendingStt;
    if (mounted) setState(() {});
  }

  /// Tap fallback: only passes cards when STT is NOT the active input.
  void _onTapDown() {
    if (_phase == _Phase.playing && !_sttActive) {
      _controller.engine.tapPass();
    }
  }

  /// Resume from the pause panel: count back in, then let the clock run.
  void _resumeFromPause() {
    _controller.resumeClock();
    _beginCountdown(sttReady: _stt.isAvailable, resuming: true);
  }

  /// Replay from the result panel (STT/camera already initialized).
  void _replay() {
    _beginCountdown(sttReady: _stt.isAvailable);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stt.status.removeListener(_onSttStatusChanged);
    _countdownTimer?.cancel();
    _controller.removeListener(_onFrame);
    _controller.dispose();
    unawaited(_stt.dispose());
    unawaited(_camera.dispose());
    unawaited(_recorder.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The stage is bottom-anchored, not centred (Figma `GameCanvas
    // (1080x1920 @ 0.347)` sits at y=145 and runs to the bottom edge). The two
    // HUD rows live above it as widgets — the canvas no longer paints them.
    return AppScaffold(
      background: _kStageBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                // ── 9:16 stage: camera backdrop + game canvas ──
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) => _onTapDown(),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Stage floor. The camera preview is fit-WIDTH, so
                            // it leaves the bottom of the 9:16 stage uncovered;
                            // without this the page background shows through
                            // there and the tunnel's HUD row (MIC / MISS, at
                            // design y 1802) lands on white in light mode. The
                            // web fills the same gap with a dimmed copy of the
                            // frame.
                            const ColoredBox(color: _kStageBackground),
                            _cameraBackdrop(),
                            CustomPaint(
                              painter: ChallengePainter(
                                mint: context.c.primaryNormal,
                                background: _kStageBackground,
                                engine: _controller.engine,
                                repaint: _controller,
                                cameraActive: _camera.isReady,
                                micLevel: _stt.micLevel,
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // ── HUD rows (Figma `HUD/top` y=52, `HUD/status` y=104) ──
                if (_phase == _Phase.playing)
                  // Rebuilt every tick. The HUD reads engine state that the
                  // ticker advances 60×/s, but `_onFrame` only calls setState
                  // on a phase change — so as widgets these froze at whatever
                  // the last rebuild held while the canvas kept running.
                  Positioned.fill(
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) =>
                          Stack(children: _hudRows(context)),
                    ),
                  ),
                // ── back, always reachable ──
                _backButton(context),
                // ── overlay panels ──
                if (_phase == _Phase.start) _startPanel(),
                if (_phase == _Phase.loading) _loadingPanel(),
                if (_phase == _Phase.countdown) _countdownPanel(),
                if (_phase == _Phase.paused) _pausedPanel(),
                if (_phase == _Phase.result) _resultPanel(),
                if (_phase == _Phase.blocked) _blockedPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Back control — 44dp, top-left of `HUD/top`.
  ///
  /// Replaces the app GNB on this screen. The design has no title bar: the
  /// camera runs edge to edge and a solid header would cut the stage.
  /// The web's 96px hit target is adjusted to 44dp here (규격 note).
  Widget _backButton(BuildContext context) {
    return Positioned(
      left: 16,
      top: 52,
      child: SizedBox(
        width: 44,
        height: 44,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: context.c.staticWhite),
        ),
      ),
    );
  }

  /// The two HUD rows, as widgets above the canvas.
  ///
  /// They used to be painted into the 1080×1920 canvas at its bottom edge.
  /// The design lifts them out: row one is timer + score, row two is the mic
  /// gauge, the combo chip and the miss dots. Labels (SCORE / MIC / MISS) are
  /// gone — "수치·게이지·점만 남김" — so the numbers carry themselves.
  List<Widget> _hudRows(BuildContext context) {
    final engine = _controller.engine;
    final mm = (engine.sessionLeft / 60).floor();
    final ss = (engine.sessionLeft % 60).floor();
    return <Widget>[
      // Row 1 — timer pill (centre) + score (right). Back sits at the left.
      Positioned(
        left: 16,
        top: 52,
        right: 16,
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 44), // the back button's slot
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: context.c.backgroundNormalDeep,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '$mm:${ss.toString().padLeft(2, '0')}',
                style: AppType.heading1.b.copyWith(
                  color: engine.sessionLeft <= 10
                      ? const Color(0xFFFF7070)
                      : context.c.commonWhiteAndDark,
                ),
              ),
            ),
            // Natural width, not a 44dp slot mirroring the back button —
            // a five-digit score does not fit in one.
            Text(
              _thousands(engine.score),
              textAlign: TextAlign.right,
              style: AppType.heading1.b
                  .copyWith(color: context.c.commonWhiteAndDark),
            ),
          ],
        ),
      ),
      // Row 2 — mic gauge · combo chip · miss dots.
      Positioned(
        left: 16,
        top: 104,
        right: 16,
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _stt.micLevel,
              builder: (context, level, _) => _micGauge(context, level),
            ),
            if (engine.combo > 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.c.primaryNormal,
                  borderRadius: BorderRadius.circular(12),
                ),
                // Dark ink on the mint chip. Mint-on-mint was unreadable in the
                // original — one of the defects the design run fixed.
                child: Text(
                  'COMBO ×${engine.combo}',
                  style: AppType.caption1.b
                      .copyWith(color: context.c.commonDarkAndWhite),
                ),
              )
            else
              const SizedBox.shrink(),
            _missDots(context, engine),
          ],
        ),
      ),
    ];
  }

  /// Mic level: an 84×8 track that fills mint with the live level.
  Widget _micGauge(BuildContext context, double level) {
    return SizedBox(
      width: 84,
      height: 8,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.c.staticWhite,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const SizedBox(width: 84, height: 8),
          ),
          FractionallySizedBox(
            widthFactor: level.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.c.primaryNormal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }

  /// One 8×8 dot per allowed miss; spent ones turn red.
  Widget _missDots(BuildContext context, ChallengeEngine engine) {
    final allow = engine.difficulty.missAllow;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < allow; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 4),
          DecoratedBox(
            decoration: BoxDecoration(
              color: i < engine.backlog
                  ? const Color(0xFFFF7070)
                  : context.c.staticWhite,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const SizedBox(width: 8, height: 8),
          ),
        ],
      ],
    );
  }

  // ── camera backdrop (mirrored selfie; web drawCamera parity) ─────────
  Widget _cameraBackdrop() {
    final controller = _camera.controller;
    if (!_camera.isReady || controller == null) {
      return const SizedBox.expand(); // solid painter background shows instead
    }
    final preview = controller.value.previewSize;
    // previewSize is reported in sensor orientation (landscape); swap W/H for
    // the portrait stage.
    final w = preview?.height ?? 9;
    final h = preview?.width ?? 16;
    // Fit-WIDTH (not cover): fill the stage width and let the height crop, so
    // the selfie isn't over-zoomed — cover scales to the taller dimension and
    // blows the face up (web drawCamera parity, lines 669–676, which uses
    // scale = W/vw for exactly this reason). Bias the crop ~30% toward the top
    // (web dy≈0.30) so the face sits up top and the belt / mic gauge keep room
    // at the bottom. No manual mirror: the earlier horizontal flip made the
    // preview read as left–right reversed, so the front camera is shown as-is.
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        alignment: const Alignment(0, -0.4),
        child: SizedBox(
          width: w,
          height: h,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  // ── panels ──────────────────────────────────────────────────────────
  /// Overlay panel: body centred, [actions] pinned to the bottom edge.
  ///
  /// Every panel in the design puts its buttons on the floor (`y=646`/`650`
  /// of 812, above the home indicator) — not trailing the content. Centring
  /// the whole column let the CTA float wherever the body happened to end,
  /// so the start button and the pause buttons landed at different heights.
  Widget _panelShell({
    required List<Widget> children,
    List<Widget> actions = const <Widget>[],
  }) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD1080A0C), // rgba(8,10,12,.82)
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s24, AppSpacing.s20, AppSpacing.s20),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  ),
                ),
                if (actions.isNotEmpty) ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _startPanel() {
    final l10n = AppLocalizations.of(context);
    return _panelShell(
      children: [
        Text(
          l10n.challengeTitle,
          textAlign: TextAlign.center,
          style: AppType.title2.b.copyWith(color: _stageInk(context)),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          l10n.challengeIntro,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: _stageInkNormal(context)),
        ),
        const SizedBox(height: AppSpacing.s24),
        _difficultyToggle(),
        if (ChallengeRecorder.isSupported) ...[
          const SizedBox(height: AppSpacing.s16),
          _recordToggle(l10n),
        ],
        const SizedBox(height: AppSpacing.s24),
        // Fill, not hug: the result panel's CTAs are Row+Expanded and span the
        // panel, so a label-width start button read as a different control in
        // the same overlay. _panelShell's Column is centre-aligned, so the
        // width has to come from here.
      ],
      actions: [
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.challengeStart,
            onPressed: _onStart,
          ),
        ),
      ],
    );
  }

  /// Opt-in gameplay screen-recording toggle (start panel). Off by default so
  /// the OS MediaProjection consent sheet only appears for players who want a
  /// clip. Records video only — see [ChallengeRecorder] for the audio rationale.
  Widget _recordToggle(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.challengeRecordToggle,
                style: AppType.body2.sb.copyWith(color: _stageInk(context)),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.challengeRecordHint,
                style: AppType.label2.r.copyWith(color: _stageInkMuted(context)),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Switch(
          value: _recordEnabled,
          activeThumbColor: context.c.primaryNormal,
          onChanged: (v) => setState(() => _recordEnabled = v),
        ),
      ],
    );
  }

  Widget _loadingPanel() {
    final l10n = AppLocalizations.of(context);
    return _panelShell(
      children: [
        Text(
          l10n.challengeLoadingTitle,
          textAlign: TextAlign.center,
          style: AppType.title2.b.copyWith(color: _stageInk(context)),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          l10n.challengeLoadingNote,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: _stageInkNormal(context)),
        ),
        const SizedBox(height: AppSpacing.s24),
        CircularProgressIndicator(color: context.c.primaryNormal),
      ],
    );
  }

  Widget _countdownPanel() {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD1080A0C),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_countdown',
                style: AppType.display1.b.copyWith(
                  color: _stageInk(context),
                  fontSize: 120,
                  height: 1,
                ),
              ),
              // The first word, previewed while the count runs. Reading it
              // cold at k=0.25 is the hardest moment of the round; the design
              // spends the countdown on it instead of on a readiness list.
              if (_firstWord != null) ...[
                const SizedBox(height: AppSpacing.s16),
                Text(
                  AppLocalizations.of(context).challengeFirstWord,
                  style: AppType.label2.r
                      .copyWith(color: _stageInkMuted(context)),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  _firstWord!,
                  textAlign: TextAlign.center,
                  style: AppType.title2.b.copyWith(color: _stageInk(context)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Result — Figma `screen/pron_result`.
  ///
  /// Score hero, then the clip with its own share pill, then the two-step
  /// action stack. The design deliberately keeps share **on the clip** rather
  /// than as a third full-width button: a third button would undo the density
  /// pass, and what is being shared is the clip, so it reads better attached
  /// to it.
  Widget _resultPanel() {
    final l10n = AppLocalizations.of(context);
    final engine = _controller.engine;
    return _panelShell(
      children: [
        Text(
          'Score',
          style: AppType.label1.b.copyWith(color: context.c.primaryNormal),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          _thousands(engine.score),
          style: AppType.display1.b.copyWith(
            color: _stageInk(context),
            fontSize: 40,
            height: 1.2,
          ),
        ),
        // Score alone. The design's hero is the number, and the stats line
        // that sat here read as a caption stack — exactly what the density
        // pass removed everywhere else.
        const SizedBox(height: AppSpacing.s24),
        // Clip + its own actions. All of it is gone when nothing was recorded:
        // there is no clip to preview, share or save, and an empty white card
        // with a dead play button is worse than no card.
        if (_hasClip) ...[
          _clipPreview(context),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _clipAction(context, Icons.share, l10n.share, _shareResult),
              const SizedBox(width: AppSpacing.s8),
              _clipAction(context, Icons.download_rounded, l10n.save,
                  _saveClipToGallery),
            ],
          ),
        ],
        if (!_stt.isAvailable)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s16),
            child: Text(
              l10n.challengeSttFallback,
              textAlign: TextAlign.center,
              style: AppType.label2.r.copyWith(color: const Color(0xFFFFCF5C)),
            ),
          ),
      ],
      actions: [
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            // 돌아가기, not 결과 보기: this IS the result. The pause panel
            // keeps 결과 보기 because there the button ends the round.
            text: l10n.challengeGoBack,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.playAgain,
            onPressed: _replay,
          ),
        ),
      ],
    );
  }

  /// Saves the recorded clip to the device gallery.
  ///
  /// Separate from share on purpose: sharing hands the file to another app and
  /// leaves nothing behind, which is the wrong verb for "I want to keep this".
  Future<void> _saveClipToGallery() async {
    final path = _videoPath;
    if (path == null || !File(path).existsSync()) return;
    final l10n = AppLocalizations.of(context);
    String message;
    try {
      // Ask only when we don't already hold it — on Android 33+ this is a
      // no-op and the plugin writes through MediaStore.
      if (!await Gal.hasAccess(toAlbum: true)) {
        await Gal.requestAccess(toAlbum: true);
      }
      // No album. Naming one put the clip in `Pictures/BeaverTalk/` — a
      // photo directory — where a device gallery does not necessarily surface
      // a video (measured on the S8, 2026-09-09: the file and its MediaStore
      // row both existed and the album still did not show up). Without it the
      // plugin uses the platform's standard video location.
      await Gal.putVideo(path);
      message = l10n.saveDone;
    } on GalException catch (e) {
      debugPrint('gallery save failed: ${e.type}');
      message = e.type == GalExceptionType.accessDenied
          ? l10n.saveDeniedNote
          : l10n.saveFailed;
    } catch (e) {
      debugPrint('gallery save failed: $e');
      message = l10n.saveFailed;
    }
    if (!mounted) return;
    // Long enough to actually be read. At the default 4s the confirmation was
    // gone before anyone looked, which reads as "nothing happened".
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Whether this run left a clip to share or save.
  bool get _hasClip {
    final path = _videoPath;
    return path != null && File(path).existsSync();
  }

  /// Paused — Figma `screen/pron_paused`.
  ///
  /// Reached by leaving the app or taking a call (the web's trigger was a
  /// hidden tab). The stats card exists so the round can be judged before
  /// deciding whether to resume or bail.
  Widget _pausedPanel() {
    final l10n = AppLocalizations.of(context);
    final engine = _controller.engine;
    final mm = (engine.sessionLeft / 60).floor();
    final ss = (engine.sessionLeft % 60).floor();
    return _panelShell(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _pauseBar(context),
            const SizedBox(width: 9),
            _pauseBar(context),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(
          l10n.challengePaused,
          style: AppType.title2.b.copyWith(color: _stageInk(context)),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          l10n.challengePausedNote,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: _stageInkNormal(context)),
        ),
        const SizedBox(height: AppSpacing.s24),
        Container(
          height: 76,
          decoration: BoxDecoration(
            color: context.c.staticWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _pauseStat(context, l10n.challengeTimeLeft,
                    '$mm:${ss.toString().padLeft(2, '0')}'),
              ),
              Expanded(
                child: _pauseStat(context, l10n.challengeScoreLabel,
                    _thousands(engine.score)),
              ),
            ],
          ),
        ),
      ],
      actions: [
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.challengeSeeAnalysis,
            onPressed: () {
              _controller.engine.endGame();
              setState(() => _phase = _Phase.result);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.challengeResume,
            onPressed: _resumeFromPause,
          ),
        ),
      ],
    );
  }

  Widget _pauseBar(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.c.primaryNormal,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const SizedBox(width: 10, height: 34),
      );

  Widget _pauseStat(BuildContext context, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
            style: AppType.caption2.b
                .copyWith(color: context.c.labelNeutral)),
        const SizedBox(height: 2),
        Text(value,
            style: AppType.heading1.b
                .copyWith(color: context.c.commonDarkAndWhite)),
      ],
    );
  }

  /// Blocked — Figma `screen/pron_permission`.
  ///
  /// Shown when the mic or camera cannot be opened. The web's causes were
  /// browser-shaped (in-app browser, address-bar lock); here they are a denied
  /// permission or a camera another app already holds, so the fix is Settings.
  Widget _blockedPanel() {
    final l10n = AppLocalizations.of(context);
    return _panelShell(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: context.c.primaryNormal,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          // Dark ink, not mint: mint-on-mint was unreadable, one of the two
          // contrast defects the design run called out.
          child: Text(
            '!',
            style: AppType.title1.b
                .copyWith(color: context.c.commonDarkAndWhite),
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(
          l10n.challengeBlockedTitle,
          textAlign: TextAlign.center,
          style: AppType.title2.b.copyWith(color: _stageInk(context)),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          l10n.challengeBlockedNote,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: _stageInkNormal(context)),
        ),
      ],
      actions: [
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.challengeGoBack,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.challengeOpenSettings,
            onPressed: () => unawaited(openAppSettings()),
          ),
        ),
      ],
    );
  }

  /// The recorded clip, as a white card with a mint play button (88×148).
  Widget _clipPreview(BuildContext context) {
    return GestureDetector(
      onTap: _shareResult,
      child: Container(
        width: 88,
        height: 148,
        decoration: BoxDecoration(
          color: context.c.staticWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.c.primaryNormal,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow_rounded,
                size: 24, color: context.c.commonDarkAndWhite),
          ),
        ),
      ),
    );
  }

  /// Outline pill under the clip — share and save both use this shape.
  ///
  /// They hang off the clip rather than joining the bottom stack: a third and
  /// fourth full-width button would undo the design's density pass, and what
  /// these act on is the clip sitting right above them.
  Widget _clipAction(
    BuildContext context,
    IconData icon,
    String label,
    Future<void> Function() onTap,
  ) {
    return OutlinedButton.icon(
      onPressed: () => unawaited(onTap()),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: BorderSide(color: context.c.primaryNormal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      icon: Icon(icon, size: 18, color: context.c.primaryNormal),
      label: Text(
        label,
        style: AppType.body1.b.copyWith(color: context.c.primaryNormal),
      ),
    );
  }


  /// Shares the recorded clip.
  ///
  /// Clip-only. The old branded-PNG fallback existed for runs with no
  /// recording, but the share action is hidden in exactly that case, so the
  /// fallback was unreachable — and it had gone silently broken: it captured
  /// through an `Offstage` RepaintBoundary, which is never painted, so
  /// `toImage()` had nothing to read.
  Future<void> _shareResult() async {
    final path = _videoPath;
    if (path == null || !File(path).existsSync()) return;
    try {
      await SharePlus.instance.share(
        ShareParams(text: _shareText(), files: <XFile>[XFile(path)]),
      );
    } catch (e) {
      debugPrint('share failed: $e');
    }
  }

  /// Share copy — the web game's `shareText()`, with the real score.
  String _shareText() {
    return '''
Think your Korean is good?

Beaver just proved you wrong.

His score: ${_thousands(_controller.engine.score)}

Yours?

👉 https://www.beavertalk.im'''
        .trimLeft();
  }

  Widget _difficultyToggle() {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.difficultyLabel,
          style: AppType.label2.b.copyWith(color: _stageInkMuted(context)),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _diffButton(Difficulty.slow, l10n.difficultySlow),
            const SizedBox(width: AppSpacing.s8),
            _diffButton(Difficulty.normal, l10n.difficultyNormal),
            const SizedBox(width: AppSpacing.s8),
            _diffButton(Difficulty.fast, l10n.difficultyFast),
          ],
        ),
      ],
    );
  }

  Widget _diffButton(Difficulty d, String label) {
    final active = _controller.difficulty == d;
    return Button(
      type: active ? BtnType.primaryFill : BtnType.secondaryFill,
      size: BtnSize.s36,
      text: label,
      onPressed: () => setState(() => _controller.difficulty = d),
    );
  }

  /// Formats an int with thousands separators.
  String _thousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
