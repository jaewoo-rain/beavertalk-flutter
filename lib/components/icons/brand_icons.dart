/// Brand and glyph icons rendered from the SVG assets in `assets/icons/`.
///
/// These wrap [SvgPicture.asset] and are the canonical way to show the social
/// sign-in marks (Kakao / Google / Facebook / Apple), the mail glyph, and the
/// BeaverTalk wordmark across the app — replacing the earlier Material-icon
/// approximations.
///
/// Two flavours exist:
/// - **Multi-colour brand marks** ([KakaoIcon], [GoogleIcon], [FacebookIcon])
///   keep their fixed brand palette and ignore any tint.
/// - **Monochrome glyphs** ([AppleIcon], [MailIcon], [BeaverTalkLogo]) are
///   authored with a black fill and tinted via [SvgPicture]'s `colorFilter`, so
///   a [color] can be supplied to match the host (defaults to [AppColors.text]).
///
/// All paths/viewBoxes are ported 1:1 from the web `src/components/icons/*`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_color_tokens.dart';


/// KakaoTalk brand mark — yellow bubble + dark glyph (Figma `kakao` 160:84688).
///
/// Brand colours are fixed and not themeable. Sized to a [size]×[size] box
/// (default 20, matching the source `viewBox`).
class KakaoIcon extends StatelessWidget {
  /// Creates the Kakao brand icon.
  const KakaoIcon({super.key, this.size = 20});

  /// Width and height of the square icon box, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/kakao.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// Google "G" brand mark on a white disc (Figma `구글` 160:85248).
///
/// The four-colour Google palette is fixed and not themeable. Sized to a
/// [size]×[size] box (default 24, matching the source `viewBox`).
class GoogleIcon extends StatelessWidget {
  /// Creates the Google brand icon.
  const GoogleIcon({super.key, this.size = 24});

  /// Width and height of the square icon box, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// Facebook "f" brand mark — white glyph knocked out of the blue disc.
///
/// Brand colours are fixed (`#1877F2`, Meta's brand blue) and not themeable,
/// matching [KakaoIcon]/[GoogleIcon]. Sized to a [size]×[size] box (default 24,
/// matching the source `viewBox`).
class FacebookIcon extends StatelessWidget {
  /// Creates the Facebook brand icon.
  const FacebookIcon({super.key, this.size = 24});

  /// Width and height of the square icon box, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/facebook.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// Apple brand mark (Figma `애플` 160:85423).
///
/// A monochrome glyph tinted with [color] (defaults to [AppColors.text], i.e.
/// white, to read on the dark social button). Sized to a [size]×[size] box
/// (default 24, matching the source `viewBox`).
class AppleIcon extends StatelessWidget {
  /// Creates the Apple brand icon.
  const AppleIcon({super.key, this.size = 24, this.color});

  /// Width and height of the square icon box, in logical pixels.
  final double size;

  /// Glyph tint colour.
  /// Glyph tint; defaults to `Label/Strong` at build time (a constructor
  /// default must be const, so it could hold only one mode).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/apple.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter:
          ColorFilter.mode(color ?? context.c.labelStrong, BlendMode.srcIn),
    );
  }
}

/// Mail / envelope glyph (Figma `mail` set 281:17652).
///
/// A monochrome glyph tinted with [color] (defaults to [AppColors.text]). Sized
/// to a [size]×[size] box (default 24, matching the source `viewBox`).
class MailIcon extends StatelessWidget {
  /// Creates the mail glyph icon.
  const MailIcon({super.key, this.size = 24, this.color});

  /// Width and height of the square icon box, in logical pixels.
  final double size;

  /// Glyph tint colour.
  /// Glyph tint; defaults to `Label/Strong` at build time (a constructor
  /// default must be const, so it could hold only one mode).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/mail.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter:
          ColorFilter.mode(color ?? context.c.labelStrong, BlendMode.srcIn),
    );
  }
}

/// "BeaverTalk" wordmark (Figma `logo` 2117:19699, 204×84).
///
/// A monochrome wordmark tinted with [color] (defaults to [AppColors.text]).
/// The intrinsic aspect ratio (204:84) is preserved; pass [width] (and
/// optionally [height]) to scale it.
class BeaverTalkLogo extends StatelessWidget {
  /// Creates the BeaverTalk wordmark.
  const BeaverTalkLogo({
    super.key,
    this.width = 204,
    this.height,
    this.color,
  });

  /// Rendered width in logical pixels (default 204, the source `viewBox` width).
  final double width;

  /// Optional explicit height; when null the 204:84 aspect ratio is kept.
  final double? height;

  /// Wordmark tint colour.
  /// Glyph tint; defaults to `Label/Strong` at build time (a constructor
  /// default must be const, so it could hold only one mode).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/beavertalk_logo.svg',
      width: width,
      height: height ?? width * (84 / 204),
      fit: BoxFit.contain,
      colorFilter:
          ColorFilter.mode(color ?? context.c.labelStrong, BlendMode.srcIn),
    );
  }
}
