import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/components/molecules/stacked_button_pair.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_content.dart';
import 'package:beavertalk/components/organisms/bottom_sheet.dart';
import 'package:beavertalk/components/organisms/dialog_basic.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter_test/flutter_test.dart';

/// 버튼 쌍은 **항상 위아래**(09-24 사장님 확정 「양옆에 나란히 놓인 버튼 쌍을 전부 위아래로
/// 쌓습니다」). 짧은 글자여도 가로로 두지 않는다 — 좁을 때만 쌓던 옛 `EqualButtonPair` 폐기.
void main() {
  Future<void> pump(WidgetTester tester, Widget child, {double width = 335}) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ));
  }

  Rect rectOf(WidgetTester tester, String label) => tester.getRect(
      find.ancestor(of: find.text(label), matching: find.byType(Button)).first);

  group('StackedButtonPair', () {
    testWidgets('짧은 글자여도 세로 — top 위 · bottom 아래 · 각자 전폭 · 간격 12', (tester) async {
      await pump(
        tester,
        const StackedButtonPair(
          top: Button(type: BtnType.secondaryOutline, size: BtnSize.s60, text: 'Home'),
          bottom: Button(type: BtnType.primaryFill, size: BtnSize.s60, text: 'Go'),
        ),
        width: 335,
      );
      final top = rectOf(tester, 'Home');
      final bottom = rectOf(tester, 'Go');
      expect(top.bottom, lessThanOrEqualTo(bottom.top));
      expect(bottom.top - top.bottom, 12);
      expect(top.width, 335);
      expect(bottom.width, 335);
    });

    testWidgets('간격을 바꿀 수 있다', (tester) async {
      await pump(
        tester,
        const StackedButtonPair(
          gap: 6,
          top: Button(type: BtnType.secondaryFill, size: BtnSize.s48, text: 'A'),
          bottom: Button(type: BtnType.primaryFill, size: BtnSize.s48, text: 'B'),
        ),
      );
      expect(rectOf(tester, 'B').top - rectOf(tester, 'A').bottom, 6);
    });
  });

  group('DialogBasic', () {
    testWidgets('두 버튼은 목록 순서대로 위→아래 · 간격 12 · 같은 폭', (tester) async {
      await pump(
        tester,
        DialogBasic(
          title: 'T',
          actions: [
            DialogAction(label: 'Cancel', onPressed: () {}),
            DialogAction(label: 'Open settings', type: BtnType.primaryFill, onPressed: () {}),
          ],
        ),
      );
      final top = rectOf(tester, 'Cancel');
      final bottom = rectOf(tester, 'Open settings');
      expect(top.top, lessThan(bottom.top));
      expect(bottom.top - top.bottom, 12);
      expect(top.width, bottom.width);
      expect(tester.widget<Button>(find.widgetWithText(Button, 'Cancel')).type, BtnType.secondaryFill,
          reason: '타입을 안 주면 secondary_fill');
      expect(tester.widget<Button>(find.widgetWithText(Button, 'Open settings')).type, BtnType.primaryFill);
    });

    testWidgets('버튼 하나면 전폭 한 개', (tester) async {
      await pump(tester, DialogBasic(title: 'T', actions: [DialogAction(label: 'OK', onPressed: () {})]));
      expect(find.byType(Button), findsOneWidget);
    });
  });

  group('BottomSheetContent', () {
    testWidgets('기본은 주요 위(구독 오버레이 정본) · secondaryOnTop 이면 보조 위(캐릭터 구매 완료)', (tester) async {
      Widget sheet({required bool secondaryOnTop}) => BottomSheetContent(
            title: 'T',
            body: 'B',
            secondaryOnTop: secondaryOnTop,
            primaryAction: SheetAction(label: 'Use now', onPressed: () {}),
            secondaryAction: SheetAction(label: 'Home', onPressed: () {}),
          );
      await pump(tester, sheet(secondaryOnTop: false), width: 375);
      expect(rectOf(tester, 'Use now').top, lessThan(rectOf(tester, 'Home').top));

      await pump(tester, KeyedSubtree(key: UniqueKey(), child: sheet(secondaryOnTop: true)), width: 375);
      expect(rectOf(tester, 'Home').top, lessThan(rectOf(tester, 'Use now').top));
    });
  });
}
