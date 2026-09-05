// 통화 결과의 「이번 통화에서 쓴 표현」 — `used_items` 파싱.
//
// ⭐ 왜 생겼나(2026-09-04). 「새로 배운 표현」은 물어봤거나 고쳐 받았거나 따라 말한
//   것만 센다(서버 분석 지시문이 그렇게 정의한다). 자유대화를 매끄럽게 하면 셋 다
//   해당이 없어 결과 화면이 통째로 비었다 — 대화를 **잘할수록** 빈다.
//   서버 체크판은 그때도 항목을 잡아 두고 있었다.

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/data/models/call_result_dto.dart';

Map<String, dynamic> _json(Object? usedItems) => {
  'call_id': 1,
  'average': const <String, dynamic>{},
  'sentences': const <dynamic>[],
  if (usedItems != null) 'used_items': usedItems,
};

void main() {
  test('쓴 표현을 읽는다 — 표면형과 학습자 인용', () {
    final r = CallResultDto.fromJson(
      _json([
        {'item_id': 464, 'surface': '가다', 'quote': '오늘 학교에 갔어요.'},
        {'item_id': 1056, 'surface': '좋다', 'quote': '어 좋아해?'},
      ]),
    ).toEntity();

    expect(r.usedItems.map((e) => e.surface).toList(), ['가다', '좋다']);
    expect(r.usedItems.first.quote, '오늘 학교에 갔어요.');
    expect(r.usedItems.first.itemId, 464);
  });

  test('서버가 안 보내면 빈 목록이다 — 화면이 섹션을 안 그린다', () {
    expect(CallResultDto.fromJson(_json(null)).toEntity().usedItems, isEmpty);
  });

  test('인용이 없거나 빈 문자열이면 null 이다 — 지어내지 않는다', () {
    final r = CallResultDto.fromJson(
      _json([
        {'item_id': 1, 'surface': '가다'},
        {'item_id': 2, 'surface': '좋다', 'quote': '   '},
      ]),
    ).toEntity();

    expect(r.usedItems.map((e) => e.quote).toList(), [null, null]);
  });

  test('모양이 어긋난 원소는 버리되 나머지는 살린다', () {
    // 🔴 한 줄 때문에 결과 화면 전체가 안 뜨면 안 된다.
    final r = CallResultDto.fromJson(
      _json([
        'not a map',
        {'surface': '표면형만'},          // id 없음
        {'item_id': 3},                   // 표면형 없음
        {'item_id': 4, 'surface': '집', 'quote': '집에 가요.'},
      ]),
    ).toEntity();

    expect(r.usedItems.length, 1);
    expect(r.usedItems.single.surface, '집');
  });
}
