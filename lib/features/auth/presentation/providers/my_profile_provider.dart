import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/accent_breakdown.dart';
import '../../domain/entities/level_summary.dart';
import '../../domain/entities/member.dart';
import 'auth_providers.dart';

/// The current member (`GET /members/me`). Consume with `AsyncValue` to render
/// loading/error/data. `ref.invalidate(myProfileProvider)` to refetch.
final myProfileProvider = FutureProvider<Member>((ref) async {
  // 세션이 없으면 **네트워크를 타지 않는다.** 로그아웃 경로가
  // `_clearUserScopedState()` 에서 이 provider 를 invalidate 하는데, 그 시점엔
  // Supabase 세션이 이미 지워진 뒤라 AuthGate 가 아직 붙어 있는 동안 토큰 없는
  // `GET /members/me` 가 나가 401 을 받아 왔다. autoDispose 가 아니라 그 401 이
  // 앱 전역에 캐시로 남고, 인터셉터는 실패할 게 뻔한 `refreshSession()` 까지
  // 왕복했다. 여기서 끊는다 — alarm_list_controller 의 동일한 가드와 같은 이유다.
  if (Supabase.instance.client.auth.currentSession == null) {
    throw const UnauthorizedFailure('로그인이 필요해요');
  }
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
