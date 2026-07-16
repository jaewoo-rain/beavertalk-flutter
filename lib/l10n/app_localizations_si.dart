// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'ඇමතුම අවසන් විය $duration';
  }

  @override
  String get callRatingPrompt => 'ඔබේ ඇමතුම කෙසේ වුණාද?';

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
  String get am => 'පෙ.ව.';

  @override
  String get pm => 'ප.ව.';

  @override
  String get save => 'සුරකින්න';

  @override
  String get conversation => 'සංවාදය';

  @override
  String get review => 'සමාලෝචනය';

  @override
  String get pronunciationChallenge => 'උච්චාරණ අභියෝගය';

  @override
  String get newExpressions => 'නව වචන ප්‍රකාශන';

  @override
  String get analysisResult => 'විශ්ලේෂණ ප්‍රතිඵලය';

  @override
  String get noNewExpressions => 'මෙම සංවාදයෙන් නව ප්‍රකාශන නොමැත.';

  @override
  String get practice => 'පුහුණුව';

  @override
  String recentScore(int score) {
    return 'මෑත ලකුණු $score%';
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
  String get oneFixTitle => 'Today\'s feedback';

  @override
  String streakBadge(int count) {
    return '$count calls in a row';
  }

  @override
  String newExpressionsCount(int count) {
    return 'New expressions $count';
  }

  @override
  String get analysisLoadError => 'විශ්ලේෂණ ප්‍රතිඵලය පූරණය කළ නොහැකි විය.';

  @override
  String get standardAudioNotReady => 'සම්මත උච්චාරණ ශබ්දය තවම සූදානම් නැත.';

  @override
  String get standardAudioPlayError =>
      'සම්මත උච්චාරණ ශබ්දය වාදනය කළ නොහැකි විය.';

  @override
  String get selectACountry => 'රටක් තෝරන්න';

  @override
  String get selectYourLanguage => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get confirm => 'තහවුරු කරන්න';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get selectTime => 'වේලාව තෝරන්න';

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
  String get myPage => 'මගේ පිටුව';

  @override
  String get languageSaveFailed => 'ඔබේ භාෂාව සුරැකිය නොහැකි විය.';

  @override
  String get accountDeleteFailed => 'ඔබේ ගිණුම මකා දැමිය නොහැකි විය.';

  @override
  String get changeAvatar => 'අවතාරය වෙනස් කරන්න';

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
  String get changePlan => 'සැලැස්ම වෙනස් කරන්න';

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
  String get keepUsingPro => 'Pro දිගටම භාවිතා කරන්න';

  @override
  String get proMembership => 'Pro සාමාජිකත්වය';

  @override
  String get pricePerMonth => '\$12.9 / මාසයකට';

  @override
  String get benefitUnlimitedCalls => 'අසීමිත ඇමතුම්';

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
  String get challengeLoadingNote =>
      'පළමු වතාවේ ධාවනයේදී කොරියානු කථන ආකෘතිය (~82MB) බාගත වේ.\nකරුණාකර මොහොතක් රැඳී සිටින්න.';

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
  String get callNow => 'දැන් අමතන්න';

  @override
  String get pronunciation => 'උච්චාරණය';

  @override
  String get fluency => 'චතුරතාව';

  @override
  String get rhythm => 'රිද්මය';

  @override
  String get analysisTimeout =>
      'මෙයට අපේක්ෂා කළාට වඩා වැඩි කාලයක් ගතවෙමින් තිබේ. කරුණාකර මොහොතකින් නැවත උත්සාහ කරන්න.';

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
  String get loginContinueWithKakao => 'Kakao සමඟ ඉදිරියට යන්න';

  @override
  String get loginContinueWithGoogle => 'Google සමඟ ඉදිරියට යන්න';

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
}
