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
      sentenceId: (json['sentence_id'] as num?)?.toInt() ?? 0,
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
    this.callDate,
    this.totalTime,
    required this.average,
    required this.sentences,
  });

  final int callId;
  final String? summary;
  final int? rating;
  final String? callDate;
  final int? totalTime;
  final ScoreAverageDto average;
  final List<LearnedSentenceDto> sentences;

  factory CallResultDto.fromJson(Map<String, dynamic> json) {
    final average = (json['average'] as Map<String, dynamic>?) ?? const {};
    final sentences = (json['sentences'] as List<dynamic>?) ?? const [];
    return CallResultDto(
      callId: (json['call_id'] as num?)?.toInt() ?? 0,
      summary: json['summary'] as String?,
      rating: json['rating'] as int?,
      callDate: json['call_date'] as String?,
      totalTime: (json['total_time'] as num?)?.toInt(),
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
        callDate: DateTime.tryParse(callDate ?? ''),
        totalTime: totalTime,
        average: average.toEntity(),
        sentences: sentences.map((s) => s.toEntity()).toList(),
      );
}

/// Wire model for the `character` object of a call summary (snake_case).
class CallCharacterBriefDto {
  const CallCharacterBriefDto({
    required this.characterId,
    required this.name,
    this.imageUrl,
  });

  final int characterId;
  final String name;
  final String? imageUrl;

  factory CallCharacterBriefDto.fromJson(Map<String, dynamic> json) {
    return CallCharacterBriefDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }

  CallCharacterBrief toEntity() => CallCharacterBrief(
        characterId: characterId,
        name: name,
        imageUrl: imageUrl,
      );
}

/// Wire model for one entry of `GET /calls` (snake_case payload).
class CallSummaryDto {
  const CallSummaryDto({
    required this.callId,
    required this.character,
    this.callDate,
    this.totalTime,
    this.summary,
    this.rating,
  });

  final int callId;
  final CallCharacterBriefDto character;
  final String? callDate;
  final int? totalTime;
  final String? summary;
  final int? rating;

  factory CallSummaryDto.fromJson(Map<String, dynamic> json) {
    final character = (json['character'] as Map<String, dynamic>?) ?? const {};
    return CallSummaryDto(
      callId: json['call_id'] as int,
      character: CallCharacterBriefDto.fromJson(character),
      callDate: json['call_date'] as String?,
      totalTime: json['total_time'] as int?,
      summary: json['summary'] as String?,
      rating: json['rating'] as int?,
    );
  }

  CallSummary toEntity() => CallSummary(
        callId: callId,
        character: character.toEntity(),
        callDate: DateTime.tryParse(callDate ?? ''),
        totalTime: totalTime,
        summary: summary,
        rating: rating,
      );
}
