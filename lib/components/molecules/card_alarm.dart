import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/select_box.dart';
import '../atoms/toggle.dart';

/// The on/off states of [CardAlarm].
enum CardAlarmState {
  /// Enabled alarm: time and user name in white, toggle on.
  active,

  /// Disabled alarm: time and user name in `textTertiary`, toggle off.
  inactive,
}

/// CardAlarm — an alarm card measured 1:1 from Figma (`Card-Alarm`
/// set `176:20652`).
///
/// Measured spec: `radius` 8 ([AppRadius.xs]), `20px` padding, the
/// [AppColors.surface] (Background/Normal/Normal) fill and a 1px
/// [AppColors.lineStrong] (Line/Normal/Normal) border. The inner content is a
/// column with a `12px` gap holding three rows:
///
/// 1. [time] (Heading 2 Medium) space-between an [AppToggle].
/// 2. seven day chips ([SelectBox]) with a `4px` gap.
/// 3. a user row: 24px user icon + [userName] (Label 1 SemiBold).
///
/// In [CardAlarmState.active] the time/name are white and the toggle is on; in
/// [CardAlarmState.inactive] they are `textTertiary` and the toggle is off.
///
/// The chips are driven by [days] (length 7); tapping one calls [onDayChange]
/// with its index and new value. A selected chip uses the SelectBox
/// `selected, bold` styling; an unselected one uses `unselected, regular`.
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

  /// Default single-character day labels (Sun..Sat, Korean).
  static const List<String> defaultDayLabels = [
    '일',
    '월',
    '화',
    '수',
    '목',
    '금',
    '토',
  ];

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
    final Color fg = _active ? AppColors.text : AppColors.textTertiary;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.lineStrong),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: AppType.heading2.m.copyWith(color: fg),
                ),
                AppToggle(value: _active, onChanged: onChanged),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 7; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  SelectBox(
                    label: dayLabels[i],
                    selected: days[i],
                    bold: days[i],
                    onChanged: onDayChange == null
                        ? null
                        : (v) => onDayChange!(i, v),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 24, color: fg),
                const SizedBox(width: 10),
                Text(
                  userName,
                  style: AppType.label1.sb.copyWith(color: fg),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: card),
    );
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
      color: AppColors.bg,
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
