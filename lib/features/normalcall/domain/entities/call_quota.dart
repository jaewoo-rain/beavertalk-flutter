/// 통화 한도 — 「하루 몇 번, 한 번에 몇 분」.
///
/// 무료 플랜은 **1일 1통화 · 통화당 5분**이다(2026-08-18 확정). 유료는 5분마다
/// 이어갈지 확인만 받고 통화 자체를 막지 않는다.
///
/// ## ⛔ 판정 권위는 서버다
///
/// 이 값은 **표시용**이다. 클라가 세는 경과시간으로 한도를 판정하면 시계를 돌리거나
/// 앱을 다시 깔아 우회할 수 있다. 서버가 끊는 것이 진짜 한도이고, 이 값은 그 전에
/// 사용자에게 상황을 보여 주기 위한 것이다.
///
/// ## 리셋은 UTC 자정이다
///
/// [resetsAt] 을 **서버가 계산해 내려준다.** 클라가 자정을 계산하면 기기 시간대를
/// 타서, 시간대를 옮기는 것만으로 한도가 재발급된다.
class CallQuota {
  /// Creates a quota snapshot.
  const CallQuota({
    required this.dailyLimit,
    required this.usedToday,
    required this.maxDurationSec,
    required this.resetsAt,
  });

  /// 하루 허용 통화 수. 유료는 무제한이라 `null` 이다.
  final int? dailyLimit;

  /// 오늘 쓴 통화 수(UTC 자정 기준).
  final int usedToday;

  /// 통화 한 번의 상한(초). 무료·유료 모두 5분 단위로 확인을 받는다.
  final int maxDurationSec;

  /// 다음 리셋 시각. **서버 값이다.**
  final DateTime? resetsAt;

  /// 오늘 더 걸 수 있는가.
  bool get hasCallLeft => dailyLimit == null || usedToday < dailyLimit!;

  /// 남은 통화 수. 무제한이면 `null`.
  int? get callsLeft =>
      dailyLimit == null ? null : (dailyLimit! - usedToday).clamp(0, dailyLimit!);

  @override
  String toString() =>
      'CallQuota(limit: $dailyLimit, used: $usedToday, '
      'max: ${maxDurationSec}s, resets: $resetsAt)';
}
