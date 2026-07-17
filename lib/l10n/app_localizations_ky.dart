// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Чалуу $duration аяктады';
  }

  @override
  String get callRatingPrompt => 'Чалуу кандай болду?';

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
  String get analysisLoadError => 'Анализ жыйынтыгын жүктөп болбоду.';

  @override
  String get standardAudioNotReady => 'Үлгү айтылыш аудиосу дагы даяр эмес.';

  @override
  String get standardAudioPlayError => 'Үлгү айтылыш аудиосун ойнотуп болбоду.';

  @override
  String get selectACountry => 'Өлкөнү тандаңыз';

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
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

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
  String get myPage => 'Менин баракчам';

  @override
  String get languageSaveFailed => 'Тилиңизди сактап болбоду.';

  @override
  String get accountDeleteFailed => 'Аккаунтуңузду өчүрүп болбоду.';

  @override
  String get changeAvatar => 'Аватарды алмаштыруу';

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
  String get changePlan => 'Планды алмаштыруу';

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
  String get keepUsingPro => 'Proду улантуу';

  @override
  String get proMembership => 'Pro мүчөлүк';

  @override
  String get pricePerMonth => '\$12.9 / айына';

  @override
  String get benefitUnlimitedCalls => 'Чексиз чалуулар';

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
  String get challengeLoadingNote =>
      'Биринчи жолу иштетүүдө корей тил моделин (~82МБ) жүктөп алат.\nСаал күтө туруңуз.';

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
  String get loginContinueWithKakao => 'Kakao аркылуу улантуу';

  @override
  String get loginContinueWithGoogle => 'Google аркылуу улантуу';

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
  String get availableForPurchase => 'Available to purchase';

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
