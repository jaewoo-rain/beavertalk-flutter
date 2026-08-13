import 'dart:async';
import '../../../theme/app_color_tokens.dart';
import 'dart:io' show File;
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/app_scaffold.dart';
import '../../../components/atoms/button.dart';
import '../../../components/organisms/gnb.dart';
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
enum _Phase { start, loading, countdown, playing, result }

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
/// unreachable). A
/// front-camera selfie backdrop sits behind the canvas when available; the
/// result panel shares a branded score-card image via `share_plus`.
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
  final GlobalKey _shareCardKey = GlobalKey();

  _Phase _phase = _Phase.start;
  int _countdown = 3;
  Timer? _countdownTimer;

  /// Whether STT is driving input this round (false → tap fallback active).
  bool _sttActive = false;

  /// Whether the player opted to screen-record this run (start-panel toggle).
  bool _recordEnabled = false;

  /// Path of the recorded gameplay MP4, when a run was captured. Shared from
  /// the result panel in place of the score-card image.
  String? _videoPath;

  /// Whether STT was actively driving input right before the app was
  /// backgrounded, so [_onAppResumed] knows whether to try restarting it.
  bool _sttActiveBeforePause = false;

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
  /// STT WebSocket connects at [_startPlaying]), then count down and play. Both
  /// inits are best-effort and degrade gracefully.
  Future<void> _onStart() async {
    setState(() => _phase = _Phase.loading);
    // Camera + STT init concurrently. Neither can throw (both return bool).
    final results = await Future.wait<bool>(<Future<bool>>[
      _camera.init(),
      _stt.init(),
    ]);
    final sttReady = results[1];
    if (!mounted) return;
    _beginCountdown(sttReady: sttReady);
  }

  void _beginCountdown({required bool sttReady}) {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = 3;
    });
    // Mirror the web game's 800ms cadence (lines 399–404).
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      _countdown--;
      if (_countdown <= 0) {
        t.cancel();
        _startPlaying(sttReady: sttReady);
      } else {
        setState(() {});
      }
    });
  }

  Future<void> _startPlaying({required bool sttReady}) async {
    // Best-effort screen capture; started just before the engine so the whole
    // run is in-frame. Never blocks or fails the game.
    if (_recordEnabled && !_recorder.isRecording) {
      _videoPath = null;
      await _recorder.start();
      if (!mounted) return;
    }
    _controller.engine.start();
    setState(() => _phase = _Phase.playing);
    if (sttReady) {
      // startListening also returns false if the mic is denied at capture time.
      _sttActive = await _stt.startListening();
      if (mounted) setState(() {});
    } else {
      _sttActive = false;
    }
  }

  /// Tap fallback: only passes cards when STT is NOT the active input.
  void _onTapDown() {
    if (_phase == _Phase.playing && !_sttActive) {
      _controller.engine.tapPass();
    }
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
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: AppLocalizations.of(context).challengeTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                // ── 9:16 stage: camera backdrop + game canvas ──
                Positioned.fill(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) => _onTapDown(),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
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
                // ── overlay panels ──
                if (_phase == _Phase.start) _startPanel(),
                if (_phase == _Phase.loading) _loadingPanel(),
                if (_phase == _Phase.countdown) _countdownPanel(),
                if (_phase == _Phase.result) _resultPanel(),
              ],
            ),
          ),
        ],
      ),
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
  Widget _panelShell({required List<Widget> children}) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD1080A0C), // rgba(8,10,12,.82)
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
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
        const SizedBox(height: AppSpacing.s16),
        _recordToggle(l10n),
        const SizedBox(height: AppSpacing.s24),
        // Fill, not hug: the result panel's CTAs are Row+Expanded and span the
        // panel, so a label-width start button read as a different control in
        // the same overlay. _panelShell's Column is centre-aligned, so the
        // width has to come from here.
        SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.challengeStart,
            onPressed: _onStart,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          l10n.challengePermissionNote,
          textAlign: TextAlign.center,
          style: AppType.label2.r.copyWith(color: _stageInkMuted(context)),
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
          child: Text(
            '$_countdown',
            style: AppType.display1.b.copyWith(
              color: _stageInk(context),
              fontSize: 120,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultPanel() {
    final engine = _controller.engine;
    return _panelShell(
      children: [
        // Branded score card — captured to a PNG for sharing.
        RepaintBoundary(
          key: _shareCardKey,
          child: _shareCard(engine),
        ),
        const SizedBox(height: AppSpacing.s16),
        if (!_stt.isAvailable)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: Text(
              AppLocalizations.of(context).challengeSttFallback,
              textAlign: TextAlign.center,
              style: AppType.label2.r.copyWith(color: const Color(0xFFFFCF5C)),
            ),
          ),
        _difficultyToggle(),
        const SizedBox(height: AppSpacing.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Button(
                type: BtnType.secondaryFill,
                size: BtnSize.s60,
                text: AppLocalizations.of(context).share,
                onPressed: _shareResult,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: AppLocalizations.of(context).playAgain,
                onPressed: _replay,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// The shareable branded score card (also shown in the result panel).
  Widget _shareCard(ChallengeEngine engine) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s24,
      ),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BEAVERTALK',
            style: AppType.label1.b.copyWith(
              color: context.c.primaryNormal,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            engine.resultTitle,
            textAlign: TextAlign.center,
            style: AppType.title2.b.copyWith(color: context.c.labelStrong),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            _thousands(engine.score),
            style: AppType.display1.b.copyWith(
              color: context.c.primaryNormal,
              fontSize: 56,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'SCORE',
            style: AppType.label2.b.copyWith(color: context.c.labelDisabled),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Best Combo ${engine.maxCombo}  ·  Cleared ${engine.passCount}',
            textAlign: TextAlign.center,
            style: AppType.body2.r.copyWith(color: context.c.labelNormal),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'beavertalk.im',
            style: AppType.label2.r.copyWith(color: context.c.labelDisabled),
          ),
        ],
      ),
    );
  }

  // ── share (score-card image + challenge copy) ───────────────────────
  /// Web game `shareText()` (lines 596–598), with the player's real score.
  String _shareText() {
    return 'Think your Korean is good?\n\n'
        'Beaver just proved you wrong.\n\n'
        'His score: ${_thousands(_controller.engine.score)}\n\n'
        'Yours?\n\n'
        '👉 https://www.beavertalk.im';
  }

  Future<void> _shareResult() async {
    try {
      // Web can't write a temp file the same way; share text only there.
      if (kIsWeb) {
        await SharePlus.instance.share(ShareParams(text: _shareText()));
        return;
      }
      // Prefer the recorded gameplay MP4 (camera + overlay) when a run was
      // captured; fall back to the branded score-card image otherwise.
      final videoPath = _videoPath;
      if (videoPath != null && File(videoPath).existsSync()) {
        await SharePlus.instance.share(
          ShareParams(text: _shareText(), files: <XFile>[XFile(videoPath)]),
        );
        return;
      }
      final boundary = _shareCardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        await SharePlus.instance.share(ShareParams(text: _shareText()));
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) {
        await SharePlus.instance.share(ShareParams(text: _shareText()));
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/beavertalk_challenge_'
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes.buffer.asUint8List());
      // Score-card image fallback: shown when the run wasn't screen-recorded
      // (toggle off / consent denied / unsupported). The recorded-MP4 path
      // above is the primary share when a clip exists.
      await SharePlus.instance.share(
        ShareParams(text: _shareText(), files: <XFile>[XFile(file.path)]),
      );
    } catch (e) {
      debugPrint('share failed: $e');
    }
  }

  // ── difficulty toggle (Slow / Normal / Fast) ────────────────────────
  Widget _difficultyToggle() {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.difficulty,
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
