// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get loginRequired => 'អ្នកត្រូវចូលគណនីជាមុនសិន។';

  @override
  String get callWebNotSupported =>
      'ការហៅជាសំឡេងមិនអាចប្រើលើគេហទំព័របានទេ។ សូមប្រើកម្មវិធី។';

  @override
  String get micPermissionRequiredForCall =>
      'ត្រូវការការអនុញ្ញាតមីក្រូហ្វូន។ សូមអនុញ្ញាតមីក្រូហ្វូនដើម្បីហៅ។';

  @override
  String get callErrorGeneric => 'មានបញ្ហាកើតឡើងកំឡុងពេលហៅ។';

  @override
  String get callNetworkError => 'មានបញ្ហាបណ្តាញ។';

  @override
  String get authInvalidCredentials => 'អ៊ីមែល ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវទេ។';

  @override
  String get authEmailAlreadyRegistered => 'អ៊ីមែលនេះបានចុះឈ្មោះរួចហើយ។';

  @override
  String get authConfirmEmailRequired =>
      'សូមបញ្ចប់ការផ្ទៀងផ្ទាត់ដែលបានផ្ញើទៅអ៊ីមែលរបស់អ្នក។';

  @override
  String get authResetCodeSent =>
      'យើងបានផ្ញើលេខកូដផ្ទៀងផ្ទាត់ទៅអ៊ីមែលរបស់អ្នក។';

  @override
  String get authResetCodeInvalid => 'លេខកូដមិនត្រឹមត្រូវ ឬផុតកំណត់។';

  @override
  String get authPasswordUpdated => 'ពាក្យសម្ងាត់របស់អ្នកត្រូវបានកំណត់ឡើងវិញ។';

  @override
  String get authAppleTokenMissing => 'មិនអាចទទួលបានថូខឹនចូល Apple ទេ។';

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
  String get quickStart => 'ចាប់ផ្តើមរហ័ស';

  @override
  String get presetMorning => 'ទម្លាប់ពេលព្រឹក';

  @override
  String get presetMorningSub => 'ថ្ងៃធ្វើការ 8:00';

  @override
  String get presetEvening => 'បញ្ចប់ពេលល្ងាច';

  @override
  String get presetEveningSub => 'រៀងរាល់ថ្ងៃ 21:00';

  @override
  String get presetCustom => 'កំណត់ដោយខ្លួនឯង';

  @override
  String get presetCustomSub => 'តាមចិត្តអ្នក';

  @override
  String alarmSummary(int count, int monthly) {
    return '$countដង/សប្តាហ៍ · $monthlyការហៅ/ខែ';
  }

  @override
  String get alarmSummaryNone => 'សូមជ្រើសរើសយ៉ាងតិចមួយថ្ងៃ';

  @override
  String get partnerInUse => 'កំពុងប្រើ';

  @override
  String get partnerOwned => 'មានរួចហើយ';

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
    return 'ការហៅលើកទី $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'ពាក្យមួយម៉ាត់ពី $name';
  }

  @override
  String characterNoteFooter(String name) {
    return '$name បានទុកភ្លាមក្រោយការហៅ';
  }

  @override
  String newExpressionsCount(int count) {
    return 'ឃ្លាថ្មី $count';
  }

  @override
  String get analysisLoadError => 'មិនអាចផ្ទុកលទ្ធផលវិភាគបានទេ។';

  @override
  String get standardAudioNotReady => 'សំឡេងបញ្ចេញស្តង់ដារមិនទាន់រួចរាល់ទេ។';

  @override
  String get standardAudioPlayError => 'មិនអាចចាក់សំឡេងបញ្ចេញស្តង់ដារបានទេ។';

  @override
  String get selectNativeLanguage => 'ជ្រើសរើសភាសាកំណើតរបស់អ្នក';

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
  String get analyzingByWord =>
      'កំពុងពិនិត្យការបញ្ចេញសំឡេងរបស់អ្នកម្តងមួយពាក្យ';

  @override
  String get analyzingTakingLonger => 'វាកំពុងចំណាយពេលយូរបន្តិច';

  @override
  String get scanConnectionLost => 'ការតភ្ជាប់ដាច់';

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
  String pricePerMonth(String price) {
    return '$price / ខែ';
  }

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
  String get loginAppleSignInFailed => 'ការចូល Apple បរាជ័យ។';

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
  String get thisMonthPayment => 'ការទូទាត់ខែនេះ';

  @override
  String get filterAll => 'ទាំងអស់';

  @override
  String get filterSubscription => 'ការជាវ';

  @override
  String get filterCharacter => 'តួអង្គ';

  @override
  String get statusCompleted => 'បញ្ចប់';

  @override
  String get lastPayment => 'ការទូទាត់ចុងក្រោយ';

  @override
  String subscriptionSwitchNote(String date) {
    return 'អ្នកអាចប្រើអត្ថប្រយោជន៍ Pro រហូតដល់ $date បន្ទាប់មកគម្រោងរបស់អ្នកនឹងប្តូរទៅឥតគិតថ្លៃដោយស្វ័យប្រវត្តិ។';
  }

  @override
  String get freePlanCallLimit => '1 ការហៅក្នុងមួយថ្ងៃ · កំណត់ 5 នាទី';

  @override
  String get freePlanBasicCharacters => 'រួមបញ្ចូលតួអង្គមូលដ្ឋាន';

  @override
  String get availableForPurchase => 'អាចទិញបាន';

  @override
  String get paymentsLoadError => 'មិនអាចផ្ទុកប្រវត្តិទូទាត់បានទេ';

  @override
  String get noPayments => 'មិនទាន់មានការទូទាត់';

  @override
  String get morePaymentsExist => 'ការទូទាត់ចាស់ៗមិនទាន់បង្ហាញនៅឡើយ';

  @override
  String get undatedPayments => 'គ្មានកាលបរិច្ឆេទ';

  @override
  String get paymentLabelFallback => 'ការទូទាត់';

  @override
  String learningPassed(int passed, int total) {
    return 'ជាប់ $passed ក្នុងចំណោម $total ប្រយោគ';
  }

  @override
  String get hardestSound => 'សំឡេងពិបាកបំផុតថ្ងៃនេះ';

  @override
  String get soundAccuracy => 'ភាពត្រឹមត្រូវតាមសំឡេង';

  @override
  String phonemeAttempts(int count) {
    return 'ក្នុងមួយសូរ · $count ដងសាកល្បង';
  }

  @override
  String get colSound => 'សំឡេង';

  @override
  String get colAttempts => 'សាកល្បង';

  @override
  String get colCorrect => 'ត្រូវ';

  @override
  String get colAccuracy => 'ត្រឹមត្រូវ';

  @override
  String get sentenceResults => 'លទ្ធផលតាមប្រយោគ';

  @override
  String viewAllSentences(int count) {
    return 'មើលទាំង $count';
  }

  @override
  String get colSentence => 'ប្រយោគ';

  @override
  String get colPronunciation => 'សំឡេង';

  @override
  String get colFluency => 'រលូន';

  @override
  String get colRhythm => 'ចង្វាក់';

  @override
  String recentSessions(int count) {
    return '$count វគ្គចុងក្រោយ';
  }

  @override
  String trendAverage(int score) {
    return 'មធ្យម $score';
  }

  @override
  String get today => 'ថ្ងៃនេះ';

  @override
  String get colDate => 'កាលបរិច្ឆេទ';

  @override
  String get colSentences => 'ប្រយោគ';

  @override
  String get colScore => 'ពិន្ទុ';

  @override
  String get colChange => 'ប្តូរ';

  @override
  String dateToday(String date) {
    return '$date (ថ្ងៃនេះ)';
  }

  @override
  String get accentAnalysis => 'ការវិភាគសំនៀង';

  @override
  String get overallLevel => 'កម្រិតរួម';

  @override
  String get overallLevelSubtitle => 'វាក្យសព្ទ · វេយ្យាករណ៍ · ការបញ្ចេញមតិ';

  @override
  String get pronunciationAnalysis => 'ការវិភាគការបញ្ចេញសំឡេង';

  @override
  String get recentSessionsAverage => 'មធ្យម ១០ វគ្គចុងក្រោយ';

  @override
  String levelStage(int stage) {
    return 'កម្រិត $stage';
  }

  @override
  String topPercent(int percent) {
    return 'កំពូល $percent%';
  }

  @override
  String get allLearnersBasis => 'ក្នុងចំណោមអ្នកសិក្សាទាំងអស់';

  @override
  String aheadOfLearners(int percent) {
    return 'អ្នកនាំមុខ $percent% នៃអ្នកសិក្សា';
  }

  @override
  String get retakeLevelTest => 'ធ្វើតេស្តកម្រិតម្តងទៀត';

  @override
  String get practicePronunciation => 'អនុវត្តការបញ្ចេញសំឡេង';

  @override
  String get priceChangedTitle => 'តម្លៃបានផ្លាស់ប្ដូរ';

  @override
  String priceChangedBody(String price) {
    return 'ទំនិញនេះឥឡូវតម្លៃ $price។ បន្តទេ?';
  }

  @override
  String get billingGroupPlanPurchases => 'គម្រោង និងការទិញ';

  @override
  String get billingGroupInTheStore => 'នៅក្នុងហាង';

  @override
  String get billingChangePlan => 'ប្ដូរគម្រោង';

  @override
  String get billingCompareAllPlans => 'ប្រៀបធៀបគម្រោងទាំងអស់';

  @override
  String get billingBuyACharacter => 'ទិញតួអង្គ';

  @override
  String get billingRestorePurchases => 'ស្ដារការទិញ';

  @override
  String get billingPaymentHistory => 'ប្រវត្តិការទូទាត់';

  @override
  String get billingManageInTheStore => 'គ្រប់គ្រងនៅក្នុងហាង';

  @override
  String get billingRefundHelp => 'ជំនួយបង្វិលប្រាក់';

  @override
  String get billingCancelSubscription => 'បញ្ឈប់ការជាវ';

  @override
  String get billingResubscribe => 'ជាវឡើងវិញ';

  @override
  String get badgeCurrent => 'បច្ចុប្បន្ន';

  @override
  String get badgeTrial => 'សាកល្បង';

  @override
  String get badgeRenewing => 'កំពុងបន្ត';

  @override
  String get badgePastDue => 'ខកខានទូទាត់';

  @override
  String get badgePaused => 'ផ្អាក';

  @override
  String get badgeCanceling => 'កំពុងបញ្ឈប់';

  @override
  String get subscriptionTitle => 'ការជាវ';

  @override
  String get plansTitle => 'គម្រោង';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'ការសាកល្បង Max';

  @override
  String get freePlanPriceLine => '\$0.00 — ការហៅមួយក្នុងមួយថ្ងៃ';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount ក្នុងមួយខែ';
  }

  @override
  String freeUntilDate(String date) {
    return 'ឥតគិតថ្លៃរហូតដល់ $date';
  }

  @override
  String get todaysCalls => 'ការហៅថ្ងៃនេះ';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'បានប្រើ $used ក្នុងចំណោម $limit';
  }

  @override
  String get firstPaymentLabel => 'ការទូទាត់ដំបូង';

  @override
  String get nextPaymentLabel => 'ការទូទាត់បន្ទាប់';

  @override
  String get retryingUntilLabel => 'ព្យាយាមម្ដងទៀតរហូតដល់';

  @override
  String get pausedSinceLabel => 'ផ្អាកចាប់តាំងពី';

  @override
  String planEndsLabel(String plan) {
    return '$plan បញ្ចប់';
  }

  @override
  String get bannerGoUnlimitedTitle => 'គ្មានដែនកំណត់ជាមួយ Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'ការហៅគ្មានដែនកំណត់ · ១៥ នាទីក្នុងមួយលើក · $price ក្នុងមួយខែ';
  }

  @override
  String get bannerMaxUpsellTitle => 'បើកវីដេអូជាមួយ Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'ការហៅទល់មុខគ្នា · $price ក្នុងមួយខែ';
  }

  @override
  String get bannerAnnualSwitchTitle => 'ប្ដូរទៅគម្រោងប្រចាំឆ្នាំ';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly ក្នុងមួយឆ្នាំ · $perMonth ក្នុងមួយខែ';
  }

  @override
  String get bannerPaymentFailedTitle => 'មិនអាចទូទាត់បានទេ';

  @override
  String get bannerPaymentFailedSub =>
      'ធ្វើបច្ចុប្បន្នភាពការទូទាត់នៅក្នុងហាង ដើម្បីរក្សា Pro';

  @override
  String get bannerPausedTitle => 'គម្រោងរបស់អ្នកត្រូវបានផ្អាក';

  @override
  String get bannerPausedSub => 'ការទូទាត់មិនបានសម្រេចទេ';

  @override
  String get noteRestoreHint =>
      'បានជាវនៅឧបករណ៍ផ្សេងឬ? ការស្ដារនឹងនាំវាមកឧបករណ៍នេះវិញ។';

  @override
  String get noteStoreHandled =>
      'វិធីទូទាត់ ការប្ដូរគម្រោង និងការបញ្ឈប់ ត្រូវបានគ្រប់គ្រងដោយហាង។';

  @override
  String get noteFairUse =>
      'ការប្រើគ្មានដែនកំណត់ ស្ថិតក្រោមគោលការណ៍ប្រើប្រាស់សមរម្យរបស់យើង។';

  @override
  String noteTrialEnds(String date) {
    return 'ការសាកល្បងរបស់អ្នកបញ្ចប់ $date។ បញ្ឈប់នៅក្នុងហាងមុនពេលនោះ នោះនឹងមិនគិតថ្លៃទេ។';
  }

  @override
  String get noteGrace =>
      'អត្ថប្រយោជន៍នៅតែដំណើរការក្នុងរយៈពេលអនុគ្រោះ។ ការបញ្ឈប់មិនដែលត្រូវបានរារាំងក្នុងកម្មវិធីទេ។';

  @override
  String get noteHold =>
      'Pro ត្រូវផ្អាករហូតដល់ការទូទាត់សម្រេច។ តួអង្គ និងវឌ្ឍនភាពរបស់អ្នកនៅសុវត្ថិភាព។';

  @override
  String noteEnding(String date) {
    return 'គម្រោងរបស់អ្នកនឹងបញ្ចប់។ អត្ថប្រយោជន៍ដំណើរការរហូតដល់ $date បន្ទាប់មកអ្នកនឹងទៅ Free។ អាចជាវឡើងវិញបានគ្រប់ពេល។';
  }

  @override
  String get trialExpiredTitle => 'ការសាកល្បង Max របស់អ្នកបានបញ្ចប់';

  @override
  String get trialExpiredSub => 'ឥឡូវអ្នកនៅលើ Free';

  @override
  String get seePlans => 'មើលគម្រោង';

  @override
  String get currentPlanTitle => 'គម្រោងបច្ចុប្បន្ន';

  @override
  String get badgeRecommended => 'បានណែនាំ';

  @override
  String get perMonthUnit => 'ក្នុងមួយខែ';

  @override
  String get planTaglinePro => 'ការហៅគ្មានដែនកំណត់។ ១៥ នាទីក្នុងមួយលើក។';

  @override
  String get planTaglineMax => 'ឥឡូវអ្នកអាចមើលឃើញពួកគេ។';

  @override
  String get planTaglineFree => 'ការហៅមួយក្នុងមួយថ្ងៃ។ ឥតគិតថ្លៃ។';

  @override
  String get bulletProCalls => 'ការហៅជាសំឡេង ច្រើនតាមចង់';

  @override
  String get bulletProLength => '១៥ នាទីក្នុងមួយការហៅ';

  @override
  String get bulletProScoring => 'ដាក់ពិន្ទុការបញ្ចេញសំឡេង តាមអក្សរនីមួយៗ';

  @override
  String get bulletProCorrections => 'ការកែតម្រូវ ផ្អែកលើភាសាកំណើតរបស់អ្នក';

  @override
  String get bulletProBeaverCalls => 'Beaver ហៅអ្នកមុន';

  @override
  String get bulletMaxVideo => 'ការហៅជាវីដេអូ ទល់មុខគ្នា';

  @override
  String get bulletMaxEverything => 'អ្វីៗទាំងអស់ក្នុង Pro';

  @override
  String get bulletMaxCharacters => 'តួអង្គទាំងអស់ គ្មានដែនកំណត់';

  @override
  String get bulletMaxStudyBook => 'សៀវភៅសិក្សា សមស្របនឹងកម្រិតរបស់អ្នក';

  @override
  String get bulletMaxWeeklyReport =>
      'របាយការណ៍ប្រចាំសប្ដាហ៍ អំពីការផ្លាស់ប្ដូរសំឡេងរបស់អ្នក';

  @override
  String get bulletFreeCall => 'ការហៅជាសំឡេង ៥ នាទី មួយក្នុងមួយថ្ងៃ';

  @override
  String get bulletFreeCheck => 'ការត្រួតពិនិត្យការបញ្ចេញសំឡេង មួយក្នុងមួយថ្ងៃ';

  @override
  String get bulletFreeAccent => 'ការត្រួតពិនិត្យសំនៀង គ្មានដែនកំណត់';

  @override
  String get bulletFreeCharacter => 'តួអង្គមួយ ដើម្បីចាប់ផ្ដើម';

  @override
  String get ctaGoUnlimited => 'គ្មានដែនកំណត់';

  @override
  String get ctaTurnOnVideo => 'បើកវីដេអូ';

  @override
  String get noteCallLength => 'ការហៅនីមួយៗមានរយៈពេល ១៥ នាទី។';

  @override
  String get paywallProTitle1 => 'មិត្តកូរ៉េរបស់អ្នក';

  @override
  String get paywallProTitle2 => 'ដែលនៅភ្ញាក់ម៉ោង ៣ យប់';

  @override
  String get paywallProSub =>
      'ការហៅគ្មានដែនកំណត់។ ១៥ នាទីក្នុងមួយលើក។ ពេញមួយឆ្នាំ។';

  @override
  String get paywallLimitHeadline => 'Pro ដកដែនកំណត់ចេញ។';

  @override
  String get limitBannerCallTitle => 'នោះជាការហៅថ្ងៃនេះហើយ';

  @override
  String get limitBannerCallSub => 'Free ផ្ដល់ការហៅមួយក្នុងមួយថ្ងៃ';

  @override
  String get limitBannerCheckTitle => 'នោះជាការត្រួតពិនិត្យថ្ងៃនេះហើយ';

  @override
  String get limitBannerCheckSub => 'Free ផ្ដល់ការត្រួតពិនិត្យមួយក្នុងមួយថ្ងៃ';

  @override
  String get bulletProCharactersForever =>
      'តួអង្គដែលអ្នកទិញ ជារបស់អ្នកជារៀងរហូត';

  @override
  String get paywallMaxTitle => 'ឥឡូវអ្នកអាចមើលឃើញពួកគេ។';

  @override
  String get paywallMaxSub =>
      'ការហៅជាវីដេអូ តួអង្គទាំងអស់ និងសៀវភៅសិក្សាធ្វើឡើងសម្រាប់កម្រិតរបស់អ្នក។';

  @override
  String get planMonthly => 'ប្រចាំខែ';

  @override
  String get planAnnual => 'ប្រចាំឆ្នាំ';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price ក្នុងមួយខែ';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth ក្នុងមួយខែ';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price ក្នុងមួយខែ';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly ក្នុងមួយឆ្នាំ · $perMonth ក្នុងមួយខែ';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price ក្នុងមួយខែ · បញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price ក្នុងមួយខែ · បញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '៧ ថ្ងៃឥតគិតថ្លៃ បន្ទាប់មក $price ក្នុងមួយខែ · បញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង';
  }

  @override
  String get ctaCaptionAutoRenew => 'បន្តដោយស្វ័យប្រវត្តិរហូតដល់បោះបង់។';

  @override
  String get footerTerms => 'លក្ខខណ្ឌ';

  @override
  String get footerPrivacy => 'ឯកជនភាព';

  @override
  String get noteMaxCharacters =>
      'តួអង្គដែលបើកដោយ Max អាចប្រើបានពេលការជាវសកម្ម។ តួអង្គដែលអ្នកទិញ នៅជារបស់អ្នក។';

  @override
  String get processingTitle => 'កំពុងបញ្ជាក់ការទិញរបស់អ្នក';

  @override
  String get processingSub => 'ជាធម្មតាចំណាយពេលពីរបីវិនាទី។';

  @override
  String get successProTitle => 'អ្នកនៅលើ Pro ហើយ។';

  @override
  String get successProSub => 'ការហៅគ្មានដែនកំណត់ ចាប់ផ្ដើមឥឡូវនេះ។';

  @override
  String get successProBenefit1 => 'ហៅច្រើនតាមចង់ — ១៥ នាទីក្នុងមួយការហៅ';

  @override
  String get successProBenefit2 =>
      'ការត្រួតពិនិត្យការបញ្ចេញសំឡេង គ្មានដែនកំណត់';

  @override
  String get successProBenefit3 => 'តួអង្គទាំងអស់ បូកការទិញម្ដងៗ';

  @override
  String get successMaxTitle => 'ឥឡូវអ្នកអាចមើលឃើញពួកគេ។';

  @override
  String get successMaxSub =>
      'ការហៅជាវីដេអូបើកហើយ។ ចុចប៊ូតុងវីដេអូក្នុងការហៅណាមួយ។';

  @override
  String get successMaxBenefit1 => 'ការហៅជាវីដេអូ ទល់មុខគ្នា';

  @override
  String get successMaxBenefit2 =>
      'តួអង្គទាំងអស់ គ្មានដែនកំណត់ — តួថ្មីៗបានមុនគេ';

  @override
  String get successMaxBenefit3 => 'សៀវភៅសិក្សា សមស្របនឹងកម្រិតរបស់អ្នក';

  @override
  String get ctaStartACall => 'ចាប់ផ្ដើមការហៅ';

  @override
  String get ctaStartAVideoCall => 'ចាប់ផ្ដើមការហៅជាវីដេអូ';

  @override
  String get ctaSeeYourSubscription => 'មើលការជាវរបស់អ្នក';

  @override
  String successProCaption(String price) {
    return '$price ត្រូវគិតប្រចាំខែរហូតដល់អ្នកបញ្ឈប់។ គ្រប់គ្រង ឬបញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង។';
  }

  @override
  String successMaxCaption(String price) {
    return '$price ត្រូវគិតប្រចាំខែរហូតដល់អ្នកបញ្ឈប់។ គ្រប់គ្រង ឬបញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង។';
  }

  @override
  String get plansErrorTitle => 'មិនអាចផ្ទុកគម្រោងបានទេ';

  @override
  String get plansErrorSub => 'ហាងមិនឆ្លើយតបទេ។';

  @override
  String get ctaTryAgain => 'ព្យាយាមម្ដងទៀត';

  @override
  String get plansErrorCaption => 'មិនបានគិតថ្លៃទេ។';

  @override
  String get changePlanTitle => 'ប្ដូរគម្រោង';

  @override
  String get moveToMaxTitle => 'ទៅ Max';

  @override
  String maxPriceShort(String price) {
    return '$price / ខែ';
  }

  @override
  String get moveToMaxCardSub =>
      'ការហៅជាវីដេអូទល់មុខគ្នា · តួអង្គទាំងអស់ · សៀវភៅសិក្សាសម្រាប់អ្នក';

  @override
  String get whatHappensNow => 'អ្វីនឹងកើតឡើងឥឡូវ';

  @override
  String get maxStartsLabel => 'Max ចាប់ផ្ដើម';

  @override
  String get immediately => 'ភ្លាមៗ';

  @override
  String get unusedProTime => 'ពេល Pro ដែលមិនទាន់ប្រើ';

  @override
  String get creditedTowardMax => 'បញ្ចូលទៅក្នុង Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'ប្ដូរទៅ Max';

  @override
  String get upgradeCaption =>
      'គម្រោងថ្មីចាប់ផ្ដើមភ្លាម។ ពេល Pro ដែលមិនទាន់ប្រើត្រូវបញ្ចូលជូន មិនគិតថ្លៃពីរដងទេ។';

  @override
  String get moveToProTitle => 'ទៅ Pro';

  @override
  String get moveToProSub =>
      'ថ្ងៃនេះគ្មានអ្វីផ្លាស់ប្ដូរទេ។ Max ដំណើរការដល់ចុងខែដែលអ្នកបានបង់រួច។';

  @override
  String get maxRunsUntil => 'Max ដំណើរការរហូតដល់';

  @override
  String get proStarts => 'Pro ចាប់ផ្ដើម';

  @override
  String get whatYouKeep => 'អ្វីដែលអ្នកនៅរក្សាបាន';

  @override
  String get keepBenefitCalls => 'ការហៅជាសំឡេងគ្មានដែនកំណត់ ១៥ នាទីក្នុងមួយលើក';

  @override
  String get keepBenefitCharacters => 'តួអង្គដែលអ្នកទិញ ជារបស់អ្នកជារៀងរហូត';

  @override
  String downgradeWarning(String date) {
    return 'ការហៅជាវីដេអូ និងតួអង្គសម្រាប់តែ Max នឹងបិទនៅ $date។';
  }

  @override
  String get ctaSwitchToPro => 'ប្ដូរទៅ Pro';

  @override
  String get ctaKeepMax => 'រក្សា Max';

  @override
  String get winbackSkip => 'រំលង';

  @override
  String get winbackTitle => 'គម្រោង Pro របស់អ្នកបានបញ្ចប់';

  @override
  String get winbackSub => 'ឥឡូវអ្នកនៅលើ Free — ការហៅមួយក្នុងមួយថ្ងៃ។';

  @override
  String get winbackQuestion => 'អាចប្រាប់យើងបានទេ ថាហេតុអ្វីអ្នកចាកចេញ?';

  @override
  String get winbackReasonExpensive => 'ថ្លៃពេក';

  @override
  String get winbackReasonUnused => 'ខ្ញុំមិនសូវបានប្រើ';

  @override
  String get winbackReasonMissing => 'ខ្វះមុខងារដែលខ្ញុំត្រូវការ';

  @override
  String get winbackReasonOtherApp => 'ខ្ញុំរកឃើញកម្មវិធីផ្សេង';

  @override
  String get winbackReasonElse => 'មូលហេតុផ្សេង';

  @override
  String get ctaSend => 'ផ្ញើ';

  @override
  String get ctaNotNow => 'មិនមែនឥឡូវទេ';

  @override
  String get winbackCaption =>
      'នេះមិនស្ដារគម្រោងរបស់អ្នកទេ។ ជាវឡើងវិញនៅក្នុងហាង។';

  @override
  String get ctaContinue => 'បន្ត';

  @override
  String get ctaClose => 'បិទ';

  @override
  String get ovRestoreSuccessTitle => 'Pro ត្រលប់មកវិញហើយ';

  @override
  String get ovRestoreSuccessBody =>
      'យើងរកឃើញការជាវរបស់អ្នក ហើយបើកវាឡើងវិញសម្រាប់ឧបករណ៍នេះ។';

  @override
  String get ovRestoreEmptyTitle => 'គ្មានអ្វីត្រូវស្ដារទេ';

  @override
  String get ovRestoreEmptyBody => 'គ្មានការជាវសកម្មភ្ជាប់នឹងគណនីហាងនេះទេ។';

  @override
  String get ovRestoreOtherTitle => 'គម្រោងនោះជារបស់គណនីផ្សេង';

  @override
  String get ovRestoreOtherBody =>
      'ការជាវនេះសកម្មរួចហើយនៅលើគណនី BeaverTalk ផ្សេង។';

  @override
  String get ctaSignInThatAccount => 'ចូលគណនីនោះ';

  @override
  String get ctaGetHelp => 'សុំជំនួយ';

  @override
  String get ovCharacterOfferTitle => 'មិនទាន់ត្រៀមខ្លួនសម្រាប់ Pro?';

  @override
  String get ovCharacterOfferBody =>
      'ជ្រើសតួអង្គមួយ ហើយរក្សាទុក។ ការទិញម្ដង — គ្មានការជាវ គ្មានការបន្ត។';

  @override
  String get rowOneCharacter => 'តួអង្គមួយ';

  @override
  String rowFromPrice(String price) {
    return 'ចាប់ពី $price';
  }

  @override
  String get rowYoursForever => 'ជារបស់អ្នកជារៀងរហូត';

  @override
  String get rowNoRenewal => 'គ្មានការបន្ត';

  @override
  String get rowWorksOnFree => 'ប្រើបានលើ Free';

  @override
  String get rowYes => 'បាន';

  @override
  String get ctaSeeCharacters => 'មើលតួអង្គ';

  @override
  String get ovNotEligibleTitle => 'គ្មានអ្វីត្រូវបញ្ឈប់ទេ';

  @override
  String get ovNotEligibleBody =>
      'អ្នកនៅលើ Free។ គ្មានការជាវសកម្មនៅលើគណនីនេះទេ។';

  @override
  String get ovCancelDownsellTitle => 'មុនពេលអ្នកចាកចេញ';

  @override
  String get ovCancelDownsellBody =>
      'ការបញ្ឈប់ធ្វើឡើងនៅក្នុងហាង។ រឿងពីរដែលគួរដឹង។';

  @override
  String get rowPayYearlyInstead => 'បង់ប្រចាំឆ្នាំវិញ';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price ក្នុងមួយខែ';
  }

  @override
  String get rowCharactersYouBought => 'តួអង្គដែលអ្នកបានទិញ';

  @override
  String get rowProRunsUntil => 'Pro ដំណើរការរហូតដល់';

  @override
  String get ctaSwitchToYearly => 'ប្ដូរទៅប្រចាំឆ្នាំ';

  @override
  String get ctaContinueToStore => 'បន្តទៅហាង';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'បង់ប្រចាំឆ្នាំ សន្សំបាន $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'អ្នកបានប្រើ Pro ពីរខែហើយ។ គម្រោងប្រចាំឆ្នាំគិតទៅថោកជាង។';

  @override
  String get rowYouSave => 'អ្នកសន្សំបាន';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'ប្រចាំឆ្នាំ';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'ប្រចាំខែ រយៈពេលមួយឆ្នាំ';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'ប្ដូរទៅប្រចាំខែ';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'គម្រោងប្រចាំឆ្នាំរបស់អ្នកដំណើរការដល់ $date។ ការគិតថ្លៃប្រចាំខែចាប់ផ្ដើមថ្ងៃបន្ទាប់។';
  }

  @override
  String get rowMonthlyBillingStarts => 'ការគិតថ្លៃប្រចាំខែ ចាប់ផ្ដើម';

  @override
  String get rowMonthlyLabel => 'ប្រចាំខែ';

  @override
  String get rowYearlyWorkedOut => 'ប្រចាំឆ្នាំគិតស្មើនឹង';

  @override
  String get ctaSwitchToMonthly => 'ប្ដូរទៅប្រចាំខែ';

  @override
  String get ovRefundHelpTitle => 'ការបង្វិលប្រាក់ គ្រប់គ្រងដោយហាង';

  @override
  String get ovRefundHelpBody =>
      'យើងមិនអាចបង្វិលប្រាក់ដោយខ្លួនឯងទេ។ រាល់សំណើត្រូវពិនិត្យដោយហាង។';

  @override
  String get ctaGoToStore => 'ទៅហាង';

  @override
  String get ovTrialEndingTitle => 'ការសាកល្បងរបស់អ្នកបញ្ចប់ថ្ងៃស្អែក';

  @override
  String get ovTrialEndingBody =>
      'Max នៅដំណើរការ លុះត្រាតែអ្នកបញ្ឈប់។ នេះជាអ្វីដែលនឹងកើតឡើង។';

  @override
  String get rowTrialEnds => 'ការសាកល្បងបញ្ចប់';

  @override
  String get rowFirstCharge => 'ការគិតថ្លៃដំបូង';

  @override
  String get rowThenMonthly => 'បន្ទាប់មកប្រចាំខែ';

  @override
  String get ctaCancelInStore => 'បញ្ឈប់នៅក្នុងហាង';

  @override
  String get ovTrialStartTitle => 'Max ៧ ថ្ងៃ ឥតគិតថ្លៃ';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'ឥតគិតថ្លៃរហូតដល់ $date។ បន្ទាប់មក $price ក្នុងមួយខែ លុះត្រាតែអ្នកបញ្ឈប់នៅក្នុងហាង។';
  }

  @override
  String get ctaStart7Days => 'ចាប់ផ្ដើម ៧ ថ្ងៃឥតគិតថ្លៃ';

  @override
  String get ovOtoTitle => 'រឿងមួយទៀត មុនពេលចាប់ផ្ដើម';

  @override
  String get ovOtoBody =>
      'ជម្រើសល្អ — ការហៅគ្មានដែនកំណត់បើកហើយ។ Pro ដដែលថោកជាង បើបង់ប្រចាំឆ្នាំ។';

  @override
  String get ovFailedDeclinedTitle => 'កាតរបស់អ្នកត្រូវបានបដិសេធ';

  @override
  String get ovFailedDeclinedBody => 'ហាងមិនអាចទូទាត់បានទេ។ មិនបានគិតថ្លៃទេ។';

  @override
  String get ctaUpdatePaymentMethod => 'ធ្វើបច្ចុប្បន្នភាពវិធីទូទាត់';

  @override
  String get ovFailedCanceledTitle => 'ការទូទាត់ត្រូវបានបោះបង់';

  @override
  String get ovFailedCanceledBody => 'អ្នកនៅតែលើ Free។ មិនបានគិតថ្លៃទេ។';

  @override
  String get ovFailedStoreTitle => 'មានអ្វីមួយខុសប្រក្រតី';

  @override
  String get ovFailedStoreBody => 'មិនអាចភ្ជាប់ទៅហាងបានទេ។ មិនបានគិតថ្លៃទេ។';

  @override
  String get ovAlreadyTitle => 'អ្នកនៅលើ Pro រួចហើយ';

  @override
  String get ovAlreadyBody => 'គណនីហាងនេះមានគម្រោងសកម្ម។ គ្មានអ្វីត្រូវទិញទេ។';

  @override
  String get ctaSeeMySubscription => 'មើលការជាវរបស់ខ្ញុំ';

  @override
  String get subCancelTitle => 'បញ្ឈប់ការជាវ';

  @override
  String subCancelBody(String date) {
    return 'Pro ដំណើរការដល់ $date។ បន្ទាប់មកអ្នកនឹងទៅ Free។';
  }

  @override
  String get subWhatYouLose => 'អ្វីដែលអ្នកនឹងបាត់បង់';

  @override
  String get benefitCalls15 => 'ការហៅគ្មានដែនកំណត់ ១៥ នាទីក្នុងមួយលើក';

  @override
  String get benefitScoring => 'ដាក់ពិន្ទុការបញ្ចេញសំឡេង តាមអក្សរនីមួយៗ';

  @override
  String get benefitEveryCharacter => 'តួអង្គទាំងអស់ គ្មានដែនកំណត់';

  @override
  String get ctaKeepPro => 'រក្សា Pro';

  @override
  String get subPaymentTitle => 'ធ្វើបច្ចុប្បន្នភាពការទូទាត់';

  @override
  String get subPaymentBody =>
      'មិនអាចទូទាត់បានទេ។ Pro នៅដំណើរការក្នុងរយៈពេលអនុគ្រោះ។';

  @override
  String get subHowToFix => 'របៀបដោះស្រាយ';

  @override
  String get fixStep1 => 'បើកហាង ហើយធ្វើបច្ចុប្បន្នភាពវិធីទូទាត់';

  @override
  String get fixStep2 => 'ត្រលប់មកវិញ — គម្រោងរបស់អ្នកបន្តដោយស្វ័យប្រវត្តិ';

  @override
  String get fixStep3 => 'គ្មានអ្វីត្រូវគិតថ្លៃពីរដងទេ';

  @override
  String get subResubTitle => 'ជាវឡើងវិញ';

  @override
  String subResubBody(String date) {
    return 'Pro បញ្ចប់នៅ $date។ បើកការបន្តស្វ័យប្រវត្តិឡើងវិញ នោះគ្មានអ្វីផ្លាស់ប្ដូរទេ។';
  }

  @override
  String get subWhatYouKeep => 'អ្វីដែលអ្នកនៅរក្សាបាន';

  @override
  String get ctaTurnItBackOn => 'បើកវាឡើងវិញ';

  @override
  String get flTodayTitle => 'នោះជាការហៅថ្ងៃនេះហើយ';

  @override
  String get flTodayBody => 'បន្តពីកន្លែងដែលអ្នកឈប់ — ឥឡូវនេះ។';

  @override
  String get flCheckTitle => 'នោះជាការត្រួតពិនិត្យថ្ងៃនេះហើយ';

  @override
  String get flCheckBody =>
      'ការត្រួតពិនិត្យមួយក្នុងមួយថ្ងៃលើ Free។ Pro ធ្វើឱ្យគ្មានដែនកំណត់។';

  @override
  String get flBenefitCalls =>
      'ការហៅគ្មានដែនកំណត់ជាមួយ Pro · ១៥ នាទីក្នុងមួយលើក';

  @override
  String get flBenefitChecks =>
      'ការត្រួតពិនិត្យការបញ្ចេញសំឡេងគ្មានដែនកំណត់ជាមួយ Pro';

  @override
  String flCaption(String price) {
    return '$price ក្នុងមួយខែ · បញ្ឈប់បានគ្រប់ពេល';
  }

  @override
  String flUsage(String used, String limit) {
    return 'បានប្រើ $used ក្នុងចំណោម $limit';
  }

  @override
  String get ctaMaybeTomorrow => 'ប្រហែលថ្ងៃស្អែក';

  @override
  String get accountSection => 'គណនី';

  @override
  String get nicknameLabel => 'ឈ្មោះហៅក្រៅ';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'របៀបចូល';

  @override
  String get joinedLabel => 'ថ្ងៃចូលរួម';

  @override
  String get editNicknameTitle => 'កែឈ្មោះហៅក្រៅ';

  @override
  String get nicknameRule => 'អក្សរ ២–១២ តួ។ អក្សរ និងលេខអង់គ្លេសប៉ុណ្ណោះ។';

  @override
  String get ctaSave => 'រក្សាទុក';

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
  String get paywallLeaveTitle => 'បើចាកចេញឥឡូវ អ្នកនឹងមិនទាន់ជាវទេ';

  @override
  String get paywallLeaveBody =>
      'អត្ថប្រយោជន៍បើកភ្លាមៗក្រោយបង់ប្រាក់។ អ្នកអាចត្រឡប់មកវិញបានគ្រប់ពេលពីទំព័ររបស់ខ្ញុំ។';

  @override
  String get ctaKeepLooking => 'មើលបន្ត';

  @override
  String get ctaLeaveAnyway => 'ចាកចេញ';

  @override
  String get iapCharacterSuccessTitle => 'មិត្តថ្មីបានចូលរួម!';

  @override
  String get iapCharacterSuccessBody =>
      'តួអង្គនេះជារបស់អ្នកជារៀងរហូត — នៅដដែលទោះគម្រោងផ្លាស់ប្ដូរ ហើយស្ដារការទិញអាចយកមកវិញនៅគ្រប់ឧបករណ៍។';

  @override
  String get iapCharacterFailedBody =>
      'ការទិញមិនបានសម្រេចទេ។ មិនមានការគិតប្រាក់ទេ — សូមព្យាយាមម្ដងទៀត។';

  @override
  String get noAccentDataTitle => 'មិនទាន់មានទិន្នន័យសំនៀងទេ';

  @override
  String get noAccentDataBody =>
      'បន្តសន្ទនា នោះលក្ខណៈសំនៀងរបស់អ្នកនឹងកកកុញឡើង។';

  @override
  String get noLevelYetTitle => 'មិនទាន់មានកម្រិតទេ';

  @override
  String get noLevelYetBody =>
      'បញ្ចប់ការហៅលើកដំបូង ដើម្បីទទួលបានកម្រិតរបស់អ្នក។';

  @override
  String get noPronunciationDataTitle => 'មិនទាន់មានកំណត់ត្រាការបញ្ចេញសំឡេងទេ';

  @override
  String get noPronunciationDataBody =>
      'យើងវិភាគការបញ្ចេញសំឡេងពីប្រយោគដែលអ្នកនិយាយពេលហៅ។';

  @override
  String get noCharacterNote => 'មិនទាន់មានសាររក្សាទុកទេ';

  @override
  String get noPhonemesYet => 'មិនទាន់មានសំឡេងសម្រាប់វិភាគទេ';

  @override
  String get noSentencesYet => 'មិនទាន់មានប្រយោគសម្រាប់វិភាគទេ';

  @override
  String get takeLevelTest => 'ធ្វើតេស្តកម្រិត';

  @override
  String get reviewToSeeScore => 'ពិនិត្យឡើងវិញ ដើម្បីមើលពិន្ទុការបញ្ចេញសំឡេង';

  @override
  String get playAgain => 'លេងម្តងទៀត';

  @override
  String get difficultySlow => 'យឺត';

  @override
  String get difficultyNormal => 'ធម្មតា';

  @override
  String get difficultyFast => 'លឿន';

  @override
  String get difficultyLabel => 'កម្រិតលំបាក';
}
