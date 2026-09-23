import 'package:beavertalk/features/normalcall/domain/entities/calendar_stats.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_streak.dart';
import 'package:beavertalk/features/normalcall/domain/entities/daily_status.dart';
import 'package:beavertalk/features/normalcall/presentation/streak_provider.dart';
import 'package:flutter_test/flutter_test.dart';

/// 서버 `premium` 브랜치(09-23) §5·§7 — 「키 없음 ≠ 0」.
void main() {
  group('CalendarStats', () {
    final json = {
      'days': [
        {'date': '2026-09-22', 'sentences': 6, 'words': 132, 'call_count': 2, 'call_minutes': 14},
        {'date': '2026-09-23', 'sentences': 3, 'call_count': 1, 'call_minutes': 5},
      ],
      'total': {'sentences': 9, 'words': 132, 'call_count': 3, 'call_days': 2, 'call_minutes': 19},
      'streak_days': 2,
    };

    test('words 키가 없으면 null — 0 으로 채우지 않는다', () {
      final s = CalendarStats.tryParse(json)!;
      expect(s.days[0].words, 132);
      expect(s.days[1].words, isNull);
      expect(s.total.callDays, 2);
      expect(s.streakDays, 2);
    });

    test('streak_days 키가 없으면 null(끊김)', () {
      final s = CalendarStats.tryParse({...json}..remove('streak_days'))!;
      expect(s.streakDays, isNull);
    });

    test('모양이 틀리면 null — 호출부가 종전 계산으로 간다', () {
      expect(CalendarStats.tryParse(null), isNull);
      expect(CalendarStats.tryParse({'days': 'x'}), isNull);
    });

    test('서버 연속일 → 칩: 오늘 칸이 있으면 done, 없으면 pending, 키 없으면 broken', () {
      final s = CalendarStats.tryParse(json)!;
      final done = streakFromServer(s, DateTime(2026, 9, 23, 20));
      expect((done.days, done.state), (2, StreakState.done));

      final pending = streakFromServer(s, DateTime(2026, 9, 24, 8));
      expect(pending.state, StreakState.pending);

      final broken = streakFromServer(
          CalendarStats.tryParse({...json}..remove('streak_days'))!,
          DateTime(2026, 9, 23));
      expect((broken.days, broken.state), (0, StreakState.broken));
    });
  });

  group('DailyStatus', () {
    test('예산 세 키는 한 묶음 — 없으면 셋 다 null(면제)', () {
      final s = DailyStatus.tryParse({'called_today': true, 'can_call_normal': true})!;
      expect(s.hasBudget, isFalse);
      expect(s.remainingSec, isNull);
    });

    test('신서버 예산', () {
      final s = DailyStatus.tryParse(
          {'budget_s': 900, 'used_s': 480, 'remaining_s': 420, 'max_fragments': 3})!;
      expect((s.budgetSec, s.usedSec, s.remainingSec), (900, 480, 420));
      expect(s.hasBudget, isTrue);
    });

    test('remaining_s 가 0 이면 0 — 「다 씀」 과 「면제」 를 가른다', () {
      final s = DailyStatus.tryParse({'budget_s': 300, 'used_s': 300, 'remaining_s': 0})!;
      expect(s.remainingSec, 0);
      expect(s.hasBudget, isTrue);
    });
  });
}
