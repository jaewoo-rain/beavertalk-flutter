import 'dart:async';

import 'package:beavertalk/core/analytics/app_analytics.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/analysis_loading.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// D15 — GA4 이벤트 보강(2026-10-08 GA4 점검 개선안 5~7).
///
/// - `analysis_viewed` 에 `source`(post_call · history) — 통화 직후와 기록 재진입을 가른다.
/// - `paywall_viewed`(variant).
/// 이벤트는 [AppAnalytics.debugOnLog] 로 본다(수집 스위치·Firebase 와 무관).
class _DoneRepo implements NormalcallRepository {
  @override
  Future<CallAnalysisStatus> getStatus(int callId) async => CallAnalysisStatus.done;

  @override
  Future<CallResult> getResult(int callId) async =>
      CallResult(callId: callId, average: const ScoreAverage(), sentences: const []);

  /// 통화 메타 줄은 이 시험의 관심 밖 — 영영 안 온다(analysis_loading_phase_test 와 같음).
  @override
  Future<CallSummary> getCallSummary(int callId) => Completer<CallSummary>().future;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

void main() {
  final logged = <(String, Map<String, Object>?)>[];
  setUp(() {
    logged.clear();
    AppAnalytics.debugOnLog = (name, params) => logged.add((name, params));
  });
  tearDown(() => AppAnalytics.debugOnLog = null);

  Future<void> pumpLoading(WidgetTester tester, Object args) async {
    addTearDown(() async => tester.pumpWidget(const SizedBox.shrink()));
    await tester.pumpWidget(ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(_DoneRepo())],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(name: '/analysis-loading', arguments: args),
          builder: (_) => const AnalysisLoadingScreen(),
        ),
      ),
    ));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  List<Map<String, Object>?> viewed() =>
      [for (final e in logged) if (e.$1 == AppEvent.analysisViewed) e.$2];

  testWidgets('통화 직후(call_finish 인자) → analysis_viewed source=post_call · 한 번', (tester) async {
    await pumpLoading(tester, (callId: 7, source: AnalysisSource.postCall));
    expect(viewed(), [
      {'source': 'post_call'},
    ]);
  });

  testWidgets('기록 쪽(int callId) → source=history', (tester) async {
    await pumpLoading(tester, 7);
    expect(viewed(), [
      {'source': 'history'},
    ]);
  });

  testWidgets('페이월 표시 → paywall_viewed(variant)', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PaywallScreen(variant: PaywallVariant.proLimit),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    expect(
      logged.where((e) => e.$1 == AppEvent.paywallViewed).map((e) => e.$2),
      [
        {'variant': 'proLimit'},
      ],
    );
  });
}
