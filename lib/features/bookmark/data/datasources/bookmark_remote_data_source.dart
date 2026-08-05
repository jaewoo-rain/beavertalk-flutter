import 'package:dio/dio.dart';

import '../models/sentence_out_dto.dart';

/// Talks to the bookmark endpoints over dio. Returns DTOs; dio errors propagate
/// to the repository which maps them to [AppException].
///
/// The [Dio] is the shared `dioProvider` instance, so `Authorization: Bearer`
/// is attached automatically by `AuthInterceptor` — no manual headers here.
/// Paths are relative; the base URL already carries the host + `/api/v1`.
class BookmarkRemoteDataSource {
  BookmarkRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /members/me/bookmarks` — the current member's bookmarked sentences
  /// (`SentenceOut[]`).
  Future<List<SentenceOutDto>> fetchBookmarks() async {
    final res = await _dio.get<List<dynamic>>('/members/me/bookmarks');
    final data = res.data ?? const [];
    return data
        .map((e) => SentenceOutDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `PATCH /sentences/{id}/bookmark` — set/clear the bookmark; returns the
  /// updated sentence (`SentenceOut`). Body: `{"is_bookmarked": <bool>}`.
  Future<SentenceOutDto> setBookmark(int sentenceId, bool isBookmarked) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/sentences/$sentenceId/bookmark',
      data: {'is_bookmarked': isBookmarked},
    );
    return SentenceOutDto.fromJson(res.data!);
  }
}
