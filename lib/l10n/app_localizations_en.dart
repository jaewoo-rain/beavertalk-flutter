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
  String get callDailyLimit => 'You\'ve used up today\'s learning time.';

  @override
  String get callAlreadyInCall => 'You\'re already on a call.';

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
  String get callRatingBody => 'Your rating helps us talk better next time.';

  @override
  String get callRatingSubmit => 'Submit';

  @override
  String get callRatingSkip => 'Skip';

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
  String get alarmAdd => 'Add alarm';

  @override
  String get alarmEdit => 'Edit alarm';

  @override
  String get alarmEveryDay => 'Every day';

  @override
  String get alarmWeekdays => 'Weekdays';

  @override
  String get alarmWeekend => 'Weekends';

  @override
  String get alarmNoRepeat => 'Never';

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
  String get alarmModeLearnSub => 'Practice curriculum expressions';

  @override
  String get alarmModeChatSub => 'Talk about anything';

  @override
  String alarmRowSummary(String days, String mode) {
    return '$days, $mode';
  }

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
  String get newExpressions => 'New Expressions';

  @override
  String get analysisPrepNote => 'Looking back on today\'s call.';

  @override
  String get analysisPrepNoteHint => 'A note will appear here shortly';

  @override
  String get analysisPrepTitle =>
      'The beaver is turning today\'s expressions into cards';

  @override
  String get analysisPrepSub => 'They\'ll show up right here when ready.';

  @override
  String get analysisPrepStepSave => 'Saving the conversation';

  @override
  String get analysisPrepStepCards => 'Making expression cards';

  @override
  String get analysisPrepStateDone => 'Done';

  @override
  String get analysisPrepStateWorking => 'In progress';

  @override
  String get analysisPrepStateWaiting => 'Waiting';

  @override
  String get usedExpressions => 'Expressions you used';

  @override
  String quizExpressionsCount(int count) {
    return 'Expressions you learned $count';
  }

  @override
  String get quizPassed => 'Got it';

  @override
  String get quizFailed => 'Review again';

  @override
  String get quizPending => 'Continue next time';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get noNewExpressions => 'No new expressions from this conversation.';

  @override
  String get practice => 'Practice';

  @override
  String get analysisNativeLabel => 'Native';

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
  String get homeCourseExpression => 'Expression';

  @override
  String get homeCourseFreetalk => 'Conversation';

  @override
  String homeExpressionsLeft(int count) {
    return '$count expressions left until conversation';
  }

  @override
  String get homeFreetalkNote => 'Use what you learned and talk freely';

  @override
  String get homeTalkTitle => 'What happened today?';

  @override
  String get homeTalkNote => 'Chat freely and learn as you go.';

  @override
  String get homeModeLearn => 'Learn';

  @override
  String get homeModeTalk => 'Talk';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Learning calendar';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days in a row',
      one: 'day in a row',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Best streak: $count days',
      one: 'Best streak: $count day',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Call time';

  @override
  String get streakMetricLearned => 'Expressions';

  @override
  String get streakMetricWords => 'Words spoken';

  @override
  String streakCountValue(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'No calls on this day.';

  @override
  String get homeLevelPending => 'Level pending';

  @override
  String get homeNoLevelTitle => 'You don\'t have a level yet';

  @override
  String get homeNoLevelNote => 'Finish your first call to get one';

  @override
  String get homeCurriculumPendingBadge => 'Coming soon';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language curriculum is on its way';
  }

  @override
  String get homeCurriculumPendingNote =>
      'You\'ll practice general expressions on your calls';

  @override
  String get myPage => 'My Page';

  @override
  String get languageSaveFailed => 'Couldn\'t save your language.';

  @override
  String get accountDeleteFailed => 'Couldn\'t delete your account.';

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get avatarUseNow => 'Use now';

  @override
  String get avatarPurchaseFailed => 'The purchase didn\'t go through';

  @override
  String avatarPromoTitle(int percent) {
    return 'Today only · $percent% off';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time left';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '${days}d $time left';
  }

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
  String pricePerMonth(String price) {
    return '$price / mo';
  }

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
      'Read each word aloud as it comes at you, for 30 seconds.\nNo mic? Tap to play instead.';

  @override
  String get challengeStart => 'Start';

  @override
  String get challengePermissionNote =>
      'Front camera and mic access is required (optional).';

  @override
  String get challengeLoadingTitle => 'Loading…';

  @override
  String get challengeLoadingNote => 'Getting the camera and microphone ready.';

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
  String get onboardingLevelTestCta => 'Take level test';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get fluency => 'Fluency';

  @override
  String get rhythm => 'Rhythm';

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
  String get freePlanCallLimit => '5 minutes of calls a day';

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
  String get levelRetakeTitle => 'Retake the level test?';

  @override
  String get levelRetakeBody =>
      'If you retake it, your progress goes back to the first lesson of that level — even if you get the same level. Your learned expressions and call history stay.';

  @override
  String get levelRetakeKeep => 'Keep my progress';

  @override
  String get levelRetakeConfirm => 'Retake test';

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
  String get billingCompareAllPlans => 'Compare plans';

  @override
  String get billingBuyACharacter => 'Buy a character';

  @override
  String get billingRestorePurchases => 'Restore purchases';

  @override
  String get billingRedeemCode => 'Redeem a code';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => '15 minutes of video calls a day';

  @override
  String get premiumBulletAnalysis => 'Full pronunciation analysis';

  @override
  String get premiumBulletWeakSounds => 'Weak-sound drills for your language';

  @override
  String get noteCharactersSeparate =>
      'Characters are sold separately. The ones you buy stay yours.';

  @override
  String get ctaGetPremium => 'Get Premium';

  @override
  String get planMaxTrial => 'Premium trial';

  @override
  String get freePlanPriceLine => '\$0.00 — 5 minutes of calls a day';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount per month';
  }

  @override
  String freeUntilDate(String date) {
    return 'Free until $date';
  }

  @override
  String get todaysCalls => 'Today\'s call time';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used of $limit min used';
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
  String get bannerMaxUpsellTitle => 'Get face to face with Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Video calls · 15 minutes a day · $price per month';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Switch to annual';

  @override
  String get bannerPaymentFailedTitle => 'We couldn\'t take the payment';

  @override
  String get bannerPaymentFailedSub =>
      'Update payment in the store to keep Premium';

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
  String noteTrialEnds(String date) {
    return 'Your trial ends $date. Cancel in the store before then and nothing is charged.';
  }

  @override
  String get noteGrace =>
      'Benefits keep running through the grace period. Cancellation is never intercepted in the app.';

  @override
  String get noteHold =>
      'Premium is paused until the payment goes through. Your characters and progress are safe.';

  @override
  String noteEnding(String date) {
    return 'Your plan is set to end. Benefits run until $date, then you move to Free. You can resubscribe any time.';
  }

  @override
  String get trialExpiredTitle => 'Your Premium trial ended';

  @override
  String get trialExpiredSub => 'You are on Free now';

  @override
  String get seePlans => 'See plans';

  @override
  String get currentPlanTitle => 'Current Plan';

  @override
  String get perMonthUnit => 'per month';

  @override
  String get planTaglineMax => 'Now you can see them.';

  @override
  String get planTaglineFree => '5 minutes of calls a day. On the house.';

  @override
  String get bulletProCorrections =>
      'Corrections aimed at your native language';

  @override
  String get bulletFreeCall => '5 minutes of voice calls a day';

  @override
  String get bulletFreeCheck => 'Full analysis for your first 3 calls';

  @override
  String get bulletFreeCharacter => 'Two characters to start';

  @override
  String get ctaTurnOnVideo => 'Turn on video';

  @override
  String get noteCallLength =>
      'Premium: 15 minutes of calls a day — call as often as you like within that.';

  @override
  String get paywallProTitle1 => 'Your Korean friend';

  @override
  String get paywallProTitle2 => 'who\'s up at 3 a.m.';

  @override
  String get paywallLimitHeadline =>
      'Premium gives you 15 minutes of calls a day.';

  @override
  String get limitBannerCallTitle => 'You\'ve used today\'s call time';

  @override
  String get limitBannerCallSub => 'Free gives you 5 minutes of calls a day';

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
  String paywallTutorCompare(String price) {
    return 'One hour with a tutor costs \$25. A month of Premium costs $price.';
  }

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
  String get processingTitle => 'Confirming your purchase';

  @override
  String get processingSub => 'This usually takes a few seconds.';

  @override
  String get successProTitle => 'You\'re on Premium.';

  @override
  String get successMaxTitle => 'You can see them now.';

  @override
  String get successMaxSub =>
      'Video calls are on. Tap the video button in any call.';

  @override
  String get ctaStartAVideoCall => 'Start a video call';

  @override
  String get ctaSeeYourSubscription => 'See your subscription';

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
  String get ctaKeepMax => 'Keep Premium';

  @override
  String get winbackSkip => 'Skip';

  @override
  String get winbackTitle => 'Your Premium plan ended';

  @override
  String get winbackSub => 'You\'re on Free now — 5 minutes of calls a day.';

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
  String get ovRestoreSuccessTitle => 'Premium is back';

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
  String get ovCharacterOfferTitle => 'Not ready for Premium?';

  @override
  String get ovCharacterOfferBody =>
      'Pick one character and keep them. A one-off purchase — no subscription, no renewal.';

  @override
  String get rowOneCharacter => 'One character';

  @override
  String rowFromPrice(String price) {
    return '$price each';
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
  String get rowProRunsUntil => 'Premium runs until';

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
      'The yearly plan works out cheaper than paying monthly.';

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
      'Premium keeps running unless you cancel. Here is what happens.';

  @override
  String get rowTrialEnds => 'Trial ends';

  @override
  String get rowFirstCharge => 'First charge';

  @override
  String get rowThenMonthly => 'Then monthly';

  @override
  String get ctaCancelInStore => 'Cancel in the store';

  @override
  String get ovTrialStartTitle => '7 days of Premium, free';

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
      'Good call. The same Premium costs less if you pay yearly.';

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
  String get ovAlreadyTitle => 'You\'re already on Premium';

  @override
  String get ovAlreadyBody =>
      'This store account has an active plan. There\'s nothing to buy.';

  @override
  String get ctaSeeMySubscription => 'See my subscription';

  @override
  String get subCancelTitle => 'Cancel subscription';

  @override
  String subCancelBody(String date) {
    return 'Premium runs until $date. After that you move to Free.';
  }

  @override
  String get subWhatYouLose => 'What you lose';

  @override
  String get benefitScoring => 'Pronunciation scored letter by letter';

  @override
  String get benefitEveryMetric => 'Every metric, every sentence';

  @override
  String get subPaymentTitle => 'Update payment';

  @override
  String get subPaymentBody =>
      'We could not take the payment. Premium keeps running during the grace period.';

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
    return 'Premium ends on $date. Turn auto-renew back on and nothing changes.';
  }

  @override
  String get subWhatYouKeep => 'What you keep';

  @override
  String get ctaTurnItBackOn => 'Turn it back on';

  @override
  String get flTodayTitle => 'You\'ve used today\'s call time';

  @override
  String get flTodayBody => 'Pick up where you left off — right now.';

  @override
  String get flCheckTitle => 'That\'s today\'s check';

  @override
  String get flCheckBody =>
      'Free includes one check a day. Premium gives you the full analysis.';

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
  String get paywallGuardTitle => 'You can keep using Free';

  @override
  String get paywallGuardBody => 'You still get 5 minutes of calls a day.';

  @override
  String get ctaMaybeLater => 'Maybe later';

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
  String get playAgain => 'Play Again';

  @override
  String get difficultySlow => 'Easy';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Hard';

  @override
  String get difficultyLabel => 'Choose a difficulty';

  @override
  String get connected => 'Connected';

  @override
  String get unlockedWithMax => 'Included with your plan';

  @override
  String get fcEndedTitle => 'Your free call has ended';

  @override
  String get fcEndedBody =>
      'Free calls last up to 5 minutes\nSubscribe to keep talking for longer';

  @override
  String get ctaSubscribeKeepTalking => 'Subscribe and keep talking';

  @override
  String get kgTitle => 'Keep going?';

  @override
  String get kgBody =>
      'Calls continue in short stretches.\nWe\'ll check in again each time.';

  @override
  String get pcEndedTitleToday => 'Let\'s wrap up for today.';

  @override
  String get pcEndedBodyToday =>
      'Review what we talked about, and call me again tomorrow!';

  @override
  String get pcEndedTitle => 'Let\'s wrap up this call.';

  @override
  String get pcEndedBody => 'Review what we talked about, and call me again!';

  @override
  String get ctaKeepTalking => 'Keep talking';

  @override
  String get callModeSheetTitle => 'How do you want to talk?';

  @override
  String get callModeSheetSubtitle => 'Applies to this call right away';

  @override
  String get callModeFreeTalk => 'Free talk';

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
  String get callExitSubtitle =>
      'Time you\'ve talked so far still counts toward today';

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

  @override
  String get callFreeEndedTitle => 'Your free call has ended';

  @override
  String get callFreeEndedCta => 'Subscribe and keep talking';

  @override
  String get callKeepGoingTitle => 'Keep going?';

  @override
  String get callKeepGoingSubtitle =>
      'Calls continue in 5-minute stretches. We\'ll check in again each time.';

  @override
  String get articulationSelectedWord => 'Selected word';

  @override
  String get articulationYouSaid => 'You said';

  @override
  String get articulationTargetSound => 'Target';

  @override
  String get reportEntry => 'Report';

  @override
  String get reportTitle => 'Report';

  @override
  String get reportPrompt => 'What was the problem?';

  @override
  String get reportGuide =>
      'Tell us what the AI character said that made you uncomfortable. We review every report.';

  @override
  String get reportReasonSexual => 'Sexual content';

  @override
  String get reportReasonHate => 'Hate or discrimination';

  @override
  String get reportReasonViolence => 'Violent or threatening content';

  @override
  String get reportReasonSelfHarm => 'Encourages self-harm';

  @override
  String get reportReasonMisinfo => 'False information';

  @override
  String get reportReasonOther => 'Something else';

  @override
  String get reportDetailHint => 'Describe what happened (optional)';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String get reportDoneTitle => 'Your report has been received';

  @override
  String get reportDoneBody =>
      'We\'ll review it and take action if needed. Thank you for helping keep BeaverTalk safe.';

  @override
  String get reportFailed => 'Couldn\'t submit your report. Please try again.';

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
  String get hwConversationOnce =>
      'You can do the conversation once per homework.';

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

  @override
  String get hwBadgeClosed => 'Closed';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$passed of $total sentences passed';
  }

  @override
  String get challengeFirstWord => 'First word';

  @override
  String get challengeSeeAnalysis => 'See results';

  @override
  String get challengePaused => 'Paused';

  @override
  String get challengePausedNote => 'The timer and the recording both stopped.';

  @override
  String get challengeTimeLeft => 'Time left';

  @override
  String get challengeScoreLabel => 'Score';

  @override
  String get challengeResume => 'Resume';

  @override
  String get challengeBlockedTitle => 'Can\'t use the camera';

  @override
  String get challengeBlockedNote =>
      'Turn on camera and mic access in Settings.';

  @override
  String get challengeGoBack => 'Go back';

  @override
  String get challengeOpenSettings => 'Open Settings';

  @override
  String get saveDone => 'Saved to your gallery';

  @override
  String get saveFailed => 'Couldn\'t save';

  @override
  String get saveDeniedNote => 'Photo access is required';

  @override
  String get callIncomingCallerFallback => 'Beaver Tutor';

  @override
  String get callIncomingHandle => 'Korean call';

  @override
  String get callMissedTitle => 'Missed call';

  @override
  String get callMissedChannelDescription =>
      'Tells you when you miss a call from Beaver.';

  @override
  String callMissedBody(String name) {
    return '$name tried to call you';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Notification access is needed to receive calls.';

  @override
  String get callNotifPermissionRequired =>
      'Please allow notifications in Settings.';

  @override
  String get callHintLockedTitle => 'Hints aren\'t available in Study';

  @override
  String get wsTitle => 'Weak sounds';

  @override
  String get wsToList => 'Back to list';

  @override
  String get wsNext => 'Next';

  @override
  String get wsRetry => 'Try again';

  @override
  String get wsDone => 'Done';

  @override
  String get wsContinue => 'Keep going';

  @override
  String get wsQuit => 'Leave';

  @override
  String get wsRetryLater => 'Please try again in a moment.';

  @override
  String get wsMissingTitle => 'We couldn\'t find that sound';

  @override
  String get wsMissingBody => 'Please choose it from the list again.';

  @override
  String get wsListLoadFailed => 'Couldn\'t load the list';

  @override
  String get wsLessonLoadFailed => 'Couldn\'t load the lesson';

  @override
  String get wsNationalTitle => 'Weak sounds for your accent';

  @override
  String get wsNationalPending =>
      'We\'ll fill this in once your accent is analyzed';

  @override
  String get wsNationalPicked => 'Chosen from your accent analysis';

  @override
  String get wsNationalEmptyBody =>
      'Make a few more calls and we\'ll analyze your accent.';

  @override
  String get wsMineTitle => 'My weak sounds';

  @override
  String get wsMineSubtitle => 'Sounds you scored lowest on recently';

  @override
  String get wsMineEmptyBody =>
      'Call and review, and your weak sounds will build up.';

  @override
  String get wsNoDataYet => 'No data yet';

  @override
  String get wsGoToCall => 'Start a call';

  @override
  String get wsRule => 'Rule';

  @override
  String get wsRecommended => 'Recommended';

  @override
  String get wsNotMeasured => 'Not measured';

  @override
  String get wsStepUnderstand => 'Learn';

  @override
  String get wsStepWords => 'Words';

  @override
  String get wsStepSentence => 'Sentence';

  @override
  String get wsStepTest => 'Test';

  @override
  String get wsQuitTitle => 'Stop practicing?';

  @override
  String get wsQuitBody => 'If you leave now, this practice won\'t be saved.';

  @override
  String get wsHowToSound => 'How to make the sound';

  @override
  String get wsPracticeWords => 'Practice words';

  @override
  String get wsPracticeSentence => 'Practice the sentence';

  @override
  String get wsPracticeAgain => 'One more time';

  @override
  String get wsStartTest => 'Take the final test';

  @override
  String get wsThisSentence => 'This sentence';

  @override
  String get wsNoScoreNote => 'This step isn\'t scored. Just say it along.';

  @override
  String get wsListen => 'Listen carefully';

  @override
  String get wsSayNow => 'Now say it';

  @override
  String get wsPracticeDone => 'Practice complete';

  @override
  String get wsPaused => 'Paused';

  @override
  String get wsAudioFailed =>
      'Couldn\'t load the audio. Read it aloud from the text.';

  @override
  String get wsReadAloud => 'Read the sentence below aloud';

  @override
  String get wsTapToStart => 'Tap to start';

  @override
  String get wsTapWhenDone => 'Tap when you\'re done';

  @override
  String get wsScoring => 'Scoring';

  @override
  String get wsMicFailed => 'Couldn\'t open the microphone.';

  @override
  String get wsMicPermissionBody =>
      'This test is read aloud, so it needs the microphone. Turn on microphone access in Settings.';

  @override
  String get wsNoSound => 'We didn\'t hear anything. Try again?';

  @override
  String get wsScoreFailed => 'Scoring failed. Please try again.';

  @override
  String get wsSomethingWrong => 'Something went wrong.';

  @override
  String get wsLearnDone => 'Lesson complete';

  @override
  String get wsRetest => 'Test again';

  @override
  String get wsFirstMeasure => 'First measurement';

  @override
  String get wsFinalTest => 'Final test';

  @override
  String wsPoints(int score) {
    return '$score pts';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Before $score pts';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Goal $score pts';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Goal · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country accent';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'Repeated $count words';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'Repeated $count chunks';
  }

  @override
  String get wsStartRecommended => 'Start with the recommended sound';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Start with $label';
  }

  @override
  String get wsPointsUnit => 'pts';

  @override
  String get wsEnterFromMypage => 'Practice weak sounds';

  @override
  String wsGoalOnly(int score) {
    return 'Goal $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label sound';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Picture this shape when it comes up in a call.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return 'Sounds $country speakers often get wrong';
  }
}
