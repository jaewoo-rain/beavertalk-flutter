import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_data_source.dart';

/// data↔domain 경계: [DioException]→[AppException] 매핑.
class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl({required DeviceRemoteDataSource remote})
      : _remote = remote;

  final DeviceRemoteDataSource _remote;

  @override
  Future<void> register({
    required String platform,
    required String token,
  }) async {
    try {
      await _remote.register(platform: platform, token: token);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> delete(String token) async {
    try {
      await _remote.delete(token);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
