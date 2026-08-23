// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get loginRequired => 'Sinun täytyy kirjautua sisään.';

  @override
  String get callWebNotSupported =>
      'Äänipuhelut eivät toimi verkossa. Käytä sovellusta.';

  @override
  String get micPermissionRequiredForCall =>
      'Mikrofonin käyttöoikeus vaaditaan. Salli mikrofoni aloittaaksesi puhelun.';

  @override
  String get callErrorGeneric => 'Puhelun aikana tapahtui virhe.';

  @override
  String get callNetworkError => 'Tapahtui verkkovirhe.';

  @override
  String get authInvalidCredentials =>
      'Sähköposti tai salasana on virheellinen.';

  @override
  String get authEmailAlreadyRegistered =>
      'Tämä sähköposti on jo rekisteröity.';

  @override
  String get authConfirmEmailRequired =>
      'Viimeistele sähköpostiisi lähetetty vahvistus.';

  @override
  String get authResetCodeSent => 'Lähetimme vahvistuskoodin sähköpostiisi.';

  @override
  String get authResetCodeInvalid => 'Koodi on virheellinen tai vanhentunut.';

  @override
  String get authPasswordUpdated => 'Salasanasi on nollattu.';

  @override
  String get authAppleTokenMissing => 'Applen kirjautumistunnusta ei saatu.';

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
  String get quickStart => 'Pika-aloitus';

  @override
  String get presetMorning => 'Aamurutiini';

  @override
  String get presetMorningSub => 'Arkisin 8:00';

  @override
  String get presetEvening => 'Illan päätös';

  @override
  String get presetEveningSub => 'Joka päivä 21:00';

  @override
  String get presetCustom => 'Oma';

  @override
  String get presetCustomSub => 'Vapaasti';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× viikossa · $monthly puhelua kuussa';
  }

  @override
  String get alarmSummaryNone => 'Valitse vähintään yksi päivä';

  @override
  String get partnerInUse => 'Käytössä';

  @override
  String get partnerOwned => 'Omistuksessa';

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
    return 'Puhelu nro $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Sananen ${name}lta';
  }

  @override
  String characterNoteFooter(String name) {
    return '$name jätti heti puhelun jälkeen';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Uusia ilmauksia $count';
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
  String get selectNativeLanguage => 'Valitse äidinkielesi';

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
  String get analyzingByWord => 'Tarkistamme ääntämistäsi sana kerrallaan';

  @override
  String get analyzingTakingLonger => 'Tämä kestää hieman kauemmin';

  @override
  String get scanConnectionLost => 'Yhteys katkesi';

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
  String pricePerMonth(String price) {
    return '$price / kk';
  }

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
  String get loginAppleSignInFailed => 'Apple-kirjautuminen epäonnistui.';

  @override
  String get loginFacebookSignInFailed => 'Facebook-kirjautuminen epäonnistui.';

  @override
  String get loginKakaoSignInFailed => 'Kakao-kirjautuminen epäonnistui.';

  @override
  String get loginContinueWithKakao => 'Jatka Kakaolla';

  @override
  String get loginContinueWithGoogle => 'Jatka Googlella';

  @override
  String get loginContinueWithFacebook => 'Jatka Facebookilla';

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
  String get thisMonthPayment => 'Tämän kuun maksu';

  @override
  String get filterAll => 'Kaikki';

  @override
  String get filterSubscription => 'Tilaus';

  @override
  String get filterCharacter => 'Hahmo';

  @override
  String get statusCompleted => 'Valmis';

  @override
  String get lastPayment => 'Viimeisin maksu';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Voit käyttää Pro-etuja $date asti, minkä jälkeen tilauksesi vaihtuu automaattisesti maksuttomaan.';
  }

  @override
  String get freePlanCallLimit => '1 puhelu päivässä · 5 min raja';

  @override
  String get freePlanBasicCharacters => 'Perushahmot mukana';

  @override
  String get availableForPurchase => 'Ostettavissa';

  @override
  String get paymentsLoadError => 'Maksuhistorian lataus epäonnistui';

  @override
  String get noPayments => 'Ei vielä maksuja';

  @override
  String get morePaymentsExist => 'Vanhempia maksuja ei näytetä vielä';

  @override
  String get undatedPayments => 'Ei päivämäärää';

  @override
  String get paymentLabelFallback => 'Maksu';

  @override
  String learningPassed(int passed, int total) {
    return '$passed/$total lausetta läpäisty';
  }

  @override
  String get hardestSound => 'Päivän vaikein äänne';

  @override
  String get soundAccuracy => 'Tarkkuus äänteittäin';

  @override
  String phonemeAttempts(int count) {
    return 'Foneemeittain · $count yritystä';
  }

  @override
  String get colSound => 'Äänne';

  @override
  String get colAttempts => 'Yrit.';

  @override
  String get colCorrect => 'Oikein';

  @override
  String get colAccuracy => 'Tarkk.';

  @override
  String get sentenceResults => 'Tulokset lauseittain';

  @override
  String viewAllSentences(int count) {
    return 'Näytä kaikki $count';
  }

  @override
  String get colSentence => 'Lause';

  @override
  String get colPronunciation => 'Ääntäm.';

  @override
  String get colFluency => 'Suju.';

  @override
  String get colRhythm => 'Rytmi';

  @override
  String recentSessions(int count) {
    return '$count viime kertaa';
  }

  @override
  String trendAverage(int score) {
    return 'Ka. $score';
  }

  @override
  String get today => 'Tänään';

  @override
  String get colDate => 'Pvm';

  @override
  String get colSentences => 'Lauseet';

  @override
  String get colScore => 'Pisteet';

  @override
  String get colChange => 'Muutos';

  @override
  String dateToday(String date) {
    return '$date (tänään)';
  }

  @override
  String get accentAnalysis => 'Aksenttianalyysi';

  @override
  String get overallLevel => 'Kokonaistaso';

  @override
  String get overallLevelSubtitle => 'Sanasto · Kielioppi · Ilmaisut';

  @override
  String get pronunciationAnalysis => 'Ääntämisanalyysi';

  @override
  String get recentSessionsAverage => '10 istunnon keskiarvo';

  @override
  String levelStage(int stage) {
    return 'Taso $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Kaikista oppijoista';

  @override
  String aheadOfLearners(int percent) {
    return 'Olet $percent% oppijaa edellä';
  }

  @override
  String get retakeLevelTest => 'Uusi tasotesti';

  @override
  String get practicePronunciation => 'Harjoittele ääntämistä';

  @override
  String get priceChangedTitle => 'Hinta muuttui';

  @override
  String priceChangedBody(String price) {
    return 'Tämä tuote maksaa nyt $price. Haluatko jatkaa?';
  }

  @override
  String get billingGroupPlanPurchases => 'Paketti ja ostot';

  @override
  String get billingGroupInTheStore => 'Kaupassa';

  @override
  String get billingChangePlan => 'Vaihda pakettia';

  @override
  String get billingCompareAllPlans => 'Vertaa kaikkia paketteja';

  @override
  String get billingBuyACharacter => 'Osta hahmo';

  @override
  String get billingRestorePurchases => 'Palauta ostot';

  @override
  String get billingPaymentHistory => 'Maksuhistoria';

  @override
  String get billingManageInTheStore => 'Hallinnoi kaupassa';

  @override
  String get billingRefundHelp => 'Apua hyvityksiin';

  @override
  String get billingCancelSubscription => 'Peruuta tilaus';

  @override
  String get billingResubscribe => 'Tilaa uudelleen';

  @override
  String get badgeCurrent => 'Nykyinen';

  @override
  String get badgeTrial => 'Kokeilu';

  @override
  String get badgeRenewing => 'Uusiutuu';

  @override
  String get badgePastDue => 'Maksu myöhässä';

  @override
  String get badgePaused => 'Tauolla';

  @override
  String get badgeCanceling => 'Päättymässä';

  @override
  String get subscriptionTitle => 'Tilaus';

  @override
  String get plansTitle => 'Paketit';

  @override
  String get planFree => 'Ilmainen';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max-kokeilu';

  @override
  String get freePlanPriceLine => '\$0.00 — yksi puhelu päivässä';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount kuukaudessa';
  }

  @override
  String freeUntilDate(String date) {
    return 'Ilmainen $date asti';
  }

  @override
  String get todaysCalls => 'Päivän puhelut';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used/$limit käytetty';
  }

  @override
  String get firstPaymentLabel => 'Ensimmäinen maksu';

  @override
  String get nextPaymentLabel => 'Seuraava maksu';

  @override
  String get retryingUntilLabel => 'Uudelleenyritys päättyy';

  @override
  String get pausedSinceLabel => 'Tauolla alkaen';

  @override
  String planEndsLabel(String plan) {
    return '$plan päättyy';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Rajattomat puhelut Pro-paketilla';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Rajattomat puhelut · 15 min kukin · $price kuukaudessa';
  }

  @override
  String get bannerMaxUpsellTitle => 'Ota video käyttöön Max-paketilla';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Kasvokkaiset puhelut · $price kuukaudessa';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Vaihda vuositilaukseen';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly vuodessa · $perMonth kuukaudessa';
  }

  @override
  String get bannerPaymentFailedTitle => 'Maksua ei voitu veloittaa';

  @override
  String get bannerPaymentFailedSub =>
      'Päivitä maksutapa kaupassa, jotta Pro säilyy';

  @override
  String get bannerPausedTitle => 'Pakettisi on tauolla';

  @override
  String get bannerPausedSub => 'Maksu ei mennyt läpi';

  @override
  String get noteRestoreHint =>
      'Tilasitko jo toisella laitteella? Palautus tuo tilauksen tälle laitteelle.';

  @override
  String get noteStoreHandled =>
      'Kauppa hoitaa maksutavan, paketin vaihdot ja peruutuksen.';

  @override
  String get noteFairUse =>
      'Rajattomaan käyttöön sovelletaan kohtuullisen käytön ehtoja.';

  @override
  String noteTrialEnds(String date) {
    return 'Kokeilusi päättyy $date. Jos peruutat kaupassa sitä ennen, mitään ei veloiteta.';
  }

  @override
  String get noteGrace =>
      'Edut jatkuvat lisäajan loppuun. Sovellus ei koskaan estä peruutusta.';

  @override
  String get noteHold =>
      'Pro on tauolla, kunnes maksu menee läpi. Hahmosi ja edistymisesi ovat tallessa.';

  @override
  String noteEnding(String date) {
    return 'Pakettisi on päättymässä. Edut jatkuvat $date asti, minkä jälkeen siirryt Ilmaiseen. Voit tilata uudelleen milloin tahansa.';
  }

  @override
  String get trialExpiredTitle => 'Max-kokeilusi päättyi';

  @override
  String get trialExpiredSub => 'Käytät nyt Ilmaista pakettia';

  @override
  String get seePlans => 'Katso paketit';

  @override
  String get currentPlanTitle => 'Nykyinen paketti';

  @override
  String get badgeRecommended => 'Suositeltu';

  @override
  String get perMonthUnit => 'kuukaudessa';

  @override
  String get planTaglinePro => 'Rajattomat puhelut. 15 min kukin.';

  @override
  String get planTaglineMax => 'Nyt näet heidät.';

  @override
  String get planTaglineFree => 'Yksi puhelu päivässä. Talon puolesta.';

  @override
  String get bulletProCalls => 'Äänipuheluita niin usein kuin haluat';

  @override
  String get bulletProLength => '15 minuuttia per puhelu';

  @override
  String get bulletProScoring => 'Ääntäminen arvioidaan kirjain kirjaimelta';

  @override
  String get bulletProCorrections => 'Korjaukset äidinkielesi mukaan';

  @override
  String get bulletProBeaverCalls => 'Beaver soittaa sinulle ensin';

  @override
  String get bulletMaxVideo => 'Kasvokkaiset videopuhelut';

  @override
  String get bulletMaxEverything => 'Kaikki Pro-paketista';

  @override
  String get bulletMaxCharacters => 'Kaikki hahmot, rajattomasti';

  @override
  String get bulletMaxStudyBook => 'Tasollesi sovitettu oppikirja';

  @override
  String get bulletMaxWeeklyReport => 'Viikkoraportti ääntämisesi kehityksestä';

  @override
  String get bulletFreeCall => 'Yksi 5 minuutin äänipuhelu päivässä';

  @override
  String get bulletFreeCheck => 'Yksi ääntämistarkistus päivässä';

  @override
  String get bulletFreeAccent => 'Rajattomat aksenttitarkistukset';

  @override
  String get bulletFreeCharacter => 'Yksi hahmo alkuun';

  @override
  String get ctaGoUnlimited => 'Siirry rajattomaan';

  @override
  String get ctaTurnOnVideo => 'Ota video käyttöön';

  @override
  String get noteCallLength => 'Puhelut ovat 15 minuutin mittaisia.';

  @override
  String get paywallProTitle1 => 'Korealainen ystäväsi,';

  @override
  String get paywallProTitle2 => 'joka valvoo kello 3 yöllä';

  @override
  String get paywallProSub =>
      'Rajattomat puhelut. 15 min kukin. Ympäri vuoden.';

  @override
  String get paywallLimitHeadline => 'Pro poistaa rajan.';

  @override
  String get limitBannerCallTitle => 'Se oli päivän puhelu';

  @override
  String get limitBannerCallSub => 'Ilmainen antaa yhden puhelun päivässä';

  @override
  String get limitBannerCheckTitle => 'Se oli päivän tarkistus';

  @override
  String get limitBannerCheckSub =>
      'Ilmainen antaa yhden tarkistuksen päivässä';

  @override
  String get bulletProCharactersForever =>
      'Ostamasi hahmot ovat omiasi ikuisesti';

  @override
  String get paywallMaxTitle => 'Nyt näet heidät.';

  @override
  String get paywallMaxSub =>
      'Videopuhelut, kaikki hahmot ja tasollesi tehty oppikirja.';

  @override
  String get planMonthly => 'Kuukausi';

  @override
  String get planAnnual => 'Vuosi';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price kuukaudessa';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth kuukaudessa';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price kuukaudessa';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly vuodessa · $perMonth kuukaudessa';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price/kk · peruuta milloin tahansa kaupassa';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price/kk · peruuta milloin tahansa kaupassa';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 päivää ilmaiseksi, sitten $price/kk · peruuta milloin tahansa kaupassa';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Uusiutuu automaattisesti, kunnes peruutat.';

  @override
  String get footerTerms => 'Ehdot';

  @override
  String get footerPrivacy => 'Tietosuoja';

  @override
  String get noteMaxCharacters =>
      'Maxin avaamat hahmot ovat käytössä, kun tilauksesi on voimassa. Ostamasi hahmot pysyvät sinulla.';

  @override
  String get processingTitle => 'Vahvistetaan ostoasi';

  @override
  String get processingSub => 'Tämä kestää yleensä muutaman sekunnin.';

  @override
  String get successProTitle => 'Pro on nyt käytössä.';

  @override
  String get successProSub => 'Rajattomat puhelut alkavat heti.';

  @override
  String get successProBenefit1 =>
      'Soita niin usein kuin haluat — 15 min per puhelu';

  @override
  String get successProBenefit2 => 'Rajattomat ääntämistarkistukset';

  @override
  String get successProBenefit3 => 'Kaikki hahmot sekä kertaostot';

  @override
  String get successMaxTitle => 'Nyt näet heidät.';

  @override
  String get successMaxSub =>
      'Videopuhelut ovat käytössä. Napauta videopainiketta missä tahansa puhelussa.';

  @override
  String get successMaxBenefit1 => 'Kasvokkaiset videopuhelut';

  @override
  String get successMaxBenefit2 => 'Kaikki hahmot rajattomasti, uudet ensin';

  @override
  String get successMaxBenefit3 => 'Tasollesi sovitettu oppikirja';

  @override
  String get ctaStartACall => 'Aloita puhelu';

  @override
  String get ctaStartAVideoCall => 'Aloita videopuhelu';

  @override
  String get ctaSeeYourSubscription => 'Katso tilauksesi';

  @override
  String successProCaption(String price) {
    return '$price veloitetaan kuukausittain, kunnes peruutat. Hallinnoi tai peruuta milloin tahansa kaupassa.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price veloitetaan kuukausittain, kunnes peruutat. Hallinnoi tai peruuta milloin tahansa kaupassa.';
  }

  @override
  String get plansErrorTitle => 'Paketteja ei voitu ladata';

  @override
  String get plansErrorSub => 'Kauppa ei vastannut.';

  @override
  String get ctaTryAgain => 'Yritä uudelleen';

  @override
  String get plansErrorCaption => 'Mitään ei veloitettu.';

  @override
  String get changePlanTitle => 'Vaihda pakettia';

  @override
  String get moveToMaxTitle => 'Siirry Max-pakettiin';

  @override
  String maxPriceShort(String price) {
    return '$price / kk';
  }

  @override
  String get moveToMaxCardSub =>
      'Kasvokkaiset videopuhelut · kaikki hahmot · sinulle tehty oppikirja';

  @override
  String get whatHappensNow => 'Mitä tapahtuu nyt';

  @override
  String get maxStartsLabel => 'Max alkaa';

  @override
  String get immediately => 'Heti';

  @override
  String get unusedProTime => 'Käyttämätön Pro-aika';

  @override
  String get creditedTowardMax => 'Hyvitetään Max-hinnassa';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Vaihda Max-pakettiin';

  @override
  String get upgradeCaption =>
      'Uusi pakettisi alkaa heti. Käyttämätön Pro-aika hyvitetään — mitään ei veloiteta kahdesti.';

  @override
  String get moveToProTitle => 'Siirry Pro-pakettiin';

  @override
  String get moveToProSub =>
      'Tänään mikään ei muutu. Max jatkuu jo maksamasi kuukauden loppuun.';

  @override
  String get maxRunsUntil => 'Max voimassa';

  @override
  String get proStarts => 'Pro alkaa';

  @override
  String get whatYouKeep => 'Mitä pidät';

  @override
  String get keepBenefitCalls => 'Rajattomat äänipuhelut, 15 min kukin';

  @override
  String get keepBenefitCharacters => 'Ostamasi hahmot ovat omiasi ikuisesti';

  @override
  String downgradeWarning(String date) {
    return 'Videopuhelut ja vain Maxin hahmot poistuvat käytöstä $date.';
  }

  @override
  String get ctaSwitchToPro => 'Vaihda Pro-pakettiin';

  @override
  String get ctaKeepMax => 'Pidä Max';

  @override
  String get winbackSkip => 'Ohita';

  @override
  String get winbackTitle => 'Pro-pakettisi päättyi';

  @override
  String get winbackSub => 'Käytät nyt Ilmaista — yksi puhelu päivässä.';

  @override
  String get winbackQuestion => 'Kertoisitko, miksi lähdit?';

  @override
  String get winbackReasonExpensive => 'Liian kallis';

  @override
  String get winbackReasonUnused => 'En käyttänyt sitä tarpeeksi';

  @override
  String get winbackReasonMissing => 'Tarvitsemani ominaisuus puuttui';

  @override
  String get winbackReasonOtherApp => 'Löysin toisen sovelluksen';

  @override
  String get winbackReasonElse => 'Jokin muu';

  @override
  String get ctaSend => 'Lähetä';

  @override
  String get ctaNotNow => 'Ei nyt';

  @override
  String get winbackCaption =>
      'Tämä ei palauta pakettiasi. Tilaa uudelleen kaupassa.';

  @override
  String get ctaContinue => 'Jatka';

  @override
  String get ctaClose => 'Sulje';

  @override
  String get ovRestoreSuccessTitle => 'Pro on palannut';

  @override
  String get ovRestoreSuccessBody =>
      'Löysimme tilauksesi ja otimme sen taas käyttöön tällä laitteella.';

  @override
  String get ovRestoreEmptyTitle => 'Ei palautettavaa';

  @override
  String get ovRestoreEmptyBody =>
      'Tähän kauppatiliin ei ole liitetty aktiivista tilausta.';

  @override
  String get ovRestoreOtherTitle => 'Tämä tilaus kuuluu toiselle tilille';

  @override
  String get ovRestoreOtherBody =>
      'Tämä tilaus on jo käytössä toisella BeaverTalk-tilillä.';

  @override
  String get ctaSignInThatAccount => 'Kirjaudu sille tilille';

  @override
  String get ctaGetHelp => 'Pyydä apua';

  @override
  String get ovCharacterOfferTitle => 'Etkö ole vielä valmis Pro-pakettiin?';

  @override
  String get ovCharacterOfferBody =>
      'Valitse yksi hahmo ja pidä hänet. Kertaosto — ei tilausta, ei uusiutumista.';

  @override
  String get rowOneCharacter => 'Yksi hahmo';

  @override
  String rowFromPrice(String price) {
    return 'alk. $price';
  }

  @override
  String get rowYoursForever => 'Omasi ikuisesti';

  @override
  String get rowNoRenewal => 'Ei uusiutumista';

  @override
  String get rowWorksOnFree => 'Toimii Ilmaisella';

  @override
  String get rowYes => 'Kyllä';

  @override
  String get ctaSeeCharacters => 'Katso hahmot';

  @override
  String get ovNotEligibleTitle => 'Ei peruutettavaa';

  @override
  String get ovNotEligibleBody =>
      'Käytät Ilmaista pakettia. Tällä tilillä ei ole aktiivista tilausta.';

  @override
  String get ovCancelDownsellTitle => 'Ennen kuin lähdet';

  @override
  String get ovCancelDownsellBody =>
      'Peruutus tehdään kaupassa. Kaksi asiaa, jotka kannattaa tietää.';

  @override
  String get rowPayYearlyInstead => 'Maksa mieluummin vuosittain';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price kuukaudessa';
  }

  @override
  String get rowCharactersYouBought => 'Ostamasi hahmot';

  @override
  String get rowProRunsUntil => 'Pro voimassa';

  @override
  String get ctaSwitchToYearly => 'Vaihda vuositilaukseen';

  @override
  String get ctaContinueToStore => 'Jatka kauppaan';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Maksa vuosittain, säästä $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Olet ollut Pro-käyttäjä kaksi kuukautta. Vuositilaus tulee halvemmaksi.';

  @override
  String get rowYouSave => 'Säästät';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Vuosittain';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Kuukausittain, vuoden ajan';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Vaihda kuukausitilaukseen';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Vuositilauksesi on voimassa $date asti. Kuukausilaskutus alkaa seuraavana päivänä.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Kuukausilaskutus alkaa';

  @override
  String get rowMonthlyLabel => 'Kuukausittain';

  @override
  String get rowYearlyWorkedOut => 'Vuositilauksen hinta oli';

  @override
  String get ctaSwitchToMonthly => 'Vaihda kuukausitilaukseen';

  @override
  String get ovRefundHelpTitle => 'Kauppa käsittelee hyvitykset';

  @override
  String get ovRefundHelpBody =>
      'Emme voi itse myöntää hyvityksiä. Kauppa käsittelee jokaisen pyynnön.';

  @override
  String get ctaGoToStore => 'Siirry kauppaan';

  @override
  String get ovTrialEndingTitle => 'Kokeilusi päättyy huomenna';

  @override
  String get ovTrialEndingBody => 'Max jatkuu, ellet peruuta. Näin käy.';

  @override
  String get rowTrialEnds => 'Kokeilu päättyy';

  @override
  String get rowFirstCharge => 'Ensimmäinen veloitus';

  @override
  String get rowThenMonthly => 'Sitten kuukausittain';

  @override
  String get ctaCancelInStore => 'Peruuta kaupassa';

  @override
  String get ovTrialStartTitle => '7 päivää Maxia, ilmaiseksi';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Ilmainen $date asti. Sitten $price kuukaudessa, ellet peruuta kaupassa.';
  }

  @override
  String get ctaStart7Days => 'Aloita 7 päivää ilmaiseksi';

  @override
  String get ovOtoTitle => 'Vielä yksi asia ennen aloitusta';

  @override
  String get ovOtoBody =>
      'Hyvä valinta — rajattomat puhelut ovat nyt käytössä. Sama Pro maksaa vähemmän vuosittain maksettuna.';

  @override
  String get ovFailedDeclinedTitle => 'Korttisi hylättiin';

  @override
  String get ovFailedDeclinedBody =>
      'Kauppa ei voinut veloittaa maksua. Mitään ei veloitettu.';

  @override
  String get ctaUpdatePaymentMethod => 'Päivitä maksutapa';

  @override
  String get ovFailedCanceledTitle => 'Maksu peruutettiin';

  @override
  String get ovFailedCanceledBody =>
      'Käytät edelleen Ilmaista. Mitään ei veloitettu.';

  @override
  String get ovFailedStoreTitle => 'Jotain meni pieleen';

  @override
  String get ovFailedStoreBody =>
      'Kauppaan ei saatu yhteyttä. Mitään ei veloitettu.';

  @override
  String get ovAlreadyTitle => 'Sinulla on jo Pro';

  @override
  String get ovAlreadyBody =>
      'Tällä kauppatilillä on aktiivinen tilaus. Ei mitään ostettavaa.';

  @override
  String get ctaSeeMySubscription => 'Katso tilaukseni';

  @override
  String get subCancelTitle => 'Peruuta tilaus';

  @override
  String subCancelBody(String date) {
    return 'Pro on voimassa $date asti. Sen jälkeen siirryt Ilmaiseen.';
  }

  @override
  String get subWhatYouLose => 'Mitä menetät';

  @override
  String get benefitCalls15 => 'Rajattomat puhelut, 15 min kukin';

  @override
  String get benefitScoring => 'Ääntäminen arvioidaan kirjain kirjaimelta';

  @override
  String get benefitEveryCharacter => 'Kaikki hahmot, rajattomasti';

  @override
  String get ctaKeepPro => 'Pidä Pro';

  @override
  String get subPaymentTitle => 'Päivitä maksutapa';

  @override
  String get subPaymentBody =>
      'Maksua ei voitu veloittaa. Pro jatkuu lisäajan loppuun.';

  @override
  String get subHowToFix => 'Näin korjaat sen';

  @override
  String get fixStep1 => 'Avaa kauppa ja päivitä maksutapasi';

  @override
  String get fixStep2 => 'Palaa takaisin — pakettisi jatkuu automaattisesti';

  @override
  String get fixStep3 => 'Mitään ei veloiteta kahdesti';

  @override
  String get subResubTitle => 'Tilaa uudelleen';

  @override
  String subResubBody(String date) {
    return 'Pro päättyy $date. Kytke automaattinen uusinta takaisin päälle, eikä mikään muutu.';
  }

  @override
  String get subWhatYouKeep => 'Mitä pidät';

  @override
  String get ctaTurnItBackOn => 'Kytke takaisin päälle';

  @override
  String get flTodayTitle => 'Se oli päivän puhelu';

  @override
  String get flTodayBody => 'Jatka siitä, mihin jäit — heti.';

  @override
  String get flCheckTitle => 'Se oli päivän tarkistus';

  @override
  String get flCheckBody =>
      'Ilmaisella yksi tarkistus päivässä. Pro tekee siitä rajattoman.';

  @override
  String get flBenefitCalls =>
      'Rajattomat puhelut Pro-paketilla · 15 min kukin';

  @override
  String get flBenefitChecks => 'Rajattomat ääntämistarkistukset Pro-paketilla';

  @override
  String flCaption(String price) {
    return '$price/kk · peruuta milloin tahansa';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used/$limit käytetty';
  }

  @override
  String get ctaMaybeTomorrow => 'Ehkä huomenna';

  @override
  String get accountSection => 'Tili';

  @override
  String get nicknameLabel => 'Nimimerkki';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Kirjautumistapa';

  @override
  String get joinedLabel => 'Liittynyt';

  @override
  String get editNicknameTitle => 'Muokkaa nimimerkkiä';

  @override
  String get nicknameRule =>
      '2–12 merkkiä. Kirjaimia ja numeroita. Vain englanniksi';

  @override
  String get ctaSave => 'Tallenna';

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
  String get paywallLeaveTitle => 'Jos poistut nyt, tilausta ei tehdä';

  @override
  String get paywallLeaveBody =>
      'Etusi avautuvat heti maksun jälkeen. Voit palata milloin tahansa Oma sivu -näkymästä.';

  @override
  String get ctaKeepLooking => 'Jatka katselua';

  @override
  String get ctaLeaveAnyway => 'Poistu silti';

  @override
  String get iapCharacterSuccessTitle => 'Uusi ystävä liittyi seuraan!';

  @override
  String get iapCharacterSuccessBody =>
      'Tämä hahmo on sinun ikuisesti — se säilyy vaikka paketti vaihtuisi, ja Palauta ostot tuo sen takaisin millä tahansa laitteella.';

  @override
  String get iapCharacterFailedBody =>
      'Ostos ei onnistunut. Mitään ei veloitettu — yritä uudelleen.';

  @override
  String get noAccentDataTitle => 'Ei vielä intonaatiotietoja';

  @override
  String get noAccentDataBody =>
      'Jatka puhumista, niin intonaatiosi piirteet kertyvät.';

  @override
  String get noLevelYetTitle => 'Ei vielä tasoa';

  @override
  String get noLevelYetBody =>
      'Suorita ensimmäinen puhelusi saadaksesi tasosi.';

  @override
  String get noPronunciationDataTitle => 'Ei vielä ääntämistietoja';

  @override
  String get noPronunciationDataBody =>
      'Analysoimme ääntämistäsi puheluissa sanomistasi lauseista.';

  @override
  String get noCharacterNote => 'Ei vielä sanottua';

  @override
  String get noPhonemesYet => 'Ei vielä analysoitavia äänteitä';

  @override
  String get noSentencesYet => 'Ei vielä analysoitavia lauseita';

  @override
  String get takeLevelTest => 'Tee tasotesti';

  @override
  String get reviewToSeeScore => 'Kertaa nähdäksesi ääntämispisteesi';

  @override
  String get playAgain => 'Pelaa uudelleen';

  @override
  String get difficultySlow => 'Hidas';

  @override
  String get difficultyNormal => 'Normaali';

  @override
  String get difficultyFast => 'Nopea';

  @override
  String get difficultyLabel => 'Vaikeustaso';

  @override
  String get connected => 'Yhdistetty';

  @override
  String get unlockedWithMax => 'Käytettävissä Maxilla';

  @override
  String get fcEndedTitle => 'Ilmainen puhelusi päättyi';

  @override
  String get fcEndedBody =>
      'Ilmaiset puhelut kestävät enintään 5 minuuttia\nTilaa, niin voit jutella pidempään';

  @override
  String get ctaSubscribeKeepTalking => 'Tilaa ja jatka juttelua';

  @override
  String get kgTitle => 'Jatketaanko?';

  @override
  String get kgBody =>
      'Puhelut jatkuvat 5 minuutin jaksoissa.\nKysymme sinulta joka kerta uudelleen.';

  @override
  String get ctaKeepTalking => 'Jatka juttelua';

  @override
  String get callModeSheetTitle => 'Miten haluat jutella?';

  @override
  String get callModeSheetSubtitle => 'Astuu voimaan heti tässä puhelussa';

  @override
  String get callModeFreeTalk => 'Vapaa juttelu';

  @override
  String get callModeFreeTalkDesc => 'Juttele ilman korjauksia';

  @override
  String get callModeStudy => 'Opiskelu';

  @override
  String get callModeStudyDesc => 'Opettele yksi ilmaus kerrallaan';

  @override
  String get callModeChange => 'Vaihda tila';

  @override
  String get callModeKeep => 'Ei nyt';

  @override
  String get callExitTitle => 'Lopetetaanko puhelu?';

  @override
  String get callExitSubtitle =>
      'Lopettaminen nyt kuluttaa silti yhden puhelun';

  @override
  String get callExitKeep => 'Jatka puhumista';

  @override
  String get callExitConfirm => 'Lopeta puhelu';

  @override
  String get callMicMute => 'Mykistä';

  @override
  String get callMicUnmute => 'Poista mykistys';

  @override
  String get callPushToTalk => 'Pidä pohjassa puhuaksesi';

  @override
  String get callFreeEndedTitle => 'Ilmainen puhelusi päättyi';

  @override
  String get callFreeEndedCta => 'Tilaa ja jatka juttelua';

  @override
  String get callKeepGoingTitle => 'Jatketaanko?';

  @override
  String get callKeepGoingSubtitle =>
      'Puhelut jatkuvat 5 minuutin jaksoissa. Kysymme joka kerta uudelleen.';
}
