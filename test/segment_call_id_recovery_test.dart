// 구간 `call_id` 되짚기 — 「비버가 앞 대화를 잊는다」의 뿌리.
//
// 5분 경계에서는 **클라가 먼저 소켓을 닫아** `call_ended` 가 오지 않는다. 그래서
// `state.callId` 가 null 이고, 그대로 다음 구간을 열면 `continues_call_id` 가
// 필드째 빠져 서버는 이어가기인 줄 모른다 — 화면상 통화는 멀쩡히 이어지는데
// 비버만 처음부터 다시 인사한다(사장님 실기기 2026-08-24).
//
// 이 파일이 지키는 것은 **어느 행을 그 구간으로 볼 것인가**다. 여기서 틀리면
// 못 찾는 것보다 나쁠 수 있다 — 엉뚱한 통화를 요약해 넣게 되기 때문이다.
//
// 플랜: docs/2026-08-24_0324_send-continues-call-id-on-segment-resume-plan.md

import 'package:beavertalk/features/normalcall/domain/segment_call_id_recovery.dart';
import 'package:flutter_test/flutter_test.dart';

/// 재시도 간격을 0 으로 둔다 — 정책을 재는 테스트에서 실제로 기다릴 이유가 없다.
const _fast = SegmentCallIdRecovery(gap: Duration.zero);

void main() {
  group('기준값보다 큰 id 를 찾는다', () {
    test('이미 새 행이 있으면 그걸 돌려준다', () async {
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async => 42,
      );
      expect(got, 42);
    });

    test('서버가 행을 늦게 마감해도 재시도로 잡는다', () async {
      // 소켓을 닫은 직후엔 아직 기준값 그대로일 수 있다. 그래서 한 번 묻고 포기하면 안 된다.
      var calls = 0;
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async => ++calls < 3 ? 41 : 42,
      );
      expect(got, 42);
      expect(calls, 3);
    });

    test('일시적 실패를 삼키고 계속 묻는다', () async {
      var calls = 0;
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async {
          if (++calls == 1) throw Exception('네트워크');
          return 42;
        },
      );
      expect(got, 42);
    });
  });

  group('기준값 이하는 그 구간이 아니다', () {
    test('끝내 새 행이 안 생기면 null — 지난 통화를 집지 않는다', () async {
      // ⛔ 여기서 41 을 돌려주면 **직전 통화를 요약해 넣는다.** 맥락이 없는 것보다
      //    엉뚱한 맥락이 들어가는 쪽이 나쁘다. 못 찾으면 못 찾은 것으로 둔다.
      var calls = 0;
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async {
          calls++;
          return 41;
        },
      );
      expect(got, isNull);
      expect(calls, 5, reason: '기본 5회를 다 써 본 뒤에 포기한다');
    });

    test('통화 목록이 비어 있으면 null', () async {
      final got = await _fast.run(
        baseline: null,
        latestCallId: () async => null,
      );
      expect(got, isNull);
    });
  });

  group('기준값을 못 잡았을 때', () {
    test('최신 id 를 그대로 믿는다 — 막으면 영영 못 이어간다', () async {
      // 기준값 캡처가 실패하는 경우가 있다(`_captureBaselineCallId` 의 catch).
      // 그때도 이어갈 수 있어야 한다. 대신 직전 통화를 집을 위험이 있다는 건
      // 구현 주석에 남겨 뒀다.
      final got = await _fast.run(
        baseline: null,
        latestCallId: () async => 7,
      );
      expect(got, 7);
    });
  });

  group('중간에 통화가 끝나면 그만둔다', () {
    test('취소 신호가 서 있으면 서버에 묻지도 않는다', () async {
      var calls = 0;
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async {
          calls++;
          return 42;
        },
        cancelled: () => true,
      );
      expect(got, isNull);
      expect(calls, 0, reason: '끊긴 통화를 위해 서버를 두드릴 이유가 없다');
    });

    test('도중에 끊기면 남은 재시도를 멈춘다', () async {
      var calls = 0;
      final got = await _fast.run(
        baseline: 41,
        latestCallId: () async {
          calls++;
          return 41; // 계속 못 찾는 상태
        },
        cancelled: () => calls >= 2,
      );
      expect(got, isNull);
      expect(calls, 2, reason: '5회를 다 돌지 않고 멈춘다');
    });
  });
}
