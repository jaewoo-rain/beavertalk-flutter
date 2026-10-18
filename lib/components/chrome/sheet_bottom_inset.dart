import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 바텀시트·하단 패널의 아래 여백 — **OS 아래 인셋을 한 번만** 세고, 그보다 작으면 [floor] 를 쓴다(PM-DEC-798).
///
/// 규칙: `아래 여백 = max(floor, 남은 아래 인셋)`. 홈 버튼 기기(인셋 0)는 [floor], iPhone 홈 인디케이터(34)는
/// max(floor, 34), 3버튼 내비(48)는 48 이다. 09-26 바텀시트 규칙표(「max(인셋, 24)」)와 같은 규칙이다.
///
/// ⛔ 안쪽에 `SafeArea`·`showModalBottomSheet(useSafeArea: true)` 를 겹치지 않는다 — 인셋이 두 번 들어간다.
///   위쪽 `SafeArea` 가 이미 인셋을 먹었으면 `MediaQuery.paddingOf` 가 0 이라 [floor] 만 남는다(이중 여백 없음).
class SheetBottomInset extends StatelessWidget {
  const SheetBottomInset({super.key, this.floor = 24, required this.child});

  /// 인셋이 없거나 작을 때의 최소 아래 여백(BottomSheet·BottomCtaBar 24 · 통화 i 시트 Figma 34).
  final double floor;

  final Widget child;

  /// 지금 자리에서의 아래 여백 값.
  static double of(BuildContext context, {double floor = 24}) =>
      math.max(floor, MediaQuery.paddingOf(context).bottom);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: of(context, floor: floor)),
      child: child,
    );
  }
}
