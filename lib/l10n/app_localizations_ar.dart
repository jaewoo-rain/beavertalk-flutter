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
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

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
