/// 오늘의 통화 상태 — 서버 `GET /calls/daily-status`(서버 `premium` 브랜치 09-23 §5).
///
/// [budgetSec]·[usedSec]·[remainingSec] 는 **한 묶음**이다. 예산 대상이 아니면(admin 면제)
/// 셋 다 키가 빠진다 → 셋 다 null. `?? 0` 으로 뭉개지 마라 — 「면제」 가 「다 씀」 이 된다.
///
/// ⚠ [remainingSec] 는 **오늘 남은 총량**이다. `call_started.remaining_s`(이 조각이 쓸 수
///   있는 초, 최대 360)와 이름만 같고 뜻이 다르다.
class DailyStatus {
  const DailyStatus({
    this.calledToday,
    this.canCallNormal,
    this.maxFragments,
    this.budgetSec,
    this.usedSec,
    this.remainingSec,
  });

  final bool? calledToday;

  /// 신서버에서는 「예산이 남았나」 다(횟수가 아니다).
  final bool? canCallNormal;

  final int? maxFragments;

  /// 하루 총량(초). Free 300 · Premium 900.
  final int? budgetSec;

  /// 오늘 쓴 초.
  final int? usedSec;

  /// 오늘 남은 초 = [budgetSec] − [usedSec].
  final int? remainingSec;

  /// 예산 정보가 왔는가(신서버 · 예산 대상).
  bool get hasBudget => remainingSec != null;

  static DailyStatus? tryParse(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    int? i(String k) => (json[k] as num?)?.toInt();
    return DailyStatus(
      calledToday: json['called_today'] as bool?,
      canCallNormal: json['can_call_normal'] as bool?,
      maxFragments: i('max_fragments'),
      budgetSec: i('budget_s'),
      usedSec: i('used_s'),
      remainingSec: i('remaining_s'),
    );
  }
}
