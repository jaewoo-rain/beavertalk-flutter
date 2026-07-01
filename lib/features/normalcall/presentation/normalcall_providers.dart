import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/datasources/normalcall_remote_data_source.dart';
import '../data/repositories/normalcall_repository_impl.dart';
import '../domain/entities/call_result.dart';
import '../domain/repositories/normalcall_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final normalcallRemoteDataSourceProvider =
    Provider<NormalcallRemoteDataSource>((ref) {
  return NormalcallRemoteDataSource(ref.watch(dioProvider));
});

/// Normalcall analysis repository (domain interface) backed by the remote
/// data source.
final normalcallRepositoryProvider = Provider<NormalcallRepository>((ref) {
  return NormalcallRepositoryImpl(
    remote: ref.watch(normalcallRemoteDataSourceProvider),
  );
});

/// Past calls for the record list (`GET /calls`). Auto-disposes so re-entering
/// the screen refetches; `ref.invalidate` drives pull-to-retry.
final callListProvider =
    FutureProvider.autoDispose<List<CallSummary>>((ref) async {
  return ref.watch(normalcallRepositoryProvider).listCalls();
});
