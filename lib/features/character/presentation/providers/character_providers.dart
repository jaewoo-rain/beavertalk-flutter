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
/// Only worth fetching for `active_discount` — the discount window
/// (`discount_price` / `start_time` / `end_time`) is the single field
/// `CharacterDetail` adds over `CharacterSummary`.
///
/// Do NOT reach for this to get `description`, `voice_url` or `tags`: the list
/// response already carries all three. The server puts them on
/// `CharacterSummary` deliberately ("캐릭터당 상세조회 N+1 회피" in its schema
/// docstring), and an earlier revision of the avatar sheet fetched detail on
/// every open for a description it already had.
///
/// autoDispose: a screen-scoped read, not app state.
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
  return ref.watch(characterByIdProvider(characterId));
});

/// 카탈로그에서 [characterId] 를 찾는다. 못 찾거나(아직 로딩 중) id 가 null 이면
/// null — 호출부는 정적 기본값으로 폴백한다.
///
/// [selectedCharacterProvider] 와 갈라놓은 이유: **통화 상대가 대표 캐릭터가 아닐
/// 수 있다.** 예약전화는 알람마다 캐릭터를 따로 고르므로, 서버가 `call_started` 로
/// 알려준 캐릭터로 화면을 그려야 대화 상대와 얼굴이 맞는다.
final characterByIdProvider = Provider.family<Character?, int?>((ref, id) {
  if (id == null) return null;
  final catalog = ref.watch(charactersProvider).valueOrNull;
  if (catalog == null) return null;
  for (final c in catalog) {
    if (c.id == id) return c;
  }
  return null;
});
