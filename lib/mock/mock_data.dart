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

/// Selectable user/native language options.
///
/// Source: Notion "05_Localization" — the canonical supported-language table
/// (한국어 대상 / Native / BCP 47 / ISO 639-1/3 / 국기 코드). Each entry is
/// `MockLanguage(BCP47 id, native endonym, ISO 3166-1 alpha-2 flag code)`.
/// Korean/English are surfaced first; the rest follow the doc order. Korean
/// stays the fixed LEARNING target elsewhere — these are the user's own
/// native-language choices.
/// NOTE: flag subdivisions in the doc (ES-CT, GB-WLS) are normalized to their
/// base country (ES, GB) because `country_flags` renders ISO alpha-2 only.
/// `id` is BCP 47 (Korean hyphenated `ko-KR`); confirm the backend accepts it.
const mockLanguages = <MockLanguage>[
  MockLanguage('ko-KR', '한국어', 'KR'),
  MockLanguage('en', 'English', 'US'),
  MockLanguage('af', 'Afrikaans', 'ZA'),
  MockLanguage('ak', 'Akan', 'GH'),
  MockLanguage('sq', 'Shqip', 'AL'),
  MockLanguage('am', 'አማርኛ', 'ET'),
  MockLanguage('ar', 'العربية', 'SA'),
  MockLanguage('hy', 'Հայերեն', 'AM'),
  MockLanguage('as', 'অসমীয়া', 'IN'),
  MockLanguage('az', 'Azərbaycan dili', 'AZ'),
  MockLanguage('eu', 'Euskara', 'ES'),
  MockLanguage('be', 'Беларуская', 'BY'),
  MockLanguage('bn', 'বাংলা', 'BD'),
  MockLanguage('bs', 'Bosanski', 'BA'),
  MockLanguage('bg', 'Български', 'BG'),
  MockLanguage('my', 'မြန်မာ', 'MM'),
  MockLanguage('ca', 'Català', 'ES'),
  MockLanguage('ceb', 'Cebuano', 'PH'),
  MockLanguage('zh', '中文', 'CN'),
  MockLanguage('hr', 'Hrvatski', 'HR'),
  MockLanguage('cs', 'Čeština', 'CZ'),
  MockLanguage('da', 'Dansk', 'DK'),
  MockLanguage('nl', 'Nederlands', 'NL'),
  MockLanguage('et', 'Eesti', 'EE'),
  MockLanguage('fo', 'Føroyskt', 'FO'),
  MockLanguage('fil', 'Filipino', 'PH'),
  MockLanguage('fi', 'Suomi', 'FI'),
  MockLanguage('fr', 'Français', 'FR'),
  MockLanguage('gl', 'Galego', 'ES'),
  MockLanguage('ka', 'ქართული', 'GE'),
  MockLanguage('de', 'Deutsch', 'DE'),
  MockLanguage('el', 'Ελληνικά', 'GR'),
  MockLanguage('gu', 'ગુજરાતી', 'IN'),
  MockLanguage('ha', 'Hausa', 'NG'),
  MockLanguage('he', 'עברית', 'IL'),
  MockLanguage('hi', 'हिन्दी', 'IN'),
  MockLanguage('hu', 'Magyar', 'HU'),
  MockLanguage('is', 'Íslenska', 'IS'),
  MockLanguage('id', 'Bahasa Indonesia', 'ID'),
  MockLanguage('ga', 'Gaeilge', 'IE'),
  MockLanguage('it', 'Italiano', 'IT'),
  MockLanguage('ja', '日本語', 'JP'),
  MockLanguage('kn', 'ಕನ್ನಡ', 'IN'),
  MockLanguage('kk', 'Қазақ тілі', 'KZ'),
  MockLanguage('km', 'ខ្មែរ', 'KH'),
  MockLanguage('rw', 'Kinyarwanda', 'RW'),
  MockLanguage('ku', 'Kurdî', 'TR'),
  MockLanguage('ky', 'Кыргызча', 'KG'),
  MockLanguage('lo', 'ລາວ', 'LA'),
  MockLanguage('lv', 'Latviešu', 'LV'),
  MockLanguage('lt', 'Lietuvių', 'LT'),
  MockLanguage('mk', 'Македонски', 'MK'),
  MockLanguage('ms', 'Bahasa Melayu', 'MY'),
  MockLanguage('ml', 'മലയാളം', 'IN'),
  MockLanguage('mt', 'Malti', 'MT'),
  MockLanguage('mi', 'Te Reo Māori', 'NZ'),
  MockLanguage('mr', 'मराठी', 'IN'),
  MockLanguage('mn', 'Монгол', 'MN'),
  MockLanguage('ne', 'नेपाली', 'NP'),
  MockLanguage('no', 'Norsk', 'NO'),
  MockLanguage('or', 'ଓଡ଼ିଆ', 'IN'),
  MockLanguage('om', 'Afaan Oromoo', 'ET'),
  MockLanguage('ps', 'پښتو', 'AF'),
  MockLanguage('fa', 'فارسی', 'IR'),
  MockLanguage('pl', 'Polski', 'PL'),
  MockLanguage('pt', 'Português', 'PT'),
  MockLanguage('pa', 'ਪੰਜਾਬੀ', 'IN'),
  MockLanguage('qu', 'Runa Simi', 'PE'),
  MockLanguage('ro', 'Română', 'RO'),
  MockLanguage('rm', 'Rumantsch', 'CH'),
  MockLanguage('ru', 'Русский', 'RU'),
  MockLanguage('sr', 'Српски', 'RS'),
  MockLanguage('sd', 'سنڌي', 'PK'),
  MockLanguage('si', 'සිංහල', 'LK'),
  MockLanguage('sk', 'Slovenčina', 'SK'),
  MockLanguage('sl', 'Slovenščina', 'SI'),
  MockLanguage('so', 'Soomaali', 'SO'),
  MockLanguage('st', 'Sesotho', 'LS'),
  MockLanguage('es', 'Español', 'ES'),
  MockLanguage('sw', 'Kiswahili', 'TZ'),
  MockLanguage('sv', 'Svenska', 'SE'),
  MockLanguage('tg', 'Тоҷикӣ', 'TJ'),
  MockLanguage('ta', 'தமிழ்', 'IN'),
  MockLanguage('te', 'తెలుగు', 'IN'),
  MockLanguage('th', 'ไทย', 'TH'),
  MockLanguage('tn', 'Setswana', 'BW'),
  MockLanguage('tr', 'Türkçe', 'TR'),
  MockLanguage('tk', 'Türkmen', 'TM'),
  MockLanguage('uk', 'Українська', 'UA'),
  MockLanguage('ur', 'اردو', 'PK'),
  MockLanguage('uz', 'Oʻzbek', 'UZ'),
  MockLanguage('vi', 'Tiếng Việt', 'VN'),
  MockLanguage('cy', 'Cymraeg', 'GB'),
  MockLanguage('fy', 'Frysk', 'NL'),
  MockLanguage('wo', 'Wolof', 'SN'),
  MockLanguage('yo', 'Yorùbá', 'NG'),
  MockLanguage('zu', 'isiZulu', 'ZA'),
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
