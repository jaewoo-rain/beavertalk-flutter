import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// RatingButton — a circular icon toggle used for quick call ratings.
///
/// Extracted from `screen/call_finish` (`2117:19981`). Renders a 64×64 circle
/// holding [icon]; when [selected] the circle fills with [AppColors.primary]
/// and the glyph turns [AppColors.onPrimary], otherwise it sits on
/// [AppColors.surface2] with a [AppColors.textSecondary] glyph.
class RatingButton extends StatelessWidget {
  /// Creates a rating button.
  const RatingButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  /// Glyph shown inside the circle (e.g. thumbs up / down).
  final IconData icon;

  /// Accessible label for the choice (e.g. "좋아요").
  final String label;

  /// Whether this rating is currently chosen.
  final bool selected;

  /// Tap callback.
  final VoidCallback onTap;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface2,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: _size,
            height: _size,
            child: Icon(
              icon,
              size: 28,
              color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Gallery demo for [RatingButton] (tap to pick one).
class RatingButtonDemo extends StatefulWidget {
  const RatingButtonDemo({super.key});

  @override
  State<RatingButtonDemo> createState() => _RatingButtonDemoState();
}

class _RatingButtonDemoState extends State<RatingButtonDemo> {
  bool? _up;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingButton(
            icon: Icons.thumb_up_alt_outlined,
            label: '좋아요',
            selected: _up == true,
            onTap: () => setState(() => _up = true),
          ),
          const SizedBox(width: 16),
          RatingButton(
            icon: Icons.thumb_down_alt_outlined,
            label: '아쉬워요',
            selected: _up == false,
            onTap: () => setState(() => _up = false),
          ),
        ],
      ),
    );
  }
}
