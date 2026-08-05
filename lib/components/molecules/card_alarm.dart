import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/day_chip.dart';
import '../atoms/toggle.dart';

/// The on/off states of [CardAlarm].
enum CardAlarmState {
  /// Enabled alarm: toggle on, card at full opacity.
  active,

  /// Disabled alarm: toggle off, the whole card at 40% opacity.
  inactive,
}

/// CardAlarm — an alarm card measured 1:1 from Figma (`Card-Alarm`
/// set `176:20652`, as instanced in `screen/etc_alarm` `3665:11992`).
///
/// Measured off the **variants** (`state=active` `3793:31193`, `state=state3`
/// `3793:31202`) rather than the frame's instances, which carry overrides.
///
/// Spec: 335×153, `radius` 8 ([AppRadius.xs]), the
/// `Background/Elevated/Alternative` fill and no border, padding `16`
/// horizontal / `20` vertical — a 303 content box. Three rows down a `12` gap:
///
/// 1. 28 high — [time] (`MO/Heading 2/Medium`) space-between an [AppToggle].
/// 2. 34 high — seven [DayChip]s, 39 wide with a [kDayChipGap], which is
///    exactly 303 across; they are [Expanded] here so the row keeps filling the
///    card on any width.
/// 3. 27 high — a 24 user glyph + [userName] (`MO/Label 1/Normal-Bold`) at a
///    `10` gap.
///
/// 20+28+12+34+12+27+20 = 153, which `skeleton_height_test` pins.
///
/// Both variants write the time, glyph and name in the same
/// `Common/White & Dark`. [CardAlarmState.inactive] differs **only** by the
/// toggle being off and 40% opacity over the whole card — that is what dims the
/// chips too. It does not swap any colour, so do not "fix" this by fading the
/// text: that would leave a switched-off alarm's green chips as bright as a
/// live one's.
///
/// The chips are driven by [days] (length 7, **0=Sun … 6=Sat**) but display
/// Monday-first; tapping one calls [onDayChange] with its **data** index and
/// new value.
class CardAlarm extends StatelessWidget {
  /// Creates an alarm card.
  const CardAlarm({
    super.key,
    required this.state,
    required this.time,
    required this.days,
    required this.userName,
    this.dayLabels = defaultDayLabels,
    this.onChanged,
    this.onDayChange,
    this.onTap,
  }) : assert(days.length == 7, 'days must contain exactly 7 entries'),
       assert(
         dayLabels.length == 7,
         'dayLabels must contain exactly 7 entries',
       );

  /// Default day labels, **Monday-first** (`3665:11992`).
  ///
  /// These are *visual* order. [days] stays Sunday-indexed (0=Sun … 6=Sat) to
  /// match [Alarm.days], the server's `days_of_week` codes and both schedulers,
  /// so [_visualToDataIndex] bridges the two — the same bridge
  /// `BottomSheetAlarmSettings` already uses. Feeding a Mon-first index straight
  /// into a Sun-indexed array would shift every alarm by a day.
  ///
  /// Was `S M T W T F S` (Sunday-first, single letter), which disagreed with
  /// both the frame and the add sheet.
  static const List<String> defaultDayLabels = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  /// Visual slot → index into [days]. Monday-first display over Sunday-first
  /// data.
  static const List<int> _visualToDataIndex = [1, 2, 3, 4, 5, 6, 0];

  /// Whether the alarm is active or inactive.
  final CardAlarmState state;

  /// The alarm time text (e.g. `"AM 8:00"`).
  final String time;

  /// Selection state for each of the 7 day chips. Must be length 7.
  final List<bool> days;

  /// Single-character labels for the 7 day chips. Must be length 7.
  final List<String> dayLabels;

  /// The associated user's name.
  final String userName;

  /// Called when the alarm toggle changes. When null the toggle is
  /// non-interactive.
  final ValueChanged<bool>? onChanged;

  /// Called with `(index, newValue)` when a day chip is tapped. When null the
  /// chips are non-interactive.
  final void Function(int index, bool value)? onDayChange;

  /// Called when the card body is tapped (e.g. open edit). When null the card
  /// is non-interactive at the body level (chips/toggle still work).
  final VoidCallback? onTap;

  bool get _active => state == CardAlarmState.active;

  @override
  Widget build(BuildContext context) {
    final Color fg = context.c.commonWhiteAndDark;

    final card = DecoratedBox(
      // `3793:31193` fills the card with Elevated/Alternative (#1F222A) and
      // draws **no** border. It used to be `surface` (#181A20) + a 1px
      // `lineStrong` hairline, i.e. a card that read as an outline on the
      // background rather than a surface lifted off it.
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.heading2.m.copyWith(color: fg),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppToggle(value: _active, onChanged: onChanged),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < 7; i++) ...[
                  if (i > 0) const SizedBox(width: kDayChipGap),
                  // `i` is the visual slot; the data index is a lookup away.
                  // [onDayChange] still reports the **data** index, which is
                  // what `toggleDay` sends the server.
                  Expanded(
                    child: DayChip(
                      label: dayLabels[i],
                      selected: days[_visualToDataIndex[i]],
                      onTap: onDayChange == null
                          ? null
                          : () => onDayChange!(
                                _visualToDataIndex[i],
                                !days[_visualToDataIndex[i]],
                              ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 27,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppIcons.user(size: 24, color: fg),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.label1.sb.copyWith(color: fg),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final Widget interactive = onTap == null
        ? card
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            clipBehavior: Clip.antiAlias,
            child: InkWell(onTap: onTap, child: card),
          );

    // Outermost, so it dims the chips and toggle with everything else — and
    // above the InkWell, since [Opacity] does not block hit testing: a
    // switched-off alarm must still be tappable to switch back on.
    if (_active) return interactive;
    return Opacity(opacity: 0.4, child: interactive);
  }
}

/// Gallery demo exposing both [CardAlarm] states.
class CardAlarmDemo extends StatefulWidget {
  /// Creates the CardAlarm gallery demo.
  const CardAlarmDemo({super.key});

  @override
  State<CardAlarmDemo> createState() => _CardAlarmDemoState();
}

class _CardAlarmDemoState extends State<CardAlarmDemo> {
  List<bool> _activeDays = [true, true, true, true, true, true, false];
  CardAlarmState _state = CardAlarmState.active;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CardAlarm(
              state: _state,
              time: 'AM 8:00',
              days: _activeDays,
              userName: 'Judi',
              onChanged: (v) => setState(() => _state =
                  v ? CardAlarmState.active : CardAlarmState.inactive),
              onDayChange: (i, v) => setState(() {
                _activeDays = [..._activeDays]..[i] = v;
              }),
            ),
            const SizedBox(height: 16),
            CardAlarm(
              state: CardAlarmState.inactive,
              time: 'PM 8:00',
              days: const [false, true, false, true, false, true, false],
              userName: 'Judi',
            ),
          ],
        ),
      ),
    );
  }
}
