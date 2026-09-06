import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// 숙제 진행 링 — Figma `숙제/ProgressRing`(`5669:5211`) 실측.
///
/// 116×116 박스 안의 지름 96 링(두께 12, `innerRadius 0.75`). 12시에서 시작해
/// 시계 방향으로 찬다. 가운데는 「N /M」 — 분자만 16 Bold, 나머지는 12 Regular.
///
/// **진행바이지 품질 지표가 아니다**(스펙 §7). 정확도·점수를 여기에 그리지 마라.
class HomeworkProgressRing extends StatelessWidget {
  /// 링을 만든다.
  const HomeworkProgressRing({
    super.key,
    required this.completed,
    required this.total,
    this.size = 116,
  });

  /// 끝낸 활동 수.
  final int completed;

  /// 전체 활동 수. 0 이면 링이 비어 있다(0 나누기를 하지 않는다).
  final int total;

  /// 바깥 박스 한 변. 기본 116.
  final double size;

  /// 링 지름 대 박스 비 — 96 / 116.
  static const double _ringRatio = 96 / 116;

  /// 링 두께 대 링 지름 비 — `innerRadius 0.75` 에서 나온다.
  static const double _strokeRatio = (1 - 0.75) / 2;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final double ring = size * _ringRatio;
    final double stroke = ring * _strokeRatio;
    final double fraction = total <= 0
        ? 0
        : (completed / total).clamp(0.0, 1.0).toDouble();
    final bool full = total > 0 && completed >= total;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: ring,
            height: ring,
            child: CustomPaint(
              painter: _RingPainter(
                fraction: fraction,
                stroke: stroke,
                track: c.fillNormal,
                progress: c.primaryNormal,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$completed ',
                  style: AppType.body1.b.copyWith(
                    color: full ? c.primaryForeground : c.labelStrong,
                  ),
                ),
                TextSpan(
                  text: '/$total',
                  style: AppType.caption1.r.copyWith(
                    color: full ? c.primaryForeground : c.labelStrong,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 트랙 원 + 진행 호. 둘 다 같은 두께의 선으로 그린다.
class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.stroke,
    required this.track,
    required this.progress,
  });

  final double fraction;
  final double stroke;
  final Color track;
  final Color progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);

    if (fraction <= 0) return;
    // Figma 는 12시(-π/2)에서 시작해 시계 방향으로 돈다. 캡은 각지게 둔다 —
    // 마스터가 둥근 캡을 쓰지 않는다.
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = progress;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * fraction, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction ||
      old.stroke != stroke ||
      old.track != track ||
      old.progress != progress;
}
