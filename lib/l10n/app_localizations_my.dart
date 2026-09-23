// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get loginRequired => 'အကောင့်ဝင်ရန် လိုအပ်ပါသည်။';

  @override
  String get callWebNotSupported =>
      'ဝဘ်တွင် အသံခေါ်ဆိုမှုကို မပံ့ပိုးပါ။ အက်ပ်ကို အသုံးပြုပါ။';

  @override
  String get micPermissionRequiredForCall =>
      'မိုက်ခရိုဖုန်း ခွင့်ပြုချက် လိုအပ်ပါသည်။ ခေါ်ဆိုရန် မိုက်ခရိုဖုန်းကို ခွင့်ပြုပါ။';

  @override
  String get callErrorGeneric => 'ခေါ်ဆိုနေစဉ် အမှားတစ်ခု ဖြစ်ပွားခဲ့သည်။';

  @override
  String get callDailyLimit => 'ယနေ့ လေ့လာချိန် ကုန်သွားပါပြီ။';

  @override
  String get callAlreadyInCall => 'သင် ဖုန်းခေါ်ဆိုမှုထဲတွင် ရှိနေပြီးဖြစ်သည်။';

  @override
  String get callNetworkError => 'ကွန်ရက် အမှား ဖြစ်ပွားခဲ့သည်။';

  @override
  String get authInvalidCredentials => 'အီးမေးလ် သို့မဟုတ် စကားဝှက် မမှန်ပါ။';

  @override
  String get authEmailAlreadyRegistered =>
      'ဤအီးမေးလ်ကို မှတ်ပုံတင်ပြီးဖြစ်သည်။';

  @override
  String get authConfirmEmailRequired =>
      'သင့်အီးမေးလ်သို့ ပို့ထားသော အတည်ပြုချက်ကို ပြီးမြောက်အောင်လုပ်ပါ။';

  @override
  String get authResetCodeSent =>
      'အတည်ပြုကုဒ်ကို သင့်အီးမေးလ်သို့ ပို့လိုက်ပါပြီ။';

  @override
  String get authResetCodeInvalid =>
      'ကုဒ်မမှန်ပါ သို့မဟုတ် သက်တမ်းကုန်သွားပါပြီ။';

  @override
  String get authPasswordUpdated => 'သင့်စကားဝှက်ကို ပြန်လည်သတ်မှတ်ပြီးပါပြီ။';

  @override
  String get authAppleTokenMissing => 'Apple ဝင်ရောက်မှု တိုကင်ကို မရရှိပါ။';

  @override
  String callEndedDuration(String duration) {
    return 'ခေါ်ဆိုမှု $duration ဖြင့် ပြီးဆုံးပါပြီ';
  }

  @override
  String get callRatingPrompt => 'ခေါ်ဆိုမှု ဘယ်လိုရှိခဲ့လဲ။';

  @override
  String get callRatingBody =>
      'သင့်အဆင့်သတ်မှတ်ချက်က နောက်တစ်ကြိမ် ပိုကောင်းစွာ စကားပြောနိုင်ရန် ကူညီပေးသည်။';

  @override
  String get callRatingSubmit => 'ပို့ရန်';

  @override
  String get callRatingSkip => 'ကျော်ရန်';

  @override
  String get ratingBad => 'သိပ်မကောင်းဘူး';

  @override
  String get ratingOkay => 'ရပါတယ်';

  @override
  String get ratingGood => 'ကောင်းပါတယ်';

  @override
  String get goHome => 'ပင်မစာမျက်နှာ';

  @override
  String get viewAnalysis => 'ဆန်းစစ်ချက် ကြည့်ရန်';

  @override
  String get loadingShort => 'ဖွင့်နေသည်…';

  @override
  String ratingSubmitFailed(String message) {
    return 'အဆင့်သတ်မှတ်ချက် ပေးပို့မှု မအောင်မြင်ပါ- $message';
  }

  @override
  String get callInfoNotFound =>
      'ခေါ်ဆိုမှု အချက်အလက် ရှာမတွေ့သဖြင့် ဆန်းစစ်ခြင်းကို ကျော်လိုက်ပါသည်။';

  @override
  String get tabRecords => 'မှတ်တမ်းများ';

  @override
  String get tabArchive => 'မော်ကွန်း';

  @override
  String get callHistory => 'ခေါ်ဆိုမှု မှတ်တမ်း';

  @override
  String get conversationRecord => 'စကားပြောမှတ်တမ်း';

  @override
  String get noCallRecords => 'ခေါ်ဆိုမှုမှတ်တမ်း မရှိသေးပါ';

  @override
  String get noCallRecordsBody =>
      'AI နှင့် ပထမဆုံးအကြိမ် ခေါ်ဆိုမှု ပြီးဆုံးသည်နှင့်၊\nသင့်မှတ်တမ်းများ ဤနေရာတွင် ပေါ်လာပါမည်။';

  @override
  String get startCall => 'ခေါ်ဆိုမှု စတင်ရန်';

  @override
  String get recordsLoadError => 'မှတ်တမ်းများ ဖွင့်၍မရပါ';

  @override
  String get tryAgainLater => 'ခဏနေ ထပ်ကြိုးစားပါ။';

  @override
  String get retry => 'ထပ်ကြိုးစားရန်';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes မိနစ် $seconds စက္ကန့်';
  }

  @override
  String get scheduleManagement => 'အချိန်ဇယား';

  @override
  String get alarms => 'နှိုးစက်များ';

  @override
  String get alarmAdd => 'နှိုးစက် ထည့်ရန်';

  @override
  String get alarmEdit => 'နှိုးစက် ပြင်ရန်';

  @override
  String get alarmEveryDay => 'နေ့တိုင်း';

  @override
  String get alarmWeekdays => 'ကြားရက်များ';

  @override
  String get alarmWeekend => 'စနေ၊ တနင်္ဂနွေ';

  @override
  String get alarmNoRepeat => 'ထပ်မလုပ်ပါ';

  @override
  String get addSchedule => 'အချိန်ဇယား ထည့်ရန်';

  @override
  String get editSchedule => 'အချိန်ဇယား တည်းဖြတ်ရန်';

  @override
  String get somethingWentWrong => 'တစ်ခုခု မှားယွင်းသွားပါသည်';

  @override
  String get alarmsLoadError => 'နှိုးစက်များ ဖွင့်၍မရပါ';

  @override
  String get charactersLoadError => 'ဇာတ်ကောင်များ ဖွင့်၍မရပါ';

  @override
  String get noCharacters => 'ဇာတ်ကောင် မရှိပါ';

  @override
  String get close => 'ပိတ်ရန်';

  @override
  String get repeat => 'ထပ်ခါထပ်ခါ';

  @override
  String get callPartner => 'ဇာတ်ကောင်';

  @override
  String get quickStart => 'အမြန်စတင်ရန်';

  @override
  String get presetMorning => 'မနက်ပိုင်း ပုံမှန်အလေ့အထ';

  @override
  String get presetMorningSub => 'အလုပ်ရက်များ 8:00';

  @override
  String get presetEvening => 'ညနေပိုင်း အဆုံးသတ်';

  @override
  String get presetEveningSub => 'နေ့တိုင်း 21:00';

  @override
  String get presetCustom => 'စိတ်ကြိုက်';

  @override
  String get presetCustomSub => 'လွတ်လပ်စွာ';

  @override
  String alarmSummary(int count, int monthly) {
    return 'တစ်ပတ် $count ကြိမ် · တစ်လ ခေါ်ဆိုမှု $monthly ကြိမ်';
  }

  @override
  String get alarmSummaryNone => 'အနည်းဆုံး တစ်ရက် ရွေးပါ';

  @override
  String get partnerInUse => 'အသုံးပြုနေသည်';

  @override
  String get partnerOwned => 'ပိုင်ဆိုင်ပြီး';

  @override
  String get am => 'နံနက်';

  @override
  String get pm => 'ညနေ';

  @override
  String get save => 'သိမ်းရန်';

  @override
  String get conversation => 'စကားဝိုင်း';

  @override
  String get review => 'သုံးသပ်ချက်';

  @override
  String get pronunciationChallenge => 'အသံထွက် စိန်ခေါ်မှု';

  @override
  String get newExpressions => 'အသုံးအနှုန်းအသစ်များ';

  @override
  String get usedExpressions => 'သင်သုံးခဲ့သော အသုံးအနှုန်းများ';

  @override
  String quizExpressionsCount(int count) {
    return 'သင်ယူခဲ့သော အသုံးအနှုန်း $count';
  }

  @override
  String get quizPassed => 'မှန်ပါသည်';

  @override
  String get quizFailed => 'ထပ်ကြည့်ရန်';

  @override
  String get quizPending => 'နောက်တစ်ကြိမ် ဆက်ရန်';

  @override
  String get analysisResult => 'ဆန်းစစ်ချက် ရလဒ်';

  @override
  String get noNewExpressions => 'ဤစကားဝိုင်းမှ အသုံးအနှုန်းအသစ် မရှိပါ။';

  @override
  String get practice => 'လေ့ကျင့်ရန်';

  @override
  String recentScore(int score) {
    return 'မကြာသေးမီက ရမှတ် $score%';
  }

  @override
  String callSequence(int count) {
    return '$count ကြိမ်မြောက် ခေါ်ဆိုမှု';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name ၏ စကားတစ်ခွန်း';
  }

  @override
  String characterNoteFooter(String name) {
    return 'ခေါ်ဆိုပြီးသည်နှင့် $name ချန်ထားခဲ့သည်';
  }

  @override
  String newExpressionsCount(int count) {
    return 'အသုံးအနှုန်းသစ် $count';
  }

  @override
  String get analysisLoadError => 'ဆန်းစစ်ချက် ရလဒ် ဖွင့်၍မရပါ။';

  @override
  String get standardAudioNotReady => 'စံအသံထွက် အသံဖိုင် မပြင်ဆင်ရသေးပါ။';

  @override
  String get standardAudioPlayError => 'စံအသံထွက် အသံဖိုင် ဖွင့်၍မရပါ။';

  @override
  String get selectNativeLanguage => 'သင့်မိခင်ဘာသာစကားကို ရွေးချယ်ပါ';

  @override
  String get selectYourLanguage => 'သင့်ဘာသာစကား ရွေးချယ်ပါ';

  @override
  String get confirm => 'အတည်ပြုရန်';

  @override
  String get cancel => 'မလုပ်တော့ပါ';

  @override
  String get selectTime => 'အချိန် ရွေးချယ်ပါ';

  @override
  String get getStarted => 'စတင်လိုက်ပါ';

  @override
  String get permissionTitle =>
      'အဆင်ပြေချောမွေ့စွာ အသုံးပြုနိုင်ရန်\nခွင့်ပြုချက်များ ပေးပါ';

  @override
  String get permissionSubtitle =>
      'ဝန်ဆောင်မှုကို အသုံးပြုရန် လိုအပ်သော ခွင့်ပြုချက်များ ဖြစ်ပါသည်။';

  @override
  String get permissionMicTitle => 'မိုက်ခရိုဖုန်း (လိုအပ်သည်)';

  @override
  String get permissionMicDesc =>
      'AI နှင့် အင်္ဂလိပ်လို စကားပြောရန် လိုအပ်ပါသည်။';

  @override
  String get permissionNotifTitle => 'အကြောင်းကြားချက် (ရွေးချယ်နိုင်သည်)';

  @override
  String get permissionNotifDesc =>
      'လေ့လာမှု သတိပေးချက်များနှင့် ခေါ်ဆိုမှု အချိန်ဇယားများ ပို့ပေးပါမည်။';

  @override
  String get micPermissionNeededTitle =>
      'မိုက်ခရိုဖုန်း ခွင့်ပြုချက် လိုအပ်သည်';

  @override
  String get micPermissionNeededBody =>
      'AI နှင့် စကားပြောရန် မိုက်ခရိုဖုန်း ခွင့်ပြုချက် ပေးရန် လိုအပ်ပါသည်။ ဆက်တင်များတွင် ဖွင့်ပေးပါ။';

  @override
  String get openSettings => 'ဆက်တင်များ ဖွင့်ရန်';

  @override
  String get connectionFailedTitle => 'ချိတ်ဆက်မှု မအောင်မြင်ပါ';

  @override
  String get connectionFailedBody =>
      'သင့်ကွန်ရက်ချိတ်ဆက်မှုကို စစ်ဆေးပြီး\nထပ်ကြိုးစားပါ။';

  @override
  String get checkout => 'ငွေချေရန်';

  @override
  String get pay => 'ငွေပေးချေရန်';

  @override
  String get orderSummary => 'အော်ဒါ အကျဉ်းချုပ်';

  @override
  String get paymentMethod => 'ငွေပေးချေမှု နည်းလမ်း';

  @override
  String get payMethodCard => 'ခရက်ဒစ် / ဒက်ဘစ်ကတ်';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'စိတ်တိုစေသော ဘီဗာ အာဗတား';

  @override
  String get productTrait => 'ပရီမီယံ ဇာတ်ကောင် · အမြဲပိုင်ဆိုင်ရသည်';

  @override
  String get amountItemPrice => 'ကုန်ပစ္စည်းစျေးနှုန်း';

  @override
  String get amountDiscount => 'လျှော့စျေး';

  @override
  String get amountTotal => 'စုစုပေါင်း';

  @override
  String get paymentCompleteTitle => 'ငွေပေးချေမှု ပြီးဆုံးပါပြီ';

  @override
  String get paymentCompleteBody =>
      'အာဗတားကို သင့်စုဆောင်းမှုထဲသို့ ထည့်သွင်းပြီးပါပြီ။';

  @override
  String get viewCollection => 'စုဆောင်းမှု ကြည့်ရန်';

  @override
  String get receiptItem => 'ပစ္စည်း';

  @override
  String get receiptAmount => 'ပမာဏ';

  @override
  String get receiptMethod => 'ငွေပေးချေမှုနည်းလမ်း';

  @override
  String get receiptDate => 'ရက်စွဲ';

  @override
  String get paymentFailedTitle => 'ငွေပေးချေမှု မအောင်မြင်ပါ';

  @override
  String get paymentFailedBody =>
      'သင့်ငွေပေးချေမှုကို ဆောင်ရွက်၍မရပါ။\nထပ်ကြိုးစားပါ။';

  @override
  String get freeCallEndingTitle => 'သင့်အခမဲ့ ခေါ်ဆိုမှု ပြီးတော့မည်';

  @override
  String get freeCallEndingBody =>
      'Beaver နှင့် ပိုကြာကြာ စကားပြောရန် စာရင်းသွင်းပါ။';

  @override
  String get subscribe => 'စာရင်းသွင်းရန်';

  @override
  String get endCall => 'ခေါ်ဆိုမှု ပိတ်ရန်';

  @override
  String get callEnded => 'ခေါ်ဆိုမှု ပြီးဆုံးသွားပါပြီ။';

  @override
  String get connecting => 'ချိတ်ဆက်နေသည်…';

  @override
  String get connectingHint =>
      'များသောအားဖြင့် ၅ စက္ကန့်ထက် နည်းစွာသာ ကြာပါသည်';

  @override
  String get callConnectFailed => 'ခေါ်ဆိုမှု ချိတ်ဆက်၍မရပါ။';

  @override
  String get saveSentenceFailed => 'စာကြောင်းကို သိမ်း၍မရပါ။';

  @override
  String get recordStartFailed => 'အသံဖမ်းခြင်း စတင်၍မရပါ။';

  @override
  String get recordTooShort => 'အသံဖမ်းချက် တိုလွန်းပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get gradingFailed => 'အမှတ်ပေးခြင်း မအောင်မြင်ပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get listenStandard => 'စံအသံထွက် နားထောင်ရန်';

  @override
  String get saveSentence => 'စာကြောင်း သိမ်းရန်';

  @override
  String get unsaveSentence => 'သိမ်းထားသော စာကြောင်း ဖယ်ရှားရန်';

  @override
  String get scoringPronunciation => 'သင့်အသံထွက်ကို အမှတ်ပေးနေသည်…';

  @override
  String get analyzingByWord =>
      'သင့်အသံထွက်ကို စကားလုံးတစ်လုံးချင်း စစ်ဆေးနေသည်';

  @override
  String get analyzingTakingLonger => 'အနည်းငယ် ကြာနေပါသည်';

  @override
  String get scanConnectionLost => 'ချိတ်ဆက်မှု ပြတ်တောက်သွားသည်';

  @override
  String get noRecordingToPlay => 'ဖွင့်ရန် အသံဖမ်းချက် မရှိပါ။';

  @override
  String get myRecordingPlayError => 'သင့်အသံဖမ်းချက် ဖွင့်၍မရပါ။';

  @override
  String get next => 'ရှေ့ဆက်ရန်';

  @override
  String get endLearning => 'သင်ခန်းစာ ရပ်ရန်';

  @override
  String get navCalendar => 'ပြက္ခဒိန်';

  @override
  String get navCall => 'ခေါ်ဆိုမှု';

  @override
  String get navStats => 'စာရင်းအင်း';

  @override
  String get homeCourseExpression => 'အသုံးအနှုန်း';

  @override
  String get homeCourseFreetalk => 'စကားဝိုင်း';

  @override
  String homeExpressionsLeft(int count) {
    return 'စကားဝိုင်းအထိ အသုံးအနှုန်း $count ခုကျန်';
  }

  @override
  String get homeFreetalkNote => 'သင်ယူထားသည်ကို သုံး၍ လွတ်လပ်စွာ စကားပြောပါ';

  @override
  String get homeTalkTitle => 'ဒီနေ့ ဘာတွေဖြစ်ခဲ့လဲ။';

  @override
  String get homeTalkNote => 'လွတ်လပ်စွာ စကားပြောရင်း လေ့လာပါ။';

  @override
  String get homeModeLearn => 'လေ့လာ';

  @override
  String get homeModeTalk => 'စကားပြော';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ဆက်တိုက် $count ရက်',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'လေ့လာမှု ပြက္ခဒိန်';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ရက် ဆက်တိုက်',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'အကောင်းဆုံးမှတ်တမ်း $count ရက်',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'ခေါ်ဆိုချိန်';

  @override
  String get streakMetricCalls => 'ခေါ်ဆိုမှု';

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count မိနစ်',
    );
    return '$_temp0';
  }

  @override
  String streakCallCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ကြိမ်',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'ဤနေ့တွင် ခေါ်ဆိုမှု မရှိပါ။';

  @override
  String get homeLevelPending => 'အဆင့် မသတ်မှတ်ရသေး';

  @override
  String get homeNoLevelTitle => 'သင့်မှာ အဆင့် မရှိသေးပါ';

  @override
  String get homeNoLevelNote => 'ပထမဆုံးခေါ်ဆိုမှုပြီးလျှင် အဆင့်ရပါမည်';

  @override
  String get homeCurriculumPendingBadge => 'မကြာမီ';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language သင်ရိုးကို ပြင်ဆင်နေပါသည်';
  }

  @override
  String get homeCurriculumPendingNote =>
      'ခေါ်ဆိုမှုတွင် အထွေထွေ အသုံးအနှုန်းများ လေ့ကျင့်ပါမည်';

  @override
  String get myPage => 'ကျွန်ုပ်၏စာမျက်နှာ';

  @override
  String get languageSaveFailed => 'သင့်ဘာသာစကားကို သိမ်း၍မရပါ။';

  @override
  String get accountDeleteFailed => 'သင့်အကောင့်ကို ဖျက်၍မရပါ။';

  @override
  String get changeAvatar => 'အာဗတား ပြောင်းရန်';

  @override
  String get avatarUseNow => 'ယခု သုံးမည်';

  @override
  String get avatarPurchaseFailed => 'ဝယ်ယူမှု မအောင်မြင်ပါ';

  @override
  String avatarPromoTitle(int percent) {
    return 'ယနေ့သာ · $percent% လျှော့';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time ကျန်';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days ရက် $time ကျန်';
  }

  @override
  String get avatarIntro =>
      'ခေါ်ဆိုမှု ဘက်ပါတနာအလိုက် အသံနှင့် အခက်အခဲအဆင့် ကွာခြားပါသည်။\nအချို့ဘက်ပါတနာများအတွက် ငွေပေးချေရနိုင်ပါသည်။';

  @override
  String myPartnersOwned(int count) {
    return 'ကျွန်ုပ်၏ ဘက်ပါတနာများ · $count ခု ပိုင်ဆိုင်';
  }

  @override
  String get limitedDiscount => 'ကန့်သတ်ချိန် လျှော့စျေး';

  @override
  String get available => 'ရရှိနိုင်သည်';

  @override
  String get inUse => 'အသုံးပြုနေသည်';

  @override
  String get owned => 'ပိုင်ဆိုင်ပြီး';

  @override
  String get noCharactersToShow => 'ပြသရန် ဇာတ်ကောင် မရှိပါ';

  @override
  String get buy => 'ဝယ်ရန်';

  @override
  String get noSavedSentences =>
      'သိမ်းထားသော စာကြောင်း မရှိသေးပါ။\nသင့်စကားဝိုင်း မှတ်တမ်းများမှ စာကြောင်းများကို မှတ်သားထားပါ။';

  @override
  String get noAlarms => 'နှိုးစက် မရှိသေးပါ';

  @override
  String get noAlarmsBody =>
      'ဆက်တိုက် အလေ့အကျင့်ရရန်\nလေ့လာမှု သတိပေးချက် ထည့်ပါ။';

  @override
  String get subscriptionManage => 'စာရင်းသွင်းမှု စီမံရန်';

  @override
  String get cancelSubscription => 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်';

  @override
  String get benefitsInUse => 'သင့်အကျိုးခံစားခွင့်များ';

  @override
  String get paymentInfo => 'ငွေပေးချေမှု အချက်အလက်';

  @override
  String get nextBillingDate => 'နောက်ငွေတောင်းခံမည့်ရက်';

  @override
  String get lostBenefitsTitle =>
      'ပယ်ဖျက်ပါက ဆုံးရှုံးမည့် အကျိုးခံစားခွင့်များ';

  @override
  String get viewBillingHistory => 'ငွေတောင်းခံမှတ်တမ်း ကြည့်ရန်';

  @override
  String pricePerMonth(String price) {
    return '$price / လ';
  }

  @override
  String get benefitDetailedAnalysis =>
      'အသေးစိတ် အသံထွက်နှင့် သဒ္ဒါ ဆန်းစစ်ချက်';

  @override
  String get benefitAllCharacters => 'ဇာတ်ကောင်အားလုံးကို အသုံးပြုနိုင်ခွင့်';

  @override
  String get benefitNoAds => 'ကြော်ငြာ မပါ';

  @override
  String get playSampleVoice => 'နမူနာအသံ ဖွင့်ရန်';

  @override
  String get useThisAvatar => 'ဤအာဗတားကို သုံးရန်';

  @override
  String get challengeTitle => 'အသံထွက် စိန်ခေါ်မှု';

  @override
  String get challengeIntro =>
      'ဇုန်ထဲက ကတ်တစ်ခုစီကို ကိုရီးယားလို မှန်ကန်စွာ အသံထွက်ပြီး ရှင်းလင်းပါ။\nမိုက်ခရိုဖုန်း မရှိလား။ ဖန်သားပြင်ကို တို့ပြီးလည်း ကစားနိုင်ပါသည်။';

  @override
  String get challengeStart => 'ကင်မရာနှင့် မိုက်ခရိုဖုန်း ဖွင့်ရန်';

  @override
  String get challengePermissionNote =>
      'ရှေ့ကင်မရာနှင့် မိုက်ခရိုဖုန်း ခွင့်ပြုချက် လိုအပ်ပါသည် (ရွေးချယ်နိုင်သည်)။';

  @override
  String get challengeLoadingTitle => 'ဖွင့်နေသည်…';

  @override
  String get challengeLoadingNote =>
      'ကင်မရာနှင့် မိုက်ခရိုဖုန်းကို ပြင်ဆင်နေသည်။';

  @override
  String get challengeSttFallback =>
      'အသံအသိအမှတ်ပြုစနစ် မရရှိနိုင်သဖြင့် တို့ခြင်းဖြင့် ကစားခဲ့ပါသည်။';

  @override
  String get reasonTravelTitle => 'ခရီးသွားစဉ် စကားပြောခြင်း';

  @override
  String get reasonTravelDesc => 'ဒေသခံများနှင့် ယုံကြည်စွာ စကားပြောပါ';

  @override
  String get reasonCareerTitle => 'အလုပ်နှင့် အသက်မွေးဝမ်းကြောင်း';

  @override
  String get reasonCareerDesc => 'စီးပွားရေး စကားဝိုင်း';

  @override
  String get reasonExamTitle => 'စာမေးပွဲ ပြင်ဆင်ခြင်း';

  @override
  String get reasonExamDesc => 'စကားပြော စာမေးပွဲများအတွက် ပြင်ဆင်ပါ';

  @override
  String get reasonDailyTitle => 'နေ့စဉ် စကားဝိုင်း';

  @override
  String get reasonDailyDesc => 'နေ့စဉ်သုံး အသုံးအနှုန်းများ';

  @override
  String get reasonFriendsTitle => 'နိုင်ငံခြားသား သူငယ်ချင်း ရှာခြင်း';

  @override
  String get reasonFriendsDesc => 'သဘာဝကျသော စကားဝိုင်း';

  @override
  String get reasonBrainTitle => 'ဦးနှောက် လှုံ့ဆော်မှု';

  @override
  String get reasonBrainDesc => 'မှတ်ဉာဏ်နှင့် အာရုံစူးစိုက်မှု မြှင့်တင်ပါ';

  @override
  String get challengeRecordToggle => 'ဤအကြိမ် ရိုက်ကူးရန်';

  @override
  String get challengeRecordHint =>
      'မျှဝေရန် သင့်ဂိမ်းကစားမှု ဗီဒီယိုကို သိမ်းဆည်းပါသည် (အသံမပါ)။';

  @override
  String get settingsSection => 'ဆက်တင်များ';

  @override
  String get paymentSection => 'ငွေပေးချေမှု';

  @override
  String get supportSection => 'အကူအညီ';

  @override
  String get userLanguage => 'အသုံးပြုသူ ဘာသာစကား';

  @override
  String get learningLanguage => 'လေ့လာနေသော ဘာသာစကား';

  @override
  String get learningLanguageKorean => 'ကိုရီးယား';

  @override
  String get notificationLabel => 'အကြောင်းကြားချက်';

  @override
  String get currentPlan => 'လက်ရှိအစီအစဉ်';

  @override
  String get paymentHistory => 'ငွေပေးချေမှု မှတ်တမ်း';

  @override
  String get contactUs => 'ဆက်သွယ်ရန်';

  @override
  String get termsOfService => 'ဝန်ဆောင်မှု စည်းမျဉ်းများ';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String get logOut => 'ထွက်ရန်';

  @override
  String get deleteAccount => 'အကောင့် ဖျက်ရန်';

  @override
  String get deleteAccountTitle => 'အကောင့် ဖျက်မှာလား။';

  @override
  String get deleteAccountBody =>
      'ဤလုပ်ဆောင်ချက်သည် သင့်အကောင့်နှင့် ဒေတာများကို အပြီးတိုင် ဖျက်သိမ်းမည်ဖြစ်ပြီး ပြန်လည်ရယူ၍ မရနိုင်ပါ။';

  @override
  String get delete => 'ဖျက်ရန်';

  @override
  String get share => 'မျှဝေရန်';

  @override
  String get accentSoundsLike => 'သင့်ကိုရီးယား အသံဟန်သည်';

  @override
  String get hintLabel => 'အကြံပြုချက်';

  @override
  String get nextHint => 'နောက်အကြံပြုချက်';

  @override
  String get translateLabel => 'ဘာသာပြန်ရန်';

  @override
  String get startRecording => 'အသံဖမ်းစတင်ရန်';

  @override
  String get stopRecording => 'အသံဖမ်းခြင်း ရပ်ရန်';

  @override
  String get back => 'နောက်သို့';

  @override
  String get onboardingNameTitle => 'သင့်ကို ဘယ်လိုခေါ်ရမလဲ။';

  @override
  String get onboardingNameSubtitle =>
      'သင့် AI ဆရာသည် သင့်နာမည်ကို မှတ်ထားပါလိမ့်မည်။';

  @override
  String get nameLabel => 'သင့်နာမည်';

  @override
  String get nameHint => 'သင့်နာမည် ရိုက်ထည့်ပါ';

  @override
  String get nameHelper => 'သင့်အမည်ရင်းဖြစ်စရာမလိုပါ — အမည်ခေါ်လည်း ရပါသည်။';

  @override
  String get continueLabel => 'ဆက်လုပ်ရန်';

  @override
  String get onboardingDoneTitle => 'Beaver က သင့်ခေါ်ဆိုမှုကို စောင့်နေပါသည်';

  @override
  String get onboardingDoneSubtitle => 'ယခုပဲ ခေါ်ဆိုမှု စတင်ပါ';

  @override
  String get home => 'ပင်မစာမျက်နှာ';

  @override
  String get callNow => 'ယခု ခေါ်ဆိုရန်';

  @override
  String get pronunciation => 'အသံထွက်';

  @override
  String get fluency => 'ချောမွေ့မှု';

  @override
  String get rhythm => 'စည်းချက်';

  @override
  String get analysisTimeout =>
      'မျှော်လင့်ထားသည်ထက် အချိန်ကြာနေပါသည်။ ခဏနေ ထပ်ကြိုးစားပါ။';

  @override
  String get analysisFailed => 'စကားဝိုင်းကို ဆန်းစစ်၍မရပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get analyzingConversation => 'သင့်စကားဝိုင်းကို ဆန်းစစ်နေသည်…';

  @override
  String get analyzingSubtitle => 'ခဏသာ ကြာပါလိမ့်မည်';

  @override
  String get tryAgain => 'ထပ်ကြိုးစားပါ';

  @override
  String get nativeLabel => 'မိခင်ဘာသာစကားသုံးသူ';

  @override
  String get meLabel => 'ကျွန်ုပ်';

  @override
  String get pronunciationPlayError => 'အသံထွက် ဖိုင် ဖွင့်၍မရပါ။';

  @override
  String get savedExpressionsLoadError =>
      'သိမ်းထားသော အသုံးအနှုန်းများ ဖွင့်၍မရပါ။';

  @override
  String get mySavedExpressions => 'ကျွန်ုပ် သိမ်းထားသော အသုံးအနှုန်းများ';

  @override
  String get avatarTraits => 'နွေးထွေး · တည်ငြိမ် · နူးညံ့';

  @override
  String get priceFree => 'အခမဲ့';

  @override
  String get loginGoogleTokenError => 'Google အကောင့်ဝင်ရန် တိုကင် ရယူ၍မရပါ။';

  @override
  String get loginGoogleSignInFailed => 'Google အကောင့်ဝင်ခြင်း မအောင်မြင်ပါ။';

  @override
  String get loginAppleSignInFailed => 'Apple အကောင့်ဝင်ခြင်း မအောင်မြင်ပါ။';

  @override
  String get loginFacebookSignInFailed =>
      'Facebook အကောင့်ဝင်ခြင်း မအောင်မြင်ပါ။';

  @override
  String get loginKakaoSignInFailed => 'Kakao အကောင့်ဝင်ခြင်း မအောင်မြင်ပါ။';

  @override
  String get loginContinueWithKakao => 'Kakao ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginContinueWithGoogle => 'Google ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginContinueWithFacebook => 'Facebook ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginContinueWithApple => 'Apple ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginContinueWithEmail => 'အီးမေးလ်ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginOrDivider => 'သို့မဟုတ်';

  @override
  String get loginNoAccount => 'အကောင့် မရှိသေးဘူးလား။';

  @override
  String get signUp => 'အကောင့်ဖွင့်ရန်';

  @override
  String get loginTermsNoticePrefix =>
      'ဆက်လုပ်ခြင်းဖြင့် သင်သည် ကျွန်ုပ်တို့၏ ';

  @override
  String get loginTermsNoticeAnd => ' နှင့် ';

  @override
  String get loginTermsNoticeSuffix => 'ကို သဘောတူပါသည်။';

  @override
  String get loginLogIn => 'လော့ဂ်အင်ဝင်ရန်';

  @override
  String get fieldEmailLabel => 'အီးမေးလ်';

  @override
  String get emailHint => 'သင့်အီးမေးလ် ရိုက်ထည့်ပါ';

  @override
  String get fieldPasswordLabel => 'စကားဝှက်';

  @override
  String get passwordHint => 'သင့်စကားဝှက် ရိုက်ထည့်ပါ';

  @override
  String get loginRememberMe => 'မှတ်ထားပါ';

  @override
  String get loginForgotPassword => 'စကားဝှက် မေ့နေလား။';

  @override
  String get loginLoggingIn => 'လော့ဂ်အင်ဝင်နေသည်...';

  @override
  String get passwordLengthError => 'စကားဝှက်သည် စာလုံး ၈–၁၆ လုံး ရှိရမည်။';

  @override
  String get passwordsDoNotMatch => 'စကားဝှက်များ မတူညီပါ။';

  @override
  String get signupCheckInput => 'သင့်ထည့်သွင်းချက်ကို စစ်ဆေးပါ။';

  @override
  String get fieldConfirmPasswordLabel => 'စကားဝှက် အတည်ပြုရန်';

  @override
  String get confirmPasswordHint => 'သင့်စကားဝှက်ကို ထပ်မံရိုက်ထည့်ပါ';

  @override
  String get signupSigningUp => 'အကောင့်ဖွင့်နေသည်...';

  @override
  String get signupHaveAccount => 'အကောင့် ရှိပြီးသားလား။';

  @override
  String get passwordMethodEmailRequired => 'သင့်အီးမေးလ် ရိုက်ထည့်ပါ';

  @override
  String get passwordResetTitle => 'စကားဝှက် ပြန်လည်သတ်မှတ်ရန်';

  @override
  String get passwordMethodDescription =>
      'စကားဝှက် ပြန်လည်သတ်မှတ်ရန် ကုဒ်ကို လက်ခံလိုသည့် အီးမေးလ်လိပ်စာကို ထည့်ပါ။';

  @override
  String get emailAddressHint => 'အီးမေးလ်လိပ်စာ';

  @override
  String get passwordMethodSending => 'ပို့နေသည်...';

  @override
  String get passwordMethodSendEmail => 'အီးမေးလ် ပို့ရန်';

  @override
  String get passwordCodeTitle => 'ကုဒ် ရိုက်ထည့်ပါ';

  @override
  String get passwordCodeDescription =>
      'သင့်အီးမေးလ်သို့ ပြန်လည်ရယူရေး ကုဒ် ပို့ထားပါသည်။ ဆက်လက်ရန် ၎င်းကို ရိုက်ထည့်ပါ။';

  @override
  String get passwordCodeNoCode => 'ကုဒ် မရသေးဘူးလား။';

  @override
  String get passwordCodeResend => 'ကုဒ် ထပ်ပို့ရန်';

  @override
  String get passwordCodeVerifying => 'အတည်ပြုနေသည်...';

  @override
  String get passwordNewTitle => 'စကားဝှက်အသစ်';

  @override
  String get passwordNewDescription =>
      'သင့်အကောင့်အတွက် စကားဝှက်အသစ် သတ်မှတ်ပါ။';

  @override
  String get fieldNewPasswordLabel => 'စကားဝှက်အသစ်';

  @override
  String get newPasswordHint => 'သင့်စကားဝှက်အသစ် ရိုက်ထည့်ပါ';

  @override
  String get fieldConfirmNewPasswordLabel => 'စကားဝှက်အသစ် အတည်ပြုရန်';

  @override
  String get confirmNewPasswordHint => 'သင့်စကားဝှက်အသစ်ကို ထပ်မံရိုက်ထည့်ပါ';

  @override
  String get passwordNewSubmitting => 'တင်သွင်းနေသည်...';

  @override
  String get passwordNewSubmit => 'တင်သွင်းရန်';

  @override
  String get passwordCompleteTitle =>
      'စကားဝှက် ပြန်လည်သတ်မှတ်မှု ပြီးဆုံးပါပြီ';

  @override
  String get passwordCompleteBody =>
      'သင့်စကားဝှက်ကို ပြန်လည်သတ်မှတ်ပြီးပါပြီ။ ဆက်လက်ရန် သင့်စကားဝှက်အသစ်ဖြင့် လော့ဂ်အင်ဝင်ပါ။';

  @override
  String get termsTitle => 'ဝန်ဆောင်မှု စည်းမျဉ်းများ';

  @override
  String get privacyTitle => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email အတွက် စကားဝှက်အသစ် သတ်မှတ်ပါ။';
  }

  @override
  String get selectComplete => 'ပြီးပါပြီ';

  @override
  String get onboardingLanguageTitle => 'သင့်မိခင်ဘာသာစကားက ဘာလဲ။';

  @override
  String get onboardingReasonTitle => 'သင် ဘာကြောင့် ဘာသာစကားတစ်ခု သင်နေတာလဲ။';

  @override
  String get onboardingReasonSubtitle =>
      'သင့်ရည်မှန်းချက်များနှင့်ကိုက်ညီအောင် သင်ယူမှုကို ချိန်ညှိပေးပါမည်။';

  @override
  String get savingLabel => 'သိမ်းဆည်းနေသည်...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'ဤလ ငွေပေးချေမှု';

  @override
  String get filterAll => 'အားလုံး';

  @override
  String get filterSubscription => 'စာရင်းသွင်းမှု';

  @override
  String get filterCharacter => 'ဇာတ်ကောင်';

  @override
  String get statusCompleted => 'ပြီးဆုံး';

  @override
  String get lastPayment => 'နောက်ဆုံး ငွေပေးချေမှု';

  @override
  String get freePlanCallLimit => 'တစ်ရက် ၁ ကြိမ် · ၅ မိနစ် ကန့်သတ်';

  @override
  String get freePlanBasicCharacters => 'အခြေခံ ဇာတ်ကောင်များ ပါဝင်သည်';

  @override
  String get availableForPurchase => 'ဝယ်ယူနိုင်သည်';

  @override
  String get paymentsLoadError => 'ငွေပေးချေမှု မှတ်တမ်း ဖတ်၍မရပါ';

  @override
  String get noPayments => 'ငွေပေးချေမှု မရှိသေးပါ';

  @override
  String get morePaymentsExist => 'ယခင် ငွေပေးချေမှုများကို မပြသရသေးပါ';

  @override
  String get undatedPayments => 'ရက်စွဲမရှိ';

  @override
  String get paymentLabelFallback => 'ငွေပေးချေမှု';

  @override
  String learningPassed(int passed, int total) {
    return 'ဝါကျ $total ခုအနက် $passed ခု အောင်မြင်';
  }

  @override
  String get hardestSound => 'ယနေ့ အခက်ဆုံး အသံ';

  @override
  String get soundAccuracy => 'အသံအလိုက် တိကျမှု';

  @override
  String phonemeAttempts(int count) {
    return 'အသံအစိတ်အပိုင်းအလိုက် · $count ကြိမ်';
  }

  @override
  String get colSound => 'အသံ';

  @override
  String get colAttempts => 'ကြိမ်';

  @override
  String get colCorrect => 'မှန်';

  @override
  String get colAccuracy => 'တိကျမှု';

  @override
  String get sentenceResults => 'ဝါကျအလိုက် ရလဒ်';

  @override
  String viewAllSentences(int count) {
    return 'အားလုံး $count ကြည့်ရန်';
  }

  @override
  String get colSentence => 'ဝါကျ';

  @override
  String get colPronunciation => 'အသံထွက်';

  @override
  String get colFluency => 'ချောမွေ့';

  @override
  String get colRhythm => 'စည်းချက်';

  @override
  String recentSessions(int count) {
    return 'နောက်ဆုံး $count ကြိမ်';
  }

  @override
  String trendAverage(int score) {
    return 'ပျမ်းမျှ $score';
  }

  @override
  String get today => 'ယနေ့';

  @override
  String get colDate => 'ရက်စွဲ';

  @override
  String get colSentences => 'ဝါကျ';

  @override
  String get colScore => 'ရမှတ်';

  @override
  String get colChange => 'ပြောင်းလဲ';

  @override
  String dateToday(String date) {
    return '$date (ယနေ့)';
  }

  @override
  String get accentAnalysis => 'လေယူလေသိမ်း ခွဲခြမ်းစိတ်ဖြာချက်';

  @override
  String get overallLevel => 'စုစုပေါင်း အဆင့်';

  @override
  String get overallLevelSubtitle => 'ဝေါဟာရ · သဒ္ဒါ · အသုံးအနှုန်း';

  @override
  String get pronunciationAnalysis => 'အသံထွက် ခွဲခြမ်းစိတ်ဖြာချက်';

  @override
  String get recentSessionsAverage => 'နောက်ဆုံး ၁၀ ကြိမ် ပျမ်းမျှ';

  @override
  String levelStage(int stage) {
    return 'အဆင့် $stage';
  }

  @override
  String topPercent(int percent) {
    return 'ထိပ်ဆုံး $percent%';
  }

  @override
  String get allLearnersBasis => 'သင်ယူသူအားလုံးအနက်';

  @override
  String aheadOfLearners(int percent) {
    return 'သင်ယူသူ $percent% ထက် သင်ရှေ့ရောက်နေသည်';
  }

  @override
  String get retakeLevelTest => 'အဆင့်စစ်ဆေးမှု ပြန်ဖြေရန်';

  @override
  String get practicePronunciation => 'အသံထွက် လေ့ကျင့်ရန်';

  @override
  String get priceChangedTitle => 'ဈေးနှုန်းပြောင်းသွားသည်';

  @override
  String priceChangedBody(String price) {
    return 'ဤပစ္စည်းသည် ယခု $price ဖြစ်သည်။ ဆက်လုပ်မလား။';
  }

  @override
  String get billingGroupPlanPurchases => 'အစီအစဉ်နှင့် ဝယ်ယူမှုများ';

  @override
  String get billingGroupInTheStore => 'စတိုးတွင်';

  @override
  String get billingCompareAllPlans => 'အစီအစဉ်များ နှိုင်းယှဉ်ရန်';

  @override
  String get billingBuyACharacter => 'ဇာတ်ကောင် ဝယ်ရန်';

  @override
  String get billingRestorePurchases => 'ဝယ်ယူမှုများ ပြန်လည်ရယူရန်';

  @override
  String get billingRedeemCode => 'ကုဒ်အသုံးပြုရန်';

  @override
  String get billingPaymentHistory => 'ငွေပေးချေမှု မှတ်တမ်း';

  @override
  String get billingManageInTheStore => 'စတိုးတွင် စီမံရန်';

  @override
  String get billingRefundHelp => 'ငွေပြန်အမ်း အကူအညီ';

  @override
  String get billingCancelSubscription => 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်';

  @override
  String get billingResubscribe => 'ပြန်လည် စာရင်းသွင်းရန်';

  @override
  String get badgeCurrent => 'လက်ရှိ';

  @override
  String get badgeTrial => 'အစမ်းသုံး';

  @override
  String get badgeRenewing => 'သက်တမ်းတိုးနေသည်';

  @override
  String get badgePastDue => 'ငွေပေးချေရန် ကျန်နေသည်';

  @override
  String get badgePaused => 'ခေတ္တရပ်ထားသည်';

  @override
  String get badgeCanceling => 'ပယ်ဖျက်နေသည်';

  @override
  String get subscriptionTitle => 'စာရင်းသွင်းမှု';

  @override
  String get plansTitle => 'အစီအစဉ်များ';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo =>
      'တစ်ရက် ဗီဒီယိုခေါ်ဆိုမှု အများဆုံး 3 ကြိမ်၊ တစ်ကြိမ် 15 မိနစ်';

  @override
  String get premiumBulletAnalysis => 'အသံထွက် ခွဲခြမ်းစိတ်ဖြာမှု အပြည့်အစုံ';

  @override
  String get premiumBulletWeakSounds =>
      'သင့်ဘာသာစကားအတွက် အခက်အခဲအသံ လေ့ကျင့်မှု';

  @override
  String get noteCharactersSeparate =>
      'ဇာတ်ကောင်များကို သီးခြားရောင်းသည်။ ဝယ်ထားသော ဇာတ်ကောင်များ သင့်ပိုင်ဖြစ်သည်။';

  @override
  String get ctaGetPremium => 'Premium ရယူရန်';

  @override
  String get planMaxTrial => 'Premium အစမ်းသုံး';

  @override
  String get freePlanPriceLine => '\$0.00 — တစ်နေ့ ခေါ်ဆိုမှုတစ်ကြိမ်';

  @override
  String pricePerMonthLine(String amount) {
    return 'တစ်လလျှင် $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date အထိ အခမဲ့';
  }

  @override
  String get todaysCalls => 'ယနေ့ ခေါ်ဆိုမှုများ';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit ကြိမ်အနက် $used ကြိမ် သုံးပြီး';
  }

  @override
  String get firstPaymentLabel => 'ပထမ ငွေပေးချေမှု';

  @override
  String get nextPaymentLabel => 'နောက်ထပ် ငွေပေးချေမှု';

  @override
  String get retryingUntilLabel => 'ထပ်ကြိုးစားနေမည့်ရက်';

  @override
  String get pausedSinceLabel => 'ရပ်ထားသည့်ရက်';

  @override
  String planEndsLabel(String plan) {
    return '$plan ကုန်ဆုံးမည့်ရက်';
  }

  @override
  String get bannerMaxUpsellTitle =>
      'Premium ဖြင့် မျက်နှာချင်းဆိုင် စကားပြောပါ';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'ဗီဒီယိုခေါ်ဆိုမှု · တစ်ရက် အများဆုံး 3 ကြိမ် · တစ်လ $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'နှစ်စဉ်အစီအစဉ်သို့ ပြောင်းရန်';

  @override
  String get bannerPaymentFailedTitle => 'ငွေပေးချေမှု မအောင်မြင်ပါ';

  @override
  String get bannerPaymentFailedSub =>
      'Premium ဆက်သုံးရန် စတိုးတွင် ငွေပေးချေမှု အပ်ဒိတ်လုပ်ပါ';

  @override
  String get bannerPausedTitle => 'သင့်အစီအစဉ် ခေတ္တရပ်ထားသည်';

  @override
  String get bannerPausedSub => 'ငွေပေးချေမှု မပြီးမြောက်ခဲ့ပါ';

  @override
  String get noteRestoreHint =>
      'အခြားစက်တွင် စာရင်းသွင်းထားပါသလား။ ပြန်လည်ရယူခြင်းဖြင့် ဤစက်တွင် ပြန်ရနိုင်သည်။';

  @override
  String get noteStoreHandled =>
      'ငွေပေးချေနည်း၊ အစီအစဉ်ပြောင်းခြင်းနှင့် ပယ်ဖျက်ခြင်းကို စတိုးက ဆောင်ရွက်သည်။';

  @override
  String noteTrialEnds(String date) {
    return 'သင့်အစမ်းသုံးကာလ $date တွင် ကုန်ဆုံးမည်။ ၎င်းမတိုင်မီ စတိုးတွင် ပယ်ဖျက်ပါက ငွေမကောက်ခံပါ။';
  }

  @override
  String get noteGrace =>
      'ဆိုင်းငံ့ကာလအတွင်း အကျိုးခံစားခွင့်များ ဆက်ရှိသည်။ အက်ပ်ထဲတွင် ပယ်ဖျက်ခြင်းကို ဘယ်တော့မှ မတားဆီးပါ။';

  @override
  String get noteHold =>
      'ငွေပေးချေမှု အောင်မြင်သည်အထိ Premium ခေတ္တရပ်ထားသည်။ သင့်ဇာတ်ကောင်များနှင့် တိုးတက်မှု လုံခြုံပါသည်။';

  @override
  String noteEnding(String date) {
    return 'သင့်အစီအစဉ် ကုန်ဆုံးရန် သတ်မှတ်ထားသည်။ $date အထိ အကျိုးခံစားခွင့်ရှိပြီး ထို့နောက် Free သို့ ပြောင်းမည်။ အချိန်မရွေး ပြန်စာရင်းသွင်းနိုင်သည်။';
  }

  @override
  String get trialExpiredTitle => 'သင့် Premium အစမ်းသုံးကာလ ကုန်ဆုံးပြီ';

  @override
  String get trialExpiredSub => 'ယခု Free တွင် ရှိနေသည်';

  @override
  String get seePlans => 'အစီအစဉ်များ ကြည့်ရန်';

  @override
  String get currentPlanTitle => 'လက်ရှိ အစီအစဉ်';

  @override
  String get perMonthUnit => 'တစ်လလျှင်';

  @override
  String get planTaglineMax => 'ယခု သူတို့ကို မြင်နိုင်ပြီ။';

  @override
  String get planTaglineFree => 'တစ်နေ့ တစ်ကြိမ်။ အခမဲ့။';

  @override
  String get bulletProCorrections => 'သင့်မိခင်ဘာသာစကားအလိုက် ပြင်ဆင်ချက်များ';

  @override
  String get bulletFreeCall => 'တစ်နေ့ ၅ မိနစ် အသံခေါ်ဆိုမှု တစ်ကြိမ်';

  @override
  String get bulletFreeCheck =>
      'ပထမ ခေါ်ဆိုမှု 3 ကြိမ်အတွက် ခွဲခြမ်းစိတ်ဖြာမှု အပြည့်အစုံ';

  @override
  String get bulletFreeCharacter => 'စတင်ရန် ဇာတ်ကောင် 2 ခု';

  @override
  String get ctaTurnOnVideo => 'ဗီဒီယို ဖွင့်ရန်';

  @override
  String get noteCallLength =>
      'Premium: တစ်ရက် အများဆုံး 3 ကြိမ် ခေါ်ဆိုနိုင်၊ တစ်ကြိမ် 15 မိနစ်။';

  @override
  String get paywallProTitle1 => 'သင့်ကိုရီးယား သူငယ်ချင်း';

  @override
  String get paywallProTitle2 => 'နံနက် ၃ နာရီမှာလည်း နိုးနေတယ်';

  @override
  String get paywallLimitHeadline =>
      'Premium ဖြင့် တစ်ရက် အများဆုံး 3 ကြိမ် ခေါ်ဆိုနိုင်သည်။';

  @override
  String get limitBannerCallTitle => 'ယနေ့ ခေါ်ဆိုမှု ပြီးပါပြီ';

  @override
  String get limitBannerCallSub => 'Free တွင် တစ်နေ့ တစ်ကြိမ် ခေါ်ဆိုနိုင်သည်';

  @override
  String get limitBannerCheckTitle => 'ယနေ့ စစ်ဆေးမှု ပြီးပါပြီ';

  @override
  String get limitBannerCheckSub => 'Free တွင် တစ်နေ့ တစ်ကြိမ် စစ်ဆေးနိုင်သည်';

  @override
  String get bulletProCharactersForever =>
      'ဝယ်ထားသော ဇာတ်ကောင်များ ထာဝရ သင့်ပိုင်';

  @override
  String get paywallMaxTitle => 'ယခု သူတို့ကို မြင်နိုင်ပြီ။';

  @override
  String paywallTutorCompare(String price) {
    return 'ဆရာနှင့် တစ်နာရီ \$25 ကျသင့်သည်။ Premium တစ်လ $price ကျသင့်သည်။';
  }

  @override
  String get planMonthly => 'လစဉ်';

  @override
  String get planAnnual => 'နှစ်စဉ်';

  @override
  String proMonthlyPriceLine(String price) {
    return 'တစ်လ $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · တစ်လ $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'တစ်လ $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'တစ်နှစ် $yearly · တစ်လ $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'တစ်လ $price · စတိုးတွင် အချိန်မရွေး ပယ်ဖျက်နိုင်';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'တစ်လ $price · စတိုးတွင် အချိန်မရွေး ပယ်ဖျက်နိုင်';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '၇ ရက် အခမဲ့၊ ထို့နောက် တစ်လ $price · စတိုးတွင် အချိန်မရွေး ပယ်ဖျက်နိုင်';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'ပယ်ဖျက်သည်အထိ အလိုအလျောက် သက်တမ်းတိုးပါမည်။';

  @override
  String get footerTerms => 'စည်းမျဉ်းများ';

  @override
  String get footerPrivacy => 'ကိုယ်ရေးလုံခြုံမှု';

  @override
  String get processingTitle => 'သင့်ဝယ်ယူမှုကို အတည်ပြုနေသည်';

  @override
  String get processingSub => 'ပုံမှန်အားဖြင့် စက္ကန့်အနည်းငယ် ကြာသည်။';

  @override
  String get successProTitle => 'ယခု Premium ဖြစ်ပါပြီ။';

  @override
  String get successMaxTitle => 'ယခု သူတို့ကို မြင်နိုင်ပြီ။';

  @override
  String get successMaxSub =>
      'ဗီဒီယိုခေါ်ဆိုမှု ဖွင့်ပြီးပြီ။ မည်သည့်ခေါ်ဆိုမှုတွင်မဆို ဗီဒီယိုခလုတ်ကို နှိပ်ပါ။';

  @override
  String get ctaStartAVideoCall => 'ဗီဒီယိုခေါ်ဆိုမှု စတင်ရန်';

  @override
  String get ctaSeeYourSubscription => 'သင့်စာရင်းသွင်းမှု ကြည့်ရန်';

  @override
  String successMaxCaption(String price) {
    return 'မပယ်ဖျက်မချင်း တစ်လ $price ကောက်ခံသည်။ စတိုးတွင် အချိန်မရွေး စီမံ သို့မဟုတ် ပယ်ဖျက်နိုင်သည်။';
  }

  @override
  String get plansErrorTitle => 'အစီအစဉ်များ ဖွင့်၍မရပါ';

  @override
  String get plansErrorSub => 'စတိုးမှ တုံ့ပြန်မှု မရပါ။';

  @override
  String get ctaTryAgain => 'ထပ်ကြိုးစားရန်';

  @override
  String get plansErrorCaption => 'ငွေမကောက်ခံခဲ့ပါ။';

  @override
  String get ctaKeepMax => 'Premium ဆက်ထားရန်';

  @override
  String get winbackSkip => 'ကျော်ရန်';

  @override
  String get winbackTitle => 'သင့် Premium အစီအစဉ် ကုန်ဆုံးပြီ';

  @override
  String get winbackSub => 'ယခု Free တွင် — တစ်နေ့ တစ်ကြိမ်။';

  @override
  String get winbackQuestion => 'ဘာကြောင့် ရပ်လိုက်သလဲ ပြောပြပေးမလား။';

  @override
  String get winbackReasonExpensive => 'ဈေးကြီးလွန်းသည်';

  @override
  String get winbackReasonUnused => 'လုံလောက်အောင် မသုံးဖြစ်ပါ';

  @override
  String get winbackReasonMissing => 'လိုအပ်သော လုပ်ဆောင်ချက် မရှိပါ';

  @override
  String get winbackReasonOtherApp => 'အခြားအက်ပ် တွေ့ပြီ';

  @override
  String get winbackReasonElse => 'အခြားအကြောင်း';

  @override
  String get ctaSend => 'ပို့ရန်';

  @override
  String get ctaNotNow => 'ယခုမဟုတ်သေး';

  @override
  String get winbackCaption =>
      'ဤအရာက အစီအစဉ်ကို ပြန်မပေးပါ။ စတိုးတွင် ပြန်စာရင်းသွင်းပါ။';

  @override
  String get ctaContinue => 'ဆက်လုပ်ရန်';

  @override
  String get ctaClose => 'ပိတ်ရန်';

  @override
  String get ovRestoreSuccessTitle => 'Premium ပြန်ရောက်ပြီ';

  @override
  String get ovRestoreSuccessBody =>
      'သင့်စာရင်းသွင်းမှုကို တွေ့ရှိပြီး ဤစက်တွင် ပြန်ဖွင့်ပေးပြီးပြီ။';

  @override
  String get ovRestoreEmptyTitle => 'ပြန်ရယူစရာ မရှိပါ';

  @override
  String get ovRestoreEmptyBody =>
      'ဤစတိုးအကောင့်နှင့် ချိတ်ဆက်ထားသော သက်ဝင် စာရင်းသွင်းမှု မရှိပါ။';

  @override
  String get ovRestoreOtherTitle => 'ဤအစီအစဉ်သည် အခြားအကောင့်ပိုင် ဖြစ်သည်';

  @override
  String get ovRestoreOtherBody =>
      'ဤစာရင်းသွင်းမှုသည် အခြား BeaverTalk အကောင့်တွင် သက်ဝင်နေပြီး ဖြစ်သည်။';

  @override
  String get ctaSignInThatAccount => 'ထိုအကောင့်ဖြင့် ဝင်ရန်';

  @override
  String get ctaGetHelp => 'အကူအညီ ရယူရန်';

  @override
  String get ovCharacterOfferTitle => 'Premium အတွက် မသင့်သေးဘူးလား။';

  @override
  String get ovCharacterOfferBody =>
      'ဇာတ်ကောင်တစ်ကောင် ရွေးပြီး ထာဝရ ပိုင်ဆိုင်ပါ။ တစ်ကြိမ်တည်း ဝယ်ယူမှု — စာရင်းသွင်းစရာမလို၊ သက်တမ်းတိုးစရာမလို။';

  @override
  String get rowOneCharacter => 'ဇာတ်ကောင် တစ်ကောင်';

  @override
  String rowFromPrice(String price) {
    return 'တစ်ခုလျှင် $price';
  }

  @override
  String get rowYoursForever => 'ထာဝရ သင့်ပိုင်';

  @override
  String get rowNoRenewal => 'သက်တမ်းတိုးစရာမလို';

  @override
  String get rowWorksOnFree => 'Free တွင်လည်း သုံးနိုင်';

  @override
  String get rowYes => 'ရသည်';

  @override
  String get ctaSeeCharacters => 'ဇာတ်ကောင်များ ကြည့်ရန်';

  @override
  String get ovNotEligibleTitle => 'ပယ်ဖျက်စရာ မရှိပါ';

  @override
  String get ovNotEligibleBody =>
      'Free တွင် ရှိနေသည်။ ဤအကောင့်တွင် သက်ဝင် စာရင်းသွင်းမှု မရှိပါ။';

  @override
  String get ovCancelDownsellTitle => 'မသွားမီ';

  @override
  String get ovCancelDownsellBody =>
      'ပယ်ဖျက်ခြင်းကို စတိုးတွင် လုပ်ရသည်။ သိထားသင့်သည့် အချက် နှစ်ချက်။';

  @override
  String get rowPayYearlyInstead => 'နှစ်စဉ် ပေးချေလျှင်';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'တစ်လ $price';
  }

  @override
  String get rowCharactersYouBought => 'ဝယ်ထားသော ဇာတ်ကောင်များ';

  @override
  String get rowProRunsUntil => 'Premium သုံးနိုင်သည့်ရက်';

  @override
  String get ctaSwitchToYearly => 'နှစ်စဉ်သို့ ပြောင်းရန်';

  @override
  String get ctaContinueToStore => 'စတိုးသို့ ဆက်သွားရန်';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'နှစ်စဉ်ပေးချေပြီး $saved ချွေတာပါ';
  }

  @override
  String get ovAnnualSwitchBody =>
      'နှစ်စဉ်အစီအစဉ်သည် လစဉ်ပေးချေခြင်းထက် ပိုသက်သာသည်။';

  @override
  String get rowYouSave => 'ချွေတာနိုင်ငွေ';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'နှစ်စဉ်';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'လစဉ်၊ တစ်နှစ်စာ';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'လစဉ်သို့ ပြောင်းရန်';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'သင့်နှစ်စဉ်အစီအစဉ် $date အထိ သက်ဝင်သည်။ နောက်တစ်ရက်မှ လစဉ်ကောက်ခံမှု စတင်မည်။';
  }

  @override
  String get rowMonthlyBillingStarts => 'လစဉ်ကောက်ခံမှု စတင်ချိန်';

  @override
  String get rowMonthlyLabel => 'လစဉ်';

  @override
  String get rowYearlyWorkedOut => 'နှစ်စဉ်နှုန်းဖြင့် တွက်လျှင်';

  @override
  String get ctaSwitchToMonthly => 'လစဉ်သို့ ပြောင်းရန်';

  @override
  String get ovRefundHelpTitle => 'ငွေပြန်အမ်းမှုကို စတိုးက ဆောင်ရွက်သည်';

  @override
  String get ovRefundHelpBody =>
      'ကျွန်ုပ်တို့ ကိုယ်တိုင် ငွေပြန်မအမ်းနိုင်ပါ။ တောင်းဆိုမှုတိုင်းကို စတိုးက စိစစ်သည်။';

  @override
  String get ctaGoToStore => 'စတိုးသို့ သွားရန်';

  @override
  String get ovTrialEndingTitle => 'သင့်အစမ်းသုံးကာလ မနက်ဖြန် ကုန်ဆုံးမည်';

  @override
  String get ovTrialEndingBody =>
      'မပယ်ဖျက်ပါက Premium ဆက်သွားမည်။ ဖြစ်လာမည့်အရာများမှာ —';

  @override
  String get rowTrialEnds => 'အစမ်းသုံး ကုန်ဆုံးချိန်';

  @override
  String get rowFirstCharge => 'ပထမ ကောက်ခံမှု';

  @override
  String get rowThenMonthly => 'ထို့နောက် လစဉ်';

  @override
  String get ctaCancelInStore => 'စတိုးတွင် ပယ်ဖျက်ရန်';

  @override
  String get ovTrialStartTitle => 'Premium ၇ ရက်၊ အခမဲ့';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date အထိ အခမဲ့။ ထို့နောက် တစ်လ $price၊ စတိုးတွင် မပယ်ဖျက်ပါက။';
  }

  @override
  String get ctaStart7Days => '၇ ရက် အခမဲ့ စတင်ရန်';

  @override
  String get ovOtoTitle => 'မစတင်မီ နောက်ထပ် တစ်ခု';

  @override
  String get ovOtoBody =>
      'ရွေးချယ်မှု ကောင်းပါသည်။ နှစ်စဉ်ပေးချေလျှင် တူညီသော Premium ကို ပိုသက်သာစွာ ရနိုင်သည်။';

  @override
  String get ovFailedDeclinedTitle => 'သင့်ကတ် ငြင်းပယ်ခံရသည်';

  @override
  String get ovFailedDeclinedBody =>
      'စတိုးက ငွေပေးချေမှု လက်မခံနိုင်ခဲ့ပါ။ ငွေမကောက်ခံခဲ့ပါ။';

  @override
  String get ctaUpdatePaymentMethod => 'ငွေပေးချေနည်း အပ်ဒိတ်လုပ်ရန်';

  @override
  String get ovFailedCanceledTitle => 'ငွေပေးချေမှု ပယ်ဖျက်လိုက်သည်';

  @override
  String get ovFailedCanceledBody => 'Free တွင် ဆက်ရှိနေသည်။ ငွေမကောက်ခံခဲ့ပါ။';

  @override
  String get ovFailedStoreTitle => 'တစ်ခုခု မှားသွားသည်';

  @override
  String get ovFailedStoreBody =>
      'စတိုးနှင့် ချိတ်ဆက်၍ မရပါ။ ငွေမကောက်ခံခဲ့ပါ။';

  @override
  String get ovAlreadyTitle => 'Premium ကို သုံးနေပြီးသား ဖြစ်သည်';

  @override
  String get ovAlreadyBody =>
      'ဤစတိုးအကောင့်တွင် သက်ဝင် အစီအစဉ်ရှိသည်။ ဝယ်စရာ မရှိပါ။';

  @override
  String get ctaSeeMySubscription => 'ကျွန်ုပ်၏ စာရင်းသွင်းမှု ကြည့်ရန်';

  @override
  String get subCancelTitle => 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်';

  @override
  String subCancelBody(String date) {
    return 'Premium $date အထိ သက်ဝင်သည်။ ထို့နောက် Free သို့ ပြောင်းမည်။';
  }

  @override
  String get subWhatYouLose => 'ဆုံးရှုံးမည့်အရာ';

  @override
  String get benefitScoring => 'စာလုံးတစ်လုံးချင်း အသံထွက် အမှတ်ပေးမှု';

  @override
  String get benefitEveryMetric => 'မက်ထရစ်တိုင်း၊ ဝါကျတိုင်း';

  @override
  String get subPaymentTitle => 'ငွေပေးချေမှု အပ်ဒိတ်လုပ်ရန်';

  @override
  String get subPaymentBody =>
      'ငွေပေးချေမှု မအောင်မြင်ပါ။ ဆိုင်းငံ့ကာလအတွင်း Premium ဆက်သုံးနိုင်သည်။';

  @override
  String get subHowToFix => 'ပြင်ဆင်နည်း';

  @override
  String get fixStep1 => 'စတိုးကို ဖွင့်ပြီး ငွေပေးချေနည်း အပ်ဒိတ်လုပ်ပါ';

  @override
  String get fixStep2 => 'ပြန်လာပါ — အစီအစဉ် အလိုအလျောက် ပြန်စမည်';

  @override
  String get fixStep3 => 'ဘာမှ နှစ်ကြိမ် မကောက်ခံပါ';

  @override
  String get subResubTitle => 'ပြန်လည် စာရင်းသွင်းရန်';

  @override
  String subResubBody(String date) {
    return 'Premium $date တွင် ကုန်ဆုံးမည်။ အလိုအလျောက် သက်တမ်းတိုးကို ပြန်ဖွင့်ပါက ဘာမှ မပြောင်းပါ။';
  }

  @override
  String get subWhatYouKeep => 'ဆက်ရရှိမည့်အရာ';

  @override
  String get ctaTurnItBackOn => 'ပြန်ဖွင့်ရန်';

  @override
  String get flTodayTitle => 'ယနေ့ ခေါ်ဆိုမှု ပြီးပါပြီ';

  @override
  String get flTodayBody => 'ရပ်ထားသည့်နေရာမှ — ယခုပဲ ဆက်လုပ်ပါ။';

  @override
  String get flCheckTitle => 'ယနေ့ စစ်ဆေးမှု ပြီးပါပြီ';

  @override
  String get flCheckBody =>
      'Free တွင် တစ်ရက် 1 ကြိမ် စစ်ဆေးနိုင်သည်။ Premium က ခွဲခြမ်းစိတ်ဖြာမှု အပြည့်အစုံ ပေးသည်။';

  @override
  String flCaption(String price) {
    return 'တစ်လ $price · အချိန်မရွေး ပယ်ဖျက်နိုင်';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit အနက် $used သုံးပြီး';
  }

  @override
  String get ctaMaybeTomorrow => 'မနက်ဖြန်မှပဲ';

  @override
  String get accountSection => 'အကောင့်';

  @override
  String get nicknameLabel => 'အမည်ပြောင်';

  @override
  String get emailLabel => 'အီးမေးလ်';

  @override
  String get loginMethodLabel => 'လော့ဂ်အင်နည်းလမ်း';

  @override
  String get joinedLabel => 'စတင်ဝင်ရောက်သည့်ရက်';

  @override
  String get editNicknameTitle => 'အမည်ပြောင် ပြင်ရန်';

  @override
  String get nicknameRule => 'စာလုံး ၂–၁၂။ အင်္ဂလိပ် စာလုံးနှင့် ဂဏန်းများသာ။';

  @override
  String get ctaSave => 'သိမ်းရန်';

  @override
  String get subscriptionRow => 'အသင်းဝင်မှု';

  @override
  String get iapSuccessTitle => 'ဝယ်ယူမှု ပြီးဆုံးပါပြီ';

  @override
  String iapSuccessBody(String name) {
    return '$name အဝတာ သည် အမြဲတမ်း သင့်ဟာ ဖြစ်ပါပြီ။\nငွေလက်ခံဖြတ်ပိုင်း အတည်ပြုသည်နှင့် ချက်ချင်း အသုံးပြုနိုင်ပါမည်။';
  }

  @override
  String get ctaGoHome => 'ပင်မသို့';

  @override
  String get ctaUseNow => 'ယခု သုံးရန်';

  @override
  String get iapFailTitle => 'ငွေပေးချေမှု မအောင်မြင်ပါ';

  @override
  String get iapFailBody => 'ထပ်မံ ကြိုးစားနိုင်ပါသည်';

  @override
  String get paywallLeaveTitle => 'ယခုထွက်လျှင် စာရင်းသွင်းပြီးမည်မဟုတ်ပါ';

  @override
  String get paywallLeaveBody =>
      'ငွေပေးချေပြီးလျှင် အကျိုးခံစားခွင့်များ ချက်ချင်းပွင့်သည်။ ကျွန်ုပ်၏စာမျက်နှာမှ အချိန်မရွေး ပြန်လာနိုင်သည်။';

  @override
  String get ctaKeepLooking => 'ဆက်ကြည့်မည်';

  @override
  String get ctaLeaveAnyway => 'ထွက်မည်';

  @override
  String get iapCharacterSuccessTitle => 'မိတ်ဆွေအသစ်ရောက်လာပြီ!';

  @override
  String get iapCharacterSuccessBody =>
      'ဤဇာတ်ကောင်သည် ထာဝရသင်၏ဖြစ်သည် — အစီအစဉ်ပြောင်းလည်း ကျန်ရှိပြီး ဝယ်ယူမှုများပြန်ယူခြင်းဖြင့် မည်သည့်စက်တွင်မဆို ပြန်ရနိုင်သည်။';

  @override
  String get iapCharacterFailedBody =>
      'ဝယ်ယူမှု မအောင်မြင်ပါ။ ငွေမဖြတ်ပါ — ထပ်စမ်းကြည့်ပါ။';

  @override
  String get noAccentDataTitle => 'အသံနေအသံထားဒေတာ မရှိသေးပါ';

  @override
  String get noAccentDataBody =>
      'ဆက်လက်စကားပြောပါက အသံနေအသံထား လက္ခဏာများ စုဆောင်းလာပါမည်။';

  @override
  String get noLevelYetTitle => 'အဆင့် မရှိသေးပါ';

  @override
  String get noLevelYetBody => 'ပထမဆုံးခေါ်ဆိုမှုပြီးလျှင် အဆင့်ရရှိပါမည်။';

  @override
  String get noPronunciationDataTitle => 'အသံထွက်မှတ်တမ်း မရှိသေးပါ';

  @override
  String get noPronunciationDataBody =>
      'ခေါ်ဆိုစဉ် ပြောသောစာကြောင်းများမှ အသံထွက်ကို ခွဲခြမ်းစိတ်ဖြာပါသည်။';

  @override
  String get noCharacterNote => 'ချန်ထားသည့်စကား မရှိသေးပါ';

  @override
  String get noPhonemesYet => 'ခွဲခြမ်းရန် အသံ မရှိသေးပါ';

  @override
  String get noSentencesYet => 'ခွဲခြမ်းရန် စာကြောင်း မရှိသေးပါ';

  @override
  String get takeLevelTest => 'အဆင့်စစ်ဆေးမှု ဖြေဆိုရန်';

  @override
  String get reviewToSeeScore => 'ပြန်လေ့လာပါက အသံထွက်ရမှတ် ပေါ်လာပါမည်';

  @override
  String get playAgain => 'ထပ်ကစားရန်';

  @override
  String get difficultySlow => 'နှေး';

  @override
  String get difficultyNormal => 'ပုံမှန်';

  @override
  String get difficultyFast => 'မြန်';

  @override
  String get difficultyLabel => 'အခက်အခဲအဆင့်';

  @override
  String get connected => 'ချိတ်ဆက်ပြီး';

  @override
  String get unlockedWithMax => 'သင့်အစီအစဉ်တွင် ပါဝင်သည်';

  @override
  String get fcEndedTitle => 'သင့်အခမဲ့ခေါ်ဆိုမှု ပြီးဆုံးသွားပါပြီ';

  @override
  String get fcEndedBody =>
      'အခမဲ့ခေါ်ဆိုမှုသည် ၅ မိနစ်အထိ ကြာပါသည်\nပိုမိုကြာရှည်စွာ စကားပြောရန် စာရင်းသွင်းပါ';

  @override
  String get ctaSubscribeKeepTalking => 'စာရင်းသွင်းပြီး ဆက်ပြောပါ';

  @override
  String get kgTitle => 'ဆက်လုပ်မလား?';

  @override
  String get kgBody =>
      'ခေါ်ဆိုမှုသည် ၅ မိနစ်စီ ဆက်လက်ဖြစ်ပေါ်ပါသည်။\nအကြိမ်တိုင်း ထပ်မံမေးပါမည်။';

  @override
  String get pcEndedTitleToday => 'ဒီနေ့ ခေါ်ဆိုမှုကို ဒီမှာ ရပ်ပါမယ်။';

  @override
  String get pcEndedBodyToday =>
      'ပြောခဲ့တာတွေ ပြန်လေ့ကျင့်ပြီး မနက်ဖြန် ထပ်ခေါ်ပါ!';

  @override
  String get pcEndedTitle => 'ဒီခေါ်ဆိုမှုကို ဒီမှာ ရပ်ပါမယ်။';

  @override
  String get pcEndedBody => 'ပြောခဲ့တာတွေ ပြန်လေ့ကျင့်ပြီး ထပ်ခေါ်ပါ!';

  @override
  String get ctaKeepTalking => 'ဆက်ပြောပါ';

  @override
  String get callModeSheetTitle => 'ဘယ်လိုစကားပြောချင်ပါသလဲ။';

  @override
  String get callModeSheetSubtitle => 'ဤခေါ်ဆိုမှုတွင် ချက်ချင်းသက်ရောက်သည်';

  @override
  String get callModeFreeTalk => 'လွတ်လပ်စွာစကားပြော';

  @override
  String get callModeFreeTalkDesc => 'ပြင်ဆင်မှုမပါဘဲ စကားပြောပါ';

  @override
  String get callModeStudy => 'လေ့လာခြင်း';

  @override
  String get callModeStudyDesc => 'အသုံးအနှုန်းတစ်ခုချင်း လေ့လာပါ';

  @override
  String get callModeChange => 'မုဒ်ပြောင်းရန်';

  @override
  String get callModeKeep => 'ယခုမဟုတ်ပါ';

  @override
  String get callExitTitle => 'ခေါ်ဆိုမှုကို အဆုံးသတ်မလား။';

  @override
  String get callExitSubtitle =>
      'ယခုအဆုံးသတ်လျှင်လည်း ယနေ့ခေါ်ဆိုမှုတစ်ကြိမ် ကုန်ပါမည်';

  @override
  String get callExitKeep => 'ဆက်ပြောပါ';

  @override
  String get callExitConfirm => 'ခေါ်ဆိုမှုအဆုံးသတ်ရန်';

  @override
  String get callMicMute => 'အသံပိတ်';

  @override
  String get callMicUnmute => 'အသံဖွင့်';

  @override
  String get callPushToTalk => 'ပြောရန် ဖိထားပါ';

  @override
  String get callFreeEndedTitle => 'သင့်အခမဲ့ခေါ်ဆိုမှု ကုန်သွားပါပြီ';

  @override
  String get callFreeEndedCta => 'စာရင်းသွင်းပြီး ဆက်ပြောပါ';

  @override
  String get callKeepGoingTitle => 'ဆက်လုပ်မလား။';

  @override
  String get callKeepGoingSubtitle =>
      'ခေါ်ဆိုမှုများသည် ၅ မိနစ်စီ ဆက်လက်ဖြစ်ပေါ်သည်။ အကြိမ်တိုင်း ထပ်မေးပါမည်။';

  @override
  String get articulationSelectedWord => 'ရွေးထားသော စကားလုံး';

  @override
  String get articulationYouSaid => 'သင့်အသံထွက်';

  @override
  String get articulationTargetSound => 'ပန်းတိုင်';

  @override
  String get reportEntry => 'သတင်းပို့ရန်';

  @override
  String get reportTitle => 'တိုင်ကြားချက်';

  @override
  String get reportPrompt => 'ဘာပြဿနာဖြစ်ခဲ့ပါသလဲ?';

  @override
  String get reportGuide =>
      'AI ဇာတ်ကောင်၏ မည်သည့်အကြောင်းအရာက သင့်ကို အနှောင့်အယှက်ဖြစ်စေခဲ့ကြောင်း ပြောပြပါ။ တိုင်ကြားချက်တိုင်းကို စိစစ်ပါသည်။';

  @override
  String get reportReasonSexual => 'လိင်ဆိုင်ရာ အကြောင်းအရာ';

  @override
  String get reportReasonHate => 'အမုန်းတရား သို့မဟုတ် ခွဲခြားမှု';

  @override
  String get reportReasonViolence => 'အကြမ်းဖက် သို့မဟုတ် ခြိမ်းခြောက်မှု';

  @override
  String get reportReasonSelfHarm => 'မိမိကိုယ်ကို အန္တရာယ်ပြုရန် အားပေးမှု';

  @override
  String get reportReasonMisinfo => 'မှားယွင်းသော သတင်းအချက်အလက်';

  @override
  String get reportReasonOther => 'အခြားပြဿနာ';

  @override
  String get reportDetailHint => 'ဘာဖြစ်ခဲ့သည်ကို ရေးပါ (ရွေးချယ်နိုင်)';

  @override
  String get reportSubmit => 'တိုင်ကြားချက် ပို့ရန်';

  @override
  String get reportDoneTitle => 'သင့်တိုင်ကြားချက်ကို လက်ခံရရှိပါပြီ';

  @override
  String get reportDoneBody =>
      'စိစစ်ပြီး လိုအပ်ပါက အရေးယူပါမည်။ BeaverTalk ကို ဘေးကင်းစေရန် ကူညီပေးသည့်အတွက် ကျေးဇူးတင်ပါသည်။';

  @override
  String get reportFailed => 'တိုင်ကြားချက် မပို့နိုင်ပါ။ ထပ်စမ်းကြည့်ပါ။';

  @override
  String get hwTitle => 'အိမ်စာ';

  @override
  String get hwJoinCodeTitle => 'သင့်အတန်းကုဒ်ကို ထည့်ပါ';

  @override
  String get hwJoinCodeSubtitle => 'ဆရာ/ဆရာမ ပေးထားသော ၆ လုံးကုဒ် ဖြစ်သည်';

  @override
  String get hwJoinCodeLabel => 'အတန်းကုဒ်';

  @override
  String get hwJoinCodeHelp => 'ကုဒ်တွင် စာလုံးအကြီးအသေး မခွဲပါ';

  @override
  String get hwJoinConfirmTitle => 'ဤအတန်း မှန်ပါသလား';

  @override
  String get hwJoinConfirmSubtitle => 'မမှန်ပါက ကုဒ်ကို ထပ်စစ်ပါ';

  @override
  String get hwJoinFieldInstitution => 'အဖွဲ့အစည်း';

  @override
  String get hwJoinFieldTeacher => 'ဆရာ/ဆရာမ';

  @override
  String get hwJoinFieldLearners => 'သင်ယူသူများ';

  @override
  String get hwJoinFieldTerm => 'သင်တန်းကာလ';

  @override
  String get hwJoinConfirmNote =>
      'အတန်းအမည်ကို ဆရာရေးသည့်အတိုင်း အတိအကျ ဖော်ပြပါသည်။ ဘာသာမပြန်ပါ။';

  @override
  String get hwJoinConfirmYes => 'ဟုတ်ကဲ့၊ ဤအတန်းပါ';

  @override
  String get hwJoinConfirmRetry => 'ကုဒ် ပြန်ထည့်ရန်';

  @override
  String get hwJoinProfileTitle => 'အတန်းတွင် မည်သည့်အမည် သုံးမည်နည်း';

  @override
  String get hwJoinProfileSubtitle =>
      'ဆရာက အတန်းစာရင်းနှင့် တိုက်ဆိုင်စစ်ပါမည်';

  @override
  String get hwJoinNameLabel => 'အမည်';

  @override
  String get hwJoinNameHelp => 'အက်ပ်အမည်နှင့် ကွဲပြားနိုင်ပါသည်';

  @override
  String get hwJoinStudentNoLabel => 'ကျောင်းသားနံပါတ် (ရွေးချယ်နိုင်)';

  @override
  String get hwJoinStudentNoHelp => 'ဆရာက အတန်းစာရင်း တိုက်ဆိုင်ရန် သုံးပါသည်';

  @override
  String get hwJoinConsentTitle => 'ဆရာ မြင်နိုင်သည့်အရာ';

  @override
  String get hwJoinConsentSubtitle => 'အတန်းသို့ ဝင်ရန် သဘောတူရပါမည်';

  @override
  String get hwJoinConsentSharedHeading => 'ဆရာနှင့် မျှဝေသည်';

  @override
  String get hwJoinConsentShared1 => 'အတန်းအမည်နှင့် ကျောင်းသားနံပါတ်';

  @override
  String get hwJoinConsentShared2 => 'အိမ်စာ လုပ်ခဲ့ခြင်း ရှိ၊ မရှိ';

  @override
  String get hwJoinConsentShared3 => 'အောင်မြင်သော နှင့် လွဲချော်သော ဝါကျများ';

  @override
  String get hwJoinConsentShared4 =>
      'အိမ်စာခေါ်ဆိုမှု ကြာချိန်နှင့် အကျဉ်းချုပ်';

  @override
  String get hwJoinConsentNotSharedHeading => 'မမျှဝေပါ';

  @override
  String get hwJoinConsentNotShared1 => 'အီးမေးလ်နှင့် ဖုန်းနံပါတ်';

  @override
  String get hwJoinConsentNotShared2 => 'အက်ပ်အမည်၊ ပရိုဖိုင်နှင့် ဇာတ်ကောင်';

  @override
  String get hwJoinConsentNotShared3 => 'နိုင်ငံသားနှင့် မိခင်ဘာသာစကား';

  @override
  String get hwJoinConsentNotShared4 => 'အတန်းပြင်ပ ခေါ်ဆိုမှုနှင့် လေ့လာမှု';

  @override
  String get hwJoinConsentNotShared5 =>
      'အသင်းဝင်မှုနှင့် ငွေပေးချေမှု အချက်အလက်';

  @override
  String get hwJoinConsentAgree => 'အထက်ပါတို့ကို သဘောတူပါသည်';

  @override
  String get hwJoinConsentCta => 'သဘောတူ၍ ဝင်ရန်';

  @override
  String hwJoinDoneTitle(String className) {
    return '$className သို့ ဝင်ရောက်ပြီးပါပြီ';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'အိမ်စာ $count ခု စောင့်နေပါသည်';
  }

  @override
  String get hwJoinDoneNoAssignment => 'အိမ်စာ မရှိသေးပါ';

  @override
  String get hwJoinDoneNextDue => 'နောက်ထပ် သတ်မှတ်ရက်';

  @override
  String get hwJoinDoneRosterName => 'အတန်းတွင် သင့်အမည်';

  @override
  String get hwJoinDoneCta => 'အိမ်စာ ကြည့်ရန်';

  @override
  String get hwJoinErrorNotFound => 'ထိုကုဒ်ကို ရှာမတွေ့ပါ';

  @override
  String get hwJoinErrorNotFoundBody => 'ဂဏန်းခြောက်လုံးကို ထပ်စစ်ပါ။';

  @override
  String get hwJoinErrorExpired => 'ထိုကုဒ် သက်တမ်းကုန်သွားပါပြီ';

  @override
  String get hwJoinErrorExpiredBody => 'ဆရာထံမှ ကုဒ်အသစ် တောင်းပါ။';

  @override
  String get hwJoinErrorFull => 'အတန်း ပြည့်နေပါပြီ';

  @override
  String get hwJoinErrorFullBody => 'ဆရာအား အကြောင်းကြားပါ။';

  @override
  String get hwJoinFailed => 'ဝင်ရောက်၍ မရပါ။ ခဏနေ ထပ်ကြိုးစားပါ။';

  @override
  String get hwSectionInProgress => 'လုပ်ဆောင်နေဆဲ';

  @override
  String get hwSectionUpcoming => 'လာမည့်';

  @override
  String get hwSectionDone => 'ပြီးဆုံး';

  @override
  String get hwLeaveClassLink => 'အတန်းမှ ထွက်ရန်';

  @override
  String get hwListEmptyTitle => 'အိမ်စာ မရှိသေးပါ';

  @override
  String get hwListEmptyBody => 'ဆရာ ပေးသည့်အခါ ဤနေရာတွင် ပေါ်ပါမည်။';

  @override
  String get hwListFailed => 'အိမ်စာကို ဖွင့်၍မရပါ။';

  @override
  String get hwRetry => 'ထပ်ကြိုးစားရန်';

  @override
  String get hwBadgeDone => 'ပြီးဆုံး';

  @override
  String get hwBadgeOverdue => 'မတင်ပြရသေး';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'မတင်ပြရသေး၊ $days ရက် နောက်ကျ';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'ယနေ့ သတ်မှတ်ရက်';

  @override
  String get hwActivitySpeaking => 'စကားပြော';

  @override
  String get hwActivityConversation => 'စကားဝိုင်း';

  @override
  String get hwActivityWorkbook => 'လေ့ကျင့်ခန်းစာအုပ်';

  @override
  String hwChapterLabel(String chapter) {
    return 'အခန်း $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'သင့်အသံထွက် ရမှတ်ကို စစ်ကြည့်ပါ';

  @override
  String get hwTaskConversationDesc =>
      'သင်ယူထားသည်ကို တကယ့်စကားဝိုင်းတွင် သုံးပါ';

  @override
  String get hwConversationOnce =>
      'စကားပြောကို အိမ်စာတစ်ခုလျှင် တစ်ကြိမ်သာ လုပ်နိုင်ပါသည်။';

  @override
  String get hwTaskWorkbookDesc => 'လေ့ကျင့်ခန်းစာအုပ်တွင် ရေးပြီး လေ့ကျင့်ပါ';

  @override
  String get hwCtaStudy => 'စတင်ရန်';

  @override
  String get hwCtaResult => 'ရလဒ် ကြည့်ရန်';

  @override
  String get hwCtaDownload => 'ဒေါင်းလုဒ်';

  @override
  String get hwSpeakingNoScore => 'စကားပြော လုပ်ငန်းကို မလုပ်ရသေးပါ';

  @override
  String get hwWorkbookUnavailable => 'လေ့ကျင့်ခန်းစာအုပ် ဖိုင် မရနိုင်သေးပါ။';

  @override
  String get hwDetailClosed => 'ဤအိမ်စာ ပိတ်သွားပါပြီ။ ထပ်မံ တင်ပြ၍ မရတော့ပါ။';

  @override
  String get hwLeaveTitle => 'အတန်းမှ ထွက်မလား';

  @override
  String get hwLeaveBody =>
      'ဆရာသည် သင့်အိမ်စာ ရလဒ်များကို နောက်ထပ် မမြင်တော့ပါ။';

  @override
  String get hwLeaveConfirm => 'ထွက်ရန်';

  @override
  String get hwLeaveCancel => 'ဆက်နေရန်';

  @override
  String get hwLeaveFailed => 'အတန်းမှ ထွက်၍ မရပါ။';

  @override
  String get hwMyClass => 'ကျွန်ုပ်၏ အတန်း';

  @override
  String get hwClassEmptyTitle => 'မည်သည့်အတန်းမှ မဝင်ရသေးပါ';

  @override
  String get hwClassEmptySubtitle => 'ဆရာပေးထားသော ကုဒ်ကို ထည့်ပါ';

  @override
  String get hwClassEmptyCta => 'အတန်းကုဒ် ထည့်ရန်';

  @override
  String get hwClassContinueCta => 'ဆက်လက်';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return 'အိမ်စာ $count ခု မနက်ဖြန် သတ်မှတ်ရက်';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'မတင်ပြရသေးသော အိမ်စာ $count ခု ရှိပါသည်';
  }

  @override
  String get hwSpeakingUnavailable => 'ဤအိမ်စာအတွက် ဝါကျများ မရနိုင်သေးပါ။';

  @override
  String get hwBadgeClosed => 'ပိတ်ထား';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return 'ဝါကျ $total ခုအနက် $passed ခု အောင်မြင်';
  }

  @override
  String get challengeFirstWord => 'ပထမစကားလုံး';

  @override
  String get challengeSeeAnalysis => 'ရလဒ်များ ကြည့်ရန်';

  @override
  String get challengePaused => 'ခေတ္တရပ်ထားသည်';

  @override
  String get challengePausedNote =>
      'အချိန်တိုင်းနှင့် အသံဖမ်းခြင်း အတူရပ်သွားပါပြီ။';

  @override
  String get challengeTimeLeft => 'ကျန်ချိန်';

  @override
  String get challengeScoreLabel => 'ရမှတ်';

  @override
  String get challengeResume => 'ဆက်လုပ်ရန်';

  @override
  String get challengeBlockedTitle => 'ကင်မရာ သုံး၍မရပါ';

  @override
  String get challengeBlockedNote =>
      'ဆက်တင်တွင် ကင်မရာနှင့် မိုက်ခွင့်ပြုချက်ကို ဖွင့်ပါ။';

  @override
  String get challengeGoBack => 'ပြန်သွားရန်';

  @override
  String get challengeOpenSettings => 'ဆက်တင် ဖွင့်ရန်';

  @override
  String get saveDone => 'ဓာတ်ပုံပြခန်းသို့ သိမ်းပြီးပါပြီ';

  @override
  String get saveFailed => 'မသိမ်းနိုင်ပါ';

  @override
  String get saveDeniedNote => 'ဓာတ်ပုံ ခွင့်ပြုချက် လိုအပ်သည်';

  @override
  String get callIncomingCallerFallback => 'Beaver ဆရာ';

  @override
  String get callIncomingHandle => 'ကိုရီးယားစကား ခေါ်ဆိုမှု';

  @override
  String get callMissedTitle => 'လွတ်သွားသော ခေါ်ဆိုမှု';

  @override
  String get callMissedChannelDescription =>
      'Beaver ထံမှ လွတ်သွားသော ခေါ်ဆိုမှုကို အကြောင်းကြားပါသည်။';

  @override
  String callMissedBody(String name) {
    return '$name က သင့်ကို ခေါ်ခဲ့သည်';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'ခေါ်ဆိုမှုများ လက်ခံရန် အကြောင်းကြားချက် ခွင့်ပြုချက် လိုအပ်သည်။';

  @override
  String get callNotifPermissionRequired =>
      'ဆက်တင်တွင် အကြောင်းကြားချက်များကို ခွင့်ပြုပါ။';

  @override
  String get callHintLockedTitle =>
      'လေ့လာခြင်းတွင် အကြံပြုချက်ကို အသုံးမပြုနိုင်ပါ';

  @override
  String get wsTitle => 'အခက်အခဲ အသံများ';

  @override
  String get wsToList => 'စာရင်းသို့';

  @override
  String get wsNext => 'ရှေ့ဆက်ရန်';

  @override
  String get wsRetry => 'ထပ်ကြိုးစားရန်';

  @override
  String get wsDone => 'ပြီးပါပြီ';

  @override
  String get wsContinue => 'ဆက်လုပ်ရန်';

  @override
  String get wsQuit => 'ထွက်ရန်';

  @override
  String get wsRetryLater => 'ခဏနေ ထပ်ကြိုးစားပါ။';

  @override
  String get wsMissingTitle => 'ထိုအသံကို ရှာမတွေ့ပါ';

  @override
  String get wsMissingBody => 'စာရင်းမှ ပြန်ရွေးပါ။';

  @override
  String get wsListLoadFailed => 'စာရင်းကို ဖွင့်မရပါ';

  @override
  String get wsLessonLoadFailed => 'သင်ခန်းစာကို ဖွင့်မရပါ';

  @override
  String get wsNationalTitle => 'သင့်အသံဟန်အတွက် အခက်အခဲ အသံများ';

  @override
  String get wsNationalPending => 'အသံဟန် ခွဲခြမ်းပြီးလျှင် ဖော်ပြပါမည်';

  @override
  String get wsNationalPicked => 'အသံဟန် ခွဲခြမ်းချက်မှ ရွေးထားသည်';

  @override
  String get wsNationalEmptyBody =>
      'ခေါ်ဆိုမှု ထပ်လုပ်ပါ၊ အသံဟန်ကို ခွဲခြမ်းပေးပါမည်။';

  @override
  String get wsMineTitle => 'ကျွန်ုပ်၏ အခက်အခဲ အသံများ';

  @override
  String get wsMineSubtitle => 'မကြာမီ ရမှတ်နိမ့်ခဲ့သော အသံများ';

  @override
  String get wsMineEmptyBody =>
      'ခေါ်ဆိုပြီး ပြန်လေ့လာလျှင် အခက်အခဲ အသံများ စုလာမည်။';

  @override
  String get wsNoDataYet => 'ဒေတာ မရှိသေးပါ';

  @override
  String get wsGoToCall => 'ခေါ်ဆိုမှု စတင်ရန်';

  @override
  String get wsRule => 'စည်းမျဉ်း';

  @override
  String get wsRecommended => 'အကြံပြုချက်';

  @override
  String get wsNotMeasured => 'မတိုင်းတာသေးပါ';

  @override
  String get wsStepUnderstand => 'လေ့လာ';

  @override
  String get wsStepWords => 'စကားလုံး';

  @override
  String get wsStepSentence => 'စာကြောင်း';

  @override
  String get wsStepTest => 'စစ်ဆေး';

  @override
  String get wsQuitTitle => 'လေ့ကျင့်မှု ရပ်မလား?';

  @override
  String get wsQuitBody => 'အခု ထွက်ပါက ဤလေ့ကျင့်မှု သိမ်းမည်မဟုတ်ပါ။';

  @override
  String get wsHowToSound => 'အသံ ထွက်ပုံ';

  @override
  String get wsPracticeWords => 'စကားလုံး လေ့ကျင့်ရန်';

  @override
  String get wsPracticeSentence => 'စာကြောင်း လေ့ကျင့်ရန်';

  @override
  String get wsStartTest => 'စစ်ဆေးမှု စတင်ရန်';

  @override
  String get wsThisSentence => 'ဤစာကြောင်း';

  @override
  String get wsNoScoreNote => 'ဤအဆင့်တွင် အမှတ်မပေးပါ။ လိုက်ဆိုကြည့်ပါ။';

  @override
  String get wsListen => 'အာရုံစိုက် နားထောင်ပါ';

  @override
  String get wsSayNow => 'အခု လိုက်ဆိုပါ';

  @override
  String get wsPracticeDone => 'လေ့ကျင့်မှု ပြီးပါပြီ';

  @override
  String get wsPaused => 'ခေတ္တရပ်ထားသည်';

  @override
  String get wsAudioFailed => 'အသံဖိုင် ဖွင့်မရပါ။ စာကိုကြည့်၍ ဆိုပါ။';

  @override
  String get wsReadAloud => 'အောက်ပါစာကြောင်းကို အသံထွက်ဖတ်ပါ';

  @override
  String get wsTapToStart => 'စတင်ရန် တို့ပါ';

  @override
  String get wsTapWhenDone => 'ပြီးလျှင် တို့ပါ';

  @override
  String get wsScoring => 'အမှတ်ပေးနေသည်';

  @override
  String get wsMicFailed => 'မိုက်ခရိုဖုန်း ဖွင့်မရပါ။';

  @override
  String get wsMicPermissionBody =>
      'ဤစာမေးပွဲတွင် အသံထွက်ဖတ်ရသဖြင့် မိုက်ခရိုဖုန်း လိုအပ်သည်။ ဆက်တင်တွင် မိုက်ခရိုဖုန်း အသုံးပြုခွင့်ကို ဖွင့်ပါ။';

  @override
  String get wsNoSound => 'အသံ မကြားရပါ။ ထပ်ဆိုကြည့်မလား?';

  @override
  String get wsScoreFailed => 'အမှတ်ပေးမှု မအောင်မြင်ပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get wsSomethingWrong => 'ပြဿနာ ရှိပါသည်။';

  @override
  String get wsLearnDone => 'သင်ခန်းစာ ပြီးပါပြီ';

  @override
  String get wsRetest => 'ထပ်စစ်ဆေးရန်';

  @override
  String get wsFirstMeasure => 'ပထမဆုံး တိုင်းတာမှု';

  @override
  String get wsFinalTest => 'နောက်ဆုံး စစ်ဆေးမှု';

  @override
  String wsPoints(int score) {
    return '$score မှတ်';
  }

  @override
  String wsBeforePoints(int score) {
    return 'မတိုင်မီ $score မှတ်';
  }

  @override
  String wsGoalPoints(int score) {
    return 'ပန်းတိုင် $score မှတ်';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'ပန်းတိုင် · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country အသံဟန်';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'စကားလုံး $count လုံး လိုက်ဆိုပြီး';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'အပိုင်း $count ပိုင်း လိုက်ဆိုပြီး';
  }

  @override
  String get wsStartRecommended => 'အကြံပြု အသံမှ စတင်ရန်';

  @override
  String wsStartRecommendedWith(String label) {
    return 'စတင်ရန် · $label';
  }

  @override
  String get wsPointsUnit => 'မှတ်';

  @override
  String get wsEnterFromMypage => 'အခက်အခဲ အသံများ လေ့ကျင့်ရန်';

  @override
  String wsGoalOnly(int score) {
    return 'ပန်းတိုင် $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label အသံ';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc။ ခေါ်ဆိုမှုမှာ ပြန်တွေ့ရင် ဒီပုံသဏ္ဌာန်ကို ပြန်စဉ်းစားပါ။';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country မှ စကားပြောသူများ မကြာခဏ မှားတတ်သော အသံများ';
  }
}
