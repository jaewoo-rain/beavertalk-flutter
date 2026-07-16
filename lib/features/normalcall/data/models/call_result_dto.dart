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
///
/// The `character`/`call_sequence`/`character_note`/`one_fix`/`first_time`/
/// `next_call`/`expressions_total` keys are what the v2 analysis design needs
/// (Figma `screen/analysis__확정`). **The server sends none of them today** —
/// they are parsed defensively so the screen lights up the moment it does, with
/// no client release. Every one stays null against the current payload.
class CallResultDto {
  const CallResultDto({
    required this.callId,
    this.summary,
    this.rating,
    this.callDate,
    this.totalTime,
    required this.average,
    required this.sentences,
    this.character,
    this.callSequence,
    this.note,
    this.oneFix,
    this.firstTime,
    this.nextCall,
    this.expressionsTotal,
  });

  final int callId;
  final String? summary;
  final int? rating;
  final String? callDate;
  final int? totalTime;
  final ScoreAverageDto average;
  final List<LearnedSentenceDto> sentences;
  final CallCharacterBriefDto? character;
  final int? callSequence;
  final CharacterNote? note;
  final OneFix? oneFix;
  final FirstTime? firstTime;
  final String? nextCall;
  final int? expressionsTotal;

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
      character: _character(json['character']),
      callSequence: (json['call_sequence'] as num?)?.toInt(),
      note: _note(json['character_note']),
      oneFix: _oneFix(json['one_fix']),
      firstTime: _firstTime(json['first_time']),
      nextCall: _text(json['next_call']),
      expressionsTotal: (json['expressions_total'] as num?)?.toInt(),
    );
  }

  /// `character` is only usable with an id — [CallCharacterBriefDto] casts
  /// `character_id` non-null, so an id-less object would throw and take the
  /// whole result parse down with it.
  static CallCharacterBriefDto? _character(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    if (value['character_id'] is! num) return null;
    return CallCharacterBriefDto.fromJson(value);
  }

  static CharacterNote? _note(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final text = _text(value['text']);
    return text == null ? null : CharacterNote(text: text);
  }

  static OneFix? _oneFix(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    // Without a title there is nothing to render a card around.
    final title = _text(value['title']);
    if (title == null) return null;
    return OneFix(
      title: title,
      evidence: _text(value['evidence']),
      l1Interference: _text(value['l1_interference']),
      streakCount: (value['streak_count'] as num?)?.toInt(),
    );
  }

  static FirstTime? _firstTime(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final text = _text(value['text']);
    if (text == null) return null;
    return FirstTime(text: text, previous: _text(value['previous']));
  }

  /// A blank string is as absent as null — both must hide the section rather
  /// than render an empty card.
  static String? _text(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  CallResult toEntity() => CallResult(
        callId: callId,
        summary: summary,
        rating: rating,
        callDate: DateTime.tryParse(callDate ?? ''),
        totalTime: totalTime,
        average: average.toEntity(),
        sentences: sentences.map((s) => s.toEntity()).toList(),
        character: character?.toEntity(),
        callSequence: callSequence,
        note: note,
        oneFix: oneFix,
        firstTime: firstTime,
        nextCall: nextCall,
        expressionsTotal: expressionsTotal,
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
