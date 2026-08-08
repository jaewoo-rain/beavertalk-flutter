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
  String get quickStart => 'Schnellstart';

  @override
  String get presetMorning => 'Morgenroutine';

  @override
  String get presetMorningSub => 'Werktags 8:00';

  @override
  String get presetEvening => 'Abendausklang';

  @override
  String get presetEveningSub => 'Täglich 21:00';

  @override
  String get presetCustom => 'Eigene';

  @override
  String get presetCustomSub => 'Frei wählbar';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× pro Woche · $monthly Anrufe im Monat';
  }

  @override
  String get alarmSummaryNone => 'Wähle mindestens einen Tag';

  @override
  String get partnerInUse => 'In Verwendung';

  @override
  String get partnerOwned => 'Im Besitz';

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
    return 'Anruf Nr. $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Ein Wort von $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Von $name direkt nach dem Anruf hinterlassen';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Neue Ausdrücke $count';
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
  String get analyzingByWord => 'Deine Aussprache wird Wort für Wort geprüft';

  @override
  String get analyzingTakingLonger => 'Das dauert etwas länger';

  @override
  String get scanConnectionLost => 'Verbindung verloren';

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
  String pricePerMonth(String price) {
    return '$price / Monat';
  }

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
  String get thisMonthPayment => 'Zahlung diesen Monat';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterSubscription => 'Abo';

  @override
  String get filterCharacter => 'Charakter';

  @override
  String get statusCompleted => 'Abgeschlossen';

  @override
  String get lastPayment => 'Letzte Zahlung';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Du kannst die Pro-Vorteile bis $date weiter nutzen, danach wechselt dein Tarif automatisch zu Free.';
  }

  @override
  String get freePlanCallLimit => '1 Anruf pro Tag · 5 Min. Limit';

  @override
  String get freePlanBasicCharacters => 'Basis-Charaktere enthalten';

  @override
  String get availableForPurchase => 'Zum Kauf verfügbar';

  @override
  String get paymentsLoadError => 'Zahlungsverlauf konnte nicht geladen werden';

  @override
  String get noPayments => 'Noch keine Zahlungen';

  @override
  String get morePaymentsExist =>
      'Ältere Zahlungen werden noch nicht angezeigt';

  @override
  String get undatedPayments => 'Ohne Datum';

  @override
  String get paymentLabelFallback => 'Zahlung';

  @override
  String learningPassed(int passed, int total) {
    return '$passed von $total Sätzen bestanden';
  }

  @override
  String get hardestSound => 'Schwerster Laut heute';

  @override
  String get soundAccuracy => 'Genauigkeit nach Laut';

  @override
  String phonemeAttempts(int count) {
    return 'Pro Phonem · $count Versuche';
  }

  @override
  String get colSound => 'Laut';

  @override
  String get colAttempts => 'Vers.';

  @override
  String get colCorrect => 'Rich.';

  @override
  String get colAccuracy => 'Genau.';

  @override
  String get sentenceResults => 'Ergebnisse nach Satz';

  @override
  String viewAllSentences(int count) {
    return 'Alle $count ansehen';
  }

  @override
  String get colSentence => 'Satz';

  @override
  String get colPronunciation => 'Aussp.';

  @override
  String get colFluency => 'Flüss.';

  @override
  String get colRhythm => 'Rhyth.';

  @override
  String recentSessions(int count) {
    return 'Letzte $count Sitzungen';
  }

  @override
  String trendAverage(int score) {
    return 'Ø $score';
  }

  @override
  String get today => 'Heute';

  @override
  String get colDate => 'Datum';

  @override
  String get colSentences => 'Sätze';

  @override
  String get colScore => 'Punkte';

  @override
  String get colChange => 'Änd.';

  @override
  String dateToday(String date) {
    return '$date (heute)';
  }

  @override
  String get accentAnalysis => 'Akzentanalyse';

  @override
  String get overallLevel => 'Gesamtniveau';

  @override
  String get overallLevelSubtitle => 'Wortschatz · Grammatik · Ausdruck';

  @override
  String get pronunciationAnalysis => 'Ausspracheanalyse';

  @override
  String get recentSessionsAverage => 'Ø der letzten 10 Sitzungen';

  @override
  String levelStage(int stage) {
    return 'Stufe $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Unter allen Lernenden';

  @override
  String aheadOfLearners(int percent) {
    return 'Du liegst vor $percent% aller Lernenden';
  }

  @override
  String get retakeLevelTest => 'Einstufungstest wiederholen';

  @override
  String get practicePronunciation => 'Aussprache üben';

  @override
  String get priceChangedTitle => 'Preis geändert';

  @override
  String priceChangedBody(String price) {
    return 'Dieser Artikel kostet jetzt $price. Möchtest du fortfahren?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plan & Käufe';

  @override
  String get billingGroupInTheStore => 'Im Store';

  @override
  String get billingChangePlan => 'Plan ändern';

  @override
  String get billingCompareAllPlans => 'Alle Pläne vergleichen';

  @override
  String get billingBuyACharacter => 'Charakter kaufen';

  @override
  String get billingRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get billingPaymentHistory => 'Zahlungsverlauf';

  @override
  String get billingManageInTheStore => 'Im Store verwalten';

  @override
  String get billingRefundHelp => 'Hilfe bei Rückerstattungen';

  @override
  String get billingCancelSubscription => 'Abo kündigen';

  @override
  String get billingResubscribe => 'Erneut abonnieren';

  @override
  String get badgeCurrent => 'Aktuell';

  @override
  String get badgeTrial => 'Testphase';

  @override
  String get badgeRenewing => 'Verlängert sich';

  @override
  String get badgePastDue => 'Zahlung überfällig';

  @override
  String get badgePaused => 'Pausiert';

  @override
  String get badgeCanceling => 'Läuft aus';

  @override
  String get subscriptionTitle => 'Abo';

  @override
  String get plansTitle => 'Pläne';

  @override
  String get planFree => 'Kostenlos';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max-Testphase';

  @override
  String get freePlanPriceLine => '\$0.00 — ein Anruf pro Tag';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount pro Monat';
  }

  @override
  String freeUntilDate(String date) {
    return 'Kostenlos bis $date';
  }

  @override
  String get todaysCalls => 'Heutige Anrufe';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used von $limit genutzt';
  }

  @override
  String get firstPaymentLabel => 'Erste Zahlung';

  @override
  String get nextPaymentLabel => 'Nächste Zahlung';

  @override
  String get retryingUntilLabel => 'Neuer Versuch bis';

  @override
  String get pausedSinceLabel => 'Pausiert seit';

  @override
  String planEndsLabel(String plan) {
    return '$plan endet';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Unbegrenzt mit Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Unbegrenzte Anrufe · je 15 Minuten · $price pro Monat';
  }

  @override
  String get bannerMaxUpsellTitle => 'Video aktivieren mit Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Anrufe von Angesicht zu Angesicht · $price pro Monat';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Zum Jahresabo wechseln';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly pro Jahr · $perMonth pro Monat';
  }

  @override
  String get bannerPaymentFailedTitle => 'Die Zahlung hat nicht geklappt';

  @override
  String get bannerPaymentFailedSub =>
      'Aktualisiere die Zahlung im Store, um Pro zu behalten';

  @override
  String get bannerPausedTitle => 'Dein Plan ist pausiert';

  @override
  String get bannerPausedSub => 'Die Zahlung ist nicht durchgegangen';

  @override
  String get noteRestoreHint =>
      'Schon auf einem anderen Gerät abonniert? Mit Wiederherstellen holst du es auf dieses Gerät.';

  @override
  String get noteStoreHandled =>
      'Zahlungsmethode, Planwechsel und Kündigung laufen über den Store.';

  @override
  String get noteFairUse =>
      'Unbegrenzte Nutzung unterliegt unserer Fair-Use-Richtlinie.';

  @override
  String noteTrialEnds(String date) {
    return 'Deine Testphase endet am $date. Kündige vorher im Store und es wird nichts berechnet.';
  }

  @override
  String get noteGrace =>
      'Deine Vorteile laufen während der Kulanzfrist weiter. Die Kündigung wird in der App nie abgefangen.';

  @override
  String get noteHold =>
      'Pro ist pausiert, bis die Zahlung durchgeht. Deine Charaktere und Fortschritte bleiben erhalten.';

  @override
  String noteEnding(String date) {
    return 'Dein Plan läuft aus. Die Vorteile gelten bis $date, danach wechselst du zu Kostenlos. Du kannst jederzeit erneut abonnieren.';
  }

  @override
  String get trialExpiredTitle => 'Deine Max-Testphase ist vorbei';

  @override
  String get trialExpiredSub => 'Du bist jetzt auf Kostenlos';

  @override
  String get seePlans => 'Pläne ansehen';

  @override
  String get currentPlanTitle => 'Aktueller Plan';

  @override
  String get badgeRecommended => 'Empfohlen';

  @override
  String get perMonthUnit => 'pro Monat';

  @override
  String get planTaglinePro => 'Unbegrenzte Anrufe. Je 15 Minuten.';

  @override
  String get planTaglineMax => 'Jetzt kannst du sie sehen.';

  @override
  String get planTaglineFree => 'Ein Anruf pro Tag. Aufs Haus.';

  @override
  String get bulletProCalls => 'Sprachanrufe, so oft du willst';

  @override
  String get bulletProLength => '15 Minuten pro Anruf';

  @override
  String get bulletProScoring => 'Aussprache Buchstabe für Buchstabe bewertet';

  @override
  String get bulletProCorrections =>
      'Korrekturen, abgestimmt auf deine Muttersprache';

  @override
  String get bulletProBeaverCalls => 'Beaver ruft dich zuerst an';

  @override
  String get bulletMaxVideo => 'Videoanrufe von Angesicht zu Angesicht';

  @override
  String get bulletMaxEverything => 'Alles aus Pro';

  @override
  String get bulletMaxCharacters => 'Alle Charaktere, unbegrenzt';

  @override
  String get bulletMaxStudyBook => 'Ein Lernbuch, das zu deinem Stand passt';

  @override
  String get bulletMaxWeeklyReport =>
      'Ein Wochenbericht darüber, wie sich dein Klang verändert';

  @override
  String get bulletFreeCall => 'Ein 5-Minuten-Sprachanruf pro Tag';

  @override
  String get bulletFreeCheck => 'Ein Aussprache-Check pro Tag';

  @override
  String get bulletFreeAccent => 'Unbegrenzte Akzent-Checks';

  @override
  String get bulletFreeCharacter => 'Ein Charakter zum Start';

  @override
  String get ctaGoUnlimited => 'Unbegrenzt loslegen';

  @override
  String get ctaTurnOnVideo => 'Video aktivieren';

  @override
  String get noteCallLength => 'Anrufe dauern je 15 Minuten.';

  @override
  String get paywallProTitle1 => 'Dein koreanischer Freund';

  @override
  String get paywallProTitle2 => 'der um 3 Uhr nachts wach ist';

  @override
  String get paywallProSub =>
      'Unbegrenzte Anrufe. Je 15 Minuten. Das ganze Jahr.';

  @override
  String get paywallLimitHeadline => 'Pro hebt das Limit auf.';

  @override
  String get limitBannerCallTitle => 'Das war der Anruf für heute';

  @override
  String get limitBannerCallSub => 'Kostenlos gibt dir einen Anruf pro Tag';

  @override
  String get limitBannerCheckTitle => 'Das war der Check für heute';

  @override
  String get limitBannerCheckSub => 'Kostenlos gibt dir einen Check pro Tag';

  @override
  String get bulletProCharactersForever =>
      'Gekaufte Charaktere gehören dir für immer';

  @override
  String get paywallMaxTitle => 'Jetzt kannst du sie sehen.';

  @override
  String get paywallMaxSub =>
      'Videoanrufe, alle Charaktere und ein Lernbuch, das zu deinem Stand passt.';

  @override
  String get planMonthly => 'Monatlich';

  @override
  String get planAnnual => 'Jährlich';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price pro Monat';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth pro Monat';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price pro Monat';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly pro Jahr · $perMonth pro Monat';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price pro Monat · jederzeit im Store kündbar';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price pro Monat · jederzeit im Store kündbar';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 Tage kostenlos, danach $price pro Monat · jederzeit im Store kündbar';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Verlängert sich automatisch bis zur Kündigung.';

  @override
  String get footerTerms => 'AGB';

  @override
  String get footerPrivacy => 'Datenschutz';

  @override
  String get noteMaxCharacters =>
      'Durch Max freigeschaltete Charaktere sind verfügbar, solange dein Abo aktiv ist. Gekaufte Charaktere gehören dir dauerhaft.';

  @override
  String get processingTitle => 'Dein Kauf wird bestätigt';

  @override
  String get processingSub => 'Das dauert normalerweise nur ein paar Sekunden.';

  @override
  String get successProTitle => 'Du bist auf Pro.';

  @override
  String get successProSub => 'Unbegrenzte Anrufe, ab sofort.';

  @override
  String get successProBenefit1 =>
      'Rufe an, so oft du willst — 15 Minuten pro Anruf';

  @override
  String get successProBenefit2 => 'Unbegrenzte Aussprache-Checks';

  @override
  String get successProBenefit3 => 'Alle Charaktere, plus Einzelkäufe';

  @override
  String get successMaxTitle => 'Jetzt kannst du sie sehen.';

  @override
  String get successMaxSub =>
      'Videoanrufe sind aktiv. Tippe in einem Anruf auf die Video-Taste.';

  @override
  String get successMaxBenefit1 => 'Videoanrufe von Angesicht zu Angesicht';

  @override
  String get successMaxBenefit2 =>
      'Alle Charaktere, unbegrenzt und neue zuerst';

  @override
  String get successMaxBenefit3 => 'Ein Lernbuch, das zu deinem Stand passt';

  @override
  String get ctaStartACall => 'Anruf starten';

  @override
  String get ctaStartAVideoCall => 'Videoanruf starten';

  @override
  String get ctaSeeYourSubscription => 'Dein Abo ansehen';

  @override
  String successProCaption(String price) {
    return '$price werden monatlich berechnet, bis du kündigst. Verwalten oder kündigen kannst du jederzeit im Store.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price werden monatlich berechnet, bis du kündigst. Verwalten oder kündigen kannst du jederzeit im Store.';
  }

  @override
  String get plansErrorTitle => 'Die Pläne konnten nicht geladen werden';

  @override
  String get plansErrorSub => 'Der Store hat nicht geantwortet.';

  @override
  String get ctaTryAgain => 'Erneut versuchen';

  @override
  String get plansErrorCaption => 'Es wurde nichts berechnet.';

  @override
  String get changePlanTitle => 'Plan ändern';

  @override
  String get moveToMaxTitle => 'Zu Max wechseln';

  @override
  String maxPriceShort(String price) {
    return '$price/Monat';
  }

  @override
  String get moveToMaxCardSub =>
      'Videoanrufe von Angesicht zu Angesicht · alle Charaktere · ein Lernbuch für dich';

  @override
  String get whatHappensNow => 'Was jetzt passiert';

  @override
  String get maxStartsLabel => 'Max startet';

  @override
  String get immediately => 'Sofort';

  @override
  String get unusedProTime => 'Ungenutzte Pro-Zeit';

  @override
  String get creditedTowardMax => 'Wird auf Max angerechnet';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Zu Max wechseln';

  @override
  String get upgradeCaption =>
      'Dein neuer Plan startet sofort. Ungenutzte Pro-Zeit wird angerechnet, nie doppelt berechnet.';

  @override
  String get moveToProTitle => 'Zu Pro wechseln';

  @override
  String get moveToProSub =>
      'Heute ändert sich nichts. Max läuft bis zum Ende des bereits bezahlten Monats.';

  @override
  String get maxRunsUntil => 'Max läuft bis';

  @override
  String get proStarts => 'Pro startet';

  @override
  String get whatYouKeep => 'Was du behältst';

  @override
  String get keepBenefitCalls => 'Unbegrenzte Sprachanrufe, je 15 Minuten';

  @override
  String get keepBenefitCharacters =>
      'Gekaufte Charaktere gehören dir für immer';

  @override
  String downgradeWarning(String date) {
    return 'Videoanrufe und Max-exklusive Charaktere werden am $date deaktiviert.';
  }

  @override
  String get ctaSwitchToPro => 'Zu Pro wechseln';

  @override
  String get ctaKeepMax => 'Max behalten';

  @override
  String get winbackSkip => 'Überspringen';

  @override
  String get winbackTitle => 'Dein Pro-Plan ist beendet';

  @override
  String get winbackSub => 'Du bist jetzt auf Kostenlos — ein Anruf pro Tag.';

  @override
  String get winbackQuestion => 'Magst du uns sagen, warum du gegangen bist?';

  @override
  String get winbackReasonExpensive => 'Zu teuer';

  @override
  String get winbackReasonUnused => 'Ich habe es zu wenig genutzt';

  @override
  String get winbackReasonMissing => 'Eine Funktion hat mir gefehlt';

  @override
  String get winbackReasonOtherApp => 'Ich habe eine andere App gefunden';

  @override
  String get winbackReasonElse => 'Etwas anderes';

  @override
  String get ctaSend => 'Senden';

  @override
  String get ctaNotNow => 'Jetzt nicht';

  @override
  String get winbackCaption =>
      'Das stellt deinen Plan nicht wieder her. Abonniere erneut im Store.';

  @override
  String get ctaContinue => 'Weiter';

  @override
  String get ctaClose => 'Schließen';

  @override
  String get ovRestoreSuccessTitle => 'Pro ist zurück';

  @override
  String get ovRestoreSuccessBody =>
      'Wir haben dein Abo gefunden und für dieses Gerät wieder aktiviert.';

  @override
  String get ovRestoreEmptyTitle => 'Nichts wiederherzustellen';

  @override
  String get ovRestoreEmptyBody =>
      'Mit diesem Store-Konto ist kein aktives Abo verknüpft.';

  @override
  String get ovRestoreOtherTitle => 'Dieser Plan gehört zu einem anderen Konto';

  @override
  String get ovRestoreOtherBody =>
      'Dieses Abo ist bereits auf einem anderen BeaverTalk-Konto aktiv.';

  @override
  String get ctaSignInThatAccount => 'Mit diesem Konto anmelden';

  @override
  String get ctaGetHelp => 'Hilfe holen';

  @override
  String get ovCharacterOfferTitle => 'Noch nicht bereit für Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Such dir einen Charakter aus und behalte ihn. Ein Einzelkauf — kein Abo, keine Verlängerung.';

  @override
  String get rowOneCharacter => 'Ein Charakter';

  @override
  String rowFromPrice(String price) {
    return 'ab $price';
  }

  @override
  String get rowYoursForever => 'Für immer deiner';

  @override
  String get rowNoRenewal => 'Keine Verlängerung';

  @override
  String get rowWorksOnFree => 'Funktioniert mit Kostenlos';

  @override
  String get rowYes => 'Ja';

  @override
  String get ctaSeeCharacters => 'Charaktere ansehen';

  @override
  String get ovNotEligibleTitle => 'Nichts zu kündigen';

  @override
  String get ovNotEligibleBody =>
      'Du bist auf Kostenlos. Auf diesem Konto gibt es kein aktives Abo.';

  @override
  String get ovCancelDownsellTitle => 'Bevor du gehst';

  @override
  String get ovCancelDownsellBody =>
      'Gekündigt wird im Store. Zwei Dinge, die du wissen solltest.';

  @override
  String get rowPayYearlyInstead => 'Zahl lieber jährlich';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price pro Monat';
  }

  @override
  String get rowCharactersYouBought => 'Gekaufte Charaktere';

  @override
  String get rowProRunsUntil => 'Pro läuft bis';

  @override
  String get ctaSwitchToYearly => 'Zu jährlich wechseln';

  @override
  String get ctaContinueToStore => 'Weiter zum Store';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Zahl jährlich und spare $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Du bist seit zwei Monaten auf Pro. Der Jahresplan ist unterm Strich günstiger.';

  @override
  String get rowYouSave => 'Du sparst';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Jährlich';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Monatlich, ein Jahr lang';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Zu monatlich wechseln';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Dein Jahresplan läuft bis $date. Die monatliche Abrechnung startet am Tag danach.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Monatliche Abrechnung startet';

  @override
  String get rowMonthlyLabel => 'Monatlich';

  @override
  String get rowYearlyWorkedOut => 'Jährlich entsprach';

  @override
  String get ctaSwitchToMonthly => 'Zu monatlich wechseln';

  @override
  String get ovRefundHelpTitle => 'Rückerstattungen laufen über den Store';

  @override
  String get ovRefundHelpBody =>
      'Wir können selbst keine Rückerstattungen ausstellen. Jede Anfrage wird vom Store geprüft.';

  @override
  String get ctaGoToStore => 'Zum Store';

  @override
  String get ovTrialEndingTitle => 'Deine Testphase endet morgen';

  @override
  String get ovTrialEndingBody =>
      'Max läuft weiter, wenn du nicht kündigst. Das passiert als Nächstes.';

  @override
  String get rowTrialEnds => 'Testphase endet';

  @override
  String get rowFirstCharge => 'Erste Abbuchung';

  @override
  String get rowThenMonthly => 'Danach monatlich';

  @override
  String get ctaCancelInStore => 'Im Store kündigen';

  @override
  String get ovTrialStartTitle => '7 Tage Max, kostenlos';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Kostenlos bis $date. Danach $price pro Monat, außer du kündigst im Store.';
  }

  @override
  String get ctaStart7Days => '7 Tage kostenlos starten';

  @override
  String get ovOtoTitle => 'Noch eine Sache, bevor du loslegst';

  @override
  String get ovOtoBody =>
      'Gute Wahl — unbegrenzte Anrufe sind ab sofort aktiv. Dasselbe Pro kostet weniger, wenn du jährlich zahlst.';

  @override
  String get ovFailedDeclinedTitle => 'Deine Karte wurde abgelehnt';

  @override
  String get ovFailedDeclinedBody =>
      'Der Store konnte die Zahlung nicht durchführen. Es wurde nichts berechnet.';

  @override
  String get ctaUpdatePaymentMethod => 'Zahlungsmethode aktualisieren';

  @override
  String get ovFailedCanceledTitle => 'Zahlung abgebrochen';

  @override
  String get ovFailedCanceledBody =>
      'Du bist weiterhin auf Kostenlos. Es wurde nichts berechnet.';

  @override
  String get ovFailedStoreTitle => 'Etwas ist schiefgelaufen';

  @override
  String get ovFailedStoreBody =>
      'Wir konnten den Store nicht erreichen. Es wurde nichts berechnet.';

  @override
  String get ovAlreadyTitle => 'Du bist bereits auf Pro';

  @override
  String get ovAlreadyBody =>
      'Dieses Store-Konto hat einen aktiven Plan. Es gibt nichts zu kaufen.';

  @override
  String get ctaSeeMySubscription => 'Mein Abo ansehen';

  @override
  String get subCancelTitle => 'Abo kündigen';

  @override
  String subCancelBody(String date) {
    return 'Pro läuft bis $date. Danach wechselst du zu Kostenlos.';
  }

  @override
  String get subWhatYouLose => 'Was du verlierst';

  @override
  String get benefitCalls15 => 'Unbegrenzte Anrufe, je 15 Minuten';

  @override
  String get benefitScoring => 'Aussprache Buchstabe für Buchstabe bewertet';

  @override
  String get benefitEveryCharacter => 'Alle Charaktere, unbegrenzt';

  @override
  String get ctaKeepPro => 'Pro behalten';

  @override
  String get subPaymentTitle => 'Zahlung aktualisieren';

  @override
  String get subPaymentBody =>
      'Wir konnten die Zahlung nicht durchführen. Pro läuft während der Kulanzfrist weiter.';

  @override
  String get subHowToFix => 'So behebst du es';

  @override
  String get fixStep1 =>
      'Öffne den Store und aktualisiere deine Zahlungsmethode';

  @override
  String get fixStep2 => 'Komm zurück — dein Plan läuft automatisch weiter';

  @override
  String get fixStep3 => 'Nichts wird doppelt berechnet';

  @override
  String get subResubTitle => 'Erneut abonnieren';

  @override
  String subResubBody(String date) {
    return 'Pro endet am $date. Aktiviere die automatische Verlängerung wieder und nichts ändert sich.';
  }

  @override
  String get subWhatYouKeep => 'Was du behältst';

  @override
  String get ctaTurnItBackOn => 'Wieder aktivieren';

  @override
  String get flTodayTitle => 'Das war der Anruf für heute';

  @override
  String get flTodayBody =>
      'Mach genau da weiter, wo du aufgehört hast — sofort.';

  @override
  String get flCheckTitle => 'Das war der Check für heute';

  @override
  String get flCheckBody =>
      'Ein Check pro Tag mit Kostenlos. Mit Pro unbegrenzt.';

  @override
  String get flBenefitCalls => 'Unbegrenzte Anrufe mit Pro · je 15 Minuten';

  @override
  String get flBenefitChecks => 'Unbegrenzte Aussprache-Checks mit Pro';

  @override
  String flCaption(String price) {
    return '$price pro Monat · jederzeit kündbar';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used von $limit genutzt';
  }

  @override
  String get ctaMaybeTomorrow => 'Vielleicht morgen';

  @override
  String get accountSection => 'Konto';

  @override
  String get nicknameLabel => 'Spitzname';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Anmeldemethode';

  @override
  String get joinedLabel => 'Beigetreten';

  @override
  String get editNicknameTitle => 'Spitznamen bearbeiten';

  @override
  String get nicknameRule =>
      '2–12 Zeichen. Buchstaben und Zahlen. Nur Englisch';

  @override
  String get ctaSave => 'Speichern';

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
      'Wenn du jetzt gehst, bist du nicht abonniert';

  @override
  String get paywallLeaveBody =>
      'Deine Vorteile werden direkt nach dem Kauf freigeschaltet. Du kannst jederzeit über Meine Seite zurückkommen.';

  @override
  String get ctaKeepLooking => 'Weiter ansehen';

  @override
  String get ctaLeaveAnyway => 'Trotzdem gehen';

  @override
  String get iapCharacterSuccessTitle => 'Ein neuer Freund ist dabei!';

  @override
  String get iapCharacterSuccessBody =>
      'Dieser Charakter gehört dir für immer — er bleibt auch bei Planwechsel, und Käufe wiederherstellen holt ihn auf jedes Gerät zurück.';

  @override
  String get iapCharacterFailedBody =>
      'Der Kauf wurde nicht abgeschlossen. Es wurde nichts abgebucht — bitte versuche es erneut.';

  @override
  String get noAccentDataTitle => 'Noch keine Intonationsdaten';

  @override
  String get noAccentDataBody =>
      'Sprich weiter, dann sammeln sich deine Intonationsmerkmale.';

  @override
  String get noLevelYetTitle => 'Noch kein Level';

  @override
  String get noLevelYetBody =>
      'Schließe deinen ersten Anruf ab, um dein Level zu erhalten.';

  @override
  String get noPronunciationDataTitle => 'Noch keine Aussprache-Aufzeichnungen';

  @override
  String get noPronunciationDataBody =>
      'Wir analysieren deine Aussprache anhand der Sätze, die du im Anruf sagst.';

  @override
  String get noCharacterNote => 'Noch nichts gesagt';

  @override
  String get noPhonemesYet => 'Noch keine Laute zum Analysieren';

  @override
  String get noSentencesYet => 'Noch keine Sätze zum Analysieren';

  @override
  String get takeLevelTest => 'Einstufungstest machen';

  @override
  String get reviewToSeeScore =>
      'Wiederhole, um deine Aussprachebewertung zu sehen';
}
