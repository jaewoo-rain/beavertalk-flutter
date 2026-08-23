// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get loginRequired => 'Be kell jelentkezned.';

  @override
  String get callWebNotSupported =>
      'A hanghívás nem támogatott a weben. Használd az alkalmazást.';

  @override
  String get micPermissionRequiredForCall =>
      'Mikrofon-hozzáférés szükséges. Engedélyezd a mikrofont a híváshoz.';

  @override
  String get callErrorGeneric => 'Hiba történt a hívás közben.';

  @override
  String get callNetworkError => 'Hálózati hiba történt.';

  @override
  String get authInvalidCredentials => 'Az e-mail-cím vagy a jelszó hibás.';

  @override
  String get authEmailAlreadyRegistered =>
      'Ez az e-mail-cím már regisztrálva van.';

  @override
  String get authConfirmEmailRequired =>
      'Fejezd be az e-mailben küldött megerősítést.';

  @override
  String get authResetCodeSent =>
      'Elküldtük az ellenőrző kódot az e-mail-címedre.';

  @override
  String get authResetCodeInvalid => 'A kód hibás vagy lejárt.';

  @override
  String get authPasswordUpdated => 'A jelszavad visszaállt.';

  @override
  String get authAppleTokenMissing =>
      'Nem sikerült megszerezni az Apple bejelentkezési tokent.';

  @override
  String callEndedDuration(String duration) {
    return 'A hívás véget ért $duration';
  }

  @override
  String get callRatingPrompt => 'Milyen volt a hívásod?';

  @override
  String get ratingBad => 'Nem volt jó';

  @override
  String get ratingOkay => 'Rendben volt';

  @override
  String get ratingGood => 'Nagyon jó';

  @override
  String get goHome => 'Kezdőlap';

  @override
  String get viewAnalysis => 'Elemzés megtekintése';

  @override
  String get loadingShort => 'Betöltés…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Nem sikerült elküldeni az értékelést: $message';
  }

  @override
  String get callInfoNotFound =>
      'A hívás adatai nem találhatók, az elemzés kimarad.';

  @override
  String get tabRecords => 'Felvételek';

  @override
  String get tabArchive => 'Archívum';

  @override
  String get callHistory => 'Hívástörténet';

  @override
  String get conversationRecord => 'Beszélgetés felvétele';

  @override
  String get noCallRecords => 'Még nincs hívásfelvétel';

  @override
  String get noCallRecordsBody =>
      'Miután befejezed az első hívásodat az AI-val,\na felvételeid itt jelennek meg.';

  @override
  String get startCall => 'Hívás indítása';

  @override
  String get recordsLoadError => 'Nem sikerült betölteni a felvételeket';

  @override
  String get tryAgainLater => 'Kérjük, próbáld újra később.';

  @override
  String get retry => 'Újra';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes perc $seconds mp';
  }

  @override
  String get scheduleManagement => 'Ütemezés';

  @override
  String get alarms => 'Riasztások';

  @override
  String get addSchedule => 'Ütemezés hozzáadása';

  @override
  String get editSchedule => 'Ütemezés szerkesztése';

  @override
  String get somethingWentWrong => 'Valami hiba történt';

  @override
  String get alarmsLoadError => 'Nem sikerült betölteni a riasztásokat';

  @override
  String get charactersLoadError => 'Nem sikerült betölteni a karaktereket';

  @override
  String get noCharacters => 'Nincs elérhető karakter';

  @override
  String get close => 'Bezárás';

  @override
  String get repeat => 'Ismétlés';

  @override
  String get callPartner => 'Karakter';

  @override
  String get quickStart => 'Gyors indítás';

  @override
  String get presetMorning => 'Reggeli rutin';

  @override
  String get presetMorningSub => 'Hétköznap 8:00';

  @override
  String get presetEvening => 'Esti levezetés';

  @override
  String get presetEveningSub => 'Minden nap 21:00';

  @override
  String get presetCustom => 'Egyéni';

  @override
  String get presetCustomSub => 'Ahogy szeretnéd';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Hetente $count× · havi $monthly hívás';
  }

  @override
  String get alarmSummaryNone => 'Válassz legalább egy napot';

  @override
  String get partnerInUse => 'Használatban';

  @override
  String get partnerOwned => 'Birtokolt';

  @override
  String get am => 'DE';

  @override
  String get pm => 'DU';

  @override
  String get save => 'Mentés';

  @override
  String get conversation => 'Beszélgetés';

  @override
  String get review => 'Áttekintés';

  @override
  String get pronunciationChallenge => 'Kiejtési kihívás';

  @override
  String get newExpressions => 'Új kifejezések';

  @override
  String get analysisResult => 'Elemzés eredménye';

  @override
  String get noNewExpressions =>
      'Ebből a beszélgetésből nincsenek új kifejezések.';

  @override
  String get practice => 'Gyakorlás';

  @override
  String recentScore(int score) {
    return 'Legutóbbi eredmény: $score%';
  }

  @override
  String callSequence(int count) {
    return '$count. hívás';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Néhány szó $name részéről';
  }

  @override
  String characterNoteFooter(String name) {
    return '$name hagyta közvetlenül a hívás után';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Új kifejezések $count';
  }

  @override
  String get analysisLoadError =>
      'Nem sikerült betölteni az elemzés eredményét.';

  @override
  String get standardAudioNotReady =>
      'A standard kiejtésű hanganyag még nem áll készen.';

  @override
  String get standardAudioPlayError =>
      'Nem sikerült lejátszani a standard kiejtésű hanganyagot.';

  @override
  String get selectNativeLanguage => 'Válaszd ki az anyanyelved';

  @override
  String get selectYourLanguage => 'Válaszd ki a nyelvedet';

  @override
  String get confirm => 'Megerősítés';

  @override
  String get cancel => 'Mégse';

  @override
  String get selectTime => 'Időpont kiválasztása';

  @override
  String get getStarted => 'Kezdjük el';

  @override
  String get permissionTitle =>
      'Engedélyezd a hozzáféréseket\na zökkenőmentes élményért';

  @override
  String get permissionSubtitle =>
      'A szükséges engedélyek elengedhetetlenek a szolgáltatás használatához.';

  @override
  String get permissionMicTitle => 'Mikrofon (kötelező)';

  @override
  String get permissionMicDesc =>
      'Szükséges ahhoz, hogy angolul beszélgethess az AI-val.';

  @override
  String get permissionNotifTitle => 'Értesítések (opcionális)';

  @override
  String get permissionNotifDesc =>
      'Tanulási emlékeztetőket és hívásütemezéseket küldünk.';

  @override
  String get micPermissionNeededTitle => 'Mikrofon-hozzáférés szükséges';

  @override
  String get micPermissionNeededBody =>
      'Az AI-val való beszélgetéshez engedélyezned kell a mikrofon-hozzáférést. Kérjük, engedélyezd a Beállításokban.';

  @override
  String get openSettings => 'Beállítások megnyitása';

  @override
  String get connectionFailedTitle => 'Sikertelen kapcsolódás';

  @override
  String get connectionFailedBody =>
      'Ellenőrizd a hálózati kapcsolatodat,\nés próbáld újra.';

  @override
  String get checkout => 'Fizetés';

  @override
  String get pay => 'Fizetés';

  @override
  String get orderSummary => 'Rendelés összegzése';

  @override
  String get paymentMethod => 'Fizetési mód';

  @override
  String get payMethodCard => 'Hitel-/betéti kártya';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Bosszantó hódavatar';

  @override
  String get productTrait => 'Prémium karakter · Örökre a tiéd';

  @override
  String get amountItemPrice => 'Termék ára';

  @override
  String get amountDiscount => 'Kedvezmény';

  @override
  String get amountTotal => 'Összesen';

  @override
  String get paymentCompleteTitle => 'Sikeres fizetés';

  @override
  String get paymentCompleteBody => 'Az avatar bekerült a gyűjteményedbe.';

  @override
  String get viewCollection => 'Gyűjtemény megtekintése';

  @override
  String get receiptItem => 'Termék';

  @override
  String get receiptAmount => 'Összeg';

  @override
  String get receiptMethod => 'Fizetési mód';

  @override
  String get receiptDate => 'Dátum';

  @override
  String get paymentFailedTitle => 'Sikertelen fizetés';

  @override
  String get paymentFailedBody =>
      'A fizetésedet nem sikerült feldolgozni.\nKérjük, próbáld újra.';

  @override
  String get freeCallEndingTitle => 'Az ingyenes hívásod hamarosan véget ér';

  @override
  String get freeCallEndingBody =>
      'Fizess elő, hogy tovább beszélgethess a Hóddal.';

  @override
  String get subscribe => 'Előfizetés';

  @override
  String get endCall => 'Hívás befejezése';

  @override
  String get callEnded => 'A hívás véget ért.';

  @override
  String get connecting => 'Kapcsolódás…';

  @override
  String get connectingHint =>
      'Ez általában kevesebb mint 5 másodpercet vesz igénybe';

  @override
  String get callConnectFailed => 'Nem sikerült kapcsolódni a híváshoz.';

  @override
  String get saveSentenceFailed => 'Nem sikerült elmenteni a mondatot.';

  @override
  String get recordStartFailed => 'Nem sikerült elindítani a felvételt.';

  @override
  String get recordTooShort =>
      'A felvétel túl rövid volt. Kérjük, próbáld újra.';

  @override
  String get gradingFailed => 'Az értékelés sikertelen. Kérjük, próbáld újra.';

  @override
  String get listenStandard => 'Standard kiejtés meghallgatása';

  @override
  String get saveSentence => 'Mondat mentése';

  @override
  String get unsaveSentence => 'Mentett mondat eltávolítása';

  @override
  String get scoringPronunciation => 'A kiejtésed értékelése…';

  @override
  String get analyzingByWord => 'Szóról szóra ellenőrizzük a kiejtésedet';

  @override
  String get analyzingTakingLonger => 'Ez egy kicsit tovább tart';

  @override
  String get scanConnectionLost => 'Megszakadt a kapcsolat';

  @override
  String get noRecordingToPlay => 'Nincs lejátszható felvétel.';

  @override
  String get myRecordingPlayError => 'Nem sikerült lejátszani a felvételedet.';

  @override
  String get next => 'Tovább';

  @override
  String get endLearning => 'Munkamenet befejezése';

  @override
  String get navCalendar => 'Naptár';

  @override
  String get navCall => 'Hívás';

  @override
  String get navStats => 'Statisztika';

  @override
  String get myPage => 'Saját oldal';

  @override
  String get languageSaveFailed => 'Nem sikerült elmenteni a nyelvedet.';

  @override
  String get accountDeleteFailed => 'Nem sikerült törölni a fiókodat.';

  @override
  String get changeAvatar => 'Avatar módosítása';

  @override
  String get avatarIntro =>
      'A hang és a nehézségi szint hívópartnerenként eltérő.\nEgyes partnerek fizetést igényelhetnek.';

  @override
  String myPartnersOwned(int count) {
    return 'Saját partnereim · $count db';
  }

  @override
  String get limitedDiscount => 'Korlátozott idejű kedvezmény';

  @override
  String get available => 'Elérhető';

  @override
  String get inUse => 'Használatban';

  @override
  String get owned => 'Megvásárolva';

  @override
  String get noCharactersToShow => 'Nincs megjeleníthető karakter';

  @override
  String get buy => 'Vásárlás';

  @override
  String get noSavedSentences =>
      'Még nincs elmentett mondatod.\nJelölj meg mondatokat a beszélgetésfelvételeidből.';

  @override
  String get noAlarms => 'Még nincs riasztás';

  @override
  String get noAlarmsBody =>
      'Adj hozzá egy tanulási emlékeztetőt,\nhogy kialakítsd a rendszeres szokást.';

  @override
  String get subscriptionManage => 'Előfizetés kezelése';

  @override
  String get changePlan => 'Csomag módosítása';

  @override
  String get cancelSubscription => 'Előfizetés lemondása';

  @override
  String get benefitsInUse => 'Az előnyeid';

  @override
  String get paymentInfo => 'Fizetési adatok';

  @override
  String get nextBillingDate => 'Következő számlázási dátum';

  @override
  String get lostBenefitsTitle =>
      'Előnyök, amelyeket lemondás esetén elveszítesz';

  @override
  String get viewBillingHistory => 'Számlázási előzmények megtekintése';

  @override
  String get keepUsingPro => 'Maradok Pro-tag';

  @override
  String get proMembership => 'Pro tagság';

  @override
  String pricePerMonth(String price) {
    return '$price / hó';
  }

  @override
  String get benefitUnlimitedCalls => 'Korlátlan hívások';

  @override
  String get benefitDetailedAnalysis =>
      'Részletes kiejtés- és nyelvtani elemzés';

  @override
  String get benefitAllCharacters => 'Hozzáférés az összes karakterhez';

  @override
  String get benefitNoAds => 'Reklámmentes';

  @override
  String get playSampleVoice => 'Minta hang lejátszása';

  @override
  String get useThisAvatar => 'Ezt választom';

  @override
  String get challengeTitle => 'Kiejtési kihívás';

  @override
  String get challengeIntro =>
      'Ejtsd ki helyesen koreaiul a zóna minden kártyáját, hogy teljesítsd.\nNincs mikrofonod? A képernyő koppintásával is játszhatsz.';

  @override
  String get challengeStart => 'Kamera és mikrofon indítása';

  @override
  String get challengePermissionNote =>
      'Az elülső kamera és a mikrofon hozzáférése szükséges (opcionális).';

  @override
  String get challengeLoadingTitle => 'Betöltés…';

  @override
  String get challengeLoadingNote =>
      'A koreai beszédfelismerő modell (~82 MB) letöltése az első indításkor.\nKérjük, várj egy kicsit.';

  @override
  String get challengeSttFallback =>
      'A beszédfelismerés nem volt elérhető, ezért koppintással játszottál.';

  @override
  String get reasonTravelTitle => 'Beszéd utazás közben';

  @override
  String get reasonTravelDesc => 'Beszélgess magabiztosan a helyiekkel';

  @override
  String get reasonCareerTitle => 'Munka és karrier';

  @override
  String get reasonCareerDesc => 'Üzleti beszélgetés';

  @override
  String get reasonExamTitle => 'Vizsgafelkészülés';

  @override
  String get reasonExamDesc => 'Készülj fel a szóbeli vizsgákra';

  @override
  String get reasonDailyTitle => 'Mindennapi beszélgetés';

  @override
  String get reasonDailyDesc => 'Kifejezések, amelyeket naponta használsz';

  @override
  String get reasonFriendsTitle => 'Külföldi barátok szerzése';

  @override
  String get reasonFriendsDesc => 'Természetes beszélgetés';

  @override
  String get reasonBrainTitle => 'Agyi stimuláció';

  @override
  String get reasonBrainDesc => 'Fejleszd az emlékezetedet és a fókuszodat';

  @override
  String get challengeRecordToggle => 'Ez a menet legyen felvéve';

  @override
  String get challengeRecordHint =>
      'Elmenti a játékmenetedről készült videót megosztásra (hang nélkül).';

  @override
  String get settingsSection => 'Beállítások';

  @override
  String get paymentSection => 'Fizetés';

  @override
  String get supportSection => 'Támogatás';

  @override
  String get userLanguage => 'Felhasználói nyelv';

  @override
  String get learningLanguage => 'Tanult nyelv';

  @override
  String get learningLanguageKorean => 'Koreai';

  @override
  String get notificationLabel => 'Értesítés';

  @override
  String get currentPlan => 'Jelenlegi csomag';

  @override
  String get paymentHistory => 'Fizetési előzmények';

  @override
  String get contactUs => 'Kapcsolat';

  @override
  String get termsOfService => 'Felhasználási feltételek';

  @override
  String get privacyPolicy => 'Adatvédelmi irányelvek';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String get deleteAccount => 'Fiók törlése';

  @override
  String get deleteAccountTitle => 'Törlöd a fiókodat?';

  @override
  String get deleteAccountBody =>
      'Ez véglegesen törli a fiókodat és az adataidat, és nem vonható vissza.';

  @override
  String get delete => 'Törlés';

  @override
  String get share => 'Megosztás';

  @override
  String get accentSoundsLike => 'A koreai kiejtésed hangzása';

  @override
  String get hintLabel => 'Tipp';

  @override
  String get nextHint => 'Következő tipp';

  @override
  String get translateLabel => 'Fordítás';

  @override
  String get startRecording => 'Felvétel indítása';

  @override
  String get stopRecording => 'Felvétel leállítása';

  @override
  String get back => 'Vissza';

  @override
  String get onboardingNameTitle => 'Hogyan szólítsunk?';

  @override
  String get onboardingNameSubtitle => 'Az AI oktatód emlékezni fog a nevedre.';

  @override
  String get nameLabel => 'A neved';

  @override
  String get nameHint => 'Add meg a neved';

  @override
  String get nameHelper =>
      'Nem kell a valódi neved legyen — egy becenév is megteszi.';

  @override
  String get continueLabel => 'Tovább';

  @override
  String get onboardingDoneTitle => 'A Hód várja a hívásodat';

  @override
  String get onboardingDoneSubtitle => 'Indíts egy hívást most azonnal';

  @override
  String get home => 'Kezdőlap';

  @override
  String get callNow => 'Hívás most';

  @override
  String get pronunciation => 'Kiejtés';

  @override
  String get fluency => 'Folyékonyság';

  @override
  String get rhythm => 'Ritmus';

  @override
  String get analysisTimeout =>
      'Ez a vártnál tovább tart. Kérjük, próbáld újra egy kicsit később.';

  @override
  String get analysisFailed =>
      'Nem sikerült elemeznünk a beszélgetést. Kérjük, próbáld újra.';

  @override
  String get analyzingConversation => 'A beszélgetésed elemzése…';

  @override
  String get analyzingSubtitle => 'Ez csak egy pillanatot vesz igénybe';

  @override
  String get tryAgain => 'Próbáld újra';

  @override
  String get nativeLabel => 'Anyanyelvi';

  @override
  String get meLabel => 'Én';

  @override
  String get pronunciationPlayError =>
      'Nem sikerült lejátszani a kiejtési hanganyagot.';

  @override
  String get savedExpressionsLoadError =>
      'Nem sikerült betölteni a mentett kifejezéseidet.';

  @override
  String get mySavedExpressions => 'Mentett kifejezéseim';

  @override
  String get avatarTraits => 'Meleg szívű · Nyugodt · Kedves';

  @override
  String get priceFree => 'Ingyenes';

  @override
  String get loginGoogleTokenError =>
      'Nem sikerült lekérni a Google bejelentkezési tokent.';

  @override
  String get loginGoogleSignInFailed =>
      'A Google bejelentkezés sikertelen volt.';

  @override
  String get loginAppleSignInFailed => 'A Apple bejelentkezés sikertelen volt.';

  @override
  String get loginFacebookSignInFailed =>
      'A Facebook bejelentkezés sikertelen volt.';

  @override
  String get loginKakaoSignInFailed => 'A Kakao bejelentkezés sikertelen volt.';

  @override
  String get loginContinueWithKakao => 'Folytatás Kakao fiókkal';

  @override
  String get loginContinueWithGoogle => 'Folytatás Google fiókkal';

  @override
  String get loginContinueWithFacebook => 'Folytatás Facebook fiókkal';

  @override
  String get loginContinueWithApple => 'Folytatás Apple fiókkal';

  @override
  String get loginContinueWithEmail => 'Folytatás e-mail címmel';

  @override
  String get loginOrDivider => 'vagy';

  @override
  String get loginNoAccount => 'Nincs még fiókod?';

  @override
  String get signUp => 'Regisztráció';

  @override
  String get loginTermsNoticePrefix => 'A folytatással elfogadod a ';

  @override
  String get loginTermsNoticeAnd => ' és a ';

  @override
  String get loginTermsNoticeSuffix => ' feltételeit.';

  @override
  String get loginLogIn => 'Bejelentkezés';

  @override
  String get fieldEmailLabel => 'E-mail';

  @override
  String get emailHint => 'Add meg az e-mail címed';

  @override
  String get fieldPasswordLabel => 'Jelszó';

  @override
  String get passwordHint => 'Add meg a jelszavad';

  @override
  String get loginRememberMe => 'Emlékezz rám';

  @override
  String get loginForgotPassword => 'Elfelejtetted a jelszavad?';

  @override
  String get loginLoggingIn => 'Bejelentkezés folyamatban…';

  @override
  String get passwordLengthError =>
      'A jelszónak 8–16 karakter hosszúnak kell lennie.';

  @override
  String get passwordsDoNotMatch => 'A jelszavak nem egyeznek.';

  @override
  String get signupCheckInput => 'Kérjük, ellenőrizd a megadott adatokat.';

  @override
  String get fieldConfirmPasswordLabel => 'Jelszó megerősítése';

  @override
  String get confirmPasswordHint => 'Add meg újra a jelszavad';

  @override
  String get signupSigningUp => 'Regisztráció folyamatban…';

  @override
  String get signupHaveAccount => 'Már van fiókod?';

  @override
  String get passwordMethodEmailRequired => 'Add meg az e-mail címed';

  @override
  String get passwordResetTitle => 'Jelszó visszaállítása';

  @override
  String get passwordMethodDescription =>
      'Add meg az e-mail címet, amelyre a jelszó-visszaállító kódot szeretnéd kapni.';

  @override
  String get emailAddressHint => 'E-mail cím';

  @override
  String get passwordMethodSending => 'Küldés folyamatban…';

  @override
  String get passwordMethodSendEmail => 'E-mail küldése';

  @override
  String get passwordCodeTitle => 'Add meg a kódot';

  @override
  String get passwordCodeDescription =>
      'Elküldtünk egy helyreállítási kódot az e-mail címedre. Add meg a folytatáshoz.';

  @override
  String get passwordCodeNoCode => 'Nem kaptad meg a kódot?';

  @override
  String get passwordCodeResend => 'Kód újraküldése';

  @override
  String get passwordCodeVerifying => 'Ellenőrzés folyamatban…';

  @override
  String get passwordNewTitle => 'Új jelszó';

  @override
  String get passwordNewDescription => 'Állíts be egy új jelszót a fiókodhoz.';

  @override
  String get fieldNewPasswordLabel => 'Új jelszó';

  @override
  String get newPasswordHint => 'Add meg az új jelszavad';

  @override
  String get fieldConfirmNewPasswordLabel => 'Új jelszó megerősítése';

  @override
  String get confirmNewPasswordHint => 'Add meg újra az új jelszavad';

  @override
  String get passwordNewSubmitting => 'Küldés folyamatban…';

  @override
  String get passwordNewSubmit => 'Küldés';

  @override
  String get passwordCompleteTitle => 'A jelszó visszaállítása megtörtént';

  @override
  String get passwordCompleteBody =>
      'A jelszavad visszaállításra került. A folytatáshoz jelentkezz be az új jelszavaddal.';

  @override
  String get termsTitle => 'Felhasználási feltételek';

  @override
  String get privacyTitle => 'Adatvédelmi irányelvek';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Állíts be egy új jelszót ehhez: $email.';
  }

  @override
  String get selectComplete => 'Kész';

  @override
  String get onboardingLanguageTitle => 'Mi az anyanyelved?';

  @override
  String get onboardingReasonTitle => 'Miért tanulsz nyelvet?';

  @override
  String get onboardingReasonSubtitle =>
      'A céljaidhoz igazítjuk a tanulásodat.';

  @override
  String get savingLabel => 'Mentés…';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'E havi fizetés';

  @override
  String get filterAll => 'Összes';

  @override
  String get filterSubscription => 'Előfizetés';

  @override
  String get filterCharacter => 'Karakter';

  @override
  String get statusCompleted => 'Befejezve';

  @override
  String get lastPayment => 'Utolsó fizetés';

  @override
  String subscriptionSwitchNote(String date) {
    return 'A Pro előnyeit $date napjáig használhatod, utána a csomagod automatikusan Ingyenesre vált.';
  }

  @override
  String get freePlanCallLimit => 'Napi 1 hívás · 5 perces korlát';

  @override
  String get freePlanBasicCharacters => 'Alapkarakterek benne vannak';

  @override
  String get availableForPurchase => 'Megvásárolható';

  @override
  String get paymentsLoadError =>
      'Nem sikerült betölteni a fizetési előzményeket';

  @override
  String get noPayments => 'Még nincs fizetés';

  @override
  String get morePaymentsExist => 'A régebbi fizetések még nem jelennek meg';

  @override
  String get undatedPayments => 'Dátum nélkül';

  @override
  String get paymentLabelFallback => 'Fizetés';

  @override
  String learningPassed(int passed, int total) {
    return '$total mondatból $passed sikerült';
  }

  @override
  String get hardestSound => 'A mai legnehezebb hang';

  @override
  String get soundAccuracy => 'Pontosság hangonként';

  @override
  String phonemeAttempts(int count) {
    return 'Fonémánként · $count próbálkozás';
  }

  @override
  String get colSound => 'Hang';

  @override
  String get colAttempts => 'Próba';

  @override
  String get colCorrect => 'Helyes';

  @override
  String get colAccuracy => 'Pont.';

  @override
  String get sentenceResults => 'Eredmények mondatonként';

  @override
  String viewAllSentences(int count) {
    return 'Mind a $count megtekintése';
  }

  @override
  String get colSentence => 'Mondat';

  @override
  String get colPronunciation => 'Kiejt.';

  @override
  String get colFluency => 'Foly.';

  @override
  String get colRhythm => 'Ritmus';

  @override
  String recentSessions(int count) {
    return 'Utolsó $count alkalom';
  }

  @override
  String trendAverage(int score) {
    return 'Átl. $score';
  }

  @override
  String get today => 'Ma';

  @override
  String get colDate => 'Dátum';

  @override
  String get colSentences => 'Mondat';

  @override
  String get colScore => 'Pont';

  @override
  String get colChange => 'Vált.';

  @override
  String dateToday(String date) {
    return '$date (ma)';
  }

  @override
  String get accentAnalysis => 'Akcentuselemzés';

  @override
  String get overallLevel => 'Összesített szint';

  @override
  String get overallLevelSubtitle => 'Szókincs · Nyelvtan · Kifejezések';

  @override
  String get pronunciationAnalysis => 'Kiejtéselemzés';

  @override
  String get recentSessionsAverage => 'Utolsó 10 alkalom átlaga';

  @override
  String levelStage(int stage) {
    return '$stage. szint';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Az összes tanuló közül';

  @override
  String aheadOfLearners(int percent) {
    return 'A tanulók $percent%-át megelőzöd';
  }

  @override
  String get retakeLevelTest => 'Szintfelmérő újra';

  @override
  String get practicePronunciation => 'Kiejtés gyakorlása';

  @override
  String get priceChangedTitle => 'Megváltozott az ár';

  @override
  String priceChangedBody(String price) {
    return 'Ez a tétel most $price. Folytatod?';
  }

  @override
  String get billingGroupPlanPurchases => 'Csomag és vásárlások';

  @override
  String get billingGroupInTheStore => 'Az áruházban';

  @override
  String get billingChangePlan => 'Csomagváltás';

  @override
  String get billingCompareAllPlans => 'Összes csomag összehasonlítása';

  @override
  String get billingBuyACharacter => 'Karakter vásárlása';

  @override
  String get billingRestorePurchases => 'Vásárlások visszaállítása';

  @override
  String get billingPaymentHistory => 'Fizetési előzmények';

  @override
  String get billingManageInTheStore => 'Kezelés az áruházban';

  @override
  String get billingRefundHelp => 'Segítség a visszatérítéshez';

  @override
  String get billingCancelSubscription => 'Előfizetés lemondása';

  @override
  String get billingResubscribe => 'Újra-előfizetés';

  @override
  String get badgeCurrent => 'Jelenlegi';

  @override
  String get badgeTrial => 'Próba';

  @override
  String get badgeRenewing => 'Megújul';

  @override
  String get badgePastDue => 'Fizetési késedelem';

  @override
  String get badgePaused => 'Szüneteltetve';

  @override
  String get badgeCanceling => 'Lemondva';

  @override
  String get subscriptionTitle => 'Előfizetés';

  @override
  String get plansTitle => 'Csomagok';

  @override
  String get planFree => 'Ingyenes';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max próba';

  @override
  String get freePlanPriceLine => '\$0.00 — napi egy hívás';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount havonta';
  }

  @override
  String freeUntilDate(String date) {
    return 'Ingyenes eddig: $date';
  }

  @override
  String get todaysCalls => 'Mai hívások';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used / $limit felhasználva';
  }

  @override
  String get firstPaymentLabel => 'Első fizetés';

  @override
  String get nextPaymentLabel => 'Következő fizetés';

  @override
  String get retryingUntilLabel => 'Újrapróbálkozás eddig';

  @override
  String get pausedSinceLabel => 'Szünetel ettől';

  @override
  String planEndsLabel(String plan) {
    return '$plan vége';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Korlátlan hívások a Pro csomaggal';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Korlátlan hívások · egyenként 15 perc · havi $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Kapcsold be a videót a Max csomaggal';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Szemtől szembeni hívások · havi $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Válts évesre';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return 'Évi $yearly · havi $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'Nem sikerült levonni a díjat';

  @override
  String get bannerPaymentFailedSub =>
      'Frissítsd a fizetést az áruházban, hogy a Pro megmaradjon';

  @override
  String get bannerPausedTitle => 'A csomagod szünetel';

  @override
  String get bannerPausedSub => 'A fizetés nem ment át';

  @override
  String get noteRestoreHint =>
      'Másik eszközön már előfizettél? A visszaállítás visszahozza erre az eszközre.';

  @override
  String get noteStoreHandled =>
      'A fizetési módot, a csomagváltást és a lemondást az áruház kezeli.';

  @override
  String get noteFairUse =>
      'A korlátlan használatra méltányos használati szabályzatunk vonatkozik.';

  @override
  String noteTrialEnds(String date) {
    return 'A próbaidőszakod $date napján ér véget. Ha előtte lemondod az áruházban, semmit nem vonunk le.';
  }

  @override
  String get noteGrace =>
      'Az előnyök a türelmi időszak alatt is működnek. A lemondást az alkalmazás soha nem akadályozza.';

  @override
  String get noteHold =>
      'A Pro szünetel, amíg a fizetés át nem megy. A karaktereid és a haladásod biztonságban vannak.';

  @override
  String noteEnding(String date) {
    return 'A csomagod hamarosan véget ér. Az előnyök $date napjáig működnek, utána Ingyenesre váltasz. Bármikor újra előfizethetsz.';
  }

  @override
  String get trialExpiredTitle => 'A Max próbád véget ért';

  @override
  String get trialExpiredSub => 'Most az Ingyenes csomagon vagy';

  @override
  String get seePlans => 'Csomagok megtekintése';

  @override
  String get currentPlanTitle => 'Jelenlegi csomag';

  @override
  String get badgeRecommended => 'Ajánlott';

  @override
  String get perMonthUnit => 'havonta';

  @override
  String get planTaglinePro => 'Korlátlan hívások. Egyenként 15 perc.';

  @override
  String get planTaglineMax => 'Most már láthatod őket.';

  @override
  String get planTaglineFree => 'Napi egy hívás. Ajándékba.';

  @override
  String get bulletProCalls => 'Hanghívások, amennyit csak szeretnél';

  @override
  String get bulletProLength => '15 perc hívásonként';

  @override
  String get bulletProScoring => 'Betűnként értékelt kiejtés';

  @override
  String get bulletProCorrections => 'Az anyanyelvedre szabott javítások';

  @override
  String get bulletProBeaverCalls => 'Beaver hív fel először';

  @override
  String get bulletMaxVideo => 'Szemtől szembeni videóhívások';

  @override
  String get bulletMaxEverything => 'Minden, ami a Pro csomagban van';

  @override
  String get bulletMaxCharacters => 'Minden karakter, korlátlanul';

  @override
  String get bulletMaxStudyBook => 'A szintedhez igazított tankönyv';

  @override
  String get bulletMaxWeeklyReport => 'Heti jelentés a kiejtésed változásáról';

  @override
  String get bulletFreeCall => 'Napi egy 5 perces hanghívás';

  @override
  String get bulletFreeCheck => 'Napi egy kiejtésellenőrzés';

  @override
  String get bulletFreeAccent => 'Korlátlan akcentusellenőrzés';

  @override
  String get bulletFreeCharacter => 'Egy karakter kezdésnek';

  @override
  String get ctaGoUnlimited => 'Váltás korlátlanra';

  @override
  String get ctaTurnOnVideo => 'Videó bekapcsolása';

  @override
  String get noteCallLength => 'A hívások egyenként 15 percesek.';

  @override
  String get paywallProTitle1 => 'A koreai barátod,';

  @override
  String get paywallProTitle2 => 'aki hajnali 3-kor is fent van';

  @override
  String get paywallProSub =>
      'Korlátlan hívások. Egyenként 15 perc. Egész évben.';

  @override
  String get paywallLimitHeadline => 'A Pro eltörli a korlátot.';

  @override
  String get limitBannerCallTitle => 'Ez volt a mai hívás';

  @override
  String get limitBannerCallSub => 'Az Ingyenes csomag napi egy hívást ad';

  @override
  String get limitBannerCheckTitle => 'Ez volt a mai ellenőrzés';

  @override
  String get limitBannerCheckSub =>
      'Az Ingyenes csomag napi egy ellenőrzést ad';

  @override
  String get bulletProCharactersForever =>
      'A megvásárolt karakterek örökre a tieid';

  @override
  String get paywallMaxTitle => 'Most már láthatod őket.';

  @override
  String get paywallMaxSub =>
      'Videóhívások, minden karakter és a szintedhez készült tankönyv.';

  @override
  String get planMonthly => 'Havi';

  @override
  String get planAnnual => 'Éves';

  @override
  String proMonthlyPriceLine(String price) {
    return 'Havi $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · havi $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'Havi $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'Évi $yearly · havi $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'Havi $price · bármikor lemondható az áruházban';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Havi $price · bármikor lemondható az áruházban';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 nap ingyen, utána Havi $price · bármikor lemondható az áruházban';
  }

  @override
  String get ctaCaptionAutoRenew => 'Lemondásig automatikusan megújul.';

  @override
  String get footerTerms => 'Feltételek';

  @override
  String get footerPrivacy => 'Adatvédelem';

  @override
  String get noteMaxCharacters =>
      'A Max által feloldott karakterek az előfizetésed ideje alatt érhetők el. A megvásárolt karakterek a tieid maradnak.';

  @override
  String get processingTitle => 'Vásárlás megerősítése';

  @override
  String get processingSub => 'Ez általában néhány másodpercet vesz igénybe.';

  @override
  String get successProTitle => 'Pro csomagon vagy.';

  @override
  String get successProSub => 'Korlátlan hívások, mostantól azonnal.';

  @override
  String get successProBenefit1 =>
      'Hívj, amennyiszer csak szeretnél — 15 perc hívásonként';

  @override
  String get successProBenefit2 => 'Korlátlan kiejtésellenőrzés';

  @override
  String get successProBenefit3 => 'Minden karakter, plusz egyszeri vásárlások';

  @override
  String get successMaxTitle => 'Most már láthatod őket.';

  @override
  String get successMaxSub =>
      'A videóhívások bekapcsolva. Koppints a videó gombra bármelyik hívásban.';

  @override
  String get successMaxBenefit1 => 'Szemtől szembeni videóhívások';

  @override
  String get successMaxBenefit2 =>
      'Minden karakter korlátlanul, az újak elsőként';

  @override
  String get successMaxBenefit3 => 'A szintedhez igazított tankönyv';

  @override
  String get ctaStartACall => 'Hívás indítása';

  @override
  String get ctaStartAVideoCall => 'Videóhívás indítása';

  @override
  String get ctaSeeYourSubscription => 'Előfizetésed megtekintése';

  @override
  String successProCaption(String price) {
    return 'Havonta $price kerül levonásra, amíg le nem mondod. Bármikor kezelheted vagy lemondhatod az áruházban.';
  }

  @override
  String successMaxCaption(String price) {
    return 'Havonta $price kerül levonásra, amíg le nem mondod. Bármikor kezelheted vagy lemondhatod az áruházban.';
  }

  @override
  String get plansErrorTitle => 'Nem sikerült betölteni a csomagokat';

  @override
  String get plansErrorSub => 'Az áruház nem válaszolt.';

  @override
  String get ctaTryAgain => 'Újra';

  @override
  String get plansErrorCaption => 'Semmit nem vontunk le.';

  @override
  String get changePlanTitle => 'Csomagváltás';

  @override
  String get moveToMaxTitle => 'Váltás Max csomagra';

  @override
  String maxPriceShort(String price) {
    return '$price / hó';
  }

  @override
  String get moveToMaxCardSub =>
      'Szemtől szembeni videóhívások · minden karakter · neked készült tankönyv';

  @override
  String get whatHappensNow => 'Mi történik most';

  @override
  String get maxStartsLabel => 'Max indul';

  @override
  String get immediately => 'Azonnal';

  @override
  String get unusedProTime => 'Fel nem használt Pro idő';

  @override
  String get creditedTowardMax => 'Beszámítjuk a Max árába';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Váltás Max csomagra';

  @override
  String get upgradeCaption =>
      'Az új csomagod azonnal indul. A fel nem használt Pro időt beszámítjuk, kétszer sosem vonunk le.';

  @override
  String get moveToProTitle => 'Váltás Pro csomagra';

  @override
  String get moveToProSub =>
      'Ma semmi nem változik. A Max a már kifizetett hónap végéig működik.';

  @override
  String get maxRunsUntil => 'Max érvényes eddig';

  @override
  String get proStarts => 'Pro indul';

  @override
  String get whatYouKeep => 'Amit megtartasz';

  @override
  String get keepBenefitCalls => 'Korlátlan hanghívások, egyenként 15 perc';

  @override
  String get keepBenefitCharacters => 'A megvásárolt karakterek örökre a tieid';

  @override
  String downgradeWarning(String date) {
    return 'A videóhívások és a csak Max karakterek $date napján kikapcsolnak.';
  }

  @override
  String get ctaSwitchToPro => 'Váltás Pro csomagra';

  @override
  String get ctaKeepMax => 'Maradjon a Max';

  @override
  String get winbackSkip => 'Kihagyás';

  @override
  String get winbackTitle => 'A Pro csomagod véget ért';

  @override
  String get winbackSub => 'Most az Ingyenes csomagon vagy — napi egy hívás.';

  @override
  String get winbackQuestion => 'Elárulod, miért mentél el?';

  @override
  String get winbackReasonExpensive => 'Túl drága';

  @override
  String get winbackReasonUnused => 'Nem használtam eleget';

  @override
  String get winbackReasonMissing => 'Hiányzott egy funkció';

  @override
  String get winbackReasonOtherApp => 'Találtam egy másik alkalmazást';

  @override
  String get winbackReasonElse => 'Valami más';

  @override
  String get ctaSend => 'Küldés';

  @override
  String get ctaNotNow => 'Most nem';

  @override
  String get winbackCaption =>
      'Ez nem állítja vissza a csomagodat. Az áruházban fizethetsz elő újra.';

  @override
  String get ctaContinue => 'Folytatás';

  @override
  String get ctaClose => 'Bezárás';

  @override
  String get ovRestoreSuccessTitle => 'A Pro visszatért';

  @override
  String get ovRestoreSuccessBody =>
      'Megtaláltuk az előfizetésedet, és újra bekapcsoltuk ezen az eszközön.';

  @override
  String get ovRestoreEmptyTitle => 'Nincs mit visszaállítani';

  @override
  String get ovRestoreEmptyBody =>
      'Ehhez az áruházi fiókhoz nem tartozik aktív előfizetés.';

  @override
  String get ovRestoreOtherTitle => 'Ez a csomag másik fiókhoz tartozik';

  @override
  String get ovRestoreOtherBody =>
      'Ez az előfizetés már aktív egy másik BeaverTalk-fiókon.';

  @override
  String get ctaSignInThatAccount => 'Bejelentkezés azzal a fiókkal';

  @override
  String get ctaGetHelp => 'Segítségkérés';

  @override
  String get ovCharacterOfferTitle => 'Még nem állsz készen a Pro csomagra?';

  @override
  String get ovCharacterOfferBody =>
      'Válassz egy karaktert, és tartsd meg. Egyszeri vásárlás — nincs előfizetés, nincs megújulás.';

  @override
  String get rowOneCharacter => 'Egy karakter';

  @override
  String rowFromPrice(String price) {
    return 'már $price-tól';
  }

  @override
  String get rowYoursForever => 'Örökre a tiéd';

  @override
  String get rowNoRenewal => 'Nincs megújulás';

  @override
  String get rowWorksOnFree => 'Ingyenes csomagon is működik';

  @override
  String get rowYes => 'Igen';

  @override
  String get ctaSeeCharacters => 'Karakterek megtekintése';

  @override
  String get ovNotEligibleTitle => 'Nincs mit lemondani';

  @override
  String get ovNotEligibleBody =>
      'Ingyenes csomagon vagy. Ezen a fiókon nincs aktív előfizetés.';

  @override
  String get ovCancelDownsellTitle => 'Mielőtt elmész';

  @override
  String get ovCancelDownsellBody =>
      'A lemondás az áruházban történik. Két dolog, amit érdemes tudni.';

  @override
  String get rowPayYearlyInstead => 'Fizess inkább évente';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'Havi $price';
  }

  @override
  String get rowCharactersYouBought => 'A megvásárolt karaktereid';

  @override
  String get rowProRunsUntil => 'Pro érvényes eddig';

  @override
  String get ctaSwitchToYearly => 'Váltás évesre';

  @override
  String get ctaContinueToStore => 'Tovább az áruházba';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Éves fizetéssel $saved megtakarítás';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Két hónapja vagy Pro csomagon. Az éves csomag olcsóbban jön ki.';

  @override
  String get rowYouSave => 'Megtakarításod';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Éves';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Havi, egy évig';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Váltás havira';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Az éves csomagod $date napjáig érvényes. A havi számlázás a következő napon indul.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Havi számlázás indul';

  @override
  String get rowMonthlyLabel => 'Havi';

  @override
  String get rowYearlyWorkedOut => 'Az éves így jött ki';

  @override
  String get ctaSwitchToMonthly => 'Váltás havira';

  @override
  String get ovRefundHelpTitle => 'A visszatérítéseket az áruház kezeli';

  @override
  String get ovRefundHelpBody =>
      'Mi magunk nem tudunk visszatéríteni. Minden kérelmet az áruház bírál el.';

  @override
  String get ctaGoToStore => 'Ugrás az áruházba';

  @override
  String get ovTrialEndingTitle => 'A próbaidőszakod holnap véget ér';

  @override
  String get ovTrialEndingBody =>
      'A Max tovább fut, hacsak le nem mondod. Íme, mi történik.';

  @override
  String get rowTrialEnds => 'Próba vége';

  @override
  String get rowFirstCharge => 'Első levonás';

  @override
  String get rowThenMonthly => 'Utána havonta';

  @override
  String get ctaCancelInStore => 'Lemondás az áruházban';

  @override
  String get ovTrialStartTitle => '7 nap Max, ingyen';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Ingyenes $date napjáig. Utána havi $price, hacsak le nem mondod az áruházban.';
  }

  @override
  String get ctaStart7Days => '7 nap ingyen indítása';

  @override
  String get ovOtoTitle => 'Még egy dolog, mielőtt elkezded';

  @override
  String get ovOtoBody =>
      'Jó döntés — a korlátlan hívások már működnek. Ugyanez a Pro éves fizetéssel olcsóbb.';

  @override
  String get ovFailedDeclinedTitle => 'A kártyádat elutasították';

  @override
  String get ovFailedDeclinedBody =>
      'Az áruház nem tudta levonni az összeget. Semmit nem vontunk le.';

  @override
  String get ctaUpdatePaymentMethod => 'Fizetési mód frissítése';

  @override
  String get ovFailedCanceledTitle => 'Fizetés megszakítva';

  @override
  String get ovFailedCanceledBody =>
      'Továbbra is az Ingyenes csomagon vagy. Semmit nem vontunk le.';

  @override
  String get ovFailedStoreTitle => 'Valami hiba történt';

  @override
  String get ovFailedStoreBody =>
      'Nem értük el az áruházat. Semmit nem vontunk le.';

  @override
  String get ovAlreadyTitle => 'Már Pro csomagon vagy';

  @override
  String get ovAlreadyBody =>
      'Ehhez az áruházi fiókhoz aktív csomag tartozik. Nincs mit megvenni.';

  @override
  String get ctaSeeMySubscription => 'Előfizetésem megtekintése';

  @override
  String get subCancelTitle => 'Előfizetés lemondása';

  @override
  String subCancelBody(String date) {
    return 'A Pro $date napjáig érvényes. Utána Ingyenesre váltasz.';
  }

  @override
  String get subWhatYouLose => 'Amit elveszítesz';

  @override
  String get benefitCalls15 => 'Korlátlan hívások, egyenként 15 perc';

  @override
  String get benefitScoring => 'Betűnként értékelt kiejtés';

  @override
  String get benefitEveryCharacter => 'Minden karakter, korlátlanul';

  @override
  String get ctaKeepPro => 'Maradjon a Pro';

  @override
  String get subPaymentTitle => 'Fizetés frissítése';

  @override
  String get subPaymentBody =>
      'Nem sikerült levonni a díjat. A Pro a türelmi időszak alatt tovább működik.';

  @override
  String get subHowToFix => 'Így javíthatod';

  @override
  String get fixStep1 =>
      'Nyisd meg az áruházat, és frissítsd a fizetési módodat';

  @override
  String get fixStep2 => 'Gyere vissza — a csomagod automatikusan folytatódik';

  @override
  String get fixStep3 => 'Semmit nem vonunk le kétszer';

  @override
  String get subResubTitle => 'Újra-előfizetés';

  @override
  String subResubBody(String date) {
    return 'A Pro $date napján ér véget. Kapcsold vissza az automatikus megújítást, és semmi sem változik.';
  }

  @override
  String get subWhatYouKeep => 'Amit megtartasz';

  @override
  String get ctaTurnItBackOn => 'Visszakapcsolás';

  @override
  String get flTodayTitle => 'Ez a mai hívás';

  @override
  String get flTodayBody => 'Folytasd ott, ahol abbahagytad — most azonnal.';

  @override
  String get flCheckTitle => 'Ez a mai ellenőrzés';

  @override
  String get flCheckBody =>
      'Az Ingyenes csomagon napi egy ellenőrzés jár. A Pro korlátlanná teszi.';

  @override
  String get flBenefitCalls =>
      'Korlátlan hívások a Pro csomaggal · egyenként 15 perc';

  @override
  String get flBenefitChecks => 'Korlátlan kiejtésellenőrzés a Pro csomaggal';

  @override
  String flCaption(String price) {
    return 'Havi $price · bármikor lemondható';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used / $limit felhasználva';
  }

  @override
  String get ctaMaybeTomorrow => 'Talán holnap';

  @override
  String get accountSection => 'Fiók';

  @override
  String get nicknameLabel => 'Becenév';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Bejelentkezési mód';

  @override
  String get joinedLabel => 'Csatlakozott';

  @override
  String get editNicknameTitle => 'Becenév szerkesztése';

  @override
  String get nicknameRule => '2–12 karakter. Betűk és számok. Csak angolul';

  @override
  String get ctaSave => 'Mentés';

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
  String get paywallLeaveTitle => 'Ha most kilépsz, nem lesz előfizetésed';

  @override
  String get paywallLeaveBody =>
      'Az előnyök közvetlenül a fizetés után nyílnak meg. Bármikor visszatérhetsz a Saját oldalról.';

  @override
  String get ctaKeepLooking => 'Nézem tovább';

  @override
  String get ctaLeaveAnyway => 'Kilépek mégis';

  @override
  String get iapCharacterSuccessTitle => 'Új barát csatlakozott!';

  @override
  String get iapCharacterSuccessBody =>
      'Ez a karakter örökre a tiéd — csomagváltásnál is megmarad, a Vásárlások visszaállítása pedig bármely eszközön visszahozza.';

  @override
  String get iapCharacterFailedBody =>
      'A vásárlás nem sikerült. Nem történt terhelés — próbáld újra.';

  @override
  String get noAccentDataTitle => 'Még nincs hanglejtési adat';

  @override
  String get noAccentDataBody =>
      'Beszélgess tovább, és összegyűlnek a hanglejtésed jellemzői.';

  @override
  String get noLevelYetTitle => 'Még nincs szint';

  @override
  String get noLevelYetBody =>
      'Fejezd be az első hívásod, hogy megkapd a szinted.';

  @override
  String get noPronunciationDataTitle => 'Még nincs kiejtési adat';

  @override
  String get noPronunciationDataBody =>
      'A hívásban elmondott mondataidból elemezzük a kiejtésed.';

  @override
  String get noCharacterNote => 'Még nem mondott semmit';

  @override
  String get noPhonemesYet => 'Még nincs elemezhető hang';

  @override
  String get noSentencesYet => 'Még nincs elemezhető mondat';

  @override
  String get takeLevelTest => 'Szintfelmérő kitöltése';

  @override
  String get reviewToSeeScore => 'Ismételd át, hogy lásd a kiejtési pontszámod';

  @override
  String get playAgain => 'Újra';

  @override
  String get difficultySlow => 'Lassú';

  @override
  String get difficultyNormal => 'Normál';

  @override
  String get difficultyFast => 'Gyors';

  @override
  String get difficultyLabel => 'Nehézség';

  @override
  String get connected => 'Csatlakozva';

  @override
  String get unlockedWithMax => 'Elérhető a Maxszal';

  @override
  String get fcEndedTitle => 'A díjmentes hívásod véget ért';

  @override
  String get fcEndedBody =>
      'A díjmentes hívások legfeljebb 5 percig tartanak\nElőfizetéssel tovább beszélgethetsz';

  @override
  String get ctaSubscribeKeepTalking => 'Előfizetés és beszélgetés folytatása';

  @override
  String get kgTitle => 'Folytatjuk?';

  @override
  String get kgBody =>
      'A hívások 5 perces szakaszokban folytatódnak.\nMinden alkalommal rákérdezünk.';

  @override
  String get ctaKeepTalking => 'Beszélgetés folytatása';

  @override
  String get callModeSheetTitle => 'Hogyan szeretnél beszélgetni?';

  @override
  String get callModeSheetSubtitle => 'Azonnal érvénybe lép ebben a hívásban';

  @override
  String get callModeFreeTalk => 'Szabad beszélgetés';

  @override
  String get callModeFreeTalkDesc => 'Beszélj javítások nélkül';

  @override
  String get callModeStudy => 'Tanulás';

  @override
  String get callModeStudyDesc => 'Egyszerre egy kifejezést tanulj';

  @override
  String get callModeChange => 'Mód váltása';

  @override
  String get callModeKeep => 'Most nem';

  @override
  String get callExitTitle => 'Befejezed a hívást?';

  @override
  String get callExitSubtitle => 'A most befejezés is felhasznál egy hívást';

  @override
  String get callExitKeep => 'Beszélgetés folytatása';

  @override
  String get callExitConfirm => 'Hívás befejezése';

  @override
  String get callMicMute => 'Némítás';

  @override
  String get callMicUnmute => 'Némítás feloldása';

  @override
  String get callPushToTalk => 'Tartsd nyomva a beszédhez';

  @override
  String get callFreeEndedTitle => 'Az ingyenes hívásod véget ért';

  @override
  String get callFreeEndedCta => 'Fizess elő és beszélgess tovább';

  @override
  String get callKeepGoingTitle => 'Folytatjuk?';

  @override
  String get callKeepGoingSubtitle =>
      'A hívások 5 perces szakaszokban folytatódnak. Minden alkalommal rákérdezünk.';
}
