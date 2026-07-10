import 'dart:math';

import 'package:beavertalk/features/pronunciation_challenge/data/curated_word_source.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_card.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_engine.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/game_config.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/speech_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

ChallengeEngine _seededEngine() =>
    ChallengeEngine(wordSource: CuratedWordSource(random: Random(42)));

void main() {
  group('SpeechMatcher token consumption', () {
    test('growing partials pass each spoken token at most once', () {
      final matcher = SpeechMatcher();
      final passed = <String>[];
      final available = <String>['사과', '바다'];
      bool attempt(String tok) {
        if (available.remove(tok)) {
          passed.add(tok);
          return true;
        }
        return false;
      }

      matcher.feed('사', isFinal: false, attempt: attempt); // partial, no match
      matcher.feed('사과', isFinal: false, attempt: attempt); // pass 사과
      matcher.feed('사과', isFinal: false, attempt: attempt); // consumed → no repeat
      expect(passed, <String>['사과']);

      // Same utterance grows with a second word → the new token passes.
      matcher.feed('사과 바다', isFinal: false, attempt: attempt);
      expect(passed, <String>['사과', '바다']);
    });

    test('isFinal resets bookkeeping so the next utterance starts clean', () {
      final matcher = SpeechMatcher();
      final passed = <String>[];
      bool attempt(String tok) {
        if (tok == '사과') {
          passed.add(tok);
          return true;
        }
        return false;
      }

      matcher.feed('사과', isFinal: true, attempt: attempt);
      matcher.feed('사과', isFinal: true, attempt: attempt); // fresh utterance
      expect(passed, <String>['사과', '사과']);
    });

    test('a non-continuation partial (restart) resets the consumed cursor', () {
      final matcher = SpeechMatcher();
      final passed = <String>[];
      bool attempt(String tok) {
        if (tok == '사과') {
          passed.add(tok);
          return true;
        }
        return false;
      }

      matcher.feed('사과', isFinal: false, attempt: attempt); // pass, consumed=1
      matcher.feed('배', isFinal: false, attempt: attempt); // restart → reset
      matcher.feed('사과', isFinal: false, attempt: attempt); // passes again
      expect(passed, <String>['사과', '사과']);
    });

    test('reset() clears the cursor', () {
      final matcher = SpeechMatcher();
      matcher.feed('사과', isFinal: false, attempt: (_) => true);
      expect(matcher.consumed, 1);
      matcher.reset();
      expect(matcher.consumed, 0);
    });

    test('normalization strips punctuation before matching', () {
      final matcher = SpeechMatcher();
      final seen = <String>[];
      matcher.feed('사과!', isFinal: true, attempt: (tok) {
        seen.add(tok);
        return false;
      });
      expect(seen, <String>['사과']); // '!' stripped by norm
    });
  });

  group('ChallengeEngine.tryPassToken', () {
    test('passes only an exact, in-zone match (front-most first)', () {
      final e = _seededEngine()..start();
      final near = ChallengeCard(
        id: 1,
        word: '사과',
        colorIndex: 0,
        x: GameConfig.zoneCx,
        y: GameConfig.beltY,
      );
      final behind = ChallengeCard(
        id: 2,
        word: '바다',
        colorIndex: 0,
        x: GameConfig.zoneCx + 100,
        y: GameConfig.beltY,
      );
      final far = ChallengeCard(
        id: 3,
        word: '포도',
        colorIndex: 0,
        x: GameConfig.zoneCx + GameConfig.acceptMargin + 200,
        y: GameConfig.beltY,
      );
      e.cards
        ..clear()
        ..addAll(<ChallengeCard>[behind, near, far]);

      expect(e.tryPassToken('배'), isFalse); // no card matches
      expect(e.tryPassToken('포도'), isFalse); // far is outside the accept range
      expect(e.tryPassToken('바다'), isTrue); // in-zone exact match
      expect(behind.state, CardState.pass);
      expect(e.tryPassToken('사과'), isTrue);
      expect(near.state, CardState.pass);
      expect(far.state, CardState.live);
    });

    test('returns false when not running', () {
      final e = _seededEngine();
      expect(e.tryPassToken('사과'), isFalse);
    });

    test('SpeechMatcher wired to tryPassToken clears matching cards', () {
      final e = _seededEngine()..start();
      final apple = ChallengeCard(
        id: 1,
        word: '사과',
        colorIndex: 0,
        x: GameConfig.zoneCx,
        y: GameConfig.beltY,
      );
      e.cards
        ..clear()
        ..add(apple);
      final matcher = SpeechMatcher();
      matcher.feed('사과', isFinal: false, attempt: e.tryPassToken);
      expect(apple.state, CardState.pass);
    });
  });
}
