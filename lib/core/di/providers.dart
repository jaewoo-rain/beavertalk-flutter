import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../storage/token_store.dart';

/// Secure JWT storage, shared app-wide.
final tokenStoreProvider = Provider<TokenStore>((ref) {
  return TokenStore();
});

/// The configured [Dio] with auth + logging interceptors attached.
///
/// The 401 handler defers to [AuthController.onSessionExpired]. Reading the
/// controller lazily inside the callback (not at build time) avoids a
/// build-order cycle between dio and the controller.
final dioProvider = Provider<Dio>((ref) {
  final dio = buildDio();
  final tokenStore = ref.watch(tokenStoreProvider);

  dio.interceptors.addAll([
    AuthInterceptor(
      tokenStore: tokenStore,
      onSessionExpired: () {
        ref.read(authControllerProvider.notifier).onSessionExpired();
      },
    ),
    LoggingInterceptor(),
  ]);

  return dio;
});
