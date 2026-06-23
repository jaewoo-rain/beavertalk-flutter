import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Dim — Figma `01_Atoms / Dim` (`176:26363`).
///
/// A full-screen scrim used behind modals, sheets and dialogs. Measured 1:1
/// from Figma:
/// - Fill: `rgba(34, 37, 49, 0.4)` → [AppColors.scrim].
/// - Backdrop: `blur(4)` ([ui.ImageFilter.blur]).
///
/// Intended to be laid over a [Stack] via [Positioned.fill]; [build] already
/// wraps itself in [Positioned.fill] so you can drop it directly as a Stack
/// child. Tapping the scrim invokes [onTap] (typically to dismiss). An optional
/// [child] is rendered on top of the scrim (e.g. a centered sheet/dialog).
class Dim extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Semantics(
        button: onTap != null,
        label: 'Dim overlay',
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: ColoredBox(
              color: AppColors.scrim,
              child: child ?? const SizedBox.expand(),
            ),
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
      color: AppColors.bg,
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
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Background content',
                    style: TextStyle(color: AppColors.textSecondary),
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
                  color: AppColors.surfaceElevatedNormal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Overlay dialog',
                  style: TextStyle(color: AppColors.text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
