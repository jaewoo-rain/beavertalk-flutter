import 'package:beavertalk/features/auth/domain/entities/level_summary.dart';
import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/level_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 레벨업 축하(09-25 사장님 확정 V1 · Figma screen/level_up 6410:42174).
class _Repo implements AuthRepository {
  _Repo(this.level);
  int? level;
  bool fail = false;

  @override
  Future<LevelSummary> getMyLevel() async {
    if (fail) throw Exception('network');
    return LevelSummary(level: level);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  group('LevelUpCheck — 마지막으로 본 레벨과 비교', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('첫 확인은 기준만 남기고 축하하지 않는다(원래 레벨을 「올랐다」고 하지 않음)', () async {
      expect(await LevelUpCheck.newLevel(_Repo(5), memberId: 1), isNull);
    });

    test('기준보다 오르면 새 레벨 · 같으면 null · 내려가면 기준만 낮춘다', () async {
      final repo = _Repo(5);
      await LevelUpCheck.newLevel(repo, memberId: 1);
      repo.level = 6;
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), 6);
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), isNull, reason: '한 번만');
      repo.level = 3; // 재측정
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), isNull);
      repo.level = 4;
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), 4, reason: '낮아진 기준에서 다시 오름');
    });

    test('못 물어보면 축하 없음 · 기준 그대로 · 레벨 없음도 축하 없음', () async {
      final repo = _Repo(5);
      await LevelUpCheck.newLevel(repo, memberId: 1);
      repo.fail = true;
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), isNull);
      repo
        ..fail = false
        ..level = 6;
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), 6, reason: '실패 때 기준이 안 바뀌었다');
      repo.level = null;
      expect(await LevelUpCheck.newLevel(repo, memberId: 1), isNull);
    });

    test('기준은 회원별 — 다른 계정의 레벨과 섞이지 않는다', () async {
      await LevelUpCheck.newLevel(_Repo(9), memberId: 1);
      expect(await LevelUpCheck.newLevel(_Repo(3), memberId: 2), isNull, reason: '2번 회원은 첫 확인');
    });
  });

  group('LevelUpScreen', () {
    Future<List<String>> pump(WidgetTester tester) async {
      final taps = <String>[];
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LevelUpScreen(level: 7, onConfirm: () => taps.add('confirm')),
      ));
      await tester.pump();
      return taps;
    }

    testWidgets('「종합 레벨」 · 「7단계」 · 「확인」 — 새 문구 없음', (tester) async {
      final taps = await pump(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('종합 레벨'), findsOneWidget);
      expect(find.text('7단계'), findsOneWidget);
      expect(tester.widget<Text>(find.text('7단계')).style!.fontSize, 40);
      await tester.tap(find.text('확인'));
      expect(taps, ['confirm']);
    });

    testWidgets('시스템 뒤로도 「확인」과 같다', (tester) async {
      final taps = await pump(tester);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(taps, ['confirm']);
    });
  });
}
