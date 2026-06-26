import '../../domain/entities/call_result.dart';

/// Wire model for the `average` object of a call result (snake_case scores).
class ScoreAverageDto {
  const ScoreAverageDto({
    this.totalScore,
    this.pronunciation,
    this.fluency,
    this.rhythm,
  });

  final double? totalScore;
  final double? pronunciation;
  final double? fluency;
  final double? rhythm;

  factory ScoreAverageDto.fromJson(Map<String, dynamic> json) {
    return ScoreAverageDto(
      totalScore: _toDouble(json['total_score']),
      pronunciation: _toDouble(json['pronunciation']),
      fluency: _toDouble(json['fluency']),
      rhythm: _toDouble(json['rhythm']),
    );
  }

  /// Accepts int or double (or null) from JSON and normalizes to [double].
  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }

  ScoreAverage toEntity() => ScoreAverage(
        totalScore: totalScore,
        pronunciation: pronunciation,
        fluency: fluency,
        rhythm: rhythm,
      );
}

/// Wire model for one entry of the `sentences` array (snake_case fields).
class LearnedSentenceDto {
  const LearnedSentenceDto({
    required this.sentenceId,
    this.koreanSentence,
    this.nativeSentence,
    this.voiceUrl,
    this.isBookmarked = false,
  });

  final int sentenceId;
  final String? koreanSentence;
  final String? nativeSentence;
  final String? voiceUrl;
  final bool isBookmarked;

  factory LearnedSentenceDto.fromJson(Map<String, dynamic> json) {
    return LearnedSentenceDto(
      sentenceId: json['sentence_id'] as int,
      koreanSentence: json['korean_sentence'] as String?,
      nativeSentence: json['native_sentence'] as String?,
      voiceUrl: json['voice_url'] as String?,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }

  LearnedSentence toEntity() => LearnedSentence(
        sentenceId: sentenceId,
        korean: koreanSentence,
        native: nativeSentence,
        voiceUrl: voiceUrl,
        isBookmarked: isBookmarked,
      );
}

/// Wire model for `GET /calls/{call_id}/result` (snake_case payload).
class CallResultDto {
  const CallResultDto({
    required this.callId,
    this.summary,
    this.rating,
    required this.average,
    required this.sentences,
  });

  final int callId;
  final String? summary;
  final int? rating;
  final ScoreAverageDto average;
  final List<LearnedSentenceDto> sentences;

  factory CallResultDto.fromJson(Map<String, dynamic> json) {
    final average = (json['average'] as Map<String, dynamic>?) ?? const {};
    final sentences = (json['sentences'] as List<dynamic>?) ?? const [];
    return CallResultDto(
      callId: json['call_id'] as int,
      summary: json['summary'] as String?,
      rating: json['rating'] as int?,
      average: ScoreAverageDto.fromJson(average),
      sentences: sentences
          .map((e) => LearnedSentenceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CallResult toEntity() => CallResult(
        callId: callId,
        summary: summary,
        rating: rating,
        average: average.toEntity(),
        sentences: sentences.map((s) => s.toEntity()).toList(),
      );
}
