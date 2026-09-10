import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/iap_service.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_remote_data_source.dart';
import '../models/entitlement_dto.dart';

/// Seam between the store rail and the server: receipts in, entitlement out.
class PurchaseRepositoryImpl implements PurchaseRepository {
  PurchaseRepositoryImpl({required PurchaseRemoteDataSource remote})
      : _remote = remote;

  final PurchaseRemoteDataSource _remote;

  /// Which store the receipt came from.
  ///
  /// The server picks Apple's or Google's verification endpoint from this, so
  /// a wrong value is a guaranteed rejection rather than a silent mismatch.
  /// Everything that is not iOS is Android — there is no third store, and the
  /// desktop/web builds never reach a purchase in the first place.
  static String get _platform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
          ? 'ios'
          : 'android';

  /// ⚠ [IapPurchase] 는 두 값을 **nullable** 로 들고, 서버 페이로드는 아니다.
  ///   목업 레일에는 스토어 거래가 없어서 null 이 정상이기 때문이다.
  ///   ⇒ 여기 닿기 전에 호출부가 [IapPurchase.hasReceipt] 로 거른다
  ///     (`avatar.dart:580`, `purchases_remote_data_source.dart:65`).
  ///   빈 문자열로 떨어뜨리는 이유: 그래도 새어 들어오면 **서버가 거절**하고,
  ///   그 거절은 이미 실패 경로가 받아 다음 실행에 재시도한다. 조용히 성공하는
  ///   경우가 없다 — 그게 여기서 던지지 않는 근거다.
  static ReceiptPayload _payload(IapPurchase p) => (
        productId: p.productId,
        transactionId: p.transactionId ?? '',
        purchaseToken: p.purchaseToken ?? '',
      );

  @override
  Future<VerifyResultDto> verify(IapPurchase purchase) async {
    try {
      return await _remote.verify(
        receipt: _payload(purchase),
        platform: _platform,
        isSandbox: purchase.isSandbox,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<RestoreResultDto> restore(List<IapPurchase> purchases) async {
    try {
      return await _remote.restore(
        receipts: purchases.map(_payload).toList(),
        platform: _platform,
        // One sandbox receipt in the batch makes the whole batch sandbox: a
        // device is signed into one store account at a time, so the flag
        // cannot legitimately differ between receipts in a single restore.
        isSandbox: purchases.any((p) => p.isSandbox),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<EntitlementDto> entitlement() async {
    try {
      return await _remote.entitlement();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
