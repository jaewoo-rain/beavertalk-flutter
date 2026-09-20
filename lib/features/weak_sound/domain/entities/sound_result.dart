/// 평가 단계 채점 결과 — 결과 화면(62 → 84 막대 + 조음카드)의 재료.
///
/// [after] 는 **서버가 채점한 값**이다. 앱이 점수를 계산해 보내는 설계는 폐기했다
/// (2026-09-20) — 클라가 100 을 보내는 것을 막을 수 없었다.
class SoundResult {
  const SoundResult({
    required this.soundKey,
    required this.label,
    required this.after,
    required this.bestScore,
    required this.attempts,
    required this.text,
    this.before,
    this.delta,
    this.charScores = const [],
    this.phonemeMisses = const [],
  });

  final String soundKey;
  final String label;

  /// 학습 전 점수. 첫 측정이면 null(Figma E8 분기).
  final int? before;

  /// 학습 후 점수 0~100.
  final int after;

  /// [after] − [before]. [before] 가 null 이면 null. 음수면 점수 하락(Figma E5).
  final int? delta;

  final int bestScore;
  final int attempts;

  /// 채점에 쓴 평가 문장.
  final String text;

  /// 글자별 상/중/하.
  final List<SoundCharScore> charScores;

  /// 틀린 자모 — 결과 화면의 조음카드가 이걸로 붙는다. 0건일 수 있다.
  final List<SoundPhonemeMiss> phonemeMisses;

  /// 점수가 내려갔는가.
  bool get dropped => (delta ?? 0) < 0;

  /// 첫 측정인가(학습 전 점수가 없음).
  bool get isFirstMeasure => before == null;
}

/// 평가 문장의 글자 1개.
class SoundCharScore {
  const SoundCharScore({
    required this.char,
    required this.score,
    required this.grade,
  });

  final String char;
  final int score;

  /// 상 | 중 | 하.
  final String grade;
}

/// 틀린 자모 1개 + 그 글자 위치.
class SoundPhonemeMiss {
  const SoundPhonemeMiss({required this.charIndex, required this.expected});

  /// [SoundResult.charScores] 안의 인덱스.
  final int charIndex;

  /// 기대한 자모.
  final String expected;
}
