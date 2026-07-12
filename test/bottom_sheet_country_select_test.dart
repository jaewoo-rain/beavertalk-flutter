import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/organisms/bottom_sheet_country_select.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

/// QA8 — the country/language select sheet renders cross-platform SVG flags
/// (not emoji) and localizes its title/confirm under the forced `en` locale.
void main() {
  Widget host(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    );
  }

  testWidgets('builds with delegates, shows CountryFlag + English strings',
      (tester) async {
    const items = [
      CountryItem(code: 'en', name: 'English', countryCode: 'US'),
      CountryItem(code: 'ko', name: '한국어', countryCode: 'KR'),
      CountryItem(code: 'ja', name: '日本語', countryCode: 'JP'),
    ];

    await tester.pumpWidget(
      host(
        const BottomSheetCountrySelect(
          items: items,
          value: 'en',
          showHomeIndicator: false,
        ),
      ),
    );
    // Let the localizations delegate + SVG flags resolve.
    await tester.pump();

    // Localized defaults render (English).
    expect(find.text('Select a country'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    // Flags render via the country_flags SVG widget (one per row), not emoji.
    expect(find.byType(CountryFlag), findsNWidgets(items.length));

    // Row names are present.
    expect(find.text('English'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
  });

  testWidgets('honors an explicit title override', (tester) async {
    await tester.pumpWidget(
      host(
        const BottomSheetCountrySelect(
          title: 'Select your language',
          items: [CountryItem(code: 'en', name: 'English', countryCode: 'US')],
          value: 'en',
          showHomeIndicator: false,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Select your language'), findsOneWidget);
    // Confirm still falls back to the localized default.
    expect(find.text('Confirm'), findsOneWidget);
  });
}
