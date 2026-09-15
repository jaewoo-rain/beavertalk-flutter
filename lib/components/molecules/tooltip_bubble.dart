import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 아래를 가리키는 꼬리 달린 말풍선 — Figma `tooltip/hint_locked`(`5986:9297`).
///
/// 규격은 **기존 Tooltip**(Workspace `5896:17635`, 「단어를 눌러 자세히 볼 수
/// 있어요」)을 그대로 따른다. 사장님 지시(2026-09-15): 색·수치는 기존 값만 쓴다.
///
/// | | 값 |
/// |---|---|
/// | 면·꼬리 | `Label/Strong` |
/// | 글자 | `Background/Normal/Normal` · `MO/Caption 2/Medium` |
/// | 패딩 | 세로 7(`Padding/V/7`) · 가로 12(`Padding/H/12`) |
/// | 모서리 | 10 |
///
/// 그림자·아이콘은 없다 — 기존 Tooltip 에 없다. 꼬리만 새로 그렸다.
///
/// 면이 `Label/Strong` 이라 Light 에서는 검은 말풍선, Dark 에서는 흰 말풍선으로
/// 저절로 뒤집힌다. 글자 `Background/Normal/Normal` 도 반대로 뒤집혀 대비가 유지된다.
///
/// ## 다국어 넘침 대응(2026-09-15)
///
/// 문구 길이가 언어마다 4배 넘게 다르다(zh 11자 ↔ fr 49자). 그래서:
///
/// 1. **폭 상한을 화면에서 역산한다** — [maxWidthFor]. 고정 335 는 320dp 폰에서
///    화면 오른쪽 밖으로 나간다.
/// 2. **줄바꿈 허용, 최대 [maxLines] 줄.** 넘치면 말줄임 — 최후 방어일 뿐, 30개
///    언어 문구는 320dp 에서 말줄임 없이 들어간다(`tooltip_bubble_i18n_test`).
/// 3. **폭은 가장 긴 줄에 맞춘다**(`TextWidthBasis.longestLine`). 줄바꿈된 말풍선이
///    상한까지 벌어져 오른쪽에 빈 띠가 생기지 않는다.
/// 4. **시스템 글자 배율은 막지 않는다.** 높이는 위로 자란다(호출부가 아래를 붙인다).
class TooltipBubble extends StatelessWidget {
  /// Creates a tooltip bubble whose tail points down.
  const TooltipBubble({
    super.key,
    required this.message,
    this.tailStart = 32,
    this.maxWidth = defaultMaxWidth,
  });

  /// 안내 문구. 폭을 넘으면 줄바꿈된다.
  final String message;

  /// 말풍선 시작 모서리 → 꼬리 시작 끝 거리. 방향성이다(RTL 은 오른쪽에서 잰다).
  ///
  /// 정본 32 는 「말풍선 x20 · 버튼 x32 · 버튼 지름 56」에서 꼬리 중심이 버튼
  /// 중심(60)에 오도록 잡은 값이다: 20 + 32 + [tailWidth]/2 = 60.
  final double tailStart;

  /// 폭 상한. 화면에 붙일 때는 [maxWidthFor] 로 구해 넘긴다.
  final double maxWidth;

  /// 폭 상한의 정본 — `size/content/width` 335.
  static const double defaultMaxWidth = 335;

  /// 줄 수 상한. 넘치면 말줄임한다.
  static const int maxLines = 3;

  /// 꼬리 폭.
  static const double tailWidth = 16;

  /// 꼬리 높이.
  static const double tailHeight = 8;

  /// 등장·퇴장 때 오르내리는 거리.
  static const double _travel = 4;

  /// 화면폭 [available] 에서 시작점 [start] 에 붙는 말풍선의 폭 상한.
  ///
  /// 끝쪽에도 시작쪽과 같은 여백([AppLayout.gutter])을 남기고 [defaultMaxWidth] 에서
  /// 멈춘다 — 폰 375 에서 335, 320 에서 280.
  static double maxWidthFor({
    required double available,
    required double start,
  }) =>
      math.max(
        0,
        math.min(defaultMaxWidth, available - start - AppLayout.gutter),
      );

  /// `AnimatedSwitcher.transitionBuilder` 용 등장·퇴장 모션.
  ///
  /// 페이드 + 아래에서 [_travel] 만큼 떠오름 + 꼬리 쪽 아래 모서리를 기준으로
  /// `AppMotion.pressScale`(0.96) → 1. 퇴장은 같은 길을 거꾸로 — 말풍선이 버튼
  /// 쪽으로 가라앉으며 사라진다. 길이·곡선은 호출부의 스위처가 정한다.
  static Widget transition(Widget child, Animation<double> animation) =>
      _BubbleTransition(animation: animation, child: child);

  @override
  Widget build(BuildContext context) {
    final fill = context.c.labelStrong;
    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                // 기존 Tooltip 실측 10. [AppRadius] 에 10 단계가 없어 값으로 둔다.
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                // 세로 7 은 `Padding/V/7` — [AppSpacing] 에 7 단계가 없다.
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: 7,
                ),
                child: Text(
                  message,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: AppType.caption2.m
                      .copyWith(color: context.c.backgroundNormalNormal),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: tailStart),
              child: CustomPaint(
                size: const Size(tailWidth, tailHeight),
                painter: _TailPainter(fill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleTransition extends StatelessWidget {
  const _BubbleTransition({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 꼬리가 시작 쪽에 있으니 확대 기준도 시작 쪽 아래 모서리다.
    final origin = Directionality.of(context) == TextDirection.rtl
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final t = animation.value;
          return Transform.translate(
            offset: Offset(0, (1 - t) * TooltipBubble._travel),
            child: Transform.scale(
              scale: lerpDouble(AppMotion.pressScale, 1, t)!,
              alignment: origin,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// 끝이 둥근 아래 방향 삼각형 — Figma `tail` 벡터와 같은 경로.
class _TailPainter extends CustomPainter {
  const _TailPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 위 변을 1 만큼 말풍선 안으로 올려 그린다 — 딱 맞추면 안티에일리어싱으로
    // 말풍선과 꼬리 사이에 가는 틈이 보인다.
    final path = Path()
      ..moveTo(0, -1)
      ..lineTo(size.width, -1)
      ..lineTo(9.5, 6.6)
      ..quadraticBezierTo(8, 8.1, 6.5, 6.6)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TailPainter oldDelegate) => oldDelegate.color != color;
}
