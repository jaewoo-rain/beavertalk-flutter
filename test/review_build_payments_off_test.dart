import 'package:beavertalk/app/placeholder_screen.dart';
import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/core/config/store_flags.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/domain/entities/character.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 결제 없는 심사 빌드(PAYMENTS_ENABLED=false · T-20261016-07 · PM-DEC-706).
///
/// 사용자 10-16: 「결제나 구독에 대한 기능을 우선은 빼고, 심사를 올리고, 심사 승인 이후에 월 구독과
/// 캐릭터 인앱결제를 업데이트 하는 방향으로 하려고 해」 · U3 「숨김」.
/// 화면 시험은 [debugPaymentsEnabledOverride] 로, 라우트 표 시험은 컴파일 상수로 본다
/// (`flutter test --dart-define=PAYMENTS_ENABLED=false test/review_build_payments_off_test.dart`).
void main() {
  tearDown(() => debugPaymentsEnabledOverride = null);

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        subscriptionStatusProvider.overrideWithValue(SubscriptionStatus.none),
        subscriptionStatusAvailabilityProvider
            .overrideWithValue(SubscriptionStatusAvailability.known),
        signInProviderProvider.overrideWithValue('email'),
        myProfileProvider.overrideWith((ref) async =>
            Member(memberId: 1, email: 'a@b.com', name: 'Tester', targetLanguage: 'ko')),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: MyPageSettingsScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('기본 — 설정에 「결제」 구획 3줄이 있다', (tester) async {
    debugPaymentsEnabledOverride = true;
    await pumpSettings(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(MyPageSettingsScreen)));
    expect(find.text(l10n.paymentSection), findsOneWidget);
    expect(find.text(l10n.subscriptionRow), findsOneWidget);
    expect(find.text(l10n.paymentHistory), findsOneWidget);
  });

  testWidgets('심사 빌드 — 설정에 결제·구독·요금제·결제 내역이 없다', (tester) async {
    debugPaymentsEnabledOverride = false;
    await pumpSettings(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(MyPageSettingsScreen)));
    for (final s in [l10n.paymentSection, l10n.subscriptionRow, l10n.currentPlan, l10n.paymentHistory,
                     l10n.planPro, l10n.planMax]) {
      expect(find.text(s), findsNothing, reason: s);
    }
  });

  List<Character> catalog(List<Map<String, dynamic>> rows) =>
      [for (final r in rows) CharacterDto.fromJson(r).toEntity()];
  Map<String, dynamic> row(int id, String name, {String price = '4.99', bool owned = false, bool? unlocked}) => {
        'character_id': id,
        'product_key': name.toLowerCase(),
        'name': name,
        'price': price,
        'effective_price': price,
        'is_owned': owned,
        'is_unlocked': unlocked ?? owned,
      };

  Future<void> pumpAvatar(WidgetTester t, List<Character> characters) async {
    await t.pumpWidget(ProviderScope(
      overrides: [
        iapServiceProvider.overrideWithValue(MockIapService()),
        charactersProvider.overrideWith((ref) async => characters),
        ownedCharactersProvider.overrideWith((ref) async => const []),
        myProfileProvider.overrideWith((ref) async => Member(memberId: 1, characterId: 1)),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AvatarScreen(),
      ),
    ));
    await t.pump();
    await t.pump();
  }

  Finder tiles() => find.byWidgetPredicate((w) => w.runtimeType.toString() == '_Tile');

  // 1 Baba(무료) · 2 Bibi(무료) · 9 Popo(구매함) · 10 Rara(구독으로 열림) · 11 Dudu(미보유)
  final roster = [
    row(1, 'Baba', price: '0', owned: true),
    row(2, 'Bibi', price: '0'),
    row(9, 'Popo', owned: true),
    row(10, 'Rara', unlocked: true),
    row(11, 'Dudu'),
  ];

  testWidgets('심사 빌드 — 캐릭터 화면에 무료·구매한 캐릭터만 · Buy·가격·요금제 배지 없음', (t) async {
    debugPaymentsEnabledOverride = false;
    await pumpAvatar(t, catalog(roster));
    final l10n = AppLocalizations.of(t.element(find.byType(AvatarScreen)));
    expect(tiles(), findsNWidgets(3), reason: 'Baba·Bibi·Popo 만 — 구독으로 열린 Rara·미보유 Dudu 는 숨김(U3)');
    expect(find.text(l10n.buy), findsNothing);
    expect(find.text(l10n.unlockedWithMax), findsNothing);
    expect(find.text(l10n.availableForPurchase), findsNothing);
    expect(find.textContaining(r'$'), findsNothing, reason: '가격 문구 0');
  });

  testWidgets('기본 — 캐릭터 화면에 유료 캐릭터가 그대로 보인다', (t) async {
    debugPaymentsEnabledOverride = true;
    await pumpAvatar(t, catalog(roster));
    expect(tiles(), findsNWidgets(5));
  });

  testWidgets('라우트 표 — 결제 화면은 PAYMENTS_ENABLED=false 빌드에 없다(이름만 알면 「준비 중」)', (t) async {
    late BuildContext ctx;
    await t.pumpWidget(MaterialApp(home: Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));
    for (final name in [Routes.subscription, Routes.plansCompare, Routes.paywallProLimit, Routes.paywallMax,
                        Routes.purchaseProcessing, Routes.purchaseSuccessMax, Routes.plansError,
                        Routes.winbackSurvey, Routes.paymentHistory]) {
      final route = onGenerateRoute(RouteSettings(name: name)) as dynamic;
      final widget = (route.builder as WidgetBuilder)(ctx);
      expect(widget is PlaceholderScreen, !kPaymentsEnabled, reason: name);
    }
  });
}
