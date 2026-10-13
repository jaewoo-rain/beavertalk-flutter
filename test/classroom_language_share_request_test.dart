// 반 참여·재동의 요청 본문 — b2b developer 계약(PM-DEC-543).
//
// - join: `language_share_version` 을 실어 보낸다. 없으면 키를 뺀다(옛 동의).
// - 재동의: `POST /classrooms/{id}/language-consent` 본문 `{"version": 2}`.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/data/datasources/classroom_remote_data_source.dart';

class _Capture implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{}),
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
  late _Capture capture;
  late ClassroomRemoteDataSource ds;

  setUp(() {
    capture = _Capture();
    ds = ClassroomRemoteDataSource(
      Dio(BaseOptions(baseUrl: 'https://b2b.test/api/v1'))
        ..httpClientAdapter = capture,
    );
  });

  test('join 은 동의한 모국어 공개 문구 버전을 보낸다', () async {
    await ds.join(
      joinCode: 'H7KQQ5',
      rosterName: '민',
      shareConsent: true,
      languageShareVersion: 2,
    );
    final body = capture.requests.single.data as Map<String, dynamic>;
    expect(body['language_share_version'], 2);
  });

  test('버전이 없으면 키를 빼서 옛 동의로 남긴다', () async {
    await ds.join(joinCode: 'H7KQQ5', rosterName: '민', shareConsent: true);
    final body = capture.requests.single.data as Map<String, dynamic>;
    expect(body.containsKey('language_share_version'), isFalse);
  });

  test('재동의는 반 id 경로에 version 을 보낸다', () async {
    await ds.setLanguageConsent(5, 2);
    final req = capture.requests.single;
    expect(req.path, '/classrooms/5/language-consent');
    expect(req.method, 'POST');
    expect(req.data, {'version': 2});
  });
}
