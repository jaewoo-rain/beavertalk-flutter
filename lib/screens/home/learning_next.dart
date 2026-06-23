import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/record_circle_button.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 2 — Figma `screen/learning_next` (`2117:20110`).
///
/// Replays the just-recorded attempt: the sentence is rendered **per character**
/// with [_scoreColor] (상 ≥85 → [AppColors.success], 중 ≥70 →
/// [AppColors.warning], else → [AppColors.error]) over the EN translation, then
/// Native / Me playback buttons (mock — they only SnackBar "재생"), and a control
/// row of:
/// - a retry circle (다시하기) → [Navigator.pop] back to re-record in
///   [Routes.learningIntro],
/// - a next circle (→) → [Routes.learningMain] (forwarding [LearningArgs]).
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningNextScreen extends StatefulWidget {
  /// Creates the learning comparison screen.
  const LearningNextScreen({super.key});

  @override
  State<LearningNextScreen> createState() => _LearningNextScreenState();
}

class _LearningNextScreenState extends State<LearningNextScreen> {
  /// Color for a per-character score: 상/중/하 thresholds.
  static Color _scoreColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  void _play(String who) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text('$who 재생')));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LearningArgs;
    final sentence = args.current;

    return AppScaffold(
      background: AppColors.surface2,
      body: Column(
        children: [
          Gnb.main2(
            progress: GnbProgress(current: args.step, total: args.total),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                const Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.volume_up_outlined,
                          size: 32, color: AppColors.text),
                      Icon(Icons.bookmark_border,
                          size: 32, color: AppColors.text),
                    ],
                  ),
                ),
                // Per-character scored sentence + translation.
                Align(
                  alignment: const Alignment(0, -0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ScoredSentence(charScores: sentence.charScores),
                        const SizedBox(height: 8),
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
                // Native / Me playback buttons.
                Align(
                  alignment: const Alignment(0, 0.18),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button(
                            type: BtnType.secondaryWhite,
                            size: BtnSize.s44,
                            text: 'Native',
                            leftIcon: const Icon(Icons.volume_up_outlined),
                            onPressed: () => _play('Native'),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Button(
                            type: BtnType.secondaryWhite,
                            size: BtnSize.s44,
                            text: 'Me',
                            leftIcon: const Icon(Icons.volume_up_outlined),
                            onPressed: () => _play('Me'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Retry (white circle) + next (arrow). A 56px invisible mirror
                // on the left keeps the retry circle screen-centered (Figma row
                // [56 mirror][96 retry][56 arrow], gap 24).
                Align(
                  alignment: const Alignment(0, 0.72),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 56),
                      const SizedBox(width: 24),
                      RecordCircleButton(
                        icon: Icons.refresh,
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
                          icon: const Icon(Icons.arrow_forward),
                          iconSize: 32,
                          color: AppColors.green700,
                          tooltip: '다음',
                        ),
                      ),
                    ],
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

/// Renders the sentence character-by-character, each tinted by its score.
class _ScoredSentence extends StatelessWidget {
  const _ScoredSentence({required this.charScores});

  final List<MockCharScore> charScores;

  @override
  Widget build(BuildContext context) {
    final base = AppType.heading2.sb;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (final cs in charScores)
            TextSpan(
              text: cs.char,
              style: base.copyWith(
                color: _LearningNextScreenState._scoreColor(cs.score),
              ),
            ),
        ],
      ),
    );
  }
}

