import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/call_streak.dart';
import 'normalcall_providers.dart';

/// 홈 불꽃 칩의 연속일 — `GET /calls` 를 최신순으로 읽어 앱이 센다.
///
/// 한 번에 100건(서버 상한 `PageParams.limit le=100`)을 읽고, 읽은 범위의 **가장
/// 오래된 날까지 연속이 이어져 있으면** 다음 쪽을 더 읽는다. 끊긴 날이 범위 안에
/// 들어오면 거기서 멈춘다. 쪽 수는 [_maxPages] 로 막는다 — 서버에 연속일 API 가
/// 생기면 이 전부가 한 줄로 바뀐다(남은판단 문서 S4).
///
/// autoDispose: 통화가 끝나면 홈이 [curMeProvider] 와 함께 이것도 다시 읽는다.
final callStreakProvider = FutureProvider.autoDispose<CallStreak>((ref) async {
  final repo = ref.watch(normalcallRepositoryProvider);
  const pageSize = 100;
  const maxPages = _maxPages;
  final dates = <DateTime>[];
  final today = DateTime.now();
  for (var page = 0; page < maxPages; page++) {
    final calls = await repo.listCalls(limit: pageSize, offset: page * pageSize);
    dates.addAll(calls.map((c) => c.callDate).whereType<DateTime>());
    if (calls.length < pageSize) break;
    // 날짜가 하나도 없으면(전부 null) 더 볼 것이 없다 — 아래 reduce 가 빈 목록에서 던진다.
    if (dates.isEmpty) break;
    // 읽은 범위 안에서 이미 끊겼으면 더 읽을 필요가 없다.
    final streak = CallStreak.fromDates(dates, today);
    final oldest = dates.map((d) => d.toLocal()).reduce((a, b) => a.isBefore(b) ? a : b);
    final reach = DateTime(today.year, today.month, today.day - streak.days);
    if (DateTime(oldest.year, oldest.month, oldest.day).isBefore(reach)) break;
  }
  return CallStreak.fromDates(dates, today);
});

/// 최대 쪽 수 — 100건 × 4 = 400건. **하루 1통화 전제**로 1년 넘게 센다.
/// ⚠ 하루 여러 통화하는 사용자는 **적게 센다**(하루 5통화 × 80일이면 400건이 차서 실제
///   100일이어도 80일로 보인다). 가장 열심히 쓴 사람이 손해 보는 자리라, 서버 연속일
///   API 제안(남은판단 S4)의 근거다.
const _maxPages = 4;
