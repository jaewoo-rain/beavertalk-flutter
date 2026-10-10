import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/data/datasources/call_diag_sink.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_diag_event.dart';

/// 통화 계측 싱크 회귀 (2026-08-25).
///
/// ⛔ 여기서 지키는 계약은 하나다: **계측이 통화를 해치지 않는다.**
///   프레임이 마이크를 밀지 않고, 손실은 조용하지 않고, 실패는 번지지 않는다.
void main() {
  /// 마이크가 닫혀 있고(= 보낼 수 있는 창) 프레임을 받아 두는 싱크.
  ({CallDiagSink sink, List<Map<String, Object?>> sent}) make({
    bool gated = true,
    String level = 'full',
    int maxFrameBytes = 2048,
  }) {
    final sent = <Map<String, Object?>>[];
    final sink = CallDiagSink(
      send: sent.add,
      micIsGated: () => gated,
      level: level,
      maxFrameBytes: maxFrameBytes,
      minGapMs: 0,
    );
    sink.start(1000);
    return (sink: sink, sent: sent);
  }

  test('마이크가 열려 있는 동안에는 보내지 않는다', () {
    // ⛔ 이게 이 파일에서 가장 중요한 줄이다. 업링크 128kbps 실기기에서 큰 텍스트
    //   프레임 하나가 앞자리를 잡으면 그 뒤 마이크 프레임이 통째로 밀린다 —
    //   서버 VAD 가 그 구멍을 「말이 끝났다」로 읽는다. 계측이 지연을 만드는 것이다.
    final r = make(gated: false);
    r.sink.add('x');
    r.sink.flush();
    expect(r.sent, isEmpty, reason: '마이크가 열린 창에 프레임을 밀어 넣었다');
  });

  test('마이크가 닫히면 보낸다', () {
    final r = make();
    r.sink.add('turn_start', fields: {'turn': 'b1'});
    r.sink.flush();
    expect(r.sent, hasLength(1));
    expect(r.sent.single['type'], 'client_diag');
    expect((r.sent.single['events']! as List).single, containsPair('e', 'turn_start'));
  });

  test('서버가 off 로 두면 버퍼조차 채우지 않는다', () {
    // ⛔ 「보내지만 않는다」로는 부족하다. 계측이 문제를 일으켰을 때 서버의 스위치가
    //   메모리까지 끊어야 진짜 탈출구다.
    final r = make(level: 'off');
    for (var i = 0; i < 100; i++) {
      r.sink.add('x');
    }
    expect(r.sink.buffer.pendingCount, 0);
    r.sink.flush(force: true);
    expect(r.sent, isEmpty);
  });

  test('프레임이 상한을 넘으면 건수를 줄이되 이벤트를 버리지 않는다', () {
    // ⚠ 상한을 「버리는 것」으로 구현하면, 이벤트가 몰린 구간 — 즉 제일 보고 싶은
    //   구간 — 이 정확히 사라진다.
    final r = make(maxFrameBytes: 400);
    for (var i = 0; i < 40; i++) {
      r.sink.add('turn_done', fields: {'i': i, 'pad': 'abcdefghij'});
    }
    final produced = r.sink.buffer.produced;
    var guard = 0;
    while (!r.sink.buffer.isEmpty && guard++ < 50) {
      r.sink.flush();
    }
    for (final f in r.sent) {
      expect(utf8.encode(jsonEncode(f)).length, lessThanOrEqualTo(400),
          reason: '2KB(테스트 400B) 상한을 넘긴 프레임이 나갔다');
    }
    final total = r.sent.fold<int>(0, (n, f) => n + (f['events']! as List).length);
    expect(total, produced, reason: '상한 때문에 이벤트가 조용히 사라졌다');
  });

  test('dropped 는 누계가 아니라 델타로 나간다', () {
    // ⛔ 서버는 배치마다 `state.diag_dropped += dropped` 로 **더한다**. 누계를 실으면
    //   손실 수가 부풀어, 「손실 많음」 경고가 상시가 되고 진짜 손실을 덮는다.
    final sent = <Map<String, Object?>>[];
    final sink = CallDiagSink(send: sent.add, micIsGated: () => true, minGapMs: 0);
    sink.start(0);
    sink.buffer.dropped = 5;
    sink.add('a');
    sink.flush();
    sink.buffer.dropped = 8; // 3 건 더 버렸다
    sink.add('b');
    sink.flush();
    expect(sent.map((f) => f['dropped']), [5, 3]);
    expect(sent.fold<int>(0, (n, f) => n + (f['dropped']! as int)), 8,
        reason: '서버가 더한 합이 실제 손실과 달라진다');
  });

  test('전송이 던져도 통화로 번지지 않는다', () {
    // R5. 계측 실패가 통화를 죽이면 본말전도다.
    final sink = CallDiagSink(
      send: (_) => throw StateError('소켓이 닫혔다'),
      micIsGated: () => true,
      minGapMs: 0,
    );
    sink.start(0);
    sink.add('x');
    expect(() => sink.flush(), returnsNormally);
  });

  test('상한을 넘으면 굵은 사건이 아니라 롤업이 먼저 죽는다', () {
    // ⛔ 「오래된 것부터」(링버퍼)로 하면 통화 **초반**이 사라진다. 우리가 제일 자주 보는
    //   것이 「붙자마자 이상하다」라, 초반이 가장 값지다.
    final b = CallDiagBuffer(maxEvents: 3);
    b.add('win', 1);
    b.add('turn_done', 2);
    b.add('win', 3);
    b.add('mk_rx', 4); // 자리가 없다 → win 하나가 밀려난다
    final names = b.take(10).map((e) => e['e']).toList();
    expect(names, contains('turn_done'));
    expect(names, contains('mk_rx'));
    expect(b.dropped, 1);
  });

  test('summary 는 이름만이 아니라 실제로 줄인다', () {
    // ⛔ 반쯤 만든 스위치는 없는 것보다 나쁘다 — 「레벨을 낮췄다」고 믿으면서 그대로
    //   보낸다. 뼈대(턴·마커·언더런)는 남고 롤업·영상 내부는 빠지는 것이 계약이다.
    final r = make(level: 'summary');
    r.sink.add('win');
    r.sink.add('vid_emo');
    r.sink.add('voice_on');
    r.sink.add('turn_done');
    r.sink.add('mk_rx');
    r.sink.flush();
    final names = (r.sent.single['events']! as List)
        .map((e) => (e as Map)['e'])
        .toList();
    expect(names, ['turn_done', 'mk_rx']);
  });

  test('앵커가 없으면 첫 이벤트가 스스로 잡는다', () {
    // start() 는 서버 `call_started` 에서 불린다. 그 전에 일어난 일도 통화 시각과
    // 대조가 돼야 한다 — 안 그러면 `t` 가 에포크 원시값이 되어 읽을 수 없다.
    final sent = <Map<String, Object?>>[];
    final sink = CallDiagSink(send: sent.add, micIsGated: () => true, minGapMs: 0);
    sink.add('early');
    sink.flush();
    final t = (sent.single['events']! as List).single as Map;
    expect(t['t'], lessThan(1000));
  });
}
