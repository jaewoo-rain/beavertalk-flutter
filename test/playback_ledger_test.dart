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

  // ⭐ 15분 단일 세션(2026-10-04) — 조각 분할이 없으면 원장이 15분을 **한 번에** 버텨야
  //   한다. 지금까지는 5분마다 reset 이 걸려 누적이 가려졌다. 플러그인 없이 잴 수 있는
  //   유일한 실제 누적 위험이라 여기서 본다(재생 엔진 자체는 실기기 몫).
  group('15분 단일 세션 — 원장이 15분을 한 번에 버티나', () {
    test('15분치를 넣어도 서버 누계와 재생량이 정확하다', () {
      final l = PlaybackLedger();
      // 40ms 푸시 루프 × 15분 = 22,500회. 출처를 번갈아 세그먼트를 최대로 만든다.
      const pushes = 15 * 60 * 1000 ~/ 40;
      const serverFramesPerPush = 24000 * 40 ~/ 1000; // 40ms @24kHz
      for (var i = 0; i < pushes; i++) {
        l.recordFeed(frames: serverFramesPerPush, server: true);
        l.recordFeed(frames: 10, server: false);
      }

      expect(l.fedServerFrames, pushes * serverFramesPerPush,
          reason: '가지치기가 누계를 건드리면 barge-in 위치가 통째로 틀어진다');
      expect(l.playedServerFrames(0), pushes * serverFramesPerPush);
    });

    test('⭐ 15분 끝에서도 꼬리 계산이 정확하다 — 가지치기가 꼬리를 먹지 않았다', () {
      final l = PlaybackLedger();
      const pushes = 15 * 60 * 1000 ~/ 40;
      for (var i = 0; i < pushes; i++) {
        l.recordFeed(frames: 960, server: true);
        l.recordFeed(frames: 10, server: false);
      }
      // 엔진 잔량 2.5초(최대 깊이)가 남은 상태 — 보관 한도(5초) 안이라 정확해야 한다.
      const remaining = 24000 * 25 ~/ 10;
      final played = l.playedServerFrames(remaining);
      expect(played, lessThan(l.fedServerFrames));
      expect(l.fedServerFrames - played, lessThanOrEqualTo(remaining),
          reason: '잔량보다 많이 빼면 음수 재생량이 되고, 적게 빼면 안 들은 것을 들었다고 센다');
    });
  });
}
