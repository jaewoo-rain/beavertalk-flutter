import 'package:dio/dio.dart';

import '../models/subscription_dto.dart';

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

  /// `POST /subscriptions/{id}/cancel` — soft-cancels and returns the updated
  /// row. Takes no request body.
  Future<SubscriptionDto> cancel(int subscribeId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/subscriptions/$subscribeId/cancel',
    );
    return SubscriptionDto.fromJson(res.data!);
  }
}
