import 'package:flutter/widgets.dart';
import 'app_colors.dart';

/// BeaverTalk typography — Pretendard, the MO/* scale from Figma.
///
/// Each style is a base (size + height + letter-spacing); use `.r/.m/.sb/.b`
/// for Regular(400)/Medium(500)/SemiBold(600)/Bold(700) weights. Color defaults
/// to white; override with `.copyWith(color: ...)` at the call site.
///
/// NOTE: the Pretendard font is referenced by family name only. Bundle the
/// Pretendard ttf via pubspec `fonts:` (assets/fonts/) for exact rendering;
/// until then Flutter falls back to the platform default (no build error).
const String kFontFamily = 'Pretendard';

class AppType {
  const AppType._(this.size, this.height, this.spacing);
  final double size;
  final double height; // line-height in px
  final double spacing; // letter-spacing in px

  TextStyle _w(FontWeight w) => TextStyle(
        fontFamily: kFontFamily,
        fontSize: size,
        height: height / size,
        letterSpacing: spacing,
        fontWeight: w,
        color: AppColors.text,
      );

  TextStyle get r => _w(FontWeight.w400);
  TextStyle get m => _w(FontWeight.w500);
  TextStyle get sb => _w(FontWeight.w600);
  TextStyle get b => _w(FontWeight.w700);

  // ── MO/* scale (size / line-height(px) / letter-spacing(px)) ──
  static const display1 = AppType._(56, 72, -1.79);
  static const title1 = AppType._(32, 44, -0.81);
  static const title2 = AppType._(28, 38, -0.66);
  static const title3 = AppType._(24, 32, -0.55);
  static const heading1 = AppType._(22, 30, -0.43);
  static const heading2 = AppType._(20, 28, -0.24);
  static const headline1 = AppType._(18, 26, 0);
  static const headline2 = AppType._(17, 24, 0);
  static const body1 = AppType._(16, 24, 0.09);
  static const body2 = AppType._(15, 22, 0.14);
  static const label1 = AppType._(14, 20, 0.20);
  static const label2 = AppType._(13, 18, 0.25);
  static const caption1 = AppType._(12, 16, 0.30);
  static const caption2 = AppType._(11, 14, 0.34);
}