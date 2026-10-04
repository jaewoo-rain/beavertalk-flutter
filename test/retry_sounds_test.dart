import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/features/weak_sound/presentation/retry_practiced.dart';
import 'package:beavertalk/features/weak_sound/presentation/widgets/retry_pack_card.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/learning_args.dart';
import 'package:beavertalk/screens/home/learning_call_main.dart';
import 'package:beavertalk/screens/home/learning_summary.dart';
import 'package:beavertalk/screens/weak_sound/retry_sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A5 「자주 틀린 소리 모아 학습」 — 리포트 카드(M1) · 목록(M2) · 모두 마침(M19).
///
/// 10-03 사용자: 「통화 분석 페이지에서 발음 학습을 마치고 나서, 해당 학습에서 여러번 틀린
/// 발음을 따로 모아서 학습할 수 있게 하고 싶어」(PM-DEC-333/341 · Figma 섹션 `6564:15217`).
const _sounds = [
  RetrySound(soundKey: 'coda_ㄹ', label: '받침 ㄹ', cardDesc: '혀끝을 붙이고 멈춰요', attempts: 7, misses: 4, score: 62),
  RetrySound(soundKey: 'onset_ㅊ', label: '초성 ㅊ', cardDesc: 'ㅈ 자리에서 바람을 세게', attempts: 8, misses: 2, score: 54),
  RetrySound(soundKey: 'coda_ㄱ', label: '받침 ㄱ', cardDesc: '혀뿌리로 막고 멈춰요', attempts: 8, misses: 2),
];

LearningSummary _summary({List<RetrySound> retry = _sounds}) => LearningSummary(
      passed: 8,
      total: 10,
      date: DateTime(2026, 10, 4),
      overall: 77,
      pronunciation: 77,
      fluency: 77,
      rhythm: 77,
      hardestSound: '받침 ㄹ',
      hardestEvidence: '',
      l1Interference: '',
      phonemes: const [],
      sentences: const [],
      sessions: const [],
      retrySounds: retry,
    );

Widget _app(Widget home, {List<Override> overrides = const [], Object? args}) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            settings: RouteSettings(arguments: args),
            builder: (_) => home,
          ),
        ),
      ),
    );

void main() {
  group('모델', () {
    test('retry_sounds 를 읽는다 · score null = 측정 전', () {
      final s = LearningSummary.fromJson({
        'retry_sounds': [
          {'sound_key': 'coda_ㄹ', 'label': '받침 ㄹ', 'card_desc': 'd', 'attempts': 7, 'misses': 4, 'score': 62},
          {'sound_key': 'onset_ㅊ', 'label': '초성 ㅊ', 'card_desc': 'd', 'attempts': 8, 'misses': 2, 'score': null},
          {'sound_key': '', 'label': '키 없음', 'attempts': 1, 'misses': 1},
        ],
      });
      expect(s.retrySounds.map((r) => r.soundKey), ['coda_ㄹ', 'onset_ㅊ'], reason: '키 없는 항목은 버린다');
      expect(s.retrySounds.first.misses, 4);
      expect(s.retrySounds.last.score, isNull);
    });

    test('구서버(키 없음)는 빈 목록 → 카드 숨김', () {
      expect(LearningSummary.fromJson({}).retrySounds, isEmpty);
    });

    test('타일 글자 = 자모(onset_/coda_) · 그 밖은 라벨 첫 글자', () {
      expect(retrySymbolOf(_sounds[0]), 'ㄹ');
      expect(retrySymbolOf(_sounds[1]), 'ㅊ');
      expect(
        retrySymbolOf(const RetrySound(soundKey: 'rule_liaison', label: '연음', cardDesc: '', attempts: 2, misses: 2)),
        '연',
      );
    });
  });

  group('M1 리포트 카드', () {
    Future<void> pumpReport(WidgetTester tester, LearningSummary s) async {
      tester.view.physicalSize = const Size(360, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(
        const LearningCallMainScreen(),
        overrides: [pronunciationReportProvider.overrideWith((ref, id) async => s)],
        args: const LearningArgs(sentences: [], origin: LearningOrigin.callReview, callId: 1),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('소리가 있으면 「가장 어려웠던 소리」 아래에 카드', (tester) async {
      await pumpReport(tester, _summary());
      expect(find.byType(RetryPackCard), findsOneWidget);
      expect(find.text('이번 학습에서 자주 틀린 소리 3개'), findsOneWidget);
      expect(find.text('모아서 연습하기'), findsOneWidget);
      final hardest = tester.getRect(find.text('가장 어려웠던 소리'));
      final pack = tester.getRect(find.text('자주 틀린 소리 연습'));
      expect(pack.top, greaterThan(hardest.top));
    });

    testWidgets('소리가 0개면 카드째 숨긴다(현행 리포트)', (tester) async {
      await pumpReport(tester, _summary(retry: const []));
      expect(find.byType(RetryPackCard), findsNothing);
      expect(find.text('자주 틀린 소리 연습'), findsNothing);
    });
  });

  group('M2 목록 · M19 모두 마침', () {
    Future<ProviderContainer> pumpList(WidgetTester tester, {String? title}) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(
        const RetrySoundsScreen(),
        overrides: [pronunciationReportProvider.overrideWith((ref, id) async => _summary())],
        args: RetrySoundsArgs(callId: 1, callTitle: title),
      ));
      await tester.pumpAndSettle();
      return ProviderScope.containerOf(tester.element(find.byType(RetrySoundsScreen)));
    }

    testWidgets('통화 제목이 있으면 부제에 넣는다 · 카드 3장', (tester) async {
      await pumpList(tester, title: '강아지 산책과 음악 취향');
      expect(find.text('자주 틀린 소리'), findsOneWidget);
      expect(find.text('이번 학습에서 모은 소리'), findsOneWidget);
      expect(find.text('강아지 산책과 음악 취향 통화에서 2번 이상 틀린 소리예요'), findsOneWidget);
      expect(find.text('받침 ㄹ'), findsOneWidget);
      expect(find.text('초성 ㅊ'), findsOneWidget);
      expect(find.text('리포트로 돌아가기'), findsNothing);
    });

    testWidgets('통화 제목이 없으면 제목 없는 부제', (tester) async {
      await pumpList(tester);
      expect(find.text('이번 학습에서 2번 이상 틀린 소리예요'), findsOneWidget);
    });

    testWidgets('모은 소리를 모두 마치면 M19 — 부제 바뀜 · 리포트로 돌아가기', (tester) async {
      final container = await pumpList(tester, title: '강아지 산책');
      final n = container.read(retryPracticedProvider.notifier);
      n.mark('coda_ㄹ');
      n.mark('onset_ㅊ');
      await tester.pump();
      expect(find.text('리포트로 돌아가기'), findsNothing, reason: '하나 남았다');
      n.mark('coda_ㄱ');
      await tester.pump();
      expect(find.text('모은 소리를 모두 연습했어요'), findsOneWidget);
      expect(find.text('리포트로 돌아가기'), findsOneWidget);
    });

    testWidgets('목록을 새로 열면 지난 방문의 「마침」 기록을 비운다', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      for (final s in _sounds) {
        container.read(retryPracticedProvider.notifier).mark(s.soundKey);
      }
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [pronunciationReportProvider.overrideWith((ref, id) async => _summary())],
            child: Navigator(
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                settings: const RouteSettings(arguments: RetrySoundsArgs(callId: 1)),
                builder: (_) => const RetrySoundsScreen(),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(container.read(retryPracticedProvider), isEmpty);
      expect(find.text('리포트로 돌아가기'), findsNothing);
    });
  });
}
