/// 한 통화가 쓸 수 있는 시간.
///
/// ## 구간(segment)은 **엔진 제약**이지 정책이 아니다
///
/// Gemini 는 연결 수명이 ~10분이라 통화를 5분짜리 세션 여러 개로 나눠 이어 붙인다
/// (플랜 §3-5). 그래서 상한 판정의 단위가 "몇 초 지났나"가 아니라 "몇 구간을 썼나"다.
///
/// ⛔ **인프라가 그 이유는 아니다 — 옛 주석이 틀렸다**(2026-10-04 교정).
///   여기엔 「Cloud Run 요청 타임아웃 기본값이 300초라 WebSocket 도 거기 걸린다」고
///   적혀 있었다. 지금 배포는 `--timeout=3600` 이다(서버 `scripts/deploy_prod.sh:57` ·
///   `deploy_demo.sh:57` 에서 확인). **한 소켓으로 15분을 버틸 수 있다.**
///   그 문장을 믿고 「5분을 넘기면 인프라가 끊는다」로 설계하지 마라.
///
/// ⭐ OpenAI Realtime(세션 60분) 검토에서는 조각이 필요 없다 — `kSingleSession` 이
///   켜지면 [limitFor] 를 **한 세션**으로 끝까지 쓴다(`seamless_fragment.dart`).
library;

/// 통화 시간 정책. 플랜이 정한다.
///
/// ⛔ **상한 숫자를 여기 밖에 쓰지 마라.** Max 전용 시안이 나오거나 정책이 바뀌면
///   이 클래스만 고치면 되도록 한 자리에 모아 둔다.
abstract final class CallAllowance {
  /// 한 구간의 길이. **플랜과 무관하게 5분이다** — 서버가 `call_started.remaining_s` 를
  /// 주지 않을 때(구서버·면제)의 폴백이다. 신서버는 조각마다 최대 360초를 준다(09-23).
  ///
  /// 그래서 「Keep going?」 본문(`kgBody`)은 숫자를 뺀 「Calls continue in short
  /// stretches.」 다(09-23 app designer 합의).
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
