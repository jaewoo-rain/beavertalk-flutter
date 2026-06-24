import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../components/organisms/bottom_sheet_time_picker.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'alarm_models.dart';

/// Add / edit alarm — Figma `screen/etc_alarm__add` (`2117:20276`).
///
/// Hosts the [BottomSheetAlarmSettings] surface (time + AM/PM + weekday chips +
/// call partner + save). The partner list is fed by the real server characters
/// (`availableCharactersProvider`); a new alarm defaults to the first one.
///
/// Reads an optional [AlarmData] off `ModalRoute.settings.arguments`:
/// - present → **edit** mode (title "일정 수정"), pre-filled from that alarm;
/// - absent → **add** mode (title "새 일정 추가"), seeded with a default.
///
/// On save it pops with the edited [AlarmData] (the caller commits it to the
/// server); close pops with `null`.
class AlarmAddScreen extends ConsumerStatefulWidget {
  /// Creates the add/edit-alarm screen.
  const AlarmAddScreen({super.key});

  @override
  ConsumerState<AlarmAddScreen> createState() => _AlarmAddScreenState();
}

class _AlarmAddScreenState extends ConsumerState<AlarmAddScreen> {
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
            // Replaced with the first real character once loaded.
            characterId: 0,
          );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data!;
    final isEdit = ModalRoute.of(context)?.settings.arguments is AlarmData;
    final charactersAsync = ref.watch(availableCharactersProvider);

    return AppScaffold(
      background: AppColors.surface,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: charactersAsync.when(
              loading: () => const _SheetLoading(),
              error: (error, stack) => _SheetMessage(
                message: '캐릭터를 불러오지 못했어요',
                onClose: () => Navigator.pop(context),
              ),
              data: (characters) {
                if (characters.isEmpty) {
                  return _SheetMessage(
                    message: '사용 가능한 캐릭터가 없어요',
                    onClose: () => Navigator.pop(context),
                  );
                }
                _ensureCharacter(data, characters);
                return BottomSheetAlarmSettings(
                  title: isEdit ? '일정 수정' : '새 일정 추가',
                  time: data.clockLabel,
                  onTimeTap: () => setState(() => _pickingTime = true),
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
          TextButton(onPressed: onClose, child: const Text('닫기')),
        ],
      ),
    );
  }
}
