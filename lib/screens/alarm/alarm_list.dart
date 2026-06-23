import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_alarm.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import 'alarm_models.dart';

/// Alarm list — Figma `screen/etc_alarm` (`2117:20250`). A scrollable list of
/// [CardAlarm]s. Each card can be:
/// - **swiped** away to delete ([Dismissible]),
/// - **tapped** to open the edit sheet ([Routes.alarmAdd] with the [AlarmData]),
///   committing the returned edit back into the list,
/// and a trailing "+" / footer button opens the same sheet in add mode.
class AlarmListScreen extends StatefulWidget {
  /// Creates the alarm list screen.
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  final List<AlarmData> _alarms = [
    AlarmData(
      hour: 8,
      minute: 0,
      meridiem: Meridiem.am,
      days: [true, true, true, true, true, false, false],
      partnerId: 'beaver',
    ),
    AlarmData(
      hour: 6,
      minute: 0,
      meridiem: Meridiem.pm,
      days: [false, true, false, true, false, true, false],
      partnerId: 'judi',
      active: false,
    ),
  ];

  /// Opens the add sheet; appends the result if the user saved.
  Future<void> _add() async {
    final result =
        await Navigator.pushNamed(context, Routes.alarmAdd) as AlarmData?;
    if (result != null) setState(() => _alarms.add(result));
  }

  /// Opens the edit sheet seeded with [i]'s data; replaces it on save.
  Future<void> _edit(int i) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.alarmAdd,
      arguments: _alarms[i],
    ) as AlarmData?;
    if (result != null) setState(() => _alarms[i] = result);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '일정 관리', onBack: () => Navigator.pop(context)),
          // "알람" subheader with an add (+) action.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('알람',
                    style: AppType.heading2.sb.copyWith(color: AppColors.text)),
                IconButton(
                  onPressed: _add,
                  icon: const Icon(Icons.add, color: AppColors.text),
                  tooltip: '새 일정 추가',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _alarms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final a = _alarms[i];
                return Dismissible(
                  key: ObjectKey(a),
                  direction: DismissDirection.endToStart,
                  background: _deleteBackground(),
                  onDismissed: (_) => setState(() => _alarms.removeAt(i)),
                  child: CardAlarm(
                    state: a.active
                        ? CardAlarmState.active
                        : CardAlarmState.inactive,
                    time: a.listLabel,
                    days: a.days,
                    userName: a.partnerName,
                    onTap: () => _edit(i),
                    onChanged: (v) => setState(() => a.active = v),
                    onDayChange: (idx, v) =>
                        setState(() => a.days = [...a.days]..[idx] = v),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '새 일정 추가',
                onPressed: _add,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The red "delete" panel revealed when swiping a card left.
  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.text, size: 28),
    );
  }
}
