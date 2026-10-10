import 'package:flutter/widgets.dart';

/// 버튼 쌍 — **항상 위아래로 쌓는다**(09-24 사장님 확정, app designer 세션 경유).
///
/// 「양옆에 나란히 놓인 버튼 쌍을 전부 위아래로 쌓습니다」 — 다국어에서 반 폭 버튼 글자가
/// 잘리거나 줄을 바꾸는 것을 막는 것이 목적이다. 좁을 때만 쌓던 옛 `EqualButtonPair`
/// (「평소 1:1, 좁으면 세로」)는 폐기했다. 폭을 재서 가르는 분기가 없다.
///
/// - 두 버튼 모두 전폭 · 사이 [gap](기본 12).
/// - 순서는 **화면마다 Figma 를 따른다** — 그래서 슬롯 이름이 주요·보조가 아니라 [top]·[bottom] 이다.
///   - 보통은 흐름이 유도하는 주요 버튼이 아래(보조 위 → 주요 아래).
///   - 예외(주요 버튼이 위, 의도): 음소 다이얼로그 · 페이월 이탈 방지 · 결제 오류(`depth/plans_error`).
/// - 색은 각 버튼의 `type` 이 정한다. 이 위젯은 배치만 한다.
class StackedButtonPair extends StatelessWidget {
  /// Creates a vertical button pair.
  const StackedButtonPair({
    super.key,
    required this.top,
    required this.bottom,
    this.gap = 12,
  });

  /// 위 버튼.
  final Widget top;

  /// 아래 버튼.
  final Widget bottom;

  /// 두 버튼 사이.
  final double gap;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [top, SizedBox(height: gap), bottom],
  );
}
