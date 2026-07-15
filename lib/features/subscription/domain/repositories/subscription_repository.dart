import '../entities/subscription.dart';

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

  /// Soft-cancels [subscribeId] and returns the updated record.
  ///
  /// Idempotent server-side: cancelling an already-cancelled subscription
  /// succeeds. A subscription belonging to someone else returns 404 (the server
  /// collapses "not yours" into "not found" to avoid id enumeration).
  Future<Subscription> cancel(int subscribeId);
}
