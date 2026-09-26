import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/normalcall/domain/entities/daily_status.dart';
import 'package:beavertalk/features/normalcall/domain/repositories/normalcall_repository.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 레벨 재측정 — 오늘 레벨테스트를 이미 봤으면 초기화 **전에** 멈춘다.
///
/// QA F002(09-26): retake 는 성공 즉시 서버가 레벨을 비우고, 한도는 통화 시작에서야 검사한다.
/// 오늘 레벨테스트를 이미 본 회원이 누르면 레벨만 비고 통화는 DAILY_LIMIT 로 막혀 다음 날까지
/// 「레벨 미확정」으로 남았다.
///
/// ⛔ 판정은 **통화 예산이 아니라** `can_call_level_test`(하루 1회)다 — 서버는 레벨테스트를
///   예산에서 뺀다. 처음 고친 판은 예산 축으로 막아 QA 재검증에서 틀렸다.
class _Normalcall implements NormalcallRepository {
  _Normalcall(this.daily);

  final DailyStatus? daily;

  @override
  Future<DailyStatus?> getDailyStatus() async => daily;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

class _Auth implements AuthRepository {
  int retakes = 0;

  @override
  Future<void> retakeLevelTest() async => retakes++;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} — 이 시험엔 없다');
}

void main() {
  Future<_Auth> tapRetake(WidgetTester tester, DailyStatus? daily) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final auth = _Auth();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        normalcallRepositoryProvider.overrideWithValue(_Normalcall(daily)),
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: myPageDataHost(level: true),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    final button = find.text('Retake level test');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    return auth;
  }

  testWidgets('오늘 레벨테스트 봄 — 예산이 남아도 확인창 없이 안내 · retake 안 보냄', (tester) async {
    final auth = await tapRetake(
      tester,
      const DailyStatus(
        canCallNormal: true,
        canCallLevelTest: false,
        budgetSec: 900,
        usedSec: 120,
        remainingSec: 780,
      ),
    );
    expect(find.text('You can take the level test once a day. Try again tomorrow.'),
        findsOneWidget);
    expect(find.text('Retake the level test?'), findsNothing);
    expect(auth.retakes, 0);
  });

  testWidgets('예산 소진이어도 레벨테스트는 된다 — 확인창이 뜬다(서버가 예산에서 뺀다)', (tester) async {
    await tapRetake(
      tester,
      const DailyStatus(
        canCallNormal: false,
        canCallLevelTest: true,
        budgetSec: 300,
        usedSec: 300,
        remainingSec: 0,
      ),
    );
    expect(find.text('Retake the level test?'), findsOneWidget);
  });

  test('daily-status 가 can_call_level_test 를 읽는다', () {
    expect(DailyStatus.tryParse({'can_call_level_test': false})!.canCallLevelTest, isFalse);
    expect(DailyStatus.tryParse({'can_call_normal': true})!.canCallLevelTest, isNull);
  });

  testWidgets('모름(구서버 · 실패) — 막지 않는다', (tester) async {
    await tapRetake(tester, null);
    expect(find.text('Retake the level test?'), findsOneWidget);
  });
}
