import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/purchase_remote_data_source.dart';
import '../../data/models/entitlement_dto.dart';
import '../../data/repositories/purchase_repository_impl.dart';
import '../../domain/repositories/purchase_repository.dart';

final purchaseRemoteDataSourceProvider =
    Provider<PurchaseRemoteDataSource>((ref) {
  return PurchaseRemoteDataSource(ref.watch(dioProvider));
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepositoryImpl(
    remote: ref.watch(purchaseRemoteDataSourceProvider),
  );
});

/// `GET /purchases/entitlement` — what the member owns right now.
///
/// The cheap read: no receipt is spent and no store round trip happens, so
/// screens can ask on entry. autoDispose because it is per-member.
final entitlementProvider =
    FutureProvider.autoDispose<EntitlementDto>((ref) async {
  return ref.watch(purchaseRepositoryProvider).entitlement();
});
