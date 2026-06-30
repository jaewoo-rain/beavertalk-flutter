import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/call_result.dart';
import '../../domain/repositories/normalcall_repository.dart';
import '../datasources/normalcall_remote_data_source.dart';

/// Seam between data and domain: DTO↔entity conversion and
/// [DioException]→[AppException] mapping.
class NormalcallRepositoryImpl implements NormalcallRepository {
  NormalcallRepositoryImpl({required NormalcallRemoteDataSource remote})
      : _remote = remote;

  final NormalcallRemoteDataSource _remote;

  @override
  Future<void> submitRating(int callId, int rating) async {
    try {
      await _remote.submitRating(callId, rating);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<CallAnalysisStatus> getStatus(int callId) async {
    try {
      final status = await _remote.getStatus(callId);
      return CallAnalysisStatus.parse(status);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<CallResult> getResult(int callId) async {
    try {
      final dto = await _remote.getResult(callId);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<CallSummary>> listCalls({int? limit, int? offset}) async {
    try {
      final dtos = await _remote.listCalls(limit: limit, offset: offset);
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<int?> latestCallId() async {
    try {
      // Pull a small page and take max(call_id) so ordering need not be assumed
      // (call_id is a monotonically increasing int → max == newest).
      final dtos = await _remote.listCalls(limit: 5);
      if (dtos.isEmpty) return null;
      return dtos
          .map((d) => d.toEntity().callId)
          .reduce((a, b) => a > b ? a : b);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
