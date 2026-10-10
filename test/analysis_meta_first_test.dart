import 'dart:async';

import 'package:beavertalk/components/atoms/skeleton.dart';
import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/analysis_loading.dart';
import 'package:beavertalk/screens/home/call_meta_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 분석 대기 — 날짜 · 통화 시간을 분석보다 먼저 보인다(A4 · PM-DEC-341).
///
/// 10-03 사용자: 「통화 이후에 분석 결과에서, 날짜와 통화 시간 초를 먼저 DB로 보내고, 이후에
/// 분석 결과를 업데이트하는 방식으로 변경하고 싶어. Loading 일 때 어색해서.」 서버는 이미 통화
/// 시작 때 행을, 끊김을 본 순간 `total_time` 을 쓴다 — 대기 화면이 그걸 안 읽고 메타 줄까지
/// 스켈레톤으로 그리던 것이 어색함이었다.
class _FakeRepo implements NormalcallRepository {
  _FakeRepo({required this.answers});

  /// `getCallSummary` 가 차례로 돌려줄 답 — 다 쓰면 마지막 답을 되풀이한다.
  /// [AppException] 이면 그것을 던진다.
  final List<Object> answers;

  int summaryCalls = 0;

  @override
  Future<CallAnalysisStatus> getStatus(int callId) =>
      Future.value(CallAnalysisStatus.analyzing);

  @override
  Future<CallResult> getResult(int callId) => Completer<CallResult>().future;

  @override
  Future<CallSummary> getCallSummary(int callId) async {
    final answer = answers[summaryCalls.clamp(0, answers.length - 1)];
    summaryCalls++;
    if (answer is AppException) throw answer;
    return answer as CallSummary;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

CallSummary _summary({int? totalTime, String? title}) => CallSummary(
  callId: 1681,
  character: const CallCharacterBrief(characterId: 1, name: 'Baba'),
  callDate: DateTime(2026, 10, 3, 14, 5),
  totalTime: totalTime,
  summary: title,
);

void main() {
  Future<_FakeRepo> pump(WidgetTester tester, List<Object> answers) async {
    final repo = _FakeRepo(answers: answers);
    await tester.pumpWidget(ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/analysis-loading', arguments: 1681),
          builder: (_) => const AnalysisLoadingScreen(),
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    return repo;
  }

  /// 상태 조회 한 주기(1.5초) — 통화 기록 재조회가 여기에 얹혀 있다.
  Future<void> nextPoll(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 50));
  }

  Finder durationSkeleton() => find.descendant(
    of: find.byType(CallMetaLine),
    matching: find.byType(Skeleton),
  );

  Finder titleSkeleton() =>
      find.byKey(const ValueKey('analysis-loading-title-skeleton'));

  Future<void> tearDownScreen(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('분석 중에도 날짜 · 통화 시간이 실값으로 보인다', (tester) async {
    final repo = await pump(tester, [_summary(totalTime: 192, title: '주말 계획 이야기')]);
    expect(find.text('10월 3일 · 3분 12초'), findsOneWidget);
    expect(durationSkeleton(), findsNothing);
    expect(find.text('주말 계획 이야기'), findsOneWidget);
    expect(titleSkeleton(), findsNothing);
    // 분석 칸은 여전히 준비 중이다(표현·현지인 표현은 2단계).
    expect(find.byType(AnalysisPreparingCard), findsOneWidget);
    // 통화 시간 · 제목을 다 받았으면 더 묻지 않는다.
    await nextPoll(tester);
    await nextPoll(tester);
    expect(repo.summaryCalls, 1);
    await tearDownScreen(tester);
  });

  // PM-DEC-366 회귀: 서버가 아직 제목을 먼저 주지 않으면(지금 운영) 제목 칸은 현행 그대로다.
  testWidgets('서버가 제목을 안 주면 제목 칸은 현행 스켈레톤 · 상한까지만 묻는다', (tester) async {
    final repo = await pump(tester, [_summary(totalTime: 192)]);
    expect(find.text('10월 3일 · 3분 12초'), findsOneWidget);
    expect(titleSkeleton(), findsOneWidget);
    for (var i = 0; i < 6; i++) {
      await nextPoll(tester);
    }
    expect(repo.summaryCalls, 5);
    expect(titleSkeleton(), findsOneWidget, reason: '분석이 끝나면 분석 화면이 제목을 낸다');
    await tearDownScreen(tester);
  });

  testWidgets('제목이 늦게 오면 스켈레톤이다가 실값으로 바뀐다', (tester) async {
    final repo = await pump(tester, [
      _summary(totalTime: 192),
      _summary(totalTime: 192, title: '자기소개 연습'),
    ]);
    expect(titleSkeleton(), findsOneWidget);
    await nextPoll(tester);
    expect(find.text('자기소개 연습'), findsOneWidget);
    expect(titleSkeleton(), findsNothing);
    await nextPoll(tester);
    expect(repo.summaryCalls, 2, reason: '다 받은 뒤로는 더 묻지 않는다');
    await tearDownScreen(tester);
  });

  testWidgets('통화 시간이 늦게 채워지면 그 칸만 스켈레톤이다가 실값으로 바뀐다', (tester) async {
    final repo = await pump(tester, [
      _summary(),
      _summary(totalTime: 0),
      _summary(totalTime: 75),
    ]);
    expect(find.textContaining('10월 3일'), findsOneWidget);
    expect(durationSkeleton(), findsOneWidget, reason: 'NULL 은 아직 안 쓰인 것');
    await nextPoll(tester);
    expect(durationSkeleton(), findsOneWidget, reason: '0 도 아직');
    await nextPoll(tester);
    expect(find.text('10월 3일 · 1분 15초'), findsOneWidget);
    expect(durationSkeleton(), findsNothing);
    expect(repo.summaryCalls, 3);
    await tearDownScreen(tester);
  });

  testWidgets('5번 물어도 통화 시간이 없으면 그만 묻고 날짜만 남긴다', (tester) async {
    final repo = await pump(tester, [_summary()]);
    for (var i = 0; i < 6; i++) {
      await nextPoll(tester);
    }
    expect(repo.summaryCalls, 5);
    expect(durationSkeleton(), findsNothing, reason: '끝없이 반짝이지 않는다');
    expect(find.text('10월 3일'), findsOneWidget);
    await tearDownScreen(tester);
  });

  testWidgets('통화 기록을 못 받으면 메타 줄은 종전 스켈레톤 · 분석 대기는 계속', (tester) async {
    final repo = await pump(tester, [const NetworkFailure()]);
    expect(find.byType(CallMetaLine), findsNothing);
    expect(find.byType(AnalysisPreparingCard), findsOneWidget);
    await nextPoll(tester);
    expect(repo.summaryCalls, 2, reason: '다음 조회 때 다시 묻는다');
    await tearDownScreen(tester);
  });

  testWidgets('메타 줄은 분석 화면과 같은 위젯 · 같은 문구다', (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CallMetaLine(
          characterName: 'Baba',
          callDate: DateTime(2026, 1, 2),
          totalTime: 637,
          callSequence: 3,
        ),
      ),
    ));
    expect(find.text('Baba · 1월 2일 · 10분 37초 · 3번째 통화'), findsOneWidget);
  });
}
