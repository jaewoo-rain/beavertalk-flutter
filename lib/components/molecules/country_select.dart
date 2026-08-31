import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// A selectable country row showing a flag and a country name, with a primary
/// check mark and highlight when [selected].
///
/// Measured 1:1 from Figma `CountrySelect` set `176:9989`:
/// * Row — 56px tall, padding 16px vertical / 20px horizontal, `radius md`
///   (16px), space-between layout.
/// * Leading — horizontal row, 12px gap: the [flag] widget then the [name]
///   text in `MO/Label 1/Normal - Medium` (Label 1 Medium, white).
/// * Trailing — a 24px slot holding a `primary` check icon when [selected].
/// * selected — fill `primary10` (#00FFB2 @10%) + 1px `primary` border + check.
/// * unselected — no fill, no border, empty trailing slot.
///
/// The widget is purely presentational/controlled: tapping reports through
/// [onSelect]; it never mutates its own [selected] flag.
class CountrySelect extends StatelessWidget {
  /// Creates a country-select row.
  const CountrySelect({
    super.key,
    required this.name,
    required this.flag,
    this.selected = false,
    this.onSelect,
  });

  /// The country name shown next to the flag (Label 1 Medium).
  final String name;

  /// The flag widget rendered at the leading edge (typically an emoji `Text`).
  final Widget flag;

  /// Whether this row is currently selected (fill + border + check).
  final bool selected;

  /// Called when the row is tapped. When null the row is non-interactive.
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    // ⚠ 테두리를 `selected ? Border.all(...) : null` 로 두면 두께가 0↔1 로 튀어
    //   행 안쪽 폭이 1px 씩 흔들린다. 폭은 1 로 고정하고 **색만** 투명으로 섞는다.
    final Widget row = AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.toggle,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: selected ? context.c.primaryNormal10 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color:
              selected ? context.c.primaryNormal : const Color(0x00000000),
          width: 1,
        ),
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
                flag,
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label1.m.copyWith(color: context.c.labelStrong),
                  ),
                ),
              ],
            ),
          ),
          // 24px trailing slot — check icon only when selected.
          // 자리는 항상 24 를 차지하므로(레이아웃 불변) 체크만 페이드·팝으로 든다.
          SizedBox(
            width: 24,
            height: 24,
            child: AnimatedScale(
              duration: AppMotion.medium,
              curve: AppMotion.toggle,
              scale: selected ? 1 : 0.6,
              child: AnimatedOpacity(
                duration: AppMotion.medium,
                curve: AppMotion.toggle,
                opacity: selected ? 1 : 0,
                child: AppIcons.check(
                    size: 24, color: context.c.primaryNormal),
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelect,
        child: row,
      ),
    );
  }
}

/// Gallery demo exposing both [CountrySelect] states with live selection.
class CountrySelectDemo extends StatefulWidget {
  /// Creates the country-select gallery demo.
  const CountrySelectDemo({super.key});

  @override
  State<CountrySelectDemo> createState() => _CountrySelectDemoState();
}

class _CountrySelectDemoState extends State<CountrySelectDemo> {
  int _selected = 0;

  static const List<(String, String)> _countries = [
    ('KR', '대한민국'),
    ('US', '미국'),
    ('JP', '일본'),
    ('CN', '중국'),
  ];

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
              for (int i = 0; i < _countries.length; i++)
                CountrySelect(
                  name: _countries[i].$2,
                  flag: CountryFlag.fromCountryCode(
                    _countries[i].$1,
                    theme: const ImageTheme(
                      height: 24,
                      width: 32,
                      shape: RoundedRectangle(4),
                    ),
                  ),
                  selected: _selected == i,
                  onSelect: () => setState(() => _selected = i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
