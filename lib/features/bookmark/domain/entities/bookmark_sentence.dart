/// A bookmarked ("saved") sentence shown on the 보관 (archive) screen.
///
/// Pure Dart — no Flutter/dio/JSON knowledge. Domain view of the server
/// `SentenceOut` (archive-minimal subset); built from `SentenceOutDto.toEntity`.
class BookmarkSentence {
  const BookmarkSentence({
    required this.sentenceId,
    required this.korean,
    required this.native,
    this.voiceUrl,
    required this.isBookmarked,
  });

  /// Server primary key of the sentence.
  final int sentenceId;

  /// Korean text of the saved expression.
  final String korean;

  /// Native-language translation.
  final String native;

  /// Playable standard-pronunciation audio URL; null until synthesized
  /// (`POST /sentences/{id}/tts` fills it on demand).
  final String? voiceUrl;

  /// Whether the sentence is currently bookmarked.
  final bool isBookmarked;
}
