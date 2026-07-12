import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Shared bottom-CTA container that gives every screen ONE consistent bottom
/// inset for its pinned control cluster (button, mic, playback row, …).
///
/// The bottom inset is derived once, here, instead of each screen re-deriving
/// it: [SafeArea] (`top: false`) honours the OS gesture-bar / home-indicator
/// inset on native, and its `minimum` bottom of [AppSpacing.s24] guarantees a
/// 24px floor on web/desktop (where `viewPadding.bottom == 0` and there is no
/// OS inset to honour). This is exactly what screens used to hand-roll as
/// `s24 + (viewPadding.bottom == 0 ? HomeIndicator.height : 0)` — but without
/// double-counting the now-removed fake home-indicator chrome.
///
/// The horizontal/top padding (`20 / 12 / 20 / 0`) matches the design's
/// standard CTA gutter; the bottom is left to [SafeArea] so it never
/// double-pads.
class BottomCtaBar extends StatelessWidget {
  /// Creates a bottom-CTA bar wrapping [child] with the consistent inset.
  const BottomCtaBar({super.key, required this.child});

  /// The control cluster to pin at the bottom (a [Button], mic, row, …).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s12,
          AppSpacing.s20,
          0,
        ),
        child: child,
      ),
    );
  }
}

/// Gallery demo showing the [BottomCtaBar] pinning a sample control.
class BottomCtaBarDemo extends StatelessWidget {
  /// Creates the demo.
  const BottomCtaBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomCtaBar(
      child: SizedBox(
        height: 48,
        child: Center(child: Text('Bottom CTA')),
      ),
    );
  }
}
