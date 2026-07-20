// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Chiamata terminata $duration';
  }

  @override
  String get callRatingPrompt => 'Com\'è andata la chiamata?';

  @override
  String get ratingBad => 'Non granché';

  @override
  String get ratingOkay => 'Discreta';

  @override
  String get ratingGood => 'Ottima';

  @override
  String get goHome => 'Home';

  @override
  String get viewAnalysis => 'Vedi analisi';

  @override
  String get loadingShort => 'Caricamento…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Invio della valutazione non riuscito: $message';
  }

  @override
  String get callInfoNotFound =>
      'Informazioni sulla chiamata non trovate, analisi saltata.';

  @override
  String get tabRecords => 'Registri';

  @override
  String get tabArchive => 'Archivio';

  @override
  String get callHistory => 'Cronologia chiamate';

  @override
  String get conversationRecord => 'Registrazione della conversazione';

  @override
  String get noCallRecords => 'Ancora nessuna chiamata registrata';

  @override
  String get noCallRecordsBody =>
      'Dopo la tua prima chiamata con l\'IA,\nqui vedrai i tuoi registri.';

  @override
  String get startCall => 'Avvia una chiamata';

  @override
  String get recordsLoadError => 'Impossibile caricare i registri';

  @override
  String get tryAgainLater => 'Riprova più tardi.';

  @override
  String get retry => 'Riprova';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds sec';
  }

  @override
  String get scheduleManagement => 'Programma';

  @override
  String get alarms => 'Sveglie';

  @override
  String get addSchedule => 'Aggiungi programma';

  @override
  String get editSchedule => 'Modifica programma';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get alarmsLoadError => 'Impossibile caricare le sveglie';

  @override
  String get charactersLoadError => 'Impossibile caricare i personaggi';

  @override
  String get noCharacters => 'Nessun personaggio disponibile';

  @override
  String get close => 'Chiudi';

  @override
  String get repeat => 'Ripeti';

  @override
  String get callPartner => 'Personaggio';

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
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'Salva';

  @override
  String get conversation => 'Conversazione';

  @override
  String get review => 'Ripasso';

  @override
  String get pronunciationChallenge => 'Sfida di pronuncia';

  @override
  String get newExpressions => 'Nuove espressioni';

  @override
  String get analysisResult => 'Risultato dell\'analisi';

  @override
  String get noNewExpressions =>
      'Nessuna nuova espressione da questa conversazione.';

  @override
  String get practice => 'Esercitati';

  @override
  String recentScore(int score) {
    return 'Punteggio recente $score%';
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
  String get analysisLoadError =>
      'Impossibile caricare il risultato dell\'analisi.';

  @override
  String get standardAudioNotReady =>
      'L\'audio della pronuncia standard non è ancora pronto.';

  @override
  String get standardAudioPlayError =>
      'Impossibile riprodurre l\'audio della pronuncia standard.';

  @override
  String get selectACountry => 'Seleziona un paese';

  @override
  String get selectYourLanguage => 'Seleziona la tua lingua';

  @override
  String get confirm => 'Conferma';

  @override
  String get cancel => 'Annulla';

  @override
  String get selectTime => 'Seleziona l\'orario';

  @override
  String get getStarted => 'Inizia';

  @override
  String get permissionTitle =>
      'Consenti le autorizzazioni\nper un\'esperienza fluida';

  @override
  String get permissionSubtitle =>
      'Le autorizzazioni richieste sono indispensabili per usare il servizio.';

  @override
  String get permissionMicTitle => 'Microfono (obbligatorio)';

  @override
  String get permissionMicDesc =>
      'Necessario per parlare con l\'IA in inglese.';

  @override
  String get permissionNotifTitle => 'Notifiche (facoltativo)';

  @override
  String get permissionNotifDesc =>
      'Ti invieremo promemoria di studio e le chiamate programmate.';

  @override
  String get micPermissionNeededTitle => 'Accesso al microfono necessario';

  @override
  String get micPermissionNeededBody =>
      'Per parlare con l\'IA devi consentire l\'accesso al microfono. Attivalo nelle Impostazioni.';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get connectionFailedTitle => 'Connessione non riuscita';

  @override
  String get connectionFailedBody =>
      'Controlla la connessione di rete\ne riprova.';

  @override
  String get checkout => 'Checkout';

  @override
  String get pay => 'Paga';

  @override
  String get orderSummary => 'Riepilogo dell\'ordine';

  @override
  String get paymentMethod => 'Metodo di pagamento';

  @override
  String get payMethodCard => 'Carta di credito / debito';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Castoro Dispettoso';

  @override
  String get productTrait => 'Personaggio premium · Per sempre tuo';

  @override
  String get amountItemPrice => 'Prezzo articolo';

  @override
  String get amountDiscount => 'Sconto';

  @override
  String get amountTotal => 'Totale';

  @override
  String get paymentCompleteTitle => 'Pagamento completato';

  @override
  String get paymentCompleteBody =>
      'L\'avatar è stato aggiunto alla tua collezione.';

  @override
  String get viewCollection => 'Vedi collezione';

  @override
  String get receiptItem => 'Articolo';

  @override
  String get receiptAmount => 'Importo';

  @override
  String get receiptMethod => 'Metodo di pagamento';

  @override
  String get receiptDate => 'Data';

  @override
  String get paymentFailedTitle => 'Pagamento non riuscito';

  @override
  String get paymentFailedBody =>
      'Non è stato possibile elaborare il pagamento.\nRiprova.';

  @override
  String get freeCallEndingTitle => 'La tua chiamata gratuita sta per finire';

  @override
  String get freeCallEndingBody =>
      'Abbonati per parlare più a lungo con Beaver.';

  @override
  String get subscribe => 'Abbonati';

  @override
  String get endCall => 'Termina chiamata';

  @override
  String get callEnded => 'La chiamata è terminata.';

  @override
  String get connecting => 'Connessione in corso…';

  @override
  String get connectingHint => 'Di solito richiede meno di 5 secondi';

  @override
  String get callConnectFailed => 'Impossibile connettere la chiamata.';

  @override
  String get saveSentenceFailed => 'Impossibile salvare la frase.';

  @override
  String get recordStartFailed => 'Impossibile avviare la registrazione.';

  @override
  String get recordTooShort => 'La registrazione era troppo breve. Riprova.';

  @override
  String get gradingFailed => 'Valutazione non riuscita. Riprova.';

  @override
  String get listenStandard => 'Ascolta la pronuncia standard';

  @override
  String get saveSentence => 'Salva frase';

  @override
  String get unsaveSentence => 'Rimuovi frase salvata';

  @override
  String get scoringPronunciation => 'Valutazione della tua pronuncia…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'Nessuna registrazione da riprodurre.';

  @override
  String get myRecordingPlayError =>
      'Impossibile riprodurre la tua registrazione.';

  @override
  String get next => 'Avanti';

  @override
  String get endLearning => 'Termina sessione';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navCall => 'Chiamata';

  @override
  String get navStats => 'Statistiche';

  @override
  String get myPage => 'Il mio profilo';

  @override
  String get languageSaveFailed => 'Impossibile salvare la tua lingua.';

  @override
  String get accountDeleteFailed => 'Impossibile eliminare il tuo account.';

  @override
  String get changeAvatar => 'Cambia avatar';

  @override
  String get avatarIntro =>
      'Voce e difficoltà variano in base al personaggio.\nAlcuni personaggi potrebbero richiedere un pagamento.';

  @override
  String myPartnersOwned(int count) {
    return 'I miei personaggi · $count posseduti';
  }

  @override
  String get limitedDiscount => 'Sconto a tempo limitato';

  @override
  String get available => 'Disponibile';

  @override
  String get inUse => 'In uso';

  @override
  String get owned => 'Posseduto';

  @override
  String get noCharactersToShow => 'Nessun personaggio da mostrare';

  @override
  String get buy => 'Acquista';

  @override
  String get noSavedSentences =>
      'Ancora nessuna frase salvata.\nSalva le frasi dai tuoi registri di conversazione.';

  @override
  String get noAlarms => 'Ancora nessuna sveglia';

  @override
  String get noAlarmsBody =>
      'Aggiungi un promemoria di studio\nper costruire un\'abitudine costante.';

  @override
  String get subscriptionManage => 'Gestisci abbonamento';

  @override
  String get changePlan => 'Cambia piano';

  @override
  String get cancelSubscription => 'Annulla abbonamento';

  @override
  String get benefitsInUse => 'I tuoi vantaggi';

  @override
  String get paymentInfo => 'Informazioni di pagamento';

  @override
  String get nextBillingDate => 'Prossima data di fatturazione';

  @override
  String get lostBenefitsTitle => 'Vantaggi che perderai annullando';

  @override
  String get viewBillingHistory => 'Vedi cronologia fatturazione';

  @override
  String get keepUsingPro => 'Continua a usare Pro';

  @override
  String get proMembership => 'Abbonamento Pro';

  @override
  String get pricePerMonth => '12,9 € / mese';

  @override
  String get benefitUnlimitedCalls => 'Chiamate illimitate';

  @override
  String get benefitDetailedAnalysis =>
      'Analisi dettagliata di pronuncia e grammatica';

  @override
  String get benefitAllCharacters => 'Accesso a tutti i personaggi';

  @override
  String get benefitNoAds => 'Nessuna pubblicità';

  @override
  String get playSampleVoice => 'Riproduci voce di esempio';

  @override
  String get useThisAvatar => 'Usa questo';

  @override
  String get challengeTitle => 'Sfida di pronuncia';

  @override
  String get challengeIntro =>
      'Pronuncia correttamente in coreano ogni carta nella zona per superarla.\nNiente microfono? Puoi giocare anche toccando lo schermo.';

  @override
  String get challengeStart => 'Avvia fotocamera e microfono';

  @override
  String get challengePermissionNote =>
      'È richiesto l\'accesso alla fotocamera anteriore e al microfono (facoltativo).';

  @override
  String get challengeLoadingTitle => 'Caricamento…';

  @override
  String get challengeLoadingNote =>
      'Al primo avvio scarichiamo il modello vocale coreano (~82MB).\nAttendi un momento.';

  @override
  String get challengeSttFallback =>
      'Il riconoscimento vocale non era disponibile, quindi hai giocato con l\'input a tocco.';

  @override
  String get reasonTravelTitle => 'Parlare in viaggio';

  @override
  String get reasonTravelDesc => 'Chiacchiera con sicurezza con i locali';

  @override
  String get reasonCareerTitle => 'Lavoro e carriera';

  @override
  String get reasonCareerDesc => 'Conversazione professionale';

  @override
  String get reasonExamTitle => 'Preparazione esami';

  @override
  String get reasonExamDesc => 'Preparati per gli esami orali';

  @override
  String get reasonDailyTitle => 'Conversazione quotidiana';

  @override
  String get reasonDailyDesc => 'Espressioni che usi ogni giorno';

  @override
  String get reasonFriendsTitle => 'Farsi amici stranieri';

  @override
  String get reasonFriendsDesc => 'Conversazione naturale';

  @override
  String get reasonBrainTitle => 'Stimolazione mentale';

  @override
  String get reasonBrainDesc => 'Migliora memoria e concentrazione';

  @override
  String get challengeRecordToggle => 'Registra questa partita';

  @override
  String get challengeRecordHint =>
      'Salva un video del tuo gameplay da condividere (senza audio).';

  @override
  String get settingsSection => 'Impostazioni';

  @override
  String get paymentSection => 'Pagamento';

  @override
  String get supportSection => 'Assistenza';

  @override
  String get userLanguage => 'Lingua dell\'utente';

  @override
  String get learningLanguage => 'Lingua di apprendimento';

  @override
  String get learningLanguageKorean => 'Coreano';

  @override
  String get notificationLabel => 'Notifiche';

  @override
  String get currentPlan => 'Piano attuale';

  @override
  String get paymentHistory => 'Cronologia pagamenti';

  @override
  String get contactUs => 'Contattaci';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get logOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountTitle => 'Eliminare l\'account?';

  @override
  String get deleteAccountBody =>
      'Questa azione elimina definitivamente il tuo account e i tuoi dati e non può essere annullata.';

  @override
  String get delete => 'Elimina';

  @override
  String get share => 'Condividi';

  @override
  String get accentSoundsLike => 'Il tuo accento coreano sembra';

  @override
  String get hintLabel => 'Suggerimento';

  @override
  String get nextHint => 'Prossimo suggerimento';

  @override
  String get translateLabel => 'Traduci';

  @override
  String get startRecording => 'Avvia registrazione';

  @override
  String get stopRecording => 'Ferma registrazione';

  @override
  String get back => 'Indietro';

  @override
  String get onboardingNameTitle => 'Come dobbiamo chiamarti?';

  @override
  String get onboardingNameSubtitle => 'Il tuo tutor IA ricorderà il tuo nome.';

  @override
  String get nameLabel => 'Il tuo nome';

  @override
  String get nameHint => 'Inserisci il tuo nome';

  @override
  String get nameHelper =>
      'Non deve essere il tuo vero nome: va bene anche un soprannome.';

  @override
  String get continueLabel => 'Continua';

  @override
  String get onboardingDoneTitle => 'Beaver aspetta la tua chiamata';

  @override
  String get onboardingDoneSubtitle => 'Avvia subito una chiamata';

  @override
  String get home => 'Home';

  @override
  String get callNow => 'Chiama ora';

  @override
  String get pronunciation => 'Pronuncia';

  @override
  String get fluency => 'Scorrevolezza';

  @override
  String get rhythm => 'Ritmo';

  @override
  String get analysisTimeout =>
      'Ci sta mettendo più del previsto. Riprova tra un momento.';

  @override
  String get analysisFailed =>
      'Non siamo riusciti ad analizzare la conversazione. Riprova.';

  @override
  String get analyzingConversation => 'Analisi della tua conversazione…';

  @override
  String get analyzingSubtitle => 'Richiederà solo un momento';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get nativeLabel => 'Madrelingua';

  @override
  String get meLabel => 'Io';

  @override
  String get pronunciationPlayError =>
      'Impossibile riprodurre l\'audio della pronuncia.';

  @override
  String get savedExpressionsLoadError =>
      'Impossibile caricare le tue espressioni salvate.';

  @override
  String get mySavedExpressions => 'Le mie espressioni salvate';

  @override
  String get avatarTraits => 'Caloroso · Calmo · Dolce';

  @override
  String get priceFree => 'Gratis';

  @override
  String get loginGoogleTokenError =>
      'Impossibile ottenere un token di accesso Google.';

  @override
  String get loginGoogleSignInFailed => 'Accesso con Google non riuscito.';

  @override
  String get loginAppleSignInFailed => 'Accesso con Apple non riuscito.';

  @override
  String get loginKakaoSignInFailed => 'Accesso con Kakao non riuscito.';

  @override
  String get loginContinueWithKakao => 'Continua con Kakao';

  @override
  String get loginContinueWithGoogle => 'Continua con Google';

  @override
  String get loginContinueWithApple => 'Continua con Apple';

  @override
  String get loginContinueWithEmail => 'Continua con l\'email';

  @override
  String get loginOrDivider => 'oppure';

  @override
  String get loginNoAccount => 'Non hai un account?';

  @override
  String get signUp => 'Registrati';

  @override
  String get loginTermsNoticePrefix => 'Continuando, accetti i nostri ';

  @override
  String get loginTermsNoticeAnd => ' e ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Accedi';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Inserisci la tua email';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get passwordHint => 'Inserisci la tua password';

  @override
  String get loginRememberMe => 'Ricordami';

  @override
  String get loginForgotPassword => 'Password dimenticata?';

  @override
  String get loginLoggingIn => 'Accesso in corso...';

  @override
  String get passwordLengthError =>
      'La password deve avere da 8 a 16 caratteri.';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono.';

  @override
  String get signupCheckInput => 'Controlla i dati inseriti.';

  @override
  String get fieldConfirmPasswordLabel => 'Conferma password';

  @override
  String get confirmPasswordHint => 'Reinserisci la tua password';

  @override
  String get signupSigningUp => 'Registrazione in corso...';

  @override
  String get signupHaveAccount => 'Hai già un account?';

  @override
  String get passwordMethodEmailRequired => 'Inserisci la tua email';

  @override
  String get passwordResetTitle => 'Reimposta password';

  @override
  String get passwordMethodDescription =>
      'Inserisci l\'indirizzo email a cui vuoi ricevere il codice di reimpostazione della password.';

  @override
  String get emailAddressHint => 'Indirizzo email';

  @override
  String get passwordMethodSending => 'Invio in corso...';

  @override
  String get passwordMethodSendEmail => 'Invia email';

  @override
  String get passwordCodeTitle => 'Inserisci il codice';

  @override
  String get passwordCodeDescription =>
      'Abbiamo inviato un codice di recupero alla tua email. Inseriscilo per continuare.';

  @override
  String get passwordCodeNoCode => 'Non hai ricevuto il codice?';

  @override
  String get passwordCodeResend => 'Invia di nuovo il codice';

  @override
  String get passwordCodeVerifying => 'Verifica in corso...';

  @override
  String get passwordNewTitle => 'Nuova password';

  @override
  String get passwordNewDescription =>
      'Imposta una nuova password per il tuo account.';

  @override
  String get fieldNewPasswordLabel => 'Nuova password';

  @override
  String get newPasswordHint => 'Inserisci la tua nuova password';

  @override
  String get fieldConfirmNewPasswordLabel => 'Conferma nuova password';

  @override
  String get confirmNewPasswordHint => 'Reinserisci la tua nuova password';

  @override
  String get passwordNewSubmitting => 'Invio in corso...';

  @override
  String get passwordNewSubmit => 'Invia';

  @override
  String get passwordCompleteTitle => 'Reimpostazione password completata';

  @override
  String get passwordCompleteBody =>
      'La tua password è stata reimpostata. Accedi con la nuova password per continuare.';

  @override
  String get termsTitle => 'Termini di servizio';

  @override
  String get privacyTitle => 'Informativa sulla privacy';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Imposta una nuova password per $email.';
  }

  @override
  String get selectComplete => 'Fatto';

  @override
  String get onboardingLanguageTitle => 'Qual è la tua lingua madre?';

  @override
  String get onboardingReasonTitle => 'Perché stai imparando una lingua?';

  @override
  String get onboardingReasonSubtitle =>
      'Personalizzeremo il tuo apprendimento in base ai tuoi obiettivi.';

  @override
  String get savingLabel => 'Salvataggio...';

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
