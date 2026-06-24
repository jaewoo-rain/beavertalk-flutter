/// Corner-radius tokens from the BeaverTalk Figma design system.
///
/// Values are `const double` in logical pixels. [full] is an arbitrarily large
/// value used for pill / circular shapes (Figma `radius-full` = 9999).
abstract final class AppRadius {
  AppRadius._();

  static const double sm = 8; // radius-sm
  static const double md = 12; // radius-md
  static const double ml = 20; // radius-ml
  static const double lg = 16; // radius-lg
  static const double full = 9999; // radius-full (pill)
}
