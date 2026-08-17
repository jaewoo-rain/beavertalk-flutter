import 'package:beavertalk/features/normalcall/domain/entities/call_allowance.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 시간 정책 — 5분 구간, 무료 1구간 / 유료 3구간.
///
/// 여기서 굳히는 건 **숫자 자체**다. 시안 카피(`flBenefitCalls` = "Unlimited calls
/// with Pro · 15 minutes each")와 `SubscriptionTier.pro` 의 "15-minute sessions"
/// 가 같은 값을 말하고 있고, 이 테스트가 그 셋을 묶어 둔다.
void main() {
  group('구간 길이', () {
    test('플랜과 무관하게 5분이다', () {
      expect(CallAllowance.segment, const Duration(minutes: 5));
    });
  });

  group('구간 수', () {
    test('무료는 1구간(5분) — 연장이 없다', () {
      expect(CallAllowance.segmentsFor(paidAccess: false), 1);
      expect(CallAllowance.limitFor(paidAccess: false),
          const Duration(minutes: 5));
    });

    test('유료는 3구간(15분) — 5+5+5', () {
      expect(CallAllowance.segmentsFor(paidAccess: true), 3);
      expect(CallAllowance.limitFor(paidAccess: true),
          const Duration(minutes: 15));
    });
  });

  group('canExtend — 어디서 멈추나', () {
    test('무료는 첫 구간을 쓰는 순간 끝', () {
      expect(CallAllowance.canExtend(segmentsUsed: 0, paidAccess: false), isTrue,
          reason: '아직 첫 구간을 안 썼다');
      expect(
          CallAllowance.canExtend(segmentsUsed: 1, paidAccess: false), isFalse);
    });

    test('유료는 3구간째에 멈춘다', () {
      expect(CallAllowance.canExtend(segmentsUsed: 1, paidAccess: true), isTrue);
      expect(CallAllowance.canExtend(segmentsUsed: 2, paidAccess: true), isTrue);
      expect(CallAllowance.canExtend(segmentsUsed: 3, paidAccess: true), isFalse,
          reason: '15분을 다 썼다');
    });

    test('상한을 넘겨 들어와도 열어 주지 않는다', () {
      expect(
          CallAllowance.canExtend(segmentsUsed: 99, paidAccess: true), isFalse);
    });
  });

  group('접근권 판정 — grace/onHold 비대칭 (스펙 §6)', () {
    // ⛔ 이 그룹이 이 기능의 가장 비싼 오작동을 막는다. `state` 로 자유/유료를
    //    가르면 **결제 재시도 중인 회원의 통화가 5분에 잘리고 구독 유도 시트가 뜬다.**
    //    `grantsPaidAccess` 가 유일한 판정이어야 하는 이유다.
    test('grace(결제 재시도)는 접근권을 유지한다 → 15분', () {
      expect(SubscriptionState.grace.grantsPaidAccess, isTrue);
      expect(
        CallAllowance.limitFor(
            paidAccess: SubscriptionState.grace.grantsPaidAccess),
        const Duration(minutes: 15),
      );
    });

    test('ending(해지 예약)도 남은 기간 동안 접근권이 있다 → 15분', () {
      expect(SubscriptionState.ending.grantsPaidAccess, isTrue);
      expect(
        CallAllowance.limitFor(
            paidAccess: SubscriptionState.ending.grantsPaidAccess),
        const Duration(minutes: 15),
      );
    });

    test('onHold(결제 실패 정지)는 차단된다 → 5분', () {
      expect(SubscriptionState.onHold.grantsPaidAccess, isFalse);
      expect(
        CallAllowance.limitFor(
            paidAccess: SubscriptionState.onHold.grantsPaidAccess),
        const Duration(minutes: 5),
      );
    });

    test('trial 은 유료다 → 15분', () {
      expect(SubscriptionState.trial.grantsPaidAccess, isTrue);
    });

    test('free / expired 는 5분', () {
      for (final s in [SubscriptionState.free, SubscriptionState.expired]) {
        expect(s.grantsPaidAccess, isFalse, reason: '$s');
        expect(CallAllowance.limitFor(paidAccess: s.grantsPaidAccess),
            const Duration(minutes: 5));
      }
    });

    test('activeMax 도 지금은 Pro 와 같은 15분', () {
      // Max 전용 시안이 아직 없다. 나오면 [CallAllowance] 한 곳만 고치면 되고,
      // 이 기대값이 그때 바뀌어야 할 자리를 가리킨다.
      expect(SubscriptionState.activeMax.grantsPaidAccess, isTrue);
      expect(CallAllowance.limitFor(paidAccess: true),
          const Duration(minutes: 15));
    });
  });

  group('경계 산수 — 컨트롤러가 쓰는 식', () {
    // 컨트롤러는 `elapsedSec >= segment.inSeconds * (segmentsUsed + 1)` 로 잰다.
    // elapsedSec 는 구간을 건너서 **누적**된다(화면 시계가 총 통화 시간이라).
    int boundaryFor(int segmentsUsed) =>
        CallAllowance.segment.inSeconds * (segmentsUsed + 1);

    test('구간 경계는 300 / 600 / 900초다', () {
      expect(boundaryFor(0), 300);
      expect(boundaryFor(1), 600);
      expect(boundaryFor(2), 900);
    });

    test('299초에는 안 걸리고 300초에 걸린다', () {
      expect(299 >= boundaryFor(0), isFalse);
      expect(300 >= boundaryFor(0), isTrue);
    });
  });
}
