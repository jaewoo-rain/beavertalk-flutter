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

  /// Marks a request that has already been replayed after a 401 refresh, so a
  /// still-failing token can't loop forever.
  static const _retriedKey = '__authRetried';

  /// The Dio used to replay a request after refreshing on 401. Set by
  /// `core/di/providers.dart` right after the client is built (can't be a
  /// constructor arg — the interceptor lives inside this same Dio).
  Dio? retryDio;

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
    final is401 = err.response?.statusCode == 401;
    final skip = err.requestOptions.extra[skipAuthKey] == true;
    final retried = err.requestOptions.extra[_retriedKey] == true;

    // First 401 on a normal request: the server rejected our token. This is
    // usually a boundary/stale token (a manual retry "works" once the session
    // refreshes). Refresh once and replay the request transparently so the user
    // never sees the error/retry button (e.g. the alarm list's initial load).
    if (is401 && !skip && !retried) {
      try {
        final auth = Supabase.instance.client.auth;
        _refresh ??= auth
            .refreshSession()
            .then((_) {})
            .whenComplete(() => _refresh = null);
        await _refresh;
        final token = auth.currentSession?.accessToken;
        final dio = retryDio;
        if (token != null && token.isNotEmpty && dio != null) {
          final opts = err.requestOptions
            ..extra[_retriedKey] = true
            ..headers['Authorization'] = 'Bearer $token';
          final res = await dio.fetch<dynamic>(opts);
          handler.resolve(res);
          return;
        }
      } catch (_) {
        // Refresh or replay failed → the session is genuinely dead; sign out.
      }
      onSessionExpired();
    } else if (is401) {
      // Replay also 401'd (or auth was skipped) → token is truly invalid.
      onSessionExpired();
    }
    handler.next(err);
  }
}
