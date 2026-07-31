/// 마이페이지 "종합 레벨" 카드 데이터 — `GET /members/me/profile`.
///
/// 예전엔 레벨을 사용자에게 감췄지만(서버 결정 D2) 마이페이지 개편으로 노출로
/// 바뀌었다. 항목별 학습 상태·진행률은 여전히 비노출이다.
class LevelSummary {
  const LevelSummary({this.level, this.maxLevel = 13, this.topPercent});

  /// 현재 레벨(1~13). **null = 레벨테스트 미실시** — 카드가 숫자 대신 안내를 띄운다.
  ///
  /// 서버가 학습 언어(`target_language`) 기준으로 계산해 내려준다. 회원은 언어마다
  /// 레벨이 따로라 앱이 `member.korean_level` 을 그대로 쓰면 안 된다.
  final int? level;

  /// 레벨 스케일의 끝(기본 13). 서버가 커리큘럼을 늘리면 응답으로 따라온다.
  final int maxLevel;

  /// "상위 N%" 표시값. **실제 회원 분포 계산이 아니라 레벨별 고정 표**다 —
  /// 모수가 수십 명이라 계산하면 한 명 승급에 남의 백분위가 크게 흔들린다.
  /// null 이면(레벨 미확정이거나 표에 없는 레벨) 카드가 그 줄을 숨긴다.
  final int? topPercent;

  /// 레벨테스트를 아직 안 봤는지 — 카드가 숫자 대신 "테스트 받기"를 보여줄 조건.
  bool get needsLevelTest => level == null;

  /// "상위 N%" 의 반대 표현("N% 보다 앞서요"). 둘은 같은 값의 두 얼굴이라
  /// 서버가 하나만 내려주고 여기서 뒤집는다 — 두 필드를 각자 내려주면 합이 100 이
  /// 아닌 상태로 어긋날 수 있다.
  int? get aheadOfPercent {
    final p = topPercent;
    return p == null ? null : 100 - p;
  }

  factory LevelSummary.fromJson(Map<String, dynamic> json) => LevelSummary(
        level: (json['korean_level'] as num?)?.toInt(),
        maxLevel: (json['level_max'] as num?)?.toInt() ?? 13,
        topPercent: (json['level_top_percent'] as num?)?.toInt(),
      );
}
