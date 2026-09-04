import '../../domain/entities/call_resume_status.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../../../screens/home/learning_summary.dart';
import '../../domain/entities/call_result.dart';
import '../../domain/entities/pron_summary.dart';
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
      final result = await _remote.getResult(callId);
      final entity = result.toEntity();
      // The `/result` endpoint omits call_date/total_time; recover them from the
      // call detail (`GET /calls/{id}`) so the analysis screen shows the real
      // date/duration. Best-effort: a failure here just leaves them hidden.
      try {
        final meta = (await _remote.getCall(callId)).toEntity();
        return entity.copyWith(
          callDate: meta.callDate,
          totalTime: meta.totalTime,
        );
      } catch (_) {
        return entity;
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LearningSummary> getPronunciationReport(int callId) async {
    try {
      return await _remote.getPronunciationReport(callId);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<PronSummary> getPronunciationSummary({int sessions = 10}) async {
    try {
      return await _remote.getPronunciationSummary(sessions: sessions);
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
  Future<CallResumeStatus?> getResumeStatus(int callId) async {
    try {
      final json = await _remote.getResumeStatus(callId);
      if (json == null) return null;
      return CallResumeStatus.fromJson(json);
    } on DioException catch (_) {
      // ⛔ **던지지 않는다.** 이걸 못 물어봤다고 통화를 막을 이유가 없다 — 호출부가
      //   로컬 계산(`CallAllowance`)으로 내려간다. 404 는 **구버전 서버**이거나
      //   **남의 통화**이고(백엔드 문서 §2③), 네트워크 실패도 마찬가지로 「모른다」다.
      //   셋 다 null 이 맞는 답이라 사유로 가르지 않는다.
      return null;
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
