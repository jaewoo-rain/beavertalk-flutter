// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

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
  String get oneFixTitle => 'Today\'s feedback';

  @override
  String streakBadge(int count) {
    return '$count calls in a row';
  }

  @override
  String newExpressionsCount(int count) {
    return 'New expressions $count';
  }

  @override
  String get analysisLoadError => 'ဆန်းစစ်ချက် ရလဒ် ဖွင့်၍မရပါ။';

  @override
  String get standardAudioNotReady => 'စံအသံထွက် အသံဖိုင် မပြင်ဆင်ရသေးပါ။';

  @override
  String get standardAudioPlayError => 'စံအသံထွက် အသံဖိုင် ဖွင့်၍မရပါ။';

  @override
  String get selectACountry => 'နိုင်ငံ ရွေးချယ်ပါ';

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
}
