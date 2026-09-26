// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get loginRequired => 'Жүйеге кіру қажет.';

  @override
  String get callWebNotSupported =>
      'Веб-нұсқада дауыстық қоңырау жұмыс істемейді. Қолданбаны пайдаланыңыз.';

  @override
  String get micPermissionRequiredForCall =>
      'Микрофонға рұқсат қажет. Қоңырау шалу үшін микрофонға рұқсат беріңіз.';

  @override
  String get callErrorGeneric => 'Қоңырау кезінде қате шықты.';

  @override
  String get callDailyLimit => 'Бүгінгі оқу уақыты таусылды.';

  @override
  String get callAlreadyInCall => 'Сіз қазір қоңырауда отырсыз.';

  @override
  String get callNetworkError => 'Желі қатесі шықты.';

  @override
  String get authInvalidCredentials =>
      'Электрондық пошта немесе құпия сөз дұрыс емес.';

  @override
  String get authEmailAlreadyRegistered => 'Бұл электрондық пошта тіркелген.';

  @override
  String get authConfirmEmailRequired =>
      'Поштаңызға жіберілген растауды аяқтаңыз.';

  @override
  String get authResetCodeSent => 'Растау кодын поштаңызға жібердік.';

  @override
  String get authResetCodeInvalid => 'Код дұрыс емес немесе мерзімі өткен.';

  @override
  String get authPasswordUpdated => 'Құпия сөз қалпына келтірілді.';

  @override
  String get authAppleTokenMissing => 'Apple кіру токенін алу мүмкін болмады.';

  @override
  String callEndedDuration(String duration) {
    return 'Қоңырау аяқталды $duration';
  }

  @override
  String get callRatingPrompt => 'Қоңырау қалай өтті?';

  @override
  String get callRatingBody =>
      'Бағалауыңыз келесі жолы жақсырақ сөйлесуге көмектеседі.';

  @override
  String get callRatingSubmit => 'Жіберу';

  @override
  String get callRatingSkip => 'Өткізіп жіберу';

  @override
  String get ratingBad => 'Жақсы емес';

  @override
  String get ratingOkay => 'Жаман емес';

  @override
  String get ratingGood => 'Жақсы';

  @override
  String get goHome => 'Басты бет';

  @override
  String get viewAnalysis => 'Талдауды көру';

  @override
  String get loadingShort => 'Жүктелуде…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Бағаны жіберу сәтсіз аяқталды: $message';
  }

  @override
  String get callInfoNotFound =>
      'Қоңырау туралы ақпарат табылмады, талдау өткізіп жіберілді.';

  @override
  String get tabRecords => 'Жазбалар';

  @override
  String get tabArchive => 'Мұрағат';

  @override
  String get callHistory => 'Қоңыраулар тарихы';

  @override
  String get conversationRecord => 'Әңгіме жазбасы';

  @override
  String get noCallRecords => 'Әзірге қоңырау жазбалары жоқ';

  @override
  String get noCallRecordsBody =>
      'AI-мен алғашқы қоңырауыңызды аяқтағаннан кейін,\nжазбаларыңыз осында пайда болады.';

  @override
  String get startCall => 'Қоңырау бастау';

  @override
  String get recordsLoadError => 'Жазбаларды жүктеу мүмкін болмады';

  @override
  String get tryAgainLater => 'Кейінірек қайталап көріңіз.';

  @override
  String get retry => 'Қайталау';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes мин $seconds сек';
  }

  @override
  String get scheduleManagement => 'Кесте';

  @override
  String get alarms => 'Дабылдар';

  @override
  String get alarmAdd => 'Оятқыш қосу';

  @override
  String get alarmEdit => 'Оятқышты өзгерту';

  @override
  String get alarmEveryDay => 'Күн сайын';

  @override
  String get alarmWeekdays => 'Жұмыс күндері';

  @override
  String get alarmWeekend => 'Демалыс күндері';

  @override
  String get alarmNoRepeat => 'Қайталанбайды';

  @override
  String get addSchedule => 'Кесте қосу';

  @override
  String get editSchedule => 'Кестені өзгерту';

  @override
  String get somethingWentWrong => 'Бірдеңе дұрыс болмады';

  @override
  String get alarmsLoadError => 'Дабылдарды жүктеу мүмкін болмады';

  @override
  String get charactersLoadError => 'Кейіпкерлерді жүктеу мүмкін болмады';

  @override
  String get noCharacters => 'Қолжетімді кейіпкерлер жоқ';

  @override
  String get close => 'Жабу';

  @override
  String get repeat => 'Қайталау';

  @override
  String get callPartner => 'Кейіпкер';

  @override
  String get alarmModeLearnSub => 'Бағдарлама тіркестерін жаттығу';

  @override
  String get alarmModeChatSub => 'Кез келген тақырыпта сөйлесу';

  @override
  String get quickStart => 'Жылдам бастау';

  @override
  String get presetMorning => 'Таңғы әдет';

  @override
  String get presetMorningSub => 'Жұмыс күндері 8:00';

  @override
  String get presetEvening => 'Кешкі қорытынды';

  @override
  String get presetEveningSub => 'Күн сайын 21:00';

  @override
  String get presetCustom => 'Өз таңдауым';

  @override
  String get presetCustomSub => 'Қалауыңша';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Аптасына $count× · айына $monthly қоңырау';
  }

  @override
  String get alarmSummaryNone => 'Кемінде бір күн таңдаңыз';

  @override
  String get partnerInUse => 'Қолданыста';

  @override
  String get partnerOwned => 'Бар';

  @override
  String get am => 'Таңғы';

  @override
  String get pm => 'Түскі';

  @override
  String get save => 'Сақтау';

  @override
  String get conversation => 'Әңгіме';

  @override
  String get newExpressions => 'Жаңа сөз тіркестері';

  @override
  String get analysisPrepNote => 'Бүгінгі қоңырау қаралып жатыр.';

  @override
  String get analysisPrepNoteHint => 'Жақында осында хабар пайда болады';

  @override
  String get analysisPrepTitle =>
      'Құндыз бүгінгі сөз тіркестерінен карта жасап жатыр';

  @override
  String get analysisPrepSub => 'Дайын болғанда дәл осында шығады.';

  @override
  String get analysisPrepStepSave => 'Сөйлесуді сақтау';

  @override
  String get analysisPrepStepCards => 'Сөз тіркесі карталарын жасау';

  @override
  String get analysisPrepStateDone => 'Дайын';

  @override
  String get analysisPrepStateWorking => 'Жүріп жатыр';

  @override
  String get analysisPrepStateWaiting => 'Күтуде';

  @override
  String get usedExpressions => 'Сіз қолданған тіркестер';

  @override
  String quizExpressionsCount(int count) {
    return 'Үйренген сөз тіркестері $count';
  }

  @override
  String get quizPassed => 'Дұрыс';

  @override
  String get quizFailed => 'Қайта қараңыз';

  @override
  String get quizPending => 'Келесі жолы жалғастырамыз';

  @override
  String get analysisResult => 'Талдау нәтижесі';

  @override
  String get noNewExpressions => 'Бұл әңгімеде жаңа сөз тіркестері жоқ.';

  @override
  String get practice => 'Жаттығу';

  @override
  String get analysisNativeLabel => 'Жергілікті';

  @override
  String recentScore(int score) {
    return 'Соңғы балл $score%';
  }

  @override
  String callSequence(int count) {
    return '$count-ші қоңырау';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name айтқан бір ауыз сөз';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Қоңыраудан кейін бірден $name қалдырды';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Жаңа тіркестер $count';
  }

  @override
  String get analysisLoadError => 'Талдау нәтижесін жүктеу мүмкін болмады.';

  @override
  String get standardAudioNotReady => 'Үлгі айтылым дыбысы әлі дайын емес.';

  @override
  String get standardAudioPlayError =>
      'Үлгі айтылым дыбысын ойнату мүмкін болмады.';

  @override
  String get selectNativeLanguage => 'Ана тіліңізді таңдаңыз';

  @override
  String get selectYourLanguage => 'Тіліңізді таңдаңыз';

  @override
  String get confirm => 'Растау';

  @override
  String get cancel => 'Бас тарту';

  @override
  String get micPermissionNeededTitle => 'Микрофонға рұқсат қажет';

  @override
  String get micPermissionNeededBody =>
      'AI-мен сөйлесу үшін микрофонға рұқсат беру қажет. Оны Баптауларда қосыңыз.';

  @override
  String get openSettings => 'Баптауларды ашу';

  @override
  String get connectionFailedTitle => 'Байланыс орнатылмады';

  @override
  String get connectionFailedBody =>
      'Желі байланысын тексеріп,\nқайта көріңіз.';

  @override
  String get checkout => 'Төлем жасау';

  @override
  String get pay => 'Төлеу';

  @override
  String get orderSummary => 'Тапсырыс жиынтығы';

  @override
  String get paymentMethod => 'Төлем әдісі';

  @override
  String get payMethodCard => 'Несие/дебет картасы';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Тентек Бобыр аватары';

  @override
  String get productTrait => 'Премиум кейіпкер · Мәңгі сіздікі';

  @override
  String get amountItemPrice => 'Тауар бағасы';

  @override
  String get amountDiscount => 'Жеңілдік';

  @override
  String get amountTotal => 'Барлығы';

  @override
  String get paymentCompleteTitle => 'Төлем аяқталды';

  @override
  String get paymentCompleteBody => 'Аватар жинағыңызға қосылды.';

  @override
  String get viewCollection => 'Жинақты көру';

  @override
  String get receiptItem => 'Тауар';

  @override
  String get receiptAmount => 'Сома';

  @override
  String get receiptMethod => 'Төлем әдісі';

  @override
  String get receiptDate => 'Күні';

  @override
  String get paymentFailedTitle => 'Төлем сәтсіз болды';

  @override
  String get paymentFailedBody => 'Төлеміңіз өңделмеді.\nҚайта көріңіз.';

  @override
  String get freeCallEndingTitle => 'Тегін қоңырауыңыз аяқталып барады';

  @override
  String get freeCallEndingBody => 'Бобырмен ұзағырақ сөйлесу үшін жазылыңыз.';

  @override
  String get subscribe => 'Жазылу';

  @override
  String get endCall => 'Қоңырауды аяқтау';

  @override
  String get callEnded => 'Қоңырау аяқталды.';

  @override
  String get connecting => 'Байланысуда…';

  @override
  String get connectingHint => 'Бұл әдетте 5 секундтан аз уақыт алады';

  @override
  String get callConnectFailed => 'Қоңырауды қосу мүмкін болмады.';

  @override
  String get saveSentenceFailed => 'Сөйлемді сақтау мүмкін болмады.';

  @override
  String get recordStartFailed => 'Жазуды бастау мүмкін болмады.';

  @override
  String get recordTooShort => 'Жазба тым қысқа болды. Қайта көріңіз.';

  @override
  String get gradingFailed => 'Бағалау сәтсіз аяқталды. Қайта көріңіз.';

  @override
  String get listenStandard => 'Үлгі айтылымды тыңдау';

  @override
  String get saveSentence => 'Сөйлемді сақтау';

  @override
  String get unsaveSentence => 'Сақталған сөйлемді өшіру';

  @override
  String get scoringPronunciation => 'Айтылымыңыз бағалануда…';

  @override
  String get analyzingByWord => 'Айтылымыңызды сөзбе-сөз тексеріп жатырмыз';

  @override
  String get analyzingTakingLonger => 'Бұл сәл ұзағырақ уақыт алуда';

  @override
  String get scanConnectionLost => 'Байланыс үзілді';

  @override
  String get noRecordingToPlay => 'Ойнатуға жазба жоқ.';

  @override
  String get myRecordingPlayError => 'Жазбаңызды ойнату мүмкін болмады.';

  @override
  String get next => 'Келесі';

  @override
  String get endLearning => 'Сабақты аяқтау';

  @override
  String get navCall => 'Қоңырау';

  @override
  String get homeCourseExpression => 'Өрнектер';

  @override
  String get homeCourseFreetalk => 'Әңгіме';

  @override
  String homeExpressionsLeft(int count) {
    return 'Әңгімеге $count өрнек қалды';
  }

  @override
  String get homeFreetalkNote => 'Үйренгеніңізді қолданып еркін сөйлесіңіз';

  @override
  String get homeTalkTitle => 'Бүгін не болды?';

  @override
  String get homeTalkNote => 'Еркін сөйлесіп, жол-жөнекей үйреніңіз.';

  @override
  String get homeModeLearn => 'Оқу';

  @override
  String get homeModeTalk => 'Сөйлесу';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'қатарынан $count күн',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Оқу күнтізбесі';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'күн қатарынан',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Үздік рекорд: $count күн',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Қоңырау уақыты';

  @override
  String get streakMetricLearned => 'Үйренген тіркестер';

  @override
  String get streakMetricWords => 'Айтылған сөздер';

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
      other: '$count мин',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'Бұл күні қоңырау болмады.';

  @override
  String get homeLevelPending => 'Деңгей белгісіз';

  @override
  String get homeNoLevelTitle => 'Сізде әзірге деңгей жоқ';

  @override
  String get homeNoLevelNote => 'Алғашқы қоңырауды аяқтасаңыз, деңгей шығады';

  @override
  String get homeCurriculumPendingBadge => 'Жақында';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language оқу бағдарламасы дайындалуда';
  }

  @override
  String get homeCurriculumPendingNote =>
      'Қоңырауларда жалпы сөз тіркестерін жаттықтырасыз';

  @override
  String get myPage => 'Менің бетім';

  @override
  String get languageSaveFailed => 'Тіліңізді сақтау мүмкін болмады.';

  @override
  String get accountDeleteFailed => 'Есептік жазбаңызды жою мүмкін болмады.';

  @override
  String get changeAvatar => 'Аватарды өзгерту';

  @override
  String get avatarUseNow => 'Қазір қолдану';

  @override
  String get avatarPurchaseFailed => 'Сатып алу аяқталмады';

  @override
  String avatarPromoTitle(int percent) {
    return 'Тек бүгін · $percent% жеңілдік';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time қалды';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days к. $time қалды';
  }

  @override
  String get avatarIntro =>
      'Дауыс пен қиындық деңгейі әңгімелесушіге қарай өзгереді.\nКейбіреулері төлемді қажет етуі мүмкін.';

  @override
  String myPartnersOwned(int count) {
    return 'Менің серіктерім · $count иелігімде';
  }

  @override
  String get limitedDiscount => 'Уақытша жеңілдік';

  @override
  String get available => 'Қолжетімді';

  @override
  String get inUse => 'Пайдалануда';

  @override
  String get owned => 'Иелігінде';

  @override
  String get noCharactersToShow => 'Көрсетуге кейіпкер жоқ';

  @override
  String get buy => 'Сатып алу';

  @override
  String get noSavedSentences =>
      'Әзірге сақталған сөйлемдер жоқ.\nӘңгіме жазбаларыңыздан сөйлемдерді бетбелгі етіп қойыңыз.';

  @override
  String get noAlarms => 'Әзірге дабылдар жоқ';

  @override
  String get noAlarmsBody =>
      'Тұрақты әдет қалыптастыру үшін\nоқу еске салғышын қосыңыз.';

  @override
  String get subscriptionManage => 'Жазылымды басқару';

  @override
  String get cancelSubscription => 'Жазылымнан бас тарту';

  @override
  String get benefitsInUse => 'Сіздің артықшылықтарыңыз';

  @override
  String get paymentInfo => 'Төлем ақпараты';

  @override
  String get nextBillingDate => 'Келесі есептеу күні';

  @override
  String get lostBenefitsTitle => 'Бас тартсаңыз жоғалтатын артықшылықтар';

  @override
  String get viewBillingHistory => 'Төлем тарихын көру';

  @override
  String pricePerMonth(String price) {
    return '$price / ай';
  }

  @override
  String get benefitDetailedAnalysis => 'Толық айтылым және грамматика талдауы';

  @override
  String get benefitAllCharacters => 'Барлық кейіпкерлерге қолжетімділік';

  @override
  String get benefitNoAds => 'Жарнамасыз';

  @override
  String get playSampleVoice => 'Үлгі дауысты ойнату';

  @override
  String get useThisAvatar => 'Осыны пайдалану';

  @override
  String get challengeTitle => 'Айтылым сынағы';

  @override
  String get challengeIntro =>
      'Аймақтағы әр картаны корей тілінде дұрыс айтып, тазартыңыз.\nМикрофон жоқ па? Экранды түртіп те ойнай аласыз.';

  @override
  String get challengeStart => 'Камера мен микрофонды қосу';

  @override
  String get challengePermissionNote =>
      'Алдыңғы камера мен микрофонға қолжетімділік қажет (міндетті емес).';

  @override
  String get challengeLoadingTitle => 'Жүктелуде…';

  @override
  String get challengeLoadingNote => 'Камера мен микрофон дайындалып жатыр.';

  @override
  String get challengeSttFallback =>
      'Дауыс тану қолжетімсіз болды, сондықтан түрту арқылы ойнадыңыз.';

  @override
  String get reasonTravelTitle => 'Саяхат кезінде сөйлесу';

  @override
  String get reasonTravelDesc => 'Жергілікті тұрғындармен сенімді сөйлесу';

  @override
  String get reasonCareerTitle => 'Жұмыс пен мансап';

  @override
  String get reasonCareerDesc => 'Іскерлік әңгіме';

  @override
  String get reasonExamTitle => 'Емтиханға дайындық';

  @override
  String get reasonExamDesc => 'Ауызша емтихандарға дайындалыңыз';

  @override
  String get reasonDailyTitle => 'Күнделікті әңгіме';

  @override
  String get reasonDailyDesc => 'Күнделікті қолданатын сөз тіркестері';

  @override
  String get reasonFriendsTitle => 'Шетелдік достар табу';

  @override
  String get reasonFriendsDesc => 'Табиғи әңгіме';

  @override
  String get reasonBrainTitle => 'Ми белсенділігі';

  @override
  String get reasonBrainDesc => 'Есте сақтау мен зейінді жақсартыңыз';

  @override
  String get challengeRecordToggle => 'Бұл ойынды жазу';

  @override
  String get challengeRecordHint =>
      'Ойыныңыздың бейнесін бөлісу үшін сақтайды (дыбыссыз).';

  @override
  String get settingsSection => 'Баптаулар';

  @override
  String get paymentSection => 'Төлем';

  @override
  String get supportSection => 'Қолдау';

  @override
  String get userLanguage => 'Пайдаланушы тілі';

  @override
  String get learningLanguage => 'Үйренетін тіл';

  @override
  String get learningLanguageKorean => 'Корей тілі';

  @override
  String get notificationLabel => 'Хабарландыру';

  @override
  String get currentPlan => 'Ағымдағы жоспар';

  @override
  String get paymentHistory => 'Төлем тарихы';

  @override
  String get contactUs => 'Бізбен байланысу';

  @override
  String get termsOfService => 'Пайдалану шарттары';

  @override
  String get privacyPolicy => 'Құпиялылық саясаты';

  @override
  String get logOut => 'Шығу';

  @override
  String get deleteAccount => 'Есептік жазбаны жою';

  @override
  String get deleteAccountTitle => 'Есептік жазбаны жоясыз ба?';

  @override
  String get deleteAccountBody =>
      'Бұл әрекет есептік жазбаңыз бен деректеріңізді біржола жояды және қайтарылмайды.';

  @override
  String get delete => 'Жою';

  @override
  String get share => 'Бөлісу';

  @override
  String get accentSoundsLike => 'Сіздің корей акцентіңіз мынандай естіледі';

  @override
  String accentShareText(String country) {
    return 'BeaverTalk-пен корей тілін үйреніп жүрмін — корей тіліндегі екпінім осындай естіледі: $country! 🦫 Өз екпініңді анықта да, менімен бірге үйрен: https://beavertalk.im';
  }

  @override
  String get hintLabel => 'Кеңес';

  @override
  String get nextHint => 'Келесі кеңес';

  @override
  String get translateLabel => 'Аудару';

  @override
  String get startRecording => 'Жазуды бастау';

  @override
  String get stopRecording => 'Жазуды тоқтату';

  @override
  String get back => 'Артқа';

  @override
  String get onboardingNameTitle => 'Сізді қалай атайық?';

  @override
  String get onboardingNameSubtitle => 'AI тьютор атыңызды есте сақтайды.';

  @override
  String get nameLabel => 'Атыңыз';

  @override
  String get nameHint => 'Атыңызды енгізіңіз';

  @override
  String get nameHelper =>
      'Бұл шын атыңыз болмауы да мүмкін — лақап ат та жарайды.';

  @override
  String get continueLabel => 'Жалғастыру';

  @override
  String get onboardingDoneTitle => 'Бобыр қоңырауыңызды күтуде';

  @override
  String get onboardingDoneSubtitle => 'Дәл қазір қоңырау бастаңыз';

  @override
  String get home => 'Басты бет';

  @override
  String get onboardingLevelTestCta => 'Деңгей тестін тапсыру';

  @override
  String get pronunciation => 'Айтылым';

  @override
  String get fluency => 'Еркіндік';

  @override
  String get rhythm => 'Ырғақ';

  @override
  String get analysisFailed => 'Әңгімені талдай алмадық. Қайта көріңіз.';

  @override
  String get analyzingConversation => 'Әңгімеңіз талдануда…';

  @override
  String get analyzingSubtitle => 'Бұл бір сәтке ғана созылады';

  @override
  String get tryAgain => 'Қайта көру';

  @override
  String get nativeLabel => 'Ана тілі';

  @override
  String get meLabel => 'Мен';

  @override
  String get pronunciationPlayError => 'Айтылым дыбысын ойнату мүмкін болмады.';

  @override
  String get savedExpressionsLoadError =>
      'Сақталған сөз тіркестеріңізді жүктеу мүмкін болмады.';

  @override
  String get mySavedExpressions => 'Менің сақталған сөз тіркестерім';

  @override
  String get avatarTraits => 'Жылы · Байсалды · Жұмсақ';

  @override
  String get priceFree => 'Тегін';

  @override
  String get loginGoogleTokenError => 'Google кіру токенін алу мүмкін болмады.';

  @override
  String get loginGoogleSignInFailed => 'Google арқылы кіру сәтсіз аяқталды.';

  @override
  String get loginAppleSignInFailed => 'Apple арқылы кіру сәтсіз аяқталды.';

  @override
  String get loginFacebookSignInFailed =>
      'Facebook арқылы кіру сәтсіз аяқталды.';

  @override
  String get loginKakaoSignInFailed => 'Kakao арқылы кіру сәтсіз аяқталды.';

  @override
  String get loginContinueWithKakao => 'Kakao арқылы жалғастыру';

  @override
  String get loginContinueWithGoogle => 'Google арқылы жалғастыру';

  @override
  String get loginContinueWithFacebook => 'Facebook арқылы жалғастыру';

  @override
  String get loginContinueWithApple => 'Apple арқылы жалғастыру';

  @override
  String get loginContinueWithEmail => 'Электрондық пошта арқылы жалғастыру';

  @override
  String get loginOrDivider => 'немесе';

  @override
  String get loginNoAccount => 'Есептік жазбаңыз жоқ па?';

  @override
  String get signUp => 'Тіркелу';

  @override
  String get loginTermsNoticePrefix => 'Жалғастыру арқылы сіз біздің ';

  @override
  String get loginTermsNoticeAnd => ' және ';

  @override
  String get loginTermsNoticeSuffix => ' шарттарымен келісім бересіз.';

  @override
  String get loginLogIn => 'Кіру';

  @override
  String get fieldEmailLabel => 'Электрондық пошта';

  @override
  String get emailHint => 'Электрондық поштаңызды енгізіңіз';

  @override
  String get fieldPasswordLabel => 'Құпия сөз';

  @override
  String get passwordHint => 'Құпия сөзіңізді енгізіңіз';

  @override
  String get loginRememberMe => 'Мені есте сақтау';

  @override
  String get loginForgotPassword => 'Құпия сөзді ұмыттыңыз ба?';

  @override
  String get loginLoggingIn => 'Кіру жүргізілуде...';

  @override
  String get passwordLengthError => 'Құпия сөз 8–16 таңбадан тұруы керек.';

  @override
  String get passwordsDoNotMatch => 'Құпия сөздер сәйкес келмейді.';

  @override
  String get signupCheckInput => 'Енгізген деректеріңізді тексеріңіз.';

  @override
  String get fieldConfirmPasswordLabel => 'Құпия сөзді растау';

  @override
  String get confirmPasswordHint => 'Құпия сөзіңізді қайта енгізіңіз';

  @override
  String get signupSigningUp => 'Тіркелу жүргізілуде...';

  @override
  String get signupHaveAccount => 'Есептік жазбаңыз бар ма?';

  @override
  String get passwordMethodEmailRequired => 'Электрондық поштаңызды енгізіңіз';

  @override
  String get passwordResetTitle => 'Құпия сөзді қалпына келтіру';

  @override
  String get passwordMethodDescription =>
      'Құпия сөзді қалпына келтіру кодын алғыңыз келетін электрондық пошта мекенжайын енгізіңіз.';

  @override
  String get emailAddressHint => 'Электрондық пошта мекенжайы';

  @override
  String get passwordMethodSending => 'Жіберілуде...';

  @override
  String get passwordMethodSendEmail => 'Хат жіберу';

  @override
  String get passwordCodeTitle => 'Кодты енгізіңіз';

  @override
  String get passwordCodeDescription =>
      'Электрондық поштаңызға қалпына келтіру коды жіберілді. Жалғастыру үшін оны енгізіңіз.';

  @override
  String get passwordCodeNoCode => 'Код келмеді ме?';

  @override
  String get passwordCodeResend => 'Кодты қайта жіберу';

  @override
  String get passwordCodeVerifying => 'Тексерілуде...';

  @override
  String get passwordNewTitle => 'Жаңа құпия сөз';

  @override
  String get passwordNewDescription =>
      'Есептік жазбаңыз үшін жаңа құпия сөз орнатыңыз.';

  @override
  String get fieldNewPasswordLabel => 'Жаңа құпия сөз';

  @override
  String get newPasswordHint => 'Жаңа құпия сөзіңізді енгізіңіз';

  @override
  String get fieldConfirmNewPasswordLabel => 'Жаңа құпия сөзді растау';

  @override
  String get confirmNewPasswordHint => 'Жаңа құпия сөзіңізді қайта енгізіңіз';

  @override
  String get passwordNewSubmitting => 'Жіберілуде...';

  @override
  String get passwordNewSubmit => 'Жіберу';

  @override
  String get passwordCompleteTitle => 'Құпия сөз қалпына келтірілді';

  @override
  String get passwordCompleteBody =>
      'Құпия сөзіңіз қалпына келтірілді. Жалғастыру үшін жаңа құпия сөзіңізбен кіріңіз.';

  @override
  String get termsTitle => 'Пайдалану шарттары';

  @override
  String get privacyTitle => 'Құпиялылық саясаты';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email үшін жаңа құпия сөз орнатыңыз.';
  }

  @override
  String get selectComplete => 'Дайын';

  @override
  String get onboardingLanguageTitle => 'Сіздің ана тіліңіз қандай?';

  @override
  String get onboardingReasonTitle => 'Сіз неге тіл үйреніп жатырсыз?';

  @override
  String get onboardingReasonSubtitle =>
      'Біз оқуыңызды мақсаттарыңызға сай бейімдейміз.';

  @override
  String get savingLabel => 'Сақталуда...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Осы айдағы төлем';

  @override
  String get filterAll => 'Барлығы';

  @override
  String get filterSubscription => 'Жазылым';

  @override
  String get filterCharacter => 'Кейіпкер';

  @override
  String get statusCompleted => 'Аяқталды';

  @override
  String get lastPayment => 'Соңғы төлем';

  @override
  String get freePlanCallLimit => 'Күніне 5 минут қоңырау';

  @override
  String get freePlanBasicCharacters => 'Негізгі кейіпкерлер кіреді';

  @override
  String get availableForPurchase => 'Сатып алуға болады';

  @override
  String get paymentsLoadError => 'Төлем тарихын жүктеу мүмкін болмады';

  @override
  String get noPayments => 'Әзірге төлем жоқ';

  @override
  String get morePaymentsExist => 'Ескі төлемдер әлі көрсетілмейді';

  @override
  String get undatedPayments => 'Күні жоқ';

  @override
  String get paymentLabelFallback => 'Төлем';

  @override
  String learningPassed(int passed, int total) {
    return '$total сөйлемнің $passed өтті';
  }

  @override
  String get hardestSound => 'Бүгінгі ең қиын дыбыс';

  @override
  String get soundAccuracy => 'Дыбыс бойынша дәлдік';

  @override
  String phonemeAttempts(int count) {
    return 'Фонема бойынша · $count әрекет';
  }

  @override
  String get colSound => 'Дыбыс';

  @override
  String get colAttempts => 'Әрек.';

  @override
  String get colCorrect => 'Дұрыс';

  @override
  String get colAccuracy => 'Дәлдік';

  @override
  String get sentenceResults => 'Сөйлем бойынша нәтиже';

  @override
  String viewAllSentences(int count) {
    return '$count барлығын көру';
  }

  @override
  String get colSentence => 'Сөйлем';

  @override
  String get colPronunciation => 'Айтыл.';

  @override
  String get colFluency => 'Еркін.';

  @override
  String get colRhythm => 'Ырғақ';

  @override
  String recentSessions(int count) {
    return 'Соңғы $count сеанс';
  }

  @override
  String trendAverage(int score) {
    return 'Орт. $score';
  }

  @override
  String get today => 'Бүгін';

  @override
  String get colDate => 'Күні';

  @override
  String get colSentences => 'Сөйлем';

  @override
  String get colScore => 'Ұпай';

  @override
  String get colChange => 'Өзг.';

  @override
  String dateToday(String date) {
    return '$date (бүгін)';
  }

  @override
  String get accentAnalysis => 'Екпін талдауы';

  @override
  String get overallLevel => 'Жалпы деңгей';

  @override
  String get overallLevelSubtitle => 'Лексика · Грамматика · Тіркестер';

  @override
  String get pronunciationAnalysis => 'Айтылым талдауы';

  @override
  String get recentSessionsAverage => 'Соңғы 10 сессия орташасы';

  @override
  String levelStage(int stage) {
    return '$stage-деңгей';
  }

  @override
  String topPercent(int percent) {
    return 'Үздік $percent%';
  }

  @override
  String get allLearnersBasis => 'Барлық оқушы ішінде';

  @override
  String aheadOfLearners(int percent) {
    return 'Сіз оқушылардың $percent%-нан оздыңыз';
  }

  @override
  String get retakeLevelTest => 'Деңгей тестін қайта тапсыру';

  @override
  String get levelTestOncePerDay =>
      'Деңгей тестін күніне бір рет тапсыруға болады. Ертең қайта көріңіз.';

  @override
  String get levelRetakeTitle => 'Деңгей тестін қайта тапсырасыз ба?';

  @override
  String get levelRetakeBody =>
      'Қайта тапсырсаңыз, үлгеріміңіз сол деңгейдің бірінші сабағына қайтады — деңгей бірдей шықса да. Үйренген тіркестер мен қоңырау тарихы сақталады.';

  @override
  String get levelRetakeKeep => 'Үлгерімді сақтау';

  @override
  String get levelRetakeConfirm => 'Қайта тапсыру';

  @override
  String get practicePronunciation => 'Айтылымды жаттықтыру';

  @override
  String get priceChangedTitle => 'Баға өзгерді';

  @override
  String priceChangedBody(String price) {
    return 'Бұл тауар енді $price тұрады. Жалғастырасыз ба?';
  }

  @override
  String get billingGroupPlanPurchases => 'Жоспар және сатып алулар';

  @override
  String get billingGroupInTheStore => 'Дүкенде';

  @override
  String get billingCompareAllPlans => 'Жоспарларды салыстыру';

  @override
  String get billingBuyACharacter => 'Кейіпкер сатып алу';

  @override
  String get billingRestorePurchases => 'Сатып алуларды қалпына келтіру';

  @override
  String get billingRedeemCode => 'Кодты пайдалану';

  @override
  String get billingPaymentHistory => 'Төлем тарихы';

  @override
  String get billingManageInTheStore => 'Дүкенде басқару';

  @override
  String get billingRefundHelp => 'Қайтарым бойынша көмек';

  @override
  String get billingCancelSubscription => 'Жазылымнан бас тарту';

  @override
  String get billingResubscribe => 'Қайта жазылу';

  @override
  String get badgeCurrent => 'Ағымдағы';

  @override
  String get badgeTrial => 'Сынақ';

  @override
  String get badgeRenewing => 'Жаңартылады';

  @override
  String get badgePastDue => 'Төлем кешікті';

  @override
  String get badgePaused => 'Кідіртілді';

  @override
  String get badgeCanceling => 'Тоқтатылуда';

  @override
  String get subscriptionTitle => 'Жазылым';

  @override
  String get plansTitle => 'Жоспарлар';

  @override
  String get planFree => 'Тегін';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Күніне 15 минут бейне қоңырау';

  @override
  String get premiumBulletAnalysis => 'Айтылымды толық талдау';

  @override
  String get premiumBulletWeakSounds =>
      'Тіліңізге сай қиын дыбыстарды жаттықтыру';

  @override
  String get noteCharactersSeparate =>
      'Кейіпкерлер бөлек сатылады. Сатып алғандарыңыз сіздікі болып қалады.';

  @override
  String get ctaGetPremium => 'Premium алу';

  @override
  String get planMaxTrial => 'Premium сынағы';

  @override
  String get freePlanPriceLine => '\$0.00 — күніне 5 минут қоңырау';

  @override
  String pricePerMonthLine(String amount) {
    return 'Айына $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date дейін тегін';
  }

  @override
  String get todaysCalls => 'Бүгінгі қоңырау уақыты';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit минуттың $used минуты қолданылды';
  }

  @override
  String get firstPaymentLabel => 'Алғашқы төлем';

  @override
  String get nextPaymentLabel => 'Келесі төлем';

  @override
  String get retryingUntilLabel => 'Қайталау мерзімі';

  @override
  String get pausedSinceLabel => 'Кідіртілген күні';

  @override
  String planEndsLabel(String plan) {
    return '$plan аяқталады';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium арқылы бетпе-бет сөйлесіңіз';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Бейне қоңырау · күніне 15 минут · айына $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Жылдық жоспарға өту';

  @override
  String get bannerPaymentFailedTitle => 'Төлемді алу мүмкін болмады';

  @override
  String get bannerPaymentFailedSub =>
      'Premium-ды сақтау үшін дүкенде төлемді жаңартыңыз';

  @override
  String get bannerPausedTitle => 'Жоспарыңыз кідіртілді';

  @override
  String get bannerPausedSub => 'Төлем өтпеді';

  @override
  String get noteRestoreHint =>
      'Басқа құрылғыда жазылып қойдыңыз ба? Қалпына келтіру оны осы құрылғыға қайтарады.';

  @override
  String get noteStoreHandled =>
      'Төлем әдісі, жоспар өзгерту және бас тарту дүкен арқылы жүзеге асады.';

  @override
  String noteTrialEnds(String date) {
    return 'Сынағыңыз $date аяқталады. Оған дейін дүкенде бас тартсаңыз, ештеңе алынбайды.';
  }

  @override
  String get noteGrace =>
      'Жеңілдік кезеңінде артықшылықтар жалғаса береді. Бас тарту қолданбада ешқашан бөгелмейді.';

  @override
  String get noteHold =>
      'Төлем өткенше Premium кідіртіледі. Кейіпкерлеріңіз бен үлгеріміңіз аман.';

  @override
  String noteEnding(String date) {
    return 'Жоспарыңыз аяқталуға қойылған. Артықшылықтар $date дейін жалғасады, содан кейін Тегінге өтесіз. Кез келген уақытта қайта жазыла аласыз.';
  }

  @override
  String get trialExpiredTitle => 'Premium сынағыңыз аяқталды';

  @override
  String get trialExpiredSub => 'Сіз қазір Тегін жоспардасыз';

  @override
  String get seePlans => 'Жоспарларды көру';

  @override
  String get currentPlanTitle => 'Ағымдағы жоспар';

  @override
  String get perMonthUnit => 'айына';

  @override
  String get planTaglineMax => 'Енді оларды көре аласыз.';

  @override
  String get planTaglineFree => 'Күніне 5 минут қоңырау. Тегін.';

  @override
  String get bulletProCorrections => 'Ана тіліңізге бейімделген түзетулер';

  @override
  String get bulletFreeCall => 'Күніне 5 минут дауыстық қоңырау';

  @override
  String get bulletFreeCheck => 'Алғашқы 3 қоңырауға толық талдау';

  @override
  String get bulletFreeCharacter => 'Бастауға 2 кейіпкер';

  @override
  String get ctaTurnOnVideo => 'Бейнені қосу';

  @override
  String get noteCallLength =>
      'Premium: күніне 15 минут — осы уақыт ішінде қалағаныңызша қоңырау шала аласыз.';

  @override
  String get paywallProTitle1 => 'Түнгі 3-те де ояу жүретін';

  @override
  String get paywallProTitle2 => 'кәріс досыңыз';

  @override
  String get paywallLimitHeadline => 'Premium күніне 15 минут қоңырау береді.';

  @override
  String get limitBannerCallTitle => 'Бүгінгі қоңырау уақыты бітті';

  @override
  String get limitBannerCallSub => 'Тегін жоспар күніне 5 минут қоңырау береді';

  @override
  String get limitBannerCheckTitle => 'Бұл бүгінгі тексеріс еді';

  @override
  String get limitBannerCheckSub => 'Тегін жоспар күніне бір тексеріс береді';

  @override
  String get bulletProCharactersForever =>
      'Сатып алған кейіпкерлеріңіз мәңгі сіздікі';

  @override
  String get paywallMaxTitle => 'Енді оларды көре аласыз.';

  @override
  String paywallTutorCompare(String price) {
    return 'Тьютормен бір сағат \$25 тұрады. Premium бір айы $price тұрады.';
  }

  @override
  String get planMonthly => 'Айлық';

  @override
  String get planAnnual => 'Жылдық';

  @override
  String proMonthlyPriceLine(String price) {
    return 'Айына $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · айына $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'Айына $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'Жылына $yearly · айына $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'Айына $price · дүкенде кез келген уақытта бас тартуға болады';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Айына $price · дүкенде кез келген уақытта бас тартуға болады';
  }

  @override
  String ctaCaptionMaxYearly(String price) {
    return 'Жылына $price · дүкенде кез келген уақытта бас тартуға болады';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 күн тегін, содан кейін Айына $price · дүкенде кез келген уақытта бас тартуға болады';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Бас тартқанға дейін автоматты түрде жаңарады.';

  @override
  String get footerTerms => 'Шарттар';

  @override
  String get footerPrivacy => 'Құпиялылық';

  @override
  String get processingTitle => 'Сатып алуыңыз расталуда';

  @override
  String get processingSub => 'Бұл әдетте бірнеше секунд алады.';

  @override
  String get successProTitle => 'Сіз енді Premium-дасыз.';

  @override
  String get successMaxTitle => 'Енді оларды көре аласыз.';

  @override
  String get successMaxSub =>
      'Бейне қоңыраулар қосылды. Кез келген қоңырауда бейне түймесін басыңыз.';

  @override
  String get ctaStartAVideoCall => 'Бейне қоңырау бастау';

  @override
  String get ctaSeeYourSubscription => 'Жазылымыңызды көру';

  @override
  String successMaxCaption(String price) {
    return 'Бас тартқанша ай сайын $price алынады. Дүкенде кез келген уақытта басқарыңыз немесе бас тартыңыз.';
  }

  @override
  String get plansErrorTitle => 'Жоспарларды жүктеу мүмкін болмады';

  @override
  String get plansErrorSub => 'Дүкен жауап бермеді.';

  @override
  String get ctaTryAgain => 'Қайта көру';

  @override
  String get plansErrorCaption => 'Ештеңе алынған жоқ.';

  @override
  String get ctaKeepMax => 'Premium-ды сақтау';

  @override
  String get winbackSkip => 'Өткізіп жіберу';

  @override
  String get winbackTitle => 'Premium жоспарыңыз аяқталды';

  @override
  String get winbackSub => 'Сіз қазір Тегіндесіз — күніне 5 минут қоңырау.';

  @override
  String get winbackQuestion => 'Неге кеткеніңізді айта аласыз ба?';

  @override
  String get winbackReasonExpensive => 'Тым қымбат';

  @override
  String get winbackReasonUnused => 'Жеткілікті пайдаланбадым';

  @override
  String get winbackReasonMissing => 'Маған керек мүмкіндік жоқ';

  @override
  String get winbackReasonOtherApp => 'Басқа қолданба таптым';

  @override
  String get winbackReasonElse => 'Басқа себеп';

  @override
  String get ctaSend => 'Жіберу';

  @override
  String get ctaNotNow => 'Қазір емес';

  @override
  String get winbackCaption =>
      'Бұл жоспарыңызды қайтармайды. Дүкенде қайта жазылыңыз.';

  @override
  String get ctaContinue => 'Жалғастыру';

  @override
  String get ctaClose => 'Жабу';

  @override
  String get ovRestoreSuccessTitle => 'Premium оралды';

  @override
  String get ovRestoreSuccessBody =>
      'Жазылымыңызды тауып, осы құрылғыда қайта қостық.';

  @override
  String get ovRestoreEmptyTitle => 'Қалпына келтіретін ештеңе жоқ';

  @override
  String get ovRestoreEmptyBody =>
      'Бұл дүкен есептік жазбасына байланған белсенді жазылым жоқ.';

  @override
  String get ovRestoreOtherTitle => 'Бұл жоспар басқа есептік жазбаға тиесілі';

  @override
  String get ovRestoreOtherBody =>
      'Бұл жазылым басқа BeaverTalk есептік жазбасында әлдеқашан белсенді.';

  @override
  String get ctaSignInThatAccount => 'Сол есептік жазбамен кіру';

  @override
  String get ctaGetHelp => 'Көмек алу';

  @override
  String get ovCharacterOfferTitle => 'Premium-ға дайын емессіз бе?';

  @override
  String get ovCharacterOfferBody =>
      'Бір кейіпкер таңдап, өзіңізге қалдырыңыз. Бір реттік сатып алу — жазылымсыз, жаңартусыз.';

  @override
  String get rowOneCharacter => 'Бір кейіпкер';

  @override
  String rowFromPrice(String price) {
    return 'әрқайсысы $price';
  }

  @override
  String get rowYoursForever => 'Мәңгі сіздікі';

  @override
  String get rowNoRenewal => 'Жаңарту жоқ';

  @override
  String get rowWorksOnFree => 'Тегін жоспарда жұмыс істейді';

  @override
  String get rowYes => 'Иә';

  @override
  String get ctaSeeCharacters => 'Кейіпкерлерді көру';

  @override
  String get ovNotEligibleTitle => 'Тоқтататын ештеңе жоқ';

  @override
  String get ovNotEligibleBody =>
      'Сіз Тегін жоспардасыз. Бұл есептік жазбада белсенді жазылым жоқ.';

  @override
  String get ovCancelDownsellTitle => 'Кетер алдында';

  @override
  String get ovCancelDownsellBody =>
      'Бас тарту дүкенде жасалады. Білуге тұрарлық екі нәрсе.';

  @override
  String get rowPayYearlyInstead => 'Орнына жылдық төлеңіз';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'Айына $price';
  }

  @override
  String get rowCharactersYouBought => 'Сатып алған кейіпкерлеріңіз';

  @override
  String get rowProRunsUntil => 'Premium жұмыс істейтін мерзім';

  @override
  String get ctaSwitchToYearly => 'Жылдыққа ауысу';

  @override
  String get ctaContinueToStore => 'Дүкенге өту';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Жылдық төлеп, $saved үнемдеңіз';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Жылдық жоспар ай сайын төлегеннен арзанырақ.';

  @override
  String get rowYouSave => 'Үнемдейсіз';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Жылдық';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Айлық, бір жыл бойы';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Айлыққа ауысу';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Жылдық жоспарыңыз $date дейін жұмыс істейді. Айлық төлем келесі күні басталады.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Айлық төлем басталады';

  @override
  String get rowMonthlyLabel => 'Айлық';

  @override
  String get rowYearlyWorkedOut => 'Жылдықтың есебі';

  @override
  String get ctaSwitchToMonthly => 'Айлыққа ауысу';

  @override
  String get ovRefundHelpTitle => 'Қайтарымды дүкен жүзеге асырады';

  @override
  String get ovRefundHelpBody =>
      'Біз өзіміз ақша қайтара алмаймыз. Әр сұранысты дүкен қарайды.';

  @override
  String get ctaGoToStore => 'Дүкенге бару';

  @override
  String get ovTrialEndingTitle => 'Сынағыңыз ертең аяқталады';

  @override
  String get ovTrialEndingBody =>
      'Бас тартпасаңыз, Premium жалғаса береді. Не болатыны мынадай.';

  @override
  String get rowTrialEnds => 'Сынақ аяқталады';

  @override
  String get rowFirstCharge => 'Алғашқы төлем';

  @override
  String get rowThenMonthly => 'Содан кейін ай сайын';

  @override
  String get ctaCancelInStore => 'Дүкенде бас тарту';

  @override
  String get ovTrialStartTitle => 'Premium-ның 7 күні, тегін';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date дейін тегін. Одан кейін дүкенде бас тартпасаңыз, айына $price.';
  }

  @override
  String get ctaStart7Days => '7 күн тегін бастау';

  @override
  String get ovOtoTitle => 'Бастамас бұрын тағы бір нәрсе';

  @override
  String get ovOtoBody =>
      'Жақсы таңдау. Жылдық төлесеңіз, сол Premium арзанырақ.';

  @override
  String get ovFailedDeclinedTitle => 'Картаңыз қабылданбады';

  @override
  String get ovFailedDeclinedBody =>
      'Дүкен төлемді ала алмады. Ештеңе алынған жоқ.';

  @override
  String get ctaUpdatePaymentMethod => 'Төлем әдісін жаңарту';

  @override
  String get ovFailedCanceledTitle => 'Төлемнен бас тартылды';

  @override
  String get ovFailedCanceledBody =>
      'Сіз әлі Тегін жоспардасыз. Ештеңе алынған жоқ.';

  @override
  String get ovFailedStoreTitle => 'Бір қателік болды';

  @override
  String get ovFailedStoreBody => 'Дүкенге қосыла алмадық. Ештеңе алынған жоқ.';

  @override
  String get ovAlreadyTitle => 'Сіз әлдеқашан Premium-дасыз';

  @override
  String get ovAlreadyBody =>
      'Бұл дүкен есептік жазбасында белсенді жоспар бар. Сатып алатын ештеңе жоқ.';

  @override
  String get ctaSeeMySubscription => 'Менің жазылымымды көру';

  @override
  String get subCancelTitle => 'Жазылымнан бас тарту';

  @override
  String subCancelBody(String date) {
    return 'Premium $date дейін жұмыс істейді. Одан кейін Тегінге өтесіз.';
  }

  @override
  String get subWhatYouLose => 'Нені жоғалтасыз';

  @override
  String get benefitScoring => 'Айтылым әріп бойынша бағаланады';

  @override
  String get benefitEveryMetric => 'Әр көрсеткіш, әр сөйлем';

  @override
  String get subPaymentTitle => 'Төлемді жаңарту';

  @override
  String get subPaymentBody =>
      'Төлемді алу мүмкін болмады. Жеңілдік кезеңінде Premium жұмыс істей береді.';

  @override
  String get subHowToFix => 'Қалай түзетуге болады';

  @override
  String get fixStep1 => 'Дүкенді ашып, төлем әдісіңізді жаңартыңыз';

  @override
  String get fixStep2 =>
      'Қайта оралыңыз — жоспарыңыз автоматты түрде жалғасады';

  @override
  String get fixStep3 => 'Ештеңе екі рет алынбайды';

  @override
  String get subResubTitle => 'Қайта жазылу';

  @override
  String subResubBody(String date) {
    return 'Premium $date аяқталады. Автожаңартуды қайта қоссаңыз, ештеңе өзгермейді.';
  }

  @override
  String get subWhatYouKeep => 'Сізде қалатыны';

  @override
  String get ctaTurnItBackOn => 'Қайта қосу';

  @override
  String get flTodayTitle => 'Бүгінгі қоңырау уақыты бітті';

  @override
  String get flTodayBody => 'Тоқтаған жерден жалғастырыңыз — дәл қазір.';

  @override
  String get flCheckTitle => 'Бұл бүгінгі тексеріс еді';

  @override
  String get flCheckBody =>
      'Тегін жоспарда күніне бір тексеру бар. Premium толық талдауды береді.';

  @override
  String flCaption(String price) {
    return 'Айына $price · кез келген уақытта бас тартуға болады';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit ішінен $used пайдаланылды';
  }

  @override
  String get ctaMaybeTomorrow => 'Мүмкін ертең';

  @override
  String get accountSection => 'Тіркелгі';

  @override
  String get nicknameLabel => 'Лақап ат';

  @override
  String get emailLabel => 'Эл. пошта';

  @override
  String get loginMethodLabel => 'Кіру әдісі';

  @override
  String get joinedLabel => 'Тіркелген күні';

  @override
  String get editNicknameTitle => 'Лақап атты өзгерту';

  @override
  String get nicknameRule => '2–12 таңба. Әріптер мен сандар. Тек ағылшынша';

  @override
  String get ctaSave => 'Сақтау';

  @override
  String get subscriptionRow => 'Жазылым';

  @override
  String get iapSuccessTitle => 'Сатып алу аяқталды';

  @override
  String iapSuccessBody(String name) {
    return '$name аватары мәңгі сіздікі.\nТүбіртек расталған бойда қолданылады.';
  }

  @override
  String get ctaGoHome => 'Басты бетке';

  @override
  String get ctaUseNow => 'Қазір қолдану';

  @override
  String get iapFailTitle => 'Төлем өтпеді';

  @override
  String get iapFailBody => 'Қайта көріп көруге болады';

  @override
  String get paywallGuardTitle => 'Тегін қолдана беруге болады';

  @override
  String get paywallGuardBody => 'Күніне 5 минут қоңырау сол күйінде қалады.';

  @override
  String get ctaMaybeLater => 'Кейінірек';

  @override
  String get iapCharacterSuccessTitle => 'Жаңа дос қосылды!';

  @override
  String get iapCharacterSuccessBody =>
      'Бұл кейіпкер мәңгі сіздікі — жоспар өзгерсе де қалады, ал Сатып алуларды қалпына келтіру оны кез келген құрылғыда қайтарады.';

  @override
  String get iapCharacterFailedBody =>
      'Сатып алу өтпеді. Ақша алынған жоқ — қайталап көріңіз.';

  @override
  String get noAccentDataTitle => 'Интонация деректері әзірге жоқ';

  @override
  String get noAccentDataBody =>
      'Сөйлесуді жалғастырсаңыз, интонация ерекшеліктері жинала береді.';

  @override
  String get noLevelYetTitle => 'Деңгей әзірге жоқ';

  @override
  String get noLevelYetBody =>
      'Алғашқы қоңырауды аяқтасаңыз деңгейіңіз шығады.';

  @override
  String get noPronunciationDataTitle => 'Айтылым жазбалары әзірге жоқ';

  @override
  String get noPronunciationDataBody =>
      'Қоңырауда айтқан сөйлемдеріңізден айтылымды талдаймыз.';

  @override
  String get noCharacterNote => 'Әзірге қалдырылған сөз жоқ';

  @override
  String get noPhonemesYet => 'Талдауға арналған дыбыс әзірге жоқ';

  @override
  String get noSentencesYet => 'Талдауға арналған сөйлем әзірге жоқ';

  @override
  String get takeLevelTest => 'Деңгей тестін тапсыру';

  @override
  String get playAgain => 'Қайта ойнау';

  @override
  String get difficultySlow => 'Баяу';

  @override
  String get difficultyNormal => 'Қалыпты';

  @override
  String get difficultyFast => 'Жылдам';

  @override
  String get difficultyLabel => 'Күрделілік';

  @override
  String get connected => 'Байланысты';

  @override
  String get unlockedWithMax => 'Жоспарыңызға кіреді';

  @override
  String get fcEndedTitle => 'Тегін қоңырауыңыз аяқталды';

  @override
  String get fcEndedBody =>
      'Тегін қоңыраулар 5 минутқа дейін созылады\nҰзағырақ сөйлесу үшін жазылыңыз';

  @override
  String get ctaSubscribeKeepTalking => 'Жазылып, сөйлесуді жалғастыру';

  @override
  String get kgTitle => 'Жалғастырамыз ба?';

  @override
  String get kgBody =>
      'Қоңырау қысқа бөліктермен жалғасады.\nӘр жолы қайта сұраймыз.';

  @override
  String get pcEndedTitleToday => 'Бүгінгі қоңырауды аяқтайық.';

  @override
  String get pcEndedBodyToday =>
      'Сөйлескенімізді қайталап, ертең тағы қоңырау шалыңыз!';

  @override
  String get pcEndedTitle => 'Бұл қоңырауды аяқтайық.';

  @override
  String get pcEndedBody => 'Сөйлескенімізді қайталап, тағы қоңырау шалыңыз!';

  @override
  String get ctaKeepTalking => 'Сөйлесуді жалғастыру';

  @override
  String get callModeSheetTitle => 'Қалай сөйлескіңіз келеді?';

  @override
  String get callModeSheetSubtitle => 'Осы қоңырауға бірден қолданылады';

  @override
  String get callModeFreeTalk => 'Еркін әңгіме';

  @override
  String get callModeFreeTalkDesc => 'Түзетусіз еркін сөйлесіңіз';

  @override
  String get callModeStudy => 'Оқу';

  @override
  String get callModeStudyDesc => 'Бір уақытта бір тіркесті үйреніңіз';

  @override
  String get callModeChange => 'Режимді өзгерту';

  @override
  String get callModeKeep => 'Қазір емес';

  @override
  String get callExitTitle => 'Қоңырауды аяқтау керек пе?';

  @override
  String get callExitSubtitle =>
      'Қазір аяқтасаңыз да, сөйлескен уақыт бүгінгі қолданысқа кіреді';

  @override
  String get callExitKeep => 'Сөйлесуді жалғастыру';

  @override
  String get callExitConfirm => 'Қоңырауды аяқтау';

  @override
  String get callMicMute => 'Дыбысты өшіру';

  @override
  String get callMicUnmute => 'Дыбысты қосу';

  @override
  String get callPushToTalk => 'Сөйлеу үшін басып тұрыңыз';

  @override
  String get callFreeEndedTitle => 'Тегін қоңырауыңыз аяқталды';

  @override
  String get callFreeEndedCta => 'Жазылып, сөйлесуді жалғастырыңыз';

  @override
  String get callKeepGoingTitle => 'Жалғастырамыз ба?';

  @override
  String get callKeepGoingSubtitle =>
      'Қоңыраулар 5 минуттық бөліктермен жалғасады. Әр жолы қайта сұраймыз.';

  @override
  String get articulationSelectedWord => 'Таңдалған сөз';

  @override
  String get articulationYouSaid => 'Сіздің айтылымыңыз';

  @override
  String get articulationTargetSound => 'Мақсат';

  @override
  String get reportEntry => 'Шағымдану';

  @override
  String get reportTitle => 'Шағым';

  @override
  String get reportPrompt => 'Қандай мәселе болды?';

  @override
  String get reportGuide =>
      'AI кейіпкерінің қандай сөзі сізді ыңғайсыздандырғанын айтыңыз. Әр шағымды қараймыз.';

  @override
  String get reportReasonSexual => 'Сексуалдық мазмұн';

  @override
  String get reportReasonHate => 'Өшпенділік немесе кемсіту';

  @override
  String get reportReasonViolence => 'Зорлық-зомбылық немесе қоқан-лоққы';

  @override
  String get reportReasonSelfHarm => 'Өзіне зиян келтіруге итермелейді';

  @override
  String get reportReasonMisinfo => 'Жалған ақпарат';

  @override
  String get reportReasonOther => 'Басқа мәселе';

  @override
  String get reportDetailHint => 'Не болғанын жазыңыз (міндетті емес)';

  @override
  String get reportSubmit => 'Шағым жіберу';

  @override
  String get reportDoneTitle => 'Шағымыңыз қабылданды';

  @override
  String get reportDoneBody =>
      'Қарап шығып, қажет болса шара қолданамыз. BeaverTalk қауіпсіздігіне көмектескеніңізге рақмет.';

  @override
  String get reportFailed => 'Шағым жіберілмеді. Қайта көріңіз.';

  @override
  String get hwTitle => 'Үй тапсырмасы';

  @override
  String get hwJoinCodeTitle => 'Сынып кодын енгізіңіз';

  @override
  String get hwJoinCodeSubtitle => 'Бұл мұғалім берген 6 таңбалы код';

  @override
  String get hwJoinCodeLabel => 'Сынып коды';

  @override
  String get hwJoinCodeHelp => 'Кодта бас және кіші әріп ажыратылмайды';

  @override
  String get hwJoinConfirmTitle => 'Дұрыс сынып па?';

  @override
  String get hwJoinConfirmSubtitle =>
      'Егер олай болмаса, кодты қайта тексеріңіз';

  @override
  String get hwJoinFieldInstitution => 'Мекеме';

  @override
  String get hwJoinFieldTeacher => 'Мұғалім';

  @override
  String get hwJoinFieldLearners => 'Оқушылар';

  @override
  String get hwJoinFieldTerm => 'Кезең';

  @override
  String get hwJoinConfirmNote =>
      'Сынып атауы мұғалім жазғандай көрсетіледі. Біз оны аудармаймыз.';

  @override
  String get hwJoinConfirmYes => 'Иә, дәл сол';

  @override
  String get hwJoinConfirmRetry => 'Кодты қайта енгізу';

  @override
  String get hwJoinProfileTitle => 'Сыныпта қандай атпен боласыз?';

  @override
  String get hwJoinProfileSubtitle => 'Мұғалім оны сынып тізімімен салыстырады';

  @override
  String get hwJoinNameLabel => 'Аты';

  @override
  String get hwJoinNameHelp => 'Қолданбадағы атыңыздан өзгеше болуы мүмкін';

  @override
  String get hwJoinStudentNoLabel => 'Оқушы нөмірі (міндетті емес)';

  @override
  String get hwJoinStudentNoHelp =>
      'Мұғалім тізімді салыстыру үшін пайдаланады';

  @override
  String get hwJoinConsentTitle => 'Мұғалім не көреді';

  @override
  String get hwJoinConsentSubtitle => 'Сыныпқа қосылу үшін келісім қажет';

  @override
  String get hwJoinConsentSharedHeading => 'Мұғаліммен бөлісіледі';

  @override
  String get hwJoinConsentShared1 => 'Сынып атауы және оқушы нөмірі';

  @override
  String get hwJoinConsentShared2 => 'Үй тапсырмасын орындағаныңыз';

  @override
  String get hwJoinConsentShared3 => 'Өткен және өтпеген сөйлемдер';

  @override
  String get hwJoinConsentShared4 => 'Тапсырма қоңырауының ұзақтығы мен түйіні';

  @override
  String get hwJoinConsentNotSharedHeading => 'Бөлісілмейді';

  @override
  String get hwJoinConsentNotShared1 => 'Эл. пошта және телефон нөмірі';

  @override
  String get hwJoinConsentNotShared2 =>
      'Қолданбадағы аты, профиль және кейіпкер';

  @override
  String get hwJoinConsentNotShared3 => 'Азаматтығы және ана тілі';

  @override
  String get hwJoinConsentNotShared4 => 'Сыныптан тыс қоңыраулар мен оқу';

  @override
  String get hwJoinConsentNotShared5 => 'Жазылым және төлем деректері';

  @override
  String get hwJoinConsentAgree => 'Жоғарыдағымен келісемін';

  @override
  String get hwJoinConsentCta => 'Келісіп қосылу';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Сіз $className сыныбына қосылдыңыз';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count тапсырма күтіп тұр';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Әзірге тапсырма жоқ';

  @override
  String get hwJoinDoneNextDue => 'Келесі мерзім';

  @override
  String get hwJoinDoneRosterName => 'Сыныптағы атыңыз';

  @override
  String get hwJoinDoneCta => 'Тапсырмаларды көру';

  @override
  String get hwJoinErrorNotFound => 'Ондай код табылмады';

  @override
  String get hwJoinErrorNotFoundBody => 'Алты таңбаны қайта тексеріңіз.';

  @override
  String get hwJoinErrorExpired => 'Кодтың мерзімі бітті';

  @override
  String get hwJoinErrorExpiredBody => 'Мұғалімнен жаңа код сұраңыз.';

  @override
  String get hwJoinErrorFull => 'Сынып толы';

  @override
  String get hwJoinErrorFullBody => 'Мұғаліміңізге хабарлаңыз.';

  @override
  String get hwJoinFailed =>
      'Қосылу мүмкін болмады. Сәлден соң қайталап көріңіз.';

  @override
  String get hwSectionInProgress => 'Орындалуда';

  @override
  String get hwSectionUpcoming => 'Алдағы';

  @override
  String get hwSectionDone => 'Аяқталды';

  @override
  String get hwLeaveClassLink => 'Сыныптан шығу';

  @override
  String get hwListEmptyTitle => 'Әзірге үй тапсырмасы жоқ';

  @override
  String get hwListEmptyBody => 'Мұғалім тапсырма бергенде осында көрінеді.';

  @override
  String get hwListFailed => 'Тапсырмалар жүктелмеді.';

  @override
  String get hwRetry => 'Қайталау';

  @override
  String get hwBadgeDone => 'Аяқталды';

  @override
  String get hwBadgeOverdue => 'Тапсырылмады';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Тапсырылмады, $days күн кешікті';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Мерзімі бүгін';

  @override
  String get hwActivitySpeaking => 'Сөйлеу';

  @override
  String get hwActivityConversation => 'Әңгіме';

  @override
  String get hwActivityWorkbook => 'Жұмыс дәптері';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter-тарау';
  }

  @override
  String get hwTaskSpeakingDesc => 'Айтылым ұпайыңызды тексеріңіз';

  @override
  String get hwTaskConversationDesc =>
      'Үйренгеніңізді нақты әңгімеде қолданыңыз';

  @override
  String get hwConversationOnce => 'Әңгіме әр тапсырма бойынша бір рет қана.';

  @override
  String get hwTaskWorkbookDesc => 'Жұмыс дәптеріне жазып жаттығыңыз';

  @override
  String get hwCtaStudy => 'Бастау';

  @override
  String get hwCtaResult => 'Нәтижені көру';

  @override
  String get hwCtaDownload => 'Жүктеу';

  @override
  String get hwSpeakingNoScore => 'Сөйлеу тапсырмасын әлі орындамадыңыз';

  @override
  String get hwWorkbookUnavailable =>
      'Жұмыс дәптерінің файлы әзірге қолжетімсіз.';

  @override
  String get hwDetailClosed => 'Бұл тапсырма жабылды. Енді тапсыра алмайсыз.';

  @override
  String get hwLeaveTitle => 'Сыныптан шығасыз ба?';

  @override
  String get hwLeaveBody =>
      'Мұғалім енді сіздің тапсырма нәтижелеріңізді көрмейді.';

  @override
  String get hwLeaveConfirm => 'Шығу';

  @override
  String get hwLeaveCancel => 'Қалу';

  @override
  String get hwLeaveFailed => 'Сыныптан шығу мүмкін болмады.';

  @override
  String get hwMyClass => 'Менің сыныбым';

  @override
  String get hwClassEmptyTitle => 'Сіз ешбір сыныпқа қосылмадыңыз';

  @override
  String get hwClassEmptySubtitle => 'Мұғалім берген кодты енгізіңіз';

  @override
  String get hwClassEmptyCta => 'Сынып кодын енгізу';

  @override
  String get hwClassContinueCta => 'Жалғастыру';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count тапсырманың мерзімі ертең';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Сізде тапсырылмаған $count тапсырма бар';
  }

  @override
  String get hwSpeakingUnavailable =>
      'Бұл тапсырманың сөйлемдері әзірге қолжетімсіз.';

  @override
  String get hwBadgeClosed => 'Жабық';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total сөйлемнің $passed өтті';
  }

  @override
  String get challengeFirstWord => 'Бірінші сөз';

  @override
  String get challengeSeeAnalysis => 'Нәтижелерді көру';

  @override
  String get challengePaused => 'Кідіртілді';

  @override
  String get challengePausedNote => 'Таймер мен жазба бірге тоқтады.';

  @override
  String get challengeTimeLeft => 'Қалған уақыт';

  @override
  String get challengeScoreLabel => 'Ұпай';

  @override
  String get challengeResume => 'Жалғастыру';

  @override
  String get challengeBlockedTitle => 'Камераны қолдану мүмкін емес';

  @override
  String get challengeBlockedNote =>
      'Параметрлерде камера мен микрофонға рұқсатты қосыңыз.';

  @override
  String get challengeGoBack => 'Артқа';

  @override
  String get challengeOpenSettings => 'Параметрлерді ашу';

  @override
  String get saveDone => 'Галереяға сақталды';

  @override
  String get saveFailed => 'Сақталмады';

  @override
  String get saveDeniedNote => 'Фотоға рұқсат қажет';

  @override
  String get callIncomingCallerFallback => 'Beaver ұстаз';

  @override
  String get callIncomingHandle => 'Корей тілінде қоңырау';

  @override
  String get callMissedTitle => 'Жауапсыз қоңырау';

  @override
  String get callMissedChannelDescription =>
      'Beaver қоңырауын өткізіп алғаныңызды хабарлайды.';

  @override
  String callMissedBody(String name) {
    return '$name сізге қоңырау шалды';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Қоңырау қабылдау үшін хабарландыру рұқсаты қажет.';

  @override
  String get callNotifPermissionRequired =>
      'Параметрлерде хабарландыруға рұқсат беріңіз.';

  @override
  String get callHintLockedTitle => 'Оқу режимінде кеңестер қолжетімсіз';

  @override
  String get wsTitle => 'Қиын дыбыстар';

  @override
  String get wsToList => 'Тізімге';

  @override
  String get wsNext => 'Келесі';

  @override
  String get wsRetry => 'Қайта көру';

  @override
  String get wsDone => 'Дайын';

  @override
  String get wsContinue => 'Жалғастыру';

  @override
  String get wsQuit => 'Шығу';

  @override
  String get wsRetryLater => 'Сәл кейін қайталап көріңіз.';

  @override
  String get wsMissingTitle => 'Ол дыбысты таба алмадық';

  @override
  String get wsMissingBody => 'Тізімнен қайта таңдаңыз.';

  @override
  String get wsListLoadFailed => 'Тізімді жүктей алмадық';

  @override
  String get wsLessonLoadFailed => 'Сабақты жүктей алмадық';

  @override
  String get wsNationalTitle => 'Акцентіңізге сай қиын дыбыстар';

  @override
  String get wsNationalPending => 'Акцент талдауы бітсе, осы жер толады';

  @override
  String get wsNationalPicked => 'Акцент талдауы бойынша таңдалды';

  @override
  String get wsNationalEmptyBody =>
      'Бірнеше қоңырау шалсаңыз, акцентіңізді талдаймыз.';

  @override
  String get wsMineTitle => 'Менің қиын дыбыстарым';

  @override
  String get wsMineSubtitle => 'Соңғы кезде балл төмен болған дыбыстар';

  @override
  String get wsMineEmptyBody =>
      'Қоңырау шалып қайталасаңыз, қиын дыбыстар жинала береді.';

  @override
  String get wsNoDataYet => 'Әзірге дерек жоқ';

  @override
  String get wsGoToCall => 'Қоңырау шалу';

  @override
  String get wsRule => 'Ереже';

  @override
  String get wsRecommended => 'Ұсынылады';

  @override
  String get wsNotMeasured => 'Өлшенбеген';

  @override
  String get wsStepUnderstand => 'Түсіну';

  @override
  String get wsStepWords => 'Сөздер';

  @override
  String get wsStepSentence => 'Сөйлем';

  @override
  String get wsStepTest => 'Бағалау';

  @override
  String get wsQuitTitle => 'Жаттығуды тоқтатасыз ба?';

  @override
  String get wsQuitBody => 'Қазір шықсаңыз, бұл жаттығу сақталмайды.';

  @override
  String get wsHowToSound => 'Дыбысты қалай айту керек';

  @override
  String get wsPracticeWords => 'Сөздерді жаттығу';

  @override
  String get wsPracticeSentence => 'Сөйлемді жаттығу';

  @override
  String get wsPracticeAgain => 'Тағы бір рет';

  @override
  String get wsStartTest => 'Қорытынды бағалауды тапсыру';

  @override
  String get wsThisSentence => 'Осы сөйлем';

  @override
  String get wsNoScoreNote => 'Бұл қадам бағаланбайды. Еркін қайталап айтыңыз.';

  @override
  String get wsListen => 'Мұқият тыңдаңыз';

  @override
  String get wsSayNow => 'Енді айтып көріңіз';

  @override
  String get wsPracticeDone => 'Жаттығу бітті';

  @override
  String get wsPaused => 'Кідіртілді';

  @override
  String get wsAudioFailed => 'Дыбысты жүктей алмадық. Мәтінді оқып айтыңыз.';

  @override
  String get wsReadAloud => 'Төмендегі сөйлемді дауыстап оқыңыз';

  @override
  String get wsTapToStart => 'Бастау үшін басыңыз';

  @override
  String get wsTapWhenDone => 'Оқып болғанда басыңыз';

  @override
  String get wsScoring => 'Бағалануда';

  @override
  String get wsMicFailed => 'Микрофонды аша алмадық.';

  @override
  String get wsMicPermissionBody =>
      'Бұл тестте дауыстап оқу керек, сондықтан микрофон қажет. Параметрлерде микрофонға рұқсатты қосыңыз.';

  @override
  String get wsNoSound => 'Дыбыс келмеді. Қайта айтып көрейік пе?';

  @override
  String get wsScoreFailed => 'Бағалау сәтсіз болды. Қайта көріңіз.';

  @override
  String get wsSomethingWrong => 'Қателік кетті.';

  @override
  String get wsLearnDone => 'Сабақ бітті';

  @override
  String get wsRetest => 'Қайта бағалау';

  @override
  String get wsFirstMeasure => 'Бірінші өлшем';

  @override
  String get wsFinalTest => 'Қорытынды бағалау';

  @override
  String wsPoints(int score) {
    return '$score балл';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Бұрын $score балл';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Мақсат $score балл';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Мақсат · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country акценті';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count сөз қайталанды';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count бөлік қайталанды';
  }

  @override
  String get wsStartRecommended => 'Ұсынылған дыбыстан бастау';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Бастау · $label';
  }

  @override
  String get wsPointsUnit => 'балл';

  @override
  String get wsEnterFromMypage => 'Қиын дыбыстарды жаттығу';

  @override
  String wsGoalOnly(int score) {
    return 'Мақсат $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label дыбысы';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Қоңырауда кездескенде осы пішінді есіңізге түсіріңіз.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country сөйлеушілері жиі қателесетін дыбыстар';
  }
}
