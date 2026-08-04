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
  String get myPage => 'ကျွန်ုပ်၏စာမျက်နှာ';

  @override
  String get languageSaveFailed => 'သင့်ဘာသာစကားကို သိမ်း၍မရပါ။';

  @override
  String get accountDeleteFailed => 'သင့်အကောင့်ကို ဖျက်၍မရပါ။';

  @override
  String get changeAvatar => 'အာဗတား ပြောင်းရန်';

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
  String get changePlan => 'အစီအစဉ် ပြောင်းရန်';

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
  String get keepUsingPro => 'Pro ကို ဆက်သုံးရန်';

  @override
  String get proMembership => 'Pro အသင်းဝင်ဖြစ်မှု';

  @override
  String get pricePerMonth => '\$12.9 / လ';

  @override
  String get benefitUnlimitedCalls => 'ကန့်သတ်မထားသော ခေါ်ဆိုမှုများ';

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
      'ပထမဆုံးအကြိမ် ဖွင့်ချိန်တွင် ကိုရီးယား အသံအသိအမှတ်ပြု မော်ဒယ် (~82MB) ကို ဒေါင်းလုတ်ဆွဲနေပါသည်။\nခဏစောင့်ပါ။';

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
  String get loginKakaoSignInFailed => 'Kakao အကောင့်ဝင်ခြင်း မအောင်မြင်ပါ။';

  @override
  String get loginContinueWithKakao => 'Kakao ဖြင့် ဆက်လုပ်ရန်';

  @override
  String get loginContinueWithGoogle => 'Google ဖြင့် ဆက်လုပ်ရန်';

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
  String subscriptionSwitchNote(String date) {
    return '$date အထိ Pro အကျိုးခံစားခွင့်များကို ဆက်လက်သုံးနိုင်ပြီး ထို့နောက် အစီအစဉ်သည် အလိုအလျောက် အခမဲ့သို့ ပြောင်းသွားပါမည်။';
  }

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
  String get billingChangePlan => 'အစီအစဉ် ပြောင်းရန်';

  @override
  String get billingCompareAllPlans => 'အစီအစဉ်အားလုံး နှိုင်းယှဉ်ရန်';

  @override
  String get billingBuyACharacter => 'ဇာတ်ကောင် ဝယ်ရန်';

  @override
  String get billingRestorePurchases => 'ဝယ်ယူမှုများ ပြန်လည်ရယူရန်';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max အစမ်းသုံး';

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
  String get bannerGoUnlimitedTitle => 'Pro ဖြင့် အကန့်အသတ်မဲ့ သုံးပါ';

  @override
  String get bannerGoUnlimitedSub =>
      'အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု · တစ်ကြိမ် ၁၅ မိနစ် · တစ်လ \$12.90';

  @override
  String get bannerMaxUpsellTitle => 'Max ဖြင့် ဗီဒီယို ဖွင့်ပါ';

  @override
  String get bannerMaxUpsellSub =>
      'မျက်နှာချင်းဆိုင် ခေါ်ဆိုမှု · တစ်လ \$19.90';

  @override
  String get bannerAnnualSwitchTitle => 'နှစ်စဉ်အစီအစဉ်သို့ ပြောင်းရန်';

  @override
  String get bannerAnnualSwitchSub => 'တစ်နှစ် \$159 · တစ်လ \$13.25';

  @override
  String get bannerPaymentFailedTitle => 'ငွေပေးချေမှု မအောင်မြင်ပါ';

  @override
  String get bannerPaymentFailedSub =>
      'Pro ဆက်သုံးရန် စတိုးတွင် ငွေပေးချေမှု အပ်ဒိတ်လုပ်ပါ';

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
  String get noteFairUse =>
      'အကန့်အသတ်မဲ့ အသုံးပြုမှုသည် တရားမျှတသုံးစွဲမှု မူဝါဒအတိုင်း ဖြစ်သည်။';

  @override
  String noteTrialEnds(String date) {
    return 'သင့်အစမ်းသုံးကာလ $date တွင် ကုန်ဆုံးမည်။ ၎င်းမတိုင်မီ စတိုးတွင် ပယ်ဖျက်ပါက ငွေမကောက်ခံပါ။';
  }

  @override
  String get noteGrace =>
      'ဆိုင်းငံ့ကာလအတွင်း အကျိုးခံစားခွင့်များ ဆက်ရှိသည်။ အက်ပ်ထဲတွင် ပယ်ဖျက်ခြင်းကို ဘယ်တော့မှ မတားဆီးပါ။';

  @override
  String get noteHold =>
      'ငွေပေးချေမှု အောင်မြင်သည်အထိ Pro ခေတ္တရပ်ထားသည်။ သင့်ဇာတ်ကောင်များနှင့် တိုးတက်မှု လုံခြုံပါသည်။';

  @override
  String noteEnding(String date) {
    return 'သင့်အစီအစဉ် ကုန်ဆုံးရန် သတ်မှတ်ထားသည်။ $date အထိ အကျိုးခံစားခွင့်ရှိပြီး ထို့နောက် Free သို့ ပြောင်းမည်။ အချိန်မရွေး ပြန်စာရင်းသွင်းနိုင်သည်။';
  }

  @override
  String get trialExpiredTitle => 'သင့် Max အစမ်းသုံးကာလ ကုန်ဆုံးပြီ';

  @override
  String get trialExpiredSub => 'ယခု Free တွင် ရှိနေသည်';

  @override
  String get seePlans => 'အစီအစဉ်များ ကြည့်ရန်';

  @override
  String get currentPlanTitle => 'လက်ရှိ အစီအစဉ်';

  @override
  String get badgeRecommended => 'အကြံပြုထားသည်';

  @override
  String get perMonthUnit => 'တစ်လလျှင်';

  @override
  String get planTaglinePro => 'အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု။ တစ်ကြိမ် ၁၅ မိနစ်။';

  @override
  String get planTaglineMax => 'ယခု သူတို့ကို မြင်နိုင်ပြီ။';

  @override
  String get planTaglineFree => 'တစ်နေ့ တစ်ကြိမ်။ အခမဲ့။';

  @override
  String get bulletProCalls => 'ကြိုက်သလောက် အသံခေါ်ဆိုမှု';

  @override
  String get bulletProLength => 'တစ်ကြိမ်လျှင် ၁၅ မိနစ်';

  @override
  String get bulletProScoring => 'စာလုံးတစ်လုံးချင်း အသံထွက် အမှတ်ပေးမှု';

  @override
  String get bulletProCorrections => 'သင့်မိခင်ဘာသာစကားအလိုက် ပြင်ဆင်ချက်များ';

  @override
  String get bulletProBeaverCalls => 'Beaver က သင့်ကို အရင်ခေါ်မည်';

  @override
  String get bulletMaxVideo => 'မျက်နှာချင်းဆိုင် ဗီဒီယိုခေါ်ဆိုမှု';

  @override
  String get bulletMaxEverything => 'Pro ပါ အရာအားလုံး';

  @override
  String get bulletMaxCharacters => 'ဇာတ်ကောင်အားလုံး၊ အကန့်အသတ်မဲ့';

  @override
  String get bulletMaxStudyBook => 'သင့်အဆင့်နှင့် ကိုက်ညီသော လေ့လာစာအုပ်';

  @override
  String get bulletMaxWeeklyReport =>
      'သင့်အသံထွက် ပြောင်းလဲပုံ အပတ်စဉ် အစီရင်ခံစာ';

  @override
  String get bulletFreeCall => 'တစ်နေ့ ၅ မိနစ် အသံခေါ်ဆိုမှု တစ်ကြိမ်';

  @override
  String get bulletFreeCheck => 'တစ်နေ့ အသံထွက်စစ်ဆေးမှု တစ်ကြိမ်';

  @override
  String get bulletFreeAccent => 'အကန့်အသတ်မဲ့ လေယူလေသိမ်း စစ်ဆေးမှု';

  @override
  String get bulletFreeCharacter => 'စတင်ရန် ဇာတ်ကောင်တစ်ကောင်';

  @override
  String get ctaGoUnlimited => 'အကန့်အသတ်မဲ့ သုံးရန်';

  @override
  String get ctaTurnOnVideo => 'ဗီဒီယို ဖွင့်ရန်';

  @override
  String get noteCallLength => 'ခေါ်ဆိုမှုတစ်ကြိမ်လျှင် ၁၅ မိနစ်ဖြစ်သည်။';

  @override
  String get paywallProTitle1 => 'သင့်ကိုရီးယား သူငယ်ချင်း';

  @override
  String get paywallProTitle2 => 'နံနက် ၃ နာရီမှာလည်း နိုးနေတယ်';

  @override
  String get paywallProSub =>
      'အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု။ တစ်ကြိမ် ၁၅ မိနစ်။ တစ်နှစ်ပတ်လုံး။';

  @override
  String get paywallLimitHeadline => 'Pro က ကန့်သတ်ချက်ကို ဖယ်ရှားပေးသည်။';

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
  String get paywallMaxSub =>
      'ဗီဒီယိုခေါ်ဆိုမှု၊ ဇာတ်ကောင်အားလုံးနှင့် သင့်အဆင့်အတွက် ပြုလုပ်ထားသော လေ့လာစာအုပ်။';

  @override
  String get planMonthly => 'လစဉ်';

  @override
  String get planAnnual => 'နှစ်စဉ်';

  @override
  String get proMonthlyPriceLine => 'တစ်လ \$12.90';

  @override
  String get proAnnualPriceLine => '\$100.00 · တစ်လ \$8.33';

  @override
  String get maxMonthlyPriceLine => 'တစ်လ \$19.90';

  @override
  String get maxAnnualPriceLine => 'တစ်နှစ် \$159.00 · တစ်လ \$13.25';

  @override
  String get ctaCaptionPro =>
      'တစ်လ \$12.90 · စတိုးတွင် အချိန်မရွေး ပယ်ဖျက်နိုင်';

  @override
  String get ctaCaptionMax =>
      'တစ်လ \$19.90 · စတိုးတွင် အချိန်မရွေး ပယ်ဖျက်နိုင်';

  @override
  String get footerTerms => 'စည်းမျဉ်းများ';

  @override
  String get footerPrivacy => 'ကိုယ်ရေးလုံခြုံမှု';

  @override
  String get noteMaxCharacters =>
      'Max ဖြင့် ဖွင့်ထားသော ဇာတ်ကောင်များကို စာရင်းသွင်းမှု သက်ဝင်နေစဉ် သုံးနိုင်သည်။ ဝယ်ထားသော ဇာတ်ကောင်များ သင့်ပိုင် ဆက်ဖြစ်သည်။';

  @override
  String get processingTitle => 'သင့်ဝယ်ယူမှုကို အတည်ပြုနေသည်';

  @override
  String get processingSub => 'ပုံမှန်အားဖြင့် စက္ကန့်အနည်းငယ် ကြာသည်။';

  @override
  String get successProTitle => 'ယခု Pro ဖြစ်ပါပြီ။';

  @override
  String get successProSub => 'အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု၊ ယခုချက်ချင်း စတင်။';

  @override
  String get successProBenefit1 => 'ကြိုက်သလောက် ခေါ်ဆိုပါ — တစ်ကြိမ် ၁၅ မိနစ်';

  @override
  String get successProBenefit2 => 'အကန့်အသတ်မဲ့ အသံထွက်စစ်ဆေးမှု';

  @override
  String get successProBenefit3 =>
      'ဇာတ်ကောင်အားလုံးနှင့် တစ်ကြိမ်တည်း ဝယ်ယူမှုများ';

  @override
  String get successMaxTitle => 'ယခု သူတို့ကို မြင်နိုင်ပြီ။';

  @override
  String get successMaxSub =>
      'ဗီဒီယိုခေါ်ဆိုမှု ဖွင့်ပြီးပြီ။ မည်သည့်ခေါ်ဆိုမှုတွင်မဆို ဗီဒီယိုခလုတ်ကို နှိပ်ပါ။';

  @override
  String get successMaxBenefit1 => 'မျက်နှာချင်းဆိုင် ဗီဒီယိုခေါ်ဆိုမှု';

  @override
  String get successMaxBenefit2 =>
      'ဇာတ်ကောင်အားလုံး အကန့်အသတ်မဲ့ — အသစ်များကို အရင်ရ';

  @override
  String get successMaxBenefit3 => 'သင့်အဆင့်နှင့် ကိုက်ညီသော လေ့လာစာအုပ်';

  @override
  String get ctaStartACall => 'ခေါ်ဆိုမှု စတင်ရန်';

  @override
  String get ctaStartAVideoCall => 'ဗီဒီယိုခေါ်ဆိုမှု စတင်ရန်';

  @override
  String get ctaSeeYourSubscription => 'သင့်စာရင်းသွင်းမှု ကြည့်ရန်';

  @override
  String get successProCaption =>
      'မပယ်ဖျက်မချင်း တစ်လ \$12.90 ကောက်ခံသည်။ စတိုးတွင် အချိန်မရွေး စီမံ သို့မဟုတ် ပယ်ဖျက်နိုင်သည်။';

  @override
  String get successMaxCaption =>
      'မပယ်ဖျက်မချင်း တစ်လ \$19.90 ကောက်ခံသည်။ စတိုးတွင် အချိန်မရွေး စီမံ သို့မဟုတ် ပယ်ဖျက်နိုင်သည်။';

  @override
  String get plansErrorTitle => 'အစီအစဉ်များ ဖွင့်၍မရပါ';

  @override
  String get plansErrorSub => 'စတိုးမှ တုံ့ပြန်မှု မရပါ။';

  @override
  String get ctaTryAgain => 'ထပ်ကြိုးစားရန်';

  @override
  String get plansErrorCaption => 'ငွေမကောက်ခံခဲ့ပါ။';

  @override
  String get changePlanTitle => 'အစီအစဉ် ပြောင်းရန်';

  @override
  String get moveToMaxTitle => 'Max သို့ ပြောင်းရန်';

  @override
  String get maxPriceShort => '\$19.90 / လ';

  @override
  String get moveToMaxCardSub =>
      'မျက်နှာချင်းဆိုင် ဗီဒီယိုခေါ်ဆိုမှု · ဇာတ်ကောင်အားလုံး · သင့်အတွက် လေ့လာစာအုပ်';

  @override
  String get whatHappensNow => 'ယခု ဖြစ်လာမည့်အရာ';

  @override
  String get maxStartsLabel => 'Max စတင်ချိန်';

  @override
  String get immediately => 'ချက်ချင်း';

  @override
  String get unusedProTime => 'Pro မသုံးရသေးသော ကာလ';

  @override
  String get creditedTowardMax => 'Max သို့ ခုနှိမ်ပေးမည်';

  @override
  String nextPaymentMaxValue(String date) {
    return '\$19.90 · $date';
  }

  @override
  String nextPaymentProValue(String date) {
    return '\$12.90 · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max သို့ ပြောင်းရန်';

  @override
  String get upgradeCaption =>
      'အစီအစဉ်အသစ် ချက်ချင်း စတင်သည်။ Pro ကျန်ကာလကို ခုနှိမ်ပေးပြီး နှစ်ကြိမ် မကောက်ခံပါ။';

  @override
  String get moveToProTitle => 'Pro သို့ ပြောင်းရန်';

  @override
  String get moveToProSub =>
      'ယနေ့ ဘာမှ မပြောင်းပါ။ ပေးချေပြီးသော လကုန်အထိ Max ဆက်သုံးနိုင်သည်။';

  @override
  String get maxRunsUntil => 'Max သုံးနိုင်သည့်ရက်';

  @override
  String get proStarts => 'Pro စတင်ချိန်';

  @override
  String get whatYouKeep => 'ဆက်ရရှိမည့်အရာ';

  @override
  String get keepBenefitCalls =>
      'အကန့်အသတ်မဲ့ အသံခေါ်ဆိုမှု၊ တစ်ကြိမ် ၁၅ မိနစ်';

  @override
  String get keepBenefitCharacters => 'ဝယ်ထားသော ဇာတ်ကောင်များ ထာဝရ သင့်ပိုင်';

  @override
  String downgradeWarning(String date) {
    return '$date တွင် ဗီဒီယိုခေါ်ဆိုမှုနှင့် Max သီးသန့် ဇာတ်ကောင်များ ပိတ်သွားမည်။';
  }

  @override
  String get ctaSwitchToPro => 'Pro သို့ ပြောင်းရန်';

  @override
  String get ctaKeepMax => 'Max ဆက်ထားရန်';

  @override
  String get winbackSkip => 'ကျော်ရန်';

  @override
  String get winbackTitle => 'သင့် Pro အစီအစဉ် ကုန်ဆုံးပြီ';

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
  String get ovRestoreSuccessTitle => 'Pro ပြန်ရောက်ပြီ';

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
  String get ovCharacterOfferTitle => 'Pro အတွက် မသင့်သေးဘူးလား။';

  @override
  String get ovCharacterOfferBody =>
      'ဇာတ်ကောင်တစ်ကောင် ရွေးပြီး ထာဝရ ပိုင်ဆိုင်ပါ။ တစ်ကြိမ်တည်း ဝယ်ယူမှု — စာရင်းသွင်းစရာမလို၊ သက်တမ်းတိုးစရာမလို။';

  @override
  String get rowOneCharacter => 'ဇာတ်ကောင် တစ်ကောင်';

  @override
  String get rowFromPrice => '\$5.00 မှစ၍';

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
  String get rowYearlyMonthEquiv => 'တစ်လ \$8.33';

  @override
  String get rowCharactersYouBought => 'ဝယ်ထားသော ဇာတ်ကောင်များ';

  @override
  String get rowProRunsUntil => 'Pro သုံးနိုင်သည့်ရက်';

  @override
  String get ctaSwitchToYearly => 'နှစ်စဉ်သို့ ပြောင်းရန်';

  @override
  String get ctaContinueToStore => 'စတိုးသို့ ဆက်သွားရန်';

  @override
  String get ovAnnualSwitchTitle => 'နှစ်စဉ်ပေးချေပြီး \$54.80 ချွေတာပါ';

  @override
  String get ovAnnualSwitchBody =>
      'Pro ကို နှစ်လ သုံးထားပြီးပြီ။ နှစ်စဉ်အစီအစဉ်က ပိုသက်သာသည်။';

  @override
  String get rowYouSave => 'ချွေတာနိုင်ငွေ';

  @override
  String get amountSaved => '\$54.80';

  @override
  String get rowYearly => 'နှစ်စဉ်';

  @override
  String get amountYearly => '\$100.00';

  @override
  String get rowMonthlyForYear => 'လစဉ်၊ တစ်နှစ်စာ';

  @override
  String get amountMonthlyForYear => '\$154.80';

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
      'မပယ်ဖျက်ပါက Max ဆက်သွားမည်။ ဖြစ်လာမည့်အရာများမှာ —';

  @override
  String get rowTrialEnds => 'အစမ်းသုံး ကုန်ဆုံးချိန်';

  @override
  String get rowFirstCharge => 'ပထမ ကောက်ခံမှု';

  @override
  String get rowThenMonthly => 'ထို့နောက် လစဉ်';

  @override
  String get ctaCancelInStore => 'စတိုးတွင် ပယ်ဖျက်ရန်';

  @override
  String get ovTrialStartTitle => 'Max ၇ ရက်၊ အခမဲ့';

  @override
  String ovTrialStartBody(String date) {
    return '$date အထိ အခမဲ့။ ထို့နောက် တစ်လ \$19.90၊ စတိုးတွင် မပယ်ဖျက်ပါက။';
  }

  @override
  String get ctaStart7Days => '၇ ရက် အခမဲ့ စတင်ရန်';

  @override
  String get ovOtoTitle => 'မစတင်မီ နောက်ထပ် တစ်ခု';

  @override
  String get ovOtoBody =>
      'ကောင်းသော ရွေးချယ်မှု — အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု ယခုဖွင့်ပြီးပြီ။ နှစ်စဉ်ပေးချေလျှင် တူညီသော Pro ကို ပိုသက်သာစွာ ရသည်။';

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
  String get ovAlreadyTitle => 'Pro ကို သုံးနေပြီးသား ဖြစ်သည်';

  @override
  String get ovAlreadyBody =>
      'ဤစတိုးအကောင့်တွင် သက်ဝင် အစီအစဉ်ရှိသည်။ ဝယ်စရာ မရှိပါ။';

  @override
  String get ctaSeeMySubscription => 'ကျွန်ုပ်၏ စာရင်းသွင်းမှု ကြည့်ရန်';

  @override
  String get subCancelTitle => 'စာရင်းသွင်းမှု ပယ်ဖျက်ရန်';

  @override
  String subCancelBody(String date) {
    return 'Pro $date အထိ သက်ဝင်သည်။ ထို့နောက် Free သို့ ပြောင်းမည်။';
  }

  @override
  String get subWhatYouLose => 'ဆုံးရှုံးမည့်အရာ';

  @override
  String get benefitCalls15 => 'အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု၊ တစ်ကြိမ် ၁၅ မိနစ်';

  @override
  String get benefitScoring => 'စာလုံးတစ်လုံးချင်း အသံထွက် အမှတ်ပေးမှု';

  @override
  String get benefitEveryCharacter => 'ဇာတ်ကောင်အားလုံး၊ အကန့်အသတ်မဲ့';

  @override
  String get ctaKeepPro => 'Pro ဆက်ထားရန်';

  @override
  String get subPaymentTitle => 'ငွေပေးချေမှု အပ်ဒိတ်လုပ်ရန်';

  @override
  String get subPaymentBody =>
      'ငွေပေးချေမှု မအောင်မြင်ပါ။ ဆိုင်းငံ့ကာလအတွင်း Pro ဆက်သုံးနိုင်သည်။';

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
    return 'Pro $date တွင် ကုန်ဆုံးမည်။ အလိုအလျောက် သက်တမ်းတိုးကို ပြန်ဖွင့်ပါက ဘာမှ မပြောင်းပါ။';
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
      'Free တွင် တစ်နေ့ တစ်ကြိမ်။ Pro ဖြင့် အကန့်အသတ်မဲ့။';

  @override
  String get flBenefitCalls =>
      'Pro ဖြင့် အကန့်အသတ်မဲ့ ခေါ်ဆိုမှု · တစ်ကြိမ် ၁၅ မိနစ်';

  @override
  String get flBenefitChecks => 'Pro ဖြင့် အကန့်အသတ်မဲ့ အသံထွက်စစ်ဆေးမှု';

  @override
  String get flCaption => 'တစ်လ \$12.90 · အချိန်မရွေး ပယ်ဖျက်နိုင်';

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
  String get emailLabel => 'Email';

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
}
