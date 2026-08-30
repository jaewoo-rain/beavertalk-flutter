import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/icon_toggle.dart';
import 'package:beavertalk/components/icons/app_icons.dart';

/// [IconToggle] 이 지켜야 하는 것 두 가지.
///
/// 1. **자리가 안 움직인다.** 팝은 `Transform` 이라 레이아웃을 안 먹어야 한다 —
///    아이콘이 눌린 자리에서 밀리면 그건 토글이 아니라 결함이다.
/// 2. **전환이 즉시가 아니다.** 켠 직후 프레임에서 두 글리프가 함께 떠 있어야
///    교차 페이드가 실제로 걸린 것이다.
void main() {
  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  testWidgets('켜고 꺼도 상자 크기가 그대로다', (tester) async {
    Widget build(bool v) => host(
          IconToggle(
            value: v,
            onIcon: AppIcons.bookmarkFill,
            offIcon: AppIcons.bookmarkLine,
            onColor: const Color(0xFF00B57E),
            offColor: const Color(0xFF9EA3B2),
            size: 32,
            onTap: () {},
          ),
        );

    await tester.pumpWidget(build(false));
    final Rect off = tester.getRect(find.byType(IconToggle));

    await tester.pumpWidget(build(true));
    // 팝이 가장 큰 전환 한가운데에서 재도 크기가 같아야 한다.
    await tester.pump(const Duration(milliseconds: 90));
    expect(tester.getRect(find.byType(IconToggle)), off);

    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getRect(find.byType(IconToggle)), off);
    expect(off.size, const Size(32, 32));
  });

  testWidgets('전환 중에는 두 글리프가 함께 떠 있다 — 즉시 교체가 아니다',
      (tester) async {
    Widget build(bool v) => host(
          IconToggle(
            value: v,
            onIcon: AppIcons.bookmarkFill,
            offIcon: AppIcons.bookmarkLine,
            onColor: const Color(0xFF00B57E),
            offColor: const Color(0xFF9EA3B2),
            onTap: () {},
          ),
        );

    await tester.pumpWidget(build(false));
    await tester.pumpWidget(build(true));
    await tester.pump(const Duration(milliseconds: 60));

    final opacities = tester
        .widgetList<Opacity>(find.byType(Opacity))
        .map((o) => o.opacity)
        .toList();
    expect(opacities.length, 2);
    // 어느 쪽도 0 이나 1 에 붙어 있지 않다 = 아직 섞이는 중이다.
    for (final o in opacities) {
      expect(o, greaterThan(0.0));
      expect(o, lessThan(1.0));
    }
  });

  testWidgets('onTap 이 null 이면 눌리지 않는다', (tester) async {
    await tester.pumpWidget(host(
      IconToggle(
        value: true,
        onIcon: AppIcons.bookmarkFill,
        offIcon: AppIcons.bookmarkLine,
        onColor: const Color(0xFF00B57E),
        offColor: const Color(0xFF9EA3B2),
      ),
    ));
    expect(find.byType(GestureDetector), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
