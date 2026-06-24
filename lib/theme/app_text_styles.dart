import 'package:flutter/painting.dart';

/// Design system typography tokens from the BeaverTalk Figma file.
///
/// Token names mirror the Figma styles (with the `MO/` prefix dropped),
/// converted to Dart camelCase — e.g. `MO/Body 1/Normal - Regular` →
/// `body1NormalRegular`.
///
/// - `fontSize` comes straight from the Figma token (px).
/// - `letterSpacing` is converted from the Figma percent value to logical
///   pixels (`fontSize × percent ÷ 100`), since Flutter expresses letter
///   spacing in pixels. E.g. Label 1's 1.45% at 14px → 0.20px.
/// - `height` is the line-height ratio (line height ÷ fontSize); Figma already
///   exports this as a unitless multiplier, so it maps directly to Flutter's
///   [TextStyle.height].
/// - `fontWeight` follows the Figma weight (note: "Bold" on Heading and smaller
///   styles is SemiBold / w600).
abstract final class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Pretendard';

  // ---------------------------------------------------------------------------
  // Display 1 — 56
  // ---------------------------------------------------------------------------
  static const TextStyle display1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.79,
    height: 1.286,
  );
  static const TextStyle display1Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.79,
    height: 1.286,
  );
  static const TextStyle display1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.79,
    height: 1.286,
  );

  // ---------------------------------------------------------------------------
  // Display 2 — 40
  // ---------------------------------------------------------------------------
  static const TextStyle display2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.13,
    height: 1.3,
  );
  static const TextStyle display2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.13,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // Display 3 — 36
  // ---------------------------------------------------------------------------
  static const TextStyle display3Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.97,
    height: 1.334,
  );
  static const TextStyle display3Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.97,
    height: 1.334,
  );
  static const TextStyle display3Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.97,
    height: 1.334,
  );

  // ---------------------------------------------------------------------------
  // Title 2 — 28
  // ---------------------------------------------------------------------------
  static const TextStyle title2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.66,
    height: 1.358,
  );

  // ---------------------------------------------------------------------------
  // Title 1 — 32
  // ---------------------------------------------------------------------------
  static const TextStyle title1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.81,
    height: 1.375,
  );
  static const TextStyle title1Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.81,
    height: 1.375,
  );

  // ---------------------------------------------------------------------------
  // Title 3 — 24
  // ---------------------------------------------------------------------------
  static const TextStyle title3Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.55,
    height: 1.334,
  );
  static const TextStyle title3Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.55,
    height: 1.334,
  );
  static const TextStyle title3Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.55,
    height: 1.334,
  );

  // ---------------------------------------------------------------------------
  // Heading 1 — 22
  // ---------------------------------------------------------------------------
  static const TextStyle heading1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.43,
    height: 1.364,
  );
  static const TextStyle heading1Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.43,
    height: 1.364,
  );
  static const TextStyle heading1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.43,
    height: 1.364,
  );

  // ---------------------------------------------------------------------------
  // Heading 2 — 20
  // ---------------------------------------------------------------------------
  static const TextStyle heading2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    height: 1.4,
  );
  static const TextStyle heading2Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.24,
    height: 1.4,
  );
  static const TextStyle heading2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Headline 1 — 18
  // ---------------------------------------------------------------------------
  static const TextStyle headline1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.004,
    height: 1.445,
  );
  static const TextStyle headline1Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.004,
    height: 1.445,
  );
  static const TextStyle headline1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.004,
    height: 1.445,
  );

  // ---------------------------------------------------------------------------
  // Headline 2 — 17
  // ---------------------------------------------------------------------------
  static const TextStyle headline2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.412,
  );
  static const TextStyle headline2Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.412,
  );
  static const TextStyle headline2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.412,
  );

  // ---------------------------------------------------------------------------
  // Body 1 — 16
  // ---------------------------------------------------------------------------
  static const TextStyle body1NormalRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.09,
    height: 1.5,
  );
  static const TextStyle body1NormalMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.09,
    height: 1.5,
  );
  static const TextStyle body1NormalBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.09,
    height: 1.5,
  );
  static const TextStyle body1ReadingRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.09,
    height: 1.625,
  );
  static const TextStyle body1ReadingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.09,
    height: 1.625,
  );
  static const TextStyle body1ReadingBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.09,
    height: 1.625,
  );

  // ---------------------------------------------------------------------------
  // Body 2 — 15
  // ---------------------------------------------------------------------------
  static const TextStyle body2NormalRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.14,
    height: 1.467,
  );
  static const TextStyle body2NormalMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.14,
    height: 1.467,
  );
  static const TextStyle body2NormalBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.14,
    height: 1.467,
  );
  static const TextStyle body2ReadingRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.14,
    height: 1.6,
  );
  static const TextStyle body2ReadingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.14,
    height: 1.6,
  );
  static const TextStyle body2ReadingBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.14,
    height: 1.6,
  );

  // ---------------------------------------------------------------------------
  // Label 1 — 14
  // ---------------------------------------------------------------------------
  static const TextStyle label1NormalBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.429,
  );
  static const TextStyle label1NormalMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.429,
  );
  static const TextStyle label1NormalRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.429,
  );
  static const TextStyle label1ReadingBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.5714,
  );
  static const TextStyle label1ReadingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.571,
  );
  static const TextStyle label1ReadingRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.571,
  );

  // ---------------------------------------------------------------------------
  // Label 2 — 13
  // ---------------------------------------------------------------------------
  static const TextStyle label2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.385,
  );
  static const TextStyle label2Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.385,
  );
  static const TextStyle label2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.385,
  );

  // ---------------------------------------------------------------------------
  // Caption 1 — 12
  // ---------------------------------------------------------------------------
  static const TextStyle caption1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.334,
  );
  static const TextStyle caption1Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.334,
  );
  static const TextStyle caption1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.334,
  );

  // ---------------------------------------------------------------------------
  // Caption 2 — 11
  // ---------------------------------------------------------------------------
  static const TextStyle caption2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.34,
    height: 1.273,
  );
  static const TextStyle caption2Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.34,
    height: 1.273,
  );
  static const TextStyle caption2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.34,
    height: 1.273,
  );
}
