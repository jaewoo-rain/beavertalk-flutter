// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get loginRequired => 'Kailangan mong mag-sign in.';

  @override
  String get callWebNotSupported =>
      'Hindi suportado ang voice call sa web. Gamitin ang app.';

  @override
  String get micPermissionRequiredForCall =>
      'Kailangan ng access sa mikropono. Payagan ang mikropono para makatawag.';

  @override
  String get callErrorGeneric => 'May naganap na problema habang tumatawag.';

  @override
  String get callNetworkError => 'May network error na naganap.';

  @override
  String get authInvalidCredentials => 'Mali ang email o password.';

  @override
  String get authEmailAlreadyRegistered => 'Nakarehistro na ang email na ito.';

  @override
  String get authConfirmEmailRequired =>
      'Kumpletuhin ang beripikasyong ipinadala sa iyong email.';

  @override
  String get authResetCodeSent =>
      'Nagpadala kami ng verification code sa iyong email.';

  @override
  String get authResetCodeInvalid => 'Mali o expired na ang code.';

  @override
  String get authPasswordUpdated => 'Na-reset na ang iyong password.';

  @override
  String get authAppleTokenMissing => 'Hindi makuha ang Apple sign-in token.';

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
  String get selectNativeLanguage => 'Piliin ang katutubong wika mo';

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
  String pricePerMonth(String price) {
    return '$price / buwan';
  }

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
  String get loginFacebookSignInFailed => 'Nabigo ang Facebook sign-in.';

  @override
  String get loginKakaoSignInFailed => 'Nabigo ang Kakao sign-in.';

  @override
  String get loginContinueWithKakao => 'Magpatuloy gamit ang Kakao';

  @override
  String get loginContinueWithGoogle => 'Magpatuloy gamit ang Google';

  @override
  String get loginContinueWithFacebook => 'Magpatuloy gamit ang Facebook';

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

  @override
  String get priceChangedTitle => 'Nagbago ang presyo';

  @override
  String priceChangedBody(String price) {
    return 'Ang item na ito ay $price na ngayon. Magpapatuloy ka ba?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plan at mga binili';

  @override
  String get billingGroupInTheStore => 'Sa store';

  @override
  String get billingChangePlan => 'Baguhin ang plan';

  @override
  String get billingCompareAllPlans => 'Ikumpara lahat ng plan';

  @override
  String get billingBuyACharacter => 'Bumili ng karakter';

  @override
  String get billingRestorePurchases => 'I-restore ang mga binili';

  @override
  String get billingPaymentHistory => 'Kasaysayan ng bayad';

  @override
  String get billingManageInTheStore => 'Pamahalaan sa store';

  @override
  String get billingRefundHelp => 'Tulong sa refund';

  @override
  String get billingCancelSubscription => 'Kanselahin ang subscription';

  @override
  String get billingResubscribe => 'Mag-subscribe muli';

  @override
  String get badgeCurrent => 'Kasalukuyan';

  @override
  String get badgeTrial => 'Trial';

  @override
  String get badgeRenewing => 'Nagre-renew';

  @override
  String get badgePastDue => 'Lampas na sa takda';

  @override
  String get badgePaused => 'Naka-pause';

  @override
  String get badgeCanceling => 'Kinakansela';

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get plansTitle => 'Mga Plan';

  @override
  String get planFree => 'Libre';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max trial';

  @override
  String get freePlanPriceLine => '\$0.00 — isang tawag kada araw';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount kada buwan';
  }

  @override
  String freeUntilDate(String date) {
    return 'Libre hanggang $date';
  }

  @override
  String get todaysCalls => 'Mga tawag ngayon';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used sa $limit ang nagamit';
  }

  @override
  String get firstPaymentLabel => 'Unang bayad';

  @override
  String get nextPaymentLabel => 'Susunod na bayad';

  @override
  String get retryingUntilLabel => 'Susubukan muli hanggang';

  @override
  String get pausedSinceLabel => 'Naka-pause mula';

  @override
  String planEndsLabel(String plan) {
    return 'Matatapos ang $plan';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Maging unlimited sa Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Unlimited na tawag · tig-15 minuto · $price kada buwan';
  }

  @override
  String get bannerMaxUpsellTitle => 'I-on ang video sa Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Harapang tawag · $price kada buwan';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Lumipat sa taunan';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly kada taon · $perMonth kada buwan';
  }

  @override
  String get bannerPaymentFailedTitle => 'Hindi namin makuha ang bayad';

  @override
  String get bannerPaymentFailedSub =>
      'I-update ang bayad sa store para manatili ang Pro';

  @override
  String get bannerPausedTitle => 'Naka-pause ang plan mo';

  @override
  String get bannerPausedSub => 'Hindi natuloy ang bayad';

  @override
  String get noteRestoreHint =>
      'Naka-subscribe na sa ibang device? I-restore para ibalik ito sa device na ito.';

  @override
  String get noteStoreHandled =>
      'Ang paraan ng pagbabayad, pagpapalit ng plan, at pagkansela ay hinahawakan ng store.';

  @override
  String get noteFairUse =>
      'Ang unlimited na paggamit ay sakop ng aming fair use policy.';

  @override
  String noteTrialEnds(String date) {
    return 'Matatapos ang trial mo sa $date. Kanselahin sa store bago iyon at walang sisingilin.';
  }

  @override
  String get noteGrace =>
      'Tuloy ang mga benepisyo sa buong grace period. Hindi kailanman hinaharang ang pagkansela sa app.';

  @override
  String get noteHold =>
      'Naka-pause ang Pro hanggang matuloy ang bayad. Ligtas ang mga karakter at progreso mo.';

  @override
  String noteEnding(String date) {
    return 'Nakatakda nang matapos ang plan mo. Tuloy ang mga benepisyo hanggang $date, pagkatapos ay lilipat ka sa Libre. Puwede kang mag-subscribe muli anumang oras.';
  }

  @override
  String get trialExpiredTitle => 'Natapos na ang Max trial mo';

  @override
  String get trialExpiredSub => 'Nasa Libre ka na ngayon';

  @override
  String get seePlans => 'Tingnan ang mga plan';

  @override
  String get currentPlanTitle => 'Kasalukuyang Plan';

  @override
  String get badgeRecommended => 'Inirerekomenda';

  @override
  String get perMonthUnit => 'kada buwan';

  @override
  String get planTaglinePro => 'Unlimited na tawag. Tig-15 minuto.';

  @override
  String get planTaglineMax => 'Ngayon ay makikita mo na sila.';

  @override
  String get planTaglineFree => 'Isang tawag kada araw. Libre.';

  @override
  String get bulletProCalls => 'Voice call kahit gaano kadalas mo gusto';

  @override
  String get bulletProLength => '15 minuto kada tawag';

  @override
  String get bulletProScoring => 'Bigkas na sinusukat letra por letra';

  @override
  String get bulletProCorrections =>
      'Mga koreksyon na angkop sa sariling wika mo';

  @override
  String get bulletProBeaverCalls => 'Si Beaver ang unang tatawag sa iyo';

  @override
  String get bulletMaxVideo => 'Harapang video call';

  @override
  String get bulletMaxEverything => 'Lahat ng nasa Pro';

  @override
  String get bulletMaxCharacters => 'Bawat karakter, unlimited';

  @override
  String get bulletMaxStudyBook => 'Study book na akma sa antas mo';

  @override
  String get bulletMaxWeeklyReport =>
      'Lingguhang report kung paano nagbabago ang bigkas mo';

  @override
  String get bulletFreeCall => 'Isang 5-minutong voice call kada araw';

  @override
  String get bulletFreeCheck => 'Isang pagsusuri ng bigkas kada araw';

  @override
  String get bulletFreeAccent => 'Unlimited na pagsusuri ng accent';

  @override
  String get bulletFreeCharacter => 'Isang karakter para magsimula';

  @override
  String get ctaGoUnlimited => 'Maging unlimited';

  @override
  String get ctaTurnOnVideo => 'I-on ang video';

  @override
  String get noteCallLength => 'Tig-15 minuto ang bawat tawag.';

  @override
  String get paywallProTitle1 => 'Ang Korean friend mo';

  @override
  String get paywallProTitle2 => 'na gising kahit alas-3 ng madaling-araw';

  @override
  String get paywallProSub => 'Unlimited na tawag. Tig-15 minuto. Buong taon.';

  @override
  String get paywallLimitHeadline => 'Inaalis ng Pro ang limitasyon.';

  @override
  String get limitBannerCallTitle => 'Iyon na ang tawag mo ngayong araw';

  @override
  String get limitBannerCallSub => 'Isang tawag kada araw sa Libre';

  @override
  String get limitBannerCheckTitle => 'Iyon na ang pagsusuri mo ngayong araw';

  @override
  String get limitBannerCheckSub => 'Isang pagsusuri kada araw sa Libre';

  @override
  String get bulletProCharactersForever =>
      'Ang mga karakter na binili mo ay sa iyo habambuhay';

  @override
  String get paywallMaxTitle => 'Ngayon ay makikita mo na sila.';

  @override
  String get paywallMaxSub =>
      'Video call, bawat karakter, at study book na ginawa para sa antas mo.';

  @override
  String get planMonthly => 'Buwanan';

  @override
  String get planAnnual => 'Taunan';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price kada buwan';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth kada buwan';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price kada buwan';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly kada taon · $perMonth kada buwan';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price kada buwan · kanselahin anumang oras sa store';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price kada buwan · kanselahin anumang oras sa store';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 araw libre, tapos $price kada buwan · kanselahin anumang oras sa store';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Awtomatikong nagre-renew hanggang kanselahin.';

  @override
  String get footerTerms => 'Mga Tuntunin';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get noteMaxCharacters =>
      'Ang mga karakter na binuksan ng Max ay magagamit habang aktibo ang subscription mo. Ang mga karakter na binili mo ay mananatiling sa iyo.';

  @override
  String get processingTitle => 'Kinukumpirma ang binili mo';

  @override
  String get processingSub => 'Karaniwang ilang segundo lang ito.';

  @override
  String get successProTitle => 'Nasa Pro ka na.';

  @override
  String get successProSub => 'Unlimited na tawag, simula ngayon mismo.';

  @override
  String get successProBenefit1 =>
      'Tumawag kahit gaano kadalas — 15 minuto kada tawag';

  @override
  String get successProBenefit2 => 'Unlimited na pagsusuri ng bigkas';

  @override
  String get successProBenefit3 => 'Bawat karakter, pati one-off na pagbili';

  @override
  String get successMaxTitle => 'Makikita mo na sila ngayon.';

  @override
  String get successMaxSub =>
      'Naka-on na ang video call. I-tap ang video button sa kahit anong tawag.';

  @override
  String get successMaxBenefit1 => 'Harapang video call';

  @override
  String get successMaxBenefit2 =>
      'Bawat karakter, unlimited at una sa mga bago';

  @override
  String get successMaxBenefit3 => 'Study book na akma sa antas mo';

  @override
  String get ctaStartACall => 'Magsimula ng tawag';

  @override
  String get ctaStartAVideoCall => 'Magsimula ng video call';

  @override
  String get ctaSeeYourSubscription => 'Tingnan ang subscription mo';

  @override
  String successProCaption(String price) {
    return '$price ang sisingilin buwan-buwan hanggang kanselahin mo. Pamahalaan o kanselahin anumang oras sa store.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price ang sisingilin buwan-buwan hanggang kanselahin mo. Pamahalaan o kanselahin anumang oras sa store.';
  }

  @override
  String get plansErrorTitle => 'Hindi ma-load ang mga plan';

  @override
  String get plansErrorSub => 'Hindi sumagot ang store.';

  @override
  String get ctaTryAgain => 'Subukan muli';

  @override
  String get plansErrorCaption => 'Walang siningil.';

  @override
  String get changePlanTitle => 'Baguhin ang Plan';

  @override
  String get moveToMaxTitle => 'Lumipat sa Max';

  @override
  String maxPriceShort(String price) {
    return '$price / buwan';
  }

  @override
  String get moveToMaxCardSub =>
      'Harapang video call · bawat karakter · study book na para sa iyo';

  @override
  String get whatHappensNow => 'Ano ang mangyayari ngayon';

  @override
  String get maxStartsLabel => 'Magsisimula ang Max';

  @override
  String get immediately => 'Kaagad';

  @override
  String get unusedProTime => 'Hindi nagamit na oras ng Pro';

  @override
  String get creditedTowardMax => 'Ikre-kredito sa Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Lumipat sa Max';

  @override
  String get upgradeCaption =>
      'Agad magsisimula ang bago mong plan. Ang hindi nagamit na oras ng Pro ay ikre-kredito, hindi kailanman sisingilin nang dalawang beses.';

  @override
  String get moveToProTitle => 'Lumipat sa Pro';

  @override
  String get moveToProSub =>
      'Walang magbabago ngayon. Tuloy ang Max hanggang matapos ang buwang nabayaran mo na.';

  @override
  String get maxRunsUntil => 'Tuloy ang Max hanggang';

  @override
  String get proStarts => 'Magsisimula ang Pro';

  @override
  String get whatYouKeep => 'Ang mananatili sa iyo';

  @override
  String get keepBenefitCalls => 'Unlimited na voice call, tig-15 minuto';

  @override
  String get keepBenefitCharacters =>
      'Ang mga karakter na binili mo ay sa iyo habambuhay';

  @override
  String downgradeWarning(String date) {
    return 'Mao-off ang video call at mga karakter na pang-Max lang sa $date.';
  }

  @override
  String get ctaSwitchToPro => 'Lumipat sa Pro';

  @override
  String get ctaKeepMax => 'Panatilihin ang Max';

  @override
  String get winbackSkip => 'Laktawan';

  @override
  String get winbackTitle => 'Natapos na ang Pro plan mo';

  @override
  String get winbackSub => 'Nasa Libre ka na — isang tawag kada araw.';

  @override
  String get winbackQuestion => 'Puwede mo bang sabihin kung bakit ka umalis?';

  @override
  String get winbackReasonExpensive => 'Masyadong mahal';

  @override
  String get winbackReasonUnused => 'Hindi ko ito nagagamit nang husto';

  @override
  String get winbackReasonMissing => 'May feature akong kailangan na wala rito';

  @override
  String get winbackReasonOtherApp => 'Nakahanap ako ng ibang app';

  @override
  String get winbackReasonElse => 'Iba pang dahilan';

  @override
  String get ctaSend => 'Ipadala';

  @override
  String get ctaNotNow => 'Hindi muna';

  @override
  String get winbackCaption =>
      'Hindi nito ibinabalik ang plan mo. Mag-subscribe muli sa store.';

  @override
  String get ctaContinue => 'Magpatuloy';

  @override
  String get ctaClose => 'Isara';

  @override
  String get ovRestoreSuccessTitle => 'Bumalik na ang Pro';

  @override
  String get ovRestoreSuccessBody =>
      'Nakita namin ang subscription mo at ibinalik ito sa device na ito.';

  @override
  String get ovRestoreEmptyTitle => 'Walang mai-restore';

  @override
  String get ovRestoreEmptyBody =>
      'Walang aktibong subscription na naka-link sa store account na ito.';

  @override
  String get ovRestoreOtherTitle => 'Sa ibang account ang plan na iyan';

  @override
  String get ovRestoreOtherBody =>
      'Aktibo na ang subscription na ito sa ibang BeaverTalk account.';

  @override
  String get ctaSignInThatAccount => 'Mag-sign in sa account na iyon';

  @override
  String get ctaGetHelp => 'Humingi ng tulong';

  @override
  String get ovCharacterOfferTitle => 'Hindi pa handa para sa Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Pumili ng isang karakter at panatilihin ito. Isang beses na pagbili — walang subscription, walang renewal.';

  @override
  String get rowOneCharacter => 'Isang karakter';

  @override
  String rowFromPrice(String price) {
    return 'mula $price';
  }

  @override
  String get rowYoursForever => 'Sa iyo habambuhay';

  @override
  String get rowNoRenewal => 'Walang renewal';

  @override
  String get rowWorksOnFree => 'Gumagana sa Libre';

  @override
  String get rowYes => 'Oo';

  @override
  String get ctaSeeCharacters => 'Tingnan ang mga karakter';

  @override
  String get ovNotEligibleTitle => 'Walang ikakansela';

  @override
  String get ovNotEligibleBody =>
      'Nasa Libre ka. Walang aktibong subscription sa account na ito.';

  @override
  String get ovCancelDownsellTitle => 'Bago ka umalis';

  @override
  String get ovCancelDownsellBody =>
      'Sa store ginagawa ang pagkansela. Dalawang bagay na dapat mong malaman.';

  @override
  String get rowPayYearlyInstead => 'Magbayad na lang taunan';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price kada buwan';
  }

  @override
  String get rowCharactersYouBought => 'Mga karakter na binili mo';

  @override
  String get rowProRunsUntil => 'Tuloy ang Pro hanggang';

  @override
  String get ctaSwitchToYearly => 'Lumipat sa taunan';

  @override
  String get ctaContinueToStore => 'Magpatuloy sa store';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Magbayad taunan, makatipid ng $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Dalawang buwan ka na sa Pro. Mas mura ang taunang plan sa kabuuan.';

  @override
  String get rowYouSave => 'Matitipid mo';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Taunan';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Buwanan, sa loob ng isang taon';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Lumipat sa buwanan';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Tuloy ang taunang plan mo hanggang $date. Magsisimula ang buwanang singil kinabukasan.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Magsisimula ang buwanang singil';

  @override
  String get rowMonthlyLabel => 'Buwanan';

  @override
  String get rowYearlyWorkedOut => 'Katumbas ng taunan';

  @override
  String get ctaSwitchToMonthly => 'Lumipat sa buwanan';

  @override
  String get ovRefundHelpTitle => 'Ang refund ay hinahawakan ng store';

  @override
  String get ovRefundHelpBody =>
      'Hindi kami mismo makakapag-isyu ng refund. Bawat kahilingan ay sinusuri ng store.';

  @override
  String get ctaGoToStore => 'Pumunta sa store';

  @override
  String get ovTrialEndingTitle => 'Matatapos ang trial mo bukas';

  @override
  String get ovTrialEndingBody =>
      'Tuloy ang Max maliban kung kanselahin mo. Ito ang mangyayari.';

  @override
  String get rowTrialEnds => 'Matatapos ang trial';

  @override
  String get rowFirstCharge => 'Unang singil';

  @override
  String get rowThenMonthly => 'Pagkatapos ay buwanan';

  @override
  String get ctaCancelInStore => 'Kanselahin sa store';

  @override
  String get ovTrialStartTitle => '7 araw ng Max, libre';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Libre hanggang $date. Pagkatapos ay $price kada buwan, maliban kung kanselahin mo sa store.';
  }

  @override
  String get ctaStart7Days => 'Simulan ang 7 araw na libre';

  @override
  String get ovOtoTitle => 'Isa pang bagay bago ka magsimula';

  @override
  String get ovOtoBody =>
      'Magandang desisyon — aktibo na ang unlimited na tawag. Mas mura ang parehong Pro kung magbabayad ka taunan.';

  @override
  String get ovFailedDeclinedTitle => 'Tinanggihan ang card mo';

  @override
  String get ovFailedDeclinedBody =>
      'Hindi makuha ng store ang bayad. Walang siningil.';

  @override
  String get ctaUpdatePaymentMethod => 'I-update ang paraan ng pagbabayad';

  @override
  String get ovFailedCanceledTitle => 'Kinansela ang bayad';

  @override
  String get ovFailedCanceledBody => 'Nasa Libre ka pa rin. Walang siningil.';

  @override
  String get ovFailedStoreTitle => 'May nangyaring mali';

  @override
  String get ovFailedStoreBody =>
      'Hindi namin maabot ang store. Walang siningil.';

  @override
  String get ovAlreadyTitle => 'Nasa Pro ka na';

  @override
  String get ovAlreadyBody =>
      'May aktibong plan na ang store account na ito. Wala nang bibilhin.';

  @override
  String get ctaSeeMySubscription => 'Tingnan ang subscription ko';

  @override
  String get subCancelTitle => 'Kanselahin ang subscription';

  @override
  String subCancelBody(String date) {
    return 'Tuloy ang Pro hanggang $date. Pagkatapos noon ay lilipat ka sa Libre.';
  }

  @override
  String get subWhatYouLose => 'Ang mawawala sa iyo';

  @override
  String get benefitCalls15 => 'Unlimited na tawag, tig-15 minuto';

  @override
  String get benefitScoring => 'Bigkas na sinusukat letra por letra';

  @override
  String get benefitEveryCharacter => 'Bawat karakter, unlimited';

  @override
  String get ctaKeepPro => 'Panatilihin ang Pro';

  @override
  String get subPaymentTitle => 'I-update ang bayad';

  @override
  String get subPaymentBody =>
      'Hindi namin makuha ang bayad. Tuloy ang Pro sa buong grace period.';

  @override
  String get subHowToFix => 'Paano ito ayusin';

  @override
  String get fixStep1 =>
      'Buksan ang store at i-update ang paraan ng pagbabayad mo';

  @override
  String get fixStep2 => 'Bumalik ka — awtomatikong magpapatuloy ang plan mo';

  @override
  String get fixStep3 => 'Walang sisingilin nang dalawang beses';

  @override
  String get subResubTitle => 'Mag-subscribe muli';

  @override
  String subResubBody(String date) {
    return 'Matatapos ang Pro sa $date. I-on muli ang auto-renew at walang magbabago.';
  }

  @override
  String get subWhatYouKeep => 'Ang mananatili sa iyo';

  @override
  String get ctaTurnItBackOn => 'I-on itong muli';

  @override
  String get flTodayTitle => 'Iyon na ang tawag mo ngayong araw';

  @override
  String get flTodayBody => 'Ituloy kung saan ka huminto — ngayon mismo.';

  @override
  String get flCheckTitle => 'Iyon na ang pagsusuri mo ngayong araw';

  @override
  String get flCheckBody =>
      'Isang pagsusuri kada araw sa Libre. Ginagawa itong unlimited ng Pro.';

  @override
  String get flBenefitCalls => 'Unlimited na tawag sa Pro · tig-15 minuto';

  @override
  String get flBenefitChecks => 'Unlimited na pagsusuri ng bigkas sa Pro';

  @override
  String flCaption(String price) {
    return '$price kada buwan · kanselahin anumang oras';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used sa $limit ang nagamit';
  }

  @override
  String get ctaMaybeTomorrow => 'Baka bukas na lang';

  @override
  String get accountSection => 'Account';

  @override
  String get nicknameLabel => 'Palayaw';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Paraan ng pag-login';

  @override
  String get joinedLabel => 'Sumali noong';

  @override
  String get editNicknameTitle => 'I-edit ang Palayaw';

  @override
  String get nicknameRule => '2–12 karakter. Mga letra at numero. English lang';

  @override
  String get ctaSave => 'I-save';

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
  String get paywallLeaveTitle =>
      'Kapag umalis ka ngayon, hindi ka pa naka-subscribe';

  @override
  String get paywallLeaveBody =>
      'Mabubuksan agad ang mga benepisyo pagkatapos magbayad. Puwede kang bumalik anumang oras mula sa Aking pahina.';

  @override
  String get ctaKeepLooking => 'Tingnan pa';

  @override
  String get ctaLeaveAnyway => 'Umalis pa rin';

  @override
  String get iapCharacterSuccessTitle => 'May bagong kaibigan ka na!';

  @override
  String get iapCharacterSuccessBody =>
      'Sa iyo na ang character na ito habambuhay — mananatili kahit magpalit ka ng plan, at maibabalik ito sa kahit anong device gamit ang Restore purchases.';

  @override
  String get iapCharacterFailedBody =>
      'Hindi natuloy ang pagbili. Walang na-charge — pakisubukan ulit.';

  @override
  String get noAccentDataTitle => 'Wala pang datos ng intonasyon';

  @override
  String get noAccentDataBody =>
      'Magpatuloy sa pagtawag at maiipon ang mga katangian ng iyong intonasyon.';

  @override
  String get noLevelYetTitle => 'Wala pang antas';

  @override
  String get noLevelYetBody =>
      'Tapusin ang unang tawag mo para makuha ang antas mo.';

  @override
  String get noPronunciationDataTitle => 'Wala pang tala ng bigkas';

  @override
  String get noPronunciationDataBody =>
      'Sinusuri namin ang bigkas mula sa mga pangungusap na sinabi mo sa tawag.';

  @override
  String get noCharacterNote => 'Wala pang naiwang mensahe';

  @override
  String get noPhonemesYet => 'Wala pang tunog na masusuri';

  @override
  String get noSentencesYet => 'Wala pang pangungusap na masusuri';

  @override
  String get takeLevelTest => 'Kumuha ng level test';

  @override
  String get reviewToSeeScore =>
      'Mag-review para makita ang iskor ng bigkas mo';

  @override
  String get playAgain => 'Ulitin';

  @override
  String get difficultySlow => 'Mabagal';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Mabilis';

  @override
  String get difficultyLabel => 'Antas ng hirap';

  @override
  String get connected => 'Nakakonekta';

  @override
  String get unlockedWithMax => 'Available sa Max';

  @override
  String get callModeSheetTitle => 'Paano mo gustong mag-usap?';

  @override
  String get callModeSheetSubtitle => 'Agad na mag-aaply sa tawag na ito';

  @override
  String get callModeFreeTalk => 'Malayang usapan';

  @override
  String get callModeFreeTalkDesc => 'Mag-usap nang walang pagwawasto';

  @override
  String get callModeStudy => 'Pag-aaral';

  @override
  String get callModeStudyDesc =>
      'Matuto ng isang ekspresyon sa bawat pagkakataon';

  @override
  String get callModeChange => 'Palitan ang mode';

  @override
  String get callModeKeep => 'Hindi muna';

  @override
  String get callExitTitle => 'Tapusin ang tawag?';

  @override
  String get callExitSubtitle =>
      'Kahit tapusin ngayon, gagamit pa rin ng isang tawag';

  @override
  String get callExitKeep => 'Magpatuloy sa pag-uusap';

  @override
  String get callExitConfirm => 'Tapusin ang tawag';

  @override
  String get callMicMute => 'I-mute';

  @override
  String get callMicUnmute => 'I-unmute';

  @override
  String get callPushToTalk => 'Pindutin nang matagal para magsalita';

  @override
  String get callFreeEndedTitle => 'Naubos na ang libre mong tawag';

  @override
  String get callFreeEndedCta => 'Mag-subscribe at magpatuloy';

  @override
  String get callKeepGoingTitle => 'Ituloy pa?';

  @override
  String get callKeepGoingSubtitle =>
      'Nagpapatuloy ang tawag kada 5 minuto. Magtatanong kami ulit sa bawat pagkakataon.';

  @override
  String get articulationSelectedWord => 'Napiling salita';

  @override
  String get articulationYouSaid => 'Ang bigkas mo';

  @override
  String get articulationTargetSound => 'Target';
}
