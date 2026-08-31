// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get loginRequired => 'Devi accedere.';

  @override
  String get callWebNotSupported =>
      'Le chiamate vocali non sono supportate sul web. Usa l\'app.';

  @override
  String get micPermissionRequiredForCall =>
      'È necessario l\'accesso al microfono. Consenti il microfono per chiamare.';

  @override
  String get callErrorGeneric =>
      'Si è verificato un errore durante la chiamata.';

  @override
  String get callNetworkError => 'Si è verificato un errore di rete.';

  @override
  String get authInvalidCredentials => 'Email o password non corretti.';

  @override
  String get authEmailAlreadyRegistered => 'Questa email è già registrata.';

  @override
  String get authConfirmEmailRequired =>
      'Completa la verifica inviata alla tua email.';

  @override
  String get authResetCodeSent =>
      'Abbiamo inviato un codice di verifica alla tua email.';

  @override
  String get authResetCodeInvalid => 'Il codice non è corretto o è scaduto.';

  @override
  String get authPasswordUpdated => 'La tua password è stata reimpostata.';

  @override
  String get authAppleTokenMissing =>
      'Impossibile ottenere il token di accesso Apple.';

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
  String get quickStart => 'Avvio rapido';

  @override
  String get presetMorning => 'Routine mattutina';

  @override
  String get presetMorningSub => 'Feriali 8:00';

  @override
  String get presetEvening => 'Chiusura serale';

  @override
  String get presetEveningSub => 'Ogni giorno 21:00';

  @override
  String get presetCustom => 'Personalizzato';

  @override
  String get presetCustomSub => 'A tuo modo';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× a settimana · $monthly chiamate al mese';
  }

  @override
  String get alarmSummaryNone => 'Scegli almeno un giorno';

  @override
  String get partnerInUse => 'In uso';

  @override
  String get partnerOwned => 'Posseduto';

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
    return 'Chiamata n. $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Due parole da $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Lasciato da $name subito dopo la chiamata';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Nuove espressioni $count';
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
  String get selectNativeLanguage => 'Seleziona la tua lingua madre';

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
  String get analyzingByWord =>
      'Sto controllando la tua pronuncia parola per parola';

  @override
  String get analyzingTakingLonger => 'Sta richiedendo un po\' più di tempo';

  @override
  String get scanConnectionLost => 'Connessione persa';

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
  String pricePerMonth(String price) {
    return '$price / mese';
  }

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
  String get loginFacebookSignInFailed => 'Accesso con Facebook non riuscito.';

  @override
  String get loginKakaoSignInFailed => 'Accesso con Kakao non riuscito.';

  @override
  String get loginContinueWithKakao => 'Continua con Kakao';

  @override
  String get loginContinueWithGoogle => 'Continua con Google';

  @override
  String get loginContinueWithFacebook => 'Continua con Facebook';

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
  String get thisMonthPayment => 'Pagamento di questo mese';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterSubscription => 'Abbonamento';

  @override
  String get filterCharacter => 'Personaggio';

  @override
  String get statusCompleted => 'Completato';

  @override
  String get lastPayment => 'Ultimo pagamento';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Puoi continuare a usare i vantaggi Pro fino al $date, dopodiché il tuo piano passerà automaticamente a Gratuito.';
  }

  @override
  String get freePlanCallLimit => '1 chiamata al giorno · limite di 5 min';

  @override
  String get freePlanBasicCharacters => 'Personaggi base inclusi';

  @override
  String get availableForPurchase => 'Disponibile all\'acquisto';

  @override
  String get paymentsLoadError => 'Impossibile caricare lo storico pagamenti';

  @override
  String get noPayments => 'Ancora nessun pagamento';

  @override
  String get morePaymentsExist =>
      'I pagamenti più vecchi non sono ancora mostrati';

  @override
  String get undatedPayments => 'Senza data';

  @override
  String get paymentLabelFallback => 'Pagamento';

  @override
  String learningPassed(int passed, int total) {
    return '$passed frasi su $total superate';
  }

  @override
  String get hardestSound => 'Suono più difficile di oggi';

  @override
  String get soundAccuracy => 'Precisione per suono';

  @override
  String phonemeAttempts(int count) {
    return 'Per fonema · $count tentativi';
  }

  @override
  String get colSound => 'Suono';

  @override
  String get colAttempts => 'Tent.';

  @override
  String get colCorrect => 'Corr.';

  @override
  String get colAccuracy => 'Prec.';

  @override
  String get sentenceResults => 'Risultati per frase';

  @override
  String viewAllSentences(int count) {
    return 'Vedi tutte le $count';
  }

  @override
  String get colSentence => 'Frase';

  @override
  String get colPronunciation => 'Pron.';

  @override
  String get colFluency => 'Flu.';

  @override
  String get colRhythm => 'Ritmo';

  @override
  String recentSessions(int count) {
    return 'Ultime $count sessioni';
  }

  @override
  String trendAverage(int score) {
    return 'Media $score';
  }

  @override
  String get today => 'Oggi';

  @override
  String get colDate => 'Data';

  @override
  String get colSentences => 'Frasi';

  @override
  String get colScore => 'Punt.';

  @override
  String get colChange => 'Var.';

  @override
  String dateToday(String date) {
    return '$date (oggi)';
  }

  @override
  String get accentAnalysis => 'Analisi dell\'accento';

  @override
  String get overallLevel => 'Livello complessivo';

  @override
  String get overallLevelSubtitle => 'Lessico · Grammatica · Espressioni';

  @override
  String get pronunciationAnalysis => 'Analisi della pronuncia';

  @override
  String get recentSessionsAverage => 'Media di 10 sessioni';

  @override
  String levelStage(int stage) {
    return 'Livello $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Tra tutti gli studenti';

  @override
  String aheadOfLearners(int percent) {
    return 'Sei avanti al $percent% degli studenti';
  }

  @override
  String get retakeLevelTest => 'Ripeti il test di livello';

  @override
  String get practicePronunciation => 'Esercita la pronuncia';

  @override
  String get priceChangedTitle => 'Il prezzo è cambiato';

  @override
  String priceChangedBody(String price) {
    return 'Questo articolo ora costa $price. Vuoi continuare?';
  }

  @override
  String get billingGroupPlanPurchases => 'Piano e acquisti';

  @override
  String get billingGroupInTheStore => 'Nello store';

  @override
  String get billingChangePlan => 'Cambia piano';

  @override
  String get billingCompareAllPlans => 'Confronta tutti i piani';

  @override
  String get billingBuyACharacter => 'Acquista un personaggio';

  @override
  String get billingRestorePurchases => 'Ripristina acquisti';

  @override
  String get billingPaymentHistory => 'Cronologia pagamenti';

  @override
  String get billingManageInTheStore => 'Gestisci nello store';

  @override
  String get billingRefundHelp => 'Assistenza rimborsi';

  @override
  String get billingCancelSubscription => 'Disdici l\'abbonamento';

  @override
  String get billingResubscribe => 'Riabbonati';

  @override
  String get badgeCurrent => 'Attuale';

  @override
  String get badgeTrial => 'Prova';

  @override
  String get badgeRenewing => 'Si rinnova';

  @override
  String get badgePastDue => 'Pagamento scaduto';

  @override
  String get badgePaused => 'In pausa';

  @override
  String get badgeCanceling => 'In scadenza';

  @override
  String get subscriptionTitle => 'Abbonamento';

  @override
  String get plansTitle => 'Piani';

  @override
  String get planFree => 'Gratis';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Prova Max';

  @override
  String get freePlanPriceLine => '\$0.00 — una chiamata al giorno';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount al mese';
  }

  @override
  String freeUntilDate(String date) {
    return 'Gratis fino al $date';
  }

  @override
  String get todaysCalls => 'Chiamate di oggi';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used di $limit usate';
  }

  @override
  String get firstPaymentLabel => 'Primo pagamento';

  @override
  String get nextPaymentLabel => 'Prossimo pagamento';

  @override
  String get retryingUntilLabel => 'Nuovi tentativi fino al';

  @override
  String get pausedSinceLabel => 'In pausa dal';

  @override
  String planEndsLabel(String plan) {
    return '$plan termina';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Passa all\'illimitato con Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Chiamate illimitate · 15 minuti ciascuna · $price al mese';
  }

  @override
  String get bannerMaxUpsellTitle => 'Attiva il video con Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Chiamate faccia a faccia · $price al mese';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Passa all\'annuale';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly all\'anno · $perMonth al mese';
  }

  @override
  String get bannerPaymentFailedTitle =>
      'Non siamo riusciti ad addebitare il pagamento';

  @override
  String get bannerPaymentFailedSub =>
      'Aggiorna il pagamento nello store per mantenere Pro';

  @override
  String get bannerPausedTitle => 'Il tuo piano è in pausa';

  @override
  String get bannerPausedSub => 'Il pagamento non è mai andato a buon fine';

  @override
  String get noteRestoreHint =>
      'Hai già un abbonamento su un altro dispositivo? Il ripristino lo riporta su questo.';

  @override
  String get noteStoreHandled =>
      'Metodo di pagamento, cambi di piano e disdetta sono gestiti dallo store.';

  @override
  String get noteFairUse =>
      'L\'uso illimitato è soggetto alla nostra politica di utilizzo corretto.';

  @override
  String noteTrialEnds(String date) {
    return 'La tua prova termina il $date. Disdici prima nello store e non ti verrà addebitato nulla.';
  }

  @override
  String get noteGrace =>
      'I tuoi vantaggi restano attivi durante il periodo di tolleranza. La disdetta non viene mai bloccata nell\'app.';

  @override
  String get noteHold =>
      'Pro è in pausa finché il pagamento non va a buon fine. I tuoi personaggi e i tuoi progressi sono al sicuro.';

  @override
  String noteEnding(String date) {
    return 'Il tuo piano sta per terminare. I vantaggi durano fino al $date, poi passi a Gratis. Puoi riabbonarti in qualsiasi momento.';
  }

  @override
  String get trialExpiredTitle => 'La tua prova Max è terminata';

  @override
  String get trialExpiredSub => 'Ora sei su Gratis';

  @override
  String get seePlans => 'Vedi i piani';

  @override
  String get currentPlanTitle => 'Piano attuale';

  @override
  String get badgeRecommended => 'Consigliato';

  @override
  String get perMonthUnit => 'al mese';

  @override
  String get planTaglinePro => 'Chiamate illimitate. 15 minuti ciascuna.';

  @override
  String get planTaglineMax => 'Ora puoi vederli.';

  @override
  String get planTaglineFree => 'Una chiamata al giorno. Offre la casa.';

  @override
  String get bulletProCalls => 'Chiamate vocali, tutte le volte che vuoi';

  @override
  String get bulletProLength => '15 minuti a chiamata';

  @override
  String get bulletProScoring => 'Pronuncia valutata lettera per lettera';

  @override
  String get bulletProCorrections =>
      'Correzioni pensate per la tua lingua madre';

  @override
  String get bulletProBeaverCalls => 'Beaver ti chiama per primo';

  @override
  String get bulletMaxVideo => 'Videochiamate faccia a faccia';

  @override
  String get bulletMaxEverything => 'Tutto ciò che offre Pro';

  @override
  String get bulletMaxCharacters => 'Tutti i personaggi, senza limiti';

  @override
  String get bulletMaxStudyBook =>
      'Un libro di studio su misura per il tuo livello';

  @override
  String get bulletMaxWeeklyReport =>
      'Un report settimanale su come cambia la tua pronuncia';

  @override
  String get bulletFreeCall => 'Una chiamata vocale di 5 minuti al giorno';

  @override
  String get bulletFreeCheck => 'Un controllo di pronuncia al giorno';

  @override
  String get bulletFreeAccent => 'Controlli dell\'accento illimitati';

  @override
  String get bulletFreeCharacter => 'Un personaggio per iniziare';

  @override
  String get ctaGoUnlimited => 'Passa all\'illimitato';

  @override
  String get ctaTurnOnVideo => 'Attiva il video';

  @override
  String get noteCallLength => 'Ogni chiamata dura 15 minuti.';

  @override
  String get paywallProTitle1 => 'Il tuo amico coreano';

  @override
  String get paywallProTitle2 => 'sveglio alle 3 di notte';

  @override
  String get paywallProSub =>
      'Chiamate illimitate. 15 minuti ciascuna. Tutto l\'anno.';

  @override
  String get paywallLimitHeadline => 'Pro elimina il limite.';

  @override
  String get limitBannerCallTitle => 'Questa era la chiamata di oggi';

  @override
  String get limitBannerCallSub => 'Gratis ti dà una chiamata al giorno';

  @override
  String get limitBannerCheckTitle => 'Questo era il controllo di oggi';

  @override
  String get limitBannerCheckSub => 'Gratis ti dà un controllo al giorno';

  @override
  String get bulletProCharactersForever =>
      'I personaggi che acquisti restano tuoi per sempre';

  @override
  String get paywallMaxTitle => 'Ora puoi vederli.';

  @override
  String get paywallMaxSub =>
      'Videochiamate, tutti i personaggi e un libro di studio su misura per il tuo livello.';

  @override
  String get planMonthly => 'Mensile';

  @override
  String get planAnnual => 'Annuale';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price al mese';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth al mese';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price al mese';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly all\'anno · $perMonth al mese';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price al mese · disdici quando vuoi nello store';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price al mese · disdici quando vuoi nello store';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 giorni gratis, poi $price al mese · disdici quando vuoi nello store';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Si rinnova automaticamente fino alla cancellazione.';

  @override
  String get footerTerms => 'Termini';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get noteMaxCharacters =>
      'I personaggi sbloccati con Max sono disponibili finché il tuo abbonamento è attivo. I personaggi acquistati restano tuoi.';

  @override
  String get processingTitle => 'Stiamo confermando il tuo acquisto';

  @override
  String get processingSub => 'Di solito ci vogliono pochi secondi.';

  @override
  String get successProTitle => 'Sei su Pro.';

  @override
  String get successProSub => 'Chiamate illimitate, da subito.';

  @override
  String get successProBenefit1 =>
      'Chiama tutte le volte che vuoi — 15 minuti a chiamata';

  @override
  String get successProBenefit2 => 'Controlli di pronuncia illimitati';

  @override
  String get successProBenefit3 => 'Tutti i personaggi, più acquisti singoli';

  @override
  String get successMaxTitle => 'Ora puoi vederli.';

  @override
  String get successMaxSub =>
      'Le videochiamate sono attive. Tocca il pulsante video in qualsiasi chiamata.';

  @override
  String get successMaxBenefit1 => 'Videochiamate faccia a faccia';

  @override
  String get successMaxBenefit2 =>
      'Tutti i personaggi, senza limiti e le novità in anteprima';

  @override
  String get successMaxBenefit3 =>
      'Un libro di studio su misura per il tuo livello';

  @override
  String get ctaStartACall => 'Avvia una chiamata';

  @override
  String get ctaStartAVideoCall => 'Avvia una videochiamata';

  @override
  String get ctaSeeYourSubscription => 'Vedi il tuo abbonamento';

  @override
  String successProCaption(String price) {
    return '$price vengono addebitati ogni mese finché non disdici. Gestisci o disdici quando vuoi nello store.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price vengono addebitati ogni mese finché non disdici. Gestisci o disdici quando vuoi nello store.';
  }

  @override
  String get plansErrorTitle => 'Non siamo riusciti a caricare i piani';

  @override
  String get plansErrorSub => 'Lo store non ha risposto.';

  @override
  String get ctaTryAgain => 'Riprova';

  @override
  String get plansErrorCaption => 'Non è stato addebitato nulla.';

  @override
  String get changePlanTitle => 'Cambia piano';

  @override
  String get moveToMaxTitle => 'Passa a Max';

  @override
  String maxPriceShort(String price) {
    return '$price/mese';
  }

  @override
  String get moveToMaxCardSub =>
      'Videochiamate faccia a faccia · tutti i personaggi · un libro di studio fatto per te';

  @override
  String get whatHappensNow => 'Cosa succede ora';

  @override
  String get maxStartsLabel => 'Max inizia';

  @override
  String get immediately => 'Immediatamente';

  @override
  String get unusedProTime => 'Tempo Pro non utilizzato';

  @override
  String get creditedTowardMax => 'Accreditato su Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Passa a Max';

  @override
  String get upgradeCaption =>
      'Il tuo nuovo piano parte subito. Il tempo Pro non utilizzato viene accreditato, mai addebitato due volte.';

  @override
  String get moveToProTitle => 'Passa a Pro';

  @override
  String get moveToProSub =>
      'Oggi non cambia nulla. Max continua fino alla fine del mese già pagato.';

  @override
  String get maxRunsUntil => 'Max continua fino al';

  @override
  String get proStarts => 'Pro inizia';

  @override
  String get whatYouKeep => 'Cosa mantieni';

  @override
  String get keepBenefitCalls =>
      'Chiamate vocali illimitate, 15 minuti ciascuna';

  @override
  String get keepBenefitCharacters =>
      'I personaggi che hai acquistato restano tuoi per sempre';

  @override
  String downgradeWarning(String date) {
    return 'Le videochiamate e i personaggi esclusivi di Max si disattivano il $date.';
  }

  @override
  String get ctaSwitchToPro => 'Passa a Pro';

  @override
  String get ctaKeepMax => 'Tieni Max';

  @override
  String get winbackSkip => 'Salta';

  @override
  String get winbackTitle => 'Il tuo piano Pro è terminato';

  @override
  String get winbackSub => 'Ora sei su Gratis — una chiamata al giorno.';

  @override
  String get winbackQuestion => 'Ti va di dirci perché te ne sei andato?';

  @override
  String get winbackReasonExpensive => 'Troppo caro';

  @override
  String get winbackReasonUnused => 'Non lo usavo abbastanza';

  @override
  String get winbackReasonMissing => 'Mancava una funzione che mi serviva';

  @override
  String get winbackReasonOtherApp => 'Ho trovato un\'altra app';

  @override
  String get winbackReasonElse => 'Altro';

  @override
  String get ctaSend => 'Invia';

  @override
  String get ctaNotNow => 'Non ora';

  @override
  String get winbackCaption =>
      'Questo non ripristina il tuo piano. Riabbonati nello store.';

  @override
  String get ctaContinue => 'Continua';

  @override
  String get ctaClose => 'Chiudi';

  @override
  String get ovRestoreSuccessTitle => 'Pro è tornato';

  @override
  String get ovRestoreSuccessBody =>
      'Abbiamo trovato il tuo abbonamento e l\'abbiamo riattivato su questo dispositivo.';

  @override
  String get ovRestoreEmptyTitle => 'Niente da ripristinare';

  @override
  String get ovRestoreEmptyBody =>
      'Nessun abbonamento attivo è collegato a questo account dello store.';

  @override
  String get ovRestoreOtherTitle => 'Quel piano appartiene a un altro account';

  @override
  String get ovRestoreOtherBody =>
      'Questo abbonamento è già attivo su un altro account BeaverTalk.';

  @override
  String get ctaSignInThatAccount => 'Accedi a quell\'account';

  @override
  String get ctaGetHelp => 'Chiedi aiuto';

  @override
  String get ovCharacterOfferTitle => 'Non sei pronto per Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Scegli un personaggio e tienilo. Un acquisto una tantum — niente abbonamento, niente rinnovo.';

  @override
  String get rowOneCharacter => 'Un personaggio';

  @override
  String rowFromPrice(String price) {
    return 'da $price';
  }

  @override
  String get rowYoursForever => 'Tuo per sempre';

  @override
  String get rowNoRenewal => 'Nessun rinnovo';

  @override
  String get rowWorksOnFree => 'Funziona con Gratis';

  @override
  String get rowYes => 'Sì';

  @override
  String get ctaSeeCharacters => 'Vedi i personaggi';

  @override
  String get ovNotEligibleTitle => 'Niente da disdire';

  @override
  String get ovNotEligibleBody =>
      'Sei su Gratis. Non c\'è nessun abbonamento attivo su questo account.';

  @override
  String get ovCancelDownsellTitle => 'Prima di andare';

  @override
  String get ovCancelDownsellBody =>
      'La disdetta avviene nello store. Due cose da sapere.';

  @override
  String get rowPayYearlyInstead => 'Paga una volta all\'anno';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price al mese';
  }

  @override
  String get rowCharactersYouBought => 'Personaggi acquistati';

  @override
  String get rowProRunsUntil => 'Pro continua fino al';

  @override
  String get ctaSwitchToYearly => 'Passa all\'annuale';

  @override
  String get ctaContinueToStore => 'Continua verso lo store';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Paga all\'anno e risparmia $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Sei su Pro da due mesi. Il piano annuale conviene di più.';

  @override
  String get rowYouSave => 'Risparmi';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Annuale';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Mensile, per un anno';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Passa al mensile';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Il tuo piano annuale dura fino al $date. La fatturazione mensile inizia il giorno dopo.';
  }

  @override
  String get rowMonthlyBillingStarts => 'La fatturazione mensile inizia';

  @override
  String get rowMonthlyLabel => 'Mensile';

  @override
  String get rowYearlyWorkedOut => 'L\'annuale equivaleva a';

  @override
  String get ctaSwitchToMonthly => 'Passa al mensile';

  @override
  String get ovRefundHelpTitle => 'I rimborsi sono gestiti dallo store';

  @override
  String get ovRefundHelpBody =>
      'Non possiamo emettere rimborsi direttamente. Ogni richiesta viene esaminata dallo store.';

  @override
  String get ctaGoToStore => 'Vai allo store';

  @override
  String get ovTrialEndingTitle => 'La tua prova termina domani';

  @override
  String get ovTrialEndingBody =>
      'Max continua a meno che tu non disdica. Ecco cosa succede.';

  @override
  String get rowTrialEnds => 'La prova termina';

  @override
  String get rowFirstCharge => 'Primo addebito';

  @override
  String get rowThenMonthly => 'Poi ogni mese';

  @override
  String get ctaCancelInStore => 'Disdici nello store';

  @override
  String get ovTrialStartTitle => '7 giorni di Max, gratis';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Gratis fino al $date. Poi $price al mese, a meno che tu non disdica nello store.';
  }

  @override
  String get ctaStart7Days => 'Inizia 7 giorni gratis';

  @override
  String get ovOtoTitle => 'Un\'ultima cosa prima di iniziare';

  @override
  String get ovOtoBody =>
      'Ottima scelta — le chiamate illimitate sono già attive. Lo stesso Pro costa meno se paghi all\'anno.';

  @override
  String get ovFailedDeclinedTitle => 'La tua carta è stata rifiutata';

  @override
  String get ovFailedDeclinedBody =>
      'Lo store non è riuscito ad addebitare il pagamento. Non è stato addebitato nulla.';

  @override
  String get ctaUpdatePaymentMethod => 'Aggiorna metodo di pagamento';

  @override
  String get ovFailedCanceledTitle => 'Pagamento annullato';

  @override
  String get ovFailedCanceledBody =>
      'Sei ancora su Gratis. Non è stato addebitato nulla.';

  @override
  String get ovFailedStoreTitle => 'Qualcosa è andato storto';

  @override
  String get ovFailedStoreBody =>
      'Non siamo riusciti a raggiungere lo store. Non è stato addebitato nulla.';

  @override
  String get ovAlreadyTitle => 'Sei già su Pro';

  @override
  String get ovAlreadyBody =>
      'Questo account dello store ha già un piano attivo. Non c\'è niente da acquistare.';

  @override
  String get ctaSeeMySubscription => 'Vedi il mio abbonamento';

  @override
  String get subCancelTitle => 'Disdici l\'abbonamento';

  @override
  String subCancelBody(String date) {
    return 'Pro continua fino al $date. Dopo passi a Gratis.';
  }

  @override
  String get subWhatYouLose => 'Cosa perdi';

  @override
  String get benefitCalls15 => 'Chiamate illimitate, 15 minuti ciascuna';

  @override
  String get benefitScoring => 'Pronuncia valutata lettera per lettera';

  @override
  String get benefitEveryCharacter => 'Tutti i personaggi, senza limiti';

  @override
  String get ctaKeepPro => 'Tieni Pro';

  @override
  String get subPaymentTitle => 'Aggiorna pagamento';

  @override
  String get subPaymentBody =>
      'Non siamo riusciti ad addebitare il pagamento. Pro resta attivo durante il periodo di tolleranza.';

  @override
  String get subHowToFix => 'Come risolvere';

  @override
  String get fixStep1 => 'Apri lo store e aggiorna il tuo metodo di pagamento';

  @override
  String get fixStep2 => 'Torna qui — il tuo piano riprende automaticamente';

  @override
  String get fixStep3 => 'Nulla viene addebitato due volte';

  @override
  String get subResubTitle => 'Riabbonati';

  @override
  String subResubBody(String date) {
    return 'Pro termina il $date. Riattiva il rinnovo automatico e non cambia nulla.';
  }

  @override
  String get subWhatYouKeep => 'Cosa mantieni';

  @override
  String get ctaTurnItBackOn => 'Riattiva';

  @override
  String get flTodayTitle => 'Questa era la chiamata di oggi';

  @override
  String get flTodayBody => 'Riprendi da dove avevi lasciato — subito.';

  @override
  String get flCheckTitle => 'Questo era il controllo di oggi';

  @override
  String get flCheckBody =>
      'Un controllo al giorno su Gratis. Con Pro è illimitato.';

  @override
  String get flBenefitCalls =>
      'Chiamate illimitate con Pro · 15 minuti ciascuna';

  @override
  String get flBenefitChecks => 'Controlli di pronuncia illimitati con Pro';

  @override
  String flCaption(String price) {
    return '$price al mese · disdici quando vuoi';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used di $limit usati';
  }

  @override
  String get ctaMaybeTomorrow => 'Magari domani';

  @override
  String get accountSection => 'Account';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Metodo di accesso';

  @override
  String get joinedLabel => 'Iscrizione';

  @override
  String get editNicknameTitle => 'Modifica nickname';

  @override
  String get nicknameRule => '2–12 caratteri. Lettere e numeri. Solo inglese';

  @override
  String get ctaSave => 'Salva';

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
  String get paywallLeaveTitle => 'Se esci ora, non sarai abbonato';

  @override
  String get paywallLeaveBody =>
      'I vantaggi si sbloccano subito dopo il pagamento. Puoi tornare quando vuoi da La mia pagina.';

  @override
  String get ctaKeepLooking => 'Continua a guardare';

  @override
  String get ctaLeaveAnyway => 'Esci comunque';

  @override
  String get iapCharacterSuccessTitle => 'Un nuovo amico si unisce a te!';

  @override
  String get iapCharacterSuccessBody =>
      'Questo personaggio è tuo per sempre: resta anche se cambi piano, e Ripristina acquisti lo riporta su qualsiasi dispositivo.';

  @override
  String get iapCharacterFailedBody =>
      'L\'acquisto non è andato a buon fine. Non è stato addebitato nulla: riprova.';

  @override
  String get noAccentDataTitle => 'Ancora nessun dato sull\'intonazione';

  @override
  String get noAccentDataBody =>
      'Continua a parlare e i tratti della tua intonazione si accumuleranno.';

  @override
  String get noLevelYetTitle => 'Ancora nessun livello';

  @override
  String get noLevelYetBody =>
      'Completa la prima chiamata per ottenere il tuo livello.';

  @override
  String get noPronunciationDataTitle =>
      'Ancora nessuna registrazione della pronuncia';

  @override
  String get noPronunciationDataBody =>
      'Analizziamo la tua pronuncia dalle frasi che dici durante le chiamate.';

  @override
  String get noCharacterNote => 'Non è ancora stato detto nulla';

  @override
  String get noPhonemesYet => 'Ancora nessun suono da analizzare';

  @override
  String get noSentencesYet => 'Ancora nessuna frase da analizzare';

  @override
  String get takeLevelTest => 'Fai il test di livello';

  @override
  String get reviewToSeeScore => 'Ripassa per vedere il punteggio di pronuncia';

  @override
  String get playAgain => 'Gioca di nuovo';

  @override
  String get difficultySlow => 'Lento';

  @override
  String get difficultyNormal => 'Normale';

  @override
  String get difficultyFast => 'Veloce';

  @override
  String get difficultyLabel => 'Difficoltà';

  @override
  String get connected => 'Connesso';

  @override
  String get unlockedWithMax => 'Disponibile con Max';

  @override
  String get callModeSheetTitle => 'Come vuoi parlare?';

  @override
  String get callModeSheetSubtitle => 'Si applica subito a questa chiamata';

  @override
  String get callModeFreeTalk => 'Chiacchierata libera';

  @override
  String get callModeFreeTalkDesc => 'Parla senza correzioni';

  @override
  String get callModeStudy => 'Studio';

  @override
  String get callModeStudyDesc => 'Impara un’espressione alla volta';

  @override
  String get callModeChange => 'Cambia modalità';

  @override
  String get callModeKeep => 'Non ora';

  @override
  String get callExitTitle => 'Terminare la chiamata?';

  @override
  String get callExitSubtitle => 'Terminare ora consuma comunque una chiamata';

  @override
  String get callExitKeep => 'Continua a parlare';

  @override
  String get callExitConfirm => 'Termina chiamata';

  @override
  String get callMicMute => 'Disattiva microfono';

  @override
  String get callMicUnmute => 'Attiva microfono';

  @override
  String get callPushToTalk => 'Tieni premuto per parlare';

  @override
  String get callFreeEndedTitle => 'La tua chiamata gratuita è finita';

  @override
  String get callFreeEndedCta => 'Abbonati e continua a parlare';

  @override
  String get callKeepGoingTitle => 'Continuiamo?';

  @override
  String get callKeepGoingSubtitle =>
      'Le chiamate proseguono a blocchi di 5 minuti. Te lo chiederemo ogni volta.';

  @override
  String get articulationSelectedWord => 'Parola selezionata';

  @override
  String get articulationYouSaid => 'La tua pronuncia';

  @override
  String get articulationTargetSound => 'Obiettivo';
}
