import '../../domain/entities/sound_lesson.dart';
import '../../domain/entities/sound_result.dart';
import '../../domain/entities/weak_sound_item.dart';

/// `/pronunciation/weak-sounds*` 응답 → 도메인 엔티티 변환(수기 파싱 — 프로젝트 컨벤션).
///
/// 방어 규칙 두 가지를 전 파서에 적용한다.
/// 1. **점수 0 과 null 을 섞지 않는다.** `score` 가 없으면 「표본 없음」이고 0점이 아니다.
/// 2. 리스트 필드는 없으면 빈 리스트다 — null 로 두고 화면에서 또 가르지 않는다.
class WeakSoundListDto {
  const WeakSoundListDto(this.value);

  final WeakSoundList value;

  static WeakSoundList parse(Map<String, dynamic> json) {
    final national = json['national'] as Map<String, dynamic>? ?? const {};
    return WeakSoundList(
      national: NationalWeakSounds(
        country: national['country'] as String?,
        items: _items(national['items']),
      ),
      mine: _items(json['mine']),
      recommended: json['recommended'] as String?,
    );
  }

  static List<WeakSoundItem> _items(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final e in raw)
        if (e is Map<String, dynamic>) _item(e),
    ];
  }

  static WeakSoundItem _item(Map<String, dynamic> j) => WeakSoundItem(
        soundKey: j['sound_key'] as String? ?? '',
        label: j['label'] as String? ?? '',
        cardDesc: j['card_desc'] as String? ?? '',
        type: j['type'] as String? ?? 'sound',
        score: _int(j['score']),
        learned: j['learned'] as bool? ?? false,
        baselineScore: _int(j['baseline_score']),
        attempts: _int(j['attempts']) ?? 0,
        share: _int(j['share']),
      );
}

/// 4단계 콘텐츠 파서.
///
/// 콘텐츠 본문은 서버가 `payload` 안에 **마스터 JSON 그대로** 담아 보낸다. 그래서 이
/// 파서가 payload 를 한 겹 더 들어간다 — 서버에서 펼쳐 주면 계약이 넓어지고, 콘텐츠를
/// 고칠 때마다 서버 DTO 도 같이 고쳐야 한다.
class SoundLessonDto {
  static SoundLesson parse(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>? ?? const {};
    return SoundLesson(
      soundKey: json['sound_key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: json['type'] as String? ?? 'sound',
      cardDesc: json['card_desc'] as String? ?? '',
      jamo: json['jamo'] as String?,
      position: json['position'] as String?,
      score: _int(json['score']),
      learned: json['learned'] as bool? ?? false,
      symbol: payload['symbol'] as String?,
      repSyllable: payload['rep_syllable'] as String?,
      // 미리 구운 음성. 서버가 안 주면(구 서버·미생성) 빈 map → 온디맨드 합성으로 떨어진다.
      audio: {
        for (final e in (json['audio'] as Map? ?? const {}).entries)
          if (e.key is String && e.value is String)
            e.key as String: e.value as String,
      },
      howTo: [
        for (final e in (payload['how_to'] as List? ?? const []))
          if (e is String) e,
      ],
      formula: [
        for (final e in (payload['formula'] as List? ?? const []))
          if (e is Map<String, dynamic>)
            SoundFormula(
              spelling: e['spelling'] as String? ?? '',
              pronunciation: e['pronunciation'] as String? ?? '',
            ),
      ],
      words: [
        for (final e in (payload['words'] as List? ?? const []))
          if (e is Map<String, dynamic>)
            SoundWord(
              text: e['text'] as String? ?? '',
              pronunciation: e['pronunciation'] as String?,
              meaningEn: e['meaning_en'] as String?,
            ),
      ],
      sentence: _sentence(payload['sentence']),
      test: _sentence(payload['test']),
    );
  }

  static SoundSentence _sentence(Object? raw) {
    if (raw is! Map<String, dynamic>) return const SoundSentence(text: '');
    return SoundSentence(
      text: raw['text'] as String? ?? '',
      pronunciation: raw['pronunciation'] as String?,
      translationEn: raw['translation_en'] as String?,
      chunks: [
        for (final e in (raw['chunks'] as List? ?? const []))
          if (e is String) e,
      ],
    );
  }
}

/// 평가 채점 결과 파서.
class SoundResultDto {
  static SoundResult parse(Map<String, dynamic> j) => SoundResult(
        soundKey: j['sound_key'] as String? ?? '',
        label: j['label'] as String? ?? '',
        before: _int(j['before']),
        after: _int(j['after']) ?? 0,
        delta: _int(j['delta']),
        bestScore: _int(j['best_score']) ?? 0,
        attempts: _int(j['attempts']) ?? 0,
        text: j['text'] as String? ?? '',
        charScores: [
          for (final e in (j['char_scores'] as List? ?? const []))
            if (e is Map<String, dynamic>)
              SoundCharScore(
                char: e['char'] as String? ?? '',
                score: _int(e['score']) ?? 0,
                grade: e['grade'] as String? ?? '중',
              ),
        ],
        phonemeMisses: [
          for (final e in (j['phoneme_misses'] as List? ?? const []))
            if (e is Map<String, dynamic>)
              SoundPhonemeMiss(
                charIndex: _int(e['char_index']) ?? 0,
                expected: e['expected'] as String? ?? '',
              ),
        ],
      );
}

/// 숫자 필드 방어 — 서버가 소수(예: 55.0)로 줄 수 있고, null 은 null 로 남긴다.
int? _int(Object? v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.round();
  if (v is String) return int.tryParse(v);
  return null;
}
