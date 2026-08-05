import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/bookmark_repository.dart';
import 'bookmark_providers.dart';

/// Owns the bookmark **mutation** (set/clear). The list data itself lives in
/// [bookmarkListProvider] (a `FutureProvider`); this controller calls the API
/// and then invalidates that provider so the list is re-read from the server.
///
/// **Simple / non-optimistic** by design: no in-memory pre-apply and no
/// rollback — the goal of this step is to confirm the server wiring actually
/// works. A failed call throws its [AppException] unchanged for the caller
/// (the screen) to surface (matching the alarm mutation convention).
final bookmarkToggleControllerProvider =
    AsyncNotifierProvider<BookmarkToggleController, void>(
  BookmarkToggleController.new,
);

class BookmarkToggleController extends AsyncNotifier<void> {
  BookmarkRepository get _repo => ref.read(bookmarkRepositoryProvider);

  @override
  Future<void> build() async {}

  /// `PATCH /sentences/{id}/bookmark` (set/clear), then invalidates
  /// [bookmarkListProvider] to refresh the list from the server. Rethrows any
  /// [AppException] on failure (no rollback).
  Future<void> toggleBookmark(int sentenceId, bool isBookmarked) async {
    await _repo.setBookmark(sentenceId, isBookmarked);
    ref.invalidate(bookmarkListProvider);
  }
}
