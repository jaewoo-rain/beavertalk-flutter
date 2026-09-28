import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar.dart';

/// 파트너 변경 — 목록+상세를 합친 한 화면(Figma `6181:29249`, 09-22).
///
/// CTA 가 상태로 갈린다(사장님 지시): 보유·사용 중 = 비활성 Use This · 보유·미사용 = Use This ·
/// 미보유 = 구매 + 위 줄 가격 · 할인 = 할인가 + 배너. 타일을 누르면 **무대만** 바뀐다.
void main() {
  List<Character> catalog(List<Map<String, dynamic>> rows) =>
      [for (final r in rows) CharacterDto.fromJson(r).toEntity()];

  // id 는 실제 슬러그 표를 따른다 — 1 Baba(무료) · 9 Popo · 10 Rara · 11 Dudu.
  Map<String, dynamic> row(int id, String name,
          {String price = '4.99',
          String? effectivePrice,
          bool owned = false,
          bool? unlocked,
          String? source,
          Map<String, dynamic>? discount}) =>
      {
        'character_id': id,
        'product_key': name.toLowerCase(),
        'name': name,
        'price': price,
        'effective_price': effectivePrice ?? price,
        'is_owned': owned,
        'is_unlocked': unlocked ?? owned,
        'unlock_source': ?source,
        'active_discount': ?discount,
      };

  Widget host(List<Character> characters,
          {int? activeId, IapService? iap}) =>
      ProviderScope(
        overrides: [
          if (iap != null) iapServiceProvider.overrideWithValue(iap),
          charactersProvider.overrideWith((ref) async => characters),
          ownedCharactersProvider.overrideWith((ref) async => const []),
          myProfileProvider.overrideWith(
            (ref) async => Member(memberId: 1, characterId: activeId),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AvatarScreen(),
        ),
      );

  Button cta(WidgetTester t) => t.widget<Button>(find.byType(Button).last);

  final base = [
    row(1, 'Baba', owned: true),
    row(9, 'Popo', owned: true),
    row(10, 'Rara'),
    row(11, 'Dudu'),
  ];

  testWidgets('보유·사용 중 — 대표 캐릭터가 무대에, CTA 는 비활성 Use This', (t) async {
    await t.pumpWidget(host(catalog(base), activeId: 1));
    await t.pumpAndSettle();
    expect(find.text('In use'), findsOneWidget);
    expect(cta(t).text, 'Use This');
    expect(cta(t).disabled, isTrue);
  });

  testWidgets('보유·미사용 타일을 누르면 무대만 바뀌고 Use This 가 살아난다', (t) async {
    await t.pumpWidget(host(catalog(base), activeId: 1));
    await t.pumpAndSettle();
    await t.tap(find.bySemanticsLabel('Popo'));
    await t.pumpAndSettle();
    expect(find.text('Owned'), findsOneWidget);
    expect(cta(t).text, 'Use This');
    expect(cta(t).disabled, isFalse);
    // 화면 이동이 아니다 — 같은 화면에 머문다.
    expect(find.byType(AvatarScreen), findsOneWidget);
  });

  testWidgets('미보유 — 구매 버튼 + 위 줄 가격(버튼 라벨에 가격을 넣지 않는다)', (t) async {
    await t.pumpWidget(host(catalog(base), activeId: 1));
    await t.pumpAndSettle();
    await t.tap(find.bySemanticsLabel('Rara'));
    await t.pumpAndSettle();
    expect(find.text('Available to purchase'), findsOneWidget);
    expect(cta(t).text, 'Buy');
    expect(find.text(r'$4.99'), findsOneWidget);
  });

  testWidgets('미보유·할인 — 할인가 · 정가 취소선 · -N% · 떠 있는 할인 배너', (t) async {
    final ends = DateTime.now().toUtc().add(const Duration(hours: 5));
    await t.pumpWidget(host(
      catalog([
        row(1, 'Baba', owned: true),
        row(10, 'Rara',
            effectivePrice: '2.49', // 정가 $4.99 · 할인가 $2.49(PM-DEC-093)
            discount: {'end_time': ends.toIso8601String()}),
      ]),
      activeId: 1,
    ));
    await t.pumpAndSettle();
    await t.tap(find.bySemanticsLabel('Rara'));
    await t.pump();
    expect(find.text(r'$2.49'), findsOneWidget);
    expect(find.text(r'$4.99'), findsOneWidget);
    expect(find.text('-50%'), findsOneWidget);
    expect(find.text('Today only · 50% off'), findsOneWidget);
    expect(find.textContaining('left'), findsOneWidget);
    // 카운트다운 타이머를 정리한다.
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('PM-DEC-129 — 스토어 현지가가 있으면 그 값만, 서버 할인 %·배너는 뺀다', (t) async {
    final ends = DateTime.now().toUtc().add(const Duration(hours: 5));
    await t.pumpWidget(host(
      catalog([
        row(1, 'Baba', owned: true),
        row(10, 'Rara',
            effectivePrice: '2.49',
            discount: {'end_time': ends.toIso8601String()}),
      ]),
      activeId: 1,
      iap: MockIapService(catalog: const [
        IapProduct(
          id: 'bt_character_rara',
          type: IapProductType.nonConsumable,
          localizedPrice: '₩6,600',
          rawPrice: 6600,
          currencyCode: 'KRW',
        ),
      ]),
    ));
    await t.pumpAndSettle();
    await t.tap(find.bySemanticsLabel('Rara'));
    await t.pumpAndSettle();
    expect(find.text('₩6,600'), findsOneWidget);
    expect(find.text(r'$2.49'), findsNothing);
    expect(find.text(r'$4.99'), findsNothing);
    expect(find.text('-50%'), findsNothing);
    expect(find.text('Today only · 50% off'), findsNothing);
    expect(find.text('%'), findsNothing, reason: '타일 % 배지도 상세와 같은 판정(C1)');
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('PM-DEC-129 C2 — 스토어 답을 기다리는 동안 서버 USD·할인이 먼저 보이지 않는다', (t) async {
    final ends = DateTime.now().toUtc().add(const Duration(hours: 5));
    final gate = Completer<List<IapProduct>>();
    await t.pumpWidget(host(
      catalog([
        row(1, 'Baba', owned: true),
        row(10, 'Rara',
            effectivePrice: '2.49',
            discount: {'end_time': ends.toIso8601String()}),
      ]),
      activeId: 1,
      iap: _SlowIap(gate.future),
    ));
    await t.pump();
    await t.tap(find.bySemanticsLabel('Rara'));
    await t.pump();
    expect(find.text(r'$2.49'), findsNothing);
    expect(find.text('-50%'), findsNothing);
    expect(find.text('Today only · 50% off'), findsNothing);
    gate.complete(const [
      IapProduct(
          id: 'bt_character_rara',
          type: IapProductType.nonConsumable,
          localizedPrice: '₩6,600'),
    ]);
    await t.pump();
    await t.pump();
    expect(find.text('₩6,600'), findsOneWidget);
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('시안 E — 태그는 칩이 아니라 가운데점으로 이은 한 줄(6443:44301)', (t) async {
    final rows = [
      {...row(1, 'Baba', owned: true), 'tags': ['Savage', 'Blunt', 'Tsundere']},
    ];
    await t.pumpWidget(host(catalog(rows), activeId: 1));
    await t.pumpAndSettle();
    final line = find.text('Savage  ·  Blunt  ·  Tsundere');
    expect(line, findsOneWidget);
    final text = t.widget<Text>(line);
    expect(text.textAlign, TextAlign.center);
    expect(text.style!.fontSize, 14);
    expect(text.style!.fontWeight, FontWeight.w400);
    expect(text.overflow, isNot(TextOverflow.ellipsis));
    expect(find.text('Savage'), findsNothing, reason: '칩 한 개씩 그리지 않는다');
  });

  testWidgets('구독으로 열린 캐릭터는 「Owned」 라고 말하지 않는다 — 쓰기는 된다', (t) async {
    await t.pumpWidget(host(
      catalog([
        row(1, 'Baba', owned: true),
        row(11, 'Dudu', unlocked: true, source: 'subscription'),
      ]),
      activeId: 1,
    ));
    await t.pumpAndSettle();
    await t.tap(find.bySemanticsLabel('Dudu'));
    await t.pumpAndSettle();
    expect(find.text('Owned'), findsNothing);
    expect(cta(t).text, 'Use This');
    expect(cta(t).disabled, isFalse);
  });
}

/// 스토어 조회가 [answer] 가 올 때까지 멈춰 있는 레일.
class _SlowIap extends MockIapService {
  _SlowIap(this.answer);
  final Future<List<IapProduct>> answer;
  @override
  Future<List<IapProduct>> getProducts(Set<String> ids) => answer;
}
