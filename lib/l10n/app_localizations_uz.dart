// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get loginRequired => 'Tizimga kirishingiz kerak.';

  @override
  String get callWebNotSupported =>
      'Vebda ovozli qoʻngʻiroq ishlamaydi. Ilovadan foydalaning.';

  @override
  String get micPermissionRequiredForCall =>
      'Mikrofonga ruxsat kerak. Qoʻngʻiroq qilish uchun mikrofonga ruxsat bering.';

  @override
  String get callErrorGeneric => 'Qoʻngʻiroq paytida xatolik yuz berdi.';

  @override
  String get callDailyLimit => 'Bugungi o\'qish vaqti tugadi.';

  @override
  String get callAlreadyInCall => 'Siz allaqachon qo\'ng\'iroqdasiz.';

  @override
  String get callNetworkError => 'Tarmoq xatosi yuz berdi.';

  @override
  String get authInvalidCredentials => 'Email yoki parol notoʻgʻri.';

  @override
  String get authEmailAlreadyRegistered =>
      'Bu email allaqachon roʻyxatdan oʻtgan.';

  @override
  String get authConfirmEmailRequired =>
      'Emailingizga yuborilgan tasdiqlashni yakunlang.';

  @override
  String get authResetCodeSent => 'Tasdiqlash kodini emailingizga yubordik.';

  @override
  String get authResetCodeInvalid => 'Kod notoʻgʻri yoki muddati oʻtgan.';

  @override
  String get authPasswordUpdated => 'Parolingiz tiklandi.';

  @override
  String get authAppleTokenMissing => 'Apple kirish tokenini olib boʻlmadi.';

  @override
  String callEndedDuration(String duration) {
    return 'Qoʻngʻiroq tugadi $duration';
  }

  @override
  String get callRatingPrompt => 'Qoʻngʻiroq qanday oʻtdi?';

  @override
  String get callRatingBody =>
      'Bahoingiz keyingi safar yaxshiroq suhbatlashishga yordam beradi.';

  @override
  String get callRatingSubmit => 'Yuborish';

  @override
  String get callRatingSkip => 'O‘tkazib yuborish';

  @override
  String get ratingBad => 'Yaxshi emas';

  @override
  String get ratingOkay => 'Yaxshi';

  @override
  String get ratingGood => 'Zoʻr';

  @override
  String get goHome => 'Bosh sahifa';

  @override
  String get viewAnalysis => 'Tahlilni koʻrish';

  @override
  String get loadingShort => 'Yuklanmoqda…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Bahoni yuborib boʻlmadi: $message';
  }

  @override
  String get callInfoNotFound =>
      'Qoʻngʻiroq maʼlumoti topilmadi, tahlil oʻtkazib yuborildi.';

  @override
  String get tabRecords => 'Yozuvlar';

  @override
  String get tabArchive => 'Arxiv';

  @override
  String get callHistory => 'Qoʻngʻiroqlar tarixi';

  @override
  String get conversationRecord => 'Suhbat yozuvi';

  @override
  String get noCallRecords => 'Hali qoʻngʻiroq yozuvlari yoʻq';

  @override
  String get noCallRecordsBody =>
      'AI bilan birinchi qoʻngʻiroqni yakunlaganingizdan soʻng,\nyozuvlaringiz shu yerda paydo boʻladi.';

  @override
  String get startCall => 'Qoʻngʻiroqni boshlash';

  @override
  String get recordsLoadError => 'Yozuvlarni yuklab boʻlmadi';

  @override
  String get tryAgainLater => 'Iltimos, keyinroq qayta urinib koʻring.';

  @override
  String get retry => 'Qayta urinish';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes daq $seconds son';
  }

  @override
  String get scheduleManagement => 'Jadval';

  @override
  String get alarms => 'Signalar';

  @override
  String get alarmAdd => 'Budilnik qo‘shish';

  @override
  String get alarmEdit => 'Budilnikni tahrirlash';

  @override
  String get alarmEveryDay => 'Har kuni';

  @override
  String get alarmWeekdays => 'Ish kunlari';

  @override
  String get alarmWeekend => 'Dam olish kunlari';

  @override
  String get alarmNoRepeat => 'Takrorlanmaydi';

  @override
  String get addSchedule => 'Jadval qoʻshish';

  @override
  String get editSchedule => 'Jadvalni tahrirlash';

  @override
  String get somethingWentWrong => 'Xatolik yuz berdi';

  @override
  String get alarmsLoadError => 'Signallarni yuklab boʻlmadi';

  @override
  String get charactersLoadError => 'Personajlarni yuklab boʻlmadi';

  @override
  String get noCharacters => 'Personajlar mavjud emas';

  @override
  String get close => 'Yopish';

  @override
  String get repeat => 'Takrorlash';

  @override
  String get callPartner => 'Personaj';

  @override
  String get alarmModeLearnSub => 'Dastur iboralarini mashq qilish';

  @override
  String get alarmModeChatSub => 'Istalgan mavzuda suhbat';

  @override
  String get quickStart => 'Tez boshlash';

  @override
  String get presetMorning => 'Ertalabki tartib';

  @override
  String get presetMorningSub => 'Ish kunlari 8:00';

  @override
  String get presetEvening => 'Kechki yakun';

  @override
  String get presetEveningSub => 'Har kuni 21:00';

  @override
  String get presetCustom => 'Ixtiyoriy';

  @override
  String get presetCustomSub => 'O\'zingizcha';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Haftasiga $count× · oyiga $monthly qo\'ng\'iroq';
  }

  @override
  String get alarmSummaryNone => 'Kamida bitta kun tanlang';

  @override
  String get partnerInUse => 'Ishlatilmoqda';

  @override
  String get partnerOwned => 'Mavjud';

  @override
  String get am => 'TO';

  @override
  String get pm => 'TK';

  @override
  String get save => 'Saqlash';

  @override
  String get conversation => 'Suhbat';

  @override
  String get newExpressions => 'Yangi iboralar';

  @override
  String get analysisPrepNote => 'Bugungi qo‘ng‘iroq ko‘rib chiqilmoqda.';

  @override
  String get analysisPrepNoteHint => 'Tez orada bu yerda xabar paydo bo‘ladi';

  @override
  String get analysisPrepTitle =>
      'Qunduz bugungi iboralardan kartalar yasamoqda';

  @override
  String get analysisPrepSub => 'Tayyor bo‘lishi bilan shu yerda chiqadi.';

  @override
  String get analysisPrepStepSave => 'Suhbatni saqlash';

  @override
  String get analysisPrepStepCards => 'Ibora kartalarini yasash';

  @override
  String get analysisPrepStateDone => 'Tayyor';

  @override
  String get analysisPrepStateWorking => 'Jarayonda';

  @override
  String get analysisPrepStateWaiting => 'Kutilmoqda';

  @override
  String get usedExpressions => 'Siz ishlatgan iboralar';

  @override
  String quizExpressionsCount(int count) {
    return 'O‘rganilgan iboralar $count';
  }

  @override
  String get quizPassed => 'To‘g‘ri';

  @override
  String get quizFailed => 'Yana ko‘rib chiqing';

  @override
  String get quizPending => 'Keyingi safar davom etamiz';

  @override
  String get analysisResult => 'Tahlil natijasi';

  @override
  String get noNewExpressions => 'Bu suhbatda yangi ibora topilmadi.';

  @override
  String get practice => 'Mashq qilish';

  @override
  String get analysisNativeLabel => 'Mahalliy';

  @override
  String recentScore(int score) {
    return 'Soʻnggi natija $score%';
  }

  @override
  String callSequence(int count) {
    return '$count-qo\'ng\'iroq';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name tomonidan bir og\'iz so\'z';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Qo\'ng\'iroqdan so\'ng darhol $name qoldirdi';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Yangi iboralar $count';
  }

  @override
  String get analysisLoadError => 'Tahlil natijasini yuklab boʻlmadi.';

  @override
  String get standardAudioNotReady =>
      'Andoza talaffuz audiosi hali tayyor emas.';

  @override
  String get standardAudioPlayError =>
      'Andoza talaffuz audiosini ijro etib boʻlmadi.';

  @override
  String get selectNativeLanguage => 'Ona tilingizni tanlang';

  @override
  String get selectYourLanguage => 'Tilingizni tanlang';

  @override
  String get confirm => 'Tasdiqlash';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get micPermissionNeededTitle => 'Mikrofonga ruxsat kerak';

  @override
  String get micPermissionNeededBody =>
      'AI bilan gaplashish uchun mikrofonga ruxsat berishingiz kerak. Buni Sozlamalarda yoqing.';

  @override
  String get openSettings => 'Sozlamalarni ochish';

  @override
  String get connectionFailedTitle => 'Ulanish amalga oshmadi';

  @override
  String get connectionFailedBody =>
      'Internet ulanishingizni tekshiring\nva qayta urinib koʻring.';

  @override
  String get checkout => 'Toʻlovga oʻtish';

  @override
  String get pay => 'Toʻlash';

  @override
  String get orderSummary => 'Buyurtma xulosasi';

  @override
  String get paymentMethod => 'Toʻlov usuli';

  @override
  String get payMethodCard => 'Kredit / Debit karta';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Yaramas Qunduz avatari';

  @override
  String get productTrait => 'Premium personaj · Abadiy sizniki';

  @override
  String get amountItemPrice => 'Mahsulot narxi';

  @override
  String get amountDiscount => 'Chegirma';

  @override
  String get amountTotal => 'Jami';

  @override
  String get paymentCompleteTitle => 'Toʻlov yakunlandi';

  @override
  String get paymentCompleteBody => 'Avatar toʻplamingizga qoʻshildi.';

  @override
  String get viewCollection => 'Toʻplamni koʻrish';

  @override
  String get receiptItem => 'Mahsulot';

  @override
  String get receiptAmount => 'Summa';

  @override
  String get receiptMethod => 'Toʻlov usuli';

  @override
  String get receiptDate => 'Sana';

  @override
  String get paymentFailedTitle => 'Toʻlov amalga oshmadi';

  @override
  String get paymentFailedBody =>
      'Toʻlovingizni amalga oshirib boʻlmadi.\nIltimos, qayta urinib koʻring.';

  @override
  String get freeCallEndingTitle => 'Bepul qoʻngʻirog\'ingiz tugamoqda';

  @override
  String get freeCallEndingBody =>
      'Qunduz bilan uzoqroq gaplashish uchun obuna boʻling.';

  @override
  String get subscribe => 'Obuna boʻlish';

  @override
  String get endCall => 'Qoʻngʻiroqni tugatish';

  @override
  String get callEnded => 'Qoʻngʻiroq tugadi.';

  @override
  String get connecting => 'Ulanmoqda…';

  @override
  String get connectingHint => 'Odatda bu 5 soniyadan kam vaqt oladi';

  @override
  String get callConnectFailed => 'Qoʻngʻiroqni ulab boʻlmadi.';

  @override
  String get saveSentenceFailed => 'Gapni saqlab boʻlmadi.';

  @override
  String get recordStartFailed => 'Yozishni boshlab boʻlmadi.';

  @override
  String get recordTooShort =>
      'Yozuv juda qisqa boʻldi. Iltimos, qayta urinib koʻring.';

  @override
  String get gradingFailed =>
      'Baholash amalga oshmadi. Iltimos, qayta urinib koʻring.';

  @override
  String get listenStandard => 'Andoza talaffuzni eshitish';

  @override
  String get saveSentence => 'Gapni saqlash';

  @override
  String get unsaveSentence => 'Saqlangan gapni olib tashlash';

  @override
  String get scoringPronunciation => 'Talaffuzingiz baholanmoqda…';

  @override
  String get analyzingByWord => 'Talaffuzingiz so\'zma-so\'z tekshirilmoqda';

  @override
  String get analyzingTakingLonger => 'Bu biroz ko\'proq vaqt olmoqda';

  @override
  String get scanConnectionLost => 'Aloqa uzildi';

  @override
  String get noRecordingToPlay => 'Ijro etish uchun yozuv yoʻq.';

  @override
  String get myRecordingPlayError => 'Yozuvingizni ijro etib boʻlmadi.';

  @override
  String get next => 'Keyingi';

  @override
  String get endLearning => 'Darsni tugatish';

  @override
  String get navCall => 'Qoʻngʻiroq';

  @override
  String get homeCourseExpression => 'Iboralar';

  @override
  String get homeCourseFreetalk => 'Suhbat';

  @override
  String homeExpressionsLeft(int count) {
    return 'Suhbatgacha $count ta ibora qoldi';
  }

  @override
  String get homeFreetalkNote =>
      'O‘rganganingizdan foydalanib erkin suhbatlashing';

  @override
  String get homeTalkTitle => 'Bugun nima bo‘ldi?';

  @override
  String get homeTalkNote => 'Erkin suhbatlashing va yo‘l-yo‘lakay o‘rganing.';

  @override
  String get homeModeLearn => 'O‘rganish';

  @override
  String get homeModeTalk => 'Suhbat';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ketma-ket $count kun',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'O‘qish taqvimi';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kun ketma-ket',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eng yaxshi natija: $count kun',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Qo‘ng‘iroq vaqti';

  @override
  String get streakMetricLearned => 'O\'rganilgan iboralar';

  @override
  String get streakMetricWords => 'Aytilgan so\'zlar';

  @override
  String streakCountValue(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count daq',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'Bu kuni qo‘ng‘iroq bo‘lmagan.';

  @override
  String get homeLevelPending => 'Daraja aniqlanmagan';

  @override
  String get homeNoLevelTitle => 'Sizda hali daraja yo‘q';

  @override
  String get homeNoLevelNote =>
      'Birinchi qo‘ng‘iroqni yakunlasangiz daraja chiqadi';

  @override
  String get homeCurriculumPendingBadge => 'Tez orada';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language o‘quv dasturi tayyorlanmoqda';
  }

  @override
  String get homeCurriculumPendingNote =>
      'Qo‘ng‘iroqlarda umumiy iboralarni mashq qilasiz';

  @override
  String get myPage => 'Mening sahifam';

  @override
  String get languageSaveFailed => 'Tilingizni saqlab boʻlmadi.';

  @override
  String get accountDeleteFailed => 'Hisobingizni oʻchirib boʻlmadi.';

  @override
  String get changeAvatar => 'Avatarni almashtirish';

  @override
  String get avatarUseNow => 'Hozir ishlatish';

  @override
  String get avatarPurchaseFailed => 'Xarid amalga oshmadi';

  @override
  String avatarPromoTitle(int percent) {
    return 'Faqat bugun · $percent% chegirma';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time qoldi';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days kun $time qoldi';
  }

  @override
  String get avatarIntro =>
      'Ovoz va qiyinlik darajasi suhbat sherigiga qarab oʻzgaradi.\nBaʼzi sheriklar toʻlov talab qilishi mumkin.';

  @override
  String myPartnersOwned(int count) {
    return 'Mening sheriklarim · $count ta';
  }

  @override
  String get limitedDiscount => 'Muddatli chegirma';

  @override
  String get available => 'Mavjud';

  @override
  String get inUse => 'Foydalanilmoqda';

  @override
  String get owned => 'Sizniki';

  @override
  String get noCharactersToShow => 'Koʻrsatish uchun personaj yoʻq';

  @override
  String get buy => 'Sotib olish';

  @override
  String get noSavedSentences =>
      'Hali saqlangan gap yoʻq.\nSuhbat yozuvlaringizdagi gaplarni belgilab qoʻying.';

  @override
  String get noAlarms => 'Hali signal yoʻq';

  @override
  String get noAlarmsBody =>
      'Barqaror odat shakllantirish uchun\noʻqish eslatmasini qoʻshing.';

  @override
  String get subscriptionManage => 'Obunani boshqarish';

  @override
  String get cancelSubscription => 'Obunani bekor qilish';

  @override
  String get benefitsInUse => 'Sizning imtiyozlaringiz';

  @override
  String get paymentInfo => 'Toʻlov maʼlumoti';

  @override
  String get nextBillingDate => 'Keyingi toʻlov sanasi';

  @override
  String get lostBenefitsTitle => 'Bekor qilsangiz yoʻqotadigan imtiyozlar';

  @override
  String get viewBillingHistory => 'Toʻlovlar tarixini koʻrish';

  @override
  String pricePerMonth(String price) {
    return '$price / oy';
  }

  @override
  String get benefitDetailedAnalysis =>
      'Batafsil talaffuz va grammatika tahlili';

  @override
  String get benefitAllCharacters => 'Barcha personajlarga kirish';

  @override
  String get benefitNoAds => 'Reklamasiz';

  @override
  String get playSampleVoice => 'Namuna ovozni ijro etish';

  @override
  String get useThisAvatar => 'Buni ishlatish';

  @override
  String get challengeTitle => 'Talaffuz sinovi';

  @override
  String get challengeIntro =>
      'Zonadagi har bir kartani koreys tilida toʻgʻri talaffuz qilib, uni yeching.\nMikrofon yoʻqmi? Ekranga bosib ham oʻynashingiz mumkin.';

  @override
  String get challengeStart => 'Kamera va mikrofonni yoqish';

  @override
  String get challengePermissionNote =>
      'Old kamera va mikrofonga ruxsat talab qilinadi (ixtiyoriy).';

  @override
  String get challengeLoadingTitle => 'Yuklanmoqda…';

  @override
  String get challengeLoadingNote => 'Kamera va mikrofon tayyorlanmoqda.';

  @override
  String get challengeSttFallback =>
      'Nutqni aniqlash mavjud emas edi, shuning uchun ekranga bosib oʻynadingiz.';

  @override
  String get reasonTravelTitle => 'Sayohat paytida gaplashish';

  @override
  String get reasonTravelDesc =>
      'Mahalliy aholi bilan ishonch bilan suhbatlashing';

  @override
  String get reasonCareerTitle => 'Ish va martaba';

  @override
  String get reasonCareerDesc => 'Biznes suhbati';

  @override
  String get reasonExamTitle => 'Imtihonga tayyorgarlik';

  @override
  String get reasonExamDesc => 'Nutq imtihonlariga tayyorlaning';

  @override
  String get reasonDailyTitle => 'Kundalik suhbat';

  @override
  String get reasonDailyDesc => 'Har kuni ishlatadigan iboralar';

  @override
  String get reasonFriendsTitle => 'Xorijiy doʻstlar orttirish';

  @override
  String get reasonFriendsDesc => 'Tabiiy suhbat';

  @override
  String get reasonBrainTitle => 'Miya faoliyatini rivojlantirish';

  @override
  String get reasonBrainDesc => 'Xotira va diqqatni kuchaytiring';

  @override
  String get challengeRecordToggle => 'Bu oʻyinni yozib olish';

  @override
  String get challengeRecordHint =>
      'Oʻyiningiz videosini ulashish uchun saqlaydi (ovozsiz).';

  @override
  String get settingsSection => 'Sozlamalar';

  @override
  String get paymentSection => 'Toʻlov';

  @override
  String get supportSection => 'Yordam';

  @override
  String get userLanguage => 'Foydalanuvchi tili';

  @override
  String get learningLanguage => 'Oʻrganilayotgan til';

  @override
  String get learningLanguageKorean => 'Koreys tili';

  @override
  String get notificationLabel => 'Bildirishnoma';

  @override
  String get currentPlan => 'Joriy reja';

  @override
  String get paymentHistory => 'Toʻlovlar tarixi';

  @override
  String get contactUs => 'Biz bilan bogʻlaning';

  @override
  String get termsOfService => 'Foydalanish shartlari';

  @override
  String get privacyPolicy => 'Maxfiylik siyosati';

  @override
  String get logOut => 'Chiqish';

  @override
  String get deleteAccount => 'Hisobni oʻchirish';

  @override
  String get deleteAccountTitle => 'Hisobni oʻchirasizmi?';

  @override
  String get deleteAccountBody =>
      'Bu hisobingiz va maʼlumotlaringizni butunlay oʻchiradi va uni qaytarib boʻlmaydi.';

  @override
  String get delete => 'Oʻchirish';

  @override
  String get share => 'Ulashish';

  @override
  String get accentSoundsLike => 'Koreys aksentingiz shunday eshitiladi';

  @override
  String accentShareText(String country) {
    return 'BeaverTalk bilan koreys tilini oʻrganyapman — koreyscha talaffuzim shunday eshitiladi: $country! 🦫 Oʻz talaffuzingni aniqla va men bilan birga oʻrgan: https://beavertalk.im';
  }

  @override
  String get hintLabel => 'Maslahat';

  @override
  String get nextHint => 'Keyingi maslahat';

  @override
  String get translateLabel => 'Tarjima qilish';

  @override
  String get startRecording => 'Yozishni boshlash';

  @override
  String get stopRecording => 'Yozishni toʻxtatish';

  @override
  String get back => 'Orqaga';

  @override
  String get onboardingNameTitle => 'Sizni qanday deb chaqiraylik?';

  @override
  String get onboardingNameSubtitle =>
      'AI oʻqituvchingiz ismingizni eslab qoladi.';

  @override
  String get nameLabel => 'Ismingiz';

  @override
  String get nameHint => 'Ismingizni kiriting';

  @override
  String get nameHelper =>
      'Bu haqiqiy ismingiz boʻlishi shart emas — taxallus ham boʻlaveradi.';

  @override
  String get continueLabel => 'Davom etish';

  @override
  String get onboardingDoneTitle => 'Qunduz qoʻngʻirogʻingizni kutmoqda';

  @override
  String get onboardingDoneSubtitle => 'Hozir qoʻngʻiroq qiling';

  @override
  String get home => 'Bosh sahifa';

  @override
  String get onboardingLevelTestCta => 'Daraja testini topshirish';

  @override
  String get pronunciation => 'Talaffuz';

  @override
  String get fluency => 'Ravonlik';

  @override
  String get rhythm => 'Ritm';

  @override
  String get analysisFailed =>
      'Suhbatni tahlil qila olmadik. Iltimos, qayta urinib koʻring.';

  @override
  String get analyzingConversation => 'Suhbatingiz tahlil qilinmoqda…';

  @override
  String get analyzingSubtitle => 'Bu bir necha soniya oladi';

  @override
  String get tryAgain => 'Qayta urinish';

  @override
  String get nativeLabel => 'Ona tili';

  @override
  String get meLabel => 'Men';

  @override
  String get pronunciationPlayError => 'Talaffuz audiosini ijro etib boʻlmadi.';

  @override
  String get savedExpressionsLoadError =>
      'Saqlangan iboralaringizni yuklab boʻlmadi.';

  @override
  String get mySavedExpressions => 'Saqlangan iboralarim';

  @override
  String get avatarTraits => 'Iliq · Xotirjam · Yumshoq';

  @override
  String get priceFree => 'Bepul';

  @override
  String get loginGoogleTokenError => 'Google kirish tokenini olib boʻlmadi.';

  @override
  String get loginGoogleSignInFailed => 'Google orqali kirish amalga oshmadi.';

  @override
  String get loginAppleSignInFailed => 'Apple orqali kirish amalga oshmadi.';

  @override
  String get loginFacebookSignInFailed =>
      'Facebook orqali kirish amalga oshmadi.';

  @override
  String get loginKakaoSignInFailed => 'Kakao orqali kirish amalga oshmadi.';

  @override
  String get loginContinueWithKakao => 'Kakao bilan davom etish';

  @override
  String get loginContinueWithGoogle => 'Google bilan davom etish';

  @override
  String get loginContinueWithFacebook => 'Facebook bilan davom etish';

  @override
  String get loginContinueWithApple => 'Apple bilan davom etish';

  @override
  String get loginContinueWithEmail => 'Email bilan davom etish';

  @override
  String get loginOrDivider => 'yoki';

  @override
  String get loginNoAccount => 'Hisobingiz yoʻqmi?';

  @override
  String get signUp => 'Roʻyxatdan oʻtish';

  @override
  String get loginTermsNoticePrefix => 'Davom etish orqali siz bizning ';

  @override
  String get loginTermsNoticeAnd => ' va ';

  @override
  String get loginTermsNoticeSuffix => ' ga rozilik bildirasiz.';

  @override
  String get loginLogIn => 'Kirish';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Emailingizni kiriting';

  @override
  String get fieldPasswordLabel => 'Parol';

  @override
  String get passwordHint => 'Parolingizni kiriting';

  @override
  String get loginRememberMe => 'Meni eslab qol';

  @override
  String get loginForgotPassword => 'Parolni unutdingizmi?';

  @override
  String get loginLoggingIn => 'Kirilmoqda...';

  @override
  String get passwordLengthError =>
      'Parol 8–16 belgidan iborat boʻlishi kerak.';

  @override
  String get passwordsDoNotMatch => 'Parollar mos kelmadi.';

  @override
  String get signupCheckInput => 'Iltimos, kiritilgan maʼlumotni tekshiring.';

  @override
  String get fieldConfirmPasswordLabel => 'Parolni tasdiqlang';

  @override
  String get confirmPasswordHint => 'Parolingizni qayta kiriting';

  @override
  String get signupSigningUp => 'Roʻyxatdan oʻtilmoqda...';

  @override
  String get signupHaveAccount => 'Hisobingiz bormi?';

  @override
  String get passwordMethodEmailRequired => 'Emailingizni kiriting';

  @override
  String get passwordResetTitle => 'Parolni tiklash';

  @override
  String get passwordMethodDescription =>
      'Parolni tiklash kodini olmoqchi boʻlgan email manzilingizni kiriting.';

  @override
  String get emailAddressHint => 'Email manzil';

  @override
  String get passwordMethodSending => 'Yuborilmoqda...';

  @override
  String get passwordMethodSendEmail => 'Email yuborish';

  @override
  String get passwordCodeTitle => 'Kodni kiriting';

  @override
  String get passwordCodeDescription =>
      'Emailingizga tiklash kodini yubordik. Davom etish uchun uni kiriting.';

  @override
  String get passwordCodeNoCode => 'Kod kelmadimi?';

  @override
  String get passwordCodeResend => 'Kodni qayta yuborish';

  @override
  String get passwordCodeVerifying => 'Tekshirilmoqda...';

  @override
  String get passwordNewTitle => 'Yangi parol';

  @override
  String get passwordNewDescription =>
      'Hisobingiz uchun yangi parol oʻrnating.';

  @override
  String get fieldNewPasswordLabel => 'Yangi parol';

  @override
  String get newPasswordHint => 'Yangi parolingizni kiriting';

  @override
  String get fieldConfirmNewPasswordLabel => 'Yangi parolni tasdiqlang';

  @override
  String get confirmNewPasswordHint => 'Yangi parolingizni qayta kiriting';

  @override
  String get passwordNewSubmitting => 'Yuborilmoqda...';

  @override
  String get passwordNewSubmit => 'Yuborish';

  @override
  String get passwordCompleteTitle => 'Parol tiklash yakunlandi';

  @override
  String get passwordCompleteBody =>
      'Parolingiz tiklandi. Davom etish uchun yangi parolingiz bilan kiring.';

  @override
  String get termsTitle => 'Foydalanish shartlari';

  @override
  String get privacyTitle => 'Maxfiylik siyosati';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email uchun yangi parol oʻrnating.';
  }

  @override
  String get selectComplete => 'Tayyor';

  @override
  String get onboardingLanguageTitle => 'Sizning ona tilingiz nima?';

  @override
  String get onboardingReasonTitle => 'Nima uchun til o\'rganyapsiz?';

  @override
  String get onboardingReasonSubtitle =>
      'Biz o\'quv jarayonini sizning maqsadlaringizga moslashtiramiz.';

  @override
  String get savingLabel => 'Saqlanmoqda...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Shu oydagi to\'lov';

  @override
  String get filterAll => 'Hammasi';

  @override
  String get filterSubscription => 'Obuna';

  @override
  String get filterCharacter => 'Qahramon';

  @override
  String get statusCompleted => 'Yakunlandi';

  @override
  String get lastPayment => 'Oxirgi to\'lov';

  @override
  String get freePlanCallLimit => 'Kuniga 5 daqiqa qo\'ng\'iroq';

  @override
  String get freePlanBasicCharacters => 'Asosiy qahramonlar kiritilgan';

  @override
  String get availableForPurchase => 'Sotib olish mumkin';

  @override
  String get paymentsLoadError => 'To\'lovlar tarixini yuklab bo\'lmadi';

  @override
  String get noPayments => 'Hozircha to\'lovlar yo\'q';

  @override
  String get undatedPayments => 'Sanasiz';

  @override
  String get paymentLabelFallback => 'To\'lov';

  @override
  String learningPassed(int passed, int total) {
    return '$total gapdan $passed tasi o\'tdi';
  }

  @override
  String get hardestSound => 'Bugungi eng qiyin tovush';

  @override
  String get soundAccuracy => 'Tovush bo\'yicha aniqlik';

  @override
  String phonemeAttempts(int count) {
    return 'Fonema bo\'yicha · $count urinish';
  }

  @override
  String get colSound => 'Tovush';

  @override
  String get colAttempts => 'Urin.';

  @override
  String get colCorrect => 'To\'g\'ri';

  @override
  String get colAccuracy => 'Aniq.';

  @override
  String get sentenceResults => 'Gap bo\'yicha natijalar';

  @override
  String viewAllSentences(int count) {
    return 'Barcha $count tasini ko\'rish';
  }

  @override
  String get colSentence => 'Gap';

  @override
  String get colPronunciation => 'Talaf.';

  @override
  String get colFluency => 'Ravon.';

  @override
  String get colRhythm => 'Ritm';

  @override
  String recentSessions(int count) {
    return 'Oxirgi $count mashg\'ulot';
  }

  @override
  String trendAverage(int score) {
    return 'O\'rt. $score';
  }

  @override
  String get today => 'Bugun';

  @override
  String get colDate => 'Sana';

  @override
  String get colSentences => 'Gaplar';

  @override
  String get colScore => 'Ball';

  @override
  String get colChange => 'O\'zg.';

  @override
  String dateToday(String date) {
    return '$date (bugun)';
  }

  @override
  String get accentAnalysis => 'Talaffuz uslubi tahlili';

  @override
  String get overallLevel => 'Umumiy daraja';

  @override
  String get overallLevelSubtitle => 'Lug\'at · Grammatika · Ifodalar';

  @override
  String get pronunciationAnalysis => 'Talaffuz tahlili';

  @override
  String get recentSessionsAverage => 'Oxirgi 10 mashg\'ulot o\'rtachasi';

  @override
  String levelStage(int stage) {
    return '$stage-daraja';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Barcha oʻquvchilar orasida';

  @override
  String aheadOfLearners(int percent) {
    return 'Siz oʻquvchilarning $percent% dan oldindasiz';
  }

  @override
  String get retakeLevelTest => 'Daraja testini qayta topshirish';

  @override
  String get levelTestOncePerDay =>
      'Daraja testini kuniga bir marta topshirish mumkin. Ertaga yana urinib koʻring.';

  @override
  String get levelRetakeTitle => 'Daraja testini qayta topshirasizmi?';

  @override
  String get levelRetakeBody =>
      'Qayta topshirsangiz, natijangiz o‘sha darajaning birinchi darsiga qaytadi — daraja bir xil chiqsa ham. O‘rganilgan iboralar va qo‘ng‘iroqlar tarixi saqlanadi.';

  @override
  String get levelRetakeKeep => 'Natijani saqlash';

  @override
  String get levelRetakeConfirm => 'Qayta topshirish';

  @override
  String get practicePronunciation => 'Talaffuzni mashq qilish';

  @override
  String get analysisNoScoreReview => 'Mashq qilsangiz, talaffuz balli chiqadi';

  @override
  String get analysisNoScoreEmpty => 'Baholanadigan gap yoʻq';

  @override
  String get priceChangedTitle => 'Narx oʻzgardi';

  @override
  String priceChangedBody(String price) {
    return 'Bu mahsulot endi $price. Davom etasizmi?';
  }

  @override
  String get billingGroupPlanPurchases => 'Tarif va xaridlar';

  @override
  String get billingGroupInTheStore => 'Doʻkonda';

  @override
  String get billingCompareAllPlans => 'Tariflarni solishtirish';

  @override
  String get billingBuyACharacter => 'Personaj sotib olish';

  @override
  String get billingRestorePurchases => 'Xaridlarni tiklash';

  @override
  String get billingRedeemCode => 'Koddan foydalanish';

  @override
  String get billingPaymentHistory => 'Toʻlovlar tarixi';

  @override
  String get billingManageInTheStore => 'Doʻkonda boshqarish';

  @override
  String get billingRefundHelp => 'Pulni qaytarish boʻyicha yordam';

  @override
  String get billingCancelSubscription => 'Obunani bekor qilish';

  @override
  String get billingResubscribe => 'Qayta obuna boʻlish';

  @override
  String get badgeCurrent => 'Joriy';

  @override
  String get badgeTrial => 'Sinov';

  @override
  String get badgeRenewing => 'Yangilanadi';

  @override
  String get badgePastDue => 'Toʻlov kechikkan';

  @override
  String get badgePaused => 'Toʻxtatilgan';

  @override
  String get badgeCanceling => 'Bekor qilinmoqda';

  @override
  String get subscriptionTitle => 'Obuna';

  @override
  String get plansTitle => 'Tariflar';

  @override
  String get planFree => 'Bepul';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Kuniga 15 daqiqa video qo‘ng‘iroq';

  @override
  String get premiumBulletAnalysis => 'To‘liq talaffuz tahlili';

  @override
  String get premiumBulletWeakSounds => 'Tilingizga mos qiyin tovushlar mashqi';

  @override
  String get noteCharactersSeparate =>
      'Personajlar alohida sotiladi. Sotib olganlaringiz sizniki bo‘lib qoladi.';

  @override
  String get ctaGetPremium => 'Premium olish';

  @override
  String get planMaxTrial => 'Premium sinovi';

  @override
  String get freePlanPriceLine => '\$0.00 — kuniga 5 daqiqa qoʻngʻiroq';

  @override
  String pricePerMonthLine(String amount) {
    return 'Oyiga $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date gacha bepul';
  }

  @override
  String get todaysCalls => 'Bugungi qoʻngʻiroq vaqti';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit daqiqadan $used daqiqa ishlatildi';
  }

  @override
  String get firstPaymentLabel => 'Birinchi toʻlov';

  @override
  String get nextPaymentLabel => 'Keyingi toʻlov';

  @override
  String get retryingUntilLabel => 'Qayta urinish muddati';

  @override
  String get pausedSinceLabel => 'Toʻxtatilgan sana';

  @override
  String planEndsLabel(String plan) {
    return '$plan tugaydi';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium bilan yuzma-yuz gaplashing';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Video qo‘ng‘iroqlar · kuniga 15 daqiqa · oyiga $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Yillik tarifga oʻting';

  @override
  String get bannerPaymentFailedTitle => 'Toʻlovni olib boʻlmadi';

  @override
  String get bannerPaymentFailedSub =>
      'Premium saqlanishi uchun doʻkonda toʻlovni yangilang';

  @override
  String get bannerPausedTitle => 'Tarifingiz toʻxtatildi';

  @override
  String get bannerPausedSub => 'Toʻlov amalga oshmadi';

  @override
  String get noteRestoreHint =>
      'Boshqa qurilmada obuna boʻlganmisiz? Tiklash uni bu qurilmaga qaytaradi.';

  @override
  String get noteStoreHandled =>
      'Toʻlov usuli, tarifni oʻzgartirish va bekor qilish doʻkon orqali amalga oshiriladi.';

  @override
  String noteTrialEnds(String date) {
    return 'Sinov muddatingiz $date tugaydi. Ungacha doʻkonda bekor qilsangiz, hech narsa olinmaydi.';
  }

  @override
  String get noteGrace =>
      'Imtiyozli davr mobaynida imkoniyatlar ishlashda davom etadi. Bekor qilish ilovada hech qachon toʻsilmaydi.';

  @override
  String get noteHold =>
      'Toʻlov oʻtguncha Premium toʻxtatib turiladi. Personajlaringiz va natijalaringiz saqlanadi.';

  @override
  String noteEnding(String date) {
    return 'Tarifingiz tugashi belgilangan. Imkoniyatlar $date gacha ishlaydi, soʻng Bepulga oʻtasiz. Istalgan vaqtda qayta obuna boʻlishingiz mumkin.';
  }

  @override
  String get trialExpiredTitle => 'Premium sinov muddatingiz tugadi';

  @override
  String get trialExpiredSub => 'Endi Bepul tarifdasiz';

  @override
  String get seePlans => 'Tariflarni koʻrish';

  @override
  String get currentPlanTitle => 'Joriy tarif';

  @override
  String get perMonthUnit => 'oyiga';

  @override
  String get planTaglineFree => 'Kuniga 5 daqiqa qoʻngʻiroq. Mutlaqo bepul.';

  @override
  String get bulletProCorrections => 'Ona tilingizga moslangan tuzatishlar';

  @override
  String get bulletFreeCall => 'Kuniga 5 daqiqa ovozli qoʻngʻiroq';

  @override
  String get bulletFreeCheck => 'Dastlabki 3 qo‘ng‘iroq uchun to‘liq tahlil';

  @override
  String get bulletFreeCharacter => 'Boshlash uchun 2 ta personaj';

  @override
  String get ctaTurnOnVideo => 'Videoni yoqish';

  @override
  String get noteCallLength =>
      'Premium: kuniga 15 daqiqa — shu vaqt ichida xohlagancha qo‘ng‘iroq qilishingiz mumkin.';

  @override
  String get paywallProTitle1 => 'Tungi soat 3da ham uygʻoq';

  @override
  String get paywallProTitle2 => 'koreys doʻstingiz';

  @override
  String get paywallLimitHeadline =>
      'Premium kuniga 15 daqiqa qo‘ng‘iroq beradi.';

  @override
  String get limitBannerCallTitle => 'Bugungi qoʻngʻiroq vaqti tugadi';

  @override
  String get limitBannerCallSub => 'Bepul tarifda kuniga 5 daqiqa qoʻngʻiroq';

  @override
  String get limitBannerCheckTitle => 'Bu bugungi tekshiruv edi';

  @override
  String get limitBannerCheckSub => 'Bepul tarifda kuniga bitta tekshiruv';

  @override
  String get bulletProCharactersForever =>
      'Sotib olgan personajlaringiz abadiy sizniki';

  @override
  String get paywallMaxTitle => 'Endi ularni koʻra olasiz.';

  @override
  String paywallTutorCompare(String price) {
    return 'Repetitor bilan bir soat \$25 turadi. Premium bir oyi $price turadi.';
  }

  @override
  String get planMonthly => 'Oylik';

  @override
  String get planAnnual => 'Yillik';

  @override
  String proMonthlyPriceLine(String price) {
    return 'Oyiga $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · oyiga $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'Oyiga $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'Yiliga $yearly · oyiga $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'Oyiga $price · doʻkonda istalgan vaqtda bekor qilish mumkin';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Oyiga $price · doʻkonda istalgan vaqtda bekor qilish mumkin';
  }

  @override
  String ctaCaptionMaxYearly(String price) {
    return 'Yiliga $price · doʻkonda istalgan vaqtda bekor qilish mumkin';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 kun bepul, keyin Oyiga $price · doʻkonda istalgan vaqtda bekor qilish mumkin';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Bekor qilinmaguncha avtomatik yangilanadi.';

  @override
  String get footerTerms => 'Shartlar';

  @override
  String get footerPrivacy => 'Maxfiylik';

  @override
  String get processingTitle => 'Xaridingiz tasdiqlanmoqda';

  @override
  String get processingSub => 'Bu odatda bir necha soniya davom etadi.';

  @override
  String get successProTitle => 'Siz Premium tarifdasiz.';

  @override
  String get successMaxTitle => 'Endi ularni koʻra olasiz.';

  @override
  String get successMaxSub =>
      'Videoqoʻngʻiroqlar yoqildi. Istalgan qoʻngʻiroqda video tugmasini bosing.';

  @override
  String get ctaStartAVideoCall => 'Videoqoʻngʻiroqni boshlash';

  @override
  String get ctaSeeYourSubscription => 'Obunangizni koʻrish';

  @override
  String successMaxCaption(String price) {
    return 'Bekor qilguningizcha har oy $price olinadi. Doʻkonda istalgan vaqtda boshqaring yoki bekor qiling.';
  }

  @override
  String get plansErrorTitle => 'Tariflarni yuklab boʻlmadi';

  @override
  String get plansErrorSub => 'Doʻkondan javob kelmadi.';

  @override
  String get ctaTryAgain => 'Qayta urinish';

  @override
  String get plansErrorCaption => 'Hech narsa olinmadi.';

  @override
  String get ctaKeepMax => 'Premium qolsin';

  @override
  String get winbackSkip => 'Oʻtkazib yuborish';

  @override
  String get winbackTitle => 'Premium tarifingiz tugadi';

  @override
  String get winbackSub =>
      'Endi Bepul tarifdasiz — kuniga 5 daqiqa qoʻngʻiroq.';

  @override
  String get winbackQuestion => 'Nega ketganingizni aytib berasizmi?';

  @override
  String get winbackReasonExpensive => 'Juda qimmat';

  @override
  String get winbackReasonUnused => 'Yetarlicha foydalanmadim';

  @override
  String get winbackReasonMissing => 'Kerakli funksiya yoʻq edi';

  @override
  String get winbackReasonOtherApp => 'Boshqa ilova topdim';

  @override
  String get winbackReasonElse => 'Boshqa sabab';

  @override
  String get ctaSend => 'Yuborish';

  @override
  String get ctaNotNow => 'Hozir emas';

  @override
  String get winbackCaption =>
      'Bu tarifingizni tiklamaydi. Doʻkonda qayta obuna boʻling.';

  @override
  String get ctaContinue => 'Davom etish';

  @override
  String get ctaClose => 'Yopish';

  @override
  String get ovRestoreSuccessTitle => 'Premium qaytdi';

  @override
  String get ovRestoreSuccessBody =>
      'Obunangizni topdik va uni bu qurilmada qayta yoqdik.';

  @override
  String get ovRestoreEmptyTitle => 'Tiklaydigan narsa yoʻq';

  @override
  String get ovRestoreEmptyBody =>
      'Bu doʻkon hisobiga faol obuna bogʻlanmagan.';

  @override
  String get ovRestoreOtherTitle => 'Bu tarif boshqa hisobga tegishli';

  @override
  String get ovRestoreOtherBody =>
      'Bu obuna boshqa BeaverTalk hisobida allaqachon faol.';

  @override
  String get ctaSignInThatAccount => 'Oʻsha hisobga kirish';

  @override
  String get ctaGetHelp => 'Yordam olish';

  @override
  String get ovCharacterOfferTitle => 'Premium uchun hali tayyor emasmisiz?';

  @override
  String get ovCharacterOfferBody =>
      'Bitta personajni tanlang va oʻzingizda qoldiring. Bir martalik xarid — obunasiz, yangilanishsiz.';

  @override
  String get rowOneCharacter => 'Bitta personaj';

  @override
  String rowFromPrice(String price) {
    return 'har biri $price';
  }

  @override
  String get rowYoursForever => 'Abadiy sizniki';

  @override
  String get rowNoRenewal => 'Yangilanish yoʻq';

  @override
  String get rowWorksOnFree => 'Bepul tarifda ishlaydi';

  @override
  String get rowYes => 'Ha';

  @override
  String get ctaSeeCharacters => 'Personajlarni koʻrish';

  @override
  String get ovNotEligibleTitle => 'Bekor qiladigan narsa yoʻq';

  @override
  String get ovNotEligibleBody =>
      'Siz Bepul tarifdasiz. Bu hisobda faol obuna yoʻq.';

  @override
  String get ovCancelDownsellTitle => 'Ketishdan oldin';

  @override
  String get ovCancelDownsellBody =>
      'Bekor qilish doʻkonda amalga oshiriladi. Bilib qoʻyishga arziydigan ikki narsa.';

  @override
  String get rowPayYearlyInstead => 'Buning oʻrniga yillik toʻlang';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'Oyiga $price';
  }

  @override
  String get rowCharactersYouBought => 'Sotib olgan personajlaringiz';

  @override
  String get rowProRunsUntil => 'Premium muddati';

  @override
  String get ctaSwitchToYearly => 'Yillikka oʻtish';

  @override
  String get ctaContinueToStore => 'Doʻkonga oʻtish';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Yillik toʻlab, $saved tejang';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Yillik tarif har oy to‘lagandan arzonroq tushadi.';

  @override
  String get rowYouSave => 'Tejaysiz';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Yillik';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Oylik, bir yil davomida';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Oylikka oʻtish';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Yillik tarifingiz $date gacha ishlaydi. Oylik toʻlov ertasi kuni boshlanadi.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Oylik toʻlov boshlanadi';

  @override
  String get rowMonthlyLabel => 'Oylik';

  @override
  String get rowYearlyWorkedOut => 'Yillik hisobda';

  @override
  String get ctaSwitchToMonthly => 'Oylikka oʻtish';

  @override
  String get ovRefundHelpTitle => 'Pulni qaytarishni doʻkon amalga oshiradi';

  @override
  String get ovRefundHelpBody =>
      'Biz oʻzimiz pul qaytara olmaymiz. Har bir soʻrovni doʻkon koʻrib chiqadi.';

  @override
  String get ctaGoToStore => 'Doʻkonga oʻtish';

  @override
  String get ovTrialEndingTitle => 'Sinov muddatingiz ertaga tugaydi';

  @override
  String get ovTrialEndingBody =>
      'Bekor qilmasangiz, Premium ishlashda davom etadi. Nima boʻlishini koʻring.';

  @override
  String get rowTrialEnds => 'Sinov tugaydi';

  @override
  String get rowFirstCharge => 'Birinchi toʻlov';

  @override
  String get rowThenMonthly => 'Soʻng har oy';

  @override
  String get ctaCancelInStore => 'Doʻkonda bekor qilish';

  @override
  String get ovTrialStartTitle => '7 kun Premium, bepul';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date gacha bepul. Soʻng oyiga $price, agar doʻkonda bekor qilmasangiz.';
  }

  @override
  String get ctaStart7Days => '7 kunni bepul boshlash';

  @override
  String get ovOtoTitle => 'Boshlashdan oldin yana bir narsa';

  @override
  String get ovOtoBody =>
      'Yaxshi tanlov. Yillik to‘lasangiz, o‘sha Premium arzonroq.';

  @override
  String get ovFailedDeclinedTitle => 'Kartangiz rad etildi';

  @override
  String get ovFailedDeclinedBody =>
      'Doʻkon toʻlovni ola olmadi. Hech narsa olinmadi.';

  @override
  String get ctaUpdatePaymentMethod => 'Toʻlov usulini yangilash';

  @override
  String get ovFailedCanceledTitle => 'Toʻlov bekor qilindi';

  @override
  String get ovFailedCanceledBody =>
      'Siz hali ham Bepul tarifdasiz. Hech narsa olinmadi.';

  @override
  String get ovFailedStoreTitle => 'Xatolik yuz berdi';

  @override
  String get ovFailedStoreBody =>
      'Doʻkonga ulanib boʻlmadi. Hech narsa olinmadi.';

  @override
  String get ovAlreadyTitle => 'Siz allaqachon Premium tarifdasiz';

  @override
  String get ovAlreadyBody =>
      'Bu doʻkon hisobida faol tarif bor. Sotib oladigan narsa yoʻq.';

  @override
  String get ctaSeeMySubscription => 'Obunamni koʻrish';

  @override
  String get subCancelTitle => 'Obunani bekor qilish';

  @override
  String subCancelBody(String date) {
    return 'Premium $date gacha ishlaydi. Soʻng Bepulga oʻtasiz.';
  }

  @override
  String get subWhatYouLose => 'Nimani yoʻqotasiz';

  @override
  String get benefitScoring => 'Talaffuz harfma-harf baholanadi';

  @override
  String get benefitEveryMetric => 'Har bir ko‘rsatkich, har bir gap';

  @override
  String get subPaymentTitle => 'Toʻlovni yangilash';

  @override
  String get subPaymentBody =>
      'Toʻlovni ola olmadik. Imtiyozli davrda Premium ishlashda davom etadi.';

  @override
  String get subHowToFix => 'Qanday tuzatish mumkin';

  @override
  String get fixStep1 => 'Doʻkonni oching va toʻlov usulingizni yangilang';

  @override
  String get fixStep2 => 'Qaytib keling — tarifingiz avtomatik davom etadi';

  @override
  String get fixStep3 => 'Hech narsa ikki marta olinmaydi';

  @override
  String get subResubTitle => 'Qayta obuna boʻlish';

  @override
  String subResubBody(String date) {
    return 'Premium $date kuni tugaydi. Avto-yangilanishni qayta yoqsangiz, hech narsa oʻzgarmaydi.';
  }

  @override
  String get subWhatYouKeep => 'Nima saqlanadi';

  @override
  String get ctaTurnItBackOn => 'Qayta yoqish';

  @override
  String get flTodayTitle => 'Bugungi qoʻngʻiroq vaqti tugadi';

  @override
  String get flTodayBody => 'Toʻxtagan joyingizdan davom eting — hoziroq.';

  @override
  String get flCheckTitle => 'Bu bugungi tekshiruv';

  @override
  String get flCheckBody =>
      'Bepul tarifda kuniga bitta tekshiruv bor. Premium to‘liq tahlilni beradi.';

  @override
  String flCaption(String price) {
    return 'Oyiga $price · istalgan vaqtda bekor qilish mumkin';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit dan $used ishlatildi';
  }

  @override
  String get ctaMaybeTomorrow => 'Balki ertaga';

  @override
  String get accountSection => 'Hisob';

  @override
  String get nicknameLabel => 'Taxallus';

  @override
  String get emailLabel => 'E-pochta';

  @override
  String get loginMethodLabel => 'Kirish usuli';

  @override
  String get joinedLabel => 'Roʻyxatdan oʻtgan sana';

  @override
  String get editNicknameTitle => 'Taxallusni tahrirlash';

  @override
  String get nicknameRule => '2–12 belgi. Harflar va raqamlar. Faqat inglizcha';

  @override
  String get ctaSave => 'Saqlash';

  @override
  String get subscriptionRow => 'Obuna';

  @override
  String get iapSuccessTitle => 'Xarid yakunlandi';

  @override
  String iapSuccessBody(String name) {
    return '$name avatari abadiy sizniki.\nChek tasdiqlangach darhol qoʻllanadi.';
  }

  @override
  String get ctaGoHome => 'Bosh sahifaga';

  @override
  String get ctaUseNow => 'Hozir ishlatish';

  @override
  String get iapFailTitle => 'Toʻlov amalga oshmadi';

  @override
  String get iapFailBody => 'Qayta urinib koʻrishingiz mumkin';

  @override
  String get paywallGuardTitle => 'Bepul foydalanishda davom etishingiz mumkin';

  @override
  String get paywallGuardBody =>
      'Kuniga 5 daqiqa qoʻngʻiroq avvalgidek qoladi.';

  @override
  String get ctaMaybeLater => 'Keyinroq';

  @override
  String get winbackOfferBadge => 'Birinchi oyga 50% chegirma';

  @override
  String get winbackOfferTitle => 'Yana xush kelibsiz';

  @override
  String get ctaGetHalfOff => '50% chegirma olish';

  @override
  String get iapCharacterSuccessTitle => 'Yangi doʻst qoʻshildi!';

  @override
  String get iapCharacterSuccessBody =>
      'Bu personaj abadiy sizniki — tarif oʻzgarsa ham qoladi, Xaridlarni tiklash esa uni istalgan qurilmada qaytaradi.';

  @override
  String get iapCharacterFailedBody =>
      'Xarid amalga oshmadi. Pul yechilmadi — qayta urinib koʻring.';

  @override
  String get noAccentDataTitle => 'Hozircha ohang ma\'lumotlari yo\'q';

  @override
  String get noAccentDataBody =>
      'Suhbatni davom ettiring, ohangingiz xususiyatlari to\'plana boradi.';

  @override
  String get noLevelYetTitle => 'Hozircha daraja yo\'q';

  @override
  String get noLevelYetBody =>
      'Birinchi qo\'ng\'iroqni yakunlasangiz darajangiz chiqadi.';

  @override
  String get noPronunciationDataTitle => 'Hozircha talaffuz yozuvlari yo\'q';

  @override
  String get noPronunciationDataBody =>
      'Qo\'ng\'iroqda aytgan gaplaringizdan talaffuzni tahlil qilamiz.';

  @override
  String get noCharacterNote => 'Hozircha qoldirilgan so\'z yo\'q';

  @override
  String get noPhonemesYet => 'Tahlil qilish uchun hozircha tovush yo\'q';

  @override
  String get noSentencesYet => 'Tahlil qilish uchun hozircha gap yo\'q';

  @override
  String get takeLevelTest => 'Daraja testini topshirish';

  @override
  String get playAgain => 'Qayta o\'ynash';

  @override
  String get difficultySlow => 'Sekin';

  @override
  String get difficultyNormal => 'Oddiy';

  @override
  String get difficultyFast => 'Tez';

  @override
  String get difficultyLabel => 'Murakkablik';

  @override
  String get connected => 'Ulandi';

  @override
  String get unlockedWithMax => 'Tarifingizga kiritilgan';

  @override
  String get fcEndedTitle => 'Bepul qo\'ng\'irog\'ingiz tugadi';

  @override
  String get fcEndedBody =>
      'Bepul qo\'ng\'iroqlar 5 daqiqagacha davom etadi\nUzoqroq suhbatlashish uchun obuna bo\'ling';

  @override
  String get ctaSubscribeKeepTalking =>
      'Obuna bo\'lib, suhbatni davom ettirish';

  @override
  String get kgTitle => 'Davom etamizmi?';

  @override
  String get kgBody =>
      'Qoʻngʻiroq qisqa boʻlaklarda davom etadi.\nHar safar yana soʻraymiz.';

  @override
  String get pcEndedTitleToday => 'Bugungi qo‘ng‘iroqni tugatamiz.';

  @override
  String get pcEndedBodyToday =>
      'Gaplashganlarimizni takrorlang va ertaga yana qo‘ng‘iroq qiling!';

  @override
  String get pcEndedTitle => 'Bu qo‘ng‘iroqni tugatamiz.';

  @override
  String get pcEndedBody =>
      'Gaplashganlarimizni takrorlang va yana qo‘ng‘iroq qiling!';

  @override
  String get ctaKeepTalking => 'Suhbatni davom ettirish';

  @override
  String get callModeSheetTitle => 'Qanday suhbatlashmoqchisiz?';

  @override
  String get callModeSheetSubtitle => 'Ushbu qo‘ng‘iroqqa darhol qo‘llanadi';

  @override
  String get callModeFreeTalk => 'Erkin suhbat';

  @override
  String get callModeFreeTalkDesc => 'Tuzatishlarsiz suhbatlashing';

  @override
  String get callModeStudy => 'O‘rganish';

  @override
  String get callModeStudyDesc => 'Bir vaqtda bitta iborani o‘rganing';

  @override
  String get callModeChange => 'Rejimni o‘zgartirish';

  @override
  String get callModeKeep => 'Hozir emas';

  @override
  String get callExitTitle => 'Qo‘ng‘iroq tugatilsinmi?';

  @override
  String get callExitSubtitle =>
      'Hozir tugatsangiz ham, gaplashgan vaqt bugungi hisobga kiradi';

  @override
  String get callExitKeep => 'Suhbatni davom ettirish';

  @override
  String get callExitConfirm => 'Qo‘ng‘iroqni tugatish';

  @override
  String get callMicMute => 'Ovozni o‘chirish';

  @override
  String get callMicUnmute => 'Ovozni yoqish';

  @override
  String get callPushToTalk => 'Gapirish uchun bosib turing';

  @override
  String get callFreeEndedTitle => 'Bepul qo‘ng‘irog‘ingiz tugadi';

  @override
  String get callFreeEndedCta => 'Obuna bo‘ling va suhbatni davom ettiring';

  @override
  String get callKeepGoingTitle => 'Davom etamizmi?';

  @override
  String get callKeepGoingSubtitle =>
      'Qo‘ng‘iroqlar 5 daqiqalik qismlarda davom etadi. Har safar qayta so‘raymiz.';

  @override
  String get articulationSelectedWord => 'Tanlangan so\'z';

  @override
  String get articulationYouSaid => 'Talaffuzingiz';

  @override
  String get articulationTargetSound => 'Maqsad';

  @override
  String get reportEntry => 'Shikoyat';

  @override
  String get reportTitle => 'Shikoyat';

  @override
  String get reportPrompt => 'Qanday muammo yuz berdi?';

  @override
  String get reportGuide =>
      'AI qahramonining qaysi gapi sizni bezovta qilganini ayting. Har bir shikoyatni ko\'rib chiqamiz.';

  @override
  String get reportReasonSexual => 'Jinsiy mazmun';

  @override
  String get reportReasonHate => 'Nafrat yoki kamsitish';

  @override
  String get reportReasonViolence => 'Zo\'ravonlik yoki tahdid';

  @override
  String get reportReasonSelfHarm => 'O\'ziga zarar yetkazishga undaydi';

  @override
  String get reportReasonMisinfo => 'Yolg\'on ma\'lumot';

  @override
  String get reportReasonOther => 'Boshqa muammo';

  @override
  String get reportDetailHint => 'Nima bo\'lganini yozing (ixtiyoriy)';

  @override
  String get reportSubmit => 'Shikoyat yuborish';

  @override
  String get reportDoneTitle => 'Shikoyatingiz qabul qilindi';

  @override
  String get reportDoneBody =>
      'Ko\'rib chiqamiz va zarur bo\'lsa chora ko\'ramiz. BeaverTalk xavfsizligiga yordam berganingiz uchun rahmat.';

  @override
  String get reportFailed => 'Shikoyat yuborilmadi. Qayta urinib ko\'ring.';

  @override
  String get hwTitle => 'Uyga vazifa';

  @override
  String get hwJoinCodeTitle => 'Sinf kodingizni kiriting';

  @override
  String get hwJoinCodeSubtitle => 'Bu oʻqituvchingiz bergan 6 belgili kod';

  @override
  String get hwJoinCodeLabel => 'Sinf kodi';

  @override
  String get hwJoinCodeHelp => 'Kodda katta-kichik harf farq qilmaydi';

  @override
  String get hwJoinConfirmTitle => 'Shu sinfmi?';

  @override
  String get hwJoinConfirmSubtitle =>
      'Agar boshqa boʻlsa, kodni qayta tekshiring';

  @override
  String get hwJoinFieldInstitution => 'Muassasa';

  @override
  String get hwJoinFieldTeacher => 'Oʻqituvchi';

  @override
  String get hwJoinFieldLearners => 'Oʻquvchilar';

  @override
  String get hwJoinFieldTerm => 'Davr';

  @override
  String get hwJoinConfirmNote =>
      'Sinf nomi oʻqituvchi yozgani kabi koʻrsatiladi. Biz uni tarjima qilmaymiz.';

  @override
  String get hwJoinConfirmYes => 'Ha, shu';

  @override
  String get hwJoinConfirmRetry => 'Kodni qayta kiritish';

  @override
  String get hwJoinProfileTitle => 'Sinfda qaysi ismdan foydalanasiz?';

  @override
  String get hwJoinProfileSubtitle =>
      'Oʻqituvchi buni sinf roʻyxati bilan solishtiradi';

  @override
  String get hwJoinNameLabel => 'Ism';

  @override
  String get hwJoinNameHelp => 'Ilovadagi ismingizdan farq qilishi mumkin';

  @override
  String get hwJoinStudentNoLabel => 'Talaba raqami (ixtiyoriy)';

  @override
  String get hwJoinStudentNoHelp =>
      'Oʻqituvchi roʻyxatni solishtirish uchun ishlatadi';

  @override
  String get hwJoinConsentTitle => 'Oʻqituvchingiz nimani koʻradi';

  @override
  String get hwJoinConsentSubtitle => 'Sinfga qoʻshilish uchun rozilik kerak';

  @override
  String get hwJoinConsentSharedHeading => 'Oʻqituvchi bilan ulashiladi';

  @override
  String get hwJoinConsentShared1 => 'Sinf nomi va talaba raqami';

  @override
  String get hwJoinConsentShared2 => 'Uyga vazifani bajarganingiz';

  @override
  String get hwJoinConsentShared3 => 'Oʻtgan va oʻtmagan gaplar';

  @override
  String get hwJoinConsentShared4 =>
      'Vazifa qoʻngʻirogʻining davomiyligi va xulosasi';

  @override
  String get hwJoinConsentNotSharedHeading => 'Ulashilmaydi';

  @override
  String get hwJoinConsentNotShared1 => 'E-pochta va telefon raqami';

  @override
  String get hwJoinConsentNotShared2 => 'Ilovadagi ism, profil va qahramon';

  @override
  String get hwJoinConsentNotShared3 => 'Fuqarolik va ona tili';

  @override
  String get hwJoinConsentNotShared4 =>
      'Sinfdan tashqari qoʻngʻiroqlar va oʻqish';

  @override
  String get hwJoinConsentNotShared5 => 'Obuna va toʻlov maʼlumotlari';

  @override
  String get hwJoinConsentAgree => 'Yuqoridagilarga roziman';

  @override
  String get hwJoinConsentCta => 'Rozi boʻlib qoʻshilish';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Siz $className sinfiga qoʻshildingiz';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count ta vazifa kutmoqda';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Hozircha vazifa yoʻq';

  @override
  String get hwJoinDoneNextDue => 'Keyingi muddat';

  @override
  String get hwJoinDoneRosterName => 'Sinfdagi ismingiz';

  @override
  String get hwJoinDoneCta => 'Vazifalarni koʻrish';

  @override
  String get hwJoinErrorNotFound => 'Bunday kod topilmadi';

  @override
  String get hwJoinErrorNotFoundBody =>
      'Iltimos, olti raqamni qayta tekshiring.';

  @override
  String get hwJoinErrorExpired => 'Bu kod muddati tugagan';

  @override
  String get hwJoinErrorExpiredBody => 'Oʻqituvchingizdan yangi kod soʻrang.';

  @override
  String get hwJoinErrorFull => 'Sinf toʻlgan';

  @override
  String get hwJoinErrorFullBody => 'Iltimos, oʻqituvchingizga xabar bering.';

  @override
  String get hwJoinFailed =>
      'Qoʻshilib boʻlmadi. Birozdan soʻng qayta urinib koʻring.';

  @override
  String get hwSectionInProgress => 'Bajarilmoqda';

  @override
  String get hwSectionUpcoming => 'Yaqinda';

  @override
  String get hwSectionDone => 'Bajarildi';

  @override
  String get hwLeaveClassLink => 'Sinfdan chiqish';

  @override
  String get hwListEmptyTitle => 'Hozircha uyga vazifa yoʻq';

  @override
  String get hwListEmptyBody => 'Oʻqituvchingiz bergach shu yerda koʻrinadi.';

  @override
  String get hwListFailed => 'Vazifalaringiz yuklanmadi.';

  @override
  String get hwRetry => 'Qayta urinish';

  @override
  String get hwBadgeDone => 'Bajarildi';

  @override
  String get hwBadgeOverdue => 'Topshirilmagan';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Topshirilmagan, $days kun kechikdi';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Muddati bugun';

  @override
  String get hwActivitySpeaking => 'Gapirish';

  @override
  String get hwActivityConversation => 'Suhbat';

  @override
  String get hwActivityWorkbook => 'Mashq daftari';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter-bob';
  }

  @override
  String get hwTaskSpeakingDesc => 'Talaffuz ballingizni tekshiring';

  @override
  String get hwTaskConversationDesc =>
      'Oʻrganganingizni haqiqiy suhbatda ishlating';

  @override
  String get hwConversationOnce =>
      'Suhbatni har bir uy vazifasi uchun bir marta bajarish mumkin.';

  @override
  String get hwTaskWorkbookDesc => 'Mashq daftariga yozib mashq qiling';

  @override
  String get hwCtaStudy => 'Boshlash';

  @override
  String get hwCtaResult => 'Natijani koʻrish';

  @override
  String get hwCtaDownload => 'Yuklab olish';

  @override
  String get hwSpeakingNoScore => 'Gapirish vazifasini hali bajarmadingiz';

  @override
  String get hwWorkbookUnavailable => 'Mashq daftari fayli hali mavjud emas.';

  @override
  String get hwDetailClosed => 'Bu vazifa yopilgan. Endi topshira olmaysiz.';

  @override
  String get hwLeaveTitle => 'Sinfdan chiqasizmi?';

  @override
  String get hwLeaveBody =>
      'Oʻqituvchingiz endi vazifa natijalaringizni koʻrmaydi.';

  @override
  String get hwLeaveConfirm => 'Chiqish';

  @override
  String get hwLeaveCancel => 'Qolish';

  @override
  String get hwLeaveFailed => 'Sinfdan chiqib boʻlmadi.';

  @override
  String get hwMyClass => 'Mening sinfim';

  @override
  String get hwClassEmptyTitle => 'Siz hech qanday sinfga qoʻshilmagansiz';

  @override
  String get hwClassEmptySubtitle => 'Oʻqituvchingiz bergan kodni kiriting';

  @override
  String get hwClassEmptyCta => 'Sinf kodini kiritish';

  @override
  String get hwClassContinueCta => 'Davom etish';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count ta vazifa muddati ertaga';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Sizda $count ta topshirilmagan vazifa bor';
  }

  @override
  String get hwSpeakingUnavailable => 'Bu vazifaning gaplari hali mavjud emas.';

  @override
  String get hwBadgeClosed => 'Yopiq';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total tadan $passed ta gap oʻtdi';
  }

  @override
  String get challengeFirstWord => 'Birinchi soʻz';

  @override
  String get challengeSeeAnalysis => 'Natijalarni koʻrish';

  @override
  String get challengePaused => 'Toʻxtatildi';

  @override
  String get challengePausedNote => 'Taymer va yozuv birga toʻxtadi.';

  @override
  String get challengeTimeLeft => 'Qolgan vaqt';

  @override
  String get challengeScoreLabel => 'Ball';

  @override
  String get challengeResume => 'Davom ettirish';

  @override
  String get challengeBlockedTitle => 'Kameradan foydalanib boʻlmaydi';

  @override
  String get challengeBlockedNote =>
      'Sozlamalarda kamera va mikrofonga ruxsatni yoqing.';

  @override
  String get challengeGoBack => 'Orqaga';

  @override
  String get challengeOpenSettings => 'Sozlamalarni ochish';

  @override
  String get saveDone => 'Galereyaga saqlandi';

  @override
  String get saveFailed => 'Saqlanmadi';

  @override
  String get saveDeniedNote => 'Suratlarga ruxsat kerak';

  @override
  String get callIncomingCallerFallback => 'Beaver ustoz';

  @override
  String get callIncomingHandle => 'Koreys tilida qoʻngʻiroq';

  @override
  String get callMissedTitle => 'Javobsiz qoʻngʻiroq';

  @override
  String get callMissedChannelDescription =>
      'Beaver dan javobsiz qoʻngʻiroq boʻlsa xabar beradi.';

  @override
  String callMissedBody(String name) {
    return '$name sizga qoʻngʻiroq qildi';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Qoʻngʻiroqlarni qabul qilish uchun bildirishnoma ruxsati kerak.';

  @override
  String get callNotifPermissionRequired =>
      'Sozlamalarda bildirishnomalarga ruxsat bering.';

  @override
  String get callHintLockedTitle =>
      'O‘rganish rejimida maslahatlar mavjud emas';

  @override
  String get wsTitle => 'Qiyin tovushlar';

  @override
  String get wsToList => 'Roʻyxatga';

  @override
  String get wsNext => 'Keyingi';

  @override
  String get wsRetry => 'Qayta urinish';

  @override
  String get wsDone => 'Tayyor';

  @override
  String get wsContinue => 'Davom etish';

  @override
  String get wsQuit => 'Chiqish';

  @override
  String get wsRetryLater => 'Iltimos, bir oz keyin qayta urinib koʻring.';

  @override
  String get wsMissingTitle => 'Bu tovush topilmadi';

  @override
  String get wsMissingBody => 'Roʻyxatdan yana tanlang.';

  @override
  String get wsListLoadFailed => 'Roʻyxat yuklanmadi';

  @override
  String get wsLessonLoadFailed => 'Mashgʻulot yuklanmadi';

  @override
  String get wsNationalTitle => 'Aksentingiz uchun qiyin tovushlar';

  @override
  String get wsNationalPending => 'Aksentingiz tahlil qilingach toʻldiramiz';

  @override
  String get wsNationalPicked => 'Aksent tahlilingiz asosida tanlandi';

  @override
  String get wsNationalEmptyBody =>
      'Yana bir necha qoʻngʻiroq qiling, aksentingizni tahlil qilamiz.';

  @override
  String get wsMineTitle => 'Mening qiyin tovushlarim';

  @override
  String get wsMineSubtitle =>
      'Soʻnggi qoʻngʻiroqlaringizda oʻlchangan tovushlar';

  @override
  String get wsMineEmptyBody =>
      'Qoʻngʻiroq qilib takrorlasangiz, qiyin tovushlar toʻplanadi.';

  @override
  String get wsNoDataYet => 'Hozircha maʼlumot yoʻq';

  @override
  String get wsGoToCall => 'Qoʻngʻiroqni boshlash';

  @override
  String get wsRule => 'Qoida';

  @override
  String get wsRecommended => 'Tavsiya etiladi';

  @override
  String get wsNotMeasured => 'Oʻlchanmagan';

  @override
  String get wsStepUnderstand => 'Tushunish';

  @override
  String get wsStepWords => 'Soʻzlar';

  @override
  String get wsStepSentence => 'Gap';

  @override
  String get wsStepTest => 'Test';

  @override
  String get wsQuitTitle => 'Mashqni toʻxtatamizmi?';

  @override
  String get wsQuitBody => 'Hozir chiqsangiz, bu mashq saqlanmaydi.';

  @override
  String get wsHowToSound => 'Tovushni qanday chiqarish kerak';

  @override
  String get wsPracticeWords => 'Soʻzlarni mashq qilish';

  @override
  String get wsPracticeSentence => 'Gapni mashq qilish';

  @override
  String get wsPracticeAgain => 'Yana bir marta';

  @override
  String get wsStartTest => 'Yakuniy testni topshirish';

  @override
  String get wsThisSentence => 'Bu gap';

  @override
  String get wsNoScoreNote => 'Bu bosqichda ball yoʻq. Erkin takrorlang.';

  @override
  String get wsListen => 'Diqqat bilan tinglang';

  @override
  String get wsSayNow => 'Endi siz aytib koʻring';

  @override
  String get wsPracticeDone => 'Mashq tugadi';

  @override
  String get wsPaused => 'Toʻxtatildi';

  @override
  String get wsAudioFailed =>
      'Audio yuklanmadi. Matnga qarab ovoz chiqarib oʻqing.';

  @override
  String get wsReadAloud => 'Pastdagi gapni ovoz chiqarib oʻqing';

  @override
  String get wsTapToStart => 'Boshlash uchun bosing';

  @override
  String get wsTapWhenDone => 'Tugatgach bosing';

  @override
  String get wsScoring => 'Baholanmoqda';

  @override
  String get wsMicFailed => 'Mikrofon ochilmadi.';

  @override
  String get wsMicPermissionBody =>
      'Bu testda ovoz chiqarib o‘qiladi, shuning uchun mikrofon kerak. Sozlamalarda mikrofonga ruxsatni yoqing.';

  @override
  String get wsNoSound => 'Hech narsa eshitilmadi. Yana aytamizmi?';

  @override
  String get wsScoreFailed =>
      'Baholash amalga oshmadi. Iltimos, qayta urinib koʻring.';

  @override
  String get wsSomethingWrong => 'Xatolik yuz berdi.';

  @override
  String get wsLearnDone => 'Mashgʻulot tugadi';

  @override
  String get wsRetest => 'Qayta test';

  @override
  String get wsFirstMeasure => 'Birinchi oʻlchov';

  @override
  String get wsFinalTest => 'Yakuniy test';

  @override
  String wsPoints(int score) {
    return '$score ball';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Oldin $score ball';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Maqsad $score ball';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Maqsad · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country aksenti';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count soʻz takrorlandi';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count boʻlak takrorlandi';
  }

  @override
  String get wsStartRecommended => 'Tavsiya etilgan tovushdan boshlash';

  @override
  String wsStartRecommendedWith(String label) {
    return '$label bilan boshlash';
  }

  @override
  String get wsPointsUnit => 'ball';

  @override
  String get wsEnterFromMypage => 'Qiyin tovushlarni mashq qilish';

  @override
  String wsGoalOnly(int score) {
    return 'Maqsad $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label tovushi';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Qoʻngʻiroqda yana uchrasa, shu shaklni eslang.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country soʻzlovchilari koʻp xato qiladigan tovushlar';
  }
}
