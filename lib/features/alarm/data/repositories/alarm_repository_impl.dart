import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_remote_data_source.dart';

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
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

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
