// 적응형 레이아웃 규약의 실측 게이트.
//
// Figma 정본 `┗ Design · Tablet`(`5272:22731`) 의 규격 노트와 프레임에서 가져온
// 앵커 두 개(모바일 375 → 여백 20 / 콘텐츠 335, 태블릿 810 → 여백 105 / 콘텐츠
// 600)를 코드가 실제로 통과하는지 본다. 상수만 검사하지 않고 **렌더된 상자를
// 재서** 확인한다 — 규칙이 맞아도 위젯이 그 규칙을 안 쓰면 소용이 없다.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/adaptive.dart';
import 'package:beavertalk/components/organisms/bottom_nav_bar.dart';
import 'package:beavertalk/components/organisms/gnb.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

/// 폭 [width] 의 화면에 [child] 를 띄운다.
Future<void> pumpAt(
  WidgetTester tester,
  double width,
  Widget child, {
  double height = 900,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('AppLayout — 정본 앵커', () {
    test('여백은 20에서 자라 태블릿에서 105가 된다', () {
      expect(AppLayout.gutterFor(375), 20); // 폰
      expect(AppLayout.gutterFor(640), 20); // 이음매 — 여기서 콘텐츠가 600 포화
      expect(AppLayout.gutterFor(810), 105); // 태블릿 정본
      expect(AppLayout.gutterFor(1024), 212);
    });

    test('콘텐츠 폭은 600에서 멈춘다', () {
      double content(double w) => w - AppLayout.gutterFor(w) * 2;
      expect(content(375), 335); // 폰 정본
      expect(content(640), 600);
      expect(content(810), 600); // 태블릿 정본
      expect(content(1024), 600);
    });

    test('문서는 700, 안내문·오버레이는 480', () {
      expect(AppLayout.gutterFor(810, cap: AppLayout.document), 55);
      expect(AppLayout.gutterFor(810, cap: AppLayout.narrow), 165);
      // 폰에서는 셋 다 20으로 무너진다 — 캡이 화면보다 넓기 때문이다.
      expect(AppLayout.gutterFor(375, cap: AppLayout.document), 20);
      expect(AppLayout.gutterFor(375, cap: AppLayout.narrow), 20);
    });

    test('오버레이 카드는 폰 335 · 태블릿 480', () {
      expect(AppLayout.cardWidthFor(375), 335);
      expect(AppLayout.cardWidthFor(810), 480);
    });

    test('타일은 폰 1열 · 콘텐츠 600에서 2열 290', () {
      expect(AppLayout.columnsFor(335), 1);
      expect(AppLayout.columnsFor(600), 2);
      expect(AppLayout.tileWidthFor(335), 335);
      expect(AppLayout.tileWidthFor(600), 290); // 290 + 20 + 290 = 600
    });

    test('폭이 최소 타일보다 좁아도 0열이 되지 않는다', () {
      expect(AppLayout.columnsFor(100), 1);
      expect(AppLayout.tileWidthFor(100), 100);
    });
  });

  group('ContentColumn — 렌더 실측', () {
    for (final (width, inset, content) in const <(double, double, double)>[
      (375, 20, 335),
      (640, 20, 600),
      (810, 105, 600),
      (1024, 212, 600),
    ]) {
      testWidgets('폭 $width 에서 여백 $inset · 콘텐츠 $content', (tester) async {
        await pumpAt(
          tester,
          width,
          const ContentColumn(
            child: SizedBox(
              key: Key('body'),
              height: 10,
              width: double.infinity,
            ),
          ),
        );
        final box = tester.getRect(find.byKey(const Key('body')));
        expect(box.left, inset);
        expect(box.width, content);
      });
    }

    testWidgets('세로 패딩은 여백에 더해진다', (tester) async {
      await pumpAt(
        tester,
        810,
        const ContentColumn(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: SizedBox(key: Key('body'), height: 10, width: double.infinity),
        ),
      );
      final box = tester.getRect(find.byKey(const Key('body')));
      expect(box.left, 105);
      expect(box.top, 14);
    });

    testWidgets('gutter 를 키우면 폰 값만 올라가고 태블릿은 그대로다', (tester) async {
      // 로그인 화면이 이 경우다(폰 여백 40).
      await pumpAt(
        tester,
        375,
        const ContentColumn(
          gutter: 40,
          child: SizedBox(key: Key('body'), height: 10, width: double.infinity),
        ),
      );
      expect(tester.getRect(find.byKey(const Key('body'))).left, 40);

      await pumpAt(
        tester,
        810,
        const ContentColumn(
          gutter: 40,
          child: SizedBox(key: Key('body'), height: 10, width: double.infinity),
        ),
      );
      expect(tester.getRect(find.byKey(const Key('body'))).left, 105);
    });

    // 회귀: LayoutBuilder 로 짰을 때 IntrinsicHeight 아래에서 전부 죽었다
    // (「LayoutBuilder does not support returning intrinsic dimensions」).
    // 빈 상태·오류 화면이 세로 중앙 정렬을 위해 쓰는 조합이라 5개 화면 ×
    // 30 로케일이 한꺼번에 무너졌다.
    testWidgets('IntrinsicHeight 안에서도 고유 크기를 답한다', (tester) async {
      await pumpAt(
        tester,
        810,
        SingleChildScrollView(
          child: IntrinsicHeight(
            child: ContentColumn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(key: Key('body'), height: 10, width: double.infinity),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.byKey(const Key('body'))).left, 105);
    });
  });

  group('AdaptiveTiles — 열 수', () {
    testWidgets('폰 폭에서는 1열 세로 목록', (tester) async {
      await pumpAt(
        tester,
        375,
        const ContentColumn(
          child: AdaptiveTiles(
            stackedGap: 12,
            children: [
              SizedBox(key: Key('t0'), height: 40, width: double.infinity),
              SizedBox(key: Key('t1'), height: 40, width: double.infinity),
            ],
          ),
        ),
      );
      final a = tester.getRect(find.byKey(const Key('t0')));
      final b = tester.getRect(find.byKey(const Key('t1')));
      expect(a.width, 335);
      expect(b.top - a.bottom, 12); // 폰 간격은 그대로 12
      expect(b.left, a.left); // 같은 열
    });

    testWidgets('태블릿 콘텐츠 폭에서는 2열 290 + 20', (tester) async {
      await pumpAt(
        tester,
        810,
        const ContentColumn(
          child: AdaptiveTiles(
            stackedGap: 12,
            children: [
              SizedBox(key: Key('t0'), height: 40, width: double.infinity),
              SizedBox(key: Key('t1'), height: 40, width: double.infinity),
              SizedBox(key: Key('t2'), height: 40, width: double.infinity),
            ],
          ),
        ),
      );
      final a = tester.getRect(find.byKey(const Key('t0')));
      final b = tester.getRect(find.byKey(const Key('t1')));
      final c = tester.getRect(find.byKey(const Key('t2')));
      expect(a.width, 290);
      expect(a.left, 105); // 콘텐츠 컬럼 시작선
      expect(b.left - a.right, 20); // 가로 간격
      expect(c.left, a.left); // 셋째는 다음 줄 왼쪽부터
      expect(c.top - a.bottom, 20); // 여러 열일 때 세로 간격도 20
    });
  });

  group('공용 부품', () {
    testWidgets('GNB 는 배경이 전폭, 내용은 콘텐츠 컬럼 선', (tester) async {
      await pumpAt(
        tester,
        810,
        Gnb.main(title: '제목', onBack: () {}),
      );
      final bar = tester.getRect(find.byType(Gnb));
      expect(bar.width, 810); // 막대 자체는 전폭
      // 뒤로가기 아이콘 상자가 콘텐츠 여백에서 시작한다.
      final back = tester.getRect(find.byType(Row).first);
      expect(back.left, 105);
      expect(back.width, 600);
    });

    testWidgets('하단 탭바는 375로 캡되고 가운데 선다', (tester) async {
      await pumpAt(
        tester,
        810,
        const Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavBar(
            items: [
              BottomNavItem(key: 'calendar', icon: BottomNavGlyph.calendar),
              BottomNavItem(key: 'call', icon: BottomNavGlyph.call),
              BottomNavItem(key: 'history', icon: BottomNavGlyph.history),
            ],
            activeKey: 'call',
          ),
        ),
      );
      final decorated = tester.getRect(
        find.descendant(
          of: find.byType(BottomNavBar),
          matching: find.byType(ConstrainedBox),
        ).first,
      );
      expect(decorated.width, AppLayout.navBar);
      expect(decorated.center.dx, 405); // 810의 한가운데
    });
  });
}
