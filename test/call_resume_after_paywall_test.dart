// 통화 중 결제 → 통화 복귀 (`NormalCallController.resumeAfterPaywall`).
//
// 5분 시트의 「Subscribe and keep talking」 은 통화를 끊지 않고 결제 화면을 통화 화면
// **위에** 얹는다. 결제 성공·취소·실패·뒤로가기가 전부 같은 자리로 돌아오고, 이어갈지
// 끝낼지는 **구독 상태를 다시 읽어** 정한다. 그 판정이 이 파일의 대상이다.
//
// 여기서 새면 증상이 둘로 갈린다:
//   - 유료인데 안 이어짐 → 결제한 사람이 5분에 잘린다(돈을 냈는데 통화가 끝난다)
//   - 무료인데 이어짐   → 무료 회원이 상한 없이 통화한다
//
// 플랜: docs/2026-08-21_2228_resume-call-after-mid-call-subscribe-plan.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_allowance.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';

/// 서버가 돌려줄 구독 상태를 고정한다. [fetchCount] 로 **다시 읽었는지**를 본다.
class _FakeSubscriptionRepository implements SubscriptionRepository {
  _FakeSubscriptionRepository(this.status);

  final SubscriptionStatus status;
  int fetchCount = 0;

  @override
  Future<SubscriptionStatus?> fetchStatus() async {
    fetchCount++;
    return status;
  }

  @override
  Future<List<Subscription>> listSubscriptions() async => const [];

  @override
  Future<Subscription> cancel(int subscribeId) => throw UnimplementedError();
}

/// 어느 길로 갔는지의 기록. **Notifier 밖에 둔다** — 세는 값을 컨트롤러의 공개
/// 필드로 달면 `avoid_public_notifier_properties` 에 걸린다(Notifier 의 공개 API 는
/// `state` 하나여야 한다). 테스트 더블이라고 예외를 두는 대신 기록을 분리한다.
class _CallLog {
  int hangUps = 0;
  int continues = 0;
}

/// 소켓·오디오를 타지 않고 **어느 길로 갔는지**만 [_CallLog] 에 적는다.
///
/// 진짜 [NormalCallController.hangUp] / [NormalCallController.continueCall] 은
/// 위젯테스트에 없는 소켓과 오디오 파이프라인을 연다. 판정 로직만 재려는 것이므로
/// 그 둘을 세어 두고, 실제 [NormalCallController.resumeAfterPaywall] 은 그대로 돌린다.
class _RecordingCallController extends NormalCallController {
  _RecordingCallController(this._initial, this._calls);

  final CallState _initial;
  final _CallLog _calls;

  @override
  CallState build() => _initial;

  @override
  Future<void> hangUp() async {
    _calls.hangUps++;
    state = state.copyWith(phase: CallPhase.ended);
  }

  @override
  Future<void> continueCall() async {
    _calls.continues++;
    state = state.copyWith(phase: CallPhase.inCall);
  }
}

const _paidStatus = SubscriptionStatus(
  state: SubscriptionState.activePro,
  tier: SubscriptionTier.pro,
);
const _freeStatus = SubscriptionStatus(
  state: SubscriptionState.free,
  tier: SubscriptionTier.free,
);

/// 무료 회원이 첫 5분을 다 쓰고 결제 시트를 본 직후의 상태.
const _parked = CallState(
  phase: CallPhase.awaitingContinue,
  callId: 'call-1',
  elapsedSec: 300,
  segmentsUsed: 1,
);

({
  _RecordingCallController controller,
  _FakeSubscriptionRepository repo,
  _CallLog calls,
}) _build(
  SubscriptionStatus status, {
  CallState initial = _parked,
  SubscriptionTier? boughtThisSession,
}) {
  final calls = _CallLog();
  final controller = _RecordingCallController(initial, calls);
  final repo = _FakeSubscriptionRepository(status);
  final container = ProviderContainer(overrides: [
    normalCallControllerProvider.overrideWith(() => controller),
    subscriptionRepositoryProvider.overrideWithValue(repo),
  ]);
  addTearDown(container.dispose);
  // 이번 세션에 결제한 사실. 결제 화면이 실제로 여기에 적는다
  // (`purchase_flow.dart` — `sessionEntitlementProvider.notifier).state = tier`).
  if (boughtThisSession != null) {
    container.read(sessionEntitlementProvider.notifier).state =
        boughtThisSession;
  }
  // Notifier 를 세운다(build() 실행).
  container.read(normalCallControllerProvider);
  return (controller: controller, repo: repo, calls: calls);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resumeAfterPaywall — 결제하고 돌아왔을 때', () {
    test('유료로 바뀌었으면 통화를 이어간다', () async {
      final b = _build(_paidStatus);

      final resumed = await b.controller.resumeAfterPaywall();

      expect(resumed, isTrue);
      expect(b.calls.continues, 1, reason: '다음 구간을 열어야 한다');
      expect(b.calls.hangUps, 0, reason: '끊으면 안 된다');
    });

    test('paidCallTime 을 굳힌다 — 안 그러면 다음 경계에서 또 잘린다', () async {
      // ⛔ 이게 false 로 남으면 이어가더라도 **10분 경계에서 무료로 판정**돼
      //    상한을 다 쓴 것으로 처리된다. 결제한 사람의 통화가 그렇게 끝난다.
      final b = _build(_paidStatus);

      await b.controller.resumeAfterPaywall();

      expect(b.controller.state.paidCallTime, isTrue);
    });

    test('구독 상태를 **다시** 읽는다', () async {
      // ⛔ 통화 시작 때 굳은 `_paidAccess` 캐시를 그대로 쓰면 무료 회원의 `false` 가
      //    답한다 — 방금 결제한 사람에게도. 그게 "결제했는데 안 이어지는" 원인이었다.
      final b = _build(_paidStatus);

      await b.controller.resumeAfterPaywall();

      expect(b.repo.fetchCount, 1);
    });
  });

  group('resumeAfterPaywall — 서버가 아직 결제를 모를 때 (실기기에서 터진 것)', () {
    test('목 IAP 라 서버는 free 라고 답해도, 이번 세션에 샀으면 이어간다', () async {
      // ⛔ 이게 이 커밋의 핵심이다. `iapServiceProvider` 는 [MockIapService] 라
      //    **결제가 서버에 닿지 않는다.** 그래서 결제 직후에도 서버는 계속 `free` 다.
      //    서버 답을 그대로 믿으면 방금 돈을 낸 사람이 무료로 판정돼,
      //    통화가 끊기고 요약 화면이 뜬다 — 사장님 실기기 리포트(2026-08-22)가 그것.
      final b = _build(_freeStatus, boughtThisSession: SubscriptionTier.pro);

      final resumed = await b.controller.resumeAfterPaywall();

      expect(resumed, isTrue, reason: '결제했으면 이어져야 한다');
      expect(b.calls.continues, 1);
      expect(b.calls.hangUps, 0, reason: '결제한 사람의 통화를 끊으면 안 된다');
      expect(b.controller.state.paidCallTime, isTrue);
    });

    test('사지 않았으면 서버 free 를 그대로 따른다', () async {
      // 보정이 "무조건 유료"로 새지 않는지. 안 그러면 무료 회원이 무한히 통화한다.
      final b = _build(_freeStatus);

      final resumed = await b.controller.resumeAfterPaywall();

      expect(resumed, isFalse);
      expect(b.calls.hangUps, 1);
    });
  });

  group('resumeAfterPaywall — 결제하지 않고 돌아왔을 때', () {
    test('취소했으면 통화를 끝낸다', () async {
      // 무료 회원은 5분을 이미 다 썼으므로 이어갈 권한이 없다. 요약 화면으로 간다.
      final b = _build(_freeStatus);

      final resumed = await b.controller.resumeAfterPaywall();

      expect(resumed, isFalse);
      expect(b.calls.hangUps, 1);
      expect(b.calls.continues, 0, reason: '무료가 이어가면 상한이 무너진다');
    });
  });

  group('resumeAfterPaywall — 부를 자리가 아닐 때', () {
    test('결정 대기 중이 아니면 아무 것도 하지 않는다', () async {
      // 결제하는 사이 사용자가 직접 끊었거나(잠금화면 포함) 이미 이어간 경우.
      // 여기서 되살리면 **끝난 통화가 다시 살아난다.**
      final b = _build(
        _paidStatus,
        initial: const CallState(phase: CallPhase.ended, callId: 'call-1'),
      );

      final resumed = await b.controller.resumeAfterPaywall();

      expect(resumed, isFalse);
      expect(b.calls.hangUps, 0);
      expect(b.calls.continues, 0);
      expect(b.repo.fetchCount, 0, reason: '읽을 이유조차 없다');
    });
  });

  group('중간 결제 후 구간 회계', () {
    test('무료로 1구간 쓰고 결제하면 2구간이 남는다', () {
      // 무료가 쓴 5분은 사라지지 않는다 — 유료 3구간 중 1구간을 이미 쓴 것으로 센다.
      expect(
        CallAllowance.canExtend(segmentsUsed: 1, paidAccess: true),
        isTrue,
      );
      expect(
        CallAllowance.canExtend(segmentsUsed: 2, paidAccess: true),
        isTrue,
      );
      expect(
        CallAllowance.canExtend(segmentsUsed: 3, paidAccess: true),
        isFalse,
        reason: '중간에 결제해도 통화 1회 상한 15분은 그대로다',
      );
    });

    test('결제 전에는 이어갈 수 없다', () {
      expect(
        CallAllowance.canExtend(segmentsUsed: 1, paidAccess: false),
        isFalse,
      );
    });
  });
}
