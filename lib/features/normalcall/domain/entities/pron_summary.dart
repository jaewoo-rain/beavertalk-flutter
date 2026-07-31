/// 마이페이지 "발음 분석" 카드 — 최근 N세션 평균
/// (`GET /calls/pronunciation-summary?sessions=`).
///
/// ⚠ 지금 점수의 출처는 **스텁**이다. 발음 채점 벤더(SpeechSuper) 계정이 만료돼
/// 서버가 스텁으로 폴백하고 있다. 배선을 먼저 만들어 두는 것이 목적이고, 벤더가
/// 살아나면 같은 경로로 진짜 점수가 채워진다(이 클래스는 그대로).
class PronSummary {
  const PronSummary({
    required this.sessions,
    required this.sentenceCount,
    this.totalScore,
    this.pronunciation,
    this.fluency,
    this.rhythm,
  });

  /// 평균에 실제로 들어간 통화 수(요청한 N 이하).
  ///
  /// **0 이면 아직 발음 기록이 없다는 뜻**이고 점수는 전부 null 이다. 통화만 하고
  /// 발음 챌린지를 안 누른 통화는 점수가 없어서 여기 안 잡힌다 — 실제로 그런
  /// 통화가 대부분이라, 통화를 여러 번 했어도 0 일 수 있다.
  final int sessions;

  /// 평균에 들어간 문장 수(표본 크기). 통화 수보다 신뢰도를 잘 나타낸다.
  final int sentenceCount;

  /// 종합 점수 0~100. 표본이 없으면 null.
  final double? totalScore;

  /// 발음 정확도 0~100.
  final double? pronunciation;

  /// 유창성 0~100.
  final double? fluency;

  /// 리듬 0~100.
  final double? rhythm;

  /// 보여줄 점수가 하나라도 있는지 — false 면 카드가 빈 상태 안내를 띄운다.
  bool get hasData => sessions > 0 && totalScore != null;

  static const empty = PronSummary(sessions: 0, sentenceCount: 0);

  factory PronSummary.fromJson(Map<String, dynamic> json) {
    double? d(String k) => (json[k] as num?)?.toDouble();
    return PronSummary(
      sessions: (json['sessions'] as num?)?.toInt() ?? 0,
      sentenceCount: (json['sentence_count'] as num?)?.toInt() ?? 0,
      totalScore: d('total_score'),
      pronunciation: d('pronunciation'),
      fluency: d('fluency'),
      rhythm: d('rhythm'),
    );
  }
}
