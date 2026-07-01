import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/atoms/record_circle_button.dart';
import '../../components/organisms/gnb.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 2 — Figma `screen/learning_next` (`2117:20110`).
///
/// Shows the just-scored attempt from the real [ReviewFeedback] in
/// [LearningArgs.feedback]: the sentence rendered **per character** colored by
/// its 상/중/하 grade (상 → [AppColors.success], 중 → [AppColors.warning], 하 →
/// [AppColors.error]; falls back to score thresholds when the grade is unknown),
/// the native translation, Native / Me playback, then a retry/next control row.
///
/// - "Me" plays the user's recorded WAV ([LearningArgs.recordedWav]).
/// - "Native" plays [ReviewFeedback.voiceUrl] when present (best-effort; a
///   storage key that isn't directly playable just shows a message).
/// - 다시하기 → pop back to re-record the same sentence.
/// - → next → next sentence's intro, or [Routes.learningMain] when last.
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningNextScreen extends StatefulWidget {
  /// Creates the learning comparison screen.
  const LearningNextScreen({super.key});

  @override
  State<LearningNextScreen> createState() => _LearningNextScreenState();
}

class _LearningNextScreenState extends State<LearningNextScreen> {
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  /// Color for a character by grade, falling back to score thresholds when the
  /// grade is unknown/missing.
  static Color _gradeColor(CharScore cs) {
    switch (cs.grade) {
      case CharGrade.high:
        return AppColors.success;
      case CharGrade.medium:
        return AppColors.warning;
      case CharGrade.low:
        return AppColors.error;
      case CharGrade.unknown:
        if (cs.score >= 85) return AppColors.success;
        if (cs.score >= 70) return AppColors.warning;
        return AppColors.error;
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playMe(LearningArgs args) async {
    final wav = args.recordedWav;
    if (wav == null || wav.isEmpty) {
      _snack('재생할 녹음이 없어요.');
      return;
    }
    try {
      await _player.playBytes(wav);
    } catch (_) {
      _snack('내 녹음을 재생할 수 없어요.');
    }
  }

  Future<void> _playNative(ReviewFeedback? feedback) async {
    final url = feedback?.voiceUrl;
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      // voiceUrl may be a storage key, not a directly playable URL.
      _snack('표준 발음 오디오를 재생할 수 없어요.');
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack('표준 발음 오디오를 재생할 수 없어요.');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LearningArgs;
    final feedback = args.feedback;
    final sentence = args.current;
    final native = feedback?.native ?? sentence.native;

    return AppScaffold(
      background: AppColors.surface2,
      body: Column(
        children: [
          Gnb.main2(
            progress: GnbProgress(current: args.step, total: args.total),
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppIcons.volume(size: 32, color: AppColors.text),
                      AppIcons.bookmarkLine(size: 32, color: AppColors.text),
                    ],
                  ),
                ),
                // Per-character scored sentence + translation (Figma top 246).
                Positioned(
                  top: 246,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ScoredSentence(
                        charScores: feedback?.charScores ?? const [],
                        fallbackText: sentence.korean,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        native,
                        textAlign: TextAlign.center,
                        style: AppType.body1.sb.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Native / Me playback buttons (Figma top 478).
                Positioned(
                  top: 478,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          type: BtnType.secondaryWhite,
                          size: BtnSize.s44,
                          text: 'Native',
                          leftIcon: AppIcons.volume(size: 20),
                          onPressed: () => _playNative(feedback),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Button(
                          type: BtnType.secondaryWhite,
                          size: BtnSize.s44,
                          text: 'Me',
                          leftIcon: AppIcons.volume(size: 20),
                          onPressed: () => _playMe(args),
                        ),
                      ),
                    ],
                  ),
                ),
                // Retry (white circle) + next (arrow), pinned bottom (Figma 24).
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 56),
                        const SizedBox(width: 24),
                        RecordCircleButton(
                          icon: AppIcons.redo,
                          semanticLabel: '다시하기',
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(
                            // More sentences left → record the next one directly;
                            // the score screen (learning_main) shows only once,
                            // after the whole review sequence is done.
                            onPressed: () => args.hasNext
                                ? Navigator.pushNamed(
                                    context,
                                    Routes.learningIntro,
                                    arguments: args.next(),
                                  )
                                : Navigator.pushNamed(
                                    context,
                                    Routes.learningMain,
                                    arguments: args,
                                  ),
                            icon: AppIcons.arrowForward(
                              size: 32,
                              color: AppColors.green700,
                            ),
                            iconSize: 32,
                            color: AppColors.green700,
                            tooltip: '다음',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the sentence character-by-character, each tinted by its grade.
/// Falls back to a plain (un-tinted) sentence when no char scores exist.
class _ScoredSentence extends StatelessWidget {
  const _ScoredSentence({required this.charScores, required this.fallbackText});

  final List<CharScore> charScores;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final base = AppType.heading2.sb;
    if (charScores.isEmpty) {
      return Text(
        fallbackText,
        textAlign: TextAlign.center,
        style: base.copyWith(color: AppColors.text),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (final cs in charScores)
            TextSpan(
              text: cs.char,
              style: base.copyWith(
                color: _LearningNextScreenState._gradeColor(cs),
              ),
            ),
        ],
      ),
    );
  }
}
