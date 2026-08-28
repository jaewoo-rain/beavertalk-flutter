// Pronunciation-review entities for a single learned sentence. Pure Dart —
// no Flutter/dio/JSON knowledge. Produced by `POST /sentences/{id}/reviews/audio`
// and consumed by the learning flow (learning_next / learning_sentence_main) and the
// frontend gauge-average recompute.

/// Overall scores for one review attempt. Each value is 0–100.
class PronScore {
  const PronScore({
    required this.totalScore,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
  });

  /// Overall score (0–100).
  final int totalScore;

  /// Pronunciation sub-score (0–100).
  final int pronunciation;

  /// Fluency sub-score (0–100).
  final int fluency;

  /// Rhythm sub-score (0–100).
  final int rhythm;
}

/// A single grade bucket for a character score.
enum CharGrade {
  /// 상 — high (good).
  high,

  /// 중 — medium (ok).
  medium,

  /// 하 — low (needs work).
  low,

  /// Unknown/unrecognized grade string.
  unknown;

  /// Parses a server grade string ('상'|'중'|'하') into a [CharGrade].
  static CharGrade parse(String? value) {
    switch (value) {
      case '상':
        return CharGrade.high;
      case '중':
        return CharGrade.medium;
      case '하':
        return CharGrade.low;
      default:
        return CharGrade.unknown;
    }
  }
}

/// A per-character pronunciation score with its 상/중/하 grade.
class CharScore {
  const CharScore({
    required this.char,
    required this.score,
    required this.grade,
  });

  /// The character (a single grapheme, e.g. '안').
  final String char;

  /// Score for this character (0–100).
  final int score;

  /// 상/중/하 grade for this character.
  final CharGrade grade;
}

/// 한 음소의 오발음 — 목표 자모와 실제로 들린 자모.
///
/// 서버가 음소 단위 결과를 내려줄 때만 채워진다. 글자 점수(`char_scores`)는
/// **얼마나 틀렸는지**만 말하고 **무엇으로 틀렸는지**는 말하지 않는다. 조음 도해의
/// 「내 발음」 컷은 [actual] 이 있어야 그릴 수 있다.
class PhonemeMiss {
  /// Creates one phoneme mismatch.
  const PhonemeMiss({
    required this.charIndex,
    required this.expected,
    this.actual,
  });

  /// 문장에서 몇 번째 글자인지 — **공백을 뺀** 0-기준 인덱스. `char_scores` 와
  /// 같은 자를 쓰므로 두 목록을 인덱스로 맞출 수 있다.
  final int charIndex;

  /// 목표 자모(예: 'ㄹ').
  final String expected;

  /// 실제로 들린 자모(예: 'ㄴ'). 인식기가 무엇인지 못 가르면 null —
  /// 그때는 도해를 한 컷만 그린다.
  final String? actual;
}

/// Full feedback for one pronunciation-review attempt.
class ReviewFeedback {
  const ReviewFeedback({
    required this.reviewId,
    required this.sentenceId,
    this.korean,
    this.native,
    this.voiceUrl,
    required this.evaluation,
    required this.charScores,
    this.phonemeMisses = const <PhonemeMiss>[],
  });

  /// Server review id.
  final int reviewId;

  /// The sentence this review is for.
  final int sentenceId;

  /// Korean sentence text, or null.
  final String? korean;

  /// Native-language translation, or null.
  final String? native;

  /// Native TTS audio URL/key for playback; null/unplayable when absent.
  final String? voiceUrl;

  /// Overall scores for this attempt.
  final PronScore evaluation;

  /// Per-character scores (may be empty).
  final List<CharScore> charScores;

  /// 음소 단위 오발음. **서버가 안 주면 빈 목록**이고, 그때 조음 시트는 목표 도해
  /// 한 컷만 그린다. 서버가 주기 시작하면 화면은 안 고쳐도 두 컷이 된다.
  final List<PhonemeMiss> phonemeMisses;
}
