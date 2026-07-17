// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Puhelu päättyi $duration';
  }

  @override
  String get callRatingPrompt => 'Millainen puhelu oli?';

  @override
  String get ratingBad => 'Ei kovin hyvä';

  @override
  String get ratingOkay => 'Ihan ok';

  @override
  String get ratingGood => 'Hyvä';

  @override
  String get goHome => 'Koti';

  @override
  String get viewAnalysis => 'Näytä analyysi';

  @override
  String get loadingShort => 'Ladataan…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Arvion lähettäminen epäonnistui: $message';
  }

  @override
  String get callInfoNotFound =>
      'Puhelutietoja ei löytynyt, analyysi ohitetaan.';

  @override
  String get tabRecords => 'Tallenteet';

  @override
  String get tabArchive => 'Arkisto';

  @override
  String get callHistory => 'Puheluhistoria';

  @override
  String get conversationRecord => 'Keskustelutallenne';

  @override
  String get noCallRecords => 'Ei vielä puhelutallenteita';

  @override
  String get noCallRecordsBody =>
      'Kun olet käynyt ensimmäisen puhelun tekoälyn kanssa,\ntallenteesi näkyvät täällä.';

  @override
  String get startCall => 'Aloita puhelu';

  @override
  String get recordsLoadError => 'Tallenteita ei voitu ladata';

  @override
  String get tryAgainLater => 'Yritä myöhemmin uudelleen.';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String get scheduleManagement => 'Aikataulu';

  @override
  String get alarms => 'Hälytykset';

  @override
  String get addSchedule => 'Lisää aikataulu';

  @override
  String get editSchedule => 'Muokkaa aikataulua';

  @override
  String get somethingWentWrong => 'Jotain meni pieleen';

  @override
  String get alarmsLoadError => 'Hälytyksiä ei voitu ladata';

  @override
  String get charactersLoadError => 'Hahmoja ei voitu ladata';

  @override
  String get noCharacters => 'Ei saatavilla olevia hahmoja';

  @override
  String get close => 'Sulje';

  @override
  String get repeat => 'Toista';

  @override
  String get callPartner => 'Hahmo';

  @override
  String get quickStart => 'Quick start';

  @override
  String get presetMorning => 'Morning routine';

  @override
  String get presetMorningSub => 'Weekdays 8:00';

  @override
  String get presetEvening => 'Evening wind-down';

  @override
  String get presetEveningSub => 'Every day 21:00';

  @override
  String get presetCustom => 'Custom';

  @override
  String get presetCustomSub => 'Your own';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× a week · $monthly calls a month';
  }

  @override
  String get alarmSummaryNone => 'Pick at least one day';

  @override
  String get partnerInUse => 'In use';

  @override
  String get partnerOwned => 'Owned';

  @override
  String get am => 'ap.';

  @override
  String get pm => 'ip.';

  @override
  String get save => 'Tallenna';

  @override
  String get conversation => 'Keskustelu';

  @override
  String get review => 'Kertaus';

  @override
  String get pronunciationChallenge => 'Ääntämishaaste';

  @override
  String get newExpressions => 'Uudet ilmaisut';

  @override
  String get analysisResult => 'Analyysin tulos';

  @override
  String get noNewExpressions =>
      'Tästä keskustelusta ei tullut uusia ilmaisuja.';

  @override
  String get practice => 'Harjoittele';

  @override
  String recentScore(int score) {
    return 'Viimeisin tulos $score %';
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
  String get analysisLoadError => 'Analyysin tulosta ei voitu ladata.';

  @override
  String get standardAudioNotReady =>
      'Mallilausunnan äänite ei ole vielä valmis.';

  @override
  String get standardAudioPlayError =>
      'Mallilausunnan äänitettä ei voitu toistaa.';

  @override
  String get selectACountry => 'Valitse maa';

  @override
  String get selectYourLanguage => 'Valitse kielesi';

  @override
  String get confirm => 'Vahvista';

  @override
  String get cancel => 'Peruuta';

  @override
  String get selectTime => 'Valitse aika';

  @override
  String get getStarted => 'Aloita';

  @override
  String get permissionTitle =>
      'Salli käyttöoikeudet\nsujuvaa kokemusta varten';

  @override
  String get permissionSubtitle =>
      'Vaaditut käyttöoikeudet ovat välttämättömiä palvelun käyttämiseksi.';

  @override
  String get permissionMicTitle => 'Mikrofoni (pakollinen)';

  @override
  String get permissionMicDesc =>
      'Tarvitaan puhumiseen tekoälyn kanssa englanniksi.';

  @override
  String get permissionNotifTitle => 'Ilmoitukset (valinnainen)';

  @override
  String get permissionNotifDesc =>
      'Lähetämme oppimismuistutuksia ja puheluaikatauluja.';

  @override
  String get micPermissionNeededTitle => 'Mikrofonin käyttöoikeus tarvitaan';

  @override
  String get micPermissionNeededBody =>
      'Puhuaksesi tekoälyn kanssa sinun täytyy sallia mikrofonin käyttö. Ota se käyttöön asetuksista.';

  @override
  String get openSettings => 'Avaa asetukset';

  @override
  String get connectionFailedTitle => 'Yhteys epäonnistui';

  @override
  String get connectionFailedBody =>
      'Tarkista verkkoyhteytesi\nja yritä uudelleen.';

  @override
  String get checkout => 'Kassa';

  @override
  String get pay => 'Maksa';

  @override
  String get orderSummary => 'Tilauksen yhteenveto';

  @override
  String get paymentMethod => 'Maksutapa';

  @override
  String get payMethodCard => 'Luotto- / pankkikortti';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Ärsyttävä majava-avatar';

  @override
  String get productTrait => 'Premium-hahmo · Ikuisesti sinun';

  @override
  String get amountItemPrice => 'Tuotteen hinta';

  @override
  String get amountDiscount => 'Alennus';

  @override
  String get amountTotal => 'Yhteensä';

  @override
  String get paymentCompleteTitle => 'Maksu suoritettu';

  @override
  String get paymentCompleteBody => 'Avatar on lisätty kokoelmaasi.';

  @override
  String get viewCollection => 'Näytä kokoelma';

  @override
  String get receiptItem => 'Tuote';

  @override
  String get receiptAmount => 'Summa';

  @override
  String get receiptMethod => 'Maksutapa';

  @override
  String get receiptDate => 'Päivämäärä';

  @override
  String get paymentFailedTitle => 'Maksu epäonnistui';

  @override
  String get paymentFailedBody =>
      'Maksuasi ei voitu käsitellä.\nYritä uudelleen.';

  @override
  String get freeCallEndingTitle => 'Ilmainen puhelusi on päättymässä';

  @override
  String get freeCallEndingBody =>
      'Tilaa jatkaaksesi keskustelua Majavan kanssa pidempään.';

  @override
  String get subscribe => 'Tilaa';

  @override
  String get endCall => 'Lopeta puhelu';

  @override
  String get callEnded => 'Puhelu on päättynyt.';

  @override
  String get connecting => 'Yhdistetään…';

  @override
  String get connectingHint => 'Tämä kestää yleensä alle 5 sekuntia';

  @override
  String get callConnectFailed => 'Puhelua ei voitu yhdistää.';

  @override
  String get saveSentenceFailed => 'Lausetta ei voitu tallentaa.';

  @override
  String get recordStartFailed => 'Nauhoitusta ei voitu käynnistää.';

  @override
  String get recordTooShort => 'Tallenne oli liian lyhyt. Yritä uudelleen.';

  @override
  String get gradingFailed => 'Pisteytys epäonnistui. Yritä uudelleen.';

  @override
  String get listenStandard => 'Kuuntele mallilausunta';

  @override
  String get saveSentence => 'Tallenna lause';

  @override
  String get unsaveSentence => 'Poista tallennettu lause';

  @override
  String get scoringPronunciation => 'Arvioidaan ääntämistäsi…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get noRecordingToPlay => 'Ei toistettavaa tallennetta.';

  @override
  String get myRecordingPlayError => 'Tallennettasi ei voitu toistaa.';

  @override
  String get next => 'Seuraava';

  @override
  String get endLearning => 'Lopeta harjoitus';

  @override
  String get navCalendar => 'Kalenteri';

  @override
  String get navCall => 'Puhelu';

  @override
  String get navStats => 'Tilastot';

  @override
  String get myPage => 'Oma sivu';

  @override
  String get languageSaveFailed => 'Kieltäsi ei voitu tallentaa.';

  @override
  String get accountDeleteFailed => 'Tiliäsi ei voitu poistaa.';

  @override
  String get changeAvatar => 'Vaihda avatar';

  @override
  String get avatarIntro =>
      'Ääni ja vaikeustaso vaihtelevat puhekumppanin mukaan.\nJotkin kumppanit voivat vaatia maksun.';

  @override
  String myPartnersOwned(int count) {
    return 'Omat kumppanit · $count kpl';
  }

  @override
  String get limitedDiscount => 'Rajoitetun ajan alennus';

  @override
  String get available => 'Saatavilla';

  @override
  String get inUse => 'Käytössä';

  @override
  String get owned => 'Omistuksessa';

  @override
  String get noCharactersToShow => 'Ei näytettäviä hahmoja';

  @override
  String get buy => 'Osta';

  @override
  String get noSavedSentences =>
      'Ei vielä tallennettuja lauseita.\nMerkitse lauseita kirjanmerkeiksi keskustelutallenteistasi.';

  @override
  String get noAlarms => 'Ei vielä hälytyksiä';

  @override
  String get noAlarmsBody =>
      'Lisää oppimismuistutus\nrakentaaksesi tasaisen tavan.';

  @override
  String get subscriptionManage => 'Hallinnoi tilausta';

  @override
  String get changePlan => 'Vaihda tilaus';

  @override
  String get cancelSubscription => 'Peruuta tilaus';

  @override
  String get benefitsInUse => 'Etusi';

  @override
  String get paymentInfo => 'Maksutiedot';

  @override
  String get nextBillingDate => 'Seuraava laskutuspäivä';

  @override
  String get lostBenefitsTitle => 'Nämä edut menetät, jos peruutat';

  @override
  String get viewBillingHistory => 'Näytä laskutushistoria';

  @override
  String get keepUsingPro => 'Jatka Pro-käyttöä';

  @override
  String get proMembership => 'Pro-jäsenyys';

  @override
  String get pricePerMonth => '12,9 \$ / kk';

  @override
  String get benefitUnlimitedCalls => 'Rajattomat puhelut';

  @override
  String get benefitDetailedAnalysis =>
      'Yksityiskohtainen ääntämis- ja kielioppianalyysi';

  @override
  String get benefitAllCharacters => 'Pääsy kaikkiin hahmoihin';

  @override
  String get benefitNoAds => 'Ei mainoksia';

  @override
  String get playSampleVoice => 'Toista äänimalli';

  @override
  String get useThisAvatar => 'Käytä tätä';

  @override
  String get challengeTitle => 'Ääntämishaaste';

  @override
  String get challengeIntro =>
      'Ääntä jokainen alueen kortti oikein koreaksi selvittääksesi sen.\nEi mikrofonia? Voit pelata myös napauttamalla ruutua.';

  @override
  String get challengeStart => 'Käynnistä kamera ja mikrofoni';

  @override
  String get challengePermissionNote =>
      'Etukameran ja mikrofonin käyttöoikeus vaaditaan (valinnainen).';

  @override
  String get challengeLoadingTitle => 'Ladataan…';

  @override
  String get challengeLoadingNote =>
      'Ladataan korean puhemallia (~82 Mt) ensimmäisellä käyttökerralla.\nOdota hetki.';

  @override
  String get challengeSttFallback =>
      'Puheentunnistus ei ollut käytettävissä, joten pelasit napautuksilla.';

  @override
  String get reasonTravelTitle => 'Puhuminen matkustaessa';

  @override
  String get reasonTravelDesc => 'Keskustele itsevarmasti paikallisten kanssa';

  @override
  String get reasonCareerTitle => 'Työ ja ura';

  @override
  String get reasonCareerDesc => 'Liikekeskustelu';

  @override
  String get reasonExamTitle => 'Kokeeseen valmistautuminen';

  @override
  String get reasonExamDesc => 'Valmistaudu puhekokeisiin';

  @override
  String get reasonDailyTitle => 'Arkikeskustelu';

  @override
  String get reasonDailyDesc => 'Ilmaisuja, joita käytät päivittäin';

  @override
  String get reasonFriendsTitle => 'Ulkomaalaisten ystävien hankkiminen';

  @override
  String get reasonFriendsDesc => 'Luonnollinen keskustelu';

  @override
  String get reasonBrainTitle => 'Aivojen stimulointi';

  @override
  String get reasonBrainDesc => 'Paranna muistia ja keskittymistä';

  @override
  String get challengeRecordToggle => 'Tallenna tämä suoritus';

  @override
  String get challengeRecordHint =>
      'Tallentaa videon pelistäsi jakamista varten (ilman ääntä).';

  @override
  String get settingsSection => 'Asetukset';

  @override
  String get paymentSection => 'Maksut';

  @override
  String get supportSection => 'Tuki';

  @override
  String get userLanguage => 'Käyttäjän kieli';

  @override
  String get learningLanguage => 'Opiskelukieli';

  @override
  String get learningLanguageKorean => 'Korea';

  @override
  String get notificationLabel => 'Ilmoitus';

  @override
  String get currentPlan => 'Nykyinen tilaus';

  @override
  String get paymentHistory => 'Maksuhistoria';

  @override
  String get contactUs => 'Ota yhteyttä';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get logOut => 'Kirjaudu ulos';

  @override
  String get deleteAccount => 'Poista tili';

  @override
  String get deleteAccountTitle => 'Poistetaanko tili?';

  @override
  String get deleteAccountBody =>
      'Tämä poistaa tilisi ja tietosi pysyvästi, eikä toimintoa voi peruuttaa.';

  @override
  String get delete => 'Poista';

  @override
  String get share => 'Jaa';

  @override
  String get accentSoundsLike => 'Korean aksenttisi kuulostaa';

  @override
  String get hintLabel => 'Vihje';

  @override
  String get nextHint => 'Seuraava vihje';

  @override
  String get translateLabel => 'Käännä';

  @override
  String get startRecording => 'Aloita nauhoitus';

  @override
  String get stopRecording => 'Lopeta nauhoitus';

  @override
  String get back => 'Takaisin';

  @override
  String get onboardingNameTitle => 'Millä nimellä kutsumme sinua?';

  @override
  String get onboardingNameSubtitle => 'Tekoälyopettajasi muistaa nimesi.';

  @override
  String get nameLabel => 'Nimesi';

  @override
  String get nameHint => 'Kirjoita nimesi';

  @override
  String get nameHelper =>
      'Sen ei tarvitse olla oikea nimesi — myös lempinimi käy.';

  @override
  String get continueLabel => 'Jatka';

  @override
  String get onboardingDoneTitle => 'Majava odottaa puheluasi';

  @override
  String get onboardingDoneSubtitle => 'Aloita puhelu heti';

  @override
  String get home => 'Koti';

  @override
  String get callNow => 'Soita nyt';

  @override
  String get pronunciation => 'Ääntäminen';

  @override
  String get fluency => 'Sujuvuus';

  @override
  String get rhythm => 'Rytmi';

  @override
  String get analysisTimeout =>
      'Tämä kestää odotettua kauemmin. Yritä hetken kuluttua uudelleen.';

  @override
  String get analysisFailed =>
      'Emme voineet analysoida keskustelua. Yritä uudelleen.';

  @override
  String get analyzingConversation => 'Analysoidaan keskusteluasi…';

  @override
  String get analyzingSubtitle => 'Tämä vie vain hetken';

  @override
  String get tryAgain => 'Yritä uudelleen';

  @override
  String get nativeLabel => 'Äidinkielinen';

  @override
  String get meLabel => 'Minä';

  @override
  String get pronunciationPlayError => 'Ääntämisäänitettä ei voitu toistaa.';

  @override
  String get savedExpressionsLoadError =>
      'Tallennettuja ilmaisujasi ei voitu ladata.';

  @override
  String get mySavedExpressions => 'Omat tallennetut ilmaisut';

  @override
  String get avatarTraits => 'Lämmin · Rauhallinen · Pehmeä';

  @override
  String get priceFree => 'Ilmainen';

  @override
  String get loginGoogleTokenError => 'Google-kirjautumistunnusta ei saatu.';

  @override
  String get loginGoogleSignInFailed => 'Google-kirjautuminen epäonnistui.';

  @override
  String get loginContinueWithKakao => 'Jatka Kakaolla';

  @override
  String get loginContinueWithGoogle => 'Jatka Googlella';

  @override
  String get loginContinueWithApple => 'Jatka Applella';

  @override
  String get loginContinueWithEmail => 'Jatka sähköpostilla';

  @override
  String get loginOrDivider => 'tai';

  @override
  String get loginNoAccount => 'Eikö sinulla ole tiliä?';

  @override
  String get signUp => 'Rekisteröidy';

  @override
  String get loginTermsNoticePrefix => 'Jatkamalla hyväksyt ';

  @override
  String get loginTermsNoticeAnd => ' ja ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Kirjaudu sisään';

  @override
  String get fieldEmailLabel => 'Sähköposti';

  @override
  String get emailHint => 'Kirjoita sähköpostiosoitteesi';

  @override
  String get fieldPasswordLabel => 'Salasana';

  @override
  String get passwordHint => 'Kirjoita salasanasi';

  @override
  String get loginRememberMe => 'Muista minut';

  @override
  String get loginForgotPassword => 'Unohditko salasanan?';

  @override
  String get loginLoggingIn => 'Kirjaudutaan sisään...';

  @override
  String get passwordLengthError => 'Salasanan tulee olla 8–16 merkkiä pitkä.';

  @override
  String get passwordsDoNotMatch => 'Salasanat eivät täsmää.';

  @override
  String get signupCheckInput => 'Tarkista syöttämäsi tiedot.';

  @override
  String get fieldConfirmPasswordLabel => 'Vahvista salasana';

  @override
  String get confirmPasswordHint => 'Kirjoita salasanasi uudelleen';

  @override
  String get signupSigningUp => 'Rekisteröidytään...';

  @override
  String get signupHaveAccount => 'Onko sinulla jo tili?';

  @override
  String get passwordMethodEmailRequired => 'Kirjoita sähköpostiosoitteesi';

  @override
  String get passwordResetTitle => 'Nollaa salasana';

  @override
  String get passwordMethodDescription =>
      'Kirjoita sähköpostiosoite, johon haluat vastaanottaa salasanan nollauskoodin.';

  @override
  String get emailAddressHint => 'Sähköpostiosoite';

  @override
  String get passwordMethodSending => 'Lähetetään...';

  @override
  String get passwordMethodSendEmail => 'Lähetä sähköposti';

  @override
  String get passwordCodeTitle => 'Syötä koodi';

  @override
  String get passwordCodeDescription =>
      'Lähetimme palautuskoodin sähköpostiisi. Syötä se jatkaaksesi.';

  @override
  String get passwordCodeNoCode => 'Etkö saanut koodia?';

  @override
  String get passwordCodeResend => 'Lähetä koodi uudelleen';

  @override
  String get passwordCodeVerifying => 'Vahvistetaan...';

  @override
  String get passwordNewTitle => 'Uusi salasana';

  @override
  String get passwordNewDescription => 'Aseta tilillesi uusi salasana.';

  @override
  String get fieldNewPasswordLabel => 'Uusi salasana';

  @override
  String get newPasswordHint => 'Kirjoita uusi salasanasi';

  @override
  String get fieldConfirmNewPasswordLabel => 'Vahvista uusi salasana';

  @override
  String get confirmNewPasswordHint => 'Kirjoita uusi salasanasi uudelleen';

  @override
  String get passwordNewSubmitting => 'Lähetetään...';

  @override
  String get passwordNewSubmit => 'Lähetä';

  @override
  String get passwordCompleteTitle => 'Salasanan nollaus valmis';

  @override
  String get passwordCompleteBody =>
      'Salasanasi on nollattu. Kirjaudu sisään uudella salasanallasi jatkaaksesi.';

  @override
  String get termsTitle => 'Käyttöehdot';

  @override
  String get privacyTitle => 'Tietosuojakäytäntö';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Aseta uusi salasana käyttäjälle $email.';
  }

  @override
  String get selectComplete => 'Valmis';

  @override
  String get onboardingLanguageTitle => 'Mikä on äidinkielesi?';

  @override
  String get onboardingReasonTitle => 'Miksi opiskelet kieltä?';

  @override
  String get onboardingReasonSubtitle =>
      'Räätälöimme oppimisesi tavoitteidesi mukaan.';

  @override
  String get savingLabel => 'Tallennetaan...';

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
