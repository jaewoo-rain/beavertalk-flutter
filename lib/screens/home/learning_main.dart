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
  /// Ends the session: unwind back to whatever launched the learning flow —
  /// the call analysis (대화 기록) or the 보관 archive. Pops every learning
  /// screen (intro/next/main) and stops at the first non-learning route, so it
  /// works regardless of entry point (popping to a hardcoded route that isn't
  /// on the stack would unwind everything → blank screen).
  void _finish() {
    Navigator.popUntil(context, (route) {
      final name = route.settings.name;
      return name != Routes.learningIntro &&
          name != Routes.learningNext &&
          name != Routes.learningMain;
    });
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
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '학습 종료',
                onPressed: _finish,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
