import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/checkbox.dart';

/// A selectable card: an icon tile, a title + description, and a trailing
/// [AppCheckbox]. When [checked] the card gains a `primary` border.
///
/// Measured 1:1 from Figma `Select Card` set `2291:21077`:
/// * Card — fill `surface2` (#252932), `radius md` (16px), padding 18px
///   vertical / 16px horizontal, space-between row.
/// * Leading — horizontal row, 12px gap: a 44×44 icon tile (fill
///   `surfaceElevated` #1F222A, `radius sm` 12px, centred [icon]) then a
///   vertical text column (4px gap) of [title] (`Label 1 Medium`, white) and
///   [description] (`Caption 1 Regular`, `textSecondary`).
/// * Trailing — the reused [AppCheckbox] at `size22`.
/// * Default — no border. Variant2 / checked — 1px `primary` border.
///
/// This is a controlled widget: it reflects [checked] and reports taps through
/// [onChanged]; it does not hold its own state. Tapping anywhere on the card
/// (or the checkbox) toggles the value.
class SelectCard extends StatelessWidget {
  /// Creates a select card.
  const SelectCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.checked = false,
    this.onChanged,
  });

  /// The card title (Label 1 Medium).
  final String title;

  /// The supporting line beneath the title (Caption 1 Regular, secondary).
  final String description;

  /// The widget centred inside the 44×44 icon tile (e.g. an emoji `Text`).
  final Widget icon;

  /// Whether the card is selected — drives the checkbox and the primary border.
  final bool checked;

  /// Called with the desired new value when the card or checkbox is tapped.
  ///
  /// When null the card is non-interactive.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: checked
            ? Border.all(color: context.c.primaryNormal, width: 1)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 44×44 icon tile — surfaceElevated, radius sm.
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.c.backgroundElevatedAlternative,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: icon,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label1.m.copyWith(color: context.c.labelStrong),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.caption1.r
                            .copyWith(color: context.c.labelNormal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Reuses the AppCheckbox atom (size 22).
          AppCheckbox(
            value: checked,
            onChanged: onChanged,
          ),
        ],
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!checked),
      child: card,
    );
  }
}

/// Gallery demo exposing both [SelectCard] variants (Default / checked).
class SelectCardDemo extends StatefulWidget {
  /// Creates the select-card gallery demo.
  const SelectCardDemo({super.key});

  @override
  State<SelectCardDemo> createState() => _SelectCardDemoState();
}

class _SelectCardDemoState extends State<SelectCardDemo> {
  bool _a = false;
  bool _b = true;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 335,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectCard(
                title: '여행에서 말하기',
                description: '현지에서 자신있게 대화하기',
                icon: const Text('🌏', style: TextStyle(fontSize: 22)),
                checked: _a,
                onChanged: (v) => setState(() => _a = v),
              ),
              const SizedBox(height: 16),
              SelectCard(
                title: '여행에서 말하기',
                description: '현지에서 자신있게 대화하기',
                icon: const Text('🌏', style: TextStyle(fontSize: 22)),
                checked: _b,
                onChanged: (v) => setState(() => _b = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
