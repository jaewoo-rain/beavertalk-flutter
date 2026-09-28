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
import 'package:beavertalk/theme/app_color_tokens.dart';
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

  test('할인율은 내림 · 묶음이 단품 합 이상이면 취소선·배지 없음', () async {
    final floor = await buildCharacterBundleOffer(
        characters: catalog(),
        iap: MockIapService(catalog: [
          product(IapProductIds.characterBundle, 13100, '₩13,100'),
          ...storeKr.skip(1),
        ]));
    expect(floor!.percent, 33, reason: '33.8% → 33 (round 였으면 34)');
    // 정확히 10% — double 연산이면 9.999…% 로 9 가 됐다.
    final exact = await buildCharacterBundleOffer(
        characters: catalog(),
        iap: MockIapService(catalog: [
          product(IapProductIds.characterBundle, 13.5, r'$13.50', currency: 'USD'),
          product('bt_character_popo', 5.0, r'$5.00', currency: 'USD'),
          product('bt_character_rara', 5.0, r'$5.00', currency: 'USD'),
          product('bt_character_dudu', 5.0, r'$5.00', currency: 'USD'),
        ]));
    expect(exact!.percent, 10);
    final noSaving = await buildCharacterBundleOffer(
        characters: catalog(),
        iap: MockIapService(catalog: [
          product(IapProductIds.characterBundle, 19800, '₩19,800'),
          ...storeKr.skip(1),
        ]));
    expect(noSaving, isNotNull);
    expect(noSaving!.original, isNull);
    expect(noSaving.percent, isNull);
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
              product('bt_character_dudu', 5.0, r'$5.00', currency: 'USD'),
            ])),
        isNull,
        reason: '통화 다름');
  });

  testWidgets('PM-DEC-146 — 시트 수치는 Figma 6438:4772(제목 18 Bold · 가격 28/16 · 테두리 4)', (tester) async {
    final offer = (await buildCharacterBundleOffer(
        characters: catalog(), iap: MockIapService(catalog: storeKr)))!;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: CharacterBundleSheet(offer: offer, onBuy: () {}, onLater: () {}),
        ),
      ),
    ));
    TextStyle styleOf(String text) => tester.widget<Text>(find.text(text)).style!;
    expect(styleOf('All three at once').fontSize, 18);
    expect(styleOf('All three at once').fontWeight, FontWeight.w700);
    expect(styleOf('₩13,200').fontSize, 28);
    expect(styleOf('₩13,200').fontWeight, FontWeight.w700);
    final was = styleOf(offer.original!);
    expect(was.fontSize, 16);
    expect(was.fontWeight, FontWeight.w400);
    expect(was.decoration, TextDecoration.lineThrough);
    final ring = tester
        .widgetList<Container>(find.byType(Container))
        .map((w) => w.decoration)
        .whereType<BoxDecoration>()
        .where((d) => d.image != null)
        .toList();
    expect(ring, hasLength(3));
    for (final d in ring) {
      final side = (d.border! as Border).top;
      expect(side.width, 4);
      // PM-DEC-150 — 시트 면 토큰(라이트 #FFFFFF · 다크 #1F222A).
      expect(
          side.color,
          tester
              .element(find.byType(CharacterBundleSheet))
              .c
              .backgroundElevatedAlternative);
    }
  });

  for (final state in [IapPurchaseState.canceled, IapPurchaseState.failed]) {
    testWidgets('F096 — 상품 id 없는 ${state.name} 결과도 이 구매의 끝으로 받아 버튼을 푼다', (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final iap = _UnlabeledIap(storeKr, state);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          charactersProvider.overrideWith((ref) async => catalog()),
          ownedCharactersProvider.overrideWith((ref) async => const []),
          myProfileProvider.overrideWith(
              (ref) async => const Member(memberId: 1, characterId: 1)),
          iapServiceProvider.overrideWithValue(iap),
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
      await tester.tap(find.text('Buy'));
      await tester.pumpAndSettle();
      // 풀렸으면 다시 누를 수 있다 — 두 번째 결제가 시작된다.
      await tester.tap(find.text('Buy'));
      await tester.pumpAndSettle();
      expect(iap.purchases_, 2, reason: '_busy 가 풀렸어야 한다');
      // 실기기 재현(09-28): 취소 뒤 다른 캐릭터로 옮겨도 구매가 막혀 있었다.
      await tester.tap(find.bySemanticsLabel('Popo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buy'));
      await tester.pumpAndSettle();
      expect(iap.purchases_, 3, reason: '다른 캐릭터의 Buy 도 눌려야 한다');
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('F095 — 캐릭터가 이미 이 스토어 계정에 있으면 Premium 시트가 아니라 복원', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final iap = _AlreadyOwnedIap(storeKr);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        charactersProvider.overrideWith((ref) async => catalog()),
        ownedCharactersProvider.overrideWith((ref) async => const []),
        myProfileProvider
            .overrideWith((ref) async => const Member(memberId: 1, characterId: 1)),
        iapServiceProvider.overrideWithValue(iap),
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
    await tester.tap(find.text('Buy'));
    await tester.pumpAndSettle();
    expect(iap.restores, 1);
    expect(find.text("You're already on Premium"), findsNothing);
    await tester.pumpWidget(const SizedBox());
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

/// 결과를 **상품 id 없이** 돌려준다 — Play 의 취소·오류가 그렇다(QA F096). 옛 가짜는 id 를
/// 채워서 이 결함을 못 잡았다.
class _UnlabeledIap extends MockIapService {
  _UnlabeledIap(List<IapProduct> catalog, this.state) : super(catalog: catalog);
  final IapPurchaseState state;
  int purchases_ = 0;
  final _events = StreamController<IapPurchase>.broadcast();

  @override
  Stream<IapPurchase> get purchases => _events.stream;

  @override
  Future<void> purchase(IapProduct product) async {
    purchases_++;
    scheduleMicrotask(() => _events.add(IapPurchase(
        productId: '',
        type: product.type,
        state: state,
        failure: state == IapPurchaseState.failed ? IapFailure.store : null)));
  }
}

/// 결과를 [outcome] 으로 답하고 복원 호출 수를 센다.
class _AlreadyOwnedIap extends MockIapService {
  _AlreadyOwnedIap(List<IapProduct> catalog) : super(catalog: catalog);
  int restores = 0;
  final _events = StreamController<IapPurchase>.broadcast();

  @override
  Stream<IapPurchase> get purchases => _events.stream;

  @override
  Future<void> purchase(IapProduct product) async {
    scheduleMicrotask(() => _events.add(IapPurchase(
        productId: product.id,
        type: product.type,
        state: IapPurchaseState.failed,
        failure: IapFailure.alreadyOwned)));
  }

  @override
  Future<RestoreOutcome> restore() async {
    restores++;
    return RestoreOutcome.restored;
  }
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
