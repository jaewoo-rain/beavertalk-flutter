// Price/Decimal parsing tests for CharacterDto (the load-bearing logic).

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/format/money.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';

void main() {
  group('parseMoneyMinor (Decimal string → USD cents)', () {
    test('parses "10.00" to 1000 cents', () {
      expect(parseMoneyMinor('10.00'), 1000);
    });

    test('parses "0.00" to 0', () {
      expect(parseMoneyMinor('0.00'), 0);
    });

    // The cents must survive: the old whole-unit parser rounded 9.99 to 10,
    // which would overcharge the label by a cent on every fractional price.
    test('keeps cents instead of rounding to whole units', () {
      expect(parseMoneyMinor('9.99'), 999);
      expect(parseMoneyMinor('4.50'), 450);
    });

    test('tolerates int and double inputs', () {
      expect(parseMoneyMinor(10), 1000);
      expect(parseMoneyMinor(10.0), 1000);
      expect(parseMoneyMinor(9.99), 999);
    });

    test('returns 0 for null/garbage', () {
      expect(parseMoneyMinor(null), 0);
      expect(parseMoneyMinor('not-a-number'), 0);
    });
  });

  group('formatUsd (cents → display string)', () {
    test('drops the cents for whole dollars', () {
      expect(formatUsd(1000), r'$10');
      expect(formatUsd(0), r'$0');
    });

    test('keeps two digits when there is a remainder', () {
      expect(formatUsd(999), r'$9.99');
      expect(formatUsd(1005), r'$10.05');
    });

    test('groups thousands', () {
      expect(formatUsd(1234567), r'$12,345.67');
      expect(formatUsd(100000), r'$1,000');
    });

    test('renders negatives with the sign before the symbol', () {
      expect(formatUsd(-500), r'-$5');
    });
  });

  // The app ships 30 locales and already localizes dates. Money has to follow:
  // German/French/Spanish/Turkish swap the grouping and decimal separators, so
  // a hardcoded `,`/`.` does not just look foreign — "$12.345" reads as twelve
  // thousand there instead of twelve. These lock the locale plumbing, not
  // intl's exact glyphs, so they assert the separators rather than full strings.
  group('formatUsd honours the locale', () {
    test('en groups with commas and decimates with a period', () {
      expect(formatUsd(1234567, locale: 'en'), r'$12,345.67');
    });

    test('de inverts both separators', () {
      final formatted = formatUsd(1234567, locale: 'de');
      expect(formatted, contains('12.345'));
      expect(formatted, contains(',67'));
      expect(formatted, isNot(contains(',345')));
    });

    test('fr decimates with a comma', () {
      expect(formatUsd(1234567, locale: 'fr'), contains(',67'));
    });

    test('whole dollars drop the cents in every locale', () {
      for (final locale in ['en', 'de', 'fr', 'ko', 'ja']) {
        final formatted = formatUsd(1000, locale: locale);
        expect(formatted, contains('10'), reason: 'locale $locale');
        expect(formatted, isNot(contains('00')), reason: 'locale $locale');
      }
    });
  });

  group('CharacterDto.fromJson', () {
    test('maps summary fields and parses prices, computes discount', () {
      final dto = CharacterDto.fromJson({
        'character_id': 2,
        'name': 'Judi',
        'image_url': null,
        'price': '4900.00',
        'effective_price': '4900.00',
        'is_owned': false,
      });
      final c = dto.toEntity();

      expect(c.id, 2);
      expect(c.name, 'Judi');
      expect(c.price, 490000); // "4900.00" → cents
      expect(c.effectivePrice, 490000);
      expect(c.isOwned, isFalse);
      expect(c.hasDiscount, isFalse); // effective == price
      expect(c.isFree, isFalse);
    });

    test('detects discount and free pricing', () {
      final discounted = CharacterDto.fromJson({
        'character_id': 3,
        'name': 'Bori',
        'price': '6900.00',
        'effective_price': '4900.00',
        'is_owned': false,
      }).toEntity();
      expect(discounted.hasDiscount, isTrue);

      final free = CharacterDto.fromJson({
        'character_id': 1,
        'name': '비비',
        'price': '0.00',
        'effective_price': '0.00',
        'is_owned': true,
      }).toEntity();
      expect(free.isFree, isTrue);
      expect(free.isOwned, isTrue);
    });

    // `description` (one-line catch-phrase) and `background_story` (the story
    // paragraph) are separate server columns feeding separate slots on the
    // detail screen. `background_story` was dropped here entirely, so the
    // story never reached the UI and the catch-phrase was rendered in its
    // place. Keep them distinct.
    test('keeps description and background_story as separate fields', () {
      final c = CharacterDto.fromJson({
        'character_id': 4,
        'name': 'BIBI',
        'price': '4900.00',
        'effective_price': '4900.00',
        'is_owned': false,
        'description': '맞히는 순간 폭발하는 리액션 부자!',
        'background_story': 'BIBI is a beaver who cheers for every answer.',
        'voice_url': 'https://cdn.example.com/bibi.mp3',
        'tags': ['Excited', 'Sweet'],
      }).toEntity();

      expect(c.description, '맞히는 순간 폭발하는 리액션 부자!');
      expect(c.backgroundStory, 'BIBI is a beaver who cheers for every answer.');
      expect(c.voiceUrl, 'https://cdn.example.com/bibi.mp3');
      expect(c.tags, ['Excited', 'Sweet']);
    });

    test('tolerates a null background_story', () {
      final c = CharacterDto.fromJson({
        'character_id': 5,
        'name': 'Popo',
        'price': '4900.00',
        'effective_price': '4900.00',
        'is_owned': false,
        'description': 'Warm and tender.',
        'background_story': null,
      }).toEntity();

      expect(c.description, 'Warm and tender.');
      expect(c.backgroundStory, isNull);
    });
  });

  // 소유(is_owned)와 접근(is_unlocked)은 **다른 축**이다. 서버는 Max 회원에게
  // member_character 행을 만들지 않는다 — 만들면 해지 후에도 영구 소유가 되어
  // 되돌릴 수 없기 때문이다. 그래서 "샀나"와 "지금 쓸 수 있나"가 별도 필드로 온다.
  //
  // 원래 버그가 여기였다: 앱이 is_owned 만 읽어서, Max 구독 중인데도 구매하지 않은
  // 캐릭터가 잠긴 채로 남았다.
  group('CharacterDto — 잠금 해제(entitlement) 축', () {
    Character parse(Map<String, dynamic> extra) => CharacterDto.fromJson({
          'character_id': 7,
          'name': 'BIBI',
          'price': '4900.00',
          'effective_price': '4900.00',
          ...extra,
        }).toEntity();

    test('Max 로 열린 미구매 캐릭터: 쓸 수 있지만 산 건 아니다', () {
      final c = parse({
        'is_owned': false,
        'is_unlocked': true,
        'unlock_source': 'subscription',
      });

      expect(c.isUnlocked, isTrue);
      expect(c.isOwned, isFalse); // ⛔ 여기가 true 로 뒤집히면 안 된다
      expect(c.unlockSource, CharacterUnlockSource.subscription);
      expect(c.isSubscriptionUnlocked, isTrue);
    });

    test('구매한 캐릭터는 소유가 구독보다 우선한다', () {
      // 순서를 뒤집으면 이미 산 캐릭터까지 "해지하면 사라짐"으로 표시된다.
      final c = parse({
        'is_owned': true,
        'is_unlocked': true,
        'unlock_source': 'owned',
      });

      expect(c.unlockSource, CharacterUnlockSource.owned);
      expect(c.isSubscriptionUnlocked, isFalse);
    });

    test('잠긴 캐릭터는 unlock_source 가 null 이다', () {
      final c = parse({
        'is_owned': false,
        'is_unlocked': false,
        'unlock_source': null,
      });

      expect(c.isUnlocked, isFalse);
      expect(c.unlockSource, isNull);
      expect(c.isSubscriptionUnlocked, isFalse);
    });

    // ★ 하위호환 — prod(app-api) 에는 서버 변경이 아직 안 나갔다. 지금 실기기가
    // 실제로 타는 경로이므로, 없으면 크래시가 아니라 종전 동작이어야 한다.
    test('is_unlocked 가 없는 구버전 응답은 is_owned 로 폴백한다', () {
      final ownedOnly = parse({'is_owned': true});
      expect(ownedOnly.isUnlocked, isTrue, reason: '산 캐릭터가 잠겼다');
      expect(ownedOnly.unlockSource, CharacterUnlockSource.owned);

      final locked = parse({'is_owned': false});
      expect(locked.isUnlocked, isFalse, reason: '안 산 캐릭터가 열렸다');
      expect(locked.unlockSource, isNull);
    });

    test('두 필드가 통째로 없어도 크래시하지 않는다', () {
      final c = parse(const {});
      expect(c.isOwned, isFalse);
      expect(c.isUnlocked, isFalse);
      expect(c.unlockSource, isNull);
    });

    test('unlock_source 만 없으면 두 축에서 파생한다', () {
      // 서버가 이유를 안 실어 보내도 화면 분기는 되어야 한다. 파생 규칙은 서버와
      // 같다 — 소유 우선.
      expect(
        parse({'is_owned': false, 'is_unlocked': true}).unlockSource,
        CharacterUnlockSource.subscription,
      );
      expect(
        parse({'is_owned': true, 'is_unlocked': true}).unlockSource,
        CharacterUnlockSource.owned,
      );
    });

    test('모르는 unlock_source 문자열은 파생값으로 떨어진다', () {
      // 서버가 나중에 값을 추가해도(예: "promo") 앱이 죽지 않아야 한다.
      final c = parse({
        'is_owned': false,
        'is_unlocked': true,
        'unlock_source': 'promo',
      });
      expect(c.isUnlocked, isTrue);
      expect(c.unlockSource, CharacterUnlockSource.subscription);
    });
  });

  group('OwnedCharacterDto.fromJson', () {
    test('parses owned fields with nullable purchase data', () {
      final owned = OwnedCharacterDto.fromJson({
        'character_id': 1,
        'name': '비비',
        'image_url': null,
        'purchase_price': '0.00',
        'purchase_date': '2026-06-24T01:00:00Z',
      }).toEntity();

      expect(owned.id, 1);
      expect(owned.purchasePrice, 0);
      expect(owned.purchaseDate, isNotNull);
    });

    test('handles missing purchase price/date', () {
      final owned = OwnedCharacterDto.fromJson({
        'character_id': 2,
        'name': 'Judi',
      }).toEntity();

      expect(owned.purchasePrice, isNull);
      expect(owned.purchaseDate, isNull);
    });

    // `OwnedCharacterOut` carries the same story column as the catalog, so an
    // owned character's detail screen must fill both slots too.
    test('carries description and background_story separately', () {
      final owned = OwnedCharacterDto.fromJson({
        'character_id': 3,
        'name': 'BABA',
        'description': '틀리면 세상 다정해지는 반전 매력 선생님.',
        'background_story': 'BABA, a beaver famous for his flawless dams.',
        'voice_url': 'https://cdn.example.com/baba.mp3',
      }).toEntity();

      expect(owned.description, '틀리면 세상 다정해지는 반전 매력 선생님.');
      expect(owned.backgroundStory, 'BABA, a beaver famous for his flawless dams.');
      expect(owned.voiceUrl, 'https://cdn.example.com/baba.mp3');
    });
  });
}
