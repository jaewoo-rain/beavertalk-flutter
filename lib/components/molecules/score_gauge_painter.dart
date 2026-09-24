import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';

/// 반원 점수 게이지 — H4 「채움 + 구간 배경」(09-24 사장님 확정 · 원장 P32).
///
/// 발음 결과(`pronunciation_result` `2224:20999`, 255 폭)와 발음 학습 결과 E5 · E8
/// (`6040:36345` · `6044:36388`, 240 폭)이 크기만 달리 같이 쓴다.
/// - 캔버스 = 반원 한 개. 중심은 **아래 변 가운데**, 바깥 반지름 = 폭 / 2.
/// - 두께 [stroke](18) · 0–100 을 20점씩 다섯 조각 · 조각 **사이**에만 0.4% 틈(맨 끝 둘은 없음).
/// - 조각 배경 = 그 구간 색 18%(Figma 는 도형에 투명도를 건다) · 채움 = 0 부터 [progress] 까지
///   지나는 조각마다 그 조각의 구간 색 · 끝은 평평하다(butt, 엔드캡 없음).
class ScoreGaugePainter extends CustomPainter {
  /// Creates the painter.
  const ScoreGaugePainter({
    required this.bands,
    required this.progress,
    this.stroke = 18,
  });

  /// `Score/1`~`Score/5` — 테마에서 읽어 넘긴다(페인터는 context 가 없다).
  final List<Color> bands;

  /// 0–1, 반원 중 채울 몫.
  final double progress;

  /// 링 두께.
  final double stroke;

  /// 조각 사이 틈의 한쪽 몫 — 0–1 범위의 0.4%(반원 180° 의 0.72°).
  static const double _inset = 0.004;

  /// 배경 조각 투명도.
  static const double _trackAlpha = 0.18;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2 - stroke / 2;
    final Offset center = Offset(size.width / 2, size.height);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    Paint pen(Color color) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = color;

    void arc(double from, double to, Paint paint) {
      if (to <= from) return;
      canvas.drawArc(
          arcRect, math.pi + from * math.pi, (to - from) * math.pi, false, paint);
    }

    final p = progress.clamp(0.0, 1.0);
    for (var i = 0; i < 5; i++) {
      // 틈은 조각 **사이**에만 — 0점 쪽 시작과 100점 쪽 끝은 비우지 않는다(Figma Band1 은 0부터,
      // Band5 는 1.0 까지 · 09-24 figma-code-diff).
      final start = i == 0 ? 0.0 : i * 0.2 + _inset;
      final end = i == 4 ? 1.0 : (i + 1) * 0.2 - _inset;
      arc(start, end, pen(bands[i].withValues(alpha: _trackAlpha)));
      if (p > start) arc(start, math.min(p, end), pen(bands[i]));
    }
  }

  @override
  bool shouldRepaint(ScoreGaugePainter old) =>
      old.progress != progress ||
      old.stroke != stroke ||
      // 색은 테마(라이트/다크)를 따른다 — 안 보면 모드를 바꿔도 이전 색이 남는다.
      !listEquals(old.bands, bands);
}
