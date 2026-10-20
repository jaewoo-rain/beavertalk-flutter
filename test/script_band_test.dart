import 'package:beavertalk/features/normalcall/presentation/widgets/script_band.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 대본 읽기 자막 띠(PM-DEC-893) — 서버 메시지로만 그리고, 메시지가 없으면 빈 상자다.
void main() {
  Future<void> pump(WidgetTester tester) => tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [AppColorTokens.light]),
        home: const Scaffold(body: Column(children: [ScriptBand()])),
      ));

  String k(String s) => ScriptBand.keepWords(s);

  Color bandColor(WidgetTester tester) =>
      (tester.widget<Container>(find.byKey(const ValueKey('script-band'))).color)!;

  setUp(ScriptBand.reset);

  testWidgets('메시지가 없으면 아무것도 안 그린다', (tester) async {
    await pump(tester);
    expect(find.byKey(const ValueKey('script-band')), findsNothing);
  });

  testWidgets('바바 줄 파랑 → 학습자 줄 빨강 → 화냄 클립 → 다시 읽기 0.9', (tester) async {
    await pump(tester);
    final c = AppColorTokens.light;
    ScriptBand.apply({'type': 'script_beaver', 'n': 3, 'total': 11, 'ko': '그래요? 그럼 소금을 좀 넣을까요?',
        'gloss': 'Really? Then shall I add some salt?', 'roman': 'Geuraeyo? Geureom sogeumeul jom neoeulkkayo?'});
    await tester.pump();
    expect(find.text(k('그래요? 그럼 소금을 좀 넣을까요?')), findsOneWidget);
    expect(find.text('Really? Then shall I add some salt?'), findsOneWidget);
    expect(find.text('/Geuraeyo? Geureom sogeumeul jom neoeulkkayo?/'), findsOneWidget);
    expect(bandColor(tester), c.accentForegroundBlue.withValues(alpha: 0.8));

    ScriptBand.apply({'type': 'script_line', 'n': 3, 'total': 11, 'ko': '아니요, 괜찮아요.', 'roman': 'Aniyo, gwaenchanayo.',
        'en': "No, it's fine.", 'attempt': 1});
    await tester.pump();
    expect(find.text(k('아니요, 괜찮아요.')), findsOneWidget);
    expect(find.text("No, it's fine."), findsOneWidget);
    expect(bandColor(tester), c.accentBackgroundRed.withValues(alpha: 0.8));

    ScriptBand.apply({'type': 'script_say', 'kind': 'angry', 'text': "That's not it. Read it again.", 'sec': 0.5});
    await tester.pump();
    expect(find.text("That's not it. Read it again."), findsOneWidget);
    expect(find.text("No, it's fine."), findsNothing); // 영어 클립 띠에는 뜻이 없다
    expect(bandColor(tester), c.accentForegroundBlue.withValues(alpha: 0.8));

    ScriptBand.apply({'type': 'script_line', 'n': 3, 'total': 11, 'ko': '아니요, 괜찮아요.', 'roman': 'Aniyo, gwaenchanayo.',
        'en': "No, it's fine.", 'attempt': 2});
    await tester.pump();
    expect(bandColor(tester), c.accentBackgroundRed.withValues(alpha: 0.9));
  });

  testWidgets('영어 클립은 sec 뒤 직전 줄로 돌아간다 · end 는 그대로', (tester) async {
    await pump(tester);
    ScriptBand.apply({'type': 'script_line', 'n': 1, 'total': 11, 'ko': '와, 맛있겠네요.', 'roman': '', 'en': 'Wow.', 'attempt': 1});
    ScriptBand.apply({'type': 'script_say', 'kind': 'again', 'text': 'Go ahead, read it.', 'sec': 0.3});
    await tester.pump();
    expect(find.text('Go ahead, read it.'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(k('와, 맛있겠네요.')), findsOneWidget);
    ScriptBand.apply({'type': 'script_say', 'kind': 'end', 'text': 'All done!', 'sec': 0.3});
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('All done!'), findsOneWidget);
  });

  test('어절 안에서는 끊지 않는다(글자 사이 WORD JOINER · 띄어쓰기는 그대로)', () {
    expect(ScriptBand.keepWords('좋아해요 정말'), '좋⁠아⁠해⁠요 정⁠말');
  });
}
