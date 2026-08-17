/// 한 통화가 쓸 수 있는 시간 — **구간(segment)** 단위로 센다.
///
/// ## 왜 구간인가
///
/// 통화는 5분짜리 세션 여러 개를 이어 붙여 만든다(플랜 §3-5). 한 소켓을 15분 열어
/// 두는 게 아니라 **5분마다 끊고 새로 연다.** 그래서 "몇 초 지났나"가 아니라
/// "몇 구간을 썼나"가 상한 판정의 단위다.
///
/// ⭐ 이 구조는 인프라 제약과도 맞아떨어진다 — Cloud Run 의 요청 타임아웃 기본값이
///   300초(=5분)라 WebSocket 도 거기 걸린다. 구간마다 새 세션을 열면 한 소켓이
///   5분을 넘길 일이 없어서, 서버·인프라가 몇 분에 끊든 설계가 영향받지 않는다.
library;

/// 통화 시간 정책. 플랜이 정한다.
///
/// ⛔ **상한 숫자를 여기 밖에 쓰지 마라.** Max 전용 시안이 나오거나 정책이 바뀌면
///   이 클래스만 고치면 되도록 한 자리에 모아 둔다.
abstract final class CallAllowance {
  /// 한 구간의 길이. **플랜과 무관하게 5분이다.**
  ///
  /// 유료 회원도 5분마다 「Keep going?」 을 받는다 — 시안의 "Calls continue in
  /// 5-minute stretches. We'll check in again each time." 가 그 뜻이다.
  static const Duration segment = Duration(minutes: 5);

  /// 이 접근권으로 쓸 수 있는 **구간 수**.
  ///
  /// - 무료: 1구간(5분). 다 쓰면 연장이 없고 구독 유도로 간다.
  /// - 유료: 3구간(15분). `SubscriptionTier.pro` 의 "15-minute sessions" 와 같은 값이다.
  ///
  /// ⚠ [paidAccess] 는 `SubscriptionStatus.grantsPaidAccess` 를 넘겨야 한다.
  ///   `tier` 나 `state` 를 직접 보고 판단하지 마라 — `grace`(결제 재시도)는 접근권을
  ///   **유지**하고 `onHold`(결제 실패 정지)는 **차단**한다. 그 비대칭이 두 상태를
  ///   따로 두는 이유 전부다(스펙 §6). 여기서 틀리면 결제 재시도 중인 회원의 통화가
  ///   5분에 잘린다.
  static int segmentsFor({required bool paidAccess}) => paidAccess ? 3 : 1;

  /// 이 접근권의 통화당 상한. 표시용(시안 카피·로그)이며 판정은 구간 수로 한다.
  static Duration limitFor({required bool paidAccess}) =>
      segment * segmentsFor(paidAccess: paidAccess);

  /// [segmentsUsed] 개를 소진한 뒤 **더 이어갈 수 있는가**.
  ///
  /// 상한에 닿으면 「Keep going?」 을 띄우지 않는다 — 누를 수 없는 버튼을 보여 주는
  /// 꼴이기 때문이다. 그대로 통화를 끝낸다(플랜 §3-6).
  static bool canExtend({
    required int segmentsUsed,
    required bool paidAccess,
  }) =>
      segmentsUsed < segmentsFor(paidAccess: paidAccess);
}
