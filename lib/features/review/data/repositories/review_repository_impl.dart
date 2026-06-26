import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/review_feedback.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

/// Seam between data and domain: DTO→entity conversion and
/// [DioException]→[AppException] mapping.
class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({required ReviewRemoteDataSource remote})
      : _remote = remote;

  final ReviewRemoteDataSource _remote;

  @override
  Future<ReviewFeedback> submitAudio(
    int sentenceId,
    Uint8List wavBytes,
  ) async {
    try {
      final dto = await _remote.submitAudio(sentenceId, wavBytes);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
