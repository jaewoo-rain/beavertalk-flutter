import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_alarm.dart';
import '../../components/molecules/card_alarm_loading.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_list_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'alarm_add.dart';
import 'alarm_empty.dart';
import 'alarm_models.dart';

/// Alarm list — Figma `screen/etc_alarm` (`3665:11992`). A scrollable list of
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
    final message = error is AppException
        ? error.message
        : AppLocalizations.of(context).somethingWentWrong;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Runs a controller mutation, showing any failure as a snackbar.
  ///
  /// Returns `true` when [action] completed and `false` when it threw. Callers
  /// that must not proceed on failure need this: `Dismissible.confirmDismiss`
  /// used to `return true` unconditionally because the error was swallowed here,
  /// so a failed DELETE still animated the card away while the controller state
  /// kept the alarm — tripping Flutter's "dismissed Dismissible is still part of
  /// the tree" assertion, and the alarm still rang.
  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (e) {
      _showError(e);
      return false;
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
      // Flutter defaults the barrier to black @ 54%; pin it to the app scrim
      // so every dim in the product is the same black @ 50%.
      barrierColor: AppColors.scrim,
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
      barrierColor: AppColors.scrim,
      builder: (_) => AlarmAddSheet(initial: AlarmData.fromEntity(alarm)),
    );
    if (result == null) return;
    await _run(() =>
        ref.read(alarmListControllerProvider.notifier).edit(result.toEntity()));
  }

  @override
  Widget build(BuildContext context) {
    final alarmsAsync = ref.watch(alarmListControllerProvider);
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
              title: l10n.scheduleManagement,
              onBack: () => Navigator.pop(context)),
          // "Alarms" subheader with an add (+) action.
          Padding(
            // 24 below the GNB (`3665:12005` sits at Body y24), not 8.
            padding: const EdgeInsets.fromLTRB(20, 24, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  // Headline 1 (18 SemiBold), not Heading 2's 20.
                  child: Text(l10n.alarms,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppType.headline1.sb
                          .copyWith(color: AppColors.text)),
                ),
                IconButton(
                  onPressed: _add,
                  icon: AppIcons.plus(color: AppColors.text),
                  tooltip: l10n.addSchedule,
                ),
              ],
            ),
          ),
          Expanded(
            child: alarmsAsync.when(
              loading: () => const _AlarmsLoading(),
              error: (e, _) => _ErrorState(
                message: e is AppException ? e.message : l10n.alarmsLoadError,
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
                text: l10n.addSchedule,
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
            // Only let the card go if the server actually deleted it. The
            // controller mutates state after a successful DELETE, so dismissing
            // on failure would desync the list from itemCount and the alarm
            // would reappear on the next refetch — still ringing meanwhile.
            return _run(() =>
                ref.read(alarmListControllerProvider.notifier).remove(id));
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

  /// The "delete" affordance revealed when swiping a card left — a single red
  /// 48 circle holding a 24 trash glyph, centred on the card (`3665:12016`).
  ///
  /// The frame reveals the circle against the screen, not a full-height red
  /// panel behind the card, which is what this used to paint.
  Widget _deleteBackground() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          child: AppIcons.trash(color: AppColors.text, size: 24),
        ),
      ),
    );
  }
}

/// The waiting state — Figma `screen/etc_alarm_loading` (`3489:4550`).
///
/// Two [CardAlarmLoading]s on the list's own padding and gap, so the real cards
/// drop straight in. Two, as the frame draws: the alarm count is exactly what
/// is loading, and a longer stack would guess at it.
class _AlarmsLoading extends StatelessWidget {
  const _AlarmsLoading();

  @override
  Widget build(BuildContext context) => const SkeletonShimmer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardAlarmLoading(),
              SizedBox(height: 20),
              CardAlarmLoading(),
            ],
          ),
        ),
      );
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
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}
