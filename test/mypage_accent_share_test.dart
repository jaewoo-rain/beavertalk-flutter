import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 억양 카드 공유 아이콘 — 억양이 없으면 보이되 눌리지 않는다.
///
/// QA F020(09-26): 「No accent data yet」 상태에서도 아이콘이 눌려, 공유 대화상자가
/// 「Your Korean accent sounds —」로 빈 결과를 내보내려 했다. 같은 카드의 「취약 발음 연습」
/// 버튼과 같은 규칙(Figma E1)으로 맞춘다.
void main() {
  Future<void> pump(WidgetTester tester, {required bool accent}) async {
    tester.view.physicalSize = const Size(360, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: myPageDataHost(level: true, accent: accent),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
  }

  SemanticsNode share(WidgetTester tester) =>
      tester.getSemantics(find.bySemanticsLabel('Share'));

  testWidgets('억양 없음 — 공유 아이콘이 꺼져 있다', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, accent: false);
    expect(find.text('No accent data yet'), findsOneWidget);
    expect(
      share(tester),
      isSemantics(
        label: 'Share',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
    handle.dispose();
  });

  testWidgets('억양 있음 — 공유 아이콘이 눌린다', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, accent: true);
    expect(
      share(tester),
      isSemantics(
        label: 'Share',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
