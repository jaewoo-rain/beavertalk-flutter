import 'package:beavertalk/features/normalcall/presentation/avatar_emotion.dart';
import 'package:beavertalk/features/normalcall/presentation/avatar_assets.dart'
    show kEmotionHappy, kEmotionSurprised, kEmotionSad, kEmotionAngry;
import 'package:flutter_test/flutter_test.dart';

/// 실제 바바 대사에 가깝게 쓴 턴 표본. 한 항목 = 한 턴(여러 문장).
/// 츤데레·반말 페르소나이며, 한국어 구어 필러를 일부러 섞었다.
const _turns = <String>[
  '뭐야, 또 틀렸잖아. 그래도 발음은 나쁘지 않네. 다시 해봐.',
  '오, 이번엔 좋아! 진짜 잘했어. 계속 그렇게 해.',
  '음... 그건 좀 아쉽다. 조사를 빼먹었어. 미안, 다시 설명할게.',
  '헐 대박. 그걸 한 번에 맞췄다고? 나 놀랐어.',
  '아니 그게 아니라. 받침을 제대로 발음해야지. 답답하네 진짜.',
  '그래 뭐, 나쁘지 않아. 다음 문장 가자.',
  '하하 웃기네. 근데 문법은 틀렸어. 정말?이라고 물어봐야지.',
  '오늘은 여기까지. 수고했어. 내일 또 보자.',
];

/// 델타 스트리밍 흉내 — 서버는 토큰 단위로 쪼개 보낸다.
List<String> _deltas(String line, {int chunk = 3}) {
  final out = <String>[];
  for (var i = 0; i < line.length; i += chunk) {
    out.add(line.substring(i, (i + chunk).clamp(0, line.length)));
  }
  return out;
}

/// 한 턴을 흘려보내며 표정이 **바뀐 횟수**와 그 순서를 센다.
///
/// [stepMs] = 델타 하나 사이의 시간. 이 값이 이 계측의 핵심 변수다 —
/// 자막(`output_transcript`)은 **모델이 생성하는 속도**로 오고 오디오는 실시간으로
/// 재생되므로, 자막이 소리보다 앞서 달릴 수 있다. 실시간 발화는 3글자에 120ms
/// 안팎이지만 생성이 앞서면 20ms 대까지 빨라진다.
({int changes, List<int> seq, int minDwellMs, int maxLagMs}) _run(
    String line, Duration hold,
    {int stepMs = 120}) {
  final e = SentenceEmotion(minHold: hold);
  final t0 = DateTime(2026, 8, 4, 12);
  var now = t0;
  final seq = <int>[];
  final at = <DateTime>[];
  e.reset(now: now);
  // 문장이 끝나 판정은 났는데 유지 시간 때문에 화면에 못 오른 시각.
  DateTime? pendingSince;
  var maxLag = 0;
  for (final d in _deltas(line)) {
    now = now.add(Duration(milliseconds: stepMs));
    final next = e.feed(d, now: now);
    if (next != null) {
      seq.add(next);
      at.add(now);
    } else if (e.deferred != null && pendingSince == null) {
      pendingSince = now;
    }
    // 델타 사이사이 프레임이 도는 동안 밀린 갱신이 풀린다(랩·실앱과 동일).
    final rel = e.tick(now: now);
    if (rel != null) {
      seq.add(rel);
      at.add(now);
      if (pendingSince != null) {
        final lag = now.difference(pendingSince).inMilliseconds;
        if (lag > maxLag) maxLag = lag;
        pendingSince = null;
      }
    }
  }
  // 턴이 끝난 뒤에도 유지 시간이 풀리며 밀린 갱신이 반영될 수 있다.
  now = now.add(const Duration(seconds: 3));
  final tail = e.tick(now: now);
  if (tail != null) {
    seq.add(tail);
    at.add(now);
    if (pendingSince != null) {
      final lag = now.difference(pendingSince).inMilliseconds;
      if (lag > maxLag) maxLag = lag;
    }
  }
  // ★깜빡임 지표 = 표정이 화면에 머문 **최단 시간**. 변경 횟수가 아니다 —
  // 유지 시간은 갱신을 미룰 뿐 없애지 않으므로 횟수로는 차이가 안 보인다.
  var minDwell = 1 << 30;
  for (var i = 0; i + 1 < at.length; i++) {
    final d = at[i + 1].difference(at[i]).inMilliseconds;
    if (d < minDwell) minDwell = d;
  }
  return (
    changes: seq.length,
    seq: seq,
    minDwellMs: at.length < 2 ? -1 : minDwell,
    maxLagMs: maxLag,
  );
}

void main() {
  group('classifyEmotion — 문장 단위 분류', () {
    test('사전에 있는 감정어를 잡는다', () {
      expect(classifyEmotion('진짜 잘했어!'), kEmotionHappy);
      expect(classifyEmotion('헐 대박이다'), kEmotionSurprised);
      expect(classifyEmotion('좀 아쉽네'), kEmotionSad);
      expect(classifyEmotion('아 답답하네'), kEmotionAngry);
    });

    test('감정어가 없으면 중립(0)', () {
      expect(classifyEmotion('다음 문장 가자.'), 0);
      expect(classifyEmotion(''), 0);
    });

    test('★2026-08-02에 제거한 구어 필러는 표정을 흔들지 않는다', () {
      // 이 표현들이 사전에 있던 탓에 "표정이 대사와 안 맞는다"가 났다.
      // 다시 넣지 마라 — 한국어 구어에서 감정과 무관하게 너무 자주 나온다.
      for (final filler in ['뭐야', '그만', '진짜?', '정말?', '뭐?', '미안', '흥', '쳇']) {
        expect(classifyEmotion(filler), 0, reason: '$filler 가 표정을 유발했다');
      }
      expect(classifyEmotion('really?'), 0);
      expect(classifyEmotion('sorry'), 0);
    });
  });

  group('lastSentenceEnd — 문장 경계', () {
    test('종결부호와 뒤따르는 공백까지 끊는다', () {
      expect(lastSentenceEnd('좋아! 다음'), 4); // '좋아!' + 뒤 공백
      expect(lastSentenceEnd('아직 안 끝난 문장'), 0);
      expect(lastSentenceEnd('하나. 둘! 셋?'), 9); // 마지막 '?' 까지
    });
  });

  group('SentenceEmotion — 스트리밍', () {
    test('문장이 끝나기 전에는 표정을 바꾸지 않는다 (R7)', () {
      final e = SentenceEmotion(minHold: Duration.zero);
      // 옛 구현은 '좋아' 가 들어온 순간 바로 happy 로 튀었다. 지금은 문장이
      // 끝날 때까지 아무 일도 일어나지 않는다.
      expect(e.feed('좋아'), isNull);
      expect(e.feed('하다가 말고'), isNull);
      expect(e.value, 0);
      // 종결부호에서 딱 한 번 판정한다.
      expect(e.feed(' 그건 아니야.'), kEmotionHappy);
    });

    test('🟡 사전은 부분문자열 매칭이라 어간이 다른 말도 잡는다 (알려진 근사)', () {
      // '좋아하다'(like) 가 '좋아'(good) 로 잡힌다. 감정 방향이 우연히 같아
      // 지금은 해롭지 않지만, 사전을 늘릴 때 이 성질을 기억해야 한다.
      // 정확한 표정은 서버 감정 태그로만 가능하다(립싱크플랜 §6 2차).
      expect(classifyEmotion('나는 김치를 좋아하지 않아.'), kEmotionHappy);
    });

    test('새 턴은 직전 턴의 미완 조각을 물려받지 않는다', () {
      final e = SentenceEmotion(minHold: Duration.zero);
      e.feed('좋아 정말');
      e.reset();
      expect(e.feed('다음 문장 가자.'), isNull); // 이미 0 이므로 변경 없음
      expect(e.value, 0);
    });

    test('최소 유지 시간은 갱신을 버리지 않고 미룬다', () {
      final t0 = DateTime(2026, 8, 4, 12);
      final e = SentenceEmotion(minHold: const Duration(milliseconds: 1500));
      expect(e.feed('진짜 잘했어!', now: t0), kEmotionHappy);
      // 0.3초 뒤 다음 문장 — 유지 시간 안이라 즉시 반영되지 않는다.
      final t1 = t0.add(const Duration(milliseconds: 300));
      expect(e.feed('답답하네.', now: t1), isNull);
      expect(e.value, kEmotionHappy);
      expect(e.deferred, kEmotionAngry);
      // 유지 시간이 지나면 밀린 값이 반영된다(턴 내내 고정하던 옛 결함과 다르다).
      final t2 = t0.add(const Duration(milliseconds: 1600));
      expect(e.tick(now: t2), kEmotionAngry);
      expect(e.value, kEmotionAngry);
    });
  });

  group('깜빡임 계측 — 유지 시간 0 vs 1.5초', () {
    // 델타 도착 속도별로 잰다. 느린 쪽 = 자막이 소리와 나란히 오는 경우,
    // 빠른 쪽 = 모델 생성이 재생을 앞질러 자막만 먼저 쏟아지는 경우.
    for (final (label, stepMs) in [('실시간 120ms', 120), ('생성선행 20ms', 20)]) {
      test('유지 시간 스윕 — $label', () {
        // 250ms 미만으로 스쳐 지나가면 사람 눈엔 깜빡임이다.
        const flickerMs = 250;
        // ignore: avoid_print
        print('[$label] 유지시간   깜빡인턴   최단유지   표정지연(최대)');
        final flicks = <int, int>{};
        for (final holdMs in [0, 400, 800, 1500]) {
          var f = 0, minDwell = 1 << 30, maxLag = 0;
          for (final line in _turns) {
            final r = _run(line, Duration(milliseconds: holdMs), stepMs: stepMs);
            if (r.minDwellMs >= 0 && r.minDwellMs < flickerMs) f++;
            if (r.minDwellMs >= 0 && r.minDwellMs < minDwell) {
              minDwell = r.minDwellMs;
            }
            if (r.maxLagMs > maxLag) maxLag = r.maxLagMs;
          }
          flicks[holdMs] = f;
          // ignore: avoid_print
          print('[$label] ${holdMs.toString().padLeft(5)}ms '
              '${f.toString().padLeft(8)}개 '
              '${minDwell.toString().padLeft(8)}ms '
              '${maxLag.toString().padLeft(12)}ms');
        }
        // 유지 시간을 늘렸는데 깜빡임이 늘어나는 일은 없어야 한다.
        expect(flicks[1500]!, lessThanOrEqualTo(flicks[0]!));
        expect(flicks[800]!, lessThanOrEqualTo(flicks[0]!));
      });
    }
  });
}
