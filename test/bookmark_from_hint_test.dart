import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/bookmark/data/datasources/bookmark_remote_data_source.dart';
import 'package:beavertalk/features/bookmark/data/repositories/bookmark_repository_impl.dart';

/// `POST /sentences/from-hint` 는 **통화 중에만** 눌리는 길이라 사람이 다시 밟아 보기
/// 어렵다. 계약이 어긋나면 "책갈피가 안 담긴다"로만 보이므로 여기서 고정한다.
///
/// 서버 계약(`domains/learning/routers/sentence.py`, 2026-09-05):
///   요청  { call_id: int, korean: str(1~500), native: str(1~500) }   ← roman·locale 없음
///   응답  SentenceOut (sentence_id, korean_sentence, native_sentence, …, is_bookmarked)
///   중복  200 + **같은 sentence_id** (에러 아님)
///   남의 call_id → 404
class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter(this.body, {this.statusCode = 200});

  final String body;
  final int statusCode;

  /// 마지막으로 나간 요청 — 경로와 바디를 검증한다.
  RequestOptions? lastRequest;
  Object? lastData;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _,
      Future<void>? __) async {
    lastRequest = options;
    lastData = options.data;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_CaptureAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://x.test/api/v1'));
  dio.httpClientAdapter = adapter;
  return dio;
}

void main() {
  group('POST /sentences/from-hint', () {
    test('경로와 바디가 서버 계약과 맞는다 — roman·locale 은 보내지 않는다', () async {
      final adapter = _CaptureAdapter(
        '{"sentence_id":567,"korean_sentence":"화장실이 어디예요?",'
        '"native_sentence":"Where is the restroom?","voice_url":null,'
        '"is_bookmarked":true}',
      );
      final ds = BookmarkRemoteDataSource(_dio(adapter));

      await ds.saveFromHint(
        callId: 1234,
        korean: '화장실이 어디예요?',
        native: 'Where is the restroom?',
      );

      expect(adapter.lastRequest!.path, '/sentences/from-hint');
      expect(adapter.lastRequest!.method, 'POST');
      final sent = adapter.lastData as Map<String, dynamic>;
      expect(sent['call_id'], 1234);
      expect(sent['korean'], '화장실이 어디예요?');
      expect(sent['native'], 'Where is the restroom?');
      // 서버가 안 받는 필드를 보내면 422 가 난다.
      expect(sent.containsKey('roman'), isFalse);
      expect(sent.containsKey('locale'), isFalse);
      expect(sent.keys.length, 3);
    });

    test('응답의 SentenceOut 을 담긴 문장으로 읽는다', () async {
      final adapter = _CaptureAdapter(
        '{"sentence_id":567,"korean_sentence":"화장실이 어디예요?",'
        '"native_sentence":"Where is the restroom?","voice_url":null,'
        '"is_bookmarked":true}',
      );
      final repo =
          BookmarkRepositoryImpl(remote: BookmarkRemoteDataSource(_dio(adapter)));

      final saved = await repo.saveHintSentence(
        callId: 1234,
        korean: '화장실이 어디예요?',
        native: 'Where is the restroom?',
      );

      expect(saved.sentenceId, 567);
      expect(saved.korean, '화장실이 어디예요?');
      // 담는 순간 이미 담긴 상태로 온다 — 앱이 따로 PATCH 할 필요가 없다.
      expect(saved.isBookmarked, isTrue);
    });

    test('같은 힌트를 다시 담아도 200 + 같은 id — 실패가 아니다', () async {
      // 서버가 행을 재사용한다. 🔖 는 연타·재진입이 흔해서 이 경로가 자주 밟힌다.
      final adapter = _CaptureAdapter(
        '{"sentence_id":567,"korean_sentence":"화장실이 어디예요?",'
        '"native_sentence":"Where is the restroom?","voice_url":null,'
        '"is_bookmarked":true}',
      );
      final repo =
          BookmarkRepositoryImpl(remote: BookmarkRemoteDataSource(_dio(adapter)));

      final first = await repo.saveHintSentence(
          callId: 1234, korean: '화장실이 어디예요?', native: 'Where is the restroom?');
      final second = await repo.saveHintSentence(
          callId: 1234, korean: '화장실이 어디예요?', native: 'Where is the restroom?');

      expect(second.sentenceId, first.sentenceId);
    });

    test('남의 call_id(404)는 AppException 으로 올라온다', () async {
      final adapter = _CaptureAdapter(
        '{"detail":{"code":"NOT_FOUND","message":"통화를 찾을 수 없습니다."}}',
        statusCode: 404,
      );
      final repo =
          BookmarkRepositoryImpl(remote: BookmarkRemoteDataSource(_dio(adapter)));

      expect(
        () => repo.saveHintSentence(
            callId: 9, korean: '가요', native: 'go'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
