import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';

/// BottomSheetTimePicker — a two-wheel (hour 1–12 / minute 0–59) time selector
/// surfaced over the alarm-settings sheet so the user can change the alarm time.
///
/// Fully self-contained: seeded with [initialHour] / [initialMinute], it tracks
/// the spun selection internally and reports the result through [onConfirm]
/// (`hour`, `minute`) when "확인" is pressed, or dismisses via [onCancel].
///
/// Composes the shared [Button] atom for its footer actions; the wheels reuse
/// Flutter's [ListWheelScrollView] styled to the BeaverTalk dark palette.
class BottomSheetTimePicker extends StatefulWidget {
  /// Creates a time-picker sheet seeded at [initialHour]:[initialMinute].
  const BottomSheetTimePicker({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onConfirm,
    this.onCancel,
    this.title,
  });

  /// Initial hour (1–12).
  final int initialHour;

  /// Initial minute (0–59).
  final int initialMinute;

  /// Called with the chosen `(hour, minute)` when "확인" is pressed.
  final void Function(int hour, int minute) onConfirm;

  /// Called when the picker is dismissed without confirming.
  final VoidCallback? onCancel;

  /// Header title; falls back to the localized "Select time" when null.
  final String? title;

  @override
  State<BottomSheetTimePicker> createState() => _BottomSheetTimePickerState();
}

class _BottomSheetTimePickerState extends State<BottomSheetTimePicker> {
  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
    _hourCtrl = FixedExtentScrollController(initialItem: _hour - 1);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: context.c.backgroundElevatedAlternative,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title ?? l10n.selectTime,
                textAlign: TextAlign.center,
                style: AppType.body1.sb.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _wheel(
                      controller: _hourCtrl,
                      count: 12,
                      label: (i) => '${i + 1}',
                      onSelected: (i) => setState(() => _hour = i + 1),
                    ),
                    Text(':',
                        style: AppType.heading2.sb
                            .copyWith(color: AppColors.text)),
                    _wheel(
                      controller: _minuteCtrl,
                      count: 60,
                      label: (i) => i.toString().padLeft(2, '0'),
                      onSelected: (i) => setState(() => _minute = i),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      type: BtnType.secondaryFill,
                      size: BtnSize.s48,
                      text: l10n.cancel,
                      onPressed: widget.onCancel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s48,
                      text: l10n.confirm,
                      onPressed: () => widget.onConfirm(_hour, _minute),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One styled selection wheel.
  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required String Function(int index) label,
    required ValueChanged<int> onSelected,
  }) {
    return SizedBox(
      width: 80,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        perspective: 0.004,
        diameterRatio: 1.3,
        physics: const FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 0.35,
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, i) => Center(
            child: Text(
              label(i),
              style: AppType.heading2.sb.copyWith(color: AppColors.text),
            ),
          ),
        ),
      ),
    );
  }
}
