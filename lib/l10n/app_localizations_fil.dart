// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Natapos ang tawag $duration';
  }

  @override
  String get callRatingPrompt => 'Kumusta ang tawag mo?';

  @override
  String get ratingBad => 'Hindi maganda';

  @override
  String get ratingOkay => 'Okay lang';

  @override
  String get ratingGood => 'Maganda';

  @override
  String get goHome => 'Home';

  @override
  String get viewAnalysis => 'Tingnan ang Analysis';

  @override
  String get loadingShort => 'Naglo-load…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Hindi na-submit ang rating: $message';
  }

  @override
  String get callInfoNotFound =>
      'Hindi nahanap ang impormasyon ng tawag, nilalaktawan ang analysis.';

  @override
  String get tabRecords => 'Mga Record';

  @override
  String get tabArchive => 'Archive';

  @override
  String get callHistory => 'Kasaysayan ng Tawag';

  @override
  String get conversationRecord => 'Talaan ng usapan';

  @override
  String get noCallRecords => 'Wala pang record ng tawag';

  @override
  String get noCallRecordsBody =>
      'Kapag natapos mo na ang una mong tawag sa AI,\nlalabas dito ang iyong mga record.';

  @override
  String get startCall => 'Simulan ang Tawag';

  @override
  String get recordsLoadError => 'Hindi ma-load ang mga record';

  @override
  String get tryAgainLater => 'Pakisubukan muli mamaya.';

  @override
  String get retry => 'Subukan Muli';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds sek';
  }

  @override
  String get scheduleManagement => 'Schedule';

  @override
  String get alarms => 'Mga Alarma';

  @override
  String get addSchedule => 'Magdagdag ng Schedule';

  @override
  String get editSchedule => 'I-edit ang Schedule';

  @override
  String get somethingWentWrong => 'May naganap na error';

  @override
  String get alarmsLoadError => 'Hindi ma-load ang mga alarma';

  @override
  String get charactersLoadError => 'Hindi ma-load ang mga karakter';

  @override
  String get noCharacters => 'Walang available na karakter';

  @override
  String get close => 'Isara';

  @override
  String get repeat => 'Ulitin';

  @override
  String get callPartner => 'Karakter';

  @override
  String get quickStart => 'Mabilis na simula';

  @override
  String get presetMorning => 'Rutin sa umaga';

  @override
  String get presetMorningSub => 'Karaniwang araw 8:00';

  @override
  String get presetEvening => 'Pagtatapos ng gabi';

  @override
  String get presetEveningSub => 'Araw-araw 21:00';

  @override
  String get presetCustom => 'Custom';

  @override
  String get presetCustomSub => 'Ikaw ang bahala';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× kada linggo · $monthly tawag kada buwan';
  }

  @override
  String get alarmSummaryNone => 'Pumili ng kahit isang araw';

  @override
  String get partnerInUse => 'Ginagamit';

  @override
  String get partnerOwned => 'Pag-aari';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'I-save';

  @override
  String get conversation => 'Usapan';

  @override
  String get review => 'Review';

  @override
  String get pronunciationChallenge => 'Hamon sa Bigkas';

  @override
  String get newExpressions => 'Mga Bagong Ekspresyon';

  @override
  String get analysisResult => 'Resulta ng Analysis';

  @override
  String get noNewExpressions =>
      'Walang bagong ekspresyon mula sa usapang ito.';

  @override
  String get practice => 'Practice';

  @override
  String recentScore(int score) {
    return 'Kamakailang score $score%';
  }

  @override
  String callSequence(int count) {
    return 'Ika-$count tawag';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Isang salita mula kay $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Iniwan ni $name pagkatapos ng tawag';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Bagong ekspresyon $count';
  }

  @override
  String get analysisLoadError => 'Hindi ma-load ang resulta ng analysis.';

  @override
  String get standardAudioNotReady =>
      'Hindi pa handa ang audio ng standard na bigkas.';

  @override
  String get standardAudioPlayError =>
      'Hindi ma-play ang audio ng standard na bigkas.';

  @override
  String get selectACountry => 'Pumili ng bansa';

  @override
  String get selectYourLanguage => 'Piliin ang iyong wika';

  @override
  String get confirm => 'Kumpirmahin';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get selectTime => 'Pumili ng oras';

  @override
  String get getStarted => 'Magsimula';

  @override
  String get permissionTitle =>
      'Payagan ang mga permiso\npara sa maayos na karanasan';

  @override
  String get permissionSubtitle =>
      'Kailangan ang mga permisong ito para magamit ang serbisyo.';

  @override
  String get permissionMicTitle => 'Mikropono (kailangan)';

  @override
  String get permissionMicDesc => 'Kailangan para makausap ang AI sa Ingles.';

  @override
  String get permissionNotifTitle => 'Mga Notification (opsyonal)';

  @override
  String get permissionNotifDesc =>
      'Magpapadala kami ng mga paalala sa pag-aaral at schedule ng tawag.';

  @override
  String get micPermissionNeededTitle => 'Kailangan ang access sa mikropono';

  @override
  String get micPermissionNeededBody =>
      'Para makausap ang AI, kailangan mong payagan ang access sa mikropono. Paki-enable ito sa Settings.';

  @override
  String get openSettings => 'Buksan ang Settings';

  @override
  String get connectionFailedTitle => 'Nabigo ang koneksyon';

  @override
  String get connectionFailedBody =>
      'Suriin ang iyong koneksyon sa network\nat subukan muli.';

  @override
  String get checkout => 'Checkout';

  @override
  String get pay => 'Magbayad';

  @override
  String get orderSummary => 'Buod ng Order';

  @override
  String get paymentMethod => 'Paraan ng Pagbabayad';

  @override
  String get payMethodCard => 'Credit / Debit Card';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Nakakainis na Beaver Avatar';

  @override
  String get productTrait => 'Premium na karakter · Sa\'yo magpakailanman';

  @override
  String get amountItemPrice => 'Presyo ng item';

  @override
  String get amountDiscount => 'Diskwento';

  @override
  String get amountTotal => 'Kabuuan';

  @override
  String get paymentCompleteTitle => 'Kumpleto ang bayad';

  @override
  String get paymentCompleteBody =>
      'Naidagdag na ang avatar sa iyong koleksyon.';

  @override
  String get viewCollection => 'Tingnan ang Koleksyon';

  @override
  String get receiptItem => 'Item';

  @override
  String get receiptAmount => 'Halaga';

  @override
  String get receiptMethod => 'Paraan ng pagbabayad';

  @override
  String get receiptDate => 'Petsa';

  @override
  String get paymentFailedTitle => 'Nabigo ang pagbabayad';

  @override
  String get paymentFailedBody =>
      'Hindi maproseso ang iyong bayad.\nPakisubukan muli.';

  @override
  String get freeCallEndingTitle => 'Matatapos na ang iyong libreng tawag';

  @override
  String get freeCallEndingBody =>
      'Mag-subscribe para mas matagal na makausap si Beaver.';

  @override
  String get subscribe => 'Mag-subscribe';

  @override
  String get endCall => 'Tapusin ang Tawag';

  @override
  String get callEnded => 'Natapos na ang tawag.';

  @override
  String get connecting => 'Kumokonekta…';

  @override
  String get connectingHint =>
      'Karaniwang tumatagal ito ng mas mababa sa 5 segundo';

  @override
  String get callConnectFailed => 'Hindi makonekta ang tawag.';

  @override
  String get saveSentenceFailed => 'Hindi ma-save ang pangungusap.';

  @override
  String get recordStartFailed => 'Hindi masimulan ang pag-record.';

  @override
  String get recordTooShort =>
      'Masyadong maikli ang recording na iyon. Pakisubukan muli.';

  @override
  String get gradingFailed => 'Nabigo ang pag-score. Pakisubukan muli.';

  @override
  String get listenStandard => 'Pakinggan ang standard na bigkas';

  @override
  String get saveSentence => 'I-save ang pangungusap';

  @override
  String get unsaveSentence => 'Alisin ang na-save na pangungusap';

  @override
  String get scoringPronunciation => 'Sino-score ang iyong bigkas…';

  @override
  String get analyzingByWord => 'Sinusuri ang bigkas mo salita bawat salita';

  @override
  String get analyzingTakingLonger => 'Medyo mas matagal ito';

  @override
  String get scanConnectionLost => 'Nawalan ng koneksyon';

  @override
  String get noRecordingToPlay => 'Walang recording na ipe-play.';

  @override
  String get myRecordingPlayError => 'Hindi ma-play ang iyong recording.';

  @override
  String get next => 'Susunod';

  @override
  String get endLearning => 'Tapusin ang Session';

  @override
  String get navCalendar => 'Kalendaryo';

  @override
  String get navCall => 'Tawag';

  @override
  String get navStats => 'Stats';

  @override
  String get myPage => 'Aking Page';

  @override
  String get languageSaveFailed => 'Hindi ma-save ang iyong wika.';

  @override
  String get accountDeleteFailed => 'Hindi ma-delete ang iyong account.';

  @override
  String get changeAvatar => 'Baguhin ang Avatar';

  @override
  String get avatarIntro =>
      'Naiiba ang boses at antas ng hirap depende sa kausap.\nAng ilang kausap ay maaaring mangailangan ng bayad.';

  @override
  String myPartnersOwned(int count) {
    return 'Aking mga Kausap · $count pag-aari';
  }

  @override
  String get limitedDiscount => 'Limitadong-oras na diskwento';

  @override
  String get available => 'Available';

  @override
  String get inUse => 'Ginagamit';

  @override
  String get owned => 'Pag-aari';

  @override
  String get noCharactersToShow => 'Walang karakter na ipapakita';

  @override
  String get buy => 'Bilhin';

  @override
  String get noSavedSentences =>
      'Wala ka pang na-save na pangungusap.\nMag-bookmark ng mga pangungusap mula sa iyong mga record ng usapan.';

  @override
  String get noAlarms => 'Wala pang alarma';

  @override
  String get noAlarmsBody =>
      'Magdagdag ng paalala sa pag-aaral\npara makabuo ng regular na gawi.';

  @override
  String get subscriptionManage => 'Pamahalaan ang Subscription';

  @override
  String get changePlan => 'Baguhin ang Plan';

  @override
  String get cancelSubscription => 'Kanselahin ang Subscription';

  @override
  String get benefitsInUse => 'Iyong mga benepisyo';

  @override
  String get paymentInfo => 'Impormasyon sa pagbabayad';

  @override
  String get nextBillingDate => 'Susunod na petsa ng bayad';

  @override
  String get lostBenefitsTitle =>
      'Mga benepisyong mawawala kapag nag-cancel ka';

  @override
  String get viewBillingHistory => 'Tingnan ang Kasaysayan ng Bayad';

  @override
  String get keepUsingPro => 'Ipagpatuloy ang Pro';

  @override
  String get proMembership => 'Pro Membership';

  @override
  String get pricePerMonth => '\$12.9 / buwan';

  @override
  String get benefitUnlimitedCalls => 'Walang limitasyong tawag';

  @override
  String get benefitDetailedAnalysis =>
      'Detalyadong analysis ng bigkas at grammar';

  @override
  String get benefitAllCharacters => 'Access sa lahat ng karakter';

  @override
  String get benefitNoAds => 'Walang ads';

  @override
  String get playSampleVoice => 'I-play ang sample na boses';

  @override
  String get useThisAvatar => 'Gamitin Ito';

  @override
  String get challengeTitle => 'Hamon sa Bigkas';

  @override
  String get challengeIntro =>
      'Bigkasin nang tama sa Korean ang bawat card sa zone para malinis ito.\nWalang mic? Puwede ka ring maglaro sa pamamagitan ng pag-tap sa screen.';

  @override
  String get challengeStart => 'Simulan ang Camera at Mic';

  @override
  String get challengePermissionNote =>
      'Kailangan ang access sa front camera at mic (opsyonal).';

  @override
  String get challengeLoadingTitle => 'Naglo-load…';

  @override
  String get challengeLoadingNote =>
      'Dina-download ang Korean speech model (~82MB) sa unang pagpapatakbo.\nPakihintay lang.';

  @override
  String get challengeSttFallback =>
      'Hindi available ang speech recognition, kaya naglaro ka gamit ang tap input.';

  @override
  String get reasonTravelTitle => 'Pagsasalita habang naglalakbay';

  @override
  String get reasonTravelDesc => 'Makipag-usap nang may tiwala sa mga lokal';

  @override
  String get reasonCareerTitle => 'Trabaho at karera';

  @override
  String get reasonCareerDesc => 'Usapang pangnegosyo';

  @override
  String get reasonExamTitle => 'Paghahanda sa eksam';

  @override
  String get reasonExamDesc => 'Maghanda para sa speaking test';

  @override
  String get reasonDailyTitle => 'Pang-araw-araw na usapan';

  @override
  String get reasonDailyDesc => 'Mga ekspresyong ginagamit araw-araw';

  @override
  String get reasonFriendsTitle => 'Paggawa ng dayuhang kaibigan';

  @override
  String get reasonFriendsDesc => 'Natural na usapan';

  @override
  String get reasonBrainTitle => 'Pagpapasigla ng utak';

  @override
  String get reasonBrainDesc => 'Pahusayin ang memorya at focus';

  @override
  String get challengeRecordToggle => 'I-record ang laro';

  @override
  String get challengeRecordHint =>
      'Nagse-save ng video ng iyong laro para ibahagi (walang tunog).';

  @override
  String get settingsSection => 'Settings';

  @override
  String get paymentSection => 'Pagbabayad';

  @override
  String get supportSection => 'Suporta';

  @override
  String get userLanguage => 'Wika ng User';

  @override
  String get learningLanguage => 'Wikang Pinag-aaralan';

  @override
  String get learningLanguageKorean => 'Korean';

  @override
  String get notificationLabel => 'Notification';

  @override
  String get currentPlan => 'Kasalukuyang Plan';

  @override
  String get paymentHistory => 'Kasaysayan ng Bayad';

  @override
  String get contactUs => 'Makipag-ugnayan sa Amin';

  @override
  String get termsOfService => 'Mga tuntunin ng serbisyo';

  @override
  String get privacyPolicy => 'Patakaran sa privacy';

  @override
  String get logOut => 'Mag-log out';

  @override
  String get deleteAccount => 'Burahin ang account';

  @override
  String get deleteAccountTitle => 'Burahin ang account?';

  @override
  String get deleteAccountBody =>
      'Permanenteng mabubura nito ang iyong account at data, at hindi na ito maibabalik.';

  @override
  String get delete => 'Burahin';

  @override
  String get share => 'Ibahagi';

  @override
  String get accentSoundsLike => 'Ang tunog ng iyong Korean accent';

  @override
  String get hintLabel => 'Hint';

  @override
  String get nextHint => 'Susunod na hint';

  @override
  String get translateLabel => 'Isalin';

  @override
  String get startRecording => 'Simulan ang pag-record';

  @override
  String get stopRecording => 'Itigil ang pag-record';

  @override
  String get back => 'Bumalik';

  @override
  String get onboardingNameTitle => 'Ano ang itatawag namin sa\'yo?';

  @override
  String get onboardingNameSubtitle =>
      'Aalalahanin ng iyong AI tutor ang iyong pangalan.';

  @override
  String get nameLabel => 'Iyong pangalan';

  @override
  String get nameHint => 'Ilagay ang iyong pangalan';

  @override
  String get nameHelper =>
      'Hindi ito kailangang ang tunay mong pangalan — puwede ring palayaw.';

  @override
  String get continueLabel => 'Magpatuloy';

  @override
  String get onboardingDoneTitle => 'Hinihintay ni Beaver ang tawag mo';

  @override
  String get onboardingDoneSubtitle => 'Magsimula ng tawag ngayon din';

  @override
  String get home => 'Home';

  @override
  String get callNow => 'Tumawag ngayon';

  @override
  String get pronunciation => 'Bigkas';

  @override
  String get fluency => 'Katatasan';

  @override
  String get rhythm => 'Ritmo';

  @override
  String get analysisTimeout =>
      'Mas matagal ito kaysa inaasahan. Pakisubukan muli sandali.';

  @override
  String get analysisFailed =>
      'Hindi namin na-analyze ang usapan. Pakisubukan muli.';

  @override
  String get analyzingConversation => 'Sinusuri ang iyong usapan…';

  @override
  String get analyzingSubtitle => 'Sandali lang ito tatagal';

  @override
  String get tryAgain => 'Subukan muli';

  @override
  String get nativeLabel => 'Native';

  @override
  String get meLabel => 'Ako';

  @override
  String get pronunciationPlayError => 'Hindi ma-play ang audio ng bigkas.';

  @override
  String get savedExpressionsLoadError =>
      'Hindi ma-load ang iyong mga na-save na ekspresyon.';

  @override
  String get mySavedExpressions => 'Aking mga Na-save na Ekspresyon';

  @override
  String get avatarTraits => 'Mainit · Kalmado · Malambot';

  @override
  String get priceFree => 'Libre';

  @override
  String get loginGoogleTokenError => 'Hindi makuha ang Google sign-in token.';

  @override
  String get loginGoogleSignInFailed => 'Nabigo ang Google sign-in.';

  @override
  String get loginAppleSignInFailed => 'Nabigo ang Apple sign-in.';

  @override
  String get loginKakaoSignInFailed => 'Nabigo ang Kakao sign-in.';

  @override
  String get loginContinueWithKakao => 'Magpatuloy gamit ang Kakao';

  @override
  String get loginContinueWithGoogle => 'Magpatuloy gamit ang Google';

  @override
  String get loginContinueWithApple => 'Magpatuloy gamit ang Apple';

  @override
  String get loginContinueWithEmail => 'Magpatuloy gamit ang email';

  @override
  String get loginOrDivider => 'o';

  @override
  String get loginNoAccount => 'Wala ka pang account?';

  @override
  String get signUp => 'Mag-sign up';

  @override
  String get loginTermsNoticePrefix =>
      'Sa pagpapatuloy, sumasang-ayon ka sa aming ';

  @override
  String get loginTermsNoticeAnd => ' at ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Mag-log in';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Ilagay ang iyong email';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get passwordHint => 'Ilagay ang iyong password';

  @override
  String get loginRememberMe => 'Tandaan ako';

  @override
  String get loginForgotPassword => 'Nakalimutan ang password?';

  @override
  String get loginLoggingIn => 'Nagla-log in...';

  @override
  String get passwordLengthError => 'Dapat 8–16 na character ang password.';

  @override
  String get passwordsDoNotMatch => 'Hindi magkatugma ang mga password.';

  @override
  String get signupCheckInput => 'Pakisuri ang iyong input.';

  @override
  String get fieldConfirmPasswordLabel => 'Kumpirmahin ang password';

  @override
  String get confirmPasswordHint => 'Ilagay muli ang iyong password';

  @override
  String get signupSigningUp => 'Nagsa-sign up...';

  @override
  String get signupHaveAccount => 'May account ka na?';

  @override
  String get passwordMethodEmailRequired => 'Ilagay ang iyong email';

  @override
  String get passwordResetTitle => 'I-reset ang password';

  @override
  String get passwordMethodDescription =>
      'Ilagay ang email address kung saan mo gustong matanggap ang code para sa pag-reset ng password.';

  @override
  String get emailAddressHint => 'Email address';

  @override
  String get passwordMethodSending => 'Ipinapadala...';

  @override
  String get passwordMethodSendEmail => 'Ipadala ang email';

  @override
  String get passwordCodeTitle => 'Ilagay ang code';

  @override
  String get passwordCodeDescription =>
      'Nagpadala kami ng recovery code sa iyong email. Ilagay ito para magpatuloy.';

  @override
  String get passwordCodeNoCode => 'Hindi natanggap ang code?';

  @override
  String get passwordCodeResend => 'Ipadala ulit ang code';

  @override
  String get passwordCodeVerifying => 'Bineberipika...';

  @override
  String get passwordNewTitle => 'Bagong password';

  @override
  String get passwordNewDescription =>
      'Magtakda ng bagong password para sa iyong account.';

  @override
  String get fieldNewPasswordLabel => 'Bagong password';

  @override
  String get newPasswordHint => 'Ilagay ang iyong bagong password';

  @override
  String get fieldConfirmNewPasswordLabel => 'Kumpirmahin ang bagong password';

  @override
  String get confirmNewPasswordHint => 'Ilagay muli ang iyong bagong password';

  @override
  String get passwordNewSubmitting => 'Isinusumite...';

  @override
  String get passwordNewSubmit => 'Isumite';

  @override
  String get passwordCompleteTitle => 'Kumpleto na ang pag-reset ng password';

  @override
  String get passwordCompleteBody =>
      'Na-reset na ang iyong password. Mag-log in gamit ang bagong password para magpatuloy.';

  @override
  String get termsTitle => 'Mga tuntunin ng serbisyo';

  @override
  String get privacyTitle => 'Patakaran sa privacy';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Magtakda ng bagong password para sa $email.';
  }

  @override
  String get selectComplete => 'Tapos na';

  @override
  String get onboardingLanguageTitle => 'Ano ang katutubong wika mo?';

  @override
  String get onboardingReasonTitle => 'Bakit ka natututo ng wika?';

  @override
  String get onboardingReasonSubtitle =>
      'Iaangkop namin ang iyong pagkatuto sa iyong mga layunin.';

  @override
  String get savingLabel => 'Sine-save...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Bayad ngayong buwan';

  @override
  String get filterAll => 'Lahat';

  @override
  String get filterSubscription => 'Subscription';

  @override
  String get filterCharacter => 'Karakter';

  @override
  String get statusCompleted => 'Tapos na';

  @override
  String get lastPayment => 'Huling bayad';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Magagamit mo pa ang mga benepisyo ng Pro hanggang $date, pagkatapos ay awtomatikong lilipat sa Libre ang plano mo.';
  }

  @override
  String get freePlanCallLimit => '1 tawag kada araw · 5 min na limitasyon';

  @override
  String get freePlanBasicCharacters => 'Kasama ang mga basic na karakter';

  @override
  String get availableForPurchase => 'Mabibili';

  @override
  String get paymentsLoadError => 'Hindi ma-load ang kasaysayan ng bayad';

  @override
  String get noPayments => 'Wala pang bayad';

  @override
  String get morePaymentsExist => 'Hindi pa ipinapakita ang mas lumang bayad';

  @override
  String get undatedPayments => 'Walang petsa';

  @override
  String get paymentLabelFallback => 'Bayad';

  @override
  String learningPassed(int passed, int total) {
    return '$passed sa $total pangungusap ang pumasa';
  }

  @override
  String get hardestSound => 'Pinakamahirap na tunog ngayon';

  @override
  String get soundAccuracy => 'Katumpakan kada tunog';

  @override
  String phonemeAttempts(int count) {
    return 'Kada ponema · $count subok';
  }

  @override
  String get colSound => 'Tunog';

  @override
  String get colAttempts => 'Subok';

  @override
  String get colCorrect => 'Tama';

  @override
  String get colAccuracy => 'Tumpak';

  @override
  String get sentenceResults => 'Resulta kada pangungusap';

  @override
  String viewAllSentences(int count) {
    return 'Tingnan lahat ng $count';
  }

  @override
  String get colSentence => 'Pangus.';

  @override
  String get colPronunciation => 'Bigkas';

  @override
  String get colFluency => 'Dulas';

  @override
  String get colRhythm => 'Ritmo';

  @override
  String recentSessions(int count) {
    return 'Huling $count sesyon';
  }

  @override
  String trendAverage(int score) {
    return 'Ave $score';
  }

  @override
  String get today => 'Ngayon';

  @override
  String get colDate => 'Petsa';

  @override
  String get colSentences => 'Pangus.';

  @override
  String get colScore => 'Iskor';

  @override
  String get colChange => 'Bago';

  @override
  String dateToday(String date) {
    return '$date (ngayon)';
  }

  @override
  String get accentAnalysis => 'Pagsusuri ng punto';

  @override
  String get overallLevel => 'Pangkalahatang antas';

  @override
  String get overallLevelSubtitle => 'Bokabularyo · Gramatika · Pagpapahayag';

  @override
  String get pronunciationAnalysis => 'Pagsusuri ng pagbigkas';

  @override
  String get recentSessionsAverage => 'Average ng huling 10 sesyon';

  @override
  String levelStage(int stage) {
    return 'Antas $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Sa lahat ng mag-aaral';

  @override
  String aheadOfLearners(int percent) {
    return 'Nangunguna ka sa $percent% ng mag-aaral';
  }

  @override
  String get retakeLevelTest => 'Ulitin ang level test';

  @override
  String get practicePronunciation => 'Magsanay ng pagbigkas';
}
