import 'dart:typed_data';

import 'package:beavertalk/features/review/data/wav_writer.dart';
import 'package:flutter_test/flutter_test.dart';

/// 채점 최소 녹음 길이 — 0.3초(PCM16 · 16kHz · 모노 = 9,600바이트).
///
/// QA F011(09-26): 취약 발음 평가가 빈 녹음만 걸러 0.1~0.3초 녹음도 유료 채점으로 보냈다.
/// 발음 학습과 같은 기준을 한 곳에서 쓴다.
void main() {
  test('0.3초 = 9,600바이트 경계', () {
    expect(kMinScorablePcmBytes, 9600);
    expect(isTooShortToScore(Uint8List(0)), isTrue);
    expect(isTooShortToScore(Uint8List(9599)), isTrue);
    expect(isTooShortToScore(Uint8List(9600)), isFalse);
  });
}
