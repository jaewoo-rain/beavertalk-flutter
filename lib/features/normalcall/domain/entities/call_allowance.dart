/// 한 통화가 쓸 수 있는 시간.
///
/// ## 한 통화 = 한 세션. 「구간」은 **상한을 적는 단위**로만 남았다
///
/// 2026-10-04 사장님 지시로 **조각 분할을 지웠다**(`call_limit_policy.dart`). 통화는
/// 소켓 하나로 아래 상한까지 가고 끝난다 — 중간 재연결도, 서버에 남은 초를 묻는
/// 왕복도 없다. 클라가 직접 1초 틱으로 재고 [limitFor] 에 닿으면 끝낸다.
///
/// 그래서 [segment]·[segmentsFor] 는 **쪼개는 단위가 아니라 상한을 적는 단위**다:
/// 유료 3×5분 = 15분, 무료 1×5분 = 5분. 둘을 따로 둔 이유는 두 자리가 아직 이 모양을
/// 읽기 때문이다 — 무료 시트의 사용량 줄(`5:00 of 5:00`, `call.dart:533`)과 서버
/// 이어가기 판정의 폴백([canExtend], `normalcall_controller.dart` 의 `_reachSegmentEnd`).
///
/// ## 왜 쪼갰었나 — 되살리기 전에 알아야 할 것
///
/// 조각 분할은 정책이 아니라 **Gemini 연결 수명(~10분)** 때문이었다.
///
/// ⛔ **인프라가 그 이유는 아니다 — 옛 주석이 틀렸다**(2026-10-04 교정).
///   여기엔 「Cloud Run 요청 타임아웃 기본값이 300초라 WebSocket 도 거기 걸린다」고
///   적혀 있었다. 지금 배포는 `--timeout=3600` 이다(서버 `scripts/deploy_prod.sh:57` ·
///   `deploy_demo.sh:57` 에서 확인). **한 소켓으로 15분을 버틸 수 있다.**
///   그 문장을 믿고 「5분을 넘기면 인프라가 끊는다」로 설계하지 마라.
///
/// ⚠ **서버 백스톱은 별개다** — 서버가 `max(540, call_duration_s + 52)` 로 통화를 끊고
///   `call_duration_s` 가 전 플랜 360초다(서버 `call_session.py:1888` · `call_service.py:287`).
///   그대로면 클라가 900 을 세도 **9:00 에 서버가 끊는다.** 테스트 서버에
///   `NORMAL_CALL_DURATION_S=900` 을 넣으면 백스톱이 952초가 된다(`call_session.py:127-130`).
library;

/// 통화 시간 정책. 플랜이 정한다.
///
/// ⛔ **상한 숫자를 여기 밖에 쓰지 마라.** Max 전용 시안이 나오거나 정책이 바뀌면
///   이 클래스만 고치면 되도록 한 자리에 모아 둔다.
abstract final class CallAllowance {
  /// 상한을 적는 단위. **플랜과 무관하게 5분이다.**
  ///
  /// ⛔ 이제 **통화를 이 길이로 쪼개지 않는다** — 단일 세션이다. 무료 시트의 사용량
  ///   줄(`5:00 of 5:00`)이 이 값을 읽는다.
  ///
  /// 그래서 「Keep going?」 본문(`kgBody`)은 숫자를 뺀 「Calls continue in short
  /// stretches.」 다(09-23 app designer 합의).
  static const Duration segment = Duration(minutes: 5);

  /// 이 접근권의 상한을 [segment] 몇 개로 적는가.
  ///
  /// - 무료: 1(5분). 다 쓰면 연장이 없고 구독 유도로 간다.
  /// - 유료: 3(15분). `SubscriptionTier.pro` 의 "15-minute sessions" 와 같은 값이다.
  ///
  /// ⚠ [paidAccess] 는 `SubscriptionStatus.grantsPaidAccess` 를 넘겨야 한다.
  ///   `tier` 나 `state` 를 직접 보고 판단하지 마라 — `grace`(결제 재시도)는 접근권을
  ///   **유지**하고 `onHold`(결제 실패 정지)는 **차단**한다. 그 비대칭이 두 상태를
  ///   따로 두는 이유 전부다(스펙 §6). 여기서 틀리면 결제 재시도 중인 회원의 통화가
  ///   5분에 잘린다.
  static int segmentsFor({required bool paidAccess}) => paidAccess ? 3 : 1;

  /// 이 접근권의 통화당 상한 — **판정의 정본이다.**
  ///
  /// `call_limit_policy.dart` 의 `callLimitAction` 이 이 값 하나만 보고 끝을 정한다.
  static Duration limitFor({required bool paidAccess}) =>
      segment * segmentsFor(paidAccess: paidAccess);

  /// [segmentsUsed] 개를 소진한 뒤 **더 이어갈 수 있는가** — 서버 이어가기 판정의 폴백.
  ///
  /// 상한에 닿으면 「Keep going?」 을 띄우지 않는다 — 누를 수 없는 버튼을 보여 주는
  /// 꼴이기 때문이다. 그대로 통화를 끝낸다(플랜 §3-6).
  ///
  /// ⭐ 단일 세션에서는 **무료만** 이 길로 온다(상한 = 1구간 = 통화 전체). `1 < 1` 이
  ///   false 라 연장이 없고, 그래서 그 시트는 「이어하기」가 아니라 구독 유도다.
  static bool canExtend({
    required int segmentsUsed,
    required bool paidAccess,
  }) =>
      segmentsUsed < segmentsFor(paidAccess: paidAccess);
}
