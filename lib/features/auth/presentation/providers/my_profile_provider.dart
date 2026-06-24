import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/member.dart';
import 'auth_providers.dart';

/// The current member (`GET /members/me`). Consume with `AsyncValue.when` to
/// render loading/error/data. `ref.invalidate(myProfileProvider)` to refetch.
final myProfileProvider = FutureProvider<Member>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getMe();
});
