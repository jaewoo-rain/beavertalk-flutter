import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/review/data/speech_cache.dart';

Uint8List _bytes(int seed) => Uint8List.fromList([seed, seed + 1, seed + 2]);

void main() {
  group('SpeechCache.keyFor', () {
    test('같은 문장이라도 캐릭터가 다르면 다른 키', () {
      expect(
        SpeechCache.keyFor('안녕하세요', 1),
        isNot(SpeechCache.keyFor('안녕하세요', 2)),
      );
    });

    test('앞뒤 공백은 같은 문장으로 본다', () {
      expect(
        SpeechCache.keyFor('  안녕하세요 ', 1),
        SpeechCache.keyFor('안녕하세요', 1),
      );
    });

    test('캐릭터가 없어도 키가 만들어진다', () {
      expect(SpeechCache.keyFor('안녕하세요', null), isNotEmpty);
    });
  });

  group('SpeechCache', () {
    test('넣은 음성을 그대로 돌려준다', () {
      final cache = SpeechCache();
      final key = SpeechCache.keyFor('가요', 1);
      expect(cache.get(key), isNull);
      cache.put(key, _bytes(10));
      expect(cache.get(key), _bytes(10));
    });

    test('빈 바이트는 저장하지 않는다 — 실패를 캐시하면 복구돼도 계속 실패로 보인다', () {
      final cache = SpeechCache();
      final key = SpeechCache.keyFor('가요', 1);
      cache.put(key, Uint8List(0));
      expect(cache.get(key), isNull);
      expect(cache.length, 0);
    });

    test('한도를 넘으면 가장 오래 안 쓴 것부터 버린다', () {
      final cache = SpeechCache(maxEntries: 2);
      cache.put('a', _bytes(1));
      cache.put('b', _bytes(2));
      cache.get('a'); // a 를 최근 사용으로 올린다
      cache.put('c', _bytes(3)); // 가장 오래된 b 가 빠진다

      expect(cache.length, 2);
      expect(cache.get('a'), isNotNull);
      expect(cache.get('b'), isNull);
      expect(cache.get('c'), isNotNull);
    });

    test('같은 키를 다시 넣어도 항목이 늘지 않는다', () {
      final cache = SpeechCache(maxEntries: 2);
      cache.put('a', _bytes(1));
      cache.put('a', _bytes(9));
      expect(cache.length, 1);
      expect(cache.get('a'), _bytes(9));
    });

    test('clear 는 전부 버린다', () {
      final cache = SpeechCache();
      cache.put('a', _bytes(1));
      cache.clear();
      expect(cache.length, 0);
    });
  });
}
