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

  // 2026-09-12 정본(`card/hint` `3229:56`)에서 **peek 은 듣기·저장을 내려놓았다.**
  // 접힌 카드가 하는 일은 「무슨 문장인지 힐끗 본다」 하나이고, 70px 한 줄에
  // 버튼 셋이 붙어 정작 문장 폭을 먹고 있었다. 종전 테스트는 그 셋이 다 있다고
  // 단언했으므로 계약과 함께 갈아 끼운다.
  testWidgets('HintCard peek 은 머리행과 문장만 보여 준다 — 듣기·저장은 없다',
      (tester) async {
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: false,
        index: 0,
        onReveal: () {},
        onCycle: () {},
        onSpeak: () {},
        onBookmarkTap: () {},
      ),
    ));

    // 머리행은 full 과 같다 — 접혀 있어도 몇 번째인지 알 수 있어야 한다.
    expect(find.text('Hint'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
    // 문장 한 줄만. 상세는 감춰 둔다.
    expect(find.text('화장실에 가요'), findsOneWidget);
    expect(find.text('hwajangsire gayo'), findsNothing);
    // 듣기·저장은 펼친 뒤의 행동이다.
    expect(find.bySemanticsLabel('Listen to standard pronunciation'),
        findsNothing);
    expect(find.bySemanticsLabel('Save sentence'), findsNothing);
  });

  testWidgets('HintCard peek 은 첫 예문이 아니라 현재 예문을 보여 준다',
      (tester) async {
    // 🔴 종전엔 `examples.first` 를 그렸다 — 사이클을 돌리고 접으면 1번으로
    //    되돌아가 보여, 접힌 카드가 지금 몇 번째인지 거짓말을 했다.
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: false,
        index: 1,
        onReveal: () {},
        onCycle: () {},
      ),
    ));

    expect(find.text('학교에 가요'), findsOneWidget);
    expect(find.text('화장실에 가요'), findsNothing);
    expect(find.text('2/3'), findsOneWidget);
  });

  testWidgets('HintCard peek 의 사이클을 눌러도 카드가 펼쳐지지 않는다',
      (tester) async {
    var cycles = 0;
    var reveals = 0;
    await tester.pumpWidget(_host(
      HintCard(
        examples: examples,
        revealed: false,
        index: 0,
        onReveal: () => reveals++,
        onCycle: () => cycles++,
      ),
    ));

    // 카드 전체가 펼치기 타깃이라, 안쪽 버튼이 탭을 먼저 먹는지가 관건이다.
    await tester.tap(find.bySemanticsLabel('Next hint 1/3'));
    await tester.pump();
    expect(cycles, 1);
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
