import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_color_tokens.dart';

/// MicAnalysis — the 96×96 spinner that stands where [MicButton] was while the
/// recording is being scored (`Mic/Spinner` `3627:9701` in `proto/2_scan_start`).
///
/// Three pieces, all `Primary/Normal`, exported from the frame:
/// - `orbit/track` — a full ring (r 46.5, stroke 3) at the SVG's own 20% alpha,
/// - `orbit/arc` — a 90° arc in the box's top-right quadrant, which is what
///   turns,
/// - `art` — a static 48×48 sparkle, centred.
///
/// Only the arc rotates: the sparkle is the subject and would read as broken if
/// it spun, so the rotation wraps a 96 box holding just the arc and leaves the
/// other two still.
///
/// **Not a button.** The frame's Analyzing state is explicitly un-pressable —
/// there is nothing to cancel, since `submitAudio` is a single blocking POST.
///
/// ## The assets are hand-corrected — keep them that way
///
/// Figma exports these with `fill="var(--fill-0, #00FFB2)"`. **flutter_svg does
/// not understand CSS custom properties**, so it resolves the paint to nothing
/// and draws an empty box — the spinner simply vanishes, silently, with no error
/// and nothing the analyzer or a widget test would catch (it only showed on a
/// device). Every other icon in `assets/icons/` uses a plain hex, which is why
/// this had never come up. The three SVGs here keep the export's exact path data
/// but with `var(...)` replaced by its own fallback hex and a fixed width/height
/// instead of `100%`. **Re-exporting from Figma will reintroduce the bug.**
///
/// The turn duration is **not in the design** (the frame is one static
/// keyframe); 1.2s is this app's spinner cadence.
class MicAnalysis extends StatefulWidget {
  /// Creates the analysing spinner.
  const MicAnalysis({super.key, this.size = 96});

  /// Edge of the square box. The frame draws it at 96, the same anchor the mic
  /// occupies, so the two states do not shift the layout.
  final double size;

  @override
  State<MicAnalysis> createState() => _MicAnalysisState();
}

class _MicAnalysisState extends State<MicAnalysis>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = ColorFilter.mode(context.c.primaryNormal, BlendMode.srcIn);
    // srcIn recolours but keeps each SVG's own alpha, so the track stays at the
    // 20% its stroke declares instead of coming back solid.
    final double s = widget.size;
    // The frame's pieces are sized against a 96 box; scale with [size] so the
    // widget stays honest at any edge.
    final double k = s / 96;

    // No semantics of its own: the `AnalyzingCaption` beside it is the real
    // announcement, and a decorative spinner that also spoke would say it twice.
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/icons/orbit-track.svg',
            width: s,
            height: s,
            colorFilter: tint,
          ),
          RotationTransition(
            turns: _spin,
            child: SizedBox(
              width: s,
              height: s,
              child: Stack(
                children: [
                  // Top-right quadrant — where the frame parks the arc. It is
                  // the offset from centre that makes the rotation read as an
                  // orbit rather than a spin in place.
                  Positioned(
                    left: 48 * k,
                    top: 0,
                    width: 48 * k,
                    height: 48 * k,
                    child: SvgPicture.asset(
                      'assets/icons/orbit-arc.svg',
                      colorFilter: tint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/icons/ai-sparkle.svg',
              width: 48 * k,
              height: 48 * k,
              colorFilter: tint,
            ),
          ),
        ],
      ),
    );
  }
}
