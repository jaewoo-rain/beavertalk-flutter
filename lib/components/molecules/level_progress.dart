import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// LevelProgress — the 종합 레벨 band on my page (Figma `Group 231`, inside
/// `Dialog-ShareProfile` `4085:30453`).
///
/// Measured 1:1 from Figma (295pt-wide reference):
/// - Overall height 52: marker band 12, track 16, gap 4, label row 20.
/// - Track: full-bleed, radius 4, a three-stop linear gradient at
///   `0.15 / 0.50 / 0.85` using `Gradient/Level/{Start,Mid,End}`.
/// - Marker: an 8×8 triangle in `Primary/Heavy` pointing down, its tip resting
///   4pt inside the top of the track (Figma places it at y=8 with the track
///   starting at y=12).
/// - Labels: [startLabel] / [endLabel], `label1` Regular in `Label/Neutral`,
///   pinned to the two ends.
///
/// Presentation-only. [level] is 1-based; pass null for "not measured yet",
/// which drops the marker and leaves the bare gradient scale.
class LevelProgress extends StatelessWidget {
  /// Creates a level progress band.
  const LevelProgress({
    super.key,
    required this.level,
    required this.startLabel,
    required this.endLabel,
    this.maxLevel = 13,
  });

  /// Current stage, 1..[maxLevel]. Null hides the marker.
  final int? level;

  /// Top of the scale — 13 stages for Korean (server `korean_level`).
  final int maxLevel;

  /// Caption under the left end of the track, e.g. "1단계".
  final String startLabel;

  /// Caption under the right end of the track, e.g. "13단계".
  final String endLabel;

  static const double _markerBand = 12;
  static const double _trackHeight = 16;
  static const double _gap = 4;
  static const double _labelHeight = 20;
  static const double _markerSize = 8;

  @override
  Widget build(BuildContext context) {
    // Fraction of the track the marker sits at. `level / maxLevel` — the share
    // of the ramp completed — rather than the mock's hand-placed x, which
    // corresponds to no formula.
    final double? fraction = level == null
        ? null
        : (level!.clamp(1, maxLevel) / maxLevel).toDouble();

    return SizedBox(
      height: _markerBand + _trackHeight + _gap + _labelHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            children: [
              // Marker — clamped so it never hangs off either end.
              if (fraction != null)
                Positioned(
                  top: _markerBand - _markerSize,
                  left: (width * fraction - _markerSize / 2)
                      .clamp(0.0, width - _markerSize),
                  child: CustomPaint(
                    size: const Size(_markerSize, _markerSize),
                    painter: _MarkerPainter(color: context.c.primaryHeavy),
                  ),
                ),
              Positioned(
                top: _markerBand,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: _trackHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [
                            context.c.gradientLevelStart,
                            context.c.gradientLevelMid,
                            context.c.gradientLevelEnd,
                          ],
                          stops: const [0.15, 0.5, 0.85],
                        ),
                      ),
                    ),
                    const SizedBox(height: _gap),
                    // Both ends are flexible: "Stage 1"/"Stage 13" is short in
                    // English but runs long in ru/mn/tr, where the pair
                    // overflows a 240pt card interior at 320dp.
                    SizedBox(
                      height: _labelHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              startLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.label1.r
                                  .copyWith(color: context.c.labelNeutral),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              endLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppType.label1.r
                                  .copyWith(color: context.c.labelNeutral),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Downward-pointing filled triangle (the level marker).
class _MarkerPainter extends CustomPainter {
  const _MarkerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MarkerPainter oldDelegate) => oldDelegate.color != color;
}

/// Gallery demo: the level band at stages 1 / 7 / 13 and unmeasured.
class LevelProgressDemo extends StatelessWidget {
  /// Creates the demo.
  const LevelProgressDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const levels = <int?>[1, 7, 13, null];
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final l in levels) ...[
              LevelProgress(level: l, startLabel: '1단계', endLabel: '13단계'),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
