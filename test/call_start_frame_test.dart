// `start` 프레임 — 서버가 통화를 어떻게 열지 정하는 필드들.
//
// 이 프레임의 결함은 지금까지 전부 **"필드가 조용히 빠졌다"** 였다. 서버는 못 받은
// 필드를 에러로 알리지 않고 폴백하므로, 화면상 통화는 멀쩡히 이어지고 증상만 엉뚱한
// 데서 튀어나온다 — 그래서 실기기로도 안 보였다:
//
//   - `continues_call_id` 미전송 → 비버가 앞 구간을 잊는다 (2026-08-24)
//   - `inbound_call_id` 미전송   → 이어간 순간 **상대가 바뀐다** (2026-08-31)
//
// 플랜: docs/2026-08-31_0516_carry-inbound-call-id-across-segments-plan.md

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// 실제 호출부와 같은 규격(`_micSampleRate` / `_micNumChannels`).
Map<String, dynamic> _frame({
  String? inboundCallId,
  String? continuesCallId,
}) =>
    buildStartFrame(
      aec: const {'mode': 'unknown'},
      sampleRate: 16000,
      numChannels: 1,
      inboundCallId: inboundCallId,
      continuesCallId: continuesCallId,
    );

void main() {
  group('buildStartFrame — 항상 나가는 것', () {
    test('타입과 마이크 규격은 빠지지 않는다', () {
      final f = _frame();

      expect(f['type'], 'start');
      expect(f['aec'], const {'mode': 'unknown'});
      // ⛔ 예전엔 안 보냈고 서버가 기본값 16000 을 가정했다 — 우리 레코더와
      //    우연히 맞았을 뿐이다. 빠지면 조용히 이상한 목소리가 된다.
      expect(f['sample_rate'], 16000);
      expect(f['num_channels'], 1);
    });
  });

  group('inbound_call_id — 통화 상대를 정하는 값', () {
    test('수신통화면 실린다', () {
      final f = _frame(inboundCallId: 'uuid-alarm-1');

      expect(f['inbound_call_id'], 'uuid-alarm-1');
    });

    test('⭐ 이어가는 구간에도 실린다 — 빠지면 상대가 바뀐다', () {
      // 사장님 실기기(2026-08-31): 알람 캐릭터 BABA 와 5분 통화 → 「Keep talking」
      // → BIBI 로 바뀌었다. 서버 `resolve_call_character` 는 이 값으로만 알람을
      // 되짚는다 — `continues_call_id` 로는 캐릭터를 못 고른다. 그래서 이어가는
      // 구간이 이 필드 없이 열리면 member.character_id(대표 캐릭터)로 떨어진다.
      final f = _frame(
        inboundCallId: 'uuid-alarm-1',
        continuesCallId: '1182',
      );

      expect(f['inbound_call_id'], 'uuid-alarm-1',
          reason: '이어가도 같은 알람의 통화다');
      expect(f['continues_call_id'], '1182');
    });

    test('홈에서 건 전화는 필드 자체가 안 나간다', () {
      // ⚠ `null` 이 실리는 것과 **필드가 없는 것**은 다르다. 서버는 값의 유무로
      //    수신통화 여부를 가른다.
      final f = _frame();

      expect(f.containsKey('inbound_call_id'), isFalse);
    });
  });

  group('continues_call_id — 앞 구간의 기억', () {
    test('이어가는 구간에 실린다', () {
      final f = _frame(continuesCallId: '1182');

      expect(f['continues_call_id'], '1182');
    });

    test('첫 구간에는 필드 자체가 안 나간다', () {
      final f = _frame();

      expect(f.containsKey('continues_call_id'), isFalse);
    });
  });
}
