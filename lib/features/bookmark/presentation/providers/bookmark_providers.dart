import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/bookmark_remote_data_source.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/entities/bookmark_sentence.dart';
import '../../domain/repositories/bookmark_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final bookmarkRemoteDataSourceProvider =
    Provider<BookmarkRemoteDataSource>((ref) {
  return BookmarkRemoteDataSource(ref.watch(dioProvider));
});

/// Bookmark repository (domain interface) backed by the remote data source.
final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(
    remote: ref.watch(bookmarkRemoteDataSourceProvider),
  );
});

/// The member's bookmarked sentences (`GET /members/me/bookmarks`).
///
/// Consume with `AsyncValue.when`. The bookmark toggle controller
/// ([bookmarkToggleControllerProvider]) invalidates this provider to re-read
/// the list from the server after a change (non-optimistic refresh).
final bookmarkListProvider =
    FutureProvider<List<BookmarkSentence>>((ref) async {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return repo.fetchBookmarks();
});
