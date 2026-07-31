import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/accent_breakdown.dart';
import '../../domain/entities/level_summary.dart';
import '../../domain/entities/member.dart';
import 'auth_providers.dart';

/// The current member (`GET /members/me`). Consume with `AsyncValue.when` to
/// render loading/error/data. `ref.invalidate(myProfileProvider)` to refetch.
final myProfileProvider = FutureProvider<Member>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getMe();
});

/// The member's accent (nationality) breakdown (`GET /members/me/profile` →
/// `speak_country`). Empty when the member hasn't been classified yet.
/// `ref.invalidate(myAccentProvider)` to refetch (e.g. after a call analyzes it).
final myAccentProvider = FutureProvider<AccentBreakdown>((ref) async {
  return ref.watch(authRepositoryProvider).getMyAccent();
});

/// 종합 레벨 카드 데이터(`GET /members/me/profile`).
///
/// 레벨테스트를 다시 받은 뒤에는 `ref.invalidate(myLevelProvider)` 로 새로 읽어야
/// 카드가 "레벨테스트 필요" 상태로 돌아간다.
final myLevelProvider = FutureProvider<LevelSummary>((ref) async {
  return ref.watch(authRepositoryProvider).getMyLevel();
});
