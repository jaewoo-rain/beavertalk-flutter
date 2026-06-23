import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../components/organisms/bottom_sheet_time_picker.dart';
import '../../theme/app_colors.dart';
import 'alarm_models.dart';

/// Add / edit alarm — Figma `screen/etc_alarm__add` (`2117:20276`).
///
/// Hosts the [BottomSheetAlarmSettings] surface (time + AM/PM + weekday chips +
/// call partner + save). Tapping the big time opens an in-frame
/// [BottomSheetTimePicker] so the hour/minute can be changed.
///
/// Reads an optional [AlarmData] off `ModalRoute.settings.arguments`:
/// - present → **edit** mode (title "일정 수정"), pre-filled from that alarm;
/// - absent → **add** mode (title "새 일정 추가"), seeded with a default.
///
/// On save it pops with the edited [AlarmData] (the caller commits it to the
/// list); close pops with `null`.
class AlarmAddScreen extends StatefulWidget {
  /// Creates the add/edit-alarm screen.
  const AlarmAddScreen({super.key});

  @override
  State<AlarmAddScreen> createState() => _AlarmAddScreenState();
}

class _AlarmAddScreenState extends State<AlarmAddScreen> {
  AlarmData? _data;
  bool _pickingTime = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_data != null) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    _data = arg is AlarmData
        ? arg.copy()
        : AlarmData(
            hour: 8,
            minute: 0,
            meridiem: Meridiem.am,
            days: [true, false, false, false, false, false, false],
            partnerId: 'beaver',
          );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data!;
    final isEdit = ModalRoute.of(context)?.settings.arguments is AlarmData;

    return AppScaffold(
      background: AppColors.surface,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetAlarmSettings(
              title: isEdit ? '일정 수정' : '새 일정 추가',
              time: data.clockLabel,
              onTimeTap: () => setState(() => _pickingTime = true),
              meridiem: data.meridiem,
              onMeridiemChanged: (m) => setState(() => data.meridiem = m),
              days: data.days,
              onDaysChanged: (index, selected) =>
                  setState(() => data.days = [...data.days]..[index] = selected),
              partners: kAlarmPartners,
              partner: data.partnerId,
              onPartnerChanged: (id) => setState(() => data.partnerId = id),
              onSave: () => Navigator.pop(context, data),
              onClose: () => Navigator.pop(context),
            ),
          ),
          if (_pickingTime) ...[
            Dim(onTap: () => setState(() => _pickingTime = false)),
            Center(
              child: BottomSheetTimePicker(
                initialHour: data.hour,
                initialMinute: data.minute,
                onCancel: () => setState(() => _pickingTime = false),
                onConfirm: (h, m) => setState(() {
                  data
                    ..hour = h
                    ..minute = m;
                  _pickingTime = false;
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
