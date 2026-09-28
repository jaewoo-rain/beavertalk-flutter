import 'dart:async';

import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar.dart';
import 'package:beavertalk/screens/mypage/character_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 캐릭터 묶음 `bt_character_bundle`(PM-DEC-142 · DEC-PR-05 · PM-DEC-144).
void main() {
  List<Character> catalog({Set<int> owned = const {}}) => [
        for (final (id, name) in [
          (1, 'Baba'),
          (2, 'Bibi'),
          (9, 'Popo'),
          (10, 'Rara'),
          (11, 'Dudu'),
        ])
          CharacterDto.fromJson({
            'character_id': id,
            'product_key': name.toLowerCase(),
            'name': name,
            'price': '4.99',
            'effective_price': '4.99',
            'is_owned': owned.contains(id) || id <= 2,
            'is_unlocked': owned.contains(id) || id <= 2,
          }).toEntity(),
      ];

  IapProduct product(String id, double raw, String display,
          {String currency = 'KRW'}) =>
      IapProduct(
        id: id,
        type: IapProductType.nonConsumable,
        localizedPrice: display,
        rawPrice: raw,
        currencyCode: currency,
      );

  final storeKr = [
    product(IapProductIds.characterBundle, 13200, '₩13,200'),
    product('bt_character_popo', 6600, '₩6,600'),
    product('bt_character_rara', 6600, '₩6,600'),
    product('bt_character_dudu', 6600, '₩6,600'),
  ];

  test('빌드 플래그 기본값은 꺼짐 — 서버 카탈로그 전에는 팔지 않는다', () {
    expect(kCharacterBundleEnabled, isFalse);
  });

  test('유료 3종 미보유 · 스토어 4종 응답 → 묶음 현지가 · 취소선 = 단품 합 · 할인율', () async {
    final offer = await buildCharacterBundleOffer(
        characters: catalog(), iap: MockIapService(catalog: storeKr));
    expect(offer, isNotNull);
    expect(offer!.product.localizedPrice, '₩13,200');
    expect(offer.original, contains('19,800'));
    expect(offer.percent, 33);
    expect(offer.characters.map((c) => c.name), ['Popo', 'Rara', 'Dudu']);
  });

  test('유료 캐릭터를 하나라도 가지면 노출 안 함', () async {
    expect(
        await buildCharacterBundleOffer(
            characters: catalog(owned: {10}),
            iap: MockIapService(catalog: storeKr)),
        isNull);
  });

  test('스토어가 묶음·단품 중 하나라도 안 주거나 통화가 다르면 노출 안 함(fail-closed)', () async {
    expect(
        await buildCharacterBundleOffer(
            characters: catalog(),
            iap: MockIapService(catalog: storeKr.skip(1).toList())),
        isNull,
        reason: '묶음 없음');
    expect(
        await buildCharacterBundleOffer(
            characters: catalog(),
            iap: MockIapService(catalog: storeKr.take(3).toList())),
        isNull,
        reason: '단품 하나 없음');
    expect(
        await buildCharacterBundleOffer(
            characters: catalog(),
            iap: MockIapService(catalog: [
              ...storeKr.take(3),
              product('bt_character_dudu', 4.99, r'$4.99', currency: 'USD'),
            ])),
        isNull,
        reason: '통화 다름');
  });

  testWidgets('아바타 화면 링크 → 묶음 시트 → Buy 면 묶음 상품 결제', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final iap = _RecordingIap(storeKr);
    final offer = (await buildCharacterBundleOffer(
        characters: catalog(), iap: MockIapService(catalog: storeKr)))!;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        charactersProvider.overrideWith((ref) async => catalog()),
        ownedCharactersProvider.overrideWith((ref) async => const []),
        myProfileProvider
            .overrideWith((ref) async => const Member(memberId: 1, characterId: 1)),
        iapServiceProvider.overrideWithValue(iap),
        characterBundleOfferProvider.overrideWith((ref) async => offer),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AvatarScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Rara'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get all three for ₩13,200'));
    await tester.pumpAndSettle();
    expect(find.text('All three at once'), findsOneWidget);
    expect(find.text('Popo · Rara · Dudu'), findsOneWidget);
    expect(find.text('33% off'), findsOneWidget);
    expect(find.textContaining('19,800'), findsOneWidget);

    await tester.tap(find.text('Buy').last);
    await tester.pumpAndSettle();
    expect(iap.bought, [IapProductIds.characterBundle]);
    await tester.pumpWidget(const SizedBox());
  });
}

/// 산 상품 id 를 기록하고 취소로 답한다.
class _RecordingIap extends MockIapService {
  _RecordingIap(List<IapProduct> catalog) : super(catalog: catalog);
  final bought = <String>[];
  final _events = StreamController<IapPurchase>.broadcast();

  @override
  Stream<IapPurchase> get purchases => _events.stream;

  @override
  Future<void> purchase(IapProduct product) async {
    bought.add(product.id);
    scheduleMicrotask(() => _events.add(IapPurchase(
        productId: product.id,
        type: product.type,
        state: IapPurchaseState.canceled)));
  }
}
