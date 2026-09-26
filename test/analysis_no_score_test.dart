import 'package:beavertalk/components/molecules/card_study.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 점수 없는 통화 분석 — 이유 한 줄 · 카드 규칙(QA F046 · PM-DEC-043).
///
/// 점수는 문장을 복습(연습)해 채점될 때만 생긴다(서버 review_service). 그래서 「-%」 는
/// 「배운 문장 있음·복습 전」 과 「배운 문장 0개」 둘로 갈린다.
void main() {
  Widget host(CallResult r) => ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            settings: RouteSettings(arguments: r),
            builder: (_) => const AnalysisScreen(),
          ),
        ),
      );

  CallResult result({required bool sentences, double? score}) => CallResult(
        callId: 1,
        average: ScoreAverage(totalScore: score),
        sentences: sentences
            ? const [LearnedSentence(sentenceId: 10, korean: '저는 선생님이에요', native: "I'm a teacher")]
            : const [],
      );

  Future<void> pump(WidgetTester tester, CallResult r) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host(r));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('배운 문장 있음 · 복습 전 — 「복습하면」 안내 · 학습 카드 둘', (tester) async {
    await pump(tester, result(sentences: true));
    expect(find.text('Practice the sentences to get your pronunciation score'), findsOneWidget);
    expect(find.text('Practice pronunciation'), findsOneWidget);
    expect(find.text('Pronunciation Challenge'), findsOneWidget);
  });

  testWidgets('배운 문장 0개 — 「점수를 낼 문장이 없어요」 · 발음 학습 숨김 · 챌린지 켜짐', (tester) async {
    await pump(tester, result(sentences: false));
    expect(find.text('No sentences to score'), findsOneWidget);
    expect(find.text('Practice the sentences to get your pronunciation score'), findsNothing);
    expect(find.text('Practice pronunciation'), findsNothing);
    final challenge = tester.widget<CardStudy>(find.ancestor(
      of: find.text('Pronunciation Challenge'),
      matching: find.byType(CardStudy),
    ));
    expect(challenge.onTap, isNotNull, reason: '문장이 없으면 기본 단어로 플레이');
  });

  testWidgets('점수가 있으면 안내 없음', (tester) async {
    await pump(tester, result(sentences: true, score: 81));
    expect(find.text('Practice the sentences to get your pronunciation score'), findsNothing);
    expect(find.text('No sentences to score'), findsNothing);
  });
}
