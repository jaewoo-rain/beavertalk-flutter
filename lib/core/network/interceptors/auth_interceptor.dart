import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Set `Options(extra: {AuthInterceptor.skipAuthKey: true})` on a request to
/// skip Bearer attachment (used by requests that must stay anonymous).
///
/// The token is sourced from the live Supabase session
/// (`Supabase.instance.client.auth.currentSession`), which the SDK persists and
/// auto-refreshes. There is no separate token store to keep in sync.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.onSessionExpired});

  /// Invoked once when a 401 is seen. The app uses this to bounce the user back
  /// to login (and best-effort sign out of Supabase).
  final void Function() onSessionExpired;

  /// Extra flag that disables Bearer attachment for a single request.
  static const skipAuthKey = 'skipAuth';

  /// Shared in-flight refresh so concurrent requests await one network refresh
  /// instead of each firing their own.
  Future<void>? _refresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skip = options.extra[skipAuthKey] == true;
    if (!skip) {
      final auth = Supabase.instance.client.auth;
      var session = auth.currentSession;
      // Supabase access tokens are short-lived. If the app was idle/backgrounded,
      // the token can lapse before the SDK's background auto-refresh runs, so the
      // FIRST request after reopening a screen goes out with a stale token → 401
      // (a manual retry then "works" once the refresh lands). Proactively refresh
      // an expired/expiring session BEFORE attaching, so there's no first-hit 401
      // (e.g. the alarm list's initial load) and no spurious sign-out.
      if (session != null && session.isExpired) {
        try {
          _refresh ??= auth
              .refreshSession()
              .then((_) {})
              .whenComplete(() => _refresh = null);
          await _refresh;
          session = auth.currentSession;
        } catch (_) {
          // Refresh failed (e.g. the refresh token itself expired) → fall through
          // with the stale token; the 401 path then signs the user out for real.
        }
      }
      final token = session?.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token is stale/invalid: signal the app to re-auth (which signs out).
      onSessionExpired();
    }
    handler.next(err);
  }
}
