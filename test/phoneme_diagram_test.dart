import 'dart:io';

import 'package:beavertalk/features/pronunciation/domain/phoneme_diagram.dart';
import 'package:flutter_test/flutter_test.dart';

/// 계열 선택 규칙을 못 박는다.
///
/// ⛔ 이 테스트가 지키는 것은 「그림이 나온다」가 아니라 **「맞는 계열이 나온다」**다.
///    긴장도만 다른 쌍을 Airflow 로 그리면 다른 픽셀이 0.00~0.02% — 사람 눈에는
///    **같은 그림 두 장**이다. 그 상태로도 앱은 멀쩡히 돌기 때문에 회귀를 눈으로
///    못 잡는다. 그래서 자로 잰다.
void main() {
  group('diagramPair 계열 선택', () {
    test('긴장도만 다르면 Phonation — Airflow 로는 같은 그림이 된다', () {
      for (final pair in [
        ('ㄱ', 'ㅋ'),
        ('ㄱ', 'ㄲ'),
        ('ㄷ', 'ㅌ'),
        ('ㅂ', 'ㅍ'),
        ('ㅅ', 'ㅆ'),
        ('ㅈ', 'ㅊ'),
      ]) {
        final r = diagramPair(pair.$1, pair.$2, isCoda: false);
        expect(r.target?.series, DiagramSeries.phonation,
            reason: '${pair.$1}→${pair.$2} 는 긴장도 대립이다');
        expect(r.current?.series, DiagramSeries.phonation);
        expect(r.target!.asset, isNot(r.current!.asset),
            reason: '두 컷이 같은 파일이면 보여줄 이유가 없다');
      }
    });

    test('조음 방법이 같고 위치가 다르면 Place', () {
      final r = diagramPair('ㄴ', 'ㅁ', isCoda: false); // 둘 다 비음
      expect(r.target?.series, DiagramSeries.place);
      expect(r.current?.series, DiagramSeries.place);
      expect(r.target!.asset, isNot(r.current!.asset));
    });

    test('조음 방법이 다르면 Airflow', () {
      final r = diagramPair('ㄹ', 'ㄴ', isCoda: true); // 유음 ↔ 비음
      expect(r.target?.series, DiagramSeries.airflow);
      expect(r.current?.series, DiagramSeries.airflow);
      expect(r.target!.asset, isNot(r.current!.asset));
    });

    test('모음끼리면 Vowel', () {
      final r = diagramPair('ㅓ', 'ㅗ', isCoda: false);
      expect(r.target?.series, DiagramSeries.vowel);
      expect(r.current?.series, DiagramSeries.vowel);
      expect(r.target!.asset, isNot(r.current!.asset));
    });

    test('실제 발음을 모르면 한 컷만 — 없는 근거로 두 컷을 그리지 않는다', () {
      final r = diagramPair('ㄹ', null, isCoda: true);
      expect(r.target, isNotNull);
      expect(r.current, isNull);
    });

    test('도해가 없는 음소는 두 컷을 포기하고 계열을 안 섞는다', () {
      // ㄷ·ㅂ 는 Airflow 초성판이 없다. 방법이 달라 Place 로도 못 가므로 한 컷.
      final r = diagramPair('ㄷ', 'ㄹ', isCoda: false);
      expect(r.current, isNull, reason: '계열이 섞인 두 컷은 비교가 아니다');
    });
  });

  group('splitJamo', () {
    test('초성·중성·종성을 가른다', () {
      expect(splitJamo('팔'), (onset: 'ㅍ', vowel: 'ㅏ', coda: 'ㄹ'));
      expect(splitJamo('이'), (onset: 'ㅇ', vowel: 'ㅣ', coda: ''));
      expect(splitJamo('a'), isNull);
      expect(splitJamo(''), isNull);
    });
  });

  group('자산', () {
    test('매핑이 가리키는 파일이 전부 존재한다', () {
      // 도해가 없으면 시트가 조용히 빈 칸을 그린다 — 런타임에만 드러난다.
      final jamo = <String>[
        ...'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ'.split(''),
        ...'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ'.split(''),
      ];
      final missing = <String>[];
      for (final j in jamo) {
        for (final s in DiagramSeries.values) {
          for (final coda in [false, true]) {
            final d = diagramForJamo(j, isCoda: coda, series: s);
            if (d == null) continue;
            if (!File(d.asset).existsSync()) missing.add('${d.jamo} $s ${d.asset}');
          }
        }
      }
      expect(missing, isEmpty);
    });
  });
}
