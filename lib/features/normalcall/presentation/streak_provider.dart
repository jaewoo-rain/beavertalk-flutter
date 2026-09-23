import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/call_result.dart';
import '../domain/entities/call_streak.dart';
import 'normalcall_providers.dart';

/// 최근 통화 기록 — 홈 불꽃 칩(연속일)과 학습 달력이 **같은 목록**을 본다.
///
/// `GET /calls` 를 최신순으로 100건씩(서버 상한 `PageParams.limit le=100`) 읽는다. 두 조건을
/// 모두 채우면 멈춘다: ①읽은 범위 안에서 연속이 끊겼다 ②이번 달 1일보다 오래된 통화까지
/// 읽었다(달력이 이번 달을 그린다). 쪽 수는 [_maxPages] 로 막는다 — 서버에 연속일·달력
/// API 가 생기면 이 전부가 한 줄로 바뀐다(남은판단 S4).
///
/// ⚠ 새로 읽게 하려면 **이것을** 무효화하라. [callStreakProvider] 만 무효화하면 이 목록이
///   캐시로 남아 옛 날짜로 다시 센다.
final callHistoryProvider = FutureProvider.autoDispose<List<CallSummary>>((
  ref,
) async {
  final repo = ref.watch(normalcallRepositoryProvider);
  const pageSize = 100;
  final all = <CallSummary>[];
  final today = DateTime.now();
  final monthStart = DateTime(today.year, today.month);
  for (var page = 0; page < _maxPages; page++) {
    final calls = await repo.listCalls(
      limit: pageSize,
      offset: page * pageSize,
    );
    all.addAll(calls);
    if (calls.length < pageSize) break;
    final dates = all.map((c) => c.callDate).whereType<DateTime>().toList();
    // 날짜가 하나도 없으면(전부 null) 더 볼 것이 없다 — 아래 reduce 가 빈 목록에서 던진다.
    if (dates.isEmpty) break;
    final streak = CallStreak.fromDates(dates, today);
    final oldest = dates
        .map((d) => d.toLocal())
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final oldestDay = DateTime(oldest.year, oldest.month, oldest.day);
    final reach = DateTime(today.year, today.month, today.day - streak.days);
    if (oldestDay.isBefore(reach) && oldestDay.isBefore(monthStart)) break;
  }
  return all;
});

/// 학습 달력의 「최고 기록」 — 통화 기록을 [_maxPages] 끝까지 읽어 가장 긴 연속일을 센다.
///
/// [callHistoryProvider] 는 현재 연속과 이번 달만 채우면 멈추므로 옛 기록이 빠진다. 최고 기록은
/// 전 기간이 필요해 따로 읽는다(달력 화면에서만 본다 — 홈은 이 비용을 내지 않는다).
/// ⚠ 상한(400건)을 넘는 오래된 기록은 못 본다 — 서버 연속일 API(남은판단 S4)가 생기면 대체한다.
final bestStreakProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(normalcallRepositoryProvider);
  const pageSize = 100;
  final dates = <DateTime>[];
  for (var page = 0; page < _maxPages; page++) {
    final calls = await repo.listCalls(
      limit: pageSize,
      offset: page * pageSize,
    );
    dates.addAll(calls.map((c) => c.callDate).whereType<DateTime>());
    if (calls.length < pageSize) break;
  }
  return CallStreak.bestDays(dates);
});

/// 홈 불꽃 칩의 연속일 — [callHistoryProvider] 의 날짜로 앱이 센다.
final callStreakProvider = FutureProvider.autoDispose<CallStreak>((ref) async {
  final calls = await ref.watch(callHistoryProvider.future);
  return CallStreak.fromDates(
    calls.map((c) => c.callDate).whereType<DateTime>(),
    DateTime.now(),
  );
});

/// 최대 쪽 수 — 100건 × 4 = 400건. 하루 1통화(무료)면 1년 넘게 센다.
/// ⚠ 하루 여러 통화하는 사용자는 **적게 센다** — Premium 은 하루 최대 3통화라 매일 꽉
///   채우면 400건이 133일에서 찬다(실제 200일이어도 133일로 보인다). 가장 열심히 쓴 사람이 손해 보는 자리라, 서버 연속일
///   API 제안(남은판단 S4)의 근거다.
const _maxPages = 4;
