/// 아바타 클립을 가리키는 **코드와 경로**만 담는다. 렌더러는 여기 없다.
///
/// 그리는 쪽은 `sync_avatar.dart`(영상)다. 예전에는 이 파일에 스프라이트 립싱크
/// 렌더러 `BeaverAvatar` 가 함께 있었고 파일 이름도 `avatar_view.dart` 였다.
///
/// ⛔ **스프라이트 렌더러를 되살리지 마라**(2026-08-31 삭제, 사용자 결정).
///    영상 방식이 그것을 대체했고, 지워질 때 **호출부가 0곳**이었다 — lib·test
///    어디에도 `BeaverAvatar(` 가 없었고 「아바타 영상 끄기」 토글의 폴백조차
///    스프라이트가 아니라 파트너 정적 이미지였다. 그런데도 캐릭터당 png 29~31장,
///    **합계 147장 · 53.2MB** 가 앱에 실려 나가고 있었다(전체 자산 121MB 중 44%).
///    되살리려면 자산부터 다시 만들어야 한다 — git 이력에 코드가 남아 있다.
library;

/// Emotion codes shared by the controller (transcript classifier) and the
/// video renderer. 0 = neutral/smug (the resting face).
const int kEmotionNeutral = 0;
const int kEmotionHappy = 1;
const int kEmotionSurprised = 2;
const int kEmotionSad = 3;
const int kEmotionAngry = 4;

/// ⭐ **박장대소** — `happy`(미소·칭찬)와 다른 축이다.
/// 재밌어서 크게 터지거나, 면박 주며 웃어젖힐 때(트래시토커 페르소나).
/// ⚠ 자산은 2026-08-09 의 11종 세트에 **처음부터 있었는데** 배선이 안 돼 있었다
///   (5캐릭터 전부 `laugh.mp4`, 3.5MB 가 안 쓰이고 실려 나가던 상태).
const int kEmotionLaugh = 5;

/// ⭐ **학습 반응 전용 2종** — 통화용 `emo_*` 와 **다른 자산**이다.
///
/// 통화용은 「말하면서 감정」으로 만들어져 입이 움직인다. 학습 반응 밴드는 무발화
/// 구간이라 입이 움직이면 말하는 것처럼 보인다. 그래서 표정·몸짓만 쓰는 `react_*`
/// 4종을 따로 만들었고(2026-08-30), 그중 정답·오답 두 자리에 이 둘을 쓴다.
///
/// ⛔ `emo_*` 로 이름을 통일하지 마라 — 같은 폴더에 공존하는 다른 자산이라
///    통화용을 덮어쓴다. 강도도 낮추지 마라(절제판은 감동이 그냥 미소로 읽혔다).
const int kEmotionExciting = 6; // 정답 — `react_exciting.mp4`
const int kEmotionCrying = 7; // 오답 — `react_crying.mp4`

/// 비버가 말하지 않는 동안의 대기 상태. `idle` **슬롯 하나**에서 갈아끼운다.
///
/// ★왜 나뉘었나 — 이전에는 「사용자가 말하는 중」과 「아무도 말 안 함」이 같은
/// `idle` 이었다. 상대가 내 말에 아무 반응이 없으면 듣고 있는지 의심하게 된다.
/// ⛔ 세 클립을 동시에 열어 두지 마라 — 하드 디코더가 2~3개 한계이고
///    idle + talk + 감정으로 이미 셋이다(2026-08-02 S8 실측).
const int kIdleWait = 0; // 아무도 말하지 않음 — `idle.mp4`
const int kIdleListen = 1; // 사용자가 말하는 중 — `idle_listen.mp4`(끄덕임)
const int kIdleThink = 2; // 응답을 기다리는 중 — `idle_think.mp4`(생각)

/// 캐릭터의 아바타 **클립 폴더**를 돌려준다. 클립 세트가 없으면 null 이고,
/// 호출부는 정적 이미지로 폴백한다.
///
/// `assets/avatar/<key>/` 아래에 클립 세트가 있는 캐릭터만 여기 적혀 있다 —
/// 새 캐릭터가 나오면 키를 추가한다.
String? avatarAssetDirFor(int? characterId, String? name) {
  // ⭐ **이름으로 매핑한다. id 는 쓰지 않는다.**
  //
  // 옛 코드는 `characterId` 를 1순위로 썼는데, 서버의 캐릭터 id 가 **환경마다 다르다**:
  //     prod: 1 BABA · 2 BIBI ·  9 Popo · 10 Rara · 11 Dudu
  //     dev : 1 BABA · 2 BIBI ·  3 Popo ·  4 Rara ·  5 Dudu
  // prod 기준으로 하드코딩하면 dev 에서 Popo 가 Rara 영상을 연다. 서버에 캐릭터가
  // 추가·재배치돼도 앱이 조용히 틀린 얼굴을 고른다.
  //
  // 이름은 그 캐릭터의 정체성이라 환경이 바뀌어도 안 흔들린다. 서버 IAP 상품 매핑도
  // 같은 이유로 id 대신 이름으로 조회한다(iap_catalog.resolve).
  //
  // 서버 표기가 'BABA'/'Baba' 로 섞여 있어 **대소문자 무시**로 맞춘다. 한국어 표기는
  // CallKit·알람 페이로드가 현지화된 이름을 실어 보낼 때를 위한 보조.
  const byName = <String, String>{
    'baba': 'baba', '바바': 'baba',
    'bibi': 'bibi', '비비': 'bibi',
    'popo': 'popo', '포포': 'popo',
    'rara': 'rara', '라라': 'rara',
    'dudu': 'dudu', '두두': 'dudu',
  };

  final n = (name ?? '').trim().toLowerCase();
  if (n.isEmpty) return null;   // 이름을 모르면 정적 이미지 폴백(틀린 얼굴보다 낫다)

  // 정확히 일치 먼저 — 부분 일치는 다른 이름을 잘못 삼킬 수 있다.
  final exact = byName[n];
  if (exact != null) return 'assets/avatar/$exact';

  // "비비 선생님" 처럼 수식어가 붙은 경우를 위한 부분 일치.
  for (final e in byName.entries) {
    if (n.contains(e.key)) return 'assets/avatar/${e.value}';
  }
  return null;
}
