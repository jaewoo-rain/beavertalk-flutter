import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_alarm.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_list_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import 'alarm_add.dart';
import 'alarm_empty.dart';
import 'alarm_models.dart';

/// Alarm list — Figma `screen/etc_alarm` (`2117:20250`). A scrollable list of
/// [CardAlarm]s backed by the server (`alarmListControllerProvider`). Each card
/// can be **swiped** to delete (DELETE), **tapped** to edit (PUT), and toggled
/// active (activate/deactivate) or per-day (PUT). The footer "+" adds (POST).
class AlarmListScreen extends ConsumerStatefulWidget {
  /// Creates the alarm list screen.
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  /// Surfaces a repository [AppException] as a snackbar.
  void _showError(Object error) {
    if (!mounted) return;
    final message =
        error is AppException ? error.message : '문제가 발생했어요';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Runs a controller mutation, showing any failure as a snackbar.
  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      _showError(e);
    }
  }

  /// Opens the add sheet as a modal bottom sheet; creates the result (POST) if
  /// the user saved. `isScrollControlled` lets the sheet + its inner time-picker
  /// size correctly and rise above the keyboard.
  Future<void> _add() async {
    final result = await showModalBottomSheet<AlarmData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AlarmAddSheet(),
    );
    if (result == null) return;
    await _run(() =>
        ref.read(alarmListControllerProvider.notifier).add(result.toEntity()));
  }

  /// Opens the edit sheet (modal bottom sheet) seeded with [alarm]; updates it
  /// (PUT) on save.
  Future<void> _edit(Alarm alarm) async {
    final result = await showModalBottomSheet<AlarmData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlarmAddSheet(initial: AlarmData.fromEntity(alarm)),
    );
    if (result == null) return;
    await _run(() =>
        ref.read(alarmListControllerProvider.notifier).edit(result.toEntity()));
  }

  @override
  Widget build(BuildContext context) {
    final alarmsAsync = ref.watch(alarmListControllerProvider);

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
                  icon: AppIcons.plus(color: AppColors.text),
                  tooltip: '새 일정 추가',
                ),
              ],
            ),
          ),
          Expanded(
            child: alarmsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => _ErrorState(
                message: e is AppException ? e.message : '알람을 불러오지 못했어요',
                onRetry: () => ref.invalidate(alarmListControllerProvider),
              ),
              data: (alarms) => alarms.isEmpty
                  ? const _EmptyState()
                  : _list(alarms),
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

  /// The scrollable alarm cards.
  Widget _list(List<Alarm> alarms) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: alarms.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, i) {
        final a = alarms[i];
        final view = AlarmData.fromEntity(a);
        final id = a.id;
        return Dismissible(
          key: ValueKey(id ?? i),
          direction: DismissDirection.endToStart,
          background: _deleteBackground(),
          confirmDismiss: (_) async {
            if (id == null) return false;
            await _run(() =>
                ref.read(alarmListControllerProvider.notifier).remove(id));
            return true;
          },
          child: CardAlarm(
            state: a.active ? CardAlarmState.active : CardAlarmState.inactive,
            time: view.listLabel,
            days: a.days,
            userName: view.partnerName,
            onTap: () => _edit(a),
            onChanged: id == null
                ? null
                : (v) => _run(() => ref
                    .read(alarmListControllerProvider.notifier)
                    .toggleActive(id, v)),
            onDayChange: id == null
                ? null
                : (idx, v) => _run(() => ref
                    .read(alarmListControllerProvider.notifier)
                    .toggleDay(id, idx, v)),
          ),
        );
      },
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
      child: AppIcons.trash(color: AppColors.text, size: 28),
    );
  }
}

/// Empty list — reuses the [AlarmEmptyScreen] body styling inline.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    // Reuse the existing empty screen's centered message block.
    return const Center(child: AlarmEmptyBody());
  }
}

/// Inline error with a retry action.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: AppType.body2.r
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
