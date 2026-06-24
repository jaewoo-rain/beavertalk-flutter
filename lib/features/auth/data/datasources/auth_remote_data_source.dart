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

  /// `GET /auth/email/available?email=` — true when the email is free to use.
  Future<bool> checkEmailAvailable(String email) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.emailAvailable,
      queryParameters: {'email': email},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return res.data?['available'] as bool? ?? false;
  }

  /// `POST /auth/email/send-code {email}` — sends a verification code (the dev
  /// stub prints it to the server console). Throws on 4xx.
  Future<void> sendEmailCode(String email) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.emailSendCode,
      data: {'email': email},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
  }

  /// `POST /auth/email/verify-code {email, code}` — throws on a wrong code.
  Future<void> verifyEmailCode(String email, String code) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.emailVerifyCode,
      data: {'email': email, 'code': code},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
  }

  /// `POST /auth/signup` — JSON body `{email, password}`, returns the created
  /// member. Onboarding data (name/language/reasons) is sent separately via
  /// [submitOnboarding] after login.
  Future<MemberDto> signup({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.signup,
      data: {'email': email, 'password': password},
      options: Options(extra: {AuthInterceptor.skipAuthKey: true}),
    );
    return MemberDto.fromJson(res.data!);
  }

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

  /// `POST /auth/password-reset/confirm {email, code, new_password}` —
  /// the server validates the code and sets the new password together.
  Future<String> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.passwordResetConfirm,
      data: {'email': email, 'code': code, 'new_password': newPassword},
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
