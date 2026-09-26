import 'dart:async';

import 'package:beavertalk/features/payment/domain/entities/payment.dart';
import 'package:beavertalk/features/payment/domain/repositories/payment_repository.dart';
import 'package:beavertalk/features/payment/presentation/providers/payment_providers.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:beavertalk/screens/payment/payment_history.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/screens/plans/plans_compare.dart';
import 'package:beavertalk/screens/system/network_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// QA 09-26 구독·결제 표시 결함 — F014(모르면 Free 로 그림) · F032(결제 내역 10건 뒤 못 봄) ·
/// F036 · F052(Premium 카드 부제 삭제 · PM-DEC-061).

Widget _app(Widget home, {List<Override> overrides = const []}) => ProviderScope(
      key: UniqueKey(),
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: home,
      ),
    );

/// 끝나지 않는 조회 — 「아직 모름」.
Future<T> _pending<T>() => Completer<T>().future;

const _premium = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);

Payment _pay(int id) => Payment(
      id: id,
      date: DateTime(2026, 9, 28 - id),
      description: 'Charge #$id',
      price: 2399,
      category: PaymentCategory.subscribe,
    );

PaymentPage _page(int page, List<int> ids, {required bool hasMore}) => PaymentPage(
      monthTotal: 2399,
      items: [for (final id in ids) _pay(id)],
      page: page,
      size: 10,
      hasMore: hasMore,
    );

class _Payments implements PaymentRepository {
  _Payments(this.pages, {this.failFirst = false});

  final Map<int, PaymentPage> pages;
  bool failFirst;
  final List<(PaymentFilter, int)> calls = [];

  @override
  Future<PaymentPage> listPayments({
    PaymentFilter filter = PaymentFilter.all,
    int page = 1,
  }) async {
    calls.add((filter, page));
    if (failFirst) {
      failFirst = false;
      throw StateError('offline');
    }
    return pages[page]!;
  }
}

void main() {
  group('F014 — 구독 상태를 그려도 되는가', () {
    Future<SubscriptionStatusAvailability> availability(
      List<Override> overrides,
    ) async {
      final c = ProviderContainer(overrides: overrides);
      addTearDown(c.dispose);
      c.listen(subscriptionStatusAvailabilityProvider, (_, _) {});
      // 두 조회가 끝날 틈을 준다(끝나지 않는 조회는 그대로 남는다).
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      return c.read(subscriptionStatusAvailabilityProvider);
    }

    test('서버 판정이 오면 known', () async {
      expect(
        await availability([
          serverSubscriptionStatusProvider.overrideWith((ref) async => _premium),
          subscriptionsProvider.overrideWith((ref) => _pending()),
        ]),
        SubscriptionStatusAvailability.known,
      );
    });

    test('서버가 실패해도 행 목록이 오면 known(행 추론)', () async {
      expect(
        await availability([
          serverSubscriptionStatusProvider.overrideWith((ref) async => throw StateError('x')),
          subscriptionsProvider.overrideWith((ref) async => const <Subscription>[]),
        ]),
        SubscriptionStatusAvailability.known,
      );
    });

    test('둘 다 답이 없으면 loading', () async {
      expect(
        await availability([
          serverSubscriptionStatusProvider.overrideWith((ref) => _pending()),
          subscriptionsProvider.overrideWith((ref) => _pending()),
        ]),
        SubscriptionStatusAvailability.loading,
      );
    });

    test('둘 다 실패면 failed — 서버가 null(구서버)이고 행 목록 실패도 같다', () async {
      expect(
        await availability([
          serverSubscriptionStatusProvider.overrideWith((ref) async => throw StateError('x')),
          subscriptionsProvider.overrideWith((ref) async => throw StateError('y')),
        ]),
        SubscriptionStatusAvailability.failed,
      );
      expect(
        await availability([
          serverSubscriptionStatusProvider.overrideWith((ref) async => null),
          subscriptionsProvider.overrideWith((ref) async => throw StateError('y')),
        ]),
        SubscriptionStatusAvailability.failed,
      );
    });

    test('이번 세션에 결제했으면 조회 전이라도 known', () async {
      expect(
        await availability([
          sessionEntitlementProvider.overrideWith((ref) => SubscriptionTier.max),
          serverSubscriptionStatusProvider.overrideWith((ref) => _pending()),
          subscriptionsProvider.overrideWith((ref) => _pending()),
        ]),
        SubscriptionStatusAvailability.known,
      );
    });

    testWidgets('로딩 중 구독 관리 — Free 카드도 업그레이드 배너도 없다', (tester) async {
      await tester.pumpWidget(_app(const SubscriptionManageScreen(), overrides: [
        serverSubscriptionStatusProvider.overrideWith((ref) => _pending()),
        subscriptionsProvider.overrideWith((ref) => _pending()),
      ]));
      await tester.pump();
      expect(find.text('Subscription'), findsOneWidget, reason: 'GNB 는 남는다');
      expect(find.text('Free'), findsNothing);
      expect(find.byType(NetworkErrorView), findsNothing);
    });

    testWidgets('둘 다 실패 — 다시 시도가 두 조회를 다시 부른다', (tester) async {
      var serverCalls = 0;
      var rowCalls = 0;
      await tester.pumpWidget(_app(const SubscriptionManageScreen(), overrides: [
        serverSubscriptionStatusProvider.overrideWith((ref) async {
          serverCalls++;
          throw StateError('offline');
        }),
        subscriptionsProvider.overrideWith((ref) async {
          rowCalls++;
          throw StateError('offline');
        }),
      ]));
      await tester.pump();
      await tester.pump();
      expect(find.byType(NetworkErrorView), findsOneWidget);
      expect(find.text('Free'), findsNothing);
      expect((serverCalls, rowCalls), (1, 1));

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect((serverCalls, rowCalls), (2, 2));
    });

    testWidgets('서버 판정이 오면 그 상태를 그린다(Premium)', (tester) async {
      await tester.pumpWidget(_app(const SubscriptionManageScreen(), overrides: [
        serverSubscriptionStatusProvider.overrideWith((ref) async => _premium),
        subscriptionsProvider.overrideWith((ref) => _pending()),
      ]));
      await tester.pump();
      await tester.pump();
      expect(find.text('Premium'), findsOneWidget);
      expect(find.byType(NetworkErrorView), findsNothing);
    });
  });

  group('F032 — 결제 내역 다음 쪽', () {
    Future<_Payments> pump(
      WidgetTester tester, {
      bool failFirst = false,
      Size size = const Size(375, 3000),
    }) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repo = _Payments({
        2: _page(2, [11, 12], hasMore: false),
      }, failFirst: failFirst);
      await tester.pumpWidget(_app(const PaymentHistoryScreen(), overrides: [
        paymentRepositoryProvider.overrideWithValue(repo),
        paymentPageProvider.overrideWith(
          (ref, filter) async => _page(1, [for (var i = 1; i <= 10; i++) i], hasMore: true),
        ),
      ]));
      await tester.pump(); // 1쪽
      await tester.pump(); // 화면을 못 채우면 다음 쪽 요청
      await tester.pump(); // 다음 쪽 도착
      return repo;
    }

    testWidgets('1쪽이 화면을 못 채우면 2쪽을 바로 불러 붙인다', (tester) async {
      final repo = await pump(tester);
      expect(repo.calls, [(PaymentFilter.all, 2)]);
      expect(find.text('Charge #1'), findsOneWidget);
      expect(find.text('Charge #12'), findsOneWidget);
    });

    testWidgets('스크롤이 끝에 가까워지면 다음 쪽 — 짧은 화면', (tester) async {
      final repo = await pump(tester, size: const Size(375, 640));
      expect(repo.calls, isEmpty, reason: '끝에서 멀면 부르지 않는다');
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -3000));
      await tester.pump();
      await tester.pump();
      expect(repo.calls, [(PaymentFilter.all, 2)]);
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -3000));
      await tester.pump();
      expect(find.text('Charge #12'), findsOneWidget);
    });

    testWidgets('다음 쪽 실패 → Retry 로 다시', (tester) async {
      final repo = await pump(tester, failFirst: true);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Charge #12'), findsNothing);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(repo.calls.length, 2);
      expect(find.text('Charge #12'), findsOneWidget);
    });
  });

  group('F036 · F052 — Premium 카드 부제 삭제(PM-DEC-061)', () {
    testWidgets('요금제 비교 Premium 카드에 「Now you can see them.」 없음', (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_app(const PlansCompareScreen()));
      await tester.pump();
      expect(find.text('Now you can see them.'), findsNothing);
      expect(find.text('15 minutes of video calls a day'), findsOneWidget, reason: '불릿은 그대로');
    });

    testWidgets('페이월 Premium 카드 — 「하루 15분 영상통화」 가 불릿에 한 번만', (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_app(const PaywallScreen(variant: PaywallVariant.max)));
      await tester.pump();
      expect(find.text('15 minutes of video calls a day'), findsOneWidget);
    });
  });
}
