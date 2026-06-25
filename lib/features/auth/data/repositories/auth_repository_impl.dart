import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Seam between data and domain for the member endpoints: converts DTOs to
/// entities and maps [DioException] to [AppException]. Auth tokens are owned by
/// the Supabase SDK, so there is no token persistence here anymore.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remote}) : _remote = remote;

  final AuthRemoteDataSource _remote;

  @override
  Future<Member> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  }) async {
    try {
      final dto = await _remote.submitOnboarding(
        name: name,
        language: language,
        reasons: reasons,
      );
      return dto.toEntity();
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
