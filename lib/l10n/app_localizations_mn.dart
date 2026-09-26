// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class AppLocalizationsMn extends AppLocalizations {
  AppLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String get loginRequired => 'Нэвтрэх шаардлагатай.';

  @override
  String get callWebNotSupported =>
      'Вэб дээр дуут дуудлага дэмжигдэхгүй. Аппыг ашиглана уу.';

  @override
  String get micPermissionRequiredForCall =>
      'Микрофоны зөвшөөрөл шаардлагатай. Дуудлага хийхийн тулд микрофоныг зөвшөөрнө үү.';

  @override
  String get callErrorGeneric => 'Дуудлагын үеэр алдаа гарлаа.';

  @override
  String get callDailyLimit => 'Өнөөдрийн суралцах цаг дууслаа.';

  @override
  String get callAlreadyInCall => 'Та аль хэдийн дуудлага дээр байна.';

  @override
  String get callNetworkError => 'Сүлжээний алдаа гарлаа.';

  @override
  String get authInvalidCredentials => 'И-мэйл эсвэл нууц үг буруу байна.';

  @override
  String get authEmailAlreadyRegistered => 'Энэ и-мэйл бүртгэлтэй байна.';

  @override
  String get authConfirmEmailRequired =>
      'И-мэйлд илгээсэн баталгаажуулалтыг гүйцэтгэнэ үү.';

  @override
  String get authResetCodeSent => 'Баталгаажуулах кодыг и-мэйлд илгээлээ.';

  @override
  String get authResetCodeInvalid =>
      'Код буруу эсвэл хугацаа нь дууссан байна.';

  @override
  String get authPasswordUpdated => 'Нууц үг сэргээгдлээ.';

  @override
  String get authAppleTokenMissing => 'Apple нэвтрэх токен авч чадсангүй.';

  @override
  String callEndedDuration(String duration) {
    return 'Дуудлага дуусав $duration';
  }

  @override
  String get callRatingPrompt => 'Дуудлага ямар байсан бэ?';

  @override
  String get callRatingBody =>
      'Таны үнэлгээ дараагийн яриаг илүү сайн болгоход тусална.';

  @override
  String get callRatingSubmit => 'Илгээх';

  @override
  String get callRatingSkip => 'Алгасах';

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
  String get alarmAdd => 'Сэрүүлэг нэмэх';

  @override
  String get alarmEdit => 'Сэрүүлэг засах';

  @override
  String get alarmEveryDay => 'Өдөр бүр';

  @override
  String get alarmWeekdays => 'Ажлын өдрүүд';

  @override
  String get alarmWeekend => 'Амралтын өдрүүд';

  @override
  String get alarmNoRepeat => 'Давтахгүй';

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
  String get alarmModeLearnSub => 'Хөтөлбөрийн хэллэг дадлагажуулах';

  @override
  String get alarmModeChatSub => 'Дурын сэдвээр ярих';

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
  String get newExpressions => 'Шинэ хэллэгүүд';

  @override
  String get analysisPrepNote => 'Өнөөдрийн дуудлагыг эргэн харж байна.';

  @override
  String get analysisPrepNoteHint => 'Удахгүй энд захидал гарч ирнэ';

  @override
  String get analysisPrepTitle => 'Минж өнөөдрийн хэллэгүүдээр карт хийж байна';

  @override
  String get analysisPrepSub => 'Бэлэн болмогц яг энд гарч ирнэ.';

  @override
  String get analysisPrepStepSave => 'Яриаг хадгалах';

  @override
  String get analysisPrepStepCards => 'Хэллэгийн карт хийх';

  @override
  String get analysisPrepStateDone => 'Дууссан';

  @override
  String get analysisPrepStateWorking => 'Хийж байна';

  @override
  String get analysisPrepStateWaiting => 'Хүлээж байна';

  @override
  String get usedExpressions => 'Таны хэрэглэсэн хэллэгүүд';

  @override
  String quizExpressionsCount(int count) {
    return 'Сурсан хэллэг $count';
  }

  @override
  String get quizPassed => 'Зөв';

  @override
  String get quizFailed => 'Дахин харах';

  @override
  String get quizPending => 'Дараагийн удаа үргэлжлүүлнэ';

  @override
  String get analysisResult => 'Дүн шинжилгээний үр дүн';

  @override
  String get noNewExpressions => 'Энэ ярианаас шинэ хэллэг олдсонгүй.';

  @override
  String get practice => 'Дадлага';

  @override
  String get analysisNativeLabel => 'Уугуул хэлтэн';

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
  String get selectNativeLanguage => 'Эх хэлээ сонгоно уу';

  @override
  String get selectYourLanguage => 'Хэлээ сонгоно уу';

  @override
  String get confirm => 'Баталгаажуулах';

  @override
  String get cancel => 'Цуцлах';

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
  String get navCall => 'Дуудлага';

  @override
  String get homeCourseExpression => 'Хэллэг';

  @override
  String get homeCourseFreetalk => 'Яриа';

  @override
  String homeExpressionsLeft(int count) {
    return 'Яриа хүртэл $count хэллэг үлдлээ';
  }

  @override
  String get homeFreetalkNote => 'Сурсанаа ашиглан чөлөөтэй ярилцаарай';

  @override
  String get homeTalkTitle => 'Өнөөдөр юу болсон бэ?';

  @override
  String get homeTalkNote => 'Чөлөөтэй ярилцаж, дундуур нь суралцаарай.';

  @override
  String get homeModeLearn => 'Суралцах';

  @override
  String get homeModeTalk => 'Ярилцах';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'дараалан $count өдөр',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Суралцах хуанли';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'өдөр дараалан',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Шилдэг амжилт: $count өдөр',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Ярианы хугацаа';

  @override
  String get streakMetricLearned => 'Сурсан хэллэг';

  @override
  String get streakMetricWords => 'Хэлсэн үг';

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
  String get streakNoCallsThatDay => 'Энэ өдөр дуудлага байхгүй.';

  @override
  String get homeLevelPending => 'Түвшин тодорхойгүй';

  @override
  String get homeNoLevelTitle => 'Танд одоогоор түвшин алга';

  @override
  String get homeNoLevelNote => 'Эхний дуудлагаа дуусгавал түвшин гарна';

  @override
  String get homeCurriculumPendingBadge => 'Удахгүй';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language хөтөлбөр бэлтгэгдэж байна';
  }

  @override
  String get homeCurriculumPendingNote =>
      'Дуудлагаар ерөнхий хэллэг дадлагажина';

  @override
  String get myPage => 'Миний хуудас';

  @override
  String get languageSaveFailed => 'Хэлний тохиргоог хадгалж чадсангүй.';

  @override
  String get accountDeleteFailed => 'Бүртгэлийг устгаж чадсангүй.';

  @override
  String get changeAvatar => 'Аватар солих';

  @override
  String get avatarUseNow => 'Одоо ашиглах';

  @override
  String get avatarPurchaseFailed => 'Худалдан авалт амжилтгүй боллоо';

  @override
  String avatarPromoTitle(int percent) {
    return 'Зөвхөн өнөөдөр · $percent% хямдрал';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time үлдсэн';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days өдөр $time үлдсэн';
  }

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
  String pricePerMonth(String price) {
    return '$price / сар';
  }

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
  String get challengeLoadingNote => 'Камер болон микрофоныг бэлтгэж байна.';

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
  String accentShareText(String country) {
    return 'Би BeaverTalk-аар солонгос хэл сурч байна — миний солонгос аялга ингэж сонсогддог: $country! 🦫 Өөрийн аялгаа олоод надтай хамт сур: https://beavertalk.im';
  }

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
  String get onboardingLevelTestCta => 'Түвшин тогтоох шалгалт өгөх';

  @override
  String get pronunciation => 'Дуудлага';

  @override
  String get fluency => 'Чөлөөтэй байдал';

  @override
  String get rhythm => 'Хэмнэл';

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
  String get loginFacebookSignInFailed => 'Facebook нэвтрэлт амжилтгүй боллоо.';

  @override
  String get loginKakaoSignInFailed => 'Kakao нэвтрэлт амжилтгүй боллоо.';

  @override
  String get loginContinueWithKakao => 'Kakao-гаар үргэлжлүүлэх';

  @override
  String get loginContinueWithGoogle => 'Google-ээр үргэлжлүүлэх';

  @override
  String get loginContinueWithFacebook => 'Facebook-оор үргэлжлүүлэх';

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
  String get freePlanCallLimit => 'Өдөрт 5 минут дуудлага';

  @override
  String get freePlanBasicCharacters => 'Үндсэн дүрүүд багтсан';

  @override
  String get availableForPurchase => 'Худалдан авах боломжтой';

  @override
  String get paymentsLoadError => 'Төлбөрийн түүхийг ачаалж чадсангүй';

  @override
  String get noPayments => 'Одоогоор төлбөр алга';

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
  String get levelTestOncePerDay =>
      'Түвшин тогтоох шалгалтыг өдөрт нэг удаа өгч болно. Маргааш дахин оролдоно уу.';

  @override
  String get levelRetakeTitle => 'Түвшний шалгалтыг дахин өгөх үү?';

  @override
  String get levelRetakeBody =>
      'Дахин өгвөл ахиц тань тухайн түвшний эхний хичээл рүү буцна — ижил түвшин гарсан ч мөн адил. Сурсан хэллэг, дуудлагын түүх хэвээр үлдэнэ.';

  @override
  String get levelRetakeKeep => 'Ахицаа хадгалах';

  @override
  String get levelRetakeConfirm => 'Дахин шалгуулах';

  @override
  String get practicePronunciation => 'Дуудлага дасгалжуулах';

  @override
  String get analysisNoScoreReview => 'Давтвал дуудлагын оноо гарна';

  @override
  String get analysisNoScoreEmpty => 'Үнэлэх өгүүлбэр алга';

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
  String get billingCompareAllPlans => 'Багцуудыг харьцуулах';

  @override
  String get billingBuyACharacter => 'Дүр худалдаж авах';

  @override
  String get billingRestorePurchases => 'Худалдан авалт сэргээх';

  @override
  String get billingRedeemCode => 'Код ашиглах';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Өдөрт 15 минут видео дуудлага';

  @override
  String get premiumBulletAnalysis => 'Дуудлагын бүрэн шинжилгээ';

  @override
  String get premiumBulletWeakSounds =>
      'Таны хэлэнд тохирсон хүндрэлтэй авианы дасгал';

  @override
  String get noteCharactersSeparate =>
      'Дүрүүдийг тусад нь зардаг. Худалдаж авсан дүрүүд тань таных хэвээр үлдэнэ.';

  @override
  String get ctaGetPremium => 'Premium авах';

  @override
  String get planMaxTrial => 'Premium туршилт';

  @override
  String get freePlanPriceLine => '\$0.00 — өдөрт 5 минут дуудлага';

  @override
  String pricePerMonthLine(String amount) {
    return 'Сард $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date хүртэл үнэгүй';
  }

  @override
  String get todaysCalls => 'Өнөөдрийн дуудлагын хугацаа';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit минутаас $used ашигласан';
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
  String get bannerMaxUpsellTitle => 'Premium-аар нүүр тулан ярилцаарай';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Видео дуудлага · өдөрт 15 минут · сард $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Жилийн багцад шилжих';

  @override
  String get bannerPaymentFailedTitle => 'Төлбөрийг авч чадсангүй';

  @override
  String get bannerPaymentFailedSub =>
      'Premium-г хадгалахын тулд дэлгүүрт төлбөрөө шинэчилнэ үү';

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
  String noteTrialEnds(String date) {
    return 'Таны туршилт $date-нд дуусна. Түүнээс өмнө дэлгүүрт цуцалбал ямар ч төлбөр гарахгүй.';
  }

  @override
  String get noteGrace =>
      'Хүлээлгийн хугацаанд давуу тал үргэлжилнэ. Цуцлалтыг апп дотор хэзээ ч саатуулахгүй.';

  @override
  String get noteHold =>
      'Төлбөр хийгдэх хүртэл Premium түр зогсоно. Таны дүрүүд болон ахиц аюулгүй.';

  @override
  String noteEnding(String date) {
    return 'Таны багц дуусахаар тохируулагдсан. Давуу тал $date хүртэл үргэлжилж, дараа нь та Үнэгүй багцад шилжинэ. Хүссэн үедээ дахин захиалж болно.';
  }

  @override
  String get trialExpiredTitle => 'Таны Premium туршилт дууслаа';

  @override
  String get trialExpiredSub => 'Та одоо Үнэгүй багцад байна';

  @override
  String get seePlans => 'Багцуудыг үзэх';

  @override
  String get currentPlanTitle => 'Одоогийн багц';

  @override
  String get perMonthUnit => 'сард';

  @override
  String get planTaglineFree => 'Өдөрт 5 минут дуудлага. Үнэгүй.';

  @override
  String get bulletProCorrections => 'Таны төрөлх хэлэнд тохирсон засварууд';

  @override
  String get bulletFreeCall => 'Өдөрт 5 минут дуут дуудлага';

  @override
  String get bulletFreeCheck => 'Эхний 3 дуудлагад бүрэн шинжилгээ';

  @override
  String get bulletFreeCharacter => 'Эхлэхэд 2 дүр';

  @override
  String get ctaTurnOnVideo => 'Видео асаах';

  @override
  String get noteCallLength =>
      'Premium: өдөрт 15 минут — энэ хугацаанд хүссэн удаагаа залгаж болно.';

  @override
  String get paywallProTitle1 => 'Шөнийн 3 цагт ч сэрүүн байдаг';

  @override
  String get paywallProTitle2 => 'таны солонгос найз';

  @override
  String get paywallLimitHeadline => 'Premium өдөрт 15 минут дуудлага өгнө.';

  @override
  String get limitBannerCallTitle => 'Өнөөдрийн дуудлагын хугацаа дууслаа';

  @override
  String get limitBannerCallSub => 'Үнэгүй багц өдөрт 5 минут дуудлага олгоно';

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
  String paywallTutorCompare(String price) {
    return 'Багштай нэг цаг \$25 болно. Premium нэг сар $price болно.';
  }

  @override
  String get planMonthly => 'Сарын';

  @override
  String get planAnnual => 'Жилийн';

  @override
  String proMonthlyPriceLine(String price) {
    return 'Сард $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · сард $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'Сард $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'Жилд $yearly · сард $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'Сард $price · дэлгүүрт хүссэн үедээ цуцална';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Сард $price · дэлгүүрт хүссэн үедээ цуцална';
  }

  @override
  String ctaCaptionMaxYearly(String price) {
    return 'Жилд $price · дэлгүүрт хүссэн үедээ цуцална';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 хоног үнэгүй, дараа нь Сард $price · дэлгүүрт хүссэн үедээ цуцална';
  }

  @override
  String get ctaCaptionAutoRenew => 'Цуцлах хүртэл автоматаар сунгагдана.';

  @override
  String get footerTerms => 'Үйлчилгээний нөхцөл';

  @override
  String get footerPrivacy => 'Нууцлал';

  @override
  String get processingTitle => 'Худалдан авалтыг баталгаажуулж байна';

  @override
  String get processingSub => 'Энэ ихэвчлэн хэдхэн секунд болно.';

  @override
  String get successProTitle => 'Та Premium боллоо.';

  @override
  String get successMaxTitle => 'Одоо та тэднийг харж чадна.';

  @override
  String get successMaxSub =>
      'Видео дуудлага идэвхжлээ. Аль ч дуудлагад видео товчийг дарна уу.';

  @override
  String get ctaStartAVideoCall => 'Видео дуудлага эхлүүлэх';

  @override
  String get ctaSeeYourSubscription => 'Захиалгаа үзэх';

  @override
  String successMaxCaption(String price) {
    return 'Цуцлах хүртэл сар бүр $price төлөгдөнө. Дэлгүүрт хүссэн үедээ удирдах эсвэл цуцлаарай.';
  }

  @override
  String get plansErrorTitle => 'Багцуудыг ачаалж чадсангүй';

  @override
  String get plansErrorSub => 'Дэлгүүр хариу өгсөнгүй.';

  @override
  String get ctaTryAgain => 'Дахин оролдох';

  @override
  String get plansErrorCaption => 'Ямар ч төлбөр гараагүй.';

  @override
  String get ctaKeepMax => 'Premium-аа хадгалах';

  @override
  String get winbackSkip => 'Алгасах';

  @override
  String get winbackTitle => 'Таны Premium багц дууслаа';

  @override
  String get winbackSub =>
      'Та одоо Үнэгүй багцад байна — өдөрт 5 минут дуудлага.';

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
  String get ovRestoreSuccessTitle => 'Premium эргэн ирлээ';

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
  String get ovCharacterOfferTitle => 'Premium-д бэлэн биш үү?';

  @override
  String get ovCharacterOfferBody =>
      'Нэг дүр сонгоод үүрд аваарай. Нэг удаагийн худалдан авалт — захиалгагүй, сунгалтгүй.';

  @override
  String get rowOneCharacter => 'Нэг дүр';

  @override
  String rowFromPrice(String price) {
    return 'тус бүр $price';
  }

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
  String rowYearlyMonthEquiv(String price) {
    return 'Сард $price';
  }

  @override
  String get rowCharactersYouBought => 'Худалдаж авсан дүрүүд';

  @override
  String get rowProRunsUntil => 'Premium үргэлжлэх хугацаа';

  @override
  String get ctaSwitchToYearly => 'Жилийн багцад шилжих';

  @override
  String get ctaContinueToStore => 'Дэлгүүр рүү үргэлжлүүлэх';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Жилээр төлж, $saved хэмнээрэй';
  }

  @override
  String get ovAnnualSwitchBody => 'Жилийн багц сар бүр төлөхөөс хямд.';

  @override
  String get rowYouSave => 'Таны хэмнэлт';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Жилийн';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Сараар, жилийн турш';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

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
      'Цуцлахгүй бол Premium үргэлжилнэ. Юу болохыг эндээс харна уу.';

  @override
  String get rowTrialEnds => 'Туршилт дуусах';

  @override
  String get rowFirstCharge => 'Эхний төлбөр';

  @override
  String get rowThenMonthly => 'Дараа нь сар бүр';

  @override
  String get ctaCancelInStore => 'Дэлгүүрт цуцлах';

  @override
  String get ovTrialStartTitle => 'Premium-ын 7 хоног, үнэгүй';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date хүртэл үнэгүй. Дараа нь дэлгүүрт цуцлахгүй бол сард $price.';
  }

  @override
  String get ctaStart7Days => '7 хоног үнэгүй эхлүүлэх';

  @override
  String get ovOtoTitle => 'Эхлэхээсээ өмнө бас нэг зүйл';

  @override
  String get ovOtoBody => 'Зөв сонголт. Жилээр төлбөл ижил Premium хямд тусна.';

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
  String get ovAlreadyTitle => 'Та аль хэдийн Premium байна';

  @override
  String get ovAlreadyBody =>
      'Энэ дэлгүүрийн бүртгэлд идэвхтэй багц байна. Худалдаж авах зүйл алга.';

  @override
  String get ctaSeeMySubscription => 'Миний захиалгыг үзэх';

  @override
  String get subCancelTitle => 'Захиалга цуцлах';

  @override
  String subCancelBody(String date) {
    return 'Premium $date хүртэл үргэлжилнэ. Дараа нь та Үнэгүй багцад шилжинэ.';
  }

  @override
  String get subWhatYouLose => 'Таны алдах зүйлс';

  @override
  String get benefitScoring => 'Дуудлагыг үсэг үсгээр нь дүгнэнэ';

  @override
  String get benefitEveryMetric => 'Бүх үзүүлэлт, бүх өгүүлбэр';

  @override
  String get subPaymentTitle => 'Төлбөр шинэчлэх';

  @override
  String get subPaymentBody =>
      'Төлбөрийг авч чадсангүй. Хүлээлгийн хугацаанд Premium үргэлжилнэ.';

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
    return 'Premium $date-нд дуусна. Автомат сунгалтыг буцааж асаавал юу ч өөрчлөгдөхгүй.';
  }

  @override
  String get subWhatYouKeep => 'Танд үлдэх зүйлс';

  @override
  String get ctaTurnItBackOn => 'Буцааж асаах';

  @override
  String get flTodayTitle => 'Өнөөдрийн дуудлагын хугацаа дууслаа';

  @override
  String get flTodayBody => 'Орхисон газраасаа үргэлжлүүлээрэй — яг одоо.';

  @override
  String get flCheckTitle => 'Энэ өнөөдрийн шалгалт байлаа';

  @override
  String get flCheckBody =>
      'Үнэгүй багцад өдөрт нэг шалгалт байна. Premium бүрэн шинжилгээг өгнө.';

  @override
  String flCaption(String price) {
    return 'Сард $price · хүссэн үедээ цуцална';
  }

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
  String get emailLabel => 'И-мэйл';

  @override
  String get loginMethodLabel => 'Нэвтрэх арга';

  @override
  String get joinedLabel => 'Бүртгүүлсэн';

  @override
  String get editNicknameTitle => 'Хоч нэр засах';

  @override
  String get nicknameRule => '2–12 тэмдэгт. Үсэг ба тоо. Зөвхөн англи хэлээр';

  @override
  String get ctaSave => 'Хадгалах';

  @override
  String get subscriptionRow => 'Захиалга';

  @override
  String get iapSuccessTitle => 'Худалдан авалт дууслаа';

  @override
  String iapSuccessBody(String name) {
    return '$name дүр үүрд таных боллоо.\nБаримт баталгаажмагц шууд идэвхжинэ.';
  }

  @override
  String get ctaGoHome => 'Нүүр рүү';

  @override
  String get ctaUseNow => 'Одоо ашиглах';

  @override
  String get iapFailTitle => 'Төлбөр гүйцэтгэгдсэнгүй';

  @override
  String get iapFailBody => 'Дахин оролдож болно';

  @override
  String get paywallGuardTitle => 'Үнэгүйгээр үргэлжлүүлэн ашиглаж болно';

  @override
  String get paywallGuardBody => 'Өдөрт 5 минут дуудлага хэвээр байна.';

  @override
  String get ctaMaybeLater => 'Дараа';

  @override
  String get winbackOfferBadge => 'Эхний сард 50% хөнгөлөлт';

  @override
  String get winbackOfferTitle => 'Эргэн тавтай морил';

  @override
  String get ctaGetHalfOff => '50% хөнгөлөлт авах';

  @override
  String get iapCharacterSuccessTitle => 'Шинэ найз нэгдлээ!';

  @override
  String get iapCharacterSuccessBody =>
      'Энэ дүр үүрд таных — багц өөрчлөгдсөн ч хадгалагдана, Худалдан авалт сэргээх нь ямар ч төхөөрөмж дээр буцааж өгнө.';

  @override
  String get iapCharacterFailedBody =>
      'Худалдан авалт амжилтгүй боллоо. Төлбөр гараагүй — дахин оролдоно уу.';

  @override
  String get noAccentDataTitle => 'Аялгууны мэдээлэл одоогоор алга';

  @override
  String get noAccentDataBody =>
      'Яриагаа үргэлжлүүлбэл аялгууны онцлог чинь хуримтлагдана.';

  @override
  String get noLevelYetTitle => 'Түвшин одоогоор алга';

  @override
  String get noLevelYetBody => 'Эхний дуудлагаа дуусгавал түвшин чинь гарна.';

  @override
  String get noPronunciationDataTitle => 'Дуудлагын бичлэг одоогоор алга';

  @override
  String get noPronunciationDataBody =>
      'Дуудлагад хэлсэн өгүүлбэрээс тань дуудлагыг шинжилнэ.';

  @override
  String get noCharacterNote => 'Одоогоор үлдээсэн үг алга';

  @override
  String get noPhonemesYet => 'Шинжлэх дуу одоогоор алга';

  @override
  String get noSentencesYet => 'Шинжлэх өгүүлбэр одоогоор алга';

  @override
  String get takeLevelTest => 'Түвшин тогтоох шалгалт өгөх';

  @override
  String get playAgain => 'Дахин тоглох';

  @override
  String get difficultySlow => 'Удаан';

  @override
  String get difficultyNormal => 'Хэвийн';

  @override
  String get difficultyFast => 'Хурдан';

  @override
  String get difficultyLabel => 'Хүндрэл';

  @override
  String get connected => 'Холбогдсон';

  @override
  String get unlockedWithMax => 'Таны багцад багтсан';

  @override
  String get fcEndedTitle => 'Таны үнэгүй дуудлага дууслаа';

  @override
  String get fcEndedBody =>
      'Үнэгүй дуудлага хамгийн ихдээ 5 минут үргэлжилнэ\nУрт ярихын тулд захиалга аваарай';

  @override
  String get ctaSubscribeKeepTalking => 'Захиалж, яриаг үргэлжлүүлэх';

  @override
  String get kgTitle => 'Үргэлжлүүлэх үү?';

  @override
  String get kgBody =>
      'Дуудлага богино хэсгүүдээр үргэлжилнэ.\nУдаа бүр дахин асууна.';

  @override
  String get pcEndedTitleToday => 'Өнөөдрийн дуудлагаа дуусгая.';

  @override
  String get pcEndedBodyToday =>
      'Ярьсан зүйлээ давтаад, маргааш дахин залгаарай!';

  @override
  String get pcEndedTitle => 'Энэ дуудлагаа дуусгая.';

  @override
  String get pcEndedBody => 'Ярьсан зүйлээ давтаад, дахин залгаарай!';

  @override
  String get ctaKeepTalking => 'Яриаг үргэлжлүүлэх';

  @override
  String get callModeSheetTitle => 'Та яаж ярихыг хүсэж байна?';

  @override
  String get callModeSheetSubtitle => 'Энэ дуудлагад шууд хэрэгжинэ';

  @override
  String get callModeFreeTalk => 'Чөлөөт яриа';

  @override
  String get callModeFreeTalkDesc => 'Засваргүйгээр чөлөөтэй ярь';

  @override
  String get callModeStudy => 'Суралцах';

  @override
  String get callModeStudyDesc => 'Нэг удаад нэг хэллэг сурна';

  @override
  String get callModeChange => 'Горим солих';

  @override
  String get callModeKeep => 'Одоо биш';

  @override
  String get callExitTitle => 'Дуудлагыг дуусгах уу?';

  @override
  String get callExitSubtitle =>
      'Одоо дуусгасан ч ярьсан хугацаа өнөөдрийн хэрэглээнд тооцогдоно';

  @override
  String get callExitKeep => 'Үргэлжлүүлэн ярих';

  @override
  String get callExitConfirm => 'Дуудлагыг дуусгах';

  @override
  String get callMicMute => 'Дуу хаах';

  @override
  String get callMicUnmute => 'Дуу нээх';

  @override
  String get callPushToTalk => 'Ярихын тулд дараад байна уу';

  @override
  String get callFreeEndedTitle => 'Таны үнэгүй дуудлага дууслаа';

  @override
  String get callFreeEndedCta => 'Захиалж яриагаа үргэлжлүүл';

  @override
  String get callKeepGoingTitle => 'Үргэлжлүүлэх үү?';

  @override
  String get callKeepGoingSubtitle =>
      'Дуудлага 5 минут тутам үргэлжилнэ. Бид тухай бүр дахин асууна.';

  @override
  String get articulationSelectedWord => 'Сонгосон үг';

  @override
  String get articulationYouSaid => 'Таны дуудлага';

  @override
  String get articulationTargetSound => 'Зорилт';

  @override
  String get reportEntry => 'Мэдэгдэх';

  @override
  String get reportTitle => 'Мэдэгдэл';

  @override
  String get reportPrompt => 'Ямар асуудал гарсан бэ?';

  @override
  String get reportGuide =>
      'AI дүрийн ямар агуулга танд эвгүй санагдсаныг хэлнэ үү. Бид бүх мэдэгдлийг хянадаг.';

  @override
  String get reportReasonSexual => 'Бэлгийн агуулга';

  @override
  String get reportReasonHate => 'Үзэн ядалт эсвэл ялгаварлал';

  @override
  String get reportReasonViolence => 'Хүчирхийлэл эсвэл заналхийлэл';

  @override
  String get reportReasonSelfHarm => 'Өөрийгөө гэмтээхийг өдөөх';

  @override
  String get reportReasonMisinfo => 'Худал мэдээлэл';

  @override
  String get reportReasonOther => 'Бусад асуудал';

  @override
  String get reportDetailHint => 'Юу болсныг бичнэ үү (заавал биш)';

  @override
  String get reportSubmit => 'Мэдэгдэл илгээх';

  @override
  String get reportDoneTitle => 'Таны мэдэгдлийг хүлээн авлаа';

  @override
  String get reportDoneBody =>
      'Хянаад шаардлагатай бол арга хэмжээ авна. BeaverTalk-ийг аюулгүй байлгахад тусалсанд баярлалаа.';

  @override
  String get reportFailed => 'Мэдэгдэл илгээж чадсангүй. Дахин оролдоно уу.';

  @override
  String get hwTitle => 'Гэрийн даалгавар';

  @override
  String get hwJoinCodeTitle => 'Ангийнхаа кодыг оруулна уу';

  @override
  String get hwJoinCodeSubtitle => 'Энэ бол багшаас өгсөн 6 тэмдэгттэй код';

  @override
  String get hwJoinCodeLabel => 'Ангийн код';

  @override
  String get hwJoinCodeHelp => 'Код том жижиг үсэг ялгадаггүй';

  @override
  String get hwJoinConfirmTitle => 'Энэ зөв анги мөн үү?';

  @override
  String get hwJoinConfirmSubtitle => 'Хэрэв биш бол кодоо дахин шалгана уу';

  @override
  String get hwJoinFieldInstitution => 'Байгууллага';

  @override
  String get hwJoinFieldTeacher => 'Багш';

  @override
  String get hwJoinFieldLearners => 'Суралцагчид';

  @override
  String get hwJoinFieldTerm => 'Хугацаа';

  @override
  String get hwJoinConfirmNote =>
      'Ангийн нэрийг багшийн бичсэнээр яг хэвээр харуулна. Бид орчуулдаггүй.';

  @override
  String get hwJoinConfirmYes => 'Тийм, энэ мөн';

  @override
  String get hwJoinConfirmRetry => 'Кодыг дахин оруулах';

  @override
  String get hwJoinProfileTitle => 'Ангид ямар нэр ашиглах вэ?';

  @override
  String get hwJoinProfileSubtitle => 'Багш үүнийг ангийн жагсаалттай тулгана';

  @override
  String get hwJoinNameLabel => 'Нэр';

  @override
  String get hwJoinNameHelp => 'Апп дахь нэрээс өөр байж болно';

  @override
  String get hwJoinStudentNoLabel => 'Оюутны дугаар (заавал биш)';

  @override
  String get hwJoinStudentNoHelp => 'Багш ангийн жагсаалт тулгахад ашиглана';

  @override
  String get hwJoinConsentTitle => 'Багш юуг харах вэ';

  @override
  String get hwJoinConsentSubtitle =>
      'Ангид элсэхийн тулд зөвшөөрөл өгөх шаардлагатай';

  @override
  String get hwJoinConsentSharedHeading => 'Багштай хуваалцана';

  @override
  String get hwJoinConsentShared1 => 'Ангийн нэр ба оюутны дугаар';

  @override
  String get hwJoinConsentShared2 => 'Даалгавраа хийсэн эсэх';

  @override
  String get hwJoinConsentShared3 => 'Давсан ба алдсан өгүүлбэрүүд';

  @override
  String get hwJoinConsentShared4 =>
      'Даалгаврын дуудлагын үргэлжлэх хугацаа ба хураангуй';

  @override
  String get hwJoinConsentNotSharedHeading => 'Хуваалцахгүй';

  @override
  String get hwJoinConsentNotShared1 => 'И-мэйл ба утасны дугаар';

  @override
  String get hwJoinConsentNotShared2 => 'Апп дахь нэр, профайл ба дүр';

  @override
  String get hwJoinConsentNotShared3 => 'Иргэншил ба төрөлх хэл';

  @override
  String get hwJoinConsentNotShared4 => 'Ангиас гадуурх дуудлага ба суралцалт';

  @override
  String get hwJoinConsentNotShared5 => 'Захиалга ба төлбөрийн мэдээлэл';

  @override
  String get hwJoinConsentAgree => 'Би дээрхтэй санал нийлж байна';

  @override
  String get hwJoinConsentCta => 'Зөвшөөрч элсэх';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Та $className ангид элслээ';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count даалгавар хүлээж байна';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Одоогоор даалгавар алга';

  @override
  String get hwJoinDoneNextDue => 'Дараагийн эцсийн хугацаа';

  @override
  String get hwJoinDoneRosterName => 'Ангид байгаа таны нэр';

  @override
  String get hwJoinDoneCta => 'Даалгавар харах';

  @override
  String get hwJoinErrorNotFound => 'Ийм код олдсонгүй';

  @override
  String get hwJoinErrorNotFoundBody => 'Зургаан оронг дахин шалгана уу.';

  @override
  String get hwJoinErrorExpired => 'Энэ кодын хугацаа дууссан';

  @override
  String get hwJoinErrorExpiredBody => 'Багшаасаа шинэ код аваарай.';

  @override
  String get hwJoinErrorFull => 'Анги дүүрсэн';

  @override
  String get hwJoinErrorFullBody => 'Багшдаа мэдэгдэнэ үү.';

  @override
  String get hwJoinFailed =>
      'Элсэж чадсангүй. Хэсэг хүлээгээд дахин оролдоно уу.';

  @override
  String get hwSectionInProgress => 'Хийгдэж байна';

  @override
  String get hwSectionUpcoming => 'Удахгүй';

  @override
  String get hwSectionDone => 'Дууссан';

  @override
  String get hwLeaveClassLink => 'Ангиас гарах';

  @override
  String get hwListEmptyTitle => 'Одоогоор даалгавар алга';

  @override
  String get hwListEmptyBody => 'Багш өгмөгц энд харагдана.';

  @override
  String get hwListFailed => 'Даалгаврыг ачаалж чадсангүй.';

  @override
  String get hwRetry => 'Дахин оролдох';

  @override
  String get hwBadgeDone => 'Дууссан';

  @override
  String get hwBadgeOverdue => 'Илгээгээгүй';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Илгээгээгүй, $days хоног хоцорсон';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Өнөөдөр дуусна';

  @override
  String get hwActivitySpeaking => 'Ярих';

  @override
  String get hwActivityConversation => 'Яриа';

  @override
  String get hwActivityWorkbook => 'Дасгалын дэвтэр';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter-р бүлэг';
  }

  @override
  String get hwTaskSpeakingDesc => 'Дуудлагын оноогоо шалгаарай';

  @override
  String get hwTaskConversationDesc => 'Сурсанаа жинхэнэ ярианд хэрэглээрэй';

  @override
  String get hwConversationOnce => 'Ярианы даалгаврыг нэг удаа хийж болно.';

  @override
  String get hwTaskWorkbookDesc => 'Дасгалын дэвтэрт бичиж дасгал хийгээрэй';

  @override
  String get hwCtaStudy => 'Эхлэх';

  @override
  String get hwCtaResult => 'Үр дүн харах';

  @override
  String get hwCtaDownload => 'Татах';

  @override
  String get hwSpeakingNoScore =>
      'Та ярианы даалгаврыг хараахан хийгээгүй байна';

  @override
  String get hwWorkbookUnavailable =>
      'Дасгалын дэвтрийн файл хараахан бэлэн болоогүй.';

  @override
  String get hwDetailClosed =>
      'Энэ даалгавар хаагдсан. Та дахин илгээх боломжгүй.';

  @override
  String get hwLeaveTitle => 'Ангиас гарах уу?';

  @override
  String get hwLeaveBody => 'Багш таны даалгаврын үр дүнг цаашид харахгүй.';

  @override
  String get hwLeaveConfirm => 'Гарах';

  @override
  String get hwLeaveCancel => 'Үлдэх';

  @override
  String get hwLeaveFailed => 'Ангиас гарч чадсангүй.';

  @override
  String get hwMyClass => 'Миний анги';

  @override
  String get hwClassEmptyTitle => 'Та ямар ч ангид элсээгүй байна';

  @override
  String get hwClassEmptySubtitle => 'Багшаас өгсөн кодоо оруулна уу';

  @override
  String get hwClassEmptyCta => 'Ангийн код оруулах';

  @override
  String get hwClassContinueCta => 'Үргэлжлүүлэх';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count даалгаврын хугацаа маргааш дуусна';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Танд илгээгээгүй $count даалгавар байна';
  }

  @override
  String get hwSpeakingUnavailable =>
      'Энэ даалгаврын өгүүлбэрүүд хараахан бэлэн болоогүй.';

  @override
  String get hwBadgeClosed => 'Хаагдсан';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total-аас $passed өгүүлбэр давсан';
  }

  @override
  String get challengeFirstWord => 'Эхний үг';

  @override
  String get challengeSeeAnalysis => 'Үр дүнг харах';

  @override
  String get challengePaused => 'Түр зогссон';

  @override
  String get challengePausedNote => 'Цаг тоолуур ба бичлэг хамт зогслоо.';

  @override
  String get challengeTimeLeft => 'Үлдсэн хугацаа';

  @override
  String get challengeScoreLabel => 'Оноо';

  @override
  String get challengeResume => 'Үргэлжлүүлэх';

  @override
  String get challengeBlockedTitle => 'Камер ашиглах боломжгүй';

  @override
  String get challengeBlockedNote =>
      'Тохиргоо хэсэгт камер, микрофоны зөвшөөрлийг асаана уу.';

  @override
  String get challengeGoBack => 'Буцах';

  @override
  String get challengeOpenSettings => 'Тохиргоог нээх';

  @override
  String get saveDone => 'Галерейд хадгаллаа';

  @override
  String get saveFailed => 'Хадгалж чадсангүй';

  @override
  String get saveDeniedNote => 'Зургийн зөвшөөрөл шаардлагатай';

  @override
  String get callIncomingCallerFallback => 'Beaver багш';

  @override
  String get callIncomingHandle => 'Солонгос хэлний дуудлага';

  @override
  String get callMissedTitle => 'Аваагүй дуудлага';

  @override
  String get callMissedChannelDescription =>
      'Beaver-ийн аваагүй дуудлагыг мэдэгдэнэ.';

  @override
  String callMissedBody(String name) {
    return '$name танд залгасан';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Дуудлага хүлээн авахад мэдэгдлийн зөвшөөрөл шаардлагатай.';

  @override
  String get callNotifPermissionRequired =>
      'Тохиргоо хэсэгт мэдэгдлийг зөвшөөрнө үү.';

  @override
  String get callHintLockedTitle => 'Суралцах горимд зөвлөмж ашиглах боломжгүй';

  @override
  String get wsTitle => 'Хүндрэлтэй авиа';

  @override
  String get wsToList => 'Жагсаалт руу';

  @override
  String get wsNext => 'Дараах';

  @override
  String get wsRetry => 'Дахин оролдох';

  @override
  String get wsDone => 'Болсон';

  @override
  String get wsContinue => 'Үргэлжлүүлэх';

  @override
  String get wsQuit => 'Гарах';

  @override
  String get wsRetryLater => 'Хэсэг хүлээгээд дахин оролдоно уу.';

  @override
  String get wsMissingTitle => 'Тэр авиаг олсонгүй';

  @override
  String get wsMissingBody => 'Жагсаалтаас дахин сонгоно уу.';

  @override
  String get wsListLoadFailed => 'Жагсаалтыг татаж чадсангүй';

  @override
  String get wsLessonLoadFailed => 'Хичээлийг татаж чадсангүй';

  @override
  String get wsNationalTitle => 'Аялгад тохирсон хүндрэлтэй авиа';

  @override
  String get wsNationalPending => 'Аялгын шинжилгээ дуусахад нөхөгдөнө';

  @override
  String get wsNationalPicked => 'Аялгын шинжилгээгээр сонгосон';

  @override
  String get wsNationalEmptyBody =>
      'Хэд хэдэн дуудлага хийвэл аялгыг шинжилж мэдэгдэнэ.';

  @override
  String get wsMineTitle => 'Миний хүндрэлтэй авиа';

  @override
  String get wsMineSubtitle => 'Сүүлийн дуудлагуудад тань хэмжсэн авианууд';

  @override
  String get wsMineEmptyBody =>
      'Дуудлага хийж, давтвал хүндрэлтэй авиа хуримтлагдана.';

  @override
  String get wsNoDataYet => 'Одоогоор дата байхгүй';

  @override
  String get wsGoToCall => 'Дуудлага хийх';

  @override
  String get wsRule => 'Дүрэм';

  @override
  String get wsRecommended => 'Зөвлөмж';

  @override
  String get wsNotMeasured => 'Хэмжээгүй';

  @override
  String get wsStepUnderstand => 'Ойлгох';

  @override
  String get wsStepWords => 'Үг';

  @override
  String get wsStepSentence => 'Өгүүлбэр';

  @override
  String get wsStepTest => 'Шалгалт';

  @override
  String get wsQuitTitle => 'Дадлагыг зогсоох уу?';

  @override
  String get wsQuitBody => 'Одоо гарвал энэ дадлага хадгалагдахгүй.';

  @override
  String get wsHowToSound => 'Авиаг хэрхэн гаргах';

  @override
  String get wsPracticeWords => 'Үг дадлагажих';

  @override
  String get wsPracticeSentence => 'Өгүүлбэр дадлагажих';

  @override
  String get wsPracticeAgain => 'Дахин нэг удаа';

  @override
  String get wsStartTest => 'Төгсгөлийн шалгалт өгөх';

  @override
  String get wsThisSentence => 'Энэ өгүүлбэр';

  @override
  String get wsNoScoreNote => 'Энэ шат оноо авахгүй. Чөлөөтэй дагаж хэлээрэй.';

  @override
  String get wsListen => 'Сайн сонсоорой';

  @override
  String get wsSayNow => 'Одоо дагаж хэлээрэй';

  @override
  String get wsPracticeDone => 'Дадлага дууслаа';

  @override
  String get wsPaused => 'Түр зогслоо';

  @override
  String get wsAudioFailed => 'Аудио татагдсангүй. Бичгийг хараад хэлээрэй.';

  @override
  String get wsReadAloud => 'Доорх өгүүлбэрийг чангаар уншаарай';

  @override
  String get wsTapToStart => 'Эхлэхийн тулд дарна уу';

  @override
  String get wsTapWhenDone => 'Уншиж дуусмагц дарна уу';

  @override
  String get wsScoring => 'Дүгнэж байна';

  @override
  String get wsMicFailed => 'Микрофоныг нээж чадсангүй.';

  @override
  String get wsMicPermissionBody =>
      'Энэ шалгалтыг чангаар уншдаг тул микрофон хэрэгтэй. Тохиргоо хэсгээс микрофоны зөвшөөрлийг асаана уу.';

  @override
  String get wsNoSound => 'Дуу орж ирсэнгүй. Дахин хэлэх үү?';

  @override
  String get wsScoreFailed => 'Дүгнэж чадсангүй. Дахин оролдоно уу.';

  @override
  String get wsSomethingWrong => 'Алдаа гарлаа.';

  @override
  String get wsLearnDone => 'Хичээл дууслаа';

  @override
  String get wsRetest => 'Дахин шалгах';

  @override
  String get wsFirstMeasure => 'Эхний хэмжилт';

  @override
  String get wsFinalTest => 'Төгсгөлийн шалгалт';

  @override
  String wsPoints(int score) {
    return '$score оноо';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Өмнө $score оноо';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Зорилт $score оноо';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Зорилт · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country аялга';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count үг давтлаа';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count хэсэг давтлаа';
  }

  @override
  String get wsStartRecommended => 'Зөвлөсөн авианаас эхлэх';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Эхлэх · $label';
  }

  @override
  String get wsPointsUnit => 'оноо';

  @override
  String get wsEnterFromMypage => 'Хүндрэлтэй авиа дадлагажих';

  @override
  String wsGoalOnly(int score) {
    return 'Зорилт $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label авиа';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Дуудлагад дахин тохиолдвол энэ хэлбэрийг санаарай.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country – хүмүүсийн түгээмэл алддаг авиа';
  }
}
