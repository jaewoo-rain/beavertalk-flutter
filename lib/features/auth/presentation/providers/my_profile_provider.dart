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
/// **autoDispose 다** — 마이페이지를 벗어나면 버리고, 들어올 때마다 서버에서 새로
/// 읽는다. 레벨은 통화(레벨테스트·자동 레벨업) 결과로 **앱 밖에서** 바뀌는 값이라,
/// 한 번 받아 캐시해 두면 앱을 껐다 켤 때까지 옛 레벨이 남는다(실제로 그랬다).
///
/// 통화 종료 시점에 무효화하지 않는 이유: 판정이 서버 백그라운드에서 **13~21초** 걸린다
/// (실측). 끝나자마자 다시 읽으면 아직 옛 값이라 헛수고다. 화면에 들어올 때 읽는 편이
/// 타이밍을 맞출 필요가 없어 확실하다 — 너무 빨리 들어왔으면 한 번 더 들어오면 된다.
final myLevelProvider = FutureProvider.autoDispose<LevelSummary>((ref) async {
  return ref.watch(authRepositoryProvider).getMyLevel();
});
