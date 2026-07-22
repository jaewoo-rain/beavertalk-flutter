/// Backend path constants (relative to [Env.apiBaseUrl], no host or prefix).
///
/// Authentication is handled by Supabase Auth (the `/auth/*` backend endpoints
/// were removed); only the Bearer-protected member endpoints remain here.
abstract final class ApiEndpoints {
  // ── Members ──
  static const membersMe = '/members/me';
  static const membersMeProfile = '/members/me/profile';
  static const onboarding = '/members/me/onboarding';
}
