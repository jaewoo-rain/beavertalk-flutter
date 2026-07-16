// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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
  String get analysisLoadError => 'विश्लेषण परिणाम लोड नहीं हो सका।';

  @override
  String get standardAudioNotReady => 'मानक उच्चारण ऑडियो अभी तैयार नहीं है।';

  @override
  String get standardAudioPlayError => 'मानक उच्चारण ऑडियो नहीं चल सका।';

  @override
  String get selectACountry => 'एक देश चुनें';

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
  String get pricePerMonth => '\$12.9 / mo';

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
  String get loginContinueWithKakao => 'Kakao के साथ जारी रखें';

  @override
  String get loginContinueWithGoogle => 'Google के साथ जारी रखें';

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
