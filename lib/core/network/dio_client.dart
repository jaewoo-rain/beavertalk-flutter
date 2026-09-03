import 'package:dio/dio.dart';

import 'env.dart';

/// Builds a [Dio] configured for the BeaverTalk backend.
///
/// Interceptors (auth/logging) are attached by the caller in
/// `core/di/providers.dart` so this stays free of app-level dependencies.
///
/// [baseUrl] 을 주면 그쪽을 본다 — 교실·과제는 분리된 B2B 서비스에 있다
/// (`Env.b2bApiBaseUrl`). 타임아웃·직렬화 설정은 두 호스트가 같이 쓴다.
Dio buildDio({String? baseUrl}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl ?? Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      // Default to JSON; the login call overrides this to form-urlencoded.
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
}
