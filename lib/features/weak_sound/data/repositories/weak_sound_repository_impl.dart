import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/sound_lesson.dart';
import '../../domain/entities/sound_result.dart';
import '../../domain/entities/weak_sound_item.dart';
import '../../domain/repositories/weak_sound_repository.dart';
import '../datasources/weak_sound_remote_data_source.dart';

/// data↔domain 경계: DTO 파싱은 데이터소스가, [DioException]→`AppException` 매핑은
/// 여기가 한다(복습·교실 리포지토리와 같은 형태).
class WeakSoundRepositoryImpl implements WeakSoundRepository {
  WeakSoundRepositoryImpl({required WeakSoundRemoteDataSource remote})
      : _remote = remote;

  final WeakSoundRemoteDataSource _remote;

  @override
  Future<WeakSoundList> list() async {
    try {
      return await _remote.list();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<SoundLesson> lesson(String soundKey) async {
    try {
      return await _remote.lesson(soundKey);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<SoundResult> assess(String soundKey, Uint8List wavBytes) async {
    try {
      return await _remote.assess(soundKey, wavBytes);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
