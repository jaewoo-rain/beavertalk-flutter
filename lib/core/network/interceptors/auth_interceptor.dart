import 'package:dio/dio.dart';

import '../../storage/token_store.dart';

/// Set `Options(extra: {AuthInterceptor.skipAuthKey: true})` on a request to
/// skip Bearer attachment (used by login/signup which have no token yet).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStore,
    required this.onSessionExpired,
  });

  /// Reads/clears the persisted access token.
  final TokenStore tokenStore;

  /// Invoked once when a 401 is seen, after the token is cleared. The app
  /// uses this to bounce the user back to login.
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
      final token = await tokenStore.read();
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
      // Token is stale/invalid: drop it and signal the app to re-auth.
      await tokenStore.clear();
      onSessionExpired();
    }
    handler.next(err);
  }
}
