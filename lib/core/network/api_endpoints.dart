/// Backend path constants (relative to [Env.apiBaseUrl], no host or prefix).
///
/// Authentication is handled by Supabase Auth (the `/auth/*` backend endpoints
/// were removed); only the Bearer-protected member endpoints remain here.
abstract final class ApiEndpoints {
  // ── Members ──
  static const membersMe = '/members/me';
  static const membersMeProfile = '/members/me/profile';
  static const onboarding = '/members/me/onboarding';

  /// 레벨테스트 다시 받기. 레벨 배정만 지우고 **체크판(학습 기록)은 보존**한다.
  /// 성공하면 다음 통화가 자동으로 레벨테스트로 라우팅된다.
  static const membersMeLevelTestRetake = '/members/me/level-test/retake';

  // ── Calls ──
  /// 마이페이지 발음 카드 — 최근 N세션 발음 4지표 평균(`?sessions=`).
  static const callsPronunciationSummary = '/calls/pronunciation-summary';
}
