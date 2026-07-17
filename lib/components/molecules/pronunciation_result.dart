import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Visual state of a [PronunciationResult].
///
/// Figma component set `2224:20999` (pronunciation_result), states
/// `active` / `inactive`.
enum PronunciationState {
  /// A real, scored result: progress arc + center percent in
  /// `Primary/Normal`.
  active,

  /// No score yet: track is dimmed ([context.c.primaryNormal24]), no progress
  /// arc, center shows `-%`.
  inactive,
}

/// A single labelled metric shown in the footer (e.g. Pronunciation 96%).
class PronunciationMetric {
  const PronunciationMetric({required this.label, required this.value});

  /// Caption label ([AppType.caption1]), e.g. "Pronunciation".
  final String label;

  /// Value text ([AppType.body1] SemiBold), e.g. "96%".
  final String value;
}

/// PronunciationResult — a semicircle score gauge with a metrics footer.
///
/// Figma component set `2224:20999` (pronunciation_result).
///
/// Measured from Figma:
/// - Outer column, `gap` 16, width 335.
/// - Gauge: a 180° semicircle, frame ≈ 255×127.5 (2:1 → half circle).
///   Track + rounded-cap progress arc drawn by [_GaugePainter]. Center
///   percent in [AppType.title1] Bold, `Primary/Normal`.
/// - `inactive`: track [context.c.primaryNormal24], no progress arc, center "-%"
///   tinted [context.c.primaryNormal24].
/// - Footer card: fill `Background/Normal/Alternative` (`Background/Normal/Alternative`),
///   `borderRadius` [AppRadius.sm] (12), vertical padding 12, horizontal 12.
///   Three equal columns (label caption1 `Label/Normal` + value
///   body1.sb white), separated by 1px `Line/Normal` dividers.
///
/// Presentation-only: pass [score] (0–100), [metrics], and [state].
class PronunciationResult extends StatelessWidget {
  const PronunciationResult({
    super.key,
    required this.score,
    required this.metrics,
    this.state = PronunciationState.active,
  });

  /// Overall score 0–100, shown in the gauge center and driving the arc.
  /// Ignored visually when [state] is [PronunciationState.inactive].
  final double score;

  /// Footer metrics (Figma shows three: Pronunciation / Fluency / Rhythm).
  final List<PronunciationMetric> metrics;

  /// Whether the result is scored ([PronunciationState.active]) or empty.
  final PronunciationState state;

  static const double _gaugeWidth = 255;
  static const double _gaugeHeight = 127.5;

  @override
  Widget build(BuildContext context) {
    final bool active = state == PronunciationState.active;
    final double clamped = score.clamp(0, 100).toDouble();

    return SizedBox(
      width: 335,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _gaugeWidth,
            height: _gaugeHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(_gaugeWidth, _gaugeHeight),
                  painter: _GaugePainter(
                    trackColor: context.c.primaryNormal24,
                    arcColor: context.c.primaryNormal,
                    progress: active ? clamped / 100 : 0,
                    active: active,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.65),
                  child: Text(
                    active ? '${clamped.round()}%' : '-%',
                    style: AppType.title1.b.copyWith(
                      color: active
                          ? context.c.primaryNormal
                          : context.c.primaryNormal24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _MetricsFooter(metrics: metrics),
        ],
      ),
    );
  }
}

/// Three-column metrics footer with vertical dividers.
class _MetricsFooter extends StatelessWidget {
  const _MetricsFooter({required this.metrics});

  final List<PronunciationMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < metrics.length; i++) {
      if (i > 0) {
        children.add(
          SizedBox(
            height: 36,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.c.lineNormal,
            ),
          ),
        );
      }
      final m = metrics[i];
      children.add(
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                m.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.caption1.r
                    .copyWith(color: context.c.labelNormal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                m.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.body1.sb,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s12),
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

/// Paints the semicircle gauge: a full 180° track plus a progress arc with
/// a rounded cap.
///
/// Geometry measured from Figma (`2224:20970`/`20939`): frame ≈ 255×127.5,
/// a true half circle. Center sits at the bottom-middle; the arc spans
/// 180° (π) from left (180°) to right (0°), swept clockwise.
class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.progress,
    required this.active,
    required this.trackColor,
    required this.arcColor,
  });

  /// `Primary/Normal-24` (the unfilled ring) and `Primary/Normal` (the filled
  /// arc), read from the theme by the caller — a painter has no context.
  final Color trackColor, arcColor;

  /// 0–1 fraction of the 180° arc to fill.
  final double progress;

  /// When false only the dimmed track is drawn (no progress arc).
  final bool active;

  static const double _stroke = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.width - _stroke) / 2;
    final Offset center = Offset(size.width / 2, size.height - _stroke / 2);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = math.pi; // left
    const double sweep = math.pi; // 180° to the right

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    canvas.drawArc(arcRect, startAngle, sweep, false, track);

    if (active && progress > 0) {
      final fg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round
        ..color = arcColor;
      canvas.drawArc(
        arcRect,
        startAngle,
        sweep * progress.clamp(0, 1),
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      old.active != active ||
      // The colours are theme-dependent now; without these the gauge would keep
      // the previous mode's ring until the score happened to change.
      old.trackColor != trackColor ||
      old.arcColor != arcColor;
}

/// Gallery demo exposing both [PronunciationResult] states.
class PronunciationResultDemo extends StatelessWidget {
  const PronunciationResultDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      PronunciationMetric(label: 'Pronunciation', value: '96%'),
      PronunciationMetric(label: 'Fluency', value: '91%'),
      PronunciationMetric(label: 'Rhythm', value: '91%'),
    ];
    const emptyMetrics = [
      PronunciationMetric(label: 'Pronunciation', value: '-%'),
      PronunciationMetric(label: 'Fluency', value: '-%'),
      PronunciationMetric(label: 'Rhythm', value: '-%'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          PronunciationResult(
            score: 98,
            metrics: metrics,
            state: PronunciationState.active,
          ),
          SizedBox(height: AppSpacing.s24),
          PronunciationResult(
            score: 0,
            metrics: emptyMetrics,
            state: PronunciationState.inactive,
          ),
        ],
      ),
    );
  }
}
