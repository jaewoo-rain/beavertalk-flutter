import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../components/organisms/bottom_sheet_time_picker.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import 'alarm_models.dart';

/// Add / edit alarm — Figma `screen/etc_alarm__add` (`2117:20276`).
///
/// The interactive surface lives in [AlarmAddSheet] so it can be dropped
/// straight into a modal bottom sheet (the primary entry point from the alarm
/// list) — see `alarm_list.dart`. This [AlarmAddScreen] is kept as a thin
/// full-page host for the legacy `Routes.alarmAdd` route (still used by
/// `alarm_empty.dart`); it simply bottom-aligns the same [AlarmAddSheet].
///
/// Reads an optional [AlarmData] off `ModalRoute.settings.arguments`:
/// - present → **edit** mode; absent → **add** mode.
class AlarmAddScreen extends StatelessWidget {
  /// Creates the add/edit-alarm host screen.
  const AlarmAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: AlarmAddSheet(initial: arg is AlarmData ? arg : null),
      ),
    );
  }
}

/// The add/edit-alarm content — the [BottomSheetAlarmSettings] surface (time +
/// AM/PM + weekday chips + call partner + save) plus its state wiring.
///
/// Designed to size to its own content (`mainAxisSize.min`) so it works as a
/// **modal bottom-sheet body** (present it via `showModalBottomSheet` with
/// `isScrollControlled: true` and `backgroundColor: Colors.transparent`) as
/// well as inside a bottom-aligned page host ([AlarmAddScreen]).
///
/// The partner list is fed by the real server characters
/// (`availableCharactersProvider`); a new alarm defaults to the first one.
///
/// - [initial] present → **edit** mode (title "일정 수정"), seeded from a copy
///   of that alarm; absent → **add** mode (title "새 일정 추가").
///
/// On save it pops its enclosing route/sheet with the edited [AlarmData] (the
/// caller commits it to the server); close/dismiss pops with `null`.
class AlarmAddSheet extends ConsumerStatefulWidget {
  /// Creates the add/edit-alarm sheet body, optionally seeded with [initial].
  const AlarmAddSheet({super.key, this.initial});

  /// The alarm being edited, or `null` for add mode.
  final AlarmData? initial;

  @override
  ConsumerState<AlarmAddSheet> createState() => _AlarmAddSheetState();
}

class _AlarmAddSheetState extends ConsumerState<AlarmAddSheet> {
  late final AlarmData _data;

  /// The highlighted 빠른 시작 card, or null once the form no longer matches one.
  ///
  /// Derived rather than remembered: a preset is only a shortcut that seeds the
  /// time and days, so as soon as the user edits either the card must stop
  /// claiming to describe the form. [_presetFor] recomputes it from the data on
  /// every build — that way editing 8:00 → 8:30 drops the highlight, and setting
  /// the fields back by hand lights it again.
  AlarmPreset? get _preset => _presetFor(_data);

  bool get _isEdit => widget.initial != null;

  /// Which preset [d] currently *is*, if any (`3665:12362`).
  ///
  /// 직접 설정 is deliberately never returned: it seeds nothing, so there is no
  /// state it could describe. It highlights only while the form matches neither
  /// of the other two.
  static AlarmPreset? _presetFor(AlarmData d) {
    if (_matches(d, hour: 8, meridiem: Meridiem.am, days: _weekdays)) {
      return AlarmPreset.morning;
    }
    if (_matches(d, hour: 9, meridiem: Meridiem.pm, days: _everyDay)) {
      return AlarmPreset.evening;
    }
    return AlarmPreset.custom;
  }

  static bool _matches(
    AlarmData d, {
    required int hour,
    required Meridiem meridiem,
    required List<bool> days,
  }) =>
      d.hour == hour &&
      d.minute == 0 &&
      d.meridiem == meridiem &&
      _sameDays(d.days, days);

  static bool _sameDays(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Sun-indexed (0=Sun … 6=Sat), like everything else that touches days.
  static const List<bool> _weekdays = [
    false, true, true, true, true, true, false, //
  ];
  static const List<bool> _everyDay = [
    true, true, true, true, true, true, true, //
  ];

  /// Seeds the form from a preset. 직접 설정 changes nothing — it is the label
  /// for "I'll set it myself", not a value.
  void _applyPreset(AlarmPreset p) {
    switch (p) {
      case AlarmPreset.morning: // 평일 8:00
        _data
          ..hour = 8
          ..minute = 0
          ..meridiem = Meridiem.am
          ..days = [..._weekdays];
      case AlarmPreset.evening: // 매일 21:00
        _data
          ..hour = 9
          ..minute = 0
          ..meridiem = Meridiem.pm
          ..days = [..._everyDay];
      case AlarmPreset.custom:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _data = widget.initial?.copy() ??
        AlarmData(
          hour: 8,
          minute: 0,
          meridiem: Meridiem.am,
          // Sun-indexed (0=Sun..6=Sat); default Monday selected (index 1).
          days: [false, true, false, false, false, false, false],
          // Replaced with the first real character once loaded.
          characterId: 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final l10n = AppLocalizations.of(context);
    final charactersAsync = ref.watch(availableCharactersProvider);

    return charactersAsync.when(
      loading: () => const _SheetLoading(),
      error: (error, stack) => _SheetMessage(
        message: l10n.charactersLoadError,
        onClose: () => Navigator.pop(context),
      ),
      data: (characters) {
        if (characters.isEmpty) {
          return _SheetMessage(
            message: l10n.noCharacters,
            onClose: () => Navigator.pop(context),
          );
        }
        _ensureCharacter(data, characters);
        return BottomSheetAlarmSettings(
          title: _isEdit ? l10n.editSchedule : l10n.addSchedule,
          // The frame's CTA repeats the sheet's title (`3665:12045`) rather
          // than saying 저장, which is what the default `saveText` gave.
          saveText: _isEdit ? l10n.save : l10n.addSchedule,
          time: data.clockLabel,
          onTimeTap: () => _pickTime(data),
          meridiem: data.meridiem,
          onMeridiemChanged: (m) => setState(() => data.meridiem = m),
          days: data.days,
          onDaysChanged: (index, selected) => setState(
            () => data.days = [...data.days]..[index] = selected,
          ),
          preset: _preset,
          onPresetChanged: (p) => setState(() => _applyPreset(p)),
          partners: partnersFromCharacters(characters),
          partner: data.characterId.toString(),
          onPartnerChanged: (id) => setState(() {
            data.characterId = int.tryParse(id) ?? data.characterId;
            data.characterName = characters
                .firstWhere((c) => c.characterId.toString() == id)
                .name;
          }),
          onSave: () => Navigator.pop(context, data),
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  /// Surfaces the [BottomSheetTimePicker] centered above everything (including
  /// the enclosing modal sheet) via [showGeneralDialog], so it layers correctly
  /// regardless of whether this body is hosted in a modal sheet or a page.
  ///
  /// Reuses the [Dim] atom for the blurred scrim + tap-to-dismiss, matching the
  /// former in-page overlay. Applies the confirmed `(hour, minute)` on return.
  Future<void> _pickTime(AlarmData data) async {
    final picked = await showGeneralDialog<(int, int)>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: AppLocalizations.of(context).selectTime,
      pageBuilder: (dialogCtx, _, _) => Stack(
        children: [
          Dim(onTap: () => Navigator.pop(dialogCtx)),
          Center(
            child: BottomSheetTimePicker(
              initialHour: data.hour,
              initialMinute: data.minute,
              onCancel: () => Navigator.pop(dialogCtx),
              onConfirm: (h, m) => Navigator.pop(dialogCtx, (h, m)),
            ),
          ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      data
        ..hour = picked.$1
        ..minute = picked.$2;
    });
  }

  /// Picks a sensible default character when none is selected yet (add mode),
  /// and fills in the display name from the loaded list.
  void _ensureCharacter(AlarmData data, List<AlarmCharacter> characters) {
    final exists =
        characters.any((c) => c.characterId == data.characterId);
    if (!exists) {
      data.characterId = characters.first.characterId;
    }
    data.characterName ??=
        characters.firstWhere((c) => c.characterId == data.characterId).name;
  }
}

/// Bottom-aligned loading placeholder while characters load.
class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(color: context.c.primaryNormal),
      ),
    );
  }
}

/// Bottom-aligned message (error / empty) with a close action.
class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      color: context.c.backgroundElevatedAlternative,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: AppType.body2.r
                  .copyWith(color: context.c.labelNormal)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onClose,
            child: Text(AppLocalizations.of(context).close),
          ),
        ],
      ),
    );
  }
}
