// 통화 결과의 표현학습 `quiz_items` — **파싱은 하고 표시는 안 한다.**
//
// ⚠ 2026-09-12 사장님 결정으로 결과 화면의 퀴즈 섹션(7f70c29)을 내렸다. 서버 필드는
//   그대로 오므로 파싱·엔티티는 남긴다(다음 판에서 다시 쓸 수 있게). 아래 «결과 화면»
//   group 이 «안 그린다» 를 잠근다.
//
// ⭐ 왜 생겼나(2026-09-11). 표현학습은 `item_evidence` 사슬을 안 쓰므로 「이번 통화에서
//   쓴 표현」(`used_items`)이 **빈다** — 승급이 «퀴즈 통과» 로 갈아탔다(D12). 그 자리에
//   서버가 통화 종료 시점에 적어 둔 퀴즈 스냅샷을 보여 준다. 두 칸은 동시에 차지 않는다.
//
// 서버 계약(`CallResultQuizItem`, 9cbea87):
//   item_id:int · surface:str · meaning:str|null · passed:bool · failed:bool
//   옛 스냅샷은 meaning 이 없고 failed 키도 없다 → null / false.
//
// ⚠ `passed=false` 는 «틀렸다» 가 아니다. 서버는 «퀴즈에서 틀림»(failed) 과 «아직 퀴즈
//   안 봄»(둘 다 false) 을 `failed` 로만 가른다. 화면이 `!passed` 를 «다시 볼 표현» 으로
//   내면 드릴만 한 표현에 틀렸다고 말하는 셈이다 — 그래서 배지 판정도 여기서 잠근다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/data/models/call_result_dto.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/analysis.dart';

Map<String, dynamic> _json(Object? quizItems) => {
  'call_id': 1,
  'average': const <String, dynamic>{},
  'sentences': const <dynamic>[],
  'quiz_items': ?quizItems,
};

void main() {
  group('quiz_items 파싱', () {
    test('정상 — 다섯 필드를 그대로 읽는다', () {
      final r = CallResultDto.fromJson(
        _json([
          {
            'item_id': 101,
            'surface': '안녕히 가세요',
            'meaning': 'Goodbye (to someone leaving)',
            'passed': true,
            'failed': false,
          },
          {
            'item_id': 102,
            'surface': '물',
            'meaning': 'water',
            'passed': false,
            'failed': true,
          },
          {
            'item_id': 103,
            'surface': '집',
            'meaning': 'house',
            'passed': false,
            'failed': false,
          },
        ]),
      ).toEntity();

      expect(r.quizItems.map((e) => e.surface).toList(), ['안녕히 가세요', '물', '집']);
      expect(r.quizItems[0].itemId, 101);
      expect(r.quizItems[0].meaning, 'Goodbye (to someone leaving)');
      expect(r.quizItems.map((e) => e.passed).toList(), [true, false, false]);
      expect(r.quizItems.map((e) => e.failed).toList(), [false, true, false]);
      // 표현학습이면 used_items 는 비어 있다 — 서버가 그렇게 보낸다. 여기서는 키를
      // 안 줬으니 빈 목록이어야 한다(두 칸이 서로를 밀어내지 않는다).
      expect(r.usedItems, isEmpty);
    });

    test('키가 없으면 빈 목록이다 — 다른 콜타입·옛 응답. 화면이 섹션을 안 그린다', () {
      expect(CallResultDto.fromJson(_json(null)).toEntity().quizItems, isEmpty);
    });

    test('meaning·failed 가 없으면 null·false 다 — 옛 스냅샷 호환', () {
      // 2026-09-10 이전 스냅샷은 item_id·surface·passed 셋만 적었다.
      final r = CallResultDto.fromJson(
        _json([
          {'item_id': 1, 'surface': '가다', 'passed': true},
          {'item_id': 2, 'surface': '오다', 'passed': false},
        ]),
      ).toEntity();

      expect(r.quizItems.map((e) => e.meaning).toList(), [null, null]);
      expect(r.quizItems.map((e) => e.failed).toList(), [false, false],
          reason: 'failed 를 !passed 로 채우면 안 된다 — 둘째는 «아직 안 봄» 이다');
      expect(r.quizItems[0].passed, isTrue);
      expect(r.quizItems[1].passed, isFalse);
    });

    test('모양이 어긋난 원소는 버리되 나머지는 살린다', () {
      // 🔴 한 줄 때문에 결과 화면 전체가 안 뜨면 안 된다(used_items 와 같은 규율).
      final r = CallResultDto.fromJson(
        _json([
          'not a map',
          {'surface': '표면형만', 'passed': true}, // id 없음
          {'item_id': 3, 'passed': true},           // 표면형 없음
          {'item_id': 4, 'surface': '  ', 'passed': true}, // 빈 표면형
          {'item_id': 5, 'surface': '집', 'passed': true},
        ]),
      ).toEntity();

      expect(r.quizItems.length, 1);
      expect(r.quizItems.single.surface, '집');
    });
  });

  group('결과 화면', () {
    CallResult result(List<QuizItem> quizItems) => CallResult(
          callId: 1,
          average: const ScoreAverage(),
          sentences: const [],
          quizItems: quizItems,
        );

    /// [AnalysisScreen] 은 라우트 인자로 [CallResult] 를 받는다 — `home:` 으로는 인자를
    /// 못 주므로 라우트를 직접 만든다.
    Widget host(CallResult r) => ProviderScope(
          child: MaterialApp(
            locale: const Locale('ko'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              settings: RouteSettings(arguments: r),
              builder: (_) => const AnalysisScreen(),
            ),
          ),
        );

    testWidgets('⛔ quizItems 가 있어도 결과 화면은 그리지 않는다 — 사장님 결정 2026-09-12',
        (tester) async {
      // 7f70c29 가 넣은 「이번에 배운 표현 N개」+배지 섹션을 화면에서 내렸다. 서버 응답
      // 필드는 그대로 오고 파싱도 남아 있다(위 group) — **표시만** 0 이다. 다시 그리게
      // 되면 이 시험이 먼저 빨간불을 낸다.
      await tester.pumpWidget(host(result(const [
        QuizItem(itemId: 1, surface: '안녕히 가세요', meaning: '작별', passed: true),
        QuizItem(itemId: 2, surface: '물', passed: false, failed: true),
        QuizItem(itemId: 3, surface: '집', passed: false),
      ])));
      await tester.pumpAndSettle();

      expect(find.textContaining('이번에 배운 표현'), findsNothing);
      expect(find.text('안녕히 가세요'), findsNothing);
      expect(find.text('맞혔어요'), findsNothing);
      expect(find.text('다시 볼 표현'), findsNothing);
      expect(find.text('다음에 이어서'), findsNothing);
    });

    testWidgets('quizItems 가 비어도 마찬가지 — 일반 통화 결과 화면 그대로', (tester) async {
      await tester.pumpWidget(host(result(const [])));
      await tester.pumpAndSettle();

      expect(find.textContaining('이번에 배운 표현'), findsNothing);
    });
  });
}
