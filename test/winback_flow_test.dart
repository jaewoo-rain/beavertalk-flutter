import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/winback_offer_sheet.dart';
import 'package:beavertalk/screens/plans/winback_survey.dart';
import 'package:beavertalk/screens/plans/winback_trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 윈백 — 만료 뒤 첫 실행 1회 설문 · 「비쌈」 이면 오퍼 시트(PM-DEC-034~036).
final _expiry = DateTime.utc(2026, 9, 20);

Member _member() => Member(
      memberId: 7,
      email: 'qa@example.com',
      name: 'QA',
      language: 'en',
      targetLanguage: 'ko',
      onboardingCompleted: true,
      createdAt: DateTime(2026, 3, 1),
    );

SubscriptionStatus _status(SubscriptionState state) => SubscriptionStatus(
      state: state,
      tier: SubscriptionTier.free,
      expiresAt: _expiry,
    );

Future<void> _pump(WidgetTester tester, SubscriptionState state) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      subscriptionStatusProvider.overrideWithValue(_status(state)),
      myProfileProvider.overrideWith((ref) async => _member()),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {Routes.winbackSurvey: (_) => const WinbackSurveyScreen()},
      home: const Scaffold(body: Stack(children: [Text('HOME'), WinbackTrigger()])),
    ),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50)); // prefs
  await tester.pump(const Duration(milliseconds: 400)); // route transition
}

void main() {
  test('기록 키 — 회원 · 만료 시각', () {
    expect(winbackMark(memberId: 7, expiresAt: _expiry), '7|2026-09-20T00:00:00.000Z');
    expect(winbackMark(), '-|-');
  });

  testWidgets('만료 → 설문 1회 · 「비쌈」 보내면 오퍼 시트 · Maybe later 로 홈', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, SubscriptionState.expired);
    expect(find.text('Your Premium plan ended'), findsOneWidget);

    // 기본 선택 없음(PM-DEC-042) — 고르기 전 Send 는 꺼져 있다.
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Your Premium plan ended'), findsOneWidget, reason: '안 골랐으면 안 보낸다');
    await tester.tap(find.text('Too expensive'));
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('50% off your first month'), findsOneWidget);
    expect(find.textContaining(r'$'), findsNothing, reason: '금액은 적지 않는다(사용자 결정 A)');

    await tester.tap(find.text('Maybe later'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('HOME'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(winbackPrefKey), winbackMark(memberId: 7, expiresAt: _expiry));
  });

  testWidgets('「안 씀」 은 보내고 홈으로 — 오퍼 시트 없음', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, SubscriptionState.expired);
    await tester.tap(find.text("I wasn't using it enough"));
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Your Premium plan ended'), findsNothing);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('같은 만료면 다시 안 띄운다', (tester) async {
    SharedPreferences.setMockInitialValues({
      winbackPrefKey: winbackMark(memberId: 7, expiresAt: _expiry),
    });
    await _pump(tester, SubscriptionState.expired);
    expect(find.text('Your Premium plan ended'), findsNothing);
  });

  testWidgets('만료가 아니면(해지 예약 포함) 안 띄운다', (tester) async {
    for (final s in [SubscriptionState.ending, SubscriptionState.free, SubscriptionState.activeMax]) {
      SharedPreferences.setMockInitialValues({});
      await _pump(tester, s);
      expect(find.text('Your Premium plan ended'), findsNothing, reason: '$s');
    }
  });

  testWidgets('오퍼 시트 — 정본 순서 · 버튼 둘(보조 위 · 주요 아래)', (tester) async {
    var got = 0;
    var later = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: WinbackOfferSheet(onGetOffer: () => got++, onLater: () => later++),
        ),
      ),
    ));
    final badgeY = tester.getCenter(find.text('50% off your first month')).dy;
    final titleY = tester.getCenter(find.text('Welcome back')).dy;
    final videoY = tester.getCenter(find.text('15 minutes of video calls a day')).dy;
    final laterY = tester.getCenter(find.text('Maybe later')).dy;
    final offerY = tester.getCenter(find.text('Get 50% off')).dy;
    expect(badgeY < titleY && titleY < videoY && videoY < laterY && laterY < offerY, isTrue);
    await tester.tap(find.text('Get 50% off'));
    await tester.tap(find.text('Maybe later'));
    expect((got, later), (1, 1));
  });
}
