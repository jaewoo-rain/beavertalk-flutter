import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// 응답시간 계기 회귀 — **끝점이 「도착」이 아니라 「소리」여야 한다.**
///
/// ⛔ 앱에는 이미 `RESPONSE: user_turn_end → turn_start` 가 있는데 그건 **다른 자다.**
/// `turn_start` 는 오디오 첫 바이트보다 **먼저** 오는 제어 메시지라(서버 불변식 I2)
/// TTS 벤더·송출·지터 쿠션이 안 들어간다. 실측 대조(2026-08-14): 1,500ms vs 3,370ms.
/// 이 스위트는 **새 자가 그 함정에 다시 빠지지 않게** 고정한다.
void main() {
  const rate = 24000; // 재생 24kHz

  test('⭐ 엔진 잔량이 크면 응답시간도 커진다 — 도착 기준이면 이게 안 변한다', () {
    int at(int frames) => audibleResponseMs(
          userTurnEndAtMs: 1000,
          fedAtMs: 2000,
          preDepthFrames: frames,
          sampleRate: rate,
        );
    // 같은 시각에 도착했는데 엔진에 쌓인 양만 다르다.
    expect(at(0), 1000);
    expect(at(rate ~/ 4), 1250); // 250ms 치가 앞에 있다
    expect(at(rate), 2000); // 1초 치가 앞에 있다
    // ⛔ 이 세 값이 같아지면 끝점이 「도착」으로 되돌아간 것이다.
    expect(at(0) < at(rate ~/ 4), isTrue);
    expect(at(rate ~/ 4) < at(rate), isTrue);
  });

  test('쿠션 300ms 와 0ms 가 구분된다 — 그 차이가 이 계기의 존재 이유다', () {
    final withCushion = audibleResponseMs(
      userTurnEndAtMs: 0,
      fedAtMs: 500,
      preDepthFrames: rate * 300 ~/ 1000,
      sampleRate: rate,
    );
    final without = audibleResponseMs(
      userTurnEndAtMs: 0,
      fedAtMs: 500,
      preDepthFrames: 0,
      sampleRate: rate,
    );
    expect(withCushion - without, 300);
  });

  test('음수 잔량은 0 으로 본다 — 네이티브 보고가 튀어도 값이 뒤로 가면 안 된다', () {
    expect(
      audibleResponseMs(
          userTurnEndAtMs: 0,
          fedAtMs: 100,
          preDepthFrames: -5000,
          sampleRate: rate),
      100,
    );
  });

  test('sampleRate 0 이어도 안 터진다 — 계측이 통화를 죽이면 안 된다', () {
    expect(
      audibleResponseMs(
          userTurnEndAtMs: 0, fedAtMs: 100, preDepthFrames: 1000, sampleRate: 0),
      100,
    );
  });
}
