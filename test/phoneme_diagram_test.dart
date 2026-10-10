import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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

    test('도해가 전부 애니메이션 WebP 다 — 정지 그림으로 되돌아가면 잡는다', () {
      // 도해는 조음이 **움직이는** 것을 보여주는 그림이다. 누가 PNG 로 되돌리면
      // 화면은 멀쩡히 뜨고 그림도 맞아서 눈으로는 회귀를 못 잡는다. 그래서
      // 컨테이너를 직접 읽는다 — RIFF/WEBP 헤더에 `ANIM` 청크가 있어야 한다.
      final files = Directory('assets/articulatory')
          .listSync()
          .whereType<File>()
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
      expect(files, isNotEmpty, reason: '자산 폴더가 비었다');

      final wrong = <String>[];
      for (final f in files) {
        final name = f.uri.pathSegments.last;
        if (!name.endsWith('.webp')) {
          wrong.add('$name — webp 가 아니다');
          continue;
        }
        final bytes = f.readAsBytesSync();
        if (bytes.length < 64) {
          wrong.add('$name — 너무 짧다(${bytes.length}B)');
          continue;
        }
        final head = String.fromCharCodes(bytes.sublist(0, 64));
        if (!head.startsWith('RIFF') || head.substring(8, 12) != 'WEBP') {
          wrong.add('$name — WebP 컨테이너가 아니다');
        } else if (!head.contains('ANIM')) {
          wrong.add('$name — ANIM 청크가 없다(정지 이미지)');
        }
      }
      expect(wrong, isEmpty, reason: wrong.join('\n'));
    });

    testWidgets('Flutter 코덱이 도해를 여러 프레임으로 읽고, 프레임이 서로 다르다',
        (tester) async {
      // 컨테이너에 `ANIM` 이 있는 것과 **Flutter 가 실제로 애니메이션으로 그리는
      // 것**은 다른 주장이다. `Image.asset` 이 쓰는 바로 그 코덱에 물어본다.
      //
      // ⚠ `runAsync` 로 감싸야 한다. 위젯 테스트의 가짜 시계 위에서는 엔진
      //    작업 큐가 돌지 않아 `toByteData` 의 Future 가 영영 안 끝난다(실측:
      //    테스트가 그대로 매달림).
      await tester.runAsync(() async {
        for (final name in ['h', 'pl_n', 'ph_g', 'vw_a', 'sy_ban']) {
          final bytes =
              File('assets/articulatory/$name.webp').readAsBytesSync();
          final codec = await ui.instantiateImageCodec(bytes);
          expect(codec.frameCount, greaterThan(1),
              reason: '$name.webp 이 한 프레임이면 도해가 안 움직인다');

          // 프레임 수만으로는 부족하다 — 같은 그림 38장이어도 통과한다.
          // 첫 프레임과 중간 프레임을 재 **움직임이 있는지**까지 본다.
          final first = await _rgba(codec);
          for (var i = 1; i < codec.frameCount ~/ 2; i++) {
            await codec.getNextFrame();
          }
          final middle = await _rgba(codec);
          expect(first.length, middle.length);
          var diff = 0;
          for (var i = 0; i < first.length; i += 4) {
            if (first[i] != middle[i] ||
                first[i + 1] != middle[i + 1] ||
                first[i + 2] != middle[i + 2]) {
              diff++;
            }
          }
          expect(diff / (first.length / 4), greaterThan(0.01),
              reason: '$name.webp 의 프레임이 서로 같다 — 정지 그림이나 다름없다');
          codec.dispose();
        }
      });
    });
  });
}

/// 코덱의 다음 프레임을 RGBA 바이트로 꺼낸다.
Future<Uint8List> _rgba(ui.Codec codec) async {
  final frame = await codec.getNextFrame();
  final data =
      await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
  frame.image.dispose();
  return data!.buffer.asUint8List();
}
