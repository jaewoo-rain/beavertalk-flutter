import '../../domain/entities/alarm.dart';

/// Wire model for `AlarmOut` plus the create/update body builders.
///
/// All time/day serialization lives here so the rest of the app deals only in
/// the [Alarm] entity (wall-clock hour/minute + `days[7]` Sun..Sat).
class AlarmDto {
  const AlarmDto({
    required this.alarmId,
    this.time,
    this.isActivate,
    required this.characterId,
    this.characterName,
    this.imageUrl,
    required this.daysOfWeek,
  });

  final int alarmId;
  final String? time;
  final bool? isActivate;
  final int characterId;
  final String? characterName;
  final String? imageUrl;
  final List<String> daysOfWeek;

  /// Index → server code. UI `days[7]` is 0=Sun … 6=Sat.
  static const dayCodes = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  factory AlarmDto.fromJson(Map<String, dynamic> json) {
    final character = (json['character'] as Map<String, dynamic>?) ?? const {};
    final days = (json['days_of_week'] as List<dynamic>?) ?? const [];
    return AlarmDto(
      alarmId: json['alarm_id'] as int,
      time: json['time'] as String?,
      isActivate: json['is_activate'] as bool?,
      characterId: character['character_id'] as int? ?? 0,
      characterName: character['name'] as String?,
      imageUrl: character['image_url'] as String?,
      daysOfWeek: days.map((e) => e.toString()).toList(),
    );
  }

  /// Converts to the domain entity, decoding the wall-clock time and days.
  Alarm toEntity() {
    var hour24 = 0;
    var minute = 0;
    if (time != null && time!.isNotEmpty) {
      // Server echoes our wall clock with a Z; read UTC fields directly (no
      // local-timezone shift — that would move the displayed time).
      final dt = DateTime.parse(time!).toUtc();
      hour24 = dt.hour;
      minute = dt.minute;
    }
    final isAm = hour24 < 12;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

    final codes = daysOfWeek.toSet();
    final days = List<bool>.generate(7, (i) => codes.contains(dayCodes[i]));

    return Alarm(
      id: alarmId,
      hour: hour12,
      minute: minute,
      isAm: isAm,
      days: days,
      characterId: characterId,
      characterName: characterName,
      imageUrl: imageUrl,
      active: isActivate ?? true,
    );
  }

  /// Body for `POST /alarms` (`AlarmCreate`).
  static Map<String, dynamic> createBody(Alarm alarm) {
    return {
      'character_id': alarm.characterId,
      'time': _encodeTime(alarm),
      'is_activate': alarm.active,
      'days_of_week': _encodeDays(alarm.days),
    };
  }

  /// Body for `PUT /alarms/{id}` (`AlarmUpdate`, full payload is accepted).
  static Map<String, dynamic> updateBody(Alarm alarm) {
    return {
      'time': _encodeTime(alarm),
      'character_id': alarm.characterId,
      'is_activate': alarm.active,
      'days_of_week': _encodeDays(alarm.days),
    };
  }

  /// Encodes the wall-clock time as a naive ISO string on a fixed base date:
  /// `2000-01-01THH:MM:00` (no Z). The date part is meaningless to the server.
  static String _encodeTime(Alarm alarm) {
    final h = alarm.hour24.toString().padLeft(2, '0');
    final m = alarm.minute.toString().padLeft(2, '0');
    return '2000-01-01T$h:$m:00';
  }

  /// Selected day indices (0=Sun..6=Sat) → server codes.
  static List<String> _encodeDays(List<bool> days) {
    final out = <String>[];
    for (var i = 0; i < days.length && i < dayCodes.length; i++) {
      if (days[i]) out.add(dayCodes[i]);
    }
    return out;
  }
}

/// Wire model for `CharacterSummary` (only the picker-relevant fields).
class CharacterDto {
  const CharacterDto({
    required this.characterId,
    required this.name,
    this.imageUrl,
  });

  final int characterId;
  final String name;
  final String? imageUrl;

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  AlarmCharacter toEntity() => AlarmCharacter(
        characterId: characterId,
        name: name,
        imageUrl: imageUrl,
      );
}
