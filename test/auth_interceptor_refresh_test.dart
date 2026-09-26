import 'dart:typed_data';

import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/core/error/dio_error_mapper.dart';
import 'package:beavertalk/core/network/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthApiException, AuthRetryableFetchException, AuthSessionMissingException;

/// 401 → 토큰 갱신이 실패했을 때 로그아웃하는가(PM-DEC-056 · 09-27).
///
/// 네트워크·타임아웃·5xx 로 갱신을 못 했으면 세션을 지키고 연결 오류만 돌려준다 — 401 을 그대로
/// 넘기면 `UnauthorizedFailure` 가 되고 AuthGate 가 그걸로 로그아웃하므로 연결 오류로 바꾼다.
/// 인증 서버가 갱신을 거절했을 때만 로그아웃한다.

/// 요청마다 [respond] 로 상태 코드를 정한다. 예외를 던지면 연결 실패다.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  final int Function(RequestOptions options) respond;
  final List<String?> auths = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    auths.add(options.headers['Authorization'] as String?);
    final status = respond(options);
    return ResponseBody.fromString(
      status == 200 ? '{"ok":true}' : '{"detail":{"code":"x","message":"no"}}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _Harness {
  _Harness({
    required Future<void> Function() refresh,
    required int Function(RequestOptions options, String? token) respond,
  }) {
    adapter = _Adapter((o) => respond(o, token));
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter;
    final auth = AuthInterceptor(
      onSessionExpired: () => expired++,
      refreshSession: () async {
        refreshCalls++;
        await refresh();
        token = 'fresh';
      },
      accessToken: () => token,
      sessionExpired: () => false,
    )..retryDio = dio;
    dio.interceptors.add(auth);
  }

  late final Dio dio;
  late final _Adapter adapter;
  String? token = 'stale';
  int expired = 0;
  int refreshCalls = 0;

  /// 요청 결과 — 성공이면 null, 실패면 그 [DioException].
  Future<DioException?> get(String path) async {
    try {
      await dio.get<dynamic>(path);
      return null;
    } on DioException catch (e) {
      return e;
    }
  }
}

/// 옛 토큰만 401, 새 토큰은 200.
int _staleRejected(RequestOptions o, String? token) =>
    o.headers['Authorization'] == 'Bearer fresh' ? 200 : 401;

void main() {
  group('갱신 실패 분류 — refreshFailureEndsSession', () {
    test('네트워크·5xx(재시도 가능)·알 수 없는 오류는 세션 유지', () {
      expect(
        AuthInterceptor.refreshFailureEndsSession(
          AuthRetryableFetchException(message: 'SocketException: Failed host lookup'),
        ),
        isFalse,
      );
      expect(
        AuthInterceptor.refreshFailureEndsSession(
          AuthRetryableFetchException(message: 'bad gateway', statusCode: '502'),
        ),
        isFalse,
      );
      expect(AuthInterceptor.refreshFailureEndsSession(StateError('?')), isFalse);
    });

    test('인증 서버의 거절은 로그아웃', () {
      expect(
        AuthInterceptor.refreshFailureEndsSession(
          AuthApiException(
            'Invalid Refresh Token: Refresh Token Not Found',
            statusCode: '400',
            code: 'refresh_token_not_found',
          ),
        ),
        isTrue,
      );
      expect(
        AuthInterceptor.refreshFailureEndsSession(AuthSessionMissingException()),
        isTrue,
      );
    });
  });

  group('401 처리', () {
    test('네트워크 오류로 갱신 실패 → 세션 유지 · 연결 오류(NetworkFailure)로 돌려준다', () async {
      final h = _Harness(
        refresh: () => throw AuthRetryableFetchException(
          message: 'ClientException: Connection closed before full header was received',
        ),
        respond: _staleRejected,
      );
      final e = await h.get('/members/me');
      expect(h.expired, 0, reason: '네트워크 실패로 로그아웃하지 않는다');
      expect(h.token, 'stale', reason: '세션을 건드리지 않는다');
      expect(e, isNotNull);
      expect(e!.type, DioExceptionType.connectionError);
      expect(
        mapDioException(e),
        isA<NetworkFailure>(),
        reason: 'UnauthorizedFailure 면 AuthGate 가 로그아웃한다',
      );
      expect(h.adapter.auths, ['Bearer stale'], reason: '갱신 못 했으면 재요청하지 않는다');
    });

    test('타임아웃·5xx 로 갱신 실패도 세션 유지', () async {
      final h = _Harness(
        refresh: () => throw AuthRetryableFetchException(message: 'timeout', statusCode: '504'),
        respond: _staleRejected,
      );
      final e = await h.get('/members/me');
      expect(h.expired, 0);
      expect(mapDioException(e!), isA<NetworkFailure>());
    });

    test('갱신 거절(invalid refresh token) → 로그아웃 · 401(UnauthorizedFailure) 그대로', () async {
      final h = _Harness(
        refresh: () => throw AuthApiException(
          'Invalid Refresh Token: Refresh Token Not Found',
          statusCode: '400',
          code: 'refresh_token_not_found',
        ),
        respond: _staleRejected,
      );
      final e = await h.get('/members/me');
      expect(h.expired, 1);
      expect(e!.response?.statusCode, 401);
      expect(mapDioException(e), isA<UnauthorizedFailure>());
    });

    test('갱신 성공 → 새 토큰으로 재요청해 그대로 성공 · 로그아웃 없음', () async {
      final h = _Harness(refresh: () async {}, respond: _staleRejected);
      expect(await h.get('/members/me'), isNull);
      expect(h.expired, 0);
      expect(h.adapter.auths, ['Bearer stale', 'Bearer fresh']);
    });

    test('갱신한 토큰도 401 → 로그아웃(한 번)', () async {
      final h = _Harness(refresh: () async {}, respond: (_, _) => 401);
      final e = await h.get('/members/me');
      expect(h.expired, 1);
      expect(mapDioException(e!), isA<UnauthorizedFailure>());
    });

    test('갱신 성공 뒤 재요청이 5xx → 로그아웃하지 않고 그 오류를 돌려준다', () async {
      var n = 0;
      final h = _Harness(refresh: () async {}, respond: (_, _) => n++ == 0 ? 401 : 503);
      final e = await h.get('/members/me');
      expect(h.expired, 0);
      expect(e!.response?.statusCode, 503);
    });

    test('갱신이 진행 중일 때 온 401 들은 그 갱신 한 번을 같이 기다린다', () async {
      // 갱신이 바로 끝나면 401 들이 차례로 와서 각자 갱신한다 — 겹치게 늦춘다.
      final h = _Harness(
        refresh: () => Future<void>.delayed(const Duration(milliseconds: 50)),
        respond: _staleRejected,
      );
      final results = await Future.wait([h.get('/a'), h.get('/b'), h.get('/c')]);
      expect(results, everyElement(isNull));
      expect(h.refreshCalls, 1);
      expect(h.expired, 0);
    });

    test('익명 요청(skipAuth)의 401 은 세션을 건드리지 않는다', () async {
      final h = _Harness(
        refresh: () => throw AuthApiException('bad', statusCode: '400'),
        respond: (_, _) => 401,
      );
      await expectLater(
        h.dio.get<dynamic>(
          '/public',
          options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
        ),
        throwsA(isA<DioException>()),
      );
      expect(h.refreshCalls, 0);
      expect(h.expired, 0);
    });
  });
}
