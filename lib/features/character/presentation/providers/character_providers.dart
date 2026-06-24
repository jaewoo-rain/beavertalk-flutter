import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
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
