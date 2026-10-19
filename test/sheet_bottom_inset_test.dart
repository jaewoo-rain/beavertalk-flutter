// PM-DEC-798·807 — 바텀시트·하단 버튼 아래 여백은 화면 바닥에서 max(34, OS 인셋 + 12) 하나다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/chrome/sheet_bottom_inset.dart';
import 'package:beavertalk/components/organisms/bottom_sheet.dart' as sheet;
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
  // PM-DEC-807 — max(34, 인셋 + 12) · 인셋 0 은 34.
  for (final (inset, want) in [(0.0, 34.0), (34.0, 46.0), (48.0, 60.0)]) {
    testWidgets('SheetBottomInset — 인셋 $inset → 아래 $want', (tester) async {
      await _pump(tester, inset, const SheetBottomInset(child: SizedBox(key: Key('c'), height: 10, width: 10)));
      expect(812 - tester.getRect(find.byKey(const Key('c'))).bottom, want);
    });
  }

  // 위쪽 SafeArea 가 인셋을 먼저 넣어도(AppScaffold 안 BottomCtaBar) 화면 바닥에서 잰 값은 같다 — 옛 「인셋 + 24」(58) 없음.
  for (final (inset, want) in [(0.0, 34.0), (34.0, 46.0), (48.0, 60.0)]) {
    testWidgets('위쪽 SafeArea 안 — 인셋 $inset → 아래 $want(이중 여백 없음)', (tester) async {
      await _pump(tester, inset, const SafeArea(child: Align(alignment: Alignment.bottomCenter,
          child: SheetBottomInset(child: SizedBox(key: Key('c'), height: 10, width: 10)))));
      expect(812 - tester.getRect(find.byKey(const Key('c'))).bottom, want);
    });
  }

  for (final (inset, want) in [(0.0, 34.0), (34.0, 46.0), (48.0, 60.0)]) {
    testWidgets('통화 i 시트 — 인셋 $inset → 카드 아래 여백 $want', (tester) async {
      await _pump(tester, inset, const BottomSheetCallInfo(type: CallInfoType.free));
      final sheet = tester.getRect(find.byType(BottomSheetCallInfo));
      final body = tester.getRect(find.text(AppLocalizationsEn().callInfoFreeTalkBody));
      // 카드 안쪽 16 + 시트 아래 여백
      expect(sheet.bottom - body.bottom, want + 16);
    });
  }

  // 공용 BottomSheet(확인·선택 시트들 · PM-DEC-807) — 아래 = max(34, 인셋 + 12).
  for (final (inset, want) in [(0.0, 34.0), (34.0, 46.0), (48.0, 60.0)]) {
    for (final layout in sheet.BottomSheetLayout.values) {
      testWidgets('공용 BottomSheet $layout — 인셋 $inset → 버튼 아래 $want', (tester) async {
        await _pump(tester, inset, sheet.BottomSheet(
          layout: layout,
          primaryAction: sheet.SheetAction(label: 'OK', onPressed: () {}),
          secondaryAction: sheet.SheetAction(label: 'Cancel', onPressed: () {}),
          child: const Text('body'),
        ));
        final s = tester.getRect(find.byType(sheet.BottomSheet));
        final ok = tester.getRect(find.text('OK'));
        // 시트 아래 ↔ 맨 아래 버튼 글자 아래 = 아래 여백 + (버튼 높이 − 글자 높이)/2 → 버튼 상자로 잰다
        final btn = tester.getRect(find.ancestor(of: find.text('OK'), matching: find.byWidgetPredicate((w) => w.runtimeType.toString() == 'Button')).first);
        expect(s.bottom - btn.bottom, want, reason: 'ok=$ok');
      });
    }
  }
}
