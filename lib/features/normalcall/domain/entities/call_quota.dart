/// 통화 한도 — 「하루 몇 번, 한 번에 몇 분」.
///
/// ## 상한과 확인 주기는 다른 축이다
///
/// 기존 제품 카피가 이미 둘을 가르고 있다 — `planTaglinePro` 는 「Unlimited calls.
/// **15 minutes each**」이고 `bulletFreeCall` 은 「One **5-minute** voice call a day」다.
/// 즉 **「무제한」은 횟수**([dailyLimit])이고 **「15분」은 한 통화의 상한**([maxDurationSec])이다.
///
/// 5분마다 뜨는 확인 시트는 그 **상한 안에서의 페이스**([checkInEverySec])이지 상한이
/// 아니다. Pro 가 15분 통화 중 5·10분에 두 번 확인받아도 「15 minutes each」는 깨지지
/// 않는다.
///
/// ⛔ 둘을 한 값으로 겸직시키지 마라. 겸직시키면 **Pro 가 5분마다 무한히 이어갈 수
///   있어 상한이 사라진다** — 2026-08-18 에 실제로 그 상태로 한 번 짰다.
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
    required this.checkInEverySec,
    required this.resetsAt,
  });

  /// 하루 허용 통화 수. 유료는 무제한이라 `null` 이다.
  final int? dailyLimit;

  /// 오늘 쓴 통화 수(UTC 자정 기준).
  final int usedToday;

  /// 통화 한 번의 **상한**(초). 무료 300 · 유료 900.
  ///
  /// 여기에 도달하면 통화가 끝난다. 실제로 끊는 것은 서버다.
  final int maxDurationSec;

  /// **확인 주기**(초). 이 배수마다 「더 이어갈까요?」를 묻는다.
  ///
  /// [maxDurationSec] 과 다른 축이다 — 상한이 아니라 그 안에서의 페이스다.
  final int checkInEverySec;

  /// 다음 리셋 시각. **서버 값이다.**
  final DateTime? resetsAt;

  /// 오늘 더 걸 수 있는가.
  bool get hasCallLeft => dailyLimit == null || usedToday < dailyLimit!;

  /// 남은 통화 수. 무제한이면 `null`.
  int? get callsLeft =>
      dailyLimit == null ? null : (dailyLimit! - usedToday).clamp(0, dailyLimit!);

  /// [elapsedSec] 가 확인 시점인가 — 상한 **미만**의 주기 배수일 때만 참이다.
  ///
  /// 상한 그 자체는 확인 시점이 아니다. 거기서는 물을 게 아니라 끝난다.
  bool isCheckIn(int elapsedSec) =>
      elapsedSec > 0 &&
      checkInEverySec > 0 &&
      elapsedSec % checkInEverySec == 0 &&
      elapsedSec < maxDurationSec;

  /// 상한에 도달했는가.
  bool isCeiling(int elapsedSec) =>
      maxDurationSec > 0 && elapsedSec >= maxDurationSec;

  @override
  String toString() =>
      'CallQuota(limit: $dailyLimit, used: $usedToday, '
      'max: ${maxDurationSec}s, checkIn: ${checkInEverySec}s, resets: $resetsAt)';
}
