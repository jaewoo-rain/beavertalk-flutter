import '../entities/payment.dart';

/// Read-only access to the member's payment history.
///
/// There is no create/refund method: charges are written by the purchase and
/// subscription flows, not by this screen.
abstract class PaymentRepository {
  /// One page of history for [filter], 1-based [page].
  ///
  /// Throws `AppException` on failure.
  Future<PaymentPage> listPayments({
    PaymentFilter filter = PaymentFilter.all,
    int page = 1,
  });
}
