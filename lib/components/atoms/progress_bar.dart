import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// ProgressBar — Figma `01_Atoms / ProgressBar` (`175:12772`).
///
/// Layout (measured 1:1 from Figma):
/// - Column, `8px` gap between the header row and the track.
/// - Header row: `space-between`, vertically centered.
///   - Left: [label] text.
///   - Right: percentage text (e.g. `87%`).
///   - Both use `AppType.label1.sb` (MO/Label 1 SemiBold) in white.
/// - Track: `8px` tall, radius `AppRadius.md` (16).
///   - Empty track: transparent fill with a `1px` [AppColors.primary] outline.
///   - Fill: solid [AppColors.primary], width driven by [value].
///   - Knob: white circle the size of the track height (8×8), centered on the
///     trailing edge of the fill.
///
/// The fill and knob are laid out with [LayoutBuilder] + [Stack]/[Align] so the
/// fill width tracks the available constraints exactly.
class ProgressBar extends StatelessWidget {
  /// Creates a ProgressBar.
  const ProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.active = true,
  });

  /// Text shown at the start (left) of the header row.
  final String label;

  /// Progress in the range `0–100`. Values outside the range are clamped.
  final double value;

  /// When true the bar uses the primary (mint) palette; when false a muted grey
  /// palette (Figma shows only the top accent bar active, the rest grey).
  final bool active;

  /// Track height in logical pixels (also the knob diameter), per Figma.
  static const double _trackHeight = 8;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 100.0).toDouble();
    final percentText = '${clamped.round()}%';

    return Semantics(
      label: label,
      value: percentText,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: label (left) + percent (right).
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.label1.sb.copyWith(color: AppColors.text),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentText,
                style: AppType.label1.sb.copyWith(color: AppColors.text),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Track + fill (filled faint track; only the active bar is mint).
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final fillWidth = trackWidth * (clamped / 100.0);
              final fillColor =
                  active ? AppColors.primary : AppColors.lineStrong;
              final trackColor =
                  active ? AppColors.primary10 : AppColors.border;
              return SizedBox(
                height: _trackHeight,
                width: trackWidth,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: trackColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: fillWidth,
                        height: _trackHeight,
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Gallery demo: ProgressBar at 0 / 34 / 62 / 87 / 100 %.
class ProgressBarDemo extends StatelessWidget {
  /// Creates the demo.
  const ProgressBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const values = <double>[0, 34, 62, 87, 100];
    return ColoredBox(
      color: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final v in values) ...[
              ProgressBar(label: 'American', value: v),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}