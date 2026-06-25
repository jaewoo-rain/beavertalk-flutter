// Verifies the request shapes the AuthRemoteDataSource sends for the member
// endpoints that survived the Supabase Auth migration (onboarding + getMe).
// Auth itself (login/signup/social/password-reset) now goes through the
// Supabase SDK and is no longer part of this data source. A fake adapter
// captures each outgoing request and returns a canned response.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/auth/data/datasources/auth_remote_data_source.dart';

/// Captures the last request and replies with [responseJson].
class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter(this.responseJson);

  final Map<String, dynamic> responseJson;
  RequestOptions? lastRequest;
  String? lastBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (requestStream != null) {
      final chunks = await requestStream.toList();
      lastBody = utf8.decode(chunks.expand((c) => c).toList());
    }
    return ResponseBody.fromString(
      jsonEncode(responseJson),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _CaptureAdapter adapter;
  late AuthRemoteDataSource ds;

  void setup(Map<String, dynamic> response) {
    adapter = _CaptureAdapter(response);
    dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))
      ..httpClientAdapter = adapter;
    ds = AuthRemoteDataSource(dio);
  }

  group('getMe', () {
    test('sends GET /members/me', () async {
      setup({'member_id': 7, 'onboarding_completed': true});
      final member = await ds.getMe();

      expect(adapter.lastRequest!.method, 'GET');
      expect(adapter.lastRequest!.path, '/members/me');
      expect(member.memberId, 7);
      expect(member.onboardingCompleted, isTrue);
    });
  });

  group('onboarding body sends only provided fields', () {
    test('name, language, reasons all present', () async {
      setup({'member_id': 1, 'onboarding_completed': true});
      await ds.submitOnboarding(
        name: 'Jae',
        language: 'en',
        reasons: ['travel'],
      );

      expect(adapter.lastRequest!.method, 'POST');
      expect(adapter.lastRequest!.path, '/members/me/onboarding');
      expect(jsonDecode(adapter.lastBody!), {
        'name': 'Jae',
        'language': 'en',
        'reasons': ['travel'],
      });
    });

    test('null fields are omitted', () async {
      setup({'member_id': 1, 'onboarding_completed': true});
      await ds.submitOnboarding(reasons: ['career']);

      final body = jsonDecode(adapter.lastBody!) as Map<String, dynamic>;
      expect(body, {'reasons': ['career']});
    });

    test('multiple reasons are sent as a list', () async {
      setup({'member_id': 1, 'onboarding_completed': true});
      await ds.submitOnboarding(reasons: ['travel', 'career', 'exam']);

      final body = jsonDecode(adapter.lastBody!) as Map<String, dynamic>;
      expect(body['reasons'], ['travel', 'career', 'exam']);
    });
  });

  group('MemberDto parses name / onboarding_completed / reasons', () {
    test('new fields reach the entity', () async {
      setup({
        'member_id': 7,
        'name': 'Jae',
        'onboarding_completed': true,
        'reasons': ['travel', 'career'],
      });
      final member = (await ds.submitOnboarding(name: 'Jae')).toEntity();

      expect(member.name, 'Jae');
      expect(member.onboardingCompleted, isTrue);
      expect(member.reasons, ['travel', 'career']);
    });

    test('onboarding_completed defaults to false when absent', () async {
      setup({'member_id': 1});
      final member = (await ds.getMe()).toEntity();

      expect(member.onboardingCompleted, isFalse);
      expect(member.name, isNull);
    });
  });
}
