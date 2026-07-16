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
  /// **'Character'**
  String get callPartner;

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

  /// Default title of the country/language select bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Select a country'**
  String get selectACountry;

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

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'\$12.9 / mo'**
  String get pricePerMonth;

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
