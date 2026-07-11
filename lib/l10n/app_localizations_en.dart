// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Call ended $duration';
  }

  @override
  String get callRatingPrompt => 'How was your call?';

  @override
  String get ratingBad => 'Not great';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get ratingGood => 'Good';

  @override
  String get goHome => 'Home';

  @override
  String get viewAnalysis => 'View Analysis';

  @override
  String get loadingShort => 'Loading…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Failed to submit rating: $message';
  }

  @override
  String get callInfoNotFound => 'Call info not found, skipping analysis.';

  @override
  String get tabRecords => 'Records';

  @override
  String get tabArchive => 'Archive';

  @override
  String get callHistory => 'Call History';

  @override
  String get conversationRecord => 'Conversation record';

  @override
  String get noCallRecords => 'No call records yet';

  @override
  String get noCallRecordsBody =>
      'Once you finish your first call with AI,\nyour records will appear here.';

  @override
  String get startCall => 'Start a Call';

  @override
  String get recordsLoadError => 'Couldn\'t load records';

  @override
  String get tryAgainLater => 'Please try again later.';

  @override
  String get retry => 'Retry';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds sec';
  }

  @override
  String get scheduleManagement => 'Schedule';

  @override
  String get alarms => 'Alarms';

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get alarmsLoadError => 'Couldn\'t load alarms';

  @override
  String get charactersLoadError => 'Couldn\'t load characters';

  @override
  String get noCharacters => 'No characters available';

  @override
  String get close => 'Close';

  @override
  String get repeat => 'Repeat';

  @override
  String get callPartner => 'Character';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'Save';

  @override
  String get conversation => 'Conversation';

  @override
  String get review => 'Review';

  @override
  String get pronunciationChallenge => 'Pronunciation Challenge';

  @override
  String get newExpressions => 'New Expressions';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get noNewExpressions => 'No new expressions from this conversation.';

  @override
  String get practice => 'Practice';

  @override
  String recentScore(int score) {
    return 'Recent score $score%';
  }

  @override
  String get analysisLoadError => 'Couldn\'t load the analysis result.';

  @override
  String get standardAudioNotReady =>
      'Standard pronunciation audio isn\'t ready yet.';

  @override
  String get standardAudioPlayError =>
      'Couldn\'t play the standard pronunciation audio.';

  @override
  String get selectACountry => 'Select a country';

  @override
  String get selectYourLanguage => 'Select your language';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get selectTime => 'Select time';

  @override
  String get getStarted => 'Get Started';

  @override
  String get permissionTitle => 'Allow permissions\nfor a smooth experience';

  @override
  String get permissionSubtitle =>
      'Required permissions are essential to use the service.';

  @override
  String get permissionMicTitle => 'Microphone (required)';

  @override
  String get permissionMicDesc => 'Needed to talk with the AI in English.';

  @override
  String get permissionNotifTitle => 'Notifications (optional)';

  @override
  String get permissionNotifDesc =>
      'We\'ll send learning reminders and call schedules.';

  @override
  String get micPermissionNeededTitle => 'Microphone access needed';

  @override
  String get micPermissionNeededBody =>
      'To talk with the AI, you need to allow microphone access. Please enable it in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get connectionFailedTitle => 'Connection failed';

  @override
  String get connectionFailedBody =>
      'Check your network connection\nand try again.';

  @override
  String get checkout => 'Checkout';

  @override
  String get pay => 'Pay';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get payMethodCard => 'Credit / Debit Card';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Annoying Beaver Avatar';

  @override
  String get productTrait => 'Premium character · Yours forever';

  @override
  String get amountItemPrice => 'Item price';

  @override
  String get amountDiscount => 'Discount';

  @override
  String get amountTotal => 'Total';

  @override
  String get paymentCompleteTitle => 'Payment complete';

  @override
  String get paymentCompleteBody =>
      'The avatar has been added to your collection.';

  @override
  String get viewCollection => 'View Collection';

  @override
  String get receiptItem => 'Item';

  @override
  String get receiptAmount => 'Amount';

  @override
  String get receiptMethod => 'Payment method';

  @override
  String get receiptDate => 'Date';

  @override
  String get paymentFailedTitle => 'Payment failed';

  @override
  String get paymentFailedBody =>
      'Your payment couldn\'t be processed.\nPlease try again.';

  @override
  String get freeCallEndingTitle => 'Your free call is ending';

  @override
  String get freeCallEndingBody => 'Subscribe to talk with Beaver for longer.';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get endCall => 'End Call';

  @override
  String get callEnded => 'The call has ended.';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connectingHint => 'This usually takes less than 5 seconds';

  @override
  String get callConnectFailed => 'Couldn\'t connect the call.';

  @override
  String get saveSentenceFailed => 'Couldn\'t save the sentence.';

  @override
  String get recordStartFailed => 'Couldn\'t start recording.';

  @override
  String get recordTooShort =>
      'That recording was too short. Please try again.';

  @override
  String get gradingFailed => 'Scoring failed. Please try again.';

  @override
  String get listenStandard => 'Listen to standard pronunciation';

  @override
  String get saveSentence => 'Save sentence';

  @override
  String get unsaveSentence => 'Remove saved sentence';

  @override
  String get scoringPronunciation => 'Scoring your pronunciation…';

  @override
  String get noRecordingToPlay => 'No recording to play.';

  @override
  String get myRecordingPlayError => 'Couldn\'t play your recording.';

  @override
  String get next => 'Next';

  @override
  String get endLearning => 'End Session';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navCall => 'Call';

  @override
  String get navStats => 'Stats';

  @override
  String get myPage => 'My Page';

  @override
  String get languageSaveFailed => 'Couldn\'t save your language.';

  @override
  String get accountDeleteFailed => 'Couldn\'t delete your account.';

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get avatarIntro =>
      'Voice and difficulty vary by call partner.\nSome partners may require payment.';

  @override
  String myPartnersOwned(int count) {
    return 'My Partners · $count owned';
  }

  @override
  String get limitedDiscount => 'Limited-time discount';

  @override
  String get available => 'Available';

  @override
  String get inUse => 'In use';

  @override
  String get owned => 'Owned';

  @override
  String get noCharactersToShow => 'No characters to show';

  @override
  String get buy => 'Buy';

  @override
  String get noSavedSentences =>
      'No saved sentences yet.\nBookmark sentences from your conversation records.';

  @override
  String get noAlarms => 'No alarms yet';

  @override
  String get noAlarmsBody =>
      'Add a learning reminder\nto build a consistent habit.';

  @override
  String get subscriptionManage => 'Manage Subscription';

  @override
  String get changePlan => 'Change Plan';

  @override
  String get cancelSubscription => 'Cancel Subscription';

  @override
  String get benefitsInUse => 'Your benefits';

  @override
  String get paymentInfo => 'Payment info';

  @override
  String get nextBillingDate => 'Next billing date';

  @override
  String get lostBenefitsTitle => 'Benefits you\'ll lose if you cancel';

  @override
  String get viewBillingHistory => 'View Billing History';

  @override
  String get keepUsingPro => 'Keep Using Pro';

  @override
  String get proMembership => 'Pro Membership';

  @override
  String get pricePerMonth => '\$12.9 / mo';

  @override
  String get benefitUnlimitedCalls => 'Unlimited calls';

  @override
  String get benefitDetailedAnalysis =>
      'Detailed pronunciation & grammar analysis';

  @override
  String get benefitAllCharacters => 'Access to all characters';

  @override
  String get benefitNoAds => 'No ads';

  @override
  String get playSampleVoice => 'Play sample voice';

  @override
  String get useThisAvatar => 'Use This';

  @override
  String get challengeTitle => 'Pronunciation Challenge';

  @override
  String get challengeIntro =>
      'Pronounce each card in the zone correctly in Korean to clear it.\nNo mic? You can also play by tapping the screen.';

  @override
  String get challengeStart => 'Start Camera & Mic';

  @override
  String get challengePermissionNote =>
      'Front camera and mic access is required (optional).';

  @override
  String get challengeLoadingTitle => 'Loading…';

  @override
  String get challengeLoadingNote =>
      'Downloading the Korean speech model (~82MB) on first run.\nPlease wait a moment.';

  @override
  String get challengeSttFallback =>
      'Speech recognition wasn\'t available, so you played with tap input.';

  @override
  String get reasonTravelTitle => 'Speaking while traveling';

  @override
  String get reasonTravelDesc => 'Chat confidently with locals';

  @override
  String get reasonCareerTitle => 'Work & career';

  @override
  String get reasonCareerDesc => 'Business conversation';

  @override
  String get reasonExamTitle => 'Test prep';

  @override
  String get reasonExamDesc => 'Prepare for speaking tests';

  @override
  String get reasonDailyTitle => 'Everyday conversation';

  @override
  String get reasonDailyDesc => 'Expressions you use daily';

  @override
  String get reasonFriendsTitle => 'Making foreign friends';

  @override
  String get reasonFriendsDesc => 'Natural conversation';

  @override
  String get reasonBrainTitle => 'Brain stimulation';

  @override
  String get reasonBrainDesc => 'Boost memory & focus';

  @override
  String get challengeRecordToggle => 'Record this run';

  @override
  String get challengeRecordHint =>
      'Saves a video of your gameplay to share (silent).';
}
