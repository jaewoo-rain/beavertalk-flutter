import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../screens/home/learning_summary.dart';
import '../../domain/entities/pron_summary.dart';
import '../models/call_result_dto.dart';

/// Talks to the call status/result endpoints over dio. Returns DTOs / raw
/// status strings; dio errors propagate to the repository which maps them to
/// [AppException].
class NormalcallRemoteDataSource {
  NormalcallRemoteDataSource(this._dio);

  final Dio _dio;

  /// `PATCH /calls/{call_id}` with `{"rating": <int>}` (rating ∈ {1,2,3}).
  /// The CallSummary response body is ignored.
  Future<void> submitRating(int callId, int rating) async {
    await _dio.patch<Map<String, dynamic>>(
      '/calls/$callId',
      data: {'rating': rating},
    );
  }

  /// `GET /calls/{call_id}/status` — returns the raw `status` string.
  Future<String?> getStatus(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId/status');
    return res.data?['status'] as String?;
  }

  /// `GET /calls/{call_id}/result`.
  Future<CallResultDto> getResult(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId/result');
    return CallResultDto.fromJson(res.data!);
  }

  /// `GET /calls/{call_id}/pronunciation-report` — 복습 종료 발음 리포트.
  Future<LearningSummary> getPronunciationReport(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/calls/$callId/pronunciation-report',
    );
    return LearningSummary.fromJson(res.data!);
  }

  /// `GET /calls/pronunciation-summary?sessions=` — 최근 N세션 발음 평균.
  ///
  /// 정적 경로라 서버가 `/{call_id}` 보다 먼저 선언한다. 여기서도 문자열을 직접
  /// 조립하지 말고 [ApiEndpoints] 상수를 쓴다.
  Future<PronSummary> getPronunciationSummary({int sessions = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.callsPronunciationSummary,
      queryParameters: {'sessions': sessions},
    );
    return PronSummary.fromJson(res.data ?? const {});
  }

  /// `GET /calls/{call_id}` — call detail. The `/result` endpoint omits
  /// `call_date`/`total_time`, so we read them here (the CallDetail body is a
  /// superset of CallSummary; extra fields like `sentences` are ignored).
  Future<CallSummaryDto> getCall(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId');
    return CallSummaryDto.fromJson(res.data!);
  }

  /// `GET /calls?limit=&offset=` — past calls, newest first.
  Future<List<CallSummaryDto>> listCalls({int? limit, int? offset}) async {
    final res = await _dio.get<List<dynamic>>(
      '/calls',
      queryParameters: {
        'limit': ?limit,
        'offset': ?offset,
      },
    );
    final data = res.data ?? const [];
    return data
        .map((e) => CallSummaryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
