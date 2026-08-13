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
  String pricePerMonth(String price) {
    return '$price / මාසයකට';
  }

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
  String subscriptionSwitchNote(String date) {
    return 'ඔබට $date දක්වා Pro ප්‍රතිලාභ භාවිත කළ හැකිය, ඉන්පසු ඔබේ සැලසුම ස්වයංක්‍රීයව නොමිලේ එකට මාරු වේ.';
  }

  @override
  String get freePlanCallLimit => 'දිනකට ඇමතුම් 1 · මිනිත්තු 5 සීමාව';

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
  String get billingChangePlan => 'සැලසුම වෙනස් කරන්න';

  @override
  String get billingCompareAllPlans => 'සියලු සැලසුම් සසඳන්න';

  @override
  String get billingBuyACharacter => 'චරිතයක් මිලදී ගන්න';

  @override
  String get billingRestorePurchases => 'මිලදී ගැනීම් යළි ලබාගන්න';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max අත්හදා බැලීම';

  @override
  String get freePlanPriceLine => '\$0.00 — දිනකට එක් ඇමතුමක්';

  @override
  String pricePerMonthLine(String amount) {
    return 'මසකට $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date දක්වා නොමිලේ';
  }

  @override
  String get todaysCalls => 'අද ඇමතුම්';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limitන් $usedක් භාවිත කර ඇත';
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
  String get bannerGoUnlimitedTitle => 'Pro සමඟ අසීමිත වන්න';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'අසීමිත ඇමතුම් · එකකට විනාඩි 15 · මසකට $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max සමඟ වීඩියෝ සක්‍රිය කරන්න';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'මුහුණට මුහුණ ඇමතුම් · මසකට $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'වාර්ෂික සැලසුමට මාරු වන්න';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return 'වසරකට $yearly · මසකට $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'ගෙවීම ලබාගත නොහැකි විය';

  @override
  String get bannerPaymentFailedSub =>
      'Pro රඳවා ගැනීමට වෙළඳසැලේ ගෙවීම යාවත්කාලීන කරන්න';

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
  String get noteFairUse =>
      'අසීමිත භාවිතය අපගේ සාධාරණ භාවිත ප්‍රතිපත්තියට යටත් වේ.';

  @override
  String noteTrialEnds(String date) {
    return 'ඔබේ අත්හදා බැලීම $date අවසන් වේ. ඊට පෙර වෙළඳසැලේ අවලංගු කළොත් කිසිදු ගාස්තුවක් නැත.';
  }

  @override
  String get noteGrace =>
      'සහන කාලය පුරා ප්‍රතිලාභ ක්‍රියාත්මකයි. යෙදුම තුළ අවලංගු කිරීම කිසිවිටෙක අවහිර නොවේ.';

  @override
  String get noteHold =>
      'ගෙවීම සිදුවන තුරු Pro නවතා ඇත. ඔබේ චරිත සහ ප්‍රගතිය ආරක්ෂිතයි.';

  @override
  String noteEnding(String date) {
    return 'ඔබේ සැලසුම අවසන් වීමට නියමිතයි. $date දක්වා ප්‍රතිලාභ ක්‍රියාත්මකයි, පසුව Free වෙත මාරු වේ. ඕනෑම විටෙක නැවත දායක විය හැක.';
  }

  @override
  String get trialExpiredTitle => 'ඔබේ Max අත්හදා බැලීම අවසන් විය';

  @override
  String get trialExpiredSub => 'ඔබ දැන් Free හි සිටී';

  @override
  String get seePlans => 'සැලසුම් බලන්න';

  @override
  String get currentPlanTitle => 'වත්මන් සැලසුම';

  @override
  String get badgeRecommended => 'නිර්දේශිත';

  @override
  String get perMonthUnit => 'මසකට';

  @override
  String get planTaglinePro => 'අසීමිත ඇමතුම්. එකකට විනාඩි 15.';

  @override
  String get planTaglineMax => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String get planTaglineFree => 'දිනකට එක් ඇමතුමක්. නොමිලේ.';

  @override
  String get bulletProCalls => 'කැමති තරම් හඬ ඇමතුම්';

  @override
  String get bulletProLength => 'ඇමතුමකට විනාඩි 15';

  @override
  String get bulletProScoring => 'අකුරින් අකුර උච්චාරණ ලකුණු';

  @override
  String get bulletProCorrections => 'ඔබේ මව්බස ඉලක්ක කළ නිවැරදි කිරීම්';

  @override
  String get bulletProBeaverCalls => 'Beaver ඔබට මුලින්ම අමතයි';

  @override
  String get bulletMaxVideo => 'මුහුණට මුහුණ වීඩියෝ ඇමතුම්';

  @override
  String get bulletMaxEverything => 'Pro හි සියල්ල';

  @override
  String get bulletMaxCharacters => 'සියලු චරිත, අසීමිත';

  @override
  String get bulletMaxStudyBook => 'ඔබේ මට්ටමට ගැළපෙන පාඩම් පොතක්';

  @override
  String get bulletMaxWeeklyReport =>
      'ඔබේ උච්චාරණය වෙනස් වන අයුරු ගැන සතිපතා වාර්තාවක්';

  @override
  String get bulletFreeCall => 'දිනකට විනාඩි 5ක හඬ ඇමතුමක්';

  @override
  String get bulletFreeCheck => 'දිනකට එක් උච්චාරණ පරීක්ෂාවක්';

  @override
  String get bulletFreeAccent => 'අසීමිත උච්චාරණ ශෛලි පරීක්ෂා';

  @override
  String get bulletFreeCharacter => 'ආරම්භයට එක් චරිතයක්';

  @override
  String get ctaGoUnlimited => 'අසීමිත වන්න';

  @override
  String get ctaTurnOnVideo => 'වීඩියෝ සක්‍රිය කරන්න';

  @override
  String get noteCallLength => 'සෑම ඇමතුමක්ම විනාඩි 15කි.';

  @override
  String get paywallProTitle1 => 'ඔබේ කොරියානු මිතුරා';

  @override
  String get paywallProTitle2 => 'පාන්දර 3ටත් අවදියෙන්';

  @override
  String get paywallProSub => 'අසීමිත ඇමතුම්. එකකට විනාඩි 15. අවුරුද්ද පුරා.';

  @override
  String get paywallLimitHeadline => 'Pro සීමාව ඉවත් කරයි.';

  @override
  String get limitBannerCallTitle => 'අද ඇමතුම එයයි';

  @override
  String get limitBannerCallSub => 'Free හි දිනකට එක් ඇමතුමක්';

  @override
  String get limitBannerCheckTitle => 'අද පරීක්ෂාව එයයි';

  @override
  String get limitBannerCheckSub => 'Free හි දිනකට එක් පරීක්ෂාවක්';

  @override
  String get bulletProCharactersForever => 'මිලදී ගත් චරිත සදහටම ඔබේමයි';

  @override
  String get paywallMaxTitle => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String get paywallMaxSub =>
      'වීඩියෝ ඇමතුම්, සියලු චරිත, සහ ඔබේ මට්ටමට සැකසූ පාඩම් පොතක්.';

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
  String get noteMaxCharacters =>
      'Max මගින් විවෘත වූ චරිත දායකත්වය සක්‍රිය අතරතුර භාවිත කළ හැක. මිලදී ගත් චරිත ඔබේම වේ.';

  @override
  String get processingTitle => 'ඔබේ මිලදී ගැනීම තහවුරු වෙමින්';

  @override
  String get processingSub => 'සාමාන්‍යයෙන් තත්පර කිහිපයක් ගතවේ.';

  @override
  String get successProTitle => 'ඔබ දැන් Pro හි.';

  @override
  String get successProSub => 'අසීමිත ඇමතුම්, මේ මොහොතේ සිටම.';

  @override
  String get successProBenefit1 => 'කැමති තරම් අමතන්න — ඇමතුමකට විනාඩි 15';

  @override
  String get successProBenefit2 => 'අසීමිත උච්චාරණ පරීක්ෂා';

  @override
  String get successProBenefit3 => 'සියලු චරිත, සමඟ තනි මිලදී ගැනීම්';

  @override
  String get successMaxTitle => 'දැන් ඔවුන්ව දැකිය හැක.';

  @override
  String get successMaxSub =>
      'වීඩියෝ ඇමතුම් සක්‍රියයි. ඕනෑම ඇමතුමක වීඩියෝ බොත්තම ඔබන්න.';

  @override
  String get successMaxBenefit1 => 'මුහුණට මුහුණ වීඩියෝ ඇමතුම්';

  @override
  String get successMaxBenefit2 => 'සියලු චරිත, අසීමිත — අලුත් ඒවා මුලින්ම';

  @override
  String get successMaxBenefit3 => 'ඔබේ මට්ටමට ගැළපෙන පාඩම් පොතක්';

  @override
  String get ctaStartACall => 'ඇමතුමක් අරඹන්න';

  @override
  String get ctaStartAVideoCall => 'වීඩියෝ ඇමතුමක් අරඹන්න';

  @override
  String get ctaSeeYourSubscription => 'ඔබේ දායකත්වය බලන්න';

  @override
  String successProCaption(String price) {
    return 'අවලංගු කරන තුරු මසකට $price අය වේ. ඕනෑම විටෙක වෙළඳසැලේ කළමනාකරණය හෝ අවලංගු කරන්න.';
  }

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
  String get changePlanTitle => 'සැලසුම වෙනස් කරන්න';

  @override
  String get moveToMaxTitle => 'Max වෙත යන්න';

  @override
  String maxPriceShort(String price) {
    return '$price / මසකට';
  }

  @override
  String get moveToMaxCardSub =>
      'මුහුණට මුහුණ වීඩියෝ ඇමතුම් · සියලු චරිත · ඔබටම සැකසූ පාඩම් පොතක්';

  @override
  String get whatHappensNow => 'දැන් සිදුවන දේ';

  @override
  String get maxStartsLabel => 'Max ආරම්භය';

  @override
  String get immediately => 'වහාම';

  @override
  String get unusedProTime => 'Pro හි ඉතිරි කාලය';

  @override
  String get creditedTowardMax => 'Max වෙත බැර වේ';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max වෙත මාරු වන්න';

  @override
  String get upgradeCaption =>
      'නව සැලසුම වහාම ආරම්භ වේ. Pro හි ඉතිරි කාලය බැර වේ, දෙවරක් අය නොවේ.';

  @override
  String get moveToProTitle => 'Pro වෙත යන්න';

  @override
  String get moveToProSub =>
      'අද කිසිවක් වෙනස් නොවේ. ගෙවූ මාසය අවසන් වන තුරු Max ක්‍රියාත්මකයි.';

  @override
  String get maxRunsUntil => 'Max අවසන් දිනය';

  @override
  String get proStarts => 'Pro ආරම්භය';

  @override
  String get whatYouKeep => 'ඔබ ළඟ ඉතිරි වන දේ';

  @override
  String get keepBenefitCalls => 'අසීමිත හඬ ඇමතුම්, එකකට විනාඩි 15';

  @override
  String get keepBenefitCharacters => 'මිලදී ගත් චරිත සදහටම ඔබේමයි';

  @override
  String downgradeWarning(String date) {
    return '$date දින වීඩියෝ ඇමතුම් සහ Max-පමණක් චරිත අක්‍රිය වේ.';
  }

  @override
  String get ctaSwitchToPro => 'Pro වෙත මාරු වන්න';

  @override
  String get ctaKeepMax => 'Max රඳවා ගන්න';

  @override
  String get winbackSkip => 'මඟ හරින්න';

  @override
  String get winbackTitle => 'ඔබේ Pro සැලසුම අවසන් විය';

  @override
  String get winbackSub => 'ඔබ දැන් Free හි — දිනකට එක් ඇමතුමක්.';

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
  String get ovRestoreSuccessTitle => 'Pro නැවත ලැබුණා';

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
  String get ovCharacterOfferTitle => 'Pro ට තවම සූදානම් නැද්ද?';

  @override
  String get ovCharacterOfferBody =>
      'එක් චරිතයක් තෝරාගෙන සදහටම තබාගන්න. තනි මිලදී ගැනීමක් — දායකත්වයක් නැත, අලුත් වීමක් නැත.';

  @override
  String get rowOneCharacter => 'එක් චරිතයක්';

  @override
  String rowFromPrice(String price) {
    return '$price සිට';
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
  String get rowProRunsUntil => 'Pro අවසන් දිනය';

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
      'ඔබ මාස දෙකක් Pro හි සිටියා. වාර්ෂික සැලසුම ලාභදායීයි.';

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
      'අවලංගු නොකළොත් Max දිගටම ක්‍රියාත්මකයි. සිදුවන දේ මෙන්න.';

  @override
  String get rowTrialEnds => 'අත්හදා බැලීම අවසන්';

  @override
  String get rowFirstCharge => 'පළමු අය කිරීම';

  @override
  String get rowThenMonthly => 'පසුව මාසිකව';

  @override
  String get ctaCancelInStore => 'වෙළඳසැලේ අවලංගු කරන්න';

  @override
  String get ovTrialStartTitle => 'දින 7ක Max, නොමිලේ';

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
      'හොඳ තීරණයක් — අසීමිත ඇමතුම් දැන් සක්‍රියයි. වාර්ෂිකව ගෙවුවොත් එම Pro ම අඩු මිලට.';

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
  String get ovAlreadyTitle => 'ඔබ දැනටමත් Pro හි';

  @override
  String get ovAlreadyBody =>
      'මෙම වෙළඳසැල් ගිණුමේ සක්‍රිය සැලසුමක් ඇත. මිලදී ගත යුතු දෙයක් නැත.';

  @override
  String get ctaSeeMySubscription => 'මගේ දායකත්වය බලන්න';

  @override
  String get subCancelTitle => 'දායකත්වය අවලංගු කරන්න';

  @override
  String subCancelBody(String date) {
    return 'Pro $date දක්වා ක්‍රියාත්මකයි. පසුව Free වෙත මාරු වේ.';
  }

  @override
  String get subWhatYouLose => 'ඔබට අහිමි වන දේ';

  @override
  String get benefitCalls15 => 'අසීමිත ඇමතුම්, එකකට විනාඩි 15';

  @override
  String get benefitScoring => 'අකුරින් අකුර උච්චාරණ ලකුණු';

  @override
  String get benefitEveryCharacter => 'සියලු චරිත, අසීමිත';

  @override
  String get ctaKeepPro => 'Pro රඳවා ගන්න';

  @override
  String get subPaymentTitle => 'ගෙවීම යාවත්කාලීන කරන්න';

  @override
  String get subPaymentBody =>
      'ගෙවීම ලබාගත නොහැකි විය. සහන කාලය තුළ Pro දිගටම ක්‍රියාත්මකයි.';

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
    return 'Pro $date අවසන් වේ. ස්වයංක්‍රීය අලුත් වීම නැවත සක්‍රිය කළොත් කිසිවක් වෙනස් නොවේ.';
  }

  @override
  String get subWhatYouKeep => 'ඔබ ළඟ ඉතිරි වන දේ';

  @override
  String get ctaTurnItBackOn => 'නැවත සක්‍රිය කරන්න';

  @override
  String get flTodayTitle => 'අද ඇමතුම එයයි';

  @override
  String get flTodayBody => 'නැවතුණු තැනින්ම — දැන්ම.';

  @override
  String get flCheckTitle => 'අද පරීක්ෂාව එයයි';

  @override
  String get flCheckBody => 'Free හි දිනකට එක් පරීක්ෂාවක්. Pro එය අසීමිත කරයි.';

  @override
  String get flBenefitCalls => 'Pro සමඟ අසීමිත ඇමතුම් · එකකට විනාඩි 15';

  @override
  String get flBenefitChecks => 'Pro සමඟ අසීමිත උච්චාරණ පරීක්ෂා';

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
  String get emailLabel => 'Email';

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
  String get paywallLeaveTitle => 'දැන් පිටව ගියොත් දායක නොවේ';

  @override
  String get paywallLeaveBody =>
      'ගෙවීමෙන් පසු වහාම ප්‍රතිලාභ විවෘත වේ. මගේ පිටුවෙන් ඕනෑම වේලාවක නැවත පැමිණිය හැක.';

  @override
  String get ctaKeepLooking => 'දිගටම බලන්න';

  @override
  String get ctaLeaveAnyway => 'කෙසේ වුවත් යන්න';

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
  String get reviewToSeeScore => 'නැවත බලා උච්චාරණ ලකුණු බලන්න';

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
}
