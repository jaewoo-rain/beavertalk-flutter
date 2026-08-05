import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/alarm/presentation/providers/alarm_providers.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';

/// 로그아웃 시 **회원별 캐시가 남지 않는지**.
///
/// `AuthController._clearUserScopedState()` 는 무효화 대상을 **손으로 나열한다.** 그래서
/// 실패 방식이 언제나 같다 — 새 provider 를 추가하고 목록에 넣는 걸 **잊는다.** 실제로
/// `charactersProvider` 가 그렇게 빠져 있었다: 바로 옆의 `ownedCharactersProvider` 는
/// 지우면서 이것만 빠져, A 가 로그아웃하고 B 가 로그인하면 B 가 A 의 소유·잠금해제
/// 상태를 봤다(카탈로그의 `is_owned`/`is_unlocked` 는 조회한 회원 기준 계산값이다).
///
/// 한 줄 고치고 끝내면 다음 provider 에서 같은 사고가 반복되므로, 두 가지를 못박는다:
///  1) 무효화가 실제로 **의존 provider 까지** 다시 흐르는가 (동작)
///  2) 목록에서 항목이 **조용히 빠지지 않는가** (누락 자체)
void main() {
  Character character(int id, String name, {required bool owned}) =>
      CharacterDto.fromJson({
        'character_id': id,
        'name': name,
        'price': '10.00',
        'effective_price': '10.00',
        'is_owned': owned,
        'is_unlocked': owned,
      }).toEntity();

  group('카탈로그 캐시는 로그아웃 경계를 못 넘는다', () {
    test('무효화하면 다음 회원 값으로 다시 읽는다', () async {
      // A: BABA 보유 / B: JUDI 보유. 같은 카탈로그라도 회원마다 붙는 값이 다르다.
      final catalogs = [
        [character(1, 'BABA', owned: true), character(2, 'BIBI', owned: false)],
        [character(1, 'BABA', owned: false), character(2, 'JUDI', owned: true)],
      ];
      var reads = 0;
      final container = ProviderContainer(overrides: [
        charactersProvider.overrideWith((ref) async => catalogs[reads++]),
      ]);
      addTearDown(container.dispose);

      final a = await container.read(charactersProvider.future);
      expect(a.onlyWhere((c) => c.isOwned).name, 'BABA');

      // 로그아웃이 하는 일.
      container.invalidate(charactersProvider);

      final b = await container.read(charactersProvider.future);
      expect(b.onlyWhere((c) => c.isOwned).name, 'JUDI',
          reason: 'B 가 A 의 소유 상태를 그대로 보고 있다');
    });

    test('알람의 통화 상대 목록도 같이 따라온다', () async {
      // ⚠ 이 목록은 카탈로그에서 파생된다(보유 목록 API 에는 is_unlocked 가 없어서).
      // 파생 provider 가 무효화를 따라오지 않으면, 캐릭터 화면만 갱신되고 예약 전화
      // 상대에는 A 의 캐릭터가 그대로 남는다.
      final catalogs = [
        [character(1, 'BABA', owned: true), character(2, 'BIBI', owned: false)],
        [character(1, 'BABA', owned: false), character(2, 'JUDI', owned: true)],
      ];
      var reads = 0;
      final container = ProviderContainer(overrides: [
        charactersProvider.overrideWith((ref) async => catalogs[reads++]),
      ]);
      addTearDown(container.dispose);

      final before = await container.read(availableCharactersProvider.future);
      expect([for (final c in before) c.name], ['BABA']);

      container.invalidate(charactersProvider);

      final after = await container.read(availableCharactersProvider.future);
      expect([for (final c in after) c.name], ['JUDI'],
          reason: 'A 의 통화 상대가 B 의 예약 화면에 남아 있다');
    });
  });

  // ── 목록 누락 자체를 잡는다 ────────────────────────────────────────────────
  //
  // 위 동작 테스트는 "목록에 있으면 제대로 지워진다"만 보장한다. 정작 이 버그는
  // **목록에서 빠진 것**이었으므로, 목록 자체를 읽어서 확인한다. 소스를 읽는 테스트라
  // 다소 특이하지만, 이 실패 방식(누락)을 잡는 방법이 달리 없다.
  //
  // 한계(알고 쓴다): 새로 만든 회원별 provider 를 **자동으로 발견하지는 못한다.**
  // 지금 있어야 할 것이 빠지는 것만 잡는다. 발견까지 하려면 무효화 목록을 코드에서
  // 순회 가능한 형태로 빼야 한다 — 별건으로 제안해 두었다.
  group('무효화 목록', () {
    late final Set<String> invalidated;

    setUpAll(() {
      final src = File(
        'lib/features/auth/presentation/providers/auth_controller.dart',
      ).readAsStringSync();
      final start = src.indexOf('void _clearUserScopedState()');
      expect(start, isNonNegative,
          reason: '_clearUserScopedState 가 사라졌거나 이름이 바뀌었다');
      final end = src.indexOf('\n  }', start);
      final body = src.substring(start, end);
      invalidated = RegExp(r'ref\.invalidate\((\w+)\)')
          .allMatches(body)
          .map((m) => m.group(1)!)
          .toSet();
    });

    test('회원별 캐시를 담는 provider 가 전부 들어 있다', () {
      // 각 항목이 빠졌을 때 무엇이 새는지는 auth_controller.dart 의 주석에 있다.
      expect(invalidated, containsAll(<String>[
        'myProfileProvider',
        'alarmListControllerProvider',
        'bookmarkListProvider',
        'ownedCharactersProvider',
        // 이것이 빠져 있던 항목이다. 지우지 않으면 B 가 A 의 소유·잠금해제 상태를 본다.
        'charactersProvider',
        'sessionEntitlementProvider',
        'signupDraftProvider',
      ]));
    });

    test('앱 실행 스코프 플래그는 여기 들어오면 안 된다', () {
      // languageSheetShownProvider 는 **회원 스코프가 아니다.** 넣으면 로그아웃 직후
      // 로그인 화면이 매번 "최초 진입"으로 착각해 언어 시트를 띄웠다가 _popToRoot 가
      // 그 라우트를 pop 해, 올라오다 마는 시트가 보인다. 그 사연은
      // language_sheet_provider.dart 에 적혀 있다 — 좋은 뜻으로 추가되기 쉬워서
      // 여기서 막는다.
      expect(invalidated, isNot(contains('languageSheetShownProvider')));
    });
  });
}

extension on List<Character> {
  /// 조건에 맞는 **유일한** 원소. 0개거나 2개 이상이면 테스트를 실패시킨다.
  Character onlyWhere(bool Function(Character) test) {
    final hits = where(test).toList();
    expect(hits, hasLength(1));
    return hits.first;
  }
}
