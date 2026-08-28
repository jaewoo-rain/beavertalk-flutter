import '../../domain/entities/review_feedback.dart';

/// Wire model for the `evaluation` object (snake_case, all ints 0–100).
class PronScoreDto {
  const PronScoreDto({
    required this.totalScore,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
  });

  final int totalScore;
  final int pronunciation;
  final int fluency;
  final int rhythm;

  factory PronScoreDto.fromJson(Map<String, dynamic> json) {
    return PronScoreDto(
      totalScore: _toInt(json['total_score']),
      pronunciation: _toInt(json['pronunciation']),
      fluency: _toInt(json['fluency']),
      rhythm: _toInt(json['rhythm']),
    );
  }

  /// Accepts int/double/null from JSON, normalizing to a 0-based [int].
  static int _toInt(Object? value) {
    if (value is num) return value.round();
    return 0;
  }

  PronScore toEntity() => PronScore(
        totalScore: totalScore,
        pronunciation: pronunciation,
        fluency: fluency,
        rhythm: rhythm,
      );
}

/// Wire model for one entry of `char_scores`.
class CharScoreDto {
  const CharScoreDto({
    required this.char,
    required this.score,
    this.grade,
  });

  final String char;
  final int score;
  final String? grade;

  factory CharScoreDto.fromJson(Map<String, dynamic> json) {
    return CharScoreDto(
      char: (json['char'] as String?) ?? '',
      score: PronScoreDto._toInt(json['score']),
      grade: json['grade'] as String?,
    );
  }

  CharScore toEntity() => CharScore(
        char: char,
        score: score,
        grade: CharGrade.parse(grade),
      );
}

/// Wire model for one entry of `phoneme_misses`.
///
/// 서버가 이 배열을 안 보내면 앱은 빈 목록으로 읽고 종전대로 동작한다 — 이 필드는
/// **선택**이다.
class PhonemeMissDto {
  const PhonemeMissDto({
    required this.charIndex,
    required this.expected,
    this.actual,
  });

  final int charIndex;
  final String expected;
  final String? actual;

  factory PhonemeMissDto.fromJson(Map<String, dynamic> json) {
    return PhonemeMissDto(
      charIndex: PronScoreDto._toInt(json['char_index']),
      expected: (json['expected'] as String?) ?? '',
      actual: json['actual'] as String?,
    );
  }

  PhonemeMiss toEntity() => PhonemeMiss(
        charIndex: charIndex,
        expected: expected,
        actual: (actual?.isEmpty ?? true) ? null : actual,
      );
}

/// Wire model for `POST /sentences/{id}/reviews/audio` (ReviewFeedback,
/// snake_case payload).
class ReviewFeedbackDto {
  const ReviewFeedbackDto({
    required this.reviewId,
    required this.sentenceId,
    this.koreanSentence,
    this.nativeSentence,
    this.voiceUrl,
    required this.evaluation,
    required this.charScores,
    this.phonemeMisses = const <PhonemeMissDto>[],
  });

  final int reviewId;
  final int sentenceId;
  final String? koreanSentence;
  final String? nativeSentence;
  final String? voiceUrl;
  final PronScoreDto evaluation;
  final List<CharScoreDto> charScores;
  final List<PhonemeMissDto> phonemeMisses;

  factory ReviewFeedbackDto.fromJson(Map<String, dynamic> json) {
    final evaluation =
        (json['evaluation'] as Map<String, dynamic>?) ?? const {};
    final charScores = (json['char_scores'] as List<dynamic>?) ?? const [];
    final misses = (json['phoneme_misses'] as List<dynamic>?) ?? const [];
    return ReviewFeedbackDto(
      reviewId: (json['review_id'] as num?)?.toInt() ?? 0,
      sentenceId: (json['sentence_id'] as num?)?.toInt() ?? 0,
      koreanSentence: json['korean_sentence'] as String?,
      nativeSentence: json['native_sentence'] as String?,
      voiceUrl: json['voice_url'] as String?,
      evaluation: PronScoreDto.fromJson(evaluation),
      charScores: charScores
          .whereType<Map<String, dynamic>>()
          .map(CharScoreDto.fromJson)
          .toList(),
      phonemeMisses: misses
          .whereType<Map<String, dynamic>>()
          .map(PhonemeMissDto.fromJson)
          .toList(),
    );
  }

  ReviewFeedback toEntity() => ReviewFeedback(
        reviewId: reviewId,
        sentenceId: sentenceId,
        korean: koreanSentence,
        native: nativeSentence,
        voiceUrl: voiceUrl,
        evaluation: evaluation.toEntity(),
        charScores: charScores.map((c) => c.toEntity()).toList(),
        phonemeMisses: phonemeMisses.map((m) => m.toEntity()).toList(),
      );
}
