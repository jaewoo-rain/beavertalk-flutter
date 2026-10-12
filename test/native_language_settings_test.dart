// 설정 「모국어」 행 — 2026-10-12 PM-DEC-515 · F066.
//
// - 계정 묶음 국적 행 아래 · 값은 언어 이름 · 미기록은 국적과 같은 「Not set」.
// - 고르면 PATCH native_language 만 — 앱 화면 언어(language)·로케일은 그대로다.

import 'package:beavertalk/core/i18n/locale_controller.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/domain/repositories/auth_repository.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuth implements AuthRepository {
  final native = <String>[];
  final ui = <String>[];

  @override
  Future<Member> updateNativeLanguage(String nativeLanguage) async {
    native.add(nativeLanguage);
    return Member(memberId: 1, nativeLanguage: nativeLanguage);
  }

  @override
  Future<Member> updateLanguage(String language) async {
    ui.add(language);
    return Member(memberId: 1, language: language);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<ProviderContainer> pumpSettings(
    WidgetTester tester, {
    String? native,
    _FakeAuth? auth,
  }) async {
    await tester.binding.setSurfaceSize(const Size(375, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(overrides: [
      subscriptionStatusProvider.overrideWithValue(SubscriptionStatus.none),
      subscriptionStatusAvailabilityProvider
          .overrideWithValue(SubscriptionStatusAvailability.known),
      signInProviderProvider.overrideWithValue('email'),
      if (auth != null) authRepositoryProvider.overrideWithValue(auth),
      myProfileProvider.overrideWith((ref) async => Member(
            memberId: 1,
            email: 'a@b.com',
            name: 'Tester',
            language: 'en',
            targetLanguage: 'ko',
            actualNationality: 'VN',
            nativeLanguage: native,
          )),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: MyPageSettingsScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump();
    return container;
  }

  testWidgets('국적 아래 「Native language」 행 · 값은 언어 이름', (tester) async {
    await pumpSettings(tester, native: 'vi');
    final row = find.text('Native language');
    expect(row, findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    final natY = tester.getTopLeft(find.text('Nationality')).dy;
    expect(tester.getTopLeft(row).dy, greaterThan(natY));
  });

  testWidgets('미기록 회원은 국적과 같은 「Not set」', (tester) async {
    await pumpSettings(tester);
    expect(find.text('Not set'), findsOneWidget);
  });

  testWidgets('고르면 native_language 만 저장 · 화면 언어는 그대로', (tester) async {
    final auth = _FakeAuth();
    final container = await pumpSettings(tester, native: 'vi', auth: auth);
    final localeBefore = container.read(localeControllerProvider);

    await tester.tap(find.text('Native language'));
    await tester.pumpAndSettle();
    expect(find.text('What is your native language?'), findsOneWidget);
    await tester.tap(find.text('한국어').last);
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyPageSettingsScreen)));
    await tester.tap(find.text(l10n.confirm).last);
    await tester.pumpAndSettle();

    expect(auth.native, ['ko']); // ko-KR → ISO 639-1
    expect(auth.ui, isEmpty);
    expect(container.read(localeControllerProvider), localeBefore);
  });
}
