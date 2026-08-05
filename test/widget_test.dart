// Smoke test: the app boots into the AuthGate splash without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/main.dart';

/// The real controller's `bootstrap()` reaches `Supabase.instance`, which
/// `main()` initialises but a widget test does not — so the unstubbed gate
/// throws "must initialize the supabase instance" from its post-frame callback.
/// Stub `bootstrap()` to a no-op: the gate then holds at [AuthStatus.unknown]
/// (the splash), which is exactly what this smoke test asserts.
class _StubAuthController extends AuthController {
  @override
  Future<void> bootstrap() async {}
}

void main() {
  testWidgets('app boots into AuthGate', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [authControllerProvider.overrideWith(_StubAuthController.new)],
      child: const BeaverTalkApp(),
    ));
    // First frame shows the splash (token read is async, fired post-frame).
    expect(find.byType(BeaverTalkApp), findsOneWidget);
    // The splash mirrors the native launch screen: the mascot centred on
    // `Background/Normal/Normal`. If either drifts the hand-off from the OS
    // splash starts to flicker.
    expect(
      tester.widget<Image>(find.byType(Image)).image,
      const AssetImage('assets/images/splash_mascot.png'),
    );
    // The ring is what tells the user a slow members/me is still working — the
    // native splash it hands off from cannot animate.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // The native launch screen follows the system appearance (`color` /
  // `color_dark` in the flutter_native_splash block). This pins the Flutter
  // side to the same pair: a splash frozen to one palette would flash against
  // the launch screen in the other mode, which is the seam this screen exists
  // to hide. Values are `Background/Normal/Normal` and `Primary/Normal`.
  for (final (brightness, background, ring) in [
    (Brightness.light, const Color(0xFFF1F1F5), const Color(0xFF007A55)),
    (Brightness.dark, const Color(0xFF181A20), const Color(0xFF00FFB2)),
  ]) {
    testWidgets('splash follows the $brightness palette',
        (WidgetTester tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_StubAuthController.new),
        ],
        child: const BeaverTalkApp(),
      ));

      expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        background,
      );
      expect(
        tester
            .widget<CircularProgressIndicator>(
                find.byType(CircularProgressIndicator))
            .color,
        ring,
      );
    });
  }
}
