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
      // 모음 자리에 자음이 들린 경우. Airflow 에는 ㅏ 가, Vowel 에는 ㄴ 이 없다.
      // 억지로 맞추면 모음 카드와 기류 카드를 나란히 놓게 되므로 한 컷만 낸다.
      final r = diagramPair('ㅏ', 'ㄴ', isCoda: false);
      expect(r.target?.series, DiagramSeries.vowel);
      expect(r.current, isNull, reason: '계열이 섞인 두 컷은 비교가 아니다');
    });

    test('ㄷ·ㅂ 초성이 Airflow 로 잡힌다 — 종성판을 빌려 쓰지 않는다', () {
      // 2026-08-30 이전에는 이 두 자모만 Airflow 초성판이 없어 시트가 안 열렸다.
      for (final pair in [('ㄷ', 'ㄹ'), ('ㅂ', 'ㄹ'), ('ㄷ', 'ㅁ'), ('ㅂ', 'ㄴ')]) {
        final r = diagramPair(pair.$1, pair.$2, isCoda: false);
        expect(r.target?.series, DiagramSeries.airflow);
        expect(r.current?.series, DiagramSeries.airflow);
        expect(r.target!.asset, isNot(r.current!.asset));
      }
      expect(
        diagramForJamo('ㄷ', isCoda: false)!.asset,
        isNot(diagramForJamo('ㄷ', isCoda: true)!.asset),
        reason: '초성은 d.png · 종성은 d_coda.png — 자리마다 제 파일을 쓴다',
      );
    });

    test('마찰음 위치 오류(ㅅ↔ㅎ)가 Place 로 잡힌다', () {
      // Place/ㅎ(성문)이 들어오기 전에는 Airflow 로 떨어졌다.
      final r = diagramPair('ㅅ', 'ㅎ', isCoda: false);
      expect(r.target?.series, DiagramSeries.place);
      expect(r.current?.series, DiagramSeries.place);
      expect(r.target!.asset, isNot(r.current!.asset));
    });
  });

  group('불변식', () {
    test('완성형 한글 11,172자 전부 도해가 나온다 — 안 눌리는 칩이 없다', () {
      // 도해가 null 이면 learning_intro 의 단어 칩이 onTap: null 이 돼
      // **눌리지 않는 칩**이 된다. 화면에는 멀쩡히 보이므로 눈으로 못 잡는다.
      final missing = <String>[];
      for (var code = 0xAC00; code <= 0xD7A3; code++) {
        final s = String.fromCharCode(code);
        if (diagramForSyllable(s) == null) missing.add(s);
      }
      expect(missing, isEmpty,
          reason: '도해 없는 음절: ${missing.take(20).join()} (총 ${missing.length}자)');
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
