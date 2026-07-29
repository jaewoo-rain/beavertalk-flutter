import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_data_source.dart';

/// Seam between data and domain: DTO↔entity conversion and
/// [DioException]→[AppException] mapping.
class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({required CharacterRemoteDataSource remote})
      : _remote = remote;

  final CharacterRemoteDataSource _remote;

  @override
  Future<List<Character>> listCharacters() async {
    try {
      final dtos = await _remote.listCharacters();
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Character> getDetail(int id) async {
    try {
      final dto = await _remote.getDetail(id);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<PurchaseResult> purchase(
    int id, {
    String? cardInfo,
    int? expectedPriceMinor,
  }) async {
    try {
      final dto = await _remote.purchase(
        id, cardInfo: cardInfo, expectedPriceMinor: expectedPriceMinor);
      return dto.toEntity();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<OwnedCharacter>> listOwned() async {
    try {
      final dtos = await _remote.listOwned();
      return dtos.map((d) => d.toEntity()).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
