// Round-trip tests for AlarmDto time/days mapping (the load-bearing logic).

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/alarm/data/models/alarm_dto.dart';
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';

void main() {
  group('AlarmDto time/days round-trip', () {
    test('parses server AlarmOut into wall-clock entity', () {
      final dto = AlarmDto.fromJson({
        'alarm_id': 1,
        'time': '2026-06-24T07:30:00Z',
        'is_activate': true,
        'character': {'character_id': 1, 'name': '비비', 'image_url': null},
        'days_of_week': ['MON', 'WED', 'FRI'],
      });
      final alarm = dto.toEntity();

      expect(alarm.hour, 7); // 07:30 AM, wall-clock (no tz shift)
      expect(alarm.minute, 30);
      expect(alarm.isAm, isTrue);
      // days[7] is 0=Sun..6=Sat → Mon=1, Wed=3, Fri=5.
      expect(alarm.days, [false, true, false, true, false, true, false]);
      expect(alarm.characterId, 1);
      expect(alarm.characterName, '비비');
      expect(alarm.active, isTrue);
    });

    test('parses PM time keeping wall-clock hours', () {
      final dto = AlarmDto.fromJson({
        'alarm_id': 2,
        'time': '2000-01-01T18:00:00Z',
        'is_activate': false,
        'character': {'character_id': 1, 'name': '비비'},
        'days_of_week': <String>[],
      });
      final alarm = dto.toEntity();

      expect(alarm.hour, 6); // 18:00 → 6 PM
      expect(alarm.minute, 0);
      expect(alarm.isAm, isFalse);
      expect(alarm.days, List.filled(7, false));
      expect(alarm.active, isFalse);
    });

    test('encodes create body as naive wall-clock ISO + day codes', () {
      const alarm = Alarm(
        hour: 7,
        minute: 30,
        isAm: true,
        // Sun..Sat → Mon, Wed, Fri selected.
        days: [false, true, false, true, false, true, false],
        characterId: 1,
      );
      final body = AlarmDto.createBody(alarm);

      expect(body['time'], '2000-01-01T07:30:00'); // 24h, no Z
      expect(body['character_id'], 1);
      expect(body['is_activate'], isTrue);
      expect(body['days_of_week'], ['MON', 'WED', 'FRI']);
    });

    test('encodes 12 AM / 12 PM boundaries to 00 / 12 hours', () {
      const midnight = Alarm(
        hour: 12,
        minute: 0,
        isAm: true,
        days: [false, false, false, false, false, false, false],
        characterId: 1,
      );
      const noon = Alarm(
        hour: 12,
        minute: 0,
        isAm: false,
        days: [false, false, false, false, false, false, false],
        characterId: 1,
      );

      expect(AlarmDto.createBody(midnight)['time'], '2000-01-01T00:00:00');
      expect(AlarmDto.createBody(noon)['time'], '2000-01-01T12:00:00');
    });

    test('full round-trip: entity → create body → fromJson → entity', () {
      const original = Alarm(
        hour: 9,
        minute: 15,
        isAm: false, // 9 PM → 21:15
        days: [true, false, false, false, false, false, true], // Sun + Sat
        characterId: 1,
      );
      final body = AlarmDto.createBody(original);

      // Simulate the server echoing our wall clock back with a Z suffix.
      final echoed = AlarmDto.fromJson({
        'alarm_id': 9,
        'time': '${body['time']}Z',
        'is_activate': body['is_activate'],
        'character': {'character_id': body['character_id'], 'name': '비비'},
        'days_of_week': body['days_of_week'],
      });
      final restored = echoed.toEntity();

      expect(restored.hour, original.hour);
      expect(restored.minute, original.minute);
      expect(restored.isAm, original.isAm);
      expect(restored.days, original.days);
      expect(restored.characterId, original.characterId);
    });
  });
}
