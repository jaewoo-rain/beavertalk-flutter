import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 바텀시트·하단 버튼 영역의 아래 여백 — 앱 전체에서 이 한 곳에서만 계산한다(PM-DEC-807).
///
/// 규칙: `화면 바닥에서 잰 아래 여백 = max(34, OS 아래 인셋 + 12)`.
/// 인셋 0(홈 버튼 기기·웹)은 34(Figma Padding/V/34), iPhone 홈 인디케이터(34)는 46, 3버튼 내비(48)는 60 이다.
/// 옛 규칙 두 갈래 — 시트 `max(인셋, 24)`(3버튼 내비에서 버튼이 내비에 닿아 보임 · PM-DEC-803)와
/// `SafeArea(minimum: 24)` 를 바깥 `SafeArea` 안에 둔 화면의 `인셋 + 24`(iPhone 58) — 를 이것으로 모은다.
///
/// 바깥 `SafeArea` 가 이미 인셋을 넣었으면(AppScaffold 안의 [BottomCtaBar] 등) 그만큼 빼고 나머지만 둔다 —
/// 어느 자리에 두어도 화면 바닥에서 잰 값은 같다. 이미 들어간 몫은 뷰의 인셋과 지금 자리 MediaQuery 인셋의 차로 안다.
///
/// ⛔ 안쪽에 `SafeArea`·`showModalBottomSheet(useSafeArea: true)` 를 또 겹치지 않는다.
class SheetBottomInset extends StatelessWidget {
  const SheetBottomInset({super.key, this.floor = defaultFloor, this.child = const SizedBox.shrink()});

  /// 인셋이 없을 때의 아래 여백(PM-DEC-807 · 34).
  static const double defaultFloor = 34;

  /// 인셋이 있을 때 그 위로 더 띄우는 몫(PM-DEC-803).
  static const double _aboveInset = 12;

  final double floor;

  final Widget child;

  /// 지금 자리에 둘 아래 여백 — 바깥에서 이미 넣은 인셋을 뺀 값이다.
  static double of(BuildContext context, {double floor = defaultFloor}) {
    final here = MediaQuery.paddingOf(context).bottom;
    final view = View.maybeOf(context);
    final raw = view == null ? here : view.padding.bottom / view.devicePixelRatio;
    final inset = math.max(here, raw);
    final consumed = math.max(0.0, raw - here);
    return math.max(floor, inset + _aboveInset) - consumed;
  }

  @override
  Widget build(BuildContext context) {
    // 좌우 안전영역은 예전 SafeArea(top: false) 그대로 지킨다. 아래는 이 값 하나로만.
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: of(context, floor: floor)),
        child: MediaQuery.removePadding(context: context, removeBottom: true, child: child),
      ),
    );
  }
}
