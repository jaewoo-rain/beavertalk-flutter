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
}
