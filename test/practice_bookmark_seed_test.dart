import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/components/molecules/card_bookmark.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/mock/mock_data.dart';
import 'package:beavertalk/screens/home/analysis.dart';
import 'package:beavertalk/screens/home/learning_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 분석 카드에서 북마크를 켠 뒤 「연습하기」 → 연습 화면에서도 북마크가 켜져 있어야 한다(2026-10-10 사용자 신고).
///
/// 원인: 분석 화면이 학습 화면에 넘기던 문장 목록의 `bookmarked` 는 **화면을 연 순간의 서버 값**이었고,
/// 학습 화면은 들어오자마자 그 값으로 공용 북마크 상태를 맞춘다(setBookmark) — 방금 켠 북마크가 꺼졌다.
MockSentence _m(int id, {bool bookmarked = false}) => MockSentence(
      id: id,
      korean: '문장 $id',
      native: 'sentence $id',
      charScores: const [],
      overall: 0,
      pronunciation: 0,
      fluency: 0,
      rhythm: 0,
      bookmarked: bookmarked,
    );

void main() {
  tearDown(clearBookmarks);

  group('withLiveBookmarks', () {
    test('공용 상태로 다시 입힌다 — 켬·끔 모두', () {
      setBookmark(1, true);
      setBookmark(2, false);
      final out = withLiveBookmarks([_m(1), _m(2, bookmarked: true), _m(3)]);
      expect(out.map((s) => s.bookmarked), [true, false, false]);
      expect(out.first.korean, '문장 1');
    });

    test('같으면 그대로 둔다(같은 객체)', () {
      final s = _m(5);
      expect(identical(withLiveBookmarks([s]).single, s), isTrue);
    });
  });

  testWidgets('분석 카드에서 켠 북마크가 「연습하기」로 넘어갈 때 켜진 채로 간다', (tester) async {
    final pushedArgs = <LearningArgs>[];
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        pronunciationReportProvider.overrideWith((ref, id) async => throw StateError('리포트 없음')),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (s) {
          final root = s.name == null || s.name == '/';
          if (!root && s.name == Routes.learningIntro && s.arguments is LearningArgs) {
            pushedArgs.add(s.arguments! as LearningArgs);
          }
          return MaterialPageRoute<void>(
            settings: root
                ? const RouteSettings(
                    arguments: CallResult(
                      callId: 1,
                      average: ScoreAverage(),
                      sentences: [
                        // 서버 값: 아직 북마크 안 함.
                        LearnedSentence(sentenceId: 10, korean: '저는 선생님이에요', native: "I'm a teacher"),
                      ],
                    ),
                  )
                : s,
            builder: (_) => root ? const AnalysisScreen() : const Scaffold(body: Text('pushed')),
          );
        },
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(bookmarkedSentenceIds.value.contains(10), isFalse);

    // 카드의 북마크 탭은 공용 상태를 먼저 켠다(낙관적 반영). 서버 호출은 이 시험의 관심 밖이다.
    toggleBookmark(10);
    await tester.pump();

    final card = tester.widget<CardBookmark>(find.byType(CardBookmark).first);
    card.onAction!();
    await tester.pump();

    expect(pushedArgs, hasLength(1));
    expect(pushedArgs.single.sentences.single.id, 10);
    expect(pushedArgs.single.sentences.single.bookmarked, isTrue,
        reason: '연습 화면은 이 값으로 공용 상태를 맞춘다 — false 면 방금 켠 북마크가 꺼진다');
  });
}
