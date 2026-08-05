import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Dev-only request/response logger. Masks the `Authorization` header and any
/// `password` field so secrets never reach the console.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '→ ${options.method} ${options.uri}\n'
        '  headers: ${_maskHeaders(options.headers)}\n'
        '  body: ${_maskBody(options.data)}',
        name: 'http',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.uri}',
        name: 'http',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '✗ ${err.response?.statusCode ?? err.type} '
        '${err.requestOptions.uri}\n  ${err.response?.data}',
        name: 'http',
      );
    }
    handler.next(err);
  }

  Map<String, Object?> _maskHeaders(Map<String, Object?> headers) {
    final copy = Map<String, Object?>.from(headers);
    if (copy.containsKey('Authorization')) copy['Authorization'] = '***';
    return copy;
  }

  Object? _maskBody(Object? data) {
    if (data is Map) {
      final copy = Map<Object?, Object?>.from(data);
      for (final key in copy.keys.toList()) {
        final k = key.toString().toLowerCase();
        if (k.contains('password') || k == 'token') copy[key] = '***';
      }
      return copy;
    }
    return data;
  }
}
