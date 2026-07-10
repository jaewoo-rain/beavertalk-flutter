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
