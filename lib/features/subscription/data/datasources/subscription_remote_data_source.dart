import 'package:dio/dio.dart';

import '../models/subscription_dto.dart';
import '../models/subscription_status_dto.dart';

/// Talks to the subscription endpoints over dio. Returns DTOs; dio errors
/// propagate to the repository, which maps them to `AppException`.
class SubscriptionRemoteDataSource {
  SubscriptionRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /subscriptions` — every subscription for the member, newest first
  /// (server orders by `subscribe_id DESC`). Cancelled ones are included:
  /// cancel is a soft flag, not a delete.
  Future<List<SubscriptionDto>> listSubscriptions() async {
    final res = await _dio.get<List<dynamic>>('/subscriptions');
    final data = res.data ?? const [];
    return data
        .map((e) => SubscriptionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /subscriptions/status` — the member-level status, or **null when the
  /// server does not have the endpoint yet** (404).
  ///
  /// Proposed in `docs/2026-08-03_1844_서버제안_구독상태_스키마확장.md`; written
  /// ahead of the server so the app flips over the day it ships. Every other
  /// error propagates normally — a 500 is an outage, not an old server.
  Future<SubscriptionStatusDto?> getStatus() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/subscriptions/status');
      final data = res.data;
      return data == null ? null : SubscriptionStatusDto.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// `POST /subscriptions/{id}/cancel` — soft-cancels and returns the updated
  /// row. Takes no request body.
  Future<SubscriptionDto> cancel(int subscribeId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/subscriptions/$subscribeId/cancel',
    );
    return SubscriptionDto.fromJson(res.data!);
  }
}
