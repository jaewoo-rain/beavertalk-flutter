// 숙제 5분·하루 무료 한도 안내(PM-DEC-551·560).
//
// - 숙제 통화가 과제 5분에 끝나면 결제 시트 대신 「숙제는 5분 통화만 가능해요.」가 뜬다.
// - 서버가 `HOMEWORK_TIME_LIMIT` 로 거절하면 같은 문구를 띄우고 숙제 화면으로 돌아간다.
// - 무료 회원이 `DAILY_LIMIT` 로 거절되면 스낵바가 아니라 한도 시트가 뜬다.
// - 유료 회원의 `DAILY_LIMIT` 는 종전대로 스낵바다(살 것이 없다).
// - 숙제 5분 시트는 C안(PM-DEC-611) — 완료 표시 · 결과 보기 · 숙제로 돌아가기.
// - 숙제 통화의 거절은 코드와 무관하게 앱 문구로 숙제 화면에 돌아간다(QA F004·F008).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/l10n/app_localizations_en.dart';
import 'package:beavertalk/screens/home/call.dart';

class _DrivableCallController extends NormalCallController {
  _DrivableCallController(this._initial);

  final CallState _initial;

  @override
  CallState build() => _initial;

  void emit(CallState next) => state = next;

  @override
  Future<void> hangUp() async => state = state.copyWith(phase: CallPhase.ended);
}

const _free = SubscriptionStatus(
  state: SubscriptionState.free,
  tier: SubscriptionTier.free,
);

const _max = SubscriptionStatus(
  state: SubscriptionState.activeMax,
  tier: SubscriptionTier.max,
);

/// `pumpAndSettle` 은 쓸 수 없다 — 아바타가 없는 통화 화면은 스켈레톤을 무한 반복한다.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

/// 숙제 상세(자리표시자) → 통화 화면을 한 칸 위에 연다.
///
/// [detailRoute] 면 숙제 상세를 이름 붙은 라우트(`Routes.assignmentDetail`)로 한 칸 더 쌓는다 —
/// 「숙제로 돌아가기」가 그 라우트를 찾아 돌아오는지 본다.
Future<_DrivableCallController> _pumpCall(
  WidgetTester tester, {
  SubscriptionStatus status = _free,
  bool detailRoute = false,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final controller = _DrivableCallController(
    const CallState(phase: CallPhase.inCall, callId: 'call-1'),
  );
  final navKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        normalCallControllerProvider.overrideWith(() => controller),
        subscriptionStatusProvider.overrideWithValue(status),
      ],
      child: MaterialApp(
        navigatorKey: navKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          Routes.callFinish: (_) => const Scaffold(body: Text('finish-page')),
          Routes.paywallProLimit: (_) =>
              const Scaffold(body: Text('paywall-page')),
          Routes.assignments: (_) => const Scaffold(body: Text('list-page')),
        },
        home: const Scaffold(body: Text('detail-page')),
      ),
    ),
  );
  if (detailRoute) {
    // 상세는 「이번에 회화를 끝낸 과제」 표시를 그대로 글자로 보여 준다.
    navKey.currentState!.push(MaterialPageRoute<void>(
      settings: const RouteSettings(name: Routes.assignmentDetail),
      builder: (_) => Scaffold(
        body: Consumer(
          builder: (_, ref, _) => Text(
              'named-detail-page ${ref.watch(homeworkConversationEndedProvider)}'),
        ),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 400));
  }
  navKey.currentState!.push(
    MaterialPageRoute<void>(builder: (_) => const CallScreen()),
  );
  await tester.pump(const Duration(milliseconds: 400));
  return controller;
}

void main() {
  final l10n = AppLocalizationsEn();

  // 잠금화면 판정 채널 — 잠기지 않은 통화로 답한다(화면 전환이 평소 흐름을 탄다).
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('beavertalk/lockscreen'),
          (call) async => false,
        );
  });

  test('HOMEWORK_TIME_LIMIT → 숙제 5분 문구(서버 한국어 문구를 쓰지 않는다)', () {
    expect(
      serverErrorMessage({
        'type': 'error',
        'code': 'HOMEWORK_TIME_LIMIT',
        'message': '숙제는 5분 통화만 가능해요.',
      }, l10n),
      l10n.homeworkCallTimeLimit,
    );
    expect(
      serverErrorMessage({
        'type': 'error',
        'code': 'HOMEWORK_CONVERSATION_COMPLETED',
      }, l10n),
      l10n.homeworkCallTimeLimit,
    );
  });

  testWidgets('숙제 5분 종료 → C안 시트(결제 유도 없음), 결과 보기로 종료 화면', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      const CallState(
        phase: CallPhase.ended,
        callId: 'call-1',
        elapsedSec: 300,
        homeworkTimeUp: true,
        assignmentId: 8,
      ),
    );
    await _settle(tester);
    expect(find.text(l10n.hwCallDoneTitle), findsOneWidget);
    expect(find.text(l10n.hwCallDoneBackToHomework), findsOneWidget);
    expect(find.text(l10n.fcEndedTitle), findsNothing);
    expect(find.text(l10n.ctaSubscribeKeepTalking), findsNothing);

    await tester.tap(find.text(l10n.hwCallDoneSeeResults));
    await _settle(tester);
    expect(find.text('finish-page'), findsOneWidget);
  });

  testWidgets('숙제로 돌아가기 → 같은 과제 상세로 복귀 · 회화 완료 표시', (tester) async {
    final controller = await _pumpCall(tester, detailRoute: true);
    controller.emit(
      const CallState(
        phase: CallPhase.ended,
        callId: 'call-1',
        elapsedSec: 300,
        homeworkTimeUp: true,
        assignmentId: 8,
      ),
    );
    await _settle(tester);
    await tester.tap(find.text(l10n.hwCallDoneBackToHomework));
    await _settle(tester);
    expect(find.text('named-detail-page {8}'), findsOneWidget);
    expect(find.byType(CallScreen), findsNothing);
    expect(find.text('finish-page'), findsNothing);
  });

  testWidgets('숙제로 돌아가기 · 상세가 스택에 없으면 숙제 목록', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      const CallState(
        phase: CallPhase.ended,
        callId: 'call-1',
        elapsedSec: 300,
        homeworkTimeUp: true,
        assignmentId: 8,
      ),
    );
    await _settle(tester);
    await tester.tap(find.text(l10n.hwCallDoneBackToHomework));
    await _settle(tester);
    expect(find.text('list-page'), findsOneWidget);
  });

  test('숙제 거절 코드 → 앱 문구(F008) · 숙제 DAILY_LIMIT → 숙제 안내(F004)', () {
    String m(String code, {bool homework = true}) => serverErrorMessage(
        {'type': 'error', 'code': code, 'message': '서버 한국어 문구'}, l10n,
        homework: homework);
    expect(m('HOMEWORK_ASSIGNMENT_CLOSED'), l10n.homeworkCallClosed);
    expect(m('HOMEWORK_ASSIGNMENT_NOT_PUBLISHED'), l10n.homeworkCallUnavailable);
    expect(m('HOMEWORK_HOMEWORK_SERVICE_UNAVAILABLE'),
        l10n.homeworkCallUnavailable);
    expect(m('RESUME_UNAVAILABLE'), l10n.callResumeUnavailable);
    expect(m('DAILY_LIMIT'), l10n.homeworkCallTimeLimit);
    expect(m('DAILY_LIMIT', homework: false), l10n.callDailyLimit);
  });

  testWidgets('숙제 통화 무료 DAILY_LIMIT 거절 → 한도 시트 없이 숙제 화면', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      CallState(
        phase: CallPhase.error,
        errorMsg: l10n.homeworkCallTimeLimit,
        errorCode: 'DAILY_LIMIT',
        assignmentId: 8,
      ),
    );
    await _settle(tester);
    expect(find.text('detail-page'), findsOneWidget);
    expect(find.text(l10n.flTodayTitle), findsNothing);
    expect(find.text(l10n.homeworkCallTimeLimit), findsOneWidget);
  });

  testWidgets('숙제 과제 마감 거절 → 홈까지 밀지 않고 숙제 상세', (tester) async {
    final controller = await _pumpCall(tester, detailRoute: true);
    controller.emit(
      CallState(
        phase: CallPhase.error,
        errorMsg: l10n.homeworkCallClosed,
        errorCode: 'HOMEWORK_ASSIGNMENT_CLOSED',
        assignmentId: 8,
      ),
    );
    await _settle(tester);
    expect(find.textContaining('named-detail-page'), findsOneWidget);
    expect(find.text(l10n.homeworkCallClosed), findsOneWidget);
  });

  testWidgets('HOMEWORK_TIME_LIMIT 거절 → 숙제 화면으로 돌아가 안내', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      CallState(
        phase: CallPhase.error,
        errorMsg: l10n.homeworkCallTimeLimit,
        errorCode: 'HOMEWORK_TIME_LIMIT',
      ),
    );
    await _settle(tester);
    expect(find.text('detail-page'), findsOneWidget);
    expect(find.byType(CallScreen), findsNothing);
    expect(find.text(l10n.homeworkCallTimeLimit), findsOneWidget);
    expect(find.text(l10n.flTodayTitle), findsNothing);
  });

  testWidgets('무료 DAILY_LIMIT 거절 → 홈으로 가서 한도 시트', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      CallState(
        phase: CallPhase.error,
        errorMsg: l10n.callDailyLimit,
        errorCode: 'DAILY_LIMIT',
      ),
    );
    await _settle(tester);
    expect(find.byType(CallScreen), findsNothing);
    expect(find.text(l10n.flTodayTitle), findsOneWidget);
    expect(
      find.text(l10n.callDailyLimit),
      findsNothing,
      reason: '시트로 바꿨으면 스낵바를 같이 띄우지 않는다',
    );
  });

  testWidgets('유료 DAILY_LIMIT 거절 → 종전대로 스낵바', (tester) async {
    final controller = await _pumpCall(tester, status: _max);
    controller.emit(
      CallState(
        phase: CallPhase.error,
        errorMsg: l10n.callDailyLimit,
        errorCode: 'DAILY_LIMIT',
      ),
    );
    await _settle(tester);
    expect(find.text(l10n.callDailyLimit), findsOneWidget);
    expect(find.text(l10n.flTodayTitle), findsNothing);
  });
}
