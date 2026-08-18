// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get loginRequired => 'आपको साइन इन करना होगा।';

  @override
  String get callWebNotSupported =>
      'वेब पर वॉइस कॉल समर्थित नहीं है। ऐप का उपयोग करें।';

  @override
  String get micPermissionRequiredForCall =>
      'माइक्रोफ़ोन अनुमति आवश्यक है। कॉल करने के लिए माइक्रोफ़ोन की अनुमति दें।';

  @override
  String get callErrorGeneric => 'कॉल के दौरान एक त्रुटि हुई।';

  @override
  String get callNetworkError => 'नेटवर्क त्रुटि हुई।';

  @override
  String get authInvalidCredentials => 'ईमेल या पासवर्ड सही नहीं है।';

  @override
  String get authEmailAlreadyRegistered => 'यह ईमेल पहले से पंजीकृत है।';

  @override
  String get authConfirmEmailRequired =>
      'अपने ईमेल पर भेजा गया सत्यापन पूरा करें।';

  @override
  String get authResetCodeSent => 'हमने आपके ईमेल पर सत्यापन कोड भेजा है।';

  @override
  String get authResetCodeInvalid => 'कोड गलत है या समाप्त हो चुका है।';

  @override
  String get authPasswordUpdated => 'आपका पासवर्ड रीसेट कर दिया गया है।';

  @override
  String get authAppleTokenMissing => 'Apple साइन-इन टोकन नहीं मिला।';

  @override
  String callEndedDuration(String duration) {
    return 'कॉल समाप्त $duration';
  }

  @override
  String get callRatingPrompt => 'आपकी कॉल कैसी रही?';

  @override
  String get ratingBad => 'अच्छी नहीं';

  @override
  String get ratingOkay => 'ठीक-ठाक';

  @override
  String get ratingGood => 'अच्छी';

  @override
  String get goHome => 'होम';

  @override
  String get viewAnalysis => 'विश्लेषण देखें';

  @override
  String get loadingShort => 'लोड हो रहा है…';

  @override
  String ratingSubmitFailed(String message) {
    return 'रेटिंग सबमिट नहीं हो सकी: $message';
  }

  @override
  String get callInfoNotFound =>
      'कॉल की जानकारी नहीं मिली, विश्लेषण छोड़ा जा रहा है।';

  @override
  String get tabRecords => 'रिकॉर्ड';

  @override
  String get tabArchive => 'संग्रह';

  @override
  String get callHistory => 'कॉल इतिहास';

  @override
  String get conversationRecord => 'बातचीत का रिकॉर्ड';

  @override
  String get noCallRecords => 'अभी तक कोई कॉल रिकॉर्ड नहीं';

  @override
  String get noCallRecordsBody =>
      'जैसे ही आप AI के साथ अपनी पहली कॉल पूरी करेंगे,\nआपके रिकॉर्ड यहाँ दिखाई देंगे।';

  @override
  String get startCall => 'कॉल शुरू करें';

  @override
  String get recordsLoadError => 'रिकॉर्ड लोड नहीं हो सके';

  @override
  String get tryAgainLater => 'कृपया बाद में फिर कोशिश करें।';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes मिनट $seconds सेकंड';
  }

  @override
  String get scheduleManagement => 'शेड्यूल';

  @override
  String get alarms => 'अलार्म';

  @override
  String get addSchedule => 'शेड्यूल जोड़ें';

  @override
  String get editSchedule => 'शेड्यूल संपादित करें';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get alarmsLoadError => 'अलार्म लोड नहीं हो सके';

  @override
  String get charactersLoadError => 'कैरेक्टर लोड नहीं हो सके';

  @override
  String get noCharacters => 'कोई कैरेक्टर उपलब्ध नहीं';

  @override
  String get close => 'बंद करें';

  @override
  String get repeat => 'दोहराएँ';

  @override
  String get callPartner => 'कैरेक्टर';

  @override
  String get quickStart => 'तुरंत शुरू करें';

  @override
  String get presetMorning => 'सुबह की दिनचर्या';

  @override
  String get presetMorningSub => 'कार्यदिवस 8:00';

  @override
  String get presetEvening => 'शाम की समाप्ति';

  @override
  String get presetEveningSub => 'हर दिन 21:00';

  @override
  String get presetCustom => 'अपनी पसंद';

  @override
  String get presetCustomSub => 'जैसे चाहें';

  @override
  String alarmSummary(int count, int monthly) {
    return 'हफ़्ते में $count बार · महीने में $monthly कॉल';
  }

  @override
  String get alarmSummaryNone => 'कम से कम एक दिन चुनें';

  @override
  String get partnerInUse => 'उपयोग में';

  @override
  String get partnerOwned => 'आपके पास';

  @override
  String get am => 'पूर्वाह्न';

  @override
  String get pm => 'अपराह्न';

  @override
  String get save => 'सहेजें';

  @override
  String get conversation => 'बातचीत';

  @override
  String get review => 'समीक्षा';

  @override
  String get pronunciationChallenge => 'उच्चारण चुनौती';

  @override
  String get newExpressions => 'नए वाक्यांश';

  @override
  String get analysisResult => 'विश्लेषण परिणाम';

  @override
  String get noNewExpressions => 'इस बातचीत से कोई नया वाक्यांश नहीं।';

  @override
  String get practice => 'अभ्यास';

  @override
  String recentScore(int score) {
    return 'हालिया स्कोर $score%';
  }

  @override
  String callSequence(int count) {
    return '$countवीं कॉल';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name की ओर से एक बात';
  }

  @override
  String characterNoteFooter(String name) {
    return 'कॉल के तुरंत बाद $name ने छोड़ा';
  }

  @override
  String newExpressionsCount(int count) {
    return 'नए वाक्यांश $count';
  }

  @override
  String get analysisLoadError => 'विश्लेषण परिणाम लोड नहीं हो सका।';

  @override
  String get standardAudioNotReady => 'मानक उच्चारण ऑडियो अभी तैयार नहीं है।';

  @override
  String get standardAudioPlayError => 'मानक उच्चारण ऑडियो नहीं चल सका।';

  @override
  String get selectNativeLanguage => 'अपनी मातृभाषा चुनें';

  @override
  String get selectYourLanguage => 'अपनी भाषा चुनें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get selectTime => 'समय चुनें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get permissionTitle => 'बेहतर अनुभव के लिए\nअनुमतियाँ दें';

  @override
  String get permissionSubtitle =>
      'सेवा का उपयोग करने के लिए आवश्यक अनुमतियाँ ज़रूरी हैं।';

  @override
  String get permissionMicTitle => 'माइक्रोफ़ोन (आवश्यक)';

  @override
  String get permissionMicDesc =>
      'AI के साथ अंग्रेज़ी में बात करने के लिए ज़रूरी है।';

  @override
  String get permissionNotifTitle => 'सूचनाएँ (वैकल्पिक)';

  @override
  String get permissionNotifDesc =>
      'हम आपको लर्निंग रिमाइंडर और कॉल शेड्यूल भेजेंगे।';

  @override
  String get micPermissionNeededTitle => 'माइक्रोफ़ोन एक्सेस की आवश्यकता है';

  @override
  String get micPermissionNeededBody =>
      'AI से बात करने के लिए, आपको माइक्रोफ़ोन एक्सेस की अनुमति देनी होगी। कृपया इसे सेटिंग्स में सक्षम करें।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get connectionFailedTitle => 'कनेक्शन विफल';

  @override
  String get connectionFailedBody =>
      'अपना नेटवर्क कनेक्शन जाँचें\nऔर फिर कोशिश करें।';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get pay => 'भुगतान करें';

  @override
  String get orderSummary => 'ऑर्डर सारांश';

  @override
  String get paymentMethod => 'भुगतान का तरीका';

  @override
  String get payMethodCard => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Annoying Beaver अवतार';

  @override
  String get productTrait => 'प्रीमियम कैरेक्टर · हमेशा के लिए आपका';

  @override
  String get amountItemPrice => 'वस्तु की कीमत';

  @override
  String get amountDiscount => 'छूट';

  @override
  String get amountTotal => 'कुल';

  @override
  String get paymentCompleteTitle => 'भुगतान पूर्ण';

  @override
  String get paymentCompleteBody => 'अवतार आपके संग्रह में जोड़ दिया गया है।';

  @override
  String get viewCollection => 'संग्रह देखें';

  @override
  String get receiptItem => 'वस्तु';

  @override
  String get receiptAmount => 'राशि';

  @override
  String get receiptMethod => 'भुगतान का तरीका';

  @override
  String get receiptDate => 'तारीख';

  @override
  String get paymentFailedTitle => 'भुगतान विफल';

  @override
  String get paymentFailedBody =>
      'आपके भुगतान को संसाधित नहीं किया जा सका।\nकृपया फिर कोशिश करें।';

  @override
  String get freeCallEndingTitle => 'आपकी मुफ़्त कॉल समाप्त हो रही है';

  @override
  String get freeCallEndingBody =>
      'Beaver के साथ और लंबे समय तक बात करने के लिए सदस्यता लें।';

  @override
  String get subscribe => 'सदस्यता लें';

  @override
  String get endCall => 'कॉल समाप्त करें';

  @override
  String get callEnded => 'कॉल समाप्त हो गई है।';

  @override
  String get connecting => 'कनेक्ट हो रहा है…';

  @override
  String get connectingHint => 'इसमें आमतौर पर 5 सेकंड से भी कम समय लगता है';

  @override
  String get callConnectFailed => 'कॉल कनेक्ट नहीं हो सकी।';

  @override
  String get saveSentenceFailed => 'वाक्य सहेजा नहीं जा सका।';

  @override
  String get recordStartFailed => 'रिकॉर्डिंग शुरू नहीं हो सकी।';

  @override
  String get recordTooShort =>
      'वह रिकॉर्डिंग बहुत छोटी थी। कृपया फिर कोशिश करें।';

  @override
  String get gradingFailed => 'स्कोरिंग विफल रही। कृपया फिर कोशिश करें।';

  @override
  String get listenStandard => 'मानक उच्चारण सुनें';

  @override
  String get saveSentence => 'वाक्य सहेजें';

  @override
  String get unsaveSentence => 'सहेजा गया वाक्य हटाएँ';

  @override
  String get scoringPronunciation => 'आपके उच्चारण का स्कोर तय हो रहा है…';

  @override
  String get analyzingByWord => 'आपका उच्चारण शब्द दर शब्द जाँचा जा रहा है';

  @override
  String get analyzingTakingLonger => 'इसमें थोड़ा और समय लग रहा है';

  @override
  String get scanConnectionLost => 'कनेक्शन टूट गया';

  @override
  String get noRecordingToPlay => 'चलाने के लिए कोई रिकॉर्डिंग नहीं।';

  @override
  String get myRecordingPlayError => 'आपकी रिकॉर्डिंग नहीं चल सकी।';

  @override
  String get next => 'अगला';

  @override
  String get endLearning => 'सत्र समाप्त करें';

  @override
  String get navCalendar => 'कैलेंडर';

  @override
  String get navCall => 'कॉल';

  @override
  String get navStats => 'आँकड़े';

  @override
  String get myPage => 'मेरा पेज';

  @override
  String get languageSaveFailed => 'आपकी भाषा सहेजी नहीं जा सकी।';

  @override
  String get accountDeleteFailed => 'आपका खाता हटाया नहीं जा सका।';

  @override
  String get changeAvatar => 'अवतार बदलें';

  @override
  String get avatarIntro =>
      'आवाज़ और कठिनाई कॉल पार्टनर के अनुसार अलग-अलग होती है।\nकुछ पार्टनर के लिए भुगतान करना पड़ सकता है।';

  @override
  String myPartnersOwned(int count) {
    return 'मेरे पार्टनर · $count स्वामित्व में';
  }

  @override
  String get limitedDiscount => 'सीमित समय की छूट';

  @override
  String get available => 'उपलब्ध';

  @override
  String get inUse => 'उपयोग में';

  @override
  String get owned => 'स्वामित्व में';

  @override
  String get noCharactersToShow => 'दिखाने के लिए कोई कैरेक्टर नहीं';

  @override
  String get buy => 'खरीदें';

  @override
  String get noSavedSentences =>
      'अभी तक कोई सहेजा गया वाक्य नहीं।\nअपनी बातचीत के रिकॉर्ड से वाक्यों को बुकमार्क करें।';

  @override
  String get noAlarms => 'अभी तक कोई अलार्म नहीं';

  @override
  String get noAlarmsBody =>
      'एक नियमित आदत बनाने के लिए\nएक लर्निंग रिमाइंडर जोड़ें।';

  @override
  String get subscriptionManage => 'सदस्यता प्रबंधित करें';

  @override
  String get changePlan => 'प्लान बदलें';

  @override
  String get cancelSubscription => 'सदस्यता रद्द करें';

  @override
  String get benefitsInUse => 'आपके लाभ';

  @override
  String get paymentInfo => 'भुगतान जानकारी';

  @override
  String get nextBillingDate => 'अगली बिलिंग तारीख';

  @override
  String get lostBenefitsTitle => 'रद्द करने पर आप जो लाभ खो देंगे';

  @override
  String get viewBillingHistory => 'बिलिंग इतिहास देखें';

  @override
  String get keepUsingPro => 'Pro का उपयोग जारी रखें';

  @override
  String get proMembership => 'Pro सदस्यता';

  @override
  String pricePerMonth(String price) {
    return '$price / माह';
  }

  @override
  String get benefitUnlimitedCalls => 'असीमित कॉल';

  @override
  String get benefitDetailedAnalysis => 'विस्तृत उच्चारण और व्याकरण विश्लेषण';

  @override
  String get benefitAllCharacters => 'सभी कैरेक्टर तक पहुँच';

  @override
  String get benefitNoAds => 'कोई विज्ञापन नहीं';

  @override
  String get playSampleVoice => 'नमूना आवाज़ चलाएँ';

  @override
  String get useThisAvatar => 'इसे उपयोग करें';

  @override
  String get challengeTitle => 'उच्चारण चुनौती';

  @override
  String get challengeIntro =>
      'इसे पूरा करने के लिए ज़ोन के हर कार्ड का कोरियाई में सही उच्चारण करें।\nमाइक नहीं है? आप स्क्रीन टैप करके भी खेल सकते हैं।';

  @override
  String get challengeStart => 'कैमरा और माइक शुरू करें';

  @override
  String get challengePermissionNote =>
      'फ्रंट कैमरा और माइक एक्सेस आवश्यक है (वैकल्पिक)।';

  @override
  String get challengeLoadingTitle => 'लोड हो रहा है…';

  @override
  String get challengeLoadingNote =>
      'पहली बार चलाने पर कोरियाई स्पीच मॉडल (~82MB) डाउनलोड हो रहा है।\nकृपया थोड़ा प्रतीक्षा करें।';

  @override
  String get challengeSttFallback =>
      'स्पीच पहचान उपलब्ध नहीं थी, इसलिए आपने टैप इनपुट से खेला।';

  @override
  String get reasonTravelTitle => 'यात्रा के दौरान बोलना';

  @override
  String get reasonTravelDesc => 'स्थानीय लोगों से आत्मविश्वास से बात करें';

  @override
  String get reasonCareerTitle => 'काम और करियर';

  @override
  String get reasonCareerDesc => 'व्यावसायिक बातचीत';

  @override
  String get reasonExamTitle => 'परीक्षा की तैयारी';

  @override
  String get reasonExamDesc => 'स्पीकिंग टेस्ट की तैयारी करें';

  @override
  String get reasonDailyTitle => 'रोज़मर्रा की बातचीत';

  @override
  String get reasonDailyDesc => 'रोज़ इस्तेमाल होने वाले वाक्यांश';

  @override
  String get reasonFriendsTitle => 'विदेशी दोस्त बनाना';

  @override
  String get reasonFriendsDesc => 'स्वाभाविक बातचीत';

  @override
  String get reasonBrainTitle => 'मस्तिष्क सक्रियता';

  @override
  String get reasonBrainDesc => 'याददाश्त और एकाग्रता बढ़ाएँ';

  @override
  String get challengeRecordToggle => 'इस रन को रिकॉर्ड करें';

  @override
  String get challengeRecordHint =>
      'शेयर करने के लिए आपके गेमप्ले का वीडियो सहेजता है (मूक)।';

  @override
  String get settingsSection => 'सेटिंग्स';

  @override
  String get paymentSection => 'भुगतान';

  @override
  String get supportSection => 'सहायता';

  @override
  String get userLanguage => 'उपयोगकर्ता भाषा';

  @override
  String get learningLanguage => 'सीखने की भाषा';

  @override
  String get learningLanguageKorean => 'कोरियाई';

  @override
  String get notificationLabel => 'सूचना';

  @override
  String get currentPlan => 'वर्तमान प्लान';

  @override
  String get paymentHistory => 'भुगतान इतिहास';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get deleteAccount => 'खाता हटाएँ';

  @override
  String get deleteAccountTitle => 'खाता हटाएँ?';

  @override
  String get deleteAccountBody =>
      'यह आपके खाते और डेटा को स्थायी रूप से हटा देता है और इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get delete => 'हटाएँ';

  @override
  String get share => 'शेयर करें';

  @override
  String get accentSoundsLike => 'आपका कोरियाई उच्चारण सुनाई देता है';

  @override
  String get hintLabel => 'संकेत';

  @override
  String get nextHint => 'अगला संकेत';

  @override
  String get translateLabel => 'अनुवाद करें';

  @override
  String get startRecording => 'रिकॉर्डिंग शुरू करें';

  @override
  String get stopRecording => 'रिकॉर्डिंग बंद करें';

  @override
  String get back => 'वापस';

  @override
  String get onboardingNameTitle => 'हम आपको क्या कहकर बुलाएँ?';

  @override
  String get onboardingNameSubtitle => 'आपका AI ट्यूटर आपका नाम याद रखेगा।';

  @override
  String get nameLabel => 'आपका नाम';

  @override
  String get nameHint => 'अपना नाम दर्ज करें';

  @override
  String get nameHelper =>
      'यह आपका असली नाम होना ज़रूरी नहीं — कोई उपनाम भी चलेगा।';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get onboardingDoneTitle => 'Beaver आपकी कॉल का इंतज़ार कर रहा है';

  @override
  String get onboardingDoneSubtitle => 'अभी कॉल शुरू करें';

  @override
  String get home => 'होम';

  @override
  String get callNow => 'अभी कॉल करें';

  @override
  String get pronunciation => 'उच्चारण';

  @override
  String get fluency => 'प्रवाह';

  @override
  String get rhythm => 'लय';

  @override
  String get analysisTimeout =>
      'इसमें उम्मीद से ज़्यादा समय लग रहा है। कृपया थोड़ी देर में फिर कोशिश करें।';

  @override
  String get analysisFailed =>
      'हम बातचीत का विश्लेषण नहीं कर सके। कृपया फिर कोशिश करें।';

  @override
  String get analyzingConversation => 'आपकी बातचीत का विश्लेषण हो रहा है…';

  @override
  String get analyzingSubtitle => 'इसमें बस एक पल लगेगा';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get nativeLabel => 'मूल वक्ता';

  @override
  String get meLabel => 'मैं';

  @override
  String get pronunciationPlayError => 'उच्चारण ऑडियो नहीं चल सका।';

  @override
  String get savedExpressionsLoadError =>
      'आपके सहेजे गए वाक्यांश लोड नहीं हो सके।';

  @override
  String get mySavedExpressions => 'मेरे सहेजे गए वाक्यांश';

  @override
  String get avatarTraits => 'गर्मजोशी · शांत · कोमल';

  @override
  String get priceFree => 'मुफ़्त';

  @override
  String get loginGoogleTokenError => 'Google साइन-इन टोकन नहीं मिल सका।';

  @override
  String get loginGoogleSignInFailed => 'Google साइन-इन विफल रहा।';

  @override
  String get loginAppleSignInFailed => 'Apple साइन-इन विफल रहा।';

  @override
  String get loginFacebookSignInFailed => 'Facebook साइन-इन विफल रहा।';

  @override
  String get loginKakaoSignInFailed => 'Kakao साइन-इन विफल रहा।';

  @override
  String get loginContinueWithKakao => 'Kakao के साथ जारी रखें';

  @override
  String get loginContinueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get loginContinueWithFacebook => 'Facebook के साथ जारी रखें';

  @override
  String get loginContinueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get loginContinueWithEmail => 'ईमेल के साथ जारी रखें';

  @override
  String get loginOrDivider => 'या';

  @override
  String get loginNoAccount => 'खाता नहीं है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get loginTermsNoticePrefix => 'जारी रखकर, आप हमारी ';

  @override
  String get loginTermsNoticeAnd => ' और ';

  @override
  String get loginTermsNoticeSuffix => ' से सहमत होते हैं।';

  @override
  String get loginLogIn => 'लॉग इन करें';

  @override
  String get fieldEmailLabel => 'ईमेल';

  @override
  String get emailHint => 'अपना ईमेल दर्ज करें';

  @override
  String get fieldPasswordLabel => 'पासवर्ड';

  @override
  String get passwordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginRememberMe => 'मुझे याद रखें';

  @override
  String get loginForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get loginLoggingIn => 'लॉग इन हो रहा है...';

  @override
  String get passwordLengthError => 'पासवर्ड 8–16 अक्षरों का होना चाहिए।';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get signupCheckInput => 'कृपया अपना इनपुट जाँचें।';

  @override
  String get fieldConfirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get confirmPasswordHint => 'अपना पासवर्ड फिर से दर्ज करें';

  @override
  String get signupSigningUp => 'साइन अप हो रहा है...';

  @override
  String get signupHaveAccount => 'पहले से एक खाता है?';

  @override
  String get passwordMethodEmailRequired => 'अपना ईमेल दर्ज करें';

  @override
  String get passwordResetTitle => 'पासवर्ड रीसेट करें';

  @override
  String get passwordMethodDescription =>
      'वह ईमेल पता दर्ज करें जहाँ आप पासवर्ड रीसेट कोड प्राप्त करना चाहते हैं।';

  @override
  String get emailAddressHint => 'ईमेल पता';

  @override
  String get passwordMethodSending => 'भेजा जा रहा है...';

  @override
  String get passwordMethodSendEmail => 'ईमेल भेजें';

  @override
  String get passwordCodeTitle => 'कोड दर्ज करें';

  @override
  String get passwordCodeDescription =>
      'हमने आपके ईमेल पर एक रिकवरी कोड भेजा है। जारी रखने के लिए इसे दर्ज करें।';

  @override
  String get passwordCodeNoCode => 'कोड नहीं मिला?';

  @override
  String get passwordCodeResend => 'कोड फिर से भेजें';

  @override
  String get passwordCodeVerifying => 'सत्यापित हो रहा है...';

  @override
  String get passwordNewTitle => 'नया पासवर्ड';

  @override
  String get passwordNewDescription =>
      'अपने खाते के लिए एक नया पासवर्ड सेट करें।';

  @override
  String get fieldNewPasswordLabel => 'नया पासवर्ड';

  @override
  String get newPasswordHint => 'अपना नया पासवर्ड दर्ज करें';

  @override
  String get fieldConfirmNewPasswordLabel => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get confirmNewPasswordHint => 'अपना नया पासवर्ड फिर से दर्ज करें';

  @override
  String get passwordNewSubmitting => 'सबमिट हो रहा है...';

  @override
  String get passwordNewSubmit => 'सबमिट करें';

  @override
  String get passwordCompleteTitle => 'पासवर्ड रीसेट पूर्ण';

  @override
  String get passwordCompleteBody =>
      'आपका पासवर्ड रीसेट हो गया है। जारी रखने के लिए अपने नए पासवर्ड से लॉग इन करें।';

  @override
  String get termsTitle => 'सेवा की शर्तें';

  @override
  String get privacyTitle => 'गोपनीयता नीति';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email के लिए एक नया पासवर्ड सेट करें।';
  }

  @override
  String get selectComplete => 'हो गया';

  @override
  String get onboardingLanguageTitle => 'आपकी मातृभाषा क्या है?';

  @override
  String get onboardingReasonTitle => 'आप भाषा क्यों सीख रहे हैं?';

  @override
  String get onboardingReasonSubtitle =>
      'हम आपके लक्ष्यों के अनुसार आपकी सीख को अनुकूलित करेंगे।';

  @override
  String get savingLabel => 'सहेजा जा रहा है...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'इस महीने का भुगतान';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterSubscription => 'सदस्यता';

  @override
  String get filterCharacter => 'किरदार';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get lastPayment => 'पिछला भुगतान';

  @override
  String subscriptionSwitchNote(String date) {
    return 'आप $date तक Pro लाभ इस्तेमाल कर सकते हैं, उसके बाद आपका प्लान अपने आप मुफ़्त में बदल जाएगा।';
  }

  @override
  String get freePlanCallLimit => 'रोज़ 1 कॉल · 5 मिनट की सीमा';

  @override
  String get freePlanBasicCharacters => 'बेसिक किरदार शामिल';

  @override
  String get availableForPurchase => 'खरीद के लिए उपलब्ध';

  @override
  String get paymentsLoadError => 'भुगतान इतिहास लोड नहीं हो सका';

  @override
  String get noPayments => 'अभी कोई भुगतान नहीं';

  @override
  String get morePaymentsExist => 'पुराने भुगतान अभी नहीं दिखाए गए';

  @override
  String get undatedPayments => 'बिना तारीख';

  @override
  String get paymentLabelFallback => 'भुगतान';

  @override
  String learningPassed(int passed, int total) {
    return '$total में से $passed वाक्य पास';
  }

  @override
  String get hardestSound => 'आज की सबसे कठिन ध्वनि';

  @override
  String get soundAccuracy => 'ध्वनि के अनुसार सटीकता';

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
  String get colAccuracy => 'सटीक.';

  @override
  String get sentenceResults => 'वाक्य के अनुसार परिणाम';

  @override
  String viewAllSentences(int count) {
    return 'सभी $count देखें';
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
    return 'पिछले $count सत्र';
  }

  @override
  String trendAverage(int score) {
    return 'औसत $score';
  }

  @override
  String get today => 'आज';

  @override
  String get colDate => 'तारीख';

  @override
  String get colSentences => 'वाक्य';

  @override
  String get colScore => 'अंक';

  @override
  String get colChange => 'बदलाव';

  @override
  String dateToday(String date) {
    return '$date (आज)';
  }

  @override
  String get accentAnalysis => 'उच्चारण-शैली विश्लेषण';

  @override
  String get overallLevel => 'समग्र स्तर';

  @override
  String get overallLevelSubtitle => 'शब्दावली · व्याकरण · अभिव्यक्ति';

  @override
  String get pronunciationAnalysis => 'उच्चारण विश्लेषण';

  @override
  String get recentSessionsAverage => 'पिछले 10 सत्रों का औसत';

  @override
  String levelStage(int stage) {
    return 'स्तर $stage';
  }

  @override
  String topPercent(int percent) {
    return 'शीर्ष $percent%';
  }

  @override
  String get allLearnersBasis => 'सभी शिक्षार्थियों में';

  @override
  String aheadOfLearners(int percent) {
    return 'आप $percent% शिक्षार्थियों से आगे हैं';
  }

  @override
  String get retakeLevelTest => 'स्तर परीक्षा दोबारा दें';

  @override
  String get practicePronunciation => 'उच्चारण अभ्यास करें';

  @override
  String get priceChangedTitle => 'कीमत बदल गई';

  @override
  String priceChangedBody(String price) {
    return 'इस आइटम की कीमत अब $price है। क्या जारी रखें?';
  }

  @override
  String get billingGroupPlanPurchases => 'प्लान और खरीदारी';

  @override
  String get billingGroupInTheStore => 'स्टोर में';

  @override
  String get billingChangePlan => 'प्लान बदलें';

  @override
  String get billingCompareAllPlans => 'सभी प्लान की तुलना करें';

  @override
  String get billingBuyACharacter => 'कैरेक्टर खरीदें';

  @override
  String get billingRestorePurchases => 'खरीदारी रीस्टोर करें';

  @override
  String get billingPaymentHistory => 'भुगतान इतिहास';

  @override
  String get billingManageInTheStore => 'स्टोर में प्रबंधित करें';

  @override
  String get billingRefundHelp => 'रिफ़ंड सहायता';

  @override
  String get billingCancelSubscription => 'सदस्यता रद्द करें';

  @override
  String get billingResubscribe => 'फिर से सदस्यता लें';

  @override
  String get badgeCurrent => 'वर्तमान';

  @override
  String get badgeTrial => 'ट्रायल';

  @override
  String get badgeRenewing => 'नवीनीकरण जारी';

  @override
  String get badgePastDue => 'भुगतान बकाया';

  @override
  String get badgePaused => 'रोका गया';

  @override
  String get badgeCanceling => 'रद्द हो रहा है';

  @override
  String get subscriptionTitle => 'सदस्यता';

  @override
  String get plansTitle => 'प्लान';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max ट्रायल';

  @override
  String get freePlanPriceLine => '\$0.00 — रोज़ एक कॉल';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount प्रति माह';
  }

  @override
  String freeUntilDate(String date) {
    return '$date तक मुफ़्त';
  }

  @override
  String get todaysCalls => 'आज की कॉल';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit में से $used इस्तेमाल हुईं';
  }

  @override
  String get firstPaymentLabel => 'पहला भुगतान';

  @override
  String get nextPaymentLabel => 'अगला भुगतान';

  @override
  String get retryingUntilLabel => 'इस तारीख़ तक पुनः प्रयास';

  @override
  String get pausedSinceLabel => 'इस तारीख़ से रोका गया';

  @override
  String planEndsLabel(String plan) {
    return '$plan समाप्त';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pro के साथ अनलिमिटेड बनें';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'अनलिमिटेड कॉल · हर कॉल 15 मिनट · $price प्रति माह';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max के साथ वीडियो चालू करें';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'आमने-सामने कॉल · $price प्रति माह';
  }

  @override
  String get bannerAnnualSwitchTitle => 'वार्षिक प्लान पर जाएँ';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly प्रति वर्ष · $perMonth प्रति माह';
  }

  @override
  String get bannerPaymentFailedTitle => 'हम भुगतान नहीं ले सके';

  @override
  String get bannerPaymentFailedSub =>
      'Pro बनाए रखने के लिए स्टोर में भुगतान अपडेट करें';

  @override
  String get bannerPausedTitle => 'आपका प्लान रोक दिया गया है';

  @override
  String get bannerPausedSub => 'भुगतान पूरा नहीं हो सका';

  @override
  String get noteRestoreHint =>
      'किसी दूसरे डिवाइस पर पहले से सदस्य हैं? रीस्टोर से वह इस डिवाइस पर वापस आ जाएगी।';

  @override
  String get noteStoreHandled =>
      'भुगतान का तरीका, प्लान बदलना और रद्द करना — सब स्टोर से होता है।';

  @override
  String get noteFairUse => 'अनलिमिटेड उपयोग हमारी उचित उपयोग नीति के अधीन है।';

  @override
  String noteTrialEnds(String date) {
    return 'आपका ट्रायल $date को समाप्त होगा। उससे पहले स्टोर में रद्द करें तो कुछ भी चार्ज नहीं होगा।';
  }

  @override
  String get noteGrace =>
      'ग्रेस अवधि के दौरान आपके लाभ चलते रहते हैं। रद्द करना ऐप में कभी रोका नहीं जाता।';

  @override
  String get noteHold =>
      'भुगतान होने तक Pro रुका हुआ है। आपके कैरेक्टर और प्रगति सुरक्षित हैं।';

  @override
  String noteEnding(String date) {
    return 'आपका प्लान समाप्त होने वाला है। लाभ $date तक चलेंगे, फिर आप Free पर आ जाएँगे। आप कभी भी फिर से सदस्यता ले सकते हैं।';
  }

  @override
  String get trialExpiredTitle => 'आपका Max ट्रायल समाप्त हो गया';

  @override
  String get trialExpiredSub => 'अब आप Free पर हैं';

  @override
  String get seePlans => 'प्लान देखें';

  @override
  String get currentPlanTitle => 'वर्तमान प्लान';

  @override
  String get badgeRecommended => 'अनुशंसित';

  @override
  String get perMonthUnit => 'प्रति माह';

  @override
  String get planTaglinePro => 'अनलिमिटेड कॉल। हर कॉल 15 मिनट।';

  @override
  String get planTaglineMax => 'अब आप उन्हें देख सकते हैं।';

  @override
  String get planTaglineFree => 'रोज़ एक कॉल। बिल्कुल मुफ़्त।';

  @override
  String get bulletProCalls => 'जितनी चाहें उतनी वॉयस कॉल';

  @override
  String get bulletProLength => 'हर कॉल 15 मिनट';

  @override
  String get bulletProScoring => 'अक्षर-दर-अक्षर उच्चारण स्कोरिंग';

  @override
  String get bulletProCorrections => 'आपकी मातृभाषा के अनुसार सुधार';

  @override
  String get bulletProBeaverCalls => 'बीवर पहले आपको कॉल करता है';

  @override
  String get bulletMaxVideo => 'आमने-सामने वीडियो कॉल';

  @override
  String get bulletMaxEverything => 'Pro की हर सुविधा';

  @override
  String get bulletMaxCharacters => 'हर कैरेक्टर, अनलिमिटेड';

  @override
  String get bulletMaxStudyBook => 'आपके स्तर के हिसाब से स्टडी बुक';

  @override
  String get bulletMaxWeeklyReport =>
      'आपके उच्चारण में बदलाव पर साप्ताहिक रिपोर्ट';

  @override
  String get bulletFreeCall => 'रोज़ एक 5 मिनट की वॉयस कॉल';

  @override
  String get bulletFreeCheck => 'रोज़ एक उच्चारण जाँच';

  @override
  String get bulletFreeAccent => 'अनलिमिटेड एक्सेंट जाँच';

  @override
  String get bulletFreeCharacter => 'शुरुआत के लिए एक कैरेक्टर';

  @override
  String get ctaGoUnlimited => 'अनलिमिटेड बनें';

  @override
  String get ctaTurnOnVideo => 'वीडियो चालू करें';

  @override
  String get noteCallLength => 'हर कॉल 15 मिनट की होती है।';

  @override
  String get paywallProTitle1 => 'आपका कोरियाई दोस्त';

  @override
  String get paywallProTitle2 => 'जो रात 3 बजे भी जागता है';

  @override
  String get paywallProSub => 'अनलिमिटेड कॉल। हर कॉल 15 मिनट। साल भर।';

  @override
  String get paywallLimitHeadline => 'Pro यह सीमा हटा देता है।';

  @override
  String get limitBannerCallTitle => 'आज की कॉल यही थी';

  @override
  String get limitBannerCallSub => 'Free में रोज़ एक कॉल मिलती है';

  @override
  String get limitBannerCheckTitle => 'आज की जाँच यही थी';

  @override
  String get limitBannerCheckSub => 'Free में रोज़ एक जाँच मिलती है';

  @override
  String get bulletProCharactersForever =>
      'खरीदे गए कैरेक्टर हमेशा आपके रहते हैं';

  @override
  String get paywallMaxTitle => 'अब आप उन्हें देख सकते हैं।';

  @override
  String get paywallMaxSub =>
      'वीडियो कॉल, हर कैरेक्टर, और आपके स्तर के लिए बनी स्टडी बुक।';

  @override
  String get planMonthly => 'मासिक';

  @override
  String get planAnnual => 'वार्षिक';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price प्रति माह';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth प्रति माह';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price प्रति माह';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly प्रति वर्ष · $perMonth प्रति माह';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price प्रति माह · स्टोर में कभी भी रद्द करें';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price प्रति माह · स्टोर में कभी भी रद्द करें';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 दिन मुफ़्त, फिर $price प्रति माह · स्टोर में कभी भी रद्द करें';
  }

  @override
  String get ctaCaptionAutoRenew => 'रद्द करने तक स्वतः नवीनीकृत होता है।';

  @override
  String get footerTerms => 'शर्तें';

  @override
  String get footerPrivacy => 'गोपनीयता';

  @override
  String get noteMaxCharacters =>
      'Max से खुले कैरेक्टर तब तक उपलब्ध हैं जब तक आपकी सदस्यता सक्रिय है। खरीदे गए कैरेक्टर आपके ही रहते हैं।';

  @override
  String get processingTitle => 'आपकी खरीदारी की पुष्टि हो रही है';

  @override
  String get processingSub => 'इसमें आमतौर पर कुछ सेकंड लगते हैं।';

  @override
  String get successProTitle => 'आप Pro पर हैं।';

  @override
  String get successProSub => 'अनलिमिटेड कॉल, अभी से शुरू।';

  @override
  String get successProBenefit1 => 'जितनी चाहें कॉल करें — हर कॉल 15 मिनट';

  @override
  String get successProBenefit2 => 'अनलिमिटेड उच्चारण जाँच';

  @override
  String get successProBenefit3 => 'हर कैरेक्टर, साथ में एकमुश्त खरीदारी भी';

  @override
  String get successMaxTitle => 'अब आप उन्हें देख सकते हैं।';

  @override
  String get successMaxSub =>
      'वीडियो कॉल चालू हैं। किसी भी कॉल में वीडियो बटन दबाएँ।';

  @override
  String get successMaxBenefit1 => 'आमने-सामने वीडियो कॉल';

  @override
  String get successMaxBenefit2 => 'हर कैरेक्टर अनलिमिटेड, नए सबसे पहले';

  @override
  String get successMaxBenefit3 => 'आपके स्तर के हिसाब से स्टडी बुक';

  @override
  String get ctaStartACall => 'कॉल शुरू करें';

  @override
  String get ctaStartAVideoCall => 'वीडियो कॉल शुरू करें';

  @override
  String get ctaSeeYourSubscription => 'अपनी सदस्यता देखें';

  @override
  String successProCaption(String price) {
    return 'रद्द करने तक हर महीने $price लिया जाएगा। स्टोर में कभी भी प्रबंधित या रद्द करें।';
  }

  @override
  String successMaxCaption(String price) {
    return 'रद्द करने तक हर महीने $price लिया जाएगा। स्टोर में कभी भी प्रबंधित या रद्द करें।';
  }

  @override
  String get plansErrorTitle => 'हम प्लान लोड नहीं कर सके';

  @override
  String get plansErrorSub => 'स्टोर से जवाब नहीं मिला।';

  @override
  String get ctaTryAgain => 'फिर से कोशिश करें';

  @override
  String get plansErrorCaption => 'कुछ भी चार्ज नहीं हुआ।';

  @override
  String get changePlanTitle => 'प्लान बदलें';

  @override
  String get moveToMaxTitle => 'Max पर जाएँ';

  @override
  String maxPriceShort(String price) {
    return '$price / माह';
  }

  @override
  String get moveToMaxCardSub =>
      'आमने-सामने वीडियो कॉल · हर कैरेक्टर · आपके लिए बनी स्टडी बुक';

  @override
  String get whatHappensNow => 'अब क्या होगा';

  @override
  String get maxStartsLabel => 'Max शुरू';

  @override
  String get immediately => 'तुरंत';

  @override
  String get unusedProTime => 'Pro का बचा हुआ समय';

  @override
  String get creditedTowardMax => 'Max में समायोजित होगा';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max पर स्विच करें';

  @override
  String get upgradeCaption =>
      'आपका नया प्लान तुरंत शुरू होता है। Pro का बचा हुआ समय समायोजित होता है, दोबारा चार्ज कभी नहीं।';

  @override
  String get moveToProTitle => 'Pro पर जाएँ';

  @override
  String get moveToProSub =>
      'आज कुछ नहीं बदलेगा। जिस महीने का भुगतान हो चुका है, Max उसके अंत तक चलेगा।';

  @override
  String get maxRunsUntil => 'Max चलेगा';

  @override
  String get proStarts => 'Pro शुरू';

  @override
  String get whatYouKeep => 'आपके पास क्या रहेगा';

  @override
  String get keepBenefitCalls => 'अनलिमिटेड वॉयस कॉल, हर कॉल 15 मिनट';

  @override
  String get keepBenefitCharacters => 'खरीदे गए कैरेक्टर हमेशा आपके रहते हैं';

  @override
  String downgradeWarning(String date) {
    return 'वीडियो कॉल और सिर्फ़ Max वाले कैरेक्टर $date को बंद हो जाएँगे।';
  }

  @override
  String get ctaSwitchToPro => 'Pro पर स्विच करें';

  @override
  String get ctaKeepMax => 'Max रखें';

  @override
  String get winbackSkip => 'छोड़ें';

  @override
  String get winbackTitle => 'आपका Pro प्लान समाप्त हो गया';

  @override
  String get winbackSub => 'अब आप Free पर हैं — रोज़ एक कॉल।';

  @override
  String get winbackQuestion => 'बताएँगे कि आपने क्यों छोड़ा?';

  @override
  String get winbackReasonExpensive => 'बहुत महँगा है';

  @override
  String get winbackReasonUnused => 'मैं इतना इस्तेमाल नहीं कर रहा था';

  @override
  String get winbackReasonMissing => 'मुझे चाहिए वाला फ़ीचर नहीं था';

  @override
  String get winbackReasonOtherApp => 'मुझे दूसरा ऐप मिल गया';

  @override
  String get winbackReasonElse => 'कुछ और';

  @override
  String get ctaSend => 'भेजें';

  @override
  String get ctaNotNow => 'अभी नहीं';

  @override
  String get winbackCaption =>
      'इससे आपका प्लान बहाल नहीं होता। स्टोर में फिर से सदस्यता लें।';

  @override
  String get ctaContinue => 'जारी रखें';

  @override
  String get ctaClose => 'बंद करें';

  @override
  String get ovRestoreSuccessTitle => 'Pro वापस आ गया';

  @override
  String get ovRestoreSuccessBody =>
      'हमें आपकी सदस्यता मिल गई और इस डिवाइस पर फिर से चालू कर दी गई।';

  @override
  String get ovRestoreEmptyTitle => 'रीस्टोर करने को कुछ नहीं';

  @override
  String get ovRestoreEmptyBody =>
      'इस स्टोर खाते से कोई सक्रिय सदस्यता जुड़ी नहीं है।';

  @override
  String get ovRestoreOtherTitle => 'यह प्लान किसी और खाते का है';

  @override
  String get ovRestoreOtherBody =>
      'यह सदस्यता पहले से एक दूसरे BeaverTalk खाते पर सक्रिय है।';

  @override
  String get ctaSignInThatAccount => 'उस खाते में साइन इन करें';

  @override
  String get ctaGetHelp => 'मदद लें';

  @override
  String get ovCharacterOfferTitle => 'Pro के लिए तैयार नहीं?';

  @override
  String get ovCharacterOfferBody =>
      'एक कैरेक्टर चुनें और अपना बना लें। एकमुश्त खरीदारी — न सदस्यता, न नवीनीकरण।';

  @override
  String get rowOneCharacter => 'एक कैरेक्टर';

  @override
  String rowFromPrice(String price) {
    return '$price से';
  }

  @override
  String get rowYoursForever => 'हमेशा आपका';

  @override
  String get rowNoRenewal => 'कोई नवीनीकरण नहीं';

  @override
  String get rowWorksOnFree => 'Free पर चलता है';

  @override
  String get rowYes => 'हाँ';

  @override
  String get ctaSeeCharacters => 'कैरेक्टर देखें';

  @override
  String get ovNotEligibleTitle => 'रद्द करने को कुछ नहीं';

  @override
  String get ovNotEligibleBody =>
      'आप Free पर हैं। इस खाते पर कोई सक्रिय सदस्यता नहीं है।';

  @override
  String get ovCancelDownsellTitle => 'जाने से पहले';

  @override
  String get ovCancelDownsellBody =>
      'रद्द करना स्टोर में होता है। दो बातें जानने लायक हैं।';

  @override
  String get rowPayYearlyInstead => 'इसके बजाय सालाना भुगतान करें';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price प्रति माह';
  }

  @override
  String get rowCharactersYouBought => 'आपके खरीदे कैरेक्टर';

  @override
  String get rowProRunsUntil => 'Pro चलेगा';

  @override
  String get ctaSwitchToYearly => 'वार्षिक पर स्विच करें';

  @override
  String get ctaContinueToStore => 'स्टोर पर जाएँ';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'सालाना भुगतान करें, $saved बचाएँ';
  }

  @override
  String get ovAnnualSwitchBody =>
      'आप दो महीने से Pro पर हैं। वार्षिक प्लान सस्ता पड़ता है।';

  @override
  String get rowYouSave => 'आपकी बचत';

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
  String get rowMonthlyForYear => 'साल भर मासिक';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'मासिक पर स्विच करें';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'आपका वार्षिक प्लान $date तक चलता है। मासिक बिलिंग उसके अगले दिन शुरू होगी।';
  }

  @override
  String get rowMonthlyBillingStarts => 'मासिक बिलिंग शुरू';

  @override
  String get rowMonthlyLabel => 'मासिक';

  @override
  String get rowYearlyWorkedOut => 'वार्षिक का हिसाब था';

  @override
  String get ctaSwitchToMonthly => 'मासिक पर स्विच करें';

  @override
  String get ovRefundHelpTitle => 'रिफ़ंड स्टोर द्वारा किया जाता है';

  @override
  String get ovRefundHelpBody =>
      'हम खुद रिफ़ंड जारी नहीं कर सकते। हर अनुरोध की समीक्षा स्टोर करता है।';

  @override
  String get ctaGoToStore => 'स्टोर पर जाएँ';

  @override
  String get ovTrialEndingTitle => 'आपका ट्रायल कल समाप्त हो रहा है';

  @override
  String get ovTrialEndingBody =>
      'रद्द नहीं करेंगे तो Max चलता रहेगा। आगे यह होगा।';

  @override
  String get rowTrialEnds => 'ट्रायल समाप्त';

  @override
  String get rowFirstCharge => 'पहला चार्ज';

  @override
  String get rowThenMonthly => 'फिर हर महीने';

  @override
  String get ctaCancelInStore => 'स्टोर में रद्द करें';

  @override
  String get ovTrialStartTitle => 'Max के 7 दिन, मुफ़्त';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date तक मुफ़्त। फिर $price प्रति माह, जब तक आप स्टोर में रद्द न करें।';
  }

  @override
  String get ctaStart7Days => '7 दिन मुफ़्त शुरू करें';

  @override
  String get ovOtoTitle => 'शुरू करने से पहले एक और बात';

  @override
  String get ovOtoBody =>
      'बढ़िया फ़ैसला — अनलिमिटेड कॉल अभी चालू हैं। वही Pro सालाना भुगतान पर सस्ता पड़ता है।';

  @override
  String get ovFailedDeclinedTitle => 'आपका कार्ड अस्वीकार हो गया';

  @override
  String get ovFailedDeclinedBody =>
      'स्टोर भुगतान नहीं ले सका। कुछ भी चार्ज नहीं हुआ।';

  @override
  String get ctaUpdatePaymentMethod => 'भुगतान का तरीका अपडेट करें';

  @override
  String get ovFailedCanceledTitle => 'भुगतान रद्द हुआ';

  @override
  String get ovFailedCanceledBody =>
      'आप अब भी Free पर हैं। कुछ भी चार्ज नहीं हुआ।';

  @override
  String get ovFailedStoreTitle => 'कुछ गड़बड़ हो गई';

  @override
  String get ovFailedStoreBody =>
      'हम स्टोर से संपर्क नहीं कर सके। कुछ भी चार्ज नहीं हुआ।';

  @override
  String get ovAlreadyTitle => 'आप पहले से Pro पर हैं';

  @override
  String get ovAlreadyBody =>
      'इस स्टोर खाते पर एक सक्रिय प्लान है। खरीदने को कुछ नहीं।';

  @override
  String get ctaSeeMySubscription => 'मेरी सदस्यता देखें';

  @override
  String get subCancelTitle => 'सदस्यता रद्द करें';

  @override
  String subCancelBody(String date) {
    return 'Pro $date तक चलेगा। उसके बाद आप Free पर आ जाएँगे।';
  }

  @override
  String get subWhatYouLose => 'आप क्या खोएँगे';

  @override
  String get benefitCalls15 => 'अनलिमिटेड कॉल, हर कॉल 15 मिनट';

  @override
  String get benefitScoring => 'अक्षर-दर-अक्षर उच्चारण स्कोरिंग';

  @override
  String get benefitEveryCharacter => 'हर कैरेक्टर, अनलिमिटेड';

  @override
  String get ctaKeepPro => 'Pro रखें';

  @override
  String get subPaymentTitle => 'भुगतान अपडेट करें';

  @override
  String get subPaymentBody =>
      'हम भुगतान नहीं ले सके। ग्रेस अवधि में Pro चलता रहता है।';

  @override
  String get subHowToFix => 'इसे कैसे ठीक करें';

  @override
  String get fixStep1 => 'स्टोर खोलें और भुगतान का तरीका अपडेट करें';

  @override
  String get fixStep2 => 'वापस आएँ — आपका प्लान अपने आप फिर शुरू हो जाएगा';

  @override
  String get fixStep3 => 'कुछ भी दोबारा चार्ज नहीं होता';

  @override
  String get subResubTitle => 'फिर से सदस्यता लें';

  @override
  String subResubBody(String date) {
    return 'Pro $date को समाप्त होगा। ऑटो-रिन्यू फिर चालू करें, कुछ नहीं बदलेगा।';
  }

  @override
  String get subWhatYouKeep => 'आपके पास क्या रहेगा';

  @override
  String get ctaTurnItBackOn => 'फिर चालू करें';

  @override
  String get flTodayTitle => 'आज की कॉल यही थी';

  @override
  String get flTodayBody => 'जहाँ छोड़ा था वहीं से जारी रखें — अभी।';

  @override
  String get flCheckTitle => 'आज की जाँच यही थी';

  @override
  String get flCheckBody =>
      'Free पर रोज़ एक जाँच। Pro इसे अनलिमिटेड बना देता है।';

  @override
  String get flBenefitCalls => 'Pro के साथ अनलिमिटेड कॉल · हर कॉल 15 मिनट';

  @override
  String get flBenefitChecks => 'Pro के साथ अनलिमिटेड उच्चारण जाँच';

  @override
  String flCaption(String price) {
    return '$price प्रति माह · कभी भी रद्द करें';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit में से $used इस्तेमाल हुआ';
  }

  @override
  String get ctaMaybeTomorrow => 'शायद कल';

  @override
  String get accountSection => 'खाता';

  @override
  String get nicknameLabel => 'निकनेम';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'लॉगिन विधि';

  @override
  String get joinedLabel => 'शामिल हुए';

  @override
  String get editNicknameTitle => 'निकनेम बदलें';

  @override
  String get nicknameRule => '2–12 अक्षर। अक्षर और अंक। केवल अंग्रेज़ी';

  @override
  String get ctaSave => 'सेव करें';

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
  String get paywallLeaveTitle => 'अभी छोड़ने पर सदस्यता नहीं होगी';

  @override
  String get paywallLeaveBody =>
      'भुगतान के तुरंत बाद आपके लाभ खुल जाते हैं। आप मेरा पेज से कभी भी वापस आ सकते हैं।';

  @override
  String get ctaKeepLooking => 'देखते रहें';

  @override
  String get ctaLeaveAnyway => 'फिर भी छोड़ें';

  @override
  String get iapCharacterSuccessTitle => 'एक नया दोस्त जुड़ गया!';

  @override
  String get iapCharacterSuccessBody =>
      'यह कैरेक्टर हमेशा के लिए आपका है — प्लान बदलने पर भी रहता है, और खरीदारी बहाल करें से किसी भी डिवाइस पर वापस आ जाता है।';

  @override
  String get iapCharacterFailedBody =>
      'खरीदारी पूरी नहीं हुई। कोई राशि नहीं कटी — कृपया फिर से कोशिश करें।';

  @override
  String get noAccentDataTitle => 'अभी तक कोई स्वर-लय डेटा नहीं';

  @override
  String get noAccentDataBody =>
      'बात करते रहिए, आपकी स्वर-लय की विशेषताएँ जमा होती जाएँगी।';

  @override
  String get noLevelYetTitle => 'अभी तक कोई स्तर नहीं';

  @override
  String get noLevelYetBody => 'पहली कॉल पूरी करने पर आपका स्तर मिलेगा।';

  @override
  String get noPronunciationDataTitle => 'अभी तक उच्चारण का रिकॉर्ड नहीं';

  @override
  String get noPronunciationDataBody =>
      'कॉल में बोले गए वाक्यों से हम उच्चारण का विश्लेषण करते हैं।';

  @override
  String get noCharacterNote => 'अभी तक कोई बात नहीं कही';

  @override
  String get noPhonemesYet => 'विश्लेषण के लिए अभी कोई ध्वनि नहीं';

  @override
  String get noSentencesYet => 'विश्लेषण के लिए अभी कोई वाक्य नहीं';

  @override
  String get takeLevelTest => 'स्तर परीक्षा दें';

  @override
  String get reviewToSeeScore => 'दोहराने पर उच्चारण स्कोर दिखेगा';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get difficultySlow => 'धीमा';

  @override
  String get difficultyNormal => 'सामान्य';

  @override
  String get difficultyFast => 'तेज़';

  @override
  String get difficultyLabel => 'कठिनाई';

  @override
  String get connected => 'कनेक्ट हो गया';

  @override
  String get unlockedWithMax => 'Max के साथ उपलब्ध';

  @override
  String get callModeSheetTitle => 'आप कैसे बात करना चाहते हैं?';

  @override
  String get callModeSheetSubtitle => 'यह कॉल पर तुरंत लागू होगा';

  @override
  String get callModeFreeTalk => 'खुली बातचीत';

  @override
  String get callModeFreeTalkDesc => 'बिना सुधार के बात करें';

  @override
  String get callModeStudy => 'अभ्यास';

  @override
  String get callModeStudyDesc => 'एक बार में एक अभिव्यक्ति सीखें';

  @override
  String get callModeChange => 'मोड बदलें';

  @override
  String get callModeKeep => 'अभी नहीं';

  @override
  String get callExitTitle => 'कॉल समाप्त करें?';

  @override
  String get callExitSubtitle => 'अभी समाप्त करने पर भी एक कॉल गिनी जाएगी';

  @override
  String get callExitKeep => 'बात जारी रखें';

  @override
  String get callExitConfirm => 'कॉल समाप्त करें';

  @override
  String get callMicMute => 'म्यूट करें';

  @override
  String get callMicUnmute => 'अनम्यूट करें';

  @override
  String get callPushToTalk => 'बोलने के लिए दबाए रखें';
}
