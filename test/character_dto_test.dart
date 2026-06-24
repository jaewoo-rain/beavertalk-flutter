// Price/Decimal parsing tests for CharacterDto (the load-bearing logic).

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/character/data/models/character_dto.dart';

void main() {
  group('parseKrw (Decimal string → integer KRW)', () {
    test('parses "4900.00" to 4900', () {
      expect(parseKrw('4900.00'), 4900);
    });

    test('parses "0.00" to 0', () {
      expect(parseKrw('0.00'), 0);
    });

    test('rounds fractional values', () {
      expect(parseKrw('6899.50'), 6900);
    });

    test('tolerates int and double inputs', () {
      expect(parseKrw(4900), 4900);
      expect(parseKrw(4900.0), 4900);
    });

    test('returns 0 for null/garbage', () {
      expect(parseKrw(null), 0);
      expect(parseKrw('not-a-number'), 0);
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
      expect(c.price, 4900);
      expect(c.effectivePrice, 4900);
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
  });
}
