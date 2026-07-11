import 'dart:math';

import 'package:beavertalk/features/pronunciation_challenge/data/curated_word_source.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_card.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_engine.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/game_config.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/matcher.dart';
import 'package:beavertalk/features/pronunciation_challenge/presentation/pronunciation_challenge_screen.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ChallengeEngine _seededEngine() =>
    ChallengeEngine(wordSource: CuratedWordSource(random: Random(42)));

void main() {
  group('matcher', () {
    test('norm strips punctuation and lower-cases', () {
      expect(norm(' Hello, 사과! '), 'hello사과');
      expect(norm(null), '');
    });

    test('wordMatch is exact after normalization', () {
      expect(wordMatch('사과', '사과'), isTrue);
      expect(wordMatch('사과', '사과!'), isTrue);
      expect(wordMatch('', '사과'), isFalse);
      expect(wordMatch('사과', '배'), isFalse);
    });
  });

  group('curated word source', () {
    test('excludes the five profanities', () {
      const banned = ['씨발', '병신', '바보', '멍청이', '개새끼'];
      for (final b in banned) {
        expect(CuratedWordSource.words, isNot(contains(b)));
      }
    });

    test('shuffle bag returns every word once before repeating', () {
      final src = CuratedWordSource(random: Random(1));
      final seen = <String>{};
      for (var i = 0; i < CuratedWordSource.words.length; i++) {
        seen.add(src.draw().word);
      }
      expect(seen.length, CuratedWordSource.words.length);
    });
  });

  group('engine', () {
    test('a pass raises score and combo', () {
      final e = _seededEngine();
      e.start();
      e.update(0.016); // spawn a card
      final card = e.cards.firstWhere((c) => c.state == CardState.live);
      final scoreBefore = e.score;
      final comboBefore = e.combo;
      e.passCard(card);
      expect(e.score, greaterThan(scoreBefore));
      expect(e.combo, comboBefore + 1);
      expect(e.passCount, 1);
      expect(card.state, CardState.pass);
    });

    test('combo increases the points awarded', () {
      final e = _seededEngine();
      e.start();
      // First pass: 100. Second consecutive pass: 100 + 1*12 = 112.
      e.update(0.016);
      e.passCard(e.cards.firstWhere((c) => c.state == CardState.live));
      expect(e.score, 100);
      // Force another live card into range and pass it.
      final c2 = ChallengeCard(
        id: 999,
        word: '사과',
        colorIndex: 0,
        x: GameConfig.zoneCx,
        y: GameConfig.beltY,
      );
      e.cards.add(c2);
      e.passCard(c2);
      expect(e.combo, 2);
      expect(e.score, 100 + 112);
    });

    test('three misses end the game', () {
      final e = _seededEngine();
      e.start();
      expect(e.running, isTrue);
      for (var i = 0; i < GameConfig.maxBacklog; i++) {
        expect(e.running, isTrue);
        final c = ChallengeCard(
          id: 1000 + i,
          word: 'x',
          colorIndex: 0,
          x: GameConfig.zoneCx,
          y: GameConfig.beltY,
        );
        e.missCard(c);
      }
      expect(e.backlog, GameConfig.maxBacklog);
      expect(e.running, isFalse);
    });

    test('timer hitting zero ends the game', () {
      final e = _seededEngine();
      e.start();
      // One update larger than the session (clamp lives in the controller, so
      // the engine accepts the raw dt here).
      e.update(GameConfig.sessionSec + 1.0);
      expect(e.sessionLeft, 0);
      expect(e.running, isFalse);
    });

    test('spawn spacing is respected (never closer than MIN_SPACING)', () {
      final e = _seededEngine();
      e.start();
      // Run ~10s of simulation at 60fps and check live-card spacing.
      for (var i = 0; i < 600; i++) {
        e.update(1 / 60);
        final live = e.cards.where((c) => c.state == CardState.live).toList()
          ..sort((a, b) => a.x.compareTo(b.x));
        for (var k = 1; k < live.length; k++) {
          final gap = live[k].x - live[k - 1].x;
          // Cards spawn at SPAWN_X only once the rightmost is >= MIN_SPACING
          // away, so adjacent live cards are always at least that far apart
          // (small float tolerance for one integration step).
          expect(gap, greaterThanOrEqualTo(GameConfig.minSpacing - 5));
        }
      }
    });

    test('tapPass passes the front-most in-zone card only', () {
      final e = _seededEngine();
      e.start();
      // Front card inside the zone, and a far one outside the accept range.
      final near = ChallengeCard(
        id: 1,
        word: 'a',
        colorIndex: 0,
        x: GameConfig.zoneCx,
        y: GameConfig.beltY,
      );
      final far = ChallengeCard(
        id: 2,
        word: 'b',
        colorIndex: 0,
        x: GameConfig.zoneCx + GameConfig.acceptMargin + 200,
        y: GameConfig.beltY,
      );
      e.cards
        ..clear()
        ..addAll([far, near]);
      expect(e.tapPass(), isTrue);
      expect(near.state, CardState.pass);
      expect(far.state, CardState.live);
    });

    test('tapPass returns false when not running', () {
      final e = _seededEngine();
      expect(e.tapPass(), isFalse);
    });
  });

  group('screen', () {
    testWidgets('builds and shows the start panel', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: PronunciationChallengeScreen(),
          ),
        ),
      );
      await tester.pump();
      // "Pronunciation Challenge" now appears twice (GNB title + start-panel
      // heading, both bound to l10n.challengeTitle after the i18n sweep).
      expect(find.text('Pronunciation Challenge'), findsNWidgets(2));
      expect(find.text('Start Camera & Mic'), findsOneWidget); // start button
    });
  });
}
