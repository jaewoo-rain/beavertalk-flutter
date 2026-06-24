/// Backend path constants (relative to [Env.apiBaseUrl], no host or prefix).
abstract final class ApiEndpoints {
  // ── Auth ──
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const social = '/auth/social';
  static const passwordResetRequest = '/auth/password-reset/request';
  static const passwordResetConfirm = '/auth/password-reset/confirm';

  // ── Members ──
  static const membersMe = '/members/me';
}
