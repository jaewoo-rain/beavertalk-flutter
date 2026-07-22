/// BeaverTalk UI glyph icons, rendered from the SVGs in `assets/icons/`.
///
/// These are the canonical monochrome glyphs exported 1:1 from the Figma
/// `02_Icon Component` set, replacing the earlier Material-icon approximations.
/// Each glyph is tinted via [SvgPicture]'s `colorFilter`, so the host **must**
/// pass a [color].
///
/// It used to default to white. That default was a `const`, which is exactly why
/// it had to go: a glyph cannot pick its own colour once there are two modes,
/// and "white" is not a decision the icon can make — only the surface it sits on
/// knows whether it wants `Label/Strong` (flips with the theme) or
/// `Static/White` (never does).
///
/// Usage mirrors Material icons:
/// ```dart
/// AppIcons.close(color: context.c.labelStrong)   // follows the theme
/// AppIcons.mic(size: 20, color: context.c.staticWhite) // always white
/// ```
///
/// Social brand marks (Kakao/Google/Apple) live in `brand_icons.dart`.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// Signature of an [AppIcons] glyph builder — pass e.g. `AppIcons.mic` where a
/// component needs to defer rendering (size/color decided at the use site).
typedef AppIconBuilder = Widget Function({double size, required Color color});

/// Canonical BeaverTalk glyph icons exported from Figma.
abstract final class AppIcons {
  static Widget _glyph(String name, double size, Color color) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  // ── Navigation / chrome ──────────────────────────────────────
  static Widget close({double size = 24, required Color color}) =>
      _glyph('close', size, color);
  static Widget chevronRight({double size = 24, required Color color}) =>
      _glyph('chevron-right', size, color);
  static Widget arrowRight({double size = 24, required Color color}) =>
      _glyph('arrow-right', size, color);
  /// Full shafted arrow `→` (Figma learning_next next control); distinct from
  /// the chevron-style [arrowRight].
  static Widget arrowForward({double size = 24, required Color color}) =>
      _glyph('arrow-forward', size, color);
  static Widget plus({double size = 24, required Color color}) =>
      _glyph('plus', size, color);
  static Widget search({double size = 24, required Color color}) =>
      _glyph('search', size, color);
  static Widget share({double size = 24, required Color color}) =>
      _glyph('share', size, color);

  // ── Status / feedback ────────────────────────────────────────
  static Widget check({double size = 24, required Color color}) =>
      _glyph('check', size, color);
  static Widget thumbsUp({double size = 24, required Color color}) =>
      _glyph('thumbs-up', size, color);
  static Widget thumbsDown({double size = 24, required Color color}) =>
      _glyph('thumbs-down', size, color);
  /// Double thumbs-up "쌍따봉" — the top satisfaction rating (Figma call_finish),
  /// distinct from the single [thumbsUp] used for the middle rating.
  static Widget thumbsUpDouble({double size = 24, required Color color}) =>
      _glyph('thumbs-up-double', size, color);
  static Widget flag({double size = 24, required Color color}) =>
      _glyph('flag', size, color);

  // ── Call / learning ──────────────────────────────────────────
  static Widget mic({double size = 24, required Color color}) =>
      _glyph('mic', size, color);
  static Widget callEnd({double size = 24, required Color color}) =>
      _glyph('call-end', size, color);
  static Widget volume({double size = 24, required Color color}) =>
      _glyph('volume', size, color);
  static Widget translate({double size = 24, required Color color}) =>
      _glyph('translate', size, color);
  static Widget redo({double size = 24, required Color color}) =>
      _glyph('redo', size, color);
  /// Lightbulb — the in-call hint toggle glyph (Figma `btn/hint`).
  static Widget lightbulb({double size = 24, required Color color}) =>
      _glyph('lightbulb', size, color);
  /// Closed-caption "CC" — the in-call subtitle toggle glyph (Figma `btn/subtitle`).
  static Widget cc({double size = 24, required Color color}) =>
      _glyph('cc', size, color);
  /// Two-way swap arrows (⇄) — the avatar "change" badge glyph.
  static Widget swap({double size = 24, required Color color}) =>
      _glyph('swap', size, color);

  // ── Content actions ──────────────────────────────────────────
  static Widget bookmarkLine({double size = 24, required Color color}) =>
      _glyph('bookmark-line', size, color);
  static Widget bookmarkFill({double size = 24, required Color color}) =>
      _glyph('bookmark-fill', size, color);
  static Widget trash({double size = 24, required Color color}) =>
      _glyph('trash', size, color);
  static Widget calendar({double size = 24, required Color color}) =>
      _glyph('calendar', size, color);

  // ── Alarm quick-start presets (`screen/etc_alarm__add`, 3665:12018) ──
  //
  // Unlike every other glyph here, these three are **not** in the
  // `02_Icon Component` library — they are drawn inline on the sheet
  // (`3665:12365` / `3665:12374` / `3665:12381`), so they were exported from
  // those nodes. Figma's export of a nested node drags the whole ancestor
  // chain in with it (an `#F5F5F5` backdrop and the artboard's rects), so each
  // file here holds only the glyph's own paths, lifted verbatim out of that
  // export — the vector data is Figma's, the wrapper is not.
  //
  // The exports carry a hardcoded `#00E8A2` stroke; `_glyph`'s `srcIn` filter
  // paints over it, so [color] still rules.
  static Widget sun({double size = 24, required Color color}) =>
      _glyph('sun', size, color);
  static Widget moon({double size = 24, required Color color}) =>
      _glyph('moon', size, color);
  static Widget sliders({double size = 24, required Color color}) =>
      _glyph('sliders', size, color);

  // ── Account / auth ───────────────────────────────────────────
  static Widget profile({double size = 24, required Color color}) =>
      _glyph('profile', size, color);
  static Widget user({double size = 24, required Color color}) =>
      _glyph('user', size, color);
  static Widget mail({double size = 24, required Color color}) =>
      _glyph('mail', size, color);
  static Widget lock({double size = 24, required Color color}) =>
      _glyph('lock', size, color);
  static Widget eye({double size = 24, required Color color}) =>
      _glyph('eye', size, color);

  // ── Password visibility (from feat/eunjung) ──────────────────
  /// Open eye outline — password is visible (tap to hide).
  static Widget eyeLine({double size = 24, required Color color}) =>
      _glyph('eye-line', size, color);

  /// Slashed eye — password is hidden (tap to reveal).
  static Widget eyeOff({double size = 24, required Color color}) =>
      _glyph('eye-off', size, color);
}
