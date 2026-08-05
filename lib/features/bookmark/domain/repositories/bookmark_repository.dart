import '../entities/bookmark_sentence.dart';

/// Bookmark (saved-sentence) capabilities the app depends on. Implemented in
/// the data layer.
///
/// All methods return entities and throw [AppException]
/// (see `core/error/app_exception.dart`) on failure. No dio/JSON leaks here.
abstract interface class BookmarkRepository {
  /// `GET /members/me/bookmarks` — the member's bookmarked sentences.
  Future<List<BookmarkSentence>> fetchBookmarks();

  /// `PATCH /sentences/{id}/bookmark` — set/clear a bookmark; returns the
  /// updated sentence.
  Future<BookmarkSentence> setBookmark(int sentenceId, bool isBookmarked);
}
