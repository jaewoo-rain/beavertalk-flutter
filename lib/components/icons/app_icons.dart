/// BeaverTalk UI glyph icons, rendered from the SVGs in `assets/icons/`.
///
/// These are the canonical monochrome glyphs exported 1:1 from the Figma
/// `02_Icon Component` set, replacing the earlier Material-icon approximations.
/// Each glyph is tinted via [SvgPicture]'s `colorFilter`, so pass a [color] to
/// match the host (defaults to [AppColors.text], i.e. white on the dark theme).
///
/// Usage mirrors Material icons:
/// ```dart
/// AppIcons.close()                       // 24px, white
/// AppIcons.mic(size: 20, color: AppColors.primary)
/// ```
///
/// Social brand marks (Kakao/Google/Apple) live in `brand_icons.dart`.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';

/// Signature of an [AppIcons] glyph builder — pass e.g. `AppIcons.mic` where a
/// component needs to defer rendering (size/color decided at the use site).
typedef AppIconBuilder = Widget Function({double size, Color color});

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
  static Widget close({double size = 24, Color color = AppColors.text}) =>
      _glyph('close', size, color);
  static Widget chevronRight({double size = 24, Color color = AppColors.text}) =>
      _glyph('chevron-right', size, color);
  static Widget arrowRight({double size = 24, Color color = AppColors.text}) =>
      _glyph('arrow-right', size, color);
  /// Full shafted arrow `→` (Figma learning_next next control); distinct from
  /// the chevron-style [arrowRight].
  static Widget arrowForward({double size = 24, Color color = AppColors.text}) =>
      _glyph('arrow-forward', size, color);
  static Widget plus({double size = 24, Color color = AppColors.text}) =>
      _glyph('plus', size, color);
  static Widget search({double size = 24, Color color = AppColors.text}) =>
      _glyph('search', size, color);
  static Widget share({double size = 24, Color color = AppColors.text}) =>
      _glyph('share', size, color);

  // ── Status / feedback ────────────────────────────────────────
  static Widget check({double size = 24, Color color = AppColors.text}) =>
      _glyph('check', size, color);
  static Widget thumbsUp({double size = 24, Color color = AppColors.text}) =>
      _glyph('thumbs-up', size, color);
  static Widget thumbsDown({double size = 24, Color color = AppColors.text}) =>
      _glyph('thumbs-down', size, color);
  static Widget flag({double size = 24, Color color = AppColors.text}) =>
      _glyph('flag', size, color);

  // ── Call / learning ──────────────────────────────────────────
  static Widget mic({double size = 24, Color color = AppColors.text}) =>
      _glyph('mic', size, color);
  static Widget callEnd({double size = 24, Color color = AppColors.text}) =>
      _glyph('call-end', size, color);
  static Widget volume({double size = 24, Color color = AppColors.text}) =>
      _glyph('volume', size, color);
  static Widget translate({double size = 24, Color color = AppColors.text}) =>
      _glyph('translate', size, color);
  static Widget redo({double size = 24, Color color = AppColors.text}) =>
      _glyph('redo', size, color);
  /// Two-way swap arrows (⇄) — the avatar "change" badge glyph.
  static Widget swap({double size = 24, Color color = AppColors.text}) =>
      _glyph('swap', size, color);

  // ── Content actions ──────────────────────────────────────────
  static Widget bookmarkLine({double size = 24, Color color = AppColors.text}) =>
      _glyph('bookmark-line', size, color);
  static Widget bookmarkFill({double size = 24, Color color = AppColors.text}) =>
      _glyph('bookmark-fill', size, color);
  static Widget trash({double size = 24, Color color = AppColors.text}) =>
      _glyph('trash', size, color);
  static Widget calendar({double size = 24, Color color = AppColors.text}) =>
      _glyph('calendar', size, color);

  // ── Account / auth ───────────────────────────────────────────
  static Widget profile({double size = 24, Color color = AppColors.text}) =>
      _glyph('profile', size, color);
  static Widget user({double size = 24, Color color = AppColors.text}) =>
      _glyph('user', size, color);
  static Widget mail({double size = 24, Color color = AppColors.text}) =>
      _glyph('mail', size, color);
  static Widget lock({double size = 24, Color color = AppColors.text}) =>
      _glyph('lock', size, color);
  static Widget eye({double size = 24, Color color = AppColors.text}) =>
      _glyph('eye', size, color);
}
