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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skip = options.extra[skipAuthKey] == true;
    if (!skip) {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
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
