import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../network/dio_client.dart';
import '../network/env.dart';
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

/// 교실·과제 전용 [Dio]. **B2B 서비스는 호스트가 다르다.**
///
/// 교실 도메인은 2026-09-02 결정으로 별도 서비스로 분리됐다 — [dioProvider] 가
/// 보는 앱 서버에는 `/classrooms/*` 가 하나도 없다. 인터셉터는 같은 것을 쓴다:
/// 두 백엔드가 같은 Supabase 프로젝트를 보므로 **토큰이 양쪽에서 통한다.**
///
/// ⛔ 주소가 없으면 **앱 서버로 폴백하지 않고 던진다.** 폴백하면 없는 경로를
///    두드려 404 가 나고, 화면이 그것을 「반이 없다」로 오독한다. 조용한 오답보다
///    시끄러운 실패가 낫다 — 설정 누락은 배포 사고이지 학습자의 상태가 아니다.
///    (목록 조회는 `myAssignmentsProvider` 가 먼저 걸러 예외를 안 만든다.)
final b2bDioProvider = Provider<Dio>((ref) {
  final baseUrl = Env.b2bApiBaseUrl;
  if (baseUrl == null) {
    throw StateError(
      'B2B_API_BASE_URL 이 없다. 숙제 화면은 Env.hasB2bApi 로 먼저 걸러야 한다.',
    );
  }
  final dio = buildDio(baseUrl: baseUrl);

  final auth = AuthInterceptor(
    onSessionExpired: () {
      ref.read(authControllerProvider.notifier).onSessionExpired();
    },
  );
  auth.retryDio = dio;

  dio.interceptors.addAll([auth, LoggingInterceptor()]);

  return dio;
});
