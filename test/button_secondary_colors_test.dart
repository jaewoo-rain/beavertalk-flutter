import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/components/molecules/pronunciation_result.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 보조 버튼 색 — 09-26 바텀시트·버튼 전수조사 사용자 결정
/// (`_shared/비버톡_앱_바텀시트_버튼색_전수조사_2026-09-26.md` §2).
///
/// - secondaryOutline 은 테두리가 바탕과 같아 secondaryFill 과 같은 모양이었다 →
///   바탕 투명 · 테두리 Line/Neutral 1px.
/// - Light 토큰 두 개가 07-17 스냅숏(#F6F6F7 · #F7F7FB)에 머물러 흰 시트 위 보조 버튼
///   경계가 안 보였다 → Figma 값으로 고정.
void main() {
  Future<Material> pumpButton(WidgetTester tester, BtnType type) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(extensions: const [AppColorTokens.light]),
      home: Scaffold(
        body: Center(
          child: Button(type: type, size: BtnSize.s60, text: '홈으로', onPressed: () {}),
        ),
      ),
    ));
    return tester.widget<Material>(
        find.ancestor(of: find.text('홈으로'), matching: find.byType(Material)).first);
  }

  testWidgets('secondaryOutline — 바탕 투명 · 테두리 Line/Neutral 1px', (tester) async {
    final m = await pumpButton(tester, BtnType.secondaryOutline);
    expect(m.color, Colors.transparent);
    final side = (m.shape! as RoundedRectangleBorder).side;
    expect(side.color, AppColorTokens.light.lineNeutral);
    expect(side.width, 1);
  });

  testWidgets('secondaryFill 은 그대로 — 바탕 Background/Normal/Alternative · 테두리 없음',
      (tester) async {
    final m = await pumpButton(tester, BtnType.secondaryFill);
    expect(m.color, AppColorTokens.light.backgroundNormalAlternative);
    expect((m.shape! as RoundedRectangleBorder).side, BorderSide.none);
  });

  // 09-26 시안 B — 흰 카드 위 불투명 회색(#CBCCD3)이 너무 진했다 → 반투명 Fill.
  testWidgets('secondaryElevated — 바탕 Fill/Strong(반투명) · 글자 Common/WhiteAndDark',
      (tester) async {
    final m = await pumpButton(tester, BtnType.secondaryElevated);
    expect(m.color, AppColorTokens.light.fillStrong);
    expect(m.color!.a, lessThan(1), reason: '불투명이면 면에 따라 맞춰지지 않는다');
    final label = tester.widget<Text>(find.text('홈으로'));
    expect(label.style!.color, AppColorTokens.light.commonWhiteAndDark);
  });

  testWidgets('채점 전 지표 패널은 Fill/Alternative · 점수 있으면 그대로', (tester) async {
    Future<Color?> panelColor(PronunciationState state) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: const [AppColorTokens.light]),
        home: Scaffold(
          body: SingleChildScrollView(
            child: PronunciationResult(
              state: state,
              score: 80,
              metrics: const [
                PronunciationMetric(label: '발음', value: '-%'),
                PronunciationMetric(label: '유창성', value: '-%'),
                PronunciationMetric(label: '리듬', value: '-%'),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final panel = tester.widget<Container>(find
          .ancestor(of: find.text('유창성'), matching: find.byType(Container))
          .first);
      return (panel.decoration as BoxDecoration?)?.color;
    }

    expect(await panelColor(PronunciationState.inactive), AppColorTokens.light.fillAlternative);
    expect(await panelColor(PronunciationState.active),
        AppColorTokens.light.backgroundSurfaceAlternative);
  });

  test('Light 토큰 두 개는 Figma 값이다', () {
    expect(AppColorTokens.light.backgroundNormalAlternative, const Color(0xFFDBDCE2));
    expect(AppColorTokens.light.backgroundElevatedNormal, const Color(0xFFCBCCD3));
    // Dark 는 바꾸지 않았다.
    expect(AppColorTokens.dark.backgroundNormalAlternative, const Color(0xFF252932));
    expect(AppColorTokens.dark.backgroundElevatedNormal, const Color(0xFF2F3340));
  });
}
