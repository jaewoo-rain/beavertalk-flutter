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
  String get loginAppleSignInFailed => 'Apple аркылуу кирүү ишке ашкан жок.';

  @override
  String get loginKakaoSignInFailed => 'Kakao аркылуу кирүү ишке ашкан жок.';

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
  String subscriptionSwitchNote(String date) {
    return 'Pro артыкчылыктарын $date чейин колдоно аласыз, андан кийин планыңыз автоматтык түрдө акысызга которулат.';
  }

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
  String get connected => 'Туташты';

  @override
  String get playAgain => 'Кайра ойноо';

  @override
  String get difficulty => 'Кыйындык';

  @override
  String get difficultySlow => 'Жай';

  @override
  String get difficultyNormal => 'Кадимки';

  @override
  String get difficultyFast => 'Тез';
}
