// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

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
  String get quickStart => 'Quick start';

  @override
  String get presetMorning => 'Morning routine';

  @override
  String get presetMorningSub => 'Weekdays 8:00';

  @override
  String get presetEvening => 'Evening wind-down';

  @override
  String get presetEveningSub => 'Every day 21:00';

  @override
  String get presetCustom => 'Custom';

  @override
  String get presetCustomSub => 'Your own';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× a week · $monthly calls a month';
  }

  @override
  String get alarmSummaryNone => 'Pick at least one day';

  @override
  String get partnerInUse => 'In use';

  @override
  String get partnerOwned => 'Owned';

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
    return 'Call #$count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'A word from $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Left by $name right after the call';
  }

  @override
  String newExpressionsCount(int count) {
    return 'New expressions $count';
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
  String get selectACountry => 'Davlatni tanlang';

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
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

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
  String get thisMonthPayment => 'This month\'s payment';

  @override
  String get filterAll => 'All';

  @override
  String get filterSubscription => 'Subscription';

  @override
  String get filterCharacter => 'Character';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get lastPayment => 'Last payment';

  @override
  String subscriptionSwitchNote(String date) {
    return 'You can keep using Pro benefits until $date, after which your plan switches to Free automatically.';
  }

  @override
  String get freePlanCallLimit => '1 call a day · 5 min limit';

  @override
  String get freePlanBasicCharacters => 'Basic characters included';

  @override
  String get availableForPurchase => 'Sotib olish mumkin';

  @override
  String get paymentsLoadError => 'Couldn\'t load payment history';

  @override
  String get noPayments => 'No payments yet';

  @override
  String get morePaymentsExist => 'Older payments aren\'t shown yet';

  @override
  String get undatedPayments => 'Undated';

  @override
  String get paymentLabelFallback => 'Payment';

  @override
  String learningPassed(int passed, int total) {
    return '$passed of $total sentences passed';
  }

  @override
  String get hardestSound => 'Hardest sound today';

  @override
  String get soundAccuracy => 'Accuracy by sound';

  @override
  String phonemeAttempts(int count) {
    return 'Per phoneme · $count attempts';
  }

  @override
  String get colSound => 'Sound';

  @override
  String get colAttempts => 'Tries';

  @override
  String get colCorrect => 'Right';

  @override
  String get colAccuracy => 'Accuracy';

  @override
  String get sentenceResults => 'Results by sentence';

  @override
  String viewAllSentences(int count) {
    return 'See all $count';
  }

  @override
  String get colSentence => 'Sentence';

  @override
  String get colPronunciation => 'Pron.';

  @override
  String get colFluency => 'Flu.';

  @override
  String get colRhythm => 'Rhy.';

  @override
  String recentSessions(int count) {
    return 'Last $count sessions';
  }

  @override
  String trendAverage(int score) {
    return 'Avg $score';
  }

  @override
  String get today => 'Today';

  @override
  String get colDate => 'Date';

  @override
  String get colSentences => 'Sentences';

  @override
  String get colScore => 'Score';

  @override
  String get colChange => 'Change';

  @override
  String dateToday(String date) {
    return '$date (today)';
  }
}
