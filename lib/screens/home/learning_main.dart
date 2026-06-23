import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../theme/app_colors.dart';
import 'learning_args.dart';

/// Learning step 3 — Figma `screen/learning_main` (`2221:3837`).
///
/// The per-sentence result: a centered [PronunciationResult] gauge fed by the
/// current sentence's scores, with a pinned footer of two actions:
/// - "학습 종료" ([BtnType.secondaryFill]) → pop back to the start of the flow,
/// - "다음" ([BtnType.primaryFill]) → if another sentence follows, push a fresh
///   [Routes.learningIntro] for it (advancing the [LearningArgs] index);
///   otherwise return to [Routes.home].
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningMainScreen extends StatefulWidget {
  /// Creates the learning result screen.
  const LearningMainScreen({super.key});

  @override
  State<LearningMainScreen> createState() => _LearningMainScreenState();
}

class _LearningMainScreenState extends State<LearningMainScreen> {
  /// Ends the session: unwind back to the analysis screen.
  void _finish() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.analysis));
  }

  /// Advances to the next sentence's intro, or home when the sequence is done.
  void _next(LearningArgs args) {
    if (args.hasNext) {
      Navigator.pushNamed(
        context,
        Routes.learningIntro,
        arguments: args.next(),
      );
    } else {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
    }
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
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PronunciationResult(
                  score: sentence.overall.toDouble(),
                  metrics: [
                    PronunciationMetric(
                      label: 'Pronunciation',
                      value: '${sentence.pronunciation}%',
                    ),
                    PronunciationMetric(
                      label: 'Fluency',
                      value: '${sentence.fluency}%',
                    ),
                    PronunciationMetric(
                      label: 'Rhythm',
                      value: '${sentence.rhythm}%',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    type: BtnType.secondaryFill,
                    size: BtnSize.s60,
                    text: '학습 종료',
                    onPressed: _finish,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: args.hasNext ? '다음' : '완료',
                    onPressed: () => _next(args),
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
