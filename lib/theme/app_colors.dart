import 'package:flutter/material.dart';

/// BeaverTalk color tokens — the **Dark** mode of Figma `beavertalk_design`'s
/// `Semantics` collection, verified 1:1 against the `Color - Semantic` chip page
/// (Dark `3702:39952` / Light `3702:39951`, 70 tokens each) on 2026-07-17.
///
/// **This palette is Dark-only, by construction.** Every entry is a `const`, so
/// nothing here can vary with the platform theme — and 102 files read these
/// statics 855 times. Figma now ships a **complete, confirmed Light mode** for
/// all 70 tokens, and none of it is reachable from here. Wiring it up is a
/// `ThemeExtension` migration, not an edit to this file; see
/// `docs/2026-07-17_0430_컬러토큰-대조.md`.
///
/// Where a token name is given below it is the **real** Figma variable and its
/// Light counterpart is one lookup away. Where a comment says a value has no
/// token, that is a claim about the design file — check it before trusting it,
/// because two such claims here turned out to be false.
abstract final class AppColors {
  // ── Semantic ────────────────────────────────────────────────
  static const primary = Color(0xFF00FFB2); // Primary/Normal (Light #007A55)
  static const onPrimary = Color(0xFF111111); // Primary/On-Primary (Light #FFF)
  static const primary10 = Color(0x1A00FFB2); // Primary/Normal-10
  static const primary24 = Color(0x3D00FFB2); // Primary/Normal-24

  /// Semantics/Primary/Strong — a *different hue*, not an alpha of [primary].
  /// The alarm sheet's 빠른 시작 border and 요약 line, and the summary screen's
  /// selected preset icon (`3665:12460`).
  static const primaryStrong = Color(0xFF00E8A2);

  /// Primary/Primary-4 — the 4% wash behind a selected 빠른 시작 card
  /// (`3665:12362`). Far fainter than [primary10]; on #1F222A the two are
  /// distinguishable side by side, which the sheet does.
  static const primary04 = Color(0x0A00FFB2);

  /// ⚠️ **Not tokens.** The `Semantics` collection ships exactly three primary
  /// alphas — `-4`, `-10`, `-24` — and these two are neither. They were read off
  /// paint opacities in `screen/learning_main` (3569:15065), and per the design
  /// team those opacities are **actively drifting**: binding a variable to a
  /// paint overwrites its opacity with the token's own alpha, so any manual
  /// opacity on an alpha-less token is temporary. Design is converting them to
  /// real alpha-carrying tokens (`Primary/Normal-14`, `-20`) one by one.
  /// Expect to repoint these; do not add more.
  static const primary22 = Color(0x3800FFB2); // past-session bars
  static const primary35 = Color(0x5900FFB2); // average line

  static const bg = Color(0xFF121217); // Background/Normal/Deep (Light #E1E2E4)
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

  /// Label/Strong — **`#000000` in Light.**
  ///
  /// ⚠️ This is the *theme text colour*, not "white". It is also the app's
  /// de-facto white for icons, toggle knobs and glyphs, which works only
  /// because there is no Light mode yet — the day there is, every such use
  /// turns black and disappears. Those call sites want `Static/White`
  /// (mode-invariant); splitting them is part of the Light migration.
  static const text = Color(0xFFFFFFFF);

  static const textSecondary = Color(0xFF9EA3B2); // Label/Normal (Light #333)
  static const textTertiary = Color(0xFF878A93); // Atomic/Cool Neutral/60
  static const labelAssistive = Color(0xFF676E81); // Label/Assistive (#808080)

  // ── Label ramp ──────────────────────────────────────────────
  // ⚠️ These two carried a comment claiming the analysis frame "was drawn with
  // raw hex" and that they "have no Figma token name". **Both claims were
  // false** — each is a first-class `Label/*` variable, verified against the
  // chip page. The role-based names are kept (call sites read better) but the
  // token is what they are, and in Light they must flip with it.
  static const labelMeta = Color(0xFF777C89); // Label/Neutral (Light #505050)
  static const labelFootnote = Color(0xFF626877); // Label/Alternative (#767676)

  /// Status/Negative as the v2 design uses it. Deliberately **not** [error]
  /// (#FF6363): 38 files render `error`, so repointing it is a separate call.
  /// Until that is settled the two coexist; use this only on analysis surfaces.
  static const negativeAccent = Color(0xFFFF7070);

  /// ⚠️ Not a token either — see [primary22]. `Primary/Normal-4`/`-10` bracket
  /// it. Used by the L1-interference box.
  static const primary08 = Color(0x1400FFB2);

  // ── Skeleton (loading) ──────────────────────────────────────
  // The `skeleton/*` frames across `design_app_v2 · Dark` fill every placeholder
  // with this white ramp. Deliberately not folded into [borderSubtle], which is
  // the identical value but a *Line* token — a stroke and a loading fill that
  // happen to match today should still be free to diverge.
  static const skeletonBase = Color(0x0FFFFFFF); // 6%
  static const skeletonHighlight = Color(0x24FFFFFF); // 14% — shimmer band

  static const hintAccent = Color(0xFFD17600); // Orange/39 — in-call hint accent (btn/hint on, "Hint" label)
  static const equalizerBar = Color(0xFF37383C); // cool-neutral/25 — speaking equalizer bars (자막off)

  /// ⚠️ **Conflicts with the token.** `Accent/Foreground/Lime` is `#58CF04` in
  /// Dark and `#429E00` in **Light** — this holds the Light value on a Dark-only
  /// app. Yet `screen/etc_alarm`'s toggle resolves the same variable to
  /// `#429E00` while sitting in a Dark frame, so the frame and the chip page
  /// disagree. Left as-is (it matches what the alarm frame renders) pending a
  /// design answer; do not "fix" it to #58CF04 without checking the toggle.
  static const accentLime = Color(0xFF429E00); // toggle on

  static const accentRed = Color(0xFFE52222); // Accent/**Background**/Red
  static const green700 = Color(0xFF00B57E); // Primary/Heavy (Light #006B4B)
  static const green50 = Color(0xFFE6FFF7); // no token — mic inner
  static const success = Color(0xFF1ED45A); // Status/Positive (Light #04B014)
  static const error = Color(0xFFFF6363); // Accent/Foreground/Red (Light #E52222)
  static const warning = Color(0xFFFFA938); // Status/Cautionary (Light #FFAA00)

  // ── Cool-neutral ramp (subset used across components) ────────
  static const cool50 = Color(0xFF70737C);
  static const cool40 = Color(0xFF5A5C63);
  static const cool30 = Color(0xFF46474C);
}