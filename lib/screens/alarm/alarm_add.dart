import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../components/organisms/bottom_sheet_time_picker.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
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
      background: AppColors.surface,
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

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _data = widget.initial?.copy() ??
        AlarmData(
          hour: 8,
          minute: 0,
          meridiem: Meridiem.am,
          days: [true, false, false, false, false, false, false],
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
          time: data.clockLabel,
          onTimeTap: () => _pickTime(data),
          meridiem: data.meridiem,
          onMeridiemChanged: (m) => setState(() => data.meridiem = m),
          days: data.days,
          onDaysChanged: (index, selected) => setState(
            () => data.days = [...data.days]..[index] = selected,
          ),
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
      barrierLabel: '시간 선택',
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
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
      color: AppColors.surfaceElevated,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: AppType.body2.r
                  .copyWith(color: AppColors.textSecondary)),
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
