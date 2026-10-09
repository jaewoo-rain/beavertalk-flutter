import 'dart:async';

import 'package:beavertalk/components/molecules/card_loading.dart';
import 'package:beavertalk/components/molecules/pronunciation_result.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/analysis_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 분석 대기 — 스켈레톤 → (LLM 미완이면) 준비 중 → 분석.
///
/// 09-26 사용자: 「screen/analysis__preparing 이거를 로딩 스켈레톤으로 쓰는 게 아니라 로딩
/// 스켈레톤 이후에 만약 LLM 결과값이 없다면 이거를 띄워야해. 만약 LLM으로부터 내용이 전달해서
/// DB 업데이트가 되면 그 때 screen/analysis를 보여주는 식이야」. 09-23 에 둘을 합쳐 첫 로딩부터
/// 준비 카드가 보였고, 이미 분석된 지난 통화도 준비 중이 잠깐 비쳤다.
class _FakeRepo implements NormalcallRepository {
  _FakeRepo(this.status);

  /// 상태 조회가 돌려줄 값 — null 이면 영영 답하지 않는다(첫 답 대기).
  final CallAnalysisStatus? status;

  @override
  Future<CallAnalysisStatus> getStatus(int callId) =>
      status == null ? Completer<CallAnalysisStatus>().future : Future.value(status);

  /// 결과는 영영 안 온다 — 분석 화면으로 넘어가기 전 상태를 본다.
  @override
  Future<CallResult> getResult(int callId) => Completer<CallResult>().future;

  /// 통화 기록도 영영 안 온다 — 이 시험은 상태별 칸만 본다(메타 줄은 analysis_meta_first_test).
  @override
  Future<CallSummary> getCallSummary(int callId) => Completer<CallSummary>().future;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

void main() {
  Future<void> pump(
    WidgetTester tester,
    CallAnalysisStatus? status, {
    Locale locale = const Locale('ko'),
  }) async {
    // 실패한 expect 뒤에도 화면을 내려 조회·shimmer 타이머를 정리한다.
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(_FakeRepo(status))],
      child: MaterialApp(
        locale: locale,
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
  }

  Future<void> tearDownScreen(WidgetTester tester) async {
    // 조회 타이머를 끄려면 화면을 내린다.
    await tester.pumpWidget(const SizedBox.shrink());
  }

  /// 게이지를 감싼 흐림 — 스켈레톤 · 준비 중 둘 다 0.4(09-24 결정 · Figma 3569:27508 · 6330:13227).
  double gaugeOpacity(WidgetTester tester) => tester
      .widget<Opacity>(find
          .ancestor(of: find.byType(PronunciationResult), matching: find.byType(Opacity))
          .first)
      .opacity;

  testWidgets('첫 답 전에는 순수 스켈레톤 — 준비 카드 없음 · 게이지 0.4', (tester) async {
    await pump(tester, null);
    expect(find.byType(CardLoading), findsOneWidget);
    expect(find.byType(AnalysisPreparingCard), findsNothing);
    expect(gaugeOpacity(tester), 0.4);
    await tearDownScreen(tester);
  });

  for (final status in [CallAnalysisStatus.ongoing, CallAnalysisStatus.analyzing]) {
    testWidgets('${status.name} — LLM 미완이면 준비 중', (tester) async {
      await pump(tester, status);
      expect(find.byType(AnalysisPreparingCard), findsOneWidget);
      expect(find.byType(CardLoading), findsNothing);
      expect(gaugeOpacity(tester), 0.4);
      await tearDownScreen(tester);
    });
  }

  // QA F024 — 없는 통화 · 남의 통화면 서버가 200 {status: unknown}. 끝없이 로딩하지 않는다.
  testWidgets('unknown 을 연속 3번 받으면 「통화 정보를 찾을 수 없어요」로 끝난다', (tester) async {
    await pump(tester, CallAnalysisStatus.unknown);
    expect(find.textContaining('통화 정보를 찾을 수 없어'), findsNothing, reason: '한 번에 끊지 않는다');
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 1600));
    }
    expect(find.textContaining('통화 정보를 찾을 수 없어'), findsOneWidget);
    await tearDownScreen(tester);
  });

  testWidgets('처음부터 done 이면 준비 중을 안 거친다 — 결과를 받는 동안 스켈레톤', (tester) async {
    await pump(tester, CallAnalysisStatus.done);
    expect(find.byType(AnalysisPreparingCard), findsNothing);
    expect(find.byType(CardLoading), findsOneWidget);
    await tearDownScreen(tester);
  });

  // getter와 화면만 비교하면 잘못 연결된 locale도 함께 통과할 수 있다.
  // ARB에서 확인한 대표값으로 locale 선택과 실제 표시를 함께 검증한다.
  const preparingCopy = <String, List<String>>{
    'ko': [
      '오늘 통화를 돌아보고 있어요.',
      '잠시 뒤 한마디가 여기에 도착해요',
      '비버가 오늘 배운 표현을 카드로 만들고 있어요',
      '다 되면 이 자리에 바로 나타나요.',
      '대화 저장',
      '표현 카드 만들기',
      '완료',
      '만드는 중',
      '대기',
    ],
    'en': [
      "Looking back on today's call.",
      'A note will appear here shortly',
      "The beaver is turning today's expressions into cards",
      "They'll show up right here when ready.",
      'Saving the conversation',
      'Making expression cards',
      'Done',
      'In progress',
      'Waiting',
    ],
    'ja': [
      '今日の通話を振り返っています。',
      'まもなくここにひとことが届きます',
      'ビーバーが今日の表現をカードにしています',
      'できあがったらすぐここに表示されます。',
      '会話の保存',
      '表現カードの作成',
      '完了',
      '作成中',
      '待機中',
    ],
  };

  for (final code in preparingCopy.keys) {
    for (final status in <CallAnalysisStatus?>[
      null,
      CallAnalysisStatus.ongoing,
      CallAnalysisStatus.analyzing,
      CallAnalysisStatus.done,
      CallAnalysisStatus.failed,
      CallAnalysisStatus.unknown,
    ]) {
      testWidgets('$code ${status?.name ?? 'first-response'} — 로딩 상태 번역',
          (tester) async {
        await pump(tester, status, locale: Locale(code));
        final context = tester.element(find.byType(AnalysisLoadingScreen));
        final l10n = AppLocalizations.of(context);
        expect(Localizations.localeOf(context).languageCode, code);
        final copy = preparingCopy[code]!;
        expect([
          l10n.analysisPrepNote,
          l10n.analysisPrepNoteHint,
          l10n.analysisPrepTitle,
          l10n.analysisPrepSub,
          l10n.analysisPrepStepSave,
          l10n.analysisPrepStepCards,
          l10n.analysisPrepStateDone,
          l10n.analysisPrepStateWorking,
          l10n.analysisPrepStateWaiting,
        ], copy);
        expect(find.text(l10n.conversationRecord), findsOneWidget);

        if (status == CallAnalysisStatus.unknown) {
          expect(find.text(l10n.callInfoNotFound), findsNothing);
          // 최초 답변이 1회다. 두 번째도 대기하며 세 번째에서 오류로 끝난다.
          await tester.pump(const Duration(milliseconds: 1600));
          expect(find.text(l10n.callInfoNotFound), findsNothing);
          await tester.pump(const Duration(milliseconds: 1600));
          expect(find.text(l10n.callInfoNotFound), findsOneWidget);
        }

        final preparing = status == CallAnalysisStatus.ongoing ||
            status == CallAnalysisStatus.analyzing;
        final error = status == CallAnalysisStatus.failed ||
            status == CallAnalysisStatus.unknown;
        expect(find.byType(AnalysisPreparingCard),
            preparing ? findsOneWidget : findsNothing);
        expect(find.byType(CardLoading),
            preparing || error ? findsNothing : findsOneWidget);

        if (preparing) {
          // Column은 지연 생성이 아니므로 화면 밖 고정 문구도 검사한다.
          for (final text in copy.take(6)) {
            expect(find.text(text), findsOneWidget);
          }
          expect(find.text(copy[7]), findsOneWidget);
          final saved = status == CallAnalysisStatus.analyzing;
          expect(find.text(copy[6]), saved ? findsOneWidget : findsNothing);
          expect(find.text(copy[8]), saved ? findsNothing : findsOneWidget);
          final card = find.byType(AnalysisPreparingCard);
          expect(tester.widget<AnalysisPreparingCard>(card).saved, saved);
          for (final (label, state) in [
            (copy[4], saved ? copy[6] : copy[7]),
            (copy[5], saved ? copy[7] : copy[8]),
          ]) {
            final row = find.ancestor(
              of: find.descendant(of: card, matching: find.text(label)),
              matching: find.byType(Row),
            ).first;
            expect(find.descendant(of: row, matching: find.text(state)),
                findsOneWidget);
          }
          expect(gaugeOpacity(tester), 0.4);
        } else {
          for (final text in copy) {
            expect(find.text(text), findsNothing);
          }
          if (!error) expect(gaugeOpacity(tester), 0.4);
        }

        if (code != 'ko') {
          for (final text in preparingCopy['ko']!) {
            expect(find.text(text), findsNothing);
          }
        }
        if (error) {
          expect(find.text(l10n.connectionFailedTitle), findsOneWidget);
          expect(find.text(l10n.retry), findsOneWidget);
          if (status == CallAnalysisStatus.failed) {
            expect(find.text(l10n.analysisFailed), findsOneWidget);
          }
        }
        expect(tester.takeException(), isNull);
        await tearDownScreen(tester);
      });
    }
  }
}
