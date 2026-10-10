import 'avatar_assets.dart'
    show kEmotionHappy, kEmotionSurprised, kEmotionSad, kEmotionAngry;

/// Keyword lexicon for the (heuristic) emotion classifier. Keyed by the same
/// codes as the avatar's emotion notifier. Korean + English; matched
/// case-insensitively.
const Map<int, List<String>> kEmotionLexicon = {
  kEmotionHappy: ['하하', 'ㅋㅋ', 'ㅎㅎ', '좋아', '좋은', '좋네', '좋다', '최고', '굿', '짱', '잘했',
    '대단', '훌륭', '기뻐', '신나', '행복', '사랑', 'good', 'great', 'awesome',
    'nice', 'love', 'cool', 'haha', 'perfect', 'well done', 'yay'],
  kEmotionSurprised: ['헐', '대박', '우와', '와우', '놀라', '세상에', '믿기',
    '오마이', 'wow', 'whoa', 'no way', 'oh my'],
  kEmotionSad: ['슬프', '슬퍼', '아쉽', '안타', '속상', '우울', 'ㅠ', 'ㅜ', '눈물',
    'sad', 'unfortunately'],
  kEmotionAngry: ['짜증', '바보', '멍청', '어이없', '답답', '열받', '화나',
    'ugh', 'stupid', 'annoying'],
};

// ⛔ 아래 표현들은 **일부러 뺐다**(2026-08-02). 한국어 구어에서 감정과 무관하게
// 너무 자주 나와 표정을 오탐시킨다 — 실기기에서 "표정이 대사와 안 맞는" 주된 원인:
//   surprised: '진짜?' '정말?' '뭐?' 'really?' 'what?!'  (되묻기·맞장구)
//   angry:     '뭐야' '그만' '흥' '쳇' 'stop it'          (필러·구두 습관)
//   sad:       '미안' 'sorry' 'poor'                      (예의 표현이 대부분)

/// [s] 안에서 **마지막으로 완결된 문장**이 끝나는 위치(없으면 0).
/// 종결부호 뒤에 오는 공백까지 포함해 잘라낸다.
int lastSentenceEnd(String s) {
  const marks = '.!?…~\n';
  var idx = -1;
  for (var i = 0; i < s.length; i++) {
    if (marks.contains(s[i])) idx = i;
  }
  if (idx < 0) return 0;
  var end = idx + 1;
  while (end < s.length && s[end] == ' ') {
    end++;
  }
  return end;
}

/// Classifies a line into an emotion code (0 neutral) by counting lexicon hits.
/// Cheap keyword scan; short lines. Ties/none → the highest-count wins, 0 when
/// nothing matches.
int classifyEmotion(String line) {
  if (line.isEmpty) return 0;
  final t = line.toLowerCase();
  var best = 0;
  var bestCount = 0;
  kEmotionLexicon.forEach((code, words) {
    var c = 0;
    for (final w in words) {
      if (t.contains(w)) c++;
    }
    if (c > bestCount) {
      bestCount = c;
      best = code;
    }
  });
  return best;
}

/// Turns the streamed transcript into **one emotion decision per sentence**.
///
/// 이전 구현은 토큰마다 누적 문자열 전체를 재검사하고 한 번 잡힌 값을 턴이 끝날
/// 때까지 고정했다. 그래서 문장 첫머리의 우연한 단어 하나가 턴 전체의 표정을
/// 결정했고, 실기기에서 "표정이 대사와 전혀 안 맞는다"로 나타났다(2026-08-02).
/// 립싱크 플랜 §6의 「턴 단위 갱신」 규약 위반이다.
///
/// 여기에 더해 **최소 유지 시간**을 둔다. 짧은 문장이 연달아 오면 표정이 문장마다
/// 바뀌어 깜빡이는데, 특히 키워드가 없는 문장은 0(중립)이라 감정 → 중립 → 감정으로
/// 오간다. [minHold] 안에 들어온 갱신은 **버리지 않고 미뤘다가** 유지 시간이 지나면
/// 반영한다(턴 내내 고정하던 옛 결함과 달리 지연은 [minHold] 로 상한이 있다).
///
/// ★왜 필요한가 — 자막(`output_transcript`)은 **모델이 생성하는 속도**로 오는데
/// 오디오는 실시간으로 재생된다. 생성이 재생을 앞지르면 한 턴의 자막이 200ms 안에
/// 다 쏟아지고, 표정이 문장마다 60~120ms 씩 스쳐 지나간다(실기기 S8 재현: 깜빡임
/// 3회 · 유지 138ms). 입은 이미 **재생 직전 바이트**를 보고 움직이지만(립싱크플랜
/// §5) 표정은 도착 시점을 보므로 둘이 어긋난다.
///
/// ★[kDefaultMinHold] = 400ms 의 근거 — 유지 시간을 0/400/800/1500 으로 훑었다
/// (`test/avatar_emotion_test.dart`). 400ms 가 무릎점이다: 자막이 앞설 때 깜빡임을
/// 전부 없애면서(4턴→0턴), 자막이 오디오와 나란히 올 때는 지연을 **전혀** 만들지
/// 않는다(실측 문장 간격 360~720ms). 800ms 이상은 자막이 나란한 경우까지 표정을
/// 3초 넘게 끌어 지난 문장의 표정이 다음 문장에 남는다.
class SentenceEmotion {
  SentenceEmotion({this.minHold = kDefaultMinHold});

  /// 계측으로 고른 기본 유지 시간. 위 주석의 근거를 읽지 않고 바꾸지 마라.
  static const Duration kDefaultMinHold = Duration(milliseconds: 400);

  /// 표정 하나가 화면에 최소한 머무는 시간.
  final Duration minHold;

  /// 아직 문장이 안 끝난 조각. 표정 분류의 입력 단위를 문장으로 만들기 위한 버퍼.
  String _pending = '';

  int _current = 0;
  DateTime? _changedAt;
  int? _deferred;

  /// 현재 표정 코드.
  int get value => _current;

  /// 유지 시간에 걸려 대기 중인 코드(없으면 null). 테스트·랩 관찰용.
  int? get deferred => _deferred;

  /// 새 턴 — 버퍼와 표정을 중립으로 되돌린다. 직전 턴의 미완 조각이 다음 턴 첫
  /// 문장에 섞이면 엉뚱한 표정이 나온다.
  void reset({DateTime? now}) {
    _pending = '';
    _current = 0;
    _deferred = null;
    _changedAt = null;
  }

  /// 스트리밍 델타를 먹인다. 표정이 **바뀌었으면** 새 코드를, 아니면 null.
  int? feed(String delta, {DateTime? now}) {
    _pending += delta;
    final cut = lastSentenceEnd(_pending);
    if (cut <= 0) return _release(now: now);
    final sentence = _pending.substring(0, cut);
    _pending = _pending.substring(cut);
    return _propose(classifyEmotion(sentence), now: now);
  }

  /// 시간만 흘려보내며 대기 중인 갱신을 반영한다(델타가 끊긴 사이 호출).
  int? tick({DateTime? now}) => _release(now: now);

  int? _propose(int code, {DateTime? now}) {
    if (code == _current) {
      _deferred = null;
      return null;
    }
    final t = now ?? DateTime.now();
    final since = _changedAt;
    if (since != null && t.difference(since) < minHold) {
      _deferred = code; // 유지 시간 중 — 미뤘다가 반영한다.
      return null;
    }
    return _apply(code, t);
  }

  int? _release({DateTime? now}) {
    final code = _deferred;
    if (code == null) return null;
    final t = now ?? DateTime.now();
    final since = _changedAt;
    if (since != null && t.difference(since) < minHold) return null;
    _deferred = null;
    if (code == _current) return null;
    return _apply(code, t);
  }

  int? _apply(int code, DateTime t) {
    _current = code;
    _changedAt = t;
    _deferred = null;
    return code;
  }
}
