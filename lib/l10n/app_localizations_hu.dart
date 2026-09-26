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
  String get callDailyLimit => 'Elhasználtad a mai tanulási idődet.';

  @override
  String get callAlreadyInCall => 'Már hívásban vagy.';

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
  String get callRatingBody =>
      'Az értékelésed segít, hogy legközelebb jobban beszélgessünk.';

  @override
  String get callRatingSubmit => 'Küldés';

  @override
  String get callRatingSkip => 'Kihagyás';

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
  String get alarmAdd => 'Ébresztő hozzáadása';

  @override
  String get alarmEdit => 'Ébresztő szerkesztése';

  @override
  String get alarmEveryDay => 'Minden nap';

  @override
  String get alarmWeekdays => 'Hétköznap';

  @override
  String get alarmWeekend => 'Hétvégén';

  @override
  String get alarmNoRepeat => 'Soha';

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
  String get alarmModeLearnSub => 'Tananyag kifejezéseinek gyakorlása';

  @override
  String get alarmModeChatSub => 'Beszélgetés bármiről';

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
  String get newExpressions => 'Új kifejezések';

  @override
  String get analysisPrepNote => 'Átnézzük a mai hívást.';

  @override
  String get analysisPrepNoteHint => 'Hamarosan itt jelenik meg egy üzenet';

  @override
  String get analysisPrepTitle => 'A hód kártyákat készít a mai kifejezésekből';

  @override
  String get analysisPrepSub => 'Amint elkészülnek, itt jelennek meg.';

  @override
  String get analysisPrepStepSave => 'Beszélgetés mentése';

  @override
  String get analysisPrepStepCards => 'Kifejezéskártyák készítése';

  @override
  String get analysisPrepStateDone => 'Kész';

  @override
  String get analysisPrepStateWorking => 'Folyamatban';

  @override
  String get analysisPrepStateWaiting => 'Várakozik';

  @override
  String get usedExpressions => 'Az általad használt kifejezések';

  @override
  String quizExpressionsCount(int count) {
    return 'Megtanult kifejezések $count';
  }

  @override
  String get quizPassed => 'Eltaláltad';

  @override
  String get quizFailed => 'Nézd át újra';

  @override
  String get quizPending => 'Legközelebb folytatjuk';

  @override
  String get analysisResult => 'Elemzés eredménye';

  @override
  String get noNewExpressions =>
      'Ebből a beszélgetésből nincsenek új kifejezések.';

  @override
  String get practice => 'Gyakorlás';

  @override
  String get analysisNativeLabel => 'Anyanyelvi';

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
  String get navCall => 'Hívás';

  @override
  String get homeCourseExpression => 'Kifejezések';

  @override
  String get homeCourseFreetalk => 'Beszélgetés';

  @override
  String homeExpressionsLeft(int count) {
    return 'Még $count kifejezés a beszélgetésig';
  }

  @override
  String get homeFreetalkNote => 'Használd a tanultakat és beszélj szabadon';

  @override
  String get homeTalkTitle => 'Mi történt ma?';

  @override
  String get homeTalkNote => 'Beszélgess szabadon, és tanulj közben.';

  @override
  String get homeModeLearn => 'Tanulás';

  @override
  String get homeModeTalk => 'Beszélgetés';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nap egymás után',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Tanulási naptár';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nap egymás után',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Legjobb sorozat: $count nap',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Hívásidő';

  @override
  String get streakMetricLearned => 'Kifejezések';

  @override
  String get streakMetricWords => 'Kimondott szavak';

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
      other: '$count perc',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'Ezen a napon nem volt hívás.';

  @override
  String get homeLevelPending => 'Szint nincs meg';

  @override
  String get homeNoLevelTitle => 'Még nincs szinted';

  @override
  String get homeNoLevelNote => 'Fejezd be az első hívást, és megkapod';

  @override
  String get homeCurriculumPendingBadge => 'Hamarosan';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'A(z) $language tanmenet készül';
  }

  @override
  String get homeCurriculumPendingNote =>
      'A hívásokban általános kifejezéseket gyakorolsz';

  @override
  String get myPage => 'Saját oldal';

  @override
  String get languageSaveFailed => 'Nem sikerült elmenteni a nyelvedet.';

  @override
  String get accountDeleteFailed => 'Nem sikerült törölni a fiókodat.';

  @override
  String get changeAvatar => 'Avatar módosítása';

  @override
  String get avatarUseNow => 'Használat most';

  @override
  String get avatarPurchaseFailed => 'A vásárlás nem sikerült';

  @override
  String avatarPromoTitle(int percent) {
    return 'Csak ma · $percent% kedvezmény';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'Még $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'Még $days nap $time';
  }

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
  String pricePerMonth(String price) {
    return '$price / hó';
  }

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
      'A kamera és a mikrofon előkészítése folyamatban.';

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
  String accentShareText(String country) {
    return 'A BeaverTalkkal tanulok koreaiul – a koreai akcentusom így hangzik: $country! 🦫 Találd meg a saját akcentusodat, és tanulj velem: https://beavertalk.im';
  }

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
  String get onboardingLevelTestCta => 'Szintfelmérő kitöltése';

  @override
  String get pronunciation => 'Kiejtés';

  @override
  String get fluency => 'Folyékonyság';

  @override
  String get rhythm => 'Ritmus';

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
  String get freePlanCallLimit => 'Napi 5 perc hívás';

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
  String get levelTestOncePerDay =>
      'A szintfelmérőt naponta egyszer töltheted ki. Próbáld újra holnap.';

  @override
  String get levelRetakeTitle => 'Újra kitöltöd a szintfelmérőt?';

  @override
  String get levelRetakeBody =>
      'Ha újra kitöltöd, a haladásod a szint első leckéjére ugrik vissza – akkor is, ha ugyanazt a szintet kapod. A megtanult kifejezések és a híváselőzmények megmaradnak.';

  @override
  String get levelRetakeKeep => 'Haladás megtartása';

  @override
  String get levelRetakeConfirm => 'Teszt újra';

  @override
  String get practicePronunciation => 'Kiejtés gyakorlása';

  @override
  String get analysisNoScoreReview =>
      'Gyakorold a mondatokat, és megkapod a kiejtési pontszámod';

  @override
  String get analysisNoScoreEmpty => 'Nincs értékelhető mondat';

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
  String get billingCompareAllPlans => 'Csomagok összehasonlítása';

  @override
  String get billingBuyACharacter => 'Karakter vásárlása';

  @override
  String get billingRestorePurchases => 'Vásárlások visszaállítása';

  @override
  String get billingRedeemCode => 'Kód beváltása';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Napi 15 perc videóhívás';

  @override
  String get premiumBulletAnalysis => 'Teljes kiejtéselemzés';

  @override
  String get premiumBulletWeakSounds => 'Nehéz hangok gyakorlása a nyelvedhez';

  @override
  String get noteCharactersSeparate =>
      'A karakterek külön kaphatók. A megvásárolt karakterek a tieid.';

  @override
  String get ctaGetPremium => 'Premium beszerzése';

  @override
  String get planMaxTrial => 'Premium próba';

  @override
  String get freePlanPriceLine => '\$0.00 — napi 5 perc hívás';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount havonta';
  }

  @override
  String freeUntilDate(String date) {
    return 'Ingyenes eddig: $date';
  }

  @override
  String get todaysCalls => 'Mai hívásidő';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit percből $used felhasználva';
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
  String get bannerMaxUpsellTitle => 'Szemtől szemben a Premiummal';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Videóhívás · napi 15 perc · havi $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Válts évesre';

  @override
  String get bannerPaymentFailedTitle => 'Nem sikerült levonni a díjat';

  @override
  String get bannerPaymentFailedSub =>
      'Frissítsd a fizetést az áruházban, hogy a Premium megmaradjon';

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
  String noteTrialEnds(String date) {
    return 'A próbaidőszakod $date napján ér véget. Ha előtte lemondod az áruházban, semmit nem vonunk le.';
  }

  @override
  String get noteGrace =>
      'Az előnyök a türelmi időszak alatt is működnek. A lemondást az alkalmazás soha nem akadályozza.';

  @override
  String get noteHold =>
      'A Premium szünetel, amíg a fizetés át nem megy. A karaktereid és a haladásod biztonságban vannak.';

  @override
  String noteEnding(String date) {
    return 'A csomagod hamarosan véget ér. Az előnyök $date napjáig működnek, utána Ingyenesre váltasz. Bármikor újra előfizethetsz.';
  }

  @override
  String get trialExpiredTitle => 'A Premium próbád véget ért';

  @override
  String get trialExpiredSub => 'Most az Ingyenes csomagon vagy';

  @override
  String get seePlans => 'Csomagok megtekintése';

  @override
  String get currentPlanTitle => 'Jelenlegi csomag';

  @override
  String get perMonthUnit => 'havonta';

  @override
  String get planTaglineFree => 'Napi 5 perc hívás. Ajándékba.';

  @override
  String get bulletProCorrections => 'Az anyanyelvedre szabott javítások';

  @override
  String get bulletFreeCall => 'Napi 5 perc hanghívás';

  @override
  String get bulletFreeCheck => 'Teljes elemzés az első 3 hívásodhoz';

  @override
  String get bulletFreeCharacter => 'Két karakter kezdésnek';

  @override
  String get ctaTurnOnVideo => 'Videó bekapcsolása';

  @override
  String get noteCallLength =>
      'Premium: napi 15 perc — ezen belül annyiszor hívhatsz, ahányszor csak akarsz.';

  @override
  String get paywallProTitle1 => 'A koreai barátod,';

  @override
  String get paywallProTitle2 => 'aki hajnali 3-kor is fent van';

  @override
  String get paywallLimitHeadline => 'A Premiummal napi 15 perc hívásod van.';

  @override
  String get limitBannerCallTitle => 'Elfogyott a mai hívásidőd';

  @override
  String get limitBannerCallSub => 'Az Ingyenes csomag napi 5 perc hívást ad';

  @override
  String get limitBannerCheckTitle => 'Ez volt a mai ellenőrzés';

  @override
  String get limitBannerCheckSub =>
      'Az Ingyenes csomag napi egy ellenőrzést ad';

  @override
  String get bulletProCharactersForever =>
      'A megvásárolt karakterek örökre a tieid';

  @override
  String get paywallMaxTitle =>
      'Most már videón, szemtől szemben beszélgethetsz.';

  @override
  String paywallTutorCompare(String price) {
    return 'Egy óra tanárral \$25. Egy hónap Premium $price.';
  }

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
  String ctaCaptionMaxYearly(String price) {
    return 'Évi $price · bármikor lemondható az áruházban';
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
  String get processingTitle => 'Vásárlás megerősítése';

  @override
  String get processingSub => 'Ez általában néhány másodpercet vesz igénybe.';

  @override
  String get successProTitle => 'Premium csomagon vagy.';

  @override
  String get successMaxTitle => 'Most már látod, kivel beszélsz.';

  @override
  String get successMaxSub =>
      'A videóhívások bekapcsolva. Koppints a videó gombra bármelyik hívásban.';

  @override
  String get ctaStartAVideoCall => 'Videóhívás indítása';

  @override
  String get ctaSeeYourSubscription => 'Előfizetésed megtekintése';

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
  String get ctaKeepMax => 'Maradjon a Premium';

  @override
  String get winbackSkip => 'Kihagyás';

  @override
  String get winbackTitle => 'A Premium csomagod véget ért';

  @override
  String get winbackSub =>
      'Most az Ingyenes csomagon vagy — napi 5 perc hívás.';

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
  String get ovRestoreSuccessTitle => 'A Premium visszatért';

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
  String get ovCharacterOfferTitle =>
      'Még nem állsz készen a Premium csomagra?';

  @override
  String get ovCharacterOfferBody =>
      'Válassz egy karaktert, és tartsd meg. Egyszeri vásárlás — nincs előfizetés, nincs megújulás.';

  @override
  String get rowOneCharacter => 'Egy karakter';

  @override
  String rowFromPrice(String price) {
    return '$price darabonként';
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
  String get rowProRunsUntil => 'Premium érvényes eddig';

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
      'Az éves csomag olcsóbb, mint a havi fizetés.';

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
      'A Premium tovább fut, hacsak le nem mondod. Íme, mi történik.';

  @override
  String get rowTrialEnds => 'Próba vége';

  @override
  String get rowFirstCharge => 'Első levonás';

  @override
  String get rowThenMonthly => 'Utána havonta';

  @override
  String get ctaCancelInStore => 'Lemondás az áruházban';

  @override
  String get ovTrialStartTitle => '7 nap Premium, ingyen';

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
      'Jó döntés. Ugyanaz a Premium kevesebbe kerül éves fizetéssel.';

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
  String get ovAlreadyTitle => 'Már Premium csomagon vagy';

  @override
  String get ovAlreadyBody =>
      'Ehhez az áruházi fiókhoz aktív csomag tartozik. Nincs mit megvenni.';

  @override
  String get ctaSeeMySubscription => 'Előfizetésem megtekintése';

  @override
  String get subCancelTitle => 'Előfizetés lemondása';

  @override
  String subCancelBody(String date) {
    return 'A Premium $date napjáig érvényes. Utána Ingyenesre váltasz.';
  }

  @override
  String get subWhatYouLose => 'Amit elveszítesz';

  @override
  String get benefitScoring => 'Betűnként értékelt kiejtés';

  @override
  String get benefitEveryMetric => 'Minden mutató, minden mondat';

  @override
  String get subPaymentTitle => 'Fizetés frissítése';

  @override
  String get subPaymentBody =>
      'Nem sikerült levonni a díjat. A Premium a türelmi időszak alatt tovább működik.';

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
    return 'A Premium $date napján ér véget. Kapcsold vissza az automatikus megújítást, és semmi sem változik.';
  }

  @override
  String get subWhatYouKeep => 'Amit megtartasz';

  @override
  String get ctaTurnItBackOn => 'Visszakapcsolás';

  @override
  String get flTodayTitle => 'Elfogyott a mai hívásidőd';

  @override
  String get flTodayBody => 'Folytasd ott, ahol abbahagytad — most azonnal.';

  @override
  String get flCheckTitle => 'Ez a mai ellenőrzés';

  @override
  String get flCheckBody =>
      'Az Ingyenesben napi egy ellenőrzés van. A Premium a teljes elemzést adja.';

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
  String get emailLabel => 'E-mail';

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
  String get subscriptionRow => 'Előfizetés';

  @override
  String get iapSuccessTitle => 'Vásárlás kész';

  @override
  String iapSuccessBody(String name) {
    return 'A(z) $name avatar örökre a tiéd.\nA nyugta megerősítése után azonnal érvénybe lép.';
  }

  @override
  String get ctaGoHome => 'Kezdőlapra';

  @override
  String get ctaUseNow => 'Használom most';

  @override
  String get iapFailTitle => 'A fizetés nem sikerült';

  @override
  String get iapFailBody => 'Újra megpróbálhatod';

  @override
  String get paywallGuardTitle => 'Ingyenesen is folytathatod';

  @override
  String get paywallGuardBody => 'Továbbra is napi 5 perc hívásod van.';

  @override
  String get ctaMaybeLater => 'Talán később';

  @override
  String get winbackOfferBadge => '50% kedvezmény az első hónapra';

  @override
  String get winbackOfferTitle => 'Örülünk, hogy visszatértél';

  @override
  String get ctaGetHalfOff => 'Kérem az 50% kedvezményt';

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
  String get unlockedWithMax => 'A csomagod része';

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
      'A hívás rövid szakaszokban folytatódik.\nMinden alkalommal újra megkérdezzük.';

  @override
  String get pcEndedTitleToday => 'Mára fejezzük be a hívást.';

  @override
  String get pcEndedBodyToday =>
      'Ismételd át, amiről beszéltünk, és hívj holnap újra!';

  @override
  String get pcEndedTitle => 'Fejezzük be ezt a hívást.';

  @override
  String get pcEndedBody => 'Ismételd át, amiről beszéltünk, és hívj újra!';

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
  String get callExitSubtitle =>
      'Az eddig beszélt idő így is beleszámít a mai keretbe';

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

  @override
  String get articulationSelectedWord => 'Kiválasztott szó';

  @override
  String get articulationYouSaid => 'A kiejtésed';

  @override
  String get articulationTargetSound => 'Cél';

  @override
  String get reportEntry => 'Jelentés';

  @override
  String get reportTitle => 'Jelentés';

  @override
  String get reportPrompt => 'Mi volt a probléma?';

  @override
  String get reportGuide =>
      'Írd meg, az MI-karakter melyik tartalma zavart. Minden bejelentést átnézünk.';

  @override
  String get reportReasonSexual => 'Szexuális tartalom';

  @override
  String get reportReasonHate => 'Gyűlölet vagy diszkrimináció';

  @override
  String get reportReasonViolence => 'Erőszakos vagy fenyegető tartalom';

  @override
  String get reportReasonSelfHarm => 'Önbántalmazásra biztat';

  @override
  String get reportReasonMisinfo => 'Téves információ';

  @override
  String get reportReasonOther => 'Egyéb probléma';

  @override
  String get reportDetailHint => 'Írd le, mi történt (nem kötelező)';

  @override
  String get reportSubmit => 'Bejelentés küldése';

  @override
  String get reportDoneTitle => 'Megkaptuk a bejelentésed';

  @override
  String get reportDoneBody =>
      'Átnézzük, és ha kell, intézkedünk. Köszönjük, hogy segítesz biztonságban tartani a BeaverTalkot.';

  @override
  String get reportFailed =>
      'Nem sikerült elküldeni a bejelentést. Próbáld újra.';

  @override
  String get hwTitle => 'Házi feladat';

  @override
  String get hwJoinCodeTitle => 'Add meg az osztálykódod';

  @override
  String get hwJoinCodeSubtitle => 'Ez a tanárodtól kapott 6 karakteres kód';

  @override
  String get hwJoinCodeLabel => 'Osztálykód';

  @override
  String get hwJoinCodeHelp => 'A kód nem érzékeny a kis- és nagybetűkre';

  @override
  String get hwJoinConfirmTitle => 'Ez a megfelelő osztály?';

  @override
  String get hwJoinConfirmSubtitle => 'Ha nem, ellenőrizd újra a kódot';

  @override
  String get hwJoinFieldInstitution => 'Intézmény';

  @override
  String get hwJoinFieldTeacher => 'Tanár';

  @override
  String get hwJoinFieldLearners => 'Tanulók';

  @override
  String get hwJoinFieldTerm => 'Időszak';

  @override
  String get hwJoinConfirmNote =>
      'Az osztály neve pontosan úgy jelenik meg, ahogy a tanárod írta. Nem fordítjuk le.';

  @override
  String get hwJoinConfirmYes => 'Igen, ez az';

  @override
  String get hwJoinConfirmRetry => 'Kód újra megadása';

  @override
  String get hwJoinProfileTitle => 'Milyen nevet használsz az osztályban?';

  @override
  String get hwJoinProfileSubtitle => 'A tanárod ezt veti össze a névsorral';

  @override
  String get hwJoinNameLabel => 'Név';

  @override
  String get hwJoinNameHelp => 'Eltérhet az appban használt nevedtől';

  @override
  String get hwJoinStudentNoLabel => 'Tanulói azonosító (nem kötelező)';

  @override
  String get hwJoinStudentNoHelp => 'A tanárod ezzel veti össze a névsort';

  @override
  String get hwJoinConsentTitle => 'Amit a tanárod lát';

  @override
  String get hwJoinConsentSubtitle =>
      'Az osztályhoz való csatlakozáshoz hozzájárulás szükséges';

  @override
  String get hwJoinConsentSharedHeading => 'Megosztva a tanároddal';

  @override
  String get hwJoinConsentShared1 => 'Osztály neve és tanulói azonosító';

  @override
  String get hwJoinConsentShared2 => 'Elkészítetted-e a házi feladatot';

  @override
  String get hwJoinConsentShared3 => 'A teljesített és elrontott mondatok';

  @override
  String get hwJoinConsentShared4 => 'A feladathívás hossza és összefoglalója';

  @override
  String get hwJoinConsentNotSharedHeading => 'Nincs megosztva';

  @override
  String get hwJoinConsentNotShared1 => 'E-mail és telefonszám';

  @override
  String get hwJoinConsentNotShared2 => 'Appbeli név, profil és karakter';

  @override
  String get hwJoinConsentNotShared3 => 'Állampolgárság és anyanyelv';

  @override
  String get hwJoinConsentNotShared4 =>
      'Az osztályon kívüli hívások és tanulás';

  @override
  String get hwJoinConsentNotShared5 => 'Előfizetési és fizetési adatok';

  @override
  String get hwJoinConsentAgree => 'Elfogadom a fentieket';

  @override
  String get hwJoinConsentCta => 'Elfogadom és csatlakozom';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Csatlakoztál ehhez: $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count feladat vár rád';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Még nincs feladat';

  @override
  String get hwJoinDoneNextDue => 'Következő határidő';

  @override
  String get hwJoinDoneRosterName => 'A neved az osztályban';

  @override
  String get hwJoinDoneCta => 'Házi feladatok megtekintése';

  @override
  String get hwJoinErrorNotFound => 'Nem találtuk ezt a kódot';

  @override
  String get hwJoinErrorNotFoundBody =>
      'Kérjük, ellenőrizd újra a hat számjegyet.';

  @override
  String get hwJoinErrorExpired => 'Ez a kód lejárt';

  @override
  String get hwJoinErrorExpiredBody => 'Kérj új kódot a tanárodtól.';

  @override
  String get hwJoinErrorFull => 'Az osztály megtelt';

  @override
  String get hwJoinErrorFullBody => 'Kérjük, szólj a tanárodnak.';

  @override
  String get hwJoinFailed =>
      'Nem sikerült csatlakozni. Próbáld újra egy pillanat múlva.';

  @override
  String get hwSectionInProgress => 'Folyamatban';

  @override
  String get hwSectionUpcoming => 'Közelgő';

  @override
  String get hwSectionDone => 'Kész';

  @override
  String get hwLeaveClassLink => 'Kilépés az osztályból';

  @override
  String get hwListEmptyTitle => 'Még nincs házi feladat';

  @override
  String get hwListEmptyBody => 'Itt jelenik meg, amint a tanárod kiadja.';

  @override
  String get hwListFailed => 'Nem sikerült betölteni a házi feladataidat.';

  @override
  String get hwRetry => 'Újra';

  @override
  String get hwBadgeDone => 'Kész';

  @override
  String get hwBadgeOverdue => 'Nincs beadva';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Nincs beadva, $days nap késés';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Ma esedékes';

  @override
  String get hwActivitySpeaking => 'Beszéd';

  @override
  String get hwActivityConversation => 'Beszélgetés';

  @override
  String get hwActivityWorkbook => 'Munkafüzet';

  @override
  String hwChapterLabel(String chapter) {
    return '$chapter. fejezet';
  }

  @override
  String get hwTaskSpeakingDesc => 'Nézd meg a kiejtési pontszámodat';

  @override
  String get hwTaskConversationDesc =>
      'Használd a tanultakat valódi beszélgetésben';

  @override
  String get hwConversationOnce =>
      'A beszélgetés házi feladatonként egyszer végezhető el.';

  @override
  String get hwTaskWorkbookDesc => 'Gyakorolj írással a munkafüzetben';

  @override
  String get hwCtaStudy => 'Kezdés';

  @override
  String get hwCtaResult => 'Eredmény megtekintése';

  @override
  String get hwCtaDownload => 'Letöltés';

  @override
  String get hwSpeakingNoScore => 'Még nem csináltad meg a beszédfeladatot';

  @override
  String get hwWorkbookUnavailable => 'A munkafüzet fájlja még nem érhető el.';

  @override
  String get hwDetailClosed => 'Ez a feladat lezárult. Már nem tudsz beadni.';

  @override
  String get hwLeaveTitle => 'Kilépsz az osztályból?';

  @override
  String get hwLeaveBody =>
      'A tanárod többé nem látja a házi feladataid eredményeit.';

  @override
  String get hwLeaveConfirm => 'Kilépés';

  @override
  String get hwLeaveCancel => 'Maradok';

  @override
  String get hwLeaveFailed => 'Nem sikerült kilépni az osztályból.';

  @override
  String get hwMyClass => 'Az osztályom';

  @override
  String get hwClassEmptyTitle => 'Még nem csatlakoztál osztályhoz';

  @override
  String get hwClassEmptySubtitle => 'Add meg a tanárodtól kapott kódot';

  @override
  String get hwClassEmptyCta => 'Osztálykód megadása';

  @override
  String get hwClassContinueCta => 'Tovább';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count feladat holnap esedékes';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return '$count beadatlan feladatod van';
  }

  @override
  String get hwSpeakingUnavailable =>
      'Ehhez a feladathoz még nincsenek mondatok.';

  @override
  String get hwBadgeClosed => 'Lezárva';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total mondatból $passed teljesítve';
  }

  @override
  String get challengeFirstWord => 'Első szó';

  @override
  String get challengeSeeAnalysis => 'Eredmények megtekintése';

  @override
  String get challengePaused => 'Szüneteltetve';

  @override
  String get challengePausedNote => 'Az időzítő és a felvétel együtt állt le.';

  @override
  String get challengeTimeLeft => 'Hátralévő idő';

  @override
  String get challengeScoreLabel => 'Pontszám';

  @override
  String get challengeResume => 'Folytatás';

  @override
  String get challengeBlockedTitle => 'A kamera nem használható';

  @override
  String get challengeBlockedNote =>
      'Kapcsold be a kamera- és mikrofonhozzáférést a Beállításokban.';

  @override
  String get challengeGoBack => 'Vissza';

  @override
  String get challengeOpenSettings => 'Beállítások megnyitása';

  @override
  String get saveDone => 'Elmentve a galériába';

  @override
  String get saveFailed => 'Nem sikerült menteni';

  @override
  String get saveDeniedNote => 'Fotókhoz való hozzáférés szükséges';

  @override
  String get callIncomingCallerFallback => 'Beaver oktató';

  @override
  String get callIncomingHandle => 'Koreai hívás';

  @override
  String get callMissedTitle => 'Nem fogadott hívás';

  @override
  String get callMissedChannelDescription =>
      'Szól, ha lemaradsz Beaver hívásáról.';

  @override
  String callMissedBody(String name) {
    return '$name hívni próbált';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'A hívások fogadásához értesítési engedély kell.';

  @override
  String get callNotifPermissionRequired =>
      'Engedélyezd az értesítéseket a Beállításokban.';

  @override
  String get callHintLockedTitle => 'Tanulás módban nem érhetők el tippek';

  @override
  String get wsTitle => 'Nehéz hangok';

  @override
  String get wsToList => 'Vissza a listához';

  @override
  String get wsNext => 'Tovább';

  @override
  String get wsRetry => 'Újra';

  @override
  String get wsDone => 'Kész';

  @override
  String get wsContinue => 'Folytatás';

  @override
  String get wsQuit => 'Kilépés';

  @override
  String get wsRetryLater => 'Kérjük, próbáld újra egy pillanat múlva.';

  @override
  String get wsMissingTitle => 'Nem találtuk ezt a hangot';

  @override
  String get wsMissingBody => 'Kérjük, válaszd ki újra a listából.';

  @override
  String get wsListLoadFailed => 'Nem sikerült betölteni a listát';

  @override
  String get wsLessonLoadFailed => 'Nem sikerült betölteni a leckét';

  @override
  String get wsNationalTitle => 'Az akcentusodhoz tartozó nehéz hangok';

  @override
  String get wsNationalPending => 'Kitöltjük, amint elemeztük az akcentusodat';

  @override
  String get wsNationalPicked => 'Az akcentuselemzésed alapján válogattuk';

  @override
  String get wsNationalEmptyBody =>
      'Beszélj még néhányat, és elemezzük az akcentusodat.';

  @override
  String get wsMineTitle => 'Az én nehéz hangjaim';

  @override
  String get wsMineSubtitle => 'A legutóbbi hívásaidban mért hangok';

  @override
  String get wsMineEmptyBody =>
      'Beszélj és ismételj, így gyűlnek a nehéz hangjaid.';

  @override
  String get wsNoDataYet => 'Még nincs adat';

  @override
  String get wsGoToCall => 'Hívás indítása';

  @override
  String get wsRule => 'Szabály';

  @override
  String get wsRecommended => 'Ajánlott';

  @override
  String get wsNotMeasured => 'Nincs mérés';

  @override
  String get wsStepUnderstand => 'Megértés';

  @override
  String get wsStepWords => 'Szavak';

  @override
  String get wsStepSentence => 'Mondat';

  @override
  String get wsStepTest => 'Teszt';

  @override
  String get wsQuitTitle => 'Befejezed a gyakorlást?';

  @override
  String get wsQuitBody => 'Ha most kilépsz, ez a gyakorlás nem lesz elmentve.';

  @override
  String get wsHowToSound => 'Így képezd a hangot';

  @override
  String get wsPracticeWords => 'Szavak gyakorlása';

  @override
  String get wsPracticeSentence => 'Mondat gyakorlása';

  @override
  String get wsPracticeAgain => 'Még egyszer';

  @override
  String get wsStartTest => 'Záróteszt kitöltése';

  @override
  String get wsThisSentence => 'Ez a mondat';

  @override
  String get wsNoScoreNote => 'Ez a lépés nem kap pontot. Csak mondd utána.';

  @override
  String get wsListen => 'Hallgasd figyelmesen';

  @override
  String get wsSayNow => 'Most mondd utána';

  @override
  String get wsPracticeDone => 'Gyakorlás befejezve';

  @override
  String get wsPaused => 'Szüneteltetve';

  @override
  String get wsAudioFailed =>
      'Nem sikerült betölteni a hangot. Olvasd fel a szöveget.';

  @override
  String get wsReadAloud => 'Olvasd fel hangosan az alábbi mondatot';

  @override
  String get wsTapToStart => 'Koppints az indításhoz';

  @override
  String get wsTapWhenDone => 'Koppints, ha végeztél';

  @override
  String get wsScoring => 'Értékelés folyamatban';

  @override
  String get wsMicFailed => 'Nem sikerült megnyitni a mikrofont.';

  @override
  String get wsMicPermissionBody =>
      'Ezt a tesztet hangosan kell felolvasni, ezért kell a mikrofon. Engedélyezd a mikrofon-hozzáférést a Beállításokban.';

  @override
  String get wsNoSound => 'Nem hallottunk semmit. Megpróbálod újra?';

  @override
  String get wsScoreFailed =>
      'Az értékelés nem sikerült. Kérjük, próbáld újra.';

  @override
  String get wsSomethingWrong => 'Valami hiba történt.';

  @override
  String get wsLearnDone => 'Lecke befejezve';

  @override
  String get wsRetest => 'Új teszt';

  @override
  String get wsFirstMeasure => 'Első mérés';

  @override
  String get wsFinalTest => 'Záróteszt';

  @override
  String wsPoints(int score) {
    return '$score pont';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Előtte $score pont';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Cél $score pont';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Cél · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country akcentus';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count szó ismételve';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count mondatrész ismételve';
  }

  @override
  String get wsStartRecommended => 'Kezdd az ajánlott hanggal';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Kezdd ezzel: $label';
  }

  @override
  String get wsPointsUnit => 'pont';

  @override
  String get wsEnterFromMypage => 'Nehéz hangok gyakorlása';

  @override
  String wsGoalOnly(int score) {
    return 'Cél $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label hang';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Idézd fel ezt a formát, amikor előjön egy hívásban.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country – a beszélők által gyakran elrontott hangok';
  }
}
