import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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
  /// **'Schedule'**
  String get scheduleManagement;

  /// No description provided for @alarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarms;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
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
  /// **'No alarms yet'**
  String get noAlarms;

  /// No description provided for @noAlarmsBody.
  ///
  /// In en, this message translates to:
  /// **'Add a learning reminder\nto build a consistent habit.'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
