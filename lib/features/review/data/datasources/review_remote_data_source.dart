import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

import '../models/review_feedback_dto.dart';

/// Talks to the pronunciation-review endpoint over dio. Returns DTOs; dio
/// errors propagate to the repository which maps them to [AppException].
class ReviewRemoteDataSource {
  ReviewRemoteDataSource(this._dio);

  final Dio _dio;

  /// `POST /sentences/{sentence_id}/reviews/audio` — multipart/form-data.
  ///
  /// Uploads [wavBytes] (a complete WAV file, PCM16/16000Hz/mono) under the
  /// form field `audio`. The Bearer header is attached by the dio interceptor.
  /// Returns the parsed 201 ReviewFeedback.
  ///
  /// [applyScore] → `apply_score` form field. True(복습): 문장 공식점수에 반영.
  /// False(연습): 채점·이력·음성은 저장·반환하되 공식점수는 불변(미반영).
  Future<ReviewFeedbackDto> submitAudio(
    int sentenceId,
    Uint8List wavBytes, {
    bool applyScore = true,
  }) async {
    final form = FormData.fromMap({
      'audio': MultipartFile.fromBytes(
        wavBytes,
        filename: 'review.wav',
        contentType: MediaType('audio', 'wav'),
      ),
      'apply_score': applyScore.toString(),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      '/sentences/$sentenceId/reviews/audio',
      data: form,
    );
    return ReviewFeedbackDto.fromJson(res.data!);
  }

  /// `POST /sentences/{id}/tts` — on-demand standard-pronunciation TTS.
  /// Returns the playable `voice_url` (public URL), or null when synthesis is
  /// unavailable. Idempotent server-side (re-uses an existing url).
  Future<String?> sentenceTtsUrl(int sentenceId) async {
    final res =
        await _dio.post<Map<String, dynamic>>('/sentences/$sentenceId/tts');
    return res.data?['voice_url'] as String?;
  }
}
