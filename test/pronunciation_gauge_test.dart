import 'package:beavertalk/components/molecules/pronunciation_result.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 발음 결과 게이지 H4 「채움 + 구간 배경」(09-24 사장님 확정 · 원장 P32 · Figma `2224:20999`).
void main() {
  const metrics = [
    PronunciationMetric(label: 'Pronunciation', value: '96%', score: 96),
    PronunciationMetric(label: 'Fluency', value: '41%', score: 41),
    PronunciationMetric(label: 'Rhythm', value: '12%', score: 12),
  ];

  Future<AppColorTokens> pump(WidgetTester tester, Widget child,
      {bool disableAnimations = false}) async {
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: Center(child: SizedBox(width: 335, child: child))),
      ),
    ));
    // 테마 확장이 없으면 `context.c` 는 Dark 토큰이다.
    return AppColorTokens.dark;
  }

  Color colorOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style!.color!;

  test('구간 = min(5, floor(score/20)+1) — 경계 20 은 2구간', () {
    expect(pronunciationBand(0), 1);
    expect(pronunciationBand(19.9), 1);
    expect(pronunciationBand(20), 2);
    expect(pronunciationBand(59), 3);
    expect(pronunciationBand(60), 4);
    expect(pronunciationBand(80), 5);
    expect(pronunciationBand(100), 5);
  });

  testWidgets('끝나면 점수 · 지표 값이 각자 구간 글자색 · 패널 테두리는 전체 구간 색', (tester) async {
    final c = await pump(tester, const PronunciationResult(score: 72, metrics: metrics));
    await tester.pumpAndSettle();
    expect(colorOf(tester, '72%'), c.score4Text);
    expect(colorOf(tester, '96%'), c.score5Text);
    expect(colorOf(tester, '41%'), c.score3Text);
    expect(colorOf(tester, '12%'), c.score1Text);
    final panel = tester.widget<Container>(find.ancestor(
        of: find.text('Pronunciation'), matching: find.byType(Container)).first);
    final border = (panel.foregroundDecoration! as BoxDecoration).border! as Border;
    expect(border.top.color, c.score4);
    expect(border.top.width, 1);
  });

  testWidgets('처음엔 0 에서 센다 — 900ms 뒤 최종값', (tester) async {
    await pump(tester, const PronunciationResult(score: 72, metrics: metrics));
    expect(find.text('0%'), findsWidgets, reason: '가운데 · 지표 모두 0 부터');
    await tester.pump(const Duration(milliseconds: 300));
    final mid = find.textContaining('%').evaluate().map((e) => (e.widget as Text).data!).toList();
    expect(mid.contains('72%'), isFalse, reason: '아직 세는 중');
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('72%'), findsOneWidget);
    expect(find.text('96%'), findsOneWidget);
  });

  testWidgets('애니메이션 끄기면 첫 화면부터 최종값', (tester) async {
    await pump(tester, const PronunciationResult(score: 72, metrics: metrics),
        disableAnimations: true);
    await tester.pump();
    expect(find.text('72%'), findsOneWidget);
    expect(find.text('12%'), findsOneWidget);
  });

  testWidgets('inactive — -% · 테두리 없음 · 재생 없음', (tester) async {
    await pump(
      tester,
      const PronunciationResult(
        score: 0,
        state: PronunciationState.inactive,
        metrics: [
          PronunciationMetric(label: 'Pronunciation', value: '-%'),
          PronunciationMetric(label: 'Fluency', value: '-%'),
          PronunciationMetric(label: 'Rhythm', value: '-%'),
        ],
      ),
    );
    expect(find.text('-%'), findsNWidgets(4));
    final panel = tester.widget<Container>(find.ancestor(
        of: find.text('Pronunciation'), matching: find.byType(Container)).first);
    expect(panel.foregroundDecoration, isNull);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
