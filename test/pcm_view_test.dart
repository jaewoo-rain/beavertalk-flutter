import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';

/// ⛔ **오디오가 조용히 깨지는 자리**를 막는 회귀.
///
/// 버퍼를 재사용하려면 큰 배열의 **일부만** 넘겨야 한다. 그런데 예전 `feed` 는
/// `buffer.bytes.buffer.asUint8List()` 였고, 그건 뷰의 offset/length 를 **무시하고
/// backing buffer 전체**를 돌려준다.
///
/// 지금까지 안 깨진 건 호출부가 매번 정확한 크기로 새 배열을 만들었기 때문이다 —
/// 즉 **재사용을 시작하는 순간** 요청보다 긴 오디오가 나가서 소리가 깨진다.
/// 에러도 예외도 없이 깨지므로 테스트로만 잡힌다.
void main() {
  group('부분 뷰를 넘겨도 그 구간만 나간다', () {
    test('⛔ 큰 버퍼의 앞부분만 — 나머지가 따라 나가면 안 된다', () {
      final backing = Uint8List(100)..fillRange(0, 100, 0xAB);
      final view = PcmArrayInt16(bytes: ByteData.sublistView(backing, 0, 10));
      final out = FlutterPcmSound.pcmBytesOf(view);
      expect(out.length, 10, reason: '뷰 길이만큼만 나가야 한다');
      expect(out.every((b) => b == 0xAB), isTrue);
    });

    test('오프셋이 0 이 아닌 뷰도 그 구간이다', () {
      final backing = Uint8List.fromList(List.generate(20, (i) => i));
      final view = PcmArrayInt16(bytes: ByteData.sublistView(backing, 4, 10));
      final out = FlutterPcmSound.pcmBytesOf(view);
      expect(out, Uint8List.fromList([4, 5, 6, 7, 8, 9]));
    });

    test('정확한 크기 배열(종전 방식)도 그대로 동작한다 — 회귀 없음', () {
      final exact = Uint8List.fromList([1, 2, 3, 4]);
      final arr = PcmArrayInt16(bytes: exact.buffer.asByteData());
      expect(FlutterPcmSound.pcmBytesOf(arr), Uint8List.fromList([1, 2, 3, 4]));
    });

    test('무음 뷰는 전부 0 이다 — 재사용해도 내용이 안 바뀐다', () {
      final scratch = Uint8List(7200 * 2); // 300ms @24kHz
      for (final frames in [1, 100, 7200]) {
        final v = PcmArrayInt16(bytes: ByteData.sublistView(scratch, 0, frames * 2));
        final out = FlutterPcmSound.pcmBytesOf(v);
        expect(out.length, frames * 2);
        expect(out.every((b) => b == 0), isTrue);
      }
    });

    test('빈 배열은 빈 채로 나간다', () {
      expect(FlutterPcmSound.pcmBytesOf(PcmArrayInt16.empty()).length, 0);
    });
  });
}
