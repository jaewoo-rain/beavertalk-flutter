import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import 'alarm_providers.dart';

/// Owns the alarm list. Loads on build, then each mutation calls the API and
/// refreshes state from the returned `AlarmOut` (server-trusted, not optimistic).
final alarmListControllerProvider =
    AsyncNotifierProvider<AlarmListController, List<Alarm>>(
  AlarmListController.new,
);

class AlarmListController extends AsyncNotifier<List<Alarm>> {
  AlarmRepository get _repo => ref.read(alarmRepositoryProvider);

  @override
  Future<List<Alarm>> build() => _repo.list();

  List<Alarm> get _current => state.value ?? const [];

  /// Creates an alarm (POST) and appends the server copy.
  Future<void> add(Alarm alarm) async {
    final created = await _repo.create(alarm);
    state = AsyncData([..._current, created]);
  }

  /// Updates an alarm (PUT) and replaces it in place.
  ///
  /// Named `edit` (not `update`) to avoid clashing with [AsyncNotifier.update].
  Future<void> edit(Alarm alarm) async {
    final updated = await _repo.update(alarm);
    state = AsyncData([
      for (final a in _current) a.id == updated.id ? updated : a,
    ]);
  }

  /// Deletes an alarm (DELETE) and drops it from the list.
  Future<void> remove(int id) async {
    await _repo.delete(id);
    state = AsyncData([for (final a in _current) if (a.id != id) a]);
  }

  /// Toggles activation (activate/deactivate) and replaces the alarm.
  Future<void> toggleActive(int id, bool active) async {
    final updated =
        active ? await _repo.activate(id) : await _repo.deactivate(id);
    state = AsyncData([
      for (final a in _current) a.id == updated.id ? updated : a,
    ]);
  }

  /// Flips a single weekday (PUT with the new day set).
  Future<void> toggleDay(int id, int dayIndex, bool selected) async {
    final target = _current.firstWhere((a) => a.id == id);
    final nextDays = [...target.days];
    if (dayIndex >= 0 && dayIndex < nextDays.length) {
      nextDays[dayIndex] = selected;
    }
    await edit(target.copyWith(days: nextDays));
  }
}
