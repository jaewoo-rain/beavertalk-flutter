// 티어를 **모르는 구간**의 경계 — 통화 화면이 아바타를 무엇으로 그릴지 가른다.
//
// 이 판정이 틀리면 증상이 둘 다 나쁘다.
//   너무 넓으면 → 플랜을 아는데도 아바타가 셔머로 사라진다(결제 직후가 그랬다)
//   너무 좁으면 → 아직 모르는데 Free 모습을 단언한다(Max 사용자가 원형을 본다)
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';

/// 영영 끝나지 않는 요청 — 「아직 답이 없다」를 만든다.
Future<T> _pending<T>() => Completer<T>().future;

void main() {
  group('subscriptionTierUnknownProvider', () {
    test('둘 다 답 전이면 모른다', () {
      final c = ProviderContainer(overrides: [
        serverSubscriptionStatusProvider
            .overrideWith((ref) => _pending<SubscriptionStatus?>()),
        subscriptionsProvider.overrideWith((ref) => _pending<List<Subscription>>()),
      ]);
      addTearDown(c.dispose);

      expect(c.read(subscriptionTierUnknownProvider), isTrue);
    });

    test('서버가 답하면 안다 — 값이 null 이어도 답은 답이다', () async {
      final c = ProviderContainer(overrides: [
        serverSubscriptionStatusProvider
            .overrideWith((ref) async => null),
        subscriptionsProvider.overrideWith((ref) => _pending<List<Subscription>>()),
      ]);
      addTearDown(c.dispose);

      // 구독해 둬야 FutureProvider 가 돈다.
      c.listen(subscriptionTierUnknownProvider, (_, _) {});
      await c.read(serverSubscriptionStatusProvider.future);

      expect(c.read(subscriptionTierUnknownProvider), isFalse);
    });

    test('서버가 실패해도 안다 — 행 목록으로 내려가면 되기 때문이다', () async {
      final c = ProviderContainer(overrides: [
        serverSubscriptionStatusProvider
            .overrideWith((ref) async => throw Exception('boom')),
        subscriptionsProvider.overrideWith((ref) => _pending<List<Subscription>>()),
      ]);
      addTearDown(c.dispose);

      c.listen(subscriptionTierUnknownProvider, (_, _) {});
      await expectLater(
        c.read(serverSubscriptionStatusProvider.future),
        throwsA(isA<Exception>()),
      );

      expect(c.read(subscriptionTierUnknownProvider), isFalse);
    });

    test('🔴 다시 물어보는 중은 모르는 게 아니다 — 결제 직후 아바타가 사라지던 버그',
        () async {
      // 결제가 끝나면 `purchase_flow`·`subscription_overlays` 가 서버 상태를
      // invalidate 한다. 그때 Riverpod 은 **이전 값을 들고 있는 채로** 다시
      // 로딩으로 간다. `isLoading` 으로 재면 그 순간이 「모름」이 되어, 통화 중
      // Max 를 결제한 사람의 아바타가 셔머로 사라졌다가 돌아왔다.
      final c = ProviderContainer(overrides: [
        serverSubscriptionStatusProvider.overrideWith((ref) async => null),
        subscriptionsProvider.overrideWith((ref) => _pending<List<Subscription>>()),
      ]);
      addTearDown(c.dispose);

      c.listen(subscriptionTierUnknownProvider, (_, _) {});
      await c.read(serverSubscriptionStatusProvider.future);
      expect(c.read(subscriptionTierUnknownProvider), isFalse);

      // 결제 직후의 그 순간.
      c.invalidate(serverSubscriptionStatusProvider);
      c.read(serverSubscriptionStatusProvider); // 재계산을 띄운다

      expect(
        c.read(subscriptionTierUnknownProvider),
        isFalse,
        reason: '값을 이미 받아 뒀으므로 갱신 중에도 티어를 안다',
      );
    });
  });
}
