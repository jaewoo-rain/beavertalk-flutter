import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// AvatarCard — a selectable avatar tile (image + name + status label).
///
/// Figma component set `170:9627` (AvatarCard), states `active` /
/// `inactive`.
///
/// Measured from Figma:
/// - Column, `padding` 8, `gap` 4, `borderRadius` [AppRadius.xs] (8),
///   center-aligned, hug sizing.
/// - Status row on top (row, gap 8): a 6×6 dot + status label
///   ([AppType.caption1]). Then a 64×64 circular avatar, then the name
///   ([AppType.label1] SemiBold).
/// - `active`   → fill [AppColors.primary04], 1px [AppColors.primary]
///   border, dot/label in [AppColors.primary].
/// - `inactive` → fill [AppColors.surfaceElevated], no border, dot/label
///   in [AppColors.textSecondary].
///
/// Presentation-only aside from [onTap]. Provide the avatar via either
/// [imageProvider] (drawn 64×64, cover) or a custom [avatar] widget;
/// when both are null a neutral placeholder is shown.
class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.name,
    this.statusLabel,
    this.active = false,
    this.imageProvider,
    this.avatar,
    this.onTap,
  });

  /// The avatar's display name (e.g. "Beaver"), rendered SemiBold.
  final String name;

  /// Status caption under/over the avatar (Figma: "사용 중" / "보유 중").
  /// When `null` the status row is omitted.
  final String? statusLabel;

  /// Whether this card is the active/selected one.
  final bool active;

  /// Image to fill the 64×64 circular avatar slot. Ignored when [avatar]
  /// is provided.
  final ImageProvider<Object>? imageProvider;

  /// Custom avatar widget, taking precedence over [imageProvider]. Sized to
  /// 64×64 and clipped to a circle by the card.
  final Widget? avatar;

  /// Tap handler; when `null` the card is non-interactive.
  final VoidCallback? onTap;

  static const double _avatarSize = 64;
  static const double _dotSize = 6;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        active ? AppColors.primary : AppColors.textSecondary;

    final card = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // `primary/normal-4` (4%), not the 10% this used to wash the selected
        // card with (`I3665:12415`).
        color: active ? AppColors.primary04 : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        // Both states are bordered per Figma (`2117:20367` / `2117:20368`):
        // active = `primary`, inactive = `line/normal`. The inactive border was
        // missing entirely, so unselected cards read as flat fills and sat 1px
        // smaller than the selected one.
        border: Border.all(
          color: active ? AppColors.primary : AppColors.lineStrong,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (statusLabel != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    statusLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // Caption 1 (12), not Label 1 (14) — measured on the alarm
                    // sheet's instances (`I3665:12415;164:13214`).
                    style: AppType.caption1.r.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          ClipOval(
            child: SizedBox(
              width: _avatarSize,
              height: _avatarSize,
              child: _buildAvatar(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.label1.sb,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        onTap: onTap,
        child: card,
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatar != null) return avatar!;
    if (imageProvider != null) {
      return Image(image: imageProvider!, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: AppColors.surface2,
      child: AppIcons.profile(color: AppColors.textTertiary, size: 32),
    );
  }
}

/// Gallery demo exposing both [AvatarCard] states.
class AvatarCardDemo extends StatelessWidget {
  const AvatarCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AvatarCard(
            name: 'Beaver',
            statusLabel: '사용 중',
            active: true,
          ),
          SizedBox(width: 16),
          AvatarCard(
            name: 'Beaver',
            statusLabel: '보유 중',
            active: false,
          ),
        ],
      ),
    );
  }
}
