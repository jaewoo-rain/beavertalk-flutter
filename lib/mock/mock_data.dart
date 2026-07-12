import 'package:flutter/widgets.dart';

/// In-memory mock data for the design_app screens (no backend). Mirrors the
/// shapes the FastAPI/SpeechSuper contract would return, so screens can later
/// swap mock → real with minimal change.

const beaverImage = AssetImage('assets/images/beaver.png');
const judiImage = AssetImage('assets/images/judi.png');

/// Onboarding — native language / nationality options.
///
/// [id] is the **BCP 47** locale code stored in the signup draft / backend
/// (hyphenated, e.g. 'en-US', 'ko-KR' — per the team's "사용 가능한 언어코드"
/// spec). [name] is the language's native endonym. [countryCode] is the ISO
/// 3166-1 alpha-2 code used to render an SVG flag via
/// `CountryFlag.fromCountryCode` (reliable on every platform, unlike emoji
/// regional-indicator glyphs which fall back to letter pairs on Windows and
/// many Android devices).
class MockLanguage {
  const MockLanguage(this.id, this.name, this.countryCode);

  /// BCP 47 locale code (hyphenated), e.g. 'en-US'.
  final String id;

  /// Native endonym shown in the picker, e.g. '日本語'.
  final String name;

  /// ISO 3166-1 alpha-2 country code for the flag (e.g. 'US', 'KR').
  final String countryCode;
}

/// Selectable user/native language options — **app-supported languages only**.
///
/// Source: `한국어학습자_K팝팬_국가별_통합.xlsx` → sheet `앱_지원언어(필터)`. The
/// earlier 95-language Notion "05_Localization" list is filtered down to the
/// **primary/official language of each of the 38 target-market countries**
/// (Korean learners + K-pop fans, all measured figures): 29 market languages +
/// Korean (app default) = **30**. Ordered by the workbook's combined market rank.
/// Each entry is `MockLanguage(BCP47 id, native endonym, ISO 3166-1 alpha-2 flag
/// code)`. Korean stays the fixed LEARNING target elsewhere — these are the
/// user's own native-language choices.
/// `id` is BCP 47 (Korean hyphenated `ko-KR`); confirm the backend accepts it.
const mockLanguages = <MockLanguage>[
  // 한국어(앱 기본·학습 대상)·영어(공용)를 맨 위 고정, 나머지는 한국어명 가나다순.
  MockLanguage('ko-KR', '한국어', 'KR'),
  MockLanguage('en', 'English', 'US'),
  MockLanguage('ne', 'नेपाली', 'NP'),
  MockLanguage('de', 'Deutsch', 'DE'),
  MockLanguage('ru', 'Русский', 'RU'),
  MockLanguage('ms', 'Bahasa Melayu', 'MY'),
  MockLanguage('mn', 'Монгол', 'MN'),
  MockLanguage('my', 'မြန်မာ', 'MM'),
  MockLanguage('vi', 'Tiếng Việt', 'VN'),
  MockLanguage('bn', 'বাংলা', 'BD'),
  MockLanguage('es', 'Español', 'ES'),
  MockLanguage('si', 'සිංහල', 'LK'),
  MockLanguage('ar', 'العربية', 'SA'),
  MockLanguage('ur', 'اردو', 'PK'),
  MockLanguage('uz', 'Oʻzbek', 'UZ'),
  MockLanguage('it', 'Italiano', 'IT'),
  MockLanguage('id', 'Bahasa Indonesia', 'ID'),
  MockLanguage('ja', '日本語', 'JP'),
  MockLanguage('zh', '中文', 'CN'),
  MockLanguage('kk', 'Қазақ тілі', 'KZ'),
  MockLanguage('km', 'ខ្មែរ', 'KH'),
  MockLanguage('ky', 'Кыргызча', 'KG'),
  MockLanguage('th', 'ไทย', 'TH'),
  MockLanguage('tr', 'Türkçe', 'TR'),
  MockLanguage('pt', 'Português', 'PT'),
  MockLanguage('fr', 'Français', 'FR'),
  MockLanguage('fi', 'Suomi', 'FI'),
  MockLanguage('fil', 'Filipino', 'PH'),
  MockLanguage('hu', 'Magyar', 'HU'),
  MockLanguage('hi', 'हिन्दी', 'IN'),
];

/// Onboarding — learning reasons (Figma copy).
class MockReason {
  const MockReason(this.id, this.icon, this.title, this.description);
  final String id;
  final String icon;
  final String title;
  final String description;
}

const mockReasons = <MockReason>[
  MockReason('travel', '✈️', '여행에서 말하기', '현지에서 자신있게 대화하기'),
  MockReason('career', '💼', '업무·커리어', '비즈니스 회화'),
  MockReason('exam', '📝', '시험 대비', '스피킹 시험 준비'),
  MockReason('daily', '💬', '일상 회화 자신감', '매일 쓰는 표현'),
  MockReason('friends', '🌏', '외국인 친구 사귀기', '자연스러운 대화'),
  MockReason('brain', '🧠', '두뇌 자극', '기억력·집중력 향상'),
];

/// A scored character (글자별 상/중/하), mirrors SpeechSuper char_scores.
class MockCharScore {
  const MockCharScore(this.char, this.score);
  final String char;
  final int score; // 0~100
}

/// A learned sentence + its review scoring (mirrors ReviewFeedback / Sentence).
class MockSentence {
  const MockSentence({
    required this.id,
    required this.korean,
    required this.native,
    required this.charScores,
    required this.overall,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
    this.bookmarked = false,
    this.voiceUrl,
  });

  final int id;
  final String korean;
  final String native;
  final List<MockCharScore> charScores;
  final int overall;
  final int pronunciation;
  final int fluency;
  final int rhythm;
  final bool bookmarked;

  /// Standard (native) pronunciation audio URL for this sentence, when the
  /// server provides one. Null until the backend exposes per-sentence audio;
  /// the learning_intro speaker plays it when present, else shows a message.
  final String? voiceUrl;
}

/// IDs of sentences the user has bookmarked (즐겨찾기). Mutable in-memory store
/// shared across screens: the analysis/대화기록 detail toggles entries here, and
/// the 보관 (archive) tab lists the matching sentences. A [ValueNotifier] so
/// screens can rebuild reactively via [ValueListenableBuilder].
final ValueNotifier<Set<int>> bookmarkedSentenceIds =
    ValueNotifier<Set<int>>(<int>{});

/// Toggles [id] in [bookmarkedSentenceIds], notifying listeners.
void toggleBookmark(int id) {
  final next = {...bookmarkedSentenceIds.value};
  if (!next.remove(id)) next.add(id);
  bookmarkedSentenceIds.value = next;
}

/// Sets [id]'s bookmark state to [saved] (idempotent). Use this to reconcile the
/// in-memory store with server truth (add when saved, remove when not) — unlike
/// [toggleBookmark], seeding must be able to clear a stale `true`, otherwise the
/// store permanently diverges from the server.
void setBookmark(int id, bool saved) {
  final has = bookmarkedSentenceIds.value.contains(id);
  if (has == saved) return;
  final next = {...bookmarkedSentenceIds.value};
  if (saved) {
    next.add(id);
  } else {
    next.remove(id);
  }
  bookmarkedSentenceIds.value = next;
}

/// The conversation partner / avatar.
///
/// Legacy fixed label — prefer [characterName]/[characterImage] keyed by the
/// member's `characterId` so calls show the avatar the user actually selected.
const mockPartnerName = 'Annoying Beaver';

/// Display name for a selected character [id] (member `character_id`).
/// `1` → Bibi (비비), `2` → Baba (바바); unknown/null falls back to Bibi, which
/// is the app's default character (see `home.dart`). The server is the source of
/// truth for alarm-triggered calls (`AlarmDto.characterName`); this maps the
/// profile's id for manual calls and fallbacks.
String characterName(int? id) => id == 2 ? 'Baba' : 'Bibi';

/// Avatar image for a selected character [id], paired with [characterName].
ImageProvider characterImage(int? id) => id == 2 ? beaverImage : judiImage;

/// "새로 배운 표현" used in the analysis + learning flow.
const mockSentences = <MockSentence>[
  MockSentence(
    id: 1,
    korean: '이 식당은 맛있는 음식을 팔아',
    native: 'This restaurant serves great food',
    overall: 97, pronunciation: 96, fluency: 91, rhythm: 91,
    charScores: [
      MockCharScore('이', 100), MockCharScore('식', 96), MockCharScore('당', 92),
      MockCharScore('은', 88), MockCharScore('맛', 72), MockCharScore('있', 80),
      MockCharScore('는', 90), MockCharScore('음', 95), MockCharScore('식', 97),
      MockCharScore('을', 84), MockCharScore('팔', 65), MockCharScore('아', 70),
    ],
  ),
  MockSentence(
    id: 2,
    korean: '오늘 날씨가 정말 좋네요',
    native: 'The weather is really nice today',
    overall: 92, pronunciation: 90, fluency: 94, rhythm: 88,
    charScores: [
      MockCharScore('오', 95), MockCharScore('늘', 88), MockCharScore('날', 90),
      MockCharScore('씨', 82), MockCharScore('가', 94), MockCharScore('정', 91),
      MockCharScore('말', 96), MockCharScore('좋', 75), MockCharScore('네', 89),
      MockCharScore('요', 93),
    ],
  ),
  MockSentence(
    id: 3,
    korean: '주말에 같이 영화 볼래요?',
    native: 'Want to watch a movie together this weekend?',
    overall: 89, pronunciation: 87, fluency: 90, rhythm: 86,
    charScores: [
      MockCharScore('주', 92), MockCharScore('말', 85), MockCharScore('에', 90),
      MockCharScore('같', 78), MockCharScore('이', 88), MockCharScore('영', 91),
      MockCharScore('화', 84), MockCharScore('볼', 80), MockCharScore('래', 86),
      MockCharScore('요', 93),
    ],
  ),
];

/// Call analysis summary (mirrors CallResult).
class MockCallResult {
  const MockCallResult({
    required this.overall,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
    required this.sentences,
  });
  final int overall;
  final int pronunciation;
  final int fluency;
  final int rhythm;
  final List<MockSentence> sentences;
}

const mockCallResult = MockCallResult(
  overall: 98, pronunciation: 96, fluency: 91, rhythm: 91,
  sentences: mockSentences,
);
