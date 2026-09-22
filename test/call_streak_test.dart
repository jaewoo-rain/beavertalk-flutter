import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_streak.dart';

void main() {
  final today = DateTime(2026, 9, 22, 9);
  DateTime d(int day, [int h = 12]) => DateTime(2026, 9, day, h);

  test('오늘 통화 = done, 오늘부터 거꾸로 센다', () {
    final s = CallStreak.fromDates([d(22), d(21), d(20), d(18)], today);
    expect(s.state, StreakState.done);
    expect(s.days, 3);
  });

  test('오늘은 아직, 어제까지 이어짐 = pending (0 으로 떨어뜨리지 않는다)', () {
    final s = CallStreak.fromDates([d(21), d(20)], today);
    expect(s.state, StreakState.pending);
    expect(s.days, 2);
  });

  test('어제도 오늘도 없음 = broken 0', () {
    final s = CallStreak.fromDates([d(19), d(18)], today);
    expect(s.state, StreakState.broken);
    expect(s.days, 0);
  });

  test('하루에 여러 통화는 하루로 센다', () {
    final s = CallStreak.fromDates([d(22, 8), d(22, 20), d(21)], today);
    expect(s.days, 2);
  });

  test('달이 바뀌어도 이어진다', () {
    final s = CallStreak.fromDates(
      [DateTime(2026, 10, 1, 10), DateTime(2026, 9, 30, 10)],
      DateTime(2026, 10, 1, 23),
    );
    expect(s.days, 2);
  });

  test('통화 기록 없음 = broken 0', () {
    expect(CallStreak.fromDates(const [], today).days, 0);
  });
}
