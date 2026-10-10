import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/sound_lesson.dart';
import '../../domain/entities/sound_result.dart';
import '../../domain/entities/weak_sound_item.dart';
import '../models/weak_sound_dto.dart';

/// 취약 발음 학습 엔드포인트 3종. Bearer 헤더는 dio 인터셉터가 붙인다.
class WeakSoundRemoteDataSource {
  WeakSoundRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /pronunciation/weak-sounds`.
  Future<WeakSoundList> list() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.weakSounds);
    return WeakSoundListDto.parse(res.data ?? const {});
  }

  /// `GET /pronunciation/weak-sounds/{sound_key}/lesson`.
  ///
  /// ⚠️ `sound_key` 에 **한글 자모가 들어간다**(`coda_ㄹ`). dio 가 경로를 인코딩하지만
  /// 문자열을 직접 이어 붙이면 그 보장이 사라진다 — 반드시 [Uri.encodeComponent] 로 감싼다.
  Future<SoundLesson> lesson(String soundKey) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.weakSoundLesson(soundKey),
    );
    return SoundLessonDto.parse(res.data ?? const {});
  }

  /// `POST /pronunciation/weak-sounds/{sound_key}/assess` — multipart/form-data.
  ///
  /// 폼 필드는 `audio` 하나다. **점수를 보내지 않는다** — 채점은 서버가 한다.
  Future<SoundResult> assess(String soundKey, Uint8List wavBytes) async {
    final form = FormData.fromMap({
      'audio': MultipartFile.fromBytes(
        wavBytes,
        filename: 'weak_sound.wav',
        contentType: MediaType('audio', 'wav'),
      ),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.weakSoundAssess(soundKey),
      data: form,
    );
    return SoundResultDto.parse(res.data ?? const {});
  }
}
