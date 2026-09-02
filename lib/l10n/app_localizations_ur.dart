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
  String get review => 'جائزہ';

  @override
  String get pronunciationChallenge => 'تلفظ چیلنج';

  @override
  String get newExpressions => 'نئے تاثرات';

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
  String get myPage => 'میرا صفحہ';

  @override
  String get languageSaveFailed => 'آپ کی زبان محفوظ نہیں ہو سکی۔';

  @override
  String get accountDeleteFailed => 'آپ کا اکاؤنٹ حذف نہیں ہو سکا۔';

  @override
  String get changeAvatar => 'اوتار تبدیل کریں';

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
  String get changePlan => 'پلان تبدیل کریں';

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
  String get keepUsingPro => 'پرو استعمال جاری رکھیں';

  @override
  String get proMembership => 'پرو رکنیت';

  @override
  String pricePerMonth(String price) {
    return '$price / ماہ';
  }

  @override
  String get benefitUnlimitedCalls => 'لامحدود کالز';

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
      'پہلی بار چلانے پر کوریائی اسپیچ ماڈل (~82MB) ڈاؤن لوڈ ہو رہا ہے۔\nبراہ کرم تھوڑی دیر انتظار کریں۔';

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
  String get analysisTimeout =>
      'اس میں توقع سے زیادہ وقت لگ رہا ہے۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔';

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
  String subscriptionSwitchNote(String date) {
    return 'آپ $date تک Pro مراعات استعمال کر سکتے ہیں، اس کے بعد آپ کا پلان خودبخود مفت میں بدل جائے گا۔';
  }

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
  String get billingChangePlan => 'پلان تبدیل کریں';

  @override
  String get billingCompareAllPlans => 'تمام پلانز کا موازنہ کریں';

  @override
  String get billingBuyACharacter => 'کردار خریدیں';

  @override
  String get billingRestorePurchases => 'خریداریاں بحال کریں';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max ٹرائل';

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
  String get bannerGoUnlimitedTitle => 'Pro کے ساتھ لامحدود ہو جائیں';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'لامحدود کالیں · ہر ایک 15 منٹ · $price ماہانہ';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max کے ساتھ ویڈیو آن کریں';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'آمنے سامنے کالیں · $price ماہانہ';
  }

  @override
  String get bannerAnnualSwitchTitle => 'سالانہ پلان پر جائیں';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly سالانہ · $perMonth ماہانہ';
  }

  @override
  String get bannerPaymentFailedTitle => 'ہم ادائیگی وصول نہیں کر سکے';

  @override
  String get bannerPaymentFailedSub =>
      'Pro برقرار رکھنے کے لیے اسٹور میں ادائیگی اپ ڈیٹ کریں';

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
  String get noteFairUse =>
      'لامحدود استعمال ہماری منصفانہ استعمال کی پالیسی کے تابع ہے۔';

  @override
  String noteTrialEnds(String date) {
    return 'آپ کا ٹرائل $date کو ختم ہوگا۔ اس سے پہلے اسٹور میں منسوخ کریں تو کچھ بھی چارج نہیں ہوگا۔';
  }

  @override
  String get noteGrace =>
      'رعایتی مدت کے دوران آپ کی سہولتیں جاری رہتی ہیں۔ منسوخی کبھی ایپ میں نہیں روکی جاتی۔';

  @override
  String get noteHold =>
      'ادائیگی مکمل ہونے تک Pro موقوف ہے۔ آپ کے کردار اور پیش رفت محفوظ ہیں۔';

  @override
  String noteEnding(String date) {
    return 'آپ کا پلان ختم ہونے والا ہے۔ سہولتیں $date تک جاری رہیں گی، پھر آپ Free پر چلے جائیں گے۔ آپ کسی بھی وقت دوبارہ سبسکرائب کر سکتے ہیں۔';
  }

  @override
  String get trialExpiredTitle => 'آپ کا Max ٹرائل ختم ہو گیا';

  @override
  String get trialExpiredSub => 'اب آپ Free پر ہیں';

  @override
  String get seePlans => 'پلانز دیکھیں';

  @override
  String get currentPlanTitle => 'موجودہ پلان';

  @override
  String get badgeRecommended => 'تجویز کردہ';

  @override
  String get perMonthUnit => 'ماہانہ';

  @override
  String get planTaglinePro => 'لامحدود کالیں۔ ہر ایک 15 منٹ۔';

  @override
  String get planTaglineMax => 'اب آپ انہیں دیکھ سکتے ہیں۔';

  @override
  String get planTaglineFree => 'روزانہ ایک کال۔ بالکل مفت۔';

  @override
  String get bulletProCalls => 'جتنی چاہیں وائس کالیں';

  @override
  String get bulletProLength => 'ہر کال 15 منٹ';

  @override
  String get bulletProScoring => 'حرف بہ حرف تلفظ کی جانچ';

  @override
  String get bulletProCorrections => 'آپ کی مادری زبان کے مطابق اصلاحات';

  @override
  String get bulletProBeaverCalls => 'بیور پہلے آپ کو کال کرتا ہے';

  @override
  String get bulletMaxVideo => 'آمنے سامنے ویڈیو کالیں';

  @override
  String get bulletMaxEverything => 'Pro کی ہر چیز';

  @override
  String get bulletMaxCharacters => 'ہر کردار، لامحدود';

  @override
  String get bulletMaxStudyBook => 'آپ کی سطح کے مطابق اسٹڈی بک';

  @override
  String get bulletMaxWeeklyReport => 'آپ کے تلفظ میں تبدیلی پر ہفتہ وار رپورٹ';

  @override
  String get bulletFreeCall => 'روزانہ ایک 5 منٹ کی وائس کال';

  @override
  String get bulletFreeCheck => 'روزانہ ایک تلفظ چیک';

  @override
  String get bulletFreeAccent => 'لامحدود لہجہ چیک';

  @override
  String get bulletFreeCharacter => 'شروعات کے لیے ایک کردار';

  @override
  String get ctaGoUnlimited => 'لامحدود ہو جائیں';

  @override
  String get ctaTurnOnVideo => 'ویڈیو آن کریں';

  @override
  String get noteCallLength => 'ہر کال 15 منٹ کی ہوتی ہے۔';

  @override
  String get paywallProTitle1 => 'آپ کا کورین دوست';

  @override
  String get paywallProTitle2 => 'جو رات 3 بجے بھی جاگ رہا ہے';

  @override
  String get paywallProSub => 'لامحدود کالیں۔ ہر ایک 15 منٹ۔ سارا سال۔';

  @override
  String get paywallLimitHeadline => 'Pro حد ہٹا دیتا ہے۔';

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
  String get paywallMaxSub =>
      'ویڈیو کالیں، ہر کردار، اور آپ کی سطح کے مطابق بنی اسٹڈی بک۔';

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
  String get noteMaxCharacters =>
      'Max سے کھلنے والے کردار اس وقت تک دستیاب ہیں جب تک آپ کی سبسکرپشن فعال ہے۔ خریدے گئے کردار آپ کے رہتے ہیں۔';

  @override
  String get processingTitle => 'آپ کی خریداری کی تصدیق ہو رہی ہے';

  @override
  String get processingSub => 'اس میں عام طور پر چند سیکنڈ لگتے ہیں۔';

  @override
  String get successProTitle => 'آپ Pro پر ہیں۔';

  @override
  String get successProSub => 'لامحدود کالیں، ابھی سے شروع۔';

  @override
  String get successProBenefit1 => 'جتنی چاہیں کال کریں — ہر کال 15 منٹ';

  @override
  String get successProBenefit2 => 'لامحدود تلفظ چیک';

  @override
  String get successProBenefit3 => 'ہر کردار، اور یکمشت خریداریاں بھی';

  @override
  String get successMaxTitle => 'اب آپ انہیں دیکھ سکتے ہیں۔';

  @override
  String get successMaxSub =>
      'ویڈیو کالیں آن ہیں۔ کسی بھی کال میں ویڈیو بٹن دبائیں۔';

  @override
  String get successMaxBenefit1 => 'آمنے سامنے ویڈیو کالیں';

  @override
  String get successMaxBenefit2 => 'ہر کردار لامحدود، نئے سب سے پہلے';

  @override
  String get successMaxBenefit3 => 'آپ کی سطح کے مطابق اسٹڈی بک';

  @override
  String get ctaStartACall => 'کال شروع کریں';

  @override
  String get ctaStartAVideoCall => 'ویڈیو کال شروع کریں';

  @override
  String get ctaSeeYourSubscription => 'اپنی سبسکرپشن دیکھیں';

  @override
  String successProCaption(String price) {
    return 'منسوخی تک ہر ماہ $price چارج ہوگا۔ اسٹور میں کسی بھی وقت منظم یا منسوخ کریں۔';
  }

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
  String get changePlanTitle => 'پلان تبدیل کریں';

  @override
  String get moveToMaxTitle => 'Max پر جائیں';

  @override
  String maxPriceShort(String price) {
    return '$price / ماہ';
  }

  @override
  String get moveToMaxCardSub =>
      'آمنے سامنے ویڈیو کالیں · ہر کردار · آپ کے لیے بنی اسٹڈی بک';

  @override
  String get whatHappensNow => 'اب کیا ہوگا';

  @override
  String get maxStartsLabel => 'Max شروع ہوگا';

  @override
  String get immediately => 'فوراً';

  @override
  String get unusedProTime => 'Pro کا غیر استعمال شدہ وقت';

  @override
  String get creditedTowardMax => 'Max میں شمار ہوگا';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max پر سوئچ کریں';

  @override
  String get upgradeCaption =>
      'آپ کا نیا پلان فوراً شروع ہوتا ہے۔ Pro کا غیر استعمال شدہ وقت شمار ہوتا ہے، دو بار کبھی چارج نہیں ہوتا۔';

  @override
  String get moveToProTitle => 'Pro پر جائیں';

  @override
  String get moveToProSub =>
      'آج کچھ نہیں بدلتا۔ Max اس مہینے کے آخر تک چلتا ہے جس کی آپ ادائیگی کر چکے ہیں۔';

  @override
  String get maxRunsUntil => 'Max جاری رہے گا';

  @override
  String get proStarts => 'Pro شروع ہوگا';

  @override
  String get whatYouKeep => 'جو آپ کے پاس رہے گا';

  @override
  String get keepBenefitCalls => 'لامحدود وائس کالیں، ہر ایک 15 منٹ';

  @override
  String get keepBenefitCharacters => 'خریدے گئے کردار ہمیشہ آپ کے رہتے ہیں';

  @override
  String downgradeWarning(String date) {
    return 'ویڈیو کالیں اور صرف Max والے کردار $date کو بند ہو جائیں گے۔';
  }

  @override
  String get ctaSwitchToPro => 'Pro پر سوئچ کریں';

  @override
  String get ctaKeepMax => 'Max رکھیں';

  @override
  String get winbackSkip => 'چھوڑیں';

  @override
  String get winbackTitle => 'آپ کا Pro پلان ختم ہو گیا';

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
  String get ovRestoreSuccessTitle => 'Pro واپس آ گیا';

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
  String get ovCharacterOfferTitle => 'Pro کے لیے تیار نہیں؟';

  @override
  String get ovCharacterOfferBody =>
      'ایک کردار چنیں اور اپنا بنا لیں۔ یکمشت خریداری — نہ سبسکرپشن، نہ تجدید۔';

  @override
  String get rowOneCharacter => 'ایک کردار';

  @override
  String rowFromPrice(String price) {
    return '$price سے';
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
  String get rowProRunsUntil => 'Pro جاری رہے گا';

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
      'آپ دو ماہ سے Pro پر ہیں۔ سالانہ پلان سستا پڑتا ہے۔';

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
      'منسوخ نہ کریں تو Max جاری رہتا ہے۔ آگے یہ ہوگا۔';

  @override
  String get rowTrialEnds => 'ٹرائل ختم';

  @override
  String get rowFirstCharge => 'پہلا چارج';

  @override
  String get rowThenMonthly => 'پھر ماہانہ';

  @override
  String get ctaCancelInStore => 'اسٹور میں منسوخ کریں';

  @override
  String get ovTrialStartTitle => 'Max کے 7 دن، مفت';

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
      'بہترین فیصلہ — لامحدود کالیں ابھی آن ہیں۔ وہی Pro سالانہ ادائیگی پر سستا پڑتا ہے۔';

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
  String get ovAlreadyTitle => 'آپ پہلے ہی Pro پر ہیں';

  @override
  String get ovAlreadyBody =>
      'اس اسٹور اکاؤنٹ پر ایک فعال پلان موجود ہے۔ خریدنے کو کچھ نہیں۔';

  @override
  String get ctaSeeMySubscription => 'میری سبسکرپشن دیکھیں';

  @override
  String get subCancelTitle => 'سبسکرپشن منسوخ کریں';

  @override
  String subCancelBody(String date) {
    return 'Pro $date تک جاری رہے گا۔ اس کے بعد آپ Free پر چلے جائیں گے۔';
  }

  @override
  String get subWhatYouLose => 'جو آپ کھو دیں گے';

  @override
  String get benefitCalls15 => 'لامحدود کالیں، ہر ایک 15 منٹ';

  @override
  String get benefitScoring => 'حرف بہ حرف تلفظ کی جانچ';

  @override
  String get benefitEveryCharacter => 'ہر کردار، لامحدود';

  @override
  String get ctaKeepPro => 'Pro رکھیں';

  @override
  String get subPaymentTitle => 'ادائیگی اپ ڈیٹ کریں';

  @override
  String get subPaymentBody =>
      'ہم ادائیگی وصول نہیں کر سکے۔ رعایتی مدت کے دوران Pro جاری رہتا ہے۔';

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
    return 'Pro $date کو ختم ہوگا۔ خودکار تجدید دوبارہ آن کریں اور کچھ نہیں بدلے گا۔';
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
      'Free پر روزانہ ایک چیک۔ Pro اسے لامحدود بنا دیتا ہے۔';

  @override
  String get flBenefitCalls => 'Pro کے ساتھ لامحدود کالیں · ہر ایک 15 منٹ';

  @override
  String get flBenefitChecks => 'Pro کے ساتھ لامحدود تلفظ چیک';

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
  String get emailLabel => 'Email';

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
  String get unlockedWithMax => 'Max کے ساتھ دستیاب';

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
}
