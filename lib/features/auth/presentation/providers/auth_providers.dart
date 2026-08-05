import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

/// How the member signed in — `email` · `google` · `kakao` · `apple`.
///
/// Read from the Supabase session, **not** from the API: `MemberRead` has no
/// `login_method` column, so the client DTO's field is always null. That is
/// why the Account card's Login Method row rendered empty and got skipped.
///
/// Null when there is no session, and in widget tests where Supabase was
/// never initialized — override this provider to pin a value.
final signInProviderProvider = Provider<String?>((ref) {
  try {
    final meta = Supabase.instance.client.auth.currentUser?.appMetadata;
    return meta?['provider'] as String?;
  } catch (_) {
    return null;
  }
});
