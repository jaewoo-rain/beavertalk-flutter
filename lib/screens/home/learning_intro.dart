import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/mic_button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/data/audio_recorder.dart';
import '../../features/review/data/wav_writer.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 1 — Figma `screen/learning_intro` (`2117:20089`).
///
/// Shows the current sentence (KO in Heading 2, EN in Body 1 secondary) over a
/// [AppColors.surface2] page, with a large mic button pinned low. The mic is a
/// real two-state recorder:
/// - **idle** — tap to start capturing PCM16/16k/mono audio.
/// - **recording** — tap to stop; the captured PCM is wrapped in a WAV header
///   and uploaded to `POST /sentences/{id}/reviews/audio`. While the upload
///   runs a spinner overlay is shown. On success the scored [ReviewFeedback] is
///   recorded into [reviewScoresProvider] (for the gauge average) and forwarded
///   with the recorded WAV to [Routes.learningNext]. On error a snackbar shows
///   and the user can re-record.
///
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

  /// Cached standard-pronunciation URL for this sentence (fetched once on the
  /// first speaker tap; the server TTS is idempotent so this just avoids re-calls).
  String? _ttsUrl;
  bool _loadingTts = false;

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  /// Plays the sentence's standard (native) pronunciation. Fetches the audio URL
  /// from the server's on-demand TTS (`POST /sentences/{id}/tts`) on the first
  /// tap, caches it, then plays. Shows a message when TTS is unavailable.
  Future<void> _playStandard(MockSentence sentence) async {
    if (_submitting || _loadingTts) return;
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
        _snack('표준 발음 오디오를 재생할 수 없어요.');
        return;
      } finally {
        if (mounted) setState(() => _loadingTts = false);
      }
    }
    if (url == null || !url.startsWith('http')) {
      _snack('표준 발음 오디오가 아직 준비되지 않았어요.');
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack('표준 발음 오디오를 재생할 수 없어요.');
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
    try {
      await _recorder.start();
      if (!mounted) return;
      setState(() => _recording = true);
    } on StateError catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack('녹음을 시작할 수 없어요.');
    }
  }

  Future<void> _stopAndSubmit(LearningArgs args) async {
    setState(() {
      _recording = false;
      _submitting = true;
    });

    try {
      final pcm = await _recorder.stop();
      // Guard against an empty/too-short recording (< ~0.3s of PCM16 @16k).
      if (pcm.lengthInBytes < 16000 * 2 * 0.3) {
        _snack('녹음이 너무 짧아요. 다시 시도해주세요.');
        return;
      }

      final wav = pcm16ToWav(pcm);
      final feedback = await ref
          .read(reviewRepositoryProvider)
          .submitAudio(args.current.id, wav);

      // Feed the running average for the analysis gauge.
      ref.read(reviewScoresProvider.notifier).record(feedback);

      if (!mounted) return;
      await Navigator.pushNamed(
        context,
        Routes.learningNext,
        arguments: args.withFeedback(feedback, wav),
      );
    } on AppException catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack('채점 요청에 실패했어요. 다시 시도해주세요.');
    } finally {
      if (mounted) setState(() => _submitting = false);
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
    final args = ModalRoute.of(context)!.settings.arguments as LearningArgs;
    final sentence = args.current;

    // Figma (screen/learning_intro 2296:26318): the mic sits 24px above the Body
    // bottom, with a 34px HomeIndicator zone below it. AppScaffold's SafeArea
    // reserves the OS bottom inset on native (→ 24px is exact), but web reports
    // no inset, so the mic would hug the viewport edge. When there's no OS inset,
    // also reserve the 34px home-indicator zone so it matches Figma on web too.
    final rawBottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final micBottomGap =
        AppSpacing.s24 + (rawBottomInset == 0 ? HomeIndicator.height : 0.0);

    return AppScaffold(
      background: AppColors.surface2,
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
                            label: '표준 발음 듣기',
                            child: GestureDetector(
                              onTap: () => _playStandard(sentence),
                              behavior: HitTestBehavior.opaque,
                              child: AppIcons.volume(
                                  size: 32, color: AppColors.text),
                            ),
                          ),
                          AppIcons.bookmarkLine(size: 32, color: AppColors.text),
                        ],
                      ),
                    ),
                    // Sentence (KO + EN) — centred in the flexible middle.
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                sentence.korean,
                                textAlign: TextAlign.center,
                                style: AppType.heading2.sb
                                    .copyWith(color: AppColors.text),
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Text(
                                sentence.native,
                                textAlign: TextAlign.center,
                                style: AppType.body1.sb
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Mic button — Figma body top 558 (node 2296:26337). The gap
                    // below is 24px (Figma) plus the home-indicator zone when the
                    // platform reserves none (web), so the mic never hugs / gets
                    // cut at the frame edge (QA: "마이크 짤림").
                    Center(
                      child: MicButton(
                        recording: _recording,
                        onTap: () => _onMicTap(args),
                      ),
                    ),
                    SizedBox(height: micBottomGap),
                  ],
                ),
              ),
            ],
          ),
          // Upload/scoring overlay.
          if (_submitting)
            const _SubmittingOverlay(),
        ],
      ),
    );
  }
}

/// Dimmed full-screen overlay with a spinner shown while the recording is
/// uploaded and scored.
class _SubmittingOverlay extends StatelessWidget {
  const _SubmittingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.scrim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              '발음을 채점하고 있어요…',
              style: AppType.body1.r.copyWith(color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
