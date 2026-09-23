import '../../domain/entities/call_resume_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/time/device_timezone.dart';
import '../../../../screens/home/learning_summary.dart';
import '../../domain/entities/calendar_stats.dart';
import '../../domain/entities/call_result.dart';
import '../../domain/entities/cur_me.dart';
import '../../domain/entities/daily_status.dart';
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
  Future<CurMe> getCurMe() async {
    try {
      return await _remote.getCurMe();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<CurResetResult> resetCurriculum() async {
    try {
      return await _remote.resetCurriculum();
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
  Future<CallResumeStatus?> getResumeStatus(int callId, {String? planOverride}) async {
    try {
      final json = await _remote.getResumeStatus(callId, planOverride: planOverride);
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

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}'
      '-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<CalendarStats?> getCalendarStats(DateTime start, DateTime end) async {
    try {
      final json = await _remote.getCalendarStats(
        start: _ymd(start),
        end: _ymd(end),
        tzParams: await DeviceTimezone.params(),
      );
      return CalendarStats.tryParse(json);
    } catch (e) {
      // ⛔ 던지지 않는다 — 구서버(404)·네트워크·모양 오류 전부 「모른다」다. 호출부가
      //   `GET /calls` 로 세는 종전 계산으로 간다([getResumeStatus] 와 같은 규율).
      //   다만 로그는 남긴다 — daily-status 의 422 가 이런 catch 에 묻혔다(09-24).
      debugPrint('[stats/calendar] 실패 — 종전 계산으로 간다: $e');
      return null;
    }
  }

  @override
  Future<DailyStatus?> getDailyStatus() async {
    try {
      final json = await _remote.getDailyStatus(
        date: _ymd(DateTime.now()),
        tz: await DeviceTimezone.iana(),
        tzOffsetMin: DeviceTimezone.offsetMinutes(),
      );
      return DailyStatus.tryParse(json);
    } catch (e) {
      // 던지지 않는다(호출부가 행을 숨기거나 종전 판정으로 간다). 다만 **조용히 삼키지 않는다** —
      // 422(필수 쿼리 누락)가 이 catch 에 묻혀 게이트·시험을 통과한 적이 있다(09-24).
      debugPrint('[daily-status] 실패 — 모름(null)으로 둔다: $e');
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
