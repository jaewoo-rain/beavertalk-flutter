import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 마이페이지 「발음 학습하기」 — 점수가 있는 가장 최근 통화로 간다.
///
/// QA F043(09-26): 평균 81% 카드에서 눌렀는데 점수 없는 최근 통화(전부 「-%」)로 가
/// 학습할 게 없는 화면이 나왔다. 데이터판 통화: 101(오늘) · 102(오늘) · 103(1일 전) · 104.
class _Repo implements NormalcallRepository {
  _Repo(this.scored);

  /// 점수가 있는 통화 id.
  final Set<int> scored;

  @override
  Future<CallResult> getResult(int callId) async => CallResult(
        callId: callId,
        average: ScoreAverage(totalScore: scored.contains(callId) ? 81 : null),
        sentences: const [],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

void main() {
  Future<List<RouteSettings>> tapPractice(WidgetTester tester, Set<int> scored) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final pushed = <RouteSettings>[];
    await tester.pumpWidget(ProviderScope(
      overrides: [normalcallRepositoryProvider.overrideWithValue(_Repo(scored))],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: myPageDataHost(level: true),
        onGenerateRoute: (s) {
          pushed.add(s);
          return MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink());
        },
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    final cta = find.text('Practice pronunciation');
    await tester.ensureVisible(cta);
    await tester.tap(cta);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    return pushed;
  }

  testWidgets('가장 최근 통화에 점수가 없으면 점수 있는 다음 통화로', (tester) async {
    final pushed = await tapPractice(tester, {102, 103});
    expect(pushed.single.name, Routes.analysisLoading);
    expect(pushed.single.arguments, 102);
  });

  testWidgets('점수 있는 통화가 없으면 기록 목록으로', (tester) async {
    final pushed = await tapPractice(tester, {});
    expect(pushed.single.name, Routes.records);
  });
}
