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
  /// 가격은 여전히 **서버가 정한다**. [expectedPriceMinor] 는 값을 정하려는 게 아니라
  /// "사용자에게 이 가격을 보여줬다"는 신고다 — 한정 할인이 탭하는 사이 끝나면 서버가
  /// 대조해 409(PRICE_CHANGED)로 거절하므로, 동의하지 않은 금액이 결제되지 않는다.
  /// 안 보내면 서버는 검사를 건너뛴다(옛 동작).
  Future<PurchaseResponseDto> purchase(
    int id, {
    String? cardInfo,
    int? expectedPriceMinor,
  }) async {
    final body = <String, dynamic>{
      'card_info': ?cardInfo,
      // 서버는 Decimal 문자열을 기대한다(센트 → "5.00").
      if (expectedPriceMinor != null)
        'expected_price': (expectedPriceMinor / 100).toStringAsFixed(2),
    };
    final res = await _dio.post<Map<String, dynamic>>(
      '/characters/$id/purchase',
      data: body.isEmpty ? null : body,
    );
    return PurchaseResponseDto.fromJson(res.data!);
  }
}
