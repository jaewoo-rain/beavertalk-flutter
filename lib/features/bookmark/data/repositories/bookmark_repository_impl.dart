import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/bookmark_sentence.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_remote_data_source.dart';

/// Seam between data and domain: DTO→entity conversion and
/// [DioException]→[AppException] mapping.
class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl({required BookmarkRemoteDataSource remote})
      : _remote = remote;

  final BookmarkRemoteDataSource _remote;

  @override
  Future<List<BookmarkSentence>> fetchBookmarks() async {
    try {
      final dtos = await _remote.fetchBookmarks();
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<BookmarkSentence> setBookmark(
      int sentenceId, bool isBookmarked) async {
    try {
      final dto = await _remote.setBookmark(sentenceId, isBookmarked);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
