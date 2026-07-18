import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/mic_analysis.dart';
import '../../components/atoms/mic_button.dart';
import '../../components/atoms/scan_cursor.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/data/audio_recorder.dart';
import '../../features/review/data/wav_writer.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 1 — Figma `screen/learning_intro` (`2117:20089`).
///
/// Shows the current sentence (KO in Heading 2, EN in Body 1 secondary) over a
/// `Background/Normal/Alternative` page, with a large mic button pinned low. The mic is a
/// real two-state recorder:
/// - **idle** — tap to start capturing PCM16/16k/mono audio.
/// - **recording** — tap to stop; the captured PCM is wrapped in a WAV header
///   and uploaded to `POST /sentences/{id}/reviews/audio`. While the upload
///   runs a spinner overlay is shown. On success the scored [ReviewFeedback] is
///   recorded into [reviewScoresProvider] (for the gauge average) and forwarded
///   with the recorded WAV to [Routes.learningNext]. On error a snackbar shows
///   and the user can re-record.
///
/// How long scoring may run before the caption softens to
/// `analyzingTakingLonger` (`screen/learning_analysis__지연5s` `3745:2`).
///
/// The frame is named 지연**5s**, but 5s is too long to sit on a caption that
/// claims progress — 2s is the product's call (2026-07-17).
///
/// The frame's `SkipButton` (`3745:28`, 「건너뛰기」) is **deliberately not built**:
/// `submitAudio` is a single POST with no cancel, so skipping would have to
/// either bin a score the server is already computing or land a result on a
/// screen the user has left. Dropped on a product decision — while scoring is one
/// blocking call, waiting is the only thing the screen can honestly offer.
const _kSlowScoring = Duration(seconds: 2);

/// Minimum time the scan screen stays up before advancing to the result, even
/// when scoring returns faster.
///
/// `submitAudio` is ~0.1s against a warm server but ~9s on a Cloud Run cold
/// start, so without a floor the scan animation (cursor sweep, spinner) would
/// flash for a single frame and snap to the result on a warm server — the
/// animation you built barely shows. 1.5s ≈ one cursor sweep, so the scan reads
/// as a real step regardless of server latency. The result push waits on
/// `max(scoring, this)`.
const _kMinScan = Duration(milliseconds: 1500);

/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningIntroScreen extends ConsumerStatefulWidget {
  /// Creates the learning intro screen.
  const LearningIntroScreen({super.key});

  @override
  ConsumerState<LearningIntroScreen> createState() =>
      _LearningIntroScreenState();
}

class _LearningIntroScreenState extends ConsumerState<LearningIntroScreen> {
  final ReviewAudioRecorder _recorder = ReviewAudioRecorder();
  final ReviewAudioPlayer _player = ReviewAudioPlayer();
  bool _recording = false;
  bool _submitting = false;

  /// Scoring has passed [_kSlowScoring] and the caption has softened.
  bool _scoringSlow = false;
  Timer? _slowTimer;

  /// Cached standard-pronunciation URL for this sentence (fetched once on the
  /// first speaker tap; the server TTS is idempotent so this just avoids re-calls).
  String? _ttsUrl;
  bool _loadingTts = false;

  /// Guards the one-time seeding of the shared bookmark store from this
  /// sentence's server flag ([MockSentence.bookmarked]).
  bool _seededBookmark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededBookmark) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LearningArgs) {
      _seededBookmark = true;
      final s = args.current;
      // Reconcile to server truth (add when saved, clear when not) so a stale
      // `true` can't stick — union-only seeding permanently diverged before.
      setBookmark(s.id, s.bookmarked);
    }
  }

  /// Sentence ids with an in-flight bookmark mutation — a second tap while one is
  /// pending is ignored so two opposite PATCHes can't resolve out of order.
  final Set<int> _bookmarkInFlight = <int>{};

  /// Toggles the current sentence's bookmark. Flips the shared in-memory store
  /// first for instant, cross-screen UI (mirrors the analysis screen), then
  /// persists via [bookmarkToggleControllerProvider]
  /// (`PATCH /sentences/{id}/bookmark`, mirrors record_archive). Reverts the
  /// local flip and surfaces a message if the server call fails.
  Future<void> _toggleBookmark(int sentenceId) async {
    // Ignore a second tap while a mutation for this id is outstanding, so two
    // opposite PATCHes can't complete out of order and desync from the server.
    if (_bookmarkInFlight.contains(sentenceId)) return;
    _bookmarkInFlight.add(sentenceId);
    final l10n = AppLocalizations.of(context);
    final willSave = !bookmarkedSentenceIds.value.contains(sentenceId);
    toggleBookmark(sentenceId);
    try {
      await ref
          .read(bookmarkToggleControllerProvider.notifier)
          .toggleBookmark(sentenceId, willSave);
    } catch (e) {
      toggleBookmark(sentenceId); // revert on failure
      _snack(e is AppException ? e.message : l10n.saveSentenceFailed);
    } finally {
      _bookmarkInFlight.remove(sentenceId);
    }
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  /// Plays the sentence's standard (native) pronunciation. Fetches the audio URL
  /// from the server's on-demand TTS (`POST /sentences/{id}/tts`) on the first
  /// tap, caches it, then plays. Shows a message when TTS is unavailable.
  Future<void> _playStandard(MockSentence sentence) async {
    // Don't play the standard-pronunciation audio through the speaker while the
    // mic is recording — it bleeds into the user's take and skews the score.
    if (_submitting || _loadingTts || _recording) return;
    final l10n = AppLocalizations.of(context);
    var url = _ttsUrl ?? sentence.voiceUrl;
    if (url == null || !url.startsWith('http')) {
      setState(() => _loadingTts = true);
      try {
        url = await ref
            .read(reviewRepositoryProvider)
            .sentenceTtsUrl(sentence.id);
        _ttsUrl = url;
      } on AppException catch (e) {
        _snack(e.message);
        return;
      } catch (_) {
        _snack(l10n.standardAudioPlayError);
        return;
      } finally {
        if (mounted) setState(() => _loadingTts = false);
      }
    }
    if (url == null || !url.startsWith('http')) {
      _snack(l10n.standardAudioNotReady);
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack(l10n.standardAudioPlayError);
    }
  }

  Future<void> _onMicTap(LearningArgs args) async {
    if (_submitting) return;
    if (!_recording) {
      await _startRecording();
    } else {
      await _stopAndSubmit(args);
    }
  }

  Future<void> _startRecording() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _recorder.start();
      if (!mounted) return;
      setState(() => _recording = true);
    } on StateError catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack(l10n.recordStartFailed);
    }
  }

  Future<void> _stopAndSubmit(LearningArgs args) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _recording = false;
      _submitting = true;
      _scoringSlow = false;
    });
    // `learning_analysis__지연5s` (3745:2) — the caption softens once scoring
    // runs long, so a slow response reads as slow rather than stuck. The frame
    // is named for 5s; 2s is the product's call.
    _slowTimer?.cancel();
    _slowTimer = Timer(_kSlowScoring, () {
      if (mounted) setState(() => _scoringSlow = true);
    });

    try {
      final pcm = await _recorder.stop();
      // Guard against an empty/too-short recording (< ~0.3s of PCM16 @16k).
      if (pcm.lengthInBytes < 16000 * 2 * 0.3) {
        _snack(l10n.recordTooShort);
        return;
      }

      final wav = pcm16ToWav(pcm);
      // Start scoring and the minimum-scan floor together, then wait on both:
      // total time = max(scoring, _kMinScan). A warm-server response (~0.1s)
      // still shows the scan for _kMinScan; a slow one dominates on its own.
      final scoring =
          ref.read(reviewRepositoryProvider).submitAudio(args.current.id, wav);
      await Future<void>.delayed(_kMinScan);
      final feedback = await scoring;

      // Feed the running average for the analysis gauge.
      ref.read(reviewScoresProvider.notifier).record(feedback);

      if (!mounted) return;
      // Leave the scan state *before* pushing, so returning from the result
      // (this route keeps its state) doesn't flash the spinning scan screen on
      // the way back to the mic.
      _slowTimer?.cancel();
      setState(() {
        _submitting = false;
        _scoringSlow = false;
      });
      await Navigator.pushNamed(
        context,
        Routes.learningNext,
        arguments: args.withFeedback(feedback, wav),
      );
    } on NetworkFailure {
      // Split out because the copy asserts a cause. `proto/E_failed` says
      // "연결이 끊겼어요", which is only true when the request never reached the
      // server — `dio_error_mapper` already classifies exactly that case
      // (connectionError + the three timeouts) as [NetworkFailure]. Everything
      // below is a *scoring* failure and must not borrow that wording.
      //
      // Uses the l10n string rather than `e.message`: [AppException]'s defaults
      // are hardcoded Korean, and this screen renders in 30 locales.
      _snack(l10n.connectionFailedTitle);
    } on AppException catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack(l10n.gradingFailed);
    } finally {
      _slowTimer?.cancel();
      if (mounted) {
        setState(() {
          _submitting = false;
          _scoringSlow = false;
        });
      }
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Mobile always arrives via in-app `pushNamed(arguments:)`; guard the cast
    // so a web refresh / deep link (args == null) degrades to an empty screen
    // instead of a build-time TypeError white-screen.
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    if (rawArgs is! LearningArgs) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final args = rawArgs;
    final sentence = args.current;

    return AppScaffold(
      background: context.c.backgroundNormalAlternative,
      body: Stack(
        children: [
          Column(
            children: [
              Gnb.main2(
                progress: GnbProgress(current: args.step, total: args.total),
                onClose: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.s16),
                    // Speaker / bookmark utility row — top (Figma body top 16).
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Speaker → plays this sentence's standard pronunciation
                          // (ready for the server's per-sentence audio URL).
                          Semantics(
                            button: true,
                            label: l10n.listenStandard,
                            child: GestureDetector(
                              onTap: () => _playStandard(sentence),
                              behavior: HitTestBehavior.opaque,
                              child: AppIcons.volume(
                                  size: 32, color: context.c.labelStrong),
                            ),
                          ),
                          // Bookmark (문장 저장) — toggles the current sentence's
                          // saved state; reflects it live via the shared store.
                          ValueListenableBuilder<Set<int>>(
                            valueListenable: bookmarkedSentenceIds,
                            builder: (context, ids, _) {
                              final saved = ids.contains(sentence.id);
                              return Semantics(
                                button: true,
                                label: saved ? l10n.unsaveSentence : l10n.saveSentence,
                                child: GestureDetector(
                                  onTap: () => _toggleBookmark(sentence.id),
                                  behavior: HitTestBehavior.opaque,
                                  child: saved
                                      ? AppIcons.bookmarkFill(
                                          size: 32, color: context.c.labelStrong)
                                      : AppIcons.bookmarkLine(
                                          size: 32, color: context.c.labelStrong),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Sentence (KO + EN) — centred in the flexible middle. While
                    // scoring, `Scan/Cursor` sweeps across it (`3627:9694`);
                    // the cursor sits *over* the text, so it shares this box
                    // rather than pushing anything.
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sentence.korean,
                                    textAlign: TextAlign.center,
                                    style: AppType.heading2.sb
                                        .copyWith(color: context.c.labelStrong),
                                  ),
                                  const SizedBox(height: AppSpacing.s8),
                                  Text(
                                    sentence.native,
                                    textAlign: TextAlign.center,
                                    style: AppType.body1.sb
                                        .copyWith(color: context.c.labelNormal),
                                  ),
                                ],
                              ),
                              // 84 over the frame's 60-high sentence block —
                              // the bar overhangs the text top and bottom.
                              // Left unpositioned so the Stack centres it and
                              // hands it loose constraints: `Positioned.fill`
                              // would force it to the full height and eat the
                              // 84.
                              if (_submitting)
                                const IgnorePointer(
                                  child: ScanCursor(height: 84),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Mic button — Figma body top 558 (node 2296:26337). The
                    // bottom inset comes from the shared [BottomCtaBar]: the OS
                    // gesture-bar inset on native, a guaranteed 24px floor on
                    // web/desktop — so the mic never hugs / gets cut at the frame
                    // edge (QA: "마이크 짤림") and sits at the same inset as other
                    // screens.
                    // `AnalyzingCaption` (`3627:9708`) — sits between the
                    // sentence and the mic anchor, so it only exists while
                    // scoring. Reserving its 20 when idle would push the mic
                    // off the frame's 558.
                    if (_submitting) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s20),
                        child: Text(
                          _scoringSlow
                              ? l10n.analyzingTakingLonger
                              : l10n.analyzingByWord,
                          textAlign: TextAlign.center,
                          style: AppType.label1.m
                              .copyWith(color: context.c.labelNormal),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                    ],
                    BottomCtaBar(
                      child: Center(
                        // Same 96 anchor either way — `Mic/Spinner` replaces the
                        // mic in place, which is why scoring no longer dims the
                        // screen behind an overlay.
                        child: _submitting
                            ? const MicAnalysis()
                            : StreamBuilder<double>(
                                stream: _recorder.amplitude,
                                builder: (context, snap) => MicButton(
                                  recording: _recording,
                                  // Drive the reactive pulse from the live mic
                                  // level while recording; static otherwise.
                                  level: _recording ? snap.data : null,
                                  onTap: () => _onMicTap(args),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// The dimmed `_SubmittingOverlay` (a centred CircularProgressIndicator over
// `l10n.scoringPronunciation`) used to live here. `proto/2_scan_start` replaces
// it: scoring is now a state of this screen — the mic anchor becomes
// [MicAnalysis], [ScanCursor] sweeps the sentence and the caption sits between
// them — so nothing dims and the sentence stays readable throughout.
