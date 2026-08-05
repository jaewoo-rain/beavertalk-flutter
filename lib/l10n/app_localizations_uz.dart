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
  String get review => 'Koʻrib chiqish';

  @override
  String get pronunciationChallenge => 'Talaffuz sinovi';

  @override
  String get newExpressions => 'Yangi iboralar';

  @override
  String get analysisResult => 'Tahlil natijasi';

  @override
  String get noNewExpressions => 'Bu suhbatda yangi ibora topilmadi.';

  @override
  String get practice => 'Mashq qilish';

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
  String get selectTime => 'Vaqtni tanlang';

  @override
  String get getStarted => 'Boshlash';

  @override
  String get permissionTitle => 'Qulay tajriba uchun\nruxsatlarni bering';

  @override
  String get permissionSubtitle =>
      'Xizmatdan foydalanish uchun kerakli ruxsatlar zarur.';

  @override
  String get permissionMicTitle => 'Mikrofon (majburiy)';

  @override
  String get permissionMicDesc =>
      'AI bilan ingliz tilida gaplashish uchun kerak.';

  @override
  String get permissionNotifTitle => 'Bildirishnomalar (ixtiyoriy)';

  @override
  String get permissionNotifDesc =>
      'Sizga oʻqish eslatmalari va qoʻngʻiroq jadvallarini yuboramiz.';

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
  String get navCalendar => 'Kalendar';

  @override
  String get navCall => 'Qoʻngʻiroq';

  @override
  String get navStats => 'Statistika';

  @override
  String get myPage => 'Mening sahifam';

  @override
  String get languageSaveFailed => 'Tilingizni saqlab boʻlmadi.';

  @override
  String get accountDeleteFailed => 'Hisobingizni oʻchirib boʻlmadi.';

  @override
  String get changeAvatar => 'Avatarni almashtirish';

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
  String get changePlan => 'Rejani almashtirish';

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
  String get keepUsingPro => 'Pro\'dan foydalanishda davom etish';

  @override
  String get proMembership => 'Pro aʼzolik';

  @override
  String get pricePerMonth => '\$12.9 / oy';

  @override
  String get benefitUnlimitedCalls => 'Cheksiz qoʻngʻiroqlar';

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
  String get challengeLoadingNote =>
      'Birinchi ishga tushirishda koreys nutq modeli (~82MB) yuklab olinmoqda.\nBiroz kuting.';

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
  String get callNow => 'Hozir qoʻngʻiroq qilish';

  @override
  String get pronunciation => 'Talaffuz';

  @override
  String get fluency => 'Ravonlik';

  @override
  String get rhythm => 'Ritm';

  @override
  String get analysisTimeout =>
      'Bu kutilganidan koʻproq vaqt olmoqda. Birozdan soʻng qayta urinib koʻring.';

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
  String get loginKakaoSignInFailed => 'Kakao orqali kirish amalga oshmadi.';

  @override
  String get loginContinueWithKakao => 'Kakao bilan davom etish';

  @override
  String get loginContinueWithGoogle => 'Google bilan davom etish';

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
  String subscriptionSwitchNote(String date) {
    return 'Pro imtiyozlaridan $date gacha foydalanishingiz mumkin, so\'ng tarifingiz avtomatik tarzda bepulga o\'tadi.';
  }

  @override
  String get freePlanCallLimit => 'Kuniga 1 qo\'ng\'iroq · 5 daqiqa chegara';

  @override
  String get freePlanBasicCharacters => 'Asosiy qahramonlar kiritilgan';

  @override
  String get availableForPurchase => 'Sotib olish mumkin';

  @override
  String get paymentsLoadError => 'To\'lovlar tarixini yuklab bo\'lmadi';

  @override
  String get noPayments => 'Hozircha to\'lovlar yo\'q';

  @override
  String get morePaymentsExist => 'Eski to\'lovlar hali ko\'rsatilmayapti';

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
  String get practicePronunciation => 'Talaffuzni mashq qilish';

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
  String get billingChangePlan => 'Tarifni oʻzgartirish';

  @override
  String get billingCompareAllPlans => 'Barcha tariflarni solishtirish';

  @override
  String get billingBuyACharacter => 'Personaj sotib olish';

  @override
  String get billingRestorePurchases => 'Xaridlarni tiklash';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max sinovi';

  @override
  String get freePlanPriceLine => '\$0.00 — kuniga bitta qoʻngʻiroq';

  @override
  String pricePerMonthLine(String amount) {
    return 'Oyiga $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date gacha bepul';
  }

  @override
  String get todaysCalls => 'Bugungi qoʻngʻiroqlar';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit tadan $used tasi ishlatildi';
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
  String get bannerGoUnlimitedTitle => 'Pro bilan cheksiz boʻling';

  @override
  String get bannerGoUnlimitedSub =>
      'Cheksiz qoʻngʻiroqlar · har biri 15 daqiqa · oyiga \$12.90';

  @override
  String get bannerMaxUpsellTitle => 'Max bilan videoni yoqing';

  @override
  String get bannerMaxUpsellSub => 'Yuzma-yuz qoʻngʻiroqlar · oyiga \$19.90';

  @override
  String get bannerAnnualSwitchTitle => 'Yillik tarifga oʻting';

  @override
  String get bannerAnnualSwitchSub => 'Yiliga \$159 · oyiga \$13.25';

  @override
  String get bannerPaymentFailedTitle => 'Toʻlovni olib boʻlmadi';

  @override
  String get bannerPaymentFailedSub =>
      'Pro saqlanishi uchun doʻkonda toʻlovni yangilang';

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
  String get noteFairUse =>
      'Cheksiz foydalanish adolatli foydalanish siyosatiga boʻysunadi.';

  @override
  String noteTrialEnds(String date) {
    return 'Sinov muddatingiz $date tugaydi. Ungacha doʻkonda bekor qilsangiz, hech narsa olinmaydi.';
  }

  @override
  String get noteGrace =>
      'Imtiyozli davr mobaynida imkoniyatlar ishlashda davom etadi. Bekor qilish ilovada hech qachon toʻsilmaydi.';

  @override
  String get noteHold =>
      'Toʻlov oʻtguncha Pro toʻxtatib turiladi. Personajlaringiz va natijalaringiz saqlanadi.';

  @override
  String noteEnding(String date) {
    return 'Tarifingiz tugashi belgilangan. Imkoniyatlar $date gacha ishlaydi, soʻng Bepulga oʻtasiz. Istalgan vaqtda qayta obuna boʻlishingiz mumkin.';
  }

  @override
  String get trialExpiredTitle => 'Max sinov muddatingiz tugadi';

  @override
  String get trialExpiredSub => 'Endi Bepul tarifdasiz';

  @override
  String get seePlans => 'Tariflarni koʻrish';

  @override
  String get currentPlanTitle => 'Joriy tarif';

  @override
  String get badgeRecommended => 'Tavsiya etiladi';

  @override
  String get perMonthUnit => 'oyiga';

  @override
  String get planTaglinePro => 'Cheksiz qoʻngʻiroqlar. Har biri 15 daqiqa.';

  @override
  String get planTaglineMax => 'Endi ularni koʻra olasiz.';

  @override
  String get planTaglineFree => 'Kuniga bitta qoʻngʻiroq. Mutlaqo bepul.';

  @override
  String get bulletProCalls => 'Istalgancha ovozli qoʻngʻiroqlar';

  @override
  String get bulletProLength => 'Har bir qoʻngʻiroq 15 daqiqa';

  @override
  String get bulletProScoring => 'Talaffuz harfma-harf baholanadi';

  @override
  String get bulletProCorrections => 'Ona tilingizga moslangan tuzatishlar';

  @override
  String get bulletProBeaverCalls =>
      'Beaver sizga birinchi boʻlib qoʻngʻiroq qiladi';

  @override
  String get bulletMaxVideo => 'Yuzma-yuz videoqoʻngʻiroqlar';

  @override
  String get bulletMaxEverything => 'Pro tarifidagi hamma narsa';

  @override
  String get bulletMaxCharacters => 'Barcha personajlar, cheksiz';

  @override
  String get bulletMaxStudyBook => 'Darajangizga mos oʻquv kitobi';

  @override
  String get bulletMaxWeeklyReport =>
      'Talaffuzingiz qanday oʻzgarayotgani haqida haftalik hisobot';

  @override
  String get bulletFreeCall => 'Kuniga bitta 5 daqiqalik ovozli qoʻngʻiroq';

  @override
  String get bulletFreeCheck => 'Kuniga bitta talaffuz tekshiruvi';

  @override
  String get bulletFreeAccent => 'Cheksiz aksent tekshiruvlari';

  @override
  String get bulletFreeCharacter => 'Boshlash uchun bitta personaj';

  @override
  String get ctaGoUnlimited => 'Cheksizga oʻtish';

  @override
  String get ctaTurnOnVideo => 'Videoni yoqish';

  @override
  String get noteCallLength => 'Har bir qoʻngʻiroq 15 daqiqa.';

  @override
  String get paywallProTitle1 => 'Tungi soat 3da ham uygʻoq';

  @override
  String get paywallProTitle2 => 'koreys doʻstingiz';

  @override
  String get paywallProSub =>
      'Cheksiz qoʻngʻiroqlar. Har biri 15 daqiqa. Yil davomida.';

  @override
  String get paywallLimitHeadline => 'Pro cheklovni olib tashlaydi.';

  @override
  String get limitBannerCallTitle => 'Bu bugungi qoʻngʻiroq edi';

  @override
  String get limitBannerCallSub => 'Bepul tarifda kuniga bitta qoʻngʻiroq';

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
  String get paywallMaxSub =>
      'Videoqoʻngʻiroqlar, barcha personajlar va darajangizga mos oʻquv kitobi.';

  @override
  String get planMonthly => 'Oylik';

  @override
  String get planAnnual => 'Yillik';

  @override
  String get proMonthlyPriceLine => 'Oyiga \$12.90';

  @override
  String get proAnnualPriceLine => '\$100.00 · oyiga \$8.33';

  @override
  String get maxMonthlyPriceLine => 'Oyiga \$19.90';

  @override
  String get maxAnnualPriceLine => 'Yiliga \$159.00 · oyiga \$13.25';

  @override
  String get ctaCaptionPro =>
      'Oyiga \$12.90 · doʻkonda istalgan vaqtda bekor qilish mumkin';

  @override
  String get ctaCaptionMax =>
      'Oyiga \$19.90 · doʻkonda istalgan vaqtda bekor qilish mumkin';

  @override
  String get footerTerms => 'Shartlar';

  @override
  String get footerPrivacy => 'Maxfiylik';

  @override
  String get noteMaxCharacters =>
      'Max ochgan personajlar obunangiz faol boʻlganda mavjud. Sotib olgan personajlaringiz sizniki boʻlib qoladi.';

  @override
  String get processingTitle => 'Xaridingiz tasdiqlanmoqda';

  @override
  String get processingSub => 'Bu odatda bir necha soniya davom etadi.';

  @override
  String get successProTitle => 'Siz Pro tarifdasiz.';

  @override
  String get successProSub => 'Cheksiz qoʻngʻiroqlar hoziroq boshlanadi.';

  @override
  String get successProBenefit1 =>
      'Istalgancha qoʻngʻiroq qiling — har biri 15 daqiqa';

  @override
  String get successProBenefit2 => 'Cheksiz talaffuz tekshiruvlari';

  @override
  String get successProBenefit3 =>
      'Barcha personajlar, qoʻshimcha bir martalik xaridlar';

  @override
  String get successMaxTitle => 'Endi ularni koʻra olasiz.';

  @override
  String get successMaxSub =>
      'Videoqoʻngʻiroqlar yoqildi. Istalgan qoʻngʻiroqda video tugmasini bosing.';

  @override
  String get successMaxBenefit1 => 'Yuzma-yuz videoqoʻngʻiroqlar';

  @override
  String get successMaxBenefit2 =>
      'Barcha personajlar, cheksiz va yangilari birinchi';

  @override
  String get successMaxBenefit3 => 'Darajangizga mos oʻquv kitobi';

  @override
  String get ctaStartACall => 'Qoʻngʻiroqni boshlash';

  @override
  String get ctaStartAVideoCall => 'Videoqoʻngʻiroqni boshlash';

  @override
  String get ctaSeeYourSubscription => 'Obunangizni koʻrish';

  @override
  String get successProCaption =>
      'Bekor qilguningizcha har oy \$12.90 olinadi. Doʻkonda istalgan vaqtda boshqaring yoki bekor qiling.';

  @override
  String get successMaxCaption =>
      'Bekor qilguningizcha har oy \$19.90 olinadi. Doʻkonda istalgan vaqtda boshqaring yoki bekor qiling.';

  @override
  String get plansErrorTitle => 'Tariflarni yuklab boʻlmadi';

  @override
  String get plansErrorSub => 'Doʻkondan javob kelmadi.';

  @override
  String get ctaTryAgain => 'Qayta urinish';

  @override
  String get plansErrorCaption => 'Hech narsa olinmadi.';

  @override
  String get changePlanTitle => 'Tarifni oʻzgartirish';

  @override
  String get moveToMaxTitle => 'Max tarifiga oʻtish';

  @override
  String get maxPriceShort => '\$19.90 / oy';

  @override
  String get moveToMaxCardSub =>
      'Yuzma-yuz videoqoʻngʻiroqlar · barcha personajlar · sizga mos oʻquv kitobi';

  @override
  String get whatHappensNow => 'Endi nima boʻladi';

  @override
  String get maxStartsLabel => 'Max boshlanadi';

  @override
  String get immediately => 'Darhol';

  @override
  String get unusedProTime => 'Ishlatilmagan Pro vaqti';

  @override
  String get creditedTowardMax => 'Max hisobiga oʻtkaziladi';

  @override
  String nextPaymentMaxValue(String date) {
    return '\$19.90 · $date';
  }

  @override
  String nextPaymentProValue(String date) {
    return '\$12.90 · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max tarifiga oʻtish';

  @override
  String get upgradeCaption =>
      'Yangi tarifingiz darhol boshlanadi. Ishlatilmagan Pro vaqti hisobga olinadi, ikki marta toʻlov olinmaydi.';

  @override
  String get moveToProTitle => 'Pro tarifiga oʻtish';

  @override
  String get moveToProSub =>
      'Bugun hech narsa oʻzgarmaydi. Max siz toʻlagan oy oxirigacha ishlaydi.';

  @override
  String get maxRunsUntil => 'Max muddati';

  @override
  String get proStarts => 'Pro boshlanadi';

  @override
  String get whatYouKeep => 'Nima saqlanadi';

  @override
  String get keepBenefitCalls =>
      'Cheksiz ovozli qoʻngʻiroqlar, har biri 15 daqiqa';

  @override
  String get keepBenefitCharacters =>
      'Sotib olgan personajlaringiz abadiy sizniki';

  @override
  String downgradeWarning(String date) {
    return 'Videoqoʻngʻiroqlar va faqat Max personajlari $date kuni oʻchiriladi.';
  }

  @override
  String get ctaSwitchToPro => 'Pro tarifiga oʻtish';

  @override
  String get ctaKeepMax => 'Max qolsin';

  @override
  String get winbackSkip => 'Oʻtkazib yuborish';

  @override
  String get winbackTitle => 'Pro tarifingiz tugadi';

  @override
  String get winbackSub => 'Endi Bepul tarifdasiz — kuniga bitta qoʻngʻiroq.';

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
  String get ovRestoreSuccessTitle => 'Pro qaytdi';

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
  String get ovCharacterOfferTitle => 'Pro uchun hali tayyor emasmisiz?';

  @override
  String get ovCharacterOfferBody =>
      'Bitta personajni tanlang va oʻzingizda qoldiring. Bir martalik xarid — obunasiz, yangilanishsiz.';

  @override
  String get rowOneCharacter => 'Bitta personaj';

  @override
  String get rowFromPrice => '\$5.00 dan boshlab';

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
  String get rowYearlyMonthEquiv => 'Oyiga \$8.33';

  @override
  String get rowCharactersYouBought => 'Sotib olgan personajlaringiz';

  @override
  String get rowProRunsUntil => 'Pro muddati';

  @override
  String get ctaSwitchToYearly => 'Yillikka oʻtish';

  @override
  String get ctaContinueToStore => 'Doʻkonga oʻtish';

  @override
  String get ovAnnualSwitchTitle => 'Yillik toʻlab, \$54.80 tejang';

  @override
  String get ovAnnualSwitchBody =>
      'Ikki oydan beri Pro tarifdasiz. Yillik tarif arzonroq chiqadi.';

  @override
  String get rowYouSave => 'Tejaysiz';

  @override
  String get amountSaved => '\$54.80';

  @override
  String get rowYearly => 'Yillik';

  @override
  String get amountYearly => '\$100.00';

  @override
  String get rowMonthlyForYear => 'Oylik, bir yil davomida';

  @override
  String get amountMonthlyForYear => '\$154.80';

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
      'Bekor qilmasangiz, Max ishlashda davom etadi. Nima boʻlishini koʻring.';

  @override
  String get rowTrialEnds => 'Sinov tugaydi';

  @override
  String get rowFirstCharge => 'Birinchi toʻlov';

  @override
  String get rowThenMonthly => 'Soʻng har oy';

  @override
  String get ctaCancelInStore => 'Doʻkonda bekor qilish';

  @override
  String get ovTrialStartTitle => '7 kun Max, bepul';

  @override
  String ovTrialStartBody(String date) {
    return '$date gacha bepul. Soʻng oyiga \$19.90, agar doʻkonda bekor qilmasangiz.';
  }

  @override
  String get ctaStart7Days => '7 kunni bepul boshlash';

  @override
  String get ovOtoTitle => 'Boshlashdan oldin yana bir narsa';

  @override
  String get ovOtoBody =>
      'Toʻgʻri qaror — cheksiz qoʻngʻiroqlar hoziroq yoniq. Yillik toʻlasangiz, xuddi shu Pro arzonroq boʻladi.';

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
  String get ovAlreadyTitle => 'Siz allaqachon Pro tarifdasiz';

  @override
  String get ovAlreadyBody =>
      'Bu doʻkon hisobida faol tarif bor. Sotib oladigan narsa yoʻq.';

  @override
  String get ctaSeeMySubscription => 'Obunamni koʻrish';

  @override
  String get subCancelTitle => 'Obunani bekor qilish';

  @override
  String subCancelBody(String date) {
    return 'Pro $date gacha ishlaydi. Soʻng Bepulga oʻtasiz.';
  }

  @override
  String get subWhatYouLose => 'Nimani yoʻqotasiz';

  @override
  String get benefitCalls15 => 'Cheksiz qoʻngʻiroqlar, har biri 15 daqiqa';

  @override
  String get benefitScoring => 'Talaffuz harfma-harf baholanadi';

  @override
  String get benefitEveryCharacter => 'Barcha personajlar, cheksiz';

  @override
  String get ctaKeepPro => 'Pro qolsin';

  @override
  String get subPaymentTitle => 'Toʻlovni yangilash';

  @override
  String get subPaymentBody =>
      'Toʻlovni ola olmadik. Imtiyozli davrda Pro ishlashda davom etadi.';

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
    return 'Pro $date kuni tugaydi. Avto-yangilanishni qayta yoqsangiz, hech narsa oʻzgarmaydi.';
  }

  @override
  String get subWhatYouKeep => 'Nima saqlanadi';

  @override
  String get ctaTurnItBackOn => 'Qayta yoqish';

  @override
  String get flTodayTitle => 'Bu bugungi qoʻngʻiroq';

  @override
  String get flTodayBody => 'Toʻxtagan joyingizdan davom eting — hoziroq.';

  @override
  String get flCheckTitle => 'Bu bugungi tekshiruv';

  @override
  String get flCheckBody =>
      'Bepul tarifda kuniga bitta tekshiruv. Pro uni cheksiz qiladi.';

  @override
  String get flBenefitCalls =>
      'Pro bilan cheksiz qoʻngʻiroqlar · har biri 15 daqiqa';

  @override
  String get flBenefitChecks => 'Pro bilan cheksiz talaffuz tekshiruvlari';

  @override
  String get flCaption => 'Oyiga \$12.90 · istalgan vaqtda bekor qilish mumkin';

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
  String get emailLabel => 'Email';

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
  String get subscriptionRow => 'Subscription';

  @override
  String get iapSuccessTitle => 'Purchase complete';

  @override
  String iapSuccessBody(String name) {
    return 'The $name avatar is yours forever.\nApplied as soon as the receipt clears.';
  }

  @override
  String get ctaGoHome => 'Home';

  @override
  String get ctaUseNow => 'Use it now';

  @override
  String get iapFailTitle => 'The payment didn\'t go through';

  @override
  String get iapFailBody => 'You can try again';

  @override
  String get paywallLeaveTitle => 'Hozir chiqsangiz, obuna boʻlmaysiz';

  @override
  String get paywallLeaveBody =>
      'Imkoniyatlar toʻlovdan soʻng darhol ochiladi. Mening sahifam orqali istalgan vaqtda qaytishingiz mumkin.';

  @override
  String get ctaKeepLooking => 'Koʻrishda davom etish';

  @override
  String get ctaLeaveAnyway => 'Baribir chiqish';

  @override
  String get iapCharacterSuccessTitle => 'Yangi doʻst qoʻshildi!';

  @override
  String get iapCharacterSuccessBody =>
      'Bu personaj abadiy sizniki — tarif oʻzgarsa ham qoladi, Xaridlarni tiklash esa uni istalgan qurilmada qaytaradi.';

  @override
  String get iapCharacterFailedBody =>
      'Xarid amalga oshmadi. Pul yechilmadi — qayta urinib koʻring.';

  @override
  String get unlockedWithMax => 'Max bilan mavjud';
}
