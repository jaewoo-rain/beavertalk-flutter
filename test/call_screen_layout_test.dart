// Layout contract of the in-call screen across the four Figma variants
// (`workspace / screen/call_main`, 3969:20583 / 20610 / 20634 / 20656).
//
// Two things here are easy to regress and invisible in a unit test of the parts
// (see call_hint_widgets_test.dart, which covers the widgets themselves):
//
// 1. The caption slot swaps between the subtitle and the equalizer. Every
//    variant shows exactly one of them, never both and never neither.
// 2. The feed, the caption slot and the hint card are one bottom-anchored
//    block, so opening the hint card pushes the feed *up*. The design encodes
//    this as the feed starting at y=279 with hints off and y=140 with them on.
//
// The surface is pinned to the Figma frame (375×812 at dpr 1). The default
// 800×600 test window is both wider and much shorter, which makes the 16:9 feed
// 450 tall and pushes the column into its scrolling regime — where every
// variant pins the feed to the top and the position assertion says nothing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/speaking_equalizer.dart';
import 'package:beavertalk/components/molecules/hint_card.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/screens/home/call.dart';

/// Holds a fixed [CallState] — the real `build()` opens a socket and starts the
/// audio pipeline, neither of which exists in a widget test.
class _StubCallController extends NormalCallController {
  _StubCallController(this._state);

  final CallState _state;

  @override
  CallState build() => _state;
}

final _hint = HintData.fromJson({
  'type': 'hint',
  'turn_id': 't1',
  'examples': [
    {'korean': '화장실에 가요', 'roman': 'hwajangsire gayo', 'native': 'restroom'},
  ],
})!;

const _subtitle = 'Can you try this one? 안녕하세요. 어디 가세요? Repeat it';

void _useFigmaFrame(WidgetTester tester) {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// 영상 아바타는 **Max 전용**이다(Figma 04_통화). 피드 위치를 재는 테스트는
/// 그 밴드가 있어야 성립하므로 Max 로 고정한다. 플랜 분기 자체는 아래 별도
/// 케이스가 검증한다.
const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);
const _free = SubscriptionStatus(
  state: SubscriptionState.free,
  tier: SubscriptionTier.free,
);

Future<void> _pumpCall(
  WidgetTester tester, {
  required bool subtitleOn,
  required bool hintOn,
  SubscriptionStatus status = _max,
}) async {
  final state = CallState(
    phase: CallPhase.inCall,
    beaverSubtitle: _subtitle,
    hint: _hint,
    subtitleOn: subtitleOn,
    hintOn: hintOn,
  );
  // Tear the previous tree down first: pumping a second ProviderScope of the
  // same shape reuses the element, and the swapped override does not take.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider
            .overrideWith(() => _StubCallController(state)),
        subscriptionStatusProvider.overrideWithValue(status),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CallScreen(),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 32));
}

/// Top edge of the 16:9 avatar feed.
double _feedTop(WidgetTester tester) =>
    tester.getTopLeft(find.byType(AspectRatio).first).dy;

void main() {
  testWidgets('caption slot: equalizer when subtitles are off', (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: false, hintOn: false);
    expect(find.byType(SpeakingEqualizer), findsOneWidget);
    expect(find.text(_subtitle), findsNothing);
  });

  testWidgets('caption slot: subtitle when subtitles are on', (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: true, hintOn: false);
    expect(find.text(_subtitle), findsOneWidget);
    expect(find.byType(SpeakingEqualizer), findsNothing);
  });

  testWidgets('hint card follows the hint toggle', (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: true, hintOn: false);
    expect(find.byType(HintCard), findsNothing);

    await _pumpCall(tester, subtitleOn: true, hintOn: true);
    expect(find.byType(HintCard), findsOneWidget);
  });

  testWidgets('the hint card pushes the feed up, it does not hang below it',
      (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: true, hintOn: false);
    final closed = _feedTop(tester);

    await _pumpCall(tester, subtitleOn: true, hintOn: true);
    final open = _feedTop(tester);

    // A feed pinned to the top would leave these equal — the regression this
    // guards against.
    expect(open, lessThan(closed));
  });

  testWidgets('avatar: Max gets the 16:9 video band', (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: true, hintOn: false, status: _max);
    expect(find.byType(AspectRatio), findsWidgets);
    expect(find.byType(ClipOval), findsNothing);
  });

  testWidgets('avatar: Free falls back to the circular still', (tester) async {
    _useFigmaFrame(tester);
    await _pumpCall(tester, subtitleOn: true, hintOn: false, status: _free);
    // 무료에게 영상 밴드가 나가면 유료 기능이 새는 것이다 — 이 줄이 그것을 막는다.
    expect(find.byType(ClipOval), findsOneWidget);
  });
}
