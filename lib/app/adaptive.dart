import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/app_spacing.dart';

/// 적응형 레이아웃 규약 — 폭이 넓어지면 **여백만 자라고 콘텐츠는 캡에서 멈춘다.**
///
/// Figma 정본 `┗ Design · Tablet`(`5272:22731`)의 규격 노트(`5294:8544`)와
/// 프레임 144장에서 유도했다. 두 앵커만 맞추면 나머지가 따라온다:
///
/// | | 모바일 375 | 태블릿 810 |
/// |---|---|---|
/// | 좌우 여백 | 20 | 105 |
/// | 콘텐츠 폭 | 335 | 600 |
///
/// `여백 = max(20, (폭 - 600) / 2)` 하나가 두 앵커를 정확히 통과한다. 640에서
/// 여백 20·콘텐츠 600 이 되므로 375~810 구간이 **끊기지 않고 이어진다** — 특정
/// 폭에서 레이아웃이 튀는 브레이크포인트 분기를 쓰지 않는 이유다.
///
/// 그래서 이 파일에는 `isTablet` 류의 판정이 없다. 기기를 묻지 말고 **가용 폭을
/// 물어라**: 같은 규칙이 폰·태블릿·Split View·데스크탑 창에 그대로 적용된다.
abstract final class AppLayout {
  /// 폰에서의 좌우 여백(Figma `screen/gutter-x` 모바일 모드).
  static const double gutter = AppSpacing.s20;

  /// 본문 콘텐츠 폭 상한. 태블릿 810에서 좌우 105를 뺀 값이다.
  static const double content = 600;

  /// 안내문·다이얼로그·경고의 폭 상한. 태블릿 810에서 좌우 165를 뺀 값이다.
  ///
  /// 한 줄이 너무 길면 읽는 눈이 다음 줄 첫 글자를 못 찾는다. 본문 컬럼보다
  /// 좁게 잡는 이유이고, 빈 상태·오류 화면의 문구도 이 폭을 쓴다.
  static const double narrow = 480;

  /// 약관·개인정보 같은 긴 문서의 폭 상한. 태블릿 810에서 좌우 55를 뺀 값이다.
  static const double document = 700;

  /// 하단 탭바 폭 상한. 태블릿에서도 375를 유지하고 하단 중앙에 둔다.
  static const double navBar = 375;

  /// 타일 그리드의 간격(Figma 태블릿 2열: 290 + 20 + 290 = 600).
  static const double gridGap = AppSpacing.s20;

  /// 타일 한 칸의 최소 폭. 이 값으로 열 수를 나눈다.
  ///
  /// 콘텐츠 600에서 정확히 2열(290)이 나오고, 폰 335에서는 1열이 된다.
  static const double gridMinTile = 300;

  /// 영상칸 비율(16:9). 태블릿 600 → 337.5, 폰 375 → 210.9375.
  static const double videoAspect = 16 / 9;

  /// [available] 폭에서 콘텐츠를 [cap] 으로 묶기 위한 좌우 여백.
  ///
  /// 폰처럼 좁으면 [gutter] 그대로, 넓어지면 남는 폭을 절반씩 나눠 가진다.
  static double gutterFor(double available, {double cap = content}) =>
      math.max(gutter, (available - cap) / 2);

  /// [available] 폭 안에 놓을 카드(다이얼로그·오버레이)의 폭.
  ///
  /// 좌우 [gutter] 를 남기고 [cap] 에서 멈춘다 — 폰 375에서 335, 태블릿 810에서
  /// 480이 되어 정본 두 값을 그대로 통과한다.
  static double cardWidthFor(double available, {double cap = narrow}) =>
      math.min(available - gutter * 2, cap);

  /// [available] 폭에 들어가는 타일 열 수.
  ///
  /// 1열 이상을 보장한다 — 폭이 [gridMinTile] 보다 좁아도 0열이 되면 안 된다.
  static int columnsFor(double available, {double minTile = gridMinTile}) =>
      math.max(1, (available / minTile).floor());

  /// [columns] 열로 나눌 때 타일 한 칸의 폭.
  static double tileWidthFor(
    double available, {
    int? columns,
    double gap = gridGap,
    double minTile = gridMinTile,
  }) {
    final n = columns ?? columnsFor(available, minTile: minTile);
    return (available - gap * (n - 1)) / n;
  }
}

/// 자식을 콘텐츠 컬럼에 가두는 좌우 패딩.
///
/// 폰에서는 [AppLayout.gutter] 여백, 넓어지면 [maxWidth] 중앙 정렬이다.
/// 화면 본문의 `EdgeInsets.symmetric(horizontal: AppSpacing.s20)` 자리를
/// 이것으로 바꾸면 폰 레이아웃은 그대로 두고 태블릿만 얻는다.
///
/// 들어온 제약(가용 폭)으로 계산하므로 스크롤 뷰·시트·분할된 칸 안에서도
/// 맞는 값이 나온다. `MediaQuery` 로 화면 폭을 보면 좁은 칸 안에서 틀린다.
///
/// **`LayoutBuilder` 로 만들지 않았다.** 그렇게 짰더니 `IntrinsicHeight` 를 쓰는
/// 화면 5장이 「LayoutBuilder does not support returning intrinsic dimensions」
/// 로 전부 죽었다(로케일 30 × 화면 5 = 150건). 고유 크기 질의는 레이아웃 전에
/// 오는데 `LayoutBuilder` 는 레이아웃 시점에야 자식을 만들 수 있어 답을 못 한다.
/// 그래서 [RenderPadding] 과 같은 층에서, 여백만 폭에 따라 정하는 렌더
/// 오브젝트로 짰다 — 고유 크기 질의에도 답한다.
class ContentColumn extends SingleChildRenderObjectWidget {
  /// 본문 폭([AppLayout.content])으로 가두는 컬럼을 만든다.
  const ContentColumn({
    super.key,
    required Widget super.child,
    this.maxWidth = AppLayout.content,
    this.gutter = AppLayout.gutter,
    this.padding = EdgeInsets.zero,
  });

  /// 안내문·경고 폭([AppLayout.narrow])으로 가둔다.
  const ContentColumn.narrow({
    super.key,
    required Widget super.child,
    this.gutter = AppLayout.gutter,
    this.padding = EdgeInsets.zero,
  }) : maxWidth = AppLayout.narrow;

  /// 긴 문서 폭([AppLayout.document])으로 가둔다.
  const ContentColumn.document({
    super.key,
    required Widget super.child,
    this.gutter = AppLayout.gutter,
    this.padding = EdgeInsets.zero,
  }) : maxWidth = AppLayout.document;

  /// 콘텐츠 폭 상한.
  final double maxWidth;

  /// 폰에서의 최소 좌우 여백.
  final double gutter;

  /// 여백 **안쪽**에 더 얹을 패딩. 세로 값을 넘기는 자리다.
  ///
  /// 좌우 값을 같이 넘기면 여백에 더해진다 — 여백을 대체하지 않는다.
  final EdgeInsets padding;

  @override
  RenderContentColumn createRenderObject(BuildContext context) =>
      RenderContentColumn(
        maxWidth: maxWidth,
        gutter: gutter,
        extra: padding,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderContentColumn renderObject,
  ) {
    renderObject
      ..maxWidth = maxWidth
      ..gutter = gutter
      ..extra = padding;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('maxWidth', maxWidth));
    properties.add(DoubleProperty('gutter', gutter));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}

/// [ContentColumn] 의 렌더 오브젝트 — 좌우 여백을 **들어온 폭에서** 정한다.
class RenderContentColumn extends RenderShiftedBox {
  /// 렌더 오브젝트를 만든다.
  RenderContentColumn({
    required double maxWidth,
    required double gutter,
    required EdgeInsets extra,
    RenderBox? child,
  })  : _maxWidth = maxWidth,
        _gutter = gutter,
        _extra = extra,
        super(child);

  double _maxWidth;

  /// 콘텐츠 폭 상한.
  double get maxWidth => _maxWidth;
  set maxWidth(double value) {
    if (_maxWidth == value) return;
    _maxWidth = value;
    markNeedsLayout();
  }

  double _gutter;

  /// 최소 좌우 여백.
  double get gutter => _gutter;
  set gutter(double value) {
    if (_gutter == value) return;
    _gutter = value;
    markNeedsLayout();
  }

  EdgeInsets _extra;

  /// 여백 안쪽에 더 얹는 패딩.
  EdgeInsets get extra => _extra;
  set extra(EdgeInsets value) {
    if (_extra == value) return;
    _extra = value;
    markNeedsLayout();
  }

  /// [width] 안에서의 좌우 여백. 폭을 모르면 최소값을 쓴다.
  double _insetFor(double width) => width.isFinite
      ? math.max(_gutter, (width - _maxWidth) / 2)
      : _gutter;

  /// 자식에게 남는 가로 폭.
  double _innerWidth(double width) => width.isFinite
      ? math.max(0.0, width - _insetFor(width) * 2 - _extra.horizontal)
      : double.infinity;

  @override
  double computeMinIntrinsicWidth(double height) {
    final inner = child?.getMinIntrinsicWidth(
          math.max(0.0, height - _extra.vertical),
        ) ??
        0.0;
    return inner + _gutter * 2 + _extra.horizontal;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final inner = child?.getMaxIntrinsicWidth(
          math.max(0.0, height - _extra.vertical),
        ) ??
        0.0;
    return inner + _gutter * 2 + _extra.horizontal;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final inner = child?.getMinIntrinsicHeight(_innerWidth(width)) ?? 0.0;
    return inner + _extra.vertical;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final inner = child?.getMaxIntrinsicHeight(_innerWidth(width)) ?? 0.0;
    return inner + _extra.vertical;
  }

  BoxConstraints _innerConstraints(BoxConstraints constraints) {
    final inset = _insetFor(constraints.maxWidth);
    return constraints.deflate(
      EdgeInsets.symmetric(horizontal: inset).add(_extra) as EdgeInsets,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    final inset = _insetFor(constraints.maxWidth);
    if (child == null) {
      return constraints.constrain(
        Size(inset * 2 + _extra.horizontal, _extra.vertical),
      );
    }
    final childSize = child.getDryLayout(_innerConstraints(constraints));
    return constraints.constrain(Size(
      inset * 2 + _extra.horizontal + childSize.width,
      _extra.vertical + childSize.height,
    ));
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final child = this.child;
    if (child == null) return null;
    final result = child.getDryBaseline(_innerConstraints(constraints), baseline);
    return result == null ? null : result + _extra.top;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final child = this.child;
    final inset = _insetFor(constraints.maxWidth);
    if (child == null) {
      size = constraints.constrain(
        Size(inset * 2 + _extra.horizontal, _extra.vertical),
      );
      return;
    }
    child.layout(_innerConstraints(constraints), parentUsesSize: true);
    (child.parentData! as BoxParentData).offset =
        Offset(inset + _extra.left, _extra.top);
    size = constraints.constrain(Size(
      inset * 2 + _extra.horizontal + child.size.width,
      _extra.vertical + child.size.height,
    ));
  }
}

/// 자식을 가운데 정렬하고 폭만 [maxWidth] 로 묶는다.
///
/// [ContentColumn] 과 달리 좌우 여백을 남기지 않는다 — 하단 탭바처럼 배경까지
/// 같이 좁혀야 하는 부품에 쓴다.
class CenteredCap extends StatelessWidget {
  /// 폭 상한만 거는 중앙 정렬 상자를 만든다.
  const CenteredCap({
    super.key,
    required this.child,
    required this.maxWidth,
  });

  /// 가둘 내용.
  final Widget child;

  /// 폭 상한.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// 폭에 따라 열 수가 바뀌는 타일 목록.
///
/// 폰(335)에서는 1열이라 기존 세로 목록과 같고, 콘텐츠 600에서는 2열
/// 290+20+290 이 된다 — Figma 태블릿 `record_list`·`main_change_avatar` 의 실측
/// 값과 일치한다. 마지막 줄이 덜 차면 왼쪽부터 채운다(정본과 동일).
///
/// 항목 수가 적고 이미 스크롤 뷰 안에 있는 목록을 대상으로 한다. 수백 건을
/// 그리는 자리에는 `SliverGrid` 를 쓸 것 — 여기는 전량을 한 번에 만든다.
class AdaptiveTiles extends StatelessWidget {
  /// 타일 목록을 만든다.
  const AdaptiveTiles({
    super.key,
    required this.children,
    this.gap = AppLayout.gridGap,
    this.stackedGap,
    this.minTile = AppLayout.gridMinTile,
  });

  /// 타일들.
  final List<Widget> children;

  /// 여러 열일 때의 가로·세로 간격(정본 태블릿은 둘 다 20).
  final double gap;

  /// **1열일 때만** 쓰는 세로 간격. 생략하면 [gap] 과 같다.
  ///
  /// 폰의 세로 목록 간격이 태블릿 그리드 간격과 다른 화면이 있어서 갈라 뒀다
  /// (기록 목록: 폰 12, 태블릿 20). 폰 값을 바꾸지 않기 위한 인자다.
  final double? stackedGap;

  /// 타일 한 칸의 최소 폭. 열 수를 정한다.
  final double minTile;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : AppLayout.content;
        final columns = AppLayout.columnsFor(available, minTile: minTile);
        // 1열이면 Wrap 을 태우지 않는다 — 세로 목록 그대로가 더 싸고, 자식의
        // 높이 계산도 기존과 완전히 같아진다.
        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: stackedGap ?? gap),
                children[i],
              ],
            ],
          );
        }
        final tile = AppLayout.tileWidthFor(
          available,
          columns: columns,
          gap: gap,
        );
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: tile, child: child),
          ],
        );
      },
    );
  }
}
