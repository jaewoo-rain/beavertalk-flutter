import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// An image that **blurs in** as it loads: a frosted placeholder shows
/// immediately, then the decoded image fades over it. Use for network images
/// (character avatars, remote art) so a slow load shows a soft blurred
/// placeholder instead of a blank box or a hard pop-in.
///
/// Fills its parent — wrap in a `SizedBox` (and `ClipOval`/`ClipRRect` for
/// shape). Already-cached images (`wasSynchronouslyLoaded`) skip the animation.
class BlurUpImage extends StatelessWidget {
  /// Creates a blur-up image.
  const BlurUpImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.fadeDuration = const Duration(milliseconds: 350),
  });

  /// The image to decode and display (typically a `NetworkImage`).
  final ImageProvider image;

  /// How the decoded image is inscribed into its box.
  final BoxFit fit;

  /// Base color of the frosted placeholder; defaults to [AppColors.surface2].
  final Color? placeholderColor;

  /// Fade-in duration once the first frame decodes.
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    final base = placeholderColor ?? AppColors.surface2;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Frosted placeholder: a blurred neutral gradient, shown until the image
        // decodes (and left underneath so transparent PNGs read cleanly).
        ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [base, AppColors.surfaceElevated],
              ),
            ),
          ),
        ),
        Image(
          image: image,
          fit: fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: fadeDuration,
              curve: Curves.easeOut,
              child: child,
            );
          },
          // On error keep the frosted placeholder rather than a broken glyph.
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
