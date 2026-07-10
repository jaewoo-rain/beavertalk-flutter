import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call_finish.dart';

/// i18n smoke test: the migrated CallFinishScreen renders its English copy when
/// the app is forced to the `en` locale (as `main.dart` does in production).
void main() {
  testWidgets('CallFinishScreen shows English copy under Locale("en")',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CallFinishScreen(),
        ),
      ),
    );
    // Let the localizations delegate resolve.
    await tester.pump();

    // The rating prompt and the primary action render in English.
    expect(find.text('How was your call?'), findsOneWidget);
    expect(find.text('View Analysis'), findsOneWidget);
    // And no leftover Korean copy from the migrated screen.
    expect(find.text('통화는 어떠셨나요?'), findsNothing);
  });
}
