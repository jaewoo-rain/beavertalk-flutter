import 'package:dio/dio.dart';

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
