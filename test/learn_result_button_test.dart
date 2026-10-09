import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/components/molecules/card_study.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/mock/mock_data.dart';
import 'package:beavertalk/screens/home/analysis.dart';
import 'package:beavertalk/screens/home/learning_args.dart';
import 'package:beavertalk/screens/home/learning_call_main.dart';
import 'package:beavertalk/screens/home/learning_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 분석 「발음 학습하기」 → 학습을 끝까지 마치면 「학습 결과 보기」(PM-DEC-427).
///
/// 사용자 10-06: 「통화가 끝나고 난 후에 발음 학습하기 버튼이 1회 학습이 끝나면 학습 결과 보기
/// 버튼으로 변경하고, 결과 페이지로 이어지도록 (이전 학습에 대한 결과 페이지) 플로우를
/// 개선해줘.」 · Q1 A(결과 화면 안 「다시 학습하기」) · Q2 A(끝까지 다 했을 때).
SentenceScore _s(int? score, {String? kind}) => SentenceScore(
      sentence: '문장',
      pronunciation: score,
      fluency: score,
      rhythm: score,
      kind: kind,
    );

LearningSummary _summary(List<SentenceScore> sentences) => LearningSummary(
      passed: 0,
      total: sentences.length,
      date: DateTime(2026, 10, 6),
      overall: 70,
      pronunciation: 70,
      fluency: 70,
      rhythm: 70,
      hardestSound: '',
      hardestEvidence: '',
      l1Interference: '',
      phonemes: const [],
      sentences: sentences,
      sessions: const [],
    );

void main() {
  group('판정 — 현지인 표현 포함 모든 항목에 점수', () {
    test('전부 채점 → 마침', () {
      expect(_summary([_s(80), _s(60)]).learningFinished, isTrue);
    });
    test('하나라도 없음(중간 이탈) → 아직', () {
      expect(_summary([_s(80), _s(null)]).learningFinished, isFalse);
    });
    test('학습 안 함 → 아직', () {
      expect(_summary([_s(null), _s(null)]).learningFinished, isFalse);
    });
    test('현지인 짝(kind=native)이 미채점이면 아직', () {
      expect(_summary([_s(80), _s(null, kind: 'native')]).learningFinished, isFalse);
    });
    test('기본 6개와 현지인 6개를 모두 채점해야 마침', () {
      final base = List.generate(6, (_) => _s(80));
      final native = List.generate(6, (_) => _s(60, kind: 'native'));
      expect(_summary([...base, ...native]).learningFinished, isTrue);
      expect(_summary([...base, ...native.take(5), _s(null, kind: 'native')])
          .learningFinished, isFalse);
    });
    test('문장 0개 → 아직', () {
      expect(_summary(const []).learningFinished, isFalse);
    });
    test('범위 밖 점수는 완료로 세지 않으며 실제 0점은 채점임', () {
      expect(_summary([_s(-1)]).learningFinished, isFalse);
      expect(_summary([_s(101)]).learningFinished, isFalse);
      expect(_summary([_s(0)]).learningFinished, isTrue);
    });
    test('새 항목 ID와 총점은 읽고 구형 응답은 없는 값을 유지함', () {
      final s = SentenceScore.fromJson({
        'sentence_id': 10, 'sentence': '문장', 'total_score': 85,
        'pronunciation': 80,
      });
      expect(s.sentenceId, 10);
      expect(s.totalScore, 85);
      final old = SentenceScore.fromJson({'sentence': '문장'});
      expect(old.sentenceId, isNull);
      expect(old.totalScore, isNull);
    });
    test('kind 를 읽는다', () {
      final s = SentenceScore.fromJson({
        'sentence': 'a',
        'pronunciation': 70,
        'fluency': 70,
        'rhythm': 70,
        'kind': 'native',
      });
      expect(s.kind, 'native');
      expect(SentenceScore.fromJson({'sentence': 'b'}).kind, isNull);
    });
  });

  group('분석 화면 카드', () {
    final pushed = <String>[];

    Widget host(LearningSummary? report, {LearningSummary Function()? load}) => ProviderScope(
          overrides: [
            pronunciationReportProvider.overrideWith(
              (ref, id) async => load?.call() ?? report ?? (throw StateError('리포트 없음')),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: (s) {
              if (s.name != null && s.name != '/') pushed.add(s.name!);
              return MaterialPageRoute<void>(
                settings: s.name == null || s.name == '/'
                    ? const RouteSettings(
                        arguments: CallResult(
                          callId: 1,
                          average: ScoreAverage(),
                          sentences: [
                            LearnedSentence(sentenceId: 10, korean: '저는 선생님이에요', native: "I'm a teacher"),
                          ],
                        ),
                      )
                    : s,
                builder: (_) => s.name == null || s.name == '/'
                    ? const AnalysisScreen()
                    : const Scaffold(body: Text('pushed')),
              );
            },
          ),
        );

    Future<void> pump(WidgetTester tester, LearningSummary? report) async {
      pushed.clear();
      tester.view.physicalSize = const Size(375, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(report));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    testWidgets('끝까지 마침 → 「See learning results」 · 누르면 발음 리포트로', (tester) async {
      await pump(tester, _summary([_s(80)]));
      expect(find.text('Practice pronunciation'), findsNothing);
      final card = tester.widget<CardStudy>(find.ancestor(
        of: find.text('See learning results'),
        matching: find.byType(CardStudy),
      ));
      card.onTap!();
      await tester.pump();
      expect(pushed, [Routes.learningCallMain]);
    });

    testWidgets('중간 이탈 → 「Practice pronunciation」 그대로 · 누르면 학습', (tester) async {
      await pump(tester, _summary([_s(80), _s(null)]));
      expect(find.text('See learning results'), findsNothing);
      final card = tester.widget<CardStudy>(find.ancestor(
        of: find.text('Practice pronunciation'),
        matching: find.byType(CardStudy),
      ));
      card.onTap!();
      await tester.pump();
      expect(pushed, [Routes.learningIntro]);
    });

    testWidgets('리포트를 못 받으면 「Practice pronunciation」(안전한 기본값)', (tester) async {
      await pump(tester, null);
      expect(find.text('Practice pronunciation'), findsOneWidget);
      expect(find.text('See learning results'), findsNothing);
    });
    testWidgets('완료된 다른 항목 ID의 보고서로 결과 버튼을 켜지 않는다', (tester) async {
      await pump(tester, _summary([
        const SentenceScore(sentence: '다른 문장', pronunciation: 80,
            fluency: 80, rhythm: 80, sentenceId: 99),
      ]));
      expect(find.text('See learning results'), findsNothing);
      expect(find.text('Practice pronunciation'), findsOneWidget);
    });
    testWidgets('학습에서 돌아오면 캐시를 새로 받아 완료 버튼이 바뀐다', (tester) async {
      var reads = 0;
      var saved = _summary([_s(null)]);
      tester.view.physicalSize = const Size(375, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(null, load: () { reads++; return saved; }));
      await tester.pumpAndSettle();
      expect(reads, 1);
      final card = tester.widget<CardStudy>(find.ancestor(
        of: find.text('Practice pronunciation'), matching: find.byType(CardStudy),
      ));
      card.onTap!();
      await tester.pumpAndSettle();
      saved = _summary([_s(80)]);
      final context = tester.element(find.text('pushed'));
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(reads, greaterThan(1));
      expect(find.text('See learning results'), findsOneWidget);
      expect(find.text('Practice pronunciation'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('결과 화면 「다시 학습하기」', () {
    Future<List<String>> pump(WidgetTester tester, LearningArgs args) async {
      final pushed = <String>[];
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          pronunciationReportProvider.overrideWith((ref, id) async => _summary([_s(80)])),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (s) {
            if (s.name != null && s.name != '/') pushed.add(s.name!);
            return MaterialPageRoute<void>(
              settings: s.name == null || s.name == '/' ? RouteSettings(arguments: args) : s,
              builder: (_) => s.name == null || s.name == '/'
                  ? const LearningCallMainScreen()
                  : const Scaffold(body: Text('pushed')),
            );
          },
        ),
      ));
      await tester.pumpAndSettle();
      return pushed;
    }

    testWidgets('통화 학습이면 「Learn again」 → 학습 처음부터', (tester) async {
      final pushed = await pump(
        tester,
        const LearningArgs(
          sentences: [
            MockSentence(
              id: 10,
              korean: '저는 선생님이에요',
              native: "I'm a teacher",
              charScores: [],
              overall: 0,
              pronunciation: 0,
              fluency: 0,
              rhythm: 0,
            ),
          ],
          origin: LearningOrigin.callReview,
          callId: 1,
        ),
      );
      expect(find.text('Learn again'), findsOneWidget);
      await tester.tap(find.text('Learn again'));
      await tester.pump();
      expect(pushed, [Routes.learningIntro]);
    });

    testWidgets('문장이 없으면 「Learn again」 없음', (tester) async {
      await pump(
        tester,
        const LearningArgs(sentences: [], origin: LearningOrigin.callReview, callId: 1),
      );
      expect(find.text('Learn again'), findsNothing);
    });
  });
}
