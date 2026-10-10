import 'dart:convert';

import '../../domain/entities/call_diag_event.dart';

/// 계측 배치를 서버로 내보내는 싱크 (2026-08-25).
///
/// ## ⛔ 오디오와 **같은 소켓**을 쓴다 — 위험은 CPU 가 아니라 순서다
/// 큰 텍스트 프레임 하나가 TCP 에서 앞자리를 잡으면 그 뒤 마이크 프레임(704B/22ms)이
/// 통째로 밀린다. 업링크 128kbps 실기기에서 4KB 프레임 = **250ms 마이크 공백** →
/// 서버 VAD 가 그 구멍을 본다. 그래서 규율 셋을 코드로 못 박는다:
///
/// - **R-a. 프레임 상한 [maxFrameBytes].** 최악 업링크에서도 125ms 안쪽.
/// - **R-b. 마이크가 닫혀 있을 때만 보낸다.** 비버가 말하는 동안 업링크는 완전히
///   비어 있다(컨트롤러 `if (_micGated) return;`) — 그 창에 보내면 **마이크 프레임을
///   단 하나도 밀지 않는다.** 예외는 둘: 버퍼가 찼을 때, 통화가 끝날 때.
/// - **R-c. 핫패스에서 인코딩 금지.** 직렬화는 이미 도는 5초 타이머에 얹는다.
///
/// ## ⚠ 실패는 삼킨다 (R5)
/// 소켓이 없거나 send 가 던지면 **버린다.** 재시도 큐를 만들지 마라 — 계측이 통화를
/// 죽이면 본말전도다. 버린 수는 `dropped` 로 서버에 실려 가 조용한 손실이 안 된다.
class CallDiagSink {
  CallDiagSink({
    required this.send,
    required this.micIsGated,
    this.level = 'summary',
    this.maxFrameBytes = 2048,
    // ⭐ 배치는 5초에 하나 나가므로 이 값이 곧 «계측이 덮는 통화 길이»다.
    //   ⛔ 40 이면 **200초에서 계측이 조용히 멈춘다.** 그런데 우리가 쫓는 증상
    //     (음성·영상 띄엄띄엄)은 1~2분부터 시작해 **후반으로 갈수록 심해진다** —
    //     문제가 가장 심한 구간이 통째로 안 남는다. 실제로 이번 조사에서 200초 이후
    //     `ping_ms`·`q` 를 서버에서 못 봐서 로그캣에 의존해야 했다.
    //   ⇒ 200 = 약 16분. 5분 통화를 끝까지 덮는다. 서버 `_DIAG_MAX_BATCHES` 와 같은 값이다
    //     (한쪽만 올리면 다른 쪽이 버린다 — 반드시 같이 움직여라).
    this.maxBatches = 200,
    this.minGapMs = 2000,
  });

  /// 서버로 프레임 1개를 보낸다. 실패하면 던져도 된다 — 여기서 삼킨다.
  final void Function(Map<String, Object?> frame) send;

  /// 지금 마이크가 닫혀 있나(= 비버 발화중 = 업링크가 비어 있는 창).
  final bool Function() micIsGated;

  /// 'off' | 'summary' | 'full'. **주인은 서버다** — `call_started.diag` 가 이긴다.
  String level;

  final int maxFrameBytes;
  final int maxBatches;
  final int minGapMs;

  final CallDiagBuffer buffer = CallDiagBuffer();

  int _seq = 0;
  int _lastFlushMs = 0;
  int _anchorEpochMs = 0;

  /// 지금까지 **보고한** 누적 손실. `dropped` 를 델타로 만드는 기준값이다.
  ///
  /// ⛔ 서버는 배치마다 `state.diag_dropped += dropped` 로 **더한다**
  ///   (`call_session._record_client_diag`). 여기서 누계를 실어 보내면 배치가 늘수록
  ///   손실 수가 제곱으로 부푼다 — 그러면 「손실이 많다」는 경고가 상시가 되고, 상시
  ///   경고는 진짜 손실을 덮는다.
  int _droppedReported = 0;

  /// 서버 시계 오프셋(ms). `pong.s` 로 잡는다. 0 이면 아직 못 잡은 것.
  int serverClockOffsetMs = 0;

  bool get enabled => level != 'off';
  int get batchesSent => _seq;

  /// 통화 시작 — 앵커를 잡는다. 이벤트의 `t` 는 이 시각 기준 상대 ms 다.
  void start(int anchorEpochMs) {
    _anchorEpochMs = anchorEpochMs;
    _seq = 0;
    _lastFlushMs = 0;
    _droppedReported = 0;
    buffer.clear();
  }

  /// 이벤트 적재. **핫패스에서 불린다.**
  ///
  /// ⛔ `level=='off'` 면 여기서 즉시 빠진다 — 서버가 껐는데 클라가 메모리를 쓰면 안 된다.
  void add(String name, {Map<String, Object?>? fields, int? atEpochMs}) {
    if (!enabled) return;
    // `summary` = 뼈대만. 턴·마커·언더런·타이밍·요약은 남고, 주기 롤업(`win`)과 영상
    // 내부 상태·보조 축은 빠진다([diagClassRank] 가 그 등급을 정한다).
    // ⛔ 이름만 두고 동작이 같으면 「레벨을 낮췄다」고 믿으면서 실제로는 그대로 보낸다 —
    //   반쯤 만든 스위치는 없는 것보다 나쁘다.
    if (level == 'summary' && diagClassRank(name) < 3) return;
    final now = atEpochMs ?? DateTime.now().millisecondsSinceEpoch;
    // ⚠ [start] 는 서버 `call_started` 에서 불린다. 그 전에 일어난 일(마이크 개방·
    //   첫 롤업)도 버려선 안 되므로 **첫 이벤트가 스스로 앵커를 잡는다.** 안 그러면
    //   `t` 가 에포크 원시값이 되어 로그에서 통화 시각과 대조가 안 된다.
    if (_anchorEpochMs == 0) _anchorEpochMs = now;
    buffer.add(name, now - _anchorEpochMs, fields);
  }

  /// 보낼 때가 됐나 — R-b 의 판정.
  ///
  /// `force` 는 통화 종료 전 마지막 flush 에만 쓴다.
  bool shouldFlush({bool force = false}) {
    if (!enabled || buffer.isEmpty) return false;
    if (_seq >= maxBatches) return false;
    if (force) return true;
    // 버퍼가 위험하게 찼으면 마이크 창을 못 기다린다(그때 통째로 잃는 게 더 나쁘다).
    if (buffer.pendingCount >= buffer.maxEvents ~/ 2) return true;
    if (!micIsGated()) return false; // ⭐ R-b — 비버가 말하는 동안만
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastFlushMs < minGapMs) return false;
    return true;
  }

  /// 배치 1개를 만들어 보낸다. 실패는 삼킨다.
  ///
  /// ⚠ 프레임이 [maxFrameBytes] 를 넘으면 **건수를 줄여 다시 만든다**(R-a).
  /// 잘라낸 이벤트는 버퍼에 남아 다음 배치로 간다 — 버리지 않는다.
  void flush({bool force = false}) {
    if (!shouldFlush(force: force)) return;

    var take = buffer.maxPerBatch;
    while (take > 0) {
      final events = buffer.take(take);
      if (events.isEmpty) return;
      // ⛔ **델타**다. 누계가 아니다 — 위 [_droppedReported] 주석 참고.
      final droppedDelta = buffer.dropped - _droppedReported;
      final frame = <String, Object?>{
        'type': 'client_diag',
        'seq': _seq + 1,
        'anchor_epoch_ms': _anchorEpochMs,
        'level': level,
        'dropped': droppedDelta,
        'events': events,
      };
      final bytes = utf8.encode(jsonEncode(frame)).length;
      if (bytes <= maxFrameBytes || take == 1) {
        try {
          send(frame);
          _seq++;
          _droppedReported = buffer.dropped;
          _lastFlushMs = DateTime.now().millisecondsSinceEpoch;
        } catch (_) {
          // ⛔ 재시도하지 않는다. 계측 실패가 통화에 번지면 안 된다(R5).
        }
        return;
      }
      // 너무 컸다 — 돌려놓고 절반으로 다시 시도.
      buffer.putBack(events);
      take = take ~/ 2;
    }
  }

  /// 통화 종료 — 남은 것을 모두 밀어낸다(마이크 창을 기다리지 않는다).
  void finish() {
    if (!enabled) return;
    var guard = 0;
    while (!buffer.isEmpty && _seq < maxBatches && guard++ < maxBatches) {
      flush(force: true);
    }
  }
}
