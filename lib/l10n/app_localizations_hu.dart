// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

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
  String get pricePerMonth => '12,9 \$ / hó';

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
  String get loginKakaoSignInFailed => 'A Kakao bejelentkezés sikertelen volt.';

  @override
  String get loginContinueWithKakao => 'Folytatás Kakao fiókkal';

  @override
  String get loginContinueWithGoogle => 'Folytatás Google fiókkal';

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
  String get priceChangedTitle => 'Price changed';

  @override
  String priceChangedBody(String price) {
    return 'This item is now $price. Would you like to continue?';
  }
}
