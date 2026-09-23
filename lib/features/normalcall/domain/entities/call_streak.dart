/// 연속 학습일 — 홈 GNB 의 불꽃 칩(Figma `Chip-Streak` `6177:29119`).
///
/// 서버에 연속일 API 가 없어 **통화 목록(`GET /calls`)의 날짜로 앱이 센다.**
/// 날짜는 기기 현지 날짜다 — 사용자가 「오늘 했나」를 느끼는 달력이 그것이기 때문이다
/// (`call_date` 는 서버가 타임존 포함으로 준다 → [DateTime.toLocal]).
enum StreakState {
  /// 오늘 통화했다 — 불꽃 주황(`state=done`).
  done,

  /// 어제까지 이어져 있고 오늘은 아직이다 — 불꽃만 주황, 숫자는 회색(`state=pending`).
  pending,

  /// 끊겼다(어제도 오늘도 없다) — 전부 회색, 숫자 0(`state=broken`).
  broken,
}

/// 연속일 판정 결과.
class CallStreak {
  /// 결과를 만든다.
  const CallStreak({required this.days, required this.state});

  /// 연속일 수. [StreakState.broken] 이면 0.
  final int days;

  /// 칩 변형.
  final StreakState state;

  /// 통화 날짜들로 연속일을 센다. [today] 는 기기 현지 날짜(시·분은 무시한다).
  ///
  /// ⚠ 오늘이 없으면 **어제부터** 센다 — 아침에 앱을 열자마자 0 이 보이면 이어 온
  ///   날들이 사라진 것처럼 읽힌다. 그 상태가 [StreakState.pending] 이다.
  factory CallStreak.fromDates(Iterable<DateTime> callDates, DateTime today) {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    final days = {for (final d in callDates) day(d.toLocal())};
    final t = day(today);
    final y = t.subtract(const Duration(days: 1));
    final DateTime start;
    final StreakState state;
    if (days.contains(t)) {
      start = t;
      state = StreakState.done;
    } else if (days.contains(y)) {
      start = y;
      state = StreakState.pending;
    } else {
      return const CallStreak(days: 0, state: StreakState.broken);
    }
    var n = 0;
    // 달력 날짜로 한 칸씩 뒤로 간다. `subtract(Duration(days: 1))` 는 서머타임 전환일에
    // 23·25시간이 되어 날짜가 밀릴 수 있어, 연·월·일로 다시 만든다.
    for (
      var d = start;
      days.contains(d);
      d = DateTime(d.year, d.month, d.day - 1)
    ) {
      n++;
    }
    return CallStreak(days: n, state: state);
  }

  /// 가장 길었던 연속일 — 학습 달력 히어로의 「최고 기록 N일」(Figma `6183:4527` Hero/Best).
  ///
  /// 통화한 날(현지 날짜)을 정렬해 하루씩 이어진 가장 긴 구간을 센다. 하루에 여러 통화는
  /// 하루다. 기록이 없으면 0.
  static int bestDays(Iterable<DateTime> callDates) {
    final days = {
      for (final d in callDates)
        DateTime(d.toLocal().year, d.toLocal().month, d.toLocal().day),
    }.toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in days) {
      // 달력 날짜로 비교한다 — 서머타임 전환일엔 차이가 23·25시간이라 Duration 으로 못 잰다.
      final next = prev == null
          ? null
          : DateTime(prev.year, prev.month, prev.day + 1);
      run = next != null && d == next ? run + 1 : 1;
      if (run > best) best = run;
      prev = d;
    }
    return best;
  }
}
