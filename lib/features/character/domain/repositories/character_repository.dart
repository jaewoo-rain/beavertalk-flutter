import '../entities/character.dart';

/// Character capabilities. Implemented in the data layer.
///
/// Returns entities and throws [AppException]
/// (see `core/error/app_exception.dart`) on failure. No dio/JSON leaks here.
abstract interface class CharacterRepository {
  /// `GET /characters` — the full catalog (with `is_owned` per member).
  Future<List<Character>> listCharacters();

  /// `GET /characters/{id}` — a single character with detail fields.
  Future<Character> getDetail(int id);

  /// `GET /members/me/characters` — characters the member owns.
  Future<List<OwnedCharacter>> listOwned();

  /// `POST /characters/{id}/purchase` — buys [id] for the current member.
  ///
  /// The amount is **not** sent: the server prices it from the active discount
  /// window, so a stale client price can't be used to underpay. [cardInfo] is an
  /// opaque masked string recorded on the payment row.
  ///
  /// Throws `ConflictFailure` when already owned (409 `ALREADY_OWNED` — the
  /// server's only semantic error code), `NotFoundFailure` for an unknown id.
  /// There is no insufficient-funds case: the server has no wallet and calls no
  /// payment gateway, so a purchase never fails for lack of money.
  /// [expectedPriceMinor] 는 화면에 보여준 가격(센트). 서버 계산가와 다르면
  /// [PriceChangedFailure] 가 난다 — 할인 종료 직후의 금액 불일치 방지.
  Future<PurchaseResult> purchase(
    int id, {
    String? cardInfo,
    int? expectedPriceMinor,
  });
}
