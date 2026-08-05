import 'package:dio/dio.dart';

import 'env.dart';

/// Builds a [Dio] configured for the BeaverTalk backend.
///
/// Interceptors (auth/logging) are attached by the caller in
/// `core/di/providers.dart` so this stays free of app-level dependencies.
Dio buildDio() {
  return Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      // Default to JSON; the login call overrides this to form-urlencoded.
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
}
