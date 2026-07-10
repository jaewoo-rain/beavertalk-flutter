import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/organisms/bottom_sheet_alarm_settings.dart';
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';
import 'package:beavertalk/features/alarm/presentation/providers/alarm_providers.dart';
import 'package:beavertalk/screens/alarm/alarm_add.dart';
import 'package:beavertalk/screens/alarm/alarm_models.dart';

/// Verifies the alarm add/edit surface now presents as a **modal bottom sheet**
/// (not a pushed full page) and still returns an [AlarmData] contract.
void main() {
  const characters = [
    AlarmCharacter(characterId: 1, name: 'Beaver'),
    AlarmCharacter(characterId: 2, name: 'Otter'),
  ];

  Widget host(void Function(AlarmData?) onResult) {
    return ProviderScope(
      overrides: [
        // Bypass the network: feed a ready list of characters.
        availableCharactersProvider
            .overrideWith((ref) async => characters),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showModalBottomSheet<AlarmData>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AlarmAddSheet(),
                  );
                  onResult(result);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('tapping open presents AlarmAddSheet in a modal sheet route',
      (tester) async {
    await tester.pumpWidget(host((_) {}));

    // The sheet is not mounted until the button is tapped.
    expect(find.byType(AlarmAddSheet), findsNothing);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Sheet body is now on a modal route above the page.
    expect(find.byType(AlarmAddSheet), findsOneWidget);
    expect(find.byType(BottomSheetAlarmSettings), findsOneWidget);
    // Add mode header.
    expect(find.text('새 일정 추가'), findsOneWidget);
  });

  testWidgets('saving pops the sheet and returns an AlarmData', (tester) async {
    AlarmData? captured;
    var called = false;
    await tester.pumpWidget(host((r) {
      captured = r;
      called = true;
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Tap the footer save button ("저장").
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(called, isTrue);
    expect(captured, isNotNull);
    // Default add-mode seed: 8:00 AM, first character selected.
    expect(captured!.hour, 8);
    expect(captured!.minute, 0);
    expect(captured!.meridiem, Meridiem.am);
    expect(captured!.characterId, 1);
    // Sheet has been dismissed.
    expect(find.byType(AlarmAddSheet), findsNothing);
  });

  testWidgets('dismissing the sheet returns null', (tester) async {
    AlarmData? captured;
    var called = false;
    await tester.pumpWidget(host((r) {
      captured = r;
      called = true;
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Dismiss by tapping the modal barrier scrim.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(called, isTrue);
    expect(captured, isNull);
    expect(find.byType(AlarmAddSheet), findsNothing);
  });
}
