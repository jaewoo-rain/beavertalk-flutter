import 'package:flutter/material.dart';

import '../atoms/button.dart';

/// SegmentedTabs — a horizontal row of pill tabs, measured 1:1 from the
/// `screen/record_list` "Top Navigation" (`2117:20319`): a row (gap 12) where
/// the active tab reuses the [BtnType.secondaryFill] / size 44 button (white
/// text on surface2) and the inactive tabs reuse [BtnType.secondaryOutline]
/// (secondary text, outlined).
///
/// Fully controlled: pass the [labels], the [activeIndex], and an [onChanged]
/// that fires with the tapped index.
class SegmentedTabs extends StatelessWidget {
  /// Creates a segmented tab row.
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.activeIndex,
    this.onChanged,
  });

  /// Tab labels, left → right.
  final List<String> labels;

  /// Index of the currently-active tab.
  final int activeIndex;

  /// Called with the tapped tab's index.
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          // Flexible (not Expanded): each tab hugs its natural width when it
          // fits, but shrinks — letting the Button's own ellipsis kick in —
          // rather than overflowing the row when labels run long in some
          // translations.
          Flexible(
            child: Button(
              type: i == activeIndex
                  ? BtnType.secondaryFill
                  : BtnType.secondaryOutline,
              size: BtnSize.s44,
              text: labels[i],
              onPressed: onChanged == null ? null : () => onChanged!(i),
            ),
          ),
        ],
      ],
    );
  }
}
