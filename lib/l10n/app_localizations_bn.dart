// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'কল শেষ হয়েছে $duration';
  }

  @override
  String get callRatingPrompt => 'আপনার কল কেমন ছিল?';

  @override
  String get ratingBad => 'ভালো না';

  @override
  String get ratingOkay => 'মোটামুটি';

  @override
  String get ratingGood => 'ভালো';

  @override
  String get goHome => 'হোম';

  @override
  String get viewAnalysis => 'বিশ্লেষণ দেখুন';

  @override
  String get loadingShort => 'লোড হচ্ছে…';

  @override
  String ratingSubmitFailed(String message) {
    return 'রেটিং জমা দেওয়া যায়নি: $message';
  }

  @override
  String get callInfoNotFound =>
      'কলের তথ্য পাওয়া যায়নি, বিশ্লেষণ বাদ দেওয়া হচ্ছে।';

  @override
  String get tabRecords => 'রেকর্ড';

  @override
  String get tabArchive => 'আর্কাইভ';

  @override
  String get callHistory => 'কল ইতিহাস';

  @override
  String get conversationRecord => 'কথোপকথনের রেকর্ড';

  @override
  String get noCallRecords => 'এখনও কোনো কল রেকর্ড নেই';

  @override
  String get noCallRecordsBody =>
      'AI-এর সাথে আপনার প্রথম কল শেষ করলে,\nআপনার রেকর্ড এখানে দেখা যাবে।';

  @override
  String get startCall => 'কল শুরু করুন';

  @override
  String get recordsLoadError => 'রেকর্ড লোড করা যায়নি';

  @override
  String get tryAgainLater => 'অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get retry => 'পুনরায় চেষ্টা করুন';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes মিনিট $seconds সেকেন্ড';
  }

  @override
  String get scheduleManagement => 'সময়সূচি';

  @override
  String get alarms => 'অ্যালার্ম';

  @override
  String get addSchedule => 'সময়সূচি যোগ করুন';

  @override
  String get editSchedule => 'সময়সূচি সম্পাদনা করুন';

  @override
  String get somethingWentWrong => 'কিছু একটা সমস্যা হয়েছে';

  @override
  String get alarmsLoadError => 'অ্যালার্ম লোড করা যায়নি';

  @override
  String get charactersLoadError => 'ক্যারেক্টার লোড করা যায়নি';

  @override
  String get noCharacters => 'কোনো ক্যারেক্টার উপলব্ধ নেই';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get repeat => 'পুনরাবৃত্তি';

  @override
  String get callPartner => 'ক্যারেক্টার';

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
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get conversation => 'কথোপকথন';

  @override
  String get review => 'পর্যালোচনা';

  @override
  String get pronunciationChallenge => 'উচ্চারণ চ্যালেঞ্জ';

  @override
  String get newExpressions => 'নতুন অভিব্যক্তি';

  @override
  String get analysisResult => 'বিশ্লেষণের ফলাফল';

  @override
  String get noNewExpressions => 'এই কথোপকথনে কোনো নতুন অভিব্যক্তি নেই।';

  @override
  String get practice => 'অনুশীলন';

  @override
  String recentScore(int score) {
    return 'সাম্প্রতিক স্কোর $score%';
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
  String get analysisLoadError => 'বিশ্লেষণের ফলাফল লোড করা যায়নি।';

  @override
  String get standardAudioNotReady =>
      'স্ট্যান্ডার্ড উচ্চারণের অডিও এখনও প্রস্তুত নয়।';

  @override
  String get standardAudioPlayError =>
      'স্ট্যান্ডার্ড উচ্চারণের অডিও চালানো যায়নি।';

  @override
  String get selectACountry => 'একটি দেশ নির্বাচন করুন';

  @override
  String get selectYourLanguage => 'আপনার ভাষা নির্বাচন করুন';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get selectTime => 'সময় নির্বাচন করুন';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get permissionTitle => 'সাবলীল অভিজ্ঞতার জন্য\nঅনুমতি দিন';

  @override
  String get permissionSubtitle =>
      'সেবাটি ব্যবহার করতে প্রয়োজনীয় অনুমতিগুলো অপরিহার্য।';

  @override
  String get permissionMicTitle => 'মাইক্রোফোন (আবশ্যক)';

  @override
  String get permissionMicDesc => 'AI-এর সাথে ইংরেজিতে কথা বলার জন্য প্রয়োজন।';

  @override
  String get permissionNotifTitle => 'নোটিফিকেশন (ঐচ্ছিক)';

  @override
  String get permissionNotifDesc =>
      'আমরা শেখার রিমাইন্ডার এবং কল সময়সূচি পাঠাব।';

  @override
  String get micPermissionNeededTitle => 'মাইক্রোফোন অ্যাক্সেস প্রয়োজন';

  @override
  String get micPermissionNeededBody =>
      'AI-এর সাথে কথা বলতে, আপনাকে মাইক্রোফোন অ্যাক্সেসের অনুমতি দিতে হবে। অনুগ্রহ করে সেটিংসে এটি চালু করুন।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get connectionFailedTitle => 'সংযোগ ব্যর্থ হয়েছে';

  @override
  String get connectionFailedBody =>
      'আপনার নেটওয়ার্ক সংযোগ পরীক্ষা করুন\nএবং আবার চেষ্টা করুন।';

  @override
  String get checkout => 'চেকআউট';

  @override
  String get pay => 'পরিশোধ করুন';

  @override
  String get orderSummary => 'অর্ডার সারাংশ';

  @override
  String get paymentMethod => 'পেমেন্ট পদ্ধতি';

  @override
  String get payMethodCard => 'ক্রেডিট / ডেবিট কার্ড';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'বিরক্তিকর বিভার অ্যাভাটার';

  @override
  String get productTrait => 'প্রিমিয়াম ক্যারেক্টার · চিরদিনের জন্য আপনার';

  @override
  String get amountItemPrice => 'পণ্যের মূল্য';

  @override
  String get amountDiscount => 'ছাড়';

  @override
  String get amountTotal => 'মোট';

  @override
  String get paymentCompleteTitle => 'পেমেন্ট সম্পন্ন হয়েছে';

  @override
  String get paymentCompleteBody => 'অ্যাভাটারটি আপনার সংগ্রহে যোগ করা হয়েছে।';

  @override
  String get viewCollection => 'সংগ্রহ দেখুন';

  @override
  String get receiptItem => 'পণ্য';

  @override
  String get receiptAmount => 'পরিমাণ';

  @override
  String get receiptMethod => 'পেমেন্ট পদ্ধতি';

  @override
  String get receiptDate => 'তারিখ';

  @override
  String get paymentFailedTitle => 'পেমেন্ট ব্যর্থ হয়েছে';

  @override
  String get paymentFailedBody =>
      'আপনার পেমেন্ট প্রক্রিয়া করা যায়নি।\nঅনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get freeCallEndingTitle => 'আপনার ফ্রি কল শেষ হয়ে আসছে';

  @override
  String get freeCallEndingBody =>
      'বিভারের সাথে আরও বেশি সময় কথা বলতে সাবস্ক্রাইব করুন।';

  @override
  String get subscribe => 'সাবস্ক্রাইব করুন';

  @override
  String get endCall => 'কল শেষ করুন';

  @override
  String get callEnded => 'কলটি শেষ হয়েছে।';

  @override
  String get connecting => 'সংযোগ হচ্ছে…';

  @override
  String get connectingHint => 'এটি সাধারণত ৫ সেকেন্ডের কম সময় নেয়';

  @override
  String get callConnectFailed => 'কল সংযোগ করা যায়নি।';

  @override
  String get saveSentenceFailed => 'বাক্যটি সংরক্ষণ করা যায়নি।';

  @override
  String get recordStartFailed => 'রেকর্ডিং শুরু করা যায়নি।';

  @override
  String get recordTooShort =>
      'রেকর্ডিংটি খুব সংক্ষিপ্ত ছিল। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get gradingFailed =>
      'স্কোরিং ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get listenStandard => 'স্ট্যান্ডার্ড উচ্চারণ শুনুন';

  @override
  String get saveSentence => 'বাক্য সংরক্ষণ করুন';

  @override
  String get unsaveSentence => 'সংরক্ষিত বাক্য সরান';

  @override
  String get scoringPronunciation => 'আপনার উচ্চারণ স্কোর করা হচ্ছে…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'চালানোর জন্য কোনো রেকর্ডিং নেই।';

  @override
  String get myRecordingPlayError => 'আপনার রেকর্ডিং চালানো যায়নি।';

  @override
  String get next => 'পরবর্তী';

  @override
  String get endLearning => 'সেশন শেষ করুন';

  @override
  String get navCalendar => 'ক্যালেন্ডার';

  @override
  String get navCall => 'কল';

  @override
  String get navStats => 'পরিসংখ্যান';

  @override
  String get myPage => 'আমার পেজ';

  @override
  String get languageSaveFailed => 'আপনার ভাষা সংরক্ষণ করা যায়নি।';

  @override
  String get accountDeleteFailed => 'আপনার অ্যাকাউন্ট মুছে ফেলা যায়নি।';

  @override
  String get changeAvatar => 'অ্যাভাটার পরিবর্তন করুন';

  @override
  String get avatarIntro =>
      'কণ্ঠস্বর এবং কঠিনতা কল পার্টনার অনুযায়ী ভিন্ন হয়।\nকিছু পার্টনারের জন্য পেমেন্ট লাগতে পারে।';

  @override
  String myPartnersOwned(int count) {
    return 'আমার পার্টনার · $countটি আছে';
  }

  @override
  String get limitedDiscount => 'সীমিত সময়ের ছাড়';

  @override
  String get available => 'উপলব্ধ';

  @override
  String get inUse => 'ব্যবহৃত হচ্ছে';

  @override
  String get owned => 'মালিকানাধীন';

  @override
  String get noCharactersToShow => 'দেখানোর জন্য কোনো ক্যারেক্টার নেই';

  @override
  String get buy => 'কিনুন';

  @override
  String get noSavedSentences =>
      'এখনও কোনো সংরক্ষিত বাক্য নেই।\nআপনার কথোপকথনের রেকর্ড থেকে বাক্য বুকমার্ক করুন।';

  @override
  String get noAlarms => 'এখনও কোনো অ্যালার্ম নেই';

  @override
  String get noAlarmsBody =>
      'নিয়মিত অভ্যাস গড়ে তুলতে\nএকটি শেখার রিমাইন্ডার যোগ করুন।';

  @override
  String get subscriptionManage => 'সাবস্ক্রিপশন পরিচালনা করুন';

  @override
  String get changePlan => 'প্ল্যান পরিবর্তন করুন';

  @override
  String get cancelSubscription => 'সাবস্ক্রিপশন বাতিল করুন';

  @override
  String get benefitsInUse => 'আপনার সুবিধাসমূহ';

  @override
  String get paymentInfo => 'পেমেন্ট তথ্য';

  @override
  String get nextBillingDate => 'পরবর্তী বিলিং তারিখ';

  @override
  String get lostBenefitsTitle => 'বাতিল করলে আপনি যেসব সুবিধা হারাবেন';

  @override
  String get viewBillingHistory => 'বিলিং ইতিহাস দেখুন';

  @override
  String get keepUsingPro => 'Pro ব্যবহার চালিয়ে যান';

  @override
  String get proMembership => 'Pro সদস্যপদ';

  @override
  String get pricePerMonth => '\$12.9 / মাস';

  @override
  String get benefitUnlimitedCalls => 'সীমাহীন কল';

  @override
  String get benefitDetailedAnalysis => 'বিস্তারিত উচ্চারণ ও ব্যাকরণ বিশ্লেষণ';

  @override
  String get benefitAllCharacters => 'সব ক্যারেক্টারে অ্যাক্সেস';

  @override
  String get benefitNoAds => 'কোনো বিজ্ঞাপন নেই';

  @override
  String get playSampleVoice => 'নমুনা কণ্ঠস্বর চালান';

  @override
  String get useThisAvatar => 'এটি ব্যবহার করুন';

  @override
  String get challengeTitle => 'উচ্চারণ চ্যালেঞ্জ';

  @override
  String get challengeIntro =>
      'জোনের প্রতিটি কার্ড ক্লিয়ার করতে কোরিয়ান ভাষায় সঠিকভাবে উচ্চারণ করুন।\nমাইক নেই? স্ক্রিনে ট্যাপ করেও খেলতে পারেন।';

  @override
  String get challengeStart => 'ক্যামেরা ও মাইক শুরু করুন';

  @override
  String get challengePermissionNote =>
      'ফ্রন্ট ক্যামেরা ও মাইক অ্যাক্সেস প্রয়োজন (ঐচ্ছিক)।';

  @override
  String get challengeLoadingTitle => 'লোড হচ্ছে…';

  @override
  String get challengeLoadingNote =>
      'প্রথমবার চালু করার সময় কোরিয়ান স্পিচ মডেল (~৮২MB) ডাউনলোড হচ্ছে।\nঅনুগ্রহ করে একটু অপেক্ষা করুন।';

  @override
  String get challengeSttFallback =>
      'স্পিচ রিকগনিশন উপলব্ধ ছিল না, তাই আপনি ট্যাপ ইনপুট দিয়ে খেলেছেন।';

  @override
  String get reasonTravelTitle => 'ভ্রমণের সময় কথা বলা';

  @override
  String get reasonTravelDesc => 'স্থানীয়দের সাথে আত্মবিশ্বাসের সাথে কথা বলুন';

  @override
  String get reasonCareerTitle => 'কাজ ও ক্যারিয়ার';

  @override
  String get reasonCareerDesc => 'ব্যবসায়িক কথোপকথন';

  @override
  String get reasonExamTitle => 'পরীক্ষার প্রস্তুতি';

  @override
  String get reasonExamDesc => 'স্পিকিং টেস্টের জন্য প্রস্তুতি নিন';

  @override
  String get reasonDailyTitle => 'দৈনন্দিন কথোপকথন';

  @override
  String get reasonDailyDesc => 'আপনি প্রতিদিন যেসব অভিব্যক্তি ব্যবহার করেন';

  @override
  String get reasonFriendsTitle => 'বিদেশি বন্ধু তৈরি করা';

  @override
  String get reasonFriendsDesc => 'স্বাভাবিক কথোপকথন';

  @override
  String get reasonBrainTitle => 'মস্তিষ্কের উদ্দীপনা';

  @override
  String get reasonBrainDesc => 'স্মৃতিশক্তি ও মনোযোগ বাড়ান';

  @override
  String get challengeRecordToggle => 'এই রান রেকর্ড করুন';

  @override
  String get challengeRecordHint =>
      'শেয়ার করার জন্য আপনার গেমপ্লের একটি ভিডিও সংরক্ষণ করে (নিঃশব্দ)।';

  @override
  String get settingsSection => 'সেটিংস';

  @override
  String get paymentSection => 'পেমেন্ট';

  @override
  String get supportSection => 'সহায়তা';

  @override
  String get userLanguage => 'ব্যবহারকারীর ভাষা';

  @override
  String get learningLanguage => 'শেখার ভাষা';

  @override
  String get learningLanguageKorean => 'কোরিয়ান';

  @override
  String get notificationLabel => 'নোটিফিকেশন';

  @override
  String get currentPlan => 'বর্তমান প্ল্যান';

  @override
  String get paymentHistory => 'পেমেন্ট ইতিহাস';

  @override
  String get contactUs => 'যোগাযোগ করুন';

  @override
  String get termsOfService => 'সেবার শর্তাবলী';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get logOut => 'লগ আউট';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountTitle => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteAccountBody =>
      'এটি আপনার অ্যাকাউন্ট ও ডেটা স্থায়ীভাবে মুছে ফেলবে এবং এটি ফিরিয়ে আনা যাবে না।';

  @override
  String get delete => 'মুছুন';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get accentSoundsLike => 'আপনার কোরিয়ান উচ্চারণ শোনায়';

  @override
  String get hintLabel => 'ইঙ্গিত';

  @override
  String get nextHint => 'পরবর্তী ইঙ্গিত';

  @override
  String get translateLabel => 'অনুবাদ';

  @override
  String get startRecording => 'রেকর্ডিং শুরু করুন';

  @override
  String get stopRecording => 'রেকর্ডিং বন্ধ করুন';

  @override
  String get back => 'পেছনে';

  @override
  String get onboardingNameTitle => 'আমরা আপনাকে কী বলে ডাকব?';

  @override
  String get onboardingNameSubtitle => 'আপনার AI টিউটর আপনার নাম মনে রাখবে।';

  @override
  String get nameLabel => 'আপনার নাম';

  @override
  String get nameHint => 'আপনার নাম লিখুন';

  @override
  String get nameHelper => 'এটি আপনার আসল নাম হতে হবে না — একটি ডাকনামও চলবে।';

  @override
  String get continueLabel => 'চালিয়ে যান';

  @override
  String get onboardingDoneTitle => 'বিভার আপনার কলের অপেক্ষায় আছে';

  @override
  String get onboardingDoneSubtitle => 'এখনই একটি কল শুরু করুন';

  @override
  String get home => 'হোম';

  @override
  String get callNow => 'এখনই কল করুন';

  @override
  String get pronunciation => 'উচ্চারণ';

  @override
  String get fluency => 'সাবলীলতা';

  @override
  String get rhythm => 'ছন্দ';

  @override
  String get analysisTimeout =>
      'এটি প্রত্যাশার চেয়ে বেশি সময় নিচ্ছে। অনুগ্রহ করে একটু পরে আবার চেষ্টা করুন।';

  @override
  String get analysisFailed =>
      'আমরা কথোপকথনটি বিশ্লেষণ করতে পারিনি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get analyzingConversation => 'আপনার কথোপকথন বিশ্লেষণ করা হচ্ছে…';

  @override
  String get analyzingSubtitle => 'এতে মাত্র কয়েক মুহূর্ত সময় লাগবে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get nativeLabel => 'নেটিভ';

  @override
  String get meLabel => 'আমি';

  @override
  String get pronunciationPlayError => 'উচ্চারণের অডিও চালানো যায়নি।';

  @override
  String get savedExpressionsLoadError =>
      'আপনার সংরক্ষিত অভিব্যক্তি লোড করা যায়নি।';

  @override
  String get mySavedExpressions => 'আমার সংরক্ষিত অভিব্যক্তি';

  @override
  String get avatarTraits => 'উষ্ণ · শান্ত · কোমল';

  @override
  String get priceFree => 'ফ্রি';

  @override
  String get loginGoogleTokenError => 'Google সাইন-ইন টোকেন পাওয়া যায়নি।';

  @override
  String get loginGoogleSignInFailed => 'Google সাইন-ইন ব্যর্থ হয়েছে।';

  @override
  String get loginAppleSignInFailed => 'Apple সাইন-ইন ব্যর্থ হয়েছে।';

  @override
  String get loginKakaoSignInFailed => 'Kakao সাইন-ইন ব্যর্থ হয়েছে।';

  @override
  String get loginContinueWithKakao => 'Kakao দিয়ে চালিয়ে যান';

  @override
  String get loginContinueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get loginContinueWithApple => 'Apple দিয়ে চালিয়ে যান';

  @override
  String get loginContinueWithEmail => 'ইমেইল দিয়ে চালিয়ে যান';

  @override
  String get loginOrDivider => 'অথবা';

  @override
  String get loginNoAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get signUp => 'সাইন আপ করুন';

  @override
  String get loginTermsNoticePrefix => 'চালিয়ে গেলে, আপনি আমাদের ';

  @override
  String get loginTermsNoticeAnd => ' এবং ';

  @override
  String get loginTermsNoticeSuffix => '-এ সম্মত হচ্ছেন।';

  @override
  String get loginLogIn => 'লগ ইন করুন';

  @override
  String get fieldEmailLabel => 'ইমেইল';

  @override
  String get emailHint => 'আপনার ইমেইল লিখুন';

  @override
  String get fieldPasswordLabel => 'পাসওয়ার্ড';

  @override
  String get passwordHint => 'আপনার পাসওয়ার্ড লিখুন';

  @override
  String get loginRememberMe => 'আমাকে মনে রাখুন';

  @override
  String get loginForgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get loginLoggingIn => 'লগ ইন হচ্ছে...';

  @override
  String get passwordLengthError => 'পাসওয়ার্ড অবশ্যই ৮–১৬ অক্ষরের হতে হবে।';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না।';

  @override
  String get signupCheckInput => 'অনুগ্রহ করে আপনার তথ্য যাচাই করুন।';

  @override
  String get fieldConfirmPasswordLabel => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get confirmPasswordHint => 'আপনার পাসওয়ার্ড আবার লিখুন';

  @override
  String get signupSigningUp => 'সাইন আপ হচ্ছে...';

  @override
  String get signupHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get passwordMethodEmailRequired => 'আপনার ইমেইল লিখুন';

  @override
  String get passwordResetTitle => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get passwordMethodDescription =>
      'যে ইমেইল ঠিকানায় পাসওয়ার্ড রিসেট কোড পেতে চান, তা লিখুন।';

  @override
  String get emailAddressHint => 'ইমেইল ঠিকানা';

  @override
  String get passwordMethodSending => 'পাঠানো হচ্ছে...';

  @override
  String get passwordMethodSendEmail => 'ইমেইল পাঠান';

  @override
  String get passwordCodeTitle => 'কোড লিখুন';

  @override
  String get passwordCodeDescription =>
      'আমরা আপনার ইমেইলে একটি রিকভারি কোড পাঠিয়েছি। চালিয়ে যেতে এটি লিখুন।';

  @override
  String get passwordCodeNoCode => 'কোড পাননি?';

  @override
  String get passwordCodeResend => 'কোড আবার পাঠান';

  @override
  String get passwordCodeVerifying => 'যাচাই করা হচ্ছে...';

  @override
  String get passwordNewTitle => 'নতুন পাসওয়ার্ড';

  @override
  String get passwordNewDescription =>
      'আপনার অ্যাকাউন্টের জন্য একটি নতুন পাসওয়ার্ড সেট করুন।';

  @override
  String get fieldNewPasswordLabel => 'নতুন পাসওয়ার্ড';

  @override
  String get newPasswordHint => 'আপনার নতুন পাসওয়ার্ড লিখুন';

  @override
  String get fieldConfirmNewPasswordLabel => 'নতুন পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get confirmNewPasswordHint => 'আপনার নতুন পাসওয়ার্ড আবার লিখুন';

  @override
  String get passwordNewSubmitting => 'জমা দেওয়া হচ্ছে...';

  @override
  String get passwordNewSubmit => 'জমা দিন';

  @override
  String get passwordCompleteTitle => 'পাসওয়ার্ড রিসেট সম্পন্ন হয়েছে';

  @override
  String get passwordCompleteBody =>
      'আপনার পাসওয়ার্ড রিসেট করা হয়েছে। চালিয়ে যেতে আপনার নতুন পাসওয়ার্ড দিয়ে লগ ইন করুন।';

  @override
  String get termsTitle => 'সেবার শর্তাবলী';

  @override
  String get privacyTitle => 'গোপনীয়তা নীতি';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email-এর জন্য একটি নতুন পাসওয়ার্ড সেট করুন।';
  }

  @override
  String get selectComplete => 'সম্পন্ন';

  @override
  String get onboardingLanguageTitle => 'আপনার মাতৃভাষা কী?';

  @override
  String get onboardingReasonTitle => 'আপনি কেন একটি ভাষা শিখছেন?';

  @override
  String get onboardingReasonSubtitle =>
      'আমরা আপনার লক্ষ্য অনুযায়ী আপনার শেখা কাস্টমাইজ করব।';

  @override
  String get savingLabel => 'সংরক্ষণ করা হচ্ছে...';

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
