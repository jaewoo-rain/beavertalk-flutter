import 'package:beavertalk/features/auth/domain/entities/level_summary.dart';
import 'package:beavertalk/features/normalcall/domain/entities/pron_summary.dart';
import 'package:flutter_test/flutter_test.dart';

/// 마이페이지 카드 데이터 파싱 회귀.
///
/// 이 화면은 오래 **목업 상수**(레벨 7 · 상위 45% · 발음 98점)를 그대로 그렸다.
/// 누구에게나 같은 가짜 수치가 보였고 아무도 눈치채지 못했다. 그래서 "값이 없을 때
/// 0이나 그럴듯한 숫자로 채우지 않는다"를 테스트로 못박는다.
void main() {
  group('LevelSummary', () {
    test('서버 필드를 그대로 읽는다', () {
      final s = LevelSummary.fromJson(const {
        'korean_level': 7,
        'level_max': 13,
        'level_top_percent': 45,
      });
      expect(s.level, 7);
      expect(s.maxLevel, 13);
      expect(s.topPercent, 45);
      expect(s.needsLevelTest, isFalse);
    });

    test('레벨 미실시 → null (0 으로 채우지 않는다)', () {
      final s = LevelSummary.fromJson(const {'korean_level': null});
      expect(s.level, isNull);
      expect(s.topPercent, isNull);
      expect(s.aheadOfPercent, isNull);
      expect(s.needsLevelTest, isTrue);
    });

    test('aheadOfPercent 는 topPercent 의 보수 — 합이 100', () {
      final s = LevelSummary.fromJson(const {'level_top_percent': 45});
      expect(s.aheadOfPercent, 55);
    });

    test('level_max 미전송이면 13 으로 폴백', () {
      expect(LevelSummary.fromJson(const {}).maxLevel, 13);
    });
  });

  group('PronSummary', () {
    test('서버 필드를 그대로 읽는다', () {
      final s = PronSummary.fromJson(const {
        'sessions': 10,
        'sentence_count': 42,
        'total_score': 82.6,
        'pronunciation': 84.0,
        'fluency': 79.5,
        'rhythm': 74.0,
      });
      expect(s.sessions, 10);
      expect(s.sentenceCount, 42);
      expect(s.totalScore, 82.6);
      expect(s.hasData, isTrue);
    });

    test('세션 0 → hasData false (카드가 빈 상태로 그린다)', () {
      final s = PronSummary.fromJson(const {'sessions': 0, 'sentence_count': 0});
      expect(s.hasData, isFalse);
      expect(s.totalScore, isNull);
      expect(s.pronunciation, isNull);
    });

    test('세션은 있는데 점수가 null 이면 hasData false', () {
      // 서버 계약상 없어야 하지만, 있어도 게이지가 0% 를 그리면 안 된다.
      final s = PronSummary.fromJson(const {'sessions': 3, 'sentence_count': 5});
      expect(s.hasData, isFalse);
    });

    test('빈 응답에도 터지지 않는다', () {
      final s = PronSummary.fromJson(const {});
      expect(s.sessions, 0);
      expect(s.hasData, isFalse);
    });

    test('empty 상수는 빈 상태다', () {
      expect(PronSummary.empty.hasData, isFalse);
      expect(PronSummary.empty.sessions, 0);
    });
  });
}
