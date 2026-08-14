import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar.dart';

/// 캐릭터 변경 화면의 **목록 배치**.
///
/// 서버가 소유(`is_owned`)와 접근(`is_unlocked`)을 나눠 보내면서, 이 화면의 목록
/// 기준이 소유에서 접근으로 옮겨갔다. 그 변경의 안전장치가 하나 있다:
///
///   **무료·Pro 회원 화면은 1픽셀도 바뀌면 안 된다.**
///
/// 그분들에게는 구독이 아무것도 열지 않아 `is_unlocked == is_owned` 이므로, 새 필터가
/// 종전 필터와 수학적으로 같은 결과를 내야 한다. 그게 이 파일의 첫 번째 그룹이고,
/// 화면에 실제로 찍힌 글자를 통째로 비교해서 못박는다.
void main() {
  /// 카탈로그를 **실제 파싱 경로로** 만든다. 엔티티를 손으로 짜면 DTO 폴백을 건너뛰어
  /// 구서버 응답을 재현할 수 없다 — 이 테스트가 확인하려는 것이 정확히 그 경로다.
  List<Character> catalog(List<Map<String, dynamic>> rows) =>
      [for (final r in rows) CharacterDto.fromJson(r).toEntity()];

  Map<String, dynamic> row(
    int id,
    String name, {
    required String price,
    String? effectivePrice,
    bool owned = false,
    // null = 키 자체를 안 보낸다(구버전 서버).
    bool? unlocked,
    String? source,
  }) =>
      {
        'character_id': id,
        'product_key': name.toLowerCase(),
        'name': name,
        'price': price,
        'effective_price': effectivePrice ?? price,
        'is_owned': owned,
        // null 이면 키 자체가 빠진다 — 구버전 서버 응답이 그 모양이다.
        'is_unlocked': ?unlocked,
        'unlock_source': ?source,
      };

  Widget host(List<Character> characters, {int? activeId}) {
    return ProviderScope(
      overrides: [
        charactersProvider.overrideWith((ref) async => characters),
        // 보유 목록 API 는 **산 것만** 내려준다(서버가 그렇게 못 박았다). 구독으로
        // 열린 캐릭터는 여기 절대 안 들어온다 — 그래서 카탈로그에서 따로 골라야 한다.
        ownedCharactersProvider.overrideWith((ref) async => [
              for (final c in characters.where((c) => c.isOwned))
                OwnedCharacter(id: c.id, name: c.name),
            ]),
        myProfileProvider.overrideWith(
          (ref) async => Member(memberId: 1, characterId: activeId),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AvatarScreen(),
      ),
    );
  }

  /// 화면에 찍힌 글자 전부(순서 유지). 목록 제목과 그 안의 캐릭터 이름이 다 들어온다.
  List<String> screenText(WidgetTester tester) => tester
      .widgetList<Text>(find.byType(Text))
      .map((w) => w.data ?? '')
      .where((s) => s.isNotEmpty)
      .toList();

  Future<List<String>> render(WidgetTester tester, Widget app) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    return screenText(tester);
  }

  // ── ★ 안전장치: 무료·Pro 회원 화면 무변화 ──────────────────────────────────
  group('무료·Pro 회원 화면은 안 바뀐다', () {
    // 같은 회원, 같은 캐릭터 3개. 다른 것은 서버가 새 필드를 실어 보내느냐뿐이다.
    final oldServer = [
      row(1, 'BABA', price: '10.00', owned: true),
      row(2, 'BIBI', price: '10.00', effectivePrice: '5.00'),
      row(3, 'JUDI', price: '10.00'),
    ];
    final newServer = [
      row(1, 'BABA', price: '10.00', owned: true, unlocked: true, source: 'owned'),
      // 구독이 없으니 안 산 캐릭터는 잠긴 채로 온다.
      row(2, 'BIBI', price: '10.00', effectivePrice: '5.00', unlocked: false),
      row(3, 'JUDI', price: '10.00', unlocked: false),
    ];

    testWidgets('구버전 응답과 신버전 응답의 화면이 글자 단위로 같다', (tester) async {
      final before = await render(tester, host(catalog(oldServer), activeId: 1));
      final after = await render(tester, host(catalog(newServer), activeId: 1));

      // 새 필드가 붙어도 무료 회원에게는 아무 일도 일어나지 않아야 한다. 이게
      // 깨지면 필터가 소유 축에서 조용히 벗어난 것이다.
      expect(after, before);
      expect(tester.takeException(), isNull);
    });

    testWidgets('종전 목록 구성이 그대로다 — Max 목록은 아예 안 생긴다', (tester) async {
      final texts = await render(tester, host(catalog(newServer), activeId: 1));

      expect(texts, contains('My Partners · 1 owned'));
      expect(texts, contains('Limited-time discount'));
      expect(texts, contains('Available to purchase'));
      // 구독이 없는 회원에게 이 목록이 뜨면 안 된다.
      expect(texts, isNot(contains('Available with Max')));
      expect(tester.takeException(), isNull);
    });
  });

  // ── Max 회원: 원래 버그가 고쳐졌는지 ──────────────────────────────────────
  group('Max 회원', () {
    // 산 것은 BABA 하나. 나머지는 구독이 열어준 것이다.
    final maxMember = [
      row(1, 'BABA', price: '10.00', owned: true, unlocked: true, source: 'owned'),
      row(2, 'BIBI',
          price: '10.00',
          effectivePrice: '5.00',
          unlocked: true,
          source: 'subscription'),
      row(3, 'JUDI', price: '10.00', unlocked: true, source: 'subscription'),
    ];

    testWidgets('안 산 캐릭터가 "Max로 이용 가능" 목록에 모인다', (tester) async {
      final texts = await render(tester, host(catalog(maxMember), activeId: 1));

      expect(texts, contains('Available with Max'));
      expect(texts, contains('BIBI'));
      expect(texts, contains('JUDI'));
      // 산 것은 여전히 보유 목록에 남는다 — 소유가 구독보다 우선이다.
      expect(texts, contains('My Partners · 1 owned'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('구매 목록은 비어서 사라진다 (사장님 결정 A안)', (tester) async {
      final texts = await render(tester, host(catalog(maxMember), activeId: 1));

      // 이미 쓸 수 있는 캐릭터를 "구매 가능"이라고 부르지 않는다.
      expect(texts, isNot(contains('Available to purchase')));
      expect(texts, isNot(contains('Limited-time discount')));
    });

    testWidgets('Max 캐릭터는 "보유"라고 말하지 않는다', (tester) async {
      // 대표 캐릭터를 비워 둔다 — 대표로 지정된 카드는 "보유" 대신 "사용 중"을
      // 달아서, activeId 를 주면 정작 확인하려는 라벨이 화면에서 사라진다.
      final texts = await render(tester, host(catalog(maxMember)));

      // 보유 라벨은 실제로 산 BABA 카드 하나뿐이어야 한다. 구독으로 열린 것에까지
      // 붙으면 산 것으로 오해시킨 뒤 해지 때 뺏는 꼴이 된다.
      expect(texts.where((t) => t == 'Owned').length, 1);
      // 대신 "이용 가능"으로 — 지금 쓸 수 있다는 사실만 말한다.
      expect(texts.where((t) => t == 'Available').length, 2);
    });

    testWidgets('Max 캐릭터를 대표로 쓰고 있으면 "사용 중"으로 표시된다', (tester) async {
      // 구독으로 열린 캐릭터도 대표가 될 수 있다 — 서버가 허용한다.
      final texts = await render(tester, host(catalog(maxMember), activeId: 2));

      expect(texts, contains('In use'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('탭하면 사용하기와 구매하기가 둘 다 있는 상세로 들어간다', (tester) async {
      await tester.pumpWidget(host(catalog(maxMember), activeId: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('BIBI'));
      await tester.pumpAndSettle();

      // 원래 버그: 여기에 "사용하기"가 없어서 고를 수가 없었다.
      expect(find.text('Use This'), findsOneWidget);
      // 그렇다고 구매 경로를 뺏지도 않는다.
      expect(find.text('Buy'), findsOneWidget);
      expect(find.text('Available with Max'), findsOneWidget);
      expect(find.text('Owned'), findsNothing);
    });
  });
}
