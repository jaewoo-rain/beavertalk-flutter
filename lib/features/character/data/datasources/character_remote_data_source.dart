import 'package:dio/dio.dart';

import '../models/character_dto.dart';

/// Talks to the character + owned-character endpoints over dio. Returns DTOs;
/// dio errors propagate to the repository which maps them to [AppException].
class CharacterRemoteDataSource {
  CharacterRemoteDataSource(this._dio);

  final Dio _dio;

  /// `GET /characters`.
  Future<List<CharacterDto>> listCharacters() async {
    final res = await _dio.get<List<dynamic>>('/characters');
    final data = res.data ?? const [];
    return data
        .map((e) => CharacterDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `GET /characters/{id}`.
  Future<CharacterDto> getDetail(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/characters/$id');
    return CharacterDto.fromJson(res.data!);
  }

  /// `GET /members/me/characters`.
  Future<List<OwnedCharacterDto>> listOwned() async {
    final res = await _dio.get<List<dynamic>>('/members/me/characters');
    final data = res.data ?? const [];
    return data
        .map((e) => OwnedCharacterDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /characters/{id}/purchase` → 201.
  ///
  /// The body is optional server-side; only `card_info` is accepted and the
  /// price is never sent — the server prices the purchase itself.
  Future<PurchaseResponseDto> purchase(int id, {String? cardInfo}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/characters/$id/purchase',
      data: cardInfo == null ? null : {'card_info': cardInfo},
    );
    return PurchaseResponseDto.fromJson(res.data!);
  }
}
