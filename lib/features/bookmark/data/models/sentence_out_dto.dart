import '../../domain/entities/bookmark_sentence.dart';

/// Wire model for the server `SentenceOut` schema — the **archive-minimal
/// subset** the 보관(bookmark) screen actually consumes.
///
/// Only the fields `record_archive` renders/uses today are parsed here:
/// [sentenceId], [koreanSentence], [nativeSentence], [voiceUrl] (for the
/// speaker), and [isBookmarked]. The server also returns `locale` and a nested
/// `evaluation {…}` object — **intentionally not parsed** (the archive UI shows
/// no per-sentence scores). Add them here only when a screen needs them.
///
/// Contract source: `docs/backend_api_reference.md` › `SentenceOut`.
class SentenceOutDto {
  const SentenceOutDto({
    required this.sentenceId,
    required this.koreanSentence,
    required this.nativeSentence,
    this.voiceUrl,
    required this.isBookmarked,
  });

  /// Server `sentence_id`.
  final int sentenceId;

  /// Server `korean_sentence`.
  final String koreanSentence;

  /// Server `native_sentence`.
  final String nativeSentence;

  /// Server `voice_url` — nullable (absent until the sentence has been
  /// synthesized; `POST /sentences/{id}/tts` fills it on demand).
  final String? voiceUrl;

  /// Server `is_bookmarked`.
  final bool isBookmarked;

  factory SentenceOutDto.fromJson(Map<String, dynamic> json) {
    return SentenceOutDto(
      // Defensive coercion (matches the review DTOs): a null/odd-typed field from
      // the server degrades gracefully instead of throwing a raw TypeError.
      sentenceId: (json['sentence_id'] as num?)?.toInt() ?? 0,
      koreanSentence: json['korean_sentence'] as String? ?? '',
      nativeSentence: json['native_sentence'] as String? ?? '',
      voiceUrl: json['voice_url'] as String?,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }

  /// Converts to the domain [BookmarkSentence] entity (drops the wire naming).
  BookmarkSentence toEntity() => BookmarkSentence(
        sentenceId: sentenceId,
        korean: koreanSentence,
        native: nativeSentence,
        voiceUrl: voiceUrl,
        isBookmarked: isBookmarked,
      );
}
