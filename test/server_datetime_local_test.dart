import 'package:beavertalk/features/normalcall/data/models/call_result_dto.dart';
import 'package:flutter_test/flutter_test.dart';

/// 서버 시각(timestamptz, UTC) → 화면 날짜는 **현지 시각**이어야 한다.
///
/// 실기기(0f80de9): 09-24 00:16 KST 통화가 분석 화면 머리글에 「9월 23일」, 학습 달력
/// 목록에는 「9월 24일」 로 찍혔다 — 분석 쪽이 UTC 그대로 포맷했다.
void main() {
  const utc = '2026-09-23T15:16:00Z'; // = 09-24 00:16 KST

  test('통화 결과 call_date 는 현지 시각으로 바뀐다', () {
    final r = CallResultDto.fromJson({
      'call_id': 1,
      'call_date': utc,
      'average': <String, dynamic>{},
      'sentences': <dynamic>[],
    }).toEntity();
    expect(r.callDate!.isUtc, isFalse);
    expect(r.callDate, DateTime.parse(utc).toLocal());
  });

  test('통화 목록 call_date 도 같다', () {
    final s = CallSummaryDto.fromJson({
      'call_id': 1,
      'call_date': utc,
      'character': {'character_id': 1, 'name': 'Baba'},
    }).toEntity();
    expect(s.callDate!.isUtc, isFalse);
    expect(s.callDate, DateTime.parse(utc).toLocal());
  });
}
