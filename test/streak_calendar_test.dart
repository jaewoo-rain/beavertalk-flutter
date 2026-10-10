import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/screens/home/streak_calendar.dart';

void main() {
  test('monthWeeks — 1일의 요일과 로케일의 주 시작 요일이 맞는다', () {
    // 2026-09-01 은 화요일. 일요일 시작이면 앞 빈칸 2, 월요일 시작이면 1.
    final sun = monthWeeks(DateTime(2026, 9), 0);
    expect(sun.first.take(3).toList(), [null, null, DateTime(2026, 9, 1)]);
    final mon = monthWeeks(DateTime(2026, 9), 1);
    expect(mon.first.take(2).toList(), [null, DateTime(2026, 9, 1)]);
    expect(sun.expand((w) => w).whereType<DateTime>().length, 30);
    for (final w in [...sun, ...mon]) {
      expect(w.length, 7);
    }
  });

  test('monthWeeks — 2월(28일)이 일요일에 시작하면 딱 4주', () {
    // 2026-02-01 은 일요일.
    expect(monthWeeks(DateTime(2026, 2), 0).length, 4);
  });

  test('callsByDay — 현지 날짜로 묶고, 날짜 없는 통화는 버린다', () {
    CallSummary c(int id, DateTime? d) => CallSummary(
          callId: id,
          character: const CallCharacterBrief(characterId: 1, name: 'Baba'),
          callDate: d,
        );
    final m = callsByDay([
      c(1, DateTime(2026, 9, 22, 21)),
      c(2, DateTime(2026, 9, 22, 8)),
      c(3, DateTime(2026, 9, 21, 23, 59)),
      c(4, null),
    ]);
    expect(m.keys.toSet(), {DateTime(2026, 9, 22), DateTime(2026, 9, 21)});
    expect(m[DateTime(2026, 9, 22)]!.map((x) => x.callId), [1, 2]);
  });
}
