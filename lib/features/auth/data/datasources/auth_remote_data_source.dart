import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/accent_breakdown.dart';
import '../../domain/entities/level_summary.dart';
import '../models/member_dto.dart';

/// Talks to the member endpoints over dio. Auth itself (login/signup/etc.) now
/// goes through the Supabase SDK in [AuthController]; the only backend calls
/// left here are the Bearer-protected member endpoints.
///
/// The interceptor attaches the Supabase access token as the Bearer header.
/// Dio errors are thrown as-is; the repository maps them to [AppException].
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// `POST /members/me/onboarding` (Bearer) — saves onboarding data and marks
  /// `onboarding_completed=true`. Only sends fields that are provided.
  Future<MemberDto> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (language != null) body['language'] = language;
    if (reasons != null) body['reasons'] = reasons;
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.onboarding,
      data: body,
    );
    return MemberDto.fromJson(res.data!);
  }

  /// `GET /members/me` — Bearer-protected, returns the current member.
  /// On first call for a new Supabase user the backend find-or-creates them.
  Future<MemberDto> getMe() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.membersMe);
    return MemberDto.fromJson(res.data!);
  }

  /// `GET /members/me/profile` (Bearer) — MyPageOut. Here we only take the
  /// `speak_country` accent breakdown (1·2·3순위 국가 + %). Empty when the member
  /// has no classification yet.
  Future<AccentBreakdown> getMyAccent() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.membersMeProfile,
    );
    final sc = res.data?['speak_country'] as Map<String, dynamic>?;
    if (sc == null) return const AccentBreakdown([]);
    final stats = <AccentStat>[];
    void add(String countryKey, String percentKey) {
      final country = sc[countryKey] as String?;
      final percent = sc[percentKey];
      if (country != null && country.isNotEmpty && percent is num) {
        stats.add(AccentStat(label: country, percent: percent.toInt()));
      }
    }

    add('first_country', 'first_percent');
    add('second_country', 'second_percent');
    add('third_country', 'third_percent');
    return AccentBreakdown(stats);
  }

  /// `GET /members/me/profile` → 종합 레벨 카드 데이터.
  ///
  /// [getMyAccent] 와 **같은 응답**을 쓴다. 호출을 나누지 않고 provider 쪽에서 한 번
  /// 받아 둘로 쪼개므로(myPageProfileProvider) 화면당 요청은 1회다.
  Future<LevelSummary> getMyLevel() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.membersMeProfile,
    );
    return LevelSummary.fromJson(res.data ?? const {});
  }

  /// `POST /members/me/level-test/retake` — 레벨 배정만 지운다(체크판 보존).
  ///
  /// 성공해도 **통화가 열린다는 보장은 아니다.** 하루 1회 제한은 통화 시작 시점에
  /// 서버가 검사하므로, 오늘 이미 레벨테스트를 했다면 이 호출은 200 이지만 다음
  /// 통화가 DAILY_LIMIT 로 거절된다.
  Future<void> retakeLevelTest() async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.membersMeLevelTestRetake,
    );
  }

  /// `DELETE /members/me` (Bearer) — deletes the current member on the backend.
  Future<void> deleteAccount() async {
    await _dio.delete<void>(ApiEndpoints.membersMe);
  }

  /// `PATCH /members/me` (Bearer) — partial update; here the UI [language] code.
  Future<MemberDto> updateLanguage(String language) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.membersMe,
      data: {'language': language},
    );
    return MemberDto.fromJson(res.data!);
  }

  /// `PATCH /members/me` (Bearer) — the language the member is **learning**
  /// (server `target_language`). This is the single source for the call's
  /// target language; the call socket no longer sends it.
  Future<MemberDto> updateTargetLanguage(String targetLanguage) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.membersMe,
      data: {'target_language': targetLanguage},
    );
    return MemberDto.fromJson(res.data!);
  }

  /// `PATCH /members/me` (Bearer) — sets the in-use call partner.
  ///
  /// `MemberUpdate` accepts `language`, `character_id` and `is_auto_payment`,
  /// all optional; sending only `character_id` leaves the rest untouched.
  Future<MemberDto> updateCharacter(int characterId) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.membersMe,
      data: {'character_id': characterId},
    );
    return MemberDto.fromJson(res.data!);
  }
}
