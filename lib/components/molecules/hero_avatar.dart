import 'package:flutter/material.dart';

import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../icons/app_icons.dart';

/// HeroAvatar — a large circular avatar with a small "change" badge pinned to
/// its bottom-right.
///
/// Extracted from `screen/main_home` (`2296:26379`). Renders the
/// [imageProvider] filling a [size]×[size] circle, and a small rounded "change"
/// badge holding a swap (⇄) glyph pinned to its bottom-right. The badge is
/// interactive only when [onEditTap] is provided.
class HeroAvatar extends StatelessWidget {
  /// Creates a hero avatar.
  const HeroAvatar({
    super.key,
    required this.imageProvider,
    this.size = 200,
    this.onEditTap,
  });

  /// Image painted (cover) inside the circular avatar.
  final ImageProvider<Object> imageProvider;

  /// Avatar diameter in logical pixels.
  final double size;

  /// Tap handler for the "change" badge. When `null` the badge is decorative
  /// (non-interactive) but still shown.
  final VoidCallback? onEditTap;

  static const double _badgeSize = 24;

  @override
  Widget build(BuildContext context) {
    final Widget badge = Container(
      width: _badgeSize,
      height: _badgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.xs), // 8
      ),
      child: AppIcons.swap(
        size: 12,
        color: AppColors.labelAssistive,
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The avatar — large circle filled with the image.
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface2,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Change badge — primary pill with an edit glyph, pinned bottom-right.
          Positioned(
            right: 8,
            bottom: 8,
            child: onEditTap == null
                ? badge
                : Semantics(
                    button: true,
                    label: 'Change avatar',
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        onTap: onEditTap,
                        child: badge,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Gallery demo for [HeroAvatar].
class HeroAvatarDemo extends StatelessWidget {
  const HeroAvatarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: HeroAvatar(imageProvider: beaverImage, size: 160),
    );
  }
}
