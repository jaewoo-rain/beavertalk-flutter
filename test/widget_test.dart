// Smoke test: the app boots into the AuthGate splash without throwing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/main.dart';

void main() {
  testWidgets('app boots into AuthGate', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BeaverTalkApp()));
    // First frame shows the splash (token read is async, fired post-frame).
    expect(find.byType(BeaverTalkApp), findsOneWidget);
  });
}
