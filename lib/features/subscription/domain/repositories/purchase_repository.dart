import '../../data/models/entitlement_dto.dart';
import '../iap_service.dart';

/// Server-side half of the IAP rail — receipt verification and entitlement.
///
/// Kept as an interface for the same reason [IapService] is: the store rail
/// calls it on every purchase, and tests need to run that path without a
/// backend.
abstract class PurchaseRepository {
  /// Verifies one fresh receipt and returns what it bought.
  Future<VerifyResultDto> verify(IapPurchase purchase);

  /// Verifies a batch of restored receipts in one call.
  Future<RestoreResultDto> restore(List<IapPurchase> purchases);

  /// Reads the current entitlement without spending a receipt.
  Future<EntitlementDto> entitlement();
}
