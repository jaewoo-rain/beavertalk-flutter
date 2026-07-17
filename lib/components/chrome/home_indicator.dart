import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Visual variant of [HomeIndicator].
///
/// Maps 1:1 to the Figma `HomeIndicator` component set (`160:79588`):
/// `white-bg`, `black-bg`, `black-transparent`, `white-transparent`,
/// `sub-transparent`.
///
/// The `*-bg` variants paint an opaque background; the `*-transparent`
/// variants are background-less. The pill color follows the variant:
/// `white-*` → white pill, `black-*` → dark pill, `sub-transparent` →
/// secondary-text gray pill.
enum HomeIndicatorVariant {
  /// Opaque white background, dark pill.
  whiteBg,

  /// Opaque black background, white pill.
  blackBg,

  /// Transparent background, dark pill.
  blackTransparent,

  /// Transparent background, white pill.
  whiteTransparent,

  /// Transparent background, secondary-gray pill.
  subTransparent,
}

/// iOS-style home indicator chrome (375×34) measured 1:1 from Figma
/// `160:79588`.
///
/// Renders a centered 134×5 pill with a fully-rounded (pill) radius. The
/// frame itself carries a 24px bottom corner radius (`AppRadius.lg`),
/// matching the Figma node `borderRadius: 0 0 24 24`.
class HomeIndicator extends StatelessWidget {
  /// Creates a home indicator with the given [variant].
  const HomeIndicator({super.key, this.variant = HomeIndicatorVariant.blackBg});

  /// The visual style; controls background and pill color.
  final HomeIndicatorVariant variant;

  /// Logical frame width from Figma.
  static const double width = 375;

  /// Logical frame height from Figma.
  static const double height = 34;

  /// Pill width from Figma.
  static const double pillWidth = 134;

  /// Pill height from Figma.
  static const double pillHeight = 5;

  /// Background fill, or `null` for the transparent variants.
  Color? _background(BuildContext context) {
    switch (variant) {
      case HomeIndicatorVariant.whiteBg:
        return context.c.staticWhite;
      case HomeIndicatorVariant.blackBg:
        return context.c.commonDarkAndWhite;
      case HomeIndicatorVariant.blackTransparent:
      case HomeIndicatorVariant.whiteTransparent:
      case HomeIndicatorVariant.subTransparent:
        return null;
    }
  }

  /// Pill color derived from the variant.
  Color _pillColor(BuildContext context) {
    switch (variant) {
      case HomeIndicatorVariant.whiteBg:
      case HomeIndicatorVariant.blackTransparent:
        return context.c.commonDarkAndWhite; // dark pill
      case HomeIndicatorVariant.blackBg:
      case HomeIndicatorVariant.whiteTransparent:
        return context.c.staticWhite; // white pill
      case HomeIndicatorVariant.subTransparent:
        return context.c.labelNormal; // #9EA3B2
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _background(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppRadius.lg),
        bottomRight: Radius.circular(AppRadius.lg),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(
          color: bg ?? const Color(0x00000000),
          child: Center(
            child: Container(
              width: pillWidth,
              height: pillHeight,
              decoration: BoxDecoration(
                color: _pillColor(context),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing every [HomeIndicatorVariant].
class HomeIndicatorDemo extends StatelessWidget {
  /// Creates the demo.
  const HomeIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const items = <(String, HomeIndicatorVariant)>[
      ('white-bg', HomeIndicatorVariant.whiteBg),
      ('black-bg', HomeIndicatorVariant.blackBg),
      ('black-transparent', HomeIndicatorVariant.blackTransparent),
      ('white-transparent', HomeIndicatorVariant.whiteTransparent),
      ('sub-transparent', HomeIndicatorVariant.subTransparent),
    ];
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, variant) in items) ...[
              Text(label, style: TextStyle(color: context.c.labelNormal)),
              const SizedBox(height: 6),
              // Surface backdrop so transparent variants are visible.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.c.backgroundNormalNormal,
                  border: Border.all(color: context.c.lineNeutral),
                ),
                child: HomeIndicator(variant: variant),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
