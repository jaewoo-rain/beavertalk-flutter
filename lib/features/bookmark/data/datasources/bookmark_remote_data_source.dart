import 'package:dio/dio.dart';

import '../models/sentence_out_dto.dart';

/// Talks to the bookmark endpoints over dio. Returns DTOs; dio errors propagate
/// to the repository which maps them to [AppException].
///
/// The [Dio] is the shared `dioProvider` instance, so `Authorization: Bearer`
/// is attached automatically by `AuthInterceptor` — no manual headers here.
/// Paths are relative; the base URL already carries the host + `/api/v1`.
class BookmarkRemoteDataSource {
  BookmarkRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /members/me/bookmarks` — the current member's bookmarked sentences
  /// (`SentenceOut[]`).
  Future<List<SentenceOutDto>> fetchBookmarks() async {
    final res = await _dio.get<List<dynamic>>('/members/me/bookmarks');
    final data = res.data ?? const [];
    return data
        .map((e) => SentenceOutDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `PATCH /sentences/{id}/bookmark` — set/clear the bookmark; returns the
  /// updated sentence (`SentenceOut`). Body: `{"is_bookmarked": <bool>}`.
  Future<SentenceOutDto> setBookmark(int sentenceId, bool isBookmarked) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/sentences/$sentenceId/bookmark',
      data: {'is_bookmarked': isBookmarked},
    );
    return SentenceOutDto.fromJson(res.data!);
  }

  /// `POST /sentences/from-hint` — 통화 중 힌트를 **담는 그 순간** 문장으로 만든다.
  /// 응답은 만들어진(또는 재사용된) `SentenceOut` 이며 `is_bookmarked` 는 true 다.
  ///
  /// 힌트는 서버 어디에도 저장돼 있지 않으므로([HintExample] 참고) `korean`·`native`
  /// 를 클라가 돌려보낸다. `roman` 은 저장 필드가 없어 받지 않고, `locale` 은 서버가
  /// 회원 정보에서 채운다 — 보내면 통화 분석이 넣는 값과 표기가 갈린다.
  ///
  /// ⛔ **중복은 에러가 아니라 재사용이다.** 같은 통화에서 같은 한국어 문장을 두 번
  /// 담아도 행은 하나고, 두 번째도 200 에 **같은 sentence_id** 가 온다. 🔖 는 연타·
  /// 재진입이 흔하니 실패로 다루면 안 된다.
  ///
  /// ⚠ 남의 `call_id` 는 **404** 다(403 아님 — 그 통화의 존재를 알려 주지 않는다).
  /// `korean`·`native` 는 각각 1~500자 필수라 빈 값이면 422 다.
  Future<SentenceOutDto> saveFromHint({
    required int callId,
    required String korean,
    required String native,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/sentences/from-hint',
      data: {'call_id': callId, 'korean': korean, 'native': native},
    );
    return SentenceOutDto.fromJson(res.data!);
  }
}
