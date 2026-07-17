import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';

/// Dim — Figma `01_Atoms / Dim` (`176:26363`).
///
/// A full-screen scrim used behind modals, sheets and dialogs.
/// - Fill: black @ 50% → [context.c.materialDim].
/// - Backdrop: `blur(4)` ([ui.ImageFilter.blur]).
///
/// Intended to be laid over a [Stack] via [Positioned.fill]; [build] already
/// wraps itself in [Positioned.fill] so you can drop it directly as a Stack
/// child. Tapping the scrim invokes [onTap] (typically to dismiss). An optional
/// [child] is rendered on top of the scrim (e.g. a centered sheet/dialog).
///
/// The scrim fades its tint and blur in on mount ([AppMotion.medium]) rather
/// than snapping. Since every sheet and dialog in the app sits on a Dim, an
/// instant 40% tint + `blur(4)` was the harshest transition in the product.
/// The blur sigma is animated alongside the opacity — fading a fully-applied
/// blur still reads as a hard cut on the background.
class Dim extends StatefulWidget {
  /// Creates a Dim scrim.
  const Dim({
    super.key,
    this.onTap,
    this.child,
  });

  /// Called when the scrim is tapped — usually dismisses the overlay.
  final VoidCallback? onTap;

  /// Optional content rendered above the scrim.
  final Widget? child;

  @override
  State<Dim> createState() => _DimState();
}

class _DimState extends State<Dim> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
  );
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: AppMotion.toggle);

  static const double _blurSigma = 4;

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Semantics(
        button: widget.onTap != null,
        label: 'Dim overlay',
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _t,
            // The child (sheet/dialog) is passed through so it isn't rebuilt on
            // every animation frame — only the scrim itself re-renders.
            child: widget.child ?? const SizedBox.expand(),
            builder: (context, child) {
              final v = _t.value;
              return BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: _blurSigma * v,
                  sigmaY: _blurSigma * v,
                ),
                child: ColoredBox(
                  color: context.c.materialDim.withValues(
                    alpha: context.c.materialDim.a * v,
                  ),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Gallery demo: a Dim scrim laid over a faux sheet, with a small dialog on top.
class DimDemo extends StatelessWidget {
  /// Creates the demo.
  const DimDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Stack(
        children: [
          // Faux background content (a sheet) that the Dim sits over.
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: context.c.backgroundNormalNormal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Background content',
                    style: TextStyle(color: context.c.labelNormal),
                  ),
                ),
              ),
            ),
          ),
          // Dim overlay + a centered dialog as its child.
          Dim(
            onTap: () {},
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.c.backgroundElevatedNormal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Overlay dialog',
                  style: TextStyle(color: context.c.labelStrong),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
