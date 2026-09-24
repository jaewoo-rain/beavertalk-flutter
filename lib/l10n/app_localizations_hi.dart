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
  String get callDailyLimit => 'आज का सीखने का समय खत्म हो गया है।';

  @override
  String get callAlreadyInCall => 'आप पहले से एक कॉल पर हैं।';

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
  String get callRatingBody => 'आपकी रेटिंग से अगली बार बातचीत और बेहतर होगी।';

  @override
  String get callRatingSubmit => 'भेजें';

  @override
  String get callRatingSkip => 'छोड़ें';

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
  String get alarmAdd => 'अलार्म जोड़ें';

  @override
  String get alarmEdit => 'अलार्म बदलें';

  @override
  String get alarmEveryDay => 'रोज़';

  @override
  String get alarmWeekdays => 'सप्ताह के दिन';

  @override
  String get alarmWeekend => 'सप्ताहांत';

  @override
  String get alarmNoRepeat => 'दोहराव नहीं';

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
  String get alarmModeLearnSub => 'पाठ्यक्रम के भाव अभ्यास करें';

  @override
  String get alarmModeChatSub => 'किसी भी विषय पर बात';

  @override
  String alarmRowSummary(String days, String mode) {
    return '$days, $mode';
  }

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
  String get newExpressions => 'नए वाक्यांश';

  @override
  String get analysisPrepNote => 'आज की कॉल को देखा जा रहा है।';

  @override
  String get analysisPrepNoteHint => 'थोड़ी देर में यहाँ एक संदेश आएगा';

  @override
  String get analysisPrepTitle => 'बीवर आज के वाक्यांशों से कार्ड बना रहा है';

  @override
  String get analysisPrepSub => 'तैयार होते ही यहीं दिखेंगे।';

  @override
  String get analysisPrepStepSave => 'बातचीत सहेजना';

  @override
  String get analysisPrepStepCards => 'वाक्यांश कार्ड बनाना';

  @override
  String get analysisPrepStateDone => 'पूरा';

  @override
  String get analysisPrepStateWorking => 'जारी';

  @override
  String get analysisPrepStateWaiting => 'प्रतीक्षा में';

  @override
  String get usedExpressions => 'आपने जो अभिव्यक्तियाँ इस्तेमाल कीं';

  @override
  String quizExpressionsCount(int count) {
    return 'इस बार सीखे वाक्यांश $count';
  }

  @override
  String get quizPassed => 'सही';

  @override
  String get quizFailed => 'फिर से देखें';

  @override
  String get quizPending => 'अगली बार जारी रखें';

  @override
  String get analysisResult => 'विश्लेषण परिणाम';

  @override
  String get noNewExpressions => 'इस बातचीत से कोई नया वाक्यांश नहीं।';

  @override
  String get practice => 'अभ्यास';

  @override
  String get analysisNativeLabel => 'स्थानीय लोग';

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
  String get homeCourseExpression => 'अभिव्यक्ति';

  @override
  String get homeCourseFreetalk => 'बातचीत';

  @override
  String homeExpressionsLeft(int count) {
    return 'बातचीत तक $count अभिव्यक्तियाँ बाकी';
  }

  @override
  String get homeFreetalkNote =>
      'जो सीखा है उसका उपयोग करके स्वतंत्र रूप से बात करें';

  @override
  String get homeTalkTitle => 'आज क्या हुआ?';

  @override
  String get homeTalkNote => 'खुलकर बात करें और बात करते-करते सीखें।';

  @override
  String get homeModeLearn => 'सीखें';

  @override
  String get homeModeTalk => 'बातचीत';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'लगातार $count दिन',
      one: 'लगातार 1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'सीखने का कैलेंडर';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'दिन लगातार',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सबसे लंबा रिकॉर्ड $count दिन',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'कॉल का समय';

  @override
  String get streakMetricLearned => 'सीखे गए भाव';

  @override
  String get streakMetricWords => 'बोले गए शब्द';

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
      other: '$count मिनट',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'इस दिन कोई कॉल नहीं हुई।';

  @override
  String get homeLevelPending => 'स्तर तय नहीं';

  @override
  String get homeNoLevelTitle => 'आपका स्तर अभी नहीं है';

  @override
  String get homeNoLevelNote => 'पहली कॉल पूरी करें और स्तर पाएँ';

  @override
  String get homeCurriculumPendingBadge => 'जल्द आ रहा है';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language पाठ्यक्रम तैयार हो रहा है';
  }

  @override
  String get homeCurriculumPendingNote =>
      'कॉल में आप सामान्य वाक्यांशों का अभ्यास करेंगे';

  @override
  String get myPage => 'मेरा पेज';

  @override
  String get languageSaveFailed => 'आपकी भाषा सहेजी नहीं जा सकी।';

  @override
  String get accountDeleteFailed => 'आपका खाता हटाया नहीं जा सका।';

  @override
  String get changeAvatar => 'अवतार बदलें';

  @override
  String get avatarUseNow => 'अभी इस्तेमाल करें';

  @override
  String get avatarPurchaseFailed => 'खरीदारी पूरी नहीं हुई';

  @override
  String avatarPromoTitle(int percent) {
    return 'सिर्फ़ आज · $percent% छूट';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time बाकी';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days दिन $time बाकी';
  }

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
  String pricePerMonth(String price) {
    return '$price / माह';
  }

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
      'कैमरा और माइक्रोफ़ोन तैयार किए जा रहे हैं।';

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
  String get onboardingLevelTestCta => 'स्तर परीक्षा दें';

  @override
  String get pronunciation => 'उच्चारण';

  @override
  String get fluency => 'प्रवाह';

  @override
  String get rhythm => 'लय';

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
  String get freePlanCallLimit => 'रोज़ 5 मिनट कॉल';

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
  String get levelRetakeTitle => 'लेवल टेस्ट फिर से दें?';

  @override
  String get levelRetakeBody =>
      'फिर से देने पर आपकी प्रगति उस लेवल के पहले पाठ पर लौट जाएगी — भले ही वही लेवल आए। सीखे हुए भाव और कॉल इतिहास बने रहेंगे।';

  @override
  String get levelRetakeKeep => 'प्रगति रखें';

  @override
  String get levelRetakeConfirm => 'टेस्ट फिर से दें';

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
  String get billingCompareAllPlans => 'प्लान की तुलना करें';

  @override
  String get billingBuyACharacter => 'कैरेक्टर खरीदें';

  @override
  String get billingRestorePurchases => 'खरीदारी रीस्टोर करें';

  @override
  String get billingRedeemCode => 'कोड रिडीम करें';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'रोज़ 15 मिनट वीडियो कॉल';

  @override
  String get premiumBulletAnalysis => 'पूरा उच्चारण विश्लेषण';

  @override
  String get premiumBulletWeakSounds =>
      'आपकी भाषा के लिए कठिन ध्वनियों का अभ्यास';

  @override
  String get noteCharactersSeparate =>
      'कैरेक्टर अलग से बिकते हैं। खरीदे गए कैरेक्टर आपके ही रहते हैं।';

  @override
  String get ctaGetPremium => 'Premium लें';

  @override
  String get planMaxTrial => 'Premium ट्रायल';

  @override
  String get freePlanPriceLine => '\$0.00 — रोज़ 5 मिनट कॉल';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount प्रति माह';
  }

  @override
  String freeUntilDate(String date) {
    return '$date तक मुफ़्त';
  }

  @override
  String get todaysCalls => 'आज का कॉल समय';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit में से $used मिनट इस्तेमाल';
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
  String get bannerMaxUpsellTitle => 'Premium के साथ आमने-सामने बात करें';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'वीडियो कॉल · रोज़ 15 मिनट · $price प्रति माह';
  }

  @override
  String get bannerAnnualSwitchTitle => 'वार्षिक प्लान पर जाएँ';

  @override
  String get bannerPaymentFailedTitle => 'हम भुगतान नहीं ले सके';

  @override
  String get bannerPaymentFailedSub =>
      'Premium बनाए रखने के लिए स्टोर में भुगतान अपडेट करें';

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
  String noteTrialEnds(String date) {
    return 'आपका ट्रायल $date को समाप्त होगा। उससे पहले स्टोर में रद्द करें तो कुछ भी चार्ज नहीं होगा।';
  }

  @override
  String get noteGrace =>
      'ग्रेस अवधि के दौरान आपके लाभ चलते रहते हैं। रद्द करना ऐप में कभी रोका नहीं जाता।';

  @override
  String get noteHold =>
      'भुगतान होने तक Premium रुका हुआ है। आपके कैरेक्टर और प्रगति सुरक्षित हैं।';

  @override
  String noteEnding(String date) {
    return 'आपका प्लान समाप्त होने वाला है। लाभ $date तक चलेंगे, फिर आप Free पर आ जाएँगे। आप कभी भी फिर से सदस्यता ले सकते हैं।';
  }

  @override
  String get trialExpiredTitle => 'आपका Premium ट्रायल समाप्त हो गया';

  @override
  String get trialExpiredSub => 'अब आप Free पर हैं';

  @override
  String get seePlans => 'प्लान देखें';

  @override
  String get currentPlanTitle => 'वर्तमान प्लान';

  @override
  String get perMonthUnit => 'प्रति माह';

  @override
  String get planTaglineMax => 'अब आप उन्हें देख सकते हैं।';

  @override
  String get planTaglineFree => 'रोज़ 5 मिनट कॉल। बिल्कुल मुफ़्त।';

  @override
  String get bulletProCorrections => 'आपकी मातृभाषा के अनुसार सुधार';

  @override
  String get bulletFreeCall => 'रोज़ 5 मिनट वॉयस कॉल';

  @override
  String get bulletFreeCheck => 'पहली 3 कॉल का पूरा विश्लेषण';

  @override
  String get bulletFreeCharacter => 'शुरुआत के लिए 2 कैरेक्टर';

  @override
  String get ctaTurnOnVideo => 'वीडियो चालू करें';

  @override
  String get noteCallLength =>
      'Premium: रोज़ 15 मिनट — इसके अंदर जितनी बार चाहें कॉल करें।';

  @override
  String get paywallProTitle1 => 'आपका कोरियाई दोस्त';

  @override
  String get paywallProTitle2 => 'जो रात 3 बजे भी जागता है';

  @override
  String get paywallLimitHeadline => 'Premium में रोज़ 15 मिनट कॉल।';

  @override
  String get limitBannerCallTitle => 'आज का कॉल समय खत्म';

  @override
  String get limitBannerCallSub => 'Free में रोज़ 5 मिनट कॉल मिलती है';

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
  String paywallTutorCompare(String price) {
    return 'ट्यूटर के साथ एक घंटे की कीमत \$25 है। Premium के एक महीने की कीमत $price है।';
  }

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
  String get processingTitle => 'आपकी खरीदारी की पुष्टि हो रही है';

  @override
  String get processingSub => 'इसमें आमतौर पर कुछ सेकंड लगते हैं।';

  @override
  String get successProTitle => 'आप Premium पर हैं।';

  @override
  String get successMaxTitle => 'अब आप उन्हें देख सकते हैं।';

  @override
  String get successMaxSub =>
      'वीडियो कॉल चालू हैं। किसी भी कॉल में वीडियो बटन दबाएँ।';

  @override
  String get ctaStartAVideoCall => 'वीडियो कॉल शुरू करें';

  @override
  String get ctaSeeYourSubscription => 'अपनी सदस्यता देखें';

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
  String get ctaKeepMax => 'Premium रखें';

  @override
  String get winbackSkip => 'छोड़ें';

  @override
  String get winbackTitle => 'आपका Premium प्लान समाप्त हो गया';

  @override
  String get winbackSub => 'अब आप Free पर हैं — रोज़ 5 मिनट कॉल।';

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
  String get ovRestoreSuccessTitle => 'Premium वापस आ गया';

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
  String get ovCharacterOfferTitle => 'Premium के लिए तैयार नहीं?';

  @override
  String get ovCharacterOfferBody =>
      'एक कैरेक्टर चुनें और अपना बना लें। एकमुश्त खरीदारी — न सदस्यता, न नवीनीकरण।';

  @override
  String get rowOneCharacter => 'एक कैरेक्टर';

  @override
  String rowFromPrice(String price) {
    return 'हर एक $price';
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
  String get rowProRunsUntil => 'Premium चलेगा';

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
      'सालाना प्लान मासिक भुगतान से सस्ता पड़ता है।';

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
      'रद्द नहीं करेंगे तो Premium चलता रहेगा। आगे यह होगा।';

  @override
  String get rowTrialEnds => 'ट्रायल समाप्त';

  @override
  String get rowFirstCharge => 'पहला चार्ज';

  @override
  String get rowThenMonthly => 'फिर हर महीने';

  @override
  String get ctaCancelInStore => 'स्टोर में रद्द करें';

  @override
  String get ovTrialStartTitle => 'Premium के 7 दिन, मुफ़्त';

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
      'अच्छा फ़ैसला। सालाना भुगतान पर वही Premium कम कीमत में मिलता है।';

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
  String get ovAlreadyTitle => 'आप पहले से Premium पर हैं';

  @override
  String get ovAlreadyBody =>
      'इस स्टोर खाते पर एक सक्रिय प्लान है। खरीदने को कुछ नहीं।';

  @override
  String get ctaSeeMySubscription => 'मेरी सदस्यता देखें';

  @override
  String get subCancelTitle => 'सदस्यता रद्द करें';

  @override
  String subCancelBody(String date) {
    return 'Premium $date तक चलेगा। उसके बाद आप Free पर आ जाएँगे।';
  }

  @override
  String get subWhatYouLose => 'आप क्या खोएँगे';

  @override
  String get benefitScoring => 'अक्षर-दर-अक्षर उच्चारण स्कोरिंग';

  @override
  String get benefitEveryMetric => 'हर मीट्रिक, हर वाक्य';

  @override
  String get subPaymentTitle => 'भुगतान अपडेट करें';

  @override
  String get subPaymentBody =>
      'हम भुगतान नहीं ले सके। ग्रेस अवधि में Premium चलता रहता है।';

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
    return 'Premium $date को समाप्त होगा। ऑटो-रिन्यू फिर चालू करें, कुछ नहीं बदलेगा।';
  }

  @override
  String get subWhatYouKeep => 'आपके पास क्या रहेगा';

  @override
  String get ctaTurnItBackOn => 'फिर चालू करें';

  @override
  String get flTodayTitle => 'आज का कॉल समय खत्म';

  @override
  String get flTodayBody => 'जहाँ छोड़ा था वहीं से जारी रखें — अभी।';

  @override
  String get flCheckTitle => 'आज की जाँच यही थी';

  @override
  String get flCheckBody =>
      'Free में दिन में 1 जाँच मिलती है। Premium में पूरा विश्लेषण मिलता है।';

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
  String get emailLabel => 'ईमेल';

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
  String get subscriptionRow => 'सदस्यता';

  @override
  String get iapSuccessTitle => 'खरीद पूरी हुई';

  @override
  String iapSuccessBody(String name) {
    return '$name अवतार हमेशा के लिए आपका है।\nरसीद की पुष्टि होते ही लागू हो जाएगा।';
  }

  @override
  String get ctaGoHome => 'होम पर जाएँ';

  @override
  String get ctaUseNow => 'अभी इस्तेमाल करें';

  @override
  String get iapFailTitle => 'भुगतान पूरा नहीं हुआ';

  @override
  String get iapFailBody => 'आप फिर से कोशिश कर सकते हैं';

  @override
  String get paywallGuardTitle => 'आप Free इस्तेमाल करते रह सकते हैं';

  @override
  String get paywallGuardBody => 'आपको अब भी रोज़ 5 मिनट कॉल मिलेंगी।';

  @override
  String get ctaMaybeLater => 'शायद बाद में';

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
  String get unlockedWithMax => 'आपके प्लान में शामिल';

  @override
  String get fcEndedTitle => 'आपकी मुफ़्त कॉल ख़त्म हो गई';

  @override
  String get fcEndedBody =>
      'मुफ़्त कॉल 5 मिनट तक चलती है\nलंबी बातचीत के लिए सब्सक्राइब करें';

  @override
  String get ctaSubscribeKeepTalking => 'सब्सक्राइब करें और बात जारी रखें';

  @override
  String get kgTitle => 'आगे बढ़ें?';

  @override
  String get kgBody =>
      'कॉल छोटे-छोटे हिस्सों में चलती है।\nहर बार हम फिर से पूछेंगे।';

  @override
  String get pcEndedTitleToday => 'आज की कॉल यहीं खत्म करते हैं।';

  @override
  String get pcEndedBodyToday => 'जो बात की उसे दोहराइए, और कल फिर कॉल कीजिए!';

  @override
  String get pcEndedTitle => 'यह कॉल यहीं खत्म करते हैं।';

  @override
  String get pcEndedBody => 'जो बात की उसे दोहराइए, और फिर कॉल कीजिए!';

  @override
  String get ctaKeepTalking => 'बात जारी रखें';

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
  String get callExitSubtitle =>
      'अभी खत्म करने पर भी बात किया गया समय आज में गिना जाएगा';

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

  @override
  String get callFreeEndedTitle => 'आपकी मुफ़्त कॉल समाप्त हो गई';

  @override
  String get callFreeEndedCta => 'सब्सक्राइब करें और बात जारी रखें';

  @override
  String get callKeepGoingTitle => 'जारी रखें?';

  @override
  String get callKeepGoingSubtitle =>
      'कॉल 5 मिनट के हिस्सों में चलती है। हर बार हम फिर पूछेंगे।';

  @override
  String get articulationSelectedWord => 'चुना गया शब्द';

  @override
  String get articulationYouSaid => 'आपका उच्चारण';

  @override
  String get articulationTargetSound => 'लक्ष्य';

  @override
  String get reportEntry => 'रिपोर्ट करें';

  @override
  String get reportTitle => 'रिपोर्ट';

  @override
  String get reportPrompt => 'क्या समस्या हुई?';

  @override
  String get reportGuide =>
      'बताइए कि AI किरदार की किस बात से आपको असहजता हुई। हम हर रिपोर्ट की समीक्षा करते हैं।';

  @override
  String get reportReasonSexual => 'यौन सामग्री';

  @override
  String get reportReasonHate => 'नफ़रत या भेदभाव';

  @override
  String get reportReasonViolence => 'हिंसक या धमकी भरी सामग्री';

  @override
  String get reportReasonSelfHarm => 'आत्म-नुकसान को बढ़ावा';

  @override
  String get reportReasonMisinfo => 'ग़लत जानकारी';

  @override
  String get reportReasonOther => 'कुछ और';

  @override
  String get reportDetailHint => 'जो हुआ उसे लिखें (वैकल्पिक)';

  @override
  String get reportSubmit => 'रिपोर्ट भेजें';

  @override
  String get reportDoneTitle => 'आपकी रिपोर्ट मिल गई';

  @override
  String get reportDoneBody =>
      'हम इसकी समीक्षा करेंगे और ज़रूरत पड़ने पर कार्रवाई करेंगे। BeaverTalk को सुरक्षित रखने में मदद के लिए धन्यवाद।';

  @override
  String get reportFailed => 'रिपोर्ट नहीं भेजी जा सकी। दोबारा कोशिश करें।';

  @override
  String get hwTitle => 'होमवर्क';

  @override
  String get hwJoinCodeTitle => 'अपनी क्लास का कोड डालें';

  @override
  String get hwJoinCodeSubtitle => 'यह आपके शिक्षक का दिया 6 अंकों का कोड है';

  @override
  String get hwJoinCodeLabel => 'क्लास कोड';

  @override
  String get hwJoinCodeHelp => 'कोड में छोटे-बड़े अक्षर मायने नहीं रखते';

  @override
  String get hwJoinConfirmTitle => 'क्या यही सही क्लास है?';

  @override
  String get hwJoinConfirmSubtitle => 'अगर नहीं, तो कोड दोबारा जाँचें';

  @override
  String get hwJoinFieldInstitution => 'संस्थान';

  @override
  String get hwJoinFieldTeacher => 'शिक्षक';

  @override
  String get hwJoinFieldLearners => 'शिक्षार्थी';

  @override
  String get hwJoinFieldTerm => 'अवधि';

  @override
  String get hwJoinConfirmNote =>
      'क्लास का नाम वैसा ही दिखता है जैसा शिक्षक ने लिखा। हम इसका अनुवाद नहीं करते।';

  @override
  String get hwJoinConfirmYes => 'हाँ, यही है';

  @override
  String get hwJoinConfirmRetry => 'कोड फिर से डालें';

  @override
  String get hwJoinProfileTitle => 'क्लास में आप कौन-सा नाम इस्तेमाल करेंगे?';

  @override
  String get hwJoinProfileSubtitle => 'शिक्षक इसे क्लास सूची से मिलाते हैं';

  @override
  String get hwJoinNameLabel => 'नाम';

  @override
  String get hwJoinNameHelp => 'यह ऐप के नाम से अलग हो सकता है';

  @override
  String get hwJoinStudentNoLabel => 'छात्र संख्या (वैकल्पिक)';

  @override
  String get hwJoinStudentNoHelp =>
      'शिक्षक इसे क्लास सूची मिलाने के लिए इस्तेमाल करते हैं';

  @override
  String get hwJoinConsentTitle => 'शिक्षक क्या देख सकते हैं';

  @override
  String get hwJoinConsentSubtitle =>
      'क्लास में शामिल होने के लिए सहमति ज़रूरी है';

  @override
  String get hwJoinConsentSharedHeading => 'शिक्षक के साथ साझा';

  @override
  String get hwJoinConsentShared1 => 'क्लास का नाम और छात्र संख्या';

  @override
  String get hwJoinConsentShared2 => 'आपने होमवर्क किया या नहीं';

  @override
  String get hwJoinConsentShared3 => 'पास और छूटे हुए वाक्य';

  @override
  String get hwJoinConsentShared4 => 'होमवर्क कॉल की अवधि और सारांश';

  @override
  String get hwJoinConsentNotSharedHeading => 'साझा नहीं';

  @override
  String get hwJoinConsentNotShared1 => 'ईमेल और फ़ोन नंबर';

  @override
  String get hwJoinConsentNotShared2 => 'ऐप का नाम, प्रोफ़ाइल और किरदार';

  @override
  String get hwJoinConsentNotShared3 => 'राष्ट्रीयता और मातृभाषा';

  @override
  String get hwJoinConsentNotShared4 => 'क्लास के बाहर की कॉल और पढ़ाई';

  @override
  String get hwJoinConsentNotShared5 => 'सदस्यता और भुगतान की जानकारी';

  @override
  String get hwJoinConsentAgree => 'मैं उपरोक्त से सहमत हूँ';

  @override
  String get hwJoinConsentCta => 'सहमत होकर शामिल हों';

  @override
  String hwJoinDoneTitle(String className) {
    return 'आप $className में शामिल हो गए';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count होमवर्क आपका इंतज़ार कर रहे हैं';
  }

  @override
  String get hwJoinDoneNoAssignment => 'अभी कोई होमवर्क नहीं';

  @override
  String get hwJoinDoneNextDue => 'अगली समय-सीमा';

  @override
  String get hwJoinDoneRosterName => 'क्लास में आपका नाम';

  @override
  String get hwJoinDoneCta => 'होमवर्क देखें';

  @override
  String get hwJoinErrorNotFound => 'वह कोड नहीं मिला';

  @override
  String get hwJoinErrorNotFoundBody => 'कृपया छह अंक दोबारा जाँचें।';

  @override
  String get hwJoinErrorExpired => 'उस कोड की अवधि समाप्त हो गई';

  @override
  String get hwJoinErrorExpiredBody => 'अपने शिक्षक से नया कोड माँगें।';

  @override
  String get hwJoinErrorFull => 'क्लास भर चुकी है';

  @override
  String get hwJoinErrorFullBody => 'कृपया अपने शिक्षक को बताएँ।';

  @override
  String get hwJoinFailed => 'शामिल नहीं हो सके। थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get hwSectionInProgress => 'चल रहा है';

  @override
  String get hwSectionUpcoming => 'आने वाला';

  @override
  String get hwSectionDone => 'पूरा';

  @override
  String get hwLeaveClassLink => 'क्लास छोड़ें';

  @override
  String get hwListEmptyTitle => 'अभी कोई होमवर्क नहीं';

  @override
  String get hwListEmptyBody => 'जब शिक्षक देंगे तो यहाँ दिखेगा।';

  @override
  String get hwListFailed => 'आपका होमवर्क लोड नहीं हो सका।';

  @override
  String get hwRetry => 'फिर कोशिश करें';

  @override
  String get hwBadgeDone => 'पूरा';

  @override
  String get hwBadgeOverdue => 'जमा नहीं किया';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'जमा नहीं किया, $days दिन देर';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'आज की समय-सीमा';

  @override
  String get hwActivitySpeaking => 'बोलना';

  @override
  String get hwActivityConversation => 'बातचीत';

  @override
  String get hwActivityWorkbook => 'अभ्यास पुस्तिका';

  @override
  String hwChapterLabel(String chapter) {
    return 'अध्याय $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'अपना उच्चारण स्कोर जाँचें';

  @override
  String get hwTaskConversationDesc =>
      'जो सीखा उसे असली बातचीत में इस्तेमाल करें';

  @override
  String get hwConversationOnce =>
      'हर होमवर्क में बातचीत एक ही बार हो सकती है।';

  @override
  String get hwTaskWorkbookDesc => 'अभ्यास पुस्तिका में लिखकर अभ्यास करें';

  @override
  String get hwCtaStudy => 'शुरू करें';

  @override
  String get hwCtaResult => 'नतीजा देखें';

  @override
  String get hwCtaDownload => 'डाउनलोड';

  @override
  String get hwSpeakingNoScore => 'आपने बोलने का काम अभी नहीं किया';

  @override
  String get hwWorkbookUnavailable =>
      'अभ्यास पुस्तिका की फ़ाइल अभी उपलब्ध नहीं है।';

  @override
  String get hwDetailClosed =>
      'यह होमवर्क बंद हो चुका है। अब जमा नहीं कर सकते।';

  @override
  String get hwLeaveTitle => 'क्लास छोड़ें?';

  @override
  String get hwLeaveBody =>
      'आपके शिक्षक अब आपके होमवर्क के नतीजे नहीं देख पाएँगे।';

  @override
  String get hwLeaveConfirm => 'छोड़ें';

  @override
  String get hwLeaveCancel => 'रुकें';

  @override
  String get hwLeaveFailed => 'क्लास नहीं छोड़ सके।';

  @override
  String get hwMyClass => 'मेरी क्लास';

  @override
  String get hwClassEmptyTitle => 'आप किसी क्लास में शामिल नहीं हुए';

  @override
  String get hwClassEmptySubtitle => 'शिक्षक का दिया कोड डालें';

  @override
  String get hwClassEmptyCta => 'क्लास कोड डालें';

  @override
  String get hwClassContinueCta => 'जारी रखें';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count होमवर्क कल जमा करने हैं';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'आपके $count होमवर्क जमा नहीं हुए';
  }

  @override
  String get hwSpeakingUnavailable =>
      'इस होमवर्क के वाक्य अभी उपलब्ध नहीं हैं।';

  @override
  String get hwBadgeClosed => 'बंद';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total में से $passed वाक्य पास';
  }

  @override
  String get challengeFirstWord => 'पहला शब्द';

  @override
  String get challengeSeeAnalysis => 'नतीजे देखें';

  @override
  String get challengePaused => 'रुका हुआ';

  @override
  String get challengePausedNote => 'टाइमर और रिकॉर्डिंग दोनों रुक गए।';

  @override
  String get challengeTimeLeft => 'बचा समय';

  @override
  String get challengeScoreLabel => 'स्कोर';

  @override
  String get challengeResume => 'जारी रखें';

  @override
  String get challengeBlockedTitle => 'कैमरा इस्तेमाल नहीं हो सकता';

  @override
  String get challengeBlockedNote =>
      'सेटिंग्स में कैमरा और माइक की अनुमति चालू करें।';

  @override
  String get challengeGoBack => 'वापस जाएँ';

  @override
  String get challengeOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get saveDone => 'गैलरी में सेव हो गया';

  @override
  String get saveFailed => 'सेव नहीं हो सका';

  @override
  String get saveDeniedNote => 'फ़ोटो की अनुमति चाहिए';

  @override
  String get callIncomingCallerFallback => 'बीवर ट्यूटर';

  @override
  String get callIncomingHandle => 'कोरियाई कॉल';

  @override
  String get callMissedTitle => 'छूटी हुई कॉल';

  @override
  String get callMissedChannelDescription =>
      'बीवर की छूटी हुई कॉल के बारे में बताता है।';

  @override
  String callMissedBody(String name) {
    return '$name ने आपको कॉल किया था';
  }

  @override
  String get callBeaverFallbackName => 'बीवर';

  @override
  String get callNotifPermissionRationale =>
      'कॉल पाने के लिए सूचना की अनुमति ज़रूरी है।';

  @override
  String get callNotifPermissionRequired => 'सेटिंग में सूचनाओं की अनुमति दें।';

  @override
  String get callHintLockedTitle => 'अभ्यास मोड में संकेत उपलब्ध नहीं हैं';

  @override
  String get wsTitle => 'कठिन ध्वनियाँ';

  @override
  String get wsToList => 'सूची पर वापस';

  @override
  String get wsNext => 'आगे';

  @override
  String get wsRetry => 'फिर कोशिश करें';

  @override
  String get wsDone => 'पूरा हुआ';

  @override
  String get wsContinue => 'जारी रखें';

  @override
  String get wsQuit => 'बाहर निकलें';

  @override
  String get wsRetryLater => 'कृपया थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get wsMissingTitle => 'वह ध्वनि नहीं मिली';

  @override
  String get wsMissingBody => 'कृपया सूची से इसे फिर चुनें।';

  @override
  String get wsListLoadFailed => 'सूची लोड नहीं हो सकी';

  @override
  String get wsLessonLoadFailed => 'पाठ लोड नहीं हो सका';

  @override
  String get wsNationalTitle => 'आपके उच्चारण के लिए कठिन ध्वनियाँ';

  @override
  String get wsNationalPending => 'उच्चारण विश्लेषण पूरा होने पर यह भर जाएगा';

  @override
  String get wsNationalPicked => 'आपके उच्चारण विश्लेषण से चुनी गई';

  @override
  String get wsNationalEmptyBody =>
      'कुछ और कॉल करें, फिर हम आपका उच्चारण विश्लेषण करेंगे।';

  @override
  String get wsMineTitle => 'मेरी कठिन ध्वनियाँ';

  @override
  String get wsMineSubtitle => 'हाल में जिनमें सबसे कम स्कोर मिला';

  @override
  String get wsMineEmptyBody =>
      'कॉल करें और दोहराएँ, आपकी कठिन ध्वनियाँ जुड़ती जाएँगी।';

  @override
  String get wsNoDataYet => 'अभी कोई डेटा नहीं';

  @override
  String get wsGoToCall => 'कॉल शुरू करें';

  @override
  String get wsRule => 'नियम';

  @override
  String get wsRecommended => 'सुझाई गई';

  @override
  String get wsNotMeasured => 'मापा नहीं गया';

  @override
  String get wsStepUnderstand => 'समझें';

  @override
  String get wsStepWords => 'शब्द';

  @override
  String get wsStepSentence => 'वाक्य';

  @override
  String get wsStepTest => 'टेस्ट';

  @override
  String get wsQuitTitle => 'अभ्यास रोक दें?';

  @override
  String get wsQuitBody => 'अभी निकलने पर यह अभ्यास सहेजा नहीं जाएगा।';

  @override
  String get wsHowToSound => 'ध्वनि निकालने का तरीका';

  @override
  String get wsPracticeWords => 'शब्द अभ्यास करें';

  @override
  String get wsPracticeSentence => 'वाक्य अभ्यास करें';

  @override
  String get wsPracticeAgain => 'एक बार और';

  @override
  String get wsStartTest => 'अंतिम टेस्ट दें';

  @override
  String get wsThisSentence => 'यह वाक्य';

  @override
  String get wsNoScoreNote => 'इस चरण में स्कोर नहीं मिलता। बस साथ बोलें।';

  @override
  String get wsListen => 'ध्यान से सुनें';

  @override
  String get wsSayNow => 'अब आप बोलें';

  @override
  String get wsPracticeDone => 'अभ्यास पूरा हुआ';

  @override
  String get wsPaused => 'रुका हुआ';

  @override
  String get wsAudioFailed => 'ऑडियो लोड नहीं हो सका। लिखा हुआ पढ़कर बोलें।';

  @override
  String get wsReadAloud => 'नीचे दिया वाक्य ज़ोर से पढ़ें';

  @override
  String get wsTapToStart => 'शुरू करने के लिए टैप करें';

  @override
  String get wsTapWhenDone => 'पूरा होने पर टैप करें';

  @override
  String get wsScoring => 'स्कोर किया जा रहा है';

  @override
  String get wsMicFailed => 'माइक्रोफ़ोन नहीं खुल सका।';

  @override
  String get wsMicPermissionBody =>
      'इस टेस्ट में ज़ोर से पढ़ना होता है, इसलिए माइक्रोफ़ोन चाहिए। सेटिंग्स में माइक्रोफ़ोन की अनुमति चालू करें।';

  @override
  String get wsNoSound => 'हमें कुछ सुनाई नहीं दिया। फिर बोलें?';

  @override
  String get wsScoreFailed => 'स्कोरिंग नहीं हो सकी। कृपया फिर कोशिश करें।';

  @override
  String get wsSomethingWrong => 'कुछ गड़बड़ हो गई।';

  @override
  String get wsLearnDone => 'पाठ पूरा हुआ';

  @override
  String get wsRetest => 'फिर टेस्ट करें';

  @override
  String get wsFirstMeasure => 'पहली माप';

  @override
  String get wsFinalTest => 'अंतिम टेस्ट';

  @override
  String wsPoints(int score) {
    return '$score अंक';
  }

  @override
  String wsBeforePoints(int score) {
    return 'पहले $score अंक';
  }

  @override
  String wsGoalPoints(int score) {
    return 'लक्ष्य $score अंक';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'लक्ष्य · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country उच्चारण';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count शब्द दोहराए';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count वाक्यांश दोहराए';
  }

  @override
  String get wsStartRecommended => 'सुझाई गई ध्वनि से शुरू करें';

  @override
  String wsStartRecommendedWith(String label) {
    return '$label से शुरू करें';
  }

  @override
  String get wsPointsUnit => 'अंक';

  @override
  String get wsEnterFromMypage => 'कठिन ध्वनि अभ्यास करें';

  @override
  String wsGoalOnly(int score) {
    return 'लक्ष्य $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label ध्वनि';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc। कॉल में यह ध्वनि आए तो यही आकार याद करें।';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country के वक्ताओं से अक्सर गलत होने वाली ध्वनियाँ';
  }
}
