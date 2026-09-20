/// 취약 발음 학습 1과 — 4단계 콘텐츠 전량.
///
/// 서버가 **한 번에** 내려준다. 단계마다 왕복하면 단어→단어 자동진행에 네트워크 지연이
/// 끼어들어 흐름이 끊긴다.
///
/// 소리 항목(`type == 'sound'`)과 규칙 항목(`rule`)이 같은 클래스를 쓴다. 규칙만 가진
/// 것은 [formula]·[symbol] 이고, 규칙의 단어·문장은 [SoundWord.pronunciation] 처럼
/// 발음 표기를 더 들고 있다.
class SoundLesson {
  const SoundLesson({
    required this.soundKey,
    required this.label,
    required this.type,
    required this.cardDesc,
    required this.howTo,
    required this.words,
    required this.sentence,
    required this.test,
    this.jamo,
    this.position,
    this.symbol,
    this.formula = const [],
    this.repSyllable,
    this.score,
    this.learned = false,
  });

  final String soundKey;
  final String label;

  /// `sound` | `rule`.
  final String type;
  final String cardDesc;

  /// 소리 내는 법 3줄(이해 단계).
  final List<String> howTo;

  /// 연습 단어 4개.
  final List<SoundWord> words;

  /// 연습 문장 1개(조각 포함).
  final SoundSentence sentence;

  /// 평가 문장 1개. 채점은 서버가 이 문장으로 한다.
  final SoundSentence test;

  /// 자모 1자(소리 항목만).
  final String? jamo;

  /// `onset` | `coda`(소리 항목만).
  final String? position;

  /// 규칙 기호(규칙 항목만) — 도해 자리에 들어간다.
  final String? symbol;

  /// 「글자 → 소리」 변환 도식(규칙 항목만).
  final List<SoundFormula> formula;

  /// 대표 음절(예: 「가」). 이해 화면의 큰 글자.
  final String? repSyllable;

  /// 현재 점수 0~100. null 이면 표본 없음.
  final int? score;

  /// 점수가 학습으로 나온 것인가(false = 복습 집계).
  final bool learned;

  bool get isRule => type == 'rule';

  /// 조음 도해 조회용 — 규칙이면 null.
  ///
  /// `position` 문자열을 믿지 않고 [soundKey] 를 쪼갠다. 서버 소스(`lessons.json`)는
  /// `onset`/`coda` 를 쓰지만 표기가 갈릴 여지가 있고, `sound_key` 는 집계·점수와 공유하는
  /// 단일 식별자라 더 단단하다.
  ({String jamo, bool isCoda})? get jamoTarget {
    if (soundKey.startsWith('onset_')) {
      return (jamo: soundKey.substring(6), isCoda: false);
    }
    if (soundKey.startsWith('coda_')) {
      return (jamo: soundKey.substring(5), isCoda: true);
    }
    return null;
  }
}

/// 연습 단어 1개.
class SoundWord {
  const SoundWord({required this.text, this.pronunciation, this.meaningEn});

  final String text;

  /// 규칙 항목의 `[발음]` 줄. 소리 항목은 null.
  final String? pronunciation;
  final String? meaningEn;
}

/// 연습·평가 문장 1개.
class SoundSentence {
  const SoundSentence({
    required this.text,
    this.pronunciation,
    this.translationEn,
    this.chunks = const [],
  });

  final String text;

  /// 규칙 항목의 `[발음]` 줄. 소리 항목은 null.
  final String? pronunciation;
  final String? translationEn;

  /// 끝에서부터 쌓는 조각 — 조각마다 목표 소리가 들어 있다. 평가 문장은 비어 있다.
  final List<String> chunks;
}

/// 「글자 → 소리」 변환 도식 1줄.
class SoundFormula {
  const SoundFormula({required this.spelling, required this.pronunciation});

  final String spelling;
  final String pronunciation;
}
