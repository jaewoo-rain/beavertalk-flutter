// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get loginRequired => 'تحتاج إلى تسجيل الدخول.';

  @override
  String get callWebNotSupported =>
      'المكالمات الصوتية غير مدعومة على الويب. يرجى استخدام التطبيق.';

  @override
  String get micPermissionRequiredForCall =>
      'إذن الميكروفون مطلوب. اسمح بالميكروفون لبدء المكالمة.';

  @override
  String get callErrorGeneric => 'حدث خطأ أثناء المكالمة.';

  @override
  String get callDailyLimit => 'لقد استنفدت وقت التعلّم لهذا اليوم.';

  @override
  String get callAlreadyInCall => 'أنت في مكالمة بالفعل.';

  @override
  String get callNetworkError => 'حدث خطأ في الشبكة.';

  @override
  String get authInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authEmailAlreadyRegistered =>
      'هذا البريد الإلكتروني مسجَّل بالفعل.';

  @override
  String get authConfirmEmailRequired =>
      'يرجى إكمال التحقق المُرسَل إلى بريدك الإلكتروني.';

  @override
  String get authResetCodeSent => 'أرسلنا رمز التحقق إلى بريدك الإلكتروني.';

  @override
  String get authResetCodeInvalid => 'الرمز غير صحيح أو منتهي الصلاحية.';

  @override
  String get authPasswordUpdated => 'تم إعادة تعيين كلمة المرور.';

  @override
  String get authAppleTokenMissing =>
      'تعذّر الحصول على رمز تسجيل الدخول عبر Apple.';

  @override
  String callEndedDuration(String duration) {
    return 'انتهت المكالمة $duration';
  }

  @override
  String get callRatingPrompt => 'كيف كانت مكالمتك؟';

  @override
  String get callRatingBody =>
      'تقييمك يساعدنا على محادثة أفضل في المرة القادمة.';

  @override
  String get callRatingSubmit => 'إرسال';

  @override
  String get callRatingSkip => 'تخطٍّ';

  @override
  String get ratingBad => 'غير جيدة';

  @override
  String get ratingOkay => 'مقبولة';

  @override
  String get ratingGood => 'جيدة';

  @override
  String get goHome => 'الرئيسية';

  @override
  String get viewAnalysis => 'عرض التحليل';

  @override
  String get loadingShort => 'جارٍ التحميل…';

  @override
  String ratingSubmitFailed(String message) {
    return 'تعذّر إرسال التقييم: $message';
  }

  @override
  String get callInfoNotFound =>
      'لم يتم العثور على معلومات المكالمة، سيتم تخطي التحليل.';

  @override
  String get tabRecords => 'السجلات';

  @override
  String get tabArchive => 'الأرشيف';

  @override
  String get callHistory => 'سجل المكالمات';

  @override
  String get conversationRecord => 'سجل المحادثة';

  @override
  String get noCallRecords => 'لا توجد سجلات مكالمات بعد';

  @override
  String get noCallRecordsBody =>
      'بعد إنهاء أول مكالمة لك مع الذكاء الاصطناعي،\nستظهر سجلاتك هنا.';

  @override
  String get startCall => 'ابدأ مكالمة';

  @override
  String get recordsLoadError => 'تعذّر تحميل السجلات';

  @override
  String get tryAgainLater => 'يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes دقيقة $seconds ثانية';
  }

  @override
  String get scheduleManagement => 'الجدول';

  @override
  String get alarms => 'التنبيهات';

  @override
  String get alarmAdd => 'إضافة منبّه';

  @override
  String get alarmEdit => 'تعديل المنبّه';

  @override
  String get alarmEveryDay => 'كل يوم';

  @override
  String get alarmWeekdays => 'أيام الأسبوع';

  @override
  String get alarmWeekend => 'عطلة نهاية الأسبوع';

  @override
  String get alarmNoRepeat => 'بدون تكرار';

  @override
  String get addSchedule => 'إضافة موعد';

  @override
  String get editSchedule => 'تعديل الموعد';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get alarmsLoadError => 'تعذّر تحميل التنبيهات';

  @override
  String get charactersLoadError => 'تعذّر تحميل الشخصيات';

  @override
  String get noCharacters => 'لا توجد شخصيات متاحة';

  @override
  String get close => 'إغلاق';

  @override
  String get repeat => 'التكرار';

  @override
  String get callPartner => 'الشخصية';

  @override
  String get alarmModeLearnSub => 'تدرّب على تعابير المنهج';

  @override
  String get alarmModeChatSub => 'تحدّث في أي موضوع';

  @override
  String get quickStart => 'بدء سريع';

  @override
  String get presetMorning => 'روتين الصباح';

  @override
  String get presetMorningSub => 'أيام العمل 8:00';

  @override
  String get presetEvening => 'ختام المساء';

  @override
  String get presetEveningSub => 'كل يوم 21:00';

  @override
  String get presetCustom => 'مخصص';

  @override
  String get presetCustomSub => 'كما تحب';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× أسبوعيًا · $monthly مكالمة شهريًا';
  }

  @override
  String get alarmSummaryNone => 'اختر يومًا واحدًا على الأقل';

  @override
  String get partnerInUse => 'قيد الاستخدام';

  @override
  String get partnerOwned => 'مملوك';

  @override
  String get am => 'ص';

  @override
  String get pm => 'م';

  @override
  String get save => 'حفظ';

  @override
  String get conversation => 'المحادثة';

  @override
  String get newExpressions => 'تعبيرات جديدة';

  @override
  String get analysisPrepNote => 'نراجع مكالمة اليوم.';

  @override
  String get analysisPrepNoteHint => 'ستظهر الملاحظة هنا بعد قليل';

  @override
  String get analysisPrepTitle => 'يصنع القندس بطاقات من تعبيرات اليوم';

  @override
  String get analysisPrepSub => 'ستظهر هنا فور جهوزها.';

  @override
  String get analysisPrepStepSave => 'حفظ المحادثة';

  @override
  String get analysisPrepStepCards => 'صنع بطاقات التعبيرات';

  @override
  String get analysisPrepStateDone => 'تم';

  @override
  String get analysisPrepStateWorking => 'جارٍ';

  @override
  String get analysisPrepStateWaiting => 'بالانتظار';

  @override
  String get usedExpressions => 'العبارات التي استخدمتها';

  @override
  String quizExpressionsCount(int count) {
    return 'التعبيرات التي تعلّمتها $count';
  }

  @override
  String get quizPassed => 'أحسنت';

  @override
  String get quizFailed => 'راجِعها مجددًا';

  @override
  String get quizPending => 'نكمل في المرة القادمة';

  @override
  String get analysisResult => 'نتيجة التحليل';

  @override
  String get noNewExpressions => 'لا توجد تعبيرات جديدة من هذه المحادثة.';

  @override
  String get practice => 'تدرّب';

  @override
  String get analysisNativeLabel => 'كما يقولها أهلها';

  @override
  String recentScore(int score) {
    return 'النتيجة الأخيرة $score%';
  }

  @override
  String callSequence(int count) {
    return 'المكالمة رقم $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'كلمة من $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'تركها $name بعد المكالمة مباشرة';
  }

  @override
  String newExpressionsCount(int count) {
    return 'تعبيرات جديدة $count';
  }

  @override
  String get analysisLoadError => 'تعذّر تحميل نتيجة التحليل.';

  @override
  String get standardAudioNotReady => 'الصوت المعياري للنطق غير جاهز بعد.';

  @override
  String get standardAudioPlayError => 'تعذّر تشغيل الصوت المعياري للنطق.';

  @override
  String get selectNativeLanguage => 'اختر لغتك الأم';

  @override
  String get selectYourLanguage => 'اختر لغتك';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get micPermissionNeededTitle => 'الوصول إلى الميكروفون مطلوب';

  @override
  String get micPermissionNeededBody =>
      'للتحدث مع الذكاء الاصطناعي، يجب السماح بالوصول إلى الميكروفون. يرجى تفعيله من الإعدادات.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get connectionFailedTitle => 'فشل الاتصال';

  @override
  String get connectionFailedBody => 'تحقّق من اتصال الشبكة\nوحاول مرة أخرى.';

  @override
  String get checkout => 'الدفع';

  @override
  String get pay => 'ادفع';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get payMethodCard => 'بطاقة ائتمان / خصم';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'أفاتار القندس المزعج';

  @override
  String get productTrait => 'شخصية مميزة · ملكك للأبد';

  @override
  String get amountItemPrice => 'سعر المنتج';

  @override
  String get amountDiscount => 'الخصم';

  @override
  String get amountTotal => 'الإجمالي';

  @override
  String get paymentCompleteTitle => 'اكتمل الدفع';

  @override
  String get paymentCompleteBody => 'تمت إضافة الأفاتار إلى مجموعتك.';

  @override
  String get viewCollection => 'عرض المجموعة';

  @override
  String get receiptItem => 'المنتج';

  @override
  String get receiptAmount => 'المبلغ';

  @override
  String get receiptMethod => 'طريقة الدفع';

  @override
  String get receiptDate => 'التاريخ';

  @override
  String get paymentFailedTitle => 'فشل الدفع';

  @override
  String get paymentFailedBody =>
      'تعذّرت معالجة دفعتك.\nيرجى المحاولة مرة أخرى.';

  @override
  String get freeCallEndingTitle => 'مكالمتك المجانية على وشك الانتهاء';

  @override
  String get freeCallEndingBody => 'اشترك للتحدث مع Beaver لفترة أطول.';

  @override
  String get subscribe => 'اشترك';

  @override
  String get endCall => 'إنهاء المكالمة';

  @override
  String get callEnded => 'انتهت المكالمة.';

  @override
  String get connecting => 'جارٍ الاتصال…';

  @override
  String get connectingHint => 'عادةً ما يستغرق هذا أقل من 5 ثوانٍ';

  @override
  String get callConnectFailed => 'تعذّر إجراء الاتصال.';

  @override
  String get saveSentenceFailed => 'تعذّر حفظ الجملة.';

  @override
  String get recordStartFailed => 'تعذّر بدء التسجيل.';

  @override
  String get recordTooShort =>
      'التسجيل كان قصيرًا جدًا. يرجى المحاولة مرة أخرى.';

  @override
  String get gradingFailed => 'فشل التقييم. يرجى المحاولة مرة أخرى.';

  @override
  String get listenStandard => 'استمع إلى النطق المعياري';

  @override
  String get saveSentence => 'حفظ الجملة';

  @override
  String get unsaveSentence => 'إزالة الجملة المحفوظة';

  @override
  String get scoringPronunciation => 'جارٍ تقييم نطقك…';

  @override
  String get analyzingByWord => 'نتحقق من نطقك كلمة بكلمة';

  @override
  String get analyzingTakingLonger => 'هذا يستغرق وقتًا أطول قليلاً';

  @override
  String get scanConnectionLost => 'انقطع الاتصال';

  @override
  String get noRecordingToPlay => 'لا يوجد تسجيل لتشغيله.';

  @override
  String get myRecordingPlayError => 'تعذّر تشغيل تسجيلك.';

  @override
  String get next => 'التالي';

  @override
  String get endLearning => 'إنهاء الجلسة';

  @override
  String get navCall => 'مكالمة';

  @override
  String get homeCourseExpression => 'التعبيرات';

  @override
  String get homeCourseFreetalk => 'حوار';

  @override
  String homeExpressionsLeft(int count) {
    return 'بقي $count تعبيرًا حتى الحوار';
  }

  @override
  String get homeFreetalkNote => 'استخدم ما تعلمته وتحدث بحرية';

  @override
  String get homeTalkTitle => 'ماذا حدث اليوم؟';

  @override
  String get homeTalkNote => 'تحدّث بحرية وتعلّم أثناء ذلك.';

  @override
  String get homeModeLearn => 'تعلّم';

  @override
  String get homeModeTalk => 'محادثة';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام متتالية',
      one: 'يوم واحد متتالٍ',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'تقويم التعلّم';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام متتالية',
      one: 'يوم متتالٍ',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أفضل سلسلة: $count يوم',
      one: 'أفضل سلسلة: يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'مدة المكالمات';

  @override
  String get streakMetricLearned => 'التعابير';

  @override
  String get streakMetricWords => 'الكلمات المنطوقة';

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
      other: '$count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'لا توجد مكالمات في هذا اليوم.';

  @override
  String get homeLevelPending => 'المستوى غير محدد';

  @override
  String get homeNoLevelTitle => 'ليس لديك مستوى بعد';

  @override
  String get homeNoLevelNote => 'أكمل مكالمتك الأولى للحصول عليه';

  @override
  String get homeCurriculumPendingBadge => 'قريبًا';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'منهج $language قيد الإعداد';
  }

  @override
  String get homeCurriculumPendingNote =>
      'ستتدرّب على تعبيرات عامة في مكالماتك';

  @override
  String get myPage => 'صفحتي';

  @override
  String get languageSaveFailed => 'تعذّر حفظ لغتك.';

  @override
  String get accountDeleteFailed => 'تعذّر حذف حسابك.';

  @override
  String get changeAvatar => 'تغيير الأفاتار';

  @override
  String get avatarUseNow => 'استخدم الآن';

  @override
  String get avatarPurchaseFailed => 'لم تكتمل عملية الشراء';

  @override
  String avatarPromoTitle(int percent) {
    return 'اليوم فقط · خصم $percent%';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'متبقٍ $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'متبقٍ $days يوم $time';
  }

  @override
  String get avatarIntro =>
      'يختلف الصوت ومستوى الصعوبة حسب الشخصية.\nقد تتطلب بعض الشخصيات الدفع.';

  @override
  String myPartnersOwned(int count) {
    return 'شخصياتي · $count مملوكة';
  }

  @override
  String get limitedDiscount => 'خصم لفترة محدودة';

  @override
  String get available => 'متاح';

  @override
  String get inUse => 'قيد الاستخدام';

  @override
  String get owned => 'مملوك';

  @override
  String get noCharactersToShow => 'لا توجد شخصيات لعرضها';

  @override
  String get buy => 'شراء';

  @override
  String get noSavedSentences =>
      'لا توجد جمل محفوظة بعد.\nاحفظ الجمل من سجلات محادثاتك.';

  @override
  String get noAlarms => 'لا توجد تنبيهات بعد';

  @override
  String get noAlarmsBody => 'أضف تذكيرًا للتعلّم\nلبناء عادة ثابتة.';

  @override
  String get subscriptionManage => 'إدارة الاشتراك';

  @override
  String get cancelSubscription => 'إلغاء الاشتراك';

  @override
  String get benefitsInUse => 'مزاياك';

  @override
  String get paymentInfo => 'معلومات الدفع';

  @override
  String get nextBillingDate => 'تاريخ الفوترة القادم';

  @override
  String get lostBenefitsTitle => 'المزايا التي ستفقدها عند الإلغاء';

  @override
  String get viewBillingHistory => 'عرض سجل الفواتير';

  @override
  String pricePerMonth(String price) {
    return '$price / شهريًا';
  }

  @override
  String get benefitDetailedAnalysis => 'تحليل مفصّل للنطق والقواعد';

  @override
  String get benefitAllCharacters => 'الوصول إلى جميع الشخصيات';

  @override
  String get benefitNoAds => 'بدون إعلانات';

  @override
  String get playSampleVoice => 'تشغيل عينة صوتية';

  @override
  String get useThisAvatar => 'استخدم هذا';

  @override
  String get challengeTitle => 'تحدي النطق';

  @override
  String get challengeIntro =>
      'انطق كل بطاقة في المنطقة بشكل صحيح باللغة الكورية لتجاوزها.\nلا يوجد ميكروفون؟ يمكنك أيضًا اللعب بالنقر على الشاشة.';

  @override
  String get challengeStart => 'تشغيل الكاميرا والميكروفون';

  @override
  String get challengePermissionNote =>
      'يلزم الوصول إلى الكاميرا الأمامية والميكروفون (اختياري).';

  @override
  String get challengeLoadingTitle => 'جارٍ التحميل…';

  @override
  String get challengeLoadingNote => 'جارٍ تجهيز الكاميرا والميكروفون.';

  @override
  String get challengeSttFallback =>
      'لم يكن التعرف على الكلام متاحًا، لذا لعبت باستخدام النقر.';

  @override
  String get reasonTravelTitle => 'التحدث أثناء السفر';

  @override
  String get reasonTravelDesc => 'تحدّث بثقة مع السكان المحليين';

  @override
  String get reasonCareerTitle => 'العمل والمهنة';

  @override
  String get reasonCareerDesc => 'محادثات العمل';

  @override
  String get reasonExamTitle => 'التحضير للاختبارات';

  @override
  String get reasonExamDesc => 'استعد لاختبارات المحادثة';

  @override
  String get reasonDailyTitle => 'محادثات يومية';

  @override
  String get reasonDailyDesc => 'تعبيرات تستخدمها يوميًا';

  @override
  String get reasonFriendsTitle => 'تكوين صداقات أجنبية';

  @override
  String get reasonFriendsDesc => 'محادثة طبيعية';

  @override
  String get reasonBrainTitle => 'تحفيز الدماغ';

  @override
  String get reasonBrainDesc => 'عزّز الذاكرة والتركيز';

  @override
  String get challengeRecordToggle => 'تسجيل هذه الجولة';

  @override
  String get challengeRecordHint => 'يحفظ فيديو للعبك لمشاركته (بدون صوت).';

  @override
  String get settingsSection => 'الإعدادات';

  @override
  String get paymentSection => 'الدفع';

  @override
  String get supportSection => 'الدعم';

  @override
  String get userLanguage => 'لغة المستخدم';

  @override
  String get learningLanguage => 'لغة التعلّم';

  @override
  String get learningLanguageKorean => 'الكورية';

  @override
  String get notificationLabel => 'الإشعارات';

  @override
  String get currentPlan => 'الخطة الحالية';

  @override
  String get paymentHistory => 'سجل المدفوعات';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف الحساب؟';

  @override
  String get deleteAccountBody =>
      'سيؤدي هذا إلى حذف حسابك وبياناتك نهائيًا، ولا يمكن التراجع عن ذلك.';

  @override
  String get delete => 'حذف';

  @override
  String get share => 'مشاركة';

  @override
  String get accentSoundsLike => 'لكنتك الكورية تبدو';

  @override
  String accentShareText(String country) {
    return 'أتعلّم الكورية مع BeaverTalk — لكنتي الكورية تبدو مثل: $country! 🦫 اكتشف لكنتك وتعلّم معي: https://beavertalk.im';
  }

  @override
  String get hintLabel => 'تلميح';

  @override
  String get nextHint => 'التلميح التالي';

  @override
  String get translateLabel => 'ترجمة';

  @override
  String get startRecording => 'بدء التسجيل';

  @override
  String get stopRecording => 'إيقاف التسجيل';

  @override
  String get back => 'رجوع';

  @override
  String get onboardingNameTitle => 'بماذا نناديك؟';

  @override
  String get onboardingNameSubtitle => 'سيتذكر معلمك الذكي اسمك.';

  @override
  String get nameLabel => 'اسمك';

  @override
  String get nameHint => 'أدخل اسمك';

  @override
  String get nameHelper =>
      'لا يجب أن يكون اسمك الحقيقي — يمكنك استخدام لقب أيضًا.';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get onboardingDoneTitle => 'Beaver في انتظار مكالمتك';

  @override
  String get onboardingDoneSubtitle => 'ابدأ مكالمة الآن';

  @override
  String get home => 'الرئيسية';

  @override
  String get onboardingLevelTestCta => 'خوض اختبار المستوى';

  @override
  String get pronunciation => 'النطق';

  @override
  String get fluency => 'الطلاقة';

  @override
  String get rhythm => 'الإيقاع';

  @override
  String get analysisFailed => 'تعذّر تحليل المحادثة. يرجى المحاولة مرة أخرى.';

  @override
  String get analyzingConversation => 'جارٍ تحليل محادثتك…';

  @override
  String get analyzingSubtitle => 'سيستغرق هذا لحظات فقط';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get nativeLabel => 'الأصلي';

  @override
  String get meLabel => 'أنا';

  @override
  String get pronunciationPlayError => 'تعذّر تشغيل صوت النطق.';

  @override
  String get savedExpressionsLoadError => 'تعذّر تحميل تعبيراتك المحفوظة.';

  @override
  String get mySavedExpressions => 'تعبيراتي المحفوظة';

  @override
  String get avatarTraits => 'دافئ · هادئ · لطيف';

  @override
  String get priceFree => 'مجاني';

  @override
  String get loginGoogleTokenError =>
      'تعذّر الحصول على رمز تسجيل الدخول عبر Google.';

  @override
  String get loginGoogleSignInFailed => 'فشل تسجيل الدخول عبر Google.';

  @override
  String get loginAppleSignInFailed => 'فشل تسجيل الدخول عبر Apple.';

  @override
  String get loginFacebookSignInFailed => 'فشل تسجيل الدخول عبر Facebook.';

  @override
  String get loginKakaoSignInFailed => 'فشل تسجيل الدخول عبر Kakao.';

  @override
  String get loginContinueWithKakao => 'المتابعة عبر Kakao';

  @override
  String get loginContinueWithGoogle => 'المتابعة عبر Google';

  @override
  String get loginContinueWithFacebook => 'المتابعة عبر Facebook';

  @override
  String get loginContinueWithApple => 'المتابعة عبر Apple';

  @override
  String get loginContinueWithEmail => 'المتابعة عبر البريد الإلكتروني';

  @override
  String get loginOrDivider => 'أو';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get loginTermsNoticePrefix => 'بالمتابعة، فإنك توافق على ';

  @override
  String get loginTermsNoticeAnd => ' و ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'تسجيل الدخول';

  @override
  String get fieldEmailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get fieldPasswordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get loginRememberMe => 'تذكرني';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginLoggingIn => 'جارٍ تسجيل الدخول...';

  @override
  String get passwordLengthError =>
      'يجب أن تتكون كلمة المرور من 8 إلى 16 حرفًا.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get signupCheckInput => 'يرجى التحقق من المدخلات.';

  @override
  String get fieldConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get signupSigningUp => 'جارٍ إنشاء الحساب...';

  @override
  String get signupHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get passwordMethodEmailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get passwordResetTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordMethodDescription =>
      'أدخل عنوان البريد الإلكتروني الذي تريد استلام رمز إعادة تعيين كلمة المرور عليه.';

  @override
  String get emailAddressHint => 'عنوان البريد الإلكتروني';

  @override
  String get passwordMethodSending => 'جارٍ الإرسال...';

  @override
  String get passwordMethodSendEmail => 'إرسال البريد الإلكتروني';

  @override
  String get passwordCodeTitle => 'أدخل الرمز';

  @override
  String get passwordCodeDescription =>
      'لقد أرسلنا رمز استعادة إلى بريدك الإلكتروني. أدخله للمتابعة.';

  @override
  String get passwordCodeNoCode => 'لم تستلم الرمز؟';

  @override
  String get passwordCodeResend => 'إعادة إرسال الرمز';

  @override
  String get passwordCodeVerifying => 'جارٍ التحقق...';

  @override
  String get passwordNewTitle => 'كلمة مرور جديدة';

  @override
  String get passwordNewDescription => 'عيّن كلمة مرور جديدة لحسابك.';

  @override
  String get fieldNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get fieldConfirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordHint => 'أعد إدخال كلمة المرور الجديدة';

  @override
  String get passwordNewSubmitting => 'جارٍ الإرسال...';

  @override
  String get passwordNewSubmit => 'إرسال';

  @override
  String get passwordCompleteTitle => 'تم إعادة تعيين كلمة المرور';

  @override
  String get passwordCompleteBody =>
      'تمت إعادة تعيين كلمة مرورك. سجّل الدخول بكلمة المرور الجديدة للمتابعة.';

  @override
  String get termsTitle => 'شروط الخدمة';

  @override
  String get privacyTitle => 'سياسة الخصوصية';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'عيّن كلمة مرور جديدة لـ $email.';
  }

  @override
  String get selectComplete => 'تم';

  @override
  String get onboardingLanguageTitle => 'ما هي لغتك الأم؟';

  @override
  String get onboardingReasonTitle => 'لماذا تتعلم لغة؟';

  @override
  String get onboardingReasonSubtitle => 'سنخصص تعلمك وفقًا لأهدافك.';

  @override
  String get savingLabel => 'جارٍ الحفظ...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'مدفوعات هذا الشهر';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterSubscription => 'الاشتراك';

  @override
  String get filterCharacter => 'الشخصية';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get lastPayment => 'آخر دفعة';

  @override
  String get freePlanCallLimit => '5 دقائق من المكالمات يوميًا';

  @override
  String get freePlanBasicCharacters => 'الشخصيات الأساسية مشمولة';

  @override
  String get availableForPurchase => 'متاح للشراء';

  @override
  String get paymentsLoadError => 'تعذّر تحميل سجل المدفوعات';

  @override
  String get noPayments => 'لا توجد مدفوعات بعد';

  @override
  String get undatedPayments => 'بدون تاريخ';

  @override
  String get paymentLabelFallback => 'دفعة';

  @override
  String learningPassed(int passed, int total) {
    return 'نجحت $passed من $total جملة';
  }

  @override
  String get hardestSound => 'أصعب صوت اليوم';

  @override
  String get soundAccuracy => 'الدقة حسب الصوت';

  @override
  String phonemeAttempts(int count) {
    return 'لكل فونيم · $count محاولة';
  }

  @override
  String get colSound => 'الصوت';

  @override
  String get colAttempts => 'محاولات';

  @override
  String get colCorrect => 'صحيح';

  @override
  String get colAccuracy => 'الدقة';

  @override
  String get sentenceResults => 'النتائج حسب الجملة';

  @override
  String viewAllSentences(int count) {
    return 'عرض الكل $count';
  }

  @override
  String get colSentence => 'الجملة';

  @override
  String get colPronunciation => 'النطق';

  @override
  String get colFluency => 'الطلاقة';

  @override
  String get colRhythm => 'الإيقاع';

  @override
  String recentSessions(int count) {
    return 'آخر $count جلسات';
  }

  @override
  String trendAverage(int score) {
    return 'المتوسط $score';
  }

  @override
  String get today => 'اليوم';

  @override
  String get colDate => 'التاريخ';

  @override
  String get colSentences => 'الجمل';

  @override
  String get colScore => 'النتيجة';

  @override
  String get colChange => 'التغير';

  @override
  String dateToday(String date) {
    return '$date (اليوم)';
  }

  @override
  String get accentAnalysis => 'تحليل اللكنة';

  @override
  String get overallLevel => 'المستوى العام';

  @override
  String get overallLevelSubtitle => 'المفردات · القواعد · التعبيرات';

  @override
  String get pronunciationAnalysis => 'تحليل النطق';

  @override
  String get recentSessionsAverage => 'متوسط آخر 10 جلسات';

  @override
  String levelStage(int stage) {
    return 'المستوى $stage';
  }

  @override
  String topPercent(int percent) {
    return 'أفضل $percent%';
  }

  @override
  String get allLearnersBasis => 'بين جميع المتعلمين';

  @override
  String aheadOfLearners(int percent) {
    return 'أنت متقدم على $percent% من المتعلمين';
  }

  @override
  String get retakeLevelTest => 'إعادة اختبار المستوى';

  @override
  String get levelTestOncePerDay =>
      'يمكنك خوض اختبار المستوى مرة واحدة في اليوم. حاول مجددًا غدًا.';

  @override
  String get levelRetakeTitle => 'هل تعيد اختبار المستوى؟';

  @override
  String get levelRetakeBody =>
      'إذا أعدت الاختبار، يعود تقدّمك إلى الدرس الأول من ذلك المستوى — حتى لو حصلت على المستوى نفسه. تبقى التعابير التي تعلّمتها وسجل مكالماتك.';

  @override
  String get levelRetakeKeep => 'الإبقاء على تقدّمي';

  @override
  String get levelRetakeConfirm => 'إعادة الاختبار';

  @override
  String get practicePronunciation => 'تدرب على النطق';

  @override
  String get analysisNoScoreReview => 'تدرّب على الجمل لتحصل على نتيجة نطقك';

  @override
  String get analysisNoScoreEmpty => 'لا توجد جمل لتقييمها';

  @override
  String get priceChangedTitle => 'تغيّر السعر';

  @override
  String priceChangedBody(String price) {
    return 'أصبح سعر هذا العنصر $price. هل تريد المتابعة؟';
  }

  @override
  String get billingGroupPlanPurchases => 'الخطة والمشتريات';

  @override
  String get billingGroupInTheStore => 'في المتجر';

  @override
  String get billingCompareAllPlans => 'مقارنة الخطط';

  @override
  String get billingBuyACharacter => 'شراء شخصية';

  @override
  String get billingRestorePurchases => 'استعادة المشتريات';

  @override
  String get billingRedeemCode => 'استخدام رمز';

  @override
  String get billingPaymentHistory => 'سجل المدفوعات';

  @override
  String get billingManageInTheStore => 'الإدارة في المتجر';

  @override
  String get billingRefundHelp => 'مساعدة في استرداد المال';

  @override
  String get billingCancelSubscription => 'إلغاء الاشتراك';

  @override
  String get billingResubscribe => 'إعادة الاشتراك';

  @override
  String get badgeCurrent => 'الحالية';

  @override
  String get badgeTrial => 'تجريبية';

  @override
  String get badgeRenewing => 'قيد التجديد';

  @override
  String get badgePastDue => 'متأخر الدفع';

  @override
  String get badgePaused => 'متوقفة مؤقتًا';

  @override
  String get badgeCanceling => 'قيد الإلغاء';

  @override
  String get subscriptionTitle => 'الاشتراك';

  @override
  String get plansTitle => 'الخطط';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => '15 دقيقة من مكالمات الفيديو يوميًا';

  @override
  String get premiumBulletAnalysis => 'تحليل كامل للنطق';

  @override
  String get premiumBulletWeakSounds => 'تدريب على الأصوات الصعبة للغتك';

  @override
  String get noteCharactersSeparate =>
      'تُباع الشخصيات بشكل منفصل، والشخصيات التي تشتريها تبقى لك.';

  @override
  String get ctaGetPremium => 'احصل على Premium';

  @override
  String get planMaxTrial => 'تجربة Premium';

  @override
  String get freePlanPriceLine => '\$0.00 — 5 دقائق من المكالمات يوميًا';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount شهريًا';
  }

  @override
  String freeUntilDate(String date) {
    return 'مجانًا حتى $date';
  }

  @override
  String get todaysCalls => 'وقت مكالمات اليوم';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'استُخدم $used من $limit دقيقة';
  }

  @override
  String get firstPaymentLabel => 'الدفعة الأولى';

  @override
  String get nextPaymentLabel => 'الدفعة التالية';

  @override
  String get retryingUntilLabel => 'إعادة المحاولة حتى';

  @override
  String get pausedSinceLabel => 'متوقفة منذ';

  @override
  String planEndsLabel(String plan) {
    return 'ينتهي $plan';
  }

  @override
  String get bannerMaxUpsellTitle => 'تحدّث وجهًا لوجه مع Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'مكالمات فيديو · 15 دقيقة يوميًا · $price شهريًا';
  }

  @override
  String get bannerAnnualSwitchTitle => 'انتقل إلى الخطة السنوية';

  @override
  String get bannerPaymentFailedTitle => 'تعذّر إتمام الدفع';

  @override
  String get bannerPaymentFailedSub =>
      'حدّث وسيلة الدفع في المتجر للحفاظ على Premium';

  @override
  String get bannerPausedTitle => 'خطتك متوقفة مؤقتًا';

  @override
  String get bannerPausedSub => 'لم تتم عملية الدفع';

  @override
  String get noteRestoreHint =>
      'مشترك بالفعل على جهاز آخر؟ الاستعادة تعيد اشتراكك إلى هذا الجهاز.';

  @override
  String get noteStoreHandled =>
      'تتم إدارة وسيلة الدفع وتغيير الخطة والإلغاء عبر المتجر.';

  @override
  String noteTrialEnds(String date) {
    return 'تنتهي فترتك التجريبية في $date. ألغِ من المتجر قبل ذلك ولن يُخصم منك شيء.';
  }

  @override
  String get noteGrace =>
      'تستمر مزاياك طوال فترة السماح. الإلغاء لا يُعترض أبدًا داخل التطبيق.';

  @override
  String get noteHold =>
      'Premium متوقف مؤقتًا حتى تتم عملية الدفع. شخصياتك وتقدمك في أمان.';

  @override
  String noteEnding(String date) {
    return 'خطتك على وشك الانتهاء. تستمر المزايا حتى $date، ثم تنتقل إلى Free. يمكنك إعادة الاشتراك في أي وقت.';
  }

  @override
  String get trialExpiredTitle => 'انتهت تجربة Premium';

  @override
  String get trialExpiredSub => 'أنت الآن على Free';

  @override
  String get seePlans => 'عرض الخطط';

  @override
  String get currentPlanTitle => 'الخطة الحالية';

  @override
  String get perMonthUnit => 'شهريًا';

  @override
  String get planTaglineFree => '5 دقائق من المكالمات يوميًا. مجانًا.';

  @override
  String get bulletProCorrections => 'تصحيحات مصممة حسب لغتك الأم';

  @override
  String get bulletFreeCall => '5 دقائق من المكالمات الصوتية يوميًا';

  @override
  String get bulletFreeCheck => 'تحليل كامل لأول 3 مكالمات';

  @override
  String get bulletFreeCharacter => 'شخصيتان للبداية';

  @override
  String get ctaTurnOnVideo => 'فعّل الفيديو';

  @override
  String get noteCallLength =>
      'Premium: 15 دقيقة يوميًا — اتصل كلما أردت ضمن هذا الوقت.';

  @override
  String get paywallProTitle1 => 'صديقك الكوري';

  @override
  String get paywallProTitle2 => 'المستيقظ في الثالثة فجرًا';

  @override
  String get paywallLimitHeadline =>
      'يمنحك Premium 15 دقيقة من المكالمات يوميًا.';

  @override
  String get limitBannerCallTitle => 'انتهى وقت مكالمات اليوم';

  @override
  String get limitBannerCallSub => 'Free يمنحك 5 دقائق من المكالمات يوميًا';

  @override
  String get limitBannerCheckTitle => 'كان هذا فحص اليوم';

  @override
  String get limitBannerCheckSub => 'Free يمنحك فحصًا واحدًا يوميًا';

  @override
  String get bulletProCharactersForever =>
      'الشخصيات التي تشتريها تبقى لك إلى الأبد';

  @override
  String get paywallMaxTitle => 'الآن يمكنك التحدث وجهًا لوجه عبر الفيديو.';

  @override
  String paywallTutorCompare(String price) {
    return 'ساعة واحدة مع مدرّس تكلّف \$25. شهر من Premium يكلّف $price.';
  }

  @override
  String get planMonthly => 'شهري';

  @override
  String get planAnnual => 'سنوي';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price شهريًا';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth شهريًا';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price شهريًا';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly سنويًا · $perMonth شهريًا';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price شهريًا · يمكنك الإلغاء من المتجر في أي وقت';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price شهريًا · يمكنك الإلغاء من المتجر في أي وقت';
  }

  @override
  String ctaCaptionMaxYearly(String price) {
    return '$price سنويًا · يمكنك الإلغاء من المتجر في أي وقت';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 أيام مجانًا، ثم $price شهريًا · يمكنك الإلغاء من المتجر في أي وقت';
  }

  @override
  String get ctaCaptionAutoRenew => 'يتجدد تلقائيًا حتى الإلغاء.';

  @override
  String get footerTerms => 'الشروط';

  @override
  String get footerPrivacy => 'الخصوصية';

  @override
  String get processingTitle => 'جارٍ تأكيد عملية الشراء';

  @override
  String get processingSub => 'يستغرق هذا عادةً بضع ثوانٍ.';

  @override
  String get successProTitle => 'أنت الآن على Premium.';

  @override
  String get successMaxTitle => 'يمكنك رؤيتهم الآن.';

  @override
  String get successMaxSub =>
      'مكالمات الفيديو مفعّلة. اضغط زر الفيديو في أي مكالمة.';

  @override
  String get ctaStartAVideoCall => 'ابدأ مكالمة فيديو';

  @override
  String get ctaSeeYourSubscription => 'عرض اشتراكك';

  @override
  String successMaxCaption(String price) {
    return 'يُخصم $price شهريًا حتى تلغي. يمكنك الإدارة أو الإلغاء من المتجر في أي وقت.';
  }

  @override
  String get plansErrorTitle => 'تعذّر تحميل الخطط';

  @override
  String get plansErrorSub => 'لم يستجب المتجر.';

  @override
  String get ctaTryAgain => 'حاول مرة أخرى';

  @override
  String get plansErrorCaption => 'لم يُخصم أي مبلغ.';

  @override
  String get ctaKeepMax => 'الاحتفاظ بـ Premium';

  @override
  String get winbackSkip => 'تخطي';

  @override
  String get winbackTitle => 'انتهت خطة Premium الخاصة بك';

  @override
  String get winbackSub => 'أنت الآن على Free — 5 دقائق من المكالمات يوميًا.';

  @override
  String get winbackQuestion => 'هل تخبرنا لماذا غادرت؟';

  @override
  String get winbackReasonExpensive => 'السعر مرتفع جدًا';

  @override
  String get winbackReasonUnused => 'لم أكن أستخدمه بما يكفي';

  @override
  String get winbackReasonMissing => 'تنقصه ميزة أحتاجها';

  @override
  String get winbackReasonOtherApp => 'وجدت تطبيقًا آخر';

  @override
  String get winbackReasonElse => 'سبب آخر';

  @override
  String get ctaSend => 'إرسال';

  @override
  String get ctaNotNow => 'ليس الآن';

  @override
  String get winbackCaption => 'هذا لا يعيد خطتك. أعد الاشتراك من المتجر.';

  @override
  String get ctaContinue => 'متابعة';

  @override
  String get ctaClose => 'إغلاق';

  @override
  String get ovRestoreSuccessTitle => 'عاد Premium';

  @override
  String get ovRestoreSuccessBody =>
      'وجدنا اشتراكك وأعدنا تفعيله على هذا الجهاز.';

  @override
  String get ovRestoreEmptyTitle => 'لا يوجد ما يُستعاد';

  @override
  String get ovRestoreEmptyBody => 'لا يوجد اشتراك نشط مرتبط بحساب المتجر هذا.';

  @override
  String get ovRestoreOtherTitle => 'هذه الخطة تخص حسابًا آخر';

  @override
  String get ovRestoreOtherBody =>
      'هذا الاشتراك نشط بالفعل على حساب BeaverTalk مختلف.';

  @override
  String get ctaSignInThatAccount => 'تسجيل الدخول بذلك الحساب';

  @override
  String get ctaGetHelp => 'طلب المساعدة';

  @override
  String get ovCharacterOfferTitle => 'لست مستعدًا لـ Premium؟';

  @override
  String get ovCharacterOfferBody =>
      'اختر شخصية واحدة واحتفظ بها. شراء لمرة واحدة — بلا اشتراك وبلا تجديد.';

  @override
  String get rowOneCharacter => 'شخصية واحدة';

  @override
  String rowFromPrice(String price) {
    return '$price لكل واحدة';
  }

  @override
  String get rowYoursForever => 'لك إلى الأبد';

  @override
  String get rowNoRenewal => 'بلا تجديد';

  @override
  String get rowWorksOnFree => 'تعمل على Free';

  @override
  String get rowYes => 'نعم';

  @override
  String get ctaSeeCharacters => 'عرض الشخصيات';

  @override
  String get ovNotEligibleTitle => 'لا يوجد ما يُلغى';

  @override
  String get ovNotEligibleBody =>
      'أنت على Free. لا يوجد اشتراك نشط على هذا الحساب.';

  @override
  String get ovCancelDownsellTitle => 'قبل أن تغادر';

  @override
  String get ovCancelDownsellBody =>
      'يتم الإلغاء في المتجر. أمران يستحقان المعرفة.';

  @override
  String get rowPayYearlyInstead => 'ادفع سنويًا بدلًا من ذلك';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price شهريًا';
  }

  @override
  String get rowCharactersYouBought => 'الشخصيات التي اشتريتها';

  @override
  String get rowProRunsUntil => 'يستمر Premium حتى';

  @override
  String get ctaSwitchToYearly => 'التبديل إلى السنوي';

  @override
  String get ctaContinueToStore => 'المتابعة إلى المتجر';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'ادفع سنويًا ووفّر $saved';
  }

  @override
  String get ovAnnualSwitchBody => 'الخطة السنوية أرخص من الدفع الشهري.';

  @override
  String get rowYouSave => 'توفّر';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'سنوي';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'شهري لمدة سنة';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'التبديل إلى الشهري';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'تستمر خطتك السنوية حتى $date. تبدأ الفوترة الشهرية في اليوم التالي.';
  }

  @override
  String get rowMonthlyBillingStarts => 'تبدأ الفوترة الشهرية';

  @override
  String get rowMonthlyLabel => 'شهري';

  @override
  String get rowYearlyWorkedOut => 'كان السنوي يعادل';

  @override
  String get ctaSwitchToMonthly => 'التبديل إلى الشهري';

  @override
  String get ovRefundHelpTitle => 'المتجر هو من يتولى الاسترداد';

  @override
  String get ovRefundHelpBody =>
      'لا يمكننا إصدار المبالغ المستردة بأنفسنا. يراجع المتجر كل طلب.';

  @override
  String get ctaGoToStore => 'الانتقال إلى المتجر';

  @override
  String get ovTrialEndingTitle => 'تنتهي تجربتك غدًا';

  @override
  String get ovTrialEndingBody => 'يستمر Premium ما لم تلغِ. إليك ما سيحدث.';

  @override
  String get rowTrialEnds => 'تنتهي التجربة';

  @override
  String get rowFirstCharge => 'أول خصم';

  @override
  String get rowThenMonthly => 'ثم شهريًا';

  @override
  String get ctaCancelInStore => 'الإلغاء من المتجر';

  @override
  String get ovTrialStartTitle => '7 أيام من Premium، مجانًا';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'مجانًا حتى $date. ثم $price شهريًا، ما لم تلغِ من المتجر.';
  }

  @override
  String get ctaStart7Days => 'ابدأ 7 أيام مجانًا';

  @override
  String get ovOtoTitle => 'أمر أخير قبل أن تبدأ';

  @override
  String get ovOtoBody => 'اختيار موفق. Premium نفسه أرخص إذا دفعت سنويًا.';

  @override
  String get ovFailedDeclinedTitle => 'رُفضت بطاقتك';

  @override
  String get ovFailedDeclinedBody =>
      'لم يتمكن المتجر من إتمام الدفع. لم يُخصم أي مبلغ.';

  @override
  String get ctaUpdatePaymentMethod => 'تحديث وسيلة الدفع';

  @override
  String get ovFailedCanceledTitle => 'أُلغي الدفع';

  @override
  String get ovFailedCanceledBody => 'ما زلت على Free. لم يُخصم أي مبلغ.';

  @override
  String get ovFailedStoreTitle => 'حدث خطأ ما';

  @override
  String get ovFailedStoreBody => 'تعذّر الوصول إلى المتجر. لم يُخصم أي مبلغ.';

  @override
  String get ovAlreadyTitle => 'أنت بالفعل على Premium';

  @override
  String get ovAlreadyBody =>
      'لدى حساب المتجر هذا خطة نشطة. لا يوجد ما يُشترى.';

  @override
  String get ctaSeeMySubscription => 'عرض اشتراكي';

  @override
  String get subCancelTitle => 'إلغاء الاشتراك';

  @override
  String subCancelBody(String date) {
    return 'يستمر Premium حتى $date. بعد ذلك تنتقل إلى Free.';
  }

  @override
  String get subWhatYouLose => 'ما ستفقده';

  @override
  String get benefitScoring => 'تقييم النطق حرفًا بحرف';

  @override
  String get benefitEveryMetric => 'كل مقياس، كل جملة';

  @override
  String get subPaymentTitle => 'تحديث الدفع';

  @override
  String get subPaymentBody =>
      'تعذّر إتمام الدفع. يستمر Premium خلال فترة السماح.';

  @override
  String get subHowToFix => 'كيفية الإصلاح';

  @override
  String get fixStep1 => 'افتح المتجر وحدّث وسيلة الدفع';

  @override
  String get fixStep2 => 'عد إلى التطبيق — تُستأنف خطتك تلقائيًا';

  @override
  String get fixStep3 => 'لن يُخصم أي مبلغ مرتين';

  @override
  String get subResubTitle => 'إعادة الاشتراك';

  @override
  String subResubBody(String date) {
    return 'ينتهي Premium في $date. أعد تفعيل التجديد التلقائي ولن يتغير شيء.';
  }

  @override
  String get subWhatYouKeep => 'ما ستحتفظ به';

  @override
  String get ctaTurnItBackOn => 'إعادة التفعيل';

  @override
  String get flTodayTitle => 'انتهى وقت مكالمات اليوم';

  @override
  String get flTodayBody => 'أكمل من حيث توقفت — الآن.';

  @override
  String get flCheckTitle => 'كان هذا فحص اليوم';

  @override
  String get flCheckBody =>
      'تتضمن الخطة المجانية فحصًا واحدًا يوميًا. يمنحك Premium التحليل الكامل.';

  @override
  String flCaption(String price) {
    return '$price شهريًا · يمكنك الإلغاء في أي وقت';
  }

  @override
  String flUsage(String used, String limit) {
    return 'استُخدم $used من $limit';
  }

  @override
  String get ctaMaybeTomorrow => 'ربما غدًا';

  @override
  String get accountSection => 'الحساب';

  @override
  String get nicknameLabel => 'الاسم المستعار';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get loginMethodLabel => 'طريقة تسجيل الدخول';

  @override
  String get joinedLabel => 'تاريخ الانضمام';

  @override
  String get editNicknameTitle => 'تعديل الاسم المستعار';

  @override
  String get nicknameRule => 'من 2 إلى 12 حرفًا. أحرف وأرقام. بالإنجليزية فقط';

  @override
  String get ctaSave => 'حفظ';

  @override
  String get subscriptionRow => 'الاشتراك';

  @override
  String get iapSuccessTitle => 'اكتمل الشراء';

  @override
  String iapSuccessBody(String name) {
    return 'الأفاتار $name لك إلى الأبد.\nيُطبَّق فور تأكيد الإيصال.';
  }

  @override
  String get ctaGoHome => 'إلى الرئيسية';

  @override
  String get ctaUseNow => 'استخدمه الآن';

  @override
  String get iapFailTitle => 'لم تكتمل عملية الدفع';

  @override
  String get iapFailBody => 'يمكنك المحاولة مرة أخرى';

  @override
  String get paywallGuardTitle => 'يمكنك الاستمرار في استخدام Free';

  @override
  String get paywallGuardBody => 'لا تزال لديك 5 دقائق من المكالمات يوميًا.';

  @override
  String get ctaMaybeLater => 'ربما لاحقًا';

  @override
  String get winbackOfferBadge => 'خصم 50% على الشهر الأول';

  @override
  String get winbackOfferTitle => 'أهلًا بعودتك';

  @override
  String get ctaGetHalfOff => 'احصل على خصم 50%';

  @override
  String get iapCharacterSuccessTitle => 'انضم إليك صديق جديد!';

  @override
  String get iapCharacterSuccessBody =>
      'هذه الشخصية ملكك للأبد — تبقى حتى لو تغيّرت خطتك، ويمكن استعادتها على أي جهاز عبر استعادة المشتريات.';

  @override
  String get iapCharacterFailedBody =>
      'لم تكتمل عملية الشراء. لم يتم خصم أي مبلغ — يرجى المحاولة مرة أخرى.';

  @override
  String get noAccentDataTitle => 'لا توجد بيانات نبرة بعد';

  @override
  String get noAccentDataBody => 'تابع المحادثة وستتراكم سمات نبرتك.';

  @override
  String get noLevelYetTitle => 'لا يوجد مستوى بعد';

  @override
  String get noLevelYetBody => 'أنهِ مكالمتك الأولى للحصول على مستواك.';

  @override
  String get noPronunciationDataTitle => 'لا توجد سجلات نطق بعد';

  @override
  String get noPronunciationDataBody =>
      'نحلل نطقك من الجمل التي تقولها أثناء المكالمة.';

  @override
  String get noCharacterNote => 'لم يُترك أي كلام بعد';

  @override
  String get noPhonemesYet => 'لا توجد أصوات للتحليل بعد';

  @override
  String get noSentencesYet => 'لا توجد جمل للتحليل بعد';

  @override
  String get takeLevelTest => 'خوض اختبار المستوى';

  @override
  String get playAgain => 'العب مرة أخرى';

  @override
  String get difficultySlow => 'بطيء';

  @override
  String get difficultyNormal => 'عادي';

  @override
  String get difficultyFast => 'سريع';

  @override
  String get difficultyLabel => 'الصعوبة';

  @override
  String get connected => 'متصل';

  @override
  String get unlockedWithMax => 'مضمّن في خطتك';

  @override
  String get fcEndedTitle => 'انتهت مكالمتك المجانية';

  @override
  String get fcEndedBody =>
      'المكالمات المجانية تصل إلى 5 دقائق\nاشترك لمواصلة الحديث لفترة أطول';

  @override
  String get ctaSubscribeKeepTalking => 'اشترك وواصل الحديث';

  @override
  String get kgTitle => 'هل نكمل؟';

  @override
  String get kgBody =>
      'تستمر المكالمات على فترات قصيرة.\nسنسألك مرة أخرى في كل مرة.';

  @override
  String get pcEndedTitleToday => 'لننهِ مكالمة اليوم.';

  @override
  String get pcEndedBodyToday => 'راجع ما تحدثنا عنه، واتصل بي مجددًا غدًا!';

  @override
  String get pcEndedTitle => 'لننهِ هذه المكالمة.';

  @override
  String get pcEndedBody => 'راجع ما تحدثنا عنه، واتصل بي مجددًا!';

  @override
  String get ctaKeepTalking => 'مواصلة الحديث';

  @override
  String get callModeSheetTitle => 'كيف تريد أن تتحدث؟';

  @override
  String get callModeSheetSubtitle => 'يُطبَّق على هذه المكالمة فورًا';

  @override
  String get callModeFreeTalk => 'محادثة حرة';

  @override
  String get callModeFreeTalkDesc => 'تحدث بحرية دون تصحيح';

  @override
  String get callModeStudy => 'التعلّم';

  @override
  String get callModeStudyDesc => 'تعلّم تعبيرًا واحدًا في كل مرة';

  @override
  String get callModeChange => 'تغيير الوضع';

  @override
  String get callModeKeep => 'ليس الآن';

  @override
  String get callExitTitle => 'هل تريد إنهاء المكالمة؟';

  @override
  String get callExitSubtitle =>
      'حتى لو أنهيت الآن، يُحتسب وقت حديثك ضمن استخدام اليوم';

  @override
  String get callExitKeep => 'متابعة الحديث';

  @override
  String get callExitConfirm => 'إنهاء المكالمة';

  @override
  String get callMicMute => 'كتم الصوت';

  @override
  String get callMicUnmute => 'إلغاء الكتم';

  @override
  String get callPushToTalk => 'اضغط مع الاستمرار للتحدث';

  @override
  String get callFreeEndedTitle => 'انتهت مكالمتك المجانية';

  @override
  String get callFreeEndedCta => 'اشترك وتابع الحديث';

  @override
  String get callKeepGoingTitle => 'هل نكمل؟';

  @override
  String get callKeepGoingSubtitle =>
      'تستمر المكالمات على دفعات من 5 دقائق. سنسألك في كل مرة.';

  @override
  String get articulationSelectedWord => 'الكلمة المختارة';

  @override
  String get articulationYouSaid => 'نطقك';

  @override
  String get articulationTargetSound => 'الهدف';

  @override
  String get reportEntry => 'إبلاغ';

  @override
  String get reportTitle => 'إبلاغ';

  @override
  String get reportPrompt => 'ما المشكلة التي واجهتها؟';

  @override
  String get reportGuide =>
      'أخبرنا عن المحتوى الذي أزعجك من شخصية الذكاء الاصطناعي. نراجع كل بلاغ.';

  @override
  String get reportReasonSexual => 'محتوى جنسي';

  @override
  String get reportReasonHate => 'كراهية أو تمييز';

  @override
  String get reportReasonViolence => 'محتوى عنيف أو تهديدي';

  @override
  String get reportReasonSelfHarm => 'يشجع على إيذاء النفس';

  @override
  String get reportReasonMisinfo => 'معلومات خاطئة';

  @override
  String get reportReasonOther => 'مشكلة أخرى';

  @override
  String get reportDetailHint => 'صف ما حدث (اختياري)';

  @override
  String get reportSubmit => 'إرسال البلاغ';

  @override
  String get reportDoneTitle => 'تم استلام بلاغك';

  @override
  String get reportDoneBody =>
      'سنراجعه ونتخذ الإجراء اللازم. شكرًا لمساعدتك في الحفاظ على أمان BeaverTalk.';

  @override
  String get reportFailed => 'تعذّر إرسال البلاغ. حاول مرة أخرى.';

  @override
  String get hwTitle => 'الواجب';

  @override
  String get hwJoinCodeTitle => 'أدخل رمز صفّك';

  @override
  String get hwJoinCodeSubtitle =>
      'هو الرمز المكوّن من 6 خانات الذي أعطاه لك معلّمك';

  @override
  String get hwJoinCodeLabel => 'رمز الصف';

  @override
  String get hwJoinCodeHelp => 'الرمز لا يفرّق بين الأحرف الكبيرة والصغيرة';

  @override
  String get hwJoinConfirmTitle => 'هل هذا هو الصف الصحيح؟';

  @override
  String get hwJoinConfirmSubtitle => 'إن لم يكن كذلك، تحقّق من الرمز مرة أخرى';

  @override
  String get hwJoinFieldInstitution => 'المؤسسة';

  @override
  String get hwJoinFieldTeacher => 'المعلّم';

  @override
  String get hwJoinFieldLearners => 'المتعلّمون';

  @override
  String get hwJoinFieldTerm => 'الفصل';

  @override
  String get hwJoinConfirmNote =>
      'يظهر اسم الصف كما كتبه معلّمك تمامًا. نحن لا نترجمه.';

  @override
  String get hwJoinConfirmYes => 'نعم، هو هذا';

  @override
  String get hwJoinConfirmRetry => 'إعادة إدخال الرمز';

  @override
  String get hwJoinProfileTitle => 'ما الاسم الذي ستستخدمه في الصف؟';

  @override
  String get hwJoinProfileSubtitle => 'يطابقه معلّمك مع كشف الأسماء';

  @override
  String get hwJoinNameLabel => 'الاسم';

  @override
  String get hwJoinNameHelp => 'يمكن أن يختلف عن اسمك في التطبيق';

  @override
  String get hwJoinStudentNoLabel => 'رقم الطالب (اختياري)';

  @override
  String get hwJoinStudentNoHelp => 'يستخدمه معلّمك لمطابقة كشف الأسماء';

  @override
  String get hwJoinConsentTitle => 'ما يراه معلّمك';

  @override
  String get hwJoinConsentSubtitle => 'عليك الموافقة للانضمام إلى الصف';

  @override
  String get hwJoinConsentSharedHeading => 'يُشارَك مع معلّمك';

  @override
  String get hwJoinConsentShared1 => 'اسم الصف ورقم الطالب';

  @override
  String get hwJoinConsentShared2 => 'ما إذا كنت قد أنجزت الواجب';

  @override
  String get hwJoinConsentShared3 => 'الجمل التي نجحت فيها والتي أخفقت';

  @override
  String get hwJoinConsentShared4 => 'مدة مكالمة الواجب وملخّصها';

  @override
  String get hwJoinConsentNotSharedHeading => 'لا يُشارَك';

  @override
  String get hwJoinConsentNotShared1 => 'البريد الإلكتروني ورقم الهاتف';

  @override
  String get hwJoinConsentNotShared2 => 'اسم التطبيق والملف الشخصي والشخصية';

  @override
  String get hwJoinConsentNotShared3 => 'الجنسية واللغة الأم';

  @override
  String get hwJoinConsentNotShared4 => 'المكالمات والدراسة خارج الصف';

  @override
  String get hwJoinConsentNotShared5 => 'بيانات الاشتراك والدفع';

  @override
  String get hwJoinConsentAgree => 'أوافق على ما سبق';

  @override
  String get hwJoinConsentCta => 'الموافقة والانضمام';

  @override
  String hwJoinDoneTitle(String className) {
    return 'انضممت إلى $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'ينتظرك $count واجب';
  }

  @override
  String get hwJoinDoneNoAssignment => 'لا توجد واجبات بعد';

  @override
  String get hwJoinDoneNextDue => 'الموعد التالي';

  @override
  String get hwJoinDoneRosterName => 'اسمك في الصف';

  @override
  String get hwJoinDoneCta => 'عرض الواجبات';

  @override
  String get hwJoinErrorNotFound => 'لم نعثر على هذا الرمز';

  @override
  String get hwJoinErrorNotFoundBody =>
      'يُرجى التحقق من الأرقام الستة مرة أخرى.';

  @override
  String get hwJoinErrorExpired => 'انتهت صلاحية هذا الرمز';

  @override
  String get hwJoinErrorExpiredBody => 'اطلب رمزًا جديدًا من معلّمك.';

  @override
  String get hwJoinErrorFull => 'الصف مكتمل';

  @override
  String get hwJoinErrorFullBody => 'يُرجى إبلاغ معلّمك.';

  @override
  String get hwJoinFailed => 'تعذّر الانضمام. حاول مرة أخرى بعد قليل.';

  @override
  String get hwSectionInProgress => 'قيد التنفيذ';

  @override
  String get hwSectionUpcoming => 'قادم';

  @override
  String get hwSectionDone => 'منجز';

  @override
  String get hwLeaveClassLink => 'مغادرة الصف';

  @override
  String get hwListEmptyTitle => 'لا توجد واجبات بعد';

  @override
  String get hwListEmptyBody => 'ستظهر هنا عندما يكلّفك معلّمك بها.';

  @override
  String get hwListFailed => 'تعذّر تحميل واجباتك.';

  @override
  String get hwRetry => 'إعادة المحاولة';

  @override
  String get hwBadgeDone => 'منجز';

  @override
  String get hwBadgeOverdue => 'لم يُسلَّم';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'لم يُسلَّم، متأخر $days يوم';
  }

  @override
  String hwBadgeDday(int days) {
    return 'باقٍ $days يوم';
  }

  @override
  String get hwBadgeDueToday => 'موعده اليوم';

  @override
  String get hwActivitySpeaking => 'المحادثة';

  @override
  String get hwActivityConversation => 'حوار';

  @override
  String get hwActivityWorkbook => 'كتاب التمارين';

  @override
  String hwChapterLabel(String chapter) {
    return 'الفصل $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'تحقّق من درجة نطقك';

  @override
  String get hwTaskConversationDesc => 'استخدم ما تعلّمته في حديث حقيقي';

  @override
  String get hwConversationOnce => 'المحادثة تُجرى مرة واحدة فقط لكل واجب.';

  @override
  String get hwTaskWorkbookDesc => 'تدرّب بالكتابة في كتاب التمارين';

  @override
  String get hwCtaStudy => 'ابدأ';

  @override
  String get hwCtaResult => 'عرض النتيجة';

  @override
  String get hwCtaDownload => 'تنزيل';

  @override
  String get hwSpeakingNoScore => 'لم تنجز مهمة المحادثة بعد';

  @override
  String get hwWorkbookUnavailable => 'ملف كتاب التمارين غير متاح بعد.';

  @override
  String get hwDetailClosed => 'أُغلق هذا الواجب. لم يعد بإمكانك التسليم.';

  @override
  String get hwLeaveTitle => 'مغادرة الصف؟';

  @override
  String get hwLeaveBody => 'لن يرى معلّمك نتائج واجباتك بعد الآن.';

  @override
  String get hwLeaveConfirm => 'مغادرة';

  @override
  String get hwLeaveCancel => 'البقاء';

  @override
  String get hwLeaveFailed => 'تعذّرت مغادرة الصف.';

  @override
  String get hwMyClass => 'صفّي';

  @override
  String get hwClassEmptyTitle => 'لم تنضم إلى أي صف';

  @override
  String get hwClassEmptySubtitle => 'أدخل الرمز الذي أعطاه لك معلّمك';

  @override
  String get hwClassEmptyCta => 'إدخال رمز الصف';

  @override
  String get hwClassContinueCta => 'متابعة';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count واجب موعده غدًا';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'لديك $count واجب لم يُسلَّم';
  }

  @override
  String get hwSpeakingUnavailable => 'جمل هذا الواجب غير متاحة بعد.';

  @override
  String get hwBadgeClosed => 'مغلق';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return 'نجحت في $passed من $total جملة';
  }

  @override
  String get challengeFirstWord => 'الكلمة الأولى';

  @override
  String get challengeSeeAnalysis => 'عرض النتائج';

  @override
  String get challengePaused => 'متوقف مؤقتًا';

  @override
  String get challengePausedNote => 'توقّف المؤقت والتسجيل معًا.';

  @override
  String get challengeTimeLeft => 'الوقت المتبقي';

  @override
  String get challengeScoreLabel => 'النقاط';

  @override
  String get challengeResume => 'متابعة';

  @override
  String get challengeBlockedTitle => 'تعذّر استخدام الكاميرا';

  @override
  String get challengeBlockedNote =>
      'فعّل إذن الكاميرا والميكروفون من الإعدادات.';

  @override
  String get challengeGoBack => 'رجوع';

  @override
  String get challengeOpenSettings => 'فتح الإعدادات';

  @override
  String get saveDone => 'تم الحفظ في المعرض';

  @override
  String get saveFailed => 'تعذّر الحفظ';

  @override
  String get saveDeniedNote => 'يلزم إذن الوصول إلى الصور';

  @override
  String get callIncomingCallerFallback => 'المعلّم بيفر';

  @override
  String get callIncomingHandle => 'مكالمة بالكورية';

  @override
  String get callMissedTitle => 'مكالمة فائتة';

  @override
  String get callMissedChannelDescription => 'يخبرك عند تفويت مكالمة من بيفر.';

  @override
  String callMissedBody(String name) {
    return 'حاول $name الاتصال بك';
  }

  @override
  String get callBeaverFallbackName => 'بيفر';

  @override
  String get callNotifPermissionRationale =>
      'إذن الإشعارات مطلوب لاستقبال المكالمات.';

  @override
  String get callNotifPermissionRequired =>
      'يرجى السماح بالإشعارات في الإعدادات.';

  @override
  String get callHintLockedTitle => 'التلميحات غير متاحة في وضع التعلّم';

  @override
  String get wsTitle => 'الأصوات الصعبة';

  @override
  String get wsToList => 'إلى القائمة';

  @override
  String get wsNext => 'التالي';

  @override
  String get wsRetry => 'حاول مرة أخرى';

  @override
  String get wsDone => 'تم';

  @override
  String get wsContinue => 'متابعة';

  @override
  String get wsQuit => 'خروج';

  @override
  String get wsRetryLater => 'يرجى المحاولة مرة أخرى بعد قليل.';

  @override
  String get wsMissingTitle => 'لم نجد هذا الصوت';

  @override
  String get wsMissingBody => 'يرجى اختياره من القائمة مرة أخرى.';

  @override
  String get wsListLoadFailed => 'تعذّر تحميل القائمة';

  @override
  String get wsLessonLoadFailed => 'تعذّر تحميل الدرس';

  @override
  String get wsNationalTitle => 'الأصوات الصعبة حسب لكنتك';

  @override
  String get wsNationalPending => 'سنكمل هذا بعد تحليل لكنتك';

  @override
  String get wsNationalPicked => 'اختيرت بناءً على تحليل لكنتك';

  @override
  String get wsNationalEmptyBody => 'أجرِ المزيد من المكالمات وسنحلّل لكنتك.';

  @override
  String get wsMineTitle => 'أصواتي الصعبة';

  @override
  String get wsMineSubtitle => 'الأصوات التي قيست في مكالماتك الأخيرة';

  @override
  String get wsMineEmptyBody => 'تحدّث وراجع، وستتجمع أصواتك الصعبة هنا.';

  @override
  String get wsNoDataYet => 'لا توجد بيانات بعد';

  @override
  String get wsGoToCall => 'ابدأ مكالمة';

  @override
  String get wsRule => 'القاعدة';

  @override
  String get wsRecommended => 'مُقترح';

  @override
  String get wsNotMeasured => 'لم يُقَس';

  @override
  String get wsStepUnderstand => 'الفهم';

  @override
  String get wsStepWords => 'الكلمات';

  @override
  String get wsStepSentence => 'الجملة';

  @override
  String get wsStepTest => 'الاختبار';

  @override
  String get wsQuitTitle => 'هل تريد إيقاف التدريب؟';

  @override
  String get wsQuitBody => 'إذا خرجت الآن، فلن يُحفظ هذا التدريب.';

  @override
  String get wsHowToSound => 'طريقة إخراج الصوت';

  @override
  String get wsPracticeWords => 'تدرّب على الكلمات';

  @override
  String get wsPracticeSentence => 'تدرّب على الجملة';

  @override
  String get wsPracticeAgain => 'مرة أخرى';

  @override
  String get wsStartTest => 'خوض الاختبار النهائي';

  @override
  String get wsThisSentence => 'هذه الجملة';

  @override
  String get wsNoScoreNote => 'لا نتيجة في هذه الخطوة. كرّر بعدنا فقط.';

  @override
  String get wsListen => 'استمع بتركيز';

  @override
  String get wsSayNow => 'الآن كرّر بصوتك';

  @override
  String get wsPracticeDone => 'انتهى التدريب';

  @override
  String get wsPaused => 'متوقف مؤقتًا';

  @override
  String get wsAudioFailed => 'تعذّر تحميل الصوت. اقرأ النص بصوت عالٍ.';

  @override
  String get wsReadAloud => 'اقرأ الجملة أدناه بصوت عالٍ';

  @override
  String get wsTapToStart => 'اضغط للبدء';

  @override
  String get wsTapWhenDone => 'اضغط عند الانتهاء';

  @override
  String get wsScoring => 'جارٍ التقييم';

  @override
  String get wsMicFailed => 'تعذّر فتح الميكروفون.';

  @override
  String get wsMicPermissionBody =>
      'يتطلب هذا الاختبار القراءة بصوت عالٍ، لذا يحتاج إلى الميكروفون. فعّل الوصول إلى الميكروفون من الإعدادات.';

  @override
  String get wsNoSound => 'لم نسمع شيئًا. نحاول مرة أخرى؟';

  @override
  String get wsScoreFailed => 'فشل التقييم. يرجى المحاولة مرة أخرى.';

  @override
  String get wsSomethingWrong => 'حدث خطأ ما.';

  @override
  String get wsLearnDone => 'انتهى الدرس';

  @override
  String get wsRetest => 'أعد الاختبار';

  @override
  String get wsFirstMeasure => 'أول قياس';

  @override
  String get wsFinalTest => 'الاختبار النهائي';

  @override
  String wsPoints(int score) {
    return '$score نقطة';
  }

  @override
  String wsBeforePoints(int score) {
    return 'قبل $score نقطة';
  }

  @override
  String wsGoalPoints(int score) {
    return 'الهدف $score نقطة';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'الهدف · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return 'لكنة $country';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'تكرار $count كلمة';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'تكرار $count جزءًا من الجملة';
  }

  @override
  String get wsStartRecommended => 'ابدأ بالصوت المُقترح';

  @override
  String wsStartRecommendedWith(String label) {
    return 'ابدأ بـ $label';
  }

  @override
  String get wsPointsUnit => 'نقطة';

  @override
  String get wsEnterFromMypage => 'تدرّب على الأصوات الصعبة';

  @override
  String wsGoalOnly(int score) {
    return 'الهدف $score';
  }

  @override
  String wsSoundOf(String label) {
    return 'صوت $label';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. تذكّر هذا الشكل عندما يصادفك في مكالمة.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return 'أصوات يخطئ فيها كثيرًا المتحدثون من $country';
  }
}
