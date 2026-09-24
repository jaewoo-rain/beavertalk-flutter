import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/auth/domain/entities/level_summary.dart';
import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 「레벨 테스트 다시하기」 확인 — 서버 「레벨이 이제 «진도» 에서 나온다」(09-24).
/// 재측정은 진도를 그 레벨 첫 차시로 되돌리므로, 확인 없이 API 를 부르면 안 된다.
class _FakeAuth implements AuthRepository {
  int retakes = 0;

  @override
  Future<void> retakeLevelTest() async => retakes++;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  Future<(_FakeAuth, List<String?>)> pump(WidgetTester tester) async {
    final auth = _FakeAuth();
    final pushed = <String?>[];
    tester.view.physicalSize = const Size(375, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        myLevelProvider.overrideWith((ref) async => const LevelSummary(level: 5)),
      ],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyPageScreen(),
        onGenerateRoute: (s) {
          pushed.add(s.name);
          return MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink());
        },
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    await tester.pump(const Duration(milliseconds: 32));
    tester.takeException();
    return (auth, pushed);
  }

  Future<void> openConfirm(WidgetTester tester) async {
    await tester.ensureVisible(find.text('레벨 테스트 다시하기'));
    await tester.tap(find.text('레벨 테스트 다시하기'));
    await tester.pumpAndSettle();
  }

  testWidgets('누르면 먼저 확인 창이 뜬다 — 아직 재측정하지 않는다', (tester) async {
    final (auth, _) = await pump(tester);
    await openConfirm(tester);
    expect(find.text('레벨을 다시 측정할까요?'), findsOneWidget);
    expect(find.textContaining('레벨이 같게 나와도 마찬가지예요'), findsOneWidget);
    expect(auth.retakes, 0);
  });

  testWidgets('「진도 유지하기」 는 재측정하지 않는다', (tester) async {
    final (auth, pushed) = await pump(tester);
    await openConfirm(tester);
    await tester.tap(find.text('진도 유지하기'));
    await tester.pumpAndSettle();
    expect(auth.retakes, 0);
    expect(pushed, isNot(contains(Routes.callLoading)));
  });

  testWidgets('「다시 측정하기」 만 재측정을 부른다', (tester) async {
    final (auth, pushed) = await pump(tester);
    await openConfirm(tester);
    await tester.tap(find.text('다시 측정하기'));
    await tester.pumpAndSettle();
    expect(auth.retakes, 1);
    expect(pushed, contains(Routes.callLoading), reason: '재측정 뒤 레벨테스트 통화로 간다');
  });
}
