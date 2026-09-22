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

import 'support/i18n_screens.dart';

void main() {
  // ⛔ 화면 목록을 여기 두지 마라 — `test/support/i18n_screens.dart` 가 정본이다.
  //    잘림 시험이 같은 목록을 본다.
  final screens = i18nScreens();

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
