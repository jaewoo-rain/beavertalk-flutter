/// BeaverTalk spacing tokens (px). Extracted 1:1 from Figma `Design System`
/// > Spacing page (node `160:79407`).
///
/// Use for padding, gaps, and margins so layout values stay in sync with the
/// design source instead of being hardcoded per-screen. Names are the raw px
/// value (`s16` = 16px) to keep a 1:1, self-documenting mapping with Figma.
///
/// The full scale is wide because it is shared with the web/PC design; on mobile
/// the `s4`–`s48` range covers almost all real usage.
abstract final class AppSpacing {
  static const s2 = 2.0;
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s28 = 28.0;
  static const s32 = 32.0;
  static const s40 = 40.0;
  static const s48 = 48.0;
  static const s60 = 60.0;
  static const s70 = 70.0;
  static const s80 = 80.0;
  static const s100 = 100.0;
  static const s120 = 120.0;
  static const s140 = 140.0;
  static const s180 = 180.0;

  // ── Aliases (feat/eunjung naming): `spacingN` == `sN`, identical values.
  // Kept so the onboarding/auth screens (which use `AppSpacing.spacingN`)
  // compile after the merge; to be unified in the B-step Figma re-sync.
  static const spacing2 = s2;
  static const spacing4 = s4;
  static const spacing8 = s8;
  static const spacing12 = s12;
  static const spacing16 = s16;
  static const spacing20 = s20;
  static const spacing24 = s24;
  static const spacing28 = s28;
  static const spacing32 = s32;
  static const spacing40 = s40;
  static const spacing48 = s48;
  static const spacing60 = s60;
  static const spacing70 = s70;
  static const spacing80 = s80;
  static const spacing100 = s100;
  static const spacing120 = s120;
  static const spacing140 = s140;
  static const spacing180 = s180;
}
