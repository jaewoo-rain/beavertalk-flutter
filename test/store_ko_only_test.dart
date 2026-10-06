import 'package:beavertalk/core/config/store_flags.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 스토어 심사 빌드 = 학습 언어 한국어만(STORE_KO_ONLY · PM-DEC-409·410).
///
/// 사용자 10-06: 「심사 올릴 때 학습 언어를 '한국어' 외에 다른 언어는 빼야해.」 ·
/// 「부스 전시할 때는 다른 언어도 넣긴 할거야.」 — 기본(부스)은 6개 그대로다.
void main() {
  tearDown(() => debugStoreKoOnlyOverride = null);

  Future<void> pumpSettings(WidgetTester tester, {String? target}) async {
    await tester.binding.setSurfaceSize(const Size(375, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        subscriptionStatusProvider.overrideWithValue(SubscriptionStatus.none),
        subscriptionStatusAvailabilityProvider
            .overrideWithValue(SubscriptionStatusAvailability.known),
        signInProviderProvider.overrideWithValue('email'),
        myProfileProvider.overrideWith((ref) async => Member(
              memberId: 1,
              email: 'a@b.com',
              name: 'Tester',
              targetLanguage: target,
            )),
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

  Future<void> openLearningSheet(WidgetTester tester) async {
    final l10n = AppLocalizations.of(tester.element(find.byType(MyPageSettingsScreen)));
    await tester.tap(find.text(l10n.learningLanguage));
    await tester.pumpAndSettle();
  }

  testWidgets('기본(부스) — 학습 언어 시트에 6개 언어', (tester) async {
    debugStoreKoOnlyOverride = false;
    await pumpSettings(tester, target: 'ko');
    await openLearningSheet(tester);
    for (final name in ['日本語', 'English', '中文', 'Français', 'Tiếng Việt']) {
      expect(find.text(name), findsWidgets, reason: name);
    }
  });

  testWidgets('스토어 빌드 — 시트에는 한국어 하나뿐', (tester) async {
    debugStoreKoOnlyOverride = true;
    await pumpSettings(tester, target: 'ko');
    await openLearningSheet(tester);
    expect(find.text('한국어'), findsWidgets);
    for (final name in ['日本語', '中文', 'Français', 'Tiếng Việt']) {
      expect(find.text(name), findsNothing, reason: name);
    }
  });

  testWidgets('스토어 빌드 — 이미 일본어인 회원은 실제 언어 이름을 본다(서버 값 그대로)', (tester) async {
    debugStoreKoOnlyOverride = true;
    await pumpSettings(tester, target: 'ja');
    expect(find.text('日本語'), findsOneWidget, reason: '설정 행은 실제 학습 언어를 보여야 한다');
    await openLearningSheet(tester);
    // 시트에는 되돌릴 한국어만 있다.
    expect(find.text('中文'), findsNothing);
  });
}
