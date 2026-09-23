// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get loginRequired => 'آپ کو سائن ان کرنا ہوگا۔';

  @override
  String get callWebNotSupported =>
      'ویب پر وائس کال دستیاب نہیں ہے۔ ایپ استعمال کریں۔';

  @override
  String get micPermissionRequiredForCall =>
      'مائیکروفون کی اجازت درکار ہے۔ کال کرنے کے لیے مائیکروفون کی اجازت دیں۔';

  @override
  String get callErrorGeneric => 'کال کے دوران خرابی پیش آئی۔';

  @override
  String get callDailyLimit => 'آج کا سیکھنے کا وقت ختم ہو گیا ہے۔';

  @override
  String get callAlreadyInCall => 'آپ پہلے سے ایک کال پر ہیں۔';

  @override
  String get callNetworkError => 'نیٹ ورک کی خرابی پیش آئی۔';

  @override
  String get authInvalidCredentials => 'ای میل یا پاس ورڈ درست نہیں ہے۔';

  @override
  String get authEmailAlreadyRegistered => 'یہ ای میل پہلے سے رجسٹرڈ ہے۔';

  @override
  String get authConfirmEmailRequired =>
      'اپنے ای میل پر بھیجی گئی تصدیق مکمل کریں۔';

  @override
  String get authResetCodeSent =>
      'ہم نے آپ کے ای میل پر تصدیقی کوڈ بھیج دیا ہے۔';

  @override
  String get authResetCodeInvalid =>
      'کوڈ درست نہیں ہے یا اس کی میعاد ختم ہو چکی ہے۔';

  @override
  String get authPasswordUpdated => 'آپ کا پاس ورڈ ری سیٹ ہو گیا ہے۔';

  @override
  String get authAppleTokenMissing => 'Apple سائن ان ٹوکن حاصل نہیں ہو سکا۔';

  @override
  String callEndedDuration(String duration) {
    return 'کال ختم ہوئی $duration';
  }

  @override
  String get callRatingPrompt => 'آپ کی کال کیسی رہی؟';

  @override
  String get callRatingBody =>
      'آپ کی ریٹنگ اگلی بار بہتر بات چیت میں مدد دیتی ہے۔';

  @override
  String get callRatingSubmit => 'بھیجیں';

  @override
  String get callRatingSkip => 'چھوڑیں';

  @override
  String get ratingBad => 'اچھی نہیں';

  @override
  String get ratingOkay => 'ٹھیک ہے';

  @override
  String get ratingGood => 'اچھی';

  @override
  String get goHome => 'ہوم';

  @override
  String get viewAnalysis => 'تجزیہ دیکھیں';

  @override
  String get loadingShort => 'لوڈ ہو رہا ہے…';

  @override
  String ratingSubmitFailed(String message) {
    return 'درجہ بندی جمع نہیں ہو سکی: $message';
  }

  @override
  String get callInfoNotFound =>
      'کال کی معلومات نہیں ملیں، تجزیہ نظر انداز کیا جا رہا ہے۔';

  @override
  String get tabRecords => 'ریکارڈز';

  @override
  String get tabArchive => 'آرکائیو';

  @override
  String get callHistory => 'کال کی تاریخ';

  @override
  String get conversationRecord => 'گفتگو کا ریکارڈ';

  @override
  String get noCallRecords => 'ابھی تک کوئی کال ریکارڈ نہیں';

  @override
  String get noCallRecordsBody =>
      'AI کے ساتھ اپنی پہلی کال مکمل کرنے کے بعد،\nآپ کے ریکارڈز یہاں دکھائی دیں گے۔';

  @override
  String get startCall => 'کال شروع کریں';

  @override
  String get recordsLoadError => 'ریکارڈز لوڈ نہیں ہو سکے';

  @override
  String get tryAgainLater => 'براہ کرم بعد میں دوبارہ کوشش کریں۔';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes منٹ $seconds سیکنڈ';
  }

  @override
  String get scheduleManagement => 'شیڈول';

  @override
  String get alarms => 'الارمز';

  @override
  String get alarmAdd => 'الارم شامل کریں';

  @override
  String get alarmEdit => 'الارم میں ترمیم';

  @override
  String get alarmEveryDay => 'روزانہ';

  @override
  String get alarmWeekdays => 'ہفتے کے دن';

  @override
  String get alarmWeekend => 'ہفتے کا اختتام';

  @override
  String get alarmNoRepeat => 'دہرایا نہیں جائے گا';

  @override
  String get addSchedule => 'شیڈول شامل کریں';

  @override
  String get editSchedule => 'شیڈول میں ترمیم کریں';

  @override
  String get somethingWentWrong => 'کچھ غلط ہو گیا';

  @override
  String get alarmsLoadError => 'الارمز لوڈ نہیں ہو سکے';

  @override
  String get charactersLoadError => 'کریکٹرز لوڈ نہیں ہو سکے';

  @override
  String get noCharacters => 'کوئی کریکٹر دستیاب نہیں';

  @override
  String get close => 'بند کریں';

  @override
  String get repeat => 'دہرائیں';

  @override
  String get callPartner => 'کریکٹر';

  @override
  String get quickStart => 'فوری آغاز';

  @override
  String get presetMorning => 'صبح کا معمول';

  @override
  String get presetMorningSub => 'کام کے دن 8:00';

  @override
  String get presetEvening => 'شام کا اختتام';

  @override
  String get presetEveningSub => 'روزانہ 21:00';

  @override
  String get presetCustom => 'اپنی مرضی';

  @override
  String get presetCustomSub => 'جیسے چاہیں';

  @override
  String alarmSummary(int count, int monthly) {
    return 'ہفتے میں $count بار · مہینے میں $monthly کالیں';
  }

  @override
  String get alarmSummaryNone => 'کم از کم ایک دن منتخب کریں';

  @override
  String get partnerInUse => 'زیر استعمال';

  @override
  String get partnerOwned => 'آپ کے پاس';

  @override
  String get am => 'صبح';

  @override
  String get pm => 'شام';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get conversation => 'گفتگو';

  @override
  String get newExpressions => 'نئے تاثرات';

  @override
  String get analysisPrepNote => 'آج کی کال کا جائزہ لیا جا رہا ہے۔';

  @override
  String get analysisPrepNoteHint => 'تھوڑی دیر میں یہاں پیغام آئے گا';

  @override
  String get analysisPrepTitle => 'بیور آج کے جملوں سے کارڈ بنا رہا ہے';

  @override
  String get analysisPrepSub => 'تیار ہوتے ہی یہیں نظر آئیں گے۔';

  @override
  String get analysisPrepStepSave => 'گفتگو محفوظ کرنا';

  @override
  String get analysisPrepStepCards => 'جملوں کے کارڈ بنانا';

  @override
  String get analysisPrepStateDone => 'مکمل';

  @override
  String get analysisPrepStateWorking => 'جاری';

  @override
  String get analysisPrepStateWaiting => 'انتظار میں';

  @override
  String get usedExpressions => 'وہ جملے جو آپ نے استعمال کیے';

  @override
  String quizExpressionsCount(int count) {
    return 'اس بار سیکھے گئے تاثرات $count';
  }

  @override
  String get quizPassed => 'درست';

  @override
  String get quizFailed => 'دوبارہ دیکھیں';

  @override
  String get quizPending => 'اگلی بار جاری رکھیں';

  @override
  String get analysisResult => 'تجزیہ کا نتیجہ';

  @override
  String get noNewExpressions => 'اس گفتگو سے کوئی نیا تاثر نہیں ملا۔';

  @override
  String get practice => 'مشق';

  @override
  String recentScore(int score) {
    return 'حالیہ سکور $score%';
  }

  @override
  String callSequence(int count) {
    return '$countویں کال';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name کی طرف سے ایک بات';
  }

  @override
  String characterNoteFooter(String name) {
    return 'کال کے فوراً بعد $name نے چھوڑا';
  }

  @override
  String newExpressionsCount(int count) {
    return 'نئے جملے $count';
  }

  @override
  String get analysisLoadError => 'تجزیہ کا نتیجہ لوڈ نہیں ہو سکا۔';

  @override
  String get standardAudioNotReady => 'معیاری تلفظ کی آڈیو ابھی تیار نہیں ہے۔';

  @override
  String get standardAudioPlayError => 'معیاری تلفظ کی آڈیو چلائی نہیں جا سکی۔';

  @override
  String get selectNativeLanguage => 'اپنی مادری زبان منتخب کریں';

  @override
  String get selectYourLanguage => 'اپنی زبان منتخب کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get selectTime => 'وقت منتخب کریں';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get permissionTitle => 'بہتر تجربے کے لیے\nاجازتیں دیں';

  @override
  String get permissionSubtitle =>
      'سروس استعمال کرنے کے لیے مطلوبہ اجازتیں ضروری ہیں۔';

  @override
  String get permissionMicTitle => 'مائیکروفون (ضروری)';

  @override
  String get permissionMicDesc =>
      'AI کے ساتھ انگریزی میں بات کرنے کے لیے درکار ہے۔';

  @override
  String get permissionNotifTitle => 'اطلاعات (اختیاری)';

  @override
  String get permissionNotifDesc =>
      'ہم آپ کو سیکھنے کی یاد دہانیاں اور کال شیڈول بھیجیں گے۔';

  @override
  String get micPermissionNeededTitle => 'مائیکروفون تک رسائی درکار ہے';

  @override
  String get micPermissionNeededBody =>
      'AI کے ساتھ بات کرنے کے لیے، آپ کو مائیکروفون تک رسائی کی اجازت دینی ہوگی۔ براہ کرم اسے سیٹنگز میں فعال کریں۔';

  @override
  String get openSettings => 'سیٹنگز کھولیں';

  @override
  String get connectionFailedTitle => 'رابطہ ناکام ہو گیا';

  @override
  String get connectionFailedBody =>
      'اپنا نیٹ ورک کنکشن چیک کریں\nاور دوبارہ کوشش کریں۔';

  @override
  String get checkout => 'چیک آؤٹ';

  @override
  String get pay => 'ادائیگی کریں';

  @override
  String get orderSummary => 'آرڈر کا خلاصہ';

  @override
  String get paymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get payMethodCard => 'کریڈٹ / ڈیبٹ کارڈ';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'تنگ کرنے والا بیور اوتار';

  @override
  String get productTrait => 'پریمیم کریکٹر · ہمیشہ کے لیے آپ کا';

  @override
  String get amountItemPrice => 'آئٹم کی قیمت';

  @override
  String get amountDiscount => 'رعایت';

  @override
  String get amountTotal => 'کل رقم';

  @override
  String get paymentCompleteTitle => 'ادائیگی مکمل';

  @override
  String get paymentCompleteBody =>
      'اوتار آپ کے مجموعے میں شامل کر دیا گیا ہے۔';

  @override
  String get viewCollection => 'مجموعہ دیکھیں';

  @override
  String get receiptItem => 'آئٹم';

  @override
  String get receiptAmount => 'رقم';

  @override
  String get receiptMethod => 'ادائیگی کا طریقہ';

  @override
  String get receiptDate => 'تاریخ';

  @override
  String get paymentFailedTitle => 'ادائیگی ناکام ہو گئی';

  @override
  String get paymentFailedBody =>
      'آپ کی ادائیگی پر کارروائی نہیں ہو سکی۔\nبراہ کرم دوبارہ کوشش کریں۔';

  @override
  String get freeCallEndingTitle => 'آپ کی مفت کال ختم ہونے والی ہے';

  @override
  String get freeCallEndingBody =>
      'بیور سے زیادہ دیر بات کرنے کے لیے سبسکرائب کریں۔';

  @override
  String get subscribe => 'سبسکرائب کریں';

  @override
  String get endCall => 'کال ختم کریں';

  @override
  String get callEnded => 'کال ختم ہو گئی ہے۔';

  @override
  String get connecting => 'رابطہ قائم ہو رہا ہے…';

  @override
  String get connectingHint => 'اس میں عام طور پر 5 سیکنڈ سے کم وقت لگتا ہے';

  @override
  String get callConnectFailed => 'کال کا رابطہ قائم نہیں ہو سکا۔';

  @override
  String get saveSentenceFailed => 'جملہ محفوظ نہیں ہو سکا۔';

  @override
  String get recordStartFailed => 'ریکارڈنگ شروع نہیں ہو سکی۔';

  @override
  String get recordTooShort =>
      'یہ ریکارڈنگ بہت مختصر تھی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get gradingFailed => 'سکورنگ ناکام ہو گئی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get listenStandard => 'معیاری تلفظ سنیں';

  @override
  String get saveSentence => 'جملہ محفوظ کریں';

  @override
  String get unsaveSentence => 'محفوظ شدہ جملہ ہٹائیں';

  @override
  String get scoringPronunciation => 'آپ کے تلفظ کا اسکور لگایا جا رہا ہے…';

  @override
  String get analyzingByWord => 'آپ کا تلفظ لفظ بہ لفظ جانچا جا رہا ہے';

  @override
  String get analyzingTakingLonger => 'اس میں کچھ زیادہ وقت لگ رہا ہے';

  @override
  String get scanConnectionLost => 'کنکشن منقطع ہو گیا';

  @override
  String get noRecordingToPlay => 'چلانے کے لیے کوئی ریکارڈنگ نہیں ہے۔';

  @override
  String get myRecordingPlayError => 'آپ کی ریکارڈنگ چلائی نہیں جا سکی۔';

  @override
  String get next => 'اگلا';

  @override
  String get endLearning => 'سیشن ختم کریں';

  @override
  String get navCalendar => 'کیلنڈر';

  @override
  String get navCall => 'کال';

  @override
  String get navStats => 'اعداد و شمار';

  @override
  String get homeCourseExpression => 'اظہار';

  @override
  String get homeCourseFreetalk => 'گفتگو';

  @override
  String homeExpressionsLeft(int count) {
    return 'گفتگو تک $count اظہار باقی';
  }

  @override
  String get homeFreetalkNote =>
      'جو سیکھا ہے اسے استعمال کرکے آزادانہ بات کریں';

  @override
  String get homeTalkTitle => 'آج کیا ہوا؟';

  @override
  String get homeTalkNote => 'آزادی سے بات کریں اور بات کرتے ہوئے سیکھیں۔';

  @override
  String get homeModeLearn => 'سیکھیں';

  @override
  String get homeModeTalk => 'بات چیت';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لگاتار $count دن',
      one: 'لگاتار 1 دن',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'سیکھنے کا کیلنڈر';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'دن لگاتار',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بہترین ریکارڈ $count دن',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'کال کا وقت';

  @override
  String get streakMetricLearned => 'سیکھے گئے جملے';

  @override
  String get streakMetricWords => 'بولے گئے الفاظ';

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
      other: '$count منٹ',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'اس دن کوئی کال نہیں ہوئی۔';

  @override
  String get homeLevelPending => 'لیول طے نہیں';

  @override
  String get homeNoLevelTitle => 'آپ کا لیول ابھی نہیں ہے';

  @override
  String get homeNoLevelNote => 'پہلی کال مکمل کریں تو لیول مل جائے گا';

  @override
  String get homeCurriculumPendingBadge => 'جلد آ رہا ہے';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language کا نصاب تیار ہو رہا ہے';
  }

  @override
  String get homeCurriculumPendingNote =>
      'کالز میں آپ عام تاثرات کی مشق کریں گے';

  @override
  String get myPage => 'میرا صفحہ';

  @override
  String get languageSaveFailed => 'آپ کی زبان محفوظ نہیں ہو سکی۔';

  @override
  String get accountDeleteFailed => 'آپ کا اکاؤنٹ حذف نہیں ہو سکا۔';

  @override
  String get changeAvatar => 'اوتار تبدیل کریں';

  @override
  String get avatarUseNow => 'ابھی استعمال کریں';

  @override
  String get avatarPurchaseFailed => 'خریداری مکمل نہیں ہوئی';

  @override
  String avatarPromoTitle(int percent) {
    return 'صرف آج · $percent% رعایت';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time باقی';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days دن $time باقی';
  }

  @override
  String get avatarIntro =>
      'آواز اور مشکل کی سطح کال پارٹنر کے مطابق مختلف ہوتی ہے۔\nکچھ پارٹنرز کے لیے ادائیگی درکار ہو سکتی ہے۔';

  @override
  String myPartnersOwned(int count) {
    return 'میرے پارٹنرز · $count کے مالک';
  }

  @override
  String get limitedDiscount => 'محدود مدت کی رعایت';

  @override
  String get available => 'دستیاب';

  @override
  String get inUse => 'زیر استعمال';

  @override
  String get owned => 'ملکیت میں';

  @override
  String get noCharactersToShow => 'دکھانے کے لیے کوئی کریکٹر نہیں';

  @override
  String get buy => 'خریدیں';

  @override
  String get noSavedSentences =>
      'ابھی تک کوئی جملہ محفوظ نہیں کیا گیا۔\nاپنی گفتگو کے ریکارڈز سے جملوں کو بک مارک کریں۔';

  @override
  String get noAlarms => 'ابھی تک کوئی الارم نہیں';

  @override
  String get noAlarmsBody =>
      'مستقل عادت بنانے کے لیے\nسیکھنے کی یاد دہانی شامل کریں۔';

  @override
  String get subscriptionManage => 'سبسکرپشن کا انتظام کریں';

  @override
  String get cancelSubscription => 'سبسکرپشن منسوخ کریں';

  @override
  String get benefitsInUse => 'آپ کے فوائد';

  @override
  String get paymentInfo => 'ادائیگی کی معلومات';

  @override
  String get nextBillingDate => 'اگلی بلنگ کی تاریخ';

  @override
  String get lostBenefitsTitle => 'منسوخ کرنے پر آپ یہ فوائد کھو دیں گے';

  @override
  String get viewBillingHistory => 'بلنگ ہسٹری دیکھیں';

  @override
  String pricePerMonth(String price) {
    return '$price / ماہ';
  }

  @override
  String get benefitDetailedAnalysis => 'تلفظ اور گرامر کا تفصیلی تجزیہ';

  @override
  String get benefitAllCharacters => 'تمام کریکٹرز تک رسائی';

  @override
  String get benefitNoAds => 'کوئی اشتہارات نہیں';

  @override
  String get playSampleVoice => 'نمونہ آواز چلائیں';

  @override
  String get useThisAvatar => 'یہ استعمال کریں';

  @override
  String get challengeTitle => 'تلفظ چیلنج';

  @override
  String get challengeIntro =>
      'زون میں موجود ہر کارڈ کو کلیئر کرنے کے لیے اسے صحیح کوریائی تلفظ میں ادا کریں۔\nمائیک نہیں ہے؟ آپ اسکرین پر ٹیپ کر کے بھی کھیل سکتے ہیں۔';

  @override
  String get challengeStart => 'کیمرہ اور مائیک شروع کریں';

  @override
  String get challengePermissionNote =>
      'فرنٹ کیمرہ اور مائیک تک رسائی درکار ہے (اختیاری)۔';

  @override
  String get challengeLoadingTitle => 'لوڈ ہو رہا ہے…';

  @override
  String get challengeLoadingNote =>
      'کیمرہ اور مائیکروفون تیار کیے جا رہے ہیں۔';

  @override
  String get challengeSttFallback =>
      'اسپیچ ریکگنیشن دستیاب نہیں تھی، اس لیے آپ نے ٹیپ ان پٹ سے کھیلا۔';

  @override
  String get reasonTravelTitle => 'سفر کے دوران بات چیت';

  @override
  String get reasonTravelDesc => 'مقامی لوگوں سے اعتماد کے ساتھ بات کریں';

  @override
  String get reasonCareerTitle => 'کام اور کیریئر';

  @override
  String get reasonCareerDesc => 'کاروباری گفتگو';

  @override
  String get reasonExamTitle => 'امتحان کی تیاری';

  @override
  String get reasonExamDesc => 'اسپیکنگ ٹیسٹ کی تیاری کریں';

  @override
  String get reasonDailyTitle => 'روزمرہ کی گفتگو';

  @override
  String get reasonDailyDesc => 'وہ تاثرات جو آپ روزانہ استعمال کرتے ہیں';

  @override
  String get reasonFriendsTitle => 'غیر ملکی دوست بنانا';

  @override
  String get reasonFriendsDesc => 'قدرتی گفتگو';

  @override
  String get reasonBrainTitle => 'ذہنی تحریک';

  @override
  String get reasonBrainDesc => 'یادداشت اور توجہ بڑھائیں';

  @override
  String get challengeRecordToggle => 'اس راؤنڈ کو ریکارڈ کریں';

  @override
  String get challengeRecordHint =>
      'شیئر کرنے کے لیے آپ کے گیم پلے کی ویڈیو محفوظ کرتا ہے (خاموش)۔';

  @override
  String get settingsSection => 'سیٹنگز';

  @override
  String get paymentSection => 'ادائیگی';

  @override
  String get supportSection => 'معاونت';

  @override
  String get userLanguage => 'صارف کی زبان';

  @override
  String get learningLanguage => 'سیکھنے کی زبان';

  @override
  String get learningLanguageKorean => 'کورین';

  @override
  String get notificationLabel => 'اطلاع';

  @override
  String get currentPlan => 'موجودہ پلان';

  @override
  String get paymentHistory => 'ادائیگی کی تاریخ';

  @override
  String get contactUs => 'ہم سے رابطہ کریں';

  @override
  String get termsOfService => 'سروس کی شرائط';

  @override
  String get privacyPolicy => 'پرائیویسی پالیسی';

  @override
  String get logOut => 'لاگ آؤٹ';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteAccountTitle => 'اکاؤنٹ حذف کریں؟';

  @override
  String get deleteAccountBody =>
      'یہ آپ کے اکاؤنٹ اور ڈیٹا کو مستقل طور پر حذف کر دیتا ہے اور اسے واپس نہیں لایا جا سکتا۔';

  @override
  String get delete => 'حذف کریں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get accentSoundsLike => 'آپ کا کورین لہجہ ایسا لگتا ہے';

  @override
  String get hintLabel => 'اشارہ';

  @override
  String get nextHint => 'اگلا اشارہ';

  @override
  String get translateLabel => 'ترجمہ کریں';

  @override
  String get startRecording => 'ریکارڈنگ شروع کریں';

  @override
  String get stopRecording => 'ریکارڈنگ روکیں';

  @override
  String get back => 'واپس';

  @override
  String get onboardingNameTitle => 'ہم آپ کو کیا کہہ کر بلائیں؟';

  @override
  String get onboardingNameSubtitle => 'آپ کا AI ٹیوٹر آپ کا نام یاد رکھے گا۔';

  @override
  String get nameLabel => 'آپ کا نام';

  @override
  String get nameHint => 'اپنا نام درج کریں';

  @override
  String get nameHelper =>
      'یہ آپ کا اصل نام ہونا ضروری نہیں — عرفی نام بھی چل جائے گا۔';

  @override
  String get continueLabel => 'جاری رکھیں';

  @override
  String get onboardingDoneTitle => 'بیور آپ کی کال کا منتظر ہے';

  @override
  String get onboardingDoneSubtitle => 'ابھی کال شروع کریں';

  @override
  String get home => 'ہوم';

  @override
  String get callNow => 'ابھی کال کریں';

  @override
  String get pronunciation => 'تلفظ';

  @override
  String get fluency => 'روانی';

  @override
  String get rhythm => 'تال';

  @override
  String get analysisFailed =>
      'ہم گفتگو کا تجزیہ نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get analyzingConversation => 'آپ کی گفتگو کا تجزیہ کیا جا رہا ہے…';

  @override
  String get analyzingSubtitle => 'اس میں صرف تھوڑا سا وقت لگے گا';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get nativeLabel => 'مقامی';

  @override
  String get meLabel => 'میں';

  @override
  String get pronunciationPlayError => 'تلفظ کی آڈیو چلائی نہیں جا سکی۔';

  @override
  String get savedExpressionsLoadError =>
      'آپ کے محفوظ شدہ تاثرات لوڈ نہیں ہو سکے۔';

  @override
  String get mySavedExpressions => 'میرے محفوظ شدہ تاثرات';

  @override
  String get avatarTraits => 'پرتپاک · پرسکون · نرم';

  @override
  String get priceFree => 'مفت';

  @override
  String get loginGoogleTokenError => 'گوگل سائن ان ٹوکن حاصل نہیں ہو سکا۔';

  @override
  String get loginGoogleSignInFailed => 'گوگل سائن ان ناکام ہو گیا۔';

  @override
  String get loginAppleSignInFailed => 'Apple سائن ان ناکام ہو گیا۔';

  @override
  String get loginFacebookSignInFailed => 'Facebook سائن ان ناکام ہو گیا۔';

  @override
  String get loginKakaoSignInFailed => 'Kakao سائن ان ناکام ہو گیا۔';

  @override
  String get loginContinueWithKakao => 'Kakao کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithFacebook => 'Facebook کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithApple => 'Apple کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithEmail => 'ای میل کے ساتھ جاری رکھیں';

  @override
  String get loginOrDivider => 'یا';

  @override
  String get loginNoAccount => 'اکاؤنٹ نہیں ہے؟';

  @override
  String get signUp => 'سائن اپ کریں';

  @override
  String get loginTermsNoticePrefix => 'جاری رکھ کر، آپ ہماری ';

  @override
  String get loginTermsNoticeAnd => ' اور ';

  @override
  String get loginTermsNoticeSuffix => ' سے اتفاق کرتے ہیں۔';

  @override
  String get loginLogIn => 'لاگ ان';

  @override
  String get fieldEmailLabel => 'ای میل';

  @override
  String get emailHint => 'اپنا ای میل درج کریں';

  @override
  String get fieldPasswordLabel => 'پاس ورڈ';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get loginRememberMe => 'مجھے یاد رکھیں';

  @override
  String get loginForgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get loginLoggingIn => 'لاگ ان ہو رہا ہے...';

  @override
  String get passwordLengthError => 'پاس ورڈ 8 سے 16 حروف کا ہونا چاہیے۔';

  @override
  String get passwordsDoNotMatch => 'پاس ورڈز مماثل نہیں ہیں۔';

  @override
  String get signupCheckInput => 'براہ کرم اپنی معلومات چیک کریں۔';

  @override
  String get fieldConfirmPasswordLabel => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get confirmPasswordHint => 'اپنا پاس ورڈ دوبارہ درج کریں';

  @override
  String get signupSigningUp => 'سائن اپ ہو رہا ہے...';

  @override
  String get signupHaveAccount => 'پہلے سے اکاؤنٹ ہے؟';

  @override
  String get passwordMethodEmailRequired => 'اپنا ای میل درج کریں';

  @override
  String get passwordResetTitle => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get passwordMethodDescription =>
      'وہ ای میل ایڈریس درج کریں جہاں آپ پاس ورڈ ری سیٹ کوڈ وصول کرنا چاہتے ہیں۔';

  @override
  String get emailAddressHint => 'ای میل ایڈریس';

  @override
  String get passwordMethodSending => 'بھیجا جا رہا ہے...';

  @override
  String get passwordMethodSendEmail => 'ای میل بھیجیں';

  @override
  String get passwordCodeTitle => 'کوڈ درج کریں';

  @override
  String get passwordCodeDescription =>
      'ہم نے آپ کے ای میل پر ایک ریکوری کوڈ بھیجا ہے۔ جاری رکھنے کے لیے اسے درج کریں۔';

  @override
  String get passwordCodeNoCode => 'کوڈ موصول نہیں ہوا؟';

  @override
  String get passwordCodeResend => 'کوڈ دوبارہ بھیجیں';

  @override
  String get passwordCodeVerifying => 'تصدیق ہو رہی ہے...';

  @override
  String get passwordNewTitle => 'نیا پاس ورڈ';

  @override
  String get passwordNewDescription =>
      'اپنے اکاؤنٹ کے لیے نیا پاس ورڈ سیٹ کریں۔';

  @override
  String get fieldNewPasswordLabel => 'نیا پاس ورڈ';

  @override
  String get newPasswordHint => 'اپنا نیا پاس ورڈ درج کریں';

  @override
  String get fieldConfirmNewPasswordLabel => 'نئے پاس ورڈ کی تصدیق کریں';

  @override
  String get confirmNewPasswordHint => 'اپنا نیا پاس ورڈ دوبارہ درج کریں';

  @override
  String get passwordNewSubmitting => 'جمع کرایا جا رہا ہے...';

  @override
  String get passwordNewSubmit => 'جمع کرائیں';

  @override
  String get passwordCompleteTitle => 'پاس ورڈ ری سیٹ مکمل';

  @override
  String get passwordCompleteBody =>
      'آپ کا پاس ورڈ ری سیٹ ہو چکا ہے۔ جاری رکھنے کے لیے اپنے نئے پاس ورڈ سے لاگ ان کریں۔';

  @override
  String get termsTitle => 'سروس کی شرائط';

  @override
  String get privacyTitle => 'پرائیویسی پالیسی';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email کے لیے نیا پاس ورڈ سیٹ کریں۔';
  }

  @override
  String get selectComplete => 'ہو گیا';

  @override
  String get onboardingLanguageTitle => 'آپ کی مادری زبان کیا ہے؟';

  @override
  String get onboardingReasonTitle => 'آپ زبان کیوں سیکھ رہے ہیں؟';

  @override
  String get onboardingReasonSubtitle =>
      'ہم آپ کے مقاصد کے مطابق آپ کی تعلیم کو ڈھالیں گے۔';

  @override
  String get savingLabel => 'محفوظ ہو رہا ہے...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'اس ماہ کی ادائیگی';

  @override
  String get filterAll => 'سب';

  @override
  String get filterSubscription => 'سبسکرپشن';

  @override
  String get filterCharacter => 'کردار';

  @override
  String get statusCompleted => 'مکمل';

  @override
  String get lastPayment => 'آخری ادائیگی';

  @override
  String get freePlanCallLimit => 'روزانہ 1 کال · 5 منٹ کی حد';

  @override
  String get freePlanBasicCharacters => 'بنیادی کردار شامل';

  @override
  String get availableForPurchase => 'خریداری کے لیے دستیاب';

  @override
  String get paymentsLoadError => 'ادائیگی کی تاریخ لوڈ نہیں ہو سکی';

  @override
  String get noPayments => 'ابھی کوئی ادائیگی نہیں';

  @override
  String get morePaymentsExist => 'پرانی ادائیگیاں ابھی نہیں دکھائی گئیں';

  @override
  String get undatedPayments => 'بغیر تاریخ';

  @override
  String get paymentLabelFallback => 'ادائیگی';

  @override
  String learningPassed(int passed, int total) {
    return '$total میں سے $passed جملے کامیاب';
  }

  @override
  String get hardestSound => 'آج کی سب سے مشکل آواز';

  @override
  String get soundAccuracy => 'آواز کے لحاظ سے درستگی';

  @override
  String phonemeAttempts(int count) {
    return 'فی صوتیہ · $count کوششیں';
  }

  @override
  String get colSound => 'آواز';

  @override
  String get colAttempts => 'کوشش';

  @override
  String get colCorrect => 'درست';

  @override
  String get colAccuracy => 'درستگی';

  @override
  String get sentenceResults => 'جملے کے لحاظ سے نتائج';

  @override
  String viewAllSentences(int count) {
    return 'تمام $count دیکھیں';
  }

  @override
  String get colSentence => 'جملہ';

  @override
  String get colPronunciation => 'تلفظ';

  @override
  String get colFluency => 'روانی';

  @override
  String get colRhythm => 'تال';

  @override
  String recentSessions(int count) {
    return 'آخری $count سیشن';
  }

  @override
  String trendAverage(int score) {
    return 'اوسط $score';
  }

  @override
  String get today => 'آج';

  @override
  String get colDate => 'تاریخ';

  @override
  String get colSentences => 'جملے';

  @override
  String get colScore => 'اسکور';

  @override
  String get colChange => 'تبدیلی';

  @override
  String dateToday(String date) {
    return '$date (آج)';
  }

  @override
  String get accentAnalysis => 'لہجے کا تجزیہ';

  @override
  String get overallLevel => 'مجموعی سطح';

  @override
  String get overallLevelSubtitle => 'الفاظ · گرامر · اظہار';

  @override
  String get pronunciationAnalysis => 'تلفظ کا تجزیہ';

  @override
  String get recentSessionsAverage => 'پچھلے 10 سیشنز کا اوسط';

  @override
  String levelStage(int stage) {
    return 'سطح $stage';
  }

  @override
  String topPercent(int percent) {
    return 'ٹاپ $percent%';
  }

  @override
  String get allLearnersBasis => 'تمام سیکھنے والوں میں';

  @override
  String aheadOfLearners(int percent) {
    return 'آپ $percent% سیکھنے والوں سے آگے ہیں';
  }

  @override
  String get retakeLevelTest => 'لیول ٹیسٹ دوبارہ دیں';

  @override
  String get practicePronunciation => 'تلفظ کی مشق کریں';

  @override
  String get priceChangedTitle => 'قیمت تبدیل ہو گئی';

  @override
  String priceChangedBody(String price) {
    return 'اس آئٹم کی قیمت اب $price ہے۔ کیا جاری رکھیں؟';
  }

  @override
  String get billingGroupPlanPurchases => 'پلان اور خریداریاں';

  @override
  String get billingGroupInTheStore => 'اسٹور میں';

  @override
  String get billingCompareAllPlans => 'پلانز کا موازنہ کریں';

  @override
  String get billingBuyACharacter => 'کردار خریدیں';

  @override
  String get billingRestorePurchases => 'خریداریاں بحال کریں';

  @override
  String get billingRedeemCode => 'کوڈ استعمال کریں';

  @override
  String get billingPaymentHistory => 'ادائیگی کی تاریخ';

  @override
  String get billingManageInTheStore => 'اسٹور میں منظم کریں';

  @override
  String get billingRefundHelp => 'رقم کی واپسی میں مدد';

  @override
  String get billingCancelSubscription => 'سبسکرپشن منسوخ کریں';

  @override
  String get billingResubscribe => 'دوبارہ سبسکرائب کریں';

  @override
  String get badgeCurrent => 'موجودہ';

  @override
  String get badgeTrial => 'ٹرائل';

  @override
  String get badgeRenewing => 'تجدید جاری';

  @override
  String get badgePastDue => 'ادائیگی باقی';

  @override
  String get badgePaused => 'موقوف';

  @override
  String get badgeCanceling => 'منسوخی جاری';

  @override
  String get subscriptionTitle => 'سبسکرپشن';

  @override
  String get plansTitle => 'پلانز';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'روزانہ 3 ویڈیو کالز تک، ہر کال 15 منٹ';

  @override
  String get premiumBulletAnalysis => 'مکمل تلفظ کا تجزیہ';

  @override
  String get premiumBulletWeakSounds => 'آپ کی زبان کے لیے کمزور آوازوں کی مشق';

  @override
  String get noteCharactersSeparate =>
      'کردار الگ سے فروخت ہوتے ہیں۔ خریدے گئے کردار آپ کے ہی رہتے ہیں۔';

  @override
  String get ctaGetPremium => 'Premium حاصل کریں';

  @override
  String get planMaxTrial => 'Premium ٹرائل';

  @override
  String get freePlanPriceLine => '\$0.00 — روزانہ ایک کال';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount ماہانہ';
  }

  @override
  String freeUntilDate(String date) {
    return '$date تک مفت';
  }

  @override
  String get todaysCalls => 'آج کی کالیں';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit میں سے $used استعمال ہوئیں';
  }

  @override
  String get firstPaymentLabel => 'پہلی ادائیگی';

  @override
  String get nextPaymentLabel => 'اگلی ادائیگی';

  @override
  String get retryingUntilLabel => 'دوبارہ کوشش جاری رہے گی';

  @override
  String get pausedSinceLabel => 'موقوف از';

  @override
  String planEndsLabel(String plan) {
    return '$plan ختم ہوگا';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium کے ساتھ آمنے سامنے بات کریں';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'ویڈیو کالز · روزانہ 3 تک · $price ماہانہ';
  }

  @override
  String get bannerAnnualSwitchTitle => 'سالانہ پلان پر جائیں';

  @override
  String get bannerPaymentFailedTitle => 'ہم ادائیگی وصول نہیں کر سکے';

  @override
  String get bannerPaymentFailedSub =>
      'Premium برقرار رکھنے کے لیے اسٹور میں ادائیگی اپ ڈیٹ کریں';

  @override
  String get bannerPausedTitle => 'آپ کا پلان موقوف ہے';

  @override
  String get bannerPausedSub => 'ادائیگی مکمل نہیں ہو سکی';

  @override
  String get noteRestoreHint =>
      'کسی اور ڈیوائس پر پہلے سے سبسکرائب ہیں؟ بحالی اسے اس ڈیوائس پر واپس لے آتی ہے۔';

  @override
  String get noteStoreHandled =>
      'ادائیگی کا طریقہ، پلان کی تبدیلی اور منسوخی اسٹور کے ذریعے ہوتی ہے۔';

  @override
  String noteTrialEnds(String date) {
    return 'آپ کا ٹرائل $date کو ختم ہوگا۔ اس سے پہلے اسٹور میں منسوخ کریں تو کچھ بھی چارج نہیں ہوگا۔';
  }

  @override
  String get noteGrace =>
      'رعایتی مدت کے دوران آپ کی سہولتیں جاری رہتی ہیں۔ منسوخی کبھی ایپ میں نہیں روکی جاتی۔';

  @override
  String get noteHold =>
      'ادائیگی مکمل ہونے تک Premium موقوف ہے۔ آپ کے کردار اور پیش رفت محفوظ ہیں۔';

  @override
  String noteEnding(String date) {
    return 'آپ کا پلان ختم ہونے والا ہے۔ سہولتیں $date تک جاری رہیں گی، پھر آپ Free پر چلے جائیں گے۔ آپ کسی بھی وقت دوبارہ سبسکرائب کر سکتے ہیں۔';
  }

  @override
  String get trialExpiredTitle => 'آپ کا Premium ٹرائل ختم ہو گیا';

  @override
  String get trialExpiredSub => 'اب آپ Free پر ہیں';

  @override
  String get seePlans => 'پلانز دیکھیں';

  @override
  String get currentPlanTitle => 'موجودہ پلان';

  @override
  String get perMonthUnit => 'ماہانہ';

  @override
  String get planTaglineMax => 'اب آپ انہیں دیکھ سکتے ہیں۔';

  @override
  String get planTaglineFree => 'روزانہ ایک کال۔ بالکل مفت۔';

  @override
  String get bulletProCorrections => 'آپ کی مادری زبان کے مطابق اصلاحات';

  @override
  String get bulletFreeCall => 'روزانہ ایک 5 منٹ کی وائس کال';

  @override
  String get bulletFreeCheck => 'پہلی 3 کالز کا مکمل تجزیہ';

  @override
  String get bulletFreeCharacter => 'شروع کے لیے 2 کردار';

  @override
  String get ctaTurnOnVideo => 'ویڈیو آن کریں';

  @override
  String get noteCallLength => 'Premium: روزانہ 3 کالز تک، ہر کال 15 منٹ۔';

  @override
  String get paywallProTitle1 => 'آپ کا کورین دوست';

  @override
  String get paywallProTitle2 => 'جو رات 3 بجے بھی جاگ رہا ہے';

  @override
  String get paywallLimitHeadline => 'Premium میں روزانہ 3 کالز تک۔';

  @override
  String get limitBannerCallTitle => 'آج کی کال یہی تھی';

  @override
  String get limitBannerCallSub => 'Free میں روزانہ ایک کال ملتی ہے';

  @override
  String get limitBannerCheckTitle => 'آج کا چیک یہی تھا';

  @override
  String get limitBannerCheckSub => 'Free میں روزانہ ایک چیک ملتا ہے';

  @override
  String get bulletProCharactersForever =>
      'خریدے گئے کردار ہمیشہ آپ کے رہتے ہیں';

  @override
  String get paywallMaxTitle => 'اب آپ انہیں دیکھ سکتے ہیں۔';

  @override
  String paywallTutorCompare(String price) {
    return 'ٹیوٹر کے ساتھ ایک گھنٹے کی قیمت \$25 ہے۔ Premium کے ایک مہینے کی قیمت $price ہے۔';
  }

  @override
  String get planMonthly => 'ماہانہ';

  @override
  String get planAnnual => 'سالانہ';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price ماہانہ';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth ماہانہ';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price ماہانہ';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly سالانہ · $perMonth ماہانہ';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price ماہانہ · اسٹور میں کسی بھی وقت منسوخ کریں';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price ماہانہ · اسٹور میں کسی بھی وقت منسوخ کریں';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 دن مفت، پھر $price ماہانہ · اسٹور میں کسی بھی وقت منسوخ کریں';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'منسوخ کرنے تک خودکار طور پر تجدید ہوتا ہے۔';

  @override
  String get footerTerms => 'شرائط';

  @override
  String get footerPrivacy => 'رازداری';

  @override
  String get processingTitle => 'آپ کی خریداری کی تصدیق ہو رہی ہے';

  @override
  String get processingSub => 'اس میں عام طور پر چند سیکنڈ لگتے ہیں۔';

  @override
  String get successProTitle => 'آپ Premium پر ہیں۔';

  @override
  String get successMaxTitle => 'اب آپ انہیں دیکھ سکتے ہیں۔';

  @override
  String get successMaxSub =>
      'ویڈیو کالیں آن ہیں۔ کسی بھی کال میں ویڈیو بٹن دبائیں۔';

  @override
  String get ctaStartAVideoCall => 'ویڈیو کال شروع کریں';

  @override
  String get ctaSeeYourSubscription => 'اپنی سبسکرپشن دیکھیں';

  @override
  String successMaxCaption(String price) {
    return 'منسوخی تک ہر ماہ $price چارج ہوگا۔ اسٹور میں کسی بھی وقت منظم یا منسوخ کریں۔';
  }

  @override
  String get plansErrorTitle => 'ہم پلانز لوڈ نہیں کر سکے';

  @override
  String get plansErrorSub => 'اسٹور نے جواب نہیں دیا۔';

  @override
  String get ctaTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get plansErrorCaption => 'کچھ بھی چارج نہیں ہوا۔';

  @override
  String get ctaKeepMax => 'Premium رکھیں';

  @override
  String get winbackSkip => 'چھوڑیں';

  @override
  String get winbackTitle => 'آپ کا Premium پلان ختم ہو گیا';

  @override
  String get winbackSub => 'اب آپ Free پر ہیں — روزانہ ایک کال۔';

  @override
  String get winbackQuestion => 'بتائیں گے کہ آپ نے کیوں چھوڑا؟';

  @override
  String get winbackReasonExpensive => 'بہت مہنگا ہے';

  @override
  String get winbackReasonUnused => 'میں اتنا استعمال نہیں کر رہا تھا';

  @override
  String get winbackReasonMissing => 'مجھے درکار فیچر موجود نہیں تھا';

  @override
  String get winbackReasonOtherApp => 'مجھے دوسری ایپ مل گئی';

  @override
  String get winbackReasonElse => 'کچھ اور';

  @override
  String get ctaSend => 'بھیجیں';

  @override
  String get ctaNotNow => 'ابھی نہیں';

  @override
  String get winbackCaption =>
      'اس سے آپ کا پلان بحال نہیں ہوتا۔ اسٹور میں دوبارہ سبسکرائب کریں۔';

  @override
  String get ctaContinue => 'جاری رکھیں';

  @override
  String get ctaClose => 'بند کریں';

  @override
  String get ovRestoreSuccessTitle => 'Premium واپس آ گیا';

  @override
  String get ovRestoreSuccessBody =>
      'ہمیں آپ کی سبسکرپشن مل گئی اور اس ڈیوائس پر دوبارہ فعال کر دی گئی۔';

  @override
  String get ovRestoreEmptyTitle => 'بحال کرنے کو کچھ نہیں';

  @override
  String get ovRestoreEmptyBody =>
      'اس اسٹور اکاؤنٹ سے کوئی فعال سبسکرپشن منسلک نہیں ہے۔';

  @override
  String get ovRestoreOtherTitle => 'یہ پلان کسی اور اکاؤنٹ کا ہے';

  @override
  String get ovRestoreOtherBody =>
      'یہ سبسکرپشن پہلے ہی ایک مختلف BeaverTalk اکاؤنٹ پر فعال ہے۔';

  @override
  String get ctaSignInThatAccount => 'اس اکاؤنٹ میں سائن ان کریں';

  @override
  String get ctaGetHelp => 'مدد حاصل کریں';

  @override
  String get ovCharacterOfferTitle => 'Premium کے لیے تیار نہیں؟';

  @override
  String get ovCharacterOfferBody =>
      'ایک کردار چنیں اور اپنا بنا لیں۔ یکمشت خریداری — نہ سبسکرپشن، نہ تجدید۔';

  @override
  String get rowOneCharacter => 'ایک کردار';

  @override
  String rowFromPrice(String price) {
    return 'ہر ایک $price';
  }

  @override
  String get rowYoursForever => 'ہمیشہ آپ کا';

  @override
  String get rowNoRenewal => 'کوئی تجدید نہیں';

  @override
  String get rowWorksOnFree => 'Free پر چلتا ہے';

  @override
  String get rowYes => 'ہاں';

  @override
  String get ctaSeeCharacters => 'کردار دیکھیں';

  @override
  String get ovNotEligibleTitle => 'منسوخ کرنے کو کچھ نہیں';

  @override
  String get ovNotEligibleBody =>
      'آپ Free پر ہیں۔ اس اکاؤنٹ پر کوئی فعال سبسکرپشن نہیں ہے۔';

  @override
  String get ovCancelDownsellTitle => 'جانے سے پہلے';

  @override
  String get ovCancelDownsellBody =>
      'منسوخی اسٹور میں ہوتی ہے۔ دو باتیں جاننا مفید ہے۔';

  @override
  String get rowPayYearlyInstead => 'اس کے بجائے سالانہ ادا کریں';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price ماہانہ';
  }

  @override
  String get rowCharactersYouBought => 'آپ کے خریدے ہوئے کردار';

  @override
  String get rowProRunsUntil => 'Premium جاری رہے گا';

  @override
  String get ctaSwitchToYearly => 'سالانہ پر سوئچ کریں';

  @override
  String get ctaContinueToStore => 'اسٹور پر جائیں';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'سالانہ ادا کریں، $saved بچائیں';
  }

  @override
  String get ovAnnualSwitchBody =>
      'سالانہ پلان ماہانہ ادائیگی سے سستا پڑتا ہے۔';

  @override
  String get rowYouSave => 'آپ کی بچت';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'سالانہ';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'ایک سال تک ماہانہ';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'ماہانہ پر سوئچ کریں';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'آپ کا سالانہ پلان $date تک چلتا ہے۔ ماہانہ بلنگ اس کے اگلے دن شروع ہوگی۔';
  }

  @override
  String get rowMonthlyBillingStarts => 'ماہانہ بلنگ شروع ہوگی';

  @override
  String get rowMonthlyLabel => 'ماہانہ';

  @override
  String get rowYearlyWorkedOut => 'سالانہ پلان کا حساب تھا';

  @override
  String get ctaSwitchToMonthly => 'ماہانہ پر سوئچ کریں';

  @override
  String get ovRefundHelpTitle => 'رقم کی واپسی اسٹور کے ذمے ہے';

  @override
  String get ovRefundHelpBody =>
      'ہم خود رقم واپس نہیں کر سکتے۔ ہر درخواست کا جائزہ اسٹور لیتا ہے۔';

  @override
  String get ctaGoToStore => 'اسٹور پر جائیں';

  @override
  String get ovTrialEndingTitle => 'آپ کا ٹرائل کل ختم ہو رہا ہے';

  @override
  String get ovTrialEndingBody =>
      'منسوخ نہ کریں تو Premium جاری رہتا ہے۔ آگے یہ ہوگا۔';

  @override
  String get rowTrialEnds => 'ٹرائل ختم';

  @override
  String get rowFirstCharge => 'پہلا چارج';

  @override
  String get rowThenMonthly => 'پھر ماہانہ';

  @override
  String get ctaCancelInStore => 'اسٹور میں منسوخ کریں';

  @override
  String get ovTrialStartTitle => 'Premium کے 7 دن، مفت';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date تک مفت۔ پھر $price ماہانہ، جب تک آپ اسٹور میں منسوخ نہ کریں۔';
  }

  @override
  String get ctaStart7Days => '7 دن مفت شروع کریں';

  @override
  String get ovOtoTitle => 'شروع کرنے سے پہلے ایک اور بات';

  @override
  String get ovOtoBody =>
      'اچھا فیصلہ۔ سالانہ ادائیگی پر وہی Premium کم قیمت میں ملتا ہے۔';

  @override
  String get ovFailedDeclinedTitle => 'آپ کا کارڈ مسترد ہو گیا';

  @override
  String get ovFailedDeclinedBody =>
      'اسٹور ادائیگی وصول نہیں کر سکا۔ کچھ بھی چارج نہیں ہوا۔';

  @override
  String get ctaUpdatePaymentMethod => 'ادائیگی کا طریقہ اپ ڈیٹ کریں';

  @override
  String get ovFailedCanceledTitle => 'ادائیگی منسوخ ہو گئی';

  @override
  String get ovFailedCanceledBody =>
      'آپ اب بھی Free پر ہیں۔ کچھ بھی چارج نہیں ہوا۔';

  @override
  String get ovFailedStoreTitle => 'کچھ غلط ہو گیا';

  @override
  String get ovFailedStoreBody =>
      'ہم اسٹور تک نہیں پہنچ سکے۔ کچھ بھی چارج نہیں ہوا۔';

  @override
  String get ovAlreadyTitle => 'آپ پہلے ہی Premium پر ہیں';

  @override
  String get ovAlreadyBody =>
      'اس اسٹور اکاؤنٹ پر ایک فعال پلان موجود ہے۔ خریدنے کو کچھ نہیں۔';

  @override
  String get ctaSeeMySubscription => 'میری سبسکرپشن دیکھیں';

  @override
  String get subCancelTitle => 'سبسکرپشن منسوخ کریں';

  @override
  String subCancelBody(String date) {
    return 'Premium $date تک جاری رہے گا۔ اس کے بعد آپ Free پر چلے جائیں گے۔';
  }

  @override
  String get subWhatYouLose => 'جو آپ کھو دیں گے';

  @override
  String get benefitScoring => 'حرف بہ حرف تلفظ کی جانچ';

  @override
  String get benefitEveryMetric => 'ہر میٹرک، ہر جملہ';

  @override
  String get subPaymentTitle => 'ادائیگی اپ ڈیٹ کریں';

  @override
  String get subPaymentBody =>
      'ہم ادائیگی وصول نہیں کر سکے۔ رعایتی مدت کے دوران Premium جاری رہتا ہے۔';

  @override
  String get subHowToFix => 'اسے کیسے ٹھیک کریں';

  @override
  String get fixStep1 => 'اسٹور کھولیں اور ادائیگی کا طریقہ اپ ڈیٹ کریں';

  @override
  String get fixStep2 => 'واپس آئیں — آپ کا پلان خود بخود بحال ہو جائے گا';

  @override
  String get fixStep3 => 'کوئی رقم دو بار چارج نہیں ہوتی';

  @override
  String get subResubTitle => 'دوبارہ سبسکرائب کریں';

  @override
  String subResubBody(String date) {
    return 'Premium $date کو ختم ہوگا۔ خودکار تجدید دوبارہ آن کریں اور کچھ نہیں بدلے گا۔';
  }

  @override
  String get subWhatYouKeep => 'جو آپ کے پاس رہے گا';

  @override
  String get ctaTurnItBackOn => 'دوبارہ آن کریں';

  @override
  String get flTodayTitle => 'آج کی کال یہی تھی';

  @override
  String get flTodayBody => 'جہاں چھوڑا تھا وہیں سے جاری رکھیں — ابھی۔';

  @override
  String get flCheckTitle => 'آج کا چیک یہی تھا';

  @override
  String get flCheckBody =>
      'Free میں روزانہ 1 جانچ ہوتی ہے۔ Premium مکمل تجزیہ دیتا ہے۔';

  @override
  String flCaption(String price) {
    return '$price ماہانہ · کسی بھی وقت منسوخ کریں';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit میں سے $used استعمال ہوا';
  }

  @override
  String get ctaMaybeTomorrow => 'شاید کل';

  @override
  String get accountSection => 'اکاؤنٹ';

  @override
  String get nicknameLabel => 'عرفی نام';

  @override
  String get emailLabel => 'ای میل';

  @override
  String get loginMethodLabel => 'لاگ ان کا طریقہ';

  @override
  String get joinedLabel => 'شمولیت کی تاریخ';

  @override
  String get editNicknameTitle => 'عرفی نام میں ترمیم کریں';

  @override
  String get nicknameRule => '2–12 حروف۔ حروف اور اعداد۔ صرف انگریزی';

  @override
  String get ctaSave => 'محفوظ کریں';

  @override
  String get subscriptionRow => 'سبسکرپشن';

  @override
  String get iapSuccessTitle => 'خریداری مکمل';

  @override
  String iapSuccessBody(String name) {
    return '$name اوتار ہمیشہ کے لیے آپ کا ہے۔\nرسید کی تصدیق ہوتے ہی لاگو ہو جائے گا۔';
  }

  @override
  String get ctaGoHome => 'ہوم پر جائیں';

  @override
  String get ctaUseNow => 'ابھی استعمال کریں';

  @override
  String get iapFailTitle => 'ادائیگی مکمل نہیں ہوئی';

  @override
  String get iapFailBody => 'آپ دوبارہ کوشش کر سکتے ہیں';

  @override
  String get paywallLeaveTitle => 'اگر آپ ابھی چلے گئے تو سبسکرپشن نہیں ہوگی';

  @override
  String get paywallLeaveBody =>
      'ادائیگی کے فوراً بعد آپ کے فوائد کھل جاتے ہیں۔ آپ میرا صفحہ سے کبھی بھی واپس آ سکتے ہیں۔';

  @override
  String get ctaKeepLooking => 'دیکھتے رہیں';

  @override
  String get ctaLeaveAnyway => 'پھر بھی جائیں';

  @override
  String get iapCharacterSuccessTitle => 'ایک نیا دوست شامل ہو گیا!';

  @override
  String get iapCharacterSuccessBody =>
      'یہ کردار ہمیشہ کے لیے آپ کا ہے — پلان بدلنے پر بھی رہتا ہے، اور خریداریاں بحال کریں سے کسی بھی ڈیوائس پر واپس آ جاتا ہے۔';

  @override
  String get iapCharacterFailedBody =>
      'خریداری مکمل نہیں ہوئی۔ کوئی رقم نہیں کٹی — دوبارہ کوشش کریں۔';

  @override
  String get noAccentDataTitle => 'ابھی تک لہجے کا کوئی ڈیٹا نہیں';

  @override
  String get noAccentDataBody =>
      'بات چیت جاری رکھیں، آپ کے لہجے کی خصوصیات جمع ہوتی جائیں گی۔';

  @override
  String get noLevelYetTitle => 'ابھی تک کوئی سطح نہیں';

  @override
  String get noLevelYetBody => 'پہلی کال مکمل کریں تو آپ کی سطح مل جائے گی۔';

  @override
  String get noPronunciationDataTitle => 'ابھی تک تلفظ کا کوئی ریکارڈ نہیں';

  @override
  String get noPronunciationDataBody =>
      'ہم کال میں کہے گئے جملوں سے تلفظ کا تجزیہ کرتے ہیں۔';

  @override
  String get noCharacterNote => 'ابھی تک کچھ نہیں کہا گیا';

  @override
  String get noPhonemesYet => 'تجزیے کے لیے ابھی کوئی آواز نہیں';

  @override
  String get noSentencesYet => 'تجزیے کے لیے ابھی کوئی جملہ نہیں';

  @override
  String get takeLevelTest => 'سطح کا امتحان دیں';

  @override
  String get reviewToSeeScore => 'دہرانے پر تلفظ کا اسکور نظر آئے گا';

  @override
  String get playAgain => 'دوبارہ کھیلیں';

  @override
  String get difficultySlow => 'آہستہ';

  @override
  String get difficultyNormal => 'معمول';

  @override
  String get difficultyFast => 'تیز';

  @override
  String get difficultyLabel => 'دشواری';

  @override
  String get connected => 'منسلک';

  @override
  String get unlockedWithMax => 'آپ کے پلان میں شامل';

  @override
  String get fcEndedTitle => 'آپ کی مفت کال ختم ہو گئی';

  @override
  String get fcEndedBody =>
      'مفت کالیں زیادہ سے زیادہ 5 منٹ کی ہوتی ہیں\nمزید بات کرنے کے لیے سبسکرائب کریں';

  @override
  String get ctaSubscribeKeepTalking => 'سبسکرائب کریں اور بات جاری رکھیں';

  @override
  String get kgTitle => 'جاری رکھیں؟';

  @override
  String get kgBody =>
      'کالیں 5 منٹ کے حصوں میں جاری رہتی ہیں۔\nہم ہر بار دوبارہ پوچھیں گے۔';

  @override
  String get pcEndedTitleToday => 'آج کی کال یہیں ختم کرتے ہیں۔';

  @override
  String get pcEndedBodyToday =>
      'جو بات ہوئی اسے دہرائیں، اور کل پھر کال کریں!';

  @override
  String get pcEndedTitle => 'یہ کال یہیں ختم کرتے ہیں۔';

  @override
  String get pcEndedBody => 'جو بات ہوئی اسے دہرائیں، اور پھر کال کریں!';

  @override
  String get ctaKeepTalking => 'بات جاری رکھیں';

  @override
  String get callModeSheetTitle => 'آپ کیسے بات کرنا چاہتے ہیں؟';

  @override
  String get callModeSheetSubtitle => 'یہ کال پر فوراً لاگو ہوگا';

  @override
  String get callModeFreeTalk => 'آزاد گفتگو';

  @override
  String get callModeFreeTalkDesc => 'بغیر اصلاح کے بات کریں';

  @override
  String get callModeStudy => 'مشق';

  @override
  String get callModeStudyDesc => 'ایک وقت میں ایک جملہ سیکھیں';

  @override
  String get callModeChange => 'موڈ تبدیل کریں';

  @override
  String get callModeKeep => 'ابھی نہیں';

  @override
  String get callExitTitle => 'کال ختم کریں؟';

  @override
  String get callExitSubtitle => 'ابھی ختم کرنے پر بھی ایک کال شمار ہوگی';

  @override
  String get callExitKeep => 'بات جاری رکھیں';

  @override
  String get callExitConfirm => 'کال ختم کریں';

  @override
  String get callMicMute => 'خاموش کریں';

  @override
  String get callMicUnmute => 'آواز کھولیں';

  @override
  String get callPushToTalk => 'بولنے کے لیے دبائے رکھیں';

  @override
  String get callFreeEndedTitle => 'آپ کی مفت کال ختم ہو گئی';

  @override
  String get callFreeEndedCta => 'سبسکرائب کریں اور بات جاری رکھیں';

  @override
  String get callKeepGoingTitle => 'جاری رکھیں؟';

  @override
  String get callKeepGoingSubtitle =>
      'کالیں 5 منٹ کے حصوں میں چلتی ہیں۔ ہر بار ہم دوبارہ پوچھیں گے۔';

  @override
  String get articulationSelectedWord => 'منتخب لفظ';

  @override
  String get articulationYouSaid => 'آپ کا تلفظ';

  @override
  String get articulationTargetSound => 'ہدف';

  @override
  String get reportEntry => 'رپورٹ کریں';

  @override
  String get reportTitle => 'رپورٹ';

  @override
  String get reportPrompt => 'کیا مسئلہ پیش آیا؟';

  @override
  String get reportGuide =>
      'بتائیں کہ AI کردار کی کس بات سے آپ کو تکلیف ہوئی۔ ہم ہر رپورٹ کا جائزہ لیتے ہیں۔';

  @override
  String get reportReasonSexual => 'جنسی مواد';

  @override
  String get reportReasonHate => 'نفرت یا امتیاز';

  @override
  String get reportReasonViolence => 'پرتشدد یا دھمکی آمیز مواد';

  @override
  String get reportReasonSelfHarm => 'خود کو نقصان پہنچانے کی ترغیب';

  @override
  String get reportReasonMisinfo => 'غلط معلومات';

  @override
  String get reportReasonOther => 'کوئی اور مسئلہ';

  @override
  String get reportDetailHint => 'جو ہوا وہ لکھیں (اختیاری)';

  @override
  String get reportSubmit => 'رپورٹ بھیجیں';

  @override
  String get reportDoneTitle => 'آپ کی رپورٹ موصول ہو گئی';

  @override
  String get reportDoneBody =>
      'ہم جائزہ لے کر ضرورت پڑنے پر کارروائی کریں گے۔ BeaverTalk کو محفوظ رکھنے میں مدد کا شکریہ۔';

  @override
  String get reportFailed => 'رپورٹ نہیں بھیجی جا سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get hwTitle => 'ہوم ورک';

  @override
  String get hwJoinCodeTitle => 'اپنا کلاس کوڈ درج کریں';

  @override
  String get hwJoinCodeSubtitle =>
      'یہ آپ کے استاد کا دیا ہوا 6 ہندسوں کا کوڈ ہے';

  @override
  String get hwJoinCodeLabel => 'کلاس کوڈ';

  @override
  String get hwJoinCodeHelp => 'کوڈ میں بڑے چھوٹے حروف کا فرق نہیں';

  @override
  String get hwJoinConfirmTitle => 'کیا یہی صحیح کلاس ہے؟';

  @override
  String get hwJoinConfirmSubtitle => 'اگر نہیں تو کوڈ دوبارہ دیکھیں';

  @override
  String get hwJoinFieldInstitution => 'ادارہ';

  @override
  String get hwJoinFieldTeacher => 'استاد';

  @override
  String get hwJoinFieldLearners => 'طلبہ';

  @override
  String get hwJoinFieldTerm => 'مدت';

  @override
  String get hwJoinConfirmNote =>
      'کلاس کا نام بالکل ویسا دکھایا جاتا ہے جیسا استاد نے لکھا۔ ہم اس کا ترجمہ نہیں کرتے۔';

  @override
  String get hwJoinConfirmYes => 'جی ہاں، یہی ہے';

  @override
  String get hwJoinConfirmRetry => 'کوڈ دوبارہ درج کریں';

  @override
  String get hwJoinProfileTitle => 'کلاس میں آپ کون سا نام استعمال کریں گے؟';

  @override
  String get hwJoinProfileSubtitle => 'استاد اسے کلاس کی فہرست سے ملاتے ہیں';

  @override
  String get hwJoinNameLabel => 'نام';

  @override
  String get hwJoinNameHelp => 'یہ ایپ کے نام سے مختلف ہو سکتا ہے';

  @override
  String get hwJoinStudentNoLabel => 'طالب علم نمبر (اختیاری)';

  @override
  String get hwJoinStudentNoHelp =>
      'استاد اسے فہرست ملانے کے لیے استعمال کرتے ہیں';

  @override
  String get hwJoinConsentTitle => 'آپ کے استاد کو کیا نظر آتا ہے';

  @override
  String get hwJoinConsentSubtitle =>
      'کلاس میں شامل ہونے کے لیے رضامندی ضروری ہے';

  @override
  String get hwJoinConsentSharedHeading => 'استاد کے ساتھ شیئر کیا جاتا ہے';

  @override
  String get hwJoinConsentShared1 => 'کلاس کا نام اور طالب علم نمبر';

  @override
  String get hwJoinConsentShared2 => 'آپ نے ہوم ورک کیا یا نہیں';

  @override
  String get hwJoinConsentShared3 => 'کامیاب اور ناکام جملے';

  @override
  String get hwJoinConsentShared4 => 'اسائنمنٹ کال کا دورانیہ اور خلاصہ';

  @override
  String get hwJoinConsentNotSharedHeading => 'شیئر نہیں کیا جاتا';

  @override
  String get hwJoinConsentNotShared1 => 'ای میل اور فون نمبر';

  @override
  String get hwJoinConsentNotShared2 => 'ایپ کا نام، پروفائل اور کردار';

  @override
  String get hwJoinConsentNotShared3 => 'قومیت اور مادری زبان';

  @override
  String get hwJoinConsentNotShared4 => 'کلاس سے باہر کی کالیں اور مطالعہ';

  @override
  String get hwJoinConsentNotShared5 => 'سبسکرپشن اور ادائیگی کی تفصیلات';

  @override
  String get hwJoinConsentAgree => 'میں مندرجہ بالا سے متفق ہوں';

  @override
  String get hwJoinConsentCta => 'متفق ہو کر شامل ہوں';

  @override
  String hwJoinDoneTitle(String className) {
    return 'آپ $className میں شامل ہو گئے';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count اسائنمنٹ آپ کے منتظر ہیں';
  }

  @override
  String get hwJoinDoneNoAssignment => 'ابھی کوئی اسائنمنٹ نہیں';

  @override
  String get hwJoinDoneNextDue => 'اگلی آخری تاریخ';

  @override
  String get hwJoinDoneRosterName => 'کلاس میں آپ کا نام';

  @override
  String get hwJoinDoneCta => 'ہوم ورک دیکھیں';

  @override
  String get hwJoinErrorNotFound => 'وہ کوڈ نہیں ملا';

  @override
  String get hwJoinErrorNotFoundBody => 'براہ کرم چھ ہندسے دوبارہ دیکھیں۔';

  @override
  String get hwJoinErrorExpired => 'اس کوڈ کی مدت ختم ہو گئی';

  @override
  String get hwJoinErrorExpiredBody => 'اپنے استاد سے نیا کوڈ لیں۔';

  @override
  String get hwJoinErrorFull => 'کلاس بھر چکی ہے';

  @override
  String get hwJoinErrorFullBody => 'براہ کرم اپنے استاد کو بتائیں۔';

  @override
  String get hwJoinFailed =>
      'شامل نہیں ہو سکے۔ تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get hwSectionInProgress => 'جاری';

  @override
  String get hwSectionUpcoming => 'آنے والے';

  @override
  String get hwSectionDone => 'مکمل';

  @override
  String get hwLeaveClassLink => 'کلاس چھوڑیں';

  @override
  String get hwListEmptyTitle => 'ابھی کوئی ہوم ورک نہیں';

  @override
  String get hwListEmptyBody => 'جب استاد دیں گے تو یہاں نظر آئے گا۔';

  @override
  String get hwListFailed => 'آپ کا ہوم ورک لوڈ نہیں ہو سکا۔';

  @override
  String get hwRetry => 'دوبارہ کوشش کریں';

  @override
  String get hwBadgeDone => 'مکمل';

  @override
  String get hwBadgeOverdue => 'جمع نہیں کرایا';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'جمع نہیں، $days دن تاخیر';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'آج آخری دن';

  @override
  String get hwActivitySpeaking => 'بول چال';

  @override
  String get hwActivityConversation => 'گفتگو';

  @override
  String get hwActivityWorkbook => 'ورک بک';

  @override
  String hwChapterLabel(String chapter) {
    return 'باب $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'اپنے تلفظ کا اسکور دیکھیں';

  @override
  String get hwTaskConversationDesc =>
      'جو سیکھا اسے حقیقی گفتگو میں استعمال کریں';

  @override
  String get hwConversationOnce =>
      'ہر ہوم ورک میں گفتگو صرف ایک بار کی جا سکتی ہے۔';

  @override
  String get hwTaskWorkbookDesc => 'ورک بک میں لکھ کر مشق کریں';

  @override
  String get hwCtaStudy => 'شروع کریں';

  @override
  String get hwCtaResult => 'نتیجہ دیکھیں';

  @override
  String get hwCtaDownload => 'ڈاؤن لوڈ';

  @override
  String get hwSpeakingNoScore => 'آپ نے ابھی بول چال کا کام نہیں کیا';

  @override
  String get hwWorkbookUnavailable => 'ورک بک کی فائل ابھی دستیاب نہیں۔';

  @override
  String get hwDetailClosed =>
      'یہ اسائنمنٹ بند ہو چکا ہے۔ اب جمع نہیں کرا سکتے۔';

  @override
  String get hwLeaveTitle => 'کلاس چھوڑ دیں؟';

  @override
  String get hwLeaveBody =>
      'آپ کے استاد اب آپ کے ہوم ورک کے نتائج نہیں دیکھ سکیں گے۔';

  @override
  String get hwLeaveConfirm => 'چھوڑیں';

  @override
  String get hwLeaveCancel => 'رہیں';

  @override
  String get hwLeaveFailed => 'کلاس نہیں چھوڑی جا سکی۔';

  @override
  String get hwMyClass => 'میری کلاس';

  @override
  String get hwClassEmptyTitle => 'آپ کسی کلاس میں شامل نہیں ہوئے';

  @override
  String get hwClassEmptySubtitle => 'استاد کا دیا ہوا کوڈ درج کریں';

  @override
  String get hwClassEmptyCta => 'کلاس کوڈ درج کریں';

  @override
  String get hwClassContinueCta => 'جاری رکھیں';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count اسائنمنٹ کل جمع کرانے ہیں';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'آپ کے $count اسائنمنٹ جمع نہیں ہوئے';
  }

  @override
  String get hwSpeakingUnavailable => 'اس اسائنمنٹ کے جملے ابھی دستیاب نہیں۔';

  @override
  String get hwBadgeClosed => 'بند';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total میں سے $passed جملے کامیاب';
  }

  @override
  String get challengeFirstWord => 'پہلا لفظ';

  @override
  String get challengeSeeAnalysis => 'نتائج دیکھیں';

  @override
  String get challengePaused => 'رکا ہوا';

  @override
  String get challengePausedNote => 'ٹائمر اور ریکارڈنگ دونوں رک گئے۔';

  @override
  String get challengeTimeLeft => 'باقی وقت';

  @override
  String get challengeScoreLabel => 'اسکور';

  @override
  String get challengeResume => 'جاری رکھیں';

  @override
  String get challengeBlockedTitle => 'کیمرا استعمال نہیں ہو سکتا';

  @override
  String get challengeBlockedNote =>
      'سیٹنگز میں کیمرا اور مائیک کی اجازت آن کریں۔';

  @override
  String get challengeGoBack => 'واپس جائیں';

  @override
  String get challengeOpenSettings => 'سیٹنگز کھولیں';

  @override
  String get saveDone => 'گیلری میں محفوظ ہو گیا';

  @override
  String get saveFailed => 'محفوظ نہیں ہو سکا';

  @override
  String get saveDeniedNote => 'تصاویر تک رسائی درکار ہے';

  @override
  String get callIncomingCallerFallback => 'بیور ٹیوٹر';

  @override
  String get callIncomingHandle => 'کورین کال';

  @override
  String get callMissedTitle => 'مسڈ کال';

  @override
  String get callMissedChannelDescription =>
      'بیور کی چھوٹی ہوئی کال کے بارے میں بتاتا ہے۔';

  @override
  String callMissedBody(String name) {
    return '$name نے آپ کو کال کی تھی';
  }

  @override
  String get callBeaverFallbackName => 'بیور';

  @override
  String get callNotifPermissionRationale =>
      'کالیں وصول کرنے کے لیے اطلاعات کی اجازت درکار ہے۔';

  @override
  String get callNotifPermissionRequired => 'ترتیبات میں اطلاعات کی اجازت دیں۔';

  @override
  String get callHintLockedTitle => 'مشق موڈ میں اشارے دستیاب نہیں ہیں';

  @override
  String get wsTitle => 'کمزور آوازیں';

  @override
  String get wsToList => 'فہرست پر واپس';

  @override
  String get wsNext => 'اگلا';

  @override
  String get wsRetry => 'دوبارہ کوشش';

  @override
  String get wsDone => 'مکمل';

  @override
  String get wsContinue => 'جاری رکھیں';

  @override
  String get wsQuit => 'چھوڑیں';

  @override
  String get wsRetryLater => 'براہ کرم کچھ دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get wsMissingTitle => 'وہ آواز نہیں مل سکی';

  @override
  String get wsMissingBody => 'براہ کرم فہرست سے دوبارہ منتخب کریں۔';

  @override
  String get wsListLoadFailed => 'فہرست لوڈ نہیں ہو سکی';

  @override
  String get wsLessonLoadFailed => 'سبق لوڈ نہیں ہو سکا';

  @override
  String get wsNationalTitle => 'آپ کے لہجے کی کمزور آوازیں';

  @override
  String get wsNationalPending => 'آپ کے لہجے کا تجزیہ ہونے پر یہ بھر جائے گا';

  @override
  String get wsNationalPicked => 'آپ کے لہجے کے تجزیے سے منتخب کیا گیا';

  @override
  String get wsNationalEmptyBody =>
      'کچھ مزید کالیں کریں تو ہم آپ کے لہجے کا تجزیہ کریں گے۔';

  @override
  String get wsMineTitle => 'میری کمزور آوازیں';

  @override
  String get wsMineSubtitle => 'حال ہی میں سب سے کم اسکور والی آوازیں';

  @override
  String get wsMineEmptyBody =>
      'کال کریں اور دہرائیں، آپ کی کمزور آوازیں جمع ہوتی جائیں گی۔';

  @override
  String get wsNoDataYet => 'ابھی کوئی ڈیٹا نہیں';

  @override
  String get wsGoToCall => 'کال شروع کریں';

  @override
  String get wsRule => 'قاعدہ';

  @override
  String get wsRecommended => 'تجویز کردہ';

  @override
  String get wsNotMeasured => 'پیمائش نہیں ہوئی';

  @override
  String get wsStepUnderstand => 'سمجھنا';

  @override
  String get wsStepWords => 'الفاظ';

  @override
  String get wsStepSentence => 'جملہ';

  @override
  String get wsStepTest => 'جانچ';

  @override
  String get wsQuitTitle => 'مشق روک دیں؟';

  @override
  String get wsQuitBody => 'ابھی نکل جائیں تو یہ مشق محفوظ نہیں ہوگی۔';

  @override
  String get wsHowToSound => 'آواز نکالنے کا طریقہ';

  @override
  String get wsPracticeWords => 'الفاظ کی مشق';

  @override
  String get wsPracticeSentence => 'جملے کی مشق';

  @override
  String get wsStartTest => 'جانچ شروع کریں';

  @override
  String get wsThisSentence => 'یہ جملہ';

  @override
  String get wsNoScoreNote =>
      'اس مرحلے کا اسکور نہیں ہوتا۔ بس آرام سے دہرائیں۔';

  @override
  String get wsListen => 'غور سے سنیں';

  @override
  String get wsSayNow => 'اب آپ بولیں';

  @override
  String get wsPracticeDone => 'مشق مکمل ہوئی';

  @override
  String get wsPaused => 'رکا ہوا';

  @override
  String get wsAudioFailed =>
      'آڈیو لوڈ نہیں ہو سکا۔ متن دیکھ کر بلند آواز میں پڑھیں۔';

  @override
  String get wsReadAloud => 'نیچے دیا جملہ بلند آواز میں پڑھیں';

  @override
  String get wsTapToStart => 'شروع کرنے کے لیے ٹیپ کریں';

  @override
  String get wsTapWhenDone => 'پڑھ چکیں تو ٹیپ کریں';

  @override
  String get wsScoring => 'اسکور لگایا جا رہا ہے';

  @override
  String get wsMicFailed => 'مائیکروفون نہیں کھل سکا۔';

  @override
  String get wsMicPermissionBody =>
      'اس ٹیسٹ میں بلند آواز سے پڑھنا ہوتا ہے، اس لیے مائیکروفون درکار ہے۔ سیٹنگز میں مائیکروفون کی اجازت آن کریں۔';

  @override
  String get wsNoSound => 'کچھ سنائی نہیں دیا۔ دوبارہ بولیں؟';

  @override
  String get wsScoreFailed => 'سکورنگ ناکام ہو گئی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get wsSomethingWrong => 'کچھ غلط ہو گیا۔';

  @override
  String get wsLearnDone => 'سبق مکمل ہوا';

  @override
  String get wsRetest => 'دوبارہ جانچ';

  @override
  String get wsFirstMeasure => 'پہلی پیمائش';

  @override
  String get wsFinalTest => 'آخری جانچ';

  @override
  String wsPoints(int score) {
    return '$score پوائنٹ';
  }

  @override
  String wsBeforePoints(int score) {
    return 'پہلے $score پوائنٹ';
  }

  @override
  String wsGoalPoints(int score) {
    return 'ہدف $score پوائنٹ';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'ہدف · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country لہجہ';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count الفاظ دہرائے';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count حصے دہرائے';
  }

  @override
  String get wsStartRecommended => 'تجویز کردہ آواز سے شروع کریں';

  @override
  String wsStartRecommendedWith(String label) {
    return '$label سے شروع کریں';
  }

  @override
  String get wsPointsUnit => 'پوائنٹ';

  @override
  String get wsEnterFromMypage => 'کمزور آوازوں کی مشق';

  @override
  String wsGoalOnly(int score) {
    return 'ہدف $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label کی آواز';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc۔ کال میں دوبارہ ملے تو یہ شکل یاد کریں۔';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country کے بولنے والوں سے اکثر غلط ہونے والی آوازیں';
  }
}
