// Smoke test: the app boots into the AuthGate splash without throwing.

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
  });
}
