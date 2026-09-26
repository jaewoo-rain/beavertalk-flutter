import 'package:beavertalk/components/atoms/button.dart';
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

  test('Light 토큰 두 개는 Figma 값이다', () {
    expect(AppColorTokens.light.backgroundNormalAlternative, const Color(0xFFDBDCE2));
    expect(AppColorTokens.light.backgroundElevatedNormal, const Color(0xFFCBCCD3));
    // Dark 는 바꾸지 않았다.
    expect(AppColorTokens.dark.backgroundNormalAlternative, const Color(0xFF252932));
    expect(AppColorTokens.dark.backgroundElevatedNormal, const Color(0xFF2F3340));
  });
}
