/// 취약 발음 목록 카드 1장.
///
/// 점수의 출처가 둘이다 — [learned] 가 true 면 학습(평가 단계)으로 낸 점수고, false 면
/// 통화 복습에서 저절로 나온 집계값이다. 결과 화면의 「학습 전」 막대는 [baselineScore]
/// 를 쓴다. [score] 가 null 이면 표본이 아직 없다는 뜻이다(0점이 아니다).
class WeakSoundItem {
  const WeakSoundItem({
    required this.soundKey,
    required this.label,
    required this.cardDesc,
    required this.type,
    this.score,
    this.learned = false,
    this.baselineScore,
    this.attempts = 0,
    this.share,
  });

  /// `onset_ㄱ` · `coda_ㄹ` · `rule_연음`. 학습 진입·점수 갱신의 식별자.
  final String soundKey;

  /// 표시 라벨 — 「받침 ㄹ」 · 「연음」.
  final String label;

  /// 카드 한 줄 설명. **소리 내는 법**이다(오류 서술이 아니다).
  final String cardDesc;

  /// `sound`(자모 소리) | `rule`(음운 규칙). 규칙은 조음 도해가 없다.
  final String type;

  /// 0~100. null 이면 아직 표본이 없다.
  final int? score;

  /// 학습으로 낸 점수인가(false = 복습 집계).
  final bool learned;

  /// 첫 학습 직전 점수. 미학습이면 null.
  final int? baselineScore;

  /// 평가 제출 누적 횟수.
  final int attempts;

  /// 국적별 목록에서만 채워진다 — 그 나라 화자 중 이 소리를 틀리는 비율 %.
  final int? share;

  /// 규칙 항목인가. 도해 대신 변환 도식을 그린다.
  bool get isRule => type == 'rule';

  /// 자모와 받침 여부 — 조음 도해 조회용(`diagramForJamo`).
  ///
  /// `sound_key` 를 그대로 쪼갠다. 서버가 주는 `diagram` 문자열을 쓰지 않는 이유는
  /// 자산 이름을 레포 둘에 걸쳐 맞추는 결합을 만들지 않기 위해서다.
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

/// 국적별 섹션. 억양 국가가 없거나 통계에 없는 나라면 [items] 가 빈 리스트다.
class NationalWeakSounds {
  const NationalWeakSounds({this.country, this.items = const []});

  final String? country;
  final List<WeakSoundItem> items;
}

/// 목록 화면 전체.
class WeakSoundList {
  const WeakSoundList({
    required this.national,
    required this.mine,
    this.recommended,
  });

  final NationalWeakSounds national;
  final List<WeakSoundItem> mine;

  /// 「먼저 해보세요」 배지를 붙일 `sound_key`. 없으면 null.
  final String? recommended;
}
