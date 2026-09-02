// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loginRequired => 'Vous devez vous connecter.';

  @override
  String get callWebNotSupported =>
      'Les appels vocaux ne sont pas pris en charge sur le web. Utilisez l\'application.';

  @override
  String get micPermissionRequiredForCall =>
      'L\'accès au micro est requis. Autorisez le micro pour appeler.';

  @override
  String get callErrorGeneric => 'Une erreur est survenue pendant l\'appel.';

  @override
  String get callNetworkError => 'Une erreur réseau est survenue.';

  @override
  String get authInvalidCredentials =>
      'L\'e-mail ou le mot de passe est incorrect.';

  @override
  String get authEmailAlreadyRegistered =>
      'Cette adresse e-mail est déjà utilisée.';

  @override
  String get authConfirmEmailRequired =>
      'Veuillez terminer la vérification envoyée à votre e-mail.';

  @override
  String get authResetCodeSent =>
      'Nous avons envoyé un code de vérification à votre e-mail.';

  @override
  String get authResetCodeInvalid => 'Ce code est incorrect ou a expiré.';

  @override
  String get authPasswordUpdated => 'Votre mot de passe a été réinitialisé.';

  @override
  String get authAppleTokenMissing =>
      'Impossible d\'obtenir le jeton de connexion Apple.';

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
  String get quickStart => 'Démarrage rapide';

  @override
  String get presetMorning => 'Routine du matin';

  @override
  String get presetMorningSub => 'En semaine 8:00';

  @override
  String get presetEvening => 'Détente du soir';

  @override
  String get presetEveningSub => 'Tous les jours 21:00';

  @override
  String get presetCustom => 'Personnalisé';

  @override
  String get presetCustomSub => 'À votre gré';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× par semaine · $monthly appels par mois';
  }

  @override
  String get alarmSummaryNone => 'Choisissez au moins un jour';

  @override
  String get partnerInUse => 'En cours';

  @override
  String get partnerOwned => 'Acquis';

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
    return 'Appel n° $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Un mot de $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Laissé par $name juste après l\'appel';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Nouvelles expressions $count';
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
  String get selectNativeLanguage => 'Sélectionnez votre langue maternelle';

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
  String get analyzingByWord => 'Vérification de votre prononciation mot à mot';

  @override
  String get analyzingTakingLonger => 'Cela prend un peu plus de temps';

  @override
  String get scanConnectionLost => 'Connexion perdue';

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
  String pricePerMonth(String price) {
    return '$price / mois';
  }

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
  String get loginAppleSignInFailed => 'Échec de la connexion avec Apple.';

  @override
  String get loginFacebookSignInFailed =>
      'Échec de la connexion avec Facebook.';

  @override
  String get loginKakaoSignInFailed => 'Échec de la connexion avec Kakao.';

  @override
  String get loginContinueWithKakao => 'Continuer avec Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuer avec Google';

  @override
  String get loginContinueWithFacebook => 'Continuer avec Facebook';

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
  String get thisMonthPayment => 'Paiement de ce mois';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterSubscription => 'Abonnement';

  @override
  String get filterCharacter => 'Personnage';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get lastPayment => 'Dernier paiement';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Vous pouvez continuer à profiter des avantages Pro jusqu\'au $date, après quoi votre forfait passera automatiquement à Gratuit.';
  }

  @override
  String get freePlanCallLimit => '1 appel par jour · limite de 5 min';

  @override
  String get freePlanBasicCharacters => 'Personnages de base inclus';

  @override
  String get availableForPurchase => 'Disponible à l\'achat';

  @override
  String get paymentsLoadError =>
      'Impossible de charger l\'historique des paiements';

  @override
  String get noPayments => 'Aucun paiement pour l\'instant';

  @override
  String get morePaymentsExist =>
      'Les paiements plus anciens ne sont pas encore affichés';

  @override
  String get undatedPayments => 'Sans date';

  @override
  String get paymentLabelFallback => 'Paiement';

  @override
  String learningPassed(int passed, int total) {
    return '$passed phrases sur $total réussies';
  }

  @override
  String get hardestSound => 'Son le plus difficile aujourd\'hui';

  @override
  String get soundAccuracy => 'Précision par son';

  @override
  String phonemeAttempts(int count) {
    return 'Par phonème · $count essais';
  }

  @override
  String get colSound => 'Son';

  @override
  String get colAttempts => 'Ess.';

  @override
  String get colCorrect => 'Just.';

  @override
  String get colAccuracy => 'Préc.';

  @override
  String get sentenceResults => 'Résultats par phrase';

  @override
  String viewAllSentences(int count) {
    return 'Voir les $count';
  }

  @override
  String get colSentence => 'Phrase';

  @override
  String get colPronunciation => 'Pron.';

  @override
  String get colFluency => 'Flu.';

  @override
  String get colRhythm => 'Rythm.';

  @override
  String recentSessions(int count) {
    return '$count dernières sessions';
  }

  @override
  String trendAverage(int score) {
    return 'Moy. $score';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get colDate => 'Date';

  @override
  String get colSentences => 'Phrases';

  @override
  String get colScore => 'Score';

  @override
  String get colChange => 'Évol.';

  @override
  String dateToday(String date) {
    return '$date (aujourd\'hui)';
  }

  @override
  String get accentAnalysis => 'Analyse d\'accent';

  @override
  String get overallLevel => 'Niveau global';

  @override
  String get overallLevelSubtitle => 'Vocabulaire · Grammaire · Expressions';

  @override
  String get pronunciationAnalysis => 'Analyse de prononciation';

  @override
  String get recentSessionsAverage => 'Moyenne sur 10 sessions';

  @override
  String levelStage(int stage) {
    return 'Niveau $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Parmi tous les apprenants';

  @override
  String aheadOfLearners(int percent) {
    return 'Vous devancez $percent% des apprenants';
  }

  @override
  String get retakeLevelTest => 'Refaire le test de niveau';

  @override
  String get practicePronunciation => 'Travailler la prononciation';

  @override
  String get priceChangedTitle => 'Le prix a changé';

  @override
  String priceChangedBody(String price) {
    return 'Cet article coûte désormais $price. Voulez-vous continuer ?';
  }

  @override
  String get billingGroupPlanPurchases => 'Forfait et achats';

  @override
  String get billingGroupInTheStore => 'Dans la boutique';

  @override
  String get billingChangePlan => 'Changer de forfait';

  @override
  String get billingCompareAllPlans => 'Comparer tous les forfaits';

  @override
  String get billingBuyACharacter => 'Acheter un personnage';

  @override
  String get billingRestorePurchases => 'Restaurer les achats';

  @override
  String get billingPaymentHistory => 'Historique des paiements';

  @override
  String get billingManageInTheStore => 'Gérer dans la boutique';

  @override
  String get billingRefundHelp => 'Aide au remboursement';

  @override
  String get billingCancelSubscription => 'Résilier l\'abonnement';

  @override
  String get billingResubscribe => 'Se réabonner';

  @override
  String get badgeCurrent => 'Actuel';

  @override
  String get badgeTrial => 'Essai';

  @override
  String get badgeRenewing => 'Se renouvelle';

  @override
  String get badgePastDue => 'Paiement en retard';

  @override
  String get badgePaused => 'En pause';

  @override
  String get badgeCanceling => 'Se termine';

  @override
  String get subscriptionTitle => 'Abonnement';

  @override
  String get plansTitle => 'Forfaits';

  @override
  String get planFree => 'Gratuit';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Essai Max';

  @override
  String get freePlanPriceLine => '\$0.00 — un appel par jour';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount par mois';
  }

  @override
  String freeUntilDate(String date) {
    return 'Gratuit jusqu\'au $date';
  }

  @override
  String get todaysCalls => 'Appels du jour';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used sur $limit utilisés';
  }

  @override
  String get firstPaymentLabel => 'Premier paiement';

  @override
  String get nextPaymentLabel => 'Prochain paiement';

  @override
  String get retryingUntilLabel => 'Nouvelle tentative jusqu\'au';

  @override
  String get pausedSinceLabel => 'En pause depuis';

  @override
  String planEndsLabel(String plan) {
    return 'Fin de $plan';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Passez en illimité avec Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Appels illimités · 15 minutes chacun · $price par mois';
  }

  @override
  String get bannerMaxUpsellTitle => 'Activez la vidéo avec Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Appels en face à face · $price par mois';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Passez à l\'annuel';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly par an · $perMonth par mois';
  }

  @override
  String get bannerPaymentFailedTitle => 'Le paiement n\'a pas abouti';

  @override
  String get bannerPaymentFailedSub =>
      'Mettez à jour le paiement dans la boutique pour garder Pro';

  @override
  String get bannerPausedTitle => 'Votre forfait est en pause';

  @override
  String get bannerPausedSub => 'Le paiement n\'a jamais abouti';

  @override
  String get noteRestoreHint =>
      'Déjà abonné sur un autre appareil ? La restauration le réactive sur celui-ci.';

  @override
  String get noteStoreHandled =>
      'Le moyen de paiement, les changements de forfait et la résiliation sont gérés par la boutique.';

  @override
  String get noteFairUse =>
      'L\'utilisation illimitée est soumise à notre politique d\'usage raisonnable.';

  @override
  String noteTrialEnds(String date) {
    return 'Votre essai se termine le $date. Résiliez dans la boutique avant cette date et rien ne sera prélevé.';
  }

  @override
  String get noteGrace =>
      'Vos avantages restent actifs pendant la période de grâce. La résiliation n\'est jamais bloquée dans l\'app.';

  @override
  String get noteHold =>
      'Pro est en pause jusqu\'à ce que le paiement aboutisse. Vos personnages et votre progression sont conservés.';

  @override
  String noteEnding(String date) {
    return 'Votre forfait prend fin. Vos avantages restent actifs jusqu\'au $date, puis vous passez à Gratuit. Vous pouvez vous réabonner à tout moment.';
  }

  @override
  String get trialExpiredTitle => 'Votre essai Max est terminé';

  @override
  String get trialExpiredSub => 'Vous êtes maintenant sur Gratuit';

  @override
  String get seePlans => 'Voir les forfaits';

  @override
  String get currentPlanTitle => 'Forfait actuel';

  @override
  String get badgeRecommended => 'Recommandé';

  @override
  String get perMonthUnit => 'par mois';

  @override
  String get planTaglinePro => 'Appels illimités. 15 minutes chacun.';

  @override
  String get planTaglineMax => 'Maintenant, vous pouvez les voir.';

  @override
  String get planTaglineFree => 'Un appel par jour. Offert.';

  @override
  String get bulletProCalls =>
      'Des appels vocaux, aussi souvent que vous voulez';

  @override
  String get bulletProLength => '15 minutes par appel';

  @override
  String get bulletProScoring => 'Prononciation notée lettre par lettre';

  @override
  String get bulletProCorrections =>
      'Des corrections adaptées à votre langue maternelle';

  @override
  String get bulletProBeaverCalls => 'Beaver vous appelle en premier';

  @override
  String get bulletMaxVideo => 'Appels vidéo en face à face';

  @override
  String get bulletMaxEverything => 'Tout ce qui est dans Pro';

  @override
  String get bulletMaxCharacters => 'Tous les personnages, en illimité';

  @override
  String get bulletMaxStudyBook => 'Un cahier d\'étude adapté à votre niveau';

  @override
  String get bulletMaxWeeklyReport =>
      'Un rapport hebdomadaire sur l\'évolution de votre prononciation';

  @override
  String get bulletFreeCall => 'Un appel vocal de 5 minutes par jour';

  @override
  String get bulletFreeCheck => 'Une vérification de prononciation par jour';

  @override
  String get bulletFreeAccent => 'Vérifications d\'accent illimitées';

  @override
  String get bulletFreeCharacter => 'Un personnage pour commencer';

  @override
  String get ctaGoUnlimited => 'Passer en illimité';

  @override
  String get ctaTurnOnVideo => 'Activer la vidéo';

  @override
  String get noteCallLength => 'Chaque appel dure 15 minutes.';

  @override
  String get paywallProTitle1 => 'Votre ami coréen';

  @override
  String get paywallProTitle2 => 'qui est debout à 3 h du matin';

  @override
  String get paywallProSub =>
      'Appels illimités. 15 minutes chacun. Toute l\'année.';

  @override
  String get paywallLimitHeadline => 'Pro supprime la limite.';

  @override
  String get limitBannerCallTitle => 'C\'était l\'appel du jour';

  @override
  String get limitBannerCallSub => 'Gratuit vous donne un appel par jour';

  @override
  String get limitBannerCheckTitle => 'C\'était la vérification du jour';

  @override
  String get limitBannerCheckSub =>
      'Gratuit vous donne une vérification par jour';

  @override
  String get bulletProCharactersForever =>
      'Les personnages achetés restent à vous pour toujours';

  @override
  String get paywallMaxTitle => 'Maintenant, vous pouvez les voir.';

  @override
  String get paywallMaxSub =>
      'Appels vidéo, tous les personnages et un cahier d\'étude adapté à votre niveau.';

  @override
  String get planMonthly => 'Mensuel';

  @override
  String get planAnnual => 'Annuel';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price par mois';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth par mois';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price par mois';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly par an · $perMonth par mois';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price par mois · résiliable à tout moment dans la boutique';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price par mois · résiliable à tout moment dans la boutique';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 jours gratuits, puis $price par mois · résiliable à tout moment dans la boutique';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Se renouvelle automatiquement jusqu’à résiliation.';

  @override
  String get footerTerms => 'Conditions';

  @override
  String get footerPrivacy => 'Confidentialité';

  @override
  String get noteMaxCharacters =>
      'Les personnages débloqués par Max sont disponibles tant que votre abonnement est actif. Les personnages achetés restent à vous.';

  @override
  String get processingTitle => 'Confirmation de votre achat';

  @override
  String get processingSub =>
      'Cela ne prend généralement que quelques secondes.';

  @override
  String get successProTitle => 'Vous êtes sur Pro.';

  @override
  String get successProSub => 'Appels illimités, dès maintenant.';

  @override
  String get successProBenefit1 =>
      'Appelez aussi souvent que vous voulez — 15 minutes par appel';

  @override
  String get successProBenefit2 => 'Vérifications de prononciation illimitées';

  @override
  String get successProBenefit3 =>
      'Tous les personnages, plus les achats à l\'unité';

  @override
  String get successMaxTitle => 'Vous pouvez les voir maintenant.';

  @override
  String get successMaxSub =>
      'Les appels vidéo sont activés. Touchez le bouton vidéo pendant un appel.';

  @override
  String get successMaxBenefit1 => 'Appels vidéo en face à face';

  @override
  String get successMaxBenefit2 =>
      'Tous les personnages, en illimité et les nouveautés en premier';

  @override
  String get successMaxBenefit3 => 'Un cahier d\'étude adapté à votre niveau';

  @override
  String get ctaStartACall => 'Passer un appel';

  @override
  String get ctaStartAVideoCall => 'Passer un appel vidéo';

  @override
  String get ctaSeeYourSubscription => 'Voir votre abonnement';

  @override
  String successProCaption(String price) {
    return '$price sont prélevés chaque mois jusqu\'à résiliation. Gérez ou résiliez à tout moment dans la boutique.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price sont prélevés chaque mois jusqu\'à résiliation. Gérez ou résiliez à tout moment dans la boutique.';
  }

  @override
  String get plansErrorTitle => 'Impossible de charger les forfaits';

  @override
  String get plansErrorSub => 'La boutique n\'a pas répondu.';

  @override
  String get ctaTryAgain => 'Réessayer';

  @override
  String get plansErrorCaption => 'Rien n\'a été prélevé.';

  @override
  String get changePlanTitle => 'Changer de forfait';

  @override
  String get moveToMaxTitle => 'Passer à Max';

  @override
  String maxPriceShort(String price) {
    return '$price/mois';
  }

  @override
  String get moveToMaxCardSub =>
      'Appels vidéo en face à face · tous les personnages · un cahier d\'étude fait pour vous';

  @override
  String get whatHappensNow => 'Ce qui se passe maintenant';

  @override
  String get maxStartsLabel => 'Max commence';

  @override
  String get immediately => 'Immédiatement';

  @override
  String get unusedProTime => 'Temps Pro non utilisé';

  @override
  String get creditedTowardMax => 'Crédité sur Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Passer à Max';

  @override
  String get upgradeCaption =>
      'Votre nouveau forfait commence tout de suite. Le temps Pro non utilisé est crédité, jamais facturé deux fois.';

  @override
  String get moveToProTitle => 'Passer à Pro';

  @override
  String get moveToProSub =>
      'Rien ne change aujourd\'hui. Max continue jusqu\'à la fin du mois déjà payé.';

  @override
  String get maxRunsUntil => 'Max continue jusqu\'au';

  @override
  String get proStarts => 'Pro commence';

  @override
  String get whatYouKeep => 'Ce que vous gardez';

  @override
  String get keepBenefitCalls => 'Appels vocaux illimités, 15 minutes chacun';

  @override
  String get keepBenefitCharacters =>
      'Les personnages achetés restent à vous pour toujours';

  @override
  String downgradeWarning(String date) {
    return 'Les appels vidéo et les personnages exclusifs à Max seront désactivés le $date.';
  }

  @override
  String get ctaSwitchToPro => 'Passer à Pro';

  @override
  String get ctaKeepMax => 'Garder Max';

  @override
  String get winbackSkip => 'Passer';

  @override
  String get winbackTitle => 'Votre forfait Pro est terminé';

  @override
  String get winbackSub =>
      'Vous êtes maintenant sur Gratuit — un appel par jour.';

  @override
  String get winbackQuestion =>
      'Voulez-vous nous dire pourquoi vous êtes parti ?';

  @override
  String get winbackReasonExpensive => 'Trop cher';

  @override
  String get winbackReasonUnused => 'Je ne l\'utilisais pas assez';

  @override
  String get winbackReasonMissing =>
      'Il manquait une fonction dont j\'avais besoin';

  @override
  String get winbackReasonOtherApp => 'J\'ai trouvé une autre appli';

  @override
  String get winbackReasonElse => 'Autre chose';

  @override
  String get ctaSend => 'Envoyer';

  @override
  String get ctaNotNow => 'Pas maintenant';

  @override
  String get winbackCaption =>
      'Cela ne rétablit pas votre forfait. Réabonnez-vous dans la boutique.';

  @override
  String get ctaContinue => 'Continuer';

  @override
  String get ctaClose => 'Fermer';

  @override
  String get ovRestoreSuccessTitle => 'Pro est de retour';

  @override
  String get ovRestoreSuccessBody =>
      'Nous avons retrouvé votre abonnement et l\'avons réactivé sur cet appareil.';

  @override
  String get ovRestoreEmptyTitle => 'Rien à restaurer';

  @override
  String get ovRestoreEmptyBody =>
      'Aucun abonnement actif n\'est associé à ce compte de la boutique.';

  @override
  String get ovRestoreOtherTitle => 'Ce forfait appartient à un autre compte';

  @override
  String get ovRestoreOtherBody =>
      'Cet abonnement est déjà actif sur un autre compte BeaverTalk.';

  @override
  String get ctaSignInThatAccount => 'Se connecter à ce compte';

  @override
  String get ctaGetHelp => 'Obtenir de l\'aide';

  @override
  String get ovCharacterOfferTitle => 'Pas encore prêt pour Pro ?';

  @override
  String get ovCharacterOfferBody =>
      'Choisissez un personnage et gardez-le. Un achat unique — sans abonnement, sans renouvellement.';

  @override
  String get rowOneCharacter => 'Un personnage';

  @override
  String rowFromPrice(String price) {
    return 'à partir de $price';
  }

  @override
  String get rowYoursForever => 'À vous pour toujours';

  @override
  String get rowNoRenewal => 'Sans renouvellement';

  @override
  String get rowWorksOnFree => 'Fonctionne avec Gratuit';

  @override
  String get rowYes => 'Oui';

  @override
  String get ctaSeeCharacters => 'Voir les personnages';

  @override
  String get ovNotEligibleTitle => 'Rien à résilier';

  @override
  String get ovNotEligibleBody =>
      'Vous êtes sur Gratuit. Il n\'y a aucun abonnement actif sur ce compte.';

  @override
  String get ovCancelDownsellTitle => 'Avant de partir';

  @override
  String get ovCancelDownsellBody =>
      'La résiliation se fait dans la boutique. Deux choses à savoir.';

  @override
  String get rowPayYearlyInstead => 'Payez à l\'année';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price par mois';
  }

  @override
  String get rowCharactersYouBought => 'Personnages achetés';

  @override
  String get rowProRunsUntil => 'Pro continue jusqu\'au';

  @override
  String get ctaSwitchToYearly => 'Passer à l\'annuel';

  @override
  String get ctaContinueToStore => 'Continuer vers la boutique';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Payez à l\'année, économisez $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Vous êtes sur Pro depuis deux mois. Le forfait annuel revient moins cher.';

  @override
  String get rowYouSave => 'Vous économisez';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Annuel';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Mensuel, pendant un an';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Passer au mensuel';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Votre forfait annuel court jusqu\'au $date. La facturation mensuelle commence le lendemain.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Début de la facturation mensuelle';

  @override
  String get rowMonthlyLabel => 'Mensuel';

  @override
  String get rowYearlyWorkedOut => 'L\'annuel revenait à';

  @override
  String get ctaSwitchToMonthly => 'Passer au mensuel';

  @override
  String get ovRefundHelpTitle =>
      'Les remboursements sont gérés par la boutique';

  @override
  String get ovRefundHelpBody =>
      'Nous ne pouvons pas effectuer de remboursements nous-mêmes. Chaque demande est examinée par la boutique.';

  @override
  String get ctaGoToStore => 'Aller à la boutique';

  @override
  String get ovTrialEndingTitle => 'Votre essai se termine demain';

  @override
  String get ovTrialEndingBody =>
      'Max continue sauf si vous résiliez. Voici ce qui se passe.';

  @override
  String get rowTrialEnds => 'Fin de l\'essai';

  @override
  String get rowFirstCharge => 'Premier prélèvement';

  @override
  String get rowThenMonthly => 'Puis chaque mois';

  @override
  String get ctaCancelInStore => 'Résilier dans la boutique';

  @override
  String get ovTrialStartTitle => '7 jours de Max, gratuits';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Gratuit jusqu\'au $date. Ensuite $price par mois, sauf si vous résiliez dans la boutique.';
  }

  @override
  String get ctaStart7Days => 'Commencer les 7 jours gratuits';

  @override
  String get ovOtoTitle => 'Une dernière chose avant de commencer';

  @override
  String get ovOtoBody =>
      'Bien vu — les appels illimités sont déjà actifs. Le même Pro coûte moins cher payé à l\'année.';

  @override
  String get ovFailedDeclinedTitle => 'Votre carte a été refusée';

  @override
  String get ovFailedDeclinedBody =>
      'La boutique n\'a pas pu effectuer le paiement. Rien n\'a été prélevé.';

  @override
  String get ctaUpdatePaymentMethod => 'Mettre à jour le moyen de paiement';

  @override
  String get ovFailedCanceledTitle => 'Paiement annulé';

  @override
  String get ovFailedCanceledBody =>
      'Vous êtes toujours sur Gratuit. Rien n\'a été prélevé.';

  @override
  String get ovFailedStoreTitle => 'Un problème est survenu';

  @override
  String get ovFailedStoreBody =>
      'Impossible de joindre la boutique. Rien n\'a été prélevé.';

  @override
  String get ovAlreadyTitle => 'Vous êtes déjà sur Pro';

  @override
  String get ovAlreadyBody =>
      'Ce compte de la boutique a déjà un forfait actif. Il n\'y a rien à acheter.';

  @override
  String get ctaSeeMySubscription => 'Voir mon abonnement';

  @override
  String get subCancelTitle => 'Résilier l\'abonnement';

  @override
  String subCancelBody(String date) {
    return 'Pro continue jusqu\'au $date. Ensuite, vous passez à Gratuit.';
  }

  @override
  String get subWhatYouLose => 'Ce que vous perdez';

  @override
  String get benefitCalls15 => 'Appels illimités, 15 minutes chacun';

  @override
  String get benefitScoring => 'Prononciation notée lettre par lettre';

  @override
  String get benefitEveryCharacter => 'Tous les personnages, en illimité';

  @override
  String get ctaKeepPro => 'Garder Pro';

  @override
  String get subPaymentTitle => 'Mettre à jour le paiement';

  @override
  String get subPaymentBody =>
      'Le paiement n\'a pas pu être effectué. Pro reste actif pendant la période de grâce.';

  @override
  String get subHowToFix => 'Comment corriger';

  @override
  String get fixStep1 =>
      'Ouvrez la boutique et mettez à jour votre moyen de paiement';

  @override
  String get fixStep2 => 'Revenez — votre forfait reprend automatiquement';

  @override
  String get fixStep3 => 'Rien n\'est facturé deux fois';

  @override
  String get subResubTitle => 'Se réabonner';

  @override
  String subResubBody(String date) {
    return 'Pro se termine le $date. Réactivez le renouvellement automatique et rien ne change.';
  }

  @override
  String get subWhatYouKeep => 'Ce que vous gardez';

  @override
  String get ctaTurnItBackOn => 'Réactiver';

  @override
  String get flTodayTitle => 'C\'était l\'appel du jour';

  @override
  String get flTodayBody =>
      'Reprenez là où vous vous êtes arrêté — tout de suite.';

  @override
  String get flCheckTitle => 'C\'était la vérification du jour';

  @override
  String get flCheckBody =>
      'Une vérification par jour avec Gratuit. Pro la rend illimitée.';

  @override
  String get flBenefitCalls => 'Appels illimités avec Pro · 15 minutes chacun';

  @override
  String get flBenefitChecks =>
      'Vérifications de prononciation illimitées avec Pro';

  @override
  String flCaption(String price) {
    return '$price par mois · résiliable à tout moment';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used sur $limit utilisés';
  }

  @override
  String get ctaMaybeTomorrow => 'Peut-être demain';

  @override
  String get accountSection => 'Compte';

  @override
  String get nicknameLabel => 'Pseudo';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Méthode de connexion';

  @override
  String get joinedLabel => 'Inscription';

  @override
  String get editNicknameTitle => 'Modifier le pseudo';

  @override
  String get nicknameRule =>
      '2–12 caractères. Lettres et chiffres. Anglais uniquement';

  @override
  String get ctaSave => 'Enregistrer';

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
      'Si vous partez maintenant, vous ne serez pas abonné';

  @override
  String get paywallLeaveBody =>
      'Vos avantages sont débloqués juste après le paiement. Vous pouvez revenir à tout moment depuis Ma page.';

  @override
  String get ctaKeepLooking => 'Continuer à regarder';

  @override
  String get ctaLeaveAnyway => 'Partir quand même';

  @override
  String get iapCharacterSuccessTitle => 'Un nouvel ami vous rejoint !';

  @override
  String get iapCharacterSuccessBody =>
      'Ce personnage est à vous pour toujours — il reste même si votre forfait change, et Restaurer les achats le ramène sur tout appareil.';

  @override
  String get iapCharacterFailedBody =>
      'L\'achat n\'a pas abouti. Rien n\'a été débité — veuillez réessayer.';

  @override
  String get noAccentDataTitle => 'Pas encore de données d\'intonation';

  @override
  String get noAccentDataBody =>
      'Continuez à parler et les traits de votre intonation s\'accumuleront.';

  @override
  String get noLevelYetTitle => 'Pas encore de niveau';

  @override
  String get noLevelYetBody =>
      'Terminez votre premier appel pour obtenir votre niveau.';

  @override
  String get noPronunciationDataTitle =>
      'Pas encore d\'enregistrements de prononciation';

  @override
  String get noPronunciationDataBody =>
      'Nous analysons votre prononciation à partir des phrases dites pendant les appels.';

  @override
  String get noCharacterNote => 'Rien n\'a encore été dit';

  @override
  String get noPhonemesYet => 'Pas encore de sons à analyser';

  @override
  String get noSentencesYet => 'Pas encore de phrases à analyser';

  @override
  String get takeLevelTest => 'Passer le test de niveau';

  @override
  String get reviewToSeeScore =>
      'Révisez pour voir votre score de prononciation';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get difficultySlow => 'Lent';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Rapide';

  @override
  String get difficultyLabel => 'Difficulté';

  @override
  String get connected => 'Connecté';

  @override
  String get unlockedWithMax => 'Disponible avec Max';

  @override
  String get callModeSheetTitle => 'Comment veux-tu parler ?';

  @override
  String get callModeSheetSubtitle => 'S’applique immédiatement à cet appel';

  @override
  String get callModeFreeTalk => 'Discussion libre';

  @override
  String get callModeFreeTalkDesc => 'Parle sans corrections';

  @override
  String get callModeStudy => 'Étude';

  @override
  String get callModeStudyDesc => 'Apprends une expression à la fois';

  @override
  String get callModeChange => 'Changer de mode';

  @override
  String get callModeKeep => 'Pas maintenant';

  @override
  String get callExitTitle => 'Terminer cet appel ?';

  @override
  String get callExitSubtitle =>
      'Terminer maintenant consomme quand même un appel';

  @override
  String get callExitKeep => 'Continuer à parler';

  @override
  String get callExitConfirm => 'Terminer l’appel';

  @override
  String get callMicMute => 'Couper le micro';

  @override
  String get callMicUnmute => 'Activer le micro';

  @override
  String get callPushToTalk => 'Maintiens pour parler';

  @override
  String get callFreeEndedTitle => 'Ton appel gratuit est terminé';

  @override
  String get callFreeEndedCta => 'S’abonner et continuer';

  @override
  String get callKeepGoingTitle => 'On continue ?';

  @override
  String get callKeepGoingSubtitle =>
      'Les appels se poursuivent par tranches de 5 minutes. On te redemandera à chaque fois.';

  @override
  String get articulationSelectedWord => 'Mot sélectionné';

  @override
  String get articulationYouSaid => 'Votre prononciation';

  @override
  String get articulationTargetSound => 'Cible';

  @override
  String get reportEntry => 'Signaler';

  @override
  String get reportTitle => 'Signaler';

  @override
  String get reportPrompt => 'Quel était le problème ?';

  @override
  String get reportGuide =>
      'Dites-nous quel contenu du personnage IA vous a mis mal à l\'aise. Nous examinons chaque signalement.';

  @override
  String get reportReasonSexual => 'Contenu sexuel';

  @override
  String get reportReasonHate => 'Haine ou discrimination';

  @override
  String get reportReasonViolence => 'Contenu violent ou menaçant';

  @override
  String get reportReasonSelfHarm => 'Incite à l\'automutilation';

  @override
  String get reportReasonMisinfo => 'Fausses informations';

  @override
  String get reportReasonOther => 'Autre problème';

  @override
  String get reportDetailHint => 'Décrivez ce qui s\'est passé (facultatif)';

  @override
  String get reportSubmit => 'Envoyer le signalement';

  @override
  String get reportDoneTitle => 'Votre signalement a bien été reçu';

  @override
  String get reportDoneBody =>
      'Nous l\'examinerons et agirons si nécessaire. Merci de contribuer à la sécurité de BeaverTalk.';

  @override
  String get reportFailed =>
      'Impossible d\'envoyer le signalement. Veuillez réessayer.';

  @override
  String get hwTitle => 'Homework';

  @override
  String get hwJoinCodeTitle => 'Enter your class code';

  @override
  String get hwJoinCodeSubtitle => 'It is the 6-digit code from your teacher';

  @override
  String get hwJoinCodeLabel => 'Class code';

  @override
  String get hwJoinCodeHelp => 'The code is not case-sensitive';

  @override
  String get hwJoinConfirmTitle => 'Is this the right class?';

  @override
  String get hwJoinConfirmSubtitle => 'If not, check the code again';

  @override
  String get hwJoinFieldInstitution => 'Institution';

  @override
  String get hwJoinFieldTeacher => 'Teacher';

  @override
  String get hwJoinFieldLearners => 'Learners';

  @override
  String get hwJoinFieldTerm => 'Term';

  @override
  String get hwJoinConfirmNote =>
      'The class name is exactly as your teacher wrote it. We do not translate it.';

  @override
  String get hwJoinConfirmYes => 'Yes, that is it';

  @override
  String get hwJoinConfirmRetry => 'Re-enter code';

  @override
  String get hwJoinProfileTitle => 'What name will you use in class?';

  @override
  String get hwJoinProfileSubtitle =>
      'Your teacher matches this with the roster';

  @override
  String get hwJoinNameLabel => 'Name';

  @override
  String get hwJoinNameHelp => 'It can differ from your app name';

  @override
  String get hwJoinStudentNoLabel => 'Student ID (optional)';

  @override
  String get hwJoinStudentNoHelp => 'Your teacher uses it to match the roster';

  @override
  String get hwJoinConsentTitle => 'What your teacher sees';

  @override
  String get hwJoinConsentSubtitle => 'You must agree to join the class';

  @override
  String get hwJoinConsentSharedHeading => 'Shared with your teacher';

  @override
  String get hwJoinConsentShared1 => 'Class name and student ID';

  @override
  String get hwJoinConsentShared2 => 'Whether you did the homework';

  @override
  String get hwJoinConsentShared3 => 'Sentences passed and missed';

  @override
  String get hwJoinConsentShared4 => 'Assignment call length and summary';

  @override
  String get hwJoinConsentNotSharedHeading => 'Not shared';

  @override
  String get hwJoinConsentNotShared1 => 'Email and phone number';

  @override
  String get hwJoinConsentNotShared2 => 'App name, profile and character';

  @override
  String get hwJoinConsentNotShared3 => 'Nationality and first language';

  @override
  String get hwJoinConsentNotShared4 => 'Calls and study outside the class';

  @override
  String get hwJoinConsentNotShared5 => 'Subscription and payment details';

  @override
  String get hwJoinConsentAgree => 'I agree to the above';

  @override
  String get hwJoinConsentCta => 'Agree and join';

  @override
  String hwJoinDoneTitle(String className) {
    return 'You joined $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count assignments are waiting';
  }

  @override
  String get hwJoinDoneNoAssignment => 'No assignments yet';

  @override
  String get hwJoinDoneNextDue => 'Next due';

  @override
  String get hwJoinDoneRosterName => 'Your class name';

  @override
  String get hwJoinDoneCta => 'See homework';

  @override
  String get hwJoinErrorNotFound => 'We could not find that code';

  @override
  String get hwJoinErrorNotFoundBody => 'Please check the six digits again.';

  @override
  String get hwJoinErrorExpired => 'That code has expired';

  @override
  String get hwJoinErrorExpiredBody => 'Ask your teacher for a new code.';

  @override
  String get hwJoinErrorFull => 'The class is full';

  @override
  String get hwJoinErrorFullBody => 'Please let your teacher know.';

  @override
  String get hwJoinFailed => 'Could not join. Please try again in a moment.';

  @override
  String get hwSectionInProgress => 'In progress';

  @override
  String get hwSectionUpcoming => 'Upcoming';

  @override
  String get hwSectionDone => 'Done';

  @override
  String get hwLeaveClassLink => 'Leave the class';

  @override
  String get hwListEmptyTitle => 'No homework yet';

  @override
  String get hwListEmptyBody =>
      'It will show up here when your teacher assigns it.';

  @override
  String get hwListFailed => 'Could not load your homework.';

  @override
  String get hwRetry => 'Try again';

  @override
  String get hwBadgeDone => 'Done';

  @override
  String get hwBadgeOverdue => 'Not submitted';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Not submitted, ${days}d late';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Due today';

  @override
  String get hwActivitySpeaking => 'Speaking';

  @override
  String get hwActivityConversation => 'Conversation';

  @override
  String get hwActivityWorkbook => 'Workbook';

  @override
  String hwChapterLabel(String chapter) {
    return 'Chapter $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Check your pronunciation score';

  @override
  String get hwTaskConversationDesc => 'Use what you learned in a real talk';

  @override
  String get hwTaskWorkbookDesc => 'Practice by writing in the workbook';

  @override
  String get hwCtaStudy => 'Start';

  @override
  String get hwCtaResult => 'See result';

  @override
  String get hwCtaDownload => 'Download';

  @override
  String get hwSpeakingNoScore => 'You have not done the speaking task yet';

  @override
  String get hwWorkbookUnavailable => 'The workbook file is not available yet.';

  @override
  String get hwDetailClosed =>
      'This assignment is closed. You can no longer submit.';

  @override
  String get hwLeaveTitle => 'Leave the class?';

  @override
  String get hwLeaveBody =>
      'Your teacher will no longer see your homework results.';

  @override
  String get hwLeaveConfirm => 'Leave';

  @override
  String get hwLeaveCancel => 'Stay';

  @override
  String get hwLeaveFailed => 'Could not leave the class.';

  @override
  String get hwMyClass => 'My class';

  @override
  String get hwClassEmptyTitle => 'You have not joined a class';

  @override
  String get hwClassEmptySubtitle => 'Enter the code your teacher gave you';

  @override
  String get hwClassEmptyCta => 'Enter class code';

  @override
  String get hwClassContinueCta => 'Continue';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count assignments are due tomorrow';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'You have $count unsubmitted assignments';
  }

  @override
  String get hwSpeakingUnavailable =>
      'The sentences for this assignment are not available yet.';

  @override
  String get hwBadgeClosed => 'Closed';
}
