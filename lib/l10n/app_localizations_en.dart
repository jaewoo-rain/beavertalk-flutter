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
}
