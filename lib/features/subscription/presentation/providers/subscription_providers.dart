import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/purchases_remote_data_source.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

final subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDataSource>((ref) {
  return SubscriptionRemoteDataSource(ref.watch(dioProvider));
});

/// Server-side receipt validation (`/purchases/verify` · `/restore`).
///
/// Separate from [subscriptionRemoteDataSourceProvider] because it serves both
/// rails: subscriptions **and** character non-consumables run through the same
/// store receipts.
final purchasesRemoteDataSourceProvider =
    Provider<PurchasesRemoteDataSource>((ref) {
  return PurchasesRemoteDataSource(ref.watch(dioProvider));
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(
    remote: ref.watch(subscriptionRemoteDataSourceProvider),
  );
});

/// All of the member's subscriptions (`GET /subscriptions`), newest first.
///
/// autoDispose: per-member data. Non-autoDispose user-scoped providers are what
/// leaked user A's state into user B's session (see
/// `AuthController._clearUserScopedState`).
final subscriptionsProvider =
    FutureProvider.autoDispose<List<Subscription>>((ref) async {
  return ref.watch(subscriptionRepositoryProvider).listSubscriptions();
});

// `currentSubscriptionProvider` now lives in `subscription_state_providers.dart`.
//
// What counts as "active" is decided in exactly one place —
// `SubscriptionStatusResolver` — because 42 subscription screens are about to
// read it, and each one keeping its own expiry check is how they drift apart
// (work order §4-1-2). Importing it back here would make the two provider files
// circular, so the status file owns it and this one stays plumbing.
