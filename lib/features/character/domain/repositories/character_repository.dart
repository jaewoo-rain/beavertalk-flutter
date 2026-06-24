import '../entities/character.dart';

/// Character read capabilities. Implemented in the data layer.
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
}
