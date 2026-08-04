import 'dart:io' show Platform;

import 'package:dio/dio.dart';

import '../../domain/iap_service.dart';

/// Server-side receipt validation — `POST /purchases/verify` · `/restore`.
///
/// ## Why the server has to see the receipt
///
/// The store tells the *app* a purchase succeeded. Trusting that alone means
/// anyone who can talk to our API can claim to have paid. The receipt token is
/// the part Apple/Google will confirm, and only the server holds the
/// credentials to ask them — so entitlement is granted server-side or not at
/// all.
///
/// ## Why restore also goes through here
///
/// Replaying ownership purely on the device would leave the server unaware
/// that a reinstalled member still owns their characters. `restore` therefore
/// re-posts the receipts and lets the server re-grant, which is idempotent by
/// `UNIQUE(platform, transaction_id)`.
class PurchasesRemoteDataSource {
  PurchasesRemoteDataSource(this._dio);

  final Dio _dio;

  /// `ios` | `android` — the only two the server accepts.
  ///
  /// Anything else (desktop/web during development) is reported as `android`
  /// so the call shape stays valid; those builds never carry real receipts
  /// anyway, so they cannot pass verification.
  static String get platform => Platform.isIOS ? 'ios' : 'android';

  /// Verifies one purchase and grants the entitlement.
  ///
  /// Returns the raw response so callers can read `already_granted` — which is
  /// a **success**, not an error: repeat deliveries are normal.
  Future<Map<String, dynamic>> verify(
    IapPurchase purchase, {
    bool isSandbox = false,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/purchases/verify',
      data: {
        'platform': platform,
        'product_id': purchase.productId,
        'transaction_id': purchase.transactionId,
        'purchase_token': purchase.purchaseToken,
        'is_sandbox': isSandbox,
      },
    );
    return res.data ?? const {};
  }

  /// Re-posts every receipt the store replayed, in one call.
  ///
  /// The server answers 200 even when some are invalid (`restored` / `failed`
  /// counts), so a single bad receipt does not sink the whole restore.
  Future<Map<String, dynamic>> restore(
    List<IapPurchase> purchases, {
    bool isSandbox = false,
  }) async {
    final items = purchases
        .where((p) => p.hasReceipt)
        .map((p) => {
              'product_id': p.productId,
              'transaction_id': p.transactionId,
              'purchase_token': p.purchaseToken,
            })
        .toList();
    // The server requires a non-empty list; nothing to restore is not an error.
    if (items.isEmpty) return const {'restored': 0, 'failed': 0};

    final res = await _dio.post<Map<String, dynamic>>(
      '/purchases/restore',
      data: {
        'platform': platform,
        'purchases': items,
        'is_sandbox': isSandbox,
      },
    );
    return res.data ?? const {};
  }

  /// `GET /purchases/entitlement` — what the member may use **right now**.
  ///
  /// The server decides expiry; the app must not compare `pro_expires_at`
  /// itself, because a wound-back device clock would then buy free access.
  Future<Map<String, dynamic>> entitlement() async {
    final res = await _dio.get<Map<String, dynamic>>('/purchases/entitlement');
    return res.data ?? const {};
  }
}
