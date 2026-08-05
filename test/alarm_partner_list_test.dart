import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/alarm/presentation/providers/alarm_providers.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';

/// 예약 전화(알람)의 "통화 상대" 목록.
///
/// 기준이 소유가 아니라 **접근**이다 — 예약 전화도 Max 혜택에 포함된다(사장님 결정,
/// 2026-08-06). 서버는 원래 그렇게 동작했고(`normalcall_service.py:155-160` — 소유
/// 행이 없어도 구독이면 통과), 앱만 막고 있었다.
///
/// ⛔ 보유 목록 API 로는 못 만든다: 그 응답에는 `is_unlocked` 가 아예 없다. 그래서
/// 출처가 카탈로그로 옮겨졌고, 이 파일이 그 기준을 못박는다.
void main() {
  Character character(
    int id,
    String name, {
    bool owned = false,
    bool? unlocked,
    String? source,
  }) =>
      CharacterDto.fromJson({
        'character_id': id,
        'name': name,
        'price': '10.00',
        'effective_price': '10.00',
        'is_owned': owned,
        // null 이면 키 자체가 빠진다 — 구버전 서버 응답이 그 모양이다.
        'is_unlocked': ?unlocked,
        'unlock_source': ?source,
      }).toEntity();

  Future<List<String>> partners(List<Character> catalog) async {
    final container = ProviderContainer(overrides: [
      charactersProvider.overrideWith((ref) async => catalog),
    ]);
    addTearDown(container.dispose);
    final list = await container.read(availableCharactersProvider.future);
    return [for (final c in list) c.name];
  }

  test('Max 회원은 구독으로 열린 캐릭터로도 예약할 수 있다', () async {
    final names = await partners([
      character(1, 'BABA', owned: true, unlocked: true, source: 'owned'),
      character(2, 'BIBI', unlocked: true, source: 'subscription'),
      character(3, 'JUDI', unlocked: true, source: 'subscription'),
    ]);

    // 고칠 때까지는 여기에 BABA 하나만 나왔다 — 대부분 회원은 가입 때 받은 무료
    // 캐릭터 하나뿐이라, Max 인데도 예약 상대가 사실상 고정이었다.
    expect(names, ['BABA', 'BIBI', 'JUDI']);
  });

  test('무료·Pro 회원은 종전대로 산 캐릭터만 보인다', () async {
    final names = await partners([
      character(1, 'BABA', owned: true, unlocked: true, source: 'owned'),
      character(2, 'BIBI', unlocked: false),
      character(3, 'JUDI', unlocked: false),
    ]);

    expect(names, ['BABA']);
  });

  test('구버전 서버 응답에서도 산 캐릭터만 보인다 (폴백)', () async {
    // prod 가 새 필드를 안 보내던 시절의 응답. 없으면 소유값으로 떨어지므로 결과가
    // 종전과 같아야 한다 — 크래시도, 잠긴 캐릭터 노출도 없다.
    final names = await partners([
      character(1, 'BABA', owned: true),
      character(2, 'BIBI'),
    ]);

    expect(names, ['BABA']);
  });

  test('아무것도 못 쓰는 회원은 빈 목록이다', () async {
    // 화면(alarm_add.dart)이 빈 상태를 그린다. 여기서 잠긴 캐릭터를 흘리면 예약은
    // 되는데 통화가 서버에서 거절되는 상태가 만들어진다.
    final names = await partners([character(2, 'BIBI', unlocked: false)]);

    expect(names, isEmpty);
  });
}
