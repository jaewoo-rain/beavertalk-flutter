import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';

/// ScanCursor — the glowing bar that sweeps across the sentence while the
/// recording is scored (`Scan/Cursor` `3627:9694` + `Scan/Halo` `3627:9693`).
///
/// Measured from `proto/2_scan_start`: a 2-wide bar, radius 1, in
/// `Primary/Normal` under an `0 0 8` glow at `rgba(0,255,178,0.6)`, riding a 64
/// halo — a horizontal `#00FFB2` gradient that is transparent at both edges and
/// 30% in the middle, blurred 6.
///
/// ## This is a flourish, not a progress bar
///
/// `scan_start` / `scan_mid` / `scan_end` are three keyframes of the same
/// component with only the cursor's x moved (49 → 150 → 257); the component's
/// own description says *"키프레임마다 x만 이동시키면 SMART_ANIMATE가 보간한다"*.
/// So the sweep is **time-based by design** and claims nothing about where
/// scoring has got to — which is just as well, because `submitAudio` is a single
/// blocking POST with no word boundaries and no streaming.
///
/// The frame's `WordScanProgress` pills (`3627:9695`) are the part that *does*
/// claim per-word progress (`done` / `active` / `pending`), and they are
/// deliberately **not** built here. Do not add them off a timer: a pill that
/// fills on a clock asserts "analysing the 3rd word now", which is false.
class ScanCursor extends StatefulWidget {
  /// Creates the sweeping scan cursor.
  const ScanCursor({super.key, this.height, this.period});

  /// Height of the bar. **Null means measure the parent** — the caller sizes the
  /// cursor by stretching it over the sentence block, so a 2-line sentence gets a
  /// 2-line cursor.
  ///
  /// The frame draws 84 over a 60-high sentence block, i.e. the cursor overhangs
  /// the text rather than being clipped to it. That overhang is the caller's job
  /// (`_kScanOverhang`); here a null height just fills whatever box it is given,
  /// keeping the frame's `halo = bar + 8` relation.
  final double? height;

  /// One left→right→left cycle. Defaults to 1.8s — **not from the design**,
  /// which is three static keyframes with no timing on them.
  final Duration? period;

  @override
  State<ScanCursor> createState() => _ScanCursorState();
}

class _ScanCursorState extends State<ScanCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: widget.period ?? const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double span = constraints.maxWidth;
        // frame: 92 halo over an 84 bar. With an explicit height that relation is
        // built up from the bar; with a null height the box IS the halo, so the
        // bar is derived back down from it.
        final double haloH = widget.height != null
            ? widget.height! + 8
            : constraints.maxHeight;
        final double barH = widget.height ?? (constraints.maxHeight - 8);
        return SizedBox(
          height: haloH,
          child: AnimatedBuilder(
            animation: _sweep,
            builder: (context, _) {
              // Ease so the bar slows at each end instead of snapping back —
              // `reverse: true` on a linear curve reads as a bounce.
              final double t = Curves.easeInOut.transform(_sweep.value);
              // Glow off the cursor's own colour, not a fixed #00FFB2. In Dark
              // `primaryNormal` *is* #00FFB2, so this is unchanged there; in
              // Light it becomes #007A55, matching the bar instead of leaving a
              // bright-mint halo around a dark-teal cursor on a pale background.
              final Color primary = context.c.primaryNormal;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: (span * t) - 32,
                    // Blur 6, as the frame's layer blur — the gradient already
                    // fades left/right, so this is what softens the band's flat
                    // top and bottom edges.
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        width: 64,
                        height: haloH,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primary.withValues(alpha: 0),
                              primary.withValues(alpha: 0.3),
                              primary.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (span * t) - 1,
                    child: Container(
                      width: 2,
                      height: barH,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
