import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/alarm/presentation/providers/alarm_list_controller.dart';
import 'package:beavertalk/features/alarm/presentation/providers/alarm_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/language_sheet_provider.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/auth/presentation/providers/signup_draft_provider.dart';
import 'package:beavertalk/features/auth/presentation/providers/user_scoped_providers.dart';
import 'package:beavertalk/features/bookmark/presentation/providers/bookmark_providers.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';

/// 로그아웃 시 **회원별 캐시가 남지 않는지**.
///
/// 이 규칙은 두 번 깨졌다. 두 번 다 방식이 같았다 — 새 provider 를 만들고 무효화 목록에
/// 넣는 걸 **잊었다**(`charactersProvider`, 그리고 `myAccentProvider`). 그래서 목록을
/// 코드 밖으로 빼 `user_scoped_providers.dart` 의 순회 가능한 상수 둘로 만들었고,
/// 여기서 세 층으로 지킨다:
///
///   1. 동작   — 목록을 돌며 무효화하면 실제로 다시 읽는가 (파생까지 따라오는가)
///   2. 심볼   — 있어야 할 것이 목록에 있는가 (소스 파싱 없이 인스턴스 동일성으로)
///   3. 발견   — 레포의 **모든** 회원 후보 provider 가 두 목록 중 정확히 한 곳에 있는가
///
/// 3번이 핵심이다. 1·2번은 "지금 아는 것"만 지키지만, 3번은 **새로 만든 provider 를
/// 자동으로 발견해** 분류를 강제한다. 잊고 지나갈 경로가 없어진다.
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

  // ── 1. 동작 ───────────────────────────────────────────────────────────────
  group('목록을 돌며 무효화하면 캐시가 로그아웃 경계를 못 넘는다', () {
    /// `AuthController._clearUserScopedState()` 가 하는 일과 같다. 그쪽은 Supabase 를
    /// 타야 해서 위젯테스트로 부르기 어렵고, 정작 검증할 것은 **목록 + 순회**다.
    void clearUserScopedState(ProviderContainer container) {
      for (final provider in userScopedProviders) {
        container.invalidate(provider);
      }
    }

    test('카탈로그가 다음 회원 값으로 다시 읽힌다', () async {
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

      clearUserScopedState(container);

      final b = await container.read(charactersProvider.future);
      expect(b.onlyWhere((c) => c.isOwned).name, 'JUDI',
          reason: 'B 가 A 의 소유 상태를 그대로 보고 있다');
    });

    test('파생 목록(알람 통화 상대)도 같이 따라온다', () async {
      // ⚠ 이 목록은 카탈로그에서 파생된다(보유 목록 API 에는 is_unlocked 가 없어서).
      // 파생이 무효화를 안 따라오면 캐릭터 화면만 갱신되고 예약 전화 상대에는 A 의
      // 캐릭터가 남는다. 그래서 파생은 목록에 안 넣고 원본만 넣는다 — 그 판단이
      // 실제로 성립하는지 여기서 확인한다.
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

      clearUserScopedState(container);

      final after = await container.read(availableCharactersProvider.future);
      expect([for (final c in after) c.name], ['JUDI'],
          reason: 'A 의 통화 상대가 B 의 예약 화면에 남아 있다');
    });
  });

  // ── 2. 심볼 ───────────────────────────────────────────────────────────────
  group('무효화 목록', () {
    test('회원별 캐시를 담는 provider 가 전부 들어 있다', () {
      // 인스턴스 동일성으로 확인한다 — 소스를 읽지 않으므로 목록 구조가 바뀌어도
      // 헛돌 수 없다. 각 항목이 빠졌을 때 무엇이 새는지는 user_scoped_providers.dart 에.
      expect(userScopedProviders, containsAll(<ProviderOrFamily>[
        myProfileProvider,
        // 빠져 있던 것 ①: B 가 A 의 소유·잠금해제 상태를 봤다.
        charactersProvider,
        // 빠져 있던 것 ②: B 의 마이페이지에 A 의 억양 통계가 떴다.
        myAccentProvider,
        alarmListControllerProvider,
        bookmarkListProvider,
        ownedCharactersProvider,
        sessionEntitlementProvider,
        signupDraftProvider,
      ]));
    });

    test('앱 실행 스코프 플래그는 지우는 쪽에 있으면 안 된다', () {
      // languageSheetShownProvider 를 지우면 로그아웃 직후 로그인 화면이 매번 "최초
      // 진입"으로 착각해 언어 시트를 띄웠다가 _popToRoot 가 그 라우트를 pop 해,
      // 올라오다 마는 시트가 보인다. 좋은 뜻으로 옮겨지기 쉬워서 양쪽으로 못박는다.
      expect(userScopedProviders, isNot(contains(languageSheetShownProvider)));
      expect(intentionallyNotUserScoped, contains(languageSheetShownProvider));
    });

    test('두 목록은 겹치지 않는다', () {
      final overlap = userScopedProviders.toSet()
        ..retainAll(intentionallyNotUserScoped.toSet());
      expect(overlap, isEmpty,
          reason: '같은 provider 가 지운다/안 지운다 양쪽에 있다');
    });
  });

  // ── 3. 발견 ───────────────────────────────────────────────────────────────
  //
  // 여기만 소스를 읽는다. 읽는 대상이 **선언부 전체**라, 새로 만든 provider 를 자동으로
  // 찾아낸다. 읽는 대상이 목록 자체이기도 해서, 목록이 비면 조용히 통과하지 않고 실패한다.
  group('새 provider 는 분류를 강제당한다', () {
    /// 상태를 담는 provider 종류. 이것들만 자기 캐시를 갖는다.
    const stateful = [
      'FutureProvider',
      'StreamProvider',
      'StateProvider',
      'NotifierProvider',
      'AsyncNotifierProvider',
      'StateNotifierProvider',
    ];

    /// `final xProvider = Kind...` 선언을 전부 찾는다. `.autoDispose` 와 순수
    /// `Provider`(파생·공장)는 제외 — 이유는 user_scoped_providers.dart 에 적어 뒀다.
    List<String> declaredStatefulProviders() {
      final found = <String>[];
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final src = entity.readAsStringSync();
        for (final m in RegExp(
          r'^final\s+(\w*Provider)\s*=\s*([\s\S]{0,140}?)[(<]',
          multiLine: true,
        ).allMatches(src)) {
          final name = m.group(1)!;
          final decl = m.group(2)!.replaceAll(RegExp(r'\s+'), '');
          if (decl.contains('autoDispose')) continue;
          if (!stateful.contains(decl.split('.').first)) continue;
          found.add(name);
        }
      }
      return found;
    }

    /// 레지스트리 파일에서 두 목록의 항목 이름을 뽑는다. 항목은 한 줄에 하나씩
    /// `name,` 형태라, 사이의 주석과 섞이지 않는다.
    Set<String> entriesOf(String listName) {
      final src = File(
        'lib/features/auth/presentation/providers/user_scoped_providers.dart',
      ).readAsStringSync();
      final start = src.indexOf('$listName = <ProviderOrFamily>[');
      expect(start, isNonNegative, reason: '$listName 목록을 찾을 수 없다');
      final body = src.substring(start, src.indexOf('];', start));
      return RegExp(r'^\s*(\w+),\s*$', multiLine: true)
          .allMatches(body)
          .map((m) => m.group(1)!)
          .toSet();
    }

    test('모든 회원 후보 provider 가 두 목록 중 정확히 한 곳에 있다', () {
      final cleared = entriesOf('userScopedProviders');
      final excluded = entriesOf('intentionallyNotUserScoped');
      // 목록이 비어 조용히 통과하는 일이 없도록.
      expect(cleared, isNotEmpty);
      expect(excluded, isNotEmpty);

      final unclassified = <String>[];
      for (final name in declaredStatefulProviders()) {
        final inCleared = cleared.contains(name);
        final inExcluded = excluded.contains(name);
        if (inCleared == inExcluded) unclassified.add(name);
      }

      expect(unclassified, isEmpty,
          reason: '이 provider 들을 user_scoped_providers.dart 의 두 목록 중 '
              '하나에 넣어라 — 로그아웃 때 지울 것인가, 일부러 남길 것인가: '
              '$unclassified');
    });

    test('목록에 죽은 이름이 남아 있지 않다', () {
      // provider 를 지웠는데 목록에서 안 뺀 경우. 컴파일은 되지만(심볼이 살아 있으면)
      // 선언 훑기와 어긋나므로 여기서 잡힌다.
      final declared = declaredStatefulProviders().toSet();
      final listed = {
        ...entriesOf('userScopedProviders'),
        ...entriesOf('intentionallyNotUserScoped'),
      };
      expect(listed.difference(declared), isEmpty,
          reason: '선언이 사라졌거나 autoDispose 로 바뀐 항목이 목록에 남아 있다');
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
