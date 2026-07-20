// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Appel terminé $duration';
  }

  @override
  String get callRatingPrompt => 'Comment s\'est passé votre appel ?';

  @override
  String get ratingBad => 'Pas terrible';

  @override
  String get ratingOkay => 'Correct';

  @override
  String get ratingGood => 'Bien';

  @override
  String get goHome => 'Accueil';

  @override
  String get viewAnalysis => 'Voir l\'analyse';

  @override
  String get loadingShort => 'Chargement…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Échec de l\'envoi de la note : $message';
  }

  @override
  String get callInfoNotFound =>
      'Informations d\'appel introuvables, analyse ignorée.';

  @override
  String get tabRecords => 'Historique';

  @override
  String get tabArchive => 'Archives';

  @override
  String get callHistory => 'Historique des appels';

  @override
  String get conversationRecord => 'Enregistrement de la conversation';

  @override
  String get noCallRecords => 'Aucun appel enregistré pour le moment';

  @override
  String get noCallRecordsBody =>
      'Une fois votre premier appel avec l\'IA terminé,\nvos enregistrements apparaîtront ici.';

  @override
  String get startCall => 'Démarrer un appel';

  @override
  String get recordsLoadError => 'Impossible de charger l\'historique';

  @override
  String get tryAgainLater => 'Veuillez réessayer plus tard.';

  @override
  String get retry => 'Réessayer';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String get scheduleManagement => 'Planning';

  @override
  String get alarms => 'Alarmes';

  @override
  String get addSchedule => 'Ajouter un horaire';

  @override
  String get editSchedule => 'Modifier l\'horaire';

  @override
  String get somethingWentWrong => 'Une erreur est survenue';

  @override
  String get alarmsLoadError => 'Impossible de charger les alarmes';

  @override
  String get charactersLoadError => 'Impossible de charger les personnages';

  @override
  String get noCharacters => 'Aucun personnage disponible';

  @override
  String get close => 'Fermer';

  @override
  String get repeat => 'Répéter';

  @override
  String get callPartner => 'Personnage';

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
  String get save => 'Enregistrer';

  @override
  String get conversation => 'Conversation';

  @override
  String get review => 'Révision';

  @override
  String get pronunciationChallenge => 'Défi de prononciation';

  @override
  String get newExpressions => 'Nouvelles expressions';

  @override
  String get analysisResult => 'Résultat de l\'analyse';

  @override
  String get noNewExpressions =>
      'Aucune nouvelle expression dans cette conversation.';

  @override
  String get practice => 'S\'entraîner';

  @override
  String recentScore(int score) {
    return 'Score récent : $score %';
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
      'Impossible de charger le résultat de l\'analyse.';

  @override
  String get standardAudioNotReady =>
      'L\'audio de prononciation standard n\'est pas encore prêt.';

  @override
  String get standardAudioPlayError =>
      'Impossible de lire l\'audio de prononciation standard.';

  @override
  String get selectACountry => 'Sélectionnez un pays';

  @override
  String get selectYourLanguage => 'Sélectionnez votre langue';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get selectTime => 'Sélectionnez l\'heure';

  @override
  String get getStarted => 'Commencer';

  @override
  String get permissionTitle =>
      'Autorisez les accès\npour une expérience fluide';

  @override
  String get permissionSubtitle =>
      'Les autorisations requises sont indispensables pour utiliser le service.';

  @override
  String get permissionMicTitle => 'Microphone (obligatoire)';

  @override
  String get permissionMicDesc =>
      'Nécessaire pour parler avec l\'IA en anglais.';

  @override
  String get permissionNotifTitle => 'Notifications (facultatif)';

  @override
  String get permissionNotifDesc =>
      'Nous vous enverrons des rappels d\'apprentissage et vos horaires d\'appel.';

  @override
  String get micPermissionNeededTitle => 'Accès au microphone requis';

  @override
  String get micPermissionNeededBody =>
      'Pour parler avec l\'IA, vous devez autoriser l\'accès au microphone. Veuillez l\'activer dans les Réglages.';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get connectionFailedTitle => 'Échec de la connexion';

  @override
  String get connectionFailedBody =>
      'Vérifiez votre connexion réseau\net réessayez.';

  @override
  String get checkout => 'Paiement';

  @override
  String get pay => 'Payer';

  @override
  String get orderSummary => 'Récapitulatif de la commande';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get payMethodCard => 'Carte de crédit / débit';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Beaver agaçant';

  @override
  String get productTrait => 'Personnage premium · À vous pour toujours';

  @override
  String get amountItemPrice => 'Prix de l\'article';

  @override
  String get amountDiscount => 'Réduction';

  @override
  String get amountTotal => 'Total';

  @override
  String get paymentCompleteTitle => 'Paiement effectué';

  @override
  String get paymentCompleteBody =>
      'L\'avatar a été ajouté à votre collection.';

  @override
  String get viewCollection => 'Voir la collection';

  @override
  String get receiptItem => 'Article';

  @override
  String get receiptAmount => 'Montant';

  @override
  String get receiptMethod => 'Mode de paiement';

  @override
  String get receiptDate => 'Date';

  @override
  String get paymentFailedTitle => 'Échec du paiement';

  @override
  String get paymentFailedBody =>
      'Votre paiement n\'a pas pu être traité.\nVeuillez réessayer.';

  @override
  String get freeCallEndingTitle => 'Votre appel gratuit touche à sa fin';

  @override
  String get freeCallEndingBody =>
      'Abonnez-vous pour parler plus longtemps avec Beaver.';

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get endCall => 'Raccrocher';

  @override
  String get callEnded => 'L\'appel est terminé.';

  @override
  String get connecting => 'Connexion…';

  @override
  String get connectingHint => 'Cela prend généralement moins de 5 secondes';

  @override
  String get callConnectFailed => 'Impossible de connecter l\'appel.';

  @override
  String get saveSentenceFailed => 'Impossible d\'enregistrer la phrase.';

  @override
  String get recordStartFailed => 'Impossible de démarrer l\'enregistrement.';

  @override
  String get recordTooShort =>
      'Cet enregistrement était trop court. Veuillez réessayer.';

  @override
  String get gradingFailed => 'Échec de la notation. Veuillez réessayer.';

  @override
  String get listenStandard => 'Écouter la prononciation standard';

  @override
  String get saveSentence => 'Enregistrer la phrase';

  @override
  String get unsaveSentence => 'Retirer la phrase enregistrée';

  @override
  String get scoringPronunciation => 'Évaluation de votre prononciation…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'Aucun enregistrement à lire.';

  @override
  String get myRecordingPlayError => 'Impossible de lire votre enregistrement.';

  @override
  String get next => 'Suivant';

  @override
  String get endLearning => 'Terminer la session';

  @override
  String get navCalendar => 'Calendrier';

  @override
  String get navCall => 'Appel';

  @override
  String get navStats => 'Stats';

  @override
  String get myPage => 'Mon compte';

  @override
  String get languageSaveFailed => 'Impossible d\'enregistrer votre langue.';

  @override
  String get accountDeleteFailed => 'Impossible de supprimer votre compte.';

  @override
  String get changeAvatar => 'Changer d\'avatar';

  @override
  String get avatarIntro =>
      'La voix et la difficulté varient selon le personnage.\nCertains personnages peuvent être payants.';

  @override
  String myPartnersOwned(int count) {
    return 'Mes personnages · $count possédés';
  }

  @override
  String get limitedDiscount => 'Réduction à durée limitée';

  @override
  String get available => 'Disponible';

  @override
  String get inUse => 'En cours d\'utilisation';

  @override
  String get owned => 'Possédé';

  @override
  String get noCharactersToShow => 'Aucun personnage à afficher';

  @override
  String get buy => 'Acheter';

  @override
  String get noSavedSentences =>
      'Aucune phrase enregistrée pour le moment.\nMarquez des phrases depuis vos enregistrements de conversation.';

  @override
  String get noAlarms => 'Aucune alarme pour le moment';

  @override
  String get noAlarmsBody =>
      'Ajoutez un rappel d\'apprentissage\npour créer une habitude régulière.';

  @override
  String get subscriptionManage => 'Gérer l\'abonnement';

  @override
  String get changePlan => 'Changer de forfait';

  @override
  String get cancelSubscription => 'Résilier l\'abonnement';

  @override
  String get benefitsInUse => 'Vos avantages';

  @override
  String get paymentInfo => 'Informations de paiement';

  @override
  String get nextBillingDate => 'Prochaine date de facturation';

  @override
  String get lostBenefitsTitle =>
      'Avantages que vous perdrez en cas de résiliation';

  @override
  String get viewBillingHistory => 'Voir l\'historique de facturation';

  @override
  String get keepUsingPro => 'Continuer avec Pro';

  @override
  String get proMembership => 'Abonnement Pro';

  @override
  String get pricePerMonth => '12,9 \$ / mois';

  @override
  String get benefitUnlimitedCalls => 'Appels illimités';

  @override
  String get benefitDetailedAnalysis =>
      'Analyse détaillée de la prononciation et de la grammaire';

  @override
  String get benefitAllCharacters => 'Accès à tous les personnages';

  @override
  String get benefitNoAds => 'Sans publicité';

  @override
  String get playSampleVoice => 'Écouter un extrait de voix';

  @override
  String get useThisAvatar => 'Utiliser celui-ci';

  @override
  String get challengeTitle => 'Défi de prononciation';

  @override
  String get challengeIntro =>
      'Prononcez correctement en coréen chaque carte de la zone pour la valider.\nPas de micro ? Vous pouvez aussi jouer en tapant sur l\'écran.';

  @override
  String get challengeStart => 'Activer caméra et micro';

  @override
  String get challengePermissionNote =>
      'L\'accès à la caméra avant et au micro est requis (facultatif).';

  @override
  String get challengeLoadingTitle => 'Chargement…';

  @override
  String get challengeLoadingNote =>
      'Téléchargement du modèle vocal coréen (~82 Mo) au premier lancement.\nVeuillez patienter un instant.';

  @override
  String get challengeSttFallback =>
      'La reconnaissance vocale n\'était pas disponible, vous avez donc joué avec la saisie tactile.';

  @override
  String get reasonTravelTitle => 'Parler en voyage';

  @override
  String get reasonTravelDesc => 'Discutez avec assurance avec les habitants';

  @override
  String get reasonCareerTitle => 'Travail et carrière';

  @override
  String get reasonCareerDesc => 'Conversation professionnelle';

  @override
  String get reasonExamTitle => 'Préparation aux examens';

  @override
  String get reasonExamDesc => 'Préparez-vous aux épreuves orales';

  @override
  String get reasonDailyTitle => 'Conversation quotidienne';

  @override
  String get reasonDailyDesc =>
      'Des expressions que vous utilisez au quotidien';

  @override
  String get reasonFriendsTitle => 'Se faire des amis étrangers';

  @override
  String get reasonFriendsDesc => 'Conversation naturelle';

  @override
  String get reasonBrainTitle => 'Stimulation cérébrale';

  @override
  String get reasonBrainDesc => 'Améliorez mémoire et concentration';

  @override
  String get challengeRecordToggle => 'Enregistrer cette partie';

  @override
  String get challengeRecordHint =>
      'Enregistre une vidéo (sans son) de votre partie à partager.';

  @override
  String get settingsSection => 'Réglages';

  @override
  String get paymentSection => 'Paiement';

  @override
  String get supportSection => 'Assistance';

  @override
  String get userLanguage => 'Langue de l\'utilisateur';

  @override
  String get learningLanguage => 'Langue d\'apprentissage';

  @override
  String get learningLanguageKorean => 'Coréen';

  @override
  String get notificationLabel => 'Notification';

  @override
  String get currentPlan => 'Forfait actuel';

  @override
  String get paymentHistory => 'Historique des paiements';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody =>
      'Cette action supprime définitivement votre compte et vos données et ne peut pas être annulée.';

  @override
  String get delete => 'Supprimer';

  @override
  String get share => 'Partager';

  @override
  String get accentSoundsLike => 'Votre accent coréen ressemble à';

  @override
  String get hintLabel => 'Indice';

  @override
  String get nextHint => 'Indice suivant';

  @override
  String get translateLabel => 'Traduire';

  @override
  String get startRecording => 'Démarrer l\'enregistrement';

  @override
  String get stopRecording => 'Arrêter l\'enregistrement';

  @override
  String get back => 'Retour';

  @override
  String get onboardingNameTitle => 'Comment devons-nous vous appeler ?';

  @override
  String get onboardingNameSubtitle =>
      'Votre tuteur IA se souviendra de votre prénom.';

  @override
  String get nameLabel => 'Votre prénom';

  @override
  String get nameHint => 'Entrez votre prénom';

  @override
  String get nameHelper =>
      'Il n\'est pas nécessaire d\'utiliser votre vrai nom — un surnom fonctionne aussi.';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get onboardingDoneTitle => 'Beaver attend votre appel';

  @override
  String get onboardingDoneSubtitle => 'Démarrez un appel dès maintenant';

  @override
  String get home => 'Accueil';

  @override
  String get callNow => 'Appeler maintenant';

  @override
  String get pronunciation => 'Prononciation';

  @override
  String get fluency => 'Fluidité';

  @override
  String get rhythm => 'Rythme';

  @override
  String get analysisTimeout =>
      'Cela prend plus de temps que prévu. Veuillez réessayer dans un instant.';

  @override
  String get analysisFailed =>
      'Nous n\'avons pas pu analyser la conversation. Veuillez réessayer.';

  @override
  String get analyzingConversation => 'Analyse de votre conversation…';

  @override
  String get analyzingSubtitle => 'Cela ne prendra qu\'un instant';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get nativeLabel => 'Natif';

  @override
  String get meLabel => 'Moi';

  @override
  String get pronunciationPlayError =>
      'Impossible de lire l\'audio de prononciation.';

  @override
  String get savedExpressionsLoadError =>
      'Impossible de charger vos expressions enregistrées.';

  @override
  String get mySavedExpressions => 'Mes expressions enregistrées';

  @override
  String get avatarTraits => 'Chaleureux · Calme · Doux';

  @override
  String get priceFree => 'Gratuit';

  @override
  String get loginGoogleTokenError =>
      'Impossible d\'obtenir un jeton de connexion Google.';

  @override
  String get loginGoogleSignInFailed => 'Échec de la connexion avec Google.';

  @override
  String get loginKakaoSignInFailed => 'Échec de la connexion avec Kakao.';

  @override
  String get loginContinueWithKakao => 'Continuer avec Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuer avec Google';

  @override
  String get loginContinueWithApple => 'Continuer avec Apple';

  @override
  String get loginContinueWithEmail => 'Continuer avec l\'e-mail';

  @override
  String get loginOrDivider => 'ou';

  @override
  String get loginNoAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get loginTermsNoticePrefix => 'En continuant, vous acceptez nos ';

  @override
  String get loginTermsNoticeAnd => ' et ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Se connecter';

  @override
  String get fieldEmailLabel => 'E-mail';

  @override
  String get emailHint => 'Entrez votre e-mail';

  @override
  String get fieldPasswordLabel => 'Mot de passe';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get loginRememberMe => 'Se souvenir de moi';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginLoggingIn => 'Connexion en cours...';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir entre 8 et 16 caractères.';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get signupCheckInput => 'Veuillez vérifier vos informations.';

  @override
  String get fieldConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordHint => 'Ressaisissez votre mot de passe';

  @override
  String get signupSigningUp => 'Inscription en cours...';

  @override
  String get signupHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get passwordMethodEmailRequired => 'Entrez votre e-mail';

  @override
  String get passwordResetTitle => 'Réinitialiser le mot de passe';

  @override
  String get passwordMethodDescription =>
      'Entrez l\'adresse e-mail à laquelle vous souhaitez recevoir le code de réinitialisation du mot de passe.';

  @override
  String get emailAddressHint => 'Adresse e-mail';

  @override
  String get passwordMethodSending => 'Envoi en cours...';

  @override
  String get passwordMethodSendEmail => 'Envoyer l\'e-mail';

  @override
  String get passwordCodeTitle => 'Entrez le code';

  @override
  String get passwordCodeDescription =>
      'Nous avons envoyé un code de récupération à votre adresse e-mail. Saisissez-le pour continuer.';

  @override
  String get passwordCodeNoCode => 'Vous n\'avez pas reçu le code ?';

  @override
  String get passwordCodeResend => 'Renvoyer le code';

  @override
  String get passwordCodeVerifying => 'Vérification en cours...';

  @override
  String get passwordNewTitle => 'Nouveau mot de passe';

  @override
  String get passwordNewDescription =>
      'Définissez un nouveau mot de passe pour votre compte.';

  @override
  String get fieldNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get newPasswordHint => 'Entrez votre nouveau mot de passe';

  @override
  String get fieldConfirmNewPasswordLabel =>
      'Confirmer le nouveau mot de passe';

  @override
  String get confirmNewPasswordHint =>
      'Ressaisissez votre nouveau mot de passe';

  @override
  String get passwordNewSubmitting => 'Envoi en cours...';

  @override
  String get passwordNewSubmit => 'Envoyer';

  @override
  String get passwordCompleteTitle =>
      'Réinitialisation du mot de passe terminée';

  @override
  String get passwordCompleteBody =>
      'Votre mot de passe a été réinitialisé. Connectez-vous avec votre nouveau mot de passe pour continuer.';

  @override
  String get termsTitle => 'Conditions d\'utilisation';

  @override
  String get privacyTitle => 'Politique de confidentialité';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Définissez un nouveau mot de passe pour $email.';
  }

  @override
  String get selectComplete => 'Terminé';

  @override
  String get onboardingLanguageTitle => 'Quelle est votre langue maternelle ?';

  @override
  String get onboardingReasonTitle => 'Pourquoi apprenez-vous une langue ?';

  @override
  String get onboardingReasonSubtitle =>
      'Nous adapterons votre apprentissage à vos objectifs.';

  @override
  String get savingLabel => 'Enregistrement...';

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
