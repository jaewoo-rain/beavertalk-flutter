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

    test('서버가 보내지 않는 필드는 무시한다 — 문장 id 는 힌트에 없다', () {
      // 힌트 시점에 서버는 DB 를 안 건드린다(문장은 🔖 를 누를 때 생긴다).
      // 낯선 키가 섞여 와도 파싱이 깨지지 않아야 통화가 안 죽는다.
      final hint = HintData.fromJson({
        'turn_id': 't1',
        'examples': [
          {'korean': '가요', 'native': 'go', 'id': 7},
          {'korean': '와요', 'native': 'come', 'id': 'x'},
        ],
      });
      expect(hint, isNotNull);
      expect(hint!.examples.length, 2);
      expect(hint.examples.first.korean, '가요');
      expect(hint.examples.first.native, 'go');
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

  testWidgets('HintCard full shows the bookmark control and reports taps',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
        onBookmarkTap: () => taps++,
      ),
    ));
    // Outline glyph + "save" label while unsaved.
    final save = find.bySemanticsLabel('Save sentence');
    expect(save, findsOneWidget);
    expect(find.bySemanticsLabel('Remove saved sentence'), findsNothing);

    await tester.tap(save);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('HintCard bookmark control flips its label when saved',
      (tester) async {
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
        bookmarked: true,
        onBookmarkTap: () {},
      ),
    ));
    expect(find.bySemanticsLabel('Remove saved sentence'), findsOneWidget);
    expect(find.bySemanticsLabel('Save sentence'), findsNothing);
  });

  testWidgets('HintCard draws both controls even with no callbacks',
      (tester) async {
    // 데이터가 없다고 카드에 속한 컨트롤이 사라지면 안 된다 — 스피커가 정확히 그렇게
    // 앱에서 한 번도 안 보였다(call.dart 가 onSpeak 을 안 넘겨서).
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
      ),
    ));
    expect(find.bySemanticsLabel('Save sentence'), findsOneWidget);
    expect(
        find.bySemanticsLabel('Listen to standard pronunciation'),
        findsOneWidget);
  });

  testWidgets('HintCard peek carries both controls too', (tester) async {
    var speaks = 0;
    var reveals = 0;
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: false,
        index: 0,
        onReveal: () => reveals++,
        onCycle: () {},
        onSpeak: () => speaks++,
        onBookmarkTap: () {},
      ),
    ));
    expect(find.bySemanticsLabel('Save sentence'), findsOneWidget);
    final speak = find.bySemanticsLabel('Listen to standard pronunciation');
    expect(speak, findsOneWidget);

    // peek 에서 버튼을 눌러도 카드가 펼쳐지지 않는다.
    await tester.tap(speak);
    await tester.pump();
    expect(speaks, 1);
    expect(reveals, 0);
  });

  testWidgets('HintCard full speaker reports taps', (tester) async {
    var speaks = 0;
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
        onSpeak: () => speaks++,
      ),
    ));
    await tester.tap(find.bySemanticsLabel('Listen to standard pronunciation'));
    await tester.pump();
    expect(speaks, 1);
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

  testWidgets('SpeakingEqualizer builds and animates without throwing',
      (tester) async {
    await tester.pumpWidget(_host(const Center(child: SpeakingEqualizer())));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SpeakingEqualizer), findsOneWidget);
  });
}
