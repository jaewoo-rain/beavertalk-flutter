import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/learning_args.dart';
import 'package:beavertalk/screens/home/learning_call_main.dart';
import 'package:beavertalk/screens/home/learning_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:beavertalk/theme/app_typography.dart' show kFontFamily;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 발음 학습 결과(`3569:15065`) — 09-24 사장님 실기기 QA 「음소 단위 5회 시도 … 양옆으로 정렬하는 게
/// 아니라 좀 붙어있어」 와 차트 · 날짜 결함(통합 담당 보고서 04).
void main() {
  final now = DateTime.now();

  SessionPoint sp(int ago, int? score, {bool withDate = true, String label = '', String date = ''}) {
    final d = now.subtract(Duration(days: ago));
    return SessionPoint(
      label: label.isEmpty ? '${d.month}/${d.day}' : label,
      date: date.isEmpty ? '${d.month}/${d.day}' : date,
      sentences: 3,
      score: score,
      callDate: withDate ? d : null,
    );
  }

  LearningSummary summary(List<SessionPoint> sessions) => LearningSummary(
        passed: 1,
        total: 2,
        date: now,
        // 눈금 글자(100·80·60·50·0)와 겹치지 않는 값.
        overall: 77,
        pronunciation: 77,
        fluency: 77,
        rhythm: 77,
        hardestSound: '',
        hardestEvidence: '',
        l1Interference: '',
        phonemes: const [PhonemeStat(sound: 'ㅓ', attempts: 5, correct: 3)],
        sentences: const [
          SentenceScore(sentence: '캐나다에서 왔어요.', pronunciation: 77, fluency: 77, rhythm: 77),
        ],
        sessions: sessions,
      );

  Future<void> pump(WidgetTester tester, LearningSummary s, {String locale = 'ko'}) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      key: UniqueKey(),
      overrides: [pronunciationReportProvider.overrideWith((ref, id) async => s)],
      child: MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            settings: const RouteSettings(
              arguments: LearningArgs(sentences: [], origin: LearningOrigin.callReview, callId: 1),
            ),
            builder: (_) => const LearningCallMainScreen(),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('구획 부가 문구는 머리 행 오른쪽 끝(Figma 3569:15125)', (tester) async {
    await pump(tester, summary([sp(1, 80), sp(0, 90)]));
    final title = tester.getRect(find.text('소리별 정확도'));
    final sub = tester.getRect(find.text('음소 단위 · 5회 시도'));
    // 화면 좌우 패딩 20 — 부가 문구 오른쪽 끝이 본문 오른쪽 끝(340)에 붙는다.
    expect(sub.right, closeTo(340, 1), reason: '가운데로 몰리지 않는다');
    expect(title.left, closeTo(20, 1));
  });

  testWidgets('모든 세션이 60 이상이면 눈금 60/80/100(Figma)', (tester) async {
    await pump(tester, summary([sp(2, 80), sp(1, 84), sp(0, 97)]));
    for (final t in ['100', '80', '60']) {
      expect(find.text(t), findsWidgets, reason: '눈금 $t');
    }
    expect(find.text('50'), findsNothing);
  });

  testWidgets('60 미만이 하나라도 있으면 눈금 0/50/100', (tester) async {
    await pump(tester, summary([sp(2, 72), sp(1, 38), sp(0, 64)]));
    expect(find.text('50'), findsOneWidget);
    expect(find.text('80'), findsNothing);
  });

  testWidgets('채점 세션이 2개 미만이면 평균선 없음 — 「평균 0」 을 그리지 않는다', (tester) async {
    await pump(tester, summary([sp(1, null), sp(0, 90)]));
    expect(find.textContaining('평균'), findsNothing);
  });

  testWidgets('점수 없음(null)은 표 · 차트 모두 「—」 · 0 은 진짜 0점(서버 1c83fd9)', (tester) async {
    await pump(tester, summary([sp(2, 0), sp(1, null), sp(0, 90)]));
    // 차트 값 줄 + 표 점수 칸 = 「—」 둘(없음 세션 하나). delta 없음의 「—」 도 있어 2개 이상.
    expect(find.text('—'), findsAtLeastNWidgets(2));
    // 0 은 진짜 0점 — 눈금이 0/50/100 이 되고 평균(0·90 → 45)에 들어간다.
    expect(find.text('50'), findsOneWidget);
    expect(find.textContaining('평균 45'), findsOneWidget);
  });

  testWidgets('평균 글자는 평균선 위(Figma 「평균 88」)', (tester) async {
    await pump(tester, summary([sp(1, 80), sp(0, 96)]));
    final label = find.textContaining('평균 88');
    expect(label, findsOneWidget);
    // 글자 아래 2px 뒤에 선이 온다 — 글자 칸(12) 바로 아래 형제가 선이다.
    final column = find.ancestor(of: label, matching: find.byType(Column)).first;
    final line = find.descendant(of: column, matching: find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxHeight == 1));
    expect(tester.getRect(line).top, greaterThanOrEqualTo(tester.getRect(label).bottom));
  });

  testWidgets('「(오늘)」은 정말 오늘인 세션에만 — 최신 세션이 어제면 안 붙는다', (tester) async {
    await pump(tester, summary([sp(2, 80), sp(1, 90)]));
    expect(find.textContaining('(오늘)'), findsNothing);
    expect(find.text('오늘'), findsNothing, reason: '차트 눈금도 날짜');
  });

  testWidgets('오늘 세션은 표 「9월 24일 (오늘)」 · 차트 「오늘」 — 현지 날짜', (tester) async {
    await pump(tester, summary([sp(1, 80), sp(0, 90)]));
    expect(find.text('${now.month}월 ${now.day}일 (오늘)'), findsOneWidget);
    expect(find.text('오늘'), findsOneWidget);
  });

  testWidgets('세션 시각이 없으면(구서버) 서버 문자열 — 서버가 「오늘」이라 한 줄만 (오늘)', (tester) async {
    await pump(tester, summary([
      sp(1, 80, withDate: false, label: '9/22', date: '9/22'),
      sp(0, 90, withDate: false, label: '오늘', date: '9/23'),
    ]));
    expect(find.text('9/23 (오늘)'), findsOneWidget);
    expect(find.text('9/22'), findsNWidgets(2), reason: '차트 눈금 + 표');
  });

  testWidgets('고정 폭 열 머리는 낱말 중간에서 끊기지 않는다 — en 「Sentences」(09-24 실기기)', (tester) async {
    // 실제 글꼴로 잰다 — 시험 글꼴(네모)은 라틴 글자를 실제보다 훨씬 넓게 잰다(R11 주의).
    await tester.runAsync(() async {
      final loader = FontLoader(kFontFamily);
      for (final w in const ['Regular', 'Medium', 'SemiBold', 'Bold']) {
        loader.addFont(rootBundle.load('assets/fonts/Pretendard-$w.otf'));
      }
      await loader.load();
    });
    await pump(tester, summary([sp(1, 80), sp(0, 90)]), locale: 'en');
    for (final h in ['Sentences', 'Score', 'Change', 'Attempts', 'Correct', 'Accuracy']) {
      final f = find.text(h);
      if (f.evaluate().isEmpty) continue;
      final ro = tester.renderObject<RenderParagraph>(f.first);
      final tops = ro
          .getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: h.length))
          .map((b) => b.top.round())
          .toSet();
      expect(tops.length, 1, reason: '「$h」 한 줄');
    }
  });
}
