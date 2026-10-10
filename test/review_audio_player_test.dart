// 10-06 실기기 R9: 자주 틀린 소리 「잘 들어 보세요」에서 멈춤.
// flutter_sound iOS 의 원격 URL 분기가 다운로드 실패 때 아무 신호도 안 내서
// `startPlayer` 가 영원히 안 끝났다. playUrl 은 이제 직접 받아서, 실패를 곧바로 던진다.
import 'dart:typed_data';

import 'package:beavertalk/features/review/data/audio_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('codecOf — 앞 바이트로 형식을 가른다', () {
    test('RIFF 머리는 wav', () {
      final b = Uint8List.fromList([0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0]);
      expect(ReviewAudioPlayer.codecOf(b), Codec.pcm16WAV);
    });

    test('ID3 태그는 mp3', () {
      final b = Uint8List.fromList([0x49, 0x44, 0x33, 0x04, 0]);
      expect(ReviewAudioPlayer.codecOf(b), Codec.mp3);
    });

    test('MPEG 프레임 동기는 mp3', () {
      final b = Uint8List.fromList([0xFF, 0xFB, 0x90, 0x64]);
      expect(ReviewAudioPlayer.codecOf(b), Codec.mp3);
    });

    test('스토리지 404 의 XML 본문은 모른다(null)', () {
      final xml = Uint8List.fromList('<?xml version'.codeUnits);
      expect(ReviewAudioPlayer.codecOf(xml), isNull);
    });

    test('너무 짧으면 모른다(null)', () {
      expect(ReviewAudioPlayer.codecOf(Uint8List(2)), isNull);
    });
  });

  group('playUrl — 실패는 곧바로 예외다(멈추지 않는다)', () {
    test('다운로드 실패를 그대로 던진다', () async {
      final player = ReviewAudioPlayer(
        download: (_) async => throw Exception('404'),
      );
      await expectLater(player.playUrl('https://x/missing.mp3'), throwsException);
    });

    test('mp3·wav 가 아니면 FormatException', () async {
      final player = ReviewAudioPlayer(
        download: (_) async => Uint8List.fromList('<?xml version'.codeUnits),
      );
      await expectLater(
        player.playUrl('https://x/not-audio'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
