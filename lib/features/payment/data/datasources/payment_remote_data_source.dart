import 'package:dio/dio.dart';

import '../models/payment_dto.dart';

/// Talks to the payment endpoints over dio. Returns DTOs; dio errors propagate
/// to the repository, which maps them to `AppException`.
class PaymentRemoteDataSource {
  PaymentRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /payments?type=&page=`.
  ///
  /// [type] is the server's tab filter: `all` | `subscribe` | `character`.
  /// [page] is 1-based; the server fixes the size at 10.
  Future<PaymentPageDto> listPayments({
    required String type,
    int page = 1,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/payments',
      queryParameters: {'type': type, 'page': page},
    );
    return PaymentPageDto.fromJson(res.data!);
  }
}
