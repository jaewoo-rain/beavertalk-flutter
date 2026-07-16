import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Loading placeholders — Figma `skeleton/*` across ` ┗ ✮ design_app_v2 · Dark`.
///
/// Every placeholder in the design is the same shape: a rounded rectangle filled
/// with a left→right ramp of [AppColors.skeletonBase] → [AppColors.skeletonHighlight]
/// (at the midpoint) → base again. Only the box size changes, so this takes a
/// size and nothing else — callers never pick the colour or the radius.
///
/// Text lines are radius 4 and block slots radius 6 (`3569:27541` vs
/// `3569:27547`), which is why [Skeleton.bar] and [Skeleton.box] are not quite
/// interchangeable after all.
///
/// **The design draws that ramp static** because Figma cannot express animation;
/// a frozen shimmer is the convention for drawing one. Here the highlight band
/// sweeps left→right on a loop instead — see [SkeletonShimmer], which every
/// [Skeleton] must sit under.
class Skeleton extends StatelessWidget {
  /// A text-line placeholder (radius 4). [width] null stretches to the parent.
  const Skeleton.bar({super.key, this.width, required this.height})
      : _shape = BoxShape.rectangle,
        _radius = _barRadius;

  /// A block placeholder — glyph slots (24×24), button slots (70×36), CTAs.
  /// Radius 6, a step rounder than [Skeleton.bar], as the design draws them.
  const Skeleton.box({super.key, required double this.width, required this.height})
      : _shape = BoxShape.rectangle,
        _radius = _boxRadius;

  /// An avatar placeholder.
  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        _shape = BoxShape.circle,
        _radius = _barRadius;

  /// Placeholder width; null means "fill the parent".
  final double? width;

  /// Placeholder height.
  final double height;

  final BoxShape _shape;
  final double _radius;

  /// Figma radii on `skeleton/*` rectangles. Both sit below `AppRadius.xs` (8),
  /// so neither has a token — and neither is a caller's choice, so they stay
  /// private: which one you get follows from the constructor you pick.
  static const double _barRadius = 4, _boxRadius = 6;

  @override
  Widget build(BuildContext context) {
    final t = SkeletonShimmer.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _SkeletonPainter(
            progress: t,
            shape: _shape,
            radius: _radius,
          ),
        ),
      ),
    );
  }
}

/// Paints the ramp, offset by [progress] so the highlight band travels.
class _SkeletonPainter extends CustomPainter {
  const _SkeletonPainter({
    required this.progress,
    required this.shape,
    required this.radius,
  });

  /// 0→1 sweep position, shared by every placeholder on the screen.
  final double progress;
  final BoxShape shape;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Travel a full band-width beyond each edge so the highlight enters and
    // leaves rather than popping in at the border.
    final dx = (progress * 2 - 0.5) * size.width;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [
          AppColors.skeletonBase,
          AppColors.skeletonHighlight,
          AppColors.skeletonBase,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: _SlideGradient(dx),
      ).createShader(rect);

    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, size.shortestSide / 2, paint);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SkeletonPainter old) =>
      old.progress != progress || old.shape != shape || old.radius != radius;
}

/// Slides a gradient horizontally by [dx] logical pixels.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

/// Drives the shimmer for every [Skeleton] beneath it.
///
/// One controller per screen, not per placeholder: `learning_main_loading`
/// (`3583:34469`) alone holds 40+ bars, and a ticker each would be 40 tickers
/// animating the same value. Descendants read the phase via [of], which
/// subscribes them to it.
class SkeletonShimmer extends StatefulWidget {
  /// Wraps [child] so any [Skeleton] under it shimmers.
  const SkeletonShimmer({
    super.key,
    required this.child,
    this.period = const Duration(milliseconds: 1400),
  });

  /// The subtree containing the placeholders.
  final Widget child;

  /// One full left→right sweep.
  final Duration period;

  /// The current 0→1 sweep phase.
  ///
  /// Returns 0 (a flat base fill, no shimmer) when there is no [SkeletonShimmer]
  /// above — a placeholder that forgot its scope should render quietly rather
  /// than throw in a loading state, which is exactly when the app can least
  /// afford a red screen.
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_ShimmerPhase>()
          ?.progress ??
      0;

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void didUpdateWidget(SkeletonShimmer old) {
    super.didUpdateWidget(old);
    if (widget.period != old.period) _controller.duration = widget.period;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        // The subtree never changes with the phase — only the painters do — so
        // it is built once and passed through.
        child: widget.child,
        builder: (context, child) => _ShimmerPhase(
          progress: _controller.value,
          child: child!,
        ),
      );
}

class _ShimmerPhase extends InheritedWidget {
  const _ShimmerPhase({required this.progress, required super.child});

  final double progress;

  @override
  bool updateShouldNotify(_ShimmerPhase old) => old.progress != progress;
}
