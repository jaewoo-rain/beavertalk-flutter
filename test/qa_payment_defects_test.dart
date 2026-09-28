import 'dart:async';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/repositories/character_repository.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/data/models/entitlement_dto.dart';
import 'package:beavertalk/features/subscription/data/repositories/purchase_repository_impl.dart';
import 'package:beavertalk/features/subscription/data/store_iap_service.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/domain/repositories/purchase_repository.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:beavertalk/screens/overlays/subscription_overlays.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// QA 09-26 결제 결함 — 서버 영수증 검증이 켜진 뒤(서버 `107a961` · PM 09-27 배정).
///
/// F003 복원 결과 · F004 보류 결제 · F005 검증 실패 ≠ 카드 거절 · F015 캐릭터 스토어 조회 실패 ·
/// F016 캐릭터 영수증 이중 검증 · F022 부여된 Premium 의 「$0 · Next payment —」 · F028 실패 코드 4종.

// ── 가짜 스토어·서버 ────────────────────────────────────────────────────────

class _FakeStore implements InAppPurchase {
  final _stream = StreamController<List<PurchaseDetails>>.broadcast();
  final completed = <String>[];
  List<PurchaseDetails> restorable = const [];

  void emit(PurchaseDetails pd) => _stream.add([pd]);

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _stream.stream;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async =>
      completed.add(purchase.verificationData.serverVerificationData);

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    for (final pd in restorable) {
      emit(pd);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PurchaseDetails _pd(String token, PurchaseStatus status,
        {String product = 'bt_max_monthly'}) =>
    PurchaseDetails(
      purchaseID: 'order-$token',
      productID: product,
      verificationData: PurchaseVerificationData(
        localVerificationData: token,
        serverVerificationData: token,
        source: 'google_play',
      ),
      transactionDate: '0',
      status: status,
    )..pendingCompletePurchase = true;

class _FakeServer implements PurchaseRepository {
  Object? verifyError;
  Object? restoreError;
  RestoreResultDto restoreResult = const RestoreResultDto(
    restored: 0,
    failed: 0,
    entitlement: EntitlementDto(isPro: false),
  );

  @override
  Future<VerifyResultDto> verify(IapPurchase purchase) async {
    if (verifyError != null) throw verifyError!;
    return const VerifyResultDto(
      productId: 'bt_max_monthly',
      kind: PurchaseKind.subscription,
      entitlement: EntitlementDto(isPro: true),
    );
  }

  @override
  Future<RestoreResultDto> restore(List<IapPurchase> purchases) async {
    if (restoreError != null) throw restoreError!;
    return restoreResult;
  }

  @override
  Future<EntitlementDto> entitlement() async => const EntitlementDto(isPro: false);
}

Widget _app(Widget home,
        {List<Override> overrides = const [], Map<String, WidgetBuilder>? routes}) =>
    ProviderScope(
      key: UniqueKey(),
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
        routes: routes ?? const {},
      ),
    );

void main() {
  // ── F028 · F005 — 레일이 실패를 가른다 ──────────────────────────────────────
  group('F028 — 검증 실패 코드 4종', () {
    test('서버 detail.code 를 읽는다', () {
      DioException err(int status, String code) => DioException(
            requestOptions: RequestOptions(path: '/purchases/verify'),
            response: Response(
              requestOptions: RequestOptions(path: '/purchases/verify'),
              statusCode: status,
              data: {
                'detail': {'code': code, 'message': 'x'}
              },
            ),
            type: DioExceptionType.badResponse,
          );
      expect(IapVerifyRejection.fromCode(
              PurchaseRepositoryImpl.verifyErrorCode(err(422, 'INVALID_RECEIPT'))),
          IapVerifyRejection.invalidReceipt);
      expect(IapVerifyRejection.fromCode(
              PurchaseRepositoryImpl.verifyErrorCode(err(409, 'RECEIPT_OWNED_BY_OTHER'))),
          IapVerifyRejection.ownedByOther);
      expect(IapVerifyRejection.fromCode(
              PurchaseRepositoryImpl.verifyErrorCode(err(404, 'UNKNOWN_PRODUCT'))),
          IapVerifyRejection.unknownProduct);
      expect(IapVerifyRejection.fromCode(
              PurchaseRepositoryImpl.verifyErrorCode(err(503, 'VERIFY_UNAVAILABLE'))),
          IapVerifyRejection.unavailable);
      expect(IapVerifyRejection.fromCode('PRICE_CHANGED'), isNull);
    });

    Future<(IapPurchase, _FakeStore)> deliver(Object? verifyError) async {
      final store = _FakeStore();
      final server = _FakeServer()..verifyError = verifyError;
      final rail = StoreIapService(server: server, store: store);
      final next = rail.purchases.first;
      store.emit(_pd('t1', PurchaseStatus.purchased));
      final ev = await next;
      await rail.dispose();
      return (ev, store);
    }

    test('INVALID_RECEIPT → rejected · 거래를 닫는다(재시도 무의미)', () async {
      final (ev, store) = await deliver(
          const IapVerifyException(IapVerifyRejection.invalidReceipt));
      expect(ev.state, IapPurchaseState.failed);
      expect(ev.failure, IapFailure.rejected);
      expect(store.completed, ['t1']);
    });

    test('RECEIPT_OWNED_BY_OTHER → otherAccount · 거래를 닫는다', () async {
      final (ev, store) = await deliver(
          const IapVerifyException(IapVerifyRejection.ownedByOther));
      expect(ev.failure, IapFailure.otherAccount);
      expect(store.completed, ['t1']);
    });

    test('VERIFY_UNAVAILABLE · UNKNOWN_PRODUCT · 네트워크 → verifyPending · 닫지 않는다', () async {
      for (final e in <Object>[
        const IapVerifyException(IapVerifyRejection.unavailable),
        const IapVerifyException(IapVerifyRejection.unknownProduct),
        const NetworkFailure(),
      ]) {
        final (ev, store) = await deliver(e);
        expect(ev.failure, IapFailure.verifyPending, reason: '$e');
        expect(store.completed, isEmpty, reason: '다음 실행에 재검증 · 미승인이면 구글이 환불');
      }
    });

    test('검증 성공 → purchased · 닫는다', () async {
      final (ev, store) = await deliver(null);
      expect(ev.state, IapPurchaseState.purchased);
      expect(store.completed, ['t1']);
    });

    test('스토어 자체 오류 → store(카드 거절 시트)', () async {
      final store = _FakeStore();
      final rail = StoreIapService(server: _FakeServer(), store: store);
      final next = rail.purchases.first;
      store.emit(_pd('t2', PurchaseStatus.error));
      final ev = await next;
      expect(ev.failure, IapFailure.store);
      expect(purchaseFailureOverlayFor(ev), SubscriptionOverlay.purchaseFailedDeclined);
      await rail.dispose();
    });

    test('실패 → 시트: 결제는 됐는데 미확인이면 카드 거절이 아니다(F005)', () {
      IapPurchase f(IapFailure? x) => IapPurchase(
          productId: 'bt_max_monthly', type: IapProductType.subscription,
          state: IapPurchaseState.failed, failure: x);
      expect(purchaseFailureOverlayFor(f(IapFailure.verifyPending)),
          SubscriptionOverlay.purchaseVerifying);
      expect(purchaseFailureOverlayFor(f(IapFailure.rejected)),
          SubscriptionOverlay.purchaseRejected);
      expect(purchaseFailureOverlayFor(f(IapFailure.otherAccount)),
          SubscriptionOverlay.restoreOtherAccount);
      expect(purchaseFailureOverlayFor(f(null)),
          SubscriptionOverlay.purchaseFailedDeclined);
    });
  });

  // ── F003 — 복원 결과 ──────────────────────────────────────────────────────
  group('F003 — 복원은 서버 판정대로', () {
    RestoreResultDto r(int restored, int failed,
            {bool pro = false, List<int> chars = const []}) =>
        RestoreResultDto(
          restored: restored,
          failed: failed,
          entitlement: EntitlementDto(isPro: pro, ownedCharacterIds: chars),
        );

    IapPurchase sent(String id, IapProductType type) =>
        IapPurchase(productId: id, type: type, state: IapPurchaseState.restored);
    final sub = sent('bt_max_monthly', IapProductType.subscription);
    final popo = sent('bt_character_popo', IapProductType.nonConsumable);
    final bundle = sent(IapProductIds.characterBundle, IapProductType.nonConsumable);

    test('판정표 — 보낸 영수증 종류로 가른다(QA F097 · PM-DEC-166)', () {
      RestoreOutcome o(RestoreResultDto res, List<IapPurchase> batch) =>
          StoreIapService.restoreOutcomeOf(res, batch);
      expect(o(r(1, 0, pro: true), [sub]), RestoreOutcome.restored);
      expect(o(r(0, 0, pro: true), [sub]), RestoreOutcome.restored,
          reason: '이미 지급된 영수증은 restored 로 안 세지만 권한은 있다');
      expect(o(r(0, 1), [sub]), RestoreOutcome.notThisAccount);
      expect(o(r(0, 0), const []), RestoreOutcome.nothing);
      // 09-28 실기기 — 구독은 만료돼 안 왔고 Popo 만 복원됐다 → 캐릭터 문구.
      // 캐릭터 하나 → 단수 제목(QA F110).
      expect(o(r(1, 0, chars: [1, 9]), [popo]), RestoreOutcome.restoredCharacter);
      // 이미 가진 캐릭터만 다시 복원(새 지급 0) → 캐릭터 문구.
      expect(o(r(0, 0, chars: [1, 9]), [popo]), RestoreOutcome.restoredCharacter);
      // 구독도 캐릭터도 보냈는데 구독만 안 됐다 → 캐릭터 문구(「Premium is back」 아님).
      expect(o(r(1, 1, chars: [9]), [sub, popo]), RestoreOutcome.restoredCharacter);
      // 캐릭터 둘 → 복수.
      final rara = sent('bt_character_rara', IapProductType.nonConsumable);
      expect(o(r(2, 0, chars: [9, 10]), [popo, rara]), RestoreOutcome.restoredCharacters);
      // 캐릭터만 보냈고 지급 없음 — 건별 사유가 없어 409·503 을 못 가른다 → 중립(QA F109).
      expect(o(r(0, 1, chars: [1]), [popo]), RestoreOutcome.unconfirmed);
      // 옛 구독 id(bt_max) 가 지급 없음 → 「확인 중」(PM-DEC-119 · F070).
      final legacy = sent('bt_max', IapProductType.subscription);
      expect(o(r(0, 1), [legacy]), RestoreOutcome.verifying);
      // 구독이 섞여 있으면 구독 문구.
      expect(o(r(0, 2, chars: [1]), [sub, popo]), RestoreOutcome.notThisAccount);
    });

    test('F114 · PM-DEC-192 — 건별 사유(§22 ③)가 있으면 그것으로 가른다', () {
      RestoreResultDto withItems(List<(String, String)> items,
              {bool pro = false, List<int> chars = const [1, 2]}) =>
          RestoreResultDto.fromJson({
            'restored': 0,
            'failed': items.length,
            'entitlement': {'is_pro': pro, 'owned_character_ids': chars},
            'items': [
              for (final (id, result) in items) {'product_id': id, 'result': result},
            ],
          });
      RestoreOutcome o(RestoreResultDto res, List<IapPurchase> batch) =>
          StoreIapService.restoreOutcomeOf(res, batch);
      // 409 — 캐릭터는 「이 캐릭터는 다른 계정」, 구독은 「그 요금제는 다른 계정」.
      expect(o(withItems([('bt_character_popo', 'owned_by_other')]), [popo]),
          RestoreOutcome.charactersNotThisAccount);
      expect(o(withItems([('bt_max_monthly', 'owned_by_other')]), [sub]),
          RestoreOutcome.notThisAccount);
      expect(
          o(withItems([('bt_max_monthly', 'invalid'), ('bt_character_popo', 'owned_by_other')]),
              [sub, popo]),
          RestoreOutcome.charactersNotThisAccount);
      // 503 · 422 · 404(invalid) — 중립 「확인하지 못함」(구독도 「다른 계정」 이라 하지 않는다).
      expect(o(withItems([('bt_character_popo', 'unavailable')]), [popo]),
          RestoreOutcome.unconfirmed);
      expect(o(withItems([('bt_max_monthly', 'invalid')]), [sub]),
          RestoreOutcome.unconfirmed);
      // 옛 구독 id 는 사유가 있어도 「확인 중」(PM-DEC-119).
      final legacy = sent('bt_max', IapProductType.subscription);
      expect(o(withItems([('bt_max', 'invalid')]), [legacy]), RestoreOutcome.verifying);
      // 지급이 있으면 사유보다 지급이 먼저다.
      expect(
          o(withItems([('bt_character_popo', 'granted')], chars: [1, 2, 9]), [popo]),
          RestoreOutcome.restoredCharacter);
      // 구서버(items 없음) — 개수 규칙 그대로.
      expect(RestoreResultDto.fromJson({'restored': 0, 'failed': 1}).items, isEmpty);
      // 모양이 틀린 항목은 버린다.
      expect(
          RestoreResultDto.fromJson({
            'items': [
              {'product_id': 'x'},
              'junk',
              {'product_id': 'bt_character_popo', 'result': 'already'},
            ],
          }).items,
          [(productId: 'bt_character_popo', result: 'already')]);
    });

    test('재검증 — 가입 때 받은 무료 스타터(Baba·Bibi)는 복원으로 세지 않는다', () {
      expect(StoreIapService.restoreOutcomeOf(r(0, 1, chars: [1, 2]), [sub]),
          RestoreOutcome.notThisAccount);
      expect(StoreIapService.restoreOutcomeOf(r(0, 1, chars: [1, 2]), [popo]),
          RestoreOutcome.unconfirmed);
    });

    test('F070 — 상품 종류: bt_character_* 만 캐릭터 · 옛 구독 id 는 구독', () {
      for (final id in ['bt_max', 'bt_pro', 'bt_pro_monthly', 'bt_max_yearly']) {
        expect(StoreIapService.typeOfProduct(id), IapProductType.subscription, reason: id);
      }
      for (final id in ['bt_character_popo', IapProductIds.characterBundle]) {
        expect(StoreIapService.typeOfProduct(id), IapProductType.nonConsumable, reason: id);
      }
    });

    test('F103 — 묶음 영수증은 유료 3종을 다 가지면 캐릭터 복원 · 거래를 닫는다', () {
      // 9 Popo · 10 Rara · 11 Dudu
      expect(StoreIapService.restoreOutcomeOf(r(1, 0, chars: [1, 9, 10, 11]), [bundle]),
          RestoreOutcome.restoredCharacters);
      expect(
          StoreIapService.grantedByRestore(bundle, RestoreOutcome.restoredCharacters,
              const EntitlementDto(isPro: false, ownedCharacterIds: [9, 10, 11])),
          isTrue);
      expect(
          StoreIapService.grantedByRestore(bundle, RestoreOutcome.restoredCharacters,
              const EntitlementDto(isPro: false, ownedCharacterIds: [9, 10])),
          isFalse, reason: '3종이 다 지급되기 전에는 닫지 않는다');
    });

    Future<(RestoreOutcome, _FakeStore, List<IapPurchase>)> run(
        _FakeServer server) async {
      final store = _FakeStore()..restorable = [_pd('r1', PurchaseStatus.restored)];
      final rail = StoreIapService(server: server, store: store);
      final events = <IapPurchase>[];
      final sub = rail.purchases.listen(events.add);
      final outcome = await rail.restore();
      await Future<void>.delayed(Duration.zero); // 브로드캐스트 전달은 한 박자 늦다
      await sub.cancel();
      await rail.dispose();
      return (outcome, store, events);
    }

    test('서버가 전부 거절(200 · restored 0 · failed 1) → 「복원 성공」이 아니다', () async {
      final (outcome, store, events) = await run(_FakeServer()..restoreResult = r(0, 1));
      expect(outcome, RestoreOutcome.notThisAccount);
      expect(events.where((e) => e.state == IapPurchaseState.restored), isEmpty);
      expect(store.completed, isEmpty);
    });

    test('서버 예외 → unavailable(「복원할 것 없음」 아님)', () async {
      final (outcome, _, _) = await run(_FakeServer()..restoreError = const NetworkFailure());
      expect(outcome, RestoreOutcome.unavailable);
    });

    test('PM-DEC-121 — 복원은 스토어 원시 id 를 보내고, Premium 은 그대로 서버 카탈로그 id 다', () async {
      final server = _RecordingServer()..restoreResult = r(1, 0, pro: true);
      final store = _FakeStore()..restorable = [_pd('r2', PurchaseStatus.restored)];
      final rail = StoreIapService(server: server, store: store);
      await rail.restore();
      await rail.dispose();
      final sent = server.restored.single;
      expect(sent.productId, 'bt_max_monthly', reason: '서버 iap_catalog 에 있는 id');
      expect(sent.type, IapProductType.subscription,
          reason: '옛 원시 id bt_max 는 캐릭터(비소모성)로 잘못 분류됐다');
    });

    test('서버가 지급 → restored · 이벤트 · 거래 닫음', () async {
      final (outcome, store, events) = await run(_FakeServer()..restoreResult = r(1, 0, pro: true));
      expect(outcome, RestoreOutcome.restored);
      expect(events.single.state, IapPurchaseState.restored);
      expect(store.completed, ['r1']);
    });

    test('판정 → 시트', () {
      expect(restoreOverlayFor(RestoreOutcome.restored), SubscriptionOverlay.restoreSuccess);
      expect(restoreOverlayFor(RestoreOutcome.nothing), SubscriptionOverlay.restoreEmpty);
      expect(restoreOverlayFor(RestoreOutcome.notThisAccount),
          SubscriptionOverlay.restoreOtherAccount);
      expect(restoreOverlayFor(RestoreOutcome.restoredCharacters),
          SubscriptionOverlay.restoreCharacters);
      expect(restoreOverlayFor(RestoreOutcome.charactersNotThisAccount),
          SubscriptionOverlay.restoreCharacterOtherAccount);
      expect(restoreOverlayFor(RestoreOutcome.restoredCharacter),
          SubscriptionOverlay.restoreCharacter);
      expect(restoreOverlayFor(RestoreOutcome.unconfirmed),
          SubscriptionOverlay.purchaseRejected);
      expect(restoreOverlayFor(RestoreOutcome.verifying),
          SubscriptionOverlay.purchaseVerifying);
      expect(restoreOverlayFor(RestoreOutcome.unavailable),
          SubscriptionOverlay.restoreUnavailable);
    });

    testWidgets('runRestoreFlow — 서버에 못 닿으면 연결 실패 시트', (tester) async {
      final iap = _OutcomeIap(RestoreOutcome.unavailable);
      await tester.pumpWidget(_app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => runRestoreFlow(context),
              child: const Text('restore'),
            ),
          ),
        ),
        overrides: [iapServiceProvider.overrideWithValue(iap)],
      ));
      await tester.tap(find.text('restore'));
      await tester.pumpAndSettle();
      expect(find.text('Connection failed'), findsOneWidget);
      expect(find.text('Nothing to restore'), findsNothing);
    });
  });

  // ── F004 · F005 — 구매 처리 화면 ──────────────────────────────────────────
  group('구매 처리 화면', () {
    Future<void> pump(WidgetTester tester, _ScriptedIap iap,
        {List<Override> extra = const []}) async {
      await tester.pumpWidget(_app(
        const Scaffold(body: Text('PAYWALL')),
        overrides: [iapServiceProvider.overrideWithValue(iap), ...extra],
        routes: {
          '/processing': (_) => const PurchaseProcessingScreen(),
          Routes.purchaseSuccessMax: (_) => const Scaffold(body: Text('success')),
        },
      ));
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      unawaited(nav.pushNamed('/processing'));
      await tester.pump();
      await tester.pump();
    }

    testWidgets('F005 — 결제 후 검증 미확인이면 「결제는 완료」, 카드 거절 아님', (tester) async {
      await pump(tester, _ScriptedIap([
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.failed,
            failure: IapFailure.verifyPending),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('Payment received'), findsOneWidget);
      expect(find.text('Your card was declined'), findsNothing);
      expect(find.text('PAYWALL'), findsOneWidget);
    });

    testWidgets('스토어가 실패했을 때만 카드 거절 시트', (tester) async {
      await pump(tester, _ScriptedIap([
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.failed,
            failure: IapFailure.store),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('Your card was declined'), findsOneWidget);
    });

    testWidgets('F004 — 보류가 이어지면 안내하고 화면을 놓아 준다', (tester) async {
      final iap = _ScriptedIap([
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.pending),
      ]);
      await pump(tester, iap);

      expect(find.text('Payment pending'), findsNothing, reason: 'StoreKit 의 결제 중 보류는 기다린다');
      await tester.pump(kPurchasePendingNoticeAfter + const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Payment pending'), findsOneWidget);
      expect(find.byType(PurchaseProcessingScreen), findsNothing);
      // 늦은 결과 감시(30분)를 끝내 타이머를 남기지 않는다.
      iap.emit(const IapPurchase(
          productId: IapProductIds.maxMonthly,
          type: IapProductType.subscription,
          state: IapPurchaseState.canceled));
      await tester.pump();
    });

    testWidgets('재검증 — 보류 안내로 화면이 닫힌 뒤 성공해도 성공 화면', (tester) async {
      final iap = _ScriptedIap([
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.pending),
      ]);
      await pump(tester, iap);
      await tester.pump(kPurchasePendingNoticeAfter + const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Payment pending'), findsOneWidget);
      iap.emit(const IapPurchase(
          productId: IapProductIds.maxMonthly,
          type: IapProductType.subscription,
          state: IapPurchaseState.purchased));
      await tester.pumpAndSettle();
      expect(find.text('success'), findsOneWidget);
    });

    IapPurchase ev(String product, IapPurchaseState s) =>
        IapPurchase(productId: product, type: IapProductType.subscription, state: s);

    Future<_ScriptedIap> pendNotice(WidgetTester tester,
        {List<Override> extra = const []}) async {
      final iap = _ScriptedIap([ev(IapProductIds.maxMonthly, IapPurchaseState.pending)]);
      await pump(tester, iap, extra: extra);
      await tester.pump(kPurchasePendingNoticeAfter + const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Payment pending'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      return iap;
    }

    testWidgets('F066 — 보류 뒤 캐릭터 구매·복원 결과로 Premium 성공 화면이 뜨지 않는다',
        (tester) async {
      final iap = await pendNotice(tester);
      iap.emit(ev('bt_character_rara', IapPurchaseState.purchased));
      iap.emit(ev('bt_character_dudu', IapPurchaseState.restored));
      await tester.pumpAndSettle();
      expect(find.text('success'), findsNothing);
      // 요청한 구독 상품의 결과는 여전히 받는다.
      iap.emit(ev(IapProductIds.maxMonthly, IapPurchaseState.purchased));
      await tester.pumpAndSettle();
      expect(find.text('success'), findsOneWidget);
    });

    testWidgets('F066 — 통화 중이면 결과를 통화 위에 띄우지 않는다(상태 갱신만)', (tester) async {
      final iap = await pendNotice(tester, extra: [
        normalCallControllerProvider.overrideWith(
            () => _StubCall(const CallState(phase: CallPhase.inCall))),
      ]);
      iap.emit(ev(IapProductIds.maxMonthly, IapPurchaseState.purchased));
      await tester.pumpAndSettle();
      expect(find.text('success'), findsNothing);
      expect(find.text('PAYWALL'), findsOneWidget);
    });

    testWidgets('F069 — 통화 중 늦은 실패는 버리지 않고 통화가 끝나면 한 번 안내', (tester) async {
      final call = _StubCall(const CallState(phase: CallPhase.inCall));
      final iap = await pendNotice(tester, extra: [
        normalCallControllerProvider.overrideWith(() => call),
      ]);
      iap.emit(IapPurchase(
          productId: IapProductIds.maxMonthly,
          type: IapProductType.subscription,
          state: IapPurchaseState.failed,
          failure: IapFailure.store));
      await tester.pumpAndSettle();
      final title = AppLocalizations.of(tester.element(find.text('PAYWALL')))
          .ovFailedDeclinedTitle;
      expect(find.text(title), findsNothing, reason: '통화 위에는 띄우지 않는다');
      // 끝났지만 통화 화면이 아직 떠나기 전(ended) — 여기서 띄우면 통화 화면의
      // pushReplacementNamed 가 이 시트를 갈아 치운다(QA F069 재현).
      call.setPhase(CallPhase.ended);
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
      // 통화 화면이 끝난 통화를 소비하고(idle) 떠난 다음 프레임에 한 번.
      call.setPhase(CallPhase.idle);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('F084 — 통화가 ended 인 순간 도착한 실패도 통화 화면이 떠난 뒤', (tester) async {
      final call = _StubCall(const CallState(phase: CallPhase.ended));
      final iap = await pendNotice(tester, extra: [
        normalCallControllerProvider.overrideWith(() => call),
      ]);
      iap.emit(IapPurchase(
          productId: IapProductIds.maxMonthly,
          type: IapProductType.subscription,
          state: IapPurchaseState.failed,
          failure: IapFailure.store));
      await tester.pumpAndSettle();
      final title = AppLocalizations.of(tester.element(find.text('PAYWALL')))
          .ovFailedDeclinedTitle;
      expect(find.text(title), findsNothing);
      call.setPhase(CallPhase.idle);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('F066 — 새 구매가 시작되면 이전 감시는 끝난다', (tester) async {
      final iap = await pendNotice(tester);
      cancelLatePurchaseWatch(); // 새 처리 화면이 여는 것과 같은 호출
      iap.emit(ev(IapProductIds.maxMonthly, IapPurchaseState.purchased));
      await tester.pumpAndSettle();
      expect(find.text('success'), findsNothing);
    });

    testWidgets('보류 뒤 곧 결제되면 보류 안내 없이 성공', (tester) async {
      await pump(tester, _ScriptedIap([
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.pending),
        const IapPurchase(
            productId: IapProductIds.maxMonthly,
            type: IapProductType.subscription,
            state: IapPurchaseState.purchased),
      ]));
      await tester.pump(kPurchasePendingNoticeAfter * 2);
      await tester.pumpAndSettle();
      expect(find.text('success'), findsOneWidget);
      expect(find.text('Payment pending'), findsNothing);
    });
  });

  // ── F015 · F016 — 캐릭터 구매 ────────────────────────────────────────────
  group('캐릭터 구매', () {
    final rara = CharacterDto.fromJson(const {
      'character_id': 10,
      'product_key': 'rara',
      'name': 'Rara',
      'price': '4.99',
      'effective_price': '4.99',
      'is_owned': false,
      'is_unlocked': false,
    }).toEntity();
    final baba = CharacterDto.fromJson(const {
      'character_id': 1,
      'product_key': 'baba',
      'name': 'Baba',
      'price': '0',
      'effective_price': '0',
      'is_owned': true,
      'is_unlocked': true,
    }).toEntity();

    Future<_RecordingCharacters> pump(WidgetTester tester, IapService iap) async {
      final repo = _RecordingCharacters();
      await tester.pumpWidget(_app(
        const AvatarScreen(),
        overrides: [
          iapServiceProvider.overrideWithValue(iap),
          characterRepositoryProvider.overrideWithValue(repo),
          charactersProvider.overrideWith((ref) async => [baba, rara]),
          ownedCharactersProvider.overrideWith((ref) async => const []),
          myProfileProvider.overrideWith((ref) async => Member(memberId: 1, characterId: 1)),
        ],
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Rara'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buy'));
      await tester.pump();
      await tester.pump();
      return repo;
    }

    testWidgets('F015 — 스토어 조회 실패면 안내 배너', (tester) async {
      await pump(tester, _ThrowingIap());
      await tester.pumpAndSettle();
      expect(find.text("The purchase didn't go through"), findsOneWidget);
    });

    testWidgets('F016 — 레일이 검증한 영수증은 다시 서버에 보내지 않는다', (tester) async {
      final repo = await pump(tester, _ScriptedIap([
        const IapPurchase(
          productId: 'bt_character_rara',
          type: IapProductType.nonConsumable,
          state: IapPurchaseState.purchased,
          transactionId: 'order-1',
          purchaseToken: 'token-1',
        ),
      ], matchProduct: true));
      await tester.pumpAndSettle();
      expect(repo.calls, isEmpty, reason: '영수증 있는 구매는 레일이 이미 검증·지급했다');
      expect(find.text('A new friend joins you!'), findsOneWidget);
    });
  });

  // ── F022 — 스토어 결제 없이 부여된 Premium ────────────────────────────────
  testWidgets('F022 — 가격 0 · 만료일 없음이면 「\$0 per month」·「Next payment —」 를 안 그린다',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(
      const SubscriptionManageScreen(),
      overrides: [
        subscriptionStatusAvailabilityProvider
            .overrideWithValue(SubscriptionStatusAvailability.known),
        subscriptionStatusProvider.overrideWithValue(const SubscriptionStatus(
          state: SubscriptionState.activeMax,
          tier: SubscriptionTier.max,
          source: Subscription(id: 7, price: 0, isActivate: true),
        )),
      ],
    ));
    await tester.pump();
    expect(find.textContaining(r'$0'), findsNothing);
    expect(find.text('Next payment'), findsNothing);
  });
}

// ── 가짜 레일들 ───────────────────────────────────────────────────────────────

/// 복원에 보낸 영수증을 기록한다.
class _RecordingServer extends _FakeServer {
  List<IapPurchase> restored = const [];
  @override
  Future<RestoreResultDto> restore(List<IapPurchase> purchases) {
    restored = purchases;
    return super.restore(purchases);
  }
}

/// 통화 상태만 정한다 — 진짜 build() 는 소켓·오디오를 연다.
class _StubCall extends NormalCallController {
  _StubCall(this._state);
  final CallState _state;
  @override
  CallState build() => _state;

  /// 통화가 끝난 것처럼 단계를 바꾼다.
  void setPhase(CallPhase phase) => state = CallState(phase: phase);
}

/// 복원 결과만 정한다.
class _OutcomeIap extends MockIapService {
  _OutcomeIap(this.outcome);
  final RestoreOutcome outcome;
  @override
  Future<RestoreOutcome> restore() async => outcome;
}

/// purchase() 가 정해 둔 이벤트를 순서대로 낸다.
class _ScriptedIap extends MockIapService {
  _ScriptedIap(this.events, {this.matchProduct = false});
  final List<IapPurchase> events;

  /// 캐릭터 구매처럼 산 상품 id 로 이벤트를 다시 쓴다.
  final bool matchProduct;
  final _out = StreamController<IapPurchase>.broadcast();

  /// 나중에 오는 이벤트(늦은 결제 완료).
  void emit(IapPurchase p) => _out.add(p);

  @override
  Stream<IapPurchase> get purchases => _out.stream;

  @override
  Future<List<IapProduct>> getProducts(Set<String> ids) async => [
        for (final id in ids)
          IapProduct(id: id, type: IapProductType.subscription, localizedPrice: r'$23.99'),
      ];

  @override
  Future<void> purchase(IapProduct product) async {
    for (final e in events) {
      _out.add(matchProduct
          ? IapPurchase(
              productId: product.id,
              type: e.type,
              state: e.state,
              failure: e.failure,
              transactionId: e.transactionId,
              purchaseToken: e.purchaseToken,
            )
          : e);
    }
  }
}

/// 스토어 조회가 실패한다(비행기 모드 · 상품 미등록).
class _ThrowingIap extends MockIapService {
  @override
  Future<void> purchase(IapProduct product) async =>
      throw StateError('product not found on store: ${product.id}');
}

/// 영수증 없는 옛 지급 경로가 불렸는지 기록한다.
class _RecordingCharacters implements CharacterRepository {
  final calls = <String>[];
  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation.memberName.toString());
    return super.noSuchMethod(invocation);
  }
}
