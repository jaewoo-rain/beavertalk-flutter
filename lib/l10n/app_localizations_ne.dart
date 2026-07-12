// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

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
  String get analysisLoadError => 'विश्लेषण नतिजा लोड गर्न सकिएन।';

  @override
  String get standardAudioNotReady => 'मानक उच्चारण अडियो अझै तयार छैन।';

  @override
  String get standardAudioPlayError => 'मानक उच्चारण अडियो बजाउन सकिएन।';

  @override
  String get selectACountry => 'देश छान्नुहोस्';

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
  String get pricePerMonth => '\$12.9 / महिना';

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
  String get loginContinueWithKakao => 'Kakao बाट जारी राख्नुहोस्';

  @override
  String get loginContinueWithGoogle => 'Google बाट जारी राख्नुहोस्';

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
}
