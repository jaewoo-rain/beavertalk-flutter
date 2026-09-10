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
    Uint8List wavBytes, {
    bool applyScore = true,
  }) async {
    try {
      final dto = await _remote.submitAudio(
        sentenceId,
        wavBytes,
        applyScore: applyScore,
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<String?> sentenceTtsUrl(int sentenceId) async {
    try {
      return await _remote.sentenceTtsUrl(sentenceId);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Uint8List?> speech(String text) async {
    try {
      final bytes = await _remote.speechBytes(text);
      return bytes.isEmpty ? null : bytes;
    } on DioException catch (e) {
      // 503 = 백엔드의 외부 TTS 가 안 될 때다("인터넷 오류니까 폴백해주세요").
      // 예외로 올리지 않고 null 로 내려 호출부가 안내 문구로 폴백하게 한다.
      if (e.response?.statusCode == 503) return null;
      throw mapDioException(e);
    }
  }
}
