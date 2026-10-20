import 'package:beavertalk/features/normalcall/presentation/widgets/script_card.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 대본 읽기 시제품 카드(PM-DEC-877) — 서버 메시지로만 그리고, 메시지가 없으면 빈 상자다.
void main() {
  Future<void> pump(WidgetTester tester) => tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [AppColorTokens.dark]),
        home: const Scaffold(body: Column(children: [ScriptCard()])),
      ));

  testWidgets('메시지가 없으면 아무것도 안 그린다', (tester) async {
    await pump(tester);
    expect(find.text('다시 읽어 보세요'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('script_line → 줄·진행 · fail → 다시 읽기 · script_end → 대본 끝', (tester) async {
    await pump(tester);
    ScriptCard.apply({'type': 'script_line', 'n': 2, 'total': 11, 'ko': '조금 싱겁네요.', 'roman': '', 'en': "It's a little bland.", 'attempt': 1});
    await tester.pump();
    expect(find.text('2/11'), findsOneWidget);
    expect(find.text('조금 싱겁네요.'), findsOneWidget);
    expect(find.text("It's a little bland."), findsOneWidget);
    expect(find.text('다시 읽어 보세요'), findsNothing);
    ScriptCard.apply({'type': 'script_result', 'n': 2, 'result': 'fail', 'attempt': 1});
    await tester.pump();
    expect(find.text('다시 읽어 보세요'), findsOneWidget);
    ScriptCard.apply({'type': 'script_end', 'total': 11});
    await tester.pump();
    expect(find.text('대본 끝'), findsOneWidget);
  });
}
