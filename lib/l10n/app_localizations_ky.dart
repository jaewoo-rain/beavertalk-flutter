// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get loginRequired => 'Тиркемеге кириңиз.';

  @override
  String get callWebNotSupported =>
      'Вебде үн чалуу колдоолбойт. Колдонмону пайдаланыңыз.';

  @override
  String get micPermissionRequiredForCall =>
      'Микрофонго уруксат керек. Чалуу үчүн микрофонго уруксат бериңиз.';

  @override
  String get callErrorGeneric => 'Чалуу учурунда ката кетти.';

  @override
  String get callNetworkError => 'Тармак катасы кетти.';

  @override
  String get authInvalidCredentials =>
      'Электрондук почта же сырсөз туура эмес.';

  @override
  String get authEmailAlreadyRegistered => 'Бул электрондук почта катталган.';

  @override
  String get authConfirmEmailRequired =>
      'Почтаңызга жөнөтүлгөн ырастоону аягына чыгарыңыз.';

  @override
  String get authResetCodeSent => 'Ырастоо кодун почтаңызга жөнөттүк.';

  @override
  String get authResetCodeInvalid => 'Код туура эмес же мөөнөтү бүткөн.';

  @override
  String get authPasswordUpdated => 'Сырсөзүңүз калыбына келтирилди.';

  @override
  String get authAppleTokenMissing =>
      'Apple кирүү токенин алуу мүмкүн болгон жок.';

  @override
  String callEndedDuration(String duration) {
    return 'Чалуу $duration аяктады';
  }

  @override
  String get callRatingPrompt => 'Чалуу кандай болду?';

  @override
  String get callRatingBody =>
      'Бааңыз кийинки жолу жакшыраак сүйлөшүүгө жардам берет.';

  @override
  String get callRatingSubmit => 'Жөнөтүү';

  @override
  String get callRatingSkip => 'Өткөрүп жиберүү';

  @override
  String get ratingBad => 'Начар';

  @override
  String get ratingOkay => 'Орточо';

  @override
  String get ratingGood => 'Жакшы';

  @override
  String get goHome => 'Башкы бет';

  @override
  String get viewAnalysis => 'Анализди көрүү';

  @override
  String get loadingShort => 'Жүктөлүүдө…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Бааны жөнөтүү ишке ашкан жок: $message';
  }

  @override
  String get callInfoNotFound =>
      'Чалуу маалыматы табылган жок, анализ өткөрүлбөйт.';

  @override
  String get tabRecords => 'Жазуулар';

  @override
  String get tabArchive => 'Архив';

  @override
  String get callHistory => 'Чалуулар тарыхы';

  @override
  String get conversationRecord => 'Маек жазуусу';

  @override
  String get noCallRecords => 'Азырынча чалуу жазуулары жок';

  @override
  String get noCallRecordsBody =>
      'AI менен биринчи чалууну аяктаганыңыздан кийин,\nжазууларыңыз бул жерде көрүнөт.';

  @override
  String get startCall => 'Чалууну баштоо';

  @override
  String get recordsLoadError => 'Жазууларды жүктөп болбоду';

  @override
  String get tryAgainLater => 'Кийинчерээк кайра аракет кылыңыз.';

  @override
  String get retry => 'Кайталоо';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes мүн $seconds сек';
  }

  @override
  String get scheduleManagement => 'Жадыбал';

  @override
  String get alarms => 'Ойготкучтар';

  @override
  String get alarmAdd => 'Ойготкуч кошуу';

  @override
  String get alarmEdit => 'Ойготкучту өзгөртүү';

  @override
  String get alarmEveryDay => 'Күн сайын';

  @override
  String get alarmWeekdays => 'Иш күндөрү';

  @override
  String get alarmWeekend => 'Дем алыш күндөрү';

  @override
  String get alarmNoRepeat => 'Кайталанбайт';

  @override
  String get addSchedule => 'Жадыбал кошуу';

  @override
  String get editSchedule => 'Жадыбалды түзөтүү';

  @override
  String get somethingWentWrong => 'Бир нерсе туура эмес болду';

  @override
  String get alarmsLoadError => 'Ойготкучтарды жүктөп болбоду';

  @override
  String get charactersLoadError => 'Каармандарды жүктөп болбоду';

  @override
  String get noCharacters => 'Каармандар жеткиликсиз';

  @override
  String get close => 'Жабуу';

  @override
  String get repeat => 'Кайталоо';

  @override
  String get callPartner => 'Каарман';

  @override
  String get quickStart => 'Тез баштоо';

  @override
  String get presetMorning => 'Эртең мененки адат';

  @override
  String get presetMorningSub => 'Жумуш күндөрү 8:00';

  @override
  String get presetEvening => 'Кечки жыйынтык';

  @override
  String get presetEveningSub => 'Күн сайын 21:00';

  @override
  String get presetCustom => 'Өзүм тандайм';

  @override
  String get presetCustomSub => 'Каалагандай';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Жумасына $count× · айына $monthly чалуу';
  }

  @override
  String get alarmSummaryNone => 'Жок дегенде бир күн тандаңыз';

  @override
  String get partnerInUse => 'Колдонулууда';

  @override
  String get partnerOwned => 'Бар';

  @override
  String get am => 'Түшкө чейин';

  @override
  String get pm => 'Түштөн кийин';

  @override
  String get save => 'Сактоо';

  @override
  String get conversation => 'Маек';

  @override
  String get review => 'Карап чыгуу';

  @override
  String get pronunciationChallenge => 'Айтылыш чакырыгы';

  @override
  String get newExpressions => 'Жаңы сөз айкаштары';

  @override
  String get usedExpressions => 'Сиз колдонгон сөз айкаштары';

  @override
  String quizExpressionsCount(int count) {
    return 'Expressions you learned $count';
  }

  @override
  String get quizPassed => 'Got it';

  @override
  String get quizFailed => 'Review again';

  @override
  String get quizPending => 'Continue next time';

  @override
  String get analysisResult => 'Анализ жыйынтыгы';

  @override
  String get noNewExpressions => 'Бул маектен жаңы сөз айкаштары табылган жок.';

  @override
  String get practice => 'Көнүгүү';

  @override
  String recentScore(int score) {
    return 'Акыркы упай $score%';
  }

  @override
  String callSequence(int count) {
    return '$count-чалуу';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name айткан бир ооз сөз';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Чалуудан кийин дароо $name калтырды';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Жаңы сөз айкаштары $count';
  }

  @override
  String get analysisLoadError => 'Анализ жыйынтыгын жүктөп болбоду.';

  @override
  String get standardAudioNotReady => 'Үлгү айтылыш аудиосу дагы даяр эмес.';

  @override
  String get standardAudioPlayError => 'Үлгү айтылыш аудиосун ойнотуп болбоду.';

  @override
  String get selectNativeLanguage => 'Эне тилиңизди тандаңыз';

  @override
  String get selectYourLanguage => 'Тилиңизди тандаңыз';

  @override
  String get confirm => 'Ырастоо';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get selectTime => 'Убакытты тандоо';

  @override
  String get getStarted => 'Баштоо';

  @override
  String get permissionTitle => 'Ыңгайлуу тажрыйба үчүн\nуруксаттарды бериңиз';

  @override
  String get permissionSubtitle =>
      'Кызматты пайдалануу үчүн керектүү уруксаттар зарыл.';

  @override
  String get permissionMicTitle => 'Микрофон (милдеттүү)';

  @override
  String get permissionMicDesc =>
      'AI менен англис тилинде сүйлөшүү үчүн керек.';

  @override
  String get permissionNotifTitle => 'Билдирүүлөр (милдеттүү эмес)';

  @override
  String get permissionNotifDesc =>
      'Биз окуу эскертүүлөрүн жана чалуу жадыбалдарын жиберебиз.';

  @override
  String get micPermissionNeededTitle => 'Микрофонго кирүү керек';

  @override
  String get micPermissionNeededBody =>
      'AI менен сүйлөшүү үчүн микрофонго кирүүгө уруксат берүү керек. Аны Жөндөөлөрдөн иштетиңиз.';

  @override
  String get openSettings => 'Жөндөөлөрдү ачуу';

  @override
  String get connectionFailedTitle => 'Байланыш ишке ашкан жок';

  @override
  String get connectionFailedBody =>
      'Тармак байланышыңызды текшерип,\nкайра аракет кылыңыз.';

  @override
  String get checkout => 'Төлөм жасоо';

  @override
  String get pay => 'Төлөө';

  @override
  String get orderSummary => 'Буйрутма жыйынтыгы';

  @override
  String get paymentMethod => 'Төлөм ыкмасы';

  @override
  String get payMethodCard => 'Кредиттик / Дебеттик карта';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Тентек Кундуз аватары';

  @override
  String get productTrait => 'Премиум каарман · Түбөлүккө сиздики';

  @override
  String get amountItemPrice => 'Товар баасы';

  @override
  String get amountDiscount => 'Арзандатуу';

  @override
  String get amountTotal => 'Жалпы суммасы';

  @override
  String get paymentCompleteTitle => 'Төлөм аяктады';

  @override
  String get paymentCompleteBody => 'Аватар жыйнагыңызга кошулду.';

  @override
  String get viewCollection => 'Жыйнакты көрүү';

  @override
  String get receiptItem => 'Товар';

  @override
  String get receiptAmount => 'Сумма';

  @override
  String get receiptMethod => 'Төлөм ыкмасы';

  @override
  String get receiptDate => 'Күнү';

  @override
  String get paymentFailedTitle => 'Төлөм ишке ашкан жок';

  @override
  String get paymentFailedBody =>
      'Төлөмүңүздү иштетүү мүмкүн болгон жок.\nКайра аракет кылыңыз.';

  @override
  String get freeCallEndingTitle => 'Акысыз чалууңуз аяктап баратат';

  @override
  String get freeCallEndingBody =>
      'Кундуз менен узагыраак сүйлөшүү үчүн жазылыңыз.';

  @override
  String get subscribe => 'Жазылуу';

  @override
  String get endCall => 'Чалууну аяктоо';

  @override
  String get callEnded => 'Чалуу аяктады.';

  @override
  String get connecting => 'Туташууда…';

  @override
  String get connectingHint => 'Бул адатта 5 секунддан аз убакыт алат';

  @override
  String get callConnectFailed => 'Чалууну туташтырып болбоду.';

  @override
  String get saveSentenceFailed => 'Сүйлөмдү сактап болбоду.';

  @override
  String get recordStartFailed => 'Жаздырууну баштап болбоду.';

  @override
  String get recordTooShort => 'Жазуу өтө кыска болду. Кайра аракет кылыңыз.';

  @override
  String get gradingFailed => 'Баалоо ишке ашкан жок. Кайра аракет кылыңыз.';

  @override
  String get listenStandard => 'Үлгү айтылышты угуу';

  @override
  String get saveSentence => 'Сүйлөмдү сактоо';

  @override
  String get unsaveSentence => 'Сакталган сүйлөмдү өчүрүү';

  @override
  String get scoringPronunciation => 'Айтылышыңыз бааланууда…';

  @override
  String get analyzingByWord => 'Айтылышыңызды сөзмө-сөз текшерип жатабыз';

  @override
  String get analyzingTakingLonger => 'Бул бир аз узагыраак убакыт алууда';

  @override
  String get scanConnectionLost => 'Байланыш үзүлдү';

  @override
  String get noRecordingToPlay => 'Ойнотуу үчүн жазуу жок.';

  @override
  String get myRecordingPlayError => 'Жазууңузду ойнотуп болбоду.';

  @override
  String get next => 'Кийинки';

  @override
  String get endLearning => 'Сабакты аяктоо';

  @override
  String get navCalendar => 'Күнтизме';

  @override
  String get navCall => 'Чалуу';

  @override
  String get navStats => 'Статистика';

  @override
  String get homeCourseExpression => 'Сөз айкаштары';

  @override
  String get homeCourseFreetalk => 'Эркин маек';

  @override
  String homeExpressionsLeft(int count) {
    return 'Эркин маекке $count сөз айкашы калды';
  }

  @override
  String get homeFreetalkNote => 'Үйрөнгөнүңүздү колдонуп эркин сүйлөшүңүз';

  @override
  String get homeTalkTitle => 'Бүгүн эмне болду?';

  @override
  String get homeTalkNote => 'Эркин сүйлөшүп, жол-жолой үйрөнүңүз.';

  @override
  String get homeModeLearn => 'Окуу';

  @override
  String get homeModeTalk => 'Сүйлөшүү';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'катары менен $count күн',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Окуу календары';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'күн катары менен',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Чалуу убактысы';

  @override
  String get streakMetricCalls => 'Чалуулар';

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мүн',
    );
    return '$_temp0';
  }

  @override
  String streakCallCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чалуу',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'Бул күнү чалуу болгон жок.';

  @override
  String get homeLevelPending => 'Деңгээл белгисиз';

  @override
  String get homeNoLevelTitle => 'Сизде азырынча деңгээл жок';

  @override
  String get homeNoLevelNote => 'Биринчи чалууну аяктасаңыз, деңгээл чыгат';

  @override
  String get homeCurriculumPendingBadge => 'Coming soon';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language curriculum is on its way';
  }

  @override
  String get homeCurriculumPendingNote =>
      'You\'ll practice general expressions on your calls';

  @override
  String get myPage => 'Менин баракчам';

  @override
  String get languageSaveFailed => 'Тилиңизди сактап болбоду.';

  @override
  String get accountDeleteFailed => 'Аккаунтуңузду өчүрүп болбоду.';

  @override
  String get changeAvatar => 'Аватарды алмаштыруу';

  @override
  String get avatarUseNow => 'Азыр колдонуу';

  @override
  String get avatarPurchaseFailed => 'Сатып алуу аяктаган жок';

  @override
  String avatarPromoTitle(int percent) {
    return 'Бүгүн гана · $percent% арзандатуу';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time калды';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days к. $time калды';
  }

  @override
  String get avatarIntro =>
      'Үн жана татаалдык чалуу шеригине жараша ар түрдүү болот.\nАйрым шериктер төлөмдү талап кылышы мүмкүн.';

  @override
  String myPartnersOwned(int count) {
    return 'Менин шериктерим · $count даана бар';
  }

  @override
  String get limitedDiscount => 'Убактылуу арзандатуу';

  @override
  String get available => 'Жеткиликтүү';

  @override
  String get inUse => 'Колдонулууда';

  @override
  String get owned => 'Сизде бар';

  @override
  String get noCharactersToShow => 'Көрсөтүлүүчү каармандар жок';

  @override
  String get buy => 'Сатып алуу';

  @override
  String get noSavedSentences =>
      'Азырынча сакталган сүйлөмдөр жок.\nМаек жазууларыңыздан сүйлөмдөрдү белгилеп коюңуз.';

  @override
  String get noAlarms => 'Азырынча ойготкучтар жок';

  @override
  String get noAlarmsBody =>
      'Туруктуу адат калыптандыруу үчүн\nокуу эскертүүсүн кошуңуз.';

  @override
  String get subscriptionManage => 'Жазылууну башкаруу';

  @override
  String get cancelSubscription => 'Жазылууну жокко чыгаруу';

  @override
  String get benefitsInUse => 'Сиздин артыкчылыктарыңыз';

  @override
  String get paymentInfo => 'Төлөм маалыматы';

  @override
  String get nextBillingDate => 'Кийинки төлөм күнү';

  @override
  String get lostBenefitsTitle => 'Жокко чыгарсаңыз жоготуучу артыкчылыктар';

  @override
  String get viewBillingHistory => 'Төлөм тарыхын көрүү';

  @override
  String pricePerMonth(String price) {
    return '$price / айына';
  }

  @override
  String get benefitDetailedAnalysis =>
      'Айтылыш жана грамматиканын кеңири анализи';

  @override
  String get benefitAllCharacters => 'Бардык каармандарга кирүү';

  @override
  String get benefitNoAds => 'Жарнамасыз';

  @override
  String get playSampleVoice => 'Үлгү үндү ойнотуу';

  @override
  String get useThisAvatar => 'Муну колдонуу';

  @override
  String get challengeTitle => 'Айтылыш чакырыгы';

  @override
  String get challengeIntro =>
      'Аймактагы ар бир картаны корей тилинде туура айтып, аны тазалаңыз.\nМикрофон жокпу? Экранды басып да ойной аласыз.';

  @override
  String get challengeStart => 'Камера жана микрофонду баштоо';

  @override
  String get challengePermissionNote =>
      'Алдыңкы камера жана микрофонго кирүү керек (милдеттүү эмес).';

  @override
  String get challengeLoadingTitle => 'Жүктөлүүдө…';

  @override
  String get challengeLoadingNote => 'Камера жана микрофон даярдалууда.';

  @override
  String get challengeSttFallback =>
      'Үн таануу жеткиликсиз болгондуктан, экранды басуу менен ойноодуңуз.';

  @override
  String get reasonTravelTitle => 'Саякаттоодо сүйлөшүү';

  @override
  String get reasonTravelDesc =>
      'Жергиликтүү тургундар менен ишенимдүү маектешиңиз';

  @override
  String get reasonCareerTitle => 'Иш жана карьера';

  @override
  String get reasonCareerDesc => 'Иш маеги';

  @override
  String get reasonExamTitle => 'Экзаменге даярдануу';

  @override
  String get reasonExamDesc => 'Оозеки экзамендерге даярданыңыз';

  @override
  String get reasonDailyTitle => 'Күнүмдүк маек';

  @override
  String get reasonDailyDesc => 'Күн сайын колдонгон сөз айкаштары';

  @override
  String get reasonFriendsTitle => 'Чет элдик достор табуу';

  @override
  String get reasonFriendsDesc => 'Табигый маек';

  @override
  String get reasonBrainTitle => 'Мээни жандандыруу';

  @override
  String get reasonBrainDesc =>
      'Эстутум жана көңүл буруунун деңгээлин жогорулатуу';

  @override
  String get challengeRecordToggle => 'Бул сессияны жаздыруу';

  @override
  String get challengeRecordHint =>
      'Оюнуңуздун видеосун бөлүшүү үчүн сактайт (үнсүз).';

  @override
  String get settingsSection => 'Жөндөөлөр';

  @override
  String get paymentSection => 'Төлөм';

  @override
  String get supportSection => 'Колдоо';

  @override
  String get userLanguage => 'Колдонуучунун тили';

  @override
  String get learningLanguage => 'Үйрөнүлүүчү тил';

  @override
  String get learningLanguageKorean => 'Корей тили';

  @override
  String get notificationLabel => 'Билдирүү';

  @override
  String get currentPlan => 'Учурдагы план';

  @override
  String get paymentHistory => 'Төлөм тарыхы';

  @override
  String get contactUs => 'Биз менен байланышуу';

  @override
  String get termsOfService => 'Кызмат көрсөтүү шарттары';

  @override
  String get privacyPolicy => 'Купуялык саясаты';

  @override
  String get logOut => 'Чыгуу';

  @override
  String get deleteAccount => 'Аккаунтту өчүрүү';

  @override
  String get deleteAccountTitle => 'Аккаунтту өчүрөсүзбү?';

  @override
  String get deleteAccountBody =>
      'Бул аккаунтуңузду жана маалыматтарыңызды биротоло өчүрөт, аны кайра калыбына келтирүү мүмкүн эмес.';

  @override
  String get delete => 'Өчүрүү';

  @override
  String get share => 'Бөлүшүү';

  @override
  String get accentSoundsLike => 'Сиздин корей акценти мындай угулат';

  @override
  String get hintLabel => 'Кеп';

  @override
  String get nextHint => 'Кийинки кеп';

  @override
  String get translateLabel => 'Которуу';

  @override
  String get startRecording => 'Жаздырууну баштоо';

  @override
  String get stopRecording => 'Жаздырууну токтотуу';

  @override
  String get back => 'Артка';

  @override
  String get onboardingNameTitle => 'Сизди кантип атайлы?';

  @override
  String get onboardingNameSubtitle =>
      'AI мугалимиңиз атыңызды эсинде сактайт.';

  @override
  String get nameLabel => 'Атыңыз';

  @override
  String get nameHint => 'Атыңызды киргизиңиз';

  @override
  String get nameHelper =>
      'Чыныгы атыңыз болушу шарт эмес — лакап атыңыз да ылайыктуу.';

  @override
  String get continueLabel => 'Улантуу';

  @override
  String get onboardingDoneTitle => 'Кундуз чалууңузду күтүп жатат';

  @override
  String get onboardingDoneSubtitle => 'Азыр эле чалууну баштаңыз';

  @override
  String get home => 'Башкы бет';

  @override
  String get callNow => 'Азыр чалуу';

  @override
  String get pronunciation => 'Айтылыш';

  @override
  String get fluency => 'Эркиндик';

  @override
  String get rhythm => 'Ритм';

  @override
  String get analysisTimeout =>
      'Бул күтүлгөндөн узагыраак убакыт алып жатат. Бир азга кийин кайра аракет кылыңыз.';

  @override
  String get analysisFailed =>
      'Маекти талдай алган жокпуз. Кайра аракет кылыңыз.';

  @override
  String get analyzingConversation => 'Маегиңиз талдануудa…';

  @override
  String get analyzingSubtitle => 'Бул бир аз убакыт гана алат';

  @override
  String get tryAgain => 'Кайра аракет кылуу';

  @override
  String get nativeLabel => 'Эне тилинде';

  @override
  String get meLabel => 'Мен';

  @override
  String get pronunciationPlayError => 'Айтылыш аудиосун ойнотуп болбоду.';

  @override
  String get savedExpressionsLoadError =>
      'Сакталган сөз айкаштарыңызды жүктөп болбоду.';

  @override
  String get mySavedExpressions => 'Менин сакталган сөз айкаштарым';

  @override
  String get avatarTraits => 'Жылуу · Тынч · Жумшак';

  @override
  String get priceFree => 'Акысыз';

  @override
  String get loginGoogleTokenError => 'Google кирүү токенин алып болбоду.';

  @override
  String get loginGoogleSignInFailed => 'Google аркылуу кирүү ишке ашкан жок.';

  @override
  String get loginAppleSignInFailed => 'Apple аркылуу кирүү ишке ашкан жок.';

  @override
  String get loginFacebookSignInFailed =>
      'Facebook аркылуу кирүү ишке ашкан жок.';

  @override
  String get loginKakaoSignInFailed => 'Kakao аркылуу кирүү ишке ашкан жок.';

  @override
  String get loginContinueWithKakao => 'Kakao аркылуу улантуу';

  @override
  String get loginContinueWithGoogle => 'Google аркылуу улантуу';

  @override
  String get loginContinueWithFacebook => 'Facebook аркылуу улантуу';

  @override
  String get loginContinueWithApple => 'Apple аркылуу улантуу';

  @override
  String get loginContinueWithEmail => 'Электрондук почта менен улантуу';

  @override
  String get loginOrDivider => 'же';

  @override
  String get loginNoAccount => 'Аккаунтуңуз жокпу?';

  @override
  String get signUp => 'Катталуу';

  @override
  String get loginTermsNoticePrefix => 'Улантуу менен сиз биздин ';

  @override
  String get loginTermsNoticeAnd => ' жана ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Кирүү';

  @override
  String get fieldEmailLabel => 'Электрондук почта';

  @override
  String get emailHint => 'Электрондук почтаңызды киргизиңиз';

  @override
  String get fieldPasswordLabel => 'Сырсөз';

  @override
  String get passwordHint => 'Сырсөзүңүздү киргизиңиз';

  @override
  String get loginRememberMe => 'Мени эстеп кал';

  @override
  String get loginForgotPassword => 'Сырсөзүңүздү унутуп калдыңызбы?';

  @override
  String get loginLoggingIn => 'Кирилүүдө...';

  @override
  String get passwordLengthError => 'Сырсөз 8–16 белгиден турушу керек.';

  @override
  String get passwordsDoNotMatch => 'Сырсөздөр дал келген жок.';

  @override
  String get signupCheckInput => 'Киргизген маалыматты текшериңиз.';

  @override
  String get fieldConfirmPasswordLabel => 'Сырсөздү ырастоо';

  @override
  String get confirmPasswordHint => 'Сырсөзүңүздү кайра киргизиңиз';

  @override
  String get signupSigningUp => 'Катталууда...';

  @override
  String get signupHaveAccount => 'Аккаунтуңуз бар беле?';

  @override
  String get passwordMethodEmailRequired => 'Электрондук почтаңызды киргизиңиз';

  @override
  String get passwordResetTitle => 'Сырсөздү калыбына келтирүү';

  @override
  String get passwordMethodDescription =>
      'Сырсөздү калыбына келтирүү кодун алгыңыз келген электрондук почта дарегин киргизиңиз.';

  @override
  String get emailAddressHint => 'Электрондук почта дареги';

  @override
  String get passwordMethodSending => 'Жөнөтүлүүдө...';

  @override
  String get passwordMethodSendEmail => 'Кат жөнөтүү';

  @override
  String get passwordCodeTitle => 'Кодду киргизиңиз';

  @override
  String get passwordCodeDescription =>
      'Электрондук почтаңызга калыбына келтирүү кодун жөнөттүк. Улантуу үчүн аны киргизиңиз.';

  @override
  String get passwordCodeNoCode => 'Код келген жокпу?';

  @override
  String get passwordCodeResend => 'Кодду кайра жөнөтүү';

  @override
  String get passwordCodeVerifying => 'Текшерилүүдө...';

  @override
  String get passwordNewTitle => 'Жаңы сырсөз';

  @override
  String get passwordNewDescription => 'Аккаунтуңуз үчүн жаңы сырсөз коюңуз.';

  @override
  String get fieldNewPasswordLabel => 'Жаңы сырсөз';

  @override
  String get newPasswordHint => 'Жаңы сырсөзүңүздү киргизиңиз';

  @override
  String get fieldConfirmNewPasswordLabel => 'Жаңы сырсөздү ырастоо';

  @override
  String get confirmNewPasswordHint => 'Жаңы сырсөзүңүздү кайра киргизиңиз';

  @override
  String get passwordNewSubmitting => 'Жөнөтүлүүдө...';

  @override
  String get passwordNewSubmit => 'Жөнөтүү';

  @override
  String get passwordCompleteTitle => 'Сырсөз калыбына келтирилди';

  @override
  String get passwordCompleteBody =>
      'Сырсөзүңүз калыбына келтирилди. Улантуу үчүн жаңы сырсөзүңүз менен кириңиз.';

  @override
  String get termsTitle => 'Кызмат көрсөтүү шарттары';

  @override
  String get privacyTitle => 'Купуялык саясаты';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email үчүн жаңы сырсөз коюңуз.';
  }

  @override
  String get selectComplete => 'Бүттү';

  @override
  String get onboardingLanguageTitle => 'Сиздин эне тилиңиз кайсы?';

  @override
  String get onboardingReasonTitle => 'Эмне үчүн тил үйрөнүп жатасыз?';

  @override
  String get onboardingReasonSubtitle =>
      'Биз үйрөнүүнү сиздин максаттарыңызга ылайыкташтырабыз.';

  @override
  String get savingLabel => 'Сакталууда...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Ушул айдагы төлөм';

  @override
  String get filterAll => 'Баары';

  @override
  String get filterSubscription => 'Жазылуу';

  @override
  String get filterCharacter => 'Каарман';

  @override
  String get statusCompleted => 'Аяктады';

  @override
  String get lastPayment => 'Акыркы төлөм';

  @override
  String get freePlanCallLimit => 'Күнүнө 1 чалуу · 5 мүн чектөө';

  @override
  String get freePlanBasicCharacters => 'Негизги каармандар кирет';

  @override
  String get availableForPurchase => 'Сатып алууга болот';

  @override
  String get paymentsLoadError => 'Төлөм тарыхын жүктөө мүмкүн болбоду';

  @override
  String get noPayments => 'Азырынча төлөм жок';

  @override
  String get morePaymentsExist => 'Эски төлөмдөр азырынча көрсөтүлбөйт';

  @override
  String get undatedPayments => 'Күнү жок';

  @override
  String get paymentLabelFallback => 'Төлөм';

  @override
  String learningPassed(int passed, int total) {
    return '$total сүйлөмдүн $passed өттү';
  }

  @override
  String get hardestSound => 'Бүгүнкү эң кыйын үн';

  @override
  String get soundAccuracy => 'Үн боюнча тактык';

  @override
  String phonemeAttempts(int count) {
    return 'Фонема боюнча · $count аракет';
  }

  @override
  String get colSound => 'Үн';

  @override
  String get colAttempts => 'Арак.';

  @override
  String get colCorrect => 'Туура';

  @override
  String get colAccuracy => 'Тактык';

  @override
  String get sentenceResults => 'Сүйлөм боюнча жыйынтык';

  @override
  String viewAllSentences(int count) {
    return 'Бардыгын көрүү $count';
  }

  @override
  String get colSentence => 'Сүйлөм';

  @override
  String get colPronunciation => 'Айтыл.';

  @override
  String get colFluency => 'Эркин.';

  @override
  String get colRhythm => 'Ыргак';

  @override
  String recentSessions(int count) {
    return 'Акыркы $count сеанс';
  }

  @override
  String trendAverage(int score) {
    return 'Орт. $score';
  }

  @override
  String get today => 'Бүгүн';

  @override
  String get colDate => 'Күнү';

  @override
  String get colSentences => 'Сүйлөм';

  @override
  String get colScore => 'Упай';

  @override
  String get colChange => 'Өзг.';

  @override
  String dateToday(String date) {
    return '$date (бүгүн)';
  }

  @override
  String get accentAnalysis => 'Акцент талдоосу';

  @override
  String get overallLevel => 'Жалпы деңгээл';

  @override
  String get overallLevelSubtitle => 'Лексика · Грамматика · Сөз айкаштары';

  @override
  String get pronunciationAnalysis => 'Айтылыш талдоосу';

  @override
  String get recentSessionsAverage => 'Акыркы 10 сессиянын орточосу';

  @override
  String levelStage(int stage) {
    return '$stage-деңгээл';
  }

  @override
  String topPercent(int percent) {
    return 'Мыкты $percent%';
  }

  @override
  String get allLearnersBasis => 'Бардык окуучулардын арасында';

  @override
  String aheadOfLearners(int percent) {
    return 'Сиз окуучулардын $percent%нан алдыдасыз';
  }

  @override
  String get retakeLevelTest => 'Деңгээл тестин кайра тапшыруу';

  @override
  String get practicePronunciation => 'Айтылышты машыктыруу';

  @override
  String get priceChangedTitle => 'Баа өзгөрдү';

  @override
  String priceChangedBody(String price) {
    return 'Бул товар эми $price турат. Улантасызбы?';
  }

  @override
  String get billingGroupPlanPurchases => 'План жана сатып алуулар';

  @override
  String get billingGroupInTheStore => 'Дүкөндө';

  @override
  String get billingCompareAllPlans => 'Бардык пландарды салыштыруу';

  @override
  String get billingBuyACharacter => 'Каарман сатып алуу';

  @override
  String get billingRestorePurchases => 'Сатып алууларды калыбына келтирүү';

  @override
  String get billingRedeemCode => 'Кодду колдонуу';

  @override
  String get billingPaymentHistory => 'Төлөм тарыхы';

  @override
  String get billingManageInTheStore => 'Дүкөндө башкаруу';

  @override
  String get billingRefundHelp => 'Кайтарым боюнча жардам';

  @override
  String get billingCancelSubscription => 'Жазылууну жокко чыгаруу';

  @override
  String get billingResubscribe => 'Кайра жазылуу';

  @override
  String get badgeCurrent => 'Учурдагы';

  @override
  String get badgeTrial => 'Сыноо';

  @override
  String get badgeRenewing => 'Узартылат';

  @override
  String get badgePastDue => 'Төлөм кечиккен';

  @override
  String get badgePaused => 'Токтотулган';

  @override
  String get badgeCanceling => 'Жокко чыгарылууда';

  @override
  String get subscriptionTitle => 'Жазылуу';

  @override
  String get plansTitle => 'Пландар';

  @override
  String get planFree => 'Акысыз';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Күн сайын 15 мүнөттүк видео чалуу';

  @override
  String get premiumBulletAnalysis => 'Айтылышты толук талдоо';

  @override
  String get premiumBulletWeakSounds =>
      'Тилиңизге ылайык кыйын тыбыштарды машыгуу';

  @override
  String get noteCharactersSeparate =>
      'Каармандар өзүнчө сатылат. Сатып алгандарыңыз сиздики бойдон калат.';

  @override
  String get ctaGetPremium => 'Premium алуу';

  @override
  String get planMaxTrial => 'Premium сыноо';

  @override
  String get freePlanPriceLine => '\$0.00 — күнүнө бир чалуу';

  @override
  String pricePerMonthLine(String amount) {
    return 'Айына $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date чейин акысыз';
  }

  @override
  String get todaysCalls => 'Бүгүнкү чалуулар';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit ичинен $used колдонулду';
  }

  @override
  String get firstPaymentLabel => 'Биринчи төлөм';

  @override
  String get nextPaymentLabel => 'Кийинки төлөм';

  @override
  String get retryingUntilLabel => 'Кайталоо мөөнөтү';

  @override
  String get pausedSinceLabel => 'Токтотулган күнү';

  @override
  String planEndsLabel(String plan) {
    return '$plan аяктайт';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium менен бетме-бет сүйлөшүңүз';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Видео чалуу · күнүнө 15 мүнөт · айына $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Жылдык планга өтүңүз';

  @override
  String get bannerPaymentFailedTitle => 'Төлөм ишке ашкан жок';

  @override
  String get bannerPaymentFailedSub =>
      'Premium сакталышы үчүн дүкөндө төлөмдү жаңыртыңыз';

  @override
  String get bannerPausedTitle => 'Планыңыз токтотулду';

  @override
  String get bannerPausedSub => 'Төлөм өтпөй койду';

  @override
  String get noteRestoreHint =>
      'Башка түзмөктө жазылгансызбы? Калыбына келтирүү аны бул түзмөккө кайтарат.';

  @override
  String get noteStoreHandled =>
      'Төлөм ыкмасы, план өзгөртүү жана жокко чыгаруу дүкөн аркылуу жүргүзүлөт.';

  @override
  String noteTrialEnds(String date) {
    return 'Сыноо мөөнөтүңүз $date аяктайт. Ага чейин дүкөндө жокко чыгарсаңыз, эч нерсе алынбайт.';
  }

  @override
  String get noteGrace =>
      'Жеңилдик мезгилинде артыкчылыктар иштей берет. Жокко чыгаруу колдонмодо эч качан тосулбайт.';

  @override
  String get noteHold =>
      'Төлөм өткөнгө чейин Premium токтотулуп турат. Каармандарыңыз жана прогрессиңиз сакталат.';

  @override
  String noteEnding(String date) {
    return 'Планыңыз аяктаганы турат. Артыкчылыктар $date чейин иштейт, андан кийин Акысызга өтөсүз. Каалаган убакта кайра жазылсаңыз болот.';
  }

  @override
  String get trialExpiredTitle => 'Premium сыноо мөөнөтүңүз аяктады';

  @override
  String get trialExpiredSub => 'Азыр Акысыз пландасыз';

  @override
  String get seePlans => 'Пландарды көрүү';

  @override
  String get currentPlanTitle => 'Учурдагы план';

  @override
  String get perMonthUnit => 'айына';

  @override
  String get planTaglineMax => 'Эми аларды көрө аласыз.';

  @override
  String get planTaglineFree => 'Күнүнө бир чалуу. Акысыз.';

  @override
  String get bulletProCorrections => 'Эне тилиңизге ылайыкталган оңдоолор';

  @override
  String get bulletFreeCall => 'Күнүнө бир 5 мүнөттүк үн чалуу';

  @override
  String get bulletFreeCheck => 'Алгачкы 3 чалууга толук талдоо';

  @override
  String get bulletFreeCharacter => 'Баштоо үчүн 2 каарман';

  @override
  String get ctaTurnOnVideo => 'Видеону күйгүзүү';

  @override
  String get noteCallLength => 'Premium: күнүнө 1 чалуу, 15 мүнөткө чейин.';

  @override
  String get paywallProTitle1 => 'Түнкү саат 3тө да ойгоо';

  @override
  String get paywallProTitle2 => 'корей досуңуз';

  @override
  String get paywallLimitHeadline => 'Premium менен 15 мүнөт сүйлөшөсүз.';

  @override
  String get limitBannerCallTitle => 'Бул бүгүнкү чалуу болду';

  @override
  String get limitBannerCallSub => 'Акысыз планда күнүнө бир чалуу';

  @override
  String get limitBannerCheckTitle => 'Бул бүгүнкү текшерүү болду';

  @override
  String get limitBannerCheckSub => 'Акысыз планда күнүнө бир текшерүү';

  @override
  String get bulletProCharactersForever =>
      'Сатып алган каармандарыңыз түбөлүк сиздики';

  @override
  String get paywallMaxTitle => 'Эми аларды көрө аласыз.';

  @override
  String get planMonthly => 'Айлык';

  @override
  String get planAnnual => 'Жылдык';

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
    return 'Айына $price · дүкөндө каалаган убакта жокко чыгарса болот';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Айына $price · дүкөндө каалаган убакта жокко чыгарса болот';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 күн акысыз, андан кийин Айына $price · дүкөндө каалаган убакта жокко чыгарса болот';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Жокко чыгарылганга чейин автоматтык түрдө жаңырат.';

  @override
  String get footerTerms => 'Шарттар';

  @override
  String get footerPrivacy => 'Купуялык';

  @override
  String get processingTitle => 'Сатып алууңуз ырасталууда';

  @override
  String get processingSub => 'Бул адатта бир нече секунд гана созулат.';

  @override
  String get successProTitle => 'Сиз Premium пландасыз.';

  @override
  String get successMaxTitle => 'Эми аларды көрө аласыз.';

  @override
  String get successMaxSub =>
      'Видео чалуулар күйдү. Каалаган чалууда видео баскычын басыңыз.';

  @override
  String get ctaStartAVideoCall => 'Видео чалууну баштоо';

  @override
  String get ctaSeeYourSubscription => 'Жазылууңузду көрүү';

  @override
  String successMaxCaption(String price) {
    return 'Жокко чыгарганга чейин ай сайын $price алынат. Дүкөндө каалаган убакта башкарыңыз же жокко чыгарыңыз.';
  }

  @override
  String get plansErrorTitle => 'Пландарды жүктөп болбоду';

  @override
  String get plansErrorSub => 'Дүкөндөн жооп келген жок.';

  @override
  String get ctaTryAgain => 'Кайра аракет кылуу';

  @override
  String get plansErrorCaption => 'Эч нерсе алынган жок.';

  @override
  String get ctaKeepMax => 'Premium калсын';

  @override
  String get winbackSkip => 'Өткөрүп жиберүү';

  @override
  String get winbackTitle => 'Premium планыңыз аяктады';

  @override
  String get winbackSub => 'Азыр Акысыз пландасыз — күнүнө бир чалуу.';

  @override
  String get winbackQuestion => 'Эмне үчүн кеткениңизди айтып бересизби?';

  @override
  String get winbackReasonExpensive => 'Өтө кымбат';

  @override
  String get winbackReasonUnused => 'Жетиштүү колдонгон жокмун';

  @override
  String get winbackReasonMissing => 'Керектүү функция жок болчу';

  @override
  String get winbackReasonOtherApp => 'Башка колдонмо таптым';

  @override
  String get winbackReasonElse => 'Башка себеп';

  @override
  String get ctaSend => 'Жөнөтүү';

  @override
  String get ctaNotNow => 'Азыр эмес';

  @override
  String get winbackCaption =>
      'Бул планыңызды калыбына келтирбейт. Дүкөндө кайра жазылыңыз.';

  @override
  String get ctaContinue => 'Улантуу';

  @override
  String get ctaClose => 'Жабуу';

  @override
  String get ovRestoreSuccessTitle => 'Premium кайтып келди';

  @override
  String get ovRestoreSuccessBody =>
      'Жазылууңузду таптык жана бул түзмөктө кайра күйгүздүк.';

  @override
  String get ovRestoreEmptyTitle => 'Калыбына келтире турган эч нерсе жок';

  @override
  String get ovRestoreEmptyBody =>
      'Бул дүкөн аккаунтуна активдүү жазылуу байланышкан эмес.';

  @override
  String get ovRestoreOtherTitle => 'Бул план башка аккаунтка таандык';

  @override
  String get ovRestoreOtherBody =>
      'Бул жазылуу башка BeaverTalk аккаунтунда мурунтан активдүү.';

  @override
  String get ctaSignInThatAccount => 'Ошол аккаунтка кирүү';

  @override
  String get ctaGetHelp => 'Жардам алуу';

  @override
  String get ovCharacterOfferTitle => 'Premium планына даяр эмессизби?';

  @override
  String get ovCharacterOfferBody =>
      'Бир каарманды тандап, өзүңүзгө калтырыңыз. Бир жолку сатып алуу — жазылуусуз, узартуусуз.';

  @override
  String get rowOneCharacter => 'Бир каарман';

  @override
  String rowFromPrice(String price) {
    return '$priceдон баштап';
  }

  @override
  String get rowYoursForever => 'Түбөлүк сиздики';

  @override
  String get rowNoRenewal => 'Узартуу жок';

  @override
  String get rowWorksOnFree => 'Акысыз планда иштейт';

  @override
  String get rowYes => 'Ооба';

  @override
  String get ctaSeeCharacters => 'Каармандарды көрүү';

  @override
  String get ovNotEligibleTitle => 'Жокко чыгара турган эч нерсе жок';

  @override
  String get ovNotEligibleBody =>
      'Сиз Акысыз пландасыз. Бул аккаунтта активдүү жазылуу жок.';

  @override
  String get ovCancelDownsellTitle => 'Кетээрден мурун';

  @override
  String get ovCancelDownsellBody =>
      'Жокко чыгаруу дүкөндө жүргүзүлөт. Билип койгонго арзырлык эки нерсе.';

  @override
  String get rowPayYearlyInstead => 'Анын ордуна жылдык төлөм';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'Айына $price';
  }

  @override
  String get rowCharactersYouBought => 'Сатып алган каармандарыңыз';

  @override
  String get rowProRunsUntil => 'Premium мөөнөтү';

  @override
  String get ctaSwitchToYearly => 'Жылдыкка өтүү';

  @override
  String get ctaContinueToStore => 'Дүкөнгө өтүү';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Жылдык төлөп, $saved үнөмдөңүз';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Жылдык план ай сайын төлөгөндөн арзаныраак.';

  @override
  String get rowYouSave => 'Үнөмүңүз';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Жылдык';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Айлык, бир жылга';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Айлыкка өтүү';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Жылдык планыңыз $date чейин иштейт. Айлык эсептешүү эртеси күнү башталат.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Айлык эсептешүү башталат';

  @override
  String get rowMonthlyLabel => 'Айлык';

  @override
  String get rowYearlyWorkedOut => 'Жылдык эсеби';

  @override
  String get ctaSwitchToMonthly => 'Айлыкка өтүү';

  @override
  String get ovRefundHelpTitle => 'Кайтарымдарды дүкөн жүргүзөт';

  @override
  String get ovRefundHelpBody =>
      'Биз өзүбүз акча кайтара албайбыз. Ар бир өтүнүчтү дүкөн карайт.';

  @override
  String get ctaGoToStore => 'Дүкөнгө өтүү';

  @override
  String get ovTrialEndingTitle => 'Сыноо мөөнөтүңүз эртең аяктайт';

  @override
  String get ovTrialEndingBody =>
      'Жокко чыгармайынча Premium иштей берет. Эмне болорун караңыз.';

  @override
  String get rowTrialEnds => 'Сыноо аяктайт';

  @override
  String get rowFirstCharge => 'Биринчи төлөм';

  @override
  String get rowThenMonthly => 'Андан кийин ай сайын';

  @override
  String get ctaCancelInStore => 'Дүкөндө жокко чыгаруу';

  @override
  String get ovTrialStartTitle => '7 күн Premium, акысыз';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date чейин акысыз. Андан кийин айына $price, эгер дүкөндө жокко чыгарбасаңыз.';
  }

  @override
  String get ctaStart7Days => '7 күндү акысыз баштоо';

  @override
  String get ovOtoTitle => 'Баштаардан мурун дагы бир нерсе';

  @override
  String get ovOtoBody =>
      'Жакшы тандоо. Жылдык төлөсөңүз, ошол эле Premium арзаныраак.';

  @override
  String get ovFailedDeclinedTitle => 'Картаңыз четке кагылды';

  @override
  String get ovFailedDeclinedBody =>
      'Дүкөн төлөмдү ала алган жок. Эч нерсе алынган жок.';

  @override
  String get ctaUpdatePaymentMethod => 'Төлөм ыкмасын жаңыртуу';

  @override
  String get ovFailedCanceledTitle => 'Төлөм жокко чыгарылды';

  @override
  String get ovFailedCanceledBody =>
      'Сиз дагы эле Акысыз пландасыз. Эч нерсе алынган жок.';

  @override
  String get ovFailedStoreTitle => 'Бир нерсе туура эмес болду';

  @override
  String get ovFailedStoreBody =>
      'Дүкөнгө жетүү мүмкүн болбоду. Эч нерсе алынган жок.';

  @override
  String get ovAlreadyTitle => 'Сиз мурунтан Premium пландасыз';

  @override
  String get ovAlreadyBody =>
      'Бул дүкөн аккаунтунда активдүү план бар. Сатып ала турган эч нерсе жок.';

  @override
  String get ctaSeeMySubscription => 'Жазылуумду көрүү';

  @override
  String get subCancelTitle => 'Жазылууну жокко чыгаруу';

  @override
  String subCancelBody(String date) {
    return 'Premium $date чейин иштейт. Андан кийин Акысызга өтөсүз.';
  }

  @override
  String get subWhatYouLose => 'Эмнеден айрыласыз';

  @override
  String get subPaymentTitle => 'Төлөмдү жаңыртуу';

  @override
  String get subPaymentBody =>
      'Төлөмдү ала алган жокпуз. Жеңилдик мезгилинде Premium иштей берет.';

  @override
  String get subHowToFix => 'Кантип оңдоо керек';

  @override
  String get fixStep1 => 'Дүкөндү ачып, төлөм ыкмаңызды жаңыртыңыз';

  @override
  String get fixStep2 => 'Кайтып келиңиз — планыңыз автоматтык түрдө улантылат';

  @override
  String get fixStep3 => 'Эч нерсе эки жолу алынбайт';

  @override
  String get subResubTitle => 'Кайра жазылуу';

  @override
  String subResubBody(String date) {
    return 'Premium $date аяктайт. Авто-узартууну кайра күйгүзсөңүз, эч нерсе өзгөрбөйт.';
  }

  @override
  String get subWhatYouKeep => 'Эмне сакталат';

  @override
  String get ctaTurnItBackOn => 'Кайра күйгүзүү';

  @override
  String get flTodayTitle => 'Бул бүгүнкү чалуу';

  @override
  String get flTodayBody => 'Токтогон жерден улантыңыз — ушул замат.';

  @override
  String get flCheckTitle => 'Бул бүгүнкү текшерүү';

  @override
  String get flCheckBody =>
      'Акысыз планда күнүнө бир текшерүү бар. Premium толук талдоону берет.';

  @override
  String flCaption(String price) {
    return 'Айына $price · каалаган убакта жокко чыгарса болот';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit ичинен $used колдонулду';
  }

  @override
  String get ctaMaybeTomorrow => 'Балким эртең';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get nicknameLabel => 'Ылакап ат';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get loginMethodLabel => 'Кирүү ыкмасы';

  @override
  String get joinedLabel => 'Катталган күнү';

  @override
  String get editNicknameTitle => 'Ылакап атты түзөтүү';

  @override
  String get nicknameRule => '2–12 белги. Тамгалар жана сандар. Англисче гана';

  @override
  String get ctaSave => 'Сактоо';

  @override
  String get subscriptionRow => 'Жазылуу';

  @override
  String get iapSuccessTitle => 'Сатып алуу аяктады';

  @override
  String iapSuccessBody(String name) {
    return '$name аватары түбөлүккө сиздики.\nТүбөлүк ырасталаары менен колдонулат.';
  }

  @override
  String get ctaGoHome => 'Башкы бетке';

  @override
  String get ctaUseNow => 'Азыр колдонуу';

  @override
  String get iapFailTitle => 'Төлөм өтпөй калды';

  @override
  String get iapFailBody => 'Кайра аракет кылсаңыз болот';

  @override
  String get paywallLeaveTitle => 'Азыр чыксаңыз, жазылуу түзүлбөйт';

  @override
  String get paywallLeaveBody =>
      'Артыкчылыктар төлөмдөн кийин дароо ачылат. Менин барагым аркылуу каалаган убакта кайтып келе аласыз.';

  @override
  String get ctaKeepLooking => 'Көрүүнү улантуу';

  @override
  String get ctaLeaveAnyway => 'Баары бир чыгуу';

  @override
  String get iapCharacterSuccessTitle => 'Жаңы дос кошулду!';

  @override
  String get iapCharacterSuccessBody =>
      'Бул каарман түбөлүккө сиздики — план өзгөрсө да калат, ал эми Сатып алууларды калыбына келтирүү аны каалаган түзмөктө кайтарат.';

  @override
  String get iapCharacterFailedBody =>
      'Сатып алуу ишке ашкан жок. Акча алынган жок — кайра аракет кылыңыз.';

  @override
  String get noAccentDataTitle => 'Интонация маалыматы азырынча жок';

  @override
  String get noAccentDataBody =>
      'Сүйлөшүүнү улантсаңыз, интонацияңыздын өзгөчөлүктөрү топтолот.';

  @override
  String get noLevelYetTitle => 'Деңгээл азырынча жок';

  @override
  String get noLevelYetBody => 'Биринчи чалууну аяктасаңыз деңгээлиңиз чыгат.';

  @override
  String get noPronunciationDataTitle => 'Айтылыш жазуулары азырынча жок';

  @override
  String get noPronunciationDataBody =>
      'Чалууда айткан сүйлөмдөрүңүздөн айтылышты талдайбыз.';

  @override
  String get noCharacterNote => 'Азырынча калтырылган сөз жок';

  @override
  String get noPhonemesYet => 'Талдоого алынуучу үн азырынча жок';

  @override
  String get noSentencesYet => 'Талдоого алынуучу сүйлөм азырынча жок';

  @override
  String get takeLevelTest => 'Деңгээл тестин тапшыруу';

  @override
  String get reviewToSeeScore => 'Кайталасаңыз айтылыш упайы чыгат';

  @override
  String get playAgain => 'Кайра ойноо';

  @override
  String get difficultySlow => 'Жай';

  @override
  String get difficultyNormal => 'Орточо';

  @override
  String get difficultyFast => 'Тез';

  @override
  String get difficultyLabel => 'Татаалдык';

  @override
  String get connected => 'Туташты';

  @override
  String get unlockedWithMax => 'Планыңызга кирет';

  @override
  String get fcEndedTitle => 'Акысыз чалууңуз аяктады';

  @override
  String get fcEndedBody =>
      'Акысыз чалуулар 5 мүнөткө чейин созулат\nУзагыраак сүйлөшүү үчүн жазылыңыз';

  @override
  String get ctaSubscribeKeepTalking => 'Жазылып, сүйлөшүүнү улантуу';

  @override
  String get kgTitle => 'Улантабызбы?';

  @override
  String get kgBody =>
      'Чалуулар 5 мүнөттүк бөлүктөр менен уланат.\nАр жолу сизден кайра сурайбыз.';

  @override
  String get ctaKeepTalking => 'Сүйлөшүүнү улантуу';

  @override
  String get callModeSheetTitle => 'Кантип сүйлөшкүңүз келет?';

  @override
  String get callModeSheetSubtitle => 'Бул чалууга дароо колдонулат';

  @override
  String get callModeFreeTalk => 'Эркин маек';

  @override
  String get callModeFreeTalkDesc => 'Оңдоосуз эркин сүйлөшүңүз';

  @override
  String get callModeStudy => 'Үйрөнүү';

  @override
  String get callModeStudyDesc => 'Бир жолу бир сөз айкашын үйрөнүңүз';

  @override
  String get callModeChange => 'Режимди өзгөртүү';

  @override
  String get callModeKeep => 'Азыр эмес';

  @override
  String get callExitTitle => 'Чалууну аяктайсызбы?';

  @override
  String get callExitSubtitle => 'Азыр аяктасаңыз да бир чалуу эсептелет';

  @override
  String get callExitKeep => 'Сүйлөшүүнү улантуу';

  @override
  String get callExitConfirm => 'Чалууну аяктоо';

  @override
  String get callMicMute => 'Үнсүз кылуу';

  @override
  String get callMicUnmute => 'Үндү күйгүзүү';

  @override
  String get callPushToTalk => 'Сүйлөш үчүн басып туруңуз';

  @override
  String get callFreeEndedTitle => 'Акысыз чалууңуз аяктады';

  @override
  String get callFreeEndedCta => 'Жазылып, сүйлөшүүнү улантыңыз';

  @override
  String get callKeepGoingTitle => 'Улантабызбы?';

  @override
  String get callKeepGoingSubtitle =>
      'Чалуулар 5 мүнөттүк бөлүктөр менен уланат. Ар жолу кайра сурайбыз.';

  @override
  String get articulationSelectedWord => 'Тандалган сөз';

  @override
  String get articulationYouSaid => 'Сиздин айтылышыңыз';

  @override
  String get articulationTargetSound => 'Максат';

  @override
  String get reportEntry => 'Даттануу';

  @override
  String get reportTitle => 'Даттануу';

  @override
  String get reportPrompt => 'Кандай көйгөй болду?';

  @override
  String get reportGuide =>
      'AI каарманынын кайсы сөзү сизди ыңгайсыз кылганын айтыңыз. Ар бир кайрылууну карайбыз.';

  @override
  String get reportReasonSexual => 'Сексуалдык мазмун';

  @override
  String get reportReasonHate => 'Жек көрүү же кемсинтүү';

  @override
  String get reportReasonViolence => 'Зомбулук же коркутуу';

  @override
  String get reportReasonSelfHarm => 'Өзүнө зыян келтирүүгө түртөт';

  @override
  String get reportReasonMisinfo => 'Жалган маалымат';

  @override
  String get reportReasonOther => 'Башка көйгөй';

  @override
  String get reportDetailHint => 'Эмне болгонун жазыңыз (милдеттүү эмес)';

  @override
  String get reportSubmit => 'Даттануу жөнөтүү';

  @override
  String get reportDoneTitle => 'Кайрылууңуз кабыл алынды';

  @override
  String get reportDoneBody =>
      'Карап чыгып, керек болсо чара көрөбүз. BeaverTalk коопсуздугуна жардам бергениңизге рахмат.';

  @override
  String get reportFailed => 'Даттануу жөнөтүлгөн жок. Кайра аракет кылыңыз.';

  @override
  String get hwTitle => 'Үй тапшырмасы';

  @override
  String get hwJoinCodeTitle => 'Класс кодуңузду киргизиңиз';

  @override
  String get hwJoinCodeSubtitle => 'Бул мугалим берген 6 сандуу код';

  @override
  String get hwJoinCodeLabel => 'Класс коду';

  @override
  String get hwJoinCodeHelp => 'Коддо чоң-кичине тамга айырмаланбайт';

  @override
  String get hwJoinConfirmTitle => 'Ушул класспы?';

  @override
  String get hwJoinConfirmSubtitle =>
      'Эгер андай болбосо, кодду кайра текшериңиз';

  @override
  String get hwJoinFieldInstitution => 'Мекеме';

  @override
  String get hwJoinFieldTeacher => 'Мугалим';

  @override
  String get hwJoinFieldLearners => 'Окуучулар';

  @override
  String get hwJoinFieldTerm => 'Мезгил';

  @override
  String get hwJoinConfirmNote =>
      'Класстын аты мугалим жазгандай көрсөтүлөт. Биз аны которбойбуз.';

  @override
  String get hwJoinConfirmYes => 'Ооба, ушул';

  @override
  String get hwJoinConfirmRetry => 'Коддун кайра киргизүү';

  @override
  String get hwJoinProfileTitle => 'Класста кайсы атты колдоносуз?';

  @override
  String get hwJoinProfileSubtitle =>
      'Мугалим аны класс тизмеси менен салыштырат';

  @override
  String get hwJoinNameLabel => 'Аты';

  @override
  String get hwJoinNameHelp => 'Колдонмодогу атыңыздан айырмаланышы мүмкүн';

  @override
  String get hwJoinStudentNoLabel => 'Окуучу номери (милдеттүү эмес)';

  @override
  String get hwJoinStudentNoHelp => 'Мугалим тизмени салыштыруу үчүн колдонот';

  @override
  String get hwJoinConsentTitle => 'Мугалим эмнени көрөт';

  @override
  String get hwJoinConsentSubtitle => 'Класска кошулуу үчүн макулдук керек';

  @override
  String get hwJoinConsentSharedHeading => 'Мугалим менен бөлүшүлөт';

  @override
  String get hwJoinConsentShared1 => 'Класстын аты жана окуучу номери';

  @override
  String get hwJoinConsentShared2 => 'Үй тапшырмасын аткардыңызбы';

  @override
  String get hwJoinConsentShared3 => 'Өткөн жана өтпөгөн сүйлөмдөр';

  @override
  String get hwJoinConsentShared4 =>
      'Тапшырма чалуусунун узактыгы жана корутундусу';

  @override
  String get hwJoinConsentNotSharedHeading => 'Бөлүшүлбөйт';

  @override
  String get hwJoinConsentNotShared1 => 'Эл. почта жана телефон номери';

  @override
  String get hwJoinConsentNotShared2 =>
      'Колдонмодогу аты, профиль жана каарман';

  @override
  String get hwJoinConsentNotShared3 => 'Жарандыгы жана эне тили';

  @override
  String get hwJoinConsentNotShared4 => 'Класстан тышкаркы чалуулар жана окуу';

  @override
  String get hwJoinConsentNotShared5 => 'Жазылуу жана төлөм маалыматы';

  @override
  String get hwJoinConsentAgree => 'Жогоркулар менен макулмун';

  @override
  String get hwJoinConsentCta => 'Макул болуп кошулуу';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Сиз $className класска кошулдуңуз';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count тапшырма күтүп турат';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Азырынча тапшырма жок';

  @override
  String get hwJoinDoneNextDue => 'Кийинки мөөнөт';

  @override
  String get hwJoinDoneRosterName => 'Класстагы атыңыз';

  @override
  String get hwJoinDoneCta => 'Тапшырмаларды көрүү';

  @override
  String get hwJoinErrorNotFound => 'Мындай код табылган жок';

  @override
  String get hwJoinErrorNotFoundBody => 'Алты сандын кайра текшериңиз.';

  @override
  String get hwJoinErrorExpired => 'Бул коддун мөөнөтү бүттү';

  @override
  String get hwJoinErrorExpiredBody => 'Мугалимден жаңы код сураңыз.';

  @override
  String get hwJoinErrorFull => 'Класс толуп калды';

  @override
  String get hwJoinErrorFullBody => 'Мугалимиңизге билдириңиз.';

  @override
  String get hwJoinFailed =>
      'Кошулуу мүмкүн болбоду. Бир аздан кийин кайра аракет кылыңыз.';

  @override
  String get hwSectionInProgress => 'Аткарылууда';

  @override
  String get hwSectionUpcoming => 'Жакында';

  @override
  String get hwSectionDone => 'Аяктады';

  @override
  String get hwLeaveClassLink => 'Класстан чыгуу';

  @override
  String get hwListEmptyTitle => 'Азырынча үй тапшырмасы жок';

  @override
  String get hwListEmptyBody => 'Мугалим бергенде ушул жерде көрүнөт.';

  @override
  String get hwListFailed => 'Тапшырмалар жүктөлгөн жок.';

  @override
  String get hwRetry => 'Кайра аракет кылуу';

  @override
  String get hwBadgeDone => 'Аяктады';

  @override
  String get hwBadgeOverdue => 'Тапшырылган жок';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Тапшырылган жок, $days күн кечикти';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Мөөнөтү бүгүн';

  @override
  String get hwActivitySpeaking => 'Сүйлөө';

  @override
  String get hwActivityConversation => 'Маек';

  @override
  String get hwActivityWorkbook => 'Иш дептери';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter-бөлүм';
  }

  @override
  String get hwTaskSpeakingDesc => 'Айтуу упайыңызды текшериңиз';

  @override
  String get hwTaskConversationDesc =>
      'Үйрөнгөнүңүздү чыныгы маекте колдонуңуз';

  @override
  String get hwConversationOnce =>
      'Маек ар бир үй тапшырмасы боюнча бир жолу гана.';

  @override
  String get hwTaskWorkbookDesc => 'Иш дептерине жазып көнүгүңүз';

  @override
  String get hwCtaStudy => 'Баштоо';

  @override
  String get hwCtaResult => 'Жыйынтыкты көрүү';

  @override
  String get hwCtaDownload => 'Жүктөө';

  @override
  String get hwSpeakingNoScore => 'Сүйлөө тапшырмасын азырынча аткара элексиз';

  @override
  String get hwWorkbookUnavailable =>
      'Иш дептеринин файлы азырынча жеткиликсиз.';

  @override
  String get hwDetailClosed =>
      'Бул тапшырма жабылды. Мындан ары тапшыра албайсыз.';

  @override
  String get hwLeaveTitle => 'Класстан чыгасызбы?';

  @override
  String get hwLeaveBody =>
      'Мугалим мындан ары тапшырма жыйынтыктарыңызды көрбөйт.';

  @override
  String get hwLeaveConfirm => 'Чыгуу';

  @override
  String get hwLeaveCancel => 'Калуу';

  @override
  String get hwLeaveFailed => 'Класстан чыгуу болбоду.';

  @override
  String get hwMyClass => 'Менин классым';

  @override
  String get hwClassEmptyTitle => 'Сиз эч бир класска кошулган жоксуз';

  @override
  String get hwClassEmptySubtitle => 'Мугалим берген кодду киргизиңиз';

  @override
  String get hwClassEmptyCta => 'Класс кодун киргизүү';

  @override
  String get hwClassContinueCta => 'Улантуу';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count тапшырманын мөөнөтү эртең';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Сизде тапшырылбаган $count тапшырма бар';
  }

  @override
  String get hwSpeakingUnavailable =>
      'Бул тапшырманын сүйлөмдөрү азырынча жеткиликсиз.';

  @override
  String get hwBadgeClosed => 'Жабык';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total сүйлөмдүн $passed өттү';
  }

  @override
  String get challengeFirstWord => 'Биринчи сөз';

  @override
  String get challengeSeeAnalysis => 'Жыйынтыктарды көрүү';

  @override
  String get challengePaused => 'Тыныгуу';

  @override
  String get challengePausedNote => 'Таймер менен жазуу чогуу токтоду.';

  @override
  String get challengeTimeLeft => 'Калган убакыт';

  @override
  String get challengeScoreLabel => 'Упай';

  @override
  String get challengeResume => 'Улантуу';

  @override
  String get challengeBlockedTitle => 'Камераны колдонууга болбойт';

  @override
  String get challengeBlockedNote =>
      'Жөндөөлөрдөн камера жана микрофонго уруксатты күйгүзүңүз.';

  @override
  String get challengeGoBack => 'Артка';

  @override
  String get challengeOpenSettings => 'Жөндөөлөрдү ачуу';

  @override
  String get saveDone => 'Галереяга сакталды';

  @override
  String get saveFailed => 'Сактоо болбоду';

  @override
  String get saveDeniedNote => 'Сүрөттөргө уруксат керек';

  @override
  String get callIncomingCallerFallback => 'Beaver мугалим';

  @override
  String get callIncomingHandle => 'Корей тилинде чалуу';

  @override
  String get callMissedTitle => 'Жооп берилбеген чалуу';

  @override
  String get callMissedChannelDescription =>
      'Beaver чалуусун өткөрүп жибергениңизди билдирет.';

  @override
  String callMissedBody(String name) {
    return '$name сизге чалды';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Чалууларды кабыл алуу үчүн билдирме уруксаты керек.';

  @override
  String get callNotifPermissionRequired =>
      'Жөндөөлөрдөн билдирмелерге уруксат бериңиз.';

  @override
  String get callHintLockedTitle => 'Үйрөнүү режиминде кеп жеткиликсиз';

  @override
  String get wsTitle => 'Кыйын тыбыштар';

  @override
  String get wsToList => 'Тизмеге';

  @override
  String get wsNext => 'Кийинки';

  @override
  String get wsRetry => 'Кайра аракет';

  @override
  String get wsDone => 'Бүттү';

  @override
  String get wsContinue => 'Улантуу';

  @override
  String get wsQuit => 'Чыгуу';

  @override
  String get wsRetryLater => 'Бир аздан кийин кайра аракет кылыңыз.';

  @override
  String get wsMissingTitle => 'Ал тыбышты таба албадык';

  @override
  String get wsMissingBody => 'Тизмеден кайра тандаңыз.';

  @override
  String get wsListLoadFailed => 'Тизмени жүктөй албадык';

  @override
  String get wsLessonLoadFailed => 'Сабакты жүктөй албадык';

  @override
  String get wsNationalTitle => 'Акцентиңизге ылайык кыйын тыбыштар';

  @override
  String get wsNationalPending => 'Акцент анализи бүткөндө толтурулат';

  @override
  String get wsNationalPicked => 'Акцент анализинин негизинде тандалды';

  @override
  String get wsNationalEmptyBody =>
      'Бир аз көбүрөөк чалсаңыз, акцентиңизди анализдейбиз.';

  @override
  String get wsMineTitle => 'Менин кыйын тыбыштарым';

  @override
  String get wsMineSubtitle => 'Акыркы учурда упайы төмөн болгон тыбыштар';

  @override
  String get wsMineEmptyBody => 'Чалып, кайталасаңыз, кыйын тыбыштар топтолот.';

  @override
  String get wsNoDataYet => 'Азырынча маалымат жок';

  @override
  String get wsGoToCall => 'Чалууну баштоо';

  @override
  String get wsRule => 'Эреже';

  @override
  String get wsRecommended => 'Сунушталат';

  @override
  String get wsNotMeasured => 'Ченелген эмес';

  @override
  String get wsStepUnderstand => 'Түшүнүү';

  @override
  String get wsStepWords => 'Сөздөр';

  @override
  String get wsStepSentence => 'Сүйлөм';

  @override
  String get wsStepTest => 'Баалоо';

  @override
  String get wsQuitTitle => 'Көнүгүүнү токтотобузбу?';

  @override
  String get wsQuitBody => 'Азыр чыксаңыз, бул көнүгүү сакталбайт.';

  @override
  String get wsHowToSound => 'Тыбышты кантип айтуу керек';

  @override
  String get wsPracticeWords => 'Сөздөрдү көнүгүү';

  @override
  String get wsPracticeSentence => 'Сүйлөмдү көнүгүү';

  @override
  String get wsStartTest => 'Баалоону баштоо';

  @override
  String get wsThisSentence => 'Ушул сүйлөм';

  @override
  String get wsNoScoreNote => 'Бул кадам бааланбайт. Эркин кайталап айтыңыз.';

  @override
  String get wsListen => 'Кунт коюп угуңуз';

  @override
  String get wsSayNow => 'Эми айтып көрүңүз';

  @override
  String get wsPracticeDone => 'Көнүгүү бүттү';

  @override
  String get wsPaused => 'Токтотулду';

  @override
  String get wsAudioFailed => 'Үндү жүктөй албадык. Тексттен окуп айтыңыз.';

  @override
  String get wsReadAloud => 'Төмөндөгү сүйлөмдү катуу окуңуз';

  @override
  String get wsTapToStart => 'Баштоо үчүн басыңыз';

  @override
  String get wsTapWhenDone => 'Окуп бүткөндө басыңыз';

  @override
  String get wsScoring => 'Баалануу жүрүп жатат';

  @override
  String get wsMicFailed => 'Микрофонду ача албадык.';

  @override
  String get wsMicPermissionBody =>
      'Бул тестте үн чыгарып окуу керек, ошондуктан микрофон керек. Жөндөөлөрдөн микрофонго уруксатты күйгүзүңүз.';

  @override
  String get wsNoSound => 'Үн келген жок. Кайра айтып көрөбүзбү?';

  @override
  String get wsScoreFailed => 'Баалоо ишке ашпады. Кайра аракет кылыңыз.';

  @override
  String get wsSomethingWrong => 'Ката кетти.';

  @override
  String get wsLearnDone => 'Сабак бүттү';

  @override
  String get wsRetest => 'Кайра баалоо';

  @override
  String get wsFirstMeasure => 'Биринчи ченөө';

  @override
  String get wsFinalTest => 'Жыйынтыктоочу баалоо';

  @override
  String wsPoints(int score) {
    return '$score упай';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Мурда $score упай';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Максат $score упай';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Максат · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country акценти';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count сөз кайталанды';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count бөлүк кайталанды';
  }

  @override
  String get wsStartRecommended => 'Сунушталган тыбыштан баштоо';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Баштоо · $label';
  }

  @override
  String get wsPointsUnit => 'упай';

  @override
  String get wsEnterFromMypage => 'Кыйын тыбыштарды көнүгүү';

  @override
  String wsGoalOnly(int score) {
    return 'Максат $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label тыбышы';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Чалууда кайра кезиксе, ушул форманы эсиңизге түшүрүңүз.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country сүйлөөчүлөрү көп жаңылган тыбыштар';
  }
}
