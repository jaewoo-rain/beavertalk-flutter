import 'package:beavertalk/core/i18n/country_names.dart';
import 'package:beavertalk/core/i18n/country_names.g.dart';
import 'package:beavertalk/features/auth/domain/entities/accent_breakdown.dart';
import 'package:beavertalk/features/weak_sound/domain/entities/weak_sound_item.dart';
import 'package:beavertalk/features/weak_sound/presentation/weak_sound_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/weak_sound/weak_sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 억양 국적 이름 — UI 언어로 바꿔 그린다.
///
/// QA F001(09-26): 공유 문장이 모든 회원·모든 언어에서 「my Korean accent sounds American!」
/// 이었다. 사용자 결정 — 1위 국적을 넣고, 국적명도 UI 언어로.
void main() {
  test('지원 언어 전부 · 서버 라벨 전부에 이름이 있다', () {
    final isos = kAccentLabelIso.values.toSet();
    for (final locale in AppLocalizations.supportedLocales) {
      final names = kCountryNames[locale.languageCode];
      expect(names, isNotNull, reason: '${locale.languageCode} 표 없음');
      for (final iso in isos) {
        expect(names![iso], isNotNull, reason: '${locale.languageCode}/$iso');
        expect(names[iso]!.trim(), isNotEmpty);
        expect(names[iso], isNot(contains('(')), reason: '괄호 설명은 뗀다');
      }
    }
  });

  test('서버 라벨 → UI 언어 이름 · 모르는 라벨은 그대로', () {
    expect(localizedCountryName('United States', 'ko'), '미국');
    expect(localizedCountryName('Japan', 'en'), 'Japan');
    expect(localizedCountryName('Russian Federation', 'ko'), '러시아');
    expect(localizedCountryName('Russia', 'ko'), '러시아');
    expect(localizedCountryName('Hong Kong', 'ko'), '홍콩');
    expect(localizedCountryName('Atlantis', 'ko'), 'Atlantis');
    expect(localizedCountryName('Japan', 'xx'), 'Japan');
  });

  test('공유 문장 — 30개 언어 모두 국적 자리가 채워진다', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      final text = l10n.accentShareText('<<C>>');
      expect(text, contains('<<C>>'), reason: locale.languageCode);
      expect(text, contains('https://beavertalk.im'), reason: locale.languageCode);
      expect(text, isNot(contains('American')), reason: locale.languageCode);
    }
  });

  testWidgets('마이페이지 억양 카드 — 한국어 UI 면 나라 이름도 한국어', (tester) async {
    tester.view.physicalSize = const Size(360, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: myPageDataHost(
          level: true,
          accentStats: const [
            AccentStat(label: 'Japan', percent: 70),
            AccentStat(label: 'Vietnam', percent: 30),
          ],
        ),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    expect(find.text('일본'), findsWidgets);
    expect(find.text('베트남'), findsWidgets);
    expect(find.text('Japan'), findsNothing);
  });

  // QA F050(09-26): 한국어 UI 취약 발음 화면에 「Hong Kong 억양」 · 「Hong Kong 화자가…」.
  testWidgets('취약 발음 화면 — 국적명도 UI 언어로', (tester) async {
    tester.view.physicalSize = const Size(360, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        weakSoundListProvider.overrideWith((ref) async => const WeakSoundList(
              national: NationalWeakSounds(country: 'Hong Kong'),
              mine: [],
            )),
      ],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WeakSoundsScreen(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));
    expect(find.text('홍콩 억양'), findsOneWidget);
    expect(find.text('홍콩 화자가 자주 틀리는 소리예요'), findsOneWidget);
    expect(find.textContaining('Hong Kong'), findsNothing);
  });
}
