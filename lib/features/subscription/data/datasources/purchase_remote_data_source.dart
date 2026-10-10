import 'package:dio/dio.dart';

import '../models/entitlement_dto.dart';

/// One store receipt, as the server's `PurchaseItem` expects it.
typedef ReceiptPayload = ({
  String productId,
  String transactionId,
  String purchaseToken,
});

/// Talks to `/purchases/*`. Returns DTOs; dio errors propagate to the
/// repository, which maps them to `AppException`.
class PurchaseRemoteDataSource {
  PurchaseRemoteDataSource(this._dio);

  final Dio _dio;

  /// `POST /purchases/verify` — hand one fresh receipt to the server, which
  /// re-checks it against the store and grants what it bought.
  ///
  /// Idempotent by contract: the same receipt sent twice returns 200 with
  /// `already_granted: true`, never an error.
  Future<VerifyResultDto> verify({
    required ReceiptPayload receipt,
    required String platform,
    bool isSandbox = false,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/purchases/verify',
      data: {
        'product_id': receipt.productId,
        'transaction_id': receipt.transactionId,
        'purchase_token': receipt.purchaseToken,
        'platform': platform,
        'is_sandbox': isSandbox,
      },
    );
    return VerifyResultDto.fromJson(res.data ?? const {});
  }

  /// `POST /purchases/restore` — replay every receipt the store still holds
  /// for this account, after a reinstall or a new phone.
  ///
  /// Sends the batch in one call rather than N verifies: the server counts
  /// `restored` / `failed` for us and returns the settled entitlement once.
  Future<RestoreResultDto> restore({
    required List<ReceiptPayload> receipts,
    required String platform,
    bool isSandbox = false,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/purchases/restore',
      data: {
        'platform': platform,
        'is_sandbox': isSandbox,
        'purchases': [
          for (final r in receipts)
            {
              'product_id': r.productId,
              'transaction_id': r.transactionId,
              'purchase_token': r.purchaseToken,
            },
        ],
      },
    );
    return RestoreResultDto.fromJson(res.data ?? const {});
  }

  /// `GET /purchases/entitlement` — what the member owns, without spending a
  /// receipt. The cheap read the app uses on launch.
  Future<EntitlementDto> entitlement() async {
    final res =
        await _dio.get<Map<String, dynamic>>('/purchases/entitlement');
    return EntitlementDto.fromJson(res.data ?? const {});
  }
}
