import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 폭을 **필요에 따라** 나누는 가로 행 두 가지(라벨·값 · 가운데 제목).
///
/// 버튼 쌍은 여기 없다 — 09-24 사장님 확정으로 **항상 세로**가 됐다(`StackedButtonPair`,
/// `lib/components/molecules/stacked_button_pair.dart`). 옛 `EqualButtonPair` 는 폐기.
///
/// ## 왜 따로 만들었나
///
/// `Row` 안의 `Flexible`·`Expanded` 는 폭을 **flex 비율로** 나눈다. 한 칸이 짧아 몫을
/// 남겨도 옆 칸은 그 폭을 쓰지 못한다.
/// - `Flexible` 둘 → 남긴 폭이 행 끝에 버려져 값이 가운데로 몰린다(R11, 09-22~23 반복 지적).
/// - `Expanded` 둘(R11 처방) → 행이 반반으로 갈려, 짧은 라벨 옆의 긴 값이 절반 폭 안에서
///   줄을 바꾼다(09-24 설정 이메일 `bt.qa.free0924@example.` / `com`).
/// 뿌리가 같아서 비율로는 둘 다 풀 수 없다. 여기서는 각 칸의 **글자 폭**을 재서 나눈다.
///
/// 전수조사: `40_배포베타_하네스/_output/2026-09-23_앱브랜치정리/02_이른줄바꿈_전수조사.md`
/// 게이트: `test/layout_premature_wrap_test.dart`.

/// 라벨 · 값 행 — 라벨은 시작 쪽 끝, 값은 끝 쪽 끝(Figma justify-between).
///
/// - 두 칸의 한 줄 폭 합이 들어가면: 각자 자기 폭, 사이는 빈 공간(spaceBetween 과 같음).
/// - 안 들어가면: 각 칸에 먼저 **가장 긴 낱말 폭**(min intrinsic)을 준다 — 짧은 라벨이 낱말
///   중간에서 끊기지 않는다. 남은 폭은 「한 줄 폭 − 낱말 폭」 비율로 나눈다. 그래서 짧은 쪽은
///   거의 안 줄고 긴 쪽이 줄을 바꾼다.
/// - 값을 자를지(ellipsis)는 자식 `Text` 가 정한다. 이 행은 자르지 않는다.
/// - 오른쪽→왼쪽 언어(ar·ur)에서는 좌우가 뒤집힌다.
class LabelValueRow extends MultiChildRenderObjectWidget {
  /// Creates a label/value row.
  LabelValueRow({
    super.key,
    required Widget label,
    required Widget value,
    this.gap = 8,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(children: [label, value]);

  /// 두 칸 사이 최소 간격.
  final double gap;

  /// 세로 정렬 — `start`·`center`·`end` 만 쓴다(그 밖은 `start`).
  final CrossAxisAlignment crossAxisAlignment;

  @override
  RenderLabelValueRow createRenderObject(BuildContext context) =>
      RenderLabelValueRow(
        gap: gap,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: Directionality.of(context),
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLabelValueRow renderObject,
  ) {
    renderObject
      ..gap = gap
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = Directionality.of(context);
  }
}

/// 가운데 제목 + 시작 쪽 버튼 — 「취소 · 제목 · (빈칸)」 시트 머리.
///
/// 시작 쪽 칸은 **자기 글자 폭**만 쓰고(행 폭의 30% 상한), 끝 쪽에 같은 폭을 비워 둔다.
/// 제목은 그 사이 폭 안에서 행의 가운데에 선다. 1:2:1 비율 분할은 긴 「キャンセル」·
/// 「Отмена」 를 줄바꿈시키면서 오른쪽 빈칸 72~82px 를 버렸다(09-24 전수조사 G).
class CenteredTitleRow extends MultiChildRenderObjectWidget {
  /// Creates a centered-title header row.
  CenteredTitleRow({
    super.key,
    required Widget leading,
    required Widget title,
    this.maxLeadingFraction = 0.3,
  }) : super(children: [leading, title]);

  /// 시작 쪽 칸 폭 상한(행 폭 대비).
  final double maxLeadingFraction;

  @override
  RenderCenteredTitleRow createRenderObject(BuildContext context) =>
      RenderCenteredTitleRow(
        maxLeadingFraction: maxLeadingFraction,
        textDirection: Directionality.of(context),
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCenteredTitleRow renderObject,
  ) {
    renderObject
      ..maxLeadingFraction = maxLeadingFraction
      ..textDirection = Directionality.of(context);
  }
}

class _RowParentData extends ContainerBoxParentData<RenderBox> {}

/// 두 자식 행의 공통 틀 — 자식 관리 · 칠하기 · 누르기.
abstract class _RenderTwoChildRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _RowParentData> {
  _RenderTwoChildRow({required TextDirection textDirection})
    : _textDirection = textDirection;

  TextDirection _textDirection;
  set textDirection(TextDirection v) {
    if (v == _textDirection) return;
    _textDirection = v;
    markNeedsLayout();
  }

  bool get _rtl => _textDirection == TextDirection.rtl;

  RenderBox get _first => firstChild!;
  RenderBox get _second => lastChild!;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RowParentData) {
      child.parentData = _RowParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  void _place(RenderBox child, double x, double y) {
    (child.parentData! as _RowParentData).offset = Offset(x, y);
  }
}

/// [LabelValueRow] 의 렌더 객체.
class RenderLabelValueRow extends _RenderTwoChildRow {
  /// Creates the render object.
  RenderLabelValueRow({
    required double gap,
    required CrossAxisAlignment crossAxisAlignment,
    required super.textDirection,
  }) : _gap = gap,
       _cross = crossAxisAlignment;

  double _gap;
  set gap(double v) {
    if (v == _gap) return;
    _gap = v;
    markNeedsLayout();
  }

  CrossAxisAlignment _cross;
  set crossAxisAlignment(CrossAxisAlignment v) {
    if (v == _cross) return;
    _cross = v;
    markNeedsLayout();
  }

  /// 라벨 · 값 폭 배분. [maxWidth] 가 무한이면 각자 한 줄 폭.
  (double, double) splitWidths(double maxWidth) {
    final a = _first.getMaxIntrinsicWidth(double.infinity);
    final b = _second.getMaxIntrinsicWidth(double.infinity);
    if (!maxWidth.isFinite) return (a, b);
    final avail = math.max(0.0, maxWidth - _gap);
    if (a + b <= avail) return (a, b);
    final aMin = math.min(a, _first.getMinIntrinsicWidth(double.infinity));
    final bMin = math.min(b, _second.getMinIntrinsicWidth(double.infinity));
    final mins = aMin + bMin;
    if (mins >= avail) {
      // 낱말 하나씩도 다 안 들어간다 — 낱말 폭 비율로 나눈다(둘 다 줄을 바꾼다).
      if (mins <= 0) return (avail / 2, avail / 2);
      final la = avail * aMin / mins;
      return (la, avail - la);
    }
    final extra = avail - mins;
    final ga = a - aMin;
    final gb = b - bMin;
    final grow = ga + gb;
    final la = aMin + (grow <= 0 ? extra / 2 : extra * ga / grow);
    return (la, avail - la);
  }

  double _y(double rowH, double childH) => switch (_cross) {
    CrossAxisAlignment.center => (rowH - childH) / 2,
    CrossAxisAlignment.end => rowH - childH,
    _ => 0,
  };

  @override
  void performLayout() {
    final (la, lb) = splitWidths(constraints.maxWidth);
    _first.layout(BoxConstraints(maxWidth: la), parentUsesSize: true);
    _second.layout(BoxConstraints(maxWidth: lb), parentUsesSize: true);
    final h = math.max(_first.size.height, _second.size.height);
    final w = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : _first.size.width + _gap + _second.size.width;
    size = constraints.constrain(Size(w, h));
    final start = _rtl ? size.width - _first.size.width : 0.0;
    final end = _rtl ? 0.0 : size.width - _second.size.width;
    _place(_first, start, _y(size.height, _first.size.height));
    _place(_second, end, _y(size.height, _second.size.height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final (la, lb) = splitWidths(constraints.maxWidth);
    final s1 = _first.getDryLayout(BoxConstraints(maxWidth: la));
    final s2 = _second.getDryLayout(BoxConstraints(maxWidth: lb));
    final w = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : s1.width + _gap + s2.width;
    return constraints.constrain(Size(w, math.max(s1.height, s2.height)));
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _first.getMinIntrinsicWidth(height) +
      _gap +
      _second.getMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _first.getMaxIntrinsicWidth(height) +
      _gap +
      _second.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) {
    final (la, lb) = splitWidths(width);
    return math.max(
      _first.getMinIntrinsicHeight(la),
      _second.getMinIntrinsicHeight(lb),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final (la, lb) = splitWidths(width);
    return math.max(
      _first.getMaxIntrinsicHeight(la),
      _second.getMaxIntrinsicHeight(lb),
    );
  }
}

/// [CenteredTitleRow] 의 렌더 객체.
class RenderCenteredTitleRow extends _RenderTwoChildRow {
  /// Creates the render object.
  RenderCenteredTitleRow({
    required double maxLeadingFraction,
    required super.textDirection,
  }) : _fraction = maxLeadingFraction;

  double _fraction;
  set maxLeadingFraction(double v) {
    if (v == _fraction) return;
    _fraction = v;
    markNeedsLayout();
  }

  double _leadingCap(double maxWidth) =>
      maxWidth.isFinite ? maxWidth * _fraction : double.infinity;

  @override
  void performLayout() {
    final maxW = constraints.maxWidth;
    _first.layout(
      BoxConstraints(maxWidth: _leadingCap(maxW)),
      parentUsesSize: true,
    );
    final side = _first.size.width;
    final titleMax = maxW.isFinite
        ? math.max(0.0, maxW - 2 * side)
        : double.infinity;
    _second.layout(BoxConstraints(maxWidth: titleMax), parentUsesSize: true);
    final w = maxW.isFinite ? maxW : 2 * side + _second.size.width;
    final h = math.max(_first.size.height, _second.size.height);
    size = constraints.constrain(Size(w, h));
    _place(
      _first,
      _rtl ? size.width - side : 0,
      (size.height - _first.size.height) / 2,
    );
    _place(
      _second,
      (size.width - _second.size.width) / 2,
      (size.height - _second.size.height) / 2,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final maxW = constraints.maxWidth;
    final s1 = _first.getDryLayout(BoxConstraints(maxWidth: _leadingCap(maxW)));
    final titleMax = maxW.isFinite
        ? math.max(0.0, maxW - 2 * s1.width)
        : double.infinity;
    final s2 = _second.getDryLayout(BoxConstraints(maxWidth: titleMax));
    final w = maxW.isFinite ? maxW : 2 * s1.width + s2.width;
    return constraints.constrain(Size(w, math.max(s1.height, s2.height)));
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      2 * _first.getMinIntrinsicWidth(height) +
      _second.getMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      2 * _first.getMaxIntrinsicWidth(height) +
      _second.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) => math.max(
    _first.getMinIntrinsicHeight(width * _fraction),
    _second.getMinIntrinsicHeight(width),
  );

  @override
  double computeMaxIntrinsicHeight(double width) => math.max(
    _first.getMaxIntrinsicHeight(width * _fraction),
    _second.getMaxIntrinsicHeight(width),
  );
}

/// **균등 격자**가 디자인인 행 표시 — 안의 `Row` 는 칸을 같은 폭으로 나누는 것이 Figma 의도다.
///
/// 칸 폭을 필요에 따라 나누면 격자가 깨진다(지표 3칸 등). 그래서 이 행들은 비율 분할을 유지하고,
/// 이른 줄바꿈 게이트(`test/layout_premature_wrap_test.dart`)는 이 표시 안의 행을 건너뛴다.
/// ⛔ Figma 에서 칸들이 모두 FILL(같은 폭)임을 확인한 곳에만 쓴다 — [figmaNode] 가 그 근거다.
class FigmaEqualColumns extends StatelessWidget {
  /// Marks [child] as an intentional equal-width grid.
  const FigmaEqualColumns({
    super.key,
    required this.figmaNode,
    required this.child,
  });

  /// 근거 Figma 노드(칸이 모두 FILL 인 행).
  final String figmaNode;

  /// 격자 행.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
