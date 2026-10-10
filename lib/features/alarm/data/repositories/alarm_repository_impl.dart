import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_remote_data_source.dart';
import '../models/alarm_dto.dart';

/// Seam between data and domain: DTO↔entity conversion and
/// [DioException]→[AppException] mapping.
class AlarmRepositoryImpl implements AlarmRepository {
  AlarmRepositoryImpl({required AlarmRemoteDataSource remote})
      : _remote = remote;

  final AlarmRemoteDataSource _remote;

  @override
  Future<List<Alarm>> list() async {
    try {
      final dtos = await _remote.list();
      _backfillTimezone(dtos);
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  /// 시간대가 비어 있는 **켜진** 알람을 기기 시간대로 한 번 다시 저장한다(F008 · PM-DEC-167).
  ///
  /// 예전 앱은 `tz` 를 안 보내서, 비한국어 회원 알람이 서울 기준으로 울렸다. 사용자 조작 없이
  /// 목록을 읽을 때 조용히 고친다 — 실패해도 목록 표시는 막지 않는다(다음 목록 조회에 다시 시도).
  /// `update` 가 기기 `tz` 를 싣는다. 한 세션에 알람마다 한 번만 보낸다.
  void _backfillTimezone(List<AlarmDto> dtos) {
    for (final d in dtos) {
      if (d.isActivate != true || (d.tz?.isNotEmpty ?? false)) continue;
      if (!_tzBackfilled.add(d.alarmId)) continue;
      _remote.update(d.toEntity()).then((_) {}, onError: (Object _) {
        _tzBackfilled.remove(d.alarmId);
      });
    }
  }

  final Set<int> _tzBackfilled = {};

  @override
  Future<Alarm> create(Alarm alarm) async {
    try {
      final dto = await _remote.create(alarm);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Alarm> get(int id) async {
    try {
      final dto = await _remote.get(id);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Alarm> update(Alarm alarm) async {
    try {
      final dto = await _remote.update(alarm);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _remote.delete(id);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Alarm> activate(int id) async {
    try {
      final dto = await _remote.activate(id);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Alarm> deactivate(int id) async {
    try {
      final dto = await _remote.deactivate(id);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<AlarmCharacter>> listCharacters() async {
    try {
      final dtos = await _remote.listCharacters();
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
