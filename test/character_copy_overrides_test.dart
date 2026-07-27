// Localized character copy: lookup, locale resolution, and — the part that
// actually matters — the fallback to the server value.
//
// The override table duplicates CMS content into the client as a stopgap while
// the server has no language axis on `character`. The failure this guards is a
// character the table does not know about (a new one added server-side)
// rendering a blank paragraph instead of the server's Korean text.

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/character/data/character_copy_overrides.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

void main() {
  const serverSummary = '틀리면 바로 비웃는 독설 마스터.';
  const serverStory = '강가에서 제일 완벽한 댐을 짓기로 유명했던 비버, 바바.';

  group('override lookup', () {
    test('returns the localized copy for a mapped character', () {
      final summary = characterSummaryFor(1, 'en', serverSummary);
      expect(summary, isNot(serverSummary));
      expect(summary, contains('sharp-tongued'));

      final story = characterStoryFor(1, 'en', serverStory);
      expect(story, isNot(serverStory));
      expect(story, contains('dam'));
    });

    test('covers every character the catalog currently ships', () {
      // Server ids: BABA 1 · BIBI 2 · Popo 9 · Rara 10 · Dudu 11.
      for (final id in [1, 2, 9, 10, 11]) {
        expect(characterSummaryFor(id, 'en', null), isNotNull,
            reason: 'summary missing for character $id');
        expect(characterStoryFor(id, 'en', null), isNotNull,
            reason: 'story missing for character $id');
      }
    });
  });

  group('fallback to the server value', () {
    // The containment for the stopgap's known gap: a character added on the
    // server has no entry here, and must still render.
    test('unmapped character falls back to the server text', () {
      expect(characterSummaryFor(999, 'en', serverSummary), serverSummary);
      expect(characterStoryFor(999, 'en', serverStory), serverStory);
    });

    test('Korean falls through to the server, which is already Korean', () {
      expect(characterSummaryFor(1, 'ko', serverSummary), serverSummary);
      expect(characterStoryFor(1, 'ko', serverStory), serverStory);
    });

    test('null server value with no override stays null', () {
      expect(characterSummaryFor(999, 'en', null), isNull);
      expect(characterStoryFor(999, 'ko', null), isNull);
    });
  });

  group('locale resolution', () {
    test('strips the region subtag', () {
      final plain = characterSummaryFor(1, 'en', null);
      expect(characterSummaryFor(1, 'en_US', null), plain);
      expect(characterSummaryFor(1, 'en-GB', null), plain);
    });

    test('is case-insensitive', () {
      expect(characterSummaryFor(1, 'EN', null),
          characterSummaryFor(1, 'en', null));
    });

    test('an unknown locale falls back to English, not to the server', () {
      // A locale with no table of its own should still read something the user
      // can understand rather than Korean prose.
      expect(characterSummaryFor(1, 'xx', serverSummary),
          characterSummaryFor(1, 'en', null));
    });

    test('a null locale still resolves through English', () {
      expect(characterSummaryFor(1, null, serverSummary),
          characterSummaryFor(1, 'en', null));
    });
  });

  group('coverage across the app\'s supported locales', () {
    const catalogIds = [1, 2, 9, 10, 11];

    // Korean is the one locale that must NOT be in the table: the server value
    // is already Korean and stays authoritative, so it falls through.
    final translatable = AppLocalizations.supportedLocales
        .where((l) => l.languageCode != 'ko')
        .toList();

    test('every supported locale has copy for every character', () {
      final gaps = <String>[];
      for (final locale in translatable) {
        for (final id in catalogIds) {
          final summary =
              characterSummaryFor(id, locale.languageCode, null);
          final story = characterStoryFor(id, locale.languageCode, null);
          if (summary == null) gaps.add('${locale.languageCode}/$id summary');
          if (story == null) gaps.add('${locale.languageCode}/$id story');
        }
      }
      expect(gaps, isEmpty, reason: 'missing copy: ${gaps.join(', ')}');
    });

    test('no locale silently falls back to English', () {
      // A locale whose entry was never written would resolve to the English
      // text. That reads fine but hides the gap, so assert each locale differs
      // from English rather than merely being non-null.
      final untranslated = <String>[];
      for (final locale in translatable) {
        if (locale.languageCode == 'en') continue;
        final summary = characterSummaryFor(1, locale.languageCode, null);
        if (summary == characterSummaryFor(1, 'en', null)) {
          untranslated.add(locale.languageCode);
        }
      }
      expect(untranslated, isEmpty,
          reason: 'falling back to English: ${untranslated.join(', ')}');
    });
  });
}
