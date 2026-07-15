import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_data_source.dart';

/// Seam between data and domain: DTO↔entity conversion and
/// [DioException]→`AppException` mapping.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({required SubscriptionRemoteDataSource remote})
      : _remote = remote;

  final SubscriptionRemoteDataSource _remote;

  @override
  Future<List<Subscription>> listSubscriptions() async {
    try {
      final dtos = await _remote.listSubscriptions();
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Subscription> cancel(int subscribeId) async {
    try {
      final dto = await _remote.cancel(subscribeId);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
