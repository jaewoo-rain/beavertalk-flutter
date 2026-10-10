/// 캐릭터 성격 태그(서버 영문 원문) → UI 언어 이름. **서버 i18n 전의 임시표다.**
///
/// QA F054(09-26): 한국어 UI 아바타 화면의 태그가 전부 영어(Savage·Blunt·Tsundere …)였다.
/// 서버 카탈로그 `tags` 는 영문 한 벌이고 언어 축이 없다 — 설명·스토리와 같은 사정이라
/// [character_copy_overrides.dart] 와 같은 임시 방식을 쓴다(PM-DEC-038: 서버 요청 + 앱 임시표).
/// 서버가 태그 번역을 내려 주면 이 파일은 지운다.
///
/// - 표의 출처: 노션 「비버톡 > 아바타 모음」 정본의 태그 15개(`docs/HANDOFF.md` 캐릭터 표 —
///   Baba ♂ · Bibi ♀ · Dudu ♂ · Popo ♀ · Rara ♀). 태그가 캐릭터마다 고정이라, 성별이 있는
///   언어는 그 캐릭터 성별로 옮겼다(예: es 「Dramática」 = Bibi).
/// - 표에 없는 태그(서버가 태그를 바꾸거나 새 캐릭터)는 **영문 원문**으로 둔다 — 틀린 번역보다 낫다.
/// - ⚠ 번역 검수 전이다 — 43 다국어 검수 하네스 대상(원어민 꾸러미에 넣을 것).
/// - `en` 은 표가 없다 — 원문이 곧 영어다.
library;

/// [tag] 를 UI 언어 [languageCode] 로. 모르면 [tag] 그대로.
String localizedCharacterTag(String tag, String languageCode) =>
    _labels[languageCode]?[tag.trim().toLowerCase()] ?? tag;

/// 언어 → (소문자 태그 → 이름). 태그 순서는 캐릭터별(Baba · Bibi · Dudu · Popo · Rara).
const Map<String, Map<String, String>> _labels = {
  'ko': {
    'savage': '독설', 'blunt': '직설적', 'tsundere': '츤데레',
    'excited': '들뜸', 'sweet': '상냥함', 'dramatic': '드라마틱',
    'chill': '느긋함', 'goofy': '엉뚱함', 'easygoing': '태평함',
    'warm': '따뜻함', 'tender': '다정함', 'emotional': '감성적',
    'hyper': '하이텐션', 'cheerful': '명랑함', 'energetic': '활기참',
  },
  'ja': {
    'savage': '毒舌', 'blunt': '率直', 'tsundere': 'ツンデレ',
    'excited': 'ワクワク', 'sweet': '優しい', 'dramatic': 'ドラマチック',
    'chill': 'のんびり', 'goofy': 'おちゃめ', 'easygoing': 'マイペース',
    'warm': 'あったか', 'tender': '思いやり', 'emotional': '涙もろい',
    'hyper': 'ハイテンション', 'cheerful': '明るい', 'energetic': '元気いっぱい',
  },
  'zh': {
    'savage': '毒舌', 'blunt': '直率', 'tsundere': '傲娇',
    'excited': '兴奋', 'sweet': '甜美', 'dramatic': '戏精',
    'chill': '悠闲', 'goofy': '搞怪', 'easygoing': '随和',
    'warm': '温暖', 'tender': '温柔', 'emotional': '感性',
    'hyper': '超嗨', 'cheerful': '开朗', 'energetic': '活力满满',
  },
  'es': {
    'savage': 'Mordaz', 'blunt': 'Directo', 'tsundere': 'Tsundere',
    'excited': 'Entusiasta', 'sweet': 'Dulce', 'dramatic': 'Dramática',
    'chill': 'Relajado', 'goofy': 'Bromista', 'easygoing': 'Despreocupado',
    'warm': 'Cálida', 'tender': 'Tierna', 'emotional': 'Emotiva',
    'hyper': 'Hiperactiva', 'cheerful': 'Alegre', 'energetic': 'Enérgica',
  },
  'pt': {
    'savage': 'Mordaz', 'blunt': 'Direto', 'tsundere': 'Tsundere',
    'excited': 'Animada', 'sweet': 'Doce', 'dramatic': 'Dramática',
    'chill': 'Tranquilo', 'goofy': 'Brincalhão', 'easygoing': 'Descontraído',
    'warm': 'Calorosa', 'tender': 'Carinhosa', 'emotional': 'Emotiva',
    'hyper': 'Elétrica', 'cheerful': 'Alegre', 'energetic': 'Enérgica',
  },
  'fr': {
    'savage': 'Cinglant', 'blunt': 'Franc', 'tsundere': 'Tsundere',
    'excited': 'Surexcitée', 'sweet': 'Douce', 'dramatic': 'Théâtrale',
    'chill': 'Cool', 'goofy': 'Farceur', 'easygoing': 'Décontracté',
    'warm': 'Chaleureuse', 'tender': 'Tendre', 'emotional': 'Émotive',
    'hyper': 'Survoltée', 'cheerful': 'Joyeuse', 'energetic': 'Énergique',
  },
  'it': {
    'savage': 'Tagliente', 'blunt': 'Schietto', 'tsundere': 'Tsundere',
    'excited': 'Euforica', 'sweet': 'Dolce', 'dramatic': 'Teatrale',
    'chill': 'Rilassato', 'goofy': 'Buffo', 'easygoing': 'Alla mano',
    'warm': 'Calorosa', 'tender': 'Tenera', 'emotional': 'Emotiva',
    'hyper': 'Iperattiva', 'cheerful': 'Allegra', 'energetic': 'Energica',
  },
  'de': {
    'savage': 'Bissig', 'blunt': 'Direkt', 'tsundere': 'Tsundere',
    'excited': 'Aufgedreht', 'sweet': 'Süß', 'dramatic': 'Dramatisch',
    'chill': 'Entspannt', 'goofy': 'Albern', 'easygoing': 'Gelassen',
    'warm': 'Herzlich', 'tender': 'Zärtlich', 'emotional': 'Emotional',
    'hyper': 'Hibbelig', 'cheerful': 'Fröhlich', 'energetic': 'Energiegeladen',
  },
  'ru': {
    'savage': 'Язвительный', 'blunt': 'Прямолинейный', 'tsundere': 'Цундэрэ',
    'excited': 'Восторженная', 'sweet': 'Милая', 'dramatic': 'Драматичная',
    'chill': 'Невозмутимый', 'goofy': 'Дурашливый', 'easygoing': 'Покладистый',
    'warm': 'Тёплая', 'tender': 'Нежная', 'emotional': 'Эмоциональная',
    'hyper': 'Гиперактивная', 'cheerful': 'Жизнерадостная', 'energetic': 'Энергичная',
  },
  'kk': {
    'savage': 'Тілі ащы', 'blunt': 'Турашыл', 'tsundere': 'Цундэрэ',
    'excited': 'Қуанышты', 'sweet': 'Мейірімді', 'dramatic': 'Драмалық',
    'chill': 'Асықпайтын', 'goofy': 'Қалжыңбас', 'easygoing': 'Жайбарақат',
    'warm': 'Жылы жүзді', 'tender': 'Нәзік', 'emotional': 'Сезімтал',
    'hyper': 'Аса белсенді', 'cheerful': 'Көңілді', 'energetic': 'Жігерлі',
  },
  'ky': {
    'savage': 'Тили ачуу', 'blunt': 'Түз сүйлөгөн', 'tsundere': 'Цундэрэ',
    'excited': 'Толкунданган', 'sweet': 'Мээримдүү', 'dramatic': 'Драмалуу',
    'chill': 'Шашпаган', 'goofy': 'Тамашакөй', 'easygoing': 'Жайбаракат',
    'warm': 'Жылуу', 'tender': 'Назик', 'emotional': 'Сезимтал',
    'hyper': 'Өтө активдүү', 'cheerful': 'Шайыр', 'energetic': 'Энергиялуу',
  },
  'mn': {
    'savage': 'Хурц үгтэй', 'blunt': 'Шулуун', 'tsundere': 'Цундэрэ',
    'excited': 'Догдолсон', 'sweet': 'Эелдэг', 'dramatic': 'Драмтай',
    'chill': 'Тайван', 'goofy': 'Шоглоомтгой', 'easygoing': 'Уужуу',
    'warm': 'Дулаахан', 'tender': 'Зөөлөн', 'emotional': 'Мэдрэмжтэй',
    'hyper': 'Хэт идэвхтэй', 'cheerful': 'Хөгжилтэй', 'energetic': 'Эрч хүчтэй',
  },
  'uz': {
    'savage': 'Tili achchiq', 'blunt': 'Toʻgʻrisoʻz', 'tsundere': 'Tsundere',
    'excited': 'Hayajonli', 'sweet': 'Shirin', 'dramatic': 'Dramatik',
    'chill': 'Xotirjam', 'goofy': 'Hazilkash', 'easygoing': 'Keng feʼlli',
    'warm': 'Samimiy', 'tender': 'Mehribon', 'emotional': 'Taʼsirchan',
    'hyper': 'Juda faol', 'cheerful': 'Quvnoq', 'energetic': 'Gʻayratli',
  },
  'tr': {
    'savage': 'Sivri dilli', 'blunt': 'Dobra', 'tsundere': 'Tsundere',
    'excited': 'Heyecanlı', 'sweet': 'Tatlı', 'dramatic': 'Dramatik',
    'chill': 'Rahat', 'goofy': 'Şakacı', 'easygoing': 'Uysal',
    'warm': 'Sıcakkanlı', 'tender': 'Şefkatli', 'emotional': 'Duygusal',
    'hyper': 'Hiperaktif', 'cheerful': 'Neşeli', 'energetic': 'Enerjik',
  },
  'ar': {
    'savage': 'لاذع', 'blunt': 'صريح', 'tsundere': 'تسونديري',
    'excited': 'متحمسة', 'sweet': 'لطيفة', 'dramatic': 'درامية',
    'chill': 'مسترخٍ', 'goofy': 'ظريف', 'easygoing': 'هادئ الطبع',
    'warm': 'دافئة', 'tender': 'حنونة', 'emotional': 'عاطفية',
    'hyper': 'مفرطة النشاط', 'cheerful': 'مبتهجة', 'energetic': 'نشيطة',
  },
  'hi': {
    'savage': 'तीखी ज़बान', 'blunt': 'मुँहफट', 'tsundere': 'त्सुनदेरे',
    'excited': 'उत्साहित', 'sweet': 'प्यारी', 'dramatic': 'नाटकीय',
    'chill': 'बेफ़िक्र', 'goofy': 'मसख़रा', 'easygoing': 'सहज',
    'warm': 'स्नेही', 'tender': 'कोमल', 'emotional': 'भावुक',
    'hyper': 'बेहद चुलबुली', 'cheerful': 'खुशमिज़ाज', 'energetic': 'ऊर्जावान',
  },
  'bn': {
    'savage': 'ঝাঁঝালো', 'blunt': 'স্পষ্টবাদী', 'tsundere': 'সুনদেরে',
    'excited': 'উচ্ছ্বসিত', 'sweet': 'মিষ্টি', 'dramatic': 'নাটুকে',
    'chill': 'নির্ভার', 'goofy': 'খামখেয়ালি', 'easygoing': 'সহজ-সরল',
    'warm': 'আন্তরিক', 'tender': 'কোমল', 'emotional': 'আবেগপ্রবণ',
    'hyper': 'অতি চঞ্চল', 'cheerful': 'হাসিখুশি', 'energetic': 'প্রাণবন্ত',
  },
  'ne': {
    'savage': 'तिखो बोली', 'blunt': 'स्पष्टवक्ता', 'tsundere': 'सुन्देरे',
    'excited': 'उत्साहित', 'sweet': 'मीठो स्वभाव', 'dramatic': 'नाटकीय',
    'chill': 'आरामी', 'goofy': 'ठट्यौली', 'easygoing': 'सरल',
    'warm': 'न्यानो', 'tender': 'कोमल', 'emotional': 'भावुक',
    'hyper': 'अति चञ्चल', 'cheerful': 'हँसिलो', 'energetic': 'जोसिलो',
  },
  'ur': {
    'savage': 'تلخ زبان', 'blunt': 'صاف گو', 'tsundere': 'سُنڈیرے',
    'excited': 'پُرجوش', 'sweet': 'میٹھی', 'dramatic': 'ڈرامائی',
    'chill': 'بےفکر', 'goofy': 'مسخرا', 'easygoing': 'سادہ مزاج',
    'warm': 'گرم جوش', 'tender': 'نرم دل', 'emotional': 'جذباتی',
    'hyper': 'بے حد چلبلی', 'cheerful': 'خوش مزاج', 'energetic': 'توانا',
  },
  'th': {
    'savage': 'ปากร้าย', 'blunt': 'ตรงไปตรงมา', 'tsundere': 'ซึนเดเระ',
    'excited': 'ตื่นเต้น', 'sweet': 'น่ารัก', 'dramatic': 'ดราม่า',
    'chill': 'ชิลล์', 'goofy': 'ติงต๊อง', 'easygoing': 'สบาย ๆ',
    'warm': 'อบอุ่น', 'tender': 'อ่อนโยน', 'emotional': 'อ่อนไหว',
    'hyper': 'ไฮเปอร์', 'cheerful': 'ร่าเริง', 'energetic': 'พลังล้น',
  },
  'vi': {
    'savage': 'Miệng độc', 'blunt': 'Thẳng thắn', 'tsundere': 'Tsundere',
    'excited': 'Hào hứng', 'sweet': 'Ngọt ngào', 'dramatic': 'Kịch tính',
    'chill': 'Thư thái', 'goofy': 'Ngố', 'easygoing': 'Dễ tính',
    'warm': 'Ấm áp', 'tender': 'Dịu dàng', 'emotional': 'Đa cảm',
    'hyper': 'Tăng động', 'cheerful': 'Vui vẻ', 'energetic': 'Tràn năng lượng',
  },
  'id': {
    'savage': 'Pedas', 'blunt': 'Blak-blakan', 'tsundere': 'Tsundere',
    'excited': 'Heboh', 'sweet': 'Manis', 'dramatic': 'Dramatis',
    'chill': 'Santai', 'goofy': 'Konyol', 'easygoing': 'Kalem',
    'warm': 'Hangat', 'tender': 'Lembut', 'emotional': 'Emosional',
    'hyper': 'Hiperaktif', 'cheerful': 'Ceria', 'energetic': 'Enerjik',
  },
  'ms': {
    'savage': 'Lidah tajam', 'blunt': 'Berterus terang', 'tsundere': 'Tsundere',
    'excited': 'Teruja', 'sweet': 'Manis', 'dramatic': 'Dramatik',
    'chill': 'Santai', 'goofy': 'Kelakar', 'easygoing': 'Tenang',
    'warm': 'Mesra', 'tender': 'Lembut', 'emotional': 'Emosional',
    'hyper': 'Hiperaktif', 'cheerful': 'Ceria', 'energetic': 'Bertenaga',
  },
  'fil': {
    'savage': 'Matabil', 'blunt': 'Prangka', 'tsundere': 'Tsundere',
    'excited': 'Sabik', 'sweet': 'Malambing', 'dramatic': 'Madrama',
    'chill': 'Relaks', 'goofy': 'Kalog', 'easygoing': 'Maluwag',
    'warm': 'Magiliw', 'tender': 'Mapagmahal', 'emotional': 'Emosyonal',
    'hyper': 'Hyper', 'cheerful': 'Masayahin', 'energetic': 'Masigla',
  },
  'fi': {
    'savage': 'Piikikäs', 'blunt': 'Suorasukainen', 'tsundere': 'Tsundere',
    'excited': 'Innostunut', 'sweet': 'Suloinen', 'dramatic': 'Dramaattinen',
    'chill': 'Rento', 'goofy': 'Hassu', 'easygoing': 'Leppoisa',
    'warm': 'Lämmin', 'tender': 'Hellä', 'emotional': 'Tunteellinen',
    'hyper': 'Ylivilkas', 'cheerful': 'Iloinen', 'energetic': 'Energinen',
  },
  'hu': {
    'savage': 'Csípős nyelvű', 'blunt': 'Szókimondó', 'tsundere': 'Tsundere',
    'excited': 'Izgatott', 'sweet': 'Édes', 'dramatic': 'Drámai',
    'chill': 'Laza', 'goofy': 'Bohókás', 'easygoing': 'Könnyed',
    'warm': 'Melegszívű', 'tender': 'Gyengéd', 'emotional': 'Érzelmes',
    'hyper': 'Pörgős', 'cheerful': 'Vidám', 'energetic': 'Energikus',
  },
  'km': {
    'savage': 'មាត់ខ្លាំង', 'blunt': 'និយាយត្រង់', 'tsundere': 'ស៊ុនដេរេ',
    'excited': 'រំភើប', 'sweet': 'ផ្អែមល្ហែម', 'dramatic': 'ឌ្រាម៉ា',
    'chill': 'ស្ងប់ស្ងាត់', 'goofy': 'កំប្លែង', 'easygoing': 'ងាយស្រួល',
    'warm': 'កក់ក្ដៅ', 'tender': 'ទន់ភ្លន់', 'emotional': 'រសើប',
    'hyper': 'សកម្មខ្លាំង', 'cheerful': 'រីករាយ', 'energetic': 'ពោរពេញថាមពល',
  },
  'my': {
    'savage': 'စကားပြတ်', 'blunt': 'ပွင့်လင်း', 'tsundere': 'ဆွန်ဒဲရဲ',
    'excited': 'စိတ်လှုပ်ရှား', 'sweet': 'ချိုသာ', 'dramatic': 'ဒရာမာဆန်',
    'chill': 'အေးဆေး', 'goofy': 'ရယ်စရာကောင်း', 'easygoing': 'သဘောကောင်း',
    'warm': 'နွေးထွေး', 'tender': 'နူးညံ့', 'emotional': 'စိတ်ခံစားလွယ်',
    'hyper': 'အလွန်တက်ကြွ', 'cheerful': 'ပျော်ရွှင်', 'energetic': 'အားအင်ပြည့်',
  },
  'si': {
    'savage': 'තියුණු කට', 'blunt': 'කෙළින් කියන', 'tsundere': 'ට්සුන්ඩෙරේ',
    'excited': 'උද්යෝගිමත්', 'sweet': 'මිහිරි', 'dramatic': 'නාට්‍යමය',
    'chill': 'නිදහස්', 'goofy': 'විහිළුකාර', 'easygoing': 'සැහැල්ලු',
    'warm': 'උණුසුම්', 'tender': 'මෘදු', 'emotional': 'හැඟීම්බර',
    'hyper': 'අධි ක්‍රියාශීලී', 'cheerful': 'සතුටු සිත්', 'energetic': 'ජවසම්පන්න',
  },
};
