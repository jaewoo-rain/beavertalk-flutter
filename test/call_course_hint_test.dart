// **표현학습**에만 힌트가 없다 — 사장님 결정(2026-09-12, 같은 날 두 번).
//
// 처음엔 코스 통화 둘(표현학습·프리토킹) 다 가렸는데(11c420b), 사장님이 「프리토킹엔
// 힌트가 보여야 한다」 로 바꾸셨다. 서버는 표현학습에만 `hint` 프레임을 안 보낸다.
// 프리토킹은 일반 통화와 같은 힌트 상자(ServerHint → 접힌 카드 → 열람 시 hint_used)다.
//
// ⭐ 2026-09-15 사장님 결정: 표현학습에서도 힌트 **버튼은 숨기지 않는다.** 그대로 두고,
//   누르면 「표현 학습에서는 힌트를 쓸 수 없어요」 말풍선(Figma `tooltip/hint_locked`)을
//   띄운다. 종전(버튼 자체를 뺌)은 「왜 힌트가 없지」를 설명하지 못했다.
//
// ⭐ 세 방향을 다 잠근다 — 표현학습에서 달라지는 것, **프리토킹에서 그대로인 것**, 일반
//   통화에서 그대로인 것. 뒤의 둘이 빠지면 조건을 «course != null» 로 되돌려도 초록이다.
//
// 하네스는 call_screen_layout_test 와 같다(고정 [CallState] 스텁 · Max 플랜).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/hint_card.dart';
import 'package:beavertalk/components/molecules/tooltip_bubble.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';
import 'package:beavertalk/theme/app_motion.dart';

/// 고정 [CallState] — 진짜 `build()` 는 소켓과 오디오를 연다.
///
/// [setHintOn] 을 가로채 기록한다 — 표현학습에서 버튼을 눌러도 토글이 **안** 불려야 한다.
class _StubCallController extends NormalCallController {
  _StubCallController(this._state);
  final CallState _state;
  final List<bool> hintOnCalls = <bool>[];
  @override
  CallState build() => _state;
  @override
  void setHintOn(bool value) => hintOnCalls.add(value);
}

final _hint = HintData.fromJson({
  'type': 'hint',
  'turn_id': 't1',
  'examples': [
    {'korean': '화장실에 가요', 'roman': 'hwajangsire gayo', 'native': 'restroom'},
  ],
})!;

const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);

/// 말풍선이 떠 있는 시간 — 2.5초(09-15 「더 빨리」로 4초에서 줄였다).
const _dwell = Duration(milliseconds: 2500);

/// 힌트가 **도착해 있고 토글도 켜진** 상태로 띄운다 — 힌트가 그려질 수 있는 최대
/// 조건이다. 그래도 표현학습이면 안 그려져야 한다.
Future<_StubCallController> _pump(
  WidgetTester tester, {
  CallCourse? course,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final state = CallState(
    phase: CallPhase.inCall,
    beaverSubtitle: '안녕하세요.',
    hint: _hint,
    hintOn: true,
    course: course,
  );
  final controller = _StubCallController(state);
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider.overrideWith(() => controller),
        subscriptionStatusProvider.overrideWithValue(_max),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CallScreen(),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 32));
  return controller;
}

Finder get _hintToggle => find.bySemanticsLabel('Hint');
Finder get _subtitleToggle => find.bySemanticsLabel('Subtitle');
Finder get _bubble => find.byType(TooltipBubble);

/// 등장·퇴장 모션이 끝날 만큼 흘린다.
///
/// ⚠ 먼저 `pump()` 한 번으로 **다시 그리기만** 한다. 상태가 바뀐 직후의 첫 프레임은
///   애니메이션을 *시작*할 뿐이라, 거기에 시간을 얹어 한 번에 흘리면 경과 0 으로
///   남아 퇴장 중인 말풍선이 그대로 잡힌다.
///
/// 퇴장(`AppMotion.page` 260ms)이 등장(`medium` 180ms)보다 길어서 퇴장 쪽에 맞춘다.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(AppMotion.page + const Duration(milliseconds: 16));
}

void main() {
  testWidgets('course=expression — 힌트 버튼은 **있고** 힌트 카드는 없다. 자막 토글도 그대로',
      (tester) async {
    await _pump(tester, course: CallCourse.expression);

    expect(_hintToggle, findsOneWidget, reason: '2026-09-15 — 버튼을 숨기지 않는다');
    expect(find.byType(HintCard), findsNothing,
        reason: '힌트가 도착해 있고 토글이 켜져 있어도 표현학습이면 안 그린다');
    expect(_subtitleToggle, findsOneWidget, reason: '자막은 코스와 무관하다');
    expect(_bubble, findsNothing, reason: '누르기 전에는 말풍선이 없다');
  });

  testWidgets('course=expression — 힌트 버튼을 누르면 말풍선이 뜨고 토글은 안 바뀐다',
      (tester) async {
    final controller = await _pump(tester, course: CallCourse.expression);

    await tester.tap(_hintToggle);
    await _settle(tester);

    expect(_bubble, findsOneWidget);
    final l10n = AppLocalizations.of(tester.element(_bubble));
    expect(find.text(l10n.callHintLockedTitle), findsOneWidget);
    expect(controller.hintOnCalls, isEmpty, reason: '표현학습에서 힌트 on/off 는 의미가 없다');
  });

  testWidgets('course=expression — 말풍선은 4초 뒤 사라지고, 다시 누르면 시간을 새로 센다',
      (tester) async {
    await _pump(tester, course: CallCourse.expression);

    await tester.tap(_hintToggle);
    await _settle(tester);
    await tester.pump(_dwell - const Duration(seconds: 1));
    expect(_bubble, findsOneWidget, reason: '아직 4초 전이다');

    // 떠 있는 동안 다시 누르면 한 장 그대로 두고 타이머만 새로 건다.
    await tester.tap(_hintToggle);
    await _settle(tester);
    await tester.pump(_dwell - const Duration(seconds: 1));
    expect(_bubble, findsOneWidget, reason: '재탭으로 시간을 새로 셌다');

    await tester.pump(const Duration(seconds: 1));
    await _settle(tester);
    expect(_bubble, findsNothing, reason: '재탭 후 4초가 지났다');
  });

  testWidgets('course=expression — 화면 다른 곳을 누르면 말풍선이 바로 닫힌다',
      (tester) async {
    await _pump(tester, course: CallCourse.expression);

    await tester.tap(_hintToggle);
    await _settle(tester);
    expect(_bubble, findsOneWidget);

    await tester.tapAt(const Offset(187, 300));
    await _settle(tester);
    expect(_bubble, findsNothing);
  });

  testWidgets('course=expression — 떠 있을 때 힌트 버튼을 누르고 있어도 말풍선이 깜빡이지 않는다',
      (tester) async {
    await _pump(tester, course: CallCourse.expression);

    await tester.tap(_hintToggle);
    await _settle(tester);

    // 손가락을 댄 채로 퇴장 모션 길이만큼 기다린다. 버튼 위 탭까지 닫으면 여기서
    // 불투명도가 0 을 향해 내려간다.
    final gesture = await tester.startGesture(tester.getCenter(_hintToggle));
    await tester.pump();
    await tester.pump(AppMotion.page);
    final fade = tester.widget<FadeTransition>(
      find.ancestor(of: _bubble, matching: find.byType(FadeTransition)).first,
    );
    expect(fade.opacity.value, 1.0, reason: '버튼 위 탭은 말풍선을 닫지 않는다');

    await gesture.up();
    await _settle(tester);
    expect(_bubble, findsOneWidget);
  });

  testWidgets('⭐ course=freetalk — 일반 통화와 **같이** 힌트 토글·카드가 있고 말풍선은 없다',
      (tester) async {
    // 처음 판(11c420b)은 여기서 findsNothing 이었다. 사장님이 뒤집으셨다.
    final controller = await _pump(tester, course: CallCourse.freetalk);

    expect(_hintToggle, findsOneWidget, reason: '프리토킹엔 힌트가 보여야 한다');
    expect(find.byType(HintCard), findsOneWidget);
    expect(_subtitleToggle, findsOneWidget);

    await tester.tap(_hintToggle);
    await _settle(tester);
    expect(_bubble, findsNothing, reason: '프리토킹의 힌트 버튼은 평소대로 토글이다');
    expect(controller.hintOnCalls, [false]);
  });

  testWidgets('course=auto(call_started 전) — 가리지 않는다. 깜빡임 방지', (tester) async {
    // auto 는 call_started.course 가 오기 전까지 잠깐 남는 요청 값이다. 이 순간 가리면
    // freetalk 으로 풀릴 때 토글이 사라졌다 돌아온다. 그 사이 힌트는 안 오니 보여도 무해.
    await _pump(tester, course: CallCourse.auto);

    expect(_hintToggle, findsOneWidget);
  });

  testWidgets('course=null(일반 통화) — 힌트 토글과 카드가 **그대로** 있다',
      (tester) async {
    // ⭐ 회귀의 반쪽. 이게 없으면 조건을 거꾸로 써도 위 시험들은 초록이다.
    final controller = await _pump(tester);

    expect(_hintToggle, findsOneWidget, reason: '기존 동작 — 한 글자도 안 바뀐다');
    expect(find.byType(HintCard), findsOneWidget);
    expect(_subtitleToggle, findsOneWidget);

    await tester.tap(_hintToggle);
    await _settle(tester);
    expect(_bubble, findsNothing);
    expect(controller.hintOnCalls, [false]);
  });
}
