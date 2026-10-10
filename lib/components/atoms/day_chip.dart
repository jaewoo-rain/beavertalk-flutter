import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// DayChip — one weekday chip, filled when selected.
///
/// Measured from `Card-Alarm`'s chip row (`3793:30388`…, variant `state=active`
/// `3793:31193`) and identical in the 시간과 요일 card (`3665:12397`): a 34-high
/// box, radius 8 ([AppRadius.xs]), label centred in `MO/Caption 1/Regular`.
/// Selected fills `Primary/Strong` and writes the label in `primaryOnPrimary`
/// (`Common/Dark & White` in the frame — the same #111→#FFF pair in both modes,
/// but named for what it is: a label on a primary fill). Unselected is a
/// `Background/Normal/Normal` box with a `Label/Normal` label.
///
/// The chip hugs nothing horizontally: the frame lays seven of them out at 39
/// wide with a 5 gap across a 303 content box, i.e. **equal widths filling the
/// row**. Callers put it in an [Expanded] and space with `5`, which reproduces
/// that at 375dp and degrades by shrinking — not clipping — on narrower phones.
///
/// Not to be confused with [SelectBox] (`170:9634`), which is still a real atom
/// in the file but conveys selection by *text colour* on a constant grey box.
/// The weekday rows stopped using it; nothing else in the app draws a chip this
/// way, so do not reach for it here.
class DayChip extends StatelessWidget {
  /// Creates a weekday chip.
  const DayChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  /// The short weekday name (e.g. `"Mo"`, `"월"`).
  final String label;

  /// Whether this day is picked.
  final bool selected;

  /// Called when the chip is tapped. When null the chip is non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 채움과 글자색이 한 프레임에 갈리면 요일을 눌렀는지 안 눌렀는지 눈이
    // 못 따라간다. 둘 다 [AppMotion.medium] 로 묶는다.
    final chip = AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.toggle,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            selected ? context.c.primaryStrong : context.c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AnimatedDefaultTextStyle(
        duration: AppMotion.medium,
        curve: AppMotion.toggle,
        style: AppType.caption1.r.copyWith(
          color: selected ? context.c.primaryOnPrimary : context.c.labelNormal,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    if (onTap == null) return chip;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: chip,
      ),
    );
  }
}

/// The gap between two [DayChip]s — the frame's 5, which no spacing token
/// carries.
const double kDayChipGap = 5;
