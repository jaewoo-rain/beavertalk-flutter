import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import 'learning_args.dart';

/// Learning step 3 — Figma `screen/learning_main` (`3627:24364`, redrawn
/// 2026-07-16; previously `2221:3837`).
///
/// Named *sentence* main because it scores **one sentence**. Three frames now
/// share the name `screen/learning_main`, so the code splits them by what they
/// measure: `2221:3837` and `3627:24364` score one sentence (this screen), while
/// `3569:15065` summarises a whole session ([LearningCallMainScreen]).
///
/// The per-sentence result: a centered [PronunciationResult] gauge fed by the
/// current sentence's scores over a pinned footer of **one** action —
/// "학습 종료" ([BtnType.primaryFill]) → unwind to whatever launched the flow.
/// The redraw confirms the single CTA; there is no "다음" button in the frame
/// (advancing happens in [LearningIntroScreen]).
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningSentenceMainScreen extends StatefulWidget {
  /// Creates the learning result screen.
  const LearningSentenceMainScreen({super.key});

  @override
  State<LearningSentenceMainScreen> createState() => _LearningSentenceMainScreenState();
}

class _LearningSentenceMainScreenState extends State<LearningSentenceMainScreen> {
  /// Ends the session: unwind back to whatever launched the learning flow —
  /// the call analysis (대화 기록) or the 보관 archive. Pops every learning
  /// screen (intro/next/main) and stops at the first non-learning route, so it
  /// works regardless of entry point (popping to a hardcoded route that isn't
  /// on the stack would unwind everything → blank screen).
  void _finish() {
    Navigator.popUntil(context, (route) {
      final name = route.settings.name;
      return name != Routes.learningIntro &&
          name != Routes.learningSentenceMain;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    if (rawArgs is! LearningArgs) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final args = rawArgs;
    // Bind the gauge to the real scored attempt. If somehow opened without
    // feedback, fall back to the inactive ("-%") gauge.
    final eval = args.feedback?.evaluation;

    return AppScaffold(
      background: context.c.backgroundNormalAlternative,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: PronunciationResult(
                  state: eval == null
                      ? PronunciationState.inactive
                      : PronunciationState.active,
                  score: (eval?.totalScore ?? 0).toDouble(),
                  metrics: [
                    PronunciationMetric(
                      label: l10n.pronunciation,
                      value: eval == null ? '-%' : '${eval.pronunciation}%',
                    ),
                    PronunciationMetric(
                      label: l10n.fluency,
                      value: eval == null ? '-%' : '${eval.fluency}%',
                    ),
                    PronunciationMetric(
                      label: l10n.rhythm,
                      value: eval == null ? '-%' : '${eval.rhythm}%',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            // Bottom is the literal home-indicator gap (34), not an
            // AppSpacing token — this screen has no trailing SafeArea /
            // BottomCtaBar (unlike its learning_intro/learning_next
            // siblings), so it would otherwise sit flush against the
            // physical bottom edge on devices with viewPadding.bottom == 0.
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s12, AppSpacing.s20, 34),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: AppLocalizations.of(context).endLearning,
                onPressed: _finish,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
