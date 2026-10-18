// PM-DEC-798 — 바텀시트 아래 여백은 OS 인셋을 한 번만 세고 floor 보다 작으면 floor.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/chrome/sheet_bottom_inset.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_call_info.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/l10n/app_localizations_en.dart';

Future<void> _pump(WidgetTester tester, double inset, Widget child) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  tester.view.padding = FakeViewPadding(bottom: inset);
  tester.view.viewPadding = FakeViewPadding(bottom: inset);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Align(alignment: Alignment.bottomCenter, child: child)),
  ));
  await tester.pump();
}

void main() {
  // PM-DEC-803 — max(floor, 인셋 + 12) · 인셋 0 은 floor 그대로.
  for (final (inset, want) in [(0.0, 24.0), (34.0, 46.0), (48.0, 60.0)]) {
    testWidgets('SheetBottomInset — 인셋 $inset → 아래 $want', (tester) async {
      await _pump(tester, inset, const SheetBottomInset(child: SizedBox(key: Key('c'), height: 10, width: 10)));
      expect(812 - tester.getRect(find.byKey(const Key('c'))).bottom, want);
    });
  }

  testWidgets('위쪽 SafeArea 가 인셋을 먹었으면 floor 만(이중 여백 없음)', (tester) async {
    await _pump(tester, 34, const SafeArea(child: Align(alignment: Alignment.bottomCenter,
        child: SheetBottomInset(child: SizedBox(key: Key('c'), height: 10, width: 10)))));
    expect(812 - tester.getRect(find.byKey(const Key('c'))).bottom, 34 + 24);
  });

  for (final (inset, want) in [(0.0, 34.0), (34.0, 46.0), (48.0, 60.0)]) {
    testWidgets('통화 i 시트 — 인셋 $inset → 카드 아래 여백 $want', (tester) async {
      await _pump(tester, inset, const BottomSheetCallInfo(type: CallInfoType.free));
      final sheet = tester.getRect(find.byType(BottomSheetCallInfo));
      final body = tester.getRect(find.text(AppLocalizationsEn().callInfoFreeTalkBody));
      // 카드 안쪽 16 + 시트 아래 여백
      expect(sheet.bottom - body.bottom, want + 16);
    });
  }
}
