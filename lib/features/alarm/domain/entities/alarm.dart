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
