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

/// Selectable alarm partners — every character the member can **use right now**
/// (`GET /characters` filtered by `is_unlocked`). Consume with `AsyncValue.when`.
///
/// 기준이 소유가 아니라 **접근**이다. 예약 전화도 Max 혜택에 포함된다(사장님 결정,
/// 2026-08-06). 서버는 이미 그렇게 동작한다 — 예약 전화가 실제로 걸릴 때
/// `MemberCharacter` 행이 없어도 구독만으로 통과시킨다
/// (`learning/service/normalcall_service.py:155-160`). 앱만 막고 있었다.
///
/// ⛔ 보유 목록(`ownedCharactersProvider` = `GET /members/me/characters`)으로는
/// 만들 수 없다. 그 응답에는 `is_unlocked` 가 **아예 없다** — 서버가 "보유 = 구매한
/// 것"으로 못 박았고, 구독으로 열린 캐릭터는 카탈로그 응답에만 나타난다. 그래서
/// 출처를 카탈로그로 옮겼다.
///
/// 무료·Pro 회원은 구독이 아무것도 열지 않아 `is_unlocked == is_owned` 이므로,
/// 종전과 똑같이 **산 캐릭터만** 보인다.
///
/// 화면(`alarm_add.dart`)은 이 목록이 비면 빈 상태를 그린다 — 아무것도 못 쓰는
/// 회원에게 맞는 결과다.
final availableCharactersProvider =
    FutureProvider<List<AlarmCharacter>>((ref) async {
  final catalog = await ref.watch(charactersProvider.future);
  return [
    for (final c in catalog.where((c) => c.isUnlocked))
      AlarmCharacter(
        characterId: c.id,
        name: c.name,
        imageUrl: c.imageUrl,
      ),
  ];
});
