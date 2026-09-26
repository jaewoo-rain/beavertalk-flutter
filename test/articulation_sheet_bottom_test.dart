import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/pronunciation/domain/phoneme_diagram.dart';
import 'package:beavertalk/features/pronunciation/presentation/articulation_sheet.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 조음 시트 하단 — 다른 전폭 시트와 같은 규칙(09-26 바텀시트 전수조사 ·
/// `_shared/비버톡_앱_바텀시트_버튼색_전수조사_2026-09-26.md` §1).
///
/// 예전에는 `SafeArea` 가 시트 **바깥**을 감싸 시트 전체가 기기 하단 인셋만큼 바닥에서
/// 떴고(그 아래로 어둡게 비침), 안쪽 하단은 20 이었다. 정본은 시트 면이 화면 바닥에
/// 닿고, 맨 아래 버튼 ↔ 바닥 = max(인셋, 24)(Figma 34 = 인셋 34 기기).
void main() {
  Future<void> open(WidgetTester tester, {required double inset}) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = FakeViewPadding(bottom: inset);
    tester.view.viewPadding = FakeViewPadding(bottom: inset);
    addTearDown(tester.view.reset);
    final data = ArticulationSheetData(
      word: '제나예요.',
      target: diagramForJamo('ㅈ', isCoda: false)!,
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showArticulationSheet(context, data: data, onPlayNative: () {}),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    // 도해 에셋 로드가 섞여도 흔들리지 않게 고정 프레임으로 민다(articulation_sheet_i18n_test 와 같음).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    tester.takeException();
  }

  double buttonsBottom(WidgetTester tester) => find
      .byType(Button)
      .evaluate()
      .map((e) => tester.getRect(find.byWidget(e.widget)).bottom)
      .reduce((a, b) => a > b ? a : b);

  testWidgets('인셋 34 기기: 시트 면이 바닥에 닿고 버튼 아래 34', (tester) async {
    await open(tester, inset: 34);
    final sheet = tester.getRect(find.byType(BottomSheet));
    expect(sheet.bottom, 812, reason: '시트가 바닥에서 떠 있다(바깥 SafeArea)');
    expect(812 - buttonsBottom(tester), 34);
  });

  testWidgets('인셋 0 기기: 버튼 아래 최소 24', (tester) async {
    await open(tester, inset: 0);
    expect(tester.getRect(find.byType(BottomSheet)).bottom, 812);
    expect(812 - buttonsBottom(tester), 24);
  });
}
