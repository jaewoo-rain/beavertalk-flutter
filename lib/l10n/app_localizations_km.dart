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
  String get callDailyLimit => 'ពេលវេលាសិក្សាថ្ងៃនេះបានអស់ហើយ។';

  @override
  String get callAlreadyInCall => 'អ្នកកំពុងនៅក្នុងការហៅរួចហើយ។';

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
  String get callRatingBody =>
      'ការវាយតម្លៃរបស់អ្នកជួយឱ្យការសន្ទនាលើកក្រោយកាន់តែប្រសើរ។';

  @override
  String get callRatingSubmit => 'ផ្ញើ';

  @override
  String get callRatingSkip => 'រំលង';

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
  String get alarmAdd => 'បន្ថែមម៉ោងរោទ៍';

  @override
  String get alarmEdit => 'កែម៉ោងរោទ៍';

  @override
  String get alarmEveryDay => 'រៀងរាល់ថ្ងៃ';

  @override
  String get alarmWeekdays => 'ថ្ងៃធ្វើការ';

  @override
  String get alarmWeekend => 'ចុងសប្តាហ៍';

  @override
  String get alarmNoRepeat => 'មិនធ្វើម្ដងទៀត';

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
  String get alarmModeLearnSub => 'អនុវត្តឃ្លាក្នុងកម្មវិធីសិក្សា';

  @override
  String get alarmModeChatSub => 'និយាយពីអ្វីក៏បាន';

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
  String get newExpressions => 'ឃ្លាថ្មី';

  @override
  String get analysisPrepNote => 'កំពុងពិនិត្យការហៅថ្ងៃនេះ។';

  @override
  String get analysisPrepNoteHint => 'បន្តិចទៀតសារនឹងលេចឡើងនៅទីនេះ';

  @override
  String get analysisPrepTitle => 'សត្វបេវើរកំពុងធ្វើកាតពីឃ្លាថ្ងៃនេះ';

  @override
  String get analysisPrepSub => 'នឹងបង្ហាញនៅទីនេះភ្លាមៗពេលរួចរាល់។';

  @override
  String get analysisPrepStepSave => 'រក្សាទុកការសន្ទនា';

  @override
  String get analysisPrepStepCards => 'បង្កើតកាតឃ្លា';

  @override
  String get analysisPrepStateDone => 'រួចរាល់';

  @override
  String get analysisPrepStateWorking => 'កំពុងដំណើរការ';

  @override
  String get analysisPrepStateWaiting => 'កំពុងរង់ចាំ';

  @override
  String get usedExpressions => 'ឃ្លាដែលអ្នកបានប្រើ';

  @override
  String quizExpressionsCount(int count) {
    return 'ឃ្លាដែលបានរៀន $count';
  }

  @override
  String get quizPassed => 'ត្រឹមត្រូវ';

  @override
  String get quizFailed => 'មើលម្តងទៀត';

  @override
  String get quizPending => 'បន្តលើកក្រោយ';

  @override
  String get analysisResult => 'លទ្ធផលវិភាគ';

  @override
  String get noNewExpressions => 'មិនមានឃ្លាថ្មីពីការសន្ទនានេះទេ។';

  @override
  String get practice => 'អនុវត្ត';

  @override
  String get analysisNativeLabel => 'ម្ចាស់ភាសា';

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
  String get navCall => 'ហៅ';

  @override
  String get homeCourseExpression => 'កន្សោម';

  @override
  String get homeCourseFreetalk => 'សន្ទនា';

  @override
  String homeExpressionsLeft(int count) {
    return 'នៅសល់កន្សោម $count រហូតដល់សន្ទនា';
  }

  @override
  String get homeFreetalkNote => 'ប្រើអ្វីដែលរៀនរួច ហើយសន្ទនាដោយសេរី';

  @override
  String get homeTalkTitle => 'ថ្ងៃនេះមានរឿងអ្វីខ្លះ?';

  @override
  String get homeTalkNote => 'និយាយដោយសេរី ហើយរៀនតាមផ្លូវ។';

  @override
  String get homeModeLearn => 'រៀន';

  @override
  String get homeModeTalk => 'និយាយ';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ថ្ងៃជាប់គ្នា',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'ប្រតិទិនសិក្សា';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ថ្ងៃជាប់គ្នា',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'កំណត់ត្រាល្អបំផុត $count ថ្ងៃ',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'រយៈពេលហៅ';

  @override
  String get streakMetricLearned => 'ឃ្លាដែលបានរៀន';

  @override
  String get streakMetricWords => 'ពាក្យដែលបាននិយាយ';

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
      other: '$count នាទី',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'ថ្ងៃនេះគ្មានការហៅទេ។';

  @override
  String get homeLevelPending => 'មិនទាន់មានកម្រិត';

  @override
  String get homeNoLevelTitle => 'អ្នកមិនទាន់មានកម្រិតទេ';

  @override
  String get homeNoLevelNote => 'បញ្ចប់ការហៅទូរស័ព្ទដំបូង នោះនឹងមានកម្រិត';

  @override
  String get homeCurriculumPendingBadge => 'ឆាប់ៗនេះ';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'កម្មវិធីសិក្សា $language កំពុងរៀបចំ';
  }

  @override
  String get homeCurriculumPendingNote => 'អ្នកនឹងហាត់ឃ្លាទូទៅក្នុងការហៅ';

  @override
  String get myPage => 'ទំព័ររបស់ខ្ញុំ';

  @override
  String get languageSaveFailed => 'មិនអាចរក្សាទុកភាសារបស់អ្នកបានទេ។';

  @override
  String get accountDeleteFailed => 'មិនអាចលុបគណនីរបស់អ្នកបានទេ។';

  @override
  String get changeAvatar => 'ប្តូររូបតំណាង';

  @override
  String get avatarUseNow => 'ប្រើឥឡូវ';

  @override
  String get avatarPurchaseFailed => 'ការទិញមិនបានសម្រេច';

  @override
  String avatarPromoTitle(int percent) {
    return 'តែថ្ងៃនេះ · បញ្ចុះ $percent%';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'នៅសល់ $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'នៅសល់ $days ថ្ងៃ $time';
  }

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
  String pricePerMonth(String price) {
    return '$price / ខែ';
  }

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
  String get challengeLoadingNote => 'កំពុងរៀបចំកាមេរ៉ា និងមីក្រូហ្វូន។';

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
  String accentShareText(String country) {
    return 'ខ្ញុំកំពុងរៀនភាសាកូរ៉េជាមួយ BeaverTalk — សំឡេងកូរ៉េរបស់ខ្ញុំស្តាប់ទៅដូចជា $country! 🦫 មករកសំឡេងរបស់អ្នក ហើយរៀនជាមួយខ្ញុំ៖ https://beavertalk.im';
  }

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
  String get onboardingLevelTestCta => 'ធ្វើតេស្តកម្រិត';

  @override
  String get pronunciation => 'ការបញ្ចេញសំឡេង';

  @override
  String get fluency => 'ភាពស្ទាត់ជំនាញ';

  @override
  String get rhythm => 'ចង្វាក់';

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
  String get loginFacebookSignInFailed => 'ការចូល Facebook បរាជ័យ។';

  @override
  String get loginKakaoSignInFailed => 'ការចូល Kakao បរាជ័យ។';

  @override
  String get loginContinueWithKakao => 'បន្តជាមួយ Kakao';

  @override
  String get loginContinueWithGoogle => 'បន្តជាមួយ Google';

  @override
  String get loginContinueWithFacebook => 'បន្តជាមួយ Facebook';

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
  String get freePlanCallLimit => 'ហៅបាន 5 នាទីក្នុងមួយថ្ងៃ';

  @override
  String get freePlanBasicCharacters => 'រួមបញ្ចូលតួអង្គមូលដ្ឋាន';

  @override
  String get availableForPurchase => 'អាចទិញបាន';

  @override
  String get paymentsLoadError => 'មិនអាចផ្ទុកប្រវត្តិទូទាត់បានទេ';

  @override
  String get noPayments => 'មិនទាន់មានការទូទាត់';

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
  String get levelTestOncePerDay =>
      'អ្នកអាចធ្វើតេស្តកម្រិតបានម្ដងក្នុងមួយថ្ងៃ។ សូមព្យាយាមម្ដងទៀតនៅថ្ងៃស្អែក។';

  @override
  String get levelRetakeTitle => 'ធ្វើតេស្តកម្រិតម្តងទៀតឬ?';

  @override
  String get levelRetakeBody =>
      'បើធ្វើម្តងទៀត វឌ្ឍនភាពរបស់អ្នកនឹងត្រឡប់ទៅមេរៀនដំបូងនៃកម្រិតនោះ — ទោះបីបានកម្រិតដដែលក៏ដោយ។ ឃ្លាដែលបានរៀន និងប្រវត្តិការហៅនៅដដែល។';

  @override
  String get levelRetakeKeep => 'រក្សាវឌ្ឍនភាព';

  @override
  String get levelRetakeConfirm => 'ធ្វើតេស្តម្តងទៀត';

  @override
  String get practicePronunciation => 'អនុវត្តការបញ្ចេញសំឡេង';

  @override
  String get analysisNoScoreReview =>
      'ហាត់ប្រយោគ ដើម្បីទទួលបានពិន្ទុបញ្ចេញសំឡេង';

  @override
  String get analysisNoScoreEmpty => 'គ្មានប្រយោគសម្រាប់ដាក់ពិន្ទុទេ';

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
  String get billingCompareAllPlans => 'ប្រៀបធៀបគម្រោង';

  @override
  String get billingBuyACharacter => 'ទិញតួអង្គ';

  @override
  String get billingRestorePurchases => 'ស្ដារការទិញ';

  @override
  String get billingRedeemCode => 'ប្រើកូដ';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'ហៅជាវីដេអូ 15 នាទីក្នុងមួយថ្ងៃ';

  @override
  String get premiumBulletAnalysis => 'ការវិភាគការបញ្ចេញសំឡេងពេញលេញ';

  @override
  String get premiumBulletWeakSounds =>
      'ហ្វឹកហាត់សំឡេងពិបាកសម្រាប់ភាសារបស់អ្នក';

  @override
  String get noteCharactersSeparate =>
      'តួអង្គលក់ដាច់ដោយឡែក។ តួអង្គដែលអ្នកទិញ នៅតែជារបស់អ្នក។';

  @override
  String get ctaGetPremium => 'ទទួលបាន Premium';

  @override
  String get planMaxTrial => 'ការសាកល្បង Premium';

  @override
  String get freePlanPriceLine => '\$0.00 — ហៅបាន 5 នាទីក្នុងមួយថ្ងៃ';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount ក្នុងមួយខែ';
  }

  @override
  String freeUntilDate(String date) {
    return 'ឥតគិតថ្លៃរហូតដល់ $date';
  }

  @override
  String get todaysCalls => 'ពេលហៅថ្ងៃនេះ';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'បានប្រើ $used ក្នុងចំណោម $limit នាទី';
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
  String get bannerMaxUpsellTitle => 'និយាយទល់មុខគ្នាជាមួយ Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'ការហៅជាវីដេអូ · 15 នាទីក្នុងមួយថ្ងៃ · $price ក្នុងមួយខែ';
  }

  @override
  String get bannerAnnualSwitchTitle => 'ប្ដូរទៅគម្រោងប្រចាំឆ្នាំ';

  @override
  String get bannerPaymentFailedTitle => 'មិនអាចទូទាត់បានទេ';

  @override
  String get bannerPaymentFailedSub =>
      'ធ្វើបច្ចុប្បន្នភាពការទូទាត់នៅក្នុងហាង ដើម្បីរក្សា Premium';

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
  String noteTrialEnds(String date) {
    return 'ការសាកល្បងរបស់អ្នកបញ្ចប់ $date។ បញ្ឈប់នៅក្នុងហាងមុនពេលនោះ នោះនឹងមិនគិតថ្លៃទេ។';
  }

  @override
  String get noteGrace =>
      'អត្ថប្រយោជន៍នៅតែដំណើរការក្នុងរយៈពេលអនុគ្រោះ។ ការបញ្ឈប់មិនដែលត្រូវបានរារាំងក្នុងកម្មវិធីទេ។';

  @override
  String get noteHold =>
      'Premium ត្រូវផ្អាករហូតដល់ការទូទាត់សម្រេច។ តួអង្គ និងវឌ្ឍនភាពរបស់អ្នកនៅសុវត្ថិភាព។';

  @override
  String noteEnding(String date) {
    return 'គម្រោងរបស់អ្នកនឹងបញ្ចប់។ អត្ថប្រយោជន៍ដំណើរការរហូតដល់ $date បន្ទាប់មកអ្នកនឹងទៅ Free។ អាចជាវឡើងវិញបានគ្រប់ពេល។';
  }

  @override
  String get trialExpiredTitle => 'ការសាកល្បង Premium របស់អ្នកបានបញ្ចប់';

  @override
  String get trialExpiredSub => 'ឥឡូវអ្នកនៅលើ Free';

  @override
  String get seePlans => 'មើលគម្រោង';

  @override
  String get currentPlanTitle => 'គម្រោងបច្ចុប្បន្ន';

  @override
  String get perMonthUnit => 'ក្នុងមួយខែ';

  @override
  String get planTaglineFree => 'ហៅបាន 5 នាទីក្នុងមួយថ្ងៃ។ ឥតគិតថ្លៃ។';

  @override
  String get bulletProCorrections => 'ការកែតម្រូវ ផ្អែកលើភាសាកំណើតរបស់អ្នក';

  @override
  String get bulletFreeCall => 'ការហៅជាសំឡេង 5 នាទីក្នុងមួយថ្ងៃ';

  @override
  String get bulletFreeCheck => 'ការវិភាគពេញលេញសម្រាប់ការហៅ 3 ដងដំបូង';

  @override
  String get bulletFreeCharacter => 'តួអង្គ 2 សម្រាប់ចាប់ផ្ដើម';

  @override
  String get ctaTurnOnVideo => 'បើកវីដេអូ';

  @override
  String get noteCallLength =>
      'Premium៖ 15 នាទីក្នុងមួយថ្ងៃ — ក្នុងរយៈពេលនោះ អាចហៅបានប៉ុន្មានដងក៏បាន។';

  @override
  String get paywallProTitle1 => 'មិត្តកូរ៉េរបស់អ្នក';

  @override
  String get paywallProTitle2 => 'ដែលនៅភ្ញាក់ម៉ោង ៣ យប់';

  @override
  String get paywallLimitHeadline => 'Premium ផ្ដល់ការហៅ 15 នាទីក្នុងមួយថ្ងៃ។';

  @override
  String get limitBannerCallTitle => 'ពេលហៅថ្ងៃនេះអស់ហើយ';

  @override
  String get limitBannerCallSub => 'Free ផ្ដល់ការហៅ 5 នាទីក្នុងមួយថ្ងៃ';

  @override
  String get limitBannerCheckTitle => 'នោះជាការត្រួតពិនិត្យថ្ងៃនេះហើយ';

  @override
  String get limitBannerCheckSub => 'Free ផ្ដល់ការត្រួតពិនិត្យមួយក្នុងមួយថ្ងៃ';

  @override
  String get bulletProCharactersForever =>
      'តួអង្គដែលអ្នកទិញ ជារបស់អ្នកជារៀងរហូត';

  @override
  String get paywallMaxTitle => 'ឥឡូវអ្នកអាចនិយាយគ្នាទល់មុខតាមវីដេអូបាន។';

  @override
  String paywallTutorCompare(String price) {
    return 'មួយម៉ោងជាមួយគ្រូបង្រៀនតម្លៃ \$25។ Premium មួយខែតម្លៃ $price។';
  }

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
  String ctaCaptionMaxYearly(String price) {
    return '$price ក្នុងមួយឆ្នាំ · បញ្ឈប់បានគ្រប់ពេលនៅក្នុងហាង';
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
  String get processingTitle => 'កំពុងបញ្ជាក់ការទិញរបស់អ្នក';

  @override
  String get processingSub => 'ជាធម្មតាចំណាយពេលពីរបីវិនាទី។';

  @override
  String get successProTitle => 'អ្នកនៅលើ Premium ហើយ។';

  @override
  String get successMaxTitle => 'ឥឡូវអ្នកអាចមើលឃើញគ្នាបានហើយ។';

  @override
  String get successMaxSub =>
      'ការហៅជាវីដេអូបើកហើយ។ ចុចប៊ូតុងវីដេអូក្នុងការហៅណាមួយ។';

  @override
  String get ctaStartAVideoCall => 'ចាប់ផ្ដើមការហៅជាវីដេអូ';

  @override
  String get ctaSeeYourSubscription => 'មើលការជាវរបស់អ្នក';

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
  String get ctaKeepMax => 'រក្សា Premium';

  @override
  String get winbackSkip => 'រំលង';

  @override
  String get winbackTitle => 'គម្រោង Premium របស់អ្នកបានបញ្ចប់';

  @override
  String get winbackSub => 'ឥឡូវអ្នកនៅលើ Free — ហៅបាន 5 នាទីក្នុងមួយថ្ងៃ។';

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
  String get ovRestoreSuccessTitle => 'Premium ត្រលប់មកវិញហើយ';

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
  String get ovCharacterOfferTitle => 'មិនទាន់ត្រៀមខ្លួនសម្រាប់ Premium?';

  @override
  String get ovCharacterOfferBody =>
      'ជ្រើសតួអង្គមួយ ហើយរក្សាទុក។ ការទិញម្ដង — គ្មានការជាវ គ្មានការបន្ត។';

  @override
  String get rowOneCharacter => 'តួអង្គមួយ';

  @override
  String rowFromPrice(String price) {
    return '$price ក្នុងមួយ';
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
  String get rowProRunsUntil => 'Premium ដំណើរការរហូតដល់';

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
      'គម្រោងប្រចាំឆ្នាំមានតម្លៃថោកជាងការបង់ប្រចាំខែ។';

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
      'Premium នៅដំណើរការ លុះត្រាតែអ្នកបញ្ឈប់។ នេះជាអ្វីដែលនឹងកើតឡើង។';

  @override
  String get rowTrialEnds => 'ការសាកល្បងបញ្ចប់';

  @override
  String get rowFirstCharge => 'ការគិតថ្លៃដំបូង';

  @override
  String get rowThenMonthly => 'បន្ទាប់មកប្រចាំខែ';

  @override
  String get ctaCancelInStore => 'បញ្ឈប់នៅក្នុងហាង';

  @override
  String get ovTrialStartTitle => 'Premium ៧ ថ្ងៃ ឥតគិតថ្លៃ';

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
      'ជម្រើសល្អ។ Premium ដដែលមានតម្លៃទាបជាង ប្រសិនបើបង់ប្រចាំឆ្នាំ។';

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
  String get ovAlreadyTitle => 'អ្នកនៅលើ Premium រួចហើយ';

  @override
  String get ovAlreadyBody => 'គណនីហាងនេះមានគម្រោងសកម្ម។ គ្មានអ្វីត្រូវទិញទេ។';

  @override
  String get ctaSeeMySubscription => 'មើលការជាវរបស់ខ្ញុំ';

  @override
  String get subCancelTitle => 'បញ្ឈប់ការជាវ';

  @override
  String subCancelBody(String date) {
    return 'Premium ដំណើរការដល់ $date។ បន្ទាប់មកអ្នកនឹងទៅ Free។';
  }

  @override
  String get subWhatYouLose => 'អ្វីដែលអ្នកនឹងបាត់បង់';

  @override
  String get benefitScoring => 'ដាក់ពិន្ទុការបញ្ចេញសំឡេង តាមអក្សរនីមួយៗ';

  @override
  String get benefitEveryMetric => 'រាល់រង្វាស់ រាល់ប្រយោគ';

  @override
  String get subPaymentTitle => 'ធ្វើបច្ចុប្បន្នភាពការទូទាត់';

  @override
  String get subPaymentBody =>
      'មិនអាចទូទាត់បានទេ។ Premium នៅដំណើរការក្នុងរយៈពេលអនុគ្រោះ។';

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
    return 'Premium បញ្ចប់នៅ $date។ បើកការបន្តស្វ័យប្រវត្តិឡើងវិញ នោះគ្មានអ្វីផ្លាស់ប្ដូរទេ។';
  }

  @override
  String get subWhatYouKeep => 'អ្វីដែលអ្នកនៅរក្សាបាន';

  @override
  String get ctaTurnItBackOn => 'បើកវាឡើងវិញ';

  @override
  String get flTodayTitle => 'ពេលហៅថ្ងៃនេះអស់ហើយ';

  @override
  String get flTodayBody => 'បន្តពីកន្លែងដែលអ្នកឈប់ — ឥឡូវនេះ។';

  @override
  String get flCheckTitle => 'នោះជាការត្រួតពិនិត្យថ្ងៃនេះហើយ';

  @override
  String get flCheckBody =>
      'Free មានការពិនិត្យ 1 ដងក្នុងមួយថ្ងៃ។ Premium ផ្ដល់ការវិភាគពេញលេញ។';

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
  String get emailLabel => 'អ៊ីមែល';

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
  String get subscriptionRow => 'ការជាវ';

  @override
  String get iapSuccessTitle => 'ការទិញបានបញ្ចប់';

  @override
  String iapSuccessBody(String name) {
    return 'តួអង្គ $name ជារបស់អ្នកជារៀងរហូត។\nអនុវត្តភ្លាមៗនៅពេលបញ្ជាក់វិក្កយបត្រ។';
  }

  @override
  String get ctaGoHome => 'ទៅទំព័រដើម';

  @override
  String get ctaUseNow => 'ប្រើឥឡូវនេះ';

  @override
  String get iapFailTitle => 'ការទូទាត់មិនបានសម្រេច';

  @override
  String get iapFailBody => 'អ្នកអាចព្យាយាមម្តងទៀត';

  @override
  String get paywallGuardTitle => 'អ្នកអាចបន្តប្រើ Free បាន';

  @override
  String get paywallGuardBody => 'អ្នកនៅតែហៅបាន 5 នាទីក្នុងមួយថ្ងៃ។';

  @override
  String get ctaMaybeLater => 'ពេលក្រោយ';

  @override
  String get winbackOfferBadge => 'បញ្ចុះ 50% ខែដំបូង';

  @override
  String get winbackOfferTitle => 'សូមស្វាគមន៍ការត្រឡប់មកវិញ';

  @override
  String get ctaGetHalfOff => 'យកការបញ្ចុះ 50%';

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
  String get playAgain => 'លេងម្តងទៀត';

  @override
  String get difficultySlow => 'យឺត';

  @override
  String get difficultyNormal => 'ធម្មតា';

  @override
  String get difficultyFast => 'លឿន';

  @override
  String get difficultyLabel => 'កម្រិតលំបាក';

  @override
  String get connected => 'បានភ្ជាប់';

  @override
  String get unlockedWithMax => 'រួមបញ្ចូលក្នុងគម្រោងរបស់អ្នក';

  @override
  String get fcEndedTitle => 'ការហៅទូរស័ព្ទឥតគិតថ្លៃរបស់អ្នកបានបញ្ចប់';

  @override
  String get fcEndedBody =>
      'ការហៅឥតគិតថ្លៃមានរយៈពេលដល់ទៅ ៥ នាទី\nជាវដើម្បីនិយាយបានយូរជាងនេះ';

  @override
  String get ctaSubscribeKeepTalking => 'ជាវ ហើយបន្តនិយាយ';

  @override
  String get kgTitle => 'បន្តទៀតទេ?';

  @override
  String get kgBody => 'ការហៅបន្តជាដំណាក់កាលខ្លីៗ។\nយើងនឹងសួរម្ដងទៀតរាល់ពេល។';

  @override
  String get pcEndedTitleToday => 'យើងបញ្ចប់ការហៅថ្ងៃនេះសិន។';

  @override
  String get pcEndedBodyToday =>
      'រំលឹកអ្វីដែលយើងបាននិយាយ ហើយហៅមកម្ដងទៀតនៅថ្ងៃស្អែក!';

  @override
  String get pcEndedTitle => 'យើងបញ្ចប់ការហៅនេះសិន។';

  @override
  String get pcEndedBody => 'រំលឹកអ្វីដែលយើងបាននិយាយ ហើយហៅមកម្ដងទៀត!';

  @override
  String get ctaKeepTalking => 'បន្តនិយាយ';

  @override
  String get callModeSheetTitle => 'តើអ្នកចង់និយាយបែបណា?';

  @override
  String get callModeSheetSubtitle => 'អនុវត្តភ្លាមៗចំពោះការហៅនេះ';

  @override
  String get callModeFreeTalk => 'ការសន្ទនាសេរី';

  @override
  String get callModeFreeTalkDesc => 'និយាយដោយគ្មានការកែតម្រូវ';

  @override
  String get callModeStudy => 'ការសិក្សា';

  @override
  String get callModeStudyDesc => 'រៀនកន្សោមម្តងមួយ';

  @override
  String get callModeChange => 'ប្តូររបៀប';

  @override
  String get callModeKeep => 'មិនទាន់ទេ';

  @override
  String get callExitTitle => 'បញ្ចប់ការហៅនេះ?';

  @override
  String get callExitSubtitle =>
      'បើបញ្ចប់ឥឡូវ ពេលដែលបាននិយាយនៅតែរាប់ក្នុងការប្រើថ្ងៃនេះ';

  @override
  String get callExitKeep => 'បន្តនិយាយ';

  @override
  String get callExitConfirm => 'បញ្ចប់ការហៅ';

  @override
  String get callMicMute => 'បិទសំឡេង';

  @override
  String get callMicUnmute => 'បើកសំឡេង';

  @override
  String get callPushToTalk => 'សង្កត់ដើម្បីនិយាយ';

  @override
  String get callFreeEndedTitle => 'ការហៅឥតគិតថ្លៃរបស់អ្នកបានបញ្ចប់';

  @override
  String get callFreeEndedCta => 'ជាវ ហើយបន្តនិយាយ';

  @override
  String get callKeepGoingTitle => 'បន្តទេ?';

  @override
  String get callKeepGoingSubtitle =>
      'ការហៅបន្តជា ៥ នាទីម្តង។ យើងនឹងសួរម្តងទៀតរាល់ពេល។';

  @override
  String get articulationSelectedWord => 'ពាក្យដែលបានជ្រើស';

  @override
  String get articulationYouSaid => 'ការបញ្ចេញសំឡេងរបស់អ្នក';

  @override
  String get articulationTargetSound => 'គោលដៅ';

  @override
  String get reportEntry => 'រាយការណ៍';

  @override
  String get reportTitle => 'រាយការណ៍';

  @override
  String get reportPrompt => 'មានបញ្ហាអ្វី?';

  @override
  String get reportGuide =>
      'សូមប្រាប់យើងពីខ្លឹមសាររបស់តួអង្គ AI ដែលធ្វើឱ្យអ្នកមិនស្រួល។ យើងពិនិត្យរាល់របាយការណ៍។';

  @override
  String get reportReasonSexual => 'ខ្លឹមសារផ្លូវភេទ';

  @override
  String get reportReasonHate => 'ការស្អប់ខ្ពើម ឬការរើសអើង';

  @override
  String get reportReasonViolence => 'ខ្លឹមសារហិង្សា ឬគំរាមកំហែង';

  @override
  String get reportReasonSelfHarm => 'លើកទឹកចិត្តឱ្យធ្វើបាបខ្លួនឯង';

  @override
  String get reportReasonMisinfo => 'ព័ត៌មានមិនពិត';

  @override
  String get reportReasonOther => 'បញ្ហាផ្សេងទៀត';

  @override
  String get reportDetailHint => 'សរសេរអំពីអ្វីដែលបានកើតឡើង (ស្រេចចិត្ត)';

  @override
  String get reportSubmit => 'ផ្ញើរបាយការណ៍';

  @override
  String get reportDoneTitle => 'បានទទួលរបាយការណ៍របស់អ្នក';

  @override
  String get reportDoneBody =>
      'យើងនឹងពិនិត្យ ហើយចាត់វិធានការបើចាំបាច់។ អរគុណដែលជួយរក្សា BeaverTalk ឱ្យមានសុវត្ថិភាព។';

  @override
  String get reportFailed => 'មិនអាចផ្ញើរបាយការណ៍បានទេ។ សូមព្យាយាមម្តងទៀត។';

  @override
  String get hwTitle => 'កិច្ចការផ្ទះ';

  @override
  String get hwJoinCodeTitle => 'បញ្ចូលលេខកូដថ្នាក់របស់អ្នក';

  @override
  String get hwJoinCodeSubtitle => 'វាជាកូដ ៦ តួអក្សរដែលគ្រូបានផ្ដល់ឱ្យ';

  @override
  String get hwJoinCodeLabel => 'លេខកូដថ្នាក់';

  @override
  String get hwJoinCodeHelp => 'លេខកូដមិនប្រកាន់អក្សរធំតូចទេ';

  @override
  String get hwJoinConfirmTitle => 'តើនេះជាថ្នាក់ត្រឹមត្រូវទេ?';

  @override
  String get hwJoinConfirmSubtitle => 'បើមិនមែនទេ សូមពិនិត្យលេខកូដម្តងទៀត';

  @override
  String get hwJoinFieldInstitution => 'ស្ថាប័ន';

  @override
  String get hwJoinFieldTeacher => 'គ្រូ';

  @override
  String get hwJoinFieldLearners => 'អ្នកសិក្សា';

  @override
  String get hwJoinFieldTerm => 'វគ្គ';

  @override
  String get hwJoinConfirmNote =>
      'ឈ្មោះថ្នាក់បង្ហាញដូចគ្រូបានសរសេរ។ យើងមិនបកប្រែទេ។';

  @override
  String get hwJoinConfirmYes => 'បាទ/ចាស នេះហើយ';

  @override
  String get hwJoinConfirmRetry => 'បញ្ចូលលេខកូដម្តងទៀត';

  @override
  String get hwJoinProfileTitle => 'តើអ្នកនឹងប្រើឈ្មោះអ្វីនៅក្នុងថ្នាក់?';

  @override
  String get hwJoinProfileSubtitle =>
      'គ្រូនឹងផ្ទៀងផ្ទាត់វាជាមួយបញ្ជីឈ្មោះថ្នាក់';

  @override
  String get hwJoinNameLabel => 'ឈ្មោះ';

  @override
  String get hwJoinNameHelp => 'អាចខុសពីឈ្មោះក្នុងកម្មវិធី';

  @override
  String get hwJoinStudentNoLabel => 'លេខសិស្ស (មិនចាំបាច់)';

  @override
  String get hwJoinStudentNoHelp => 'គ្រូប្រើវាដើម្បីផ្ទៀងផ្ទាត់បញ្ជីឈ្មោះ';

  @override
  String get hwJoinConsentTitle => 'អ្វីដែលគ្រូឃើញ';

  @override
  String get hwJoinConsentSubtitle => 'អ្នកត្រូវយល់ព្រមដើម្បីចូលរួមថ្នាក់';

  @override
  String get hwJoinConsentSharedHeading => 'ចែករំលែកជាមួយគ្រូ';

  @override
  String get hwJoinConsentShared1 => 'ឈ្មោះថ្នាក់ និងលេខសិស្ស';

  @override
  String get hwJoinConsentShared2 => 'ថាតើអ្នកបានធ្វើកិច្ចការផ្ទះឬអត់';

  @override
  String get hwJoinConsentShared3 => 'ប្រយោគដែលជាប់ និងធ្លាក់';

  @override
  String get hwJoinConsentShared4 => 'រយៈពេល និងសេចក្ដីសង្ខេបនៃការហៅកិច្ចការ';

  @override
  String get hwJoinConsentNotSharedHeading => 'មិនចែករំលែក';

  @override
  String get hwJoinConsentNotShared1 => 'អ៊ីមែល និងលេខទូរស័ព្ទ';

  @override
  String get hwJoinConsentNotShared2 =>
      'ឈ្មោះក្នុងកម្មវិធី ប្រវត្តិរូប និងតួអង្គ';

  @override
  String get hwJoinConsentNotShared3 => 'សញ្ជាតិ និងភាសាកំណើត';

  @override
  String get hwJoinConsentNotShared4 => 'ការហៅ និងការសិក្សានៅក្រៅថ្នាក់';

  @override
  String get hwJoinConsentNotShared5 => 'ព័ត៌មានការជាវ និងការទូទាត់';

  @override
  String get hwJoinConsentAgree => 'ខ្ញុំយល់ព្រមតាមខាងលើ';

  @override
  String get hwJoinConsentCta => 'យល់ព្រម និងចូលរួម';

  @override
  String hwJoinDoneTitle(String className) {
    return 'អ្នកបានចូលរួម $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'មានកិច្ចការ $count កំពុងរង់ចាំ';
  }

  @override
  String get hwJoinDoneNoAssignment => 'មិនទាន់មានកិច្ចការទេ';

  @override
  String get hwJoinDoneNextDue => 'កាលបរិច្ឆេទបន្ទាប់';

  @override
  String get hwJoinDoneRosterName => 'ឈ្មោះរបស់អ្នកក្នុងថ្នាក់';

  @override
  String get hwJoinDoneCta => 'មើលកិច្ចការផ្ទះ';

  @override
  String get hwJoinErrorNotFound => 'រកមិនឃើញលេខកូដនោះទេ';

  @override
  String get hwJoinErrorNotFoundBody => 'សូមពិនិត្យលេខទាំងប្រាំមួយម្តងទៀត។';

  @override
  String get hwJoinErrorExpired => 'លេខកូដនោះផុតកំណត់ហើយ';

  @override
  String get hwJoinErrorExpiredBody => 'សូមសុំលេខកូដថ្មីពីគ្រូ។';

  @override
  String get hwJoinErrorFull => 'ថ្នាក់ពេញហើយ';

  @override
  String get hwJoinErrorFullBody => 'សូមប្រាប់គ្រូរបស់អ្នក។';

  @override
  String get hwJoinFailed => 'មិនអាចចូលរួមបានទេ។ សូមព្យាយាមម្តងទៀតបន្តិចទៀត។';

  @override
  String get hwSectionInProgress => 'កំពុងដំណើរការ';

  @override
  String get hwSectionUpcoming => 'នឹងមកដល់';

  @override
  String get hwSectionDone => 'រួចរាល់';

  @override
  String get hwLeaveClassLink => 'ចាកចេញពីថ្នាក់';

  @override
  String get hwListEmptyTitle => 'មិនទាន់មានកិច្ចការផ្ទះទេ';

  @override
  String get hwListEmptyBody => 'វានឹងបង្ហាញនៅទីនេះពេលគ្រូផ្ដល់ឱ្យ។';

  @override
  String get hwListFailed => 'មិនអាចផ្ទុកកិច្ចការផ្ទះបានទេ។';

  @override
  String get hwRetry => 'ព្យាយាមម្តងទៀត';

  @override
  String get hwBadgeDone => 'រួចរាល់';

  @override
  String get hwBadgeOverdue => 'មិនទាន់ដាក់ស្នើ';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'មិនទាន់ដាក់ស្នើ យឺត $days ថ្ងៃ';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'ផុតកំណត់ថ្ងៃនេះ';

  @override
  String get hwActivitySpeaking => 'និយាយ';

  @override
  String get hwActivityConversation => 'សន្ទនា';

  @override
  String get hwActivityWorkbook => 'សៀវភៅលំហាត់';

  @override
  String hwChapterLabel(String chapter) {
    return 'ជំពូក $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'ពិនិត្យពិន្ទុការបញ្ចេញសំឡេងរបស់អ្នក';

  @override
  String get hwTaskConversationDesc => 'ប្រើអ្វីដែលបានរៀនក្នុងការសន្ទនាពិត';

  @override
  String get hwConversationOnce =>
      'ការសន្ទនាធ្វើបានតែម្តងក្នុងកិច្ចការផ្ទះមួយ។';

  @override
  String get hwTaskWorkbookDesc => 'អនុវត្តដោយសរសេរក្នុងសៀវភៅលំហាត់';

  @override
  String get hwCtaStudy => 'ចាប់ផ្ដើម';

  @override
  String get hwCtaResult => 'មើលលទ្ធផល';

  @override
  String get hwCtaDownload => 'ទាញយក';

  @override
  String get hwSpeakingNoScore => 'អ្នកមិនទាន់បានធ្វើកិច្ចការនិយាយទេ';

  @override
  String get hwWorkbookUnavailable => 'ឯកសារសៀវភៅលំហាត់មិនទាន់មានទេ។';

  @override
  String get hwDetailClosed =>
      'កិច្ចការនេះបានបិទហើយ។ អ្នកមិនអាចដាក់ស្នើបានទៀតទេ។';

  @override
  String get hwLeaveTitle => 'ចាកចេញពីថ្នាក់?';

  @override
  String get hwLeaveBody =>
      'គ្រូរបស់អ្នកនឹងលែងឃើញលទ្ធផលកិច្ចការផ្ទះរបស់អ្នកទៀតហើយ។';

  @override
  String get hwLeaveConfirm => 'ចាកចេញ';

  @override
  String get hwLeaveCancel => 'នៅបន្ត';

  @override
  String get hwLeaveFailed => 'មិនអាចចាកចេញពីថ្នាក់បានទេ។';

  @override
  String get hwMyClass => 'ថ្នាក់របស់ខ្ញុំ';

  @override
  String get hwClassEmptyTitle => 'អ្នកមិនទាន់ចូលរួមថ្នាក់ណាមួយទេ';

  @override
  String get hwClassEmptySubtitle => 'បញ្ចូលលេខកូដដែលគ្រូបានផ្ដល់ឱ្យ';

  @override
  String get hwClassEmptyCta => 'បញ្ចូលលេខកូដថ្នាក់';

  @override
  String get hwClassContinueCta => 'បន្ត';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return 'កិច្ចការ $count ផុតកំណត់ថ្ងៃស្អែក';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'អ្នកមានកិច្ចការ $count ដែលមិនទាន់ដាក់ស្នើ';
  }

  @override
  String get hwSpeakingUnavailable => 'ប្រយោគសម្រាប់កិច្ចការនេះមិនទាន់មានទេ។';

  @override
  String get hwBadgeClosed => 'បិទ';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return 'ជាប់ $passed ក្នុងចំណោម $total ប្រយោគ';
  }

  @override
  String get challengeFirstWord => 'ពាក្យទីមួយ';

  @override
  String get challengeSeeAnalysis => 'មើលលទ្ធផល';

  @override
  String get challengePaused => 'បានផ្អាក';

  @override
  String get challengePausedNote => 'នាឡិកា និងការថតបានឈប់ជាមួយគ្នា។';

  @override
  String get challengeTimeLeft => 'ពេលនៅសល់';

  @override
  String get challengeScoreLabel => 'ពិន្ទុ';

  @override
  String get challengeResume => 'បន្ត';

  @override
  String get challengeBlockedTitle => 'មិនអាចប្រើកាមេរ៉ាបានទេ';

  @override
  String get challengeBlockedNote =>
      'សូមបើកសិទ្ធិកាមេរ៉ា និងមីក្រូហ្វូននៅក្នុងការកំណត់។';

  @override
  String get challengeGoBack => 'ត្រឡប់ក្រោយ';

  @override
  String get challengeOpenSettings => 'បើកការកំណត់';

  @override
  String get saveDone => 'បានរក្សាទុកក្នុងវិចិត្រសាល';

  @override
  String get saveFailed => 'មិនអាចរក្សាទុកបានទេ';

  @override
  String get saveDeniedNote => 'ត្រូវការសិទ្ធិចូលមើលរូបភាព';

  @override
  String get callIncomingCallerFallback => 'គ្រូ Beaver';

  @override
  String get callIncomingHandle => 'ការហៅជាភាសាកូរ៉េ';

  @override
  String get callMissedTitle => 'ការហៅដែលខកខាន';

  @override
  String get callMissedChannelDescription =>
      'ជូនដំណឹងពេលអ្នកខកខានការហៅពី Beaver។';

  @override
  String callMissedBody(String name) {
    return '$name បានហៅអ្នក';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'ត្រូវការការអនុញ្ញាតជូនដំណឹង ដើម្បីទទួលការហៅ។';

  @override
  String get callNotifPermissionRequired =>
      'សូមអនុញ្ញាតការជូនដំណឹងក្នុងការកំណត់។';

  @override
  String get callHintLockedTitle => 'មិនអាចប្រើជំនួយក្នុងការសិក្សាបានទេ';

  @override
  String get wsTitle => 'សំឡេងពិបាក';

  @override
  String get wsToList => 'ទៅបញ្ជី';

  @override
  String get wsNext => 'បន្ទាប់';

  @override
  String get wsRetry => 'ព្យាយាមម្ដងទៀត';

  @override
  String get wsDone => 'រួចរាល់';

  @override
  String get wsContinue => 'បន្តទៀត';

  @override
  String get wsQuit => 'ចាកចេញ';

  @override
  String get wsRetryLater => 'សូមព្យាយាមម្ដងទៀតបន្តិចទៀត។';

  @override
  String get wsMissingTitle => 'រកមិនឃើញសំឡេងនោះទេ';

  @override
  String get wsMissingBody => 'សូមជ្រើសរើសពីបញ្ជីម្ដងទៀត។';

  @override
  String get wsListLoadFailed => 'មិនអាចផ្ទុកបញ្ជីបានទេ';

  @override
  String get wsLessonLoadFailed => 'មិនអាចផ្ទុកមេរៀនបានទេ';

  @override
  String get wsNationalTitle => 'សំឡេងពិបាកតាមសំនៀងរបស់អ្នក';

  @override
  String get wsNationalPending => 'នឹងបំពេញពេលវិភាគសំនៀងរបស់អ្នករួច';

  @override
  String get wsNationalPicked => 'ជ្រើសរើសតាមលទ្ធផលវិភាគសំនៀង';

  @override
  String get wsNationalEmptyBody =>
      'ហៅច្រើនបន្តិចទៀត យើងនឹងវិភាគសំនៀងរបស់អ្នក។';

  @override
  String get wsMineTitle => 'សំឡេងពិបាករបស់ខ្ញុំ';

  @override
  String get wsMineSubtitle => 'សំឡេងដែលបានវាស់ក្នុងការហៅថ្មីៗរបស់អ្នក';

  @override
  String get wsMineEmptyBody => 'ហៅ និងរំលឹក សំឡេងពិបាករបស់អ្នកនឹងកើនឡើង។';

  @override
  String get wsNoDataYet => 'មិនទាន់មានទិន្នន័យទេ';

  @override
  String get wsGoToCall => 'ចាប់ផ្ដើមការហៅ';

  @override
  String get wsRule => 'វិធាន';

  @override
  String get wsRecommended => 'បានណែនាំ';

  @override
  String get wsNotMeasured => 'មិនទាន់វាស់';

  @override
  String get wsStepUnderstand => 'ស្វែងយល់';

  @override
  String get wsStepWords => 'ពាក្យ';

  @override
  String get wsStepSentence => 'ប្រយោគ';

  @override
  String get wsStepTest => 'តេស្ត';

  @override
  String get wsQuitTitle => 'ឈប់អនុវត្តឬ?';

  @override
  String get wsQuitBody => 'បើចេញឥឡូវ ការអនុវត្តនេះនឹងមិនត្រូវបានរក្សាទុកទេ។';

  @override
  String get wsHowToSound => 'របៀបបញ្ចេញសំឡេង';

  @override
  String get wsPracticeWords => 'អនុវត្តពាក្យ';

  @override
  String get wsPracticeSentence => 'អនុវត្តប្រយោគ';

  @override
  String get wsPracticeAgain => 'ម្ដងទៀត';

  @override
  String get wsStartTest => 'ធ្វើតេស្តចុងក្រោយ';

  @override
  String get wsThisSentence => 'ប្រយោគនេះ';

  @override
  String get wsNoScoreNote => 'ជំហាននេះមិនគិតពិន្ទុទេ។ គ្រាន់តែនិយាយតាម។';

  @override
  String get wsListen => 'ស្តាប់ឱ្យបានល្អ';

  @override
  String get wsSayNow => 'ឥឡូវនិយាយតាម';

  @override
  String get wsPracticeDone => 'អនុវត្តរួចរាល់';

  @override
  String get wsPaused => 'បានផ្អាក';

  @override
  String get wsAudioFailed => 'មិនអាចផ្ទុកសំឡេងបានទេ។ សូមអានតាមអក្សរ។';

  @override
  String get wsReadAloud => 'សូមអានប្រយោគខាងក្រោមឱ្យឮៗ';

  @override
  String get wsTapToStart => 'ចុចដើម្បីចាប់ផ្ដើម';

  @override
  String get wsTapWhenDone => 'ចុចពេលអ្នករួចរាល់';

  @override
  String get wsScoring => 'កំពុងគិតពិន្ទុ';

  @override
  String get wsMicFailed => 'មិនអាចបើកមីក្រូហ្វូនបានទេ។';

  @override
  String get wsMicPermissionBody =>
      'ការធ្វើតេស្តនេះត្រូវអានឮៗ ដូច្នេះត្រូវការមីក្រូហ្វូន។ សូមបើកការចូលប្រើមីក្រូហ្វូននៅក្នុងការកំណត់។';

  @override
  String get wsNoSound => 'យើងមិនបានឮអ្វីទេ។ ព្យាយាមម្ដងទៀតឬ?';

  @override
  String get wsScoreFailed => 'ការគិតពិន្ទុបានបរាជ័យ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get wsSomethingWrong => 'មានបញ្ហាកើតឡើង។';

  @override
  String get wsLearnDone => 'មេរៀនរួចរាល់';

  @override
  String get wsRetest => 'តេស្តម្ដងទៀត';

  @override
  String get wsFirstMeasure => 'ការវាស់លើកទី១';

  @override
  String get wsFinalTest => 'តេស្តចុងក្រោយ';

  @override
  String wsPoints(int score) {
    return '$score ពិន្ទុ';
  }

  @override
  String wsBeforePoints(int score) {
    return 'មុន $score ពិន្ទុ';
  }

  @override
  String wsGoalPoints(int score) {
    return 'គោលដៅ $score ពិន្ទុ';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'គោលដៅ · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return 'សំនៀង $country';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'និយាយតាម $count ពាក្យ';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'និយាយតាម $count ចំណែក';
  }

  @override
  String get wsStartRecommended => 'ចាប់ផ្ដើមពីសំឡេងដែលបានណែនាំ';

  @override
  String wsStartRecommendedWith(String label) {
    return 'ចាប់ផ្ដើម · $label';
  }

  @override
  String get wsPointsUnit => 'ពិន្ទុ';

  @override
  String get wsEnterFromMypage => 'អនុវត្តសំឡេងពិបាក';

  @override
  String wsGoalOnly(int score) {
    return 'គោលដៅ $score';
  }

  @override
  String wsSoundOf(String label) {
    return 'សំឡេង $label';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc។ ពេលជួបវាម្ដងទៀតក្នុងការហៅ សូមនឹកឃើញរូបរាងនេះ។';
  }

  @override
  String wsNationalSubtitle(String country) {
    return 'សំឡេងដែលអ្នកនិយាយមកពី $country ច្រើនតែខុស';
  }
}
