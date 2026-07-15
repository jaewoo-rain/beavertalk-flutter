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
}
