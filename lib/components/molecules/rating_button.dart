import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../icons/app_icons.dart';

/// RatingButton — a circular icon toggle used for quick call ratings.
///
/// Extracted from `screen/call_finish` (`2117:19981`). Renders a 64×64 circle
/// holding [icon]; when [selected] the circle fills with `Primary/Normal`
/// and the glyph turns `Primary/On-Primary`, otherwise it sits on
/// `Background/Normal/Alternative` with a `Label/Normal` glyph.
class RatingButton extends StatelessWidget {
  /// Creates a rating button.
  const RatingButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  /// Glyph builder shown inside the circle (e.g. [AppIcons.thumbsUp]).
  final AppIconBuilder icon;

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
      // 채움과 글리프가 한 프레임에 갈리면 어느 쪽을 골랐는지 눈이 못 따라간다.
      // 두 색 모두 실제 색이라(투명이 없다) 그대로 섞으면 된다.
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: selected ? 1 : 0),
        duration: AppMotion.medium,
        curve: AppMotion.toggle,
        builder: (context, t, _) => Material(
          color: Color.lerp(context.c.backgroundNormalAlternative,
              context.c.primaryNormal, t)!,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: _size,
              height: _size,
              child: Center(
                child: icon(
                  size: 28,
                  color: Color.lerp(context.c.labelNormal,
                      context.c.primaryOnPrimary, t)!,
                ),
              ),
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
            icon: AppIcons.thumbsUp,
            label: '좋아요',
            selected: _up == true,
            onTap: () => setState(() => _up = true),
          ),
          const SizedBox(width: 16),
          RatingButton(
            icon: AppIcons.thumbsDown,
            label: '아쉬워요',
            selected: _up == false,
            onTap: () => setState(() => _up = false),
          ),
        ],
      ),
    );
  }
}
