import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../character/presentation/providers/character_providers.dart';
import '../../data/datasources/alarm_remote_data_source.dart';
import '../../data/repositories/alarm_repository_impl.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final alarmRemoteDataSourceProvider = Provider<AlarmRemoteDataSource>((ref) {
  return AlarmRemoteDataSource(ref.watch(dioProvider));
});

/// Alarm repository (domain interface) backed by the remote data source.
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl(
    remote: ref.watch(alarmRemoteDataSourceProvider),
  );
});

/// Selectable alarm partners — the characters the member actually **owns**
/// (`GET /members/me/characters`). Consume with `AsyncValue.when`.
///
/// This used to call `GET /characters` (the whole catalog) via
/// `alarmRepository.listCharacters()`, so the alarm picker offered characters
/// the user had not bought — scheduling a call with a partner they cannot use.
/// Owned-only is the requirement, and `ownedCharactersProvider` is exactly that
/// list, so it feeds the picker directly instead of fetching the catalog and
/// filtering it (one request instead of two).
///
/// [OwnedCharacter] maps field-for-field onto [AlarmCharacter]
/// (`id`→`characterId`, `name`, `imageUrl`); the extra purchase fields are not
/// needed here. The alarm screen already renders an empty state when this is
/// empty (`alarm_add.dart`), which is the correct result for a member who owns
/// nothing.
final availableCharactersProvider =
    FutureProvider<List<AlarmCharacter>>((ref) async {
  final owned = await ref.watch(ownedCharactersProvider.future);
  return [
    for (final c in owned)
      AlarmCharacter(
        characterId: c.id,
        name: c.name,
        imageUrl: c.imageUrl,
      ),
  ];
});
