// **표현학습**에만 힌트 UI 가 없다 — 사장님 결정(2026-09-12, 같은 날 두 번).
//
// 처음엔 코스 통화 둘(표현학습·프리토킹) 다 가렸는데(11c420b), 사장님이 「프리토킹엔
// 힌트가 보여야 한다」 로 바꾸셨다. 서버는 표현학습에만 `hint` 프레임을 안 보낸다 —
// 토글을 그대로 두면 「눌러도 아무것도 안 나오는 버튼」이 된다. 프리토킹은 일반 통화와
// 같은 힌트 상자(ServerHint → 접힌 카드 → 열람 시 hint_used)다. 자막·마이크·끊기는 그대로.
//
// ⭐ 세 방향을 다 잠근다 — 표현학습에서 없어지는 것, **프리토킹에서 있는 것**, 일반
//   통화에서 그대로 있는 것. 뒤의 둘이 빠지면 조건을 «course != null» 로 되돌려도 초록이다.
//
// 하네스는 call_screen_layout_test 와 같다(고정 [CallState] 스텁 · Max 플랜).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/hint_card.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';

/// 고정 [CallState] — 진짜 `build()` 는 소켓과 오디오를 연다.
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

const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);

/// 힌트가 **도착해 있고 토글도 켜진** 상태로 띄운다 — 힌트가 그려질 수 있는 최대
/// 조건이다. 그래도 코스 통화면 안 그려져야 한다.
Future<void> _pump(WidgetTester tester, {CallCourse? course}) async {
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
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider
            .overrideWith(() => _StubCallController(state)),
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
}

Finder get _hintToggle => find.bySemanticsLabel('Hint');
Finder get _subtitleToggle => find.bySemanticsLabel('Subtitle');

void main() {
  testWidgets('course=expression — 힌트 토글도 힌트 카드도 없다. 자막 토글은 그대로',
      (tester) async {
    await _pump(tester, course: CallCourse.expression);

    expect(_hintToggle, findsNothing, reason: '서버가 힌트를 안 보내는 코스다');
    expect(find.byType(HintCard), findsNothing,
        reason: '힌트가 도착해 있고 토글이 켜져 있어도 코스 통화면 안 그린다');
    expect(_subtitleToggle, findsOneWidget, reason: '자막은 코스와 무관하다');
  });

  testWidgets('⭐ course=freetalk — 일반 통화와 **같이** 힌트 토글·카드가 있다',
      (tester) async {
    // 처음 판(11c420b)은 여기서 findsNothing 이었다. 사장님이 뒤집으셨다.
    await _pump(tester, course: CallCourse.freetalk);

    expect(_hintToggle, findsOneWidget, reason: '프리토킹엔 힌트가 보여야 한다');
    expect(find.byType(HintCard), findsOneWidget);
    expect(_subtitleToggle, findsOneWidget);
  });

  testWidgets('course=auto(call_started 전) — 가리지 않는다. 깜빡임 방지', (tester) async {
    // auto 는 call_started.course 가 오기 전까지 잠깐 남는 요청 값이다. 이 순간 가리면
    // freetalk 으로 풀릴 때 토글이 사라졌다 돌아온다. 그 사이 힌트는 안 오니 보여도 무해.
    await _pump(tester, course: CallCourse.auto);

    expect(_hintToggle, findsOneWidget);
  });

  testWidgets('course=null(일반 통화) — 힌트 토글과 카드가 **그대로** 있다',
      (tester) async {
    // ⭐ 회귀의 반쪽. 이게 없으면 조건을 거꾸로 써도 위 두 시험은 초록이다.
    await _pump(tester);

    expect(_hintToggle, findsOneWidget, reason: '기존 동작 — 한 글자도 안 바뀐다');
    expect(find.byType(HintCard), findsOneWidget);
    expect(_subtitleToggle, findsOneWidget);
  });
}
