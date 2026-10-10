/// 학습 달력 집계 — 서버 `GET /api/v1/stats/calendar`(서버 `premium` 브랜치 09-23 §7).
///
/// ⛔ **키 없음 ≠ 0.** 이 API 는 값이 없으면 키 자체를 빼고 보낸다(§0). 그래서 전부 nullable
///   로 받고 `?? 0` 으로 뭉개지 않는다 — 「데이터 없음」 이 「0개」 로 보이면 거짓이다.
///   - [CalendarDay.words] · [CalendarTotal.words]: 집계된 게 없으면 null
///   - [streakDays]: 연속이 끊겼으면(오늘도 어제도 통화 없음) null — 0 이 아니다
///   - 통화가 없는 날은 [days] 에 아예 없다
class CalendarStats {
  /// Creates the aggregate.
  const CalendarStats({
    required this.days,
    required this.total,
    this.streakDays,
  });

  /// 통화가 있었던 날만. 순서는 서버가 준 대로.
  final List<CalendarDay> days;

  /// 요청 범위 전체 합계.
  final CalendarTotal total;

  /// 오늘 기준 학습 연속일(최대 999). 끊겼으면 null. 범위(`start`·`end`)와 무관하다.
  ///
  /// 오늘 아직 통화를 안 했으면 **어제 기준** 값이 온다(오늘 통화하면 +1).
  final int? streakDays;

  /// 그날(현지 날짜)의 집계. 없으면 null — 그날 통화 없음.
  CalendarDay? dayOf(DateTime date) {
    for (final d in days) {
      if (d.date.year == date.year &&
          d.date.month == date.month &&
          d.date.day == date.day) {
        return d;
      }
    }
    return null;
  }

  /// 서버 JSON → 집계. 모양이 틀리면 null(호출부가 종전 계산으로 내려간다).
  static CalendarStats? tryParse(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final rawDays = json['days'];
    final rawTotal = json['total'];
    if (rawDays is! List || rawTotal is! Map<String, dynamic>) return null;
    final days = <CalendarDay>[
      for (final d in rawDays) ?CalendarDay._tryParse(d),
    ];
    return CalendarStats(
      days: days,
      total: CalendarTotal._fromJson(rawTotal),
      streakDays: (json['streak_days'] as num?)?.toInt(),
    );
  }
}

/// 하루치 집계.
class CalendarDay {
  const CalendarDay({
    required this.date,
    this.sentences,
    this.words,
    this.callCount,
    this.callMinutes,
  });

  /// 현지 날짜(시·분 없음).
  final DateTime date;

  /// 그날 배운 문장 수.
  final int? sentences;

  /// 그날 사용자가 말한 단어 수 — **대략치**(중복 포함, 일·중은 글자 수 환산). 없으면 null.
  final int? words;

  /// 통화 수.
  final int? callCount;

  /// 통화 시간(분, 올림).
  final int? callMinutes;

  static CalendarDay? _tryParse(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final raw = json['date'];
    if (raw is! String) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    return CalendarDay(
      date: DateTime(parsed.year, parsed.month, parsed.day),
      sentences: (json['sentences'] as num?)?.toInt(),
      words: (json['words'] as num?)?.toInt(),
      callCount: (json['call_count'] as num?)?.toInt(),
      callMinutes: (json['call_minutes'] as num?)?.toInt(),
    );
  }
}

/// 범위 합계.
///
/// ⚠ [callMinutes] 는 일별 올림의 합이 아니라 **전체 초를 한 번 올림**한 값이라 일별 합과
///   다를 수 있다 — 서버 정상 동작이다(§7).
class CalendarTotal {
  const CalendarTotal({
    this.sentences,
    this.words,
    this.callCount,
    this.callDays,
    this.callMinutes,
  });

  final int? sentences;
  final int? words;
  final int? callCount;
  final int? callDays;
  final int? callMinutes;

  factory CalendarTotal._fromJson(Map<String, dynamic> json) => CalendarTotal(
        sentences: (json['sentences'] as num?)?.toInt(),
        words: (json['words'] as num?)?.toInt(),
        callCount: (json['call_count'] as num?)?.toInt(),
        callDays: (json['call_days'] as num?)?.toInt(),
        callMinutes: (json['call_minutes'] as num?)?.toInt(),
      );
}
