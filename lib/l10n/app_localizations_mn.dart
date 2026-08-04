// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class AppLocalizationsMn extends AppLocalizations {
  AppLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Дуудлага дуусав $duration';
  }

  @override
  String get callRatingPrompt => 'Дуудлага ямар байсан бэ?';

  @override
  String get ratingBad => 'Тийм ч сайнгүй';

  @override
  String get ratingOkay => 'Дунд зэрэг';

  @override
  String get ratingGood => 'Сайн';

  @override
  String get goHome => 'Нүүр хуудас';

  @override
  String get viewAnalysis => 'Дүн шинжилгээ үзэх';

  @override
  String get loadingShort => 'Ачаалж байна…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Үнэлгээ илгээхэд алдаа гарлаа: $message';
  }

  @override
  String get callInfoNotFound =>
      'Дуудлагын мэдээлэл олдсонгүй тул дүн шинжилгээг алгасаж байна.';

  @override
  String get tabRecords => 'Түүх';

  @override
  String get tabArchive => 'Архив';

  @override
  String get callHistory => 'Дуудлагын түүх';

  @override
  String get conversationRecord => 'Ярианы бичлэг';

  @override
  String get noCallRecords => 'Дуудлагын түүх алга байна';

  @override
  String get noCallRecordsBody =>
      'AI-тай эхний дуудлагаа хийсний дараа\nтаны түүх энд харагдана.';

  @override
  String get startCall => 'Дуудлага эхлүүлэх';

  @override
  String get recordsLoadError => 'Түүхийг ачаалж чадсангүй';

  @override
  String get tryAgainLater => 'Дараа дахин оролдоно уу.';

  @override
  String get retry => 'Дахин оролдох';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes мин $seconds сек';
  }

  @override
  String get scheduleManagement => 'Хуваарь';

  @override
  String get alarms => 'Сэрүүлэг';

  @override
  String get addSchedule => 'Хуваарь нэмэх';

  @override
  String get editSchedule => 'Хуваарь засах';

  @override
  String get somethingWentWrong => 'Ямар нэг алдаа гарлаа';

  @override
  String get alarmsLoadError => 'Сэрүүлгийг ачаалж чадсангүй';

  @override
  String get charactersLoadError => 'Дүрүүдийг ачаалж чадсангүй';

  @override
  String get noCharacters => 'Боломжтой дүр алга байна';

  @override
  String get close => 'Хаах';

  @override
  String get repeat => 'Давтах';

  @override
  String get callPartner => 'Дүр';

  @override
  String get quickStart => 'Хурдан эхлэх';

  @override
  String get presetMorning => 'Өглөөний хэвшил';

  @override
  String get presetMorningSub => 'Ажлын өдрүүд 8:00';

  @override
  String get presetEvening => 'Оройн төгсгөл';

  @override
  String get presetEveningSub => 'Өдөр бүр 21:00';

  @override
  String get presetCustom => 'Өөрийн сонголт';

  @override
  String get presetCustomSub => 'Дураараа';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Долоо хоногт $count× · сард $monthly дуудлага';
  }

  @override
  String get alarmSummaryNone => 'Дор хаяж нэг өдөр сонгоно уу';

  @override
  String get partnerInUse => 'Ашиглаж байна';

  @override
  String get partnerOwned => 'Эзэмшсэн';

  @override
  String get am => 'ӨӨ';

  @override
  String get pm => 'ӨХ';

  @override
  String get save => 'Хадгалах';

  @override
  String get conversation => 'Яриа';

  @override
  String get review => 'Дахин үзэх';

  @override
  String get pronunciationChallenge => 'Дуудлагын сорилт';

  @override
  String get newExpressions => 'Шинэ хэллэгүүд';

  @override
  String get analysisResult => 'Дүн шинжилгээний үр дүн';

  @override
  String get noNewExpressions => 'Энэ ярианаас шинэ хэллэг олдсонгүй.';

  @override
  String get practice => 'Дадлага';

  @override
  String recentScore(int score) {
    return 'Сүүлийн оноо $score%';
  }

  @override
  String callSequence(int count) {
    return '$count дэх дуудлага';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name-с хэдэн үг';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Дуудлагын дараа шууд $name үлдээв';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Шинэ хэллэг $count';
  }

  @override
  String get analysisLoadError => 'Дүн шинжилгээний үр дүнг ачаалж чадсангүй.';

  @override
  String get standardAudioNotReady =>
      'Стандарт дуудлагын аудио бэлэн болоогүй байна.';

  @override
  String get standardAudioPlayError =>
      'Стандарт дуудлагын аудиог тоглуулж чадсангүй.';

  @override
  String get selectACountry => 'Улс сонгох';

  @override
  String get selectYourLanguage => 'Хэлээ сонгоно уу';

  @override
  String get confirm => 'Баталгаажуулах';

  @override
  String get cancel => 'Цуцлах';

  @override
  String get selectTime => 'Цаг сонгох';

  @override
  String get getStarted => 'Эхлэх';

  @override
  String get permissionTitle =>
      'Тав тухтай ашиглахын тулд\nзөвшөөрлийг идэвхжүүлнэ үү';

  @override
  String get permissionSubtitle =>
      'Үйлчилгээг ашиглахад шаардлагатай зөвшөөрлүүд.';

  @override
  String get permissionMicTitle => 'Микрофон (заавал)';

  @override
  String get permissionMicDesc => 'AI-тай англи хэлээр ярихад шаардлагатай.';

  @override
  String get permissionNotifTitle => 'Мэдэгдэл (сонголт)';

  @override
  String get permissionNotifDesc =>
      'Бид танд сургалтын сануулга болон дуудлагын хуваарийг илгээнэ.';

  @override
  String get micPermissionNeededTitle => 'Микрофоны зөвшөөрөл шаардлагатай';

  @override
  String get micPermissionNeededBody =>
      'AI-тай ярихын тулд микрофоны зөвшөөрлийг идэвхжүүлэх шаардлагатай. Тохиргоо цэснээс идэвхжүүлнэ үү.';

  @override
  String get openSettings => 'Тохиргоо нээх';

  @override
  String get connectionFailedTitle => 'Холболт амжилтгүй боллоо';

  @override
  String get connectionFailedBody =>
      'Сүлжээний холболтоо шалгаад\nдахин оролдоно уу.';

  @override
  String get checkout => 'Худалдан авалт';

  @override
  String get pay => 'Төлөх';

  @override
  String get orderSummary => 'Захиалгын мэдээлэл';

  @override
  String get paymentMethod => 'Төлбөрийн хэрэгсэл';

  @override
  String get payMethodCard => 'Кредит / Дебит карт';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Ааштай бобрын аватар';

  @override
  String get productTrait => 'Премиум дүр · Мөнхөд чинийх';

  @override
  String get amountItemPrice => 'Барааны үнэ';

  @override
  String get amountDiscount => 'Хөнгөлөлт';

  @override
  String get amountTotal => 'Нийт дүн';

  @override
  String get paymentCompleteTitle => 'Төлбөр амжилттай';

  @override
  String get paymentCompleteBody => 'Аватар таны цуглуулгад нэмэгдлээ.';

  @override
  String get viewCollection => 'Цуглуулга үзэх';

  @override
  String get receiptItem => 'Бараа';

  @override
  String get receiptAmount => 'Дүн';

  @override
  String get receiptMethod => 'Төлбөрийн хэрэгсэл';

  @override
  String get receiptDate => 'Огноо';

  @override
  String get paymentFailedTitle => 'Төлбөр амжилтгүй боллоо';

  @override
  String get paymentFailedBody =>
      'Таны төлбөрийг боловсруулж чадсангүй.\nДахин оролдоно уу.';

  @override
  String get freeCallEndingTitle => 'Таны үнэгүй дуудлага дуусах гэж байна';

  @override
  String get freeCallEndingBody =>
      'Бобртой илүү удаан ярихын тулд захиалга хийнэ үү.';

  @override
  String get subscribe => 'Захиалга авах';

  @override
  String get endCall => 'Дуудлага дуусгах';

  @override
  String get callEnded => 'Дуудлага дууслаа.';

  @override
  String get connecting => 'Холбогдож байна…';

  @override
  String get connectingHint => 'Ихэвчлэн 5 секундээс бага хугацаа зарцуулна';

  @override
  String get callConnectFailed => 'Дуудлагыг холбож чадсангүй.';

  @override
  String get saveSentenceFailed => 'Өгүүлбэрийг хадгалж чадсангүй.';

  @override
  String get recordStartFailed => 'Бичлэгийг эхлүүлж чадсангүй.';

  @override
  String get recordTooShort => 'Бичлэг хэт богино байна. Дахин оролдоно уу.';

  @override
  String get gradingFailed => 'Дүгнэлт хийхэд алдаа гарлаа. Дахин оролдоно уу.';

  @override
  String get listenStandard => 'Стандарт дуудлагыг сонсох';

  @override
  String get saveSentence => 'Өгүүлбэр хадгалах';

  @override
  String get unsaveSentence => 'Хадгалсан өгүүлбэрийг устгах';

  @override
  String get scoringPronunciation => 'Дуудлагыг дүгнэж байна…';

  @override
  String get analyzingByWord => 'Таны дуудлагыг үг тус бүрээр шалгаж байна';

  @override
  String get analyzingTakingLonger => 'Энэ арай удаж байна';

  @override
  String get scanConnectionLost => 'Холболт тасарлаа';

  @override
  String get noRecordingToPlay => 'Тоглуулах бичлэг алга байна.';

  @override
  String get myRecordingPlayError => 'Таны бичлэгийг тоглуулж чадсангүй.';

  @override
  String get next => 'Дараах';

  @override
  String get endLearning => 'Сургалт дуусгах';

  @override
  String get navCalendar => 'Хуанли';

  @override
  String get navCall => 'Дуудлага';

  @override
  String get navStats => 'Статистик';

  @override
  String get myPage => 'Миний хуудас';

  @override
  String get languageSaveFailed => 'Хэлний тохиргоог хадгалж чадсангүй.';

  @override
  String get accountDeleteFailed => 'Бүртгэлийг устгаж чадсангүй.';

  @override
  String get changeAvatar => 'Аватар солих';

  @override
  String get avatarIntro =>
      'Дуу хоолой болон түвшин дүрээс хамаарч ялгаатай.\nЗарим дүрд төлбөр шаардлагатай байж болно.';

  @override
  String myPartnersOwned(int count) {
    return 'Миний дүрүүд · $count эзэмшсэн';
  }

  @override
  String get limitedDiscount => 'Хугацаатай хөнгөлөлт';

  @override
  String get available => 'Боломжтой';

  @override
  String get inUse => 'Ашиглаж байна';

  @override
  String get owned => 'Эзэмшсэн';

  @override
  String get noCharactersToShow => 'Харуулах дүр алга байна';

  @override
  String get buy => 'Худалдаж авах';

  @override
  String get noSavedSentences =>
      'Хадгалсан өгүүлбэр алга байна.\nЯриа түүхээсээ өгүүлбэр хавчуулна уу.';

  @override
  String get noAlarms => 'Сэрүүлэг алга байна';

  @override
  String get noAlarmsBody =>
      'Тогтмол дадал үүсгэхийн тулд\nсургалтын сануулга нэмнэ үү.';

  @override
  String get subscriptionManage => 'Захиалга удирдах';

  @override
  String get changePlan => 'Багц солих';

  @override
  String get cancelSubscription => 'Захиалга цуцлах';

  @override
  String get benefitsInUse => 'Таны ашиглаж буй эрхүүд';

  @override
  String get paymentInfo => 'Төлбөрийн мэдээлэл';

  @override
  String get nextBillingDate => 'Дараагийн төлбөрийн огноо';

  @override
  String get lostBenefitsTitle => 'Цуцлавал алдах эрхүүд';

  @override
  String get viewBillingHistory => 'Төлбөрийн түүх үзэх';

  @override
  String get keepUsingPro => 'Pro-г үргэлжлүүлэн ашиглах';

  @override
  String get proMembership => 'Pro гишүүнчлэл';

  @override
  String get pricePerMonth => '\$12.9 / сар';

  @override
  String get benefitUnlimitedCalls => 'Хязгааргүй дуудлага';

  @override
  String get benefitDetailedAnalysis =>
      'Дуудлага, дүрмийн дэлгэрэнгүй шинжилгээ';

  @override
  String get benefitAllCharacters => 'Бүх дүрд хандах';

  @override
  String get benefitNoAds => 'Реклам байхгүй';

  @override
  String get playSampleVoice => 'Жишээ дуу хоолой сонсох';

  @override
  String get useThisAvatar => 'Үүнийг ашиглах';

  @override
  String get challengeTitle => 'Дуудлагын сорилт';

  @override
  String get challengeIntro =>
      'Бүсэд байгаа карт бүрийг Солонгос хэлээр зөв дуудаж түрж арилга.\nМикрофон байхгүй бол дэлгэц дарж тоглож болно.';

  @override
  String get challengeStart => 'Камер, микрофон эхлүүлэх';

  @override
  String get challengePermissionNote =>
      'Урд камер болон микрофоны зөвшөөрөл шаардлагатай (сонголт).';

  @override
  String get challengeLoadingTitle => 'Ачаалж байна…';

  @override
  String get challengeLoadingNote =>
      'Анх удаа ажиллуулахад Солонгос хэлний загварыг (~82MB) татаж байна.\nТэвчээртэй хүлээнэ үү.';

  @override
  String get challengeSttFallback =>
      'Дуу хоолойн танилт боломжгүй тул та товшилтоор тоглолоо.';

  @override
  String get reasonTravelTitle => 'Аялахдаа ярих';

  @override
  String get reasonTravelDesc => 'Орон нутгийн хүмүүстэй итгэлтэй ярилц';

  @override
  String get reasonCareerTitle => 'Ажил, карьер';

  @override
  String get reasonCareerDesc => 'Бизнесийн яриа хэлцэл';

  @override
  String get reasonExamTitle => 'Шалгалтад бэлдэх';

  @override
  String get reasonExamDesc => 'Ярианы шалгалтад бэлтгэ';

  @override
  String get reasonDailyTitle => 'Өдөр тутмын яриа';

  @override
  String get reasonDailyDesc => 'Өдөр бүр хэрэглэдэг хэллэгүүд';

  @override
  String get reasonFriendsTitle => 'Гадаад найз олох';

  @override
  String get reasonFriendsDesc => 'Байгалийн жам ёсны яриа';

  @override
  String get reasonBrainTitle => 'Тархины дасгал';

  @override
  String get reasonBrainDesc => 'Санах ой, анхаарлыг сайжруулах';

  @override
  String get challengeRecordToggle => 'Энэ удаагийн тоглолтыг бичих';

  @override
  String get challengeRecordHint =>
      'Тоглолтын видеог хуваалцахын тулд хадгална (дуугүй).';

  @override
  String get settingsSection => 'Тохиргоо';

  @override
  String get paymentSection => 'Төлбөр';

  @override
  String get supportSection => 'Тусламж';

  @override
  String get userLanguage => 'Хэрэглэгчийн хэл';

  @override
  String get learningLanguage => 'Суралцаж буй хэл';

  @override
  String get learningLanguageKorean => 'Солонгос';

  @override
  String get notificationLabel => 'Мэдэгдэл';

  @override
  String get currentPlan => 'Одоогийн багц';

  @override
  String get paymentHistory => 'Төлбөрийн түүх';

  @override
  String get contactUs => 'Бидэнтэй холбогдох';

  @override
  String get termsOfService => 'Үйлчилгээний нөхцөл';

  @override
  String get privacyPolicy => 'Нууцлалын бодлого';

  @override
  String get logOut => 'Гарах';

  @override
  String get deleteAccount => 'Бүртгэл устгах';

  @override
  String get deleteAccountTitle => 'Бүртгэлээ устгах уу?';

  @override
  String get deleteAccountBody =>
      'Энэ нь таны бүртгэл болон өгөгдлийг бүрмөсөн устгах бөгөөд буцаах боломжгүй.';

  @override
  String get delete => 'Устгах';

  @override
  String get share => 'Хуваалцах';

  @override
  String get accentSoundsLike => 'Таны Солонгос аялга ийм сонсогдож байна';

  @override
  String get hintLabel => 'Зөвлөмж';

  @override
  String get nextHint => 'Дараагийн зөвлөмж';

  @override
  String get translateLabel => 'Орчуулга';

  @override
  String get startRecording => 'Бичлэг эхлүүлэх';

  @override
  String get stopRecording => 'Бичлэг зогсоох';

  @override
  String get back => 'Буцах';

  @override
  String get onboardingNameTitle => 'Таныг юу гэж дуудах вэ?';

  @override
  String get onboardingNameSubtitle => 'Таны AI багш таны нэрийг санана.';

  @override
  String get nameLabel => 'Таны нэр';

  @override
  String get nameHint => 'Нэрээ оруулна уу';

  @override
  String get nameHelper => 'Жинхэнэ нэр байх шаардлагагүй — хоч нэр ч болно.';

  @override
  String get continueLabel => 'Үргэлжлүүлэх';

  @override
  String get onboardingDoneTitle => 'Бобр таны дуудлагыг хүлээж байна';

  @override
  String get onboardingDoneSubtitle => 'Одоо дуудлага эхлүүл';

  @override
  String get home => 'Нүүр';

  @override
  String get callNow => 'Одоо дуудах';

  @override
  String get pronunciation => 'Дуудлага';

  @override
  String get fluency => 'Чөлөөтэй байдал';

  @override
  String get rhythm => 'Хэмнэл';

  @override
  String get analysisTimeout =>
      'Энэ нь хүлээгдснээс удаж байна. Түр хүлээгээд дахин оролдоно уу.';

  @override
  String get analysisFailed =>
      'Ярианд дүн шинжилгээ хийж чадсангүй. Дахин оролдоно уу.';

  @override
  String get analyzingConversation => 'Таны яриаг шинжилж байна…';

  @override
  String get analyzingSubtitle => 'Энэ нь хормын дотор дуусна';

  @override
  String get tryAgain => 'Дахин оролдох';

  @override
  String get nativeLabel => 'Уугуул';

  @override
  String get meLabel => 'Би';

  @override
  String get pronunciationPlayError => 'Дуудлагын аудиог тоглуулж чадсангүй.';

  @override
  String get savedExpressionsLoadError =>
      'Хадгалсан хэллэгүүдийг ачаалж чадсангүй.';

  @override
  String get mySavedExpressions => 'Миний хадгалсан хэллэгүүд';

  @override
  String get avatarTraits => 'Дулаан · Тайван · Зөөлөн';

  @override
  String get priceFree => 'Үнэгүй';

  @override
  String get loginGoogleTokenError => 'Google нэвтрэх токен авч чадсангүй.';

  @override
  String get loginGoogleSignInFailed => 'Google нэвтрэлт амжилтгүй боллоо.';

  @override
  String get loginAppleSignInFailed => 'Apple нэвтрэлт амжилтгүй боллоо.';

  @override
  String get loginKakaoSignInFailed => 'Kakao нэвтрэлт амжилтгүй боллоо.';

  @override
  String get loginContinueWithKakao => 'Kakao-гаар үргэлжлүүлэх';

  @override
  String get loginContinueWithGoogle => 'Google-ээр үргэлжлүүлэх';

  @override
  String get loginContinueWithApple => 'Apple-ээр үргэлжлүүлэх';

  @override
  String get loginContinueWithEmail => 'Имэйлээр үргэлжлүүлэх';

  @override
  String get loginOrDivider => 'эсвэл';

  @override
  String get loginNoAccount => 'Бүртгэл байхгүй юу?';

  @override
  String get signUp => 'Бүртгүүлэх';

  @override
  String get loginTermsNoticePrefix => 'Үргэлжлүүлснээр та манай ';

  @override
  String get loginTermsNoticeAnd => ' болон ';

  @override
  String get loginTermsNoticeSuffix => '-г зөвшөөрч байна.';

  @override
  String get loginLogIn => 'Нэвтрэх';

  @override
  String get fieldEmailLabel => 'Имэйл';

  @override
  String get emailHint => 'Имэйлээ оруулна уу';

  @override
  String get fieldPasswordLabel => 'Нууц үг';

  @override
  String get passwordHint => 'Нууц үгээ оруулна уу';

  @override
  String get loginRememberMe => 'Намайг сана';

  @override
  String get loginForgotPassword => 'Нууц үгээ мартсан уу?';

  @override
  String get loginLoggingIn => 'Нэвтэрч байна...';

  @override
  String get passwordLengthError => 'Нууц үг 8–16 тэмдэгт байх ёстой.';

  @override
  String get passwordsDoNotMatch => 'Нууц үг тохирохгүй байна.';

  @override
  String get signupCheckInput => 'Оруулсан мэдээллээ шалгана уу.';

  @override
  String get fieldConfirmPasswordLabel => 'Нууц үг баталгаажуулах';

  @override
  String get confirmPasswordHint => 'Нууц үгээ дахин оруулна уу';

  @override
  String get signupSigningUp => 'Бүртгүүлж байна...';

  @override
  String get signupHaveAccount => 'Бүртгэлтэй юу?';

  @override
  String get passwordMethodEmailRequired => 'Имэйлээ оруулна уу';

  @override
  String get passwordResetTitle => 'Нууц үг сэргээх';

  @override
  String get passwordMethodDescription =>
      'Нууц үг сэргээх кодыг хүлээн авах имэйл хаягаа оруулна уу.';

  @override
  String get emailAddressHint => 'Имэйл хаяг';

  @override
  String get passwordMethodSending => 'Илгээж байна...';

  @override
  String get passwordMethodSendEmail => 'Имэйл илгээх';

  @override
  String get passwordCodeTitle => 'Код оруулах';

  @override
  String get passwordCodeDescription =>
      'Бид таны имэйл хаяг руу сэргээх код илгээлээ. Үргэлжлүүлэхийн тулд оруулна уу.';

  @override
  String get passwordCodeNoCode => 'Код ирээгүй юу?';

  @override
  String get passwordCodeResend => 'Код дахин илгээх';

  @override
  String get passwordCodeVerifying => 'Шалгаж байна...';

  @override
  String get passwordNewTitle => 'Шинэ нууц үг';

  @override
  String get passwordNewDescription => 'Бүртгэлдээ шинэ нууц үг тохируулна уу.';

  @override
  String get fieldNewPasswordLabel => 'Шинэ нууц үг';

  @override
  String get newPasswordHint => 'Шинэ нууц үгээ оруулна уу';

  @override
  String get fieldConfirmNewPasswordLabel => 'Шинэ нууц үг баталгаажуулах';

  @override
  String get confirmNewPasswordHint => 'Шинэ нууц үгээ дахин оруулна уу';

  @override
  String get passwordNewSubmitting => 'Илгээж байна...';

  @override
  String get passwordNewSubmit => 'Илгээх';

  @override
  String get passwordCompleteTitle => 'Нууц үг сэргээгдлээ';

  @override
  String get passwordCompleteBody =>
      'Таны нууц үг шинэчлэгдлээ. Үргэлжлүүлэхийн тулд шинэ нууц үгээрээ нэвтэрнэ үү.';

  @override
  String get termsTitle => 'Үйлчилгээний нөхцөл';

  @override
  String get privacyTitle => 'Нууцлалын бодлого';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email-д зориулж шинэ нууц үг тохируулна уу.';
  }

  @override
  String get selectComplete => 'Дууслаа';

  @override
  String get onboardingLanguageTitle => 'Таны эх хэл юу вэ?';

  @override
  String get onboardingReasonTitle => 'Та яагаад хэл сурч байна вэ?';

  @override
  String get onboardingReasonSubtitle =>
      'Бид таны зорилгод тохируулан сургалтыг тохируулна.';

  @override
  String get savingLabel => 'Хадгалж байна...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Энэ сарын төлбөр';

  @override
  String get filterAll => 'Бүгд';

  @override
  String get filterSubscription => 'Захиалга';

  @override
  String get filterCharacter => 'Дүр';

  @override
  String get statusCompleted => 'Дууссан';

  @override
  String get lastPayment => 'Сүүлийн төлбөр';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Та $date хүртэл Pro давуу талыг үргэлжлүүлэн ашиглах боломжтой, дараа нь таны багц автоматаар үнэгүй болж солигдоно.';
  }

  @override
  String get freePlanCallLimit => 'Өдөрт 1 дуудлага · 5 мин хязгаар';

  @override
  String get freePlanBasicCharacters => 'Үндсэн дүрүүд багтсан';

  @override
  String get availableForPurchase => 'Худалдан авах боломжтой';

  @override
  String get paymentsLoadError => 'Төлбөрийн түүхийг ачаалж чадсангүй';

  @override
  String get noPayments => 'Одоогоор төлбөр алга';

  @override
  String get morePaymentsExist => 'Хуучин төлбөрүүд хараахан харагдахгүй байна';

  @override
  String get undatedPayments => 'Огноогүй';

  @override
  String get paymentLabelFallback => 'Төлбөр';

  @override
  String learningPassed(int passed, int total) {
    return '$total өгүүлбэрээс $passed нь тэнцлээ';
  }

  @override
  String get hardestSound => 'Өнөөдрийн хамгийн хэцүү авиа';

  @override
  String get soundAccuracy => 'Авиа тус бүрийн нарийвчлал';

  @override
  String phonemeAttempts(int count) {
    return 'Авиа тус бүрд · $count оролдлого';
  }

  @override
  String get colSound => 'Авиа';

  @override
  String get colAttempts => 'Оролд.';

  @override
  String get colCorrect => 'Зөв';

  @override
  String get colAccuracy => 'Нарийв.';

  @override
  String get sentenceResults => 'Өгүүлбэр тус бүрийн үр дүн';

  @override
  String viewAllSentences(int count) {
    return 'Бүгдийг харах $count';
  }

  @override
  String get colSentence => 'Өгүүлбэр';

  @override
  String get colPronunciation => 'Дуудл.';

  @override
  String get colFluency => 'Чөлөөт.';

  @override
  String get colRhythm => 'Хэмнэл';

  @override
  String recentSessions(int count) {
    return 'Сүүлийн $count хуралдаан';
  }

  @override
  String trendAverage(int score) {
    return 'Дунд. $score';
  }

  @override
  String get today => 'Өнөөдөр';

  @override
  String get colDate => 'Огноо';

  @override
  String get colSentences => 'Өгүүлбэр';

  @override
  String get colScore => 'Оноо';

  @override
  String get colChange => 'Өөрч.';

  @override
  String dateToday(String date) {
    return '$date (өнөөдөр)';
  }

  @override
  String get accentAnalysis => 'Аялгууны шинжилгээ';

  @override
  String get overallLevel => 'Нийт түвшин';

  @override
  String get overallLevelSubtitle => 'Үгсийн сан · Хэлзүй · Илэрхийлэл';

  @override
  String get pronunciationAnalysis => 'Дуудлагын шинжилгээ';

  @override
  String get recentSessionsAverage => 'Сүүлийн 10 хичээлийн дундаж';

  @override
  String levelStage(int stage) {
    return '$stage-р түвшин';
  }

  @override
  String topPercent(int percent) {
    return 'Шилдэг $percent%';
  }

  @override
  String get allLearnersBasis => 'Бүх суралцагчаас';

  @override
  String aheadOfLearners(int percent) {
    return 'Та суралцагчдын $percent%-аас түрүүлж байна';
  }

  @override
  String get retakeLevelTest => 'Түвшин тогтоох шалгалтыг дахин өгөх';

  @override
  String get practicePronunciation => 'Дуудлага дасгалжуулах';

  @override
  String get priceChangedTitle => 'Үнэ өөрчлөгдлөө';

  @override
  String priceChangedBody(String price) {
    return 'Энэ бараа одоо $price болсон. Үргэлжлүүлэх үү?';
  }

  @override
  String get billingGroupPlanPurchases => 'Багц ба худалдан авалт';

  @override
  String get billingGroupInTheStore => 'Дэлгүүрт';

  @override
  String get billingChangePlan => 'Багц солих';

  @override
  String get billingCompareAllPlans => 'Бүх багцыг харьцуулах';

  @override
  String get billingBuyACharacter => 'Дүр худалдаж авах';

  @override
  String get billingRestorePurchases => 'Худалдан авалт сэргээх';

  @override
  String get billingPaymentHistory => 'Төлбөрийн түүх';

  @override
  String get billingManageInTheStore => 'Дэлгүүрт удирдах';

  @override
  String get billingRefundHelp => 'Буцаан олголтын тусламж';

  @override
  String get billingCancelSubscription => 'Захиалга цуцлах';

  @override
  String get billingResubscribe => 'Дахин захиалах';

  @override
  String get badgeCurrent => 'Одоогийн';

  @override
  String get badgeTrial => 'Туршилт';

  @override
  String get badgeRenewing => 'Сунгагдана';

  @override
  String get badgePastDue => 'Төлбөр хоцорсон';

  @override
  String get badgePaused => 'Түр зогссон';

  @override
  String get badgeCanceling => 'Цуцлагдаж байна';

  @override
  String get subscriptionTitle => 'Захиалга';

  @override
  String get plansTitle => 'Багцууд';

  @override
  String get planFree => 'Үнэгүй';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max туршилт';

  @override
  String get freePlanPriceLine => '\$0.00 — өдөрт нэг дуудлага';

  @override
  String pricePerMonthLine(String amount) {
    return 'Сард $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date хүртэл үнэгүй';
  }

  @override
  String get todaysCalls => 'Өнөөдрийн дуудлага';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit-с $used ашигласан';
  }

  @override
  String get firstPaymentLabel => 'Эхний төлбөр';

  @override
  String get nextPaymentLabel => 'Дараагийн төлбөр';

  @override
  String get retryingUntilLabel => 'Дахин оролдох хугацаа';

  @override
  String get pausedSinceLabel => 'Түр зогссон огноо';

  @override
  String planEndsLabel(String plan) {
    return '$plan дуусах';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pro-гоор хязгааргүй болоорой';

  @override
  String get bannerGoUnlimitedSub =>
      'Хязгааргүй дуудлага · тус бүр 15 минут · сард \$12.90';

  @override
  String get bannerMaxUpsellTitle => 'Max-аар видеог асаагаарай';

  @override
  String get bannerMaxUpsellSub => 'Нүүр тулсан дуудлага · сард \$19.90';

  @override
  String get bannerAnnualSwitchTitle => 'Жилийн багцад шилжих';

  @override
  String get bannerAnnualSwitchSub => 'Жилд \$159 · сард \$13.25';

  @override
  String get bannerPaymentFailedTitle => 'Төлбөрийг авч чадсангүй';

  @override
  String get bannerPaymentFailedSub =>
      'Pro-г хадгалахын тулд дэлгүүрт төлбөрөө шинэчилнэ үү';

  @override
  String get bannerPausedTitle => 'Таны багц түр зогссон';

  @override
  String get bannerPausedSub => 'Төлбөр хийгдээгүй';

  @override
  String get noteRestoreHint =>
      'Өөр төхөөрөмж дээр захиалсан уу? Сэргээх нь энэ төхөөрөмж дээр буцааж идэвхжүүлнэ.';

  @override
  String get noteStoreHandled =>
      'Төлбөрийн хэрэгсэл, багц солих, цуцлалтыг дэлгүүр хариуцна.';

  @override
  String get noteFairUse =>
      'Хязгааргүй хэрэглээ нь манай шударга хэрэглээний бодлогод захирагдана.';

  @override
  String noteTrialEnds(String date) {
    return 'Таны туршилт $date-нд дуусна. Түүнээс өмнө дэлгүүрт цуцалбал ямар ч төлбөр гарахгүй.';
  }

  @override
  String get noteGrace =>
      'Хүлээлгийн хугацаанд давуу тал үргэлжилнэ. Цуцлалтыг апп дотор хэзээ ч саатуулахгүй.';

  @override
  String get noteHold =>
      'Төлбөр хийгдэх хүртэл Pro түр зогсоно. Таны дүрүүд болон ахиц аюулгүй.';

  @override
  String noteEnding(String date) {
    return 'Таны багц дуусахаар тохируулагдсан. Давуу тал $date хүртэл үргэлжилж, дараа нь та Үнэгүй багцад шилжинэ. Хүссэн үедээ дахин захиалж болно.';
  }

  @override
  String get trialExpiredTitle => 'Таны Max туршилт дууслаа';

  @override
  String get trialExpiredSub => 'Та одоо Үнэгүй багцад байна';

  @override
  String get seePlans => 'Багцуудыг үзэх';

  @override
  String get currentPlanTitle => 'Одоогийн багц';

  @override
  String get badgeRecommended => 'Санал болгож буй';

  @override
  String get perMonthUnit => 'сард';

  @override
  String get planTaglinePro => 'Хязгааргүй дуудлага. Тус бүр 15 минут.';

  @override
  String get planTaglineMax => 'Одоо та тэднийг харах боломжтой.';

  @override
  String get planTaglineFree => 'Өдөрт нэг дуудлага. Үнэгүй.';

  @override
  String get bulletProCalls => 'Хүссэн хэмжээгээрээ дуут дуудлага';

  @override
  String get bulletProLength => 'Дуудлага бүр 15 минут';

  @override
  String get bulletProScoring => 'Дуудлагыг үсэг үсгээр нь дүгнэнэ';

  @override
  String get bulletProCorrections => 'Таны төрөлх хэлэнд тохирсон засварууд';

  @override
  String get bulletProBeaverCalls => 'Beaver танд түрүүлж залгана';

  @override
  String get bulletMaxVideo => 'Нүүр тулсан видео дуудлага';

  @override
  String get bulletMaxEverything => 'Pro-гийн бүх зүйл';

  @override
  String get bulletMaxCharacters => 'Бүх дүр, хязгааргүй';

  @override
  String get bulletMaxStudyBook => 'Таны түвшинд тохирсон сурах бичиг';

  @override
  String get bulletMaxWeeklyReport =>
      'Таны дуудлага хэрхэн өөрчлөгдөж буй долоо хоногийн тайлан';

  @override
  String get bulletFreeCall => 'Өдөрт нэг 5 минутын дуут дуудлага';

  @override
  String get bulletFreeCheck => 'Өдөрт нэг дуудлагын шалгалт';

  @override
  String get bulletFreeAccent => 'Хязгааргүй аялгууны шалгалт';

  @override
  String get bulletFreeCharacter => 'Эхлэхэд нэг дүр';

  @override
  String get ctaGoUnlimited => 'Хязгааргүй болох';

  @override
  String get ctaTurnOnVideo => 'Видео асаах';

  @override
  String get noteCallLength => 'Дуудлага бүр 15 минут үргэлжилнэ.';

  @override
  String get paywallProTitle1 => 'Шөнийн 3 цагт ч сэрүүн байдаг';

  @override
  String get paywallProTitle2 => 'таны солонгос найз';

  @override
  String get paywallProSub =>
      'Хязгааргүй дуудлага. Тус бүр 15 минут. Жилийн турш.';

  @override
  String get paywallLimitHeadline => 'Pro хязгаарыг арилгана.';

  @override
  String get limitBannerCallTitle => 'Энэ өнөөдрийн дуудлага байлаа';

  @override
  String get limitBannerCallSub => 'Үнэгүй багц өдөрт нэг дуудлага олгоно';

  @override
  String get limitBannerCheckTitle => 'Энэ өнөөдрийн шалгалт байлаа';

  @override
  String get limitBannerCheckSub => 'Үнэгүй багц өдөрт нэг шалгалт олгоно';

  @override
  String get bulletProCharactersForever =>
      'Худалдаж авсан дүрүүд тань үүрд таных';

  @override
  String get paywallMaxTitle => 'Одоо та тэднийг харах боломжтой.';

  @override
  String get paywallMaxSub =>
      'Видео дуудлага, бүх дүр, таны түвшинд зориулж бүтээсэн сурах бичиг.';

  @override
  String get planMonthly => 'Сарын';

  @override
  String get planAnnual => 'Жилийн';

  @override
  String get proMonthlyPriceLine => 'Сард \$12.90';

  @override
  String get proAnnualPriceLine => '\$100.00 · сард \$8.33';

  @override
  String get maxMonthlyPriceLine => 'Сард \$19.90';

  @override
  String get maxAnnualPriceLine => 'Жилд \$159.00 · сард \$13.25';

  @override
  String get ctaCaptionPro => 'Сард \$12.90 · дэлгүүрт хүссэн үедээ цуцална';

  @override
  String get ctaCaptionMax => 'Сард \$19.90 · дэлгүүрт хүссэн үедээ цуцална';

  @override
  String get footerTerms => 'Үйлчилгээний нөхцөл';

  @override
  String get footerPrivacy => 'Нууцлал';

  @override
  String get noteMaxCharacters =>
      'Max-аар нээгдсэн дүрүүд захиалга идэвхтэй үед ашиглагдана. Худалдаж авсан дүрүүд тань таных хэвээр үлдэнэ.';

  @override
  String get processingTitle => 'Худалдан авалтыг баталгаажуулж байна';

  @override
  String get processingSub => 'Энэ ихэвчлэн хэдхэн секунд болно.';

  @override
  String get successProTitle => 'Та Pro боллоо.';

  @override
  String get successProSub => 'Хязгааргүй дуудлага, яг одооноос.';

  @override
  String get successProBenefit1 =>
      'Хүссэн хэмжээгээрээ залгаарай — дуудлага бүр 15 минут';

  @override
  String get successProBenefit2 => 'Хязгааргүй дуудлагын шалгалт';

  @override
  String get successProBenefit3 =>
      'Бүх дүр, дээр нь нэг удаагийн худалдан авалт';

  @override
  String get successMaxTitle => 'Одоо та тэднийг харж чадна.';

  @override
  String get successMaxSub =>
      'Видео дуудлага идэвхжлээ. Аль ч дуудлагад видео товчийг дарна уу.';

  @override
  String get successMaxBenefit1 => 'Нүүр тулсан видео дуудлага';

  @override
  String get successMaxBenefit2 =>
      'Бүх дүр, хязгааргүй, шинийг нь түрүүлж авна';

  @override
  String get successMaxBenefit3 => 'Таны түвшинд тохирсон сурах бичиг';

  @override
  String get ctaStartACall => 'Дуудлага эхлүүлэх';

  @override
  String get ctaStartAVideoCall => 'Видео дуудлага эхлүүлэх';

  @override
  String get ctaSeeYourSubscription => 'Захиалгаа үзэх';

  @override
  String get successProCaption =>
      'Цуцлах хүртэл сар бүр \$12.90 төлөгдөнө. Дэлгүүрт хүссэн үедээ удирдах эсвэл цуцлаарай.';

  @override
  String get successMaxCaption =>
      'Цуцлах хүртэл сар бүр \$19.90 төлөгдөнө. Дэлгүүрт хүссэн үедээ удирдах эсвэл цуцлаарай.';

  @override
  String get plansErrorTitle => 'Багцуудыг ачаалж чадсангүй';

  @override
  String get plansErrorSub => 'Дэлгүүр хариу өгсөнгүй.';

  @override
  String get ctaTryAgain => 'Дахин оролдох';

  @override
  String get plansErrorCaption => 'Ямар ч төлбөр гараагүй.';

  @override
  String get changePlanTitle => 'Багц солих';

  @override
  String get moveToMaxTitle => 'Max руу шилжих';

  @override
  String get maxPriceShort => '\$19.90 / сар';

  @override
  String get moveToMaxCardSub =>
      'Нүүр тулсан видео дуудлага · бүх дүр · танд зориулсан сурах бичиг';

  @override
  String get whatHappensNow => 'Одоо юу болох вэ';

  @override
  String get maxStartsLabel => 'Max эхлэх';

  @override
  String get immediately => 'Шууд';

  @override
  String get unusedProTime => 'Ашиглаагүй Pro хугацаа';

  @override
  String get creditedTowardMax => 'Max-д тооцогдоно';

  @override
  String nextPaymentMaxValue(String date) {
    return '\$19.90 · $date';
  }

  @override
  String nextPaymentProValue(String date) {
    return '\$12.90 · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max руу шилжих';

  @override
  String get upgradeCaption =>
      'Шинэ багц тань шууд эхэлнэ. Ашиглаагүй Pro хугацаа тооцогдох бөгөөд хэзээ ч давхар төлбөр гарахгүй.';

  @override
  String get moveToProTitle => 'Pro руу шилжих';

  @override
  String get moveToProSub =>
      'Өнөөдөр юу ч өөрчлөгдөхгүй. Max таны төлсөн сарын эцэс хүртэл үргэлжилнэ.';

  @override
  String get maxRunsUntil => 'Max үргэлжлэх хугацаа';

  @override
  String get proStarts => 'Pro эхлэх';

  @override
  String get whatYouKeep => 'Танд үлдэх зүйлс';

  @override
  String get keepBenefitCalls => 'Хязгааргүй дуут дуудлага, тус бүр 15 минут';

  @override
  String get keepBenefitCharacters => 'Худалдаж авсан дүрүүд тань үүрд таных';

  @override
  String downgradeWarning(String date) {
    return 'Видео дуудлага болон зөвхөн Max-ын дүрүүд $date-нд унтарна.';
  }

  @override
  String get ctaSwitchToPro => 'Pro руу шилжих';

  @override
  String get ctaKeepMax => 'Max-аа хадгалах';

  @override
  String get winbackSkip => 'Алгасах';

  @override
  String get winbackTitle => 'Таны Pro багц дууслаа';

  @override
  String get winbackSub => 'Та одоо Үнэгүй багцад байна — өдөрт нэг дуудлага.';

  @override
  String get winbackQuestion => 'Яагаад гарсан шалтгаанаа хэлж өгөх үү?';

  @override
  String get winbackReasonExpensive => 'Хэтэрхий үнэтэй';

  @override
  String get winbackReasonUnused => 'Хангалттай ашигладаггүй байсан';

  @override
  String get winbackReasonMissing => 'Надад хэрэгтэй функц байгаагүй';

  @override
  String get winbackReasonOtherApp => 'Өөр апп олсон';

  @override
  String get winbackReasonElse => 'Өөр шалтгаан';

  @override
  String get ctaSend => 'Илгээх';

  @override
  String get ctaNotNow => 'Одоохондоо үгүй';

  @override
  String get winbackCaption =>
      'Энэ таны багцыг сэргээхгүй. Дэлгүүрт дахин захиална уу.';

  @override
  String get ctaContinue => 'Үргэлжлүүлэх';

  @override
  String get ctaClose => 'Хаах';

  @override
  String get ovRestoreSuccessTitle => 'Pro эргэн ирлээ';

  @override
  String get ovRestoreSuccessBody =>
      'Бид таны захиалгыг олж, энэ төхөөрөмж дээр буцааж идэвхжүүллээ.';

  @override
  String get ovRestoreEmptyTitle => 'Сэргээх зүйл алга';

  @override
  String get ovRestoreEmptyBody =>
      'Энэ дэлгүүрийн бүртгэлд холбогдсон идэвхтэй захиалга алга.';

  @override
  String get ovRestoreOtherTitle => 'Энэ багц өөр бүртгэлийнх байна';

  @override
  String get ovRestoreOtherBody =>
      'Энэ захиалга өөр BeaverTalk бүртгэл дээр аль хэдийн идэвхтэй байна.';

  @override
  String get ctaSignInThatAccount => 'Тэр бүртгэлээр нэвтрэх';

  @override
  String get ctaGetHelp => 'Тусламж авах';

  @override
  String get ovCharacterOfferTitle => 'Pro-д бэлэн биш үү?';

  @override
  String get ovCharacterOfferBody =>
      'Нэг дүр сонгоод үүрд аваарай. Нэг удаагийн худалдан авалт — захиалгагүй, сунгалтгүй.';

  @override
  String get rowOneCharacter => 'Нэг дүр';

  @override
  String get rowFromPrice => '\$5.00-с эхлэн';

  @override
  String get rowYoursForever => 'Үүрд таных';

  @override
  String get rowNoRenewal => 'Сунгалтгүй';

  @override
  String get rowWorksOnFree => 'Үнэгүй багц дээр ажиллана';

  @override
  String get rowYes => 'Тийм';

  @override
  String get ctaSeeCharacters => 'Дүрүүдийг үзэх';

  @override
  String get ovNotEligibleTitle => 'Цуцлах зүйл алга';

  @override
  String get ovNotEligibleBody =>
      'Та Үнэгүй багцад байна. Энэ бүртгэлд идэвхтэй захиалга алга.';

  @override
  String get ovCancelDownsellTitle => 'Явахаасаа өмнө';

  @override
  String get ovCancelDownsellBody =>
      'Цуцлалт дэлгүүрт хийгдэнэ. Мэдэх ёстой хоёр зүйл.';

  @override
  String get rowPayYearlyInstead => 'Оронд нь жилээр төлөх';

  @override
  String get rowYearlyMonthEquiv => 'Сард \$8.33';

  @override
  String get rowCharactersYouBought => 'Худалдаж авсан дүрүүд';

  @override
  String get rowProRunsUntil => 'Pro үргэлжлэх хугацаа';

  @override
  String get ctaSwitchToYearly => 'Жилийн багцад шилжих';

  @override
  String get ctaContinueToStore => 'Дэлгүүр рүү үргэлжлүүлэх';

  @override
  String get ovAnnualSwitchTitle => 'Жилээр төлж, \$54.80 хэмнээрэй';

  @override
  String get ovAnnualSwitchBody =>
      'Та Pro-г хоёр сар ашиглалаа. Жилийн багц тооцоод үзэхэд хямд.';

  @override
  String get rowYouSave => 'Таны хэмнэлт';

  @override
  String get amountSaved => '\$54.80';

  @override
  String get rowYearly => 'Жилийн';

  @override
  String get amountYearly => '\$100.00';

  @override
  String get rowMonthlyForYear => 'Сараар, жилийн турш';

  @override
  String get amountMonthlyForYear => '\$154.80';

  @override
  String get ovMonthlySwitchTitle => 'Сарын багцад шилжих';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Таны жилийн багц $date хүртэл үргэлжилнэ. Сарын төлбөр дараагийн өдрөөс эхэлнэ.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Сарын төлбөр эхлэх';

  @override
  String get rowMonthlyLabel => 'Сарын';

  @override
  String get rowYearlyWorkedOut => 'Жилийнх тооцоход';

  @override
  String get ctaSwitchToMonthly => 'Сарын багцад шилжих';

  @override
  String get ovRefundHelpTitle => 'Буцаан олголтыг дэлгүүр хариуцна';

  @override
  String get ovRefundHelpBody =>
      'Бид өөрсдөө буцаан олголт хийх боломжгүй. Хүсэлт бүрийг дэлгүүр хянана.';

  @override
  String get ctaGoToStore => 'Дэлгүүр рүү очих';

  @override
  String get ovTrialEndingTitle => 'Таны туршилт маргааш дуусна';

  @override
  String get ovTrialEndingBody =>
      'Цуцлахгүй бол Max үргэлжилнэ. Юу болохыг эндээс харна уу.';

  @override
  String get rowTrialEnds => 'Туршилт дуусах';

  @override
  String get rowFirstCharge => 'Эхний төлбөр';

  @override
  String get rowThenMonthly => 'Дараа нь сар бүр';

  @override
  String get ctaCancelInStore => 'Дэлгүүрт цуцлах';

  @override
  String get ovTrialStartTitle => 'Max-ын 7 хоног, үнэгүй';

  @override
  String ovTrialStartBody(String date) {
    return '$date хүртэл үнэгүй. Дараа нь дэлгүүрт цуцлахгүй бол сард \$19.90.';
  }

  @override
  String get ctaStart7Days => '7 хоног үнэгүй эхлүүлэх';

  @override
  String get ovOtoTitle => 'Эхлэхээсээ өмнө бас нэг зүйл';

  @override
  String get ovOtoBody =>
      'Сайн сонголт — хязгааргүй дуудлага одоо идэвхтэй. Яг ижил Pro жилээр төлбөл хямд.';

  @override
  String get ovFailedDeclinedTitle => 'Таны карт татгалзагдлаа';

  @override
  String get ovFailedDeclinedBody =>
      'Дэлгүүр төлбөрийг авч чадсангүй. Ямар ч төлбөр гараагүй.';

  @override
  String get ctaUpdatePaymentMethod => 'Төлбөрийн хэрэгсэл шинэчлэх';

  @override
  String get ovFailedCanceledTitle => 'Төлбөр цуцлагдлаа';

  @override
  String get ovFailedCanceledBody =>
      'Та Үнэгүй багцад хэвээр байна. Ямар ч төлбөр гараагүй.';

  @override
  String get ovFailedStoreTitle => 'Алдаа гарлаа';

  @override
  String get ovFailedStoreBody =>
      'Дэлгүүртэй холбогдож чадсангүй. Ямар ч төлбөр гараагүй.';

  @override
  String get ovAlreadyTitle => 'Та аль хэдийн Pro байна';

  @override
  String get ovAlreadyBody =>
      'Энэ дэлгүүрийн бүртгэлд идэвхтэй багц байна. Худалдаж авах зүйл алга.';

  @override
  String get ctaSeeMySubscription => 'Миний захиалгыг үзэх';

  @override
  String get subCancelTitle => 'Захиалга цуцлах';

  @override
  String subCancelBody(String date) {
    return 'Pro $date хүртэл үргэлжилнэ. Дараа нь та Үнэгүй багцад шилжинэ.';
  }

  @override
  String get subWhatYouLose => 'Таны алдах зүйлс';

  @override
  String get benefitCalls15 => 'Хязгааргүй дуудлага, тус бүр 15 минут';

  @override
  String get benefitScoring => 'Дуудлагыг үсэг үсгээр нь дүгнэнэ';

  @override
  String get benefitEveryCharacter => 'Бүх дүр, хязгааргүй';

  @override
  String get ctaKeepPro => 'Pro-гоо хадгалах';

  @override
  String get subPaymentTitle => 'Төлбөр шинэчлэх';

  @override
  String get subPaymentBody =>
      'Төлбөрийг авч чадсангүй. Хүлээлгийн хугацаанд Pro үргэлжилнэ.';

  @override
  String get subHowToFix => 'Хэрхэн засах вэ';

  @override
  String get fixStep1 => 'Дэлгүүрээ нээж, төлбөрийн хэрэгслээ шинэчилнэ үү';

  @override
  String get fixStep2 => 'Буцаж ирээрэй — багц тань автоматаар сэргэнэ';

  @override
  String get fixStep3 => 'Ямар ч давхар төлбөр гарахгүй';

  @override
  String get subResubTitle => 'Дахин захиалах';

  @override
  String subResubBody(String date) {
    return 'Pro $date-нд дуусна. Автомат сунгалтыг буцааж асаавал юу ч өөрчлөгдөхгүй.';
  }

  @override
  String get subWhatYouKeep => 'Танд үлдэх зүйлс';

  @override
  String get ctaTurnItBackOn => 'Буцааж асаах';

  @override
  String get flTodayTitle => 'Энэ өнөөдрийн дуудлага байлаа';

  @override
  String get flTodayBody => 'Орхисон газраасаа үргэлжлүүлээрэй — яг одоо.';

  @override
  String get flCheckTitle => 'Энэ өнөөдрийн шалгалт байлаа';

  @override
  String get flCheckBody =>
      'Үнэгүй багцад өдөрт нэг шалгалт. Pro хязгааргүй болгоно.';

  @override
  String get flBenefitCalls =>
      'Pro-гоор хязгааргүй дуудлага · тус бүр 15 минут';

  @override
  String get flBenefitChecks => 'Pro-гоор хязгааргүй дуудлагын шалгалт';

  @override
  String get flCaption => 'Сард \$12.90 · хүссэн үедээ цуцална';

  @override
  String flUsage(String used, String limit) {
    return '$limit-с $used ашигласан';
  }

  @override
  String get ctaMaybeTomorrow => 'Магадгүй маргааш';

  @override
  String get accountSection => 'Данс';

  @override
  String get nicknameLabel => 'Хоч нэр';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Нэвтрэх арга';

  @override
  String get joinedLabel => 'Бүртгүүлсэн';

  @override
  String get editNicknameTitle => 'Хоч нэр засах';

  @override
  String get nicknameRule => '2–12 тэмдэгт. Зөвхөн үсэг ба тоо.';

  @override
  String get ctaSave => 'Хадгалах';

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
  String get paywallLeaveTitle => 'Одоо гарвал захиалга хийгдэхгүй';

  @override
  String get paywallLeaveBody =>
      'Төлбөрийн дараа шууд давуу тал нээгдэнэ. Миний хуудаснаас хүссэн үедээ буцаж болно.';

  @override
  String get ctaKeepLooking => 'Үргэлжлүүлэн үзэх';

  @override
  String get ctaLeaveAnyway => 'Гарах';

  @override
  String get iapCharacterSuccessTitle => 'Шинэ найз нэгдлээ!';

  @override
  String get iapCharacterSuccessBody =>
      'Энэ дүр үүрд таных — багц өөрчлөгдсөн ч хадгалагдана, Худалдан авалт сэргээх нь ямар ч төхөөрөмж дээр буцааж өгнө.';

  @override
  String get iapCharacterFailedBody =>
      'Худалдан авалт амжилтгүй боллоо. Төлбөр гараагүй — дахин оролдоно уу.';
}
