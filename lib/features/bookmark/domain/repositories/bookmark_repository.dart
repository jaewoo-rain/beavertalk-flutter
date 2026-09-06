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

  /// `POST /sentences/from-hint` — turns an in-call hint example into a saved
  /// sentence at the moment the learner taps 🔖, and returns it already
  /// bookmarked. Hints carry no server id, so [korean] and [native] are sent
  /// back verbatim; from then on the sentence is an ordinary bookmark and
  /// [setBookmark] toggles it.
  ///
  /// Saving the same hint twice is **not** an error — the same sentence comes
  /// back.
  Future<BookmarkSentence> saveHintSentence({
    required int callId,
    required String korean,
    required String native,
  });
}
