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
    this.kind,
    this.pairedSentenceId,
    this.nuance,
  });

  final int sentenceId;
  final String? koreanSentence;
  final String? nativeSentence;
  final String? voiceUrl;
  final bool isBookmarked;

  /// `"native"` = 현지인 표현 짝. 기본 문장에는 키 자체가 없다(null 이 아니라 부재).
  final String? kind;
  final int? pairedSentenceId;
  final String? nuance;

  factory LearnedSentenceDto.fromJson(Map<String, dynamic> json) {
    return LearnedSentenceDto(
      sentenceId: (json['sentence_id'] as num?)?.toInt() ?? 0,
      koreanSentence: json['korean_sentence'] as String?,
      nativeSentence: json['native_sentence'] as String?,
      voiceUrl: json['voice_url'] as String?,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
      kind: json['kind'] as String?,
      pairedSentenceId: (json['paired_sentence_id'] as num?)?.toInt(),
      nuance: json['nuance'] as String?,
    );
  }

  LearnedSentence toEntity() => LearnedSentence(
        sentenceId: sentenceId,
        korean: koreanSentence,
        native: nativeSentence,
        voiceUrl: voiceUrl,
        isBookmarked: isBookmarked,
        isNative: kind == 'native',
        pairedSentenceId: pairedSentenceId,
        nuance: nuance,
      );
}

/// Wire model for `GET /calls/{call_id}/result` (snake_case payload).
///
/// The `character`/`call_sequence`/`character_note` keys are what the v2
/// analysis design needs (Figma `screen/analysis`, `3583:34434`). **The server
/// sends none of them today** — they are parsed defensively so the screen lights
/// up the moment it does, with no client release. Every one stays null against
/// the current payload.
///
/// `one_fix` was parsed here too, for the 오늘의 피드백 section. That section was
/// deleted from the design on 2026-07-16, and since the server never sent the
/// key, dropping the parse changes nothing on the wire.
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
    this.usedItems = const [],
    this.quizItems = const [],
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
  final List<UsedItem> usedItems;
  final List<QuizItem> quizItems;

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
      usedItems: _usedItems(json['used_items']),
      quizItems: _quizItems(json['quiz_items']),
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

  /// 서버가 준 「이번 통화에서 쓴 표현」. 모양이 어긋난 원소는 조용히 버린다 —
  /// 한 줄 때문에 결과 화면 전체가 안 뜨면 안 된다.
  static List<UsedItem> _usedItems(Object? value) {
    if (value is! List) return const [];
    final out = <UsedItem>[];
    for (final e in value) {
      if (e is! Map<String, dynamic>) continue;
      final id = (e['item_id'] as num?)?.toInt();
      final surface = _text(e['surface']);
      if (id == null || surface == null) continue;
      out.add(UsedItem(itemId: id, surface: surface, quote: _text(e['quote'])));
    }
    return out;
  }

  /// 표현학습 퀴즈 결과(`quiz_items`). [_usedItems] 와 같은 규율 — 모양이 어긋난
  /// 원소는 조용히 버리고, 키가 없으면 빈 목록이다(옛 응답·다른 콜타입).
  ///
  /// 서버 스키마(`CallResultQuizItem`, 9cbea87):
  ///   `item_id:int · surface:str · meaning:str|null · passed:bool · failed:bool`
  /// `meaning` 은 옛 스냅샷에서 null, `failed` 는 옛 스냅샷에서 키가 없다 — 둘 다
  /// 없으면 null/false 로 두고 결과 파싱을 멈추지 않는다.
  /// ⛔ `failed` 를 `!passed` 로 채우지 마라. 서버가 «퀴즈에서 틀림»(failed) 과
  ///   «아직 퀴즈 안 봄»(passed=false·failed=false) 을 가르는 유일한 칸이 이것이다.
  ///   `passed` 면 항상 `failed=false` 다(단조).
  static List<QuizItem> _quizItems(Object? value) {
    if (value is! List) return const [];
    final out = <QuizItem>[];
    for (final e in value) {
      if (e is! Map<String, dynamic>) continue;
      final id = (e['item_id'] as num?)?.toInt();
      final surface = _text(e['surface']);
      if (id == null || surface == null) continue;
      out.add(QuizItem(
        itemId: id,
        surface: surface,
        meaning: _text(e['meaning']),
        passed: e['passed'] == true,
        failed: e['failed'] == true,
      ));
    }
    return out;
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
        usedItems: usedItems,
        quizItems: quizItems,
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
