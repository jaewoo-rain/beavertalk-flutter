import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/organisms/bottom_sheet_alarm_add.dart';
import '../../components/organisms/bottom_sheet_alarm_settings.dart' show Meridiem;
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import 'alarm_days.dart';
import 'alarm_models.dart';

/// Add / edit alarm — Figma `screen/etc_alarm__add` (`6222:20710`, 09-22 개편:
/// 24시간 휠 · 반복·통화 상대 인라인 펼침 · 빠른 시작 프리셋 삭제).
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

/// The add/edit-alarm content — the [BottomSheetAlarmAdd] surface (24-hour
/// wheel + repeat days + call partner + save) plus its state wiring.
///
/// Designed to size to its own content (`mainAxisSize.min`) so it works as a
/// **modal bottom-sheet body** (present it via `showModalBottomSheet` with
/// `isScrollControlled: true` and `backgroundColor: Colors.transparent`) as
/// well as inside a bottom-aligned page host ([AlarmAddScreen]).
///
/// The partner list is fed by the real server characters
/// (`availableCharactersProvider`); a new alarm defaults to the first one.
///
/// - [initial] present → **edit** mode (title 「알람 수정」), seeded from a copy
///   of that alarm; absent → **add** mode (title 「알람 추가」).
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
          // Sun-indexed (0=Sun..6=Sat); a new alarm starts on weekdays (Figma 평일).
          days: [false, true, true, true, true, true, false],
          // Replaced with the first real character once loaded.
          characterId: 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
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
        return BottomSheetAlarmAdd(
          title: _isEdit ? l10n.alarmEdit : l10n.alarmAdd,
          cancelText: l10n.cancel,
          saveText: l10n.save,
          repeatLabel: l10n.repeat,
          partnerLabel: l10n.callPartner,
          hour24: data.hour24,
          minute: data.minute,
          // 휠이 멈출 때마다 다시 그리면 휠이 제자리로 튄다 — 값만 적고 그리지 않는다.
          onTimeChanged: (h, m) {
            data
              ..hour24 = h
              ..minute = m;
          },
          days: data.days,
          dayLabels: AlarmDays.shortLabels(locale),
          daysSummary: AlarmDays.summary(data.days, l10n, locale),
          onDayToggled: (index, on) =>
              setState(() => data.days = [...data.days]..[index] = on),
          partners: partnersFromCharacters(characters),
          partner: data.characterId.toString(),
          onPartnerChanged: (id) => setState(() {
            data.characterId = int.tryParse(id) ?? data.characterId;
            data.characterName = characters
                .firstWhere((c) => c.characterId.toString() == id)
                .name;
          }),
          onSave: () => Navigator.pop(context, data),
          onCancel: () => Navigator.pop(context),
          // 서버 `Alarm.call_type`. 알람 통화는 서버가 이 모드로 시작한다(앱은 싣지 않는다).
          callMode: data.callMode,
          onCallModeChanged: (m) => setState(() => data.callMode = m),
          learnModeTitle: l10n.homeModeLearn,
          learnModeSubtitle: l10n.alarmModeLearnSub,
          chatModeTitle: l10n.callModeFreeTalk,
          chatModeSubtitle: l10n.alarmModeChatSub,
        );
      },
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
    // 배경 띠는 전폭, 글만 콘텐츠 컬럼 — 색 면이 좁아지면 띠가 아니라 카드로
    // 보인다.
    return Container(
      width: double.infinity,
      color: context.c.backgroundElevatedAlternative,
      child: ContentColumn(
        padding: const EdgeInsets.only(top: 32, bottom: 32),
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
      ),
    );
  }
}
