// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Anruf beendet $duration';
  }

  @override
  String get callRatingPrompt => 'Wie war dein Anruf?';

  @override
  String get ratingBad => 'Nicht so gut';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get ratingGood => 'Gut';

  @override
  String get goHome => 'Startseite';

  @override
  String get viewAnalysis => 'Analyse ansehen';

  @override
  String get loadingShort => 'Wird geladen…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Bewertung konnte nicht gesendet werden: $message';
  }

  @override
  String get callInfoNotFound =>
      'Anrufinformationen nicht gefunden, Analyse wird übersprungen.';

  @override
  String get tabRecords => 'Aufzeichnungen';

  @override
  String get tabArchive => 'Archiv';

  @override
  String get callHistory => 'Anrufverlauf';

  @override
  String get conversationRecord => 'Gesprächsaufzeichnung';

  @override
  String get noCallRecords => 'Noch keine Anrufaufzeichnungen';

  @override
  String get noCallRecordsBody =>
      'Sobald du deinen ersten Anruf mit der KI beendet hast,\ndeine Aufzeichnungen erscheinen hier.';

  @override
  String get startCall => 'Anruf starten';

  @override
  String get recordsLoadError => 'Aufzeichnungen konnten nicht geladen werden';

  @override
  String get tryAgainLater => 'Bitte versuche es später erneut.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes Min. $seconds Sek.';
  }

  @override
  String get scheduleManagement => 'Zeitplan';

  @override
  String get alarms => 'Erinnerungen';

  @override
  String get addSchedule => 'Zeitplan hinzufügen';

  @override
  String get editSchedule => 'Zeitplan bearbeiten';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get alarmsLoadError => 'Erinnerungen konnten nicht geladen werden';

  @override
  String get charactersLoadError => 'Charaktere konnten nicht geladen werden';

  @override
  String get noCharacters => 'Keine Charaktere verfügbar';

  @override
  String get close => 'Schließen';

  @override
  String get repeat => 'Wiederholen';

  @override
  String get callPartner => 'Charakter';

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
  String get am => 'vorm.';

  @override
  String get pm => 'nachm.';

  @override
  String get save => 'Speichern';

  @override
  String get conversation => 'Gespräch';

  @override
  String get review => 'Überprüfung';

  @override
  String get pronunciationChallenge => 'Aussprache-Challenge';

  @override
  String get newExpressions => 'Neue Ausdrücke';

  @override
  String get analysisResult => 'Analyseergebnis';

  @override
  String get noNewExpressions => 'Keine neuen Ausdrücke aus diesem Gespräch.';

  @override
  String get practice => 'Üben';

  @override
  String recentScore(int score) {
    return 'Letzte Punktzahl $score%';
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
      'Das Analyseergebnis konnte nicht geladen werden.';

  @override
  String get standardAudioNotReady =>
      'Die Standardaussprache ist noch nicht bereit.';

  @override
  String get standardAudioPlayError =>
      'Die Standardaussprache konnte nicht abgespielt werden.';

  @override
  String get selectACountry => 'Land auswählen';

  @override
  String get selectYourLanguage => 'Wähle deine Sprache';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get selectTime => 'Uhrzeit auswählen';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get permissionTitle =>
      'Berechtigungen erlauben\nfür ein reibungsloses Erlebnis';

  @override
  String get permissionSubtitle =>
      'Erforderliche Berechtigungen sind notwendig, um den Dienst zu nutzen.';

  @override
  String get permissionMicTitle => 'Mikrofon (erforderlich)';

  @override
  String get permissionMicDesc =>
      'Wird benötigt, um mit der KI auf Englisch zu sprechen.';

  @override
  String get permissionNotifTitle => 'Benachrichtigungen (optional)';

  @override
  String get permissionNotifDesc =>
      'Wir senden dir Lernerinnerungen und Anruftermine.';

  @override
  String get micPermissionNeededTitle => 'Mikrofonzugriff erforderlich';

  @override
  String get micPermissionNeededBody =>
      'Um mit der KI zu sprechen, musst du den Mikrofonzugriff erlauben. Bitte aktiviere ihn in den Einstellungen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get connectionFailedTitle => 'Verbindung fehlgeschlagen';

  @override
  String get connectionFailedBody =>
      'Überprüfe deine Netzwerkverbindung\nund versuche es erneut.';

  @override
  String get checkout => 'Kasse';

  @override
  String get pay => 'Bezahlen';

  @override
  String get orderSummary => 'Bestellübersicht';

  @override
  String get paymentMethod => 'Zahlungsmethode';

  @override
  String get payMethodCard => 'Kredit-/Debitkarte';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Nerviger Biber-Avatar';

  @override
  String get productTrait => 'Premium-Charakter · Für immer deiner';

  @override
  String get amountItemPrice => 'Artikelpreis';

  @override
  String get amountDiscount => 'Rabatt';

  @override
  String get amountTotal => 'Gesamt';

  @override
  String get paymentCompleteTitle => 'Zahlung abgeschlossen';

  @override
  String get paymentCompleteBody =>
      'Der Avatar wurde deiner Sammlung hinzugefügt.';

  @override
  String get viewCollection => 'Sammlung ansehen';

  @override
  String get receiptItem => 'Artikel';

  @override
  String get receiptAmount => 'Betrag';

  @override
  String get receiptMethod => 'Zahlungsmethode';

  @override
  String get receiptDate => 'Datum';

  @override
  String get paymentFailedTitle => 'Zahlung fehlgeschlagen';

  @override
  String get paymentFailedBody =>
      'Deine Zahlung konnte nicht verarbeitet werden.\nBitte versuche es erneut.';

  @override
  String get freeCallEndingTitle => 'Dein kostenloser Anruf endet gleich';

  @override
  String get freeCallEndingBody =>
      'Abonniere, um länger mit Beaver zu sprechen.';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get endCall => 'Anruf beenden';

  @override
  String get callEnded => 'Der Anruf wurde beendet.';

  @override
  String get connecting => 'Verbindung wird hergestellt…';

  @override
  String get connectingHint =>
      'Das dauert normalerweise weniger als 5 Sekunden';

  @override
  String get callConnectFailed => 'Der Anruf konnte nicht verbunden werden.';

  @override
  String get saveSentenceFailed => 'Der Satz konnte nicht gespeichert werden.';

  @override
  String get recordStartFailed => 'Die Aufnahme konnte nicht gestartet werden.';

  @override
  String get recordTooShort =>
      'Die Aufnahme war zu kurz. Bitte versuche es erneut.';

  @override
  String get gradingFailed =>
      'Bewertung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get listenStandard => 'Standardaussprache anhören';

  @override
  String get saveSentence => 'Satz speichern';

  @override
  String get unsaveSentence => 'Gespeicherten Satz entfernen';

  @override
  String get scoringPronunciation => 'Deine Aussprache wird bewertet…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'Keine Aufnahme zum Abspielen vorhanden.';

  @override
  String get myRecordingPlayError =>
      'Deine Aufnahme konnte nicht abgespielt werden.';

  @override
  String get next => 'Weiter';

  @override
  String get endLearning => 'Sitzung beenden';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navCall => 'Anruf';

  @override
  String get navStats => 'Statistik';

  @override
  String get myPage => 'Mein Bereich';

  @override
  String get languageSaveFailed =>
      'Deine Sprache konnte nicht gespeichert werden.';

  @override
  String get accountDeleteFailed => 'Dein Konto konnte nicht gelöscht werden.';

  @override
  String get changeAvatar => 'Avatar ändern';

  @override
  String get avatarIntro =>
      'Stimme und Schwierigkeitsgrad variieren je nach Gesprächspartner.\nManche Partner sind kostenpflichtig.';

  @override
  String myPartnersOwned(int count) {
    return 'Meine Partner · $count im Besitz';
  }

  @override
  String get limitedDiscount => 'Zeitlich begrenzter Rabatt';

  @override
  String get available => 'Verfügbar';

  @override
  String get inUse => 'In Verwendung';

  @override
  String get owned => 'Im Besitz';

  @override
  String get noCharactersToShow => 'Keine Charaktere zum Anzeigen';

  @override
  String get buy => 'Kaufen';

  @override
  String get noSavedSentences =>
      'Noch keine gespeicherten Sätze.\nMarkiere Sätze aus deinen Gesprächsaufzeichnungen.';

  @override
  String get noAlarms => 'Noch keine Erinnerungen';

  @override
  String get noAlarmsBody =>
      'Füge eine Lernerinnerung hinzu,\num eine feste Gewohnheit aufzubauen.';

  @override
  String get subscriptionManage => 'Abo verwalten';

  @override
  String get changePlan => 'Plan ändern';

  @override
  String get cancelSubscription => 'Abo kündigen';

  @override
  String get benefitsInUse => 'Deine Vorteile';

  @override
  String get paymentInfo => 'Zahlungsinformationen';

  @override
  String get nextBillingDate => 'Nächstes Abrechnungsdatum';

  @override
  String get lostBenefitsTitle =>
      'Vorteile, die du bei einer Kündigung verlierst';

  @override
  String get viewBillingHistory => 'Abrechnungsverlauf ansehen';

  @override
  String get keepUsingPro => 'Pro weiter nutzen';

  @override
  String get proMembership => 'Pro-Mitgliedschaft';

  @override
  String get pricePerMonth => '\$12,9 / Monat';

  @override
  String get benefitUnlimitedCalls => 'Unbegrenzte Anrufe';

  @override
  String get benefitDetailedAnalysis =>
      'Detaillierte Aussprache- und Grammatikanalyse';

  @override
  String get benefitAllCharacters => 'Zugriff auf alle Charaktere';

  @override
  String get benefitNoAds => 'Keine Werbung';

  @override
  String get playSampleVoice => 'Hörprobe abspielen';

  @override
  String get useThisAvatar => 'Diesen verwenden';

  @override
  String get challengeTitle => 'Aussprache-Challenge';

  @override
  String get challengeIntro =>
      'Sprich jede Karte in der Zone korrekt auf Koreanisch aus, um sie zu schaffen.\nKein Mikrofon? Du kannst auch durch Tippen auf den Bildschirm spielen.';

  @override
  String get challengeStart => 'Kamera & Mikrofon starten';

  @override
  String get challengePermissionNote =>
      'Zugriff auf Frontkamera und Mikrofon ist erforderlich (optional).';

  @override
  String get challengeLoadingTitle => 'Wird geladen…';

  @override
  String get challengeLoadingNote =>
      'Beim ersten Start wird das koreanische Sprachmodell (~82MB) heruntergeladen.\nBitte warte einen Moment.';

  @override
  String get challengeSttFallback =>
      'Die Spracherkennung war nicht verfügbar, daher hast du mit Tipp-Eingabe gespielt.';

  @override
  String get reasonTravelTitle => 'Sprechen auf Reisen';

  @override
  String get reasonTravelDesc => 'Selbstbewusst mit Einheimischen sprechen';

  @override
  String get reasonCareerTitle => 'Arbeit & Karriere';

  @override
  String get reasonCareerDesc => 'Geschäftliche Gespräche';

  @override
  String get reasonExamTitle => 'Prüfungsvorbereitung';

  @override
  String get reasonExamDesc => 'Auf mündliche Prüfungen vorbereiten';

  @override
  String get reasonDailyTitle => 'Alltagsgespräche';

  @override
  String get reasonDailyDesc => 'Ausdrücke, die du täglich verwendest';

  @override
  String get reasonFriendsTitle => 'Freunde im Ausland finden';

  @override
  String get reasonFriendsDesc => 'Natürliche Gespräche';

  @override
  String get reasonBrainTitle => 'Gehirntraining';

  @override
  String get reasonBrainDesc => 'Gedächtnis & Konzentration stärken';

  @override
  String get challengeRecordToggle => 'Diesen Durchlauf aufnehmen';

  @override
  String get challengeRecordHint =>
      'Speichert ein Video deines Spiels zum Teilen (ohne Ton).';

  @override
  String get settingsSection => 'Einstellungen';

  @override
  String get paymentSection => 'Zahlung';

  @override
  String get supportSection => 'Support';

  @override
  String get userLanguage => 'Benutzersprache';

  @override
  String get learningLanguage => 'Lernsprache';

  @override
  String get learningLanguageKorean => 'Koreanisch';

  @override
  String get notificationLabel => 'Benachrichtigung';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get paymentHistory => 'Zahlungsverlauf';

  @override
  String get contactUs => 'Kontaktiere uns';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get logOut => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountBody =>
      'Dadurch werden dein Konto und deine Daten dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get delete => 'Löschen';

  @override
  String get share => 'Teilen';

  @override
  String get accentSoundsLike => 'Dein koreanischer Akzent klingt';

  @override
  String get hintLabel => 'Hinweis';

  @override
  String get nextHint => 'Nächster Hinweis';

  @override
  String get translateLabel => 'Übersetzen';

  @override
  String get startRecording => 'Aufnahme starten';

  @override
  String get stopRecording => 'Aufnahme stoppen';

  @override
  String get back => 'Zurück';

  @override
  String get onboardingNameTitle => 'Wie sollen wir dich nennen?';

  @override
  String get onboardingNameSubtitle => 'Dein KI-Tutor merkt sich deinen Namen.';

  @override
  String get nameLabel => 'Dein Name';

  @override
  String get nameHint => 'Gib deinen Namen ein';

  @override
  String get nameHelper =>
      'Es muss nicht dein echter Name sein — ein Spitzname geht auch.';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get onboardingDoneTitle => 'Beaver wartet auf deinen Anruf';

  @override
  String get onboardingDoneSubtitle => 'Starte jetzt einen Anruf';

  @override
  String get home => 'Start';

  @override
  String get callNow => 'Jetzt anrufen';

  @override
  String get pronunciation => 'Aussprache';

  @override
  String get fluency => 'Sprachfluss';

  @override
  String get rhythm => 'Rhythmus';

  @override
  String get analysisTimeout =>
      'Das dauert länger als erwartet. Bitte versuche es gleich noch einmal.';

  @override
  String get analysisFailed =>
      'Wir konnten das Gespräch nicht analysieren. Bitte versuche es erneut.';

  @override
  String get analyzingConversation => 'Dein Gespräch wird analysiert…';

  @override
  String get analyzingSubtitle => 'Das dauert nur einen Moment';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get nativeLabel => 'Muttersprachler';

  @override
  String get meLabel => 'Ich';

  @override
  String get pronunciationPlayError =>
      'Die Ausspracheaufnahme konnte nicht abgespielt werden.';

  @override
  String get savedExpressionsLoadError =>
      'Deine gespeicherten Ausdrücke konnten nicht geladen werden.';

  @override
  String get mySavedExpressions => 'Meine gespeicherten Ausdrücke';

  @override
  String get avatarTraits => 'Warmherzig · Ruhig · Sanft';

  @override
  String get priceFree => 'Kostenlos';

  @override
  String get loginGoogleTokenError =>
      'Google-Anmeldetoken konnte nicht abgerufen werden.';

  @override
  String get loginGoogleSignInFailed => 'Google-Anmeldung fehlgeschlagen.';

  @override
  String get loginAppleSignInFailed => 'Apple-Anmeldung fehlgeschlagen.';

  @override
  String get loginKakaoSignInFailed => 'Kakao-Anmeldung fehlgeschlagen.';

  @override
  String get loginContinueWithKakao => 'Mit Kakao fortfahren';

  @override
  String get loginContinueWithGoogle => 'Mit Google fortfahren';

  @override
  String get loginContinueWithApple => 'Mit Apple fortfahren';

  @override
  String get loginContinueWithEmail => 'Mit E-Mail fortfahren';

  @override
  String get loginOrDivider => 'oder';

  @override
  String get loginNoAccount => 'Noch kein Konto?';

  @override
  String get signUp => 'Registrieren';

  @override
  String get loginTermsNoticePrefix =>
      'Wenn du fortfährst, stimmst du unseren ';

  @override
  String get loginTermsNoticeAnd => ' und ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Anmelden';

  @override
  String get fieldEmailLabel => 'E-Mail';

  @override
  String get emailHint => 'Gib deine E-Mail-Adresse ein';

  @override
  String get fieldPasswordLabel => 'Passwort';

  @override
  String get passwordHint => 'Gib dein Passwort ein';

  @override
  String get loginRememberMe => 'Angemeldet bleiben';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginLoggingIn => 'Anmeldung läuft…';

  @override
  String get passwordLengthError => 'Das Passwort muss 8–16 Zeichen lang sein.';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein.';

  @override
  String get signupCheckInput => 'Bitte überprüfe deine Eingaben.';

  @override
  String get fieldConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get confirmPasswordHint => 'Passwort erneut eingeben';

  @override
  String get signupSigningUp => 'Registrierung läuft…';

  @override
  String get signupHaveAccount => 'Du hast bereits ein Konto?';

  @override
  String get passwordMethodEmailRequired => 'Gib deine E-Mail-Adresse ein';

  @override
  String get passwordResetTitle => 'Passwort zurücksetzen';

  @override
  String get passwordMethodDescription =>
      'Gib die E-Mail-Adresse ein, an die du den Code zum Zurücksetzen des Passworts erhalten möchtest.';

  @override
  String get emailAddressHint => 'E-Mail-Adresse';

  @override
  String get passwordMethodSending => 'Wird gesendet…';

  @override
  String get passwordMethodSendEmail => 'E-Mail senden';

  @override
  String get passwordCodeTitle => 'Code eingeben';

  @override
  String get passwordCodeDescription =>
      'Wir haben dir einen Wiederherstellungscode per E-Mail gesendet. Gib ihn ein, um fortzufahren.';

  @override
  String get passwordCodeNoCode => 'Keinen Code erhalten?';

  @override
  String get passwordCodeResend => 'Code erneut senden';

  @override
  String get passwordCodeVerifying => 'Wird überprüft…';

  @override
  String get passwordNewTitle => 'Neues Passwort';

  @override
  String get passwordNewDescription =>
      'Lege ein neues Passwort für dein Konto fest.';

  @override
  String get fieldNewPasswordLabel => 'Neues Passwort';

  @override
  String get newPasswordHint => 'Gib dein neues Passwort ein';

  @override
  String get fieldConfirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get confirmNewPasswordHint => 'Neues Passwort erneut eingeben';

  @override
  String get passwordNewSubmitting => 'Wird übermittelt…';

  @override
  String get passwordNewSubmit => 'Absenden';

  @override
  String get passwordCompleteTitle => 'Passwort erfolgreich zurückgesetzt';

  @override
  String get passwordCompleteBody =>
      'Dein Passwort wurde zurückgesetzt. Melde dich mit deinem neuen Passwort an, um fortzufahren.';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get privacyTitle => 'Datenschutzerklärung';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Lege ein neues Passwort für $email fest.';
  }

  @override
  String get selectComplete => 'Fertig';

  @override
  String get onboardingLanguageTitle => 'Was ist deine Muttersprache?';

  @override
  String get onboardingReasonTitle => 'Warum lernst du eine Sprache?';

  @override
  String get onboardingReasonSubtitle =>
      'Wir passen dein Lernen an deine Ziele an.';

  @override
  String get savingLabel => 'Wird gespeichert…';

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
