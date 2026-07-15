import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

/// Seam between data and domain: DTO↔entity conversion and
/// [DioException]→`AppException` mapping.
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required PaymentRemoteDataSource remote})
      : _remote = remote;

  final PaymentRemoteDataSource _remote;

  @override
  Future<PaymentPage> listPayments({
    PaymentFilter filter = PaymentFilter.all,
    int page = 1,
  }) async {
    try {
      final dto = await _remote.listPayments(type: filter.wire, page: page);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
