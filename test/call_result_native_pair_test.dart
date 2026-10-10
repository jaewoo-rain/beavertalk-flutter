import 'package:beavertalk/features/normalcall/data/models/call_result_dto.dart';
import 'package:flutter_test/flutter_test.dart';

/// 서버 `premium` 브랜치(09-23) §6 — 결과 문장에 현지인 표현 짝이 붙는다.
///
/// 기본 문장에는 `kind`·`paired_sentence_id`·`nuance` 키가 **아예 없고**, 짝은
/// `kind: "native"` 로 기본 바로 뒤에 온다. 3개를 배우면 6개가 온다.
void main() {
  Map<String, dynamic> result(List<Map<String, dynamic>> sentences) => {
        'call_id': 1,
        'average': <String, dynamic>{},
        'sentences': sentences,
      };

  final newServer = result([
    {'sentence_id': 10, 'korean_sentence': '배고파요'},
    {
      'sentence_id': 11,
      'korean_sentence': '뱃가죽이 등에 붙을 것 같아요',
      'kind': 'native',
      'paired_sentence_id': 10,
      'nuance': 'Very hungry, playful',
    },
    {'sentence_id': 12, 'korean_sentence': '안녕하세요'},
    {
      'sentence_id': 13,
      'korean_sentence': '안녕',
      'kind': 'native',
      'paired_sentence_id': 12,
    },
  ]);

  test('짝은 isNative · 짝 id · 뉘앙스를 싣고, 기본 문장은 셋 다 비어 있다', () {
    final s = CallResultDto.fromJson(newServer).toEntity().sentences;
    expect(s.map((e) => e.isNative), [false, true, false, true]);
    expect(s[1].pairedSentenceId, 10);
    expect(s[1].nuance, 'Very hungry, playful');
    expect(s[0].pairedSentenceId, isNull);
    expect(s[0].nuance, isNull);
    expect(s[3].nuance, isNull, reason: '키가 없으면 null — 빈 문자열로 채우지 않는다');
  });

  test('받은 순서를 바꾸지 않는다', () {
    final s = CallResultDto.fromJson(newServer).toEntity().sentences;
    expect(s.map((e) => e.sentenceId), [10, 11, 12, 13]);
  });

  test('배운 표현 수는 짝을 빼고 센다 — 「새로운 표현 4개」 가 아니라 2개', () {
    expect(CallResultDto.fromJson(newServer).toEntity().learnedCount, 2);
  });

  test('구서버 페이로드(키 없음)는 전부 기본 문장이다', () {
    final r = CallResultDto.fromJson(result([
      {'sentence_id': 1, 'korean_sentence': 'a'},
      {'sentence_id': 2, 'korean_sentence': 'b'},
    ])).toEntity();
    expect(r.sentences.every((e) => !e.isNative), isTrue);
    expect(r.learnedCount, 2);
  });
}
