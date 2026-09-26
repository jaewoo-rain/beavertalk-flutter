import 'dart:math';
import 'dart:ui' show PictureRecorder;

import 'package:beavertalk/features/pronunciation_challenge/data/curated_word_source.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_card.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/challenge_engine.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/game_config.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/matcher.dart';
import 'package:beavertalk/features/pronunciation_challenge/domain/word_layout.dart';
import 'package:beavertalk/features/pronunciation_challenge/presentation/challenge_painter.dart';
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
      // First pass: 100. Second consecutive pass: 100 + 1*100 = 200 (09-24).
      e.update(0.016);
      e.passCard(e.cards.firstWhere((c) => c.state == CardState.live));
      expect(e.score, 100);
      // Force another live card into range and pass it.
      final c2 = ChallengeCard(
        id: 999,
        word: '사과',
        k: 1.0, // at the judgment point
      );
      e.cards.add(c2);
      e.passCard(c2);
      expect(e.combo, 2);
      expect(e.score, 100 + 200);
    });

    test('the miss allowance ends the game, and it follows difficulty', () {
      // A flat three would end a beginner's run in ~10s and leave no clip.
      for (final d in Difficulty.values) {
        final e = _seededEngine();
        e.difficulty = d;
        e.start();
        for (var i = 0; i < d.missAllow; i++) {
          expect(e.running, isTrue,
              reason: '$d must survive ${d.missAllow - 1} misses');
          e.missCard(ChallengeCard(id: 1000 + i, word: 'x', k: 1.0));
        }
        expect(e.backlog, d.missAllow);
        expect(e.running, isFalse);
      }
    });

    test('grade and accuracy come from cleared vs attempted', () {
      final e = _seededEngine();
      e.start();
      expect(e.accuracy, 0, reason: 'no attempts reads as zero, not NaN');
      expect(e.grade, 'C');

      // 8 cleared, 0 missed → 100% but only 8 attempts: A, not S.
      for (var i = 0; i < 8; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      expect(e.accuracy, 1.0);
      expect(e.grade, 'A', reason: 'S needs volume, not just a clean streak');

      // 12 cleared clears the volume bar.
      for (var i = 8; i < 12; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      expect(e.grade, 'S');
      expect(e.resultTitle, 'Flawless!');
    });

    test('a mostly-missed run does not read as a good one', () {
      // The old title only looked at maxCombo, so three in a row said "Nice!"
      // no matter how much was missed.
      final e = _seededEngine();
      e.difficulty = Difficulty.slow; // 4 misses of rope
      e.start();
      for (var i = 0; i < 3; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      expect(e.maxCombo, 3);
      for (var i = 0; i < 4; i++) {
        e.missCard(ChallengeCard(id: 100 + i, word: 'x', k: 1.0));
      }
      expect(e.accuracy, closeTo(3 / 7, 0.001));
      expect(e.grade, 'C');
      expect(e.resultTitle, 'Keep going!');
    });

    test('slow is more forgiving than fast', () {
      expect(Difficulty.slow.missAllow, greaterThan(Difficulty.fast.missAllow));
      expect(Difficulty.fast.missAllow, GameConfig.minMissAllow);
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

    test('spawn spacing is respected (never closer than K_SPACING)', () {
      final e = _seededEngine();
      e.start();
      // Run ~10s of simulation at 60fps and check live-word depth spacing.
      for (var i = 0; i < 600; i++) {
        e.update(1 / 60);
        final live = e.cards.where((c) => c.state == CardState.live).toList()
          ..sort((a, b) => a.k.compareTo(b.k));
        for (var n = 1; n < live.length; n++) {
          final gap = live[n].k - live[n - 1].k;
          // A word spawns at K_SPAWN only once the youngest live one is
          // K_SPACING ahead, and every live word advances at the same rate, so
          // that gap is preserved (small float tolerance for one step).
          expect(gap, greaterThanOrEqualTo(GameConfig.kSpacing - 0.01));
        }
      }
    });

    test('overlap invariant: no two live words are within a 1.6 k-ratio', () {
      // The real constraint behind K_SPACING. A word's half-height is
      // ~0.57*size, so two words only clear each other above a k ratio of 1.6.
      final e = _seededEngine();
      e.start();
      for (var i = 0; i < 900; i++) {
        e.update(1 / 60);
        final live = e.cards.where((c) => c.state == CardState.live).toList()
          ..sort((a, b) => a.k.compareTo(b.k));
        for (var n = 1; n < live.length; n++) {
          expect(live[n].k / live[n - 1].k, greaterThanOrEqualTo(1.6));
        }
      }
    });

    test('a word past K_MISS freezes into grace, not a miss', () {
      final e = _seededEngine();
      e.start();
      final c = ChallengeCard(id: 1, word: '사과', k: GameConfig.kMiss - 0.001);
      e.cards
        ..clear()
        ..add(c);
      e.update(1 / 30); // enough to carry it past kMiss
      expect(c.state, CardState.grace);
      expect(c.k, GameConfig.kMiss);
      expect(e.backlog, 0, reason: 'grace must not count as a miss yet');
    });

    test('a grace word still passes, at the late-point ratio', () {
      final e = _seededEngine();
      e.start();
      final c = ChallengeCard(
        id: 1,
        word: '사과',
        k: GameConfig.kMiss,
        state: CardState.grace,
        graceLeft: GameConfig.graceSec,
      );
      e.cards
        ..clear()
        ..add(c);
      expect(e.tryPassToken('사과'), isTrue);
      expect(c.state, CardState.pass);
      // 100 * 0.6 = 60, versus 100 for an on-time first pass.
      expect(e.score, (100 * GameConfig.latePointRatio).round());
      // 유예 통과는 판정 GOOD(웹 judgeOf) — 옛 「LATE」 보조 글자는 판정 글자로 바뀌었다.
      expect(e.hitTexts.single.judge, Judge.good);
      expect(e.hitTexts.single.points, 60);
    });

    test('grace running out is the miss', () {
      final e = _seededEngine();
      e.start();
      final c = ChallengeCard(
        id: 1,
        word: '사과',
        k: GameConfig.kMiss,
        state: CardState.grace,
        graceLeft: GameConfig.graceSec,
      );
      e.cards
        ..clear()
        ..add(c);
      e.update(GameConfig.graceSec / 2);
      expect(e.backlog, 0);
      e.update(GameConfig.graceSec);
      expect(c.state, CardState.miss);
      expect(e.backlog, 1);
    });

    test('tapPass passes the front-most in-zone card only', () {
      final e = _seededEngine();
      e.start();
      // Front card inside the zone, and a far one outside the accept range.
      final near = ChallengeCard(
        id: 1,
        word: 'a',
        k: 1.0, // at the judgment point
      );
      final far = ChallengeCard(
        id: 2,
        word: 'b',
        k: GameConfig.kSpawn, // far from the viewer → below kAccept
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

  // ── 09-26 웹 개편 앱 반영(T-20260926-05 요청서 §6 완료 조건) ─────────────
  group('web 개편 반영', () {
    test('목숨 4 / 3 / 2 · 속도 배율 그대로', () {
      expect(Difficulty.slow.missAllow, 4);
      expect(Difficulty.normal.missAllow, 3);
      expect(Difficulty.fast.missAllow, 2);
      expect(Difficulty.slow.mult, 0.6);
      expect(Difficulty.normal.mult, 1.0);
      expect(Difficulty.fast.mult, 1.8);
    });

    test('점수 = 100 + (콤보-1)×100 · 10콤보 연속 합 5,500', () {
      final e = _seededEngine();
      e.start();
      for (var i = 0; i < 10; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      expect(e.combo, 10);
      expect(e.score, 5500);
      expect(ChallengeEngine.pointsFor(10, late: false), 1000);
      expect(ChallengeEngine.pointsFor(3, late: true), 180); // 300 × 0.6
    });

    test('판정 등급 경계 — k 0.8 · 0.9 · 1.15 · LATE', () {
      Judge j(double k, {bool late = false}) =>
          ChallengeEngine.judgeOf(k, late: late);
      expect(j(0.79), Judge.good);
      expect(j(0.8), Judge.great);
      expect(j(0.89), Judge.great);
      expect(j(0.9), Judge.perfect);
      expect(j(1.0), Judge.perfect);
      expect(j(1.15), Judge.perfect);
      expect(j(1.16), Judge.great);
      expect(j(1.0, late: true), Judge.good, reason: '유예 통과는 무조건 GOOD');
    });

    test('판정 글자 · 5콤보마다 마일스톤 · 흔들림 · 콤보 튐', () {
      final e = _seededEngine();
      e.start();
      for (var i = 0; i < 4; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      expect(e.hitTexts.where((h) => h.isMilestone), isEmpty);
      expect(e.hitTexts.last.judge, Judge.perfect);
      expect(e.hitTexts.last.y, ChallengeEngine.judgeY);
      expect(e.comboPop, 1);
      expect(e.shake, 0.25);

      e.passCard(ChallengeCard(id: 4, word: 'x', k: 1.0)); // 5콤보
      final m = e.hitTexts.where((h) => h.isMilestone).single;
      expect(m.combo, 5);
      expect(m.y, ChallengeEngine.milestoneY);
      expect(m.life, 1.3);
      expect(e.shake, 1);
      expect(e.flashPass, 1.6);

      e.missCard(ChallengeCard(id: 5, word: 'x', k: 1.0));
      expect(e.comboPop, 0);
      expect(e.shake, 1, reason: '큰 값을 줄이지 않는다');
      expect(e.hitTexts.last.judge, Judge.miss);
      expect(e.hitTexts.last.points, 0);

      e.update(1); // 3.5/s·4/s 로 줄어든다
      expect(e.shake, 0);
      expect(e.comboPop, 0);
    });

    test('학습 문장 두 줄 — 가운데에 가장 가까운 띄어쓰기에서 접는다', () {
      final (a, b) = splitInTwoLines('저는 선생님이에요')!;
      expect((a, b), ('저는', '선생님이에요'));
      expect((a.length, b.length), (2, 6));
      // 띄어쓰기가 여럿이면 글자 수 가운데에 가장 가까운 것.
      expect(splitInTwoLines('오늘 날씨가 정말 좋네요'), ('오늘 날씨가', '정말 좋네요'));
      // 띄어쓰기가 없으면 절반(올림) — 11자 → 6 | 5.
      expect(splitInTwoLines('안녕하세요반갑습니다요'), ('안녕하세요반', '갑습니다요'));
      expect(splitInTwoLines('가'), isNull);
    });

    testWidgets('painter — 판정 글자 · 마일스톤 · 흔들림 · 두 줄 문장을 그린다', (tester) async {
      final e = _seededEngine();
      e.start();
      e.cards.add(ChallengeCard(id: 900, word: '저는 선생님이에요 정말 반갑습니다', k: 1.0));
      for (var i = 0; i < 5; i++) {
        e.passCard(ChallengeCard(id: i, word: 'x', k: 1.0));
      }
      e.missCard(ChallengeCard(id: 50, word: 'x', k: 1.0));
      expect(e.shake, greaterThan(0));
      final painter = ChallengePainter(
        engine: e,
        repaint: ChangeNotifier(),
        mint: const Color(0xFF00FFB2),
        background: const Color(0xFF0B0F14),
      );
      final recorder = PictureRecorder();
      painter.paint(Canvas(recorder), const Size(360, 640));
      recorder.endRecording().dispose();
    });

    test('점수 글자 천 단위 쉼표', () {
      expect(thousands(900), '900');
      expect(thousands(1000), '1,000');
      expect(thousands(5500), '5,500');
      expect(thousands(1234567), '1,234,567');
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
      // Once, not twice: the design drops the GNB on this screen (the camera
      // runs edge to edge and a solid header would cut the stage), so the
      // start-panel heading is the only place the title appears.
      expect(find.text('Pronunciation Challenge'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(find.text('Start'), findsOneWidget); // CTA, shortened by the design
      expect(find.text('Choose a difficulty'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);
    });

    // QA F042(09-26): 뒤로 버튼이 시작 패널 **아래**에 쌓여, 딤에 덮여 흐리고 탭도 막혔다.
    testWidgets('시작 패널 위에서도 뒤로 화살표가 눌려 화면을 닫는다', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PronunciationChallengeScreen(),
                      ),
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      // 화면이 틱커를 계속 돌려 pumpAndSettle 은 끝나지 않는다 — 전환 시간만큼 민다.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Choose a difficulty'), findsOneWidget);
      // hitTestable: 위에 덮인 것이 없어야 찾힌다.
      final back = find.byIcon(Icons.arrow_back_ios_new).hitTestable();
      expect(back, findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
      await tester.tap(back);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(PronunciationChallengeScreen), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });
  });
}
