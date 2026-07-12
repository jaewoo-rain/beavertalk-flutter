import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The 5-bar "speaking" equalizer that replaces the caption when subtitles are
/// off — Figma `speaking` (`3233:17875`): 5 bars, width 3, gap 4, radius 2,
/// resting heights 9/15/20/14/8, fill `equalizerBar` (a muted grey).
///
/// The Figma bars are a static muted-grey affordance, not a live VU meter (the
/// call controller exposes no mic-amplitude stream). This renders a gentle
/// looping "breathing" animation around the resting heights so the indicator
/// reads as active without needing real audio levels.
class SpeakingEqualizer extends StatefulWidget {
  const SpeakingEqualizer({super.key, this.color = AppColors.equalizerBar});

  /// Bar color.
  final Color color;

  @override
  State<SpeakingEqualizer> createState() => _SpeakingEqualizerState();
}

class _SpeakingEqualizerState extends State<SpeakingEqualizer>
    with SingleTickerProviderStateMixin {
  static const List<double> _rest = [9, 15, 20, 14, 8];
  static const double _barW = 3;
  static const double _gap = 4;
  static const double _maxH = 20; // tallest resting bar → fixed region height

  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _maxH,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value * 2 * math.pi;
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < _rest.length; i++) ...[
                if (i != 0) const SizedBox(width: _gap),
                _bar(_rest[i], t + i * 0.9),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _bar(double rest, double phase) {
    // Oscillate between 45% and 100% of the resting height.
    final f = 0.45 + 0.55 * (0.5 + 0.5 * math.sin(phase));
    return Container(
      width: _barW,
      height: rest * f,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
