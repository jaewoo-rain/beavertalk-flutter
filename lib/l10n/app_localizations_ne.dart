// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get loginRequired => 'साइन इन गर्नुपर्छ।';

  @override
  String get callWebNotSupported =>
      'वेबमा भ्वाइस कल समर्थित छैन। एप प्रयोग गर्नुहोस्।';

  @override
  String get micPermissionRequiredForCall =>
      'माइक्रोफोन अनुमति आवश्यक छ। कल गर्न माइक्रोफोन अनुमति दिनुहोस्।';

  @override
  String get callErrorGeneric => 'कलको क्रममा त्रुटि भयो।';

  @override
  String get callNetworkError => 'नेटवर्क त्रुटि भयो।';

  @override
  String get authInvalidCredentials => 'इमेल वा पासवर्ड मिलेन।';

  @override
  String get authEmailAlreadyRegistered => 'यो इमेल पहिले नै दर्ता भइसकेको छ।';

  @override
  String get authConfirmEmailRequired =>
      'तपाईंको इमेलमा पठाइएको प्रमाणीकरण पूरा गर्नुहोस्।';

  @override
  String get authResetCodeSent =>
      'हामीले तपाईंको इमेलमा प्रमाणीकरण कोड पठायौं।';

  @override
  String get authResetCodeInvalid => 'कोड मिलेन वा म्याद सकियो।';

  @override
  String get authPasswordUpdated => 'तपाईंको पासवर्ड रिसेट भयो।';

  @override
  String get authAppleTokenMissing => 'Apple साइन-इन टोकन प्राप्त भएन।';

  @override
  String callEndedDuration(String duration) {
    return 'कल $duration मा समाप्त भयो';
  }

  @override
  String get callRatingPrompt => 'तपाईंको कल कस्तो थियो?';

  @override
  String get ratingBad => 'राम्रो थिएन';

  @override
  String get ratingOkay => 'ठिकै छ';

  @override
  String get ratingGood => 'राम्रो';

  @override
  String get goHome => 'गृहपृष्ठ';

  @override
  String get viewAnalysis => 'विश्लेषण हेर्नुहोस्';

  @override
  String get loadingShort => 'लोड हुँदैछ…';

  @override
  String ratingSubmitFailed(String message) {
    return 'मूल्याङ्कन पठाउन असफल: $message';
  }

  @override
  String get callInfoNotFound => 'कल जानकारी फेला परेन, विश्लेषण छोडियो।';

  @override
  String get tabRecords => 'रेकर्डहरू';

  @override
  String get tabArchive => 'अभिलेख';

  @override
  String get callHistory => 'कल इतिहास';

  @override
  String get conversationRecord => 'कुराकानीको रेकर्ड';

  @override
  String get noCallRecords => 'अहिलेसम्म कुनै कल रेकर्ड छैन';

  @override
  String get noCallRecordsBody =>
      'AI सँग तपाईंको पहिलो कल सकिएपछि,\nतपाईंको रेकर्डहरू यहाँ देखिनेछ।';

  @override
  String get startCall => 'कल सुरु गर्नुहोस्';

  @override
  String get recordsLoadError => 'रेकर्डहरू लोड गर्न सकिएन';

  @override
  String get tryAgainLater => 'कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes मिनेट $seconds सेकेन्ड';
  }

  @override
  String get scheduleManagement => 'तालिका';

  @override
  String get alarms => 'अलार्महरू';

  @override
  String get addSchedule => 'तालिका थप्नुहोस्';

  @override
  String get editSchedule => 'तालिका सम्पादन गर्नुहोस्';

  @override
  String get somethingWentWrong => 'केही समस्या भयो';

  @override
  String get alarmsLoadError => 'अलार्महरू लोड गर्न सकिएन';

  @override
  String get charactersLoadError => 'क्यारेक्टरहरू लोड गर्न सकिएन';

  @override
  String get noCharacters => 'कुनै क्यारेक्टर उपलब्ध छैन';

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get repeat => 'दोहोर्याउनुहोस्';

  @override
  String get callPartner => 'क्यारेक्टर';

  @override
  String get quickStart => 'छिटो सुरु';

  @override
  String get presetMorning => 'बिहानको दिनचर्या';

  @override
  String get presetMorningSub => 'कामका दिन 8:00';

  @override
  String get presetEvening => 'साँझको समापन';

  @override
  String get presetEveningSub => 'हरेक दिन 21:00';

  @override
  String get presetCustom => 'आफ्नै अनुसार';

  @override
  String get presetCustomSub => 'स्वतन्त्र रूपमा';

  @override
  String alarmSummary(int count, int monthly) {
    return 'हप्तामा $count पटक · महिनामा $monthly कल';
  }

  @override
  String get alarmSummaryNone => 'कम्तीमा एक दिन छान्नुहोस्';

  @override
  String get partnerInUse => 'प्रयोगमा';

  @override
  String get partnerOwned => 'तपाईंसँग छ';

  @override
  String get am => 'पूर्वाह्न';

  @override
  String get pm => 'अपराह्न';

  @override
  String get save => 'सेभ गर्नुहोस्';

  @override
  String get conversation => 'कुराकानी';

  @override
  String get review => 'समीक्षा';

  @override
  String get pronunciationChallenge => 'उच्चारण चुनौती';

  @override
  String get newExpressions => 'नयाँ अभिव्यक्तिहरू';

  @override
  String get analysisResult => 'विश्लेषण नतिजा';

  @override
  String get noNewExpressions => 'यस कुराकानीबाट कुनै नयाँ अभिव्यक्ति छैन।';

  @override
  String get practice => 'अभ्यास';

  @override
  String recentScore(int score) {
    return 'हालको स्कोर $score%';
  }

  @override
  String callSequence(int count) {
    return '$count औं कल';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name को एक कुरा';
  }

  @override
  String characterNoteFooter(String name) {
    return 'कल सकिएपछि $name ले छोडेको';
  }

  @override
  String newExpressionsCount(int count) {
    return 'नयाँ अभिव्यक्ति $count';
  }

  @override
  String get analysisLoadError => 'विश्लेषण नतिजा लोड गर्न सकिएन।';

  @override
  String get standardAudioNotReady => 'मानक उच्चारण अडियो अझै तयार छैन।';

  @override
  String get standardAudioPlayError => 'मानक उच्चारण अडियो बजाउन सकिएन।';

  @override
  String get selectNativeLanguage => 'आफ्नो मातृभाषा छान्नुहोस्';

  @override
  String get selectYourLanguage => 'तपाईंको भाषा छान्नुहोस्';

  @override
  String get confirm => 'पुष्टि गर्नुहोस्';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get selectTime => 'समय छान्नुहोस्';

  @override
  String get getStarted => 'सुरु गर्नुहोस्';

  @override
  String get permissionTitle => 'सहज अनुभवका लागि\nअनुमतिहरू दिनुहोस्';

  @override
  String get permissionSubtitle =>
      'सेवा प्रयोग गर्न आवश्यक अनुमतिहरू अनिवार्य छन्।';

  @override
  String get permissionMicTitle => 'माइक्रोफोन (अनिवार्य)';

  @override
  String get permissionMicDesc => 'AI सँग अंग्रेजीमा कुरा गर्न आवश्यक।';

  @override
  String get permissionNotifTitle => 'सूचनाहरू (वैकल्पिक)';

  @override
  String get permissionNotifDesc => 'हामी सिकाइ सम्झना र कल तालिका पठाउनेछौं।';

  @override
  String get micPermissionNeededTitle => 'माइक्रोफोन पहुँच आवश्यक छ';

  @override
  String get micPermissionNeededBody =>
      'AI सँग कुरा गर्न, तपाईंले माइक्रोफोन पहुँचलाई अनुमति दिनुपर्छ। कृपया सेटिङमा यसलाई सक्षम गर्नुहोस्।';

  @override
  String get openSettings => 'सेटिङ खोल्नुहोस्';

  @override
  String get connectionFailedTitle => 'जडान असफल भयो';

  @override
  String get connectionFailedBody =>
      'तपाईंको नेटवर्क जडान जाँच गर्नुहोस्\nर फेरि प्रयास गर्नुहोस्।';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get pay => 'भुक्तानी गर्नुहोस्';

  @override
  String get orderSummary => 'अर्डर सारांश';

  @override
  String get paymentMethod => 'भुक्तानी विधि';

  @override
  String get payMethodCard => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'अटेरी Beaver अवतार';

  @override
  String get productTrait => 'प्रिमियम क्यारेक्टर · सधैंभरिको तपाईंको';

  @override
  String get amountItemPrice => 'वस्तु मूल्य';

  @override
  String get amountDiscount => 'छुट';

  @override
  String get amountTotal => 'जम्मा';

  @override
  String get paymentCompleteTitle => 'भुक्तानी पूरा भयो';

  @override
  String get paymentCompleteBody => 'अवतार तपाईंको सङ्ग्रहमा थपिएको छ।';

  @override
  String get viewCollection => 'सङ्ग्रह हेर्नुहोस्';

  @override
  String get receiptItem => 'वस्तु';

  @override
  String get receiptAmount => 'रकम';

  @override
  String get receiptMethod => 'भुक्तानी विधि';

  @override
  String get receiptDate => 'मिति';

  @override
  String get paymentFailedTitle => 'भुक्तानी असफल भयो';

  @override
  String get paymentFailedBody =>
      'तपाईंको भुक्तानी प्रक्रिया गर्न सकिएन।\nकृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get freeCallEndingTitle => 'तपाईंको निःशुल्क कल सकिँदैछ';

  @override
  String get freeCallEndingBody =>
      'Beaver सँग लामो समय कुरा गर्न सदस्यता लिनुहोस्।';

  @override
  String get subscribe => 'सदस्यता लिनुहोस्';

  @override
  String get endCall => 'कल अन्त्य गर्नुहोस्';

  @override
  String get callEnded => 'कल समाप्त भयो।';

  @override
  String get connecting => 'जडान हुँदैछ…';

  @override
  String get connectingHint => 'यसमा सामान्यतया ५ सेकेन्डभन्दा कम समय लाग्छ';

  @override
  String get callConnectFailed => 'कल जडान गर्न सकिएन।';

  @override
  String get saveSentenceFailed => 'वाक्य सेभ गर्न सकिएन।';

  @override
  String get recordStartFailed => 'रेकर्डिङ सुरु गर्न सकिएन।';

  @override
  String get recordTooShort =>
      'त्यो रेकर्डिङ धेरै छोटो थियो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get gradingFailed => 'स्कोरिङ असफल भयो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get listenStandard => 'मानक उच्चारण सुन्नुहोस्';

  @override
  String get saveSentence => 'वाक्य सेभ गर्नुहोस्';

  @override
  String get unsaveSentence => 'सेभ गरिएको वाक्य हटाउनुहोस्';

  @override
  String get scoringPronunciation => 'तपाईंको उच्चारण स्कोर गर्दैछ…';

  @override
  String get analyzingByWord => 'तपाईंको उच्चारण शब्द–शब्द जाँचिँदै छ';

  @override
  String get analyzingTakingLonger => 'यसमा अलि बढी समय लाग्दै छ';

  @override
  String get scanConnectionLost => 'जडान टुट्यो';

  @override
  String get noRecordingToPlay => 'बजाउनको लागि कुनै रेकर्डिङ छैन।';

  @override
  String get myRecordingPlayError => 'तपाईंको रेकर्डिङ बजाउन सकिएन।';

  @override
  String get next => 'अर्को';

  @override
  String get endLearning => 'सत्र अन्त्य गर्नुहोस्';

  @override
  String get navCalendar => 'पात्रो';

  @override
  String get navCall => 'कल';

  @override
  String get navStats => 'तथ्याङ्क';

  @override
  String get myPage => 'मेरो पेज';

  @override
  String get languageSaveFailed => 'तपाईंको भाषा सेभ गर्न सकिएन।';

  @override
  String get accountDeleteFailed => 'तपाईंको खाता मेटाउन सकिएन।';

  @override
  String get changeAvatar => 'अवतार परिवर्तन गर्नुहोस्';

  @override
  String get avatarIntro =>
      'आवाज र कठिनाइ कल साथी अनुसार फरक हुन्छ।\nकेही साथीहरूका लागि भुक्तानी आवश्यक हुन सक्छ।';

  @override
  String myPartnersOwned(int count) {
    return 'मेरा साथीहरू · $count स्वामित्वमा';
  }

  @override
  String get limitedDiscount => 'सीमित समयको छुट';

  @override
  String get available => 'उपलब्ध';

  @override
  String get inUse => 'प्रयोगमा';

  @override
  String get owned => 'स्वामित्वमा';

  @override
  String get noCharactersToShow => 'देखाउनको लागि कुनै क्यारेक्टर छैन';

  @override
  String get buy => 'किन्नुहोस्';

  @override
  String get noSavedSentences =>
      'अहिलेसम्म कुनै सेभ गरिएको वाक्य छैन।\nतपाईंको कुराकानी रेकर्डबाट वाक्यहरू बुकमार्क गर्नुहोस्।';

  @override
  String get noAlarms => 'अहिलेसम्म कुनै अलार्म छैन';

  @override
  String get noAlarmsBody => 'निरन्तर बानी बनाउन\nसिकाइ सम्झना थप्नुहोस्।';

  @override
  String get subscriptionManage => 'सदस्यता व्यवस्थापन गर्नुहोस्';

  @override
  String get changePlan => 'योजना परिवर्तन गर्नुहोस्';

  @override
  String get cancelSubscription => 'सदस्यता रद्द गर्नुहोस्';

  @override
  String get benefitsInUse => 'तपाईंका सुविधाहरू';

  @override
  String get paymentInfo => 'भुक्तानी जानकारी';

  @override
  String get nextBillingDate => 'अर्को बिलिङ मिति';

  @override
  String get lostBenefitsTitle => 'रद्द गरे गुम्ने सुविधाहरू';

  @override
  String get viewBillingHistory => 'बिलिङ इतिहास हेर्नुहोस्';

  @override
  String get keepUsingPro => 'Pro प्रयोग जारी राख्नुहोस्';

  @override
  String get proMembership => 'Pro सदस्यता';

  @override
  String pricePerMonth(String price) {
    return '$price / महिना';
  }

  @override
  String get benefitUnlimitedCalls => 'असीमित कलहरू';

  @override
  String get benefitDetailedAnalysis => 'विस्तृत उच्चारण र व्याकरण विश्लेषण';

  @override
  String get benefitAllCharacters => 'सबै क्यारेक्टरहरूमा पहुँच';

  @override
  String get benefitNoAds => 'कुनै विज्ञापन छैन';

  @override
  String get playSampleVoice => 'नमूना आवाज बजाउनुहोस्';

  @override
  String get useThisAvatar => 'यो प्रयोग गर्नुहोस्';

  @override
  String get challengeTitle => 'उच्चारण चुनौती';

  @override
  String get challengeIntro =>
      'जोनमा भएका प्रत्येक कार्ड कोरियनमा सही उच्चारण गरेर पास गर्नुहोस्।\nमाइक छैन? तपाईं स्क्रिन ट्याप गरेर पनि खेल्न सक्नुहुन्छ।';

  @override
  String get challengeStart => 'क्यामेरा र माइक सुरु गर्नुहोस्';

  @override
  String get challengePermissionNote =>
      'अगाडिको क्यामेरा र माइक पहुँच आवश्यक छ (वैकल्पिक)।';

  @override
  String get challengeLoadingTitle => 'लोड हुँदैछ…';

  @override
  String get challengeLoadingNote =>
      'पहिलो पटक चलाउँदा कोरियन स्पिच मोडेल (~82MB) डाउनलोड हुँदैछ।\nकृपया केही समय पर्खनुहोस्।';

  @override
  String get challengeSttFallback =>
      'स्पिच पहिचान उपलब्ध थिएन, त्यसैले तपाईंले ट्याप इनपुटबाट खेल्नुभयो।';

  @override
  String get reasonTravelTitle => 'यात्रा गर्दा बोल्ने';

  @override
  String get reasonTravelDesc =>
      'स्थानीयवासीसँग आत्मविश्वासका साथ कुरा गर्नुहोस्';

  @override
  String get reasonCareerTitle => 'काम र करियर';

  @override
  String get reasonCareerDesc => 'व्यावसायिक कुराकानी';

  @override
  String get reasonExamTitle => 'परीक्षा तयारी';

  @override
  String get reasonExamDesc => 'बोलाइ परीक्षाका लागि तयारी गर्नुहोस्';

  @override
  String get reasonDailyTitle => 'दैनिक कुराकानी';

  @override
  String get reasonDailyDesc => 'तपाईंले दैनिक प्रयोग गर्ने अभिव्यक्तिहरू';

  @override
  String get reasonFriendsTitle => 'विदेशी साथी बनाउने';

  @override
  String get reasonFriendsDesc => 'स्वाभाविक कुराकानी';

  @override
  String get reasonBrainTitle => 'मस्तिष्क उत्तेजना';

  @override
  String get reasonBrainDesc => 'सम्झना र एकाग्रता बढाउनुहोस्';

  @override
  String get challengeRecordToggle => 'यो राउन्ड रेकर्ड गर्नुहोस्';

  @override
  String get challengeRecordHint =>
      'सेयर गर्न तपाईंको गेमप्लेको भिडियो सेभ गर्छ (साइलेन्ट)।';

  @override
  String get settingsSection => 'सेटिङ';

  @override
  String get paymentSection => 'भुक्तानी';

  @override
  String get supportSection => 'सहयोग';

  @override
  String get userLanguage => 'प्रयोगकर्ता भाषा';

  @override
  String get learningLanguage => 'सिक्ने भाषा';

  @override
  String get learningLanguageKorean => 'कोरियन';

  @override
  String get notificationLabel => 'सूचना';

  @override
  String get currentPlan => 'हालको योजना';

  @override
  String get paymentHistory => 'भुक्तानी इतिहास';

  @override
  String get contactUs => 'हामीलाई सम्पर्क गर्नुहोस्';

  @override
  String get termsOfService => 'सेवाका सर्तहरू';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get logOut => 'लगआउट गर्नुहोस्';

  @override
  String get deleteAccount => 'खाता मेटाउनुहोस्';

  @override
  String get deleteAccountTitle => 'खाता मेटाउने हो?';

  @override
  String get deleteAccountBody =>
      'यसले तपाईंको खाता र डाटा स्थायी रूपमा मेटाउँछ र यो फिर्ता गर्न सकिँदैन।';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get share => 'सेयर गर्नुहोस्';

  @override
  String get accentSoundsLike => 'तपाईंको कोरियन उच्चारण';

  @override
  String get hintLabel => 'सङ्केत';

  @override
  String get nextHint => 'अर्को सङ्केत';

  @override
  String get translateLabel => 'अनुवाद';

  @override
  String get startRecording => 'रेकर्डिङ सुरु गर्नुहोस्';

  @override
  String get stopRecording => 'रेकर्डिङ रोक्नुहोस्';

  @override
  String get back => 'पछाडि';

  @override
  String get onboardingNameTitle => 'हामीले तपाईंलाई के भनेर बोलाऔं?';

  @override
  String get onboardingNameSubtitle =>
      'तपाईंको AI ट्युटरले तपाईंको नाम सम्झिनेछ।';

  @override
  String get nameLabel => 'तपाईंको नाम';

  @override
  String get nameHint => 'तपाईंको नाम लेख्नुहोस्';

  @override
  String get nameHelper =>
      'यो तपाईंको वास्तविक नाम हुनुपर्दैन — उपनाम पनि प्रयोग गर्न सकिन्छ।';

  @override
  String get continueLabel => 'जारी राख्नुहोस्';

  @override
  String get onboardingDoneTitle => 'Beaver तपाईंको कलको प्रतीक्षा गर्दैछ';

  @override
  String get onboardingDoneSubtitle => 'अहिले नै कल सुरु गर्नुहोस्';

  @override
  String get home => 'गृहपृष्ठ';

  @override
  String get callNow => 'अहिले कल गर्नुहोस्';

  @override
  String get pronunciation => 'उच्चारण';

  @override
  String get fluency => 'प्रवाह';

  @override
  String get rhythm => 'लय';

  @override
  String get analysisTimeout =>
      'यसमा अपेक्षाभन्दा बढी समय लाग्दैछ। कृपया केही क्षणपछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get analysisFailed =>
      'हामीले कुराकानी विश्लेषण गर्न सकेनौं। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get analyzingConversation => 'तपाईंको कुराकानी विश्लेषण गर्दैछ…';

  @override
  String get analyzingSubtitle => 'यसमा केही क्षण मात्र लाग्नेछ';

  @override
  String get tryAgain => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get nativeLabel => 'नेटिभ';

  @override
  String get meLabel => 'म';

  @override
  String get pronunciationPlayError => 'उच्चारण अडियो बजाउन सकिएन।';

  @override
  String get savedExpressionsLoadError =>
      'तपाईंका सेभ गरिएका अभिव्यक्तिहरू लोड गर्न सकिएन।';

  @override
  String get mySavedExpressions => 'मेरा सेभ गरिएका अभिव्यक्तिहरू';

  @override
  String get avatarTraits => 'न्यानो · शान्त · कोमल';

  @override
  String get priceFree => 'निःशुल्क';

  @override
  String get loginGoogleTokenError => 'Google साइन-इन टोकन प्राप्त गर्न सकिएन।';

  @override
  String get loginGoogleSignInFailed => 'Google साइन-इन असफल भयो।';

  @override
  String get loginAppleSignInFailed => 'Apple साइन-इन असफल भयो।';

  @override
  String get loginFacebookSignInFailed => 'Facebook साइन-इन असफल भयो।';

  @override
  String get loginKakaoSignInFailed => 'Kakao साइन-इन असफल भयो।';

  @override
  String get loginContinueWithKakao => 'Kakao बाट जारी राख्नुहोस्';

  @override
  String get loginContinueWithGoogle => 'Google बाट जारी राख्नुहोस्';

  @override
  String get loginContinueWithFacebook => 'Facebook बाट जारी राख्नुहोस्';

  @override
  String get loginContinueWithApple => 'Apple बाट जारी राख्नुहोस्';

  @override
  String get loginContinueWithEmail => 'इमेलबाट जारी राख्नुहोस्';

  @override
  String get loginOrDivider => 'वा';

  @override
  String get loginNoAccount => 'खाता छैन?';

  @override
  String get signUp => 'साइन अप गर्नुहोस्';

  @override
  String get loginTermsNoticePrefix => 'जारी राखेर, तपाईं हाम्रो ';

  @override
  String get loginTermsNoticeAnd => ' र ';

  @override
  String get loginTermsNoticeSuffix => ' मा सहमत हुनुहुन्छ।';

  @override
  String get loginLogIn => 'लगइन गर्नुहोस्';

  @override
  String get fieldEmailLabel => 'इमेल';

  @override
  String get emailHint => 'तपाईंको इमेल लेख्नुहोस्';

  @override
  String get fieldPasswordLabel => 'पासवर्ड';

  @override
  String get passwordHint => 'तपाईंको पासवर्ड लेख्नुहोस्';

  @override
  String get loginRememberMe => 'मलाई सम्झनुहोस्';

  @override
  String get loginForgotPassword => 'पासवर्ड बिर्सनुभयो?';

  @override
  String get loginLoggingIn => 'लगइन हुँदैछ...';

  @override
  String get passwordLengthError => 'पासवर्ड ८–१६ अक्षरको हुनुपर्छ।';

  @override
  String get passwordsDoNotMatch => 'पासवर्डहरू मिलेनन्।';

  @override
  String get signupCheckInput => 'कृपया आफ्नो इनपुट जाँच गर्नुहोस्।';

  @override
  String get fieldConfirmPasswordLabel => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get confirmPasswordHint => 'तपाईंको पासवर्ड फेरि लेख्नुहोस्';

  @override
  String get signupSigningUp => 'साइन अप हुँदैछ...';

  @override
  String get signupHaveAccount => 'पहिले नै खाता छ?';

  @override
  String get passwordMethodEmailRequired => 'तपाईंको इमेल लेख्नुहोस्';

  @override
  String get passwordResetTitle => 'पासवर्ड रिसेट गर्नुहोस्';

  @override
  String get passwordMethodDescription =>
      'पासवर्ड रिसेट कोड प्राप्त गर्न चाहनुभएको इमेल ठेगाना लेख्नुहोस्।';

  @override
  String get emailAddressHint => 'इमेल ठेगाना';

  @override
  String get passwordMethodSending => 'पठाउँदैछ...';

  @override
  String get passwordMethodSendEmail => 'इमेल पठाउनुहोस्';

  @override
  String get passwordCodeTitle => 'कोड लेख्नुहोस्';

  @override
  String get passwordCodeDescription =>
      'हामीले तपाईंको इमेलमा रिकभरी कोड पठाएका छौं। जारी राख्न यो लेख्नुहोस्।';

  @override
  String get passwordCodeNoCode => 'कोड पाउनुभएन?';

  @override
  String get passwordCodeResend => 'कोड फेरि पठाउनुहोस्';

  @override
  String get passwordCodeVerifying => 'प्रमाणित गर्दैछ...';

  @override
  String get passwordNewTitle => 'नयाँ पासवर्ड';

  @override
  String get passwordNewDescription =>
      'तपाईंको खाताका लागि नयाँ पासवर्ड सेट गर्नुहोस्।';

  @override
  String get fieldNewPasswordLabel => 'नयाँ पासवर्ड';

  @override
  String get newPasswordHint => 'तपाईंको नयाँ पासवर्ड लेख्नुहोस्';

  @override
  String get fieldConfirmNewPasswordLabel => 'नयाँ पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get confirmNewPasswordHint => 'तपाईंको नयाँ पासवर्ड फेरि लेख्नुहोस्';

  @override
  String get passwordNewSubmitting => 'पेश गर्दैछ...';

  @override
  String get passwordNewSubmit => 'पेश गर्नुहोस्';

  @override
  String get passwordCompleteTitle => 'पासवर्ड रिसेट पूरा भयो';

  @override
  String get passwordCompleteBody =>
      'तपाईंको पासवर्ड रिसेट भयो। जारी राख्न आफ्नो नयाँ पासवर्डले लगइन गर्नुहोस्।';

  @override
  String get termsTitle => 'सेवाका सर्तहरू';

  @override
  String get privacyTitle => 'गोपनीयता नीति';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email का लागि नयाँ पासवर्ड सेट गर्नुहोस्।';
  }

  @override
  String get selectComplete => 'सम्पन्न';

  @override
  String get onboardingLanguageTitle => 'तपाईंको मातृभाषा के हो?';

  @override
  String get onboardingReasonTitle => 'तपाईं भाषा किन सिक्दै हुनुहुन्छ?';

  @override
  String get onboardingReasonSubtitle =>
      'हामी तपाईंको लक्ष्य अनुसार सिकाइलाई अनुकूल बनाउनेछौं।';

  @override
  String get savingLabel => 'सुरक्षित गर्दै...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'यस महिनाको भुक्तानी';

  @override
  String get filterAll => 'सबै';

  @override
  String get filterSubscription => 'सदस्यता';

  @override
  String get filterCharacter => 'पात्र';

  @override
  String get statusCompleted => 'सम्पन्न';

  @override
  String get lastPayment => 'पछिल्लो भुक्तानी';

  @override
  String subscriptionSwitchNote(String date) {
    return 'तपाईं $date सम्म Pro सुविधा प्रयोग गर्न सक्नुहुन्छ, त्यसपछि तपाईंको योजना स्वतः निःशुल्कमा बदलिन्छ।';
  }

  @override
  String get freePlanCallLimit => 'दिनमा १ कल · ५ मिनेट सीमा';

  @override
  String get freePlanBasicCharacters => 'आधारभूत पात्र समावेश';

  @override
  String get availableForPurchase => 'किन्न उपलब्ध';

  @override
  String get paymentsLoadError => 'भुक्तानी इतिहास लोड गर्न सकिएन';

  @override
  String get noPayments => 'अझै कुनै भुक्तानी छैन';

  @override
  String get morePaymentsExist => 'पुराना भुक्तानी अझै देखाइएका छैनन्';

  @override
  String get undatedPayments => 'मिति नभएको';

  @override
  String get paymentLabelFallback => 'भुक्तानी';

  @override
  String learningPassed(int passed, int total) {
    return '$total मध्ये $passed वाक्य उत्तीर्ण';
  }

  @override
  String get hardestSound => 'आजको सबैभन्दा कठिन ध्वनि';

  @override
  String get soundAccuracy => 'ध्वनि अनुसार शुद्धता';

  @override
  String phonemeAttempts(int count) {
    return 'प्रति स्वनिम · $count प्रयास';
  }

  @override
  String get colSound => 'ध्वनि';

  @override
  String get colAttempts => 'प्रयास';

  @override
  String get colCorrect => 'सही';

  @override
  String get colAccuracy => 'शुद्ध.';

  @override
  String get sentenceResults => 'वाक्य अनुसार नतिजा';

  @override
  String viewAllSentences(int count) {
    return 'सबै $count हेर्नुहोस्';
  }

  @override
  String get colSentence => 'वाक्य';

  @override
  String get colPronunciation => 'उच्चा.';

  @override
  String get colFluency => 'प्रवाह';

  @override
  String get colRhythm => 'लय';

  @override
  String recentSessions(int count) {
    return 'पछिल्ला $count सत्र';
  }

  @override
  String trendAverage(int score) {
    return 'औसत $score';
  }

  @override
  String get today => 'आज';

  @override
  String get colDate => 'मिति';

  @override
  String get colSentences => 'वाक्य';

  @override
  String get colScore => 'अंक';

  @override
  String get colChange => 'परिवर्तन';

  @override
  String dateToday(String date) {
    return '$date (आज)';
  }

  @override
  String get accentAnalysis => 'उच्चारण शैली विश्लेषण';

  @override
  String get overallLevel => 'समग्र स्तर';

  @override
  String get overallLevelSubtitle => 'शब्दभण्डार · व्याकरण · अभिव्यक्ति';

  @override
  String get pronunciationAnalysis => 'उच्चारण विश्लेषण';

  @override
  String get recentSessionsAverage => 'पछिल्लो १० सत्रको औसत';

  @override
  String levelStage(int stage) {
    return 'स्तर $stage';
  }

  @override
  String topPercent(int percent) {
    return 'शीर्ष $percent%';
  }

  @override
  String get allLearnersBasis => 'सबै सिकारुमध्ये';

  @override
  String aheadOfLearners(int percent) {
    return 'तपाईं $percent% सिकारुभन्दा अगाडि हुनुहुन्छ';
  }

  @override
  String get retakeLevelTest => 'स्तर परीक्षा दोहोर्‍याउनुहोस्';

  @override
  String get practicePronunciation => 'उच्चारण अभ्यास गर्नुहोस्';

  @override
  String get priceChangedTitle => 'मूल्य परिवर्तन भयो';

  @override
  String priceChangedBody(String price) {
    return 'यो वस्तुको मूल्य अब $price छ। जारी राख्ने?';
  }

  @override
  String get billingGroupPlanPurchases => 'योजना र खरिदहरू';

  @override
  String get billingGroupInTheStore => 'स्टोरमा';

  @override
  String get billingChangePlan => 'योजना परिवर्तन';

  @override
  String get billingCompareAllPlans => 'सबै योजना तुलना गर्नुहोस्';

  @override
  String get billingBuyACharacter => 'क्यारेक्टर किन्नुहोस्';

  @override
  String get billingRestorePurchases => 'खरिदहरू पुनर्स्थापना';

  @override
  String get billingPaymentHistory => 'भुक्तानी इतिहास';

  @override
  String get billingManageInTheStore => 'स्टोरमा व्यवस्थापन गर्नुहोस्';

  @override
  String get billingRefundHelp => 'रिफन्ड सहायता';

  @override
  String get billingCancelSubscription => 'सदस्यता रद्द गर्नुहोस्';

  @override
  String get billingResubscribe => 'फेरि सदस्यता लिनुहोस्';

  @override
  String get badgeCurrent => 'हालको';

  @override
  String get badgeTrial => 'परीक्षण';

  @override
  String get badgeRenewing => 'नवीकरण हुँदै';

  @override
  String get badgePastDue => 'भुक्तानी बाँकी';

  @override
  String get badgePaused => 'रोकिएको';

  @override
  String get badgeCanceling => 'रद्द हुँदै';

  @override
  String get subscriptionTitle => 'सदस्यता';

  @override
  String get plansTitle => 'योजनाहरू';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max परीक्षण';

  @override
  String get freePlanPriceLine => '\$0.00 — दिनमा एक कल';

  @override
  String pricePerMonthLine(String amount) {
    return 'प्रति महिना $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date सम्म निःशुल्क';
  }

  @override
  String get todaysCalls => 'आजका कलहरू';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit मध्ये $used प्रयोग भयो';
  }

  @override
  String get firstPaymentLabel => 'पहिलो भुक्तानी';

  @override
  String get nextPaymentLabel => 'अर्को भुक्तानी';

  @override
  String get retryingUntilLabel => 'पुनःप्रयास हुनेसम्म';

  @override
  String get pausedSinceLabel => 'रोकिएको मिति';

  @override
  String planEndsLabel(String plan) {
    return '$plan समाप्त हुने';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pro सँग असीमित बन्नुहोस्';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'असीमित कल · प्रत्येक १५ मिनेट · प्रति महिना $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max सँग भिडियो खोल्नुहोस्';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'आमनेसामने कल · प्रति महिना $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'वार्षिक योजनामा जानुहोस्';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return 'प्रति वर्ष $yearly · प्रति महिना $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'भुक्तानी लिन सकिएन';

  @override
  String get bannerPaymentFailedSub =>
      'Pro राख्न स्टोरमा भुक्तानी अपडेट गर्नुहोस्';

  @override
  String get bannerPausedTitle => 'तपाईंको योजना रोकिएको छ';

  @override
  String get bannerPausedSub => 'भुक्तानी पूरा भएन';

  @override
  String get noteRestoreHint =>
      'अर्को डिभाइसमा सदस्यता लिनुभएको छ? पुनर्स्थापनाले यही डिभाइसमा फर्काउँछ।';

  @override
  String get noteStoreHandled =>
      'भुक्तानी विधि, योजना परिवर्तन र रद्द — सबै स्टोरले व्यवस्थापन गर्छ।';

  @override
  String get noteFairUse =>
      'असीमित प्रयोग हाम्रो उचित प्रयोग नीति अनुसार हुन्छ।';

  @override
  String noteTrialEnds(String date) {
    return 'तपाईंको परीक्षण $date मा सकिन्छ। त्यसअघि स्टोरमा रद्द गरे केही शुल्क लाग्दैन।';
  }

  @override
  String get noteGrace =>
      'ग्रेस अवधिभर सुविधा चालु रहन्छ। एपमा रद्द कहिल्यै रोकिँदैन।';

  @override
  String get noteHold =>
      'भुक्तानी नभएसम्म Pro रोकिन्छ। तपाईंका क्यारेक्टर र प्रगति सुरक्षित छन्।';

  @override
  String noteEnding(String date) {
    return 'तपाईंको योजना समाप्त हुँदैछ। $date सम्म सुविधा चल्छ, त्यसपछि Free मा जानुहुन्छ। जुनसुकै बेला फेरि सदस्यता लिन सकिन्छ।';
  }

  @override
  String get trialExpiredTitle => 'तपाईंको Max परीक्षण सकियो';

  @override
  String get trialExpiredSub => 'तपाईं अहिले Free मा हुनुहुन्छ';

  @override
  String get seePlans => 'योजनाहरू हेर्नुहोस्';

  @override
  String get currentPlanTitle => 'हालको योजना';

  @override
  String get badgeRecommended => 'सिफारिस गरिएको';

  @override
  String get perMonthUnit => 'प्रति महिना';

  @override
  String get planTaglinePro => 'असीमित कल। प्रत्येक १५ मिनेट।';

  @override
  String get planTaglineMax => 'अब उनीहरूलाई देख्न सक्नुहुन्छ।';

  @override
  String get planTaglineFree => 'दिनमा एक कल। निःशुल्क।';

  @override
  String get bulletProCalls => 'जति चाह्यो त्यति भ्वाइस कल';

  @override
  String get bulletProLength => 'प्रति कल १५ मिनेट';

  @override
  String get bulletProScoring => 'अक्षर-अक्षर उच्चारण स्कोर';

  @override
  String get bulletProCorrections => 'तपाईंको मातृभाषा अनुसार सुधार';

  @override
  String get bulletProBeaverCalls => 'Beaver ले पहिले तपाईंलाई कल गर्छ';

  @override
  String get bulletMaxVideo => 'आमनेसामने भिडियो कल';

  @override
  String get bulletMaxEverything => 'Pro का सबै सुविधा';

  @override
  String get bulletMaxCharacters => 'सबै क्यारेक्टर, असीमित';

  @override
  String get bulletMaxStudyBook => 'तपाईंको स्तर अनुसारको अध्ययन पुस्तक';

  @override
  String get bulletMaxWeeklyReport =>
      'उच्चारण कसरी बदलिँदैछ भन्ने साप्ताहिक रिपोर्ट';

  @override
  String get bulletFreeCall => 'दिनमा एक ५-मिनेटको भ्वाइस कल';

  @override
  String get bulletFreeCheck => 'दिनमा एक उच्चारण जाँच';

  @override
  String get bulletFreeAccent => 'असीमित एक्सेन्ट जाँच';

  @override
  String get bulletFreeCharacter => 'सुरु गर्न एउटा क्यारेक्टर';

  @override
  String get ctaGoUnlimited => 'असीमित बन्नुहोस्';

  @override
  String get ctaTurnOnVideo => 'भिडियो खोल्नुहोस्';

  @override
  String get noteCallLength => 'प्रत्येक कल १५ मिनेटको हुन्छ।';

  @override
  String get paywallProTitle1 => 'तपाईंको कोरियन साथी';

  @override
  String get paywallProTitle2 => 'राति ३ बजे पनि जागै';

  @override
  String get paywallProSub => 'असीमित कल। प्रत्येक १५ मिनेट। वर्षभरि।';

  @override
  String get paywallLimitHeadline => 'Pro ले सीमा हटाउँछ।';

  @override
  String get limitBannerCallTitle => 'आजको कल सकियो';

  @override
  String get limitBannerCallSub => 'Free मा दिनमा एक कल';

  @override
  String get limitBannerCheckTitle => 'आजको जाँच सकियो';

  @override
  String get limitBannerCheckSub => 'Free मा दिनमा एक जाँच';

  @override
  String get bulletProCharactersForever => 'किनेका क्यारेक्टर सधैँ तपाईंकै';

  @override
  String get paywallMaxTitle => 'अब उनीहरूलाई देख्न सक्नुहुन्छ।';

  @override
  String get paywallMaxSub =>
      'भिडियो कल, सबै क्यारेक्टर, र तपाईंको स्तरका लागि बनेको अध्ययन पुस्तक।';

  @override
  String get planMonthly => 'मासिक';

  @override
  String get planAnnual => 'वार्षिक';

  @override
  String proMonthlyPriceLine(String price) {
    return 'प्रति महिना $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · प्रति महिना $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'प्रति महिना $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'प्रति वर्ष $yearly · प्रति महिना $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'प्रति महिना $price · स्टोरमा जुनसुकै बेला रद्द';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'प्रति महिना $price · स्टोरमा जुनसुकै बेला रद्द';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '७ दिन नि:शुल्क, त्यसपछि प्रति महिना $price · स्टोरमा जुनसुकै बेला रद्द';
  }

  @override
  String get ctaCaptionAutoRenew => 'रद्द नगरेसम्म स्वतः नवीकरण हुन्छ।';

  @override
  String get footerTerms => 'सर्तहरू';

  @override
  String get footerPrivacy => 'गोपनीयता';

  @override
  String get noteMaxCharacters =>
      'Max ले खोलेका क्यारेक्टर सदस्यता चालु रहेसम्म उपलब्ध हुन्छन्। किनेका क्यारेक्टर तपाईंकै रहन्छन्।';

  @override
  String get processingTitle => 'तपाईंको खरिद पुष्टि हुँदैछ';

  @override
  String get processingSub => 'सामान्यतया केही सेकेन्ड लाग्छ।';

  @override
  String get successProTitle => 'तपाईं अब Pro मा हुनुहुन्छ।';

  @override
  String get successProSub => 'असीमित कल, अहिलेदेखि नै।';

  @override
  String get successProBenefit1 =>
      'जति चाह्यो त्यति कल गर्नुहोस् — प्रति कल १५ मिनेट';

  @override
  String get successProBenefit2 => 'असीमित उच्चारण जाँच';

  @override
  String get successProBenefit3 => 'सबै क्यारेक्टर, साथै एकपटकको खरिद';

  @override
  String get successMaxTitle => 'अब उनीहरूलाई देख्न सक्नुहुन्छ।';

  @override
  String get successMaxSub =>
      'भिडियो कल खुल्यो। जुनसुकै कलमा भिडियो बटन थिच्नुहोस्।';

  @override
  String get successMaxBenefit1 => 'आमनेसामने भिडियो कल';

  @override
  String get successMaxBenefit2 =>
      'सबै क्यारेक्टर, असीमित — नयाँ सबैभन्दा पहिले';

  @override
  String get successMaxBenefit3 => 'तपाईंको स्तर अनुसारको अध्ययन पुस्तक';

  @override
  String get ctaStartACall => 'कल सुरु गर्नुहोस्';

  @override
  String get ctaStartAVideoCall => 'भिडियो कल सुरु गर्नुहोस्';

  @override
  String get ctaSeeYourSubscription => 'आफ्नो सदस्यता हेर्नुहोस्';

  @override
  String successProCaption(String price) {
    return 'रद्द नगरेसम्म प्रति महिना $price शुल्क लाग्छ। स्टोरमा जुनसुकै बेला व्यवस्थापन वा रद्द गर्नुहोस्।';
  }

  @override
  String successMaxCaption(String price) {
    return 'रद्द नगरेसम्म प्रति महिना $price शुल्क लाग्छ। स्टोरमा जुनसुकै बेला व्यवस्थापन वा रद्द गर्नुहोस्।';
  }

  @override
  String get plansErrorTitle => 'योजनाहरू लोड गर्न सकिएन';

  @override
  String get plansErrorSub => 'स्टोरबाट जवाफ आएन।';

  @override
  String get ctaTryAgain => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get plansErrorCaption => 'कुनै शुल्क लागेन।';

  @override
  String get changePlanTitle => 'योजना परिवर्तन';

  @override
  String get moveToMaxTitle => 'Max मा जानुहोस्';

  @override
  String maxPriceShort(String price) {
    return '$price / महिना';
  }

  @override
  String get moveToMaxCardSub =>
      'आमनेसामने भिडियो कल · सबै क्यारेक्टर · तपाईंका लागि बनेको अध्ययन पुस्तक';

  @override
  String get whatHappensNow => 'अब के हुन्छ';

  @override
  String get maxStartsLabel => 'Max सुरु';

  @override
  String get immediately => 'तुरुन्तै';

  @override
  String get unusedProTime => 'Pro को बाँकी समय';

  @override
  String get creditedTowardMax => 'Max मा मिलान हुन्छ';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max मा जानुहोस्';

  @override
  String get upgradeCaption =>
      'नयाँ योजना तुरुन्तै सुरु हुन्छ। Pro को बाँकी समय मिलान हुन्छ, दुईपटक शुल्क लाग्दैन।';

  @override
  String get moveToProTitle => 'Pro मा जानुहोस्';

  @override
  String get moveToProSub =>
      'आज केही बदलिँदैन। भुक्तानी गरिसकेको महिनाको अन्त्यसम्म Max चल्छ।';

  @override
  String get maxRunsUntil => 'Max चल्ने अवधि';

  @override
  String get proStarts => 'Pro सुरु';

  @override
  String get whatYouKeep => 'के रहन्छ';

  @override
  String get keepBenefitCalls => 'असीमित भ्वाइस कल, प्रत्येक १५ मिनेट';

  @override
  String get keepBenefitCharacters => 'किनेका क्यारेक्टर सधैँ तपाईंकै';

  @override
  String downgradeWarning(String date) {
    return '$date मा भिडियो कल र Max-मात्र क्यारेक्टर बन्द हुन्छन्।';
  }

  @override
  String get ctaSwitchToPro => 'Pro मा जानुहोस्';

  @override
  String get ctaKeepMax => 'Max राख्नुहोस्';

  @override
  String get winbackSkip => 'छोड्नुहोस्';

  @override
  String get winbackTitle => 'तपाईंको Pro योजना सकियो';

  @override
  String get winbackSub => 'तपाईं अहिले Free मा — दिनमा एक कल।';

  @override
  String get winbackQuestion => 'किन छोड्नुभयो, भनिदिनुहुन्छ?';

  @override
  String get winbackReasonExpensive => 'धेरै महँगो';

  @override
  String get winbackReasonUnused => 'पर्याप्त प्रयोग गरिनँ';

  @override
  String get winbackReasonMissing => 'चाहिएको सुविधा छैन';

  @override
  String get winbackReasonOtherApp => 'अर्को एप भेटेँ';

  @override
  String get winbackReasonElse => 'अरू नै कारण';

  @override
  String get ctaSend => 'पठाउनुहोस्';

  @override
  String get ctaNotNow => 'अहिले होइन';

  @override
  String get winbackCaption =>
      'यसले योजना फर्काउँदैन। स्टोरमा फेरि सदस्यता लिनुहोस्।';

  @override
  String get ctaContinue => 'जारी राख्नुहोस्';

  @override
  String get ctaClose => 'बन्द गर्नुहोस्';

  @override
  String get ovRestoreSuccessTitle => 'Pro फर्कियो';

  @override
  String get ovRestoreSuccessBody =>
      'तपाईंको सदस्यता भेटियो र यो डिभाइसमा फेरि चालु गरियो।';

  @override
  String get ovRestoreEmptyTitle => 'पुनर्स्थापना गर्ने केही छैन';

  @override
  String get ovRestoreEmptyBody =>
      'यो स्टोर खातासँग कुनै सक्रिय सदस्यता जोडिएको छैन।';

  @override
  String get ovRestoreOtherTitle => 'यो योजना अर्को खाताको हो';

  @override
  String get ovRestoreOtherBody =>
      'यो सदस्यता अर्कै BeaverTalk खातामा पहिले नै सक्रिय छ।';

  @override
  String get ctaSignInThatAccount => 'त्यो खातामा साइन इन गर्नुहोस्';

  @override
  String get ctaGetHelp => 'सहायता लिनुहोस्';

  @override
  String get ovCharacterOfferTitle => 'Pro का लागि तयार हुनुहुन्न?';

  @override
  String get ovCharacterOfferBody =>
      'एउटा क्यारेक्टर रोज्नुहोस्, सधैँका लागि। एकपटकको खरिद — न सदस्यता, न नवीकरण।';

  @override
  String get rowOneCharacter => 'एउटा क्यारेक्टर';

  @override
  String rowFromPrice(String price) {
    return '$price देखि';
  }

  @override
  String get rowYoursForever => 'सधैँ तपाईंकै';

  @override
  String get rowNoRenewal => 'नवीकरण छैन';

  @override
  String get rowWorksOnFree => 'Free मा पनि चल्छ';

  @override
  String get rowYes => 'हो';

  @override
  String get ctaSeeCharacters => 'क्यारेक्टरहरू हेर्नुहोस्';

  @override
  String get ovNotEligibleTitle => 'रद्द गर्ने केही छैन';

  @override
  String get ovNotEligibleBody =>
      'तपाईं Free मा हुनुहुन्छ। यो खातामा कुनै सक्रिय सदस्यता छैन।';

  @override
  String get ovCancelDownsellTitle => 'जानुअघि';

  @override
  String get ovCancelDownsellBody =>
      'रद्द स्टोरमा हुन्छ। जान्नैपर्ने दुई कुरा।';

  @override
  String get rowPayYearlyInstead => 'बरु वार्षिक तिर्नुहोस्';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'प्रति महिना $price';
  }

  @override
  String get rowCharactersYouBought => 'किनेका क्यारेक्टर';

  @override
  String get rowProRunsUntil => 'Pro चल्ने अवधि';

  @override
  String get ctaSwitchToYearly => 'वार्षिकमा जानुहोस्';

  @override
  String get ctaContinueToStore => 'स्टोरतर्फ जारी राख्नुहोस्';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'वार्षिक तिर्नुहोस्, $saved बचाउनुहोस्';
  }

  @override
  String get ovAnnualSwitchBody =>
      'तपाईं दुई महिनादेखि Pro मा हुनुहुन्छ। वार्षिक योजना सस्तो पर्छ।';

  @override
  String get rowYouSave => 'तपाईंको बचत';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'वार्षिक';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'मासिक, एक वर्षभरि';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'मासिकमा जानुहोस्';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'तपाईंको वार्षिक योजना $date सम्म चल्छ। भोलिपल्टदेखि मासिक बिलिङ सुरु हुन्छ।';
  }

  @override
  String get rowMonthlyBillingStarts => 'मासिक बिलिङ सुरु';

  @override
  String get rowMonthlyLabel => 'मासिक';

  @override
  String get rowYearlyWorkedOut => 'वार्षिकको हिसाबले';

  @override
  String get ctaSwitchToMonthly => 'मासिकमा जानुहोस्';

  @override
  String get ovRefundHelpTitle => 'रिफन्ड स्टोरले हेर्छ';

  @override
  String get ovRefundHelpBody =>
      'हामी आफैँ रिफन्ड दिन सक्दैनौँ। हरेक अनुरोध स्टोरले समीक्षा गर्छ।';

  @override
  String get ctaGoToStore => 'स्टोरमा जानुहोस्';

  @override
  String get ovTrialEndingTitle => 'तपाईंको परीक्षण भोलि सकिन्छ';

  @override
  String get ovTrialEndingBody => 'रद्द नगरे Max चलिरहन्छ। के हुन्छ, यहाँ छ।';

  @override
  String get rowTrialEnds => 'परीक्षण सकिने';

  @override
  String get rowFirstCharge => 'पहिलो शुल्क';

  @override
  String get rowThenMonthly => 'त्यसपछि मासिक';

  @override
  String get ctaCancelInStore => 'स्टोरमा रद्द गर्नुहोस्';

  @override
  String get ovTrialStartTitle => '७ दिन Max, निःशुल्क';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date सम्म निःशुल्क। त्यसपछि प्रति महिना $price, स्टोरमा रद्द नगरेसम्म।';
  }

  @override
  String get ctaStart7Days => '७ दिन निःशुल्क सुरु गर्नुहोस्';

  @override
  String get ovOtoTitle => 'सुरु गर्नुअघि एउटा कुरा';

  @override
  String get ovOtoBody =>
      'राम्रो निर्णय — असीमित कल अहिल्यै चालु छ। वार्षिक तिरे उही Pro सस्तो पर्छ।';

  @override
  String get ovFailedDeclinedTitle => 'तपाईंको कार्ड अस्वीकृत भयो';

  @override
  String get ovFailedDeclinedBody =>
      'स्टोरले भुक्तानी लिन सकेन। कुनै शुल्क लागेन।';

  @override
  String get ctaUpdatePaymentMethod => 'भुक्तानी विधि अपडेट गर्नुहोस्';

  @override
  String get ovFailedCanceledTitle => 'भुक्तानी रद्द भयो';

  @override
  String get ovFailedCanceledBody =>
      'तपाईं अझै Free मा हुनुहुन्छ। कुनै शुल्क लागेन।';

  @override
  String get ovFailedStoreTitle => 'केही गडबड भयो';

  @override
  String get ovFailedStoreBody => 'स्टोरसम्म पुग्न सकिएन। कुनै शुल्क लागेन।';

  @override
  String get ovAlreadyTitle => 'तपाईं पहिल्यै Pro मा हुनुहुन्छ';

  @override
  String get ovAlreadyBody =>
      'यो स्टोर खातामा सक्रिय योजना छ। किन्नुपर्ने केही छैन।';

  @override
  String get ctaSeeMySubscription => 'मेरो सदस्यता हेर्नुहोस्';

  @override
  String get subCancelTitle => 'सदस्यता रद्द गर्नुहोस्';

  @override
  String subCancelBody(String date) {
    return 'Pro $date सम्म चल्छ। त्यसपछि Free मा जानुहुन्छ।';
  }

  @override
  String get subWhatYouLose => 'के गुमाउनुहुन्छ';

  @override
  String get benefitCalls15 => 'असीमित कल, प्रत्येक १५ मिनेट';

  @override
  String get benefitScoring => 'अक्षर-अक्षर उच्चारण स्कोर';

  @override
  String get benefitEveryCharacter => 'सबै क्यारेक्टर, असीमित';

  @override
  String get ctaKeepPro => 'Pro राख्नुहोस्';

  @override
  String get subPaymentTitle => 'भुक्तानी अपडेट गर्नुहोस्';

  @override
  String get subPaymentBody => 'भुक्तानी लिन सकिएन। ग्रेस अवधिमा Pro चलिरहन्छ।';

  @override
  String get subHowToFix => 'कसरी मिलाउने';

  @override
  String get fixStep1 => 'स्टोर खोलेर भुक्तानी विधि अपडेट गर्नुहोस्';

  @override
  String get fixStep2 => 'फर्केर आउनुहोस् — योजना आफैँ सुचारु हुन्छ';

  @override
  String get fixStep3 => 'केही पनि दुईपटक शुल्क लाग्दैन';

  @override
  String get subResubTitle => 'फेरि सदस्यता लिनुहोस्';

  @override
  String subResubBody(String date) {
    return 'Pro $date मा सकिन्छ। स्वतः नवीकरण फेरि खोल्नुहोस्, केही बदलिँदैन।';
  }

  @override
  String get subWhatYouKeep => 'के रहन्छ';

  @override
  String get ctaTurnItBackOn => 'फेरि खोल्नुहोस्';

  @override
  String get flTodayTitle => 'आजको कल यही थियो';

  @override
  String get flTodayBody => 'जहाँ छोड्नुभयो, त्यहीँबाट — अहिल्यै।';

  @override
  String get flCheckTitle => 'आजको जाँच यही थियो';

  @override
  String get flCheckBody => 'Free मा दिनमा एक जाँच। Pro ले असीमित बनाउँछ।';

  @override
  String get flBenefitCalls => 'Pro सँग असीमित कल · प्रत्येक १५ मिनेट';

  @override
  String get flBenefitChecks => 'Pro सँग असीमित उच्चारण जाँच';

  @override
  String flCaption(String price) {
    return 'प्रति महिना $price · जुनसुकै बेला रद्द';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit मध्ये $used प्रयोग भयो';
  }

  @override
  String get ctaMaybeTomorrow => 'भोलि हेरौँला';

  @override
  String get accountSection => 'खाता';

  @override
  String get nicknameLabel => 'उपनाम';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'लगइन विधि';

  @override
  String get joinedLabel => 'सामेल भएको मिति';

  @override
  String get editNicknameTitle => 'उपनाम सम्पादन';

  @override
  String get nicknameRule => '२–१२ अक्षर। अंग्रेजी अक्षर र अंक मात्र।';

  @override
  String get ctaSave => 'सुरक्षित गर्नुहोस्';

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
  String get paywallLeaveTitle => 'अहिले छोड्नुभयो भने सदस्यता हुँदैन';

  @override
  String get paywallLeaveBody =>
      'भुक्तानीपछि तुरुन्तै तपाईंका सुविधा खुल्छन्। मेरो पृष्ठबाट जहिले पनि फर्कन सक्नुहुन्छ।';

  @override
  String get ctaKeepLooking => 'हेर्दै गर्नुहोस्';

  @override
  String get ctaLeaveAnyway => 'जे होस् छोड्ने';

  @override
  String get iapCharacterSuccessTitle => 'नयाँ साथी जोडियो!';

  @override
  String get iapCharacterSuccessBody =>
      'यो पात्र सधैँका लागि तपाईंको हो — योजना फेरिए पनि रहन्छ, र खरिद पुनर्स्थापना गरेर जुनसुकै डिभाइसमा फर्काउन सकिन्छ।';

  @override
  String get iapCharacterFailedBody =>
      'खरिद पूरा भएन। कुनै रकम काटिएको छैन — फेरि प्रयास गर्नुहोस्।';

  @override
  String get noAccentDataTitle => 'अझै स्वराघात डेटा छैन';

  @override
  String get noAccentDataBody =>
      'कुराकानी जारी राख्नुहोस्, स्वराघातका विशेषता जम्मा हुँदै जान्छन्।';

  @override
  String get noLevelYetTitle => 'अझै स्तर छैन';

  @override
  String get noLevelYetBody => 'पहिलो कल सकेपछि तपाईंको स्तर देखिन्छ।';

  @override
  String get noPronunciationDataTitle => 'अझै उच्चारण रेकर्ड छैन';

  @override
  String get noPronunciationDataBody =>
      'कलमा बोलेका वाक्यबाट उच्चारण विश्लेषण गर्छौं।';

  @override
  String get noCharacterNote => 'अझै छाडिएको सन्देश छैन';

  @override
  String get noPhonemesYet => 'विश्लेषण गर्ने ध्वनि अझै छैन';

  @override
  String get noSentencesYet => 'विश्लेषण गर्ने वाक्य अझै छैन';

  @override
  String get takeLevelTest => 'स्तर परीक्षा दिनुहोस्';

  @override
  String get reviewToSeeScore => 'दोहोर्‍याएपछि उच्चारण अंक देखिन्छ';

  @override
  String get playAgain => 'फेरि खेल्नुहोस्';

  @override
  String get difficultySlow => 'बिस्तारै';

  @override
  String get difficultyNormal => 'सामान्य';

  @override
  String get difficultyFast => 'छिटो';

  @override
  String get difficultyLabel => 'कठिनाइ';

  @override
  String get connected => 'जडान भयो';

  @override
  String get unlockedWithMax => 'Max सँग उपलब्ध';

  @override
  String get callModeSheetTitle => 'तपाईं कसरी कुरा गर्न चाहनुहुन्छ?';

  @override
  String get callModeSheetSubtitle => 'यो कलमा तुरुन्तै लागू हुन्छ';

  @override
  String get callModeFreeTalk => 'स्वतन्त्र कुराकानी';

  @override
  String get callModeFreeTalkDesc => 'सुधार बिना कुरा गर्नुहोस्';

  @override
  String get callModeStudy => 'अभ्यास';

  @override
  String get callModeStudyDesc => 'एक पटकमा एउटा अभिव्यक्ति सिक्नुहोस्';

  @override
  String get callModeChange => 'मोड बदल्नुहोस्';

  @override
  String get callModeKeep => 'अहिले होइन';

  @override
  String get callExitTitle => 'कल समाप्त गर्ने?';

  @override
  String get callExitSubtitle => 'अहिले समाप्त गरे पनि एक कल गनिन्छ';

  @override
  String get callExitKeep => 'कुरा जारी राख्नुहोस्';

  @override
  String get callExitConfirm => 'कल समाप्त गर्नुहोस्';

  @override
  String get callMicMute => 'म्युट';

  @override
  String get callMicUnmute => 'अनम्युट';

  @override
  String get callPushToTalk => 'बोल्न थिचिराख्नुहोस्';

  @override
  String get callFreeEndedTitle => 'तपाईंको निःशुल्क कल सकियो';

  @override
  String get callFreeEndedCta => 'सदस्यता लिनुहोस् र कुरा जारी राख्नुहोस्';

  @override
  String get callKeepGoingTitle => 'जारी राख्ने?';

  @override
  String get callKeepGoingSubtitle =>
      'कल ५ मिनेटको खण्डमा जारी रहन्छ। हरेक पटक हामी फेरि सोध्नेछौं।';

  @override
  String get articulationSelectedWord => 'छानिएको शब्द';

  @override
  String get articulationYouSaid => 'तपाईंको उच्चारण';

  @override
  String get articulationTargetSound => 'लक्ष्य';

  @override
  String get articulationListenNative => 'नेटिभ उच्चारण सुन्नुहोस्';
}
