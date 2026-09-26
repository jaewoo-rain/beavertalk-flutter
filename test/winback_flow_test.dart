import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/winback_offer_sheet.dart';
import 'package:beavertalk/screens/plans/winback_survey.dart';
import 'package:beavertalk/screens/plans/winback_trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 윈백 — 만료 뒤 첫 실행 1회 설문 · 「비쌈」 이면 오퍼 시트(PM-DEC-034~036 · 052).
///
/// 띄우는 조건: 서버 판정 expired(F059) · 한 번이라도 활성화된 행(F058) · 회원별 기록(F061).
final _expiry = DateTime.utc(2026, 9, 20);

Member _member(int id) => Member(
      memberId: id,
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

/// 한 번은 활성이었다가 해지·만료된 행.
final _lapsed = [Subscription(id: 1, endDate: _expiry, isActivate: false)];

Future<void> _pump(
  WidgetTester tester, {
  SubscriptionStatus? server,
  List<Subscription>? rows,
  int memberId = 7,
  bool profileFails = false,
}) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    // 매 호출 새 스코프 — 같은 시험 안에서 회원을 바꿔 다시 띄운다.
    key: UniqueKey(),
    overrides: [
      serverSubscriptionStatusProvider.overrideWith((ref) async => server),
      subscriptionsProvider.overrideWith((ref) async => rows ?? _lapsed),
      myProfileProvider.overrideWith((ref) async {
        if (profileFails) throw StateError('profile down');
        return _member(memberId);
      }),
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
  await tester.pump(const Duration(milliseconds: 50)); // futures · prefs
  await tester.pump(const Duration(milliseconds: 400)); // route transition
}

final _survey = find.text('Your Premium plan ended');

void main() {
  test('권할 회원 — 서버 expired + 활성화된 적 있는 행', () {
    final expired = _status(SubscriptionState.expired);
    expect(shouldOfferWinback(status: expired, rows: _lapsed), isTrue);
    expect(
      shouldOfferWinback(status: expired, rows: [const Subscription(id: 2)]),
      isFalse,
      reason: 'is_activate null 만 있으면 결제한 적이 없다(F058)',
    );
    expect(
      shouldOfferWinback(status: _status(SubscriptionState.ending), rows: _lapsed),
      isFalse,
    );
    expect(winbackPrefKeyFor(7), 'winback_survey_shown_for_7');
    expect(winbackMark(_expiry), '2026-09-20T00:00:00.000Z');
  });

  testWidgets('만료 → 설문 1회 · 사유 고르기 전 Send 꺼짐 · 「비쌈」 → 오퍼 시트 · Maybe later 로 홈',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, server: _status(SubscriptionState.expired));
    expect(_survey, findsOneWidget);

    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(_survey, findsOneWidget, reason: '안 골랐으면 안 보낸다(PM-DEC-042)');
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
    expect(prefs.getString(winbackPrefKeyFor(7)), winbackMark(_expiry));
  });

  testWidgets('「안 씀」 은 보내고 홈으로 — 오퍼 시트 없음', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, server: _status(SubscriptionState.expired));
    await tester.tap(find.text("I wasn't using it enough"));
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(_survey, findsNothing);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('F058 — 활성화된 적 없는 행(null)뿐이면 안 띄운다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester,
        server: _status(SubscriptionState.expired), rows: [const Subscription(id: 3)]);
    expect(_survey, findsNothing);
  });

  testWidgets('F059 — 서버 판정이 없으면(구서버·실패) 행 추론으로 띄우지 않는다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, server: null);
    expect(_survey, findsNothing);
  });

  testWidgets('만료가 아니면(해지 예약 포함) 안 띄운다', (tester) async {
    for (final s in [SubscriptionState.ending, SubscriptionState.free, SubscriptionState.activeMax]) {
      SharedPreferences.setMockInitialValues({});
      await _pump(tester, server: _status(s));
      expect(_survey, findsNothing, reason: '$s');
    }
  });

  testWidgets('F061 — 회원별 기록: 같은 회원 같은 만료는 한 번 · 다른 회원 기록이 덮지 않는다',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      winbackPrefKeyFor(7): winbackMark(_expiry),
    });
    // A(7) 는 이미 봤다.
    await _pump(tester, server: _status(SubscriptionState.expired), memberId: 7);
    expect(_survey, findsNothing);
    // B(8) 는 처음 — 뜬다.
    await _pump(tester, server: _status(SubscriptionState.expired), memberId: 8);
    expect(_survey, findsOneWidget);
    // 다시 A — B 의 기록이 A 를 덮지 않았으니 안 뜬다.
    await _pump(tester, server: _status(SubscriptionState.expired), memberId: 7);
    expect(_survey, findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(winbackPrefKeyFor(7)), winbackMark(_expiry));
    expect(prefs.getString(winbackPrefKeyFor(8)), winbackMark(_expiry));
  });

  testWidgets('F061 — 프로필을 못 읽으면 띄우지도 기록하지도 않는다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pump(tester, server: _status(SubscriptionState.expired), profileFails: true);
    expect(_survey, findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), isEmpty);
  });

  testWidgets('F060 — 사유 행은 선택 상태·단일 선택을, Skip 은 버튼 역할을 알린다', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WinbackSurveyScreen(),
    ));
    await tester.tap(find.text('Too expensive'));
    await tester.pump();
    expect(
      tester.getSemantics(find.text('Too expensive')),
      isSemantics(
        label: 'Too expensive',
        hasCheckedState: true,
        isChecked: true,
        isInMutuallyExclusiveGroup: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('Something else')),
      isSemantics(
        label: 'Something else',
        hasCheckedState: true,
        isChecked: false,
        isInMutuallyExclusiveGroup: true,
        hasTapAction: true,
      ),
    );
    expect(tester.getSemantics(find.text('Skip')), isSemantics(label: 'Skip', isButton: true, hasTapAction: true));
    handle.dispose();
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
