import 'package:dio/dio.dart';

import '../../domain/entities/alarm.dart';
import '../models/alarm_dto.dart';

/// Talks to the alarm + characters endpoints over dio. Returns DTOs; dio errors
/// propagate to the repository which maps them to [AppException].
class AlarmRemoteDataSource {
  AlarmRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /alarms`.
  Future<List<AlarmDto>> list() async {
    final res = await _dio.get<List<dynamic>>('/alarms');
    final data = res.data ?? const [];
    return data
        .map((e) => AlarmDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /alarms` (201).
  Future<AlarmDto> create(Alarm alarm) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/alarms',
      data: AlarmDto.createBody(alarm),
    );
    return AlarmDto.fromJson(res.data!);
  }

  /// `GET /alarms/{id}`.
  Future<AlarmDto> get(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/alarms/$id');
    return AlarmDto.fromJson(res.data!);
  }

  /// `PUT /alarms/{id}`.
  Future<AlarmDto> update(Alarm alarm) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/alarms/${alarm.id}',
      data: AlarmDto.updateBody(alarm),
    );
    return AlarmDto.fromJson(res.data!);
  }

  /// `DELETE /alarms/{id}`.
  Future<void> delete(int id) async {
    await _dio.delete<void>('/alarms/$id');
  }

  /// `POST /alarms/{id}/activate`.
  Future<AlarmDto> activate(int id) async {
    final res = await _dio.post<Map<String, dynamic>>('/alarms/$id/activate');
    return AlarmDto.fromJson(res.data!);
  }

  /// `POST /alarms/{id}/deactivate`.
  Future<AlarmDto> deactivate(int id) async {
    final res = await _dio.post<Map<String, dynamic>>('/alarms/$id/deactivate');
    return AlarmDto.fromJson(res.data!);
  }

  /// `GET /characters` — read-only picker source.
  Future<List<CharacterDto>> listCharacters() async {
    final res = await _dio.get<List<dynamic>>('/characters');
    final data = res.data ?? const [];
    return data
        .map((e) => CharacterDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
