import 'dart:math';

import 'package:beavertalk/features/pronunciation_challenge/data/curated_word_source.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_card.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_engine.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/game_config.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/matcher.dart';
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

  group('wordMatch tolerance (particles + 1-char wobble)', () {
    test('exact match', () {
      expect(wordMatch('음악', '음악'), isTrue);
    });

    test('attached Korean particle (token ⊇ card word)', () {
      expect(wordMatch('음악을', '음악'), isTrue);
      expect(wordMatch('학교에서', '학교'), isTrue);
      expect(wordMatch('커피를', '커피'), isTrue);
    });

    test('does NOT let a 1-char card swallow a longer word', () {
      expect(wordMatch('코끼리', '코'), isFalse); // "끼리" is not a particle
      expect(wordMatch('개나리', '개'), isFalse);
    });

    test('1-char wobble matches for words ≥3 chars', () {
      expect(wordMatch('시게', '시계'), isFalse); // len 2 → exact only
      expect(wordMatch('원숭기', '원숭이'), isTrue); // len 3, distance 1
      expect(wordMatch('지하절', '지하철'), isTrue);
    });

    test('short words require exact (no fuzzy false positives)', () {
      expect(wordMatch('개', '게'), isFalse); // distance 1 but len 2
      expect(wordMatch('배', '개'), isFalse);
    });

    test('unrelated words never match', () {
      expect(wordMatch('바나나', '사과'), isFalse);
      expect(wordMatch('토마토', '포도'), isFalse);
    });
  });

  group('sentenceMatch (whole-sentence cards from DB)', () {
    test('transcript containing the sentence matches (spacing ignored)', () {
      expect(sentenceMatch('어 저는 학생입니다 네', '저는 학생입니다'), isTrue);
      expect(sentenceMatch('저는 학생 입니다', '저는 학생입니다'), isTrue);
      expect(sentenceMatch('커피 주세요 그리고 물도요', '커피 주세요'), isTrue);
    });

    test('partial / trailing speech still matches via containment', () {
      expect(
        sentenceMatch('오늘 날씨가 참 좋네요 정말', '오늘 날씨가 참 좋네요'),
        isTrue,
      );
    });

    test('a different sentence does not match', () {
      expect(sentenceMatch('저는 회사원입니다', '저는 학생입니다'), isFalse);
      expect(sentenceMatch('바나나 주세요', '커피 주세요'), isFalse);
    });

    test('eojeol coverage passes a mostly-right long sentence', () {
      // 4 eojeols, one mis-heard → 3/4 ≥ ceil(0.7*4)=3.
      expect(
        sentenceMatch('나는 매일 아침 커피를', '나는 매일 아침에 커피를'),
        isTrue,
      );
    });

    test('ChallengeEngine.tryPassSentence clears the in-zone sentence card', () {
      final e = _seededEngine()..start();
      final card = ChallengeCard(
        id: 1,
        word: '저는 학생입니다',
        colorIndex: 0,
        x: GameConfig.zoneCx,
        y: GameConfig.beltY,
      );
      e.cards
        ..clear()
        ..add(card);
      expect(e.tryPassSentence('음 저는 학생입니다'), isTrue);
      expect(card.state, CardState.pass);
    });
  });

  group('server-STT stateless matching (cumulative transcript)', () {
    // Mirrors SttService._matchSpoken: every transcript message re-scans ALL
    // tokens against the engine's in-zone live cards. Google Cloud STT
    // streaming (single_utterance=false) sends a *cumulative* growing
    // transcript ("머리" → "머리 가방" → "머리 가방 우유") with a `final` only at
    // pauses — so per-utterance/consumed-cursor logic clears only the first
    // word. Stateless re-scan clears each word as its card sits in the zone.
    final whitespace = RegExp(r'\s+');
    void matchSpoken(String text, bool Function(String) tryPass) {
      for (final raw in text.toLowerCase().split(whitespace)) {
        final tok = norm(raw);
        if (tok.isNotEmpty) tryPass(tok);
      }
    }

    // The real event stream Google returned for "머리 가방 우유" spoken
    // continuously (captured against the live backend).
    const cumulativeStream = <String>[
      '머', '머리', '머리', '머리가', '머리',
      ' 가방', '머리 가방', '머리 가방',
      ' 우', '머리 가방', ' 우유',
      '머리 가방 우유', // final
    ];

    test('clears every in-zone word from one growing transcript', () {
      final e = _seededEngine()..start();
      final cards = <ChallengeCard>[
        for (final (i, w) in <String>['머리', '가방', '우유'].indexed)
          ChallengeCard(
            id: i + 1,
            word: w,
            colorIndex: 0,
            x: GameConfig.zoneCx,
            y: GameConfig.beltY,
          ),
      ];
      e.cards
        ..clear()
        ..addAll(cards);

      for (final msg in cumulativeStream) {
        matchSpoken(msg, e.tryPassToken);
      }

      // All three cards cleared — not just the first (the bug this fixes).
      expect(cards.map((c) => c.state), everyElement(CardState.pass));
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
