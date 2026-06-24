import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';
import '../models/member_dto.dart';
import '../models/token_dto.dart';

/// Talks to the auth endpoints over dio. Encapsulates the transport details
/// (login is form-urlencoded, everything else is JSON) and returns DTOs.
///
/// Dio errors are thrown as-is here; the repository maps them to
/// [AppException].
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// `POST /auth/login` — OAuth2 form body (`username`=email, `password`).
  /// `skipAuth` so the (absent) Bearer header isn't attached.
  Future<TokenDto> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'username': email, 'password': password},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: {AuthInterceptor.skipAuthKey: true},
      ),
    );
    return TokenDto.fromJson(res.data!);
  }

  /// `POST /auth/signup` — JSON body, returns the created member.
  Future<MemberDto> signup({
    required String email,
    required String password,
    String? language,
    String? loginMethod,
    String? uniqueValue,
    int? speakCountryId,
    int? characterId,
  }) async {
    // Only send optional fields when present.
    final body = <String, dynamic>{'email': email, 'password': password};
    if (language != null) body['language'] = language;
    if (loginMethod != null) body['login_method'] = loginMethod;
    if (uniqueValue != null) body['unique_value'] = uniqueValue;
    if (speakCountryId != null) body['speak_country_id'] = speakCountryId;
    if (characterId != null) body['character_id'] = characterId;
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.signup,
      data: body,
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return MemberDto.fromJson(res.data!);
  }

  /// `POST /auth/social` — JSON `{login_method, token}`.
  Future<TokenDto> socialLogin({
    required String loginMethod,
    required String token,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.social,
      data: {'login_method': loginMethod, 'token': token},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return TokenDto.fromJson(res.data!);
  }

  /// `POST /auth/password-reset/request` — returns the server `message`.
  Future<String> requestPasswordReset({required String email}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.passwordResetRequest,
      data: {'email': email},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return (res.data?['message'] as String?) ?? '';
  }

  /// `POST /auth/password-reset/confirm` — returns the server `message`.
  Future<String> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.passwordResetConfirm,
      data: {'token': token, 'new_password': newPassword},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return (res.data?['message'] as String?) ?? '';
  }

  /// `GET /members/me` — Bearer-protected, returns the current member.
  Future<MemberDto> getMe() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.membersMe);
    return MemberDto.fromJson(res.data!);
  }
}
