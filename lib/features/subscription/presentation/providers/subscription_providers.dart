import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

final subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDataSource>((ref) {
  return SubscriptionRemoteDataSource(ref.watch(dioProvider));
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

/// The subscription to treat as current, or null when none is active.
///
/// The server has no "active subscription" endpoint and nothing prevents
/// several concurrently-active rows (`start` never checks for an existing one),
/// so this takes the newest active row rather than assuming uniqueness. Expiry
/// is evaluated client-side — see [Subscription.isCurrentlyActive].
final currentSubscriptionProvider = Provider.autoDispose<Subscription?>((ref) {
  final subs = ref.watch(subscriptionsProvider).valueOrNull ?? const [];
  for (final s in subs) {
    if (s.isCurrentlyActive) return s;
  }
  return null;
});
