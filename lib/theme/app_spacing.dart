/// Design system spacing tokens from the BeaverTalk Figma file.
///
/// Token names follow the Figma spacing scale (px values), converted to Dart
/// camelCase. All values are `const double` in logical pixels.
///
/// Note: the Figma `60px` token is rendered as a 56px swatch in the source
/// file; the labelled token value (60) is used here.
abstract final class AppSpacing {
  AppSpacing._();

  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing28 = 28;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing60 = 60;
  static const double spacing70 = 70;
  static const double spacing80 = 80;
  static const double spacing100 = 100;
  static const double spacing120 = 120;
  static const double spacing140 = 140;
  static const double spacing180 = 180;
}
