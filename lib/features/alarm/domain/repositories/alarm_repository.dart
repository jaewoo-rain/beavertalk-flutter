import '../entities/alarm.dart';

/// Alarm capabilities the app depends on. Implemented in the data layer.
///
/// All methods return entities and throw [AppException]
/// (see `core/error/app_exception.dart`) on failure. No dio/JSON leaks here.
abstract interface class AlarmRepository {
  /// `GET /alarms` — all alarms for the current member.
  Future<List<Alarm>> list();

  /// `POST /alarms` — creates an alarm, returns the server copy.
  Future<Alarm> create(Alarm alarm);

  /// `GET /alarms/{id}` — a single alarm.
  Future<Alarm> get(int id);

  /// `PUT /alarms/{id}` — partial update; returns the updated alarm.
  Future<Alarm> update(Alarm alarm);

  /// `DELETE /alarms/{id}`.
  Future<void> delete(int id);

  /// `POST /alarms/{id}/activate` — enables the alarm.
  Future<Alarm> activate(int id);

  /// `POST /alarms/{id}/deactivate` — disables the alarm.
  Future<Alarm> deactivate(int id);

  /// `GET /characters` — selectable alarm partners (read-only here).
  Future<List<AlarmCharacter>> listCharacters();
}
