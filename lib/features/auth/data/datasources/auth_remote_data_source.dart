import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
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
}
