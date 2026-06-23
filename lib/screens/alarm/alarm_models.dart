import '../../components/organisms/bottom_sheet_alarm_settings.dart';
import '../../mock/mock_data.dart';

/// A single alarm/schedule entry shared between the list ([AlarmListScreen]) and
/// the add/edit sheet ([AlarmAddScreen]).
///
/// Time is held as a 12-hour [hour] (1–12) + [minute] + [meridiem] so it can
/// drive both the big clock label ("8:00") in the editor and the prefixed list
/// label ("AM 8:00") on the card.
class AlarmData {
  /// Creates an alarm entry.
  AlarmData({
    required this.hour,
    required this.minute,
    required this.meridiem,
    required this.days,
    required this.partnerId,
    this.active = true,
  });

  /// Hour in 12-hour form (1–12).
  int hour;

  /// Minute (0–59).
  int minute;

  /// AM / PM.
  Meridiem meridiem;

  /// 7 booleans (Sun→Sat) — which weekdays repeat.
  List<bool> days;

  /// Selected call-partner id (see [kAlarmPartners]).
  String partnerId;

  /// Whether the alarm is enabled.
  bool active;

  /// "8:00" — the editor clock face.
  String get clockLabel => '$hour:${minute.toString().padLeft(2, '0')}';

  /// "AM 8:00" — the list card label.
  String get listLabel =>
      '${meridiem == Meridiem.am ? 'AM' : 'PM'} $clockLabel';

  /// Display name of the selected partner.
  String get partnerName => partnerNameOf(partnerId);

  /// A deep copy (so edits can be staged then committed/discarded).
  AlarmData copy() => AlarmData(
        hour: hour,
        minute: minute,
        meridiem: meridiem,
        days: [...days],
        partnerId: partnerId,
        active: active,
      );
}

/// The available call partners for an alarm.
const List<AlarmPartner> kAlarmPartners = [
  AlarmPartner(
      id: 'beaver', name: 'Annoying Beaver', imageProvider: beaverImage),
  AlarmPartner(id: 'judi', name: 'Judi', imageProvider: judiImage),
];

/// Resolves a partner id to its display name (falls back to the id).
String partnerNameOf(String id) {
  for (final p in kAlarmPartners) {
    if (p.id == id) return p.name;
  }
  return id;
}
