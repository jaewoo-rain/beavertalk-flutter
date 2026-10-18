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
import 'package:beavertalk/components/organisms/bottom_sheet_call_info.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/entities/homework_roleplay.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
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
  bool partner = true,
  bool homeworkExpression = false,
  HomeworkRoleplay? homeworkRoleplay,
  int? assignmentId,
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
    homeworkExpression: homeworkExpression,
    homeworkRoleplay: homeworkRoleplay,
    assignmentId: assignmentId,
  );
  final controller = _StubCallController(state);
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider.overrideWith(() => controller),
        subscriptionStatusProvider.overrideWithValue(_max),
        // 회화학습 힌트 시트가 읽는 서버 값(구서버면 partner 키가 없다).
        curMeProvider.overrideWith((ref) async => CurMe.fromJson({
              'lesson': {
                'no': 5,
                'code': 'A1-T01-2',
                'level_no': 2,
                'situation': '처음 만난 반 친구와 이름을 묻고 답하기',
                'situation_translation': 'Ask and answer names with a new classmate',
                'topic': '인사와 소개',
                'topic_translation': 'Greetings and introductions',
                if (partner) 'partner': '한국어 수업에서 처음 만난 반 친구',
                if (partner)
                  'partner_translation': 'A classmate you just met in Korean class',
                if (partner) 'learner_role': '이름을 묻는 학생',
              },
              'status': 'expression_done',
            })),
        curLessonsProvider.overrideWith((ref, level) async => [
              for (var no = 4; no <= 7; no++)
                CurLessonRow(no: no, code: 'A1-T01-$no', levelNo: level, situation: '상황 $no'),
            ]),
        curLessonItemsProvider.overrideWith((ref, no) async => const [
              CurLessonItem(itemId: 11, seq: 1, surface: '안녕하세요', meaning: 'Hello.', role: 'chunk'),
              CurLessonItem(itemId: 12, seq: 2, surface: '반갑습니다', role: 'chunk'),
            ]),
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

/// 시트 등장 모션(≈300ms)을 흘린다 — 통화 화면은 음성 막대가 계속 돌아 `pumpAndSettle` 이 끝나지 않는다.
Future<void> _flush(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
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

  testWidgets('⭐ course=freetalk(회화학습) — 힌트 카드 없이 버튼이 시트를 연다',
      (tester) async {
    // 09-12 「프리토킹엔 힌트 카드」 → 10-10 사용자 「회화학습에서는 시트만 띄우자」로 바뀌었다
    // (디자인 `BottomSheet/CallLessonHint` · PM-DEC-485).
    final controller = await _pump(tester, course: CallCourse.freetalk);

    expect(_hintToggle, findsOneWidget, reason: '버튼은 그대로 있다');
    expect(find.byType(HintCard), findsNothing,
        reason: '힌트가 와 있고 토글이 켜져 있어도 회화학습은 카드를 안 그린다');
    expect(_subtitleToggle, findsOneWidget);

    await tester.tap(_hintToggle);
    await _flush(tester);
    // PM-DEC-760·793 — 힌트 버튼도 통화 i 시트(회화학습 · 첫 탭 이번 대화)를 연다.
    expect(find.byType(BottomSheetCallInfo), findsOneWidget);
    expect(_bubble, findsNothing);
    expect(controller.hintOnCalls, isEmpty, reason: '시트를 여는 버튼이지 토글이 아니다');

    // 「이번 대화」 — 제목 = 주제 + 번역 · 상황·상대·나 행(라벨 없음) · 값은 /cur/me 그대로.
    final l10n = AppLocalizations.of(tester.element(find.byType(BottomSheetCallInfo)));
    expect(find.text('인사와 소개'), findsOneWidget);
    expect(find.text('Greetings and introductions'), findsOneWidget);
    expect(find.text('처음 만난 반 친구와 이름을 묻고 답하기'), findsOneWidget);
    expect(find.text('Ask and answer names with a new classmate'), findsOneWidget);
    expect(find.text('한국어 수업에서 처음 만난 반 친구'), findsOneWidget);
    expect(find.text('A classmate you just met in Korean class'), findsOneWidget);
    expect(find.text('이름을 묻는 학생'), findsOneWidget, reason: '나 행(PM-DEC-785)');
    expect(find.text(l10n.callHintSituation), findsNothing, reason: '라벨 없음(PM-DEC-793)');
    expect(find.text(l10n.callHintPartner), findsNothing);

    // 「차시 목록」 — 레벨명 A1(level_no 2) · 지금 차시만 강조 · 배지 없음.
    await tester.tap(find.text(l10n.callHintTabLessons));
    await _flush(tester);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('5'), findsOneWidget, reason: '번호는 DB cur_lesson.no 그대로');
    expect(find.text(l10n.callHintNowBadge), findsNothing, reason: '「지금 대화」 배지 없음(PM-DEC-793)');
  });

  testWidgets('course=freetalk · 구서버(partner 없음) — 상대 줄을 숨긴다', (tester) async {
    await _pump(tester, course: CallCourse.freetalk, partner: false);
    await tester.tap(_hintToggle);
    await _flush(tester);
    expect(find.byType(BottomSheetCallInfo), findsOneWidget);
    expect(find.text('처음 만난 반 친구와 이름을 묻고 답하기'), findsOneWidget);
    expect(find.text('한국어 수업에서 처음 만난 반 친구'), findsNothing, reason: '상대 행 숨김');
    expect(find.text('이름을 묻는 학생'), findsNothing, reason: 'learner_role 없음 → 나 행 숨김');
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

  // PM-DEC-607 — 표현학습 숙제(call_started.homework_mode=expression)는 course 가 없어도
  // 일반 표현학습과 같은 잠금이다. 역할극 숙제는 현행 유지(PM-DEC-609).
  testWidgets('표현학습 숙제 — 힌트 카드 없음 · 버튼은 잠금 안내 말풍선', (tester) async {
    final controller = await _pump(tester, homeworkExpression: true);

    expect(_hintToggle, findsOneWidget);
    expect(find.byType(HintCard), findsNothing);

    await tester.tap(_hintToggle);
    await _settle(tester);
    final l10n = AppLocalizations.of(tester.element(_bubble));
    expect(find.text(l10n.callHintLockedTitle), findsOneWidget);
    expect(controller.hintOnCalls, isEmpty);
  });

  testWidgets('역할극 숙제(homework_mode=roleplay) — 힌트 카드 그대로', (tester) async {
    await _pump(tester);
    expect(find.byType(HintCard), findsOneWidget);
  });

  // PM-DEC-760 — 코스·숙제 통화 5유형 모두 GNB 왼쪽 i 안내(역할극 전용 → 전 유형).
  Finder infoButton(BuildContext ctx) =>
      find.bySemanticsLabel(AppLocalizations.of(ctx).callInfoA11y);

  testWidgets('일반 통화(course 없음 · 숙제 아님) — i 버튼 없음', (tester) async {
    await _pump(tester);
    final ctx = tester.element(find.byType(CallScreen));
    expect(infoButton(ctx), findsNothing);
  });

  for (final (name, course, hwExpr, aid) in <(String, CallCourse?, bool, int?)>[
    ('표현학습', CallCourse.expression, false, null),
    ('회화학습', CallCourse.freetalk, false, null),
    ('자유대화', CallCourse.chat, false, null),
    ('표현학습 숙제', null, true, 7),
  ]) {
    testWidgets('$name — i 버튼이 있다', (tester) async {
      await _pump(tester, course: course, homeworkExpression: hwExpr, assignmentId: aid);
      final ctx = tester.element(find.byType(CallScreen));
      expect(infoButton(ctx), findsOneWidget);
    });
  }

  testWidgets('표현학습 — i → 표현 행(뜻 en · 없으면 뜻 줄 없음)과 차시 탭', (tester) async {
    await _pump(tester, course: CallCourse.expression);
    final ctx = tester.element(find.byType(CallScreen));
    await tester.tap(infoButton(ctx));
    await _flush(tester);
    await _flush(tester);   // /cur/me 뒤에 차시 표현 목록(family)을 받는다 — 두 단계라 한 번 더 흘린다
    expect(find.byType(BottomSheetCallInfo), findsOneWidget);
    expect(find.text('인사와 소개'), findsOneWidget);
    expect(find.text('안녕하세요'), findsOneWidget);
    expect(find.text('Hello.'), findsOneWidget);
    expect(find.text('반갑습니다'), findsOneWidget);
    expect(find.text(AppLocalizations.of(ctx).callHintTabLessons), findsOneWidget);
  });

  testWidgets('자유대화 — i → 「자유 대화」 카드 · 탭 없음', (tester) async {
    await _pump(tester, course: CallCourse.chat);
    final ctx = tester.element(find.byType(CallScreen));
    final l10n = AppLocalizations.of(ctx);
    await tester.tap(infoButton(ctx));
    await _flush(tester);
    expect(find.text(l10n.callInfoFreeTalkBody), findsOneWidget);
    expect(find.text(l10n.callHintTabLessons), findsNothing);
  });

  testWidgets('역할극 숙제 — i 버튼 · 시트에 상황·상대·나와 번역이 보이고 힌트는 그대로', (tester) async {
    await _pump(tester,
        homeworkRoleplay: HomeworkRoleplay.fromJson(const {
          'topic': '공원 산책과 사진',
          'situation': '공원에서 처음 만난 사람에게 사진을 부탁한다',
          'ai_role': '공원에서 만난 친절한 사람',
          'learner_role': '사진을 부탁하는 관광객',
          'situation_translation': 'Ask a stranger in the park to take a photo',
          'ai_role_translation': 'A kind person you meet in the park',
        }));
    final ctx = tester.element(find.byType(CallScreen));
    final l10n = AppLocalizations.of(ctx);
    expect(find.byType(HintCard), findsOneWidget, reason: '힌트는 살린다(PM-DEC-622)');
    await tester.tap(infoButton(ctx));
    await _flush(tester);
    expect(find.byType(BottomSheetCallInfo), findsOneWidget);
    expect(find.text(l10n.callHintSituation), findsNothing, reason: '라벨 없음(PM-DEC-793)');
    expect(find.text('공원에서 처음 만난 사람에게 사진을 부탁한다'), findsOneWidget);
    expect(find.text('Ask a stranger in the park to take a photo'), findsOneWidget);
    expect(find.text('공원에서 만난 친절한 사람'), findsOneWidget);
    expect(find.text('A kind person you meet in the park'), findsOneWidget);
    expect(find.text(l10n.callRoleplayMe), findsNothing, reason: '나 라벨 없음 · 값만');
    expect(find.text('사진을 부탁하는 관광객'), findsOneWidget);
  });

  testWidgets('역할극 숙제 · learner_role 없음 — 나 줄 숨김 · 상황이 없으면 주제', (tester) async {
    await _pump(tester,
        homeworkRoleplay: HomeworkRoleplay.fromJson(const {
          'topic': '공원 산책과 사진',
          'ai_role': '공원에서 만난 친절한 사람',
        }));
    final ctx = tester.element(find.byType(CallScreen));
    final l10n = AppLocalizations.of(ctx);
    await tester.tap(infoButton(ctx));
    await _flush(tester);
    // 과제 목록이 없으면 제목 자리는 주제 · 상황이 없으면 상황 행도 주제 → 두 곳.
    expect(find.text('공원 산책과 사진'), findsNWidgets(2));
    expect(find.text(l10n.callRoleplayMe), findsNothing);
  });

  test('homework_roleplay 프레임 — 빈 칸은 버리고 상황·상대역이 모두 없으면 비어 있다', () {
    expect(HomeworkRoleplay.fromJson(const {'topic': ' ', 'learner_role': '손님'}).isEmpty,
        isTrue);
    final r = HomeworkRoleplay.fromJson(const {'situation': ' 가게 ', 'ai_role': '사장님'});
    expect(r.scene, '가게');
    expect(r.learnerRole, isNull);
  });
}
