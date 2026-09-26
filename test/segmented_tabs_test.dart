import 'package:beavertalk/components/molecules/segmented_tabs.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 기록 · 보관함 알약 탭 — Figma `Tab/Pill` `6459:46170`(09-26 사용자 「어떤 버튼이 눌렸는지
/// 티가 안나」 → 검수안 A-1). 예전 버튼 차용(secondaryFill / Outline)은 Light 에서 선택 · 비선택이
/// 같은 모양이었다 — 여기서는 두 상태가 **바탕 · 글자색 · 굵기** 셋 다 다른지를 본다.
void main() {
  Future<AppColorTokens> pump(WidgetTester tester, {int active = 0, ValueChanged<int>? onChanged}) async {
    late AppColorTokens c;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(extensions: const [AppColorTokens.light]),
      home: Scaffold(
        body: Center(
          child: Builder(builder: (ctx) {
            c = ctx.c;
            return SegmentedTabs(
              labels: const ['기록', '보관함'],
              activeIndex: active,
              onChanged: onChanged ?? (_) {},
            );
          }),
        ),
      ),
    ));
    return c;
  }

  Material pillOf(WidgetTester tester, String label) => tester.widget<Material>(
      find.ancestor(of: find.text(label), matching: find.byType(Material)).first);

  Text textOf(WidgetTester tester, String label) => tester.widget<Text>(find.text(label));

  testWidgets('선택 · 비선택이 바탕 · 글자색 · 굵기 모두 다르다', (tester) async {
    final c = await pump(tester);
    expect(pillOf(tester, '기록').color, c.backgroundElevatedAlternative);
    expect(pillOf(tester, '보관함').color, c.fillNormal);
    expect(textOf(tester, '기록').style!.color, c.labelStrong);
    expect(textOf(tester, '보관함').style!.color, c.labelAlternative);
    expect(textOf(tester, '기록').style!.fontWeight, FontWeight.w700);
    expect(textOf(tester, '보관함').style!.fontWeight, FontWeight.w500);
    // Light 에서 두 바탕이 실제로 달라야 한다 — 같은 모양이던 것이 결함이었다.
    expect(c.backgroundElevatedAlternative, isNot(c.fillNormal));
  });

  testWidgets('높이 44 · 반경 12 · 탭 사이 12 · 테두리 없음', (tester) async {
    await pump(tester);
    final a = tester.getRect(find.ancestor(of: find.text('기록'), matching: find.byType(Material)).first);
    final b = tester.getRect(find.ancestor(of: find.text('보관함'), matching: find.byType(Material)).first);
    expect(a.height, 44);
    expect(b.height, 44);
    expect(b.left - a.right, 12);
    final pill = pillOf(tester, '보관함');
    expect(pill.borderRadius, BorderRadius.circular(12));
    expect(pill.shape, isNull);
  });

  testWidgets('누르면 그 번호로 알리고 선택 상태를 읽어 준다', (tester) async {
    final taps = <int>[];
    await pump(tester, active: 1, onChanged: taps.add);
    await tester.tap(find.text('기록'));
    expect(taps, [0]);
    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.text('보관함')),
      isSemantics(label: '보관함', isButton: true, isSelected: true, hasTapAction: true),
    );
    semantics.dispose();
  });
}
