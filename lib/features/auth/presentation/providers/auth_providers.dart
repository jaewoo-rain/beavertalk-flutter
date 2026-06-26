import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

/// Member repository (domain interface) backed by the remote data source.
///
/// To swap in a fake for tests, override this provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
  );
});
