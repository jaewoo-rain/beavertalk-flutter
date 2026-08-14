import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/playback_ledger.dart';

/// `played_server_bytes` 의 정확도가 이 클래스 하나에 걸려 있다.
///
/// 핵심 계약: **클라가 만든 무음 필러는 세지 않는다.** 필러는 턴 사이·프리버퍼 대기·
/// starve 구간에 전부 끼므로, 이걸 안 빼면 서버는 "사용자가 듣지도 않은 침묵"을
/// 들은 것으로 기록한다.
void main() {
  group('PlaybackLedger', () {
    test('잔량이 0이면 넣은 서버 프레임이 전부 재생된 것', () {
      final l = PlaybackLedger()..recordFeed(frames: 1000, server: true);
      expect(l.playedServerFrames(0), 1000);
    });

    test('잔량이 통째로 서버 오디오면 그만큼 덜 재생된 것', () {
      final l = PlaybackLedger()..recordFeed(frames: 1000, server: true);
      expect(l.playedServerFrames(400), 600);
    });

    test('꼬리가 필러면 서버 재생량은 줄지 않는다 — 이게 핵심', () {
      // 서버 오디오 1000 → 필러 500 (큐가 비어 무음을 먹인 상황)
      final l = PlaybackLedger()
        ..recordFeed(frames: 1000, server: true)
        ..recordFeed(frames: 500, server: false);

      // 엔진에 500 남았고 그건 전부 필러다 → 서버 오디오는 이미 다 나갔다.
      expect(l.playedServerFrames(500), 1000);
    });

    test('잔량이 필러를 지나 서버 오디오까지 걸치면 걸친 만큼만 뺀다', () {
      final l = PlaybackLedger()
        ..recordFeed(frames: 1000, server: true)
        ..recordFeed(frames: 500, server: false);

      // 잔량 800 = 필러 500 + 서버 300
      expect(l.playedServerFrames(800), 700);
    });

    test('필러가 중간에 낀 경우(starve 후 재개)도 정확히 가른다', () {
      final l = PlaybackLedger()
        ..recordFeed(frames: 300, server: true) // 첫 조각
        ..recordFeed(frames: 200, server: false) // 굶어서 무음
        ..recordFeed(frames: 700, server: true); // 재개

      expect(l.fedServerFrames, 1000);
      // 잔량 400 → 전부 마지막 서버 구간
      expect(l.playedServerFrames(400), 600);
      // 잔량 900 → 서버 700 + 필러 200 → 서버는 700만 걸린다
      expect(l.playedServerFrames(900), 300);
    });

    test('같은 출처 연속 피드는 합쳐진다 (10ms 푸시 루프에서 세그먼트 폭증 방지)', () {
      final l = PlaybackLedger();
      for (var i = 0; i < 1000; i++) {
        l.recordFeed(frames: 240, server: true);
      }
      expect(l.fedServerFrames, 240000);
      expect(l.playedServerFrames(0), 240000);
    });

    test('reset 은 턴 스코프를 새로 연다', () {
      final l = PlaybackLedger()..recordFeed(frames: 1000, server: true);
      l.reset();
      expect(l.fedServerFrames, 0);
      expect(l.playedServerFrames(0), 0);

      l.recordFeed(frames: 480, server: true);
      expect(l.playedServerFrames(80), 400);
    });

    test('잔량이 넣은 양보다 크게 들어와도 음수를 내지 않는다', () {
      final l = PlaybackLedger()..recordFeed(frames: 100, server: true);
      expect(l.playedServerFrames(999999), 0);
    });

    test('음수 잔량은 0으로 취급', () {
      final l = PlaybackLedger()..recordFeed(frames: 100, server: true);
      expect(l.playedServerFrames(-5), 100);
    });

    test('오래된 세그먼트를 잘라내도 누계는 유지된다 (긴 통화 누수 방지)', () {
      final l = PlaybackLedger();
      // 5초 보관 한도를 훌쩍 넘겨 60초치를 넣는다 (24kHz × 60s).
      for (var i = 0; i < 600; i++) {
        l.recordFeed(frames: 2400, server: true);
        l.recordFeed(frames: 10, server: false); // 출처를 번갈아 세그먼트를 만든다
      }
      expect(l.fedServerFrames, 600 * 2400);
      // 엔진 잔량은 늘 엔진 깊이(≈2.5초) 이하다 — 보관분(5초) 안에 들어온다.
      expect(l.playedServerFrames(0), 600 * 2400);
      expect(l.playedServerFrames(2400), 600 * 2400 - 2390);
    });
  });
}
