// 숙제 5분·하루 무료 한도 안내(PM-DEC-551·560).
//
// - 숙제 통화가 과제 5분에 끝나면 결제 시트 대신 「숙제는 5분 통화만 가능해요.」가 뜬다.
// - 서버가 `HOMEWORK_TIME_LIMIT` 로 거절하면 같은 문구를 띄우고 숙제 화면으로 돌아간다.
// - 무료 회원이 `DAILY_LIMIT` 로 거절되면 스낵바가 아니라 한도 시트가 뜬다.
// - 유료 회원의 `DAILY_LIMIT` 는 종전대로 스낵바다(살 것이 없다).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/app/routes.dart';
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
Future<_DrivableCallController> _pumpCall(
  WidgetTester tester, {
  SubscriptionStatus status = _free,
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
        },
        home: const Scaffold(body: Text('detail-page')),
      ),
    ),
  );
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

  testWidgets('숙제 5분 종료 → 결제 시트 대신 숙제 안내, End Call 로 종료 화면', (tester) async {
    final controller = await _pumpCall(tester);
    controller.emit(
      const CallState(
        phase: CallPhase.ended,
        callId: 'call-1',
        elapsedSec: 300,
        homeworkTimeUp: true,
      ),
    );
    await _settle(tester);
    expect(find.text(l10n.homeworkCallTimeLimit), findsOneWidget);
    expect(find.text(l10n.fcEndedTitle), findsNothing);
    expect(find.text(l10n.ctaSubscribeKeepTalking), findsNothing);

    await tester.tap(find.text(l10n.endCall));
    await _settle(tester);
    expect(find.text('finish-page'), findsOneWidget);
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
