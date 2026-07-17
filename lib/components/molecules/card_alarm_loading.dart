import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../atoms/skeleton.dart';

/// CardAlarmLoading — the loading stand-in for [CardAlarm], Figma
/// `screen/etc_alarm_loading` (`3489:4550`).
///
/// Mirrors [CardAlarm]'s box exactly — the same `Background/Elevated/Alternative`
/// fill, no border, radius 8, 20 padding — and the same three rows at the same
/// heights, so the card does not resize when the alarms land:
///
/// 1. the time beside the toggle's 52×28 pill (the toggle is taller than the
///    time's 24 line box, so 28 is the row),
/// 2. seven day chips at [SelectBox]'s 28-high box,
/// 3. the 24 user glyph beside the partner's name.
///
/// Nothing here is a real label: unlike the record/analysis skeletons, an alarm
/// card has no static text at all — every word on it (time, day, partner) comes
/// from the response.
///
/// Must sit under a [SkeletonShimmer].
class CardAlarmLoading extends StatelessWidget {
  /// Creates an alarm loading card.
  const CardAlarmLoading({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time + toggle. The toggle's 28 sets the row height, as it does
              // in the real card.
              SizedBox(
                height: 28,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton.bar(width: 96, height: 20),
                    Skeleton.box(width: 52, height: 28),
                  ],
                ),
              ),
              SizedBox(height: 12),
              // Seven day chips at their real size — the row is seven chips
              // wide whatever the response says, so this promises nothing.
              _DayChips(),
              SizedBox(height: 12),
              Row(
                children: [
                  Skeleton.box(width: 24, height: 24),
                  SizedBox(width: 10),
                  Skeleton.bar(width: 64, height: 14),
                ],
              ),
            ],
          ),
        ),
      );
}

/// The seven day chips' row, at [SelectBox]'s real 28-high box and 4 gap.
class _DayChips extends StatelessWidget {
  const _DayChips();

  @override
  Widget build(BuildContext context) => SizedBox(
        // Same 28 box + scale-down as the real card's chip row, so the two keep
        // the same height on a narrow screen instead of drifting apart.
        height: 28,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                const Skeleton.box(width: 32, height: 28),
              ],
            ],
          ),
        ),
      );
}
