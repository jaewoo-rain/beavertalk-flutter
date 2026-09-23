import 'package:beavertalk/components/layout/need_based_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// 폭을 **필요에 따라** 나누는 행 세 가지(09-24 「칸이 남는데 줄바꿈」 전수조사).
void main() {
  const style = TextStyle(fontSize: 14);

  Future<void> pump(WidgetTester tester, Widget child,
      {double width = 300, TextDirection dir = TextDirection.ltr}) async {
    await tester.pumpWidget(Directionality(
      textDirection: dir,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ));
  }

  /// 글자가 몇 줄로 그려졌나 — 선택 상자의 윗변 개수.
  int lines(WidgetTester tester, String text) {
    final ro = tester.renderObject<RenderParagraph>(find.text(text));
    return ro
        .getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: text.length))
        .map((b) => b.top.round())
        .toSet()
        .length;
  }

  group('LabelValueRow', () {
    testWidgets('둘이 한 줄에 들어가면 라벨은 왼쪽 끝, 값은 오른쪽 끝(spaceBetween)', (tester) async {
      await pump(tester,
          LabelValueRow(label: const Text('Plan', style: style), value: const Text('Premium', style: style)));
      expect(tester.getTopLeft(find.text('Plan')).dx, 0);
      expect(tester.getTopRight(find.text('Premium')).dx, 300);
    });

    testWidgets('⭐ 짧은 라벨 옆 긴 값은 라벨이 남긴 폭을 쓴다 — 설정 이메일(09-24 실기기)', (tester) async {
      const email = 'bt.qa.free0924@example.com';
      // 시험 글꼴은 글자당 14px — 라벨 70 + 간격 8 + 이메일 364 = 442 가 460 행에 들어간다.
      // 옛 2:3 분할이면 값 칸은 (460−8)×0.6 = 271 이라 줄을 바꿨다.
      await pump(tester,
          LabelValueRow(label: const Text('Email', style: style), value: const Text(email, style: style)),
          width: 460);
      expect(lines(tester, email), 1, reason: '값이 한 줄 — 라벨 몫을 비워 두지 않는다');
      expect(lines(tester, 'Email'), 1);
      expect(tester.getTopRight(find.text(email)).dx, 460);
    });

    testWidgets('둘 다 길면 긴 쪽이 줄을 바꾸고 짧은 낱말은 끊지 않는다', (tester) async {
      const label = 'Label';
      const value = 'a very long value that certainly needs more than one line here';
      await pump(tester,
          LabelValueRow(label: const Text(label, style: style), value: const Text(value, style: style)),
          width: 260);
      expect(lines(tester, label), 1, reason: '짧은 라벨은 낱말 중간에서 끊지 않는다');
      expect(lines(tester, value), greaterThan(1));
    });

    testWidgets('오른쪽→왼쪽 언어에서는 좌우가 뒤집힌다', (tester) async {
      await pump(
          tester,
          LabelValueRow(label: const Text('A', style: style), value: const Text('B', style: style)),
          dir: TextDirection.rtl);
      expect(tester.getTopRight(find.text('A')).dx, 300);
      expect(tester.getTopLeft(find.text('B')).dx, 0);
    });
  });

  group('CenteredTitleRow', () {
    testWidgets('취소는 자기 폭만, 제목은 행의 가운데 — 긴 「キャンセル」 도 한 줄', (tester) async {
      await pump(
          tester,
          CenteredTitleRow(
            leading: const Text('キャンセル', style: style),
            title: const Text('Title', style: style, textAlign: TextAlign.center),
          ),
          width: 320);
      expect(lines(tester, 'キャンセル'), 1);
      expect(tester.getCenter(find.text('Title')).dx, closeTo(160, 0.5));
    });
  });

  group('EqualButtonPair', () {
    Widget btn(String t) => SizedBox(
          height: 60,
          child: Center(child: Text(t, style: style, maxLines: 2)),
        );

    testWidgets('둘 다 반 폭에 들어가면 같은 폭 가로(보조 왼쪽 · 주요 오른쪽)', (tester) async {
      await pump(tester, EqualButtonPair(secondary: btn('Home'), primary: btn('Call')), width: 300);
      final home = tester.getRect(find.ancestor(of: find.text('Home'), matching: find.byType(SizedBox)).first);
      final call = tester.getRect(find.ancestor(of: find.text('Call'), matching: find.byType(SizedBox)).first);
      expect(home.width, call.width);
      expect(home.left, 0);
      expect(call.right, 300);
      expect(home.top, call.top);
    });

    testWidgets('한쪽이 반 폭에 안 들어가면 세로로 쌓는다 — 주요 버튼 위', (tester) async {
      const long = 'A primary label that is far too long for half the row';
      await pump(tester, EqualButtonPair(secondary: btn('Home'), primary: btn(long)), width: 300);
      final home = tester.getRect(find.ancestor(of: find.text('Home'), matching: find.byType(SizedBox)).first);
      final main = tester.getRect(find.ancestor(of: find.text(long), matching: find.byType(SizedBox)).first);
      expect(main.top, lessThan(home.top), reason: '주요 버튼이 위');
      expect(main.width, 300);
      expect(home.width, 300);
      expect(home.top - main.bottom, 10, reason: '간격 10');
    });
  });
}
