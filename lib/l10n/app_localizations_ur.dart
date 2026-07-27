// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

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
  String get selectACountry => 'ملک منتخب کریں';

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
  String get pricePerMonth => '\$12.9 / ماہ';

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
  String get loginAppleSignInFailed => 'گوگل سائن ان ناکام ہو گیا۔';

  @override
  String get loginKakaoSignInFailed => 'گوگل سائن ان ناکام ہو گیا۔';

  @override
  String get loginContinueWithKakao => 'Kakao کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithGoogle => 'Google کے ساتھ جاری رکھیں';

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
}
