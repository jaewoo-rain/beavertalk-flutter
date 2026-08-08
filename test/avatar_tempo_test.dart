// 발화 템포 판정 회귀 테스트.
//
// ⛔ 합성 파형만으로 시험하지 마라. 음절 사이가 0 까지 떨어지는 파형은 절대 문턱
//    구현도 통과시킨다. 실기기에서 터진 뒤에 `_realEnv` 를 넣었다.
//
// 문턱값(2.3 · 3.2회/초)은 **클립 실측값에서 고른 값**이다 — slow 1.97 · normal 2.63 ·
// fast 3.79. 근거를 읽지 않고 바꾸면 실기기에서 엉뚱한 클립이 걸린다.
// 골 문턱 0.45 도 마찬가지다 — 실측 파형으로 훑어 고른 값이고, 0.35 면 얕은 골을
// 간발로 놓쳐 한 턴에 3개만 세어진다.

import 'package:beavertalk/features/normalcall/presentation/avatar_tempo.dart';
import 'package:flutter_test/flutter_test.dart';

/// 초당 [rate] 회로 오르내리는 엔벨로프를 [seconds] 초 동안 흘린다.
/// [noise] 를 켜면 봉우리마다 잔물결을 얹어 잡음 내성을 본다.
double? _measure(double rate, {double seconds = 3.0, bool noise = false}) {
  final m = TempoMeter();
  var t = DateTime(2026, 8, 5);
  const stepMs = 20;
  final steps = (seconds * 1000 / stepMs).round();
  final periodSteps = (1000 / rate / stepMs);
  for (var i = 0; i < steps; i++) {
    final phase = (i % periodSteps) / periodSteps;
    // 음절 = 앞쪽 40%만 소리가 있고 나머지는 잦아든다.
    var v = phase < 0.4 ? 0.05 : 0.001;
    if (noise && phase < 0.4) {
      // 봉우리 안의 **잔물결**. 깊이는 실측 파형에서 가져왔다 —
      // `_realEnv` 의 한 음절 안이 1.0 → 0.785 → 0.827 로 흔들린다(봉우리의 78%).
      // ⛔ 더 깊게(45% 미만) 파는 것은 잔물결이 아니라 **새 음절**이고, 그렇게 세는
      //    것이 설계 의도다. 이 테스트를 통과시키려고 골 문턱을 낮추지 마라.
      v = (i % 2 == 0) ? 0.05 : 0.039;
    }
    m.feed(v, t);
    t = t.add(const Duration(milliseconds: stepMs));
  }
  return m.rate;
}


/// 실통화에서 뽑은 엔벨로프 한 턴치(25ms 간격) — `lib/avatar_lab_main.dart` 의 `_env` 와 같다.
/// ★이 표본이 이 파일의 핵심이다. 합성 파형(음절 사이 0까지 하강)만으로 시험했더니
///  절대 문턱 구현이 테스트를 통과했고, 실기기에서야 한 턴에 2음절만 잡혀 판정 불능이었다.
const _realEnv = <double>[
  0.0, 0.0, 0.0, 0.0, 0.0, 0.149, 0.573, 0.843, 0.989, 0.974, 0.785, 0.827,
  1.0, 1.0, 1.0, 0.916, 0.934, 0.752, 0.453, 0.328, 0.836, 0.904, 0.981, 0.83,
  0.851, 0.876, 0.794, 0.615, 0.328, 0.265, 0.125, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.212, 0.389, 0.93, 1.0, 0.999, 0.814, 0.853, 0.778, 0.865, 0.912,
  0.781, 0.747, 0.3, 0.34, 0.511, 0.345, 0.826, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
  0.914, 0.632, 0.389, 0.7, 1.0, 0.807, 0.767, 0.6, 0.659, 0.293, 0.239,
  0.568, 0.827, 0.913, 1.0, 0.885, 0.738, 0.569, 0.411, 0.398, 0.35, 0.155,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
];

void _feedReal(TempoMeter m, {double speed = 1.0}) {
  var t = DateTime(2026, 8, 5);
  var pos = 0.0;
  while (pos < _realEnv.length) {
    m.feed(_realEnv[pos.floor()], t);
    t = t.add(const Duration(milliseconds: 25));
    pos += speed;
  }
}

void main() {
  group('TempoMeter', () {
    test('표본이 모자라면 판단하지 않는다', () {
      // 음절 3개 = minSyllables(4) 미만.
      expect(_measure(1.0, seconds: 3.0), isNull);
    });

    test('느린 말 → slow', () {
      final r = _measure(2.0);
      expect(r, isNotNull);
      expect(TempoMeter.tempoFor(r!), kTalkSlow);
    });

    test('보통 말 → normal', () {
      final r = _measure(2.7);
      expect(r, isNotNull);
      expect(TempoMeter.tempoFor(r!), kTalkNormal);
    });

    test('빠른 말 → fast', () {
      final r = _measure(4.0);
      expect(r, isNotNull);
      expect(TempoMeter.tempoFor(r!), kTalkFast);
    });

    test('측정값이 실제 음절률과 20% 안에서 맞는다', () {
      for (final want in [2.0, 2.7, 4.0, 5.0]) {
        final got = _measure(want);
        expect(got, isNotNull, reason: '$want회/초에서 측정 실패');
        expect((got! - want).abs() / want, lessThan(0.2),
            reason: '$want회/초 → 측정 $got');
      }
    });

    test('봉우리 안의 잔물결을 한 음절로 센다 (히스테리시스)', () {
      final clean = _measure(3.0)!;
      final noisy = _measure(3.0, noise: true)!;
      // 잡음이 있어도 세는 개수가 같아야 한다. 문턱이 하나면 두 배로 세어진다.
      expect((noisy - clean).abs(), lessThan(0.3),
          reason: '잡음 $noisy vs 깨끗 $clean');
    });


    test('실통화 엔벨로프에서 음절이 잡힌다 (실기기 회귀)', () {
      // 절대 문턱(0.012/0.005) 구현은 여기서 2음절만 세어 rate 가 null 이었다.
      final m = TempoMeter();
      _feedReal(m);
      expect(m.rate, isNotNull, reason: '실측 파형에서 판정 불능 - 회귀');
      expect(m.rate!, greaterThan(1.5));
      expect(m.rate!, lessThan(8.0));
    });

    test('재생 속도를 올리면 측정값이 단조 증가한다', () {
      // 음절 **개수**는 6~7 로 거의 일정하고 재생 시간이 줄어 초당값이 오른다.
      // 개수만 보면 안 되는 이유다.
      double? at(double speed) {
        final m = TempoMeter();
        _feedReal(m, speed: speed);
        return m.rate;
      }
      final r = [0.6, 1.0, 1.6].map(at).toList();
      for (final v in r) {
        expect(v, isNotNull, reason: '측정 실패 - $r');
      }
      expect(r[1]!, greaterThan(r[0]!));
      expect(r[2]!, greaterThan(r[1]!));
    });

    test('실측 파형이 세 템포를 전부 태운다', () {
      int tempoAt(double speed) {
        final m = TempoMeter();
        _feedReal(m, speed: speed);
        return TempoMeter.tempoFor(m.rate!);
      }
      expect(tempoAt(0.6), kTalkSlow);
      expect(tempoAt(1.0), kTalkNormal); // 실통화 속도 = normal
      expect(tempoAt(1.6), kTalkFast);
    });

    test('발화 뒤 침묵이 측정값을 깎지 않는다 (실기기 회귀)', () {
      // 판정은 발화 종료 180ms 뒤에 일어난다. `개수/(지금-첫음절)` 로 재면 침묵이
      // 분모를 늘려 값이 내려가고, 실제보다 느린 클립이 걸린다(실기기 2.47 → 1.7).
      final m = TempoMeter();
      _feedReal(m);
      final atEnd = m.rate!;
      var t = DateTime(2026, 8, 5).add(
          Duration(milliseconds: (_realEnv.length * 25) + 25));
      for (var i = 0; i < 20; i++) {
        m.feed(0.0, t);
        t = t.add(const Duration(milliseconds: 25));
      }
      expect(m.rate!, closeTo(atEnd, 0.01),
          reason: '침묵 뒤 ${m.rate} vs 종료 시점 $atEnd');
    });

    test('경계값은 클립 실측값 사이에 있다', () {
      // slow 1.97 · normal 2.63 · fast 3.79 — 각 클립이 자기 구간에 떨어져야 한다.
      expect(TempoMeter.tempoFor(1.97), kTalkSlow);
      expect(TempoMeter.tempoFor(2.63), kTalkNormal);
      expect(TempoMeter.tempoFor(3.79), kTalkFast);
    });

    test('reset 하면 다시 표본 부족 상태가 된다', () {
      final m = TempoMeter();
      var t = DateTime(2026, 8, 5);
      for (var i = 0; i < 40; i++) {
        m.feed(i % 4 == 0 ? 0.05 : 0.001, t);
        t = t.add(const Duration(milliseconds: 50));
      }
      expect(m.rate, isNotNull);
      m.reset();
      expect(m.rate, isNull);
    });
  });
}
