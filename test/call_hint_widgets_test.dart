import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/call_toggle_button.dart';
import 'package:beavertalk/components/atoms/speaking_equalizer.dart';
import 'package:beavertalk/components/icons/app_icons.dart';
import 'package:beavertalk/components/molecules/hint_card.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

/// Widgets that call `AppLocalizations.of(context)` (HintCard's counter/label)
/// crash with a null-check unless the host installs the l10n delegates — the
/// real app wires these in `main.dart`. Mirror that here.
Widget _host(Widget body) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: body),
    );

void main() {
  group('HintData.fromJson', () {
    test('parses examples and drops empty-Korean ones', () {
      final hint = HintData.fromJson({
        'type': 'hint',
        'turn_id': 't1',
        'examples': [
          {'korean': '화장실에 가요', 'roman': 'hwajangsire gayo', 'native': 'restroom'},
          {'korean': '', 'roman': 'x', 'native': 'y'}, // dropped
          {'korean': '집에 가요', 'native': 'home'}, // null roman ok
        ],
      });
      expect(hint, isNotNull);
      expect(hint!.turnId, 't1');
      expect(hint.examples.length, 2);
      expect(hint.examples[1].roman, isNull);
    });

    test('returns null when no usable example', () {
      expect(
        HintData.fromJson({'turn_id': 't1', 'examples': []}),
        isNull,
      );
      expect(HintData.fromJson({'examples': []}), isNull); // no turn_id
    });
  });

  const examples = [
    HintExample(korean: '화장실에 가요', roman: 'hwajangsire gayo', native: 'restroom'),
    HintExample(korean: '학교에 가요', roman: 'hakgyoe gayo', native: 'school'),
    HintExample(korean: '집에 가요', roman: 'jibe gayo', native: 'home'),
  ];

  testWidgets('HintCard peek → tap fires onReveal exactly once', (tester) async {
    var reveals = 0;
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: false,
        index: 0,
        onReveal: () => reveals++,
        onCycle: () {},
      ),
    ));
    // Peek shows only the first Korean line; roman/native hidden.
    expect(find.text('화장실에 가요'), findsOneWidget);
    expect(find.text('hwajangsire gayo'), findsNothing);

    await tester.tap(find.byType(HintCard));
    await tester.pump();
    expect(reveals, 1);
  });

  testWidgets('HintCard full shows roman/native + counter and cycles',
      (tester) async {
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: true,
        index: 1,
        onReveal: () {},
        onCycle: () {},
      ),
    ));
    expect(find.text('Hint'), findsOneWidget);
    expect(find.text('2/3'), findsOneWidget);
    expect(find.text('학교에 가요'), findsOneWidget);
    expect(find.text('hakgyoe gayo'), findsOneWidget);
    expect(find.text('school'), findsOneWidget);
  });

  testWidgets('CallToggleButton reports toggled value', (tester) async {
    bool? got;
    await tester.pumpWidget(_host(
      Center(
        child: CallToggleButton(
          icon: AppIcons.lightbulb,
          active: true,
          activeFill: const Color(0xFFD17600),
          semanticLabel: 'Hint',
          onChanged: (v) => got = v,
        ),
      ),
    ));
    await tester.tap(find.byType(CallToggleButton));
    await tester.pump();
    expect(got, false); // was active:true → toggles to false
  });

  testWidgets('CallToggleButton 켜고 꺼도 상자 크기가 그대로다', (tester) async {
    // 켜짐/꺼짐의 테두리 선언이 갈리면(`BorderSide.none` ↔ 1px) 상자가 상태에
    // 따라 달라질 여지가 생긴다. 지금은 폭 1px 을 고정하고 색만 투명으로
    // 보간하므로 그 여지가 없다 — 그 사실을 여기서 못 박는다.
    // (통화 화면 버튼이 스스로 자리를 옮기면 눌러 놓고 딴 데를 누르게 된다.)
    Widget build(bool active) => _host(
          Center(
            child: CallToggleButton(
              icon: AppIcons.lightbulb,
              active: active,
              activeFill: const Color(0xFFD17600),
              semanticLabel: 'Hint',
              onChanged: (_) {},
            ),
          ),
        );

    await tester.pumpWidget(build(false));
    final Size off = tester.getSize(find.byType(CallToggleButton));

    await tester.pumpWidget(build(true));
    await tester.pump(const Duration(milliseconds: 200));
    final Size on = tester.getSize(find.byType(CallToggleButton));

    expect(on, off, reason: '상태에 따라 버튼 크기가 달라지면 안 된다');
  });

  testWidgets('SpeakingEqualizer builds and animates without throwing',
      (tester) async {
    await tester.pumpWidget(_host(const Center(child: SpeakingEqualizer())));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SpeakingEqualizer), findsOneWidget);
  });
}
