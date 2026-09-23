/// 알람 통화의 모드 — 서버 `Alarm.call_type`(dev·운영 배포 09-24).
///
/// 알람 통화는 `start.inbound_call_id` 로 서버가 알람을 되짚어 **이 모드로 시작**한다 — 앱이
/// 통화 프레임에 `call_type` 을 실을 필요가 없다. 예외: 레벨 미확정 회원은 모드와 무관하게
/// 레벨테스트가 먼저다(서버 회신).
enum AlarmCallMode {
  /// 학습 — 서버가 진도로 코스를 정한다(홈 학습 버튼과 같음). 서버 기본값.
  learn('auto'),

  /// 자유대화(홈 대화 버튼과 같음).
  chat('chat');

  const AlarmCallMode(this.wireValue);

  /// 서버 문자열. 그 밖의 값을 보내면 서버가 422 를 준다.
  final String wireValue;

  /// 서버 값 → 모드. 모르는 값·null 은 [learn](서버 기본값과 같다).
  static AlarmCallMode fromWire(Object? raw) =>
      raw == AlarmCallMode.chat.wireValue ? AlarmCallMode.chat : AlarmCallMode.learn;
}

/// A repeating call alarm. Pure Dart — no Flutter/dio/JSON knowledge.
///
/// Time is held as a wall-clock 12-hour value ([hour] 1–12 + [minute] + [isAm])
/// so it drives the editor clock and list label directly. [days] is 7 booleans
/// indexed **0=Sun … 6=Sat**.
class Alarm {
  const Alarm({
    this.id,
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.days,
    required this.characterId,
    this.characterName,
    this.imageUrl,
    this.active = true,
    this.callMode = AlarmCallMode.learn,
  });

  /// Server primary key (null before the alarm is created).
  final int? id;

  /// Hour in 12-hour form (1–12).
  final int hour;

  /// Minute (0–59).
  final int minute;

  /// AM when true, PM when false.
  final bool isAm;

  /// 7 booleans (0=Sun … 6=Sat) — which weekdays repeat.
  final List<bool> days;

  /// Selected character id (required by the server on create).
  final int characterId;

  /// Display name of the character (from the server on read).
  final String? characterName;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// Whether the alarm is enabled.
  final bool active;

  /// 이 알람 통화의 모드(학습 · 자유대화).
  final AlarmCallMode callMode;

  /// Hour in 24-hour form (0–23) derived from [hour]/[isAm].
  int get hour24 {
    if (isAm) return hour % 12; // 12am → 0
    return hour % 12 + 12; // 12pm → 12, 1pm → 13
  }

  /// Returns a copy with selected fields replaced.
  Alarm copyWith({
    int? id,
    int? hour,
    int? minute,
    bool? isAm,
    List<bool>? days,
    int? characterId,
    String? characterName,
    String? imageUrl,
    bool? active,
    AlarmCallMode? callMode,
  }) {
    return Alarm(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isAm: isAm ?? this.isAm,
      days: days ?? this.days,
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      imageUrl: imageUrl ?? this.imageUrl,
      active: active ?? this.active,
      callMode: callMode ?? this.callMode,
    );
  }
}

/// A purchasable/selectable character (alarm partner picker source). Pure Dart.
class AlarmCharacter {
  const AlarmCharacter({
    required this.characterId,
    required this.name,
    this.imageUrl,
  });

  final int characterId;
  final String name;
  final String? imageUrl;
}
