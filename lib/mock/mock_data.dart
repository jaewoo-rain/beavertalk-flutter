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

/// Selectable user/native language + nationality options.
///
/// Source: Notion "04_사용가능한_언어코드_확인" (easy_localization-supported set,
/// 24 languages) — BCP 47 code + native endonym + flag country code (BCP 47
/// region). Korean/English are surfaced first; the rest keep the doc order.
/// Korean stays the fixed LEARNING target elsewhere — these are the user's own
/// native-language choices.
/// NOTE: `id` is now BCP 47 (was short ISO 639-1); confirm the backend accepts
/// the hyphenated form on signup (coordination point).
const mockLanguages = <MockLanguage>[
  MockLanguage('ko-KR', '한국어', 'KR'),
  MockLanguage('en-US', 'English (US)', 'US'),
  MockLanguage('en-IN', 'English (India)', 'IN'),
  MockLanguage('ar-EG', 'العربية (مصر)', 'EG'),
  MockLanguage('bn-BD', 'বাংলা (বাংলাদেশ)', 'BD'),
  MockLanguage('nl-NL', 'Nederlands', 'NL'),
  MockLanguage('hi-IN', 'हिन्दी', 'IN'),
  MockLanguage('fr-FR', 'Français', 'FR'),
  MockLanguage('de-DE', 'Deutsch', 'DE'),
  MockLanguage('id-ID', 'Bahasa Indonesia', 'ID'),
  MockLanguage('it-IT', 'Italiano', 'IT'),
  MockLanguage('ja-JP', '日本語', 'JP'),
  MockLanguage('mr-IN', 'मराठी', 'IN'),
  MockLanguage('pl-PL', 'Polski', 'PL'),
  MockLanguage('pt-BR', 'Português (Brasil)', 'BR'),
  MockLanguage('ro-RO', 'Română', 'RO'),
  MockLanguage('ru-RU', 'Русский', 'RU'),
  MockLanguage('es-US', 'Español (EE. UU.)', 'US'),
  MockLanguage('ta-IN', 'தமிழ்', 'IN'),
  MockLanguage('te-IN', 'తెలుగు', 'IN'),
  MockLanguage('th-TH', 'ภาษาไทย', 'TH'),
  MockLanguage('tr-TR', 'Türkçe', 'TR'),
  MockLanguage('uk-UA', 'Українська', 'UA'),
  MockLanguage('vi-VN', 'Tiếng Việt', 'VN'),
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
    ValueNotifier<Set<int>>({1});

/// Toggles [id] in [bookmarkedSentenceIds], notifying listeners.
void toggleBookmark(int id) {
  final next = {...bookmarkedSentenceIds.value};
  if (!next.remove(id)) next.add(id);
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
