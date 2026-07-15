import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/payment_remote_data_source.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource(ref.watch(dioProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    remote: ref.watch(paymentRemoteDataSourceProvider),
  );
});

/// First page of payment history for a filter tab (`GET /payments`).
///
/// autoDispose + family: switching tabs fetches that tab and drops the previous
/// one, and leaving the screen releases everything — this is per-member data
/// that must not survive a sign-out (see `AuthController._clearUserScopedState`,
/// which exists because non-autoDispose providers leaked user A's data to B).
///
/// Pagination beyond page 1 is not wired: the server pages at 10 with
/// `has_more`, but the screen has no load-more affordance yet.
final paymentPageProvider =
    FutureProvider.autoDispose.family<PaymentPage, PaymentFilter>(
  (ref, filter) async {
    return ref.watch(paymentRepositoryProvider).listPayments(filter: filter);
  },
);
