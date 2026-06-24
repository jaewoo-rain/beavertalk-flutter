import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
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

/// Selectable alarm partners (`GET /characters`), read-only for this slice.
/// Consume with `AsyncValue.when`; defaults to the first character.
final availableCharactersProvider =
    FutureProvider<List<AlarmCharacter>>((ref) async {
  final repo = ref.watch(alarmRepositoryProvider);
  return repo.listCharacters();
});
