import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Set `Options(extra: {AuthInterceptor.skipAuthKey: true})` on a request to
/// skip Bearer attachment (used by requests that must stay anonymous).
///
/// The token is sourced from the live Supabase session
/// (`Supabase.instance.client.auth.currentSession`), which the SDK persists and
/// auto-refreshes. There is no separate token store to keep in sync.
///
/// ## When a 401 signs the member out (PM-DEC-056 · 09-27)
///
/// Only when the session is **genuinely** dead:
/// - the auth server **rejected** the refresh (invalid / revoked refresh
///   token — any [AuthException] that is not retryable), or
/// - the refresh worked and the replay still got 401.
///
/// A refresh that failed because of the **network** (no connection, timeout,
/// 5xx — gotrue raises [AuthRetryableFetchException] for all of these) does
/// **not** sign out. The caller gets a connection error instead of the 401 —
/// a 401 maps to `UnauthorizedFailure`, and `AuthGate` signs out on that, so
/// passing the 401 through would sign out anyway. It used to sign out here
/// too, so a flaky connection right after launch was enough to log a member
/// out (QA 09-26 · Note20 after an update — which path it was is not yet
/// confirmed; the logs below are for that).
///
/// Every sign-out and every kept session is logged with the request and the
/// reason (`[auth] …`) so the next report can tell which path it was.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.onSessionExpired,
    Future<void> Function()? refreshSession,
    String? Function()? accessToken,
    bool Function()? sessionExpired,
  })  : _refreshSession = refreshSession ?? _supabaseRefresh,
        _accessToken = accessToken ?? _supabaseAccessToken,
        _sessionExpired = sessionExpired ?? _supabaseSessionExpired;

  /// Invoked once when the session is judged dead. The app uses this to bounce
  /// the user back to login (and best-effort sign out of Supabase).
  final void Function() onSessionExpired;

  /// Refreshes the session — Supabase in the app, a fake in tests.
  final Future<void> Function() _refreshSession;

  /// The current access token, or null when there is no session.
  final String? Function() _accessToken;

  /// Whether the current session is expired or about to be.
  final bool Function() _sessionExpired;

  static Future<void> _supabaseRefresh() =>
      Supabase.instance.client.auth.refreshSession().then((_) {});

  static String? _supabaseAccessToken() =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  static bool _supabaseSessionExpired() =>
      Supabase.instance.client.auth.currentSession?.isExpired ?? false;

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

  Future<void> _refreshOnce() =>
      _refresh ??= _refreshSession().whenComplete(() => _refresh = null);

  /// Whether a failed refresh means the session is **dead** (sign out) rather
  /// than unreachable (keep it, surface the error).
  ///
  /// - [AuthRetryableFetchException] — gotrue's wrapper for every network
  ///   failure and 5xx: **keep**.
  /// - Any other [AuthException] (invalid or revoked refresh token, missing
  ///   session): the auth server said no — **sign out**. This is gotrue's own
  ///   rule: on exactly these it has already removed the session and emitted
  ///   `signedOut`, so keeping ours would only leave a dead token behind.
  /// - Anything else: unknown, so **keep** — signing a member out on a guess is
  ///   the worse mistake (they lose their place; a kept stale session only
  ///   costs one more failed request).
  @visibleForTesting
  static bool refreshFailureEndsSession(Object error) {
    if (error is AuthRetryableFetchException) return false;
    if (error is AuthException) return true;
    return false;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skip = options.extra[skipAuthKey] == true;
    if (!skip) {
      // Supabase access tokens are short-lived. If the app was idle/backgrounded,
      // the token can lapse before the SDK's background auto-refresh runs, so the
      // FIRST request after reopening a screen goes out with a stale token → 401
      // (a manual retry then "works" once the refresh lands). Proactively refresh
      // an expired/expiring session BEFORE attaching, so there's no first-hit 401
      // (e.g. the alarm list's initial load) and no spurious sign-out.
      if (_sessionExpired()) {
        try {
          await _refreshOnce();
        } catch (e) {
          // Refresh failed → fall through with the stale token; the 401 path
          // below decides whether that means sign-out.
          debugPrint('[auth] 요청 전 갱신 실패(${e.runtimeType}) — 옛 토큰으로 보냄: '
              '${options.method} ${options.path}');
        }
      }
      final token = _accessToken();
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

    // Only a first 401 on an authed request triggers refresh+replay. A `skip`
    // (anonymous) request must never affect the session, and a `retried` request
    // is the failed replay itself — let it propagate so the ORIGINAL request's
    // handling below decides once (avoids double onSessionExpired).
    if (!is401 || skip || retried) {
      handler.next(err);
      return;
    }

    final opts = err.requestOptions;
    final where = '${opts.method} ${opts.path}';

    // First 401: the server rejected our token — usually a boundary/stale token.
    // Refresh once and replay transparently.
    try {
      await _refreshOnce();
    } catch (e) {
      if (!refreshFailureEndsSession(e)) {
        debugPrint('[auth] 401 · 갱신 실패(${e.runtimeType}) — 네트워크 계열이라 '
            '로그아웃하지 않음: $where');
        handler.next(DioException(
          requestOptions: opts,
          type: DioExceptionType.connectionError,
          error: e,
          message: 'Session refresh failed: $e',
        ));
        return;
      }
      debugPrint('[auth] 401 · 갱신 거절($e) → 로그아웃: $where');
      onSessionExpired();
      handler.next(err);
      return;
    }

    final token = _accessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[auth] 401 · 갱신 뒤에도 세션 없음 → 로그아웃: $where');
      onSessionExpired();
      handler.next(err);
      return;
    }
    final dio = retryDio;
    if (dio == null) {
      // Wiring gap (retryDio is set in core/di/providers.dart) — not a session
      // problem, so no sign-out.
      handler.next(err);
      return;
    }

    // Multipart/stream bodies can only be sent once (Dio finalizes FormData in
    // place). Clone so the replay of an audio-review upload doesn't throw
    // "FormData has already been finalized".
    if (opts.data is FormData) {
      opts.data = (opts.data as FormData).clone();
    }
    opts.extra[_retriedKey] = true;
    opts.headers['Authorization'] = 'Bearer $token';
    try {
      final res = await dio.fetch<dynamic>(opts);
      handler.resolve(res);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // A fresh token still rejected — the session is really dead.
        debugPrint('[auth] 401 · 갱신한 토큰도 거절 → 로그아웃: $where');
        onSessionExpired();
        handler.next(err);
        return;
      }
      // The replay failed for another reason (network, 5xx) — not a session
      // problem. Surface that error instead of signing out.
      debugPrint('[auth] 401 · 재요청 실패(${e.type}) — 로그아웃하지 않음: $where');
      handler.next(e);
    }
  }
}
