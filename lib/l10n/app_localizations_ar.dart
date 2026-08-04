// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'انتهت المكالمة $duration';
  }

  @override
  String get callRatingPrompt => 'كيف كانت مكالمتك؟';

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
  String get review => 'المراجعة';

  @override
  String get pronunciationChallenge => 'تحدي النطق';

  @override
  String get newExpressions => 'تعبيرات جديدة';

  @override
  String get analysisResult => 'نتيجة التحليل';

  @override
  String get noNewExpressions => 'لا توجد تعبيرات جديدة من هذه المحادثة.';

  @override
  String get practice => 'تدرّب';

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
  String get selectACountry => 'اختر دولة';

  @override
  String get selectYourLanguage => 'اختر لغتك';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get permissionTitle => 'اسمح بالأذونات\nلتجربة سلسة';

  @override
  String get permissionSubtitle => 'الأذونات المطلوبة ضرورية لاستخدام الخدمة.';

  @override
  String get permissionMicTitle => 'الميكروفون (مطلوب)';

  @override
  String get permissionMicDesc =>
      'مطلوب للتحدث مع الذكاء الاصطناعي بالإنجليزية.';

  @override
  String get permissionNotifTitle => 'الإشعارات (اختياري)';

  @override
  String get permissionNotifDesc =>
      'سنرسل لك تذكيرات التعلّم ومواعيد المكالمات.';

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
  String get navCalendar => 'التقويم';

  @override
  String get navCall => 'مكالمة';

  @override
  String get navStats => 'الإحصاءات';

  @override
  String get myPage => 'صفحتي';

  @override
  String get languageSaveFailed => 'تعذّر حفظ لغتك.';

  @override
  String get accountDeleteFailed => 'تعذّر حذف حسابك.';

  @override
  String get changeAvatar => 'تغيير الأفاتار';

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
  String get changePlan => 'تغيير الخطة';

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
  String get keepUsingPro => 'الاستمرار في استخدام Pro';

  @override
  String get proMembership => 'عضوية Pro';

  @override
  String get pricePerMonth => '12.9 دولار / شهريًا';

  @override
  String get benefitUnlimitedCalls => 'مكالمات غير محدودة';

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
  String get challengeLoadingNote =>
      'جارٍ تنزيل نموذج التعرف على الكلام الكوري (~82 ميجابايت) عند التشغيل الأول.\nيرجى الانتظار قليلاً.';

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
  String get callNow => 'اتصل الآن';

  @override
  String get pronunciation => 'النطق';

  @override
  String get fluency => 'الطلاقة';

  @override
  String get rhythm => 'الإيقاع';

  @override
  String get analysisTimeout =>
      'يستغرق هذا وقتًا أطول من المتوقع. يرجى المحاولة مرة أخرى بعد قليل.';

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
  String get loginKakaoSignInFailed => 'فشل تسجيل الدخول عبر Kakao.';

  @override
  String get loginContinueWithKakao => 'المتابعة عبر Kakao';

  @override
  String get loginContinueWithGoogle => 'المتابعة عبر Google';

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
  String subscriptionSwitchNote(String date) {
    return 'يمكنك الاستمرار في استخدام مزايا Pro حتى $date، وبعدها تتحول خطتك تلقائيًا إلى المجانية.';
  }

  @override
  String get freePlanCallLimit => 'مكالمة واحدة يوميًا · حد 5 دقائق';

  @override
  String get freePlanBasicCharacters => 'الشخصيات الأساسية مشمولة';

  @override
  String get availableForPurchase => 'متاح للشراء';

  @override
  String get paymentsLoadError => 'تعذّر تحميل سجل المدفوعات';

  @override
  String get noPayments => 'لا توجد مدفوعات بعد';

  @override
  String get morePaymentsExist => 'لم تُعرض المدفوعات الأقدم بعد';

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
  String get practicePronunciation => 'تدرب على النطق';

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
  String get billingChangePlan => 'تغيير الخطة';

  @override
  String get billingCompareAllPlans => 'مقارنة جميع الخطط';

  @override
  String get billingBuyACharacter => 'شراء شخصية';

  @override
  String get billingRestorePurchases => 'استعادة المشتريات';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'تجربة Max';

  @override
  String get freePlanPriceLine => '\$0.00 — مكالمة واحدة في اليوم';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount شهريًا';
  }

  @override
  String freeUntilDate(String date) {
    return 'مجانًا حتى $date';
  }

  @override
  String get todaysCalls => 'مكالمات اليوم';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'استُخدم $used من $limit';
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
  String get bannerGoUnlimitedTitle => 'انطلق بلا حدود مع Pro';

  @override
  String get bannerGoUnlimitedSub =>
      'مكالمات غير محدودة · 15 دقيقة لكل مكالمة · \$12.90 شهريًا';

  @override
  String get bannerMaxUpsellTitle => 'فعّل الفيديو مع Max';

  @override
  String get bannerMaxUpsellSub => 'مكالمات وجهًا لوجه · \$19.90 شهريًا';

  @override
  String get bannerAnnualSwitchTitle => 'انتقل إلى الخطة السنوية';

  @override
  String get bannerAnnualSwitchSub => '\$159 سنويًا · \$13.25 شهريًا';

  @override
  String get bannerPaymentFailedTitle => 'تعذّر إتمام الدفع';

  @override
  String get bannerPaymentFailedSub =>
      'حدّث وسيلة الدفع في المتجر للحفاظ على Pro';

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
  String get noteFairUse =>
      'يخضع الاستخدام غير المحدود لسياسة الاستخدام العادل لدينا.';

  @override
  String noteTrialEnds(String date) {
    return 'تنتهي فترتك التجريبية في $date. ألغِ من المتجر قبل ذلك ولن يُخصم منك شيء.';
  }

  @override
  String get noteGrace =>
      'تستمر مزاياك طوال فترة السماح. الإلغاء لا يُعترض أبدًا داخل التطبيق.';

  @override
  String get noteHold =>
      'Pro متوقف مؤقتًا حتى تتم عملية الدفع. شخصياتك وتقدمك في أمان.';

  @override
  String noteEnding(String date) {
    return 'خطتك على وشك الانتهاء. تستمر المزايا حتى $date، ثم تنتقل إلى Free. يمكنك إعادة الاشتراك في أي وقت.';
  }

  @override
  String get trialExpiredTitle => 'انتهت تجربة Max';

  @override
  String get trialExpiredSub => 'أنت الآن على Free';

  @override
  String get seePlans => 'عرض الخطط';

  @override
  String get currentPlanTitle => 'الخطة الحالية';

  @override
  String get badgeRecommended => 'موصى بها';

  @override
  String get perMonthUnit => 'شهريًا';

  @override
  String get planTaglinePro => 'مكالمات غير محدودة. 15 دقيقة لكل مكالمة.';

  @override
  String get planTaglineMax => 'الآن يمكنك رؤيتهم.';

  @override
  String get planTaglineFree => 'مكالمة واحدة في اليوم. مجانًا.';

  @override
  String get bulletProCalls => 'مكالمات صوتية بلا حدود';

  @override
  String get bulletProLength => '15 دقيقة لكل مكالمة';

  @override
  String get bulletProScoring => 'تقييم النطق حرفًا بحرف';

  @override
  String get bulletProCorrections => 'تصحيحات مصممة حسب لغتك الأم';

  @override
  String get bulletProBeaverCalls => 'بيفر يتصل بك أولًا';

  @override
  String get bulletMaxVideo => 'مكالمات فيديو وجهًا لوجه';

  @override
  String get bulletMaxEverything => 'كل ما في Pro';

  @override
  String get bulletMaxCharacters => 'جميع الشخصيات، بلا حدود';

  @override
  String get bulletMaxStudyBook => 'كتاب دراسي يناسب مستواك';

  @override
  String get bulletMaxWeeklyReport => 'تقرير أسبوعي عن تطور نطقك';

  @override
  String get bulletFreeCall => 'مكالمة صوتية واحدة مدتها 5 دقائق يوميًا';

  @override
  String get bulletFreeCheck => 'فحص نطق واحد يوميًا';

  @override
  String get bulletFreeAccent => 'فحوصات لهجة غير محدودة';

  @override
  String get bulletFreeCharacter => 'شخصية واحدة للبداية';

  @override
  String get ctaGoUnlimited => 'انطلق بلا حدود';

  @override
  String get ctaTurnOnVideo => 'فعّل الفيديو';

  @override
  String get noteCallLength => 'مدة كل مكالمة 15 دقيقة.';

  @override
  String get paywallProTitle1 => 'صديقك الكوري';

  @override
  String get paywallProTitle2 => 'المستيقظ في الثالثة فجرًا';

  @override
  String get paywallProSub =>
      'مكالمات غير محدودة. 15 دقيقة لكل مكالمة. طوال العام.';

  @override
  String get paywallLimitHeadline => 'Pro يزيل الحد.';

  @override
  String get limitBannerCallTitle => 'كانت هذه مكالمة اليوم';

  @override
  String get limitBannerCallSub => 'Free يمنحك مكالمة واحدة يوميًا';

  @override
  String get limitBannerCheckTitle => 'كان هذا فحص اليوم';

  @override
  String get limitBannerCheckSub => 'Free يمنحك فحصًا واحدًا يوميًا';

  @override
  String get bulletProCharactersForever =>
      'الشخصيات التي تشتريها تبقى لك إلى الأبد';

  @override
  String get paywallMaxTitle => 'الآن يمكنك رؤيتهم.';

  @override
  String get paywallMaxSub =>
      'مكالمات فيديو، وجميع الشخصيات، وكتاب دراسي مصمم لمستواك.';

  @override
  String get planMonthly => 'شهري';

  @override
  String get planAnnual => 'سنوي';

  @override
  String get proMonthlyPriceLine => '\$12.90 شهريًا';

  @override
  String get proAnnualPriceLine => '\$100.00 · \$8.33 شهريًا';

  @override
  String get maxMonthlyPriceLine => '\$19.90 شهريًا';

  @override
  String get maxAnnualPriceLine => '\$159.00 سنويًا · \$13.25 شهريًا';

  @override
  String get ctaCaptionPro =>
      '\$12.90 شهريًا · يمكنك الإلغاء من المتجر في أي وقت';

  @override
  String get ctaCaptionMax =>
      '\$19.90 شهريًا · يمكنك الإلغاء من المتجر في أي وقت';

  @override
  String get footerTerms => 'الشروط';

  @override
  String get footerPrivacy => 'الخصوصية';

  @override
  String get noteMaxCharacters =>
      'الشخصيات المفتوحة عبر Max متاحة ما دام اشتراكك نشطًا. الشخصيات التي اشتريتها تبقى لك.';

  @override
  String get processingTitle => 'جارٍ تأكيد عملية الشراء';

  @override
  String get processingSub => 'يستغرق هذا عادةً بضع ثوانٍ.';

  @override
  String get successProTitle => 'أنت الآن على Pro.';

  @override
  String get successProSub => 'مكالمات غير محدودة، تبدأ الآن.';

  @override
  String get successProBenefit1 => 'اتصل متى شئت — 15 دقيقة لكل مكالمة';

  @override
  String get successProBenefit2 => 'فحوصات نطق غير محدودة';

  @override
  String get successProBenefit3 =>
      'جميع الشخصيات، إضافة إلى المشتريات لمرة واحدة';

  @override
  String get successMaxTitle => 'يمكنك رؤيتهم الآن.';

  @override
  String get successMaxSub =>
      'مكالمات الفيديو مفعّلة. اضغط زر الفيديو في أي مكالمة.';

  @override
  String get successMaxBenefit1 => 'مكالمات فيديو وجهًا لوجه';

  @override
  String get successMaxBenefit2 =>
      'جميع الشخصيات بلا حدود، والجديدة تصلك أولًا';

  @override
  String get successMaxBenefit3 => 'كتاب دراسي يناسب مستواك';

  @override
  String get ctaStartACall => 'ابدأ مكالمة';

  @override
  String get ctaStartAVideoCall => 'ابدأ مكالمة فيديو';

  @override
  String get ctaSeeYourSubscription => 'عرض اشتراكك';

  @override
  String get successProCaption =>
      'يُخصم \$12.90 شهريًا حتى تلغي. يمكنك الإدارة أو الإلغاء من المتجر في أي وقت.';

  @override
  String get successMaxCaption =>
      'يُخصم \$19.90 شهريًا حتى تلغي. يمكنك الإدارة أو الإلغاء من المتجر في أي وقت.';

  @override
  String get plansErrorTitle => 'تعذّر تحميل الخطط';

  @override
  String get plansErrorSub => 'لم يستجب المتجر.';

  @override
  String get ctaTryAgain => 'حاول مرة أخرى';

  @override
  String get plansErrorCaption => 'لم يُخصم أي مبلغ.';

  @override
  String get changePlanTitle => 'تغيير الخطة';

  @override
  String get moveToMaxTitle => 'الانتقال إلى Max';

  @override
  String get maxPriceShort => '\$19.90 / شهر';

  @override
  String get moveToMaxCardSub =>
      'مكالمات فيديو وجهًا لوجه · جميع الشخصيات · كتاب دراسي مصمم لك';

  @override
  String get whatHappensNow => 'ماذا سيحدث الآن';

  @override
  String get maxStartsLabel => 'يبدأ Max';

  @override
  String get immediately => 'فورًا';

  @override
  String get unusedProTime => 'مدة Pro غير المستخدمة';

  @override
  String get creditedTowardMax => 'تُحتسب من قيمة Max';

  @override
  String nextPaymentMaxValue(String date) {
    return '\$19.90 · $date';
  }

  @override
  String nextPaymentProValue(String date) {
    return '\$12.90 · $date';
  }

  @override
  String get ctaSwitchToMax => 'التبديل إلى Max';

  @override
  String get upgradeCaption =>
      'تبدأ خطتك الجديدة فورًا. تُحتسب مدة Pro غير المستخدمة، ولن تُحاسب مرتين أبدًا.';

  @override
  String get moveToProTitle => 'الانتقال إلى Pro';

  @override
  String get moveToProSub =>
      'لن يتغير شيء اليوم. يستمر Max حتى نهاية الشهر الذي دفعته بالفعل.';

  @override
  String get maxRunsUntil => 'يستمر Max حتى';

  @override
  String get proStarts => 'يبدأ Pro';

  @override
  String get whatYouKeep => 'ما ستحتفظ به';

  @override
  String get keepBenefitCalls =>
      'مكالمات صوتية غير محدودة، 15 دقيقة لكل مكالمة';

  @override
  String get keepBenefitCharacters =>
      'الشخصيات التي اشتريتها تبقى لك إلى الأبد';

  @override
  String downgradeWarning(String date) {
    return 'تتوقف مكالمات الفيديو والشخصيات الحصرية لـ Max في $date.';
  }

  @override
  String get ctaSwitchToPro => 'التبديل إلى Pro';

  @override
  String get ctaKeepMax => 'الاحتفاظ بـ Max';

  @override
  String get winbackSkip => 'تخطي';

  @override
  String get winbackTitle => 'انتهت خطة Pro الخاصة بك';

  @override
  String get winbackSub => 'أنت الآن على Free — مكالمة واحدة في اليوم.';

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
  String get ovRestoreSuccessTitle => 'عاد Pro';

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
  String get ovCharacterOfferTitle => 'لست مستعدًا لـ Pro؟';

  @override
  String get ovCharacterOfferBody =>
      'اختر شخصية واحدة واحتفظ بها. شراء لمرة واحدة — بلا اشتراك وبلا تجديد.';

  @override
  String get rowOneCharacter => 'شخصية واحدة';

  @override
  String get rowFromPrice => 'ابتداءً من \$5.00';

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
  String get rowYearlyMonthEquiv => '\$8.33 شهريًا';

  @override
  String get rowCharactersYouBought => 'الشخصيات التي اشتريتها';

  @override
  String get rowProRunsUntil => 'يستمر Pro حتى';

  @override
  String get ctaSwitchToYearly => 'التبديل إلى السنوي';

  @override
  String get ctaContinueToStore => 'المتابعة إلى المتجر';

  @override
  String get ovAnnualSwitchTitle => 'ادفع سنويًا ووفّر \$54.80';

  @override
  String get ovAnnualSwitchBody => 'أنت على Pro منذ شهرين. الخطة السنوية أوفر.';

  @override
  String get rowYouSave => 'توفّر';

  @override
  String get amountSaved => '\$54.80';

  @override
  String get rowYearly => 'سنوي';

  @override
  String get amountYearly => '\$100.00';

  @override
  String get rowMonthlyForYear => 'شهري لمدة سنة';

  @override
  String get amountMonthlyForYear => '\$154.80';

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
  String get ovTrialEndingBody => 'يستمر Max ما لم تلغِ. إليك ما سيحدث.';

  @override
  String get rowTrialEnds => 'تنتهي التجربة';

  @override
  String get rowFirstCharge => 'أول خصم';

  @override
  String get rowThenMonthly => 'ثم شهريًا';

  @override
  String get ctaCancelInStore => 'الإلغاء من المتجر';

  @override
  String get ovTrialStartTitle => '7 أيام من Max، مجانًا';

  @override
  String ovTrialStartBody(String date) {
    return 'مجانًا حتى $date. ثم \$19.90 شهريًا، ما لم تلغِ من المتجر.';
  }

  @override
  String get ctaStart7Days => 'ابدأ 7 أيام مجانًا';

  @override
  String get ovOtoTitle => 'أمر أخير قبل أن تبدأ';

  @override
  String get ovOtoBody =>
      'اختيار موفق — المكالمات غير المحدودة مفعّلة الآن. نفس Pro يكلف أقل عند الدفع سنويًا.';

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
  String get ovAlreadyTitle => 'أنت بالفعل على Pro';

  @override
  String get ovAlreadyBody =>
      'لدى حساب المتجر هذا خطة نشطة. لا يوجد ما يُشترى.';

  @override
  String get ctaSeeMySubscription => 'عرض اشتراكي';

  @override
  String get subCancelTitle => 'إلغاء الاشتراك';

  @override
  String subCancelBody(String date) {
    return 'يستمر Pro حتى $date. بعد ذلك تنتقل إلى Free.';
  }

  @override
  String get subWhatYouLose => 'ما ستفقده';

  @override
  String get benefitCalls15 => 'مكالمات غير محدودة، 15 دقيقة لكل مكالمة';

  @override
  String get benefitScoring => 'تقييم النطق حرفًا بحرف';

  @override
  String get benefitEveryCharacter => 'جميع الشخصيات، بلا حدود';

  @override
  String get ctaKeepPro => 'الاحتفاظ بـ Pro';

  @override
  String get subPaymentTitle => 'تحديث الدفع';

  @override
  String get subPaymentBody => 'تعذّر إتمام الدفع. يستمر Pro خلال فترة السماح.';

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
    return 'ينتهي Pro في $date. أعد تفعيل التجديد التلقائي ولن يتغير شيء.';
  }

  @override
  String get subWhatYouKeep => 'ما ستحتفظ به';

  @override
  String get ctaTurnItBackOn => 'إعادة التفعيل';

  @override
  String get flTodayTitle => 'كانت هذه مكالمة اليوم';

  @override
  String get flTodayBody => 'أكمل من حيث توقفت — الآن.';

  @override
  String get flCheckTitle => 'كان هذا فحص اليوم';

  @override
  String get flCheckBody => 'فحص واحد يوميًا على Free. مع Pro يصبح غير محدود.';

  @override
  String get flBenefitCalls =>
      'مكالمات غير محدودة مع Pro · 15 دقيقة لكل مكالمة';

  @override
  String get flBenefitChecks => 'فحوصات نطق غير محدودة مع Pro';

  @override
  String get flCaption => '\$12.90 شهريًا · يمكنك الإلغاء في أي وقت';

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
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'طريقة تسجيل الدخول';

  @override
  String get joinedLabel => 'Joined';

  @override
  String get editNicknameTitle => 'تعديل الاسم المستعار';

  @override
  String get nicknameRule => 'من 2 إلى 12 حرفًا. أحرف وأرقام. بالإنجليزية فقط';

  @override
  String get ctaSave => 'حفظ';

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
  String get paywallLeaveTitle => 'إذا غادرت الآن، فلن تكون مشتركًا';

  @override
  String get paywallLeaveBody =>
      'تُفتح مزاياك فور إتمام الدفع. يمكنك العودة في أي وقت من صفحتي.';

  @override
  String get ctaKeepLooking => 'متابعة التصفح';

  @override
  String get ctaLeaveAnyway => 'المغادرة على أي حال';

  @override
  String get iapCharacterSuccessTitle => 'انضم إليك صديق جديد!';

  @override
  String get iapCharacterSuccessBody =>
      'هذه الشخصية ملكك للأبد — تبقى حتى لو تغيّرت خطتك، ويمكن استعادتها على أي جهاز عبر استعادة المشتريات.';

  @override
  String get iapCharacterFailedBody =>
      'لم تكتمل عملية الشراء. لم يتم خصم أي مبلغ — يرجى المحاولة مرة أخرى.';
}
