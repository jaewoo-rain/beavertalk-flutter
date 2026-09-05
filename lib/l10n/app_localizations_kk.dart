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
  String get usedExpressions => 'Сіз қолданған тіркестер';

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
  String pricePerMonth(String price) {
    return '$price / ай';
  }

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
  String get billingChangePlan => 'Жоспарды өзгерту';

  @override
  String get billingCompareAllPlans => 'Барлық жоспарды салыстыру';

  @override
  String get billingBuyACharacter => 'Кейіпкер сатып алу';

  @override
  String get billingRestorePurchases => 'Сатып алуларды қалпына келтіру';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max сынағы';

  @override
  String get freePlanPriceLine => '\$0.00 — күніне бір қоңырау';

  @override
  String pricePerMonthLine(String amount) {
    return 'Айына $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date дейін тегін';
  }

  @override
  String get todaysCalls => 'Бүгінгі қоңыраулар';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit ішінен $used пайдаланылды';
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
  String get bannerGoUnlimitedTitle => 'Pro-мен шексіз болыңыз';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Шексіз қоңырау · әрқайсысы 15 минут · айына $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max-пен бейнені қосыңыз';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Бетпе-бет қоңыраулар · айына $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Жылдық жоспарға өту';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return 'Жылына $yearly · айына $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'Төлемді алу мүмкін болмады';

  @override
  String get bannerPaymentFailedSub =>
      'Pro-ны сақтау үшін дүкенде төлемді жаңартыңыз';

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
  String get noteFairUse =>
      'Шексіз пайдалану біздің әділ пайдалану саясатына бағынады.';

  @override
  String noteTrialEnds(String date) {
    return 'Сынағыңыз $date аяқталады. Оған дейін дүкенде бас тартсаңыз, ештеңе алынбайды.';
  }

  @override
  String get noteGrace =>
      'Жеңілдік кезеңінде артықшылықтар жалғаса береді. Бас тарту қолданбада ешқашан бөгелмейді.';

  @override
  String get noteHold =>
      'Төлем өткенше Pro кідіртіледі. Кейіпкерлеріңіз бен үлгеріміңіз аман.';

  @override
  String noteEnding(String date) {
    return 'Жоспарыңыз аяқталуға қойылған. Артықшылықтар $date дейін жалғасады, содан кейін Тегінге өтесіз. Кез келген уақытта қайта жазыла аласыз.';
  }

  @override
  String get trialExpiredTitle => 'Max сынағыңыз аяқталды';

  @override
  String get trialExpiredSub => 'Сіз қазір Тегін жоспардасыз';

  @override
  String get seePlans => 'Жоспарларды көру';

  @override
  String get currentPlanTitle => 'Ағымдағы жоспар';

  @override
  String get badgeRecommended => 'Ұсынылады';

  @override
  String get perMonthUnit => 'айына';

  @override
  String get planTaglinePro => 'Шексіз қоңырау. Әрқайсысы 15 минут.';

  @override
  String get planTaglineMax => 'Енді оларды көре аласыз.';

  @override
  String get planTaglineFree => 'Күніне бір қоңырау. Тегін.';

  @override
  String get bulletProCalls => 'Қалағаныңызша дауыстық қоңыраулар';

  @override
  String get bulletProLength => 'Әр қоңырау 15 минут';

  @override
  String get bulletProScoring => 'Айтылым әріп бойынша бағаланады';

  @override
  String get bulletProCorrections => 'Ана тіліңізге бейімделген түзетулер';

  @override
  String get bulletProBeaverCalls => 'Beaver сізге бірінші қоңырау шалады';

  @override
  String get bulletMaxVideo => 'Бетпе-бет бейне қоңыраулар';

  @override
  String get bulletMaxEverything => 'Pro-дағы барлық мүмкіндік';

  @override
  String get bulletMaxCharacters => 'Барлық кейіпкер, шексіз';

  @override
  String get bulletMaxStudyBook => 'Деңгейіңізге сай оқу кітабы';

  @override
  String get bulletMaxWeeklyReport =>
      'Айтылымыңыздың өзгерісі туралы апталық есеп';

  @override
  String get bulletFreeCall => 'Күніне бір 5 минуттық дауыстық қоңырау';

  @override
  String get bulletFreeCheck => 'Күніне бір айтылым тексерісі';

  @override
  String get bulletFreeAccent => 'Шексіз акцент тексерісі';

  @override
  String get bulletFreeCharacter => 'Бастауға бір кейіпкер';

  @override
  String get ctaGoUnlimited => 'Шексіз болу';

  @override
  String get ctaTurnOnVideo => 'Бейнені қосу';

  @override
  String get noteCallLength => 'Әр қоңырау 15 минутқа созылады.';

  @override
  String get paywallProTitle1 => 'Түнгі 3-те де ояу жүретін';

  @override
  String get paywallProTitle2 => 'кәріс досыңыз';

  @override
  String get paywallProSub => 'Шексіз қоңырау. Әрқайсысы 15 минут. Жыл бойы.';

  @override
  String get paywallLimitHeadline => 'Pro шектеуді алып тастайды.';

  @override
  String get limitBannerCallTitle => 'Бұл бүгінгі қоңырау еді';

  @override
  String get limitBannerCallSub => 'Тегін жоспар күніне бір қоңырау береді';

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
  String get paywallMaxSub =>
      'Бейне қоңыраулар, барлық кейіпкер және деңгейіңізге арнап жасалған оқу кітабы.';

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
  String get noteMaxCharacters =>
      'Max ашқан кейіпкерлер жазылымыңыз белсенді кезде қолжетімді. Сатып алған кейіпкерлеріңіз сіздікі болып қалады.';

  @override
  String get processingTitle => 'Сатып алуыңыз расталуда';

  @override
  String get processingSub => 'Бұл әдетте бірнеше секунд алады.';

  @override
  String get successProTitle => 'Сіз енді Pro-дасыз.';

  @override
  String get successProSub => 'Шексіз қоңыраулар, дәл қазірден бастап.';

  @override
  String get successProBenefit1 =>
      'Қалағаныңызша қоңырау шалыңыз — әр қоңырау 15 минут';

  @override
  String get successProBenefit2 => 'Шексіз айтылым тексерісі';

  @override
  String get successProBenefit3 => 'Барлық кейіпкер және жеке сатып алулар';

  @override
  String get successMaxTitle => 'Енді оларды көре аласыз.';

  @override
  String get successMaxSub =>
      'Бейне қоңыраулар қосылды. Кез келген қоңырауда бейне түймесін басыңыз.';

  @override
  String get successMaxBenefit1 => 'Бетпе-бет бейне қоңыраулар';

  @override
  String get successMaxBenefit2 =>
      'Барлық кейіпкер, шексіз және жаңалары бірінші';

  @override
  String get successMaxBenefit3 => 'Деңгейіңізге сай оқу кітабы';

  @override
  String get ctaStartACall => 'Қоңырау бастау';

  @override
  String get ctaStartAVideoCall => 'Бейне қоңырау бастау';

  @override
  String get ctaSeeYourSubscription => 'Жазылымыңызды көру';

  @override
  String successProCaption(String price) {
    return 'Бас тартқанша ай сайын $price алынады. Дүкенде кез келген уақытта басқарыңыз немесе бас тартыңыз.';
  }

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
  String get changePlanTitle => 'Жоспарды өзгерту';

  @override
  String get moveToMaxTitle => 'Max-қа өту';

  @override
  String maxPriceShort(String price) {
    return '$price / ай';
  }

  @override
  String get moveToMaxCardSub =>
      'Бетпе-бет бейне қоңыраулар · барлық кейіпкер · сізге арналған оқу кітабы';

  @override
  String get whatHappensNow => 'Енді не болады';

  @override
  String get maxStartsLabel => 'Max басталады';

  @override
  String get immediately => 'Дереу';

  @override
  String get unusedProTime => 'Пайдаланылмаған Pro уақыты';

  @override
  String get creditedTowardMax => 'Max есебіне саналады';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max-қа ауысу';

  @override
  String get upgradeCaption =>
      'Жаңа жоспарыңыз бірден басталады. Пайдаланылмаған Pro уақыты есепке алынады, ешқашан екі рет алынбайды.';

  @override
  String get moveToProTitle => 'Pro-ға өту';

  @override
  String get moveToProSub =>
      'Бүгін ештеңе өзгермейді. Max сіз төлеген айдың соңына дейін жұмыс істейді.';

  @override
  String get maxRunsUntil => 'Max жұмыс істейтін мерзім';

  @override
  String get proStarts => 'Pro басталады';

  @override
  String get whatYouKeep => 'Сізде қалатыны';

  @override
  String get keepBenefitCalls =>
      'Шексіз дауыстық қоңыраулар, әрқайсысы 15 минут';

  @override
  String get keepBenefitCharacters =>
      'Сатып алған кейіпкерлеріңіз мәңгі сіздікі';

  @override
  String downgradeWarning(String date) {
    return 'Бейне қоңыраулар мен тек Max кейіпкерлері $date өшіріледі.';
  }

  @override
  String get ctaSwitchToPro => 'Pro-ға ауысу';

  @override
  String get ctaKeepMax => 'Max-ты сақтау';

  @override
  String get winbackSkip => 'Өткізіп жіберу';

  @override
  String get winbackTitle => 'Pro жоспарыңыз аяқталды';

  @override
  String get winbackSub => 'Сіз қазір Тегіндесіз — күніне бір қоңырау.';

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
  String get ovRestoreSuccessTitle => 'Pro оралды';

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
  String get ovCharacterOfferTitle => 'Pro-ға дайын емессіз бе?';

  @override
  String get ovCharacterOfferBody =>
      'Бір кейіпкер таңдап, өзіңізге қалдырыңыз. Бір реттік сатып алу — жазылымсыз, жаңартусыз.';

  @override
  String get rowOneCharacter => 'Бір кейіпкер';

  @override
  String rowFromPrice(String price) {
    return '$price бастап';
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
  String get rowProRunsUntil => 'Pro жұмыс істейтін мерзім';

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
      'Pro-да екі ай болдыңыз. Жылдық жоспар есептегенде арзанырақ шығады.';

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
      'Бас тартпасаңыз, Max жалғаса береді. Не болатыны мынадай.';

  @override
  String get rowTrialEnds => 'Сынақ аяқталады';

  @override
  String get rowFirstCharge => 'Алғашқы төлем';

  @override
  String get rowThenMonthly => 'Содан кейін ай сайын';

  @override
  String get ctaCancelInStore => 'Дүкенде бас тарту';

  @override
  String get ovTrialStartTitle => 'Max-тың 7 күні, тегін';

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
      'Дұрыс шешім — шексіз қоңыраулар қазір қосулы. Дәл сол Pro жылдық төлесеңіз арзанырақ.';

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
  String get ovAlreadyTitle => 'Сіз әлдеқашан Pro-дасыз';

  @override
  String get ovAlreadyBody =>
      'Бұл дүкен есептік жазбасында белсенді жоспар бар. Сатып алатын ештеңе жоқ.';

  @override
  String get ctaSeeMySubscription => 'Менің жазылымымды көру';

  @override
  String get subCancelTitle => 'Жазылымнан бас тарту';

  @override
  String subCancelBody(String date) {
    return 'Pro $date дейін жұмыс істейді. Одан кейін Тегінге өтесіз.';
  }

  @override
  String get subWhatYouLose => 'Нені жоғалтасыз';

  @override
  String get benefitCalls15 => 'Шексіз қоңыраулар, әрқайсысы 15 минут';

  @override
  String get benefitScoring => 'Айтылым әріп бойынша бағаланады';

  @override
  String get benefitEveryCharacter => 'Барлық кейіпкер, шексіз';

  @override
  String get ctaKeepPro => 'Pro-ны сақтау';

  @override
  String get subPaymentTitle => 'Төлемді жаңарту';

  @override
  String get subPaymentBody =>
      'Төлемді алу мүмкін болмады. Жеңілдік кезеңінде Pro жұмыс істей береді.';

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
    return 'Pro $date аяқталады. Автожаңартуды қайта қоссаңыз, ештеңе өзгермейді.';
  }

  @override
  String get subWhatYouKeep => 'Сізде қалатыны';

  @override
  String get ctaTurnItBackOn => 'Қайта қосу';

  @override
  String get flTodayTitle => 'Бұл бүгінгі қоңырау еді';

  @override
  String get flTodayBody => 'Тоқтаған жерден жалғастырыңыз — дәл қазір.';

  @override
  String get flCheckTitle => 'Бұл бүгінгі тексеріс еді';

  @override
  String get flCheckBody =>
      'Тегін жоспарда күніне бір тексеріс. Pro оны шексіз етеді.';

  @override
  String get flBenefitCalls => 'Pro-мен шексіз қоңыраулар · әрқайсысы 15 минут';

  @override
  String get flBenefitChecks => 'Pro-мен шексіз айтылым тексерісі';

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
  String get emailLabel => 'Email';

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
  String get paywallLeaveTitle => 'Қазір шықсаңыз, жазылым рәсімделмейді';

  @override
  String get paywallLeaveBody =>
      'Артықшылықтар төлемнен кейін бірден ашылады. Менің бетім арқылы кез келген уақытта орала аласыз.';

  @override
  String get ctaKeepLooking => 'Қарауды жалғастыру';

  @override
  String get ctaLeaveAnyway => 'Бәрібір шығу';

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
  String get reviewToSeeScore => 'Қайталасаңыз айтылым ұпайы шығады';

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
  String get unlockedWithMax => 'Max-пен қолжетімді';

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
  String get callExitSubtitle => 'Қазір аяқтасаңыз да бір қоңырау есептеледі';

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
  String get hwTitle => 'Homework';

  @override
  String get hwJoinCodeTitle => 'Enter your class code';

  @override
  String get hwJoinCodeSubtitle => 'It is the 6-digit code from your teacher';

  @override
  String get hwJoinCodeLabel => 'Class code';

  @override
  String get hwJoinCodeHelp => 'The code is not case-sensitive';

  @override
  String get hwJoinConfirmTitle => 'Is this the right class?';

  @override
  String get hwJoinConfirmSubtitle => 'If not, check the code again';

  @override
  String get hwJoinFieldInstitution => 'Institution';

  @override
  String get hwJoinFieldTeacher => 'Teacher';

  @override
  String get hwJoinFieldLearners => 'Learners';

  @override
  String get hwJoinFieldTerm => 'Term';

  @override
  String get hwJoinConfirmNote =>
      'The class name is exactly as your teacher wrote it. We do not translate it.';

  @override
  String get hwJoinConfirmYes => 'Yes, that is it';

  @override
  String get hwJoinConfirmRetry => 'Re-enter code';

  @override
  String get hwJoinProfileTitle => 'What name will you use in class?';

  @override
  String get hwJoinProfileSubtitle =>
      'Your teacher matches this with the roster';

  @override
  String get hwJoinNameLabel => 'Name';

  @override
  String get hwJoinNameHelp => 'It can differ from your app name';

  @override
  String get hwJoinStudentNoLabel => 'Student ID (optional)';

  @override
  String get hwJoinStudentNoHelp => 'Your teacher uses it to match the roster';

  @override
  String get hwJoinConsentTitle => 'What your teacher sees';

  @override
  String get hwJoinConsentSubtitle => 'You must agree to join the class';

  @override
  String get hwJoinConsentSharedHeading => 'Shared with your teacher';

  @override
  String get hwJoinConsentShared1 => 'Class name and student ID';

  @override
  String get hwJoinConsentShared2 => 'Whether you did the homework';

  @override
  String get hwJoinConsentShared3 => 'Sentences passed and missed';

  @override
  String get hwJoinConsentShared4 => 'Assignment call length and summary';

  @override
  String get hwJoinConsentNotSharedHeading => 'Not shared';

  @override
  String get hwJoinConsentNotShared1 => 'Email and phone number';

  @override
  String get hwJoinConsentNotShared2 => 'App name, profile and character';

  @override
  String get hwJoinConsentNotShared3 => 'Nationality and first language';

  @override
  String get hwJoinConsentNotShared4 => 'Calls and study outside the class';

  @override
  String get hwJoinConsentNotShared5 => 'Subscription and payment details';

  @override
  String get hwJoinConsentAgree => 'I agree to the above';

  @override
  String get hwJoinConsentCta => 'Agree and join';

  @override
  String hwJoinDoneTitle(String className) {
    return 'You joined $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count assignments are waiting';
  }

  @override
  String get hwJoinDoneNoAssignment => 'No assignments yet';

  @override
  String get hwJoinDoneNextDue => 'Next due';

  @override
  String get hwJoinDoneRosterName => 'Your class name';

  @override
  String get hwJoinDoneCta => 'See homework';

  @override
  String get hwJoinErrorNotFound => 'We could not find that code';

  @override
  String get hwJoinErrorNotFoundBody => 'Please check the six digits again.';

  @override
  String get hwJoinErrorExpired => 'That code has expired';

  @override
  String get hwJoinErrorExpiredBody => 'Ask your teacher for a new code.';

  @override
  String get hwJoinErrorFull => 'The class is full';

  @override
  String get hwJoinErrorFullBody => 'Please let your teacher know.';

  @override
  String get hwJoinFailed => 'Could not join. Please try again in a moment.';

  @override
  String get hwSectionInProgress => 'In progress';

  @override
  String get hwSectionUpcoming => 'Upcoming';

  @override
  String get hwSectionDone => 'Done';

  @override
  String get hwLeaveClassLink => 'Leave the class';

  @override
  String get hwListEmptyTitle => 'No homework yet';

  @override
  String get hwListEmptyBody =>
      'It will show up here when your teacher assigns it.';

  @override
  String get hwListFailed => 'Could not load your homework.';

  @override
  String get hwRetry => 'Try again';

  @override
  String get hwBadgeDone => 'Done';

  @override
  String get hwBadgeOverdue => 'Not submitted';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Not submitted, ${days}d late';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Due today';

  @override
  String get hwActivitySpeaking => 'Speaking';

  @override
  String get hwActivityConversation => 'Conversation';

  @override
  String get hwActivityWorkbook => 'Workbook';

  @override
  String hwChapterLabel(String chapter) {
    return 'Chapter $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Check your pronunciation score';

  @override
  String get hwTaskConversationDesc => 'Use what you learned in a real talk';

  @override
  String get hwTaskWorkbookDesc => 'Practice by writing in the workbook';

  @override
  String get hwCtaStudy => 'Start';

  @override
  String get hwCtaResult => 'See result';

  @override
  String get hwCtaDownload => 'Download';

  @override
  String get hwSpeakingNoScore => 'You have not done the speaking task yet';

  @override
  String get hwWorkbookUnavailable => 'The workbook file is not available yet.';

  @override
  String get hwDetailClosed =>
      'This assignment is closed. You can no longer submit.';

  @override
  String get hwLeaveTitle => 'Leave the class?';

  @override
  String get hwLeaveBody =>
      'Your teacher will no longer see your homework results.';

  @override
  String get hwLeaveConfirm => 'Leave';

  @override
  String get hwLeaveCancel => 'Stay';

  @override
  String get hwLeaveFailed => 'Could not leave the class.';

  @override
  String get hwMyClass => 'My class';

  @override
  String get hwClassEmptyTitle => 'You have not joined a class';

  @override
  String get hwClassEmptySubtitle => 'Enter the code your teacher gave you';

  @override
  String get hwClassEmptyCta => 'Enter class code';

  @override
  String get hwClassContinueCta => 'Continue';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count assignments are due tomorrow';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'You have $count unsubmitted assignments';
  }

  @override
  String get hwSpeakingUnavailable =>
      'The sentences for this assignment are not available yet.';

  @override
  String get hwBadgeClosed => 'Closed';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$passed of $total sentences passed';
  }
}
