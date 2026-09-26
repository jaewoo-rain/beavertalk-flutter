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

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

void main() {
  Future<void> pump(WidgetTester tester, CallAnalysisStatus? status) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(_FakeRepo(status))],
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

  testWidgets('처음부터 done 이면 준비 중을 안 거친다 — 결과를 받는 동안 스켈레톤', (tester) async {
    await pump(tester, CallAnalysisStatus.done);
    expect(find.byType(AnalysisPreparingCard), findsNothing);
    expect(find.byType(CardLoading), findsOneWidget);
    await tearDownScreen(tester);
  });
}
