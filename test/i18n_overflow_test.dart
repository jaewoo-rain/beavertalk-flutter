// Per-locale overflow audit: pumps text-dense screens in every supported locale
// at a narrow phone width (320dp) and fails if any RenderFlex/text overflow is
// reported during layout. This is the exhaustive guard for the "translation made
// text overflow" class of bugs — long endonyms/strings (de, fi, ru, mn, …) must
// wrap/ellipsize, never overflow.
//
// Scope note: covers screens that pump standalone without route args or
// persistent timers. Timer/stream-heavy live screens (call, call_loading,
// analysis_loading, home) are exercised structurally via the shared component
// hardening (Button/Gnb/CardBox/SegmentedTabs/… are all Flexible+ellipsis), not
// pumped here, to keep this audit deterministic.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';

import 'package:beavertalk/screens/alarm/alarm_add.dart';
import 'package:beavertalk/screens/alarm/alarm_empty.dart';
import 'package:beavertalk/screens/alarm/alarm_list.dart';
import 'package:beavertalk/screens/auth/login.dart';
import 'package:beavertalk/screens/auth/login_form.dart';
import 'package:beavertalk/screens/auth/password_code.dart';
import 'package:beavertalk/screens/auth/password_complete.dart';
import 'package:beavertalk/screens/auth/password_method.dart';
import 'package:beavertalk/screens/auth/password_new.dart';
import 'package:beavertalk/screens/auth/signup.dart';
import 'package:beavertalk/screens/home/call_finish.dart';
import 'package:beavertalk/screens/mypage/avatar_detail.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/screens/mypage/subscription_info.dart';
import 'package:beavertalk/screens/onboarding/onboarding_done.dart';
import 'package:beavertalk/screens/onboarding/onboarding_language.dart';
import 'package:beavertalk/screens/onboarding/onboarding_name.dart';
import 'package:beavertalk/screens/onboarding/onboarding_reason.dart';
import 'package:beavertalk/screens/payment/payment.dart';
import 'package:beavertalk/screens/payment/payment_complete.dart';
import 'package:beavertalk/screens/payment/payment_failed.dart';
import 'package:beavertalk/screens/record/record_empty.dart';
import 'package:beavertalk/screens/home/learning_call_main.dart';
import 'package:beavertalk/screens/home/learning_call_main_loading.dart';
import 'package:beavertalk/screens/record/record_list.dart';
import 'package:beavertalk/screens/system/mic_denied.dart';
import 'package:beavertalk/screens/system/network_error.dart';
import 'package:beavertalk/screens/system/permission.dart';

void main() {
  final screens = <String, Widget Function()>{
    'AlarmAdd': () => const AlarmAddScreen(),
    'AlarmEmpty': () => const AlarmEmptyScreen(),
    'AlarmList': () => const AlarmListScreen(),
    'Login': () => const LoginScreen(),
    'LoginForm': () => const LoginFormScreen(),
    'PasswordCode': () => const PasswordCodeScreen(),
    'PasswordComplete': () => const PasswordCompleteScreen(),
    'PasswordMethod': () => const PasswordMethodScreen(),
    'PasswordNew': () => const PasswordNewScreen(),
    'Signup': () => const SignupScreen(),
    'CallFinish': () => const CallFinishScreen(),
    // Worst case for the detail screen's name row: name + the long
    // "Available to purchase" badge + a "-N%" marker, all on one line.
    'AvatarDetailDiscount': () => const AvatarDetailScreen(
          state: AvatarDetailState.unownedDiscount,
          name: 'Baba',
          tags: ['Savage', 'Blunt', 'Tsundere'],
          summary: 'A sharp-tongued master.',
          description: 'Baba, a beaver famous for his flawless dams.',
          price: '₩4,900',
          discountPrice: '₩2,450',
          discountPercent: 50,
        ),
    'AvatarDetailOwned': () => const AvatarDetailScreen(
          state: AvatarDetailState.ownedUnused,
          name: 'Baba',
          tags: ['Savage', 'Blunt', 'Tsundere'],
          summary: 'A sharp-tongued master.',
          description: 'Baba, a beaver famous for his flawless dams.',
        ),
    'MyPage': () => const MyPageScreen(),
    'MyPageSettings': () => const MyPageSettingsScreen(),
    // Nothing navigates to `Routes.subscription` today — MyPage opens the same
    // sheet as a modal — but it is the screen the subscription flow will use
    // once payment is wired, so it stays audited rather than being dropped as
    // dead code. It overflowed in 11 locales until the sheet's body was made
    // scrollable; keeping it here is what stops that from coming back.
    'SubscriptionInfo': () => const SubscriptionInfoScreen(),
    'OnboardingDone': () => const OnboardingDoneScreen(),
    'OnboardingLanguage': () => const OnboardingLanguageScreen(),
    'OnboardingName': () => const OnboardingNameScreen(),
    'OnboardingReason': () => const OnboardingReasonScreen(),
    'Payment': () => const PaymentScreen(),
    'PaymentComplete': () => const PaymentCompleteScreen(),
    'PaymentFailed': () => const PaymentFailedScreen(),
    'RecordEmpty': () => const RecordEmptyScreen(),
    'RecordList': () => const RecordListScreen(),
    'RecordArchiveTab': () => const RecordListScreen(initialTab: 1),
    // Densest screen in the app — three tables and a chart, all fixed-width
    // number columns. Narrow locales break here first.
    'LearningCallMain': () => const LearningCallMainScreen(),
    'LearningCallMainLoading': () => const LearningCallMainLoadingScreen(),
    'MicDenied': () => const MicDeniedScreen(),
    'NetworkError': () => const NetworkErrorScreen(),
    'Permission': () => const PermissionScreen(),
  };

  // Narrow phone (iPhone SE / small Android). Horizontal overflow surfaces here.
  //
  // Height is a REAL phone's, not a tall canvas. It used to be 1400, which is
  // nearly twice any handset: anything that grew vertically simply fit, so this
  // audit only ever proved the horizontal half of its own claim. 640 is the
  // iPhone SE class logical height.
  const narrow = Size(320, 640);

  testWidgets('no text overflow across all 30 locales @ 320×640', (tester) async {
    tester.view.physicalSize = narrow;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final overflows = <String>[];

    for (final locale in AppLocalizations.supportedLocales) {
      for (final entry in screens.entries) {
        // Capture layout-time overflow errors (they're reported via
        // FlutterError.onError, not thrown), while ignoring unrelated render
        // errors from missing route args / providers in this harness.
        final captured = <String>[];
        final prev = FlutterError.onError;
        FlutterError.onError = (details) {
          final s = details.toString();
          if (s.contains('overflowed') || s.contains('RenderFlex')) {
            // The banner line says nothing useful; the line that names the
            // direction and pixel count is what tells you whether this is a
            // width problem (translation too long) or a height problem
            // (content taller than the phone).
            final detail = s
                .split('\n')
                .firstWhere((l) => l.contains('overflowed'),
                    orElse: () => s.split('\n').first)
                .trim();
            captured.add(detail);
          }
        };
        try {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: entry.value(),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 32));
        } catch (_) {
          // Non-overflow render error (route args/plugins/providers) — ignore;
          // this audit only cares about layout overflow.
        } finally {
          FlutterError.onError = prev;
        }
        // Drain any thrown exception so it doesn't fail the test for non-overflow
        // reasons; overflow is tracked via `captured` above.
        tester.takeException();
        if (captured.isNotEmpty) {
          overflows.add('${locale.toLanguageTag()} · ${entry.key}: '
              '${captured.first}');
        }
        // Clear the tree between cases.
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }

    if (overflows.isNotEmpty) {
      fail('Overflow in ${overflows.length} (locale × screen) case(s):\n'
          '${overflows.join('\n')}');
    }
  });
}
