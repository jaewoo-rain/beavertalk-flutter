// Price/Decimal parsing tests for CharacterDto (the load-bearing logic).

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/format/money.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';

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
