import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_my.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kk'),
    Locale('km'),
    Locale('ko'),
    Locale('ky'),
    Locale('mn'),
    Locale('ms'),
    Locale('my'),
    Locale('ne'),
    Locale('pt'),
    Locale('ru'),
    Locale('si'),
    Locale('th'),
    Locale('tr'),
    Locale('ur'),
    Locale('uz'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'You need to sign in.'**
  String get loginRequired;

  /// No description provided for @callWebNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Voice calls aren\'t supported on the web. Please use the app.'**
  String get callWebNotSupported;

  /// No description provided for @micPermissionRequiredForCall.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is required. Allow the microphone to start a call.'**
  String get micPermissionRequiredForCall;

  /// No description provided for @callErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during the call.'**
  String get callErrorGeneric;

  /// No description provided for @callNetworkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred.'**
  String get callNetworkError;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is incorrect.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authEmailAlreadyRegistered;

  /// No description provided for @authConfirmEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete the verification sent to your email.'**
  String get authConfirmEmailRequired;

  /// No description provided for @authResetCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your email.'**
  String get authResetCodeSent;

  /// No description provided for @authResetCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect or has expired.'**
  String get authResetCodeInvalid;

  /// No description provided for @authPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset.'**
  String get authPasswordUpdated;

  /// No description provided for @authAppleTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your Apple sign-in token.'**
  String get authAppleTokenMissing;

  /// Sub-label on the call-finished screen showing the elapsed call time.
  ///
  /// In en, this message translates to:
  /// **'Call ended {duration}'**
  String callEndedDuration(String duration);

  /// Heading asking the user to rate the call just ended.
  ///
  /// In en, this message translates to:
  /// **'How was your call?'**
  String get callRatingPrompt;

  /// Lowest call rating choice (thumbs-down).
  ///
  /// In en, this message translates to:
  /// **'Not great'**
  String get ratingBad;

  /// Middle call rating choice (single thumbs-up).
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get ratingOkay;

  /// Highest call rating choice (double thumbs-up).
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get goHome;

  /// No description provided for @viewAnalysis.
  ///
  /// In en, this message translates to:
  /// **'View Analysis'**
  String get viewAnalysis;

  /// No description provided for @loadingShort.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingShort;

  /// No description provided for @ratingSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating: {message}'**
  String ratingSubmitFailed(String message);

  /// No description provided for @callInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Call info not found, skipping analysis.'**
  String get callInfoNotFound;

  /// No description provided for @tabRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get tabRecords;

  /// No description provided for @tabArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tabArchive;

  /// No description provided for @callHistory.
  ///
  /// In en, this message translates to:
  /// **'Call History'**
  String get callHistory;

  /// No description provided for @conversationRecord.
  ///
  /// In en, this message translates to:
  /// **'Conversation record'**
  String get conversationRecord;

  /// No description provided for @noCallRecords.
  ///
  /// In en, this message translates to:
  /// **'No call records yet'**
  String get noCallRecords;

  /// No description provided for @noCallRecordsBody.
  ///
  /// In en, this message translates to:
  /// **'Once you finish your first call with AI,\nyour records will appear here.'**
  String get noCallRecordsBody;

  /// No description provided for @startCall.
  ///
  /// In en, this message translates to:
  /// **'Start a Call'**
  String get startCall;

  /// No description provided for @recordsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load records'**
  String get recordsLoadError;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get tryAgainLater;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// A duration formatted as minutes and seconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min {seconds} sec'**
  String durationMinSec(int minutes, int seconds);

  /// No description provided for @scheduleManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage schedule'**
  String get scheduleManagement;

  /// No description provided for @alarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarms;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add new schedule'**
  String get addSchedule;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get editSchedule;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @alarmsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load alarms'**
  String get alarmsLoadError;

  /// No description provided for @charactersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load characters'**
  String get charactersLoadError;

  /// No description provided for @noCharacters.
  ///
  /// In en, this message translates to:
  /// **'No characters available'**
  String get noCharacters;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @callPartner.
  ///
  /// In en, this message translates to:
  /// **'Call partner'**
  String get callPartner;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get quickStart;

  /// No description provided for @presetMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning routine'**
  String get presetMorning;

  /// No description provided for @presetMorningSub.
  ///
  /// In en, this message translates to:
  /// **'Weekdays 8:00'**
  String get presetMorningSub;

  /// No description provided for @presetEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening wind-down'**
  String get presetEvening;

  /// No description provided for @presetEveningSub.
  ///
  /// In en, this message translates to:
  /// **'Every day 21:00'**
  String get presetEveningSub;

  /// No description provided for @presetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get presetCustom;

  /// No description provided for @presetCustomSub.
  ///
  /// In en, this message translates to:
  /// **'Your own'**
  String get presetCustomSub;

  /// Summary under the alarm form. monthly = count × 4.
  ///
  /// In en, this message translates to:
  /// **'{count}× a week · {monthly} calls a month'**
  String alarmSummary(int count, int monthly);

  /// No description provided for @alarmSummaryNone.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one day'**
  String get alarmSummaryNone;

  /// No description provided for @partnerInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get partnerInUse;

  /// No description provided for @partnerOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get partnerOwned;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversation;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @pronunciationChallenge.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Challenge'**
  String get pronunciationChallenge;

  /// No description provided for @newExpressions.
  ///
  /// In en, this message translates to:
  /// **'New Expressions'**
  String get newExpressions;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @noNewExpressions.
  ///
  /// In en, this message translates to:
  /// **'No new expressions from this conversation.'**
  String get noNewExpressions;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @recentScore.
  ///
  /// In en, this message translates to:
  /// **'Recent score {score}%'**
  String recentScore(int score);

  /// Which call this is with the same partner, shown in the analysis meta line.
  ///
  /// In en, this message translates to:
  /// **'Call #{count}'**
  String callSequence(int count);

  /// Section title for the partner's post-call remark.
  ///
  /// In en, this message translates to:
  /// **'A word from {name}'**
  String characterNoteTitle(String name);

  /// No description provided for @characterNoteFooter.
  ///
  /// In en, this message translates to:
  /// **'Left by {name} right after the call'**
  String characterNoteFooter(String name);

  /// No description provided for @newExpressionsCount.
  ///
  /// In en, this message translates to:
  /// **'New expressions {count}'**
  String newExpressionsCount(int count);

  /// No description provided for @analysisLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the analysis result.'**
  String get analysisLoadError;

  /// No description provided for @standardAudioNotReady.
  ///
  /// In en, this message translates to:
  /// **'Standard pronunciation audio isn\'t ready yet.'**
  String get standardAudioNotReady;

  /// No description provided for @standardAudioPlayError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play the standard pronunciation audio.'**
  String get standardAudioPlayError;

  /// Default title of the language-select bottom sheet shown over the login screen. Asks for the user's native language, not a country.
  ///
  /// In en, this message translates to:
  /// **'Select your native language'**
  String get selectNativeLanguage;

  /// Title of the language select sheet opened from My Page.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectYourLanguage;

  /// Confirm button in the country/language select bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow permissions\nfor a smooth experience'**
  String get permissionTitle;

  /// No description provided for @permissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required permissions are essential to use the service.'**
  String get permissionSubtitle;

  /// No description provided for @permissionMicTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone (required)'**
  String get permissionMicTitle;

  /// No description provided for @permissionMicDesc.
  ///
  /// In en, this message translates to:
  /// **'Needed to talk with the AI in English.'**
  String get permissionMicDesc;

  /// No description provided for @permissionNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications (optional)'**
  String get permissionNotifTitle;

  /// No description provided for @permissionNotifDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send learning reminders and call schedules.'**
  String get permissionNotifDesc;

  /// No description provided for @micPermissionNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access needed'**
  String get micPermissionNeededTitle;

  /// No description provided for @micPermissionNeededBody.
  ///
  /// In en, this message translates to:
  /// **'To talk with the AI, you need to allow microphone access. Please enable it in Settings.'**
  String get micPermissionNeededBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @connectionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailedTitle;

  /// No description provided for @connectionFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Check your network connection\nand try again.'**
  String get connectionFailedBody;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @payMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get payMethodCard;

  /// No description provided for @payMethodKakao.
  ///
  /// In en, this message translates to:
  /// **'KakaoPay'**
  String get payMethodKakao;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Annoying Beaver Avatar'**
  String get productName;

  /// No description provided for @productTrait.
  ///
  /// In en, this message translates to:
  /// **'Premium character · Yours forever'**
  String get productTrait;

  /// No description provided for @amountItemPrice.
  ///
  /// In en, this message translates to:
  /// **'Item price'**
  String get amountItemPrice;

  /// No description provided for @amountDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get amountDiscount;

  /// No description provided for @amountTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get amountTotal;

  /// No description provided for @paymentCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment complete'**
  String get paymentCompleteTitle;

  /// No description provided for @paymentCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'The avatar has been added to your collection.'**
  String get paymentCompleteBody;

  /// No description provided for @viewCollection.
  ///
  /// In en, this message translates to:
  /// **'View Collection'**
  String get viewCollection;

  /// No description provided for @receiptItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get receiptItem;

  /// No description provided for @receiptAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receiptAmount;

  /// No description provided for @receiptMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get receiptMethod;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get receiptDate;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailedTitle;

  /// No description provided for @paymentFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Your payment couldn\'t be processed.\nPlease try again.'**
  String get paymentFailedBody;

  /// No description provided for @freeCallEndingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your free call is ending'**
  String get freeCallEndingTitle;

  /// No description provided for @freeCallEndingBody.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to talk with Beaver for longer.'**
  String get freeCallEndingBody;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @endCall.
  ///
  /// In en, this message translates to:
  /// **'End Call'**
  String get endCall;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'The call has ended.'**
  String get callEnded;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @connectingHint.
  ///
  /// In en, this message translates to:
  /// **'This usually takes less than 5 seconds'**
  String get connectingHint;

  /// No description provided for @callConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect the call.'**
  String get callConnectFailed;

  /// No description provided for @saveSentenceFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the sentence.'**
  String get saveSentenceFailed;

  /// No description provided for @recordStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start recording.'**
  String get recordStartFailed;

  /// No description provided for @recordTooShort.
  ///
  /// In en, this message translates to:
  /// **'That recording was too short. Please try again.'**
  String get recordTooShort;

  /// No description provided for @gradingFailed.
  ///
  /// In en, this message translates to:
  /// **'Scoring failed. Please try again.'**
  String get gradingFailed;

  /// No description provided for @listenStandard.
  ///
  /// In en, this message translates to:
  /// **'Listen to standard pronunciation'**
  String get listenStandard;

  /// No description provided for @saveSentence.
  ///
  /// In en, this message translates to:
  /// **'Save sentence'**
  String get saveSentence;

  /// No description provided for @unsaveSentence.
  ///
  /// In en, this message translates to:
  /// **'Remove saved sentence'**
  String get unsaveSentence;

  /// No description provided for @scoringPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Scoring your pronunciation…'**
  String get scoringPronunciation;

  /// Caption under the scan cursor while a recording is scored (proto/2_scan_start AnalyzingCaption 3627:9708).
  ///
  /// In en, this message translates to:
  /// **'Checking your pronunciation word by word'**
  String get analyzingByWord;

  /// Replaces analyzingByWord once scoring runs long (screen/learning_analysis__지연5s AnalyzingCaption 3745:27).
  ///
  /// In en, this message translates to:
  /// **'This is taking a little longer'**
  String get analyzingTakingLonger;

  /// Caption on the scan-failed screen when the request never reached the server (proto/E_failed AnalyzingCaption 3627:9847).
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get scanConnectionLost;

  /// No description provided for @noRecordingToPlay.
  ///
  /// In en, this message translates to:
  /// **'No recording to play.'**
  String get noRecordingToPlay;

  /// No description provided for @myRecordingPlayError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play your recording.'**
  String get myRecordingPlayError;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @endLearning.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endLearning;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get navCall;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @myPage.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myPage;

  /// No description provided for @languageSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your language.'**
  String get languageSaveFailed;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account.'**
  String get accountDeleteFailed;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get changeAvatar;

  /// No description provided for @avatarIntro.
  ///
  /// In en, this message translates to:
  /// **'Voice and difficulty vary by call partner.\nSome partners may require payment.'**
  String get avatarIntro;

  /// No description provided for @myPartnersOwned.
  ///
  /// In en, this message translates to:
  /// **'My Partners · {count} owned'**
  String myPartnersOwned(int count);

  /// No description provided for @limitedDiscount.
  ///
  /// In en, this message translates to:
  /// **'Limited-time discount'**
  String get limitedDiscount;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @inUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get inUse;

  /// No description provided for @owned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// No description provided for @noCharactersToShow.
  ///
  /// In en, this message translates to:
  /// **'No characters to show'**
  String get noCharactersToShow;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @noSavedSentences.
  ///
  /// In en, this message translates to:
  /// **'No saved sentences yet.\nBookmark sentences from your conversation records.'**
  String get noSavedSentences;

  /// No description provided for @noAlarms.
  ///
  /// In en, this message translates to:
  /// **'No alarms registered'**
  String get noAlarms;

  /// No description provided for @noAlarmsBody.
  ///
  /// In en, this message translates to:
  /// **'Add a learning reminder\nand you can build a consistent habit.'**
  String get noAlarmsBody;

  /// No description provided for @subscriptionManage.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get subscriptionManage;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @benefitsInUse.
  ///
  /// In en, this message translates to:
  /// **'Your benefits'**
  String get benefitsInUse;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment info'**
  String get paymentInfo;

  /// No description provided for @nextBillingDate.
  ///
  /// In en, this message translates to:
  /// **'Next billing date'**
  String get nextBillingDate;

  /// No description provided for @lostBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits you\'ll lose if you cancel'**
  String get lostBenefitsTitle;

  /// No description provided for @viewBillingHistory.
  ///
  /// In en, this message translates to:
  /// **'View Billing History'**
  String get viewBillingHistory;

  /// No description provided for @keepUsingPro.
  ///
  /// In en, this message translates to:
  /// **'Keep Using Pro'**
  String get keepUsingPro;

  /// No description provided for @proMembership.
  ///
  /// In en, this message translates to:
  /// **'Pro Membership'**
  String get proMembership;

  /// Subscription price line. {price} is the store-formatted, storefront-local price string (StoreKit displayPrice / Play formattedPrice) and already carries its own currency symbol - never prefix or append one in a translation.
  ///
  /// In en, this message translates to:
  /// **'{price} / mo'**
  String pricePerMonth(String price);

  /// No description provided for @benefitUnlimitedCalls.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls'**
  String get benefitUnlimitedCalls;

  /// No description provided for @benefitDetailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed pronunciation & grammar analysis'**
  String get benefitDetailedAnalysis;

  /// No description provided for @benefitAllCharacters.
  ///
  /// In en, this message translates to:
  /// **'Access to all characters'**
  String get benefitAllCharacters;

  /// No description provided for @benefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get benefitNoAds;

  /// No description provided for @playSampleVoice.
  ///
  /// In en, this message translates to:
  /// **'Play sample voice'**
  String get playSampleVoice;

  /// No description provided for @useThisAvatar.
  ///
  /// In en, this message translates to:
  /// **'Use This'**
  String get useThisAvatar;

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Challenge'**
  String get challengeTitle;

  /// No description provided for @challengeIntro.
  ///
  /// In en, this message translates to:
  /// **'Pronounce each card in the zone correctly in Korean to clear it.\nNo mic? You can also play by tapping the screen.'**
  String get challengeIntro;

  /// No description provided for @challengeStart.
  ///
  /// In en, this message translates to:
  /// **'Start Camera & Mic'**
  String get challengeStart;

  /// No description provided for @challengePermissionNote.
  ///
  /// In en, this message translates to:
  /// **'Front camera and mic access is required (optional).'**
  String get challengePermissionNote;

  /// No description provided for @challengeLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get challengeLoadingTitle;

  /// No description provided for @challengeLoadingNote.
  ///
  /// In en, this message translates to:
  /// **'Downloading the Korean speech model (~82MB) on first run.\nPlease wait a moment.'**
  String get challengeLoadingNote;

  /// No description provided for @challengeSttFallback.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition wasn\'t available, so you played with tap input.'**
  String get challengeSttFallback;

  /// No description provided for @reasonTravelTitle.
  ///
  /// In en, this message translates to:
  /// **'Speaking while traveling'**
  String get reasonTravelTitle;

  /// No description provided for @reasonTravelDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat confidently with locals'**
  String get reasonTravelDesc;

  /// No description provided for @reasonCareerTitle.
  ///
  /// In en, this message translates to:
  /// **'Work & career'**
  String get reasonCareerTitle;

  /// No description provided for @reasonCareerDesc.
  ///
  /// In en, this message translates to:
  /// **'Business conversation'**
  String get reasonCareerDesc;

  /// No description provided for @reasonExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Test prep'**
  String get reasonExamTitle;

  /// No description provided for @reasonExamDesc.
  ///
  /// In en, this message translates to:
  /// **'Prepare for speaking tests'**
  String get reasonExamDesc;

  /// No description provided for @reasonDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday conversation'**
  String get reasonDailyTitle;

  /// No description provided for @reasonDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'Expressions you use daily'**
  String get reasonDailyDesc;

  /// No description provided for @reasonFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Making foreign friends'**
  String get reasonFriendsTitle;

  /// No description provided for @reasonFriendsDesc.
  ///
  /// In en, this message translates to:
  /// **'Natural conversation'**
  String get reasonFriendsDesc;

  /// No description provided for @reasonBrainTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain stimulation'**
  String get reasonBrainTitle;

  /// No description provided for @reasonBrainDesc.
  ///
  /// In en, this message translates to:
  /// **'Boost memory & focus'**
  String get reasonBrainDesc;

  /// No description provided for @challengeRecordToggle.
  ///
  /// In en, this message translates to:
  /// **'Record this run'**
  String get challengeRecordToggle;

  /// No description provided for @challengeRecordHint.
  ///
  /// In en, this message translates to:
  /// **'Saves a video of your gameplay to share (silent).'**
  String get challengeRecordHint;

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSection;

  /// No description provided for @paymentSection.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentSection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @userLanguage.
  ///
  /// In en, this message translates to:
  /// **'User Language'**
  String get userLanguage;

  /// No description provided for @learningLanguage.
  ///
  /// In en, this message translates to:
  /// **'Learning Language'**
  String get learningLanguage;

  /// No description provided for @learningLanguageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get learningLanguageKorean;

  /// No description provided for @notificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationLabel;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and data and cannot be undone.'**
  String get deleteAccountBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @accentSoundsLike.
  ///
  /// In en, this message translates to:
  /// **'Your Korean accent sounds'**
  String get accentSoundsLike;

  /// No description provided for @hintLabel.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hintLabel;

  /// No description provided for @nextHint.
  ///
  /// In en, this message translates to:
  /// **'Next hint'**
  String get nextHint;

  /// No description provided for @translateLabel.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateLabel;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI tutor will remember your name.'**
  String get onboardingNameSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @nameHelper.
  ///
  /// In en, this message translates to:
  /// **'It doesn\'t have to be your real name — a nickname works too.'**
  String get nameHelper;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onboardingDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Beaver is waiting for your call'**
  String get onboardingDoneTitle;

  /// No description provided for @onboardingDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a call right now'**
  String get onboardingDoneSubtitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call now'**
  String get callNow;

  /// No description provided for @pronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get pronunciation;

  /// No description provided for @fluency.
  ///
  /// In en, this message translates to:
  /// **'Fluency'**
  String get fluency;

  /// No description provided for @rhythm.
  ///
  /// In en, this message translates to:
  /// **'Rhythm'**
  String get rhythm;

  /// No description provided for @analysisTimeout.
  ///
  /// In en, this message translates to:
  /// **'This is taking longer than expected. Please try again in a moment.'**
  String get analysisTimeout;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t analyze the conversation. Please try again.'**
  String get analysisFailed;

  /// No description provided for @analyzingConversation.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your conversation…'**
  String get analyzingConversation;

  /// No description provided for @analyzingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will only take a moment'**
  String get analyzingSubtitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @nativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get nativeLabel;

  /// No description provided for @meLabel.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meLabel;

  /// No description provided for @pronunciationPlayError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play the pronunciation audio.'**
  String get pronunciationPlayError;

  /// No description provided for @savedExpressionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved expressions.'**
  String get savedExpressionsLoadError;

  /// No description provided for @mySavedExpressions.
  ///
  /// In en, this message translates to:
  /// **'My Saved Expressions'**
  String get mySavedExpressions;

  /// No description provided for @avatarTraits.
  ///
  /// In en, this message translates to:
  /// **'Warm · Calm · Soft'**
  String get avatarTraits;

  /// No description provided for @priceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get priceFree;

  /// No description provided for @loginGoogleTokenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get a Google sign-in token.'**
  String get loginGoogleTokenError;

  /// No description provided for @loginGoogleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed.'**
  String get loginGoogleSignInFailed;

  /// No description provided for @loginAppleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in failed.'**
  String get loginAppleSignInFailed;

  /// No description provided for @loginFacebookSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Facebook sign-in failed.'**
  String get loginFacebookSignInFailed;

  /// No description provided for @loginKakaoSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Kakao sign-in failed.'**
  String get loginKakaoSignInFailed;

  /// No description provided for @loginContinueWithKakao.
  ///
  /// In en, this message translates to:
  /// **'Continue with Kakao'**
  String get loginContinueWithKakao;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginContinueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get loginContinueWithFacebook;

  /// No description provided for @loginContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginContinueWithApple;

  /// No description provided for @loginContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get loginContinueWithEmail;

  /// No description provided for @loginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOrDivider;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @loginTermsNoticePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get loginTermsNoticePrefix;

  /// No description provided for @loginTermsNoticeAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get loginTermsNoticeAnd;

  /// No description provided for @loginTermsNoticeSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get loginTermsNoticeSuffix;

  /// No description provided for @loginLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLogIn;

  /// No description provided for @fieldEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @fieldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPasswordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get loginRememberMe;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loginLoggingIn;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8–16 characters.'**
  String get passwordLengthError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @signupCheckInput.
  ///
  /// In en, this message translates to:
  /// **'Please check your input.'**
  String get signupCheckInput;

  /// No description provided for @fieldConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @signupSigningUp.
  ///
  /// In en, this message translates to:
  /// **'Signing up...'**
  String get signupSigningUp;

  /// No description provided for @signupHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signupHaveAccount;

  /// No description provided for @passwordMethodEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get passwordMethodEmailRequired;

  /// No description provided for @passwordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get passwordResetTitle;

  /// No description provided for @passwordMethodDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address where you\'d like to receive the password reset code.'**
  String get passwordMethodDescription;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressHint;

  /// No description provided for @passwordMethodSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get passwordMethodSending;

  /// No description provided for @passwordMethodSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get passwordMethodSendEmail;

  /// No description provided for @passwordCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get passwordCodeTitle;

  /// No description provided for @passwordCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a recovery code to your email. Enter it to continue.'**
  String get passwordCodeDescription;

  /// No description provided for @passwordCodeNoCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get passwordCodeNoCode;

  /// No description provided for @passwordCodeResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get passwordCodeResend;

  /// No description provided for @passwordCodeVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get passwordCodeVerifying;

  /// No description provided for @passwordNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get passwordNewTitle;

  /// No description provided for @passwordNewDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a new password for your account.'**
  String get passwordNewDescription;

  /// No description provided for @fieldNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPasswordLabel;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordHint;

  /// No description provided for @fieldConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get fieldConfirmNewPasswordLabel;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @passwordNewSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get passwordNewSubmitting;

  /// No description provided for @passwordNewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get passwordNewSubmit;

  /// No description provided for @passwordCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Password reset complete'**
  String get passwordCompleteTitle;

  /// No description provided for @passwordCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset. Log in with your new password to continue.'**
  String get passwordCompleteBody;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyTitle;

  /// No description provided for @passwordNewDescriptionEmail.
  ///
  /// In en, this message translates to:
  /// **'Set a new password for {email}.'**
  String passwordNewDescriptionEmail(String email);

  /// No description provided for @selectComplete.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get selectComplete;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your native language?'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you learning a language?'**
  String get onboardingReasonTitle;

  /// No description provided for @onboardingReasonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor your learning to your goals.'**
  String get onboardingReasonSubtitle;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLabel;

  /// No description provided for @payMethodApple.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get payMethodApple;

  /// Header of the summary card on the payment-history screen.
  ///
  /// In en, this message translates to:
  /// **'This month\'s payment'**
  String get thisMonthPayment;

  /// Payment-history filter chip: show every transaction.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Payment-history filter chip: subscription charges only.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get filterSubscription;

  /// Payment-history filter chip: character purchases only.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get filterCharacter;

  /// Payment-history row status: the charge went through.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Label of the most-recent-charge row in the subscription sheet's 결제 정보 section.
  ///
  /// In en, this message translates to:
  /// **'Last payment'**
  String get lastPayment;

  /// Note paragraph on the change-plan and cancel subscription sheets.
  ///
  /// In en, this message translates to:
  /// **'You can keep using Pro benefits until {date}, after which your plan switches to Free automatically.'**
  String subscriptionSwitchNote(String date);

  /// Free plan benefit line on the change-plan sheet.
  ///
  /// In en, this message translates to:
  /// **'1 call a day · 5 min limit'**
  String get freePlanCallLimit;

  /// Free plan benefit line on the change-plan sheet.
  ///
  /// In en, this message translates to:
  /// **'Basic characters included'**
  String get freePlanBasicCharacters;

  /// Section heading on the change-avatar screen listing characters the user does not own yet and can buy. Distinct from the sheet's 'Available' status chip.
  ///
  /// In en, this message translates to:
  /// **'Available to purchase'**
  String get availableForPurchase;

  /// Error state on the payment-history screen when GET /payments fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load payment history'**
  String get paymentsLoadError;

  /// Empty state on the payment-history screen.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPayments;

  /// Shown when the server reports has_more but load-more isn't wired.
  ///
  /// In en, this message translates to:
  /// **'Older payments aren\'t shown yet'**
  String get morePaymentsExist;

  /// Month-group heading for payments whose payment_date is null.
  ///
  /// In en, this message translates to:
  /// **'Undated'**
  String get undatedPayments;

  /// Row label when the server sends no description and the category is unknown.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabelFallback;

  /// Headline of the learning summary screen.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {total} sentences passed'**
  String learningPassed(int passed, int total);

  /// No description provided for @hardestSound.
  ///
  /// In en, this message translates to:
  /// **'Hardest sound today'**
  String get hardestSound;

  /// No description provided for @soundAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy by sound'**
  String get soundAccuracy;

  /// No description provided for @phonemeAttempts.
  ///
  /// In en, this message translates to:
  /// **'Per phoneme · {count} attempts'**
  String phonemeAttempts(int count);

  /// No description provided for @colSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get colSound;

  /// No description provided for @colAttempts.
  ///
  /// In en, this message translates to:
  /// **'Tries'**
  String get colAttempts;

  /// No description provided for @colCorrect.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get colCorrect;

  /// No description provided for @colAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get colAccuracy;

  /// No description provided for @sentenceResults.
  ///
  /// In en, this message translates to:
  /// **'Results by sentence'**
  String get sentenceResults;

  /// No description provided for @viewAllSentences.
  ///
  /// In en, this message translates to:
  /// **'See all {count}'**
  String viewAllSentences(int count);

  /// No description provided for @colSentence.
  ///
  /// In en, this message translates to:
  /// **'Sentence'**
  String get colSentence;

  /// No description provided for @colPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pron.'**
  String get colPronunciation;

  /// No description provided for @colFluency.
  ///
  /// In en, this message translates to:
  /// **'Flu.'**
  String get colFluency;

  /// No description provided for @colRhythm.
  ///
  /// In en, this message translates to:
  /// **'Rhy.'**
  String get colRhythm;

  /// No description provided for @recentSessions.
  ///
  /// In en, this message translates to:
  /// **'Last {count} sessions'**
  String recentSessions(int count);

  /// No description provided for @trendAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg {score}'**
  String trendAverage(int score);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @colDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get colDate;

  /// No description provided for @colSentences.
  ///
  /// In en, this message translates to:
  /// **'Sentences'**
  String get colSentences;

  /// No description provided for @colScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get colScore;

  /// No description provided for @colChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get colChange;

  /// The most recent row of the trend table.
  ///
  /// In en, this message translates to:
  /// **'{date} (today)'**
  String dateToday(String date);

  /// Title of the accent-breakdown card on my page.
  ///
  /// In en, this message translates to:
  /// **'Accent analysis'**
  String get accentAnalysis;

  /// Title of the overall-level card on my page.
  ///
  /// In en, this message translates to:
  /// **'Overall level'**
  String get overallLevel;

  /// Subtitle listing what the overall level covers.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary · Grammar · Expressions'**
  String get overallLevelSubtitle;

  /// Title of the pronunciation card on my page.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation analysis'**
  String get pronunciationAnalysis;

  /// Card subtitle: the figure is an average over the last 10 sessions.
  ///
  /// In en, this message translates to:
  /// **'Last 10 sessions avg.'**
  String get recentSessionsAverage;

  /// A proficiency stage, 1-13. Also used for the two ends of the level scale.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}'**
  String levelStage(int stage);

  /// Percentile rank, e.g. Top 45%.
  ///
  /// In en, this message translates to:
  /// **'Top {percent}%'**
  String topPercent(int percent);

  /// Caption under the percentile: the rank is across all learners.
  ///
  /// In en, this message translates to:
  /// **'Among all learners'**
  String get allLearnersBasis;

  /// Sentence under the level scale. The my-page card emphasises the '{percent}%' token in Label/Strong, so keep the number and the percent sign adjacent with no space.
  ///
  /// In en, this message translates to:
  /// **'You\'re ahead of {percent}% of all learners'**
  String aheadOfLearners(int percent);

  /// CTA on the level card - start the level-test call again.
  ///
  /// In en, this message translates to:
  /// **'Retake level test'**
  String get retakeLevelTest;

  /// CTA on the pronunciation card - open the latest call analysis.
  ///
  /// In en, this message translates to:
  /// **'Practice pronunciation'**
  String get practicePronunciation;

  /// No description provided for @priceChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Price changed'**
  String get priceChangedTitle;

  /// No description provided for @priceChangedBody.
  ///
  /// In en, this message translates to:
  /// **'This item is now {price}. Would you like to continue?'**
  String priceChangedBody(String price);

  /// Billing list group title - in-app rail rows (spec section 5). English copy is final; do not localize away from the confirmed wording.
  ///
  /// In en, this message translates to:
  /// **'Plan & purchases'**
  String get billingGroupPlanPurchases;

  /// Billing list group title - rows that leave the app for the store.
  ///
  /// In en, this message translates to:
  /// **'In the store'**
  String get billingGroupInTheStore;

  /// Billing slot 1 label on a paid plan.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get billingChangePlan;

  /// Billing slot 1 label on every non-paid state.
  ///
  /// In en, this message translates to:
  /// **'Compare all plans'**
  String get billingCompareAllPlans;

  /// Billing slot 2 - character one-off purchase (in-house PG rail).
  ///
  /// In en, this message translates to:
  /// **'Buy a character'**
  String get billingBuyACharacter;

  /// Billing slot 3.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get billingRestorePurchases;

  /// Billing slot 4.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get billingPaymentHistory;

  /// Billing slot 5 - deep link to the platform store. 'the store' is deliberately neutral; store names never appear in copy (work order section 1-3).
  ///
  /// In en, this message translates to:
  /// **'Manage in the store'**
  String get billingManageInTheStore;

  /// Billing slot 6 - external, refunds are delegated to the store.
  ///
  /// In en, this message translates to:
  /// **'Refund help'**
  String get billingRefundHelp;

  /// Billing slot 7 in every state but ENDING.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get billingCancelSubscription;

  /// Billing slot 7 on ENDING - the cancellation is reversible until expiry.
  ///
  /// In en, this message translates to:
  /// **'Resubscribe'**
  String get billingResubscribe;

  /// Status pill - Free plan in force.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get badgeCurrent;

  /// Status pill - inside the Max trial. Not 'Renewing' (spec section 16-4 fixed that defect).
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get badgeTrial;

  /// Status pill - paid plan with auto-renew on.
  ///
  /// In en, this message translates to:
  /// **'Renewing'**
  String get badgeRenewing;

  /// Status pill - renewal failed, store retrying (GRACE).
  ///
  /// In en, this message translates to:
  /// **'Past due'**
  String get badgePastDue;

  /// Status pill - account hold (ON_HOLD).
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get badgePaused;

  /// Status pill - cancelled, running out the paid term (ENDING).
  ///
  /// In en, this message translates to:
  /// **'Canceling'**
  String get badgeCanceling;

  /// GNB title of every manage-state screen (measured off 4514:4739 etc).
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// GNB title of the trial-expired notice screen (4514:5179).
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plansTitle;

  /// No description provided for @planFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// No description provided for @planPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get planPro;

  /// No description provided for @planMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get planMax;

  /// Plan-card title while inside the Max trial.
  ///
  /// In en, this message translates to:
  /// **'Max trial'**
  String get planMaxTrial;

  /// Plan-card subtitle on the Free state. Confirmed copy; do not reword.
  ///
  /// In en, this message translates to:
  /// **'\$0.00 — one call a day'**
  String get freePlanPriceLine;

  /// Plan-card subtitle for a monthly paid plan. 'per month' is mandated wording (spec 6-4 forbids 'a month').
  ///
  /// In en, this message translates to:
  /// **'{amount} per month'**
  String pricePerMonthLine(String amount);

  /// No description provided for @freeUntilDate.
  ///
  /// In en, this message translates to:
  /// **'Free until {date}'**
  String freeUntilDate(String date);

  /// No description provided for @todaysCalls.
  ///
  /// In en, this message translates to:
  /// **'Today\'s calls'**
  String get todaysCalls;

  /// No description provided for @callsUsedOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} used'**
  String callsUsedOfLimit(int used, int limit);

  /// No description provided for @firstPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'First payment'**
  String get firstPaymentLabel;

  /// No description provided for @nextPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get nextPaymentLabel;

  /// Grace plan-card row label. The date value is a server value (spec 11-3).
  ///
  /// In en, this message translates to:
  /// **'Retrying until'**
  String get retryingUntilLabel;

  /// No description provided for @pausedSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Paused since'**
  String get pausedSinceLabel;

  /// Ending plan-card row label; design shows 'Pro ends'.
  ///
  /// In en, this message translates to:
  /// **'{plan} ends'**
  String planEndsLabel(String plan);

  /// No description provided for @bannerGoUnlimitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Go unlimited with Pro'**
  String get bannerGoUnlimitedTitle;

  /// No description provided for @bannerGoUnlimitedSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls · 15 minutes each · {price} per month'**
  String bannerGoUnlimitedSub(String price);

  /// No description provided for @bannerMaxUpsellTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on video with Max'**
  String get bannerMaxUpsellTitle;

  /// No description provided for @bannerMaxUpsellSub.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face calls · {price} per month'**
  String bannerMaxUpsellSub(String price);

  /// No description provided for @bannerAnnualSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to annual'**
  String get bannerAnnualSwitchTitle;

  /// No description provided for @bannerAnnualSwitchSub.
  ///
  /// In en, this message translates to:
  /// **'{yearly} per year · {perMonth} per month'**
  String bannerAnnualSwitchSub(String yearly, String perMonth);

  /// No description provided for @bannerPaymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t take the payment'**
  String get bannerPaymentFailedTitle;

  /// No description provided for @bannerPaymentFailedSub.
  ///
  /// In en, this message translates to:
  /// **'Update payment in the store to keep Pro'**
  String get bannerPaymentFailedSub;

  /// No description provided for @bannerPausedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan is paused'**
  String get bannerPausedTitle;

  /// No description provided for @bannerPausedSub.
  ///
  /// In en, this message translates to:
  /// **'The payment never went through'**
  String get bannerPausedSub;

  /// No description provided for @noteRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed on another device? Restore brings it back on this one.'**
  String get noteRestoreHint;

  /// No description provided for @noteStoreHandled.
  ///
  /// In en, this message translates to:
  /// **'Payment method, plan changes, and cancellation are handled by the store.'**
  String get noteStoreHandled;

  /// No description provided for @noteFairUse.
  ///
  /// In en, this message translates to:
  /// **'Unlimited use is subject to our fair use policy.'**
  String get noteFairUse;

  /// No description provided for @noteTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Your trial ends {date}. Cancel in the store before then and nothing is charged.'**
  String noteTrialEnds(String date);

  /// No description provided for @noteGrace.
  ///
  /// In en, this message translates to:
  /// **'Benefits keep running through the grace period. Cancellation is never intercepted in the app.'**
  String get noteGrace;

  /// No description provided for @noteHold.
  ///
  /// In en, this message translates to:
  /// **'Pro is paused until the payment goes through. Your characters and progress are safe.'**
  String get noteHold;

  /// No description provided for @noteEnding.
  ///
  /// In en, this message translates to:
  /// **'Your plan is set to end. Benefits run until {date}, then you move to Free. You can resubscribe any time.'**
  String noteEnding(String date);

  /// No description provided for @trialExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Max trial ended'**
  String get trialExpiredTitle;

  /// No description provided for @trialExpiredSub.
  ///
  /// In en, this message translates to:
  /// **'You are on Free now'**
  String get trialExpiredSub;

  /// No description provided for @seePlans.
  ///
  /// In en, this message translates to:
  /// **'See plans'**
  String get seePlans;

  /// GNB title of plans_compare (4514:5226).
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlanTitle;

  /// No description provided for @badgeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get badgeRecommended;

  /// No description provided for @perMonthUnit.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonthUnit;

  /// No description provided for @planTaglinePro.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls. 15 minutes each.'**
  String get planTaglinePro;

  /// No description provided for @planTaglineMax.
  ///
  /// In en, this message translates to:
  /// **'Now you can see them.'**
  String get planTaglineMax;

  /// No description provided for @planTaglineFree.
  ///
  /// In en, this message translates to:
  /// **'One call a day. On the house.'**
  String get planTaglineFree;

  /// No description provided for @bulletProCalls.
  ///
  /// In en, this message translates to:
  /// **'Voice calls, as often as you want'**
  String get bulletProCalls;

  /// No description provided for @bulletProLength.
  ///
  /// In en, this message translates to:
  /// **'15 minutes a call'**
  String get bulletProLength;

  /// No description provided for @bulletProScoring.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation scored letter by letter'**
  String get bulletProScoring;

  /// No description provided for @bulletProCorrections.
  ///
  /// In en, this message translates to:
  /// **'Corrections aimed at your native language'**
  String get bulletProCorrections;

  /// No description provided for @bulletProBeaverCalls.
  ///
  /// In en, this message translates to:
  /// **'Beaver calls you first'**
  String get bulletProBeaverCalls;

  /// No description provided for @bulletMaxVideo.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face video calls'**
  String get bulletMaxVideo;

  /// No description provided for @bulletMaxEverything.
  ///
  /// In en, this message translates to:
  /// **'Everything in Pro'**
  String get bulletMaxEverything;

  /// No description provided for @bulletMaxCharacters.
  ///
  /// In en, this message translates to:
  /// **'Every character, unlimited'**
  String get bulletMaxCharacters;

  /// No description provided for @bulletMaxStudyBook.
  ///
  /// In en, this message translates to:
  /// **'A study book matched to where you are'**
  String get bulletMaxStudyBook;

  /// No description provided for @bulletMaxWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'A weekly report on how your sound is changing'**
  String get bulletMaxWeeklyReport;

  /// No description provided for @bulletFreeCall.
  ///
  /// In en, this message translates to:
  /// **'One 5-minute voice call a day'**
  String get bulletFreeCall;

  /// No description provided for @bulletFreeCheck.
  ///
  /// In en, this message translates to:
  /// **'One pronunciation check a day'**
  String get bulletFreeCheck;

  /// No description provided for @bulletFreeAccent.
  ///
  /// In en, this message translates to:
  /// **'Unlimited accent checks'**
  String get bulletFreeAccent;

  /// No description provided for @bulletFreeCharacter.
  ///
  /// In en, this message translates to:
  /// **'One character to start'**
  String get bulletFreeCharacter;

  /// No description provided for @ctaGoUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Go unlimited'**
  String get ctaGoUnlimited;

  /// No description provided for @ctaTurnOnVideo.
  ///
  /// In en, this message translates to:
  /// **'Turn on video'**
  String get ctaTurnOnVideo;

  /// No description provided for @noteCallLength.
  ///
  /// In en, this message translates to:
  /// **'Calls are 15 minutes each.'**
  String get noteCallLength;

  /// No description provided for @paywallProTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Korean friend'**
  String get paywallProTitle1;

  /// No description provided for @paywallProTitle2.
  ///
  /// In en, this message translates to:
  /// **'who\'s up at 3 a.m.'**
  String get paywallProTitle2;

  /// No description provided for @paywallProSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls. 15 minutes each. All year.'**
  String get paywallProSub;

  /// Hot-entry paywall headline - one line, no story (spec 8-1).
  ///
  /// In en, this message translates to:
  /// **'Pro removes the limit.'**
  String get paywallLimitHeadline;

  /// No description provided for @limitBannerCallTitle.
  ///
  /// In en, this message translates to:
  /// **'That was today\'s call'**
  String get limitBannerCallTitle;

  /// No description provided for @limitBannerCallSub.
  ///
  /// In en, this message translates to:
  /// **'Free gives you one call a day'**
  String get limitBannerCallSub;

  /// No description provided for @limitBannerCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'That was today\'s check'**
  String get limitBannerCheckTitle;

  /// No description provided for @limitBannerCheckSub.
  ///
  /// In en, this message translates to:
  /// **'Free gives you one check a day'**
  String get limitBannerCheckSub;

  /// No description provided for @bulletProCharactersForever.
  ///
  /// In en, this message translates to:
  /// **'Characters you buy stay yours forever'**
  String get bulletProCharactersForever;

  /// No description provided for @paywallMaxTitle.
  ///
  /// In en, this message translates to:
  /// **'Now you can see them.'**
  String get paywallMaxTitle;

  /// No description provided for @paywallMaxSub.
  ///
  /// In en, this message translates to:
  /// **'Video calls, every character, and a study book made for where you are.'**
  String get paywallMaxSub;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get planAnnual;

  /// No description provided for @proMonthlyPriceLine.
  ///
  /// In en, this message translates to:
  /// **'{price} per month'**
  String proMonthlyPriceLine(String price);

  /// No description provided for @proAnnualPriceLine.
  ///
  /// In en, this message translates to:
  /// **'{yearly} · {perMonth} per month'**
  String proAnnualPriceLine(String yearly, String perMonth);

  /// No description provided for @maxMonthlyPriceLine.
  ///
  /// In en, this message translates to:
  /// **'{price} per month'**
  String maxMonthlyPriceLine(String price);

  /// No description provided for @maxAnnualPriceLine.
  ///
  /// In en, this message translates to:
  /// **'{yearly} per year · {perMonth} per month'**
  String maxAnnualPriceLine(String yearly, String perMonth);

  /// No description provided for @ctaCaptionPro.
  ///
  /// In en, this message translates to:
  /// **'{price} per month · cancel anytime in the store'**
  String ctaCaptionPro(String price);

  /// No description provided for @ctaCaptionMax.
  ///
  /// In en, this message translates to:
  /// **'{price} per month · cancel anytime in the store'**
  String ctaCaptionMax(String price);

  /// No description provided for @ctaCaptionMaxTrial.
  ///
  /// In en, this message translates to:
  /// **'7 days free, then {price} per month · cancel anytime in the store'**
  String ctaCaptionMaxTrial(String price);

  /// No description provided for @ctaCaptionAutoRenew.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically until canceled.'**
  String get ctaCaptionAutoRenew;

  /// No description provided for @footerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get footerTerms;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get footerPrivacy;

  /// No description provided for @noteMaxCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters unlocked by Max are available while your subscription is active. Characters you bought stay yours.'**
  String get noteMaxCharacters;

  /// No description provided for @processingTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirming your purchase'**
  String get processingTitle;

  /// No description provided for @processingSub.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a few seconds.'**
  String get processingSub;

  /// No description provided for @successProTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Pro.'**
  String get successProTitle;

  /// No description provided for @successProSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls, starting right now.'**
  String get successProSub;

  /// No description provided for @successProBenefit1.
  ///
  /// In en, this message translates to:
  /// **'Call as often as you want — 15 minutes a call'**
  String get successProBenefit1;

  /// No description provided for @successProBenefit2.
  ///
  /// In en, this message translates to:
  /// **'Unlimited pronunciation checks'**
  String get successProBenefit2;

  /// No description provided for @successProBenefit3.
  ///
  /// In en, this message translates to:
  /// **'Every character, plus one-off purchases'**
  String get successProBenefit3;

  /// No description provided for @successMaxTitle.
  ///
  /// In en, this message translates to:
  /// **'You can see them now.'**
  String get successMaxTitle;

  /// No description provided for @successMaxSub.
  ///
  /// In en, this message translates to:
  /// **'Video calls are on. Tap the video button in any call.'**
  String get successMaxSub;

  /// No description provided for @successMaxBenefit1.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face video calls'**
  String get successMaxBenefit1;

  /// No description provided for @successMaxBenefit2.
  ///
  /// In en, this message translates to:
  /// **'Every character, unlimited and new ones first'**
  String get successMaxBenefit2;

  /// No description provided for @successMaxBenefit3.
  ///
  /// In en, this message translates to:
  /// **'A study book matched to where you are'**
  String get successMaxBenefit3;

  /// No description provided for @ctaStartACall.
  ///
  /// In en, this message translates to:
  /// **'Start a call'**
  String get ctaStartACall;

  /// No description provided for @ctaStartAVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Start a video call'**
  String get ctaStartAVideoCall;

  /// No description provided for @ctaSeeYourSubscription.
  ///
  /// In en, this message translates to:
  /// **'See your subscription'**
  String get ctaSeeYourSubscription;

  /// No description provided for @successProCaption.
  ///
  /// In en, this message translates to:
  /// **'{price} is charged monthly until you cancel. Manage or cancel anytime in the store.'**
  String successProCaption(String price);

  /// No description provided for @successMaxCaption.
  ///
  /// In en, this message translates to:
  /// **'{price} is charged monthly until you cancel. Manage or cancel anytime in the store.'**
  String successMaxCaption(String price);

  /// No description provided for @plansErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the plans'**
  String get plansErrorTitle;

  /// No description provided for @plansErrorSub.
  ///
  /// In en, this message translates to:
  /// **'The store didn\'t answer.'**
  String get plansErrorSub;

  /// No description provided for @ctaTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get ctaTryAgain;

  /// No description provided for @plansErrorCaption.
  ///
  /// In en, this message translates to:
  /// **'Nothing was charged.'**
  String get plansErrorCaption;

  /// No description provided for @changePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlanTitle;

  /// No description provided for @moveToMaxTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to Max'**
  String get moveToMaxTitle;

  /// No description provided for @maxPriceShort.
  ///
  /// In en, this message translates to:
  /// **'{price} / mo'**
  String maxPriceShort(String price);

  /// No description provided for @moveToMaxCardSub.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face video calls · every character · a study book made for you'**
  String get moveToMaxCardSub;

  /// No description provided for @whatHappensNow.
  ///
  /// In en, this message translates to:
  /// **'What happens now'**
  String get whatHappensNow;

  /// No description provided for @maxStartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Max starts'**
  String get maxStartsLabel;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @unusedProTime.
  ///
  /// In en, this message translates to:
  /// **'Unused Pro time'**
  String get unusedProTime;

  /// No description provided for @creditedTowardMax.
  ///
  /// In en, this message translates to:
  /// **'Credited toward Max'**
  String get creditedTowardMax;

  /// No description provided for @nextPaymentMaxValue.
  ///
  /// In en, this message translates to:
  /// **'{price} · {date}'**
  String nextPaymentMaxValue(String price, String date);

  /// No description provided for @nextPaymentProValue.
  ///
  /// In en, this message translates to:
  /// **'{price} · {date}'**
  String nextPaymentProValue(String price, String date);

  /// No description provided for @ctaSwitchToMax.
  ///
  /// In en, this message translates to:
  /// **'Switch to Max'**
  String get ctaSwitchToMax;

  /// No description provided for @upgradeCaption.
  ///
  /// In en, this message translates to:
  /// **'Your new plan starts right away. Unused Pro time is credited, never charged twice.'**
  String get upgradeCaption;

  /// No description provided for @moveToProTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to Pro'**
  String get moveToProTitle;

  /// No description provided for @moveToProSub.
  ///
  /// In en, this message translates to:
  /// **'Nothing changes today. Max runs to the end of the month you already paid for.'**
  String get moveToProSub;

  /// No description provided for @maxRunsUntil.
  ///
  /// In en, this message translates to:
  /// **'Max runs until'**
  String get maxRunsUntil;

  /// No description provided for @proStarts.
  ///
  /// In en, this message translates to:
  /// **'Pro starts'**
  String get proStarts;

  /// No description provided for @whatYouKeep.
  ///
  /// In en, this message translates to:
  /// **'What you keep'**
  String get whatYouKeep;

  /// No description provided for @keepBenefitCalls.
  ///
  /// In en, this message translates to:
  /// **'Unlimited voice calls, 15 minutes each'**
  String get keepBenefitCalls;

  /// No description provided for @keepBenefitCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters you bought stay yours forever'**
  String get keepBenefitCharacters;

  /// No description provided for @downgradeWarning.
  ///
  /// In en, this message translates to:
  /// **'Video calls and Max-only characters turn off on {date}.'**
  String downgradeWarning(String date);

  /// No description provided for @ctaSwitchToPro.
  ///
  /// In en, this message translates to:
  /// **'Switch to Pro'**
  String get ctaSwitchToPro;

  /// No description provided for @ctaKeepMax.
  ///
  /// In en, this message translates to:
  /// **'Keep Max'**
  String get ctaKeepMax;

  /// No description provided for @winbackSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get winbackSkip;

  /// No description provided for @winbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Pro plan ended'**
  String get winbackTitle;

  /// No description provided for @winbackSub.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Free now — one call a day.'**
  String get winbackSub;

  /// No description provided for @winbackQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mind telling us why you left?'**
  String get winbackQuestion;

  /// No description provided for @winbackReasonExpensive.
  ///
  /// In en, this message translates to:
  /// **'Too expensive'**
  String get winbackReasonExpensive;

  /// No description provided for @winbackReasonUnused.
  ///
  /// In en, this message translates to:
  /// **'I wasn\'t using it enough'**
  String get winbackReasonUnused;

  /// No description provided for @winbackReasonMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing a feature I needed'**
  String get winbackReasonMissing;

  /// No description provided for @winbackReasonOtherApp.
  ///
  /// In en, this message translates to:
  /// **'I found another app'**
  String get winbackReasonOtherApp;

  /// No description provided for @winbackReasonElse.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get winbackReasonElse;

  /// No description provided for @ctaSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get ctaSend;

  /// No description provided for @ctaNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get ctaNotNow;

  /// No description provided for @winbackCaption.
  ///
  /// In en, this message translates to:
  /// **'This doesn\'t restore your plan. Resubscribe in the store.'**
  String get winbackCaption;

  /// No description provided for @ctaContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ctaContinue;

  /// No description provided for @ctaClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get ctaClose;

  /// No description provided for @ovRestoreSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro is back'**
  String get ovRestoreSuccessTitle;

  /// No description provided for @ovRestoreSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'We found your subscription and turned it back on for this device.'**
  String get ovRestoreSuccessBody;

  /// No description provided for @ovRestoreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore'**
  String get ovRestoreEmptyTitle;

  /// No description provided for @ovRestoreEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No active subscription is linked to this store account.'**
  String get ovRestoreEmptyBody;

  /// No description provided for @ovRestoreOtherTitle.
  ///
  /// In en, this message translates to:
  /// **'That plan belongs to another account'**
  String get ovRestoreOtherTitle;

  /// No description provided for @ovRestoreOtherBody.
  ///
  /// In en, this message translates to:
  /// **'This subscription is already active on a different BeaverTalk account.'**
  String get ovRestoreOtherBody;

  /// No description provided for @ctaSignInThatAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to that account'**
  String get ctaSignInThatAccount;

  /// No description provided for @ctaGetHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get ctaGetHelp;

  /// No description provided for @ovCharacterOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Not ready for Pro?'**
  String get ovCharacterOfferTitle;

  /// No description provided for @ovCharacterOfferBody.
  ///
  /// In en, this message translates to:
  /// **'Pick one character and keep them. A one-off purchase — no subscription, no renewal.'**
  String get ovCharacterOfferBody;

  /// No description provided for @rowOneCharacter.
  ///
  /// In en, this message translates to:
  /// **'One character'**
  String get rowOneCharacter;

  /// No description provided for @rowFromPrice.
  ///
  /// In en, this message translates to:
  /// **'from {price}'**
  String rowFromPrice(String price);

  /// No description provided for @rowYoursForever.
  ///
  /// In en, this message translates to:
  /// **'Yours forever'**
  String get rowYoursForever;

  /// No description provided for @rowNoRenewal.
  ///
  /// In en, this message translates to:
  /// **'No renewal'**
  String get rowNoRenewal;

  /// No description provided for @rowWorksOnFree.
  ///
  /// In en, this message translates to:
  /// **'Works on Free'**
  String get rowWorksOnFree;

  /// No description provided for @rowYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get rowYes;

  /// No description provided for @ctaSeeCharacters.
  ///
  /// In en, this message translates to:
  /// **'See characters'**
  String get ctaSeeCharacters;

  /// No description provided for @ovNotEligibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to cancel'**
  String get ovNotEligibleTitle;

  /// No description provided for @ovNotEligibleBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Free. There is no active subscription on this account.'**
  String get ovNotEligibleBody;

  /// No description provided for @ovCancelDownsellTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you go'**
  String get ovCancelDownsellTitle;

  /// No description provided for @ovCancelDownsellBody.
  ///
  /// In en, this message translates to:
  /// **'Canceling happens in the store. Two things worth knowing.'**
  String get ovCancelDownsellBody;

  /// No description provided for @rowPayYearlyInstead.
  ///
  /// In en, this message translates to:
  /// **'Pay yearly instead'**
  String get rowPayYearlyInstead;

  /// No description provided for @rowYearlyMonthEquiv.
  ///
  /// In en, this message translates to:
  /// **'{price} per month'**
  String rowYearlyMonthEquiv(String price);

  /// No description provided for @rowCharactersYouBought.
  ///
  /// In en, this message translates to:
  /// **'Characters you bought'**
  String get rowCharactersYouBought;

  /// No description provided for @rowProRunsUntil.
  ///
  /// In en, this message translates to:
  /// **'Pro runs until'**
  String get rowProRunsUntil;

  /// No description provided for @ctaSwitchToYearly.
  ///
  /// In en, this message translates to:
  /// **'Switch to yearly'**
  String get ctaSwitchToYearly;

  /// No description provided for @ctaContinueToStore.
  ///
  /// In en, this message translates to:
  /// **'Continue to the store'**
  String get ctaContinueToStore;

  /// No description provided for @ovAnnualSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay yearly, save {saved}'**
  String ovAnnualSwitchTitle(String saved);

  /// No description provided for @ovAnnualSwitchBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been on Pro for two months. The yearly plan works out cheaper.'**
  String get ovAnnualSwitchBody;

  /// No description provided for @rowYouSave.
  ///
  /// In en, this message translates to:
  /// **'You save'**
  String get rowYouSave;

  /// No description provided for @amountSaved.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String amountSaved(String price);

  /// No description provided for @rowYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get rowYearly;

  /// No description provided for @amountYearly.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String amountYearly(String price);

  /// No description provided for @rowMonthlyForYear.
  ///
  /// In en, this message translates to:
  /// **'Monthly, for a year'**
  String get rowMonthlyForYear;

  /// No description provided for @amountMonthlyForYear.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String amountMonthlyForYear(String price);

  /// No description provided for @ovMonthlySwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to monthly'**
  String get ovMonthlySwitchTitle;

  /// No description provided for @ovMonthlySwitchBody.
  ///
  /// In en, this message translates to:
  /// **'Your yearly plan runs until {date}. Monthly billing starts the day after.'**
  String ovMonthlySwitchBody(String date);

  /// No description provided for @rowMonthlyBillingStarts.
  ///
  /// In en, this message translates to:
  /// **'Monthly billing starts'**
  String get rowMonthlyBillingStarts;

  /// No description provided for @rowMonthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get rowMonthlyLabel;

  /// No description provided for @rowYearlyWorkedOut.
  ///
  /// In en, this message translates to:
  /// **'Yearly worked out at'**
  String get rowYearlyWorkedOut;

  /// No description provided for @ctaSwitchToMonthly.
  ///
  /// In en, this message translates to:
  /// **'Switch to monthly'**
  String get ctaSwitchToMonthly;

  /// No description provided for @ovRefundHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Refunds are handled by the store'**
  String get ovRefundHelpTitle;

  /// No description provided for @ovRefundHelpBody.
  ///
  /// In en, this message translates to:
  /// **'We cannot issue refunds ourselves. Every request is reviewed by the store.'**
  String get ovRefundHelpBody;

  /// No description provided for @ctaGoToStore.
  ///
  /// In en, this message translates to:
  /// **'Go to the store'**
  String get ctaGoToStore;

  /// No description provided for @ovTrialEndingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your trial ends tomorrow'**
  String get ovTrialEndingTitle;

  /// No description provided for @ovTrialEndingBody.
  ///
  /// In en, this message translates to:
  /// **'Max keeps running unless you cancel. Here is what happens.'**
  String get ovTrialEndingBody;

  /// No description provided for @rowTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends'**
  String get rowTrialEnds;

  /// No description provided for @rowFirstCharge.
  ///
  /// In en, this message translates to:
  /// **'First charge'**
  String get rowFirstCharge;

  /// No description provided for @rowThenMonthly.
  ///
  /// In en, this message translates to:
  /// **'Then monthly'**
  String get rowThenMonthly;

  /// No description provided for @ctaCancelInStore.
  ///
  /// In en, this message translates to:
  /// **'Cancel in the store'**
  String get ctaCancelInStore;

  /// No description provided for @ovTrialStartTitle.
  ///
  /// In en, this message translates to:
  /// **'7 days of Max, free'**
  String get ovTrialStartTitle;

  /// No description provided for @ovTrialStartBody.
  ///
  /// In en, this message translates to:
  /// **'Free until {date}. Then {price} per month, unless you cancel in the store.'**
  String ovTrialStartBody(String price, String date);

  /// No description provided for @ctaStart7Days.
  ///
  /// In en, this message translates to:
  /// **'Start 7 days free'**
  String get ctaStart7Days;

  /// No description provided for @ovOtoTitle.
  ///
  /// In en, this message translates to:
  /// **'One more thing before you start'**
  String get ovOtoTitle;

  /// No description provided for @ovOtoBody.
  ///
  /// In en, this message translates to:
  /// **'Good call — unlimited calls are on right now. The same Pro costs less if you pay yearly.'**
  String get ovOtoBody;

  /// No description provided for @ovFailedDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your card was declined'**
  String get ovFailedDeclinedTitle;

  /// No description provided for @ovFailedDeclinedBody.
  ///
  /// In en, this message translates to:
  /// **'The store couldn\'t take the payment. Nothing was charged.'**
  String get ovFailedDeclinedBody;

  /// No description provided for @ctaUpdatePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Update payment method'**
  String get ctaUpdatePaymentMethod;

  /// No description provided for @ovFailedCanceledTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment canceled'**
  String get ovFailedCanceledTitle;

  /// No description provided for @ovFailedCanceledBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re still on Free. Nothing was charged.'**
  String get ovFailedCanceledBody;

  /// No description provided for @ovFailedStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get ovFailedStoreTitle;

  /// No description provided for @ovFailedStoreBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach the store. Nothing was charged.'**
  String get ovFailedStoreBody;

  /// No description provided for @ovAlreadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re already on Pro'**
  String get ovAlreadyTitle;

  /// No description provided for @ovAlreadyBody.
  ///
  /// In en, this message translates to:
  /// **'This store account has an active plan. There\'s nothing to buy.'**
  String get ovAlreadyBody;

  /// No description provided for @ctaSeeMySubscription.
  ///
  /// In en, this message translates to:
  /// **'See my subscription'**
  String get ctaSeeMySubscription;

  /// No description provided for @subCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get subCancelTitle;

  /// No description provided for @subCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Pro runs until {date}. After that you move to Free.'**
  String subCancelBody(String date);

  /// No description provided for @subWhatYouLose.
  ///
  /// In en, this message translates to:
  /// **'What you lose'**
  String get subWhatYouLose;

  /// No description provided for @benefitCalls15.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls, 15 minutes each'**
  String get benefitCalls15;

  /// No description provided for @benefitScoring.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation scored letter by letter'**
  String get benefitScoring;

  /// No description provided for @benefitEveryCharacter.
  ///
  /// In en, this message translates to:
  /// **'Every character, unlimited'**
  String get benefitEveryCharacter;

  /// No description provided for @ctaKeepPro.
  ///
  /// In en, this message translates to:
  /// **'Keep Pro'**
  String get ctaKeepPro;

  /// No description provided for @subPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Update payment'**
  String get subPaymentTitle;

  /// No description provided for @subPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'We could not take the payment. Pro keeps running during the grace period.'**
  String get subPaymentBody;

  /// No description provided for @subHowToFix.
  ///
  /// In en, this message translates to:
  /// **'How to fix it'**
  String get subHowToFix;

  /// No description provided for @fixStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the store and update your payment method'**
  String get fixStep1;

  /// No description provided for @fixStep2.
  ///
  /// In en, this message translates to:
  /// **'Come back — your plan resumes automatically'**
  String get fixStep2;

  /// No description provided for @fixStep3.
  ///
  /// In en, this message translates to:
  /// **'Nothing is charged twice'**
  String get fixStep3;

  /// No description provided for @subResubTitle.
  ///
  /// In en, this message translates to:
  /// **'Resubscribe'**
  String get subResubTitle;

  /// No description provided for @subResubBody.
  ///
  /// In en, this message translates to:
  /// **'Pro ends on {date}. Turn auto-renew back on and nothing changes.'**
  String subResubBody(String date);

  /// No description provided for @subWhatYouKeep.
  ///
  /// In en, this message translates to:
  /// **'What you keep'**
  String get subWhatYouKeep;

  /// No description provided for @ctaTurnItBackOn.
  ///
  /// In en, this message translates to:
  /// **'Turn it back on'**
  String get ctaTurnItBackOn;

  /// free_limit call sheet. Source: pre-neutralization backup doc - reconfirm against Figma host section (04_tonghwa).
  ///
  /// In en, this message translates to:
  /// **'That\'s today\'s call'**
  String get flTodayTitle;

  /// No description provided for @flTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off — right now.'**
  String get flTodayBody;

  /// No description provided for @flCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s today\'s check'**
  String get flCheckTitle;

  /// No description provided for @flCheckBody.
  ///
  /// In en, this message translates to:
  /// **'One check a day on Free. Pro makes it unlimited.'**
  String get flCheckBody;

  /// No description provided for @flBenefitCalls.
  ///
  /// In en, this message translates to:
  /// **'Unlimited calls with Pro · 15 minutes each'**
  String get flBenefitCalls;

  /// No description provided for @flBenefitChecks.
  ///
  /// In en, this message translates to:
  /// **'Unlimited pronunciation checks with Pro'**
  String get flBenefitChecks;

  /// No description provided for @flCaption.
  ///
  /// In en, this message translates to:
  /// **'{price} per month · cancel anytime'**
  String flCaption(String price);

  /// No description provided for @flUsage.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} used'**
  String flUsage(String used, String limit);

  /// No description provided for @ctaMaybeTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Maybe tomorrow'**
  String get ctaMaybeTomorrow;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @loginMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Login Method'**
  String get loginMethodLabel;

  /// No description provided for @joinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joinedLabel;

  /// No description provided for @editNicknameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Nickname'**
  String get editNicknameTitle;

  /// No description provided for @nicknameRule.
  ///
  /// In en, this message translates to:
  /// **'2–12 characters. Letters and numbers. English Only'**
  String get nicknameRule;

  /// No description provided for @ctaSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get ctaSave;

  /// No description provided for @subscriptionRow.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionRow;

  /// Character IAP result sheet (4713:28243). Korean is the confirmed original; this is its translation.
  ///
  /// In en, this message translates to:
  /// **'Purchase complete'**
  String get iapSuccessTitle;

  /// No description provided for @iapSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'The {name} avatar is yours forever.\nApplied as soon as the receipt clears.'**
  String iapSuccessBody(String name);

  /// No description provided for @ctaGoHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get ctaGoHome;

  /// No description provided for @ctaUseNow.
  ///
  /// In en, this message translates to:
  /// **'Use it now'**
  String get ctaUseNow;

  /// No description provided for @iapFailTitle.
  ///
  /// In en, this message translates to:
  /// **'The payment didn\'t go through'**
  String get iapFailTitle;

  /// No description provided for @iapFailBody.
  ///
  /// In en, this message translates to:
  /// **'You can try again'**
  String get iapFailBody;

  /// No description provided for @paywallLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'If you leave now, you won\'t be subscribed'**
  String get paywallLeaveTitle;

  /// No description provided for @paywallLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'Your benefits unlock right after checkout. You can come back anytime from My Page.'**
  String get paywallLeaveBody;

  /// No description provided for @ctaKeepLooking.
  ///
  /// In en, this message translates to:
  /// **'Keep looking'**
  String get ctaKeepLooking;

  /// No description provided for @ctaLeaveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Leave anyway'**
  String get ctaLeaveAnyway;

  /// No description provided for @iapCharacterSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'A new friend joins you!'**
  String get iapCharacterSuccessTitle;

  /// No description provided for @iapCharacterSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'This character is yours forever - it stays even if your plan changes, and Restore purchases brings it back on any device.'**
  String get iapCharacterSuccessBody;

  /// No description provided for @iapCharacterFailedBody.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. Nothing was charged - please try again.'**
  String get iapCharacterFailedBody;

  /// Mypage accent card, empty state title.
  ///
  /// In en, this message translates to:
  /// **'No accent data yet'**
  String get noAccentDataTitle;

  /// Mypage accent card, empty state body.
  ///
  /// In en, this message translates to:
  /// **'Keep talking and your accent patterns will build up.'**
  String get noAccentDataBody;

  /// Mypage level card, empty state title.
  ///
  /// In en, this message translates to:
  /// **'No level yet'**
  String get noLevelYetTitle;

  /// Mypage level card, empty state body.
  ///
  /// In en, this message translates to:
  /// **'Finish your first call to get your level.'**
  String get noLevelYetBody;

  /// Mypage pronunciation card, empty state title.
  ///
  /// In en, this message translates to:
  /// **'No pronunciation records yet'**
  String get noPronunciationDataTitle;

  /// Mypage pronunciation card, empty state body.
  ///
  /// In en, this message translates to:
  /// **'We analyze your pronunciation from what you say on calls.'**
  String get noPronunciationDataBody;

  /// Analysis - the character left no remark for this call.
  ///
  /// In en, this message translates to:
  /// **'Nothing said yet'**
  String get noCharacterNote;

  /// Learning report - the per-sound table has no rows yet.
  ///
  /// In en, this message translates to:
  /// **'No sounds to analyze yet'**
  String get noPhonemesYet;

  /// Learning report - the per-sentence table has no rows yet.
  ///
  /// In en, this message translates to:
  /// **'No sentences to analyze yet'**
  String get noSentencesYet;

  /// CTA on the level card when the user has never taken the test.
  ///
  /// In en, this message translates to:
  /// **'Take level test'**
  String get takeLevelTest;

  /// Hint under the pronunciation gauge when there is no score yet.
  ///
  /// In en, this message translates to:
  /// **'Review to see your pronunciation score'**
  String get reviewToSeeScore;

  /// Pronunciation challenge - restart the run from the result screen.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Pronunciation challenge difficulty - slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get difficultySlow;

  /// Pronunciation challenge difficulty - normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get difficultyNormal;

  /// Pronunciation challenge difficulty - fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get difficultyFast;

  /// Pronunciation challenge - label above the difficulty toggle.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyLabel;

  /// Call header status - the call is live. Sibling of `connecting`.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Characters unlocked by the member's Max subscription but NOT bought. Used twice: the section heading on the change-avatar screen, and the status chip on the avatar detail screen. Must never read as ownership - the access ends when the subscription does.
  ///
  /// In en, this message translates to:
  /// **'Available with Max'**
  String get unlockedWithMax;

  /// Mode sheet - heading. Asks how the learner wants to talk in this call.
  ///
  /// In en, this message translates to:
  /// **'How do you want to talk?'**
  String get callModeSheetTitle;

  /// Mode sheet - subheading. The choice applies to the current call immediately.
  ///
  /// In en, this message translates to:
  /// **'Applies to this call right away'**
  String get callModeSheetSubtitle;

  /// Mode sheet - the Free Talk mode name (streaming conversation, no corrections).
  ///
  /// In en, this message translates to:
  /// **'Free Talk'**
  String get callModeFreeTalk;

  /// Mode sheet - one-line description of Free Talk.
  ///
  /// In en, this message translates to:
  /// **'Just talk — no corrections'**
  String get callModeFreeTalkDesc;

  /// Mode sheet - the Study mode name (turn-based expression drill).
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get callModeStudy;

  /// Mode sheet - one-line description of Study.
  ///
  /// In en, this message translates to:
  /// **'Learn one expression at a time'**
  String get callModeStudyDesc;

  /// Mode sheet - confirm button, and the label of the call header button that opens the sheet.
  ///
  /// In en, this message translates to:
  /// **'Change mode'**
  String get callModeChange;

  /// Mode sheet - dismiss button. Closes without changing the mode.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get callModeKeep;

  /// End-call dialog - heading.
  ///
  /// In en, this message translates to:
  /// **'End this call?'**
  String get callExitTitle;

  /// End-call dialog - body. Warns the call is still counted against the daily quota.
  ///
  /// In en, this message translates to:
  /// **'Ending now still uses one of your calls'**
  String get callExitSubtitle;

  /// End-call dialog - stay in the call.
  ///
  /// In en, this message translates to:
  /// **'Keep talking'**
  String get callExitKeep;

  /// End-call dialog - confirm hanging up.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get callExitConfirm;

  /// Live call - accessibility label for the mic button when the mic is open.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get callMicMute;

  /// Live call - accessibility label for the mic button when muted.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get callMicUnmute;

  /// Study call - accessibility label for the hold-to-talk button.
  ///
  /// In en, this message translates to:
  /// **'Hold to talk'**
  String get callPushToTalk;

  /// Five-minute sheet (free) - heading when the free call time is used up.
  ///
  /// In en, this message translates to:
  /// **'Your free call has ended'**
  String get callFreeEndedTitle;

  /// Five-minute sheet (free) - primary action, opens the paywall.
  ///
  /// In en, this message translates to:
  /// **'Subscribe and keep talking'**
  String get callFreeEndedCta;

  /// Five-minute sheet (paid) - heading of the continue check-in.
  ///
  /// In en, this message translates to:
  /// **'Keep going?'**
  String get callKeepGoingTitle;

  /// Five-minute sheet (paid) - body explaining calls run in 5-minute stretches.
  ///
  /// In en, this message translates to:
  /// **'Calls continue in 5-minute stretches. We\'ll check in again each time.'**
  String get callKeepGoingSubtitle;

  /// No description provided for @articulationSelectedWord.
  ///
  /// In en, this message translates to:
  /// **'Selected word'**
  String get articulationSelectedWord;

  /// No description provided for @articulationYouSaid.
  ///
  /// In en, this message translates to:
  /// **'You said'**
  String get articulationYouSaid;

  /// No description provided for @articulationTargetSound.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get articulationTargetSound;

  /// No description provided for @articulationListenNative.
  ///
  /// In en, this message translates to:
  /// **'Listen to a native speaker'**
  String get articulationListenNative;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fi',
    'fil',
    'fr',
    'hi',
    'hu',
    'id',
    'it',
    'ja',
    'kk',
    'km',
    'ko',
    'ky',
    'mn',
    'ms',
    'my',
    'ne',
    'pt',
    'ru',
    'si',
    'th',
    'tr',
    'ur',
    'uz',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'ko':
      return AppLocalizationsKo();
    case 'ky':
      return AppLocalizationsKy();
    case 'mn':
      return AppLocalizationsMn();
    case 'ms':
      return AppLocalizationsMs();
    case 'my':
      return AppLocalizationsMy();
    case 'ne':
      return AppLocalizationsNe();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
