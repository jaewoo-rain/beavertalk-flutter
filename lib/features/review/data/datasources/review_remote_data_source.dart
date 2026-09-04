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

  /// `POST /tts/speech` — 저장되지 않은 **텍스트 단건** 합성(통화 중 힌트 예시).
  ///
  /// ⚠ **응답 본문이 mp3 바이트 그 자체다 — JSON 이 아니다**(백엔드 규약 2026-09-04).
  /// 그래서 `ResponseType.bytes` 로 받는다. 이걸 빼먹으면 dio 가 바이너리를 문자열로
  /// 디코드하려다 깨지고, 화면에는 "소리가 안 난다"로만 보인다.
  ///
  /// 200 만 음성이고 나머지 상태코드는 JSON 에러 바디다 — dio 가 [DioException] 으로
  /// 올리므로 여기서 따로 가르지 않는다. 503 은 외부 TTS 실패(백엔드가 "인터넷 오류"라
  /// 부른 것)이며 호출부가 안내로 폴백한다.
  ///
  /// ⚠ **`character_id` 를 보내지 않는다** — 서버가 토큰으로 회원의 캐릭터를 DB 에서
  /// 직접 찾아 그 목소리로 합성한다(백엔드 확인 2026-09-04: "캐릭터도 그냥 db에서
  /// 해결했었죠, id 없이 가면 될 거 같아요"). 앱이 굳이 실어 보내면 두 출처가 갈릴 수
  /// 있고, 어긋났을 때 어느 쪽이 맞는지 알 방법이 없다.
  Future<Uint8List> speechBytes(String text) async {
    final res = await _dio.post<List<int>>(
      '/tts/speech',
      data: {'text': text},
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(res.data ?? const <int>[]);
  }
}
