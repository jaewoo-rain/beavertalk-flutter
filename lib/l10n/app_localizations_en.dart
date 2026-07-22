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
  String get loginKakaoSignInFailed => 'Kakao sign-in failed.';

  @override
  String get loginContinueWithKakao => 'Continue with Kakao';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

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
}
