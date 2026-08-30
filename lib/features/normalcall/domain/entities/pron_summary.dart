/// 마이페이지 "발음 분석" 카드 — 최근 N세션 평균
/// (`GET /calls/pronunciation-summary?sessions=`).
///
/// ⭐ 점수의 출처는 **SpeechSuper 실채점**이다(2026-08-30 런타임 실측). 한동안
/// 벤더 계정 만료(errId 41030)로 스텁 폴백이었으나 08-28 재연동됐고, 그 뒤 실기기로
/// 확인했다 — 같은 문장을 두 번 읽었을 때 글자 점수가 갈렸고(review 208·209),
/// 두 번 다 **같은 글자**(「저」「는」)에서만 무너졌다. 난수 스텁이면 실패 글자가
/// 매번 옮겨다녀야 하므로 이 패턴은 실엔진의 증거다.
///
/// ⚠ **「점수가 나온다」는 실채점의 증거가 아니다.** 키가 없거나 벤더가 죽으면 서버의
/// `core.speechsuper` 가 예외를 안 던지고 **조용히 스텁으로 되돌아간다**. 다시 가려야
/// 할 때는 서버 응답의 `phoneme` 이 빈 문자열인지 보는 것이 가장 빠르다.
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
