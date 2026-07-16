import 'package:flutter/material.dart';

/// BeaverTalk color tokens — extracted 1:1 from Figma `beavertalk_design`.
/// Dark theme with a mint-green primary (#00FFB2).
abstract final class AppColors {
  // ── Semantic ────────────────────────────────────────────────
  static const primary = Color(0xFF00FFB2); // Semantics/Primary/Normal
  static const onPrimary = Color(0xFF111111); // text on primary
  static const primary10 = Color(0x1A00FFB2); // Primary/Primary-10 (≈10%)
  static const primary24 = Color(0x3D00FFB2); // ≈24%

  /// Semantics/Primary/Strong — a *different hue*, not an alpha of [primary].
  /// The alarm sheet's 빠른 시작 border and 요약 line, and the summary screen's
  /// selected preset icon (`3665:12460`).
  static const primaryStrong = Color(0xFF00E8A2);

  /// Primary/Primary-4 — the 4% wash behind a selected 빠른 시작 card
  /// (`3665:12362`). Far fainter than [primary10]; on #1F222A the two are
  /// distinguishable side by side, which the sheet does.
  static const primary04 = Color(0x0A00FFB2);

  // Alphas the learning-session summary asks for (`screen/learning_main`,
  // 3569:15065). Each is within a couple of percent of one above, but they sit
  // side by side on that screen — the delta pill against the bars, the bars
  // against the average line — so rounding them together would flatten the
  // depth the chart reads by.
  static const primary12 = Color(0x1F00FFB2); // delta pill fill
  static const primary22 = Color(0x3800FFB2); // past-session bars
  static const primary35 = Color(0x5900FFB2); // average line

  static const bg = Color(0xFF121217); // screen background
  static const surface = Color(0xFF181A20); // Background/Normal/Normal
  /// Semantics/Common/Black — a true black-ish, darker than [surface].
  /// `screen/call_loading` (`3360:19104`) fills the whole screen with it; the
  /// call flow starts by dimming everything else away.
  static const black = Color(0xFF111111);

  static const surface2 = Color(0xFF252932); // Background/Normal/Alternative
  static const surfaceElevated = Color(0xFF1F222A); // Elevated/Alternative
  static const surfaceElevatedNormal = Color(0xFF2F3340); // Elevated/Normal — dialogs

  static const border = Color(0x1FFFFFFF); // Line/Normal/Neutral (12%, Figma dark)
  static const borderSubtle = Color(0x0FFFFFFF); // Line/Normal/Alternative (6%)
  static const lineStrong = Color(0xFF70737C); // Line/Normal/Normal (strong)
  static const scrim = Color(0x80000000); // Dim overlay — black @ 50%

  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9EA3B2);
  static const textTertiary = Color(0xFF878A93); // Figma Atomic/Cool Neutral/60
  static const textDisabled = Color(0xFF5A5C63);
  static const labelAssistive = Color(0xFF676E81); // Label/Assistive

  // ── Analysis screen (Figma `screen/analysis__확정`, 3474:435) ──
  // That frame was drawn with raw hex rather than design-system styles, so these
  // four have no Figma token name — they are named by role. Each is close to but
  // not equal to an existing token, so none can be folded into one:
  // labelMeta≉textTertiary(#878A93), labelFootnote≉labelAssistive(#676E81).
  static const labelMeta = Color(0xFF777C89); // call date/duration line
  static const labelFootnote = Color(0xFF626877); // "통화 직후 Baba가 남김" etc.

  /// Status/Negative as the v2 design uses it. Deliberately **not** [error]
  /// (#FF6363): 38 files render `error`, so repointing it is a separate call.
  /// Until that is settled the two coexist; use this only on analysis surfaces.
  static const negativeAccent = Color(0xFFFF7070);
  static const negativeAccent16 = Color(0x29FF7070); // streak badge fill (16%)
  static const primary08 = Color(0x1400FFB2); // L1-interference box fill (8%)

  // ── Skeleton (loading) ──────────────────────────────────────
  // The `skeleton/*` frames across `design_app_v2 · Dark` fill every placeholder
  // with this white ramp. Deliberately not folded into [borderSubtle], which is
  // the identical value but a *Line* token — a stroke and a loading fill that
  // happen to match today should still be free to diverge.
  static const skeletonBase = Color(0x0FFFFFFF); // 6%
  static const skeletonHighlight = Color(0x24FFFFFF); // 14% — shimmer band

  static const hintAccent = Color(0xFFD17600); // Orange/39 — in-call hint accent (btn/hint on, "Hint" label)
  static const equalizerBar = Color(0xFF37383C); // cool-neutral/25 — speaking equalizer bars (자막off)

  static const accentLime = Color(0xFF429E00); // Accent/Foreground/Lime — toggle on
  static const accentRed = Color(0xFFE52222); // Figma Semantics/Accent/Foreground/Red — call-end
  static const green700 = Color(0xFF00B57E); // Foundation/Green/green-700 — mic/record
  static const green50 = Color(0xFFE6FFF7); // Foundation/Green/green-50 — mic inner
  static const success = Color(0xFF1ED45A); // Status/Positive
  static const error = Color(0xFFFF6363); // Figma Atomic/Red/60 (Status/Negative; matches success·warning /60)
  static const warning = Color(0xFFFFA938); // Status/Warning

  // ── Cool-neutral ramp (subset used across components) ────────
  static const cool50 = Color(0xFF70737C);
  static const cool40 = Color(0xFF5A5C63);
  static const cool30 = Color(0xFF46474C);
}