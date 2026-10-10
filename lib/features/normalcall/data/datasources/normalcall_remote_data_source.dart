import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/env.dart';
import '../../../../screens/home/learning_summary.dart';
import '../../domain/entities/cur_me.dart';
import '../../domain/entities/pron_summary.dart';
import '../models/call_result_dto.dart';

/// Talks to the call status/result endpoints over dio. Returns DTOs / raw
/// status strings; dio errors propagate to the repository which maps them to
/// [AppException].
class NormalcallRemoteDataSource {
  NormalcallRemoteDataSource(this._dio);

  final Dio _dio;

  /// `PATCH /calls/{call_id}` with `{"rating": <int>}` (rating ∈ {1,2,3}).
  /// The CallSummary response body is ignored.
  Future<void> submitRating(int callId, int rating) async {
    await _dio.patch<Map<String, dynamic>>(
      '/calls/$callId',
      data: {'rating': rating},
    );
  }

  /// `GET /calls/{call_id}/status` — returns the raw `status` string.
  Future<String?> getStatus(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId/status');
    return res.data?['status'] as String?;
  }

  /// `GET /calls/{call_id}/resume-status` — 이 통화를 이어갈 수 있는지 서버에 묻는다.
  ///
  /// 남의 통화를 조회하면 서버가 **404** 를 준다(백엔드 문서 §2③). 리포지토리가
  /// 그 경우를 null 로 눕힌다 — 이어가기를 못 할 뿐 통화를 막을 일은 아니다.
  ///
  /// [planOverride] 가 있으면 `?plan_override=` 를 붙인다 — 서버(admin 만)가 그 플랜의
  /// 조각 상한으로 `can_resume`·`max_fragments` 를 답한다.
  ///
  /// [tzParams]([DeviceTimezone.params] — `tz` · `tz_offset_min`)도 싣는다. 서버는 하루 예산을
  /// 이 시간대의 날짜로 센다 — 안 보내면 UTC 로 세서 한국 자정 전후에 「이어갈 수 없다」나
  /// `max_fragments` 가 최대 9시간 어긋난다(서버 1c83fd9 프론트 조치 목록 🔴1 · 달력 · WS start 와 같은 값).
  Future<Map<String, dynamic>?> getResumeStatus(
    int callId, {
    String? planOverride,
    Map<String, Object> tzParams = const {},
  }) async {
    final query = <String, dynamic>{
      'plan_override': ?planOverride,
      ...tzParams,
    };
    final res = await _dio.get<Map<String, dynamic>>(
      '/calls/$callId/resume-status',
      queryParameters: query.isEmpty ? null : query,
    );
    return res.data;
  }

  /// `GET /api/v1/stats/calendar?start=&end=&tz=&tz_offset_min=` — 학습 달력 집계.
  ///
  /// 서버 `premium` 브랜치(09-23) §7 신규. 구서버는 404 — 리포지토리가 null 로 눕힌다.
  /// [start]·[end] 는 현지 날짜 `YYYY-MM-DD`(양끝 포함). [tzParams] 는 [DeviceTimezone.params].
  Future<Map<String, dynamic>?> getCalendarStats({
    required String start,
    required String end,
    required Map<String, Object> tzParams,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/stats/calendar',
      queryParameters: <String, dynamic>{'start': start, 'end': end, ...tzParams},
    );
    return res.data;
  }

  /// `GET /calls/daily-status?date=&tz=&tz_offset=` — 오늘 남은 예산(서버 `premium` §5).
  ///
  /// 서버 dev `routers/call.py` `get_daily_status(date: str, tz_offset: int = 0, tz: str | None)`:
  /// - `date` 는 **필수**(기기 로컬 오늘 `YYYY-MM-DD`). 빠지면 422 다(09-24 실기기 — 한때
  ///   「보내지 않는다」 로 거꾸로 읽어 Free 카드 행이 늘 숨었다). ⛔ 오늘 날짜로만 묻는다 —
  ///   `can_call_*` 는 서버의 「지금」 을 보므로 과거 날짜와 뜻이 갈린다.
  /// - 오프셋 이름은 `tz_offset` 이다(달력·WS 의 `tz_offset_min` 과 **이름이 다르다**).
  Future<Map<String, dynamic>?> getDailyStatus({
    required String date,
    String? tz,
    required int tzOffsetMin,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/calls/daily-status',
      queryParameters: <String, dynamic>{
        'date': date,
        'tz': ?tz,
        'tz_offset': tzOffsetMin,
      },
    );
    return res.data;
  }

  /// `GET /calls/{call_id}/result`.
  Future<CallResultDto> getResult(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId/result');
    return CallResultDto.fromJson(res.data!);
  }

  /// `GET /calls/{call_id}/pronunciation-report` — 복습 종료 발음 리포트.
  Future<LearningSummary> getPronunciationReport(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/calls/$callId/pronunciation-report',
    );
    return LearningSummary.fromJson(res.data!);
  }

  /// `GET /calls/pronunciation-summary?sessions=` — 최근 N세션 발음 평균.
  ///
  /// 정적 경로라 서버가 `/{call_id}` 보다 먼저 선언한다. 여기서도 문자열을 직접
  /// 조립하지 말고 [ApiEndpoints] 상수를 쓴다.
  Future<PronSummary> getPronunciationSummary({int sessions = 10}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.callsPronunciationSummary,
      queryParameters: {'sessions': sessions},
    );
    return PronSummary.fromJson(res.data ?? const {});
  }

  /// `GET /cur/me` — 내 커리큘럼 위치(현재 차시·진도·`auto` 가 정할 코스).
  Future<CurMe> getCurMe() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.curMe);
    return CurMe.fromJson(res.data ?? const {});
  }

  /// `POST /__dev/cur-reset` — 내 커리큘럼 2단계 진도 백지화(dev 도구).
  ///
  /// ⚠ **루트 경로**다. `/api/v1` 아래가 아니라 `Env.apiRootUrl` 로 절대 URL 을 만들어
  /// 보낸다(dio 는 절대 URL 이면 baseUrl 을 무시한다). body `{}` = 본인·차시 1.
  Future<CurResetResult> resetCurriculum() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '${Env.apiRootUrl}${ApiEndpoints.devCurReset}',
      data: const <String, dynamic>{},
    );
    return CurResetResult.fromJson(res.data ?? const {});
  }

  /// `GET /calls/{call_id}` — call detail. The `/result` endpoint omits
  /// `call_date`/`total_time`, so we read them here (the CallDetail body is a
  /// superset of CallSummary; extra fields like `sentences` are ignored).
  Future<CallSummaryDto> getCall(int callId) async {
    final res = await _dio.get<Map<String, dynamic>>('/calls/$callId');
    return CallSummaryDto.fromJson(res.data!);
  }

  /// `GET /calls?limit=&offset=` — past calls, newest first.
  Future<List<CallSummaryDto>> listCalls({int? limit, int? offset}) async {
    final res = await _dio.get<List<dynamic>>(
      '/calls',
      queryParameters: {
        'limit': ?limit,
        'offset': ?offset,
      },
    );
    final data = res.data ?? const [];
    return data
        .map((e) => CallSummaryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
