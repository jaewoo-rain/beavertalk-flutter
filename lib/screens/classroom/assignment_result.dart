import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/presentation/assignment_attempt_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 발음 과제를 마친 뒤의 결과 화면.
///
/// 문장 하나의 결과를 그리는 `learning_sentence_main` 과 다르다 — 여기는 **과제
/// 전체**의 평균과 「n / m 문장」이다. 과제는 38문장짜리 한 덩어리라, 마지막
/// 문장의 점수만 보여주면 학습자는 자기가 얼마나 했는지 알 수 없다.
///
/// ⛔ 여기서 점수를 다시 계산하지 마라. 통과 판정도 평균도 **서버가 준 값**을
///    접기만 한다([AssignmentAttempt]). 앱이 다시 재면 교사 화면과 갈린다.
///
/// 인자는 과제 id(int) 하나다. 집계는 [assignmentAttemptProvider] 가 들고 있고,
/// 그 값은 과제에 들어올 때 서버에서 되살린 것이다.
class AssignmentResultScreen extends ConsumerWidget {
  /// 결과 화면을 만든다.
  const AssignmentResultScreen({super.key});

  /// 학습 흐름을 통째로 걷어내고 과제 상세로 돌아간다.
  ///
  /// 단순 pop 이면 이미 채점을 끝내고 해체된 녹음 화면으로 떨어진다
  /// (`learning_sentence_main._finish` 와 같은 사정이다).
  void _finish(BuildContext context) {
    Navigator.popUntil(context, (route) {
      final name = route.settings.name;
      return name != Routes.learningIntro && name != Routes.assignmentResult;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final raw = ModalRoute.of(context)?.settings.arguments;
    if (raw is! int) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final attempt = ref.watch(assignmentAttemptProvider)[raw];
    final int? average = attempt?.averageScore;

    return AppScaffold(
      background: context.c.backgroundNormalAlternative,
      body: Column(
        children: [
          Gnb.main(onBack: () => _finish(context)),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PronunciationResult(
                      state: average == null
                          ? PronunciationState.inactive
                          : PronunciationState.active,
                      score: (average ?? 0).toDouble(),
                      // 시안의 세 칸은 발음·유창성·리듬이다. 과제 맥락이라고 다른
                      // 축을 끼워 넣으면 같은 컴포넌트가 화면마다 다른 뜻이 된다.
                      metrics: [
                        PronunciationMetric(
                          label: l10n.pronunciation,
                          value: _pct(attempt?.averagePronunciation),
                        ),
                        PronunciationMetric(
                          label: l10n.fluency,
                          value: _pct(attempt?.averageFluency),
                        ),
                        PronunciationMetric(
                          label: l10n.rhythm,
                          value: _pct(attempt?.averageRhythm),
                        ),
                      ],
                    ),
                    if (attempt != null) ...[
                      const SizedBox(height: AppSpacing.s24),
                      Text(
                        // 「38문장 중 37문장 통과」 — 카드와 같은 문장을 쓴다.
                        l10n.hwSpeakingProgress(
                          attempt.passed,
                          attempt.total,
                        ),
                        style: AppType.label1.r.copyWith(
                          color: context.c.labelNeutral,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            // 하단은 홈 인디케이터 간격(34)이다. 이 화면에는 BottomCtaBar 가 없어
            // 토큰을 쓰면 기기에 따라 바닥에 붙는다(sentence_main 과 같은 사정).
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s12,
              AppSpacing.s20,
              34,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.endLearning,
                onPressed: () => _finish(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 채점 전이면 `-%`. 0% 와 다르다.
  String _pct(int? value) => value == null ? '-%' : '$value%';
}
