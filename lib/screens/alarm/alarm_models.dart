import 'package:flutter/widgets.dart';

import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../mock/mock_data.dart';

/// A single alarm/schedule entry shared between the list ([AlarmListScreen]) and
/// the add/edit sheet ([AlarmAddScreen]).
///
/// Time is held as a 12-hour [hour] (1–12) + [minute] + [meridiem] so it can
/// drive both the big clock label ("8:00") in the editor and the prefixed list
/// label ("AM 8:00") on the card.
///
/// This is the editor *view-model*; it converts to/from the server [Alarm]
/// entity via [toEntity] / [AlarmData.fromEntity].
class AlarmData {
  /// Creates an alarm entry.
  AlarmData({
    this.id,
    required this.hour,
    required this.minute,
    required this.meridiem,
    required this.days,
    required this.characterId,
    this.characterName,
    this.imageUrl,
    this.active = true,
  });

  /// Server alarm id (null in add mode, set in edit mode).
  int? id;

  /// Hour in 12-hour form (1–12).
  int hour;

  /// Minute (0–59).
  int minute;

  /// AM / PM.
  Meridiem meridiem;

  /// 7 booleans (Sun→Sat) — which weekdays repeat.
  List<bool> days;

  /// Selected character id (server `character_id`, required on create).
  int characterId;

  /// Display name of the selected character (from the server).
  String? characterName;

  /// Optional avatar URL from the server (null → static fallback).
  String? imageUrl;

  /// Whether the alarm is enabled.
  bool active;

  /// "8:00" — the editor clock face.
  String get clockLabel => '$hour:${minute.toString().padLeft(2, '0')}';

  /// "AM 8:00" — the list card label.
  String get listLabel =>
      '${meridiem == Meridiem.am ? 'AM' : 'PM'} $clockLabel';

  /// Display name of the selected partner (falls back to a generic label).
  String get partnerName => characterName ?? '캐릭터';

  /// A deep copy (so edits can be staged then committed/discarded).
  AlarmData copy() => AlarmData(
        id: id,
        hour: hour,
        minute: minute,
        meridiem: meridiem,
        days: [...days],
        characterId: characterId,
        characterName: characterName,
        imageUrl: imageUrl,
        active: active,
      );

  /// Builds an editor view-model from a server [Alarm] entity.
  factory AlarmData.fromEntity(Alarm a) => AlarmData(
        id: a.id,
        hour: a.hour,
        minute: a.minute,
        meridiem: a.isAm ? Meridiem.am : Meridiem.pm,
        days: [...a.days],
        characterId: a.characterId,
        characterName: a.characterName,
        imageUrl: a.imageUrl,
        active: a.active,
      );

  /// Converts back to a server [Alarm] entity for create/update.
  Alarm toEntity() => Alarm(
        id: id,
        hour: hour,
        minute: minute,
        isAm: meridiem == Meridiem.am,
        days: [...days],
        characterId: characterId,
        characterName: characterName,
        imageUrl: imageUrl,
        active: active,
      );
}

/// Builds the partner-picker items from server characters. The picker's string
/// id is the stringified `character_id`. Falls back to [beaverImage] when the
/// server provides no avatar URL.
List<AlarmPartner> partnersFromCharacters(List<AlarmCharacter> characters) {
  return [
    for (final c in characters)
      AlarmPartner(
        id: c.characterId.toString(),
        name: c.name,
        imageProvider: _imageFor(c.imageUrl),
      ),
  ];
}

/// Network avatar when available, else the static beaver asset.
ImageProvider<Object> _imageFor(String? url) {
  if (url != null && url.isNotEmpty) return NetworkImage(url);
  return beaverImage;
}
