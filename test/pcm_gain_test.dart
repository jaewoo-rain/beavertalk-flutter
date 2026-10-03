import 'dart:math' as math;
import 'dart:typed_data';

import 'package:beavertalk/features/normalcall/domain/pcm_gain.dart';
import 'package:flutter_test/flutter_test.dart';

/// 음량 측정 진입점이 쓰는 게인 + 리미터(A2 · 03_측정결과_Note20.md).
/// 측정값을 믿으려면 「디지털로는 정확히 N dB 가 들어갔다」가 먼저 참이어야 한다.
void main() {
  double rmsDb(Int16List s) {
    var acc = 0.0;
    for (final v in s) {
      acc += (v / 32768.0) * (v / 32768.0);
    }
    return 20 * math.log(math.sqrt(acc / s.length)) / math.ln10;
  }

  Int16List sine(double amp) => Int16List.fromList([
        for (var i = 0; i < 2400; i++)
          (amp * 32767 * math.sin(2 * math.pi * 440 * i / 24000)).round(),
      ]);

  test('1.0 이면 원본을 그대로 돌려준다(복사 없음)', () {
    final s = sine(0.3);
    expect(identical(applyPcmGain(s, 1.0), s), isTrue);
  });

  test('무릎 아래에서는 선형 — +6dB 가 RMS +6dB', () {
    final s = sine(0.2); // 피크 0.2 → +6dB 해도 0.4 < 0.8
    final out = applyPcmGain(s, dbToGain(6));
    expect(rmsDb(out) - rmsDb(s), closeTo(6.0, 0.05));
  });

  test('풀스케일을 넘기면 눌러 담고 넘치지 않는다', () {
    final out = applyPcmGain(sine(0.9), dbToGain(12));
    final peak = out.map((v) => v.abs()).reduce(math.max);
    // 음수 쪽 최솟값 −32768 의 절댓값이 32768 이다(정상 범위).
    expect(peak, lessThanOrEqualTo(32768));
    expect(peak, greaterThan(26000), reason: '무릎(0.8) 위로는 올라간다');
  });

  test('부호를 지킨다', () {
    final out = applyPcmGain(Int16List.fromList([-30000, 30000, -100, 100]), 2);
    expect(out[0], isNegative);
    expect(out[1], isPositive);
    expect(out[2], -200);
    expect(out[3], 200);
  });
  // PM-DEC-352: 통화 재생 게인은 4~6dB · 끄기 스위치 1곳. 범위를 벗어나면 압축감만 늘거나(>6)
  // 체감이 없다(<4) — 바꾸려면 이 시험과 근거 문서를 같이 고친다.
  test('통화 재생 게인 상수는 4~6dB 범위다', () {
    expect(kCallPlaybackGainDb, inInclusiveRange(4.0, 6.0));
  });
}
