// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get loginRequired => 'ඔබ පිවිසිය යුතුයි.';

  @override
  String get callWebNotSupported =>
      'වෙබයේ හඬ ඇමතුම් සහාය නොදක්වයි. යෙදුම භාවිත කරන්න.';

  @override
  String get micPermissionRequiredForCall =>
      'මයික්‍රොෆෝන අවසරය අවශ්‍යයි. ඇමතුමක් ගැනීමට මයික්‍රොෆෝනයට අවසර දෙන්න.';

  @override
  String get callErrorGeneric => 'ඇමතුම අතරතුර දෝෂයක් ඇති විය.';

  @override
  String get callDailyLimit => 'අද ඉගෙනුම් කාලය අවසන්.';

  @override
  String get callAlreadyInCall => 'ඔබ දැනටමත් ඇමතුමක සිටී.';

  @override
  String get callNetworkError => 'ජාල දෝෂයක් ඇති විය.';

  @override
  String get authInvalidCredentials => 'විද්‍යුත් තැපෑල හෝ මුරපදය වැරදියි.';

  @override
  String get authEmailAlreadyRegistered =>
      'මෙම විද්‍යුත් තැපෑල දැනටමත් ලියාපදිංචි වී ඇත.';

  @override
  String get authConfirmEmailRequired =>
      'ඔබේ විද්‍යුත් තැපෑලට එවූ තහවුරු කිරීම සම්පූර්ණ කරන්න.';

  @override
  String get authResetCodeSent =>
      'තහවුරු කිරීමේ කේතය ඔබේ විද්‍යුත් තැපෑලට එවා ඇත.';

  @override
  String get authResetCodeInvalid => 'කේතය වැරදියි හෝ කල් ඉකුත් වී ඇත.';

  @override
  String get authPasswordUpdated => 'ඔබේ මුරපදය නැවත සකසා ඇත.';

  @override
  String get authAppleTokenMissing => 'Apple පිවිසුම් ටෝකනය ලබා ගත නොහැකි විය.';

  @override
  String callEndedDuration(String duration) {
    return 'ඇමතුම අවසන් විය $duration';
  }

  @override
  String get callRatingPrompt => 'ඔබේ ඇමතුම කෙසේ වුණාද?';

  @override
  String get callRatingBody =>
      'ඔබේ ඇගයීම ඊළඟ වතාවේ වඩා හොඳින් කතා කිරීමට උදව් කරයි.';

  @override
  String get callRatingSubmit => 'යවන්න';

  @override
  String get callRatingSkip => 'මඟ හරින්න';

  @override
  String get ratingBad => 'එච්චර හොඳ නැහැ';

  @override
  String get ratingOkay => 'සාමාන්‍යයි';

  @override
  String get ratingGood => 'හොඳයි';

  @override
  String get goHome => 'මුල් පිටුව';

  @override
  String get viewAnalysis => 'විශ්ලේෂණය බලන්න';

  @override
  String get loadingShort => 'පූරණය වෙමින්…';

  @override
  String ratingSubmitFailed(String message) {
    return 'ශ්‍රේණිගත කිරීම යැවීමට අසමත් විය: $message';
  }

  @override
  String get callInfoNotFound =>
      'ඇමතුම් තොරතුරු හමු නොවීය, විශ්ලේෂණය මඟහරිනු ලැබේ.';

  @override
  String get tabRecords => 'වාර්තා';

  @override
  String get tabArchive => 'සංරක්ෂිතය';

  @override
  String get callHistory => 'ඇමතුම් ඉතිහාසය';

  @override
  String get conversationRecord => 'සංවාද වාර්තාව';

  @override
  String get noCallRecords => 'තවම ඇමතුම් වාර්තා නැත';

  @override
  String get noCallRecordsBody =>
      'ඔබ AI සමඟ ඔබේ පළමු ඇමතුම අවසන් කළ පසු,\nඔබේ වාර්තා මෙහි දිස්වනු ඇත.';

  @override
  String get startCall => 'ඇමතුමක් ආරම්භ කරන්න';

  @override
  String get recordsLoadError => 'වාර්තා පූරණය කළ නොහැකි විය';

  @override
  String get tryAgainLater => 'කරුණාකර පසුව නැවත උත්සාහ කරන්න.';

  @override
  String get retry => 'නැවත උත්සාහ කරන්න';

  @override
  String durationMinSec(int minutes, int seconds) {
    return 'විනාඩි $minutes තත්පර $seconds';
  }

  @override
  String get scheduleManagement => 'කාලසටහන';

  @override
  String get alarms => 'එලාම්';

  @override
  String get alarmAdd => 'එලාම් එක් කරන්න';

  @override
  String get alarmEdit => 'එලාම් සංස්කරණය';

  @override
  String get alarmEveryDay => 'සෑම දිනකම';

  @override
  String get alarmWeekdays => 'සතියේ දින';

  @override
  String get alarmWeekend => 'සති අන්ත';

  @override
  String get alarmNoRepeat => 'නැවත නොකෙරේ';

  @override
  String get addSchedule => 'කාලසටහනක් එක් කරන්න';

  @override
  String get editSchedule => 'කාලසටහන සංස්කරණය කරන්න';

  @override
  String get somethingWentWrong => 'යමක් වැරදී ගියේය';

  @override
  String get alarmsLoadError => 'එලාම් පූරණය කළ නොහැකි විය';

  @override
  String get charactersLoadError => 'චරිත පූරණය කළ නොහැකි විය';

  @override
  String get noCharacters => 'චරිත නොමැත';

  @override
  String get close => 'වසන්න';

  @override
  String get repeat => 'පුනරාවර්තනය';

  @override
  String get callPartner => 'චරිතය';

  @override
  String get alarmModeLearnSub => 'විෂයමාලා ප්‍රකාශන පුහුණුව';

  @override
  String get alarmModeChatSub => 'ඕනෑම දෙයක් ගැන කතා කරන්න';

  @override
  String get quickStart => 'ඉක්මන් ආරම්භය';

  @override
  String get presetMorning => 'උදෑසන දිනචරියාව';

  @override
  String get presetMorningSub => 'සතියේ දිනවල 8:00';

  @override
  String get presetEvening => 'සවස නිමාව';

  @override
  String get presetEveningSub => 'දිනපතා 21:00';

  @override
  String get presetCustom => 'අභිරුචි';

  @override
  String get presetCustomSub => 'ඔබ කැමති ලෙස';

  @override
  String alarmSummary(int count, int monthly) {
    return 'සතියකට $countක් · මසකට ඇමතුම් $monthlyක්';
  }

  @override
  String get alarmSummaryNone => 'අවම වශයෙන් එක් දිනයක් තෝරන්න';

  @override
  String get partnerInUse => 'භාවිතයේ';

  @override
  String get partnerOwned => 'ඔබ සතුයි';

  @override
  String get am => 'පෙ.ව.';

  @override
  String get pm => 'ප.ව.';

  @override
  String get save => 'සුරකින්න';

  @override
  String get conversation => 'සංවාදය';

  @override
  String get newExpressions => 'නව වචන ප්‍රකාශන';

  @override
  String get analysisPrepNote => 'අද ඇමතුම නැවත බලමින් සිටී.';

  @override
  String get analysisPrepNoteHint => 'ටික වේලාවකින් පණිවිඩයක් මෙහි පෙනේ';

  @override
  String get analysisPrepTitle =>
      'බීවර් අද ප්‍රකාශන කාඩ්පත් බවට පත් කරමින් සිටී';

  @override
  String get analysisPrepSub => 'සූදානම් වූ වහාම මෙහි පෙනේ.';

  @override
  String get analysisPrepStepSave => 'සංවාදය සුරැකීම';

  @override
  String get analysisPrepStepCards => 'ප්‍රකාශන කාඩ්පත් සෑදීම';

  @override
  String get analysisPrepStateDone => 'අවසන්';

  @override
  String get analysisPrepStateWorking => 'සිදු වෙමින්';

  @override
  String get analysisPrepStateWaiting => 'රැඳී සිටී';

  @override
  String get usedExpressions => 'ඔබ භාවිත කළ ප්‍රකාශන';

  @override
  String quizExpressionsCount(int count) {
    return 'ඉගෙන ගත් ප්‍රකාශන $count';
  }

  @override
  String get quizPassed => 'නිවැරදියි';

  @override
  String get quizFailed => 'නැවත බලන්න';

  @override
  String get quizPending => 'ඊළඟ වතාවේ දිගටම';

  @override
  String get analysisResult => 'විශ්ලේෂණ ප්‍රතිඵලය';

  @override
  String get noNewExpressions => 'මෙම සංවාදයෙන් නව ප්‍රකාශන නොමැත.';

  @override
  String get practice => 'පුහුණුව';

  @override
  String get analysisNativeLabel => 'දේශීය';

  @override
  String recentScore(int score) {
    return 'මෑත ලකුණු $score%';
  }

  @override
  String callSequence(int count) {
    return '$count වන ඇමතුම';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name ගෙන් වචනයක්';
  }

  @override
  String characterNoteFooter(String name) {
    return 'ඇමතුමෙන් පසු $name විසින් තබන ලදී';
  }

  @override
  String newExpressionsCount(int count) {
    return 'නව ප්‍රකාශන $count';
  }

  @override
  String get analysisLoadError => 'විශ්ලේෂණ ප්‍රතිඵලය පූරණය කළ නොහැකි විය.';

  @override
  String get standardAudioNotReady => 'සම්මත උච්චාරණ ශබ්දය තවම සූදානම් නැත.';

  @override
  String get standardAudioPlayError =>
      'සම්මත උච්චාරණ ශබ්දය වාදනය කළ නොහැකි විය.';

  @override
  String get selectNativeLanguage => 'ඔබේ මව් භාෂාව තෝරන්න';

  @override
  String get selectYourLanguage => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get confirm => 'තහවුරු කරන්න';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get getStarted => 'ආරම්භ කරන්න';

  @override
  String get permissionTitle => 'සුමට අත්දැකීමක් සඳහා\nඅවසර ලබා දෙන්න';

  @override
  String get permissionSubtitle =>
      'සේවාව භාවිතා කිරීමට අවශ්‍ය අවසර අත්‍යවශ්‍ය වේ.';

  @override
  String get permissionMicTitle => 'මයික්‍රෆෝනය (අවශ්‍යයි)';

  @override
  String get permissionMicDesc => 'AI සමඟ ඉංග්‍රීසියෙන් කතා කිරීමට අවශ්‍යයි.';

  @override
  String get permissionNotifTitle => 'දැනුම්දීම් (විකල්ප)';

  @override
  String get permissionNotifDesc =>
      'අපි ඉගෙනුම් මතක් කිරීම් සහ ඇමතුම් කාලසටහන් යවන්නෙමු.';

  @override
  String get micPermissionNeededTitle => 'මයික්‍රෆෝන ප්‍රවේශය අවශ්‍යයි';

  @override
  String get micPermissionNeededBody =>
      'AI සමඟ කතා කිරීමට, ඔබ මයික්‍රෆෝන ප්‍රවේශයට අවසර දිය යුතුයි. කරුණාකර සැකසීම් තුළ එය සක්‍රිය කරන්න.';

  @override
  String get openSettings => 'සැකසීම් විවෘත කරන්න';

  @override
  String get connectionFailedTitle => 'සම්බන්ධතාවය අසාර්ථක විය';

  @override
  String get connectionFailedBody =>
      'ඔබේ ජාල සම්බන්ධතාවය පරීක්ෂා කර\nනැවත උත්සාහ කරන්න.';

  @override
  String get checkout => 'ගෙවීම් කරන්න';

  @override
  String get pay => 'ගෙවන්න';

  @override
  String get orderSummary => 'ඇණවුම් සාරාංශය';

  @override
  String get paymentMethod => 'ගෙවීම් ක්‍රමය';

  @override
  String get payMethodCard => 'ක්‍රෙඩිට් / ඩෙබිට් කාඩ්පත';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'කරදරකාරී බීවර් අවතාරය';

  @override
  String get productTrait => 'වාරික චරිතයක් · සදහටම ඔබේ';

  @override
  String get amountItemPrice => 'අයිතමයේ මිල';

  @override
  String get amountDiscount => 'වට්ටම';

  @override
  String get amountTotal => 'එකතුව';

  @override
  String get paymentCompleteTitle => 'ගෙවීම සම්පූර්ණයි';

  @override
  String get paymentCompleteBody => 'අවතාරය ඔබේ එකතුවට එකතු කර ඇත.';

  @override
  String get viewCollection => 'එකතුව බලන්න';

  @override
  String get receiptItem => 'අයිතමය';

  @override
  String get receiptAmount => 'මුදල';

  @override
  String get receiptMethod => 'ගෙවීම් ක්‍රමය';

  @override
  String get receiptDate => 'දිනය';

  @override
  String get paymentFailedTitle => 'ගෙවීම අසාර්ථක විය';

  @override
  String get paymentFailedBody =>
      'ඔබේ ගෙවීම සැකසිය නොහැකි විය.\nකරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get freeCallEndingTitle => 'ඔබේ නොමිලේ ඇමතුම අවසන් වෙමින් පවතී';

  @override
  String get freeCallEndingBody => 'බීවර් සමඟ තව දුරටත් කතා කිරීමට දායක වන්න.';

  @override
  String get subscribe => 'දායක වන්න';

  @override
  String get endCall => 'ඇමතුම අවසන් කරන්න';

  @override
  String get callEnded => 'ඇමතුම අවසන් වී ඇත.';

  @override
  String get connecting => 'සම්බන්ධ වෙමින්…';

  @override
  String get connectingHint =>
      'සාමාන්‍යයෙන් මෙයට තත්පර 5කට වඩා අඩු කාලයක් ගතවේ';

  @override
  String get callConnectFailed => 'ඇමතුම සම්බන්ධ කළ නොහැකි විය.';

  @override
  String get saveSentenceFailed => 'වාක්‍යය සුරැකිය නොහැකි විය.';

  @override
  String get recordStartFailed => 'පටිගත කිරීම ආරම්භ කළ නොහැකි විය.';

  @override
  String get recordTooShort =>
      'එම පටිගත කිරීම ඉතා කෙටියි. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get gradingFailed =>
      'ලකුණු දීම අසාර්ථක විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get listenStandard => 'සම්මත උච්චාරණයට සවන් දෙන්න';

  @override
  String get saveSentence => 'වාක්‍යය සුරකින්න';

  @override
  String get unsaveSentence => 'සුරැකි වාක්‍යය ඉවත් කරන්න';

  @override
  String get scoringPronunciation => 'ඔබේ උච්චාරණයට ලකුණු දෙමින්…';

  @override
  String get analyzingByWord => 'ඔබේ උච්චාරණය වචනයෙන් වචනය පරීක්ෂා කරමින්';

  @override
  String get analyzingTakingLonger => 'මෙයට තව ටිකක් කාලය ගතවේ';

  @override
  String get scanConnectionLost => 'සම්බන්ධතාවය නැති විය';

  @override
  String get noRecordingToPlay => 'වාදනය කිරීමට පටිගත කිරීමක් නැත.';

  @override
  String get myRecordingPlayError => 'ඔබේ පටිගත කිරීම වාදනය කළ නොහැකි විය.';

  @override
  String get next => 'ඊළඟ';

  @override
  String get endLearning => 'සැසිය අවසන් කරන්න';

  @override
  String get navCalendar => 'දින දර්ශනය';

  @override
  String get navCall => 'ඇමතුම';

  @override
  String get navStats => 'සංඛ්‍යාලේඛන';

  @override
  String get homeCourseExpression => 'ප්‍රකාශන';

  @override
  String get homeCourseFreetalk => 'සංවාදය';

  @override
  String homeExpressionsLeft(int count) {
    return 'සංවාදය දක්වා ප්‍රකාශන $countක් ඉතිරියි';
  }

  @override
  String get homeFreetalkNote => 'ඉගෙන ගත් දේ භාවිතා කර නිදහසේ කතා කරන්න';

  @override
  String get homeTalkTitle => 'අද මොකද වුණේ?';

  @override
  String get homeTalkNote => 'නිදහසේ කතා කරමින් ඉගෙන ගන්න.';

  @override
  String get homeModeLearn => 'ඉගෙනුම';

  @override
  String get homeModeTalk => 'කතාබහ';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'දින $countක් අඛණ්ඩව',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'ඉගෙනුම් දින දර්ශනය';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'දින අඛණ්ඩව',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'හොඳම වාර්තාව දින $count',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'ඇමතුම් කාලය';

  @override
  String get streakMetricLearned => 'ඉගෙනගත් ප්‍රකාශන';

  @override
  String get streakMetricWords => 'කී වචන';

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
      other: 'මිනි. $count',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'මෙදින ඇමතුම් නැත.';

  @override
  String get homeLevelPending => 'මට්ටම නිශ්චිත නැත';

  @override
  String get homeNoLevelTitle => 'ඔබට තවම මට්ටමක් නැත';

  @override
  String get homeNoLevelNote => 'පළමු ඇමතුම අවසන් කළ විට මට්ටම ලැබේ';

  @override
  String get homeCurriculumPendingBadge => 'ළඟදීම';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language විෂය නිර්දේශය සූදානම් වෙමින් පවතී';
  }

  @override
  String get homeCurriculumPendingNote =>
      'ඇමතුම්වලදී ඔබ සාමාන්‍ය ප්‍රකාශන පුහුණු වේ';

  @override
  String get myPage => 'මගේ පිටුව';

  @override
  String get languageSaveFailed => 'ඔබේ භාෂාව සුරැකිය නොහැකි විය.';

  @override
  String get accountDeleteFailed => 'ඔබේ ගිණුම මකා දැමිය නොහැකි විය.';

  @override
  String get changeAvatar => 'අවතාරය වෙනස් කරන්න';

  @override
  String get avatarUseNow => 'දැන් භාවිත කරන්න';

  @override
  String get avatarPurchaseFailed => 'මිලදී ගැනීම සම්පූර්ණ නොවීය';

  @override
  String avatarPromoTitle(int percent) {
    return 'අද පමණයි · $percent% වට්ටම්';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time ඉතිරියි';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'දින $days $time ඉතිරියි';
  }

  @override
  String get avatarIntro =>
      'හඬ සහ අපහසුතා මට්ටම ඇමතුම් හවුල්කරු අනුව වෙනස් වේ.\nසමහර හවුල්කරුවන් සඳහා ගෙවීමක් අවශ්‍ය විය හැක.';

  @override
  String myPartnersOwned(int count) {
    return 'මගේ හවුල්කරුවන් · $count ක් හිමිකම්';
  }

  @override
  String get limitedDiscount => 'සීමිත කාලීන වට්ටම';

  @override
  String get available => 'ලබාගත හැක';

  @override
  String get inUse => 'භාවිතයේ';

  @override
  String get owned => 'හිමිකම්';

  @override
  String get noCharactersToShow => 'පෙන්වීමට චරිත නොමැත';

  @override
  String get buy => 'මිලදී ගන්න';

  @override
  String get noSavedSentences =>
      'තවම සුරැකි වාක්‍ය නැත.\nඔබේ සංවාද වාර්තාවලින් වාක්‍ය පිටු සලකුණු කරන්න.';

  @override
  String get noAlarms => 'තවම එලාම් නැත';

  @override
  String get noAlarmsBody =>
      'නිරන්තර පුරුද්දක් ගොඩනගා ගැනීමට\nඉගෙනුම් මතක් කිරීමක් එක් කරන්න.';

  @override
  String get subscriptionManage => 'දායකත්වය කළමනාකරණය කරන්න';

  @override
  String get cancelSubscription => 'දායකත්වය අවලංගු කරන්න';

  @override
  String get benefitsInUse => 'ඔබේ ප්‍රතිලාභ';

  @override
  String get paymentInfo => 'ගෙවීම් තොරතුරු';

  @override
  String get nextBillingDate => 'ඊළඟ බිල්පත් දිනය';

  @override
  String get lostBenefitsTitle => 'අවලංගු කළහොත් ඔබට අහිමි වන ප්‍රතිලාභ';

  @override
  String get viewBillingHistory => 'බිල්පත් ඉතිහාසය බලන්න';

  @override
  String pricePerMonth(String price) {
    return '$price / මාසයකට';
  }

  @override
  String get benefitDetailedAnalysis => 'සවිස්තර උච්චාරණ සහ ව්‍යාකරණ විශ්ලේෂණය';

  @override
  String get benefitAllCharacters => 'සියලුම චරිත වෙත ප්‍රවේශය';

  @override
  String get benefitNoAds => 'දැන්වීම් නැත';

  @override
  String get playSampleVoice => 'නියැදි හඬ වාදනය කරන්න';

  @override
  String get useThisAvatar => 'මෙය භාවිතා කරන්න';

  @override
  String get challengeTitle => 'උච්චාරණ අභියෝගය';

  @override
  String get challengeIntro =>
      'කලාපයේ ඇති සෑම කාඩ්පතක්ම කොරියානු භාෂාවෙන් නිවැරදිව උච්චාරණය කර එය නිමකරන්න.\nමයික් නැද්ද? තිරය තට්ටු කර ද ක්‍රීඩා කළ හැක.';

  @override
  String get challengeStart => 'කැමරාව සහ මයික් ආරම්භ කරන්න';

  @override
  String get challengePermissionNote =>
      'ඉදිරි කැමරාව සහ මයික් ප්‍රවේශය අවශ්‍යයි (විකල්ප).';

  @override
  String get challengeLoadingTitle => 'පූරණය වෙමින්…';

  @override
  String get challengeLoadingNote => 'කැමරාව සහ මයික්‍රෆෝනය සූදානම් කරමින්.';

  @override
  String get challengeSttFallback =>
      'කථන හඳුනාගැනීම ලබාගත නොහැකි වූ බැවින්, ඔබ තට්ටු කිරීමේ ආදානය සමඟ ක්‍රීඩා කළා.';

  @override
  String get reasonTravelTitle => 'සංචාරය කරමින් කථා කිරීම';

  @override
  String get reasonTravelDesc => 'ප්‍රාදේශීයයන් සමඟ විශ්වාසයෙන් කතා කරන්න';

  @override
  String get reasonCareerTitle => 'රැකියාව සහ වෘත්තිය';

  @override
  String get reasonCareerDesc => 'ව්‍යාපාරික සංවාදය';

  @override
  String get reasonExamTitle => 'විභාග සූදානම';

  @override
  String get reasonExamDesc => 'කථන විභාග සඳහා සූදානම් වන්න';

  @override
  String get reasonDailyTitle => 'දෛනික සංවාදය';

  @override
  String get reasonDailyDesc => 'ඔබ දිනපතා භාවිතා කරන ප්‍රකාශන';

  @override
  String get reasonFriendsTitle => 'විදේශීය මිතුරන් ඇති කර ගැනීම';

  @override
  String get reasonFriendsDesc => 'ස්වාභාවික සංවාදය';

  @override
  String get reasonBrainTitle => 'මොළය උත්තේජනය';

  @override
  String get reasonBrainDesc => 'මතකය සහ අවධානය වැඩි දියුණු කරන්න';

  @override
  String get challengeRecordToggle => 'මෙම ධාවනය පටිගත කරන්න';

  @override
  String get challengeRecordHint =>
      'බෙදාගැනීමට ඔබේ ක්‍රීඩා වීඩියෝවක් සුරකියි (නිශ්ශබ්ද).';

  @override
  String get settingsSection => 'සැකසීම්';

  @override
  String get paymentSection => 'ගෙවීම';

  @override
  String get supportSection => 'සහාය';

  @override
  String get userLanguage => 'පරිශීලක භාෂාව';

  @override
  String get learningLanguage => 'ඉගෙනුම් භාෂාව';

  @override
  String get learningLanguageKorean => 'කොරියානු';

  @override
  String get notificationLabel => 'දැනුම්දීම';

  @override
  String get currentPlan => 'වත්මන් සැලැස්ම';

  @override
  String get paymentHistory => 'ගෙවීම් ඉතිහාසය';

  @override
  String get contactUs => 'අප අමතන්න';

  @override
  String get termsOfService => 'සේවා නියම';

  @override
  String get privacyPolicy => 'රහස්‍යතා ප්‍රතිපත්තිය';

  @override
  String get logOut => 'ලොග් අවුට් වන්න';

  @override
  String get deleteAccount => 'ගිණුම මකන්න';

  @override
  String get deleteAccountTitle => 'ගිණුම මකන්නද?';

  @override
  String get deleteAccountBody =>
      'මෙය ඔබේ ගිණුම සහ දත්ත ස්ථිරවම මකා දමන අතර, එය ආපසු හැරවිය නොහැක.';

  @override
  String get delete => 'මකන්න';

  @override
  String get share => 'බෙදාගන්න';

  @override
  String get accentSoundsLike => 'ඔබේ කොරියානු උච්චාරණය පෙනෙන්නේ';

  @override
  String accentShareText(String country) {
    return 'මම BeaverTalk එක්ක කොරියානු ඉගෙන ගන්නවා — මගේ කොරියානු උච්චාරණය ඇහෙන්නේ මෙහෙමයි: $country! 🦫 ඔයාගේ උච්චාරණය හොයාගෙන මාත් එක්ක ඉගෙන ගන්න: https://beavertalk.im';
  }

  @override
  String get hintLabel => 'ඉඟිය';

  @override
  String get nextHint => 'ඊළඟ ඉඟිය';

  @override
  String get translateLabel => 'පරිවර්තනය';

  @override
  String get startRecording => 'පටිගත කිරීම ආරම්භ කරන්න';

  @override
  String get stopRecording => 'පටිගත කිරීම නවත්වන්න';

  @override
  String get back => 'ආපසු';

  @override
  String get onboardingNameTitle => 'ඔබව අප ඇමතිය යුත්තේ කුමක් ලෙසද?';

  @override
  String get onboardingNameSubtitle => 'ඔබේ AI උපදේශකයා ඔබේ නම මතක තබා ගනු ඇත.';

  @override
  String get nameLabel => 'ඔබේ නම';

  @override
  String get nameHint => 'ඔබේ නම ඇතුළත් කරන්න';

  @override
  String get nameHelper =>
      'එය ඔබේ සැබෑ නම විය යුතු නැත — අන්වර්ථ නාමයක් ද ප්‍රමාණවත්.';

  @override
  String get continueLabel => 'ඉදිරියට';

  @override
  String get onboardingDoneTitle => 'බීවර් ඔබේ ඇමතුම බලාපොරොත්තුවෙන් සිටී';

  @override
  String get onboardingDoneSubtitle => 'දැන්ම ඇමතුමක් ආරම්භ කරන්න';

  @override
  String get home => 'මුල් පිටුව';

  @override
  String get onboardingLevelTestCta => 'මට්ටම් පරීක්ෂණය කරන්න';

  @override
  String get pronunciation => 'උච්චාරණය';

  @override
  String get fluency => 'චතුරතාව';

  @override
  String get rhythm => 'රිද්මය';

  @override
  String get analysisFailed =>
      'අපට සංවාදය විශ්ලේෂණය කළ නොහැකි විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get analyzingConversation => 'ඔබේ සංවාදය විශ්ලේෂණය කරමින්…';

  @override
  String get analyzingSubtitle => 'මෙයට මොහොතක් පමණක් ගතවනු ඇත';

  @override
  String get tryAgain => 'නැවත උත්සාහ කරන්න';

  @override
  String get nativeLabel => 'ස්වදේශික';

  @override
  String get meLabel => 'මම';

  @override
  String get pronunciationPlayError => 'උච්චාරණ ශබ්දය වාදනය කළ නොහැකි විය.';

  @override
  String get savedExpressionsLoadError =>
      'ඔබේ සුරැකි ප්‍රකාශන පූරණය කළ නොහැකි විය.';

  @override
  String get mySavedExpressions => 'මගේ සුරැකි ප්‍රකාශන';

  @override
  String get avatarTraits => 'උණුසුම් · සන්සුන් · මෘදු';

  @override
  String get priceFree => 'නොමිලේ';

  @override
  String get loginGoogleTokenError => 'Google පිවිසුම් ටෝකනය ලබාගත නොහැකි විය.';

  @override
  String get loginGoogleSignInFailed => 'Google පිවිසුම අසාර්ථක විය.';

  @override
  String get loginAppleSignInFailed => 'Apple පිවිසුම අසාර්ථක විය.';

  @override
  String get loginFacebookSignInFailed => 'Facebook පිවිසුම අසාර්ථක විය.';

  @override
  String get loginKakaoSignInFailed => 'Kakao පිවිසුම අසාර්ථක විය.';

  @override
  String get loginContinueWithKakao => 'Kakao සමඟ ඉදිරියට යන්න';

  @override
  String get loginContinueWithGoogle => 'Google සමඟ ඉදිරියට යන්න';

  @override
  String get loginContinueWithFacebook => 'Facebook සමඟ ඉදිරියට යන්න';

  @override
  String get loginContinueWithApple => 'Apple සමඟ ඉදිරියට යන්න';

  @override
  String get loginContinueWithEmail => 'විද්‍යුත් තැපෑලෙන් ඉදිරියට යන්න';

  @override
  String get loginOrDivider => 'හෝ';

  @override
  String get loginNoAccount => 'ගිණුමක් නැද්ද?';

  @override
  String get signUp => 'ලියාපදිංචි වන්න';

  @override
  String get loginTermsNoticePrefix => 'ඉදිරියට යැමෙන් ඔබ අපගේ ';

  @override
  String get loginTermsNoticeAnd => ' සහ ';

  @override
  String get loginTermsNoticeSuffix => ' ට එකඟ වේ.';

  @override
  String get loginLogIn => 'ලොග් වන්න';

  @override
  String get fieldEmailLabel => 'විද්‍යුත් තැපෑල';

  @override
  String get emailHint => 'ඔබේ විද්‍යුත් තැපෑල ඇතුළත් කරන්න';

  @override
  String get fieldPasswordLabel => 'මුරපදය';

  @override
  String get passwordHint => 'ඔබේ මුරපදය ඇතුළත් කරන්න';

  @override
  String get loginRememberMe => 'මාව මතක තබාගන්න';

  @override
  String get loginForgotPassword => 'මුරපදය අමතකද?';

  @override
  String get loginLoggingIn => 'ලොග් වෙමින්...';

  @override
  String get passwordLengthError => 'මුරපදය අක්ෂර 8–16 අතර විය යුතුය.';

  @override
  String get passwordsDoNotMatch => 'මුරපද ගැලපෙන්නේ නැත.';

  @override
  String get signupCheckInput => 'කරුණාකර ඔබ ඇතුළත් කළ තොරතුරු පරීක්ෂා කරන්න.';

  @override
  String get fieldConfirmPasswordLabel => 'මුරපදය තහවුරු කරන්න';

  @override
  String get confirmPasswordHint => 'ඔබේ මුරපදය නැවත ඇතුළත් කරන්න';

  @override
  String get signupSigningUp => 'ලියාපදිංචි වෙමින්...';

  @override
  String get signupHaveAccount => 'දැනටමත් ගිණුමක් තිබේද?';

  @override
  String get passwordMethodEmailRequired => 'ඔබේ විද්‍යුත් තැපෑල ඇතුළත් කරන්න';

  @override
  String get passwordResetTitle => 'මුරපදය යළි පිහිටුවන්න';

  @override
  String get passwordMethodDescription =>
      'මුරපදය යළි පිහිටුවීමේ කේතය ලැබීමට කැමති විද්‍යුත් තැපැල් ලිපිනය ඇතුළත් කරන්න.';

  @override
  String get emailAddressHint => 'විද්‍යුත් තැපැල් ලිපිනය';

  @override
  String get passwordMethodSending => 'යවමින්...';

  @override
  String get passwordMethodSendEmail => 'විද්‍යුත් තැපෑල යවන්න';

  @override
  String get passwordCodeTitle => 'කේතය ඇතුළත් කරන්න';

  @override
  String get passwordCodeDescription =>
      'අපි ඔබේ විද්‍යුත් තැපෑලට ප්‍රතිසාධන කේතයක් යවා ඇත. ඉදිරියට යාමට එය ඇතුළත් කරන්න.';

  @override
  String get passwordCodeNoCode => 'කේතය ලැබුනේ නැද්ද?';

  @override
  String get passwordCodeResend => 'කේතය නැවත යවන්න';

  @override
  String get passwordCodeVerifying => 'සත්‍යාපනය කරමින්...';

  @override
  String get passwordNewTitle => 'නව මුරපදය';

  @override
  String get passwordNewDescription => 'ඔබේ ගිණුම සඳහා නව මුරපදයක් සකසන්න.';

  @override
  String get fieldNewPasswordLabel => 'නව මුරපදය';

  @override
  String get newPasswordHint => 'ඔබේ නව මුරපදය ඇතුළත් කරන්න';

  @override
  String get fieldConfirmNewPasswordLabel => 'නව මුරපදය තහවුරු කරන්න';

  @override
  String get confirmNewPasswordHint => 'ඔබේ නව මුරපදය නැවත ඇතුළත් කරන්න';

  @override
  String get passwordNewSubmitting => 'යොමු කරමින්...';

  @override
  String get passwordNewSubmit => 'යොමු කරන්න';

  @override
  String get passwordCompleteTitle => 'මුරපදය යළි පිහිටුවීම සම්පූර්ණයි';

  @override
  String get passwordCompleteBody =>
      'ඔබේ මුරපදය යළි පිහිටුවා ඇත. ඉදිරියට යාමට ඔබේ නව මුරපදයෙන් ලොග් වන්න.';

  @override
  String get termsTitle => 'සේවා නියම';

  @override
  String get privacyTitle => 'රහස්‍යතා ප්‍රතිපත්තිය';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email සඳහා නව මුරපදයක් සකසන්න.';
  }

  @override
  String get selectComplete => 'නිමයි';

  @override
  String get onboardingLanguageTitle => 'ඔබේ මව් භාෂාව කුමක්ද?';

  @override
  String get onboardingReasonTitle => 'ඔබ භාෂාවක් ඉගෙන ගන්නේ ඇයි?';

  @override
  String get onboardingReasonSubtitle =>
      'අපි ඔබේ ඉලක්ක වලට ගැලපෙන පරිදි ඉගෙනුම සකසන්නෙමු.';

  @override
  String get savingLabel => 'සුරකිමින්...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'මෙම මාසයේ ගෙවීම';

  @override
  String get filterAll => 'සියල්ල';

  @override
  String get filterSubscription => 'දායකත්වය';

  @override
  String get filterCharacter => 'චරිතය';

  @override
  String get statusCompleted => 'සම්පූර්ණයි';

  @override
  String get lastPayment => 'අවසන් ගෙවීම';

  @override
  String get freePlanCallLimit => 'දිනකට ඇමතුම් මිනිත්තු 5';

  @override
  String get freePlanBasicCharacters => 'මූලික චරිත ඇතුළත්';

  @override
  String get availableForPurchase => 'මිලදී ගැනීමට ඇත';

  @override
  String get paymentsLoadError => 'ගෙවීම් ඉතිහාසය පූරණය කළ නොහැකි විය';

  @override
  String get noPayments => 'තවම ගෙවීම් නැත';

  @override
  String get morePaymentsExist => 'පැරණි ගෙවීම් තවම පෙන්වා නැත';

  @override
  String get undatedPayments => 'දිනයක් නැත';

  @override
  String get paymentLabelFallback => 'ගෙවීම';

  @override
  String learningPassed(int passed, int total) {
    return 'වාක්‍ය $totalෙන් $passedක් සමත්';
  }

  @override
  String get hardestSound => 'අද අමාරුම ශබ්දය';

  @override
  String get soundAccuracy => 'ශබ්දය අනුව නිරවද්‍යතාව';

  @override
  String phonemeAttempts(int count) {
    return 'ශබ්දඛණ්ඩයකට · උත්සාහ $count';
  }

  @override
  String get colSound => 'ශබ්දය';

  @override
  String get colAttempts => 'උත්සා.';

  @override
  String get colCorrect => 'නිවැරදි';

  @override
  String get colAccuracy => 'නිරවද්‍ය.';

  @override
  String get sentenceResults => 'වාක්‍ය අනුව ප්‍රතිඵල';

  @override
  String viewAllSentences(int count) {
    return 'සියලු $count බලන්න';
  }

  @override
  String get colSentence => 'වාක්‍යය';

  @override
  String get colPronunciation => 'උච්චා.';

  @override
  String get colFluency => 'චතුර.';

  @override
  String get colRhythm => 'රිද්මය';

  @override
  String recentSessions(int count) {
    return 'අවසන් සැසි $count';
  }

  @override
  String trendAverage(int score) {
    return 'සාමා. $score';
  }

  @override
  String get today => 'අද';

  @override
  String get colDate => 'දිනය';

  @override
  String get colSentences => 'වාක්‍ය';

  @override
  String get colScore => 'ලකුණු';

  @override
  String get colChange => 'වෙනස';

  @override
  String dateToday(String date) {
    return '$date (අද)';
  }

  @override
  String get accentAnalysis => 'උච්චාරණ රටාව විශ්ලේෂණය';

  @override
  String get overallLevel => 'සමස්ත මට්ටම';

  @override
  String get overallLevelSubtitle => 'වචන මාලාව · ව්‍යාකරණ · ප්‍රකාශන';

  @override
  String get pronunciationAnalysis => 'උච්චාරණ විශ්ලේෂණය';

  @override
  String get recentSessionsAverage => 'පසුගිය සැසි 10 සාමාන්‍යය';

  @override
  String levelStage(int stage) {
    return 'මට්ටම $stage';
  }

  @override
  String topPercent(int percent) {
    return 'ඉහළම $percent%';
  }

  @override
  String get allLearnersBasis => 'සියලු ඉගෙනුම්කරුවන් අතර';

  @override
  String aheadOfLearners(int percent) {
    return 'ඔබ ඉගෙනුම්කරුවන්ගෙන් $percent% ට වඩා ඉදිරියෙන්';
  }

  @override
  String get retakeLevelTest => 'මට්ටම් පරීක්ෂණය නැවත කරන්න';

  @override
  String get levelRetakeTitle => 'මට්ටම් පරීක්ෂණය නැවත කරනවාද?';

  @override
  String get levelRetakeBody =>
      'නැවත කළහොත් ඔබේ ප්‍රගතිය එම මට්ටමේ පළමු පාඩමට ආපසු යයි — එම මට්ටමම ලැබුණත්. ඉගෙනගත් ප්‍රකාශන සහ ඇමතුම් ඉතිහාසය රැඳේ.';

  @override
  String get levelRetakeKeep => 'ප්‍රගතිය තබාගන්න';

  @override
  String get levelRetakeConfirm => 'නැවත පරීක්ෂා කරන්න';

  @override
  String get practicePronunciation => 'උච්චාරණය පුහුණු වන්න';

  @override
  String get priceChangedTitle => 'මිල වෙනස් වුණා';

  @override
  String priceChangedBody(String price) {
    return 'මෙම අයිතමය දැන් $price යි. දිගටම යන්නද?';
  }

  @override
  String get billingGroupPlanPurchases => 'සැලසුම සහ මිලදී ගැනීම්';

  @override
  String get billingGroupInTheStore => 'වෙළඳසැලේ';

  @override
  String get billingCompareAllPlans => 'සැලසුම් සසඳන්න';

  @override
  String get billingBuyACharacter => 'චරිතයක් මිලදී ගන්න';

  @override
  String get billingRestorePurchases => 'මිලදී ගැනීම් යළි ලබාගන්න';

  @override
  String get billingRedeemCode => 'කේතය භාවිතා කරන්න';

  @override
  String get billingPaymentHistory => 'ගෙවීම් ඉතිහාසය';

  @override
  String get billingManageInTheStore => 'වෙළඳසැලෙන් කළමනාකරණය';

  @override
  String get billingRefundHelp => 'මුදල් ආපසු උදව්';

  @override
  String get billingCancelSubscription => 'දායකත්වය අවලංගු කරන්න';

  @override
  String get billingResubscribe => 'නැවත දායක වන්න';

  @override
  String get badgeCurrent => 'වත්මන්';

  @override
  String get badgeTrial => 'අත්හදා බැලීම';

  @override
  String get badgeRenewing => 'අලුත් වෙමින්';

  @override
  String get badgePastDue => 'ගෙවීම ප්‍රමාදයි';

  @override
  String get badgePaused => 'නවතා ඇත';

  @override
  String get badgeCanceling => 'අවලංගු වෙමින්';

  @override
  String get subscriptionTitle => 'දායකත්වය';

  @override
  String get plansTitle => 'සැලසුම්';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'දිනකට වීඩියෝ ඇමතුම් මිනිත්තු 15';

  @override
  String get premiumBulletAnalysis => 'සම්පූර්ණ උච්චාරණ විශ්ලේෂණය';

  @override
  String get premiumBulletWeakSounds => 'ඔබේ භාෂාවට ගැළපෙන දුර්වල ශබ්ද පුහුණුව';

  @override
  String get noteCharactersSeparate =>
      'චරිත වෙනම විකිණේ. ඔබ මිලදී ගත් චරිත ඔබේමයි.';

  @override
  String get ctaGetPremium => 'Premium ලබා ගන්න';

  @override
  String get planMaxTrial => 'Premium අත්හදා බැලීම';

  @override
  String get freePlanPriceLine => '\$0.00 — දිනකට ඇමතුම් මිනිත්තු 5';

  @override
  String pricePerMonthLine(String amount) {
    return 'මසකට $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date දක්වා නොමිලේ';
  }

  @override
  String get todaysCalls => 'අද ඇමතුම් කාලය';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'මිනිත්තු $limit න් $used ක් භාවිතයි';
  }

  @override
  String get firstPaymentLabel => 'පළමු ගෙවීම';

  @override
  String get nextPaymentLabel => 'ඊළඟ ගෙවීම';

  @override
  String get retryingUntilLabel => 'යළි උත්සාහ අවසානය';

  @override
  String get pausedSinceLabel => 'නැවතුණු දිනය';

  @override
  String planEndsLabel(String plan) {
    return '$plan අවසන් වේ';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium සමඟ මුහුණට මුහුණ කතා කරන්න';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'වීඩියෝ ඇමතුම් · දිනකට මිනිත්තු 15 · මසකට $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'වාර්ෂික සැලසුමට මාරු වන්න';

  @override
  String get bannerPaymentFailedTitle => 'ගෙවීම ලබාගත නොහැකි විය';

  @override
  String get bannerPaymentFailedSub =>
      'Premium රඳවා ගැනීමට වෙළඳසැලේ ගෙවීම යාවත්කාලීන කරන්න';

  @override
  String get bannerPausedTitle => 'ඔබේ සැලසුම නවතා ඇත';

  @override
  String get bannerPausedSub => 'ගෙවීම සිදු වුණේ නැත';

  @override
  String get noteRestoreHint =>
      'වෙනත් උපාංගයක දායක වී තිබේද? යළි ලබාගැනීමෙන් මෙයටත් ගෙනෙයි.';

  @override
  String get noteStoreHandled =>
      'ගෙවීම් ක්‍රමය, සැලසුම් වෙනස් කිරීම් සහ අවලංගු කිරීම වෙළඳසැල මගින් සිදුවේ.';

  @override
  String noteTrialEnds(String date) {
    return 'ඔබේ අත්හදා බැලීම $date අවසන් වේ. ඊට පෙර වෙළඳසැලේ අවලංගු කළොත් කිසිදු ගාස්තුවක් නැත.';
  }

  @override
  String get noteGrace =>
      'සහන කාලය පුරා ප්‍රතිලාභ ක්‍රියාත්මකයි. යෙදුම තුළ අවලංගු කිරීම කිසිවිටෙක අවහිර නොවේ.';

  @override
  String get noteHold =>
      'ගෙවීම සිදුවන තුරු Premium නවතා ඇත. ඔබේ චරිත සහ ප්‍රගතිය ආරක්ෂිතයි.';

  @override
  String noteEnding(String date) {
    return 'ඔබේ සැලසුම අවසන් වීමට නියමිතයි. $date දක්වා ප්‍රතිලාභ ක්‍රියාත්මකයි, පසුව Free වෙත මාරු වේ. ඕනෑම විටෙක නැවත දායක විය හැක.';
  }

  @override
  String get trialExpiredTitle => 'ඔබේ Premium අත්හදා බැලීම අවසන් විය';

  @override
  String get trialExpiredSub => 'ඔබ දැන් Free හි සිටී';

  @override
  String get seePlans => 'සැලසුම් බලන්න';

  @override
  String get currentPlanTitle => 'වත්මන් සැලසුම';

  @override
  String get perMonthUnit => 'මසකට';

  @override
  String get planTaglineMax => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String get planTaglineFree => 'දිනකට ඇමතුම් මිනිත්තු 5. නොමිලේ.';

  @override
  String get bulletProCorrections => 'ඔබේ මව්බස ඉලක්ක කළ නිවැරදි කිරීම්';

  @override
  String get bulletFreeCall => 'දිනකට හඬ ඇමතුම් මිනිත්තු 5';

  @override
  String get bulletFreeCheck => 'පළමු ඇමතුම් 3 සඳහා සම්පූර්ණ විශ්ලේෂණය';

  @override
  String get bulletFreeCharacter => 'ආරම්භයට චරිත 2ක්';

  @override
  String get ctaTurnOnVideo => 'වීඩියෝ සක්‍රිය කරන්න';

  @override
  String get noteCallLength =>
      'Premium: දිනකට මිනිත්තු 15 — ඒ කාලය තුළ කැමති වාර ගණනක් අමතන්න.';

  @override
  String get paywallProTitle1 => 'ඔබේ කොරියානු මිතුරා';

  @override
  String get paywallProTitle2 => 'පාන්දර 3ටත් අවදියෙන්';

  @override
  String get paywallLimitHeadline => 'Premium සමඟ දිනකට ඇමතුම් මිනිත්තු 15.';

  @override
  String get limitBannerCallTitle => 'අද ඇමතුම් කාලය අවසන්';

  @override
  String get limitBannerCallSub => 'Free හි දිනකට ඇමතුම් මිනිත්තු 5';

  @override
  String get limitBannerCheckTitle => 'අද පරීක්ෂාව එයයි';

  @override
  String get limitBannerCheckSub => 'Free හි දිනකට එක් පරීක්ෂාවක්';

  @override
  String get bulletProCharactersForever => 'මිලදී ගත් චරිත සදහටම ඔබේමයි';

  @override
  String get paywallMaxTitle => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String paywallTutorCompare(String price) {
    return 'ගුරුවරයෙකු සමඟ පැයකට \$25 වැය වේ. Premium මාසයකට $price වැය වේ.';
  }

  @override
  String get planMonthly => 'මාසික';

  @override
  String get planAnnual => 'වාර්ෂික';

  @override
  String proMonthlyPriceLine(String price) {
    return 'මසකට $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · මසකට $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'මසකට $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'වසරකට $yearly · මසකට $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'මසකට $price · ඕනෑම විටෙක වෙළඳසැලේ අවලංගු කරන්න';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'මසකට $price · ඕනෑම විටෙක වෙළඳසැලේ අවලංගු කරන්න';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return 'දින 7ක් නොමිලේ, ඉන්පසු මසකට $price · ඕනෑම විටෙක වෙළඳසැලේ අවලංගු කරන්න';
  }

  @override
  String get ctaCaptionAutoRenew => 'අවලංගු කරන තෙක් ස්වයංක්‍රීයව අලුත් වේ.';

  @override
  String get footerTerms => 'කොන්දේසි';

  @override
  String get footerPrivacy => 'පෞද්ගලිකත්වය';

  @override
  String get processingTitle => 'ඔබේ මිලදී ගැනීම තහවුරු වෙමින්';

  @override
  String get processingSub => 'සාමාන්‍යයෙන් තත්පර කිහිපයක් ගතවේ.';

  @override
  String get successProTitle => 'ඔබ දැන් Premium හි.';

  @override
  String get successMaxTitle => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String get successMaxSub =>
      'වීඩියෝ ඇමතුම් සක්‍රියයි. ඕනෑම ඇමතුමක වීඩියෝ බොත්තම ඔබන්න.';

  @override
  String get ctaStartAVideoCall => 'වීඩියෝ ඇමතුමක් අරඹන්න';

  @override
  String get ctaSeeYourSubscription => 'ඔබේ දායකත්වය බලන්න';

  @override
  String successMaxCaption(String price) {
    return 'අවලංගු කරන තුරු මසකට $price අය වේ. ඕනෑම විටෙක වෙළඳසැලේ කළමනාකරණය හෝ අවලංගු කරන්න.';
  }

  @override
  String get plansErrorTitle => 'සැලසුම් පූරණය කළ නොහැකි විය';

  @override
  String get plansErrorSub => 'වෙළඳසැලෙන් පිළිතුරක් නැත.';

  @override
  String get ctaTryAgain => 'නැවත උත්සාහ කරන්න';

  @override
  String get plansErrorCaption => 'කිසිදු ගාස්තුවක් අය වුණේ නැත.';

  @override
  String get ctaKeepMax => 'Premium රඳවා ගන්න';

  @override
  String get winbackSkip => 'මඟ හරින්න';

  @override
  String get winbackTitle => 'ඔබේ Premium සැලසුම අවසන් විය';

  @override
  String get winbackSub => 'ඔබ දැන් Free හි — දිනකට ඇමතුම් මිනිත්තු 5.';

  @override
  String get winbackQuestion => 'ඇයි ගියේ කියා කියනවාද?';

  @override
  String get winbackReasonExpensive => 'මිල වැඩියි';

  @override
  String get winbackReasonUnused => 'ප්‍රමාණවත්ව භාවිත කළේ නැත';

  @override
  String get winbackReasonMissing => 'අවශ්‍ය විශේෂාංගයක් නැත';

  @override
  String get winbackReasonOtherApp => 'වෙනත් යෙදුමක් හමු විය';

  @override
  String get winbackReasonElse => 'වෙනත් හේතුවක්';

  @override
  String get ctaSend => 'යවන්න';

  @override
  String get ctaNotNow => 'දැන් නොවේ';

  @override
  String get winbackCaption =>
      'මෙයින් සැලසුම යළි නොලැබේ. වෙළඳසැලේ නැවත දායක වන්න.';

  @override
  String get ctaContinue => 'ඉදිරියට';

  @override
  String get ctaClose => 'වසන්න';

  @override
  String get ovRestoreSuccessTitle => 'Premium නැවත ලැබුණා';

  @override
  String get ovRestoreSuccessBody =>
      'ඔබේ දායකත්වය සොයාගෙන මෙම උපාංගයේ නැවත සක්‍රිය කළා.';

  @override
  String get ovRestoreEmptyTitle => 'යළි ලබාගත හැකි දෙයක් නැත';

  @override
  String get ovRestoreEmptyBody =>
      'මෙම වෙළඳසැල් ගිණුමට සම්බන්ධ සක්‍රිය දායකත්වයක් නැත.';

  @override
  String get ovRestoreOtherTitle => 'එම සැලසුම වෙනත් ගිණුමකට අයත්';

  @override
  String get ovRestoreOtherBody =>
      'මෙම දායකත්වය වෙනත් BeaverTalk ගිණුමක දැනටමත් සක්‍රියයි.';

  @override
  String get ctaSignInThatAccount => 'එම ගිණුමට පිවිසෙන්න';

  @override
  String get ctaGetHelp => 'උදව් ලබාගන්න';

  @override
  String get ovCharacterOfferTitle => 'Premium ට තවම සූදානම් නැද්ද?';

  @override
  String get ovCharacterOfferBody =>
      'එක් චරිතයක් තෝරාගෙන සදහටම තබාගන්න. තනි මිලදී ගැනීමක් — දායකත්වයක් නැත, අලුත් වීමක් නැත.';

  @override
  String get rowOneCharacter => 'එක් චරිතයක්';

  @override
  String rowFromPrice(String price) {
    return 'එකකට $price';
  }

  @override
  String get rowYoursForever => 'සදහටම ඔබේ';

  @override
  String get rowNoRenewal => 'අලුත් වීමක් නැත';

  @override
  String get rowWorksOnFree => 'Free හිද ක්‍රියා කරයි';

  @override
  String get rowYes => 'ඔව්';

  @override
  String get ctaSeeCharacters => 'චරිත බලන්න';

  @override
  String get ovNotEligibleTitle => 'අවලංගු කළ හැකි දෙයක් නැත';

  @override
  String get ovNotEligibleBody =>
      'ඔබ Free හි සිටී. මෙම ගිණුමේ සක්‍රිය දායකත්වයක් නැත.';

  @override
  String get ovCancelDownsellTitle => 'යාමට පෙර';

  @override
  String get ovCancelDownsellBody =>
      'අවලංගු කිරීම වෙළඳසැලේ සිදුවේ. දැනගත යුතු කරුණු දෙකක්.';

  @override
  String get rowPayYearlyInstead => 'ඒ වෙනුවට වාර්ෂිකව ගෙවන්න';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'මසකට $price';
  }

  @override
  String get rowCharactersYouBought => 'ඔබ මිලදී ගත් චරිත';

  @override
  String get rowProRunsUntil => 'Premium අවසන් දිනය';

  @override
  String get ctaSwitchToYearly => 'වාර්ෂිකයට මාරු වන්න';

  @override
  String get ctaContinueToStore => 'වෙළඳසැල වෙත ඉදිරියට';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'වාර්ෂිකව ගෙවා $savedක් ඉතිරි කරන්න';
  }

  @override
  String get ovAnnualSwitchBody =>
      'මාසිකව ගෙවීමට වඩා වාර්ෂික සැලැස්ම ලාභදායී වේ.';

  @override
  String get rowYouSave => 'ඔබේ ඉතිරිය';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'වාර්ෂික';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'මාසිකව, වසරකට';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'මාසිකයට මාරු වන්න';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'ඔබේ වාර්ෂික සැලසුම $date දක්වා ක්‍රියාත්මකයි. පසුදා සිට මාසික අය කිරීම ආරම්භ වේ.';
  }

  @override
  String get rowMonthlyBillingStarts => 'මාසික අය කිරීම ආරම්භය';

  @override
  String get rowMonthlyLabel => 'මාසික';

  @override
  String get rowYearlyWorkedOut => 'වාර්ෂිකව ගණනය කළ විට';

  @override
  String get ctaSwitchToMonthly => 'මාසිකයට මාරු වන්න';

  @override
  String get ovRefundHelpTitle => 'මුදල් ආපසු දීම වෙළඳසැල මගින්';

  @override
  String get ovRefundHelpBody =>
      'අපට කෙලින්ම මුදල් ආපසු දිය නොහැක. සෑම ඉල්ලීමක්ම වෙළඳසැල සමාලෝචනය කරයි.';

  @override
  String get ctaGoToStore => 'වෙළඳසැලට යන්න';

  @override
  String get ovTrialEndingTitle => 'ඔබේ අත්හදා බැලීම හෙට අවසන්';

  @override
  String get ovTrialEndingBody =>
      'අවලංගු නොකළොත් Premium දිගටම ක්‍රියාත්මකයි. සිදුවන දේ මෙන්න.';

  @override
  String get rowTrialEnds => 'අත්හදා බැලීම අවසන්';

  @override
  String get rowFirstCharge => 'පළමු අය කිරීම';

  @override
  String get rowThenMonthly => 'පසුව මාසිකව';

  @override
  String get ctaCancelInStore => 'වෙළඳසැලේ අවලංගු කරන්න';

  @override
  String get ovTrialStartTitle => 'දින 7ක Premium, නොමිලේ';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date දක්වා නොමිලේ. පසුව මසකට $price, වෙළඳසැලේ අවලංගු නොකළොත්.';
  }

  @override
  String get ctaStart7Days => 'දින 7 නොමිලේ අරඹන්න';

  @override
  String get ovOtoTitle => 'ආරම්භයට පෙර තව එක් දෙයක්';

  @override
  String get ovOtoBody =>
      'හොඳ තේරීමක්. වාර්ෂිකව ගෙවුවහොත් එම Premium අඩු මිලකට ලැබේ.';

  @override
  String get ovFailedDeclinedTitle => 'ඔබේ කාඩ්පත ප්‍රතික්ෂේප විය';

  @override
  String get ovFailedDeclinedBody =>
      'වෙළඳසැලට ගෙවීම ලබාගත නොහැකි විය. කිසිදු ගාස්තුවක් අය වුණේ නැත.';

  @override
  String get ctaUpdatePaymentMethod => 'ගෙවීම් ක්‍රමය යාවත්කාලීන කරන්න';

  @override
  String get ovFailedCanceledTitle => 'ගෙවීම අවලංගු විය';

  @override
  String get ovFailedCanceledBody =>
      'ඔබ තවමත් Free හි. කිසිදු ගාස්තුවක් අය වුණේ නැත.';

  @override
  String get ovFailedStoreTitle => 'යමක් වැරදුණා';

  @override
  String get ovFailedStoreBody =>
      'වෙළඳසැල වෙත සම්බන්ධ විය නොහැකි විය. කිසිදු ගාස්තුවක් අය වුණේ නැත.';

  @override
  String get ovAlreadyTitle => 'ඔබ දැනටමත් Premium හි';

  @override
  String get ovAlreadyBody =>
      'මෙම වෙළඳසැල් ගිණුමේ සක්‍රිය සැලසුමක් ඇත. මිලදී ගත යුතු දෙයක් නැත.';

  @override
  String get ctaSeeMySubscription => 'මගේ දායකත්වය බලන්න';

  @override
  String get subCancelTitle => 'දායකත්වය අවලංගු කරන්න';

  @override
  String subCancelBody(String date) {
    return 'Premium $date දක්වා ක්‍රියාත්මකයි. පසුව Free වෙත මාරු වේ.';
  }

  @override
  String get subWhatYouLose => 'ඔබට අහිමි වන දේ';

  @override
  String get benefitScoring => 'අකුරින් අකුර උච්චාරණ ලකුණු';

  @override
  String get benefitEveryMetric => 'සෑම මිනුමක්ම, සෑම වාක්‍යයක්ම';

  @override
  String get subPaymentTitle => 'ගෙවීම යාවත්කාලීන කරන්න';

  @override
  String get subPaymentBody =>
      'ගෙවීම ලබාගත නොහැකි විය. සහන කාලය තුළ Premium දිගටම ක්‍රියාත්මකයි.';

  @override
  String get subHowToFix => 'නිවැරදි කරන ආකාරය';

  @override
  String get fixStep1 => 'වෙළඳසැල විවෘත කර ගෙවීම් ක්‍රමය යාවත්කාලීන කරන්න';

  @override
  String get fixStep2 => 'ආපසු එන්න — ඔබේ සැලසුම ස්වයංක්‍රීයව යළි ඇරඹේ';

  @override
  String get fixStep3 => 'කිසිවක් දෙවරක් අය නොවේ';

  @override
  String get subResubTitle => 'නැවත දායක වන්න';

  @override
  String subResubBody(String date) {
    return 'Premium $date අවසන් වේ. ස්වයංක්‍රීය අලුත් වීම නැවත සක්‍රිය කළොත් කිසිවක් වෙනස් නොවේ.';
  }

  @override
  String get subWhatYouKeep => 'ඔබ ළඟ ඉතිරි වන දේ';

  @override
  String get ctaTurnItBackOn => 'නැවත සක්‍රිය කරන්න';

  @override
  String get flTodayTitle => 'අද ඇමතුම් කාලය අවසන්';

  @override
  String get flTodayBody => 'නැවතුණු තැනින්ම — දැන්ම.';

  @override
  String get flCheckTitle => 'අද පරීක්ෂාව එයයි';

  @override
  String get flCheckBody =>
      'Free හි දිනකට එක් පරීක්ෂාවක් ඇත. Premium සම්පූර්ණ විශ්ලේෂණය ලබා දෙයි.';

  @override
  String flCaption(String price) {
    return 'මසකට $price · ඕනෑම විටෙක අවලංගු කරන්න';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limitන් $usedක් භාවිත කර ඇත';
  }

  @override
  String get ctaMaybeTomorrow => 'හෙට බලමු';

  @override
  String get accountSection => 'ගිණුම';

  @override
  String get nicknameLabel => 'අන්වර්ථ නාමය';

  @override
  String get emailLabel => 'ඊමේල්';

  @override
  String get loginMethodLabel => 'පිවිසුම් ක්‍රමය';

  @override
  String get joinedLabel => 'එක් වූ දිනය';

  @override
  String get editNicknameTitle => 'අන්වර්ථ නාමය සංස්කරණය';

  @override
  String get nicknameRule => 'අකුරු 2–12. ඉංග්‍රීසි අකුරු සහ ඉලක්කම් පමණි.';

  @override
  String get ctaSave => 'සුරකින්න';

  @override
  String get subscriptionRow => 'දායකත්වය';

  @override
  String get iapSuccessTitle => 'මිලදී ගැනීම සම්පූර්ණයි';

  @override
  String iapSuccessBody(String name) {
    return '$name අවතාරය සදහටම ඔබේ.\nරිසිට්පත තහවුරු වූ වහාම යෙදේ.';
  }

  @override
  String get ctaGoHome => 'මුල් පිටුවට';

  @override
  String get ctaUseNow => 'දැන් භාවිත කරන්න';

  @override
  String get iapFailTitle => 'ගෙවීම සම්පූර්ණ නොවීය';

  @override
  String get iapFailBody => 'ඔබට නැවත උත්සාහ කළ හැක';

  @override
  String get paywallGuardTitle => 'ඔබට Free දිගටම භාවිත කළ හැක';

  @override
  String get paywallGuardBody => 'දිනකට ඇමතුම් මිනිත්තු 5 තවමත් ලැබේ.';

  @override
  String get ctaMaybeLater => 'පසුව';

  @override
  String get iapCharacterSuccessTitle => 'අලුත් මිතුරෙක් එක්වුණා!';

  @override
  String get iapCharacterSuccessBody =>
      'මෙම චරිතය සදහටම ඔබේ ය — සැලැස්ම වෙනස් වුවත් රැඳේ, මිලදී ගැනීම් ප්‍රතිසාධනයෙන් ඕනෑම උපාංගයක නැවත ලැබේ.';

  @override
  String get iapCharacterFailedBody =>
      'මිලදී ගැනීම සම්පූර්ණ නොවීය. මුදල් අය නොවුණි — නැවත උත්සාහ කරන්න.';

  @override
  String get noAccentDataTitle => 'තවම ස්වර දත්ත නැත';

  @override
  String get noAccentDataBody => 'කතා කරමින් සිටින්න, ඔබේ ස්වර ලක්ෂණ එකතු වේ.';

  @override
  String get noLevelYetTitle => 'තවම මට්ටමක් නැත';

  @override
  String get noLevelYetBody => 'පළමු ඇමතුම අවසන් කර ඔබේ මට්ටම ලබා ගන්න.';

  @override
  String get noPronunciationDataTitle => 'තවම උච්චාරණ වාර්තා නැත';

  @override
  String get noPronunciationDataBody =>
      'ඇමතුමේදී ඔබ කී වාක්‍ය අනුව උච්චාරණය විශ්ලේෂණය කරමු.';

  @override
  String get noCharacterNote => 'තවම තැබූ පණිවිඩයක් නැත';

  @override
  String get noPhonemesYet => 'විශ්ලේෂණය කිරීමට තවම ශබ්ද නැත';

  @override
  String get noSentencesYet => 'විශ්ලේෂණය කිරීමට තවම වාක්‍ය නැත';

  @override
  String get takeLevelTest => 'මට්ටම් පරීක්ෂණය කරන්න';

  @override
  String get playAgain => 'නැවත සෙල්ලම් කරන්න';

  @override
  String get difficultySlow => 'සෙමින්';

  @override
  String get difficultyNormal => 'සාමාන්‍ය';

  @override
  String get difficultyFast => 'වේගයෙන්';

  @override
  String get difficultyLabel => 'දුෂ්කරතාව';

  @override
  String get connected => 'සම්බන්ධයි';

  @override
  String get unlockedWithMax => 'ඔබේ සැලැස්මට ඇතුළත්';

  @override
  String get fcEndedTitle => 'ඔබේ නොමිලේ ඇමතුම අවසන් විය';

  @override
  String get fcEndedBody =>
      'නොමිලේ ඇමතුම් විනාඩි 5ක් දක්වා පවතී\nවැඩි වේලාවක් කතා කිරීමට දායක වන්න';

  @override
  String get ctaSubscribeKeepTalking => 'දායක වී කතාව දිගටම කරගෙන යන්න';

  @override
  String get kgTitle => 'දිගටම කරගෙන යමුද?';

  @override
  String get kgBody => 'ඇමතුම් කෙටි කොටස් ලෙස දිගටම යයි.\nසෑම වරම නැවත අසමු.';

  @override
  String get pcEndedTitleToday => 'අද ඇමතුම මෙතැනින් නවත්වමු.';

  @override
  String get pcEndedBodyToday =>
      'අපි කතා කළ දේ පුනරීක්ෂණය කර, හෙට නැවත අමතන්න!';

  @override
  String get pcEndedTitle => 'මෙම ඇමතුම මෙතැනින් නවත්වමු.';

  @override
  String get pcEndedBody => 'අපි කතා කළ දේ පුනරීක්ෂණය කර, නැවත අමතන්න!';

  @override
  String get ctaKeepTalking => 'කතාව දිගටම කරගෙන යන්න';

  @override
  String get callModeSheetTitle => 'ඔබට කෙසේ කතා කරන්න ඕනද?';

  @override
  String get callModeSheetSubtitle => 'මෙම ඇමතුමට වහාම අදාළ වේ';

  @override
  String get callModeFreeTalk => 'නිදහස් කතාබහ';

  @override
  String get callModeFreeTalkDesc => 'නිවැරදි කිරීමකින් තොරව කතා කරන්න';

  @override
  String get callModeStudy => 'ඉගෙනීම';

  @override
  String get callModeStudyDesc => 'එක් ප්‍රකාශනයක් බැගින් ඉගෙන ගන්න';

  @override
  String get callModeChange => 'ආකාරය වෙනස් කරන්න';

  @override
  String get callModeKeep => 'දැන් නොවේ';

  @override
  String get callExitTitle => 'ඇමතුම අවසන් කරන්නද?';

  @override
  String get callExitSubtitle => 'දැන් අවසන් කළත්, කතා කළ කාලය අද භාවිතයට ගැනේ';

  @override
  String get callExitKeep => 'කතා කරමින් සිටින්න';

  @override
  String get callExitConfirm => 'ඇමතුම අවසන් කරන්න';

  @override
  String get callMicMute => 'නිශ්ශබ්ද';

  @override
  String get callMicUnmute => 'නිශ්ශබ්දතාව ඉවත් කරන්න';

  @override
  String get callPushToTalk => 'කතා කිරීමට තද කර තබන්න';

  @override
  String get callFreeEndedTitle => 'ඔබේ නොමිලේ ඇමතුම අවසන් විය';

  @override
  String get callFreeEndedCta => 'දායක වී කතාබහ දිගටම කරන්න';

  @override
  String get callKeepGoingTitle => 'දිගටම කරන්නද?';

  @override
  String get callKeepGoingSubtitle =>
      'ඇමතුම් මිනිත්තු 5 බැගින් දිගටම යයි. සෑම වතාවකම නැවත අසන්නෙමු.';

  @override
  String get articulationSelectedWord => 'තෝරාගත් වචනය';

  @override
  String get articulationYouSaid => 'ඔබේ උච්චාරණය';

  @override
  String get articulationTargetSound => 'ඉලක්කය';

  @override
  String get reportEntry => 'වාර්තා කරන්න';

  @override
  String get reportTitle => 'වාර්තාව';

  @override
  String get reportPrompt => 'ගැටලුව කුමක්ද?';

  @override
  String get reportGuide =>
      'AI චරිතයේ කුමන දෙයක් ඔබට අපහසුතාවක් ඇති කළේද කියා කියන්න. අපි සෑම වාර්තාවක්ම සමාලෝචනය කරමු.';

  @override
  String get reportReasonSexual => 'ලිංගික අන්තර්ගතය';

  @override
  String get reportReasonHate => 'වෛරය හෝ වෙනස්කම්';

  @override
  String get reportReasonViolence => 'ප්‍රචණ්ඩ හෝ තර්ජනාත්මක අන්තර්ගතය';

  @override
  String get reportReasonSelfHarm => 'සිය-හානියට දිරිගැන්වීම';

  @override
  String get reportReasonMisinfo => 'වැරදි තොරතුරු';

  @override
  String get reportReasonOther => 'වෙනත් ගැටලුවක්';

  @override
  String get reportDetailHint => 'සිදු වූ දේ ලියන්න (විකල්ප)';

  @override
  String get reportSubmit => 'වාර්තාව යවන්න';

  @override
  String get reportDoneTitle => 'ඔබේ වාර්තාව ලැබුණා';

  @override
  String get reportDoneBody =>
      'අපි එය සමාලෝචනය කර අවශ්‍ය නම් පියවර ගන්නෙමු. BeaverTalk ආරක්ෂිතව තබා ගැනීමට උදව් කිරීම ගැන ස්තූතියි.';

  @override
  String get reportFailed => 'වාර්තාව යැවීමට නොහැකි විය. නැවත උත්සාහ කරන්න.';

  @override
  String get hwTitle => 'ගෙදර වැඩ';

  @override
  String get hwJoinCodeTitle => 'ඔබේ පන්ති කේතය ඇතුළු කරන්න';

  @override
  String get hwJoinCodeSubtitle => 'එය ඔබේ ගුරුතුමා දුන් අක්ෂර 6ක කේතයයි';

  @override
  String get hwJoinCodeLabel => 'පන්ති කේතය';

  @override
  String get hwJoinCodeHelp => 'කේතයේ ලොකු කුඩා අකුරු වෙනස නොසලකයි';

  @override
  String get hwJoinConfirmTitle => 'මෙය නිවැරදි පන්තියද?';

  @override
  String get hwJoinConfirmSubtitle => 'නොවේ නම් කේතය නැවත පරීක්ෂා කරන්න';

  @override
  String get hwJoinFieldInstitution => 'ආයතනය';

  @override
  String get hwJoinFieldTeacher => 'ගුරුවරයා';

  @override
  String get hwJoinFieldLearners => 'ඉගෙනුම්ලාභීන්';

  @override
  String get hwJoinFieldTerm => 'කාලය';

  @override
  String get hwJoinConfirmNote =>
      'පන්තියේ නම ගුරුතුමා ලියූ ආකාරයටම පෙන්වයි. අපි එය පරිවර්තනය නොකරමු.';

  @override
  String get hwJoinConfirmYes => 'ඔව්, මෙයයි';

  @override
  String get hwJoinConfirmRetry => 'කේතය නැවත ඇතුළු කරන්න';

  @override
  String get hwJoinProfileTitle => 'පන්තියේදී ඔබ භාවිත කරන නම කුමක්ද?';

  @override
  String get hwJoinProfileSubtitle => 'ගුරුතුමා එය පන්ති නාමලේඛනය සමඟ ගළපයි';

  @override
  String get hwJoinNameLabel => 'නම';

  @override
  String get hwJoinNameHelp => 'යෙදුමේ නමට වඩා වෙනස් විය හැක';

  @override
  String get hwJoinStudentNoLabel => 'ශිෂ්‍ය අංකය (අත්‍යවශ්‍ය නොවේ)';

  @override
  String get hwJoinStudentNoHelp => 'ගුරුතුමා නාමලේඛනය ගැළපීමට භාවිත කරයි';

  @override
  String get hwJoinConsentTitle => 'ගුරුතුමාට පෙනෙන දේ';

  @override
  String get hwJoinConsentSubtitle => 'පන්තියට එක්වීමට ඔබේ එකඟතාව අවශ්‍යයි';

  @override
  String get hwJoinConsentSharedHeading => 'ගුරුතුමා සමඟ බෙදාගනී';

  @override
  String get hwJoinConsentShared1 => 'පන්තියේ නම සහ ශිෂ්‍ය අංකය';

  @override
  String get hwJoinConsentShared2 => 'ඔබ ගෙදර වැඩ කළාද යන්න';

  @override
  String get hwJoinConsentShared3 => 'සමත් වූ සහ මඟහැරුණු වාක්‍ය';

  @override
  String get hwJoinConsentShared4 => 'පැවරුම් ඇමතුමේ දිග සහ සාරාංශය';

  @override
  String get hwJoinConsentNotSharedHeading => 'බෙදා නොගනී';

  @override
  String get hwJoinConsentNotShared1 => 'ඊමේල් සහ දුරකථන අංකය';

  @override
  String get hwJoinConsentNotShared2 => 'යෙදුමේ නම, පැතිකඩ සහ චරිතය';

  @override
  String get hwJoinConsentNotShared3 => 'ජාතිකත්වය සහ මව් භාෂාව';

  @override
  String get hwJoinConsentNotShared4 => 'පන්තියෙන් පිටත ඇමතුම් සහ ඉගෙනීම';

  @override
  String get hwJoinConsentNotShared5 => 'දායකත්ව සහ ගෙවීම් තොරතුරු';

  @override
  String get hwJoinConsentAgree => 'ඉහත සඳහන් දෑට මම එකඟයි';

  @override
  String get hwJoinConsentCta => 'එකඟ වී එක්වන්න';

  @override
  String hwJoinDoneTitle(String className) {
    return 'ඔබ $className වෙත එක් වී ඇත';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'පැවරුම් $countක් බලා සිටී';
  }

  @override
  String get hwJoinDoneNoAssignment => 'තවම පැවරුම් නැත';

  @override
  String get hwJoinDoneNextDue => 'ඊළඟ නියමිත දිනය';

  @override
  String get hwJoinDoneRosterName => 'පන්තියේ ඔබේ නම';

  @override
  String get hwJoinDoneCta => 'ගෙදර වැඩ බලන්න';

  @override
  String get hwJoinErrorNotFound => 'එම කේතය හමු නොවීය';

  @override
  String get hwJoinErrorNotFoundBody => 'කරුණාකර අංක හය නැවත පරීක්ෂා කරන්න.';

  @override
  String get hwJoinErrorExpired => 'එම කේතය කල් ඉකුත් වී ඇත';

  @override
  String get hwJoinErrorExpiredBody => 'ගුරුතුමාගෙන් නව කේතයක් ඉල්ලන්න.';

  @override
  String get hwJoinErrorFull => 'පන්තිය පිරී ඇත';

  @override
  String get hwJoinErrorFullBody => 'කරුණාකර ගුරුතුමාට දන්වන්න.';

  @override
  String get hwJoinFailed => 'එක්විය නොහැකි විය. මොහොතකින් නැවත උත්සාහ කරන්න.';

  @override
  String get hwSectionInProgress => 'ක්‍රියාත්මකයි';

  @override
  String get hwSectionUpcoming => 'ඉදිරියේ';

  @override
  String get hwSectionDone => 'අවසන්';

  @override
  String get hwLeaveClassLink => 'පන්තියෙන් ඉවත් වන්න';

  @override
  String get hwListEmptyTitle => 'තවම ගෙදර වැඩ නැත';

  @override
  String get hwListEmptyBody => 'ගුරුතුමා ලබා දුන් විට මෙහි පෙන්වයි.';

  @override
  String get hwListFailed => 'ඔබේ ගෙදර වැඩ පූරණය කළ නොහැකි විය.';

  @override
  String get hwRetry => 'නැවත උත්සාහ කරන්න';

  @override
  String get hwBadgeDone => 'අවසන්';

  @override
  String get hwBadgeOverdue => 'ඉදිරිපත් කර නැත';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'ඉදිරිපත් කර නැත, දින $daysක් ප්‍රමාදයි';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'අද නියමිතයි';

  @override
  String get hwActivitySpeaking => 'කථනය';

  @override
  String get hwActivityConversation => 'සංවාදය';

  @override
  String get hwActivityWorkbook => 'අභ්‍යාස පොත';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter පරිච්ඡේදය';
  }

  @override
  String get hwTaskSpeakingDesc => 'ඔබේ උච්චාරණ ලකුණු පරීක්ෂා කරන්න';

  @override
  String get hwTaskConversationDesc => 'ඉගෙන ගත් දේ සැබෑ සංවාදයක භාවිත කරන්න';

  @override
  String get hwConversationOnce => 'සංවාදය එක් ගෙදර වැඩක් සඳහා එක් වරක් පමණි.';

  @override
  String get hwTaskWorkbookDesc => 'අභ්‍යාස පොතේ ලියමින් පුහුණු වන්න';

  @override
  String get hwCtaStudy => 'අරඹන්න';

  @override
  String get hwCtaResult => 'ප්‍රතිඵලය බලන්න';

  @override
  String get hwCtaDownload => 'බාගන්න';

  @override
  String get hwSpeakingNoScore => 'ඔබ තවම කථන කාර්යය කර නැත';

  @override
  String get hwWorkbookUnavailable => 'අභ්‍යාස පොතේ ගොනුව තවම නොමැත.';

  @override
  String get hwDetailClosed => 'මෙම පැවරුම වසා ඇත. තවදුරටත් ඉදිරිපත් කළ නොහැක.';

  @override
  String get hwLeaveTitle => 'පන්තියෙන් ඉවත් වන්නද?';

  @override
  String get hwLeaveBody =>
      'ඔබේ ගුරුතුමා තවදුරටත් ඔබේ ගෙදර වැඩ ප්‍රතිඵල නොදකියි.';

  @override
  String get hwLeaveConfirm => 'ඉවත් වන්න';

  @override
  String get hwLeaveCancel => 'රැඳී සිටින්න';

  @override
  String get hwLeaveFailed => 'පන්තියෙන් ඉවත් විය නොහැකි විය.';

  @override
  String get hwMyClass => 'මගේ පන්තිය';

  @override
  String get hwClassEmptyTitle => 'ඔබ කිසිදු පන්තියකට එක් වී නැත';

  @override
  String get hwClassEmptySubtitle => 'ගුරුතුමා දුන් කේතය ඇතුළු කරන්න';

  @override
  String get hwClassEmptyCta => 'පන්ති කේතය ඇතුළු කරන්න';

  @override
  String get hwClassContinueCta => 'දිගටම';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return 'පැවරුම් $countක් හෙට නියමිතයි';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'ඔබට ඉදිරිපත් නොකළ පැවරුම් $countක් තිබේ';
  }

  @override
  String get hwSpeakingUnavailable => 'මෙම පැවරුමේ වාක්‍ය තවම නොමැත.';

  @override
  String get hwBadgeClosed => 'වසා ඇත';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return 'වාක්‍ය $totalන් $passedක් සමත්';
  }

  @override
  String get challengeFirstWord => 'පළමු වචනය';

  @override
  String get challengeSeeAnalysis => 'ප්‍රතිඵල බලන්න';

  @override
  String get challengePaused => 'විරාම කර ඇත';

  @override
  String get challengePausedNote => 'කාල ගණකය සහ පටිගත කිරීම එකට නැවතුණි.';

  @override
  String get challengeTimeLeft => 'ඉතිරි කාලය';

  @override
  String get challengeScoreLabel => 'ලකුණු';

  @override
  String get challengeResume => 'දිගටම කරන්න';

  @override
  String get challengeBlockedTitle => 'කැමරාව භාවිත කළ නොහැක';

  @override
  String get challengeBlockedNote =>
      'සැකසුම් තුළ කැමරා සහ මයික් අවසරය සක්‍රීය කරන්න.';

  @override
  String get challengeGoBack => 'ආපසු';

  @override
  String get challengeOpenSettings => 'සැකසුම් විවෘත කරන්න';

  @override
  String get saveDone => 'ගැලරියට සුරැකිණි';

  @override
  String get saveFailed => 'සුරැකීමට නොහැකි විය';

  @override
  String get saveDeniedNote => 'ඡායාරූප වෙත ප්‍රවේශය අවශ්‍යයි';

  @override
  String get callIncomingCallerFallback => 'Beaver ගුරු';

  @override
  String get callIncomingHandle => 'කොරියානු ඇමතුම';

  @override
  String get callMissedTitle => 'මඟ හැරුණු ඇමතුම';

  @override
  String get callMissedChannelDescription =>
      'Beaver ගෙන් මඟ හැරුණු ඇමතුම් ගැන දැනුම් දෙයි.';

  @override
  String callMissedBody(String name) {
    return '$name ඔබට ඇමතුමක් දුන්නා';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'ඇමතුම් ලබා ගැනීමට දැනුම්දීම් අවසරය අවශ්‍යයි.';

  @override
  String get callNotifPermissionRequired =>
      'සැකසුම් තුළ දැනුම්දීම්වලට අවසර දෙන්න.';

  @override
  String get callHintLockedTitle => 'ඉගෙනීම් ප්‍රකාරයේදී ඉඟි භාවිත කළ නොහැක';

  @override
  String get wsTitle => 'දුර්වල ශබ්ද';

  @override
  String get wsToList => 'ලැයිස්තුවට';

  @override
  String get wsNext => 'ඊළඟ';

  @override
  String get wsRetry => 'නැවත උත්සාහ කරන්න';

  @override
  String get wsDone => 'නිමයි';

  @override
  String get wsContinue => 'දිගටම කරන්න';

  @override
  String get wsQuit => 'ඉවත් වන්න';

  @override
  String get wsRetryLater => 'මොහොතකින් නැවත උත්සාහ කරන්න.';

  @override
  String get wsMissingTitle => 'ඒ ශබ්දය හමු නොවිණි';

  @override
  String get wsMissingBody => 'ලැයිස්තුවෙන් නැවත තෝරන්න.';

  @override
  String get wsListLoadFailed => 'ලැයිස්තුව පූරණය කළ නොහැකි විය';

  @override
  String get wsLessonLoadFailed => 'පාඩම පූරණය කළ නොහැකි විය';

  @override
  String get wsNationalTitle => 'ඔබේ උච්චාරණ රටාවට දුර්වල ශබ්ද';

  @override
  String get wsNationalPending => 'උච්චාරණ රටාව විශ්ලේෂණය වූ පසු මෙය පිරෙයි';

  @override
  String get wsNationalPicked => 'ඔබේ උච්චාරණ විශ්ලේෂණයෙන් තෝරා ගත්තා';

  @override
  String get wsNationalEmptyBody =>
      'ඇමතුම් කිහිපයක් තව ගන්න, ඔබේ උච්චාරණය විශ්ලේෂණය කර දෙන්නම්.';

  @override
  String get wsMineTitle => 'මගේ දුර්වල ශබ්ද';

  @override
  String get wsMineSubtitle => 'මෑතක ලකුණු අඩුම ශබ්ද';

  @override
  String get wsMineEmptyBody =>
      'ඇමතුම් ගෙන පුනරීක්ෂණය කළොත් දුර්වල ශබ්ද එකතු වේ.';

  @override
  String get wsNoDataYet => 'තවම දත්ත නැත';

  @override
  String get wsGoToCall => 'ඇමතුමක් අරඹන්න';

  @override
  String get wsRule => 'රීතිය';

  @override
  String get wsRecommended => 'නිර්දේශිත';

  @override
  String get wsNotMeasured => 'මැනුම් නැත';

  @override
  String get wsStepUnderstand => 'තේරුම';

  @override
  String get wsStepWords => 'වචන';

  @override
  String get wsStepSentence => 'වාක්‍යය';

  @override
  String get wsStepTest => 'ඇගයීම';

  @override
  String get wsQuitTitle => 'පුහුණුව නවත්වන්නද?';

  @override
  String get wsQuitBody => 'දැන් ඉවත් වුණොත් මෙම පුහුණුව සුරැකෙන්නේ නැත.';

  @override
  String get wsHowToSound => 'ශබ්දය උච්චාරණය කරන ආකාරය';

  @override
  String get wsPracticeWords => 'වචන පුහුණු වන්න';

  @override
  String get wsPracticeSentence => 'වාක්‍යය පුහුණු වන්න';

  @override
  String get wsPracticeAgain => 'තවත් වරක්';

  @override
  String get wsStartTest => 'අවසන් ඇගයීම කරන්න';

  @override
  String get wsThisSentence => 'මෙම වාක්‍යය';

  @override
  String get wsNoScoreNote => 'මෙම පියවරට ලකුණු නැත. නිදහසේ අනුව කියන්න.';

  @override
  String get wsListen => 'හොඳින් අහන්න';

  @override
  String get wsSayNow => 'දැන් අනුව කියන්න';

  @override
  String get wsPracticeDone => 'පුහුණුව අවසන්';

  @override
  String get wsPaused => 'විරාම කර ඇත';

  @override
  String get wsAudioFailed => 'ශබ්දය පූරණය කළ නොහැකි විය. අකුරු බලා කියන්න.';

  @override
  String get wsReadAloud => 'පහත වාක්‍යය හඬ නඟා කියවන්න';

  @override
  String get wsTapToStart => 'ඇරඹීමට තට්ටු කරන්න';

  @override
  String get wsTapWhenDone => 'අවසන් වූ විට තට්ටු කරන්න';

  @override
  String get wsScoring => 'ලකුණු දෙමින්';

  @override
  String get wsMicFailed => 'මයික්‍රොෆෝනය විවෘත කළ නොහැකි විය.';

  @override
  String get wsMicPermissionBody =>
      'මෙම පරීක්ෂණය ශබ්ද නගා කියවිය යුතු නිසා මයික්‍රෆෝනය අවශ්‍යයි. සැකසුම් තුළ මයික්‍රෆෝන ප්‍රවේශය සක්‍රිය කරන්න.';

  @override
  String get wsNoSound => 'කිසිවක් ඇහුණේ නැහැ. නැවත කියමුද?';

  @override
  String get wsScoreFailed =>
      'ලකුණු දීම අසාර්ථක විය. කරුණාකර නැවත උත්සාහ කරන්න.';

  @override
  String get wsSomethingWrong => 'ගැටලුවක් ඇති විය.';

  @override
  String get wsLearnDone => 'පාඩම අවසන්';

  @override
  String get wsRetest => 'නැවත ඇගයීම';

  @override
  String get wsFirstMeasure => 'පළමු මැනුමයි';

  @override
  String get wsFinalTest => 'අවසන් ඇගයීම';

  @override
  String wsPoints(int score) {
    return 'ලකුණු $score';
  }

  @override
  String wsBeforePoints(int score) {
    return 'පෙර ලකුණු $score';
  }

  @override
  String wsGoalPoints(int score) {
    return 'ඉලක්කය ලකුණු $score';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'ඉලක්කය · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country උච්චාරණය';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'වචන $countක් අනුව කීවා';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'කොටස් $countක් අනුව කීවා';
  }

  @override
  String get wsStartRecommended => 'නිර්දේශිත ශබ්දයෙන් පටන් ගන්න';

  @override
  String wsStartRecommendedWith(String label) {
    return '$label සිට පටන් ගන්න';
  }

  @override
  String get wsPointsUnit => 'ලකුණු';

  @override
  String get wsEnterFromMypage => 'දුර්වල ශබ්ද පුහුණු වන්න';

  @override
  String wsGoalOnly(int score) {
    return 'ඉලක්කය $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label ශබ්දය';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. ඇමතුමකදී නැවත හමු වූ විට මේ හැඩය සිහිපත් කරන්න.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country කථිකයන් බොහෝ විට වැරදි කරන ශබ්ද';
  }
}
