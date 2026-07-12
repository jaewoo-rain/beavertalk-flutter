import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';

/// The configured [Dio] with auth + logging interceptors attached.
///
/// The auth token is read from the live Supabase session inside the
/// interceptor. The 401 handler defers to [AuthController.onSessionExpired].
/// Reading the controller lazily inside the callback (not at build time) avoids
/// a build-order cycle between dio and the controller.
final dioProvider = Provider<Dio>((ref) {
  final dio = buildDio();

  final auth = AuthInterceptor(
    onSessionExpired: () {
      ref.read(authControllerProvider.notifier).onSessionExpired();
    },
  );
  // Let the auth interceptor replay a request through this same client after a
  // 401 refresh (the replay carries a retried flag so it can't loop).
  auth.retryDio = dio;

  dio.interceptors.addAll([auth, LoggingInterceptor()]);

  return dio;
});
