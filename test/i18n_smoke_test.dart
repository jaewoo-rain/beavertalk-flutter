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
    await tester.pump();
    await tester.pumpAndSettle();

    // P8: 종료 화면이 먼저 보인다 — 도착했을 때 평가 시트가 덮지 않는다.
    expect(find.text('How was your call?'), findsNothing);
    expect(find.text('View Analysis'), findsOneWidget);
    // And no leftover Korean copy from the migrated screen.
    expect(find.text('통화는 어떠셨나요?'), findsNothing);

    // 떠나려 할 때(홈으로) 시트가 한 번 뜨고, 영어로 그려진다.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('How was your call?'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    // Skip closes the sheet without rating.
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('How was your call?'), findsNothing);

    // 한 화면에 한 번만 묻는다.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('How was your call?'), findsNothing);
  });
}
