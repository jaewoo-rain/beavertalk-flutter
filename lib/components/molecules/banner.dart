import 'package:flutter/material.dart' hide Banner;

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

// Flutter ships a debug `Banner` widget, so this class shadows it — the same
// trade the project already made with `BottomSheet`, keeping the Figma
// component name as the code name. Call sites `hide Banner` as this file does.

/// Colour family of a [Banner] — the Figma `tone=*` variant (`4206:622`).
enum BannerTone {
  /// Gold — the Max upsell (`Banner/upgrade`).
  gold,

  /// Red — payment failure. `GRACE` and `ON_HOLD` only (spec §6-1).
  danger,

  /// Mint — the Pro upsell.
  brand,

  /// Grey — informational (e.g. cancellation notice).
  neutral,
}

/// Top-of-screen notice / upsell banner — Figma `Banner` (`4206:622`).
///
/// Min 76px, 24/16 padding, radius 12, 1px tone border. Title in Body 2
/// SemiBold `Label/Strong`; sub and chevron in the tone's foreground colour.
///
/// Always inline — the Figma notes forbid using it as a blocking dialog. Most
/// banners navigate (chevron shown); the limit-paywall banner is deliberately
/// **non-interactive** (spec §8-1): pass `onTap: null, showChevron: false`.
class Banner extends StatelessWidget {
  /// Creates a banner.
  const Banner({
    super.key,
    required this.tone,
    required this.title,
    required this.sub,
    this.onTap,
    this.showChevron = true,
  });

  /// Colour family; see [BannerTone].
  final BannerTone tone;

  /// Headline, from l10n. May carry a server-formatted date — `Retrying until
  /// [date]` and `Paused since [date]` are server values (spec §11-3), where
  /// `[date]` is never computed locally.
  final String title;

  /// Supporting line, from l10n.
  final String sub;

  /// Navigation callback. Null renders the banner inert.
  final VoidCallback? onTap;

  /// Whether the trailing chevron is drawn. Hide it together with a null
  /// [onTap] — an affordance on a dead banner is a lie.
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (Color face, Color border, Color fg) = switch (tone) {
      BannerTone.gold =>
        (c.statusCautionarySurface, c.statusCautionary, c.accentForegroundOrange),
      BannerTone.danger =>
        (c.statusNegative6, c.statusNegative, c.accentForegroundRed),
      // Sub is bound to `Primary/Foreground` in Figma — identical to
      // `Primary/Normal` in Dark and the design's mint text value in Light,
      // so it maps onto the existing token rather than minting a twin.
      BannerTone.brand => (c.primaryNormal10, c.primaryNormal, c.primaryNormal),
      BannerTone.neutral =>
        (c.backgroundSurfaceAlternative, c.lineNormal, c.labelNormal),
    };

    final banner = Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: face,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppType.body2.sb.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: 4),
                Text(sub, style: AppType.caption1.r.copyWith(color: fg)),
              ],
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 12),
            AppIcons.chevronRight(size: 20, color: fg),
          ],
        ],
      ),
    );

    if (onTap == null) return banner;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: banner,
    );
  }
}
