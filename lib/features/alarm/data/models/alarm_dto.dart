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
    this.callType,
    this.tz,
  });

  final int alarmId;
  final String? time;
  final bool? isActivate;
  final int characterId;
  final String? characterName;
  final String? imageUrl;
  final List<String> daysOfWeek;

  /// 서버 `call_type` — "auto" | "chat"(09-24 배포). 구서버·누락이면 null → 학습.
  final String? callType;

  /// 서버에 저장된 알람 시간대(IANA). 비어 있으면 서버가 서울 기준으로 울린다(F008).
  final String? tz;

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
      callType: json['call_type'] as String?,
      tz: json['tz'] as String?,
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
      callMode: AlarmCallMode.fromWire(callType),
    );
  }

  /// Body for `POST /alarms` (`AlarmCreate`).
  ///
  /// [tz] 는 기기 IANA 시간대 — 알람은 기기 현지 시각으로 울려야 한다(F008 · PM-DEC-167).
  /// `tz_offset_min` 은 보내지 않는다(서버 범위 검사 §25 · PM 지시). 모르면 키를 뺀다.
  static Map<String, dynamic> createBody(Alarm alarm, {String? tz}) {
    return {
      'tz': ?tz,
      'character_id': alarm.characterId,
      'time': _encodeTime(alarm),
      'is_activate': alarm.active,
      'days_of_week': _encodeDays(alarm.days),
      // 서버 `AlarmCreate.call_type: Literal["auto","chat"] = "auto"`.
      'call_type': alarm.callMode.wireValue,
    };
  }

  /// Body for `PUT /alarms/{id}` (`AlarmUpdate`, full payload is accepted).
  static Map<String, dynamic> updateBody(Alarm alarm, {String? tz}) {
    return {
      'tz': ?tz,
      'time': _encodeTime(alarm),
      'character_id': alarm.characterId,
      'is_activate': alarm.active,
      'days_of_week': _encodeDays(alarm.days),
      // 서버 `AlarmUpdate.call_type`(부분 갱신) — 전체 페이로드라 항상 싣는다.
      'call_type': alarm.callMode.wireValue,
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
