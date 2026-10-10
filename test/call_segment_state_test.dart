import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// 5분 구간 상태가 통화 수명주기에 제대로 얹혔는지.
void main() {
  group('CallPhase.isBusy — 통화를 붙들고 있는 상태', () {
    test('결정 대기 중도 통화 중이다', () {
      // ⛔ 이게 false 면 시트를 보고 있는 사이 **수신 전화가 끼어들어** 이어가던
      //    통화가 통째로 날아간다. 판정이 세 곳(push_bootstrap ·
      //    inbound_call_scheduler · incoming_call_coordinator)에 복붙돼 있던 걸
      //    한 자리로 모으면서 이 상태를 추가했다.
      expect(CallPhase.awaitingContinue.isBusy, isTrue);
    });

    test('진행 중인 상태들은 전부 통화 중이다', () {
      for (final p in [
        CallPhase.connecting,
        CallPhase.inCall,
        CallPhase.ending,
        CallPhase.awaitingContinue,
      ]) {
        expect(p.isBusy, isTrue, reason: '$p');
      }
    });

    test('끝났거나 시작 전인 상태는 통화 중이 아니다', () {
      for (final p in [CallPhase.idle, CallPhase.ended, CallPhase.error]) {
        expect(p.isBusy, isFalse, reason: '$p');
      }
    });

    test('모든 phase 가 판정을 갖는다', () {
      // switch 가 exhaustive 라 컴파일이 막아 주지만, 새 phase 가 늘 때
      // "일단 false" 로 밀어 넣는 걸 이 테스트가 눈에 띄게 한다.
      for (final p in CallPhase.values) {
        expect(() => p.isBusy, returnsNormally, reason: '$p');
      }
    });
  });

  group('CallState — 구간 필드', () {
    test('기본값은 0구간·무료다', () {
      const s = CallState();
      expect(s.segmentsUsed, 0);
      expect(s.paidCallTime, isFalse);
      expect(s.phase, CallPhase.idle);
    });

    test('copyWith 가 구간 필드를 흘리지 않는다', () {
      // ⛔ copyWith 가 이 둘을 빠뜨리면 **통화가 영원히 끝나지 않는다** — 구간 수가
      //    리셋되어 매 구간 5분이 새로 주어진다. 상태가 1초마다 갈리므로
      //    (경과 시계) 한 번만 새면 바로 드러난다.
      const s = CallState(
        phase: CallPhase.inCall,
        segmentsUsed: 2,
        paidCallTime: true,
        elapsedSec: 640,
      );
      final next = s.copyWith(elapsedSec: 641);
      expect(next.segmentsUsed, 2);
      expect(next.paidCallTime, isTrue);
      expect(next.elapsedSec, 641);
    });

    test('copyWith 로 구간을 올릴 수 있다', () {
      const s = CallState(phase: CallPhase.inCall, segmentsUsed: 1);
      expect(s.copyWith(segmentsUsed: 2).segmentsUsed, 2);
    });
  });
}
