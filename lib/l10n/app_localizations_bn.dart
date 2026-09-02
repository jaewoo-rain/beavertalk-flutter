// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get loginRequired => 'আপনাকে সাইন ইন করতে হবে।';

  @override
  String get callWebNotSupported =>
      'ওয়েবে ভয়েস কল সমর্থিত নয়। অ্যাপ ব্যবহার করুন।';

  @override
  String get micPermissionRequiredForCall =>
      'মাইক্রোফোন অনুমতি প্রয়োজন। কল শুরু করতে মাইক্রোফোন অনুমতি দিন।';

  @override
  String get callErrorGeneric => 'কল চলাকালীন একটি সমস্যা হয়েছে।';

  @override
  String get callNetworkError => 'নেটওয়ার্ক ত্রুটি হয়েছে।';

  @override
  String get authInvalidCredentials => 'ইমেইল বা পাসওয়ার্ড সঠিক নয়।';

  @override
  String get authEmailAlreadyRegistered => 'এই ইমেইলটি ইতিমধ্যে নিবন্ধিত।';

  @override
  String get authConfirmEmailRequired =>
      'আপনার ইমেইলে পাঠানো যাচাইকরণ সম্পূর্ণ করুন।';

  @override
  String get authResetCodeSent => 'আপনার ইমেইলে যাচাইকরণ কোড পাঠানো হয়েছে।';

  @override
  String get authResetCodeInvalid => 'কোডটি সঠিক নয় বা মেয়াদ শেষ হয়ে গেছে।';

  @override
  String get authPasswordUpdated => 'পাসওয়ার্ড রিসেট করা হয়েছে।';

  @override
  String get authAppleTokenMissing => 'Apple সাইন-ইন টোকেন পাওয়া যায়নি।';

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
  String get quickStart => 'দ্রুত শুরু';

  @override
  String get presetMorning => 'সকালের রুটিন';

  @override
  String get presetMorningSub => 'কর্মদিবস 8:00';

  @override
  String get presetEvening => 'সন্ধ্যার সমাপ্তি';

  @override
  String get presetEveningSub => 'প্রতিদিন 21:00';

  @override
  String get presetCustom => 'নিজের মতো';

  @override
  String get presetCustomSub => 'যেভাবে চান';

  @override
  String alarmSummary(int count, int monthly) {
    return 'সপ্তাহে $count বার · মাসে $monthly কল';
  }

  @override
  String get alarmSummaryNone => 'অন্তত একটি দিন বেছে নিন';

  @override
  String get partnerInUse => 'ব্যবহৃত হচ্ছে';

  @override
  String get partnerOwned => 'আপনার আছে';

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
    return '$count নম্বর কল';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name এর কিছু কথা';
  }

  @override
  String characterNoteFooter(String name) {
    return 'কলের ঠিক পরে $name রেখে গেছে';
  }

  @override
  String newExpressionsCount(int count) {
    return 'নতুন অভিব্যক্তি $count';
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
  String get selectNativeLanguage => 'আপনার মাতৃভাষা নির্বাচন করুন';

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
  String get analyzingByWord => 'আপনার উচ্চারণ শব্দে শব্দে দেখা হচ্ছে';

  @override
  String get analyzingTakingLonger => 'এতে একটু বেশি সময় লাগছে';

  @override
  String get scanConnectionLost => 'সংযোগ বিচ্ছিন্ন';

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
  String pricePerMonth(String price) {
    return '$price / মাস';
  }

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
  String get loginFacebookSignInFailed => 'Facebook সাইন-ইন ব্যর্থ হয়েছে।';

  @override
  String get loginKakaoSignInFailed => 'Kakao সাইন-ইন ব্যর্থ হয়েছে।';

  @override
  String get loginContinueWithKakao => 'Kakao দিয়ে চালিয়ে যান';

  @override
  String get loginContinueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get loginContinueWithFacebook => 'Facebook দিয়ে চালিয়ে যান';

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
  String get thisMonthPayment => 'এই মাসের পেমেন্ট';

  @override
  String get filterAll => 'সব';

  @override
  String get filterSubscription => 'সাবস্ক্রিপশন';

  @override
  String get filterCharacter => 'চরিত্র';

  @override
  String get statusCompleted => 'সম্পন্ন';

  @override
  String get lastPayment => 'সর্বশেষ পেমেন্ট';

  @override
  String subscriptionSwitchNote(String date) {
    return 'আপনি $date পর্যন্ত Pro সুবিধা ব্যবহার করতে পারবেন, এরপর আপনার প্ল্যান স্বয়ংক্রিয়ভাবে ফ্রি-তে বদলে যাবে।';
  }

  @override
  String get freePlanCallLimit => 'দিনে ১টি কল · ৫ মিনিট সীমা';

  @override
  String get freePlanBasicCharacters => 'বেসিক চরিত্র অন্তর্ভুক্ত';

  @override
  String get availableForPurchase => 'কেনার জন্য উপলব্ধ';

  @override
  String get paymentsLoadError => 'পেমেন্ট ইতিহাস লোড করা যায়নি';

  @override
  String get noPayments => 'এখনও কোনো পেমেন্ট নেই';

  @override
  String get morePaymentsExist => 'পুরোনো পেমেন্ট এখনও দেখানো হয়নি';

  @override
  String get undatedPayments => 'তারিখহীন';

  @override
  String get paymentLabelFallback => 'পেমেন্ট';

  @override
  String learningPassed(int passed, int total) {
    return '$total টির মধ্যে $passed টি বাক্য উত্তীর্ণ';
  }

  @override
  String get hardestSound => 'আজকের সবচেয়ে কঠিন ধ্বনি';

  @override
  String get soundAccuracy => 'ধ্বনি অনুযায়ী নির্ভুলতা';

  @override
  String phonemeAttempts(int count) {
    return 'ধ্বনিমূল প্রতি · $count বার চেষ্টা';
  }

  @override
  String get colSound => 'ধ্বনি';

  @override
  String get colAttempts => 'চেষ্টা';

  @override
  String get colCorrect => 'সঠিক';

  @override
  String get colAccuracy => 'নির্ভুল.';

  @override
  String get sentenceResults => 'বাক্য অনুযায়ী ফল';

  @override
  String viewAllSentences(int count) {
    return 'সব $count দেখুন';
  }

  @override
  String get colSentence => 'বাক্য';

  @override
  String get colPronunciation => 'উচ্চা.';

  @override
  String get colFluency => 'সাবলীল';

  @override
  String get colRhythm => 'ছন্দ';

  @override
  String recentSessions(int count) {
    return 'সর্বশেষ $count সেশন';
  }

  @override
  String trendAverage(int score) {
    return 'গড় $score';
  }

  @override
  String get today => 'আজ';

  @override
  String get colDate => 'তারিখ';

  @override
  String get colSentences => 'বাক্য';

  @override
  String get colScore => 'স্কোর';

  @override
  String get colChange => 'পরিবর্তন';

  @override
  String dateToday(String date) {
    return '$date (আজ)';
  }

  @override
  String get accentAnalysis => 'উচ্চারণভঙ্গি বিশ্লেষণ';

  @override
  String get overallLevel => 'সামগ্রিক স্তর';

  @override
  String get overallLevelSubtitle => 'শব্দভাণ্ডার · ব্যাকরণ · প্রকাশভঙ্গি';

  @override
  String get pronunciationAnalysis => 'উচ্চারণ বিশ্লেষণ';

  @override
  String get recentSessionsAverage => 'সাম্প্রতিক ১০ সেশনের গড়';

  @override
  String levelStage(int stage) {
    return 'স্তর $stage';
  }

  @override
  String topPercent(int percent) {
    return 'শীর্ষ $percent%';
  }

  @override
  String get allLearnersBasis => 'সব শিক্ষার্থীর মধ্যে';

  @override
  String aheadOfLearners(int percent) {
    return 'আপনি $percent% শিক্ষার্থীর চেয়ে এগিয়ে';
  }

  @override
  String get retakeLevelTest => 'স্তর পরীক্ষা আবার দিন';

  @override
  String get practicePronunciation => 'উচ্চারণ অনুশীলন করুন';

  @override
  String get priceChangedTitle => 'দাম বদলে গেছে';

  @override
  String priceChangedBody(String price) {
    return 'এই আইটেমের দাম এখন $price। চালিয়ে যেতে চান?';
  }

  @override
  String get billingGroupPlanPurchases => 'প্ল্যান ও কেনাকাটা';

  @override
  String get billingGroupInTheStore => 'স্টোরে';

  @override
  String get billingChangePlan => 'প্ল্যান পরিবর্তন';

  @override
  String get billingCompareAllPlans => 'সব প্ল্যান তুলনা করুন';

  @override
  String get billingBuyACharacter => 'ক্যারেক্টার কিনুন';

  @override
  String get billingRestorePurchases => 'কেনাকাটা পুনরুদ্ধার';

  @override
  String get billingPaymentHistory => 'পেমেন্ট ইতিহাস';

  @override
  String get billingManageInTheStore => 'স্টোরে ম্যানেজ করুন';

  @override
  String get billingRefundHelp => 'রিফান্ড সহায়তা';

  @override
  String get billingCancelSubscription => 'সাবস্ক্রিপশন বাতিল';

  @override
  String get billingResubscribe => 'আবার সাবস্ক্রাইব করুন';

  @override
  String get badgeCurrent => 'বর্তমান';

  @override
  String get badgeTrial => 'ট্রায়াল';

  @override
  String get badgeRenewing => 'নবায়ন হচ্ছে';

  @override
  String get badgePastDue => 'পেমেন্ট বাকি';

  @override
  String get badgePaused => 'বিরতিতে';

  @override
  String get badgeCanceling => 'বাতিল হচ্ছে';

  @override
  String get subscriptionTitle => 'সাবস্ক্রিপশন';

  @override
  String get plansTitle => 'প্ল্যান';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max ট্রায়াল';

  @override
  String get freePlanPriceLine => '\$0.00 — দিনে একটি কল';

  @override
  String pricePerMonthLine(String amount) {
    return 'প্রতি মাসে $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date পর্যন্ত ফ্রি';
  }

  @override
  String get todaysCalls => 'আজকের কল';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limitটির মধ্যে $usedটি ব্যবহৃত';
  }

  @override
  String get firstPaymentLabel => 'প্রথম পেমেন্ট';

  @override
  String get nextPaymentLabel => 'পরবর্তী পেমেন্ট';

  @override
  String get retryingUntilLabel => 'পুনঃচেষ্টা চলবে';

  @override
  String get pausedSinceLabel => 'বিরতি শুরু';

  @override
  String planEndsLabel(String plan) {
    return '$plan শেষ হবে';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pro দিয়ে সীমাহীন হোন';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'সীমাহীন কল · প্রতিটি ১৫ মিনিট · প্রতি মাসে $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max দিয়ে ভিডিও চালু করুন';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'মুখোমুখি কল · প্রতি মাসে $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'বার্ষিক প্ল্যানে যান';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return 'বছরে $yearly · প্রতি মাসে $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'পেমেন্ট নেওয়া যায়নি';

  @override
  String get bannerPaymentFailedSub => 'Pro রাখতে স্টোরে পেমেন্ট আপডেট করুন';

  @override
  String get bannerPausedTitle => 'আপনার প্ল্যান বিরতিতে আছে';

  @override
  String get bannerPausedSub => 'পেমেন্ট সম্পন্ন হয়নি';

  @override
  String get noteRestoreHint =>
      'অন্য ডিভাইসে সাবস্ক্রাইব করা আছে? পুনরুদ্ধার করলে এই ডিভাইসে ফিরে আসবে।';

  @override
  String get noteStoreHandled =>
      'পেমেন্ট পদ্ধতি, প্ল্যান পরিবর্তন ও বাতিল — সবই স্টোর পরিচালনা করে।';

  @override
  String get noteFairUse =>
      'সীমাহীন ব্যবহার আমাদের ন্যায্য ব্যবহার নীতির অধীন।';

  @override
  String noteTrialEnds(String date) {
    return 'আপনার ট্রায়াল $date শেষ হবে। তার আগে স্টোরে বাতিল করলে কোনো চার্জ হবে না।';
  }

  @override
  String get noteGrace =>
      'গ্রেস পিরিয়ড চলাকালে সুবিধা চালু থাকে। অ্যাপে বাতিল কখনো আটকানো হয় না।';

  @override
  String get noteHold =>
      'পেমেন্ট সম্পন্ন না হওয়া পর্যন্ত Pro বিরতিতে থাকবে। আপনার ক্যারেক্টার ও অগ্রগতি নিরাপদ।';

  @override
  String noteEnding(String date) {
    return 'আপনার প্ল্যান শেষ হতে চলেছে। $date পর্যন্ত সুবিধা চলবে, তারপর Free-তে চলে যাবেন। যেকোনো সময় আবার সাবস্ক্রাইব করা যায়।';
  }

  @override
  String get trialExpiredTitle => 'আপনার Max ট্রায়াল শেষ হয়েছে';

  @override
  String get trialExpiredSub => 'আপনি এখন Free-তে আছেন';

  @override
  String get seePlans => 'প্ল্যান দেখুন';

  @override
  String get currentPlanTitle => 'বর্তমান প্ল্যান';

  @override
  String get badgeRecommended => 'প্রস্তাবিত';

  @override
  String get perMonthUnit => 'প্রতি মাসে';

  @override
  String get planTaglinePro => 'সীমাহীন কল। প্রতিটি ১৫ মিনিট।';

  @override
  String get planTaglineMax => 'এখন তাদের দেখতে পাবেন।';

  @override
  String get planTaglineFree => 'দিনে একটি কল। একদম ফ্রি।';

  @override
  String get bulletProCalls => 'যত খুশি ভয়েস কল';

  @override
  String get bulletProLength => 'প্রতি কলে ১৫ মিনিট';

  @override
  String get bulletProScoring => 'অক্ষর ধরে ধরে উচ্চারণের স্কোর';

  @override
  String get bulletProCorrections => 'আপনার মাতৃভাষা অনুযায়ী সংশোধন';

  @override
  String get bulletProBeaverCalls => 'Beaver আগে আপনাকে কল করবে';

  @override
  String get bulletMaxVideo => 'মুখোমুখি ভিডিও কল';

  @override
  String get bulletMaxEverything => 'Pro-এর সবকিছু';

  @override
  String get bulletMaxCharacters => 'সব ক্যারেক্টার, সীমাহীন';

  @override
  String get bulletMaxStudyBook => 'আপনার স্তর অনুযায়ী স্টাডি বুক';

  @override
  String get bulletMaxWeeklyReport =>
      'উচ্চারণের পরিবর্তন নিয়ে সাপ্তাহিক রিপোর্ট';

  @override
  String get bulletFreeCall => 'দিনে একটি ৫ মিনিটের ভয়েস কল';

  @override
  String get bulletFreeCheck => 'দিনে একটি উচ্চারণ পরীক্ষা';

  @override
  String get bulletFreeAccent => 'সীমাহীন অ্যাকসেন্ট চেক';

  @override
  String get bulletFreeCharacter => 'শুরুতে একটি ক্যারেক্টার';

  @override
  String get ctaGoUnlimited => 'সীমাহীন হোন';

  @override
  String get ctaTurnOnVideo => 'ভিডিও চালু করুন';

  @override
  String get noteCallLength => 'প্রতিটি কল ১৫ মিনিটের।';

  @override
  String get paywallProTitle1 => 'আপনার কোরিয়ান বন্ধু';

  @override
  String get paywallProTitle2 => 'রাত ৩টায়ও জেগে থাকে';

  @override
  String get paywallProSub => 'সীমাহীন কল। প্রতিটি ১৫ মিনিট। সারা বছর।';

  @override
  String get paywallLimitHeadline => 'Pro সীমা তুলে দেয়।';

  @override
  String get limitBannerCallTitle => 'আজকের কল শেষ';

  @override
  String get limitBannerCallSub => 'Free-তে দিনে একটি কল';

  @override
  String get limitBannerCheckTitle => 'আজকের পরীক্ষা শেষ';

  @override
  String get limitBannerCheckSub => 'Free-তে দিনে একটি পরীক্ষা';

  @override
  String get bulletProCharactersForever => 'কেনা ক্যারেক্টার চিরকাল আপনারই';

  @override
  String get paywallMaxTitle => 'এখন তাদের দেখতে পাবেন।';

  @override
  String get paywallMaxSub =>
      'ভিডিও কল, সব ক্যারেক্টার, আর আপনার স্তরের জন্য তৈরি স্টাডি বুক।';

  @override
  String get planMonthly => 'মাসিক';

  @override
  String get planAnnual => 'বার্ষিক';

  @override
  String proMonthlyPriceLine(String price) {
    return 'প্রতি মাসে $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · প্রতি মাসে $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'প্রতি মাসে $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'বছরে $yearly · প্রতি মাসে $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'প্রতি মাসে $price · স্টোরে যেকোনো সময় বাতিল';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'প্রতি মাসে $price · স্টোরে যেকোনো সময় বাতিল';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '৭ দিন ফ্রি, এরপর প্রতি মাসে $price · স্টোরে যেকোনো সময় বাতিল';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'বাতিল না করা পর্যন্ত স্বয়ংক্রিয়ভাবে নবায়ন হয়।';

  @override
  String get footerTerms => 'শর্তাবলী';

  @override
  String get footerPrivacy => 'গোপনীয়তা';

  @override
  String get noteMaxCharacters =>
      'Max-এ আনলক হওয়া ক্যারেক্টার সাবস্ক্রিপশন চালু থাকা পর্যন্ত ব্যবহারযোগ্য। কেনা ক্যারেক্টার আপনারই থাকবে।';

  @override
  String get processingTitle => 'আপনার কেনাকাটা নিশ্চিত হচ্ছে';

  @override
  String get processingSub => 'সাধারণত কয়েক সেকেন্ড লাগে।';

  @override
  String get successProTitle => 'আপনি এখন Pro-তে।';

  @override
  String get successProSub => 'সীমাহীন কল, এখন থেকেই শুরু।';

  @override
  String get successProBenefit1 => 'যত খুশি কল করুন — প্রতি কলে ১৫ মিনিট';

  @override
  String get successProBenefit2 => 'সীমাহীন উচ্চারণ পরীক্ষা';

  @override
  String get successProBenefit3 => 'সব ক্যারেক্টার, সঙ্গে এককালীন কেনাকাটা';

  @override
  String get successMaxTitle => 'এখন তাদের দেখতে পাচ্ছেন।';

  @override
  String get successMaxSub =>
      'ভিডিও কল চালু হয়েছে। যেকোনো কলে ভিডিও বোতামে চাপ দিন।';

  @override
  String get successMaxBenefit1 => 'মুখোমুখি ভিডিও কল';

  @override
  String get successMaxBenefit2 =>
      'সব ক্যারেক্টার, সীমাহীন — নতুনগুলো সবার আগে';

  @override
  String get successMaxBenefit3 => 'আপনার স্তর অনুযায়ী স্টাডি বুক';

  @override
  String get ctaStartACall => 'কল শুরু করুন';

  @override
  String get ctaStartAVideoCall => 'ভিডিও কল শুরু করুন';

  @override
  String get ctaSeeYourSubscription => 'আপনার সাবস্ক্রিপশন দেখুন';

  @override
  String successProCaption(String price) {
    return 'বাতিল না করা পর্যন্ত প্রতি মাসে $price চার্জ হবে। স্টোরে যেকোনো সময় ম্যানেজ বা বাতিল করুন।';
  }

  @override
  String successMaxCaption(String price) {
    return 'বাতিল না করা পর্যন্ত প্রতি মাসে $price চার্জ হবে। স্টোরে যেকোনো সময় ম্যানেজ বা বাতিল করুন।';
  }

  @override
  String get plansErrorTitle => 'প্ল্যান লোড করা যায়নি';

  @override
  String get plansErrorSub => 'স্টোর থেকে সাড়া মেলেনি।';

  @override
  String get ctaTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get plansErrorCaption => 'কোনো চার্জ হয়নি।';

  @override
  String get changePlanTitle => 'প্ল্যান পরিবর্তন';

  @override
  String get moveToMaxTitle => 'Max-এ যান';

  @override
  String maxPriceShort(String price) {
    return '$price / মাস';
  }

  @override
  String get moveToMaxCardSub =>
      'মুখোমুখি ভিডিও কল · সব ক্যারেক্টার · আপনার জন্য তৈরি স্টাডি বুক';

  @override
  String get whatHappensNow => 'এখন যা হবে';

  @override
  String get maxStartsLabel => 'Max শুরু';

  @override
  String get immediately => 'এখনই';

  @override
  String get unusedProTime => 'Pro-এর অব্যবহৃত সময়';

  @override
  String get creditedTowardMax => 'Max-এ সমন্বয় হবে';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max-এ যান';

  @override
  String get upgradeCaption =>
      'নতুন প্ল্যান সঙ্গে সঙ্গে শুরু হবে। Pro-এর অব্যবহৃত সময় সমন্বয় হয়, দুবার চার্জ হয় না।';

  @override
  String get moveToProTitle => 'Pro-তে যান';

  @override
  String get moveToProSub =>
      'আজ কিছুই বদলাবে না। যে মাসের টাকা দিয়েছেন, Max সেই মাসের শেষ পর্যন্ত চলবে।';

  @override
  String get maxRunsUntil => 'Max চলবে';

  @override
  String get proStarts => 'Pro শুরু';

  @override
  String get whatYouKeep => 'যা থাকবে';

  @override
  String get keepBenefitCalls => 'সীমাহীন ভয়েস কল, প্রতিটি ১৫ মিনিট';

  @override
  String get keepBenefitCharacters => 'কেনা ক্যারেক্টার চিরকাল আপনারই';

  @override
  String downgradeWarning(String date) {
    return '$date থেকে ভিডিও কল ও শুধু-Max ক্যারেক্টার বন্ধ হবে।';
  }

  @override
  String get ctaSwitchToPro => 'Pro-তে যান';

  @override
  String get ctaKeepMax => 'Max রাখুন';

  @override
  String get winbackSkip => 'এড়িয়ে যান';

  @override
  String get winbackTitle => 'আপনার Pro প্ল্যান শেষ হয়েছে';

  @override
  String get winbackSub => 'আপনি এখন Free-তে — দিনে একটি কল।';

  @override
  String get winbackQuestion => 'কেন ছেড়ে গেলেন, জানাবেন কি?';

  @override
  String get winbackReasonExpensive => 'খরচ বেশি';

  @override
  String get winbackReasonUnused => 'যথেষ্ট ব্যবহার করিনি';

  @override
  String get winbackReasonMissing => 'দরকারি একটি ফিচার নেই';

  @override
  String get winbackReasonOtherApp => 'অন্য একটি অ্যাপ পেয়েছি';

  @override
  String get winbackReasonElse => 'অন্য কিছু';

  @override
  String get ctaSend => 'পাঠান';

  @override
  String get ctaNotNow => 'এখন নয়';

  @override
  String get winbackCaption =>
      'এতে প্ল্যান ফিরে আসবে না। স্টোরে আবার সাবস্ক্রাইব করুন।';

  @override
  String get ctaContinue => 'এগিয়ে যান';

  @override
  String get ctaClose => 'বন্ধ করুন';

  @override
  String get ovRestoreSuccessTitle => 'Pro ফিরে এসেছে';

  @override
  String get ovRestoreSuccessBody =>
      'আপনার সাবস্ক্রিপশন খুঁজে পেয়ে এই ডিভাইসে আবার চালু করেছি।';

  @override
  String get ovRestoreEmptyTitle => 'পুনরুদ্ধারের কিছু নেই';

  @override
  String get ovRestoreEmptyBody =>
      'এই স্টোর অ্যাকাউন্টে কোনো সক্রিয় সাবস্ক্রিপশন যুক্ত নেই।';

  @override
  String get ovRestoreOtherTitle => 'এই প্ল্যানটি অন্য অ্যাকাউন্টের';

  @override
  String get ovRestoreOtherBody =>
      'এই সাবস্ক্রিপশন অন্য একটি BeaverTalk অ্যাকাউন্টে ইতিমধ্যে সক্রিয়।';

  @override
  String get ctaSignInThatAccount => 'সেই অ্যাকাউন্টে সাইন ইন করুন';

  @override
  String get ctaGetHelp => 'সহায়তা নিন';

  @override
  String get ovCharacterOfferTitle => 'Pro-এর জন্য প্রস্তুত নন?';

  @override
  String get ovCharacterOfferBody =>
      'একটি ক্যারেক্টার বেছে নিন, চিরকালের জন্য। এককালীন কেনা — সাবস্ক্রিপশন নেই, নবায়ন নেই।';

  @override
  String get rowOneCharacter => 'একটি ক্যারেক্টার';

  @override
  String rowFromPrice(String price) {
    return '$price থেকে';
  }

  @override
  String get rowYoursForever => 'চিরকাল আপনার';

  @override
  String get rowNoRenewal => 'নবায়ন নেই';

  @override
  String get rowWorksOnFree => 'Free-তেও চলে';

  @override
  String get rowYes => 'হ্যাঁ';

  @override
  String get ctaSeeCharacters => 'ক্যারেক্টার দেখুন';

  @override
  String get ovNotEligibleTitle => 'বাতিলের কিছু নেই';

  @override
  String get ovNotEligibleBody =>
      'আপনি Free-তে আছেন। এই অ্যাকাউন্টে কোনো সক্রিয় সাবস্ক্রিপশন নেই।';

  @override
  String get ovCancelDownsellTitle => 'যাওয়ার আগে';

  @override
  String get ovCancelDownsellBody =>
      'বাতিল হয় স্টোরে। জেনে রাখার মতো দুটি বিষয়।';

  @override
  String get rowPayYearlyInstead => 'বরং বছরে একবার দিন';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'প্রতি মাসে $price';
  }

  @override
  String get rowCharactersYouBought => 'কেনা ক্যারেক্টার';

  @override
  String get rowProRunsUntil => 'Pro চলবে';

  @override
  String get ctaSwitchToYearly => 'বার্ষিকে যান';

  @override
  String get ctaContinueToStore => 'স্টোরে এগিয়ে যান';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'বছরে দিন, $saved বাঁচান';
  }

  @override
  String get ovAnnualSwitchBody =>
      'আপনি দুই মাস ধরে Pro-তে আছেন। বার্ষিক প্ল্যানে খরচ কম পড়ে।';

  @override
  String get rowYouSave => 'আপনার সাশ্রয়';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'বার্ষিক';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'মাসিক, এক বছরে';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'মাসিকে যান';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'আপনার বার্ষিক প্ল্যান $date পর্যন্ত চলবে। পরদিন থেকে মাসিক বিলিং শুরু হবে।';
  }

  @override
  String get rowMonthlyBillingStarts => 'মাসিক বিলিং শুরু';

  @override
  String get rowMonthlyLabel => 'মাসিক';

  @override
  String get rowYearlyWorkedOut => 'বার্ষিক হিসাবে দাঁড়ায়';

  @override
  String get ctaSwitchToMonthly => 'মাসিকে যান';

  @override
  String get ovRefundHelpTitle => 'রিফান্ড স্টোর পরিচালনা করে';

  @override
  String get ovRefundHelpBody =>
      'আমরা নিজেরা রিফান্ড দিতে পারি না। প্রতিটি অনুরোধ স্টোর পর্যালোচনা করে।';

  @override
  String get ctaGoToStore => 'স্টোরে যান';

  @override
  String get ovTrialEndingTitle => 'আপনার ট্রায়াল আগামীকাল শেষ';

  @override
  String get ovTrialEndingBody =>
      'বাতিল না করলে Max চলতেই থাকবে। যা হবে তা এখানে।';

  @override
  String get rowTrialEnds => 'ট্রায়াল শেষ';

  @override
  String get rowFirstCharge => 'প্রথম চার্জ';

  @override
  String get rowThenMonthly => 'তারপর মাসিক';

  @override
  String get ctaCancelInStore => 'স্টোরে বাতিল করুন';

  @override
  String get ovTrialStartTitle => '৭ দিন Max, ফ্রি';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date পর্যন্ত ফ্রি। তারপর প্রতি মাসে $price, স্টোরে বাতিল না করলে।';
  }

  @override
  String get ctaStart7Days => '৭ দিন ফ্রি শুরু করুন';

  @override
  String get ovOtoTitle => 'শুরুর আগে আর একটি কথা';

  @override
  String get ovOtoBody =>
      'দারুণ সিদ্ধান্ত — সীমাহীন কল এখনই চালু। বছরে দিলে একই Pro-তে খরচ কম।';

  @override
  String get ovFailedDeclinedTitle => 'আপনার কার্ড প্রত্যাখ্যাত হয়েছে';

  @override
  String get ovFailedDeclinedBody =>
      'স্টোর পেমেন্ট নিতে পারেনি। কোনো চার্জ হয়নি।';

  @override
  String get ctaUpdatePaymentMethod => 'পেমেন্ট পদ্ধতি আপডেট করুন';

  @override
  String get ovFailedCanceledTitle => 'পেমেন্ট বাতিল হয়েছে';

  @override
  String get ovFailedCanceledBody =>
      'আপনি এখনো Free-তে আছেন। কোনো চার্জ হয়নি।';

  @override
  String get ovFailedStoreTitle => 'কিছু একটা সমস্যা হয়েছে';

  @override
  String get ovFailedStoreBody => 'স্টোরে পৌঁছানো যায়নি। কোনো চার্জ হয়নি।';

  @override
  String get ovAlreadyTitle => 'আপনি ইতিমধ্যে Pro-তে আছেন';

  @override
  String get ovAlreadyBody =>
      'এই স্টোর অ্যাকাউন্টে একটি সক্রিয় প্ল্যান আছে। কেনার কিছু নেই।';

  @override
  String get ctaSeeMySubscription => 'আমার সাবস্ক্রিপশন দেখুন';

  @override
  String get subCancelTitle => 'সাবস্ক্রিপশন বাতিল';

  @override
  String subCancelBody(String date) {
    return 'Pro $date পর্যন্ত চলবে। তারপর Free-তে চলে যাবেন।';
  }

  @override
  String get subWhatYouLose => 'যা হারাবেন';

  @override
  String get benefitCalls15 => 'সীমাহীন কল, প্রতিটি ১৫ মিনিট';

  @override
  String get benefitScoring => 'অক্ষর ধরে ধরে উচ্চারণের স্কোর';

  @override
  String get benefitEveryCharacter => 'সব ক্যারেক্টার, সীমাহীন';

  @override
  String get ctaKeepPro => 'Pro রাখুন';

  @override
  String get subPaymentTitle => 'পেমেন্ট আপডেট করুন';

  @override
  String get subPaymentBody =>
      'পেমেন্ট নেওয়া যায়নি। গ্রেস পিরিয়ডে Pro চালু থাকবে।';

  @override
  String get subHowToFix => 'কীভাবে ঠিক করবেন';

  @override
  String get fixStep1 => 'স্টোর খুলে পেমেন্ট পদ্ধতি আপডেট করুন';

  @override
  String get fixStep2 => 'ফিরে আসুন — প্ল্যান নিজে থেকেই চালু হবে';

  @override
  String get fixStep3 => 'কিছুই দুবার চার্জ হয় না';

  @override
  String get subResubTitle => 'আবার সাবস্ক্রাইব করুন';

  @override
  String subResubBody(String date) {
    return 'Pro $date শেষ হবে। অটো-নবায়ন আবার চালু করলে কিছুই বদলাবে না।';
  }

  @override
  String get subWhatYouKeep => 'যা থাকবে';

  @override
  String get ctaTurnItBackOn => 'আবার চালু করুন';

  @override
  String get flTodayTitle => 'এটাই ছিল আজকের কল';

  @override
  String get flTodayBody => 'যেখানে থেমেছিলেন, সেখান থেকে — এখনই।';

  @override
  String get flCheckTitle => 'এটাই ছিল আজকের পরীক্ষা';

  @override
  String get flCheckBody => 'Free-তে দিনে একটি পরীক্ষা। Pro-তে সীমাহীন।';

  @override
  String get flBenefitCalls => 'Pro-তে সীমাহীন কল · প্রতিটি ১৫ মিনিট';

  @override
  String get flBenefitChecks => 'Pro-তে সীমাহীন উচ্চারণ পরীক্ষা';

  @override
  String flCaption(String price) {
    return 'প্রতি মাসে $price · যেকোনো সময় বাতিল';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit-এর মধ্যে $used ব্যবহৃত';
  }

  @override
  String get ctaMaybeTomorrow => 'কাল দেখা যাবে';

  @override
  String get accountSection => 'অ্যাকাউন্ট';

  @override
  String get nicknameLabel => 'ডাকনাম';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'লগইন পদ্ধতি';

  @override
  String get joinedLabel => 'যোগদানের তারিখ';

  @override
  String get editNicknameTitle => 'ডাকনাম সম্পাদনা';

  @override
  String get nicknameRule => '২–১২ অক্ষর। শুধুই ইংরেজি অক্ষর ও সংখ্যা।';

  @override
  String get ctaSave => 'সংরক্ষণ';

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
  String get paywallLeaveTitle => 'এখন চলে গেলে সাবস্ক্রিপশন হবে না';

  @override
  String get paywallLeaveBody =>
      'পেমেন্টের পরপরই আপনার সুবিধা খুলে যায়। আমার পেজ থেকে যেকোনো সময় ফিরে আসতে পারেন।';

  @override
  String get ctaKeepLooking => 'দেখতে থাকুন';

  @override
  String get ctaLeaveAnyway => 'তবুও চলে যান';

  @override
  String get iapCharacterSuccessTitle => 'নতুন বন্ধু যোগ দিয়েছে!';

  @override
  String get iapCharacterSuccessBody =>
      'এই চরিত্র চিরদিনের জন্য আপনার — প্ল্যান বদলালেও থাকে, আর কেনাকাটা পুনরুদ্ধার দিয়ে যেকোনো ডিভাইসে ফিরে পাবেন।';

  @override
  String get iapCharacterFailedBody =>
      'কেনা সম্পন্ন হয়নি। কোনো টাকা কাটা হয়নি — আবার চেষ্টা করুন।';

  @override
  String get noAccentDataTitle => 'এখনও স্বরভঙ্গির তথ্য নেই';

  @override
  String get noAccentDataBody =>
      'কথা বলা চালিয়ে গেলে আপনার স্বরভঙ্গির বৈশিষ্ট্য জমতে থাকবে।';

  @override
  String get noLevelYetTitle => 'এখনও কোনো স্তর নেই';

  @override
  String get noLevelYetBody => 'প্রথম কল শেষ করলে আপনার স্তর পাবেন।';

  @override
  String get noPronunciationDataTitle => 'এখনও উচ্চারণের রেকর্ড নেই';

  @override
  String get noPronunciationDataBody =>
      'কলে বলা বাক্য থেকে আমরা উচ্চারণ বিশ্লেষণ করি।';

  @override
  String get noCharacterNote => 'এখনও কিছু বলা হয়নি';

  @override
  String get noPhonemesYet => 'বিশ্লেষণের জন্য এখনও কোনো ধ্বনি নেই';

  @override
  String get noSentencesYet => 'বিশ্লেষণের জন্য এখনও কোনো বাক্য নেই';

  @override
  String get takeLevelTest => 'স্তর পরীক্ষা দিন';

  @override
  String get reviewToSeeScore => 'পুনরালোচনা করলে উচ্চারণের স্কোর দেখা যাবে';

  @override
  String get playAgain => 'আবার খেলুন';

  @override
  String get difficultySlow => 'ধীরে';

  @override
  String get difficultyNormal => 'স্বাভাবিক';

  @override
  String get difficultyFast => 'দ্রুত';

  @override
  String get difficultyLabel => 'কঠিনতা';

  @override
  String get connected => 'সংযুক্ত';

  @override
  String get unlockedWithMax => 'Max দিয়ে ব্যবহারযোগ্য';

  @override
  String get callModeSheetTitle => 'আপনি কীভাবে কথা বলতে চান?';

  @override
  String get callModeSheetSubtitle => 'এই কলে সঙ্গে সঙ্গে প্রযোজ্য';

  @override
  String get callModeFreeTalk => 'মুক্ত আলাপ';

  @override
  String get callModeFreeTalkDesc => 'সংশোধন ছাড়াই কথা বলুন';

  @override
  String get callModeStudy => 'অনুশীলন';

  @override
  String get callModeStudyDesc => 'একবারে একটি অভিব্যক্তি শিখুন';

  @override
  String get callModeChange => 'মোড বদলান';

  @override
  String get callModeKeep => 'এখন নয়';

  @override
  String get callExitTitle => 'কল শেষ করবেন?';

  @override
  String get callExitSubtitle => 'এখন শেষ করলেও একটি কল গণনা হবে';

  @override
  String get callExitKeep => 'কথা চালিয়ে যান';

  @override
  String get callExitConfirm => 'কল শেষ করুন';

  @override
  String get callMicMute => 'মিউট';

  @override
  String get callMicUnmute => 'আনমিউট';

  @override
  String get callPushToTalk => 'বলতে চেপে ধরুন';

  @override
  String get callFreeEndedTitle => 'আপনার ফ্রি কল শেষ হয়েছে';

  @override
  String get callFreeEndedCta => 'সাবস্ক্রাইব করে কথা চালিয়ে যান';

  @override
  String get callKeepGoingTitle => 'চালিয়ে যাবেন?';

  @override
  String get callKeepGoingSubtitle =>
      'কল ৫ মিনিট করে চলতে থাকে। প্রতিবার আমরা আবার জিজ্ঞাসা করব।';

  @override
  String get articulationSelectedWord => 'নির্বাচিত শব্দ';

  @override
  String get articulationYouSaid => 'আপনার উচ্চারণ';

  @override
  String get articulationTargetSound => 'লক্ষ্য';

  @override
  String get reportEntry => 'রিপোর্ট করুন';

  @override
  String get reportTitle => 'রিপোর্ট';

  @override
  String get reportPrompt => 'কী সমস্যা হয়েছিল?';

  @override
  String get reportGuide =>
      'AI চরিত্রের কোন কথা আপনাকে অস্বস্তিতে ফেলেছে তা জানান। আমরা প্রতিটি রিপোর্ট পর্যালোচনা করি।';

  @override
  String get reportReasonSexual => 'যৌন বিষয়বস্তু';

  @override
  String get reportReasonHate => 'ঘৃণা বা বৈষম্য';

  @override
  String get reportReasonViolence => 'সহিংস বা হুমকিমূলক বিষয়বস্তু';

  @override
  String get reportReasonSelfHarm => 'আত্মক্ষতিতে উৎসাহ দেয়';

  @override
  String get reportReasonMisinfo => 'ভুল তথ্য';

  @override
  String get reportReasonOther => 'অন্য কিছু';

  @override
  String get reportDetailHint => 'কী ঘটেছে লিখুন (ঐচ্ছিক)';

  @override
  String get reportSubmit => 'রিপোর্ট পাঠান';

  @override
  String get reportDoneTitle => 'আপনার রিপোর্ট পেয়েছি';

  @override
  String get reportDoneBody =>
      'আমরা এটি পর্যালোচনা করে প্রয়োজনীয় ব্যবস্থা নেব। BeaverTalk নিরাপদ রাখতে সাহায্য করার জন্য ধন্যবাদ।';

  @override
  String get reportFailed => 'রিপোর্ট পাঠানো যায়নি। আবার চেষ্টা করুন।';

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
