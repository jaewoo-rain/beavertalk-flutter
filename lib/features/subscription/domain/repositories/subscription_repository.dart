import '../entities/subscription.dart';
import '../subscription_status_resolver.dart';

/// The member's subscriptions.
///
/// `POST /subscriptions` (start) is intentionally absent: nothing in the app
/// starts a subscription yet, and the server's `start` takes a client-supplied
/// price with no plan catalog behind it — wiring that needs a product decision,
/// not just a method.
abstract class SubscriptionRepository {
  /// All subscriptions, newest first. Includes cancelled ones.
  ///
  /// Throws `AppException` on failure.
  Future<List<Subscription>> listSubscriptions();

  /// The member-level status from `GET /subscriptions/status`, or **null when
  /// the server predates the endpoint** — callers then fall back to inferring
  /// from [listSubscriptions] via `SubscriptionStatusResolver`.
  ///
  /// Throws `AppException` on failure other than the 404 that means "old
  /// server".
  Future<SubscriptionStatus?> fetchStatus();

  /// Soft-cancels [subscribeId] and returns the updated record.
  ///
  /// Idempotent server-side: cancelling an already-cancelled subscription
  /// succeeds. A subscription belonging to someone else returns 404 (the server
  /// collapses "not yours" into "not found" to avoid id enumeration).
  Future<Subscription> cancel(int subscribeId);
}
