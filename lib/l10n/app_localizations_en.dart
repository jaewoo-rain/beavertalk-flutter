// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginRequired => 'You need to sign in.';

  @override
  String get callWebNotSupported =>
      'Voice calls aren\'t supported on the web. Please use the app.';

  @override
  String get micPermissionRequiredForCall =>
      'Microphone access is required. Allow the microphone to start a call.';

  @override
  String get callErrorGeneric => 'Something went wrong during the call.';

  @override
  String get callNetworkError => 'A network error occurred.';

  @override
  String get authInvalidCredentials => 'Your email or password is incorrect.';

  @override
  String get authEmailAlreadyRegistered => 'This email is already registered.';

  @override
  String get authConfirmEmailRequired =>
      'Please complete the verification sent to your email.';

  @override
  String get authResetCodeSent =>
      'We\'ve sent a verification code to your email.';

  @override
  String get authResetCodeInvalid => 'That code is incorrect or has expired.';

  @override
  String get authPasswordUpdated => 'Your password has been reset.';

  @override
  String get authAppleTokenMissing => 'Couldn\'t get your Apple sign-in token.';

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
  String get scheduleManagement => 'Manage schedule';

  @override
  String get alarms => 'Alarms';

  @override
  String get addSchedule => 'Add new schedule';

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
  String get callPartner => 'Call partner';

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
  String get analysisLoadError => 'Couldn\'t load the analysis result.';

  @override
  String get standardAudioNotReady =>
      'Standard pronunciation audio isn\'t ready yet.';

  @override
  String get standardAudioPlayError =>
      'Couldn\'t play the standard pronunciation audio.';

  @override
  String get selectNativeLanguage => 'Select your native language';

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
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

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
  String get noAlarms => 'No alarms registered';

  @override
  String get noAlarmsBody =>
      'Add a learning reminder\nand you can build a consistent habit.';

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
  String pricePerMonth(String price) {
    return '$price / mo';
  }

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

  @override
  String get settingsSection => 'Settings';

  @override
  String get paymentSection => 'Payment';

  @override
  String get supportSection => 'Support';

  @override
  String get userLanguage => 'User Language';

  @override
  String get learningLanguage => 'Learning Language';

  @override
  String get learningLanguageKorean => 'Korean';

  @override
  String get notificationLabel => 'Notification';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get logOut => 'Log out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account and data and cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get accentSoundsLike => 'Your Korean accent sounds';

  @override
  String get hintLabel => 'Hint';

  @override
  String get nextHint => 'Next hint';

  @override
  String get translateLabel => 'Translate';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get back => 'Back';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingNameSubtitle => 'Your AI tutor will remember your name.';

  @override
  String get nameLabel => 'Your name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get nameHelper =>
      'It doesn\'t have to be your real name — a nickname works too.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardingDoneTitle => 'Beaver is waiting for your call';

  @override
  String get onboardingDoneSubtitle => 'Start a call right now';

  @override
  String get home => 'Home';

  @override
  String get callNow => 'Call now';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get fluency => 'Fluency';

  @override
  String get rhythm => 'Rhythm';

  @override
  String get analysisTimeout =>
      'This is taking longer than expected. Please try again in a moment.';

  @override
  String get analysisFailed =>
      'We couldn\'t analyze the conversation. Please try again.';

  @override
  String get analyzingConversation => 'Analyzing your conversation…';

  @override
  String get analyzingSubtitle => 'This will only take a moment';

  @override
  String get tryAgain => 'Try again';

  @override
  String get nativeLabel => 'Native';

  @override
  String get meLabel => 'Me';

  @override
  String get pronunciationPlayError =>
      'Couldn\'t play the pronunciation audio.';

  @override
  String get savedExpressionsLoadError =>
      'Couldn\'t load your saved expressions.';

  @override
  String get mySavedExpressions => 'My Saved Expressions';

  @override
  String get avatarTraits => 'Warm · Calm · Soft';

  @override
  String get priceFree => 'Free';

  @override
  String get loginGoogleTokenError => 'Couldn\'t get a Google sign-in token.';

  @override
  String get loginGoogleSignInFailed => 'Google sign-in failed.';

  @override
  String get loginAppleSignInFailed => 'Apple sign-in failed.';

  @override
  String get loginFacebookSignInFailed => 'Facebook sign-in failed.';

  @override
  String get loginKakaoSignInFailed => 'Kakao sign-in failed.';

  @override
  String get loginContinueWithKakao => 'Continue with Kakao';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginContinueWithFacebook => 'Continue with Facebook';

  @override
  String get loginContinueWithApple => 'Continue with Apple';

  @override
  String get loginContinueWithEmail => 'Continue with email';

  @override
  String get loginOrDivider => 'or';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginTermsNoticePrefix => 'By continuing, you agree to our ';

  @override
  String get loginTermsNoticeAnd => ' and ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Log in';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get loginRememberMe => 'Remember me';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginLoggingIn => 'Logging in...';

  @override
  String get passwordLengthError => 'Password must be 8–16 characters.';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match.';

  @override
  String get signupCheckInput => 'Please check your input.';

  @override
  String get fieldConfirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get signupSigningUp => 'Signing up...';

  @override
  String get signupHaveAccount => 'Already have an account?';

  @override
  String get passwordMethodEmailRequired => 'Enter your email';

  @override
  String get passwordResetTitle => 'Reset password';

  @override
  String get passwordMethodDescription =>
      'Enter the email address where you\'d like to receive the password reset code.';

  @override
  String get emailAddressHint => 'Email address';

  @override
  String get passwordMethodSending => 'Sending...';

  @override
  String get passwordMethodSendEmail => 'Send email';

  @override
  String get passwordCodeTitle => 'Enter code';

  @override
  String get passwordCodeDescription =>
      'We\'ve sent a recovery code to your email. Enter it to continue.';

  @override
  String get passwordCodeNoCode => 'Didn\'t get the code?';

  @override
  String get passwordCodeResend => 'Resend code';

  @override
  String get passwordCodeVerifying => 'Verifying...';

  @override
  String get passwordNewTitle => 'New password';

  @override
  String get passwordNewDescription => 'Set a new password for your account.';

  @override
  String get fieldNewPasswordLabel => 'New password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get fieldConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get confirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get passwordNewSubmitting => 'Submitting...';

  @override
  String get passwordNewSubmit => 'Submit';

  @override
  String get passwordCompleteTitle => 'Password reset complete';

  @override
  String get passwordCompleteBody =>
      'Your password has been reset. Log in with your new password to continue.';

  @override
  String get termsTitle => 'Terms of service';

  @override
  String get privacyTitle => 'Privacy policy';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Set a new password for $email.';
  }

  @override
  String get selectComplete => 'Done';

  @override
  String get onboardingLanguageTitle => 'What is your native language?';

  @override
  String get onboardingReasonTitle => 'Why are you learning a language?';

  @override
  String get onboardingReasonSubtitle =>
      'We\'ll tailor your learning to your goals.';

  @override
  String get savingLabel => 'Saving...';

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

  @override
  String get accentAnalysis => 'Accent analysis';

  @override
  String get overallLevel => 'Overall level';

  @override
  String get overallLevelSubtitle => 'Vocabulary · Grammar · Expressions';

  @override
  String get pronunciationAnalysis => 'Pronunciation analysis';

  @override
  String get recentSessionsAverage => 'Last 10 sessions avg.';

  @override
  String levelStage(int stage) {
    return 'Stage $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Among all learners';

  @override
  String aheadOfLearners(int percent) {
    return 'You\'re ahead of $percent% of all learners';
  }

  @override
  String get retakeLevelTest => 'Retake level test';

  @override
  String get practicePronunciation => 'Practice pronunciation';

  @override
  String get priceChangedTitle => 'Price changed';

  @override
  String priceChangedBody(String price) {
    return 'This item is now $price. Would you like to continue?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plan & purchases';

  @override
  String get billingGroupInTheStore => 'In the store';

  @override
  String get billingChangePlan => 'Change plan';

  @override
  String get billingCompareAllPlans => 'Compare all plans';

  @override
  String get billingBuyACharacter => 'Buy a character';

  @override
  String get billingRestorePurchases => 'Restore purchases';

  @override
  String get billingPaymentHistory => 'Payment history';

  @override
  String get billingManageInTheStore => 'Manage in the store';

  @override
  String get billingRefundHelp => 'Refund help';

  @override
  String get billingCancelSubscription => 'Cancel subscription';

  @override
  String get billingResubscribe => 'Resubscribe';

  @override
  String get badgeCurrent => 'Current';

  @override
  String get badgeTrial => 'Trial';

  @override
  String get badgeRenewing => 'Renewing';

  @override
  String get badgePastDue => 'Past due';

  @override
  String get badgePaused => 'Paused';

  @override
  String get badgeCanceling => 'Canceling';

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get plansTitle => 'Plans';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max trial';

  @override
  String get freePlanPriceLine => '\$0.00 — one call a day';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount per month';
  }

  @override
  String freeUntilDate(String date) {
    return 'Free until $date';
  }

  @override
  String get todaysCalls => 'Today\'s calls';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used of $limit used';
  }

  @override
  String get firstPaymentLabel => 'First payment';

  @override
  String get nextPaymentLabel => 'Next payment';

  @override
  String get retryingUntilLabel => 'Retrying until';

  @override
  String get pausedSinceLabel => 'Paused since';

  @override
  String planEndsLabel(String plan) {
    return '$plan ends';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Go unlimited with Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Unlimited calls · 15 minutes each · $price per month';
  }

  @override
  String get bannerMaxUpsellTitle => 'Turn on video with Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Face-to-face calls · $price per month';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Switch to annual';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly per year · $perMonth per month';
  }

  @override
  String get bannerPaymentFailedTitle => 'We couldn\'t take the payment';

  @override
  String get bannerPaymentFailedSub =>
      'Update payment in the store to keep Pro';

  @override
  String get bannerPausedTitle => 'Your plan is paused';

  @override
  String get bannerPausedSub => 'The payment never went through';

  @override
  String get noteRestoreHint =>
      'Already subscribed on another device? Restore brings it back on this one.';

  @override
  String get noteStoreHandled =>
      'Payment method, plan changes, and cancellation are handled by the store.';

  @override
  String get noteFairUse => 'Unlimited use is subject to our fair use policy.';

  @override
  String noteTrialEnds(String date) {
    return 'Your trial ends $date. Cancel in the store before then and nothing is charged.';
  }

  @override
  String get noteGrace =>
      'Benefits keep running through the grace period. Cancellation is never intercepted in the app.';

  @override
  String get noteHold =>
      'Pro is paused until the payment goes through. Your characters and progress are safe.';

  @override
  String noteEnding(String date) {
    return 'Your plan is set to end. Benefits run until $date, then you move to Free. You can resubscribe any time.';
  }

  @override
  String get trialExpiredTitle => 'Your Max trial ended';

  @override
  String get trialExpiredSub => 'You are on Free now';

  @override
  String get seePlans => 'See plans';

  @override
  String get currentPlanTitle => 'Current Plan';

  @override
  String get badgeRecommended => 'Recommended';

  @override
  String get perMonthUnit => 'per month';

  @override
  String get planTaglinePro => 'Unlimited calls. 15 minutes each.';

  @override
  String get planTaglineMax => 'Now you can see them.';

  @override
  String get planTaglineFree => 'One call a day. On the house.';

  @override
  String get bulletProCalls => 'Voice calls, as often as you want';

  @override
  String get bulletProLength => '15 minutes a call';

  @override
  String get bulletProScoring => 'Pronunciation scored letter by letter';

  @override
  String get bulletProCorrections =>
      'Corrections aimed at your native language';

  @override
  String get bulletProBeaverCalls => 'Beaver calls you first';

  @override
  String get bulletMaxVideo => 'Face-to-face video calls';

  @override
  String get bulletMaxEverything => 'Everything in Pro';

  @override
  String get bulletMaxCharacters => 'Every character, unlimited';

  @override
  String get bulletMaxStudyBook => 'A study book matched to where you are';

  @override
  String get bulletMaxWeeklyReport =>
      'A weekly report on how your sound is changing';

  @override
  String get bulletFreeCall => 'One 5-minute voice call a day';

  @override
  String get bulletFreeCheck => 'One pronunciation check a day';

  @override
  String get bulletFreeAccent => 'Unlimited accent checks';

  @override
  String get bulletFreeCharacter => 'One character to start';

  @override
  String get ctaGoUnlimited => 'Go unlimited';

  @override
  String get ctaTurnOnVideo => 'Turn on video';

  @override
  String get noteCallLength => 'Calls are 15 minutes each.';

  @override
  String get paywallProTitle1 => 'Your Korean friend';

  @override
  String get paywallProTitle2 => 'who\'s up at 3 a.m.';

  @override
  String get paywallProSub => 'Unlimited calls. 15 minutes each. All year.';

  @override
  String get paywallLimitHeadline => 'Pro removes the limit.';

  @override
  String get limitBannerCallTitle => 'That was today\'s call';

  @override
  String get limitBannerCallSub => 'Free gives you one call a day';

  @override
  String get limitBannerCheckTitle => 'That was today\'s check';

  @override
  String get limitBannerCheckSub => 'Free gives you one check a day';

  @override
  String get bulletProCharactersForever =>
      'Characters you buy stay yours forever';

  @override
  String get paywallMaxTitle => 'Now you can see them.';

  @override
  String get paywallMaxSub =>
      'Video calls, every character, and a study book made for where you are.';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planAnnual => 'Annual';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price per month';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth per month';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price per month';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly per year · $perMonth per month';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price per month · cancel anytime in the store';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price per month · cancel anytime in the store';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 days free, then $price per month · cancel anytime in the store';
  }

  @override
  String get ctaCaptionAutoRenew => 'Renews automatically until canceled.';

  @override
  String get footerTerms => 'Terms';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get noteMaxCharacters =>
      'Characters unlocked by Max are available while your subscription is active. Characters you bought stay yours.';

  @override
  String get processingTitle => 'Confirming your purchase';

  @override
  String get processingSub => 'This usually takes a few seconds.';

  @override
  String get successProTitle => 'You\'re on Pro.';

  @override
  String get successProSub => 'Unlimited calls, starting right now.';

  @override
  String get successProBenefit1 =>
      'Call as often as you want — 15 minutes a call';

  @override
  String get successProBenefit2 => 'Unlimited pronunciation checks';

  @override
  String get successProBenefit3 => 'Every character, plus one-off purchases';

  @override
  String get successMaxTitle => 'You can see them now.';

  @override
  String get successMaxSub =>
      'Video calls are on. Tap the video button in any call.';

  @override
  String get successMaxBenefit1 => 'Face-to-face video calls';

  @override
  String get successMaxBenefit2 =>
      'Every character, unlimited and new ones first';

  @override
  String get successMaxBenefit3 => 'A study book matched to where you are';

  @override
  String get ctaStartACall => 'Start a call';

  @override
  String get ctaStartAVideoCall => 'Start a video call';

  @override
  String get ctaSeeYourSubscription => 'See your subscription';

  @override
  String successProCaption(String price) {
    return '$price is charged monthly until you cancel. Manage or cancel anytime in the store.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price is charged monthly until you cancel. Manage or cancel anytime in the store.';
  }

  @override
  String get plansErrorTitle => 'We couldn\'t load the plans';

  @override
  String get plansErrorSub => 'The store didn\'t answer.';

  @override
  String get ctaTryAgain => 'Try again';

  @override
  String get plansErrorCaption => 'Nothing was charged.';

  @override
  String get changePlanTitle => 'Change Plan';

  @override
  String get moveToMaxTitle => 'Move to Max';

  @override
  String maxPriceShort(String price) {
    return '$price / mo';
  }

  @override
  String get moveToMaxCardSub =>
      'Face-to-face video calls · every character · a study book made for you';

  @override
  String get whatHappensNow => 'What happens now';

  @override
  String get maxStartsLabel => 'Max starts';

  @override
  String get immediately => 'Immediately';

  @override
  String get unusedProTime => 'Unused Pro time';

  @override
  String get creditedTowardMax => 'Credited toward Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Switch to Max';

  @override
  String get upgradeCaption =>
      'Your new plan starts right away. Unused Pro time is credited, never charged twice.';

  @override
  String get moveToProTitle => 'Move to Pro';

  @override
  String get moveToProSub =>
      'Nothing changes today. Max runs to the end of the month you already paid for.';

  @override
  String get maxRunsUntil => 'Max runs until';

  @override
  String get proStarts => 'Pro starts';

  @override
  String get whatYouKeep => 'What you keep';

  @override
  String get keepBenefitCalls => 'Unlimited voice calls, 15 minutes each';

  @override
  String get keepBenefitCharacters =>
      'Characters you bought stay yours forever';

  @override
  String downgradeWarning(String date) {
    return 'Video calls and Max-only characters turn off on $date.';
  }

  @override
  String get ctaSwitchToPro => 'Switch to Pro';

  @override
  String get ctaKeepMax => 'Keep Max';

  @override
  String get winbackSkip => 'Skip';

  @override
  String get winbackTitle => 'Your Pro plan ended';

  @override
  String get winbackSub => 'You\'re on Free now — one call a day.';

  @override
  String get winbackQuestion => 'Mind telling us why you left?';

  @override
  String get winbackReasonExpensive => 'Too expensive';

  @override
  String get winbackReasonUnused => 'I wasn\'t using it enough';

  @override
  String get winbackReasonMissing => 'Missing a feature I needed';

  @override
  String get winbackReasonOtherApp => 'I found another app';

  @override
  String get winbackReasonElse => 'Something else';

  @override
  String get ctaSend => 'Send';

  @override
  String get ctaNotNow => 'Not now';

  @override
  String get winbackCaption =>
      'This doesn\'t restore your plan. Resubscribe in the store.';

  @override
  String get ctaContinue => 'Continue';

  @override
  String get ctaClose => 'Close';

  @override
  String get ovRestoreSuccessTitle => 'Pro is back';

  @override
  String get ovRestoreSuccessBody =>
      'We found your subscription and turned it back on for this device.';

  @override
  String get ovRestoreEmptyTitle => 'Nothing to restore';

  @override
  String get ovRestoreEmptyBody =>
      'No active subscription is linked to this store account.';

  @override
  String get ovRestoreOtherTitle => 'That plan belongs to another account';

  @override
  String get ovRestoreOtherBody =>
      'This subscription is already active on a different BeaverTalk account.';

  @override
  String get ctaSignInThatAccount => 'Sign in to that account';

  @override
  String get ctaGetHelp => 'Get help';

  @override
  String get ovCharacterOfferTitle => 'Not ready for Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Pick one character and keep them. A one-off purchase — no subscription, no renewal.';

  @override
  String get rowOneCharacter => 'One character';

  @override
  String rowFromPrice(String price) {
    return 'from $price';
  }

  @override
  String get rowYoursForever => 'Yours forever';

  @override
  String get rowNoRenewal => 'No renewal';

  @override
  String get rowWorksOnFree => 'Works on Free';

  @override
  String get rowYes => 'Yes';

  @override
  String get ctaSeeCharacters => 'See characters';

  @override
  String get ovNotEligibleTitle => 'Nothing to cancel';

  @override
  String get ovNotEligibleBody =>
      'You\'re on Free. There is no active subscription on this account.';

  @override
  String get ovCancelDownsellTitle => 'Before you go';

  @override
  String get ovCancelDownsellBody =>
      'Canceling happens in the store. Two things worth knowing.';

  @override
  String get rowPayYearlyInstead => 'Pay yearly instead';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price per month';
  }

  @override
  String get rowCharactersYouBought => 'Characters you bought';

  @override
  String get rowProRunsUntil => 'Pro runs until';

  @override
  String get ctaSwitchToYearly => 'Switch to yearly';

  @override
  String get ctaContinueToStore => 'Continue to the store';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Pay yearly, save $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'You\'ve been on Pro for two months. The yearly plan works out cheaper.';

  @override
  String get rowYouSave => 'You save';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Yearly';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Monthly, for a year';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Switch to monthly';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Your yearly plan runs until $date. Monthly billing starts the day after.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Monthly billing starts';

  @override
  String get rowMonthlyLabel => 'Monthly';

  @override
  String get rowYearlyWorkedOut => 'Yearly worked out at';

  @override
  String get ctaSwitchToMonthly => 'Switch to monthly';

  @override
  String get ovRefundHelpTitle => 'Refunds are handled by the store';

  @override
  String get ovRefundHelpBody =>
      'We cannot issue refunds ourselves. Every request is reviewed by the store.';

  @override
  String get ctaGoToStore => 'Go to the store';

  @override
  String get ovTrialEndingTitle => 'Your trial ends tomorrow';

  @override
  String get ovTrialEndingBody =>
      'Max keeps running unless you cancel. Here is what happens.';

  @override
  String get rowTrialEnds => 'Trial ends';

  @override
  String get rowFirstCharge => 'First charge';

  @override
  String get rowThenMonthly => 'Then monthly';

  @override
  String get ctaCancelInStore => 'Cancel in the store';

  @override
  String get ovTrialStartTitle => '7 days of Max, free';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Free until $date. Then $price per month, unless you cancel in the store.';
  }

  @override
  String get ctaStart7Days => 'Start 7 days free';

  @override
  String get ovOtoTitle => 'One more thing before you start';

  @override
  String get ovOtoBody =>
      'Good call — unlimited calls are on right now. The same Pro costs less if you pay yearly.';

  @override
  String get ovFailedDeclinedTitle => 'Your card was declined';

  @override
  String get ovFailedDeclinedBody =>
      'The store couldn\'t take the payment. Nothing was charged.';

  @override
  String get ctaUpdatePaymentMethod => 'Update payment method';

  @override
  String get ovFailedCanceledTitle => 'Payment canceled';

  @override
  String get ovFailedCanceledBody =>
      'You\'re still on Free. Nothing was charged.';

  @override
  String get ovFailedStoreTitle => 'Something went wrong';

  @override
  String get ovFailedStoreBody =>
      'We couldn\'t reach the store. Nothing was charged.';

  @override
  String get ovAlreadyTitle => 'You\'re already on Pro';

  @override
  String get ovAlreadyBody =>
      'This store account has an active plan. There\'s nothing to buy.';

  @override
  String get ctaSeeMySubscription => 'See my subscription';

  @override
  String get subCancelTitle => 'Cancel subscription';

  @override
  String subCancelBody(String date) {
    return 'Pro runs until $date. After that you move to Free.';
  }

  @override
  String get subWhatYouLose => 'What you lose';

  @override
  String get benefitCalls15 => 'Unlimited calls, 15 minutes each';

  @override
  String get benefitScoring => 'Pronunciation scored letter by letter';

  @override
  String get benefitEveryCharacter => 'Every character, unlimited';

  @override
  String get ctaKeepPro => 'Keep Pro';

  @override
  String get subPaymentTitle => 'Update payment';

  @override
  String get subPaymentBody =>
      'We could not take the payment. Pro keeps running during the grace period.';

  @override
  String get subHowToFix => 'How to fix it';

  @override
  String get fixStep1 => 'Open the store and update your payment method';

  @override
  String get fixStep2 => 'Come back — your plan resumes automatically';

  @override
  String get fixStep3 => 'Nothing is charged twice';

  @override
  String get subResubTitle => 'Resubscribe';

  @override
  String subResubBody(String date) {
    return 'Pro ends on $date. Turn auto-renew back on and nothing changes.';
  }

  @override
  String get subWhatYouKeep => 'What you keep';

  @override
  String get ctaTurnItBackOn => 'Turn it back on';

  @override
  String get flTodayTitle => 'That\'s today\'s call';

  @override
  String get flTodayBody => 'Pick up where you left off — right now.';

  @override
  String get flCheckTitle => 'That\'s today\'s check';

  @override
  String get flCheckBody => 'One check a day on Free. Pro makes it unlimited.';

  @override
  String get flBenefitCalls => 'Unlimited calls with Pro · 15 minutes each';

  @override
  String get flBenefitChecks => 'Unlimited pronunciation checks with Pro';

  @override
  String flCaption(String price) {
    return '$price per month · cancel anytime';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used of $limit used';
  }

  @override
  String get ctaMaybeTomorrow => 'Maybe tomorrow';

  @override
  String get accountSection => 'Account';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Login Method';

  @override
  String get joinedLabel => 'Joined';

  @override
  String get editNicknameTitle => 'Edit Nickname';

  @override
  String get nicknameRule =>
      '2–12 characters. Letters and numbers. English Only';

  @override
  String get ctaSave => 'Save';

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
  String get paywallLeaveTitle => 'If you leave now, you won\'t be subscribed';

  @override
  String get paywallLeaveBody =>
      'Your benefits unlock right after checkout. You can come back anytime from My Page.';

  @override
  String get ctaKeepLooking => 'Keep looking';

  @override
  String get ctaLeaveAnyway => 'Leave anyway';

  @override
  String get iapCharacterSuccessTitle => 'A new friend joins you!';

  @override
  String get iapCharacterSuccessBody =>
      'This character is yours forever - it stays even if your plan changes, and Restore purchases brings it back on any device.';

  @override
  String get iapCharacterFailedBody =>
      'The purchase didn\'t go through. Nothing was charged - please try again.';

  @override
  String get noAccentDataTitle => 'No accent data yet';

  @override
  String get noAccentDataBody =>
      'Keep talking and your accent patterns will build up.';

  @override
  String get noLevelYetTitle => 'No level yet';

  @override
  String get noLevelYetBody => 'Finish your first call to get your level.';

  @override
  String get noPronunciationDataTitle => 'No pronunciation records yet';

  @override
  String get noPronunciationDataBody =>
      'We analyze your pronunciation from what you say on calls.';

  @override
  String get noCharacterNote => 'Nothing said yet';

  @override
  String get noPhonemesYet => 'No sounds to analyze yet';

  @override
  String get noSentencesYet => 'No sentences to analyze yet';

  @override
  String get takeLevelTest => 'Take level test';

  @override
  String get reviewToSeeScore => 'Review to see your pronunciation score';

  @override
  String get playAgain => 'Play Again';

  @override
  String get difficultySlow => 'Slow';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Fast';

  @override
  String get difficultyLabel => 'Difficulty';

  @override
  String get connected => 'Connected';

  @override
  String get unlockedWithMax => 'Available with Max';

  @override
  String get callModeSheetTitle => 'How do you want to talk?';

  @override
  String get callModeSheetSubtitle => 'Applies to this call right away';

  @override
  String get callModeFreeTalk => 'Free Talk';

  @override
  String get callModeFreeTalkDesc => 'Just talk — no corrections';

  @override
  String get callModeStudy => 'Study';

  @override
  String get callModeStudyDesc => 'Learn one expression at a time';

  @override
  String get callModeChange => 'Change mode';

  @override
  String get callModeKeep => 'Not now';

  @override
  String get callExitTitle => 'End this call?';

  @override
  String get callExitSubtitle => 'Ending now still uses one of your calls';

  @override
  String get callExitKeep => 'Keep talking';

  @override
  String get callExitConfirm => 'End call';

  @override
  String get callMicMute => 'Mute';

  @override
  String get callMicUnmute => 'Unmute';

  @override
  String get callPushToTalk => 'Hold to talk';
}
