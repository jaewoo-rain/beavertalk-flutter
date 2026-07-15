import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/my_profile_provider.dart';
import '../../data/datasources/character_remote_data_source.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final characterRemoteDataSourceProvider =
    Provider<CharacterRemoteDataSource>((ref) {
  return CharacterRemoteDataSource(ref.watch(dioProvider));
});

/// Character repository (domain interface) backed by the remote data source.
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepositoryImpl(
    remote: ref.watch(characterRemoteDataSourceProvider),
  );
});

/// Full character catalog (`GET /characters`). Consume with `AsyncValue.when`.
final charactersProvider = FutureProvider<List<Character>>((ref) async {
  return ref.watch(characterRepositoryProvider).listCharacters();
});

/// Characters the member owns (`GET /members/me/characters`).
final ownedCharactersProvider =
    FutureProvider<List<OwnedCharacter>>((ref) async {
  return ref.watch(characterRepositoryProvider).listOwned();
});

/// One character's detail (`GET /characters/{id}`), keyed by id.
///
/// [Character.description] only comes from this endpoint — the list at
/// [charactersProvider] leaves it null. The avatar sheet shows a description
/// paragraph (Figma v2 `3360:20576`), so it has to fetch the detail on open;
/// without this provider there was no way to reach `getDetail`, and the
/// paragraph silently never rendered.
///
/// autoDispose: a sheet-scoped read, not app state.
final characterDetailProvider =
    FutureProvider.autoDispose.family<Character, int>((ref, id) async {
  return ref.watch(characterRepositoryProvider).getDetail(id);
});

/// The member's currently in-use ("representative") character, resolved from
/// the catalog by `members/me.character_id`. Returns null while the profile or
/// catalog is still loading, or when the id has no catalog match — callers then
/// fall back to a static default. This is the source of truth for the home /
/// call partner name + avatar (never a hardcoded id→name guess).
final selectedCharacterProvider = Provider<Character?>((ref) {
  final characterId = ref.watch(myProfileProvider).valueOrNull?.characterId;
  if (characterId == null) return null;
  final catalog = ref.watch(charactersProvider).valueOrNull;
  if (catalog == null) return null;
  for (final c in catalog) {
    if (c.id == characterId) return c;
  }
  return null;
});
