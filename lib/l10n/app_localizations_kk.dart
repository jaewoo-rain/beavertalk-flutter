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
  String get review => 'Шолу';

  @override
  String get pronunciationChallenge => 'Айтылым сынағы';

  @override
  String get newExpressions => 'Жаңа сөз тіркестері';

  @override
  String get analysisResult => 'Талдау нәтижесі';

  @override
  String get noNewExpressions => 'Бұл әңгімеде жаңа сөз тіркестері жоқ.';

  @override
  String get practice => 'Жаттығу';

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
  String get selectTime => 'Уақытты таңдаңыз';

  @override
  String get getStarted => 'Бастау';

  @override
  String get permissionTitle => 'Ыңғайлы тәжірибе үшін\nрұқсаттарды беріңіз';

  @override
  String get permissionSubtitle =>
      'Қажетті рұқсаттар қызметті пайдалану үшін міндетті.';

  @override
  String get permissionMicTitle => 'Микрофон (міндетті)';

  @override
  String get permissionMicDesc => 'AI-мен ағылшынша сөйлесу үшін қажет.';

  @override
  String get permissionNotifTitle => 'Хабарландырулар (міндетті емес)';

  @override
  String get permissionNotifDesc =>
      'Біз оқу еске салғыштары мен қоңырау кестелерін жібереміз.';

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
  String get navCalendar => 'Күнтізбе';

  @override
  String get navCall => 'Қоңырау';

  @override
  String get navStats => 'Статистика';

  @override
  String get myPage => 'Менің бетім';

  @override
  String get languageSaveFailed => 'Тіліңізді сақтау мүмкін болмады.';

  @override
  String get accountDeleteFailed => 'Есептік жазбаңызды жою мүмкін болмады.';

  @override
  String get changeAvatar => 'Аватарды өзгерту';

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
  String get changePlan => 'Жоспарды өзгерту';

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
  String get keepUsingPro => 'Pro нұсқасын пайдалануды жалғастыру';

  @override
  String get proMembership => 'Pro мүшелігі';

  @override
  String get pricePerMonth => '\$12.9 / ай';

  @override
  String get benefitUnlimitedCalls => 'Шексіз қоңыраулар';

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
  String get challengeLoadingNote =>
      'Алғашқы іске қосуда корей тілі моделі (~82МБ) жүктеліп жатыр.\nСәл күте тұрыңыз.';

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
  String get callNow => 'Қазір қоңырау шалу';

  @override
  String get pronunciation => 'Айтылым';

  @override
  String get fluency => 'Еркіндік';

  @override
  String get rhythm => 'Ырғақ';

  @override
  String get analysisTimeout =>
      'Бұл күткеннен ұзағырақ уақыт алып жатыр. Сәлден соң қайта көріңіз.';

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
  String get loginKakaoSignInFailed => 'Kakao арқылы кіру сәтсіз аяқталды.';

  @override
  String get loginContinueWithKakao => 'Kakao арқылы жалғастыру';

  @override
  String get loginContinueWithGoogle => 'Google арқылы жалғастыру';

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
  String subscriptionSwitchNote(String date) {
    return 'Pro артықшылықтарын $date дейін пайдалана аласыз, содан кейін жоспарыңыз автоматты түрде тегінге ауысады.';
  }

  @override
  String get freePlanCallLimit => 'Күніне 1 қоңырау · 5 мин шектеу';

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
  String get practicePronunciation => 'Айтылымды жаттықтыру';

  @override
  String get priceChangedTitle => 'Price changed';

  @override
  String priceChangedBody(String price) {
    return 'This item is now $price. Would you like to continue?';
  }
}
