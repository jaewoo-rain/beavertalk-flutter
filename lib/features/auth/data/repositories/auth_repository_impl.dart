import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/storage/token_store.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Seam between data and domain: converts DTOs to entities, maps
/// [DioException] to [AppException], and persists the token after auth.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStore tokenStore,
  })  : _remote = remote,
        _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final TokenStore _tokenStore;

  @override
  Future<AuthToken> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _remote.login(email: email, password: password);
      await _tokenStore.save(dto.accessToken);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Member> signup({
    required String email,
    required String password,
    String? language,
    String? loginMethod,
    String? uniqueValue,
    int? speakCountryId,
    int? characterId,
  }) async {
    try {
      final dto = await _remote.signup(
        email: email,
        password: password,
        language: language,
        loginMethod: loginMethod,
        uniqueValue: uniqueValue,
        speakCountryId: speakCountryId,
        characterId: characterId,
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AuthToken> socialLogin({
    required String loginMethod,
    required String token,
  }) async {
    try {
      final dto = await _remote.socialLogin(
        loginMethod: loginMethod,
        token: token,
      );
      await _tokenStore.save(dto.accessToken);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<String> requestPasswordReset({required String email}) async {
    try {
      return await _remote.requestPasswordReset(email: email);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<String> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _remote.confirmPasswordReset(
        token: token,
        newPassword: newPassword,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Member> getMe() async {
    try {
      final dto = await _remote.getMe();
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
