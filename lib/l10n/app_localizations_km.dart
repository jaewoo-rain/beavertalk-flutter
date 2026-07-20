// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'ការហៅបានបញ្ចប់ $duration';
  }

  @override
  String get callRatingPrompt => 'តើការហៅរបស់អ្នកយ៉ាងណាដែរ?';

  @override
  String get ratingBad => 'មិនសូវល្អ';

  @override
  String get ratingOkay => 'មធ្យម';

  @override
  String get ratingGood => 'ល្អ';

  @override
  String get goHome => 'ទំព័រដើម';

  @override
  String get viewAnalysis => 'មើលការវិភាគ';

  @override
  String get loadingShort => 'កំពុងផ្ទុក…';

  @override
  String ratingSubmitFailed(String message) {
    return 'បរាជ័យក្នុងការដាក់ស្នើការវាយតម្លៃ៖ $message';
  }

  @override
  String get callInfoNotFound =>
      'រកមិនឃើញព័ត៌មានការហៅទេ ដូច្នេះនឹងរំលងការវិភាគ។';

  @override
  String get tabRecords => 'កំណត់ត្រា';

  @override
  String get tabArchive => 'ប័ណ្ណសារ';

  @override
  String get callHistory => 'ប្រវត្តិការហៅ';

  @override
  String get conversationRecord => 'កំណត់ត្រាការសន្ទនា';

  @override
  String get noCallRecords => 'មិនទាន់មានកំណត់ត្រាការហៅទេ';

  @override
  String get noCallRecordsBody =>
      'នៅពេលអ្នកបញ្ចប់ការហៅដំបូងជាមួយ AI\nកំណត់ត្រារបស់អ្នកនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get startCall => 'ចាប់ផ្ដើមការហៅ';

  @override
  String get recordsLoadError => 'មិនអាចផ្ទុកកំណត់ត្រាបានទេ';

  @override
  String get tryAgainLater => 'សូមព្យាយាមម្ដងទៀតពេលក្រោយ។';

  @override
  String get retry => 'ព្យាយាមម្ដងទៀត';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes នាទី $seconds វិនាទី';
  }

  @override
  String get scheduleManagement => 'កាលវិភាគ';

  @override
  String get alarms => 'ម៉ោងរោទ៍';

  @override
  String get addSchedule => 'បន្ថែមកាលវិភាគ';

  @override
  String get editSchedule => 'កែសម្រួលកាលវិភាគ';

  @override
  String get somethingWentWrong => 'មានបញ្ហាកើតឡើង';

  @override
  String get alarmsLoadError => 'មិនអាចផ្ទុកម៉ោងរោទ៍បានទេ';

  @override
  String get charactersLoadError => 'មិនអាចផ្ទុកតួអង្គបានទេ';

  @override
  String get noCharacters => 'មិនមានតួអង្គទេ';

  @override
  String get close => 'បិទ';

  @override
  String get repeat => 'ធ្វើម្ដងទៀត';

  @override
  String get callPartner => 'តួអង្គ';

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
  String get am => 'ព្រឹក';

  @override
  String get pm => 'ល្ងាច';

  @override
  String get save => 'រក្សាទុក';

  @override
  String get conversation => 'ការសន្ទនា';

  @override
  String get review => 'ពិនិត្យឡើងវិញ';

  @override
  String get pronunciationChallenge => 'ការប្រកួតការបញ្ចេញសំឡេង';

  @override
  String get newExpressions => 'ឃ្លាថ្មី';

  @override
  String get analysisResult => 'លទ្ធផលវិភាគ';

  @override
  String get noNewExpressions => 'មិនមានឃ្លាថ្មីពីការសន្ទនានេះទេ។';

  @override
  String get practice => 'អនុវត្ត';

  @override
  String recentScore(int score) {
    return 'ពិន្ទុថ្មីៗ $score%';
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
  String get analysisLoadError => 'មិនអាចផ្ទុកលទ្ធផលវិភាគបានទេ។';

  @override
  String get standardAudioNotReady => 'សំឡេងបញ្ចេញស្តង់ដារមិនទាន់រួចរាល់ទេ។';

  @override
  String get standardAudioPlayError => 'មិនអាចចាក់សំឡេងបញ្ចេញស្តង់ដារបានទេ។';

  @override
  String get selectACountry => 'ជ្រើសរើសប្រទេស';

  @override
  String get selectYourLanguage => 'ជ្រើសរើសភាសារបស់អ្នក';

  @override
  String get confirm => 'បញ្ជាក់';

  @override
  String get cancel => 'បោះបង់';

  @override
  String get selectTime => 'ជ្រើសរើសម៉ោង';

  @override
  String get getStarted => 'ចាប់ផ្ដើម';

  @override
  String get permissionTitle => 'អនុញ្ញាតសិទ្ធិចូលប្រើ\nសម្រាប់បទពិសោធន៍រលូន';

  @override
  String get permissionSubtitle =>
      'សិទ្ធិចាំបាច់ត្រូវការសម្រាប់ប្រើសេវាកម្មនេះ។';

  @override
  String get permissionMicTitle => 'មីក្រូហ្វូន (ចាំបាច់)';

  @override
  String get permissionMicDesc =>
      'ត្រូវការសម្រាប់និយាយជាមួយ AI ជាភាសាអង់គ្លេស។';

  @override
  String get permissionNotifTitle => 'ការជូនដំណឹង (ជាជម្រើស)';

  @override
  String get permissionNotifDesc =>
      'យើងនឹងផ្ញើការរំលឹកការសិក្សា និងកាលវិភាគហៅទូរស័ព្ទ។';

  @override
  String get micPermissionNeededTitle => 'ត្រូវការសិទ្ធិចូលប្រើមីក្រូហ្វូន';

  @override
  String get micPermissionNeededBody =>
      'ដើម្បីនិយាយជាមួយ AI អ្នកត្រូវអនុញ្ញាតសិទ្ធិចូលប្រើមីក្រូហ្វូន។ សូមបើកវានៅក្នុងការកំណត់។';

  @override
  String get openSettings => 'បើកការកំណត់';

  @override
  String get connectionFailedTitle => 'ការតភ្ជាប់បរាជ័យ';

  @override
  String get connectionFailedBody =>
      'ពិនិត្យការតភ្ជាប់បណ្តាញរបស់អ្នក\nហើយព្យាយាមម្ដងទៀត។';

  @override
  String get checkout => 'ទូទាត់ប្រាក់';

  @override
  String get pay => 'បង់ប្រាក់';

  @override
  String get orderSummary => 'សេចក្តីសង្ខេបការបញ្ជាទិញ';

  @override
  String get paymentMethod => 'វិធីបង់ប្រាក់';

  @override
  String get payMethodCard => 'កាតឥណទាន / កាតឥណពន្ធ';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'រូបតំណាង Beaver គួរឱ្យធុញ';

  @override
  String get productTrait => 'តួអង្គពិសេស · ជារបស់អ្នកជារៀងរហូត';

  @override
  String get amountItemPrice => 'តម្លៃទំនិញ';

  @override
  String get amountDiscount => 'បញ្ចុះតម្លៃ';

  @override
  String get amountTotal => 'សរុប';

  @override
  String get paymentCompleteTitle => 'បង់ប្រាក់រួចរាល់';

  @override
  String get paymentCompleteBody =>
      'រូបតំណាងត្រូវបានបន្ថែមទៅក្នុងបណ្តុំរបស់អ្នក។';

  @override
  String get viewCollection => 'មើលបណ្តុំ';

  @override
  String get receiptItem => 'ទំនិញ';

  @override
  String get receiptAmount => 'ចំនួនទឹកប្រាក់';

  @override
  String get receiptMethod => 'វិធីបង់ប្រាក់';

  @override
  String get receiptDate => 'កាលបរិច្ឆេទ';

  @override
  String get paymentFailedTitle => 'បង់ប្រាក់បរាជ័យ';

  @override
  String get paymentFailedBody =>
      'ការបង់ប្រាក់របស់អ្នកមិនអាចដំណើរការបានទេ។\nសូមព្យាយាមម្ដងទៀត។';

  @override
  String get freeCallEndingTitle => 'ការហៅឥតគិតថ្លៃរបស់អ្នកជិតបញ្ចប់';

  @override
  String get freeCallEndingBody =>
      'ជាវសមាជិកភាពដើម្បីនិយាយជាមួយ Beaver បានយូរជាងនេះ។';

  @override
  String get subscribe => 'ជាវសមាជិកភាព';

  @override
  String get endCall => 'បញ្ចប់ការហៅ';

  @override
  String get callEnded => 'ការហៅបានបញ្ចប់ហើយ។';

  @override
  String get connecting => 'កំពុងភ្ជាប់…';

  @override
  String get connectingHint => 'ជាធម្មតាចំណាយពេលតិចជាង ៥ វិនាទី';

  @override
  String get callConnectFailed => 'មិនអាចភ្ជាប់ការហៅបានទេ។';

  @override
  String get saveSentenceFailed => 'មិនអាចរក្សាទុកប្រយោគបានទេ។';

  @override
  String get recordStartFailed => 'មិនអាចចាប់ផ្ដើមថតបានទេ។';

  @override
  String get recordTooShort => 'ការថតនោះខ្លីពេក។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get gradingFailed => 'ការគិតពិន្ទុបរាជ័យ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get listenStandard => 'ស្តាប់ការបញ្ចេញសំឡេងស្តង់ដារ';

  @override
  String get saveSentence => 'រក្សាទុកប្រយោគ';

  @override
  String get unsaveSentence => 'លុបប្រយោគដែលបានរក្សាទុក';

  @override
  String get scoringPronunciation => 'កំពុងគិតពិន្ទុការបញ្ចេញសំឡេងរបស់អ្នក…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'មិនមានការថតដើម្បីចាក់ទេ។';

  @override
  String get myRecordingPlayError => 'មិនអាចចាក់ការថតរបស់អ្នកបានទេ។';

  @override
  String get next => 'បន្ទាប់';

  @override
  String get endLearning => 'បញ្ចប់វគ្គ';

  @override
  String get navCalendar => 'ប្រតិទិន';

  @override
  String get navCall => 'ហៅ';

  @override
  String get navStats => 'ស្ថិតិ';

  @override
  String get myPage => 'ទំព័ររបស់ខ្ញុំ';

  @override
  String get languageSaveFailed => 'មិនអាចរក្សាទុកភាសារបស់អ្នកបានទេ។';

  @override
  String get accountDeleteFailed => 'មិនអាចលុបគណនីរបស់អ្នកបានទេ។';

  @override
  String get changeAvatar => 'ប្តូររូបតំណាង';

  @override
  String get avatarIntro =>
      'សំឡេង និងកម្រិតលំបាកខុសគ្នាទៅតាមដៃគូការហៅ។\nដៃគូខ្លះអាចត្រូវការការបង់ប្រាក់។';

  @override
  String myPartnersOwned(int count) {
    return 'ដៃគូរបស់ខ្ញុំ · មាន $count';
  }

  @override
  String get limitedDiscount => 'បញ្ចុះតម្លៃមានកំណត់ពេល';

  @override
  String get available => 'អាចប្រើបាន';

  @override
  String get inUse => 'កំពុងប្រើ';

  @override
  String get owned => 'ជាកម្មសិទ្ធិ';

  @override
  String get noCharactersToShow => 'មិនមានតួអង្គដើម្បីបង្ហាញទេ';

  @override
  String get buy => 'ទិញ';

  @override
  String get noSavedSentences =>
      'មិនទាន់មានប្រយោគដែលបានរក្សាទុកទេ។\nសូមចំណាំប្រយោគពីកំណត់ត្រាការសន្ទនារបស់អ្នក។';

  @override
  String get noAlarms => 'មិនទាន់មានម៉ោងរោទ៍ទេ';

  @override
  String get noAlarmsBody =>
      'បន្ថែមការរំលឹកការសិក្សា\nដើម្បីបង្កើតទម្លាប់ជាប់លាប់។';

  @override
  String get subscriptionManage => 'គ្រប់គ្រងសមាជិកភាព';

  @override
  String get changePlan => 'ប្តូរគម្រោង';

  @override
  String get cancelSubscription => 'បោះបង់សមាជិកភាព';

  @override
  String get benefitsInUse => 'អត្ថប្រយោជន៍របស់អ្នក';

  @override
  String get paymentInfo => 'ព័ត៌មានបង់ប្រាក់';

  @override
  String get nextBillingDate => 'កាលបរិច្ឆេទគិតប្រាក់បន្ទាប់';

  @override
  String get lostBenefitsTitle => 'អត្ថប្រយោជន៍ដែលអ្នកនឹងបាត់បង់ប្រសិនបើបោះបង់';

  @override
  String get viewBillingHistory => 'មើលប្រវត្តិវិក្កយបត្រ';

  @override
  String get keepUsingPro => 'បន្តប្រើ Pro';

  @override
  String get proMembership => 'សមាជិកភាព Pro';

  @override
  String get pricePerMonth => '\$12.9 / ខែ';

  @override
  String get benefitUnlimitedCalls => 'ការហៅគ្មានកំណត់';

  @override
  String get benefitDetailedAnalysis =>
      'ការវិភាគលម្អិតអំពីការបញ្ចេញសំឡេង និងវេយ្យាករណ៍';

  @override
  String get benefitAllCharacters => 'ចូលប្រើតួអង្គទាំងអស់';

  @override
  String get benefitNoAds => 'គ្មានការផ្សាយពាណិជ្ជកម្ម';

  @override
  String get playSampleVoice => 'ចាក់សំឡេងគំរូ';

  @override
  String get useThisAvatar => 'ប្រើវា';

  @override
  String get challengeTitle => 'ការប្រកួតការបញ្ចេញសំឡេង';

  @override
  String get challengeIntro =>
      'បញ្ចេញសំឡេងកាតនីមួយៗក្នុងតំបន់ឱ្យបានត្រឹមត្រូវជាភាសាកូរ៉េ ដើម្បីកម្ចាត់វា។\nគ្មានមីក្រូហ្វូនមែនទេ? អ្នកអាចលេងដោយចុចលើអេក្រង់ក៏បាន។';

  @override
  String get challengeStart => 'ចាប់ផ្ដើមកាមេរ៉ា និងមីក្រូហ្វូន';

  @override
  String get challengePermissionNote =>
      'ត្រូវការសិទ្ធិចូលប្រើកាមេរ៉ាមុខ និងមីក្រូហ្វូន (ជាជម្រើស)។';

  @override
  String get challengeLoadingTitle => 'កំពុងផ្ទុក…';

  @override
  String get challengeLoadingNote =>
      'កំពុងទាញយកម៉ូដែលសំឡេងកូរ៉េ (~82MB) នៅពេលដំណើរការដំបូង។\nសូមរង់ចាំបន្តិច។';

  @override
  String get challengeSttFallback =>
      'ការសម្គាល់សំឡេងមិនអាចប្រើបានទេ ដូច្នេះអ្នកបានលេងដោយប្រើការចុច។';

  @override
  String get reasonTravelTitle => 'និយាយពេលធ្វើដំណើរ';

  @override
  String get reasonTravelDesc => 'សន្ទនាដោយទំនុកចិត្តជាមួយអ្នកស្រុក';

  @override
  String get reasonCareerTitle => 'ការងារ និងអាជីព';

  @override
  String get reasonCareerDesc => 'ការសន្ទនាអាជីវកម្ម';

  @override
  String get reasonExamTitle => 'ត្រៀមប្រឡង';

  @override
  String get reasonExamDesc => 'ត្រៀមប្រឡងការនិយាយ';

  @override
  String get reasonDailyTitle => 'ការសន្ទនាប្រចាំថ្ងៃ';

  @override
  String get reasonDailyDesc => 'ឃ្លាដែលអ្នកប្រើប្រចាំថ្ងៃ';

  @override
  String get reasonFriendsTitle => 'ការបង្កើតមិត្តភក្តិបរទេស';

  @override
  String get reasonFriendsDesc => 'ការសន្ទនាធម្មជាតិ';

  @override
  String get reasonBrainTitle => 'ការជំរុញខួរក្បាល';

  @override
  String get reasonBrainDesc => 'បង្កើនការចងចាំ និងការផ្តោតអារម្មណ៍';

  @override
  String get challengeRecordToggle => 'ថតលេងលើកនេះ';

  @override
  String get challengeRecordHint =>
      'រក្សាទុកវីដេអូនៃការលេងរបស់អ្នកសម្រាប់ចែករំលែក (គ្មានសំឡេង)។';

  @override
  String get settingsSection => 'ការកំណត់';

  @override
  String get paymentSection => 'ការបង់ប្រាក់';

  @override
  String get supportSection => 'ជំនួយ';

  @override
  String get userLanguage => 'ភាសាអ្នកប្រើ';

  @override
  String get learningLanguage => 'ភាសាកំពុងសិក្សា';

  @override
  String get learningLanguageKorean => 'ភាសាកូរ៉េ';

  @override
  String get notificationLabel => 'ការជូនដំណឹង';

  @override
  String get currentPlan => 'គម្រោងបច្ចុប្បន្ន';

  @override
  String get paymentHistory => 'ប្រវត្តិបង់ប្រាក់';

  @override
  String get contactUs => 'ទាក់ទងយើង';

  @override
  String get termsOfService => 'លក្ខខណ្ឌប្រើប្រាស់សេវាកម្ម';

  @override
  String get privacyPolicy => 'គោលការណ៍ភាពឯកជន';

  @override
  String get logOut => 'ចាកចេញ';

  @override
  String get deleteAccount => 'លុបគណនី';

  @override
  String get deleteAccountTitle => 'លុបគណនីមែនទេ?';

  @override
  String get deleteAccountBody =>
      'សកម្មភាពនេះនឹងលុបគណនី និងទិន្នន័យរបស់អ្នកជាអចិន្ត្រៃយ៍ ហើយមិនអាចត្រឡប់វិញបានទេ។';

  @override
  String get delete => 'លុប';

  @override
  String get share => 'ចែករំលែក';

  @override
  String get accentSoundsLike => 'សំនៀងកូរ៉េរបស់អ្នកស្តាប់ទៅដូច';

  @override
  String get hintLabel => 'ជំនួយ';

  @override
  String get nextHint => 'ជំនួយបន្ទាប់';

  @override
  String get translateLabel => 'បកប្រែ';

  @override
  String get startRecording => 'ចាប់ផ្ដើមថត';

  @override
  String get stopRecording => 'បញ្ឈប់ការថត';

  @override
  String get back => 'ត្រឡប់ក្រោយ';

  @override
  String get onboardingNameTitle => 'តើយើងគួរហៅអ្នកយ៉ាងណា?';

  @override
  String get onboardingNameSubtitle =>
      'គ្រូបង្រៀន AI របស់អ្នកនឹងចងចាំឈ្មោះរបស់អ្នក។';

  @override
  String get nameLabel => 'ឈ្មោះរបស់អ្នក';

  @override
  String get nameHint => 'បញ្ចូលឈ្មោះរបស់អ្នក';

  @override
  String get nameHelper =>
      'វាមិនចាំបាច់ជាឈ្មោះពិតរបស់អ្នកទេ — ឈ្មោះហៅក៏បានដែរ។';

  @override
  String get continueLabel => 'បន្ត';

  @override
  String get onboardingDoneTitle => 'Beaver កំពុងរង់ចាំការហៅរបស់អ្នក';

  @override
  String get onboardingDoneSubtitle => 'ចាប់ផ្ដើមហៅឥឡូវនេះ';

  @override
  String get home => 'ទំព័រដើម';

  @override
  String get callNow => 'ហៅឥឡូវនេះ';

  @override
  String get pronunciation => 'ការបញ្ចេញសំឡេង';

  @override
  String get fluency => 'ភាពស្ទាត់ជំនាញ';

  @override
  String get rhythm => 'ចង្វាក់';

  @override
  String get analysisTimeout =>
      'វាចំណាយពេលយូរជាងការរំពឹងទុក។ សូមព្យាយាមម្ដងទៀតបន្តិចទៀត។';

  @override
  String get analysisFailed =>
      'យើងមិនអាចវិភាគការសន្ទនាបានទេ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get analyzingConversation => 'កំពុងវិភាគការសន្ទនារបស់អ្នក…';

  @override
  String get analyzingSubtitle => 'វានឹងចំណាយពេលបន្តិចប៉ុណ្ណោះ';

  @override
  String get tryAgain => 'ព្យាយាមម្ដងទៀត';

  @override
  String get nativeLabel => 'ម្ចាស់ភាសា';

  @override
  String get meLabel => 'ខ្ញុំ';

  @override
  String get pronunciationPlayError => 'មិនអាចចាក់សំឡេងបញ្ចេញសំឡេងបានទេ។';

  @override
  String get savedExpressionsLoadError =>
      'មិនអាចផ្ទុកឃ្លាដែលបានរក្សាទុករបស់អ្នកបានទេ។';

  @override
  String get mySavedExpressions => 'ឃ្លាដែលខ្ញុំបានរក្សាទុក';

  @override
  String get avatarTraits => 'កក់ក្តៅ · ស្ងប់ស្ងាត់ · ទន់ភ្លន់';

  @override
  String get priceFree => 'ឥតគិតថ្លៃ';

  @override
  String get loginGoogleTokenError => 'មិនអាចទទួលបានតូខឹនចូល Google បានទេ។';

  @override
  String get loginGoogleSignInFailed => 'ការចូល Google បរាជ័យ។';

  @override
  String get loginKakaoSignInFailed => 'ការចូល Kakao បរាជ័យ។';

  @override
  String get loginContinueWithKakao => 'បន្តជាមួយ Kakao';

  @override
  String get loginContinueWithGoogle => 'បន្តជាមួយ Google';

  @override
  String get loginContinueWithApple => 'បន្តជាមួយ Apple';

  @override
  String get loginContinueWithEmail => 'បន្តជាមួយអ៊ីមែល';

  @override
  String get loginOrDivider => 'ឬ';

  @override
  String get loginNoAccount => 'មិនទាន់មានគណនីមែនទេ?';

  @override
  String get signUp => 'ចុះឈ្មោះ';

  @override
  String get loginTermsNoticePrefix => 'ការបន្តបញ្ជាក់ថាអ្នកយល់ព្រមតាម ';

  @override
  String get loginTermsNoticeAnd => ' និង ';

  @override
  String get loginTermsNoticeSuffix => '។';

  @override
  String get loginLogIn => 'ចូល';

  @override
  String get fieldEmailLabel => 'អ៊ីមែល';

  @override
  String get emailHint => 'បញ្ចូលអ៊ីមែលរបស់អ្នក';

  @override
  String get fieldPasswordLabel => 'ពាក្យសម្ងាត់';

  @override
  String get passwordHint => 'បញ្ចូលពាក្យសម្ងាត់របស់អ្នក';

  @override
  String get loginRememberMe => 'ចងចាំខ្ញុំ';

  @override
  String get loginForgotPassword => 'ភ្លេចពាក្យសម្ងាត់?';

  @override
  String get loginLoggingIn => 'កំពុងចូល...';

  @override
  String get passwordLengthError => 'ពាក្យសម្ងាត់ត្រូវមានចាប់ពី ៨–១៦ តួអក្សរ។';

  @override
  String get passwordsDoNotMatch => 'ពាក្យសម្ងាត់មិនត្រូវគ្នាទេ។';

  @override
  String get signupCheckInput => 'សូមពិនិត្យព័ត៌មានដែលអ្នកបានបញ្ចូល។';

  @override
  String get fieldConfirmPasswordLabel => 'បញ្ជាក់ពាក្យសម្ងាត់';

  @override
  String get confirmPasswordHint => 'បញ្ចូលពាក្យសម្ងាត់របស់អ្នកម្ដងទៀត';

  @override
  String get signupSigningUp => 'កំពុងចុះឈ្មោះ...';

  @override
  String get signupHaveAccount => 'មានគណនីរួចហើយមែនទេ?';

  @override
  String get passwordMethodEmailRequired => 'បញ្ចូលអ៊ីមែលរបស់អ្នក';

  @override
  String get passwordResetTitle => 'កំណត់ពាក្យសម្ងាត់ឡើងវិញ';

  @override
  String get passwordMethodDescription =>
      'បញ្ចូលអាសយដ្ឋានអ៊ីមែលដែលអ្នកចង់ទទួលកូដកំណត់ពាក្យសម្ងាត់ឡើងវិញ។';

  @override
  String get emailAddressHint => 'អាសយដ្ឋានអ៊ីមែល';

  @override
  String get passwordMethodSending => 'កំពុងផ្ញើ...';

  @override
  String get passwordMethodSendEmail => 'ផ្ញើអ៊ីមែល';

  @override
  String get passwordCodeTitle => 'បញ្ចូលកូដ';

  @override
  String get passwordCodeDescription =>
      'យើងបានផ្ញើកូដសង្គ្រោះទៅអ៊ីមែលរបស់អ្នក។ សូមបញ្ចូលវាដើម្បីបន្ត។';

  @override
  String get passwordCodeNoCode => 'មិនទទួលបានកូដមែនទេ?';

  @override
  String get passwordCodeResend => 'ផ្ញើកូដម្ដងទៀត';

  @override
  String get passwordCodeVerifying => 'កំពុងផ្ទៀងផ្ទាត់...';

  @override
  String get passwordNewTitle => 'ពាក្យសម្ងាត់ថ្មី';

  @override
  String get passwordNewDescription =>
      'កំណត់ពាក្យសម្ងាត់ថ្មីសម្រាប់គណនីរបស់អ្នក។';

  @override
  String get fieldNewPasswordLabel => 'ពាក្យសម្ងាត់ថ្មី';

  @override
  String get newPasswordHint => 'បញ្ចូលពាក្យសម្ងាត់ថ្មីរបស់អ្នក';

  @override
  String get fieldConfirmNewPasswordLabel => 'បញ្ជាក់ពាក្យសម្ងាត់ថ្មី';

  @override
  String get confirmNewPasswordHint => 'បញ្ចូលពាក្យសម្ងាត់ថ្មីរបស់អ្នកម្ដងទៀត';

  @override
  String get passwordNewSubmitting => 'កំពុងដាក់ស្នើ...';

  @override
  String get passwordNewSubmit => 'ដាក់ស្នើ';

  @override
  String get passwordCompleteTitle => 'កំណត់ពាក្យសម្ងាត់ឡើងវិញបានជោគជ័យ';

  @override
  String get passwordCompleteBody =>
      'ពាក្យសម្ងាត់របស់អ្នកត្រូវបានកំណត់ឡើងវិញ។ សូមចូលដោយប្រើពាក្យសម្ងាត់ថ្មីដើម្បីបន្ត។';

  @override
  String get termsTitle => 'លក្ខខណ្ឌប្រើប្រាស់សេវាកម្ម';

  @override
  String get privacyTitle => 'គោលការណ៍ភាពឯកជន';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'កំណត់ពាក្យសម្ងាត់ថ្មីសម្រាប់ $email។';
  }

  @override
  String get selectComplete => 'រួចរាល់';

  @override
  String get onboardingLanguageTitle => 'តើភាសាកំណើតរបស់អ្នកជាអ្វី?';

  @override
  String get onboardingReasonTitle => 'ហេតុអ្វីបានជាអ្នកកំពុងរៀនភាសា?';

  @override
  String get onboardingReasonSubtitle =>
      'យើងនឹងកែសម្រួលការសិក្សារបស់អ្នកឱ្យសមស្របតាមគោលដៅរបស់អ្នក។';

  @override
  String get savingLabel => 'កំពុងរក្សាទុក...';

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
