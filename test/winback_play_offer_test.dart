import 'dart:async';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/subscription/data/store_iap_service.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 안드로이드 윈백 — 앱이 Play 윈백 오퍼 토큰으로 결제창을 직접 연다(PM-DEC-049).
///
/// Play 는 이탈 구독자 할인을 스토어 구독 화면에서 자동 적용하지 않아, 스토어로 보내면 정가가
/// 보였다. 실결제는 서버 검증 대기라 확인 못 한다 — 오퍼 선택과 흐름 분기까지 시험한다.
class _WinbackIap extends MockIapService {
  _WinbackIap({required this.offerAvailable});

  final bool offerAvailable;
  int winbackCalls = 0;
  final List<String> bought = [];

  @override
  Future<bool> purchaseWinbackOffer() async {
    winbackCalls++;
    if (!offerAvailable) return false;
    await purchase(const IapProduct(
      id: IapProductIds.maxMonthly,
      type: IapProductType.subscription,
      localizedPrice: r'$11.99',
    ));
    return true;
  }

  @override
  Future<void> purchase(IapProduct product) {
    bought.add(product.id);
    return super.purchase(product);
  }
}

typedef _Offer = ({String basePlanId, String? offerId, List<String> tags});

void main() {
  group('오퍼 선택 — pickWinbackOffer', () {
    _Offer o(String base, String? id, [List<String> tags = const []]) =>
        (basePlanId: base, offerId: id, tags: tags);

    test('월간 기본 플랜 위의 winback-50-1m', () {
      final i = StoreIapService.pickWinbackOffer([
        o('monthly', null), // 기본 플랜 행
        o('yearly', 'winback-50-1m', ['winback']), // 다른 기본 플랜
        o('monthly', 'intro-7d'),
        o('monthly', 'winback-50-1m', ['winback']),
      ], basePlanId: 'monthly');
      expect(i, 3);
    });

    test('id 가 달라도 태그 winback 이면 잡는다 · id 일치가 먼저', () {
      expect(
        StoreIapService.pickWinbackOffer([o('monthly', 'wb-2', ['winback'])], basePlanId: 'monthly'),
        0,
      );
      expect(
        StoreIapService.pickWinbackOffer([
          o('monthly', 'wb-2', ['winback']),
          o('monthly', 'winback-50-1m'),
        ], basePlanId: 'monthly'),
        1,
      );
    });

    test('없으면 null — 기본 플랜 행·다른 오퍼만 있을 때', () {
      expect(
        StoreIapService.pickWinbackOffer([o('monthly', null), o('monthly', 'intro-7d')],
            basePlanId: 'monthly'),
        isNull,
      );
    });
  });

  group('결제 처리 화면 — WinbackPurchase 인자', () {
    Future<_WinbackIap> pump(WidgetTester tester, {required bool offer}) async {
      final iap = _WinbackIap(offerAvailable: offer);
      await tester.pumpWidget(ProviderScope(
        overrides: [iapServiceProvider.overrideWithValue(iap)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(body: Text('HOME')),
          routes: {
            '/processing': (_) => const PurchaseProcessingScreen(),
            Routes.purchaseSuccessMax: (_) => const Scaffold(body: Text('success-max')),
          },
        ),
      ));
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      unawaited(nav.pushNamed('/processing', arguments: const WinbackPurchase()));
      await tester.pumpAndSettle();
      return iap;
    }

    testWidgets('오퍼 결제 → 월간 Premium 성공 화면', (tester) async {
      final iap = await pump(tester, offer: true);
      expect(iap.winbackCalls, 1);
      expect(iap.bought, [IapProductIds.maxMonthly]);
      expect(find.text('success-max'), findsOneWidget);
    });

    testWidgets('오퍼를 못 열면 정가로 사지 않고 닫는다(스토어 화면 폴백)', (tester) async {
      final iap = await pump(tester, offer: false);
      expect(iap.winbackCalls, 1);
      expect(iap.bought, isEmpty, reason: '할인 보고 들어온 회원에게 정가 결제창을 열지 않는다');
      expect(find.text('HOME'), findsOneWidget);
    });
  });
}
