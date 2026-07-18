// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Llamada finalizada $duration';
  }

  @override
  String get callRatingPrompt => '¿Qué tal tu llamada?';

  @override
  String get ratingBad => 'No muy bien';

  @override
  String get ratingOkay => 'Bien';

  @override
  String get ratingGood => 'Muy bien';

  @override
  String get goHome => 'Inicio';

  @override
  String get viewAnalysis => 'Ver análisis';

  @override
  String get loadingShort => 'Cargando…';

  @override
  String ratingSubmitFailed(String message) {
    return 'No se pudo enviar la calificación: $message';
  }

  @override
  String get callInfoNotFound =>
      'No se encontró información de la llamada; se omite el análisis.';

  @override
  String get tabRecords => 'Registros';

  @override
  String get tabArchive => 'Archivo';

  @override
  String get callHistory => 'Historial de llamadas';

  @override
  String get conversationRecord => 'Registro de conversación';

  @override
  String get noCallRecords => 'Aún no hay registros de llamadas';

  @override
  String get noCallRecordsBody =>
      'Cuando termines tu primera llamada con la IA,\ntus registros aparecerán aquí.';

  @override
  String get startCall => 'Iniciar llamada';

  @override
  String get recordsLoadError => 'No se pudieron cargar los registros';

  @override
  String get tryAgainLater => 'Inténtalo de nuevo más tarde.';

  @override
  String get retry => 'Reintentar';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds seg';
  }

  @override
  String get scheduleManagement => 'Horario';

  @override
  String get alarms => 'Alarmas';

  @override
  String get addSchedule => 'Añadir horario';

  @override
  String get editSchedule => 'Editar horario';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get alarmsLoadError => 'No se pudieron cargar las alarmas';

  @override
  String get charactersLoadError => 'No se pudieron cargar los personajes';

  @override
  String get noCharacters => 'No hay personajes disponibles';

  @override
  String get close => 'Cerrar';

  @override
  String get repeat => 'Repetir';

  @override
  String get callPartner => 'Personaje';

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
  String get save => 'Guardar';

  @override
  String get conversation => 'Conversación';

  @override
  String get review => 'Repaso';

  @override
  String get pronunciationChallenge => 'Desafío de pronunciación';

  @override
  String get newExpressions => 'Expresiones nuevas';

  @override
  String get analysisResult => 'Resultado del análisis';

  @override
  String get noNewExpressions =>
      'No hay expresiones nuevas en esta conversación.';

  @override
  String get practice => 'Practicar';

  @override
  String recentScore(int score) {
    return 'Puntuación reciente $score%';
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
      'No se pudo cargar el resultado del análisis.';

  @override
  String get standardAudioNotReady =>
      'El audio de pronunciación estándar aún no está listo.';

  @override
  String get standardAudioPlayError =>
      'No se pudo reproducir el audio de pronunciación estándar.';

  @override
  String get selectACountry => 'Selecciona un país';

  @override
  String get selectYourLanguage => 'Selecciona tu idioma';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get selectTime => 'Selecciona la hora';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get permissionTitle =>
      'Permite los accesos\npara una experiencia fluida';

  @override
  String get permissionSubtitle =>
      'Los permisos requeridos son esenciales para usar el servicio.';

  @override
  String get permissionMicTitle => 'Micrófono (obligatorio)';

  @override
  String get permissionMicDesc => 'Necesario para hablar con la IA en inglés.';

  @override
  String get permissionNotifTitle => 'Notificaciones (opcional)';

  @override
  String get permissionNotifDesc =>
      'Te enviaremos recordatorios de aprendizaje y horarios de llamadas.';

  @override
  String get micPermissionNeededTitle => 'Se necesita acceso al micrófono';

  @override
  String get micPermissionNeededBody =>
      'Para hablar con la IA, debes permitir el acceso al micrófono. Actívalo en Configuración.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get connectionFailedTitle => 'Fallo de conexión';

  @override
  String get connectionFailedBody =>
      'Comprueba tu conexión a internet\ne inténtalo de nuevo.';

  @override
  String get checkout => 'Finalizar compra';

  @override
  String get pay => 'Pagar';

  @override
  String get orderSummary => 'Resumen del pedido';

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get payMethodCard => 'Tarjeta de crédito / débito';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar de Castor Molesto';

  @override
  String get productTrait => 'Personaje premium · Tuyo para siempre';

  @override
  String get amountItemPrice => 'Precio del artículo';

  @override
  String get amountDiscount => 'Descuento';

  @override
  String get amountTotal => 'Total';

  @override
  String get paymentCompleteTitle => 'Pago completado';

  @override
  String get paymentCompleteBody => 'El avatar se ha añadido a tu colección.';

  @override
  String get viewCollection => 'Ver colección';

  @override
  String get receiptItem => 'Artículo';

  @override
  String get receiptAmount => 'Importe';

  @override
  String get receiptMethod => 'Método de pago';

  @override
  String get receiptDate => 'Fecha';

  @override
  String get paymentFailedTitle => 'Pago fallido';

  @override
  String get paymentFailedBody =>
      'No se pudo procesar tu pago.\nInténtalo de nuevo.';

  @override
  String get freeCallEndingTitle => 'Tu llamada gratuita está por terminar';

  @override
  String get freeCallEndingBody =>
      'Suscríbete para hablar más tiempo con Beaver.';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get endCall => 'Finalizar llamada';

  @override
  String get callEnded => 'La llamada ha finalizado.';

  @override
  String get connecting => 'Conectando…';

  @override
  String get connectingHint => 'Esto suele tardar menos de 5 segundos';

  @override
  String get callConnectFailed => 'No se pudo conectar la llamada.';

  @override
  String get saveSentenceFailed => 'No se pudo guardar la frase.';

  @override
  String get recordStartFailed => 'No se pudo iniciar la grabación.';

  @override
  String get recordTooShort =>
      'La grabación fue demasiado corta. Inténtalo de nuevo.';

  @override
  String get gradingFailed => 'Error al calificar. Inténtalo de nuevo.';

  @override
  String get listenStandard => 'Escuchar pronunciación estándar';

  @override
  String get saveSentence => 'Guardar frase';

  @override
  String get unsaveSentence => 'Quitar frase guardada';

  @override
  String get scoringPronunciation => 'Calificando tu pronunciación…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'No hay grabación para reproducir.';

  @override
  String get myRecordingPlayError => 'No se pudo reproducir tu grabación.';

  @override
  String get next => 'Siguiente';

  @override
  String get endLearning => 'Finalizar sesión';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navCall => 'Llamada';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get myPage => 'Mi página';

  @override
  String get languageSaveFailed => 'No se pudo guardar tu idioma.';

  @override
  String get accountDeleteFailed => 'No se pudo eliminar tu cuenta.';

  @override
  String get changeAvatar => 'Cambiar avatar';

  @override
  String get avatarIntro =>
      'La voz y la dificultad varían según el personaje.\nAlgunos personajes pueden requerir pago.';

  @override
  String myPartnersOwned(int count) {
    return 'Mis personajes · $count adquiridos';
  }

  @override
  String get limitedDiscount => 'Descuento por tiempo limitado';

  @override
  String get available => 'Disponible';

  @override
  String get inUse => 'En uso';

  @override
  String get owned => 'Adquirido';

  @override
  String get noCharactersToShow => 'No hay personajes para mostrar';

  @override
  String get buy => 'Comprar';

  @override
  String get noSavedSentences =>
      'Aún no hay frases guardadas.\nGuarda frases desde tus registros de conversación.';

  @override
  String get noAlarms => 'Aún no hay alarmas';

  @override
  String get noAlarmsBody =>
      'Añade un recordatorio de aprendizaje\npara crear un hábito constante.';

  @override
  String get subscriptionManage => 'Administrar suscripción';

  @override
  String get changePlan => 'Cambiar plan';

  @override
  String get cancelSubscription => 'Cancelar suscripción';

  @override
  String get benefitsInUse => 'Tus beneficios';

  @override
  String get paymentInfo => 'Información de pago';

  @override
  String get nextBillingDate => 'Próxima fecha de facturación';

  @override
  String get lostBenefitsTitle => 'Beneficios que perderás si cancelas';

  @override
  String get viewBillingHistory => 'Ver historial de facturación';

  @override
  String get keepUsingPro => 'Seguir usando Pro';

  @override
  String get proMembership => 'Membresía Pro';

  @override
  String get pricePerMonth => '\$12.9 / mes';

  @override
  String get benefitUnlimitedCalls => 'Llamadas ilimitadas';

  @override
  String get benefitDetailedAnalysis =>
      'Análisis detallado de pronunciación y gramática';

  @override
  String get benefitAllCharacters => 'Acceso a todos los personajes';

  @override
  String get benefitNoAds => 'Sin anuncios';

  @override
  String get playSampleVoice => 'Reproducir voz de muestra';

  @override
  String get useThisAvatar => 'Usar este';

  @override
  String get challengeTitle => 'Desafío de pronunciación';

  @override
  String get challengeIntro =>
      'Pronuncia correctamente en coreano cada tarjeta de la zona para superarla.\n¿Sin micrófono? También puedes jugar tocando la pantalla.';

  @override
  String get challengeStart => 'Activar cámara y micrófono';

  @override
  String get challengePermissionNote =>
      'Se requiere acceso a la cámara frontal y al micrófono (opcional).';

  @override
  String get challengeLoadingTitle => 'Cargando…';

  @override
  String get challengeLoadingNote =>
      'Descargando el modelo de voz en coreano (~82MB) en el primer uso.\nEspera un momento.';

  @override
  String get challengeSttFallback =>
      'El reconocimiento de voz no estaba disponible, así que jugaste tocando la pantalla.';

  @override
  String get reasonTravelTitle => 'Hablar mientras viajas';

  @override
  String get reasonTravelDesc => 'Conversa con confianza con los locales';

  @override
  String get reasonCareerTitle => 'Trabajo y carrera';

  @override
  String get reasonCareerDesc => 'Conversación de negocios';

  @override
  String get reasonExamTitle => 'Preparación de exámenes';

  @override
  String get reasonExamDesc => 'Prepárate para exámenes orales';

  @override
  String get reasonDailyTitle => 'Conversación cotidiana';

  @override
  String get reasonDailyDesc => 'Expresiones que usas a diario';

  @override
  String get reasonFriendsTitle => 'Hacer amigos extranjeros';

  @override
  String get reasonFriendsDesc => 'Conversación natural';

  @override
  String get reasonBrainTitle => 'Estimulación cerebral';

  @override
  String get reasonBrainDesc => 'Mejora la memoria y la concentración';

  @override
  String get challengeRecordToggle => 'Grabar esta partida';

  @override
  String get challengeRecordHint =>
      'Guarda un video de tu partida para compartir (sin sonido).';

  @override
  String get settingsSection => 'Configuración';

  @override
  String get paymentSection => 'Pago';

  @override
  String get supportSection => 'Soporte';

  @override
  String get userLanguage => 'Idioma del usuario';

  @override
  String get learningLanguage => 'Idioma de aprendizaje';

  @override
  String get learningLanguageKorean => 'Coreano';

  @override
  String get notificationLabel => 'Notificación';

  @override
  String get currentPlan => 'Plan actual';

  @override
  String get paymentHistory => 'Historial de pagos';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountBody =>
      'Esto elimina permanentemente tu cuenta y tus datos, y no se puede deshacer.';

  @override
  String get delete => 'Eliminar';

  @override
  String get share => 'Compartir';

  @override
  String get accentSoundsLike => 'Tu acento coreano suena';

  @override
  String get hintLabel => 'Pista';

  @override
  String get nextHint => 'Siguiente pista';

  @override
  String get translateLabel => 'Traducir';

  @override
  String get startRecording => 'Iniciar grabación';

  @override
  String get stopRecording => 'Detener grabación';

  @override
  String get back => 'Atrás';

  @override
  String get onboardingNameTitle => '¿Cómo deberíamos llamarte?';

  @override
  String get onboardingNameSubtitle => 'Tu tutor de IA recordará tu nombre.';

  @override
  String get nameLabel => 'Tu nombre';

  @override
  String get nameHint => 'Ingresa tu nombre';

  @override
  String get nameHelper =>
      'No tiene que ser tu nombre real; un apodo también sirve.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get onboardingDoneTitle => 'Beaver está esperando tu llamada';

  @override
  String get onboardingDoneSubtitle => 'Inicia una llamada ahora mismo';

  @override
  String get home => 'Inicio';

  @override
  String get callNow => 'Llamar ahora';

  @override
  String get pronunciation => 'Pronunciación';

  @override
  String get fluency => 'Fluidez';

  @override
  String get rhythm => 'Ritmo';

  @override
  String get analysisTimeout =>
      'Esto está tardando más de lo esperado. Inténtalo de nuevo en un momento.';

  @override
  String get analysisFailed =>
      'No pudimos analizar la conversación. Inténtalo de nuevo.';

  @override
  String get analyzingConversation => 'Analizando tu conversación…';

  @override
  String get analyzingSubtitle => 'Esto solo tomará un momento';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get nativeLabel => 'Nativo';

  @override
  String get meLabel => 'Yo';

  @override
  String get pronunciationPlayError =>
      'No se pudo reproducir el audio de pronunciación.';

  @override
  String get savedExpressionsLoadError =>
      'No se pudieron cargar tus expresiones guardadas.';

  @override
  String get mySavedExpressions => 'Mis expresiones guardadas';

  @override
  String get avatarTraits => 'Cálido · Tranquilo · Suave';

  @override
  String get priceFree => 'Gratis';

  @override
  String get loginGoogleTokenError =>
      'No se pudo obtener el token de inicio de sesión de Google.';

  @override
  String get loginGoogleSignInFailed => 'Error al iniciar sesión con Google.';

  @override
  String get loginContinueWithKakao => 'Continuar con Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuar con Google';

  @override
  String get loginContinueWithApple => 'Continuar con Apple';

  @override
  String get loginContinueWithEmail => 'Continuar con correo electrónico';

  @override
  String get loginOrDivider => 'o';

  @override
  String get loginNoAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get loginTermsNoticePrefix => 'Al continuar, aceptas nuestros ';

  @override
  String get loginTermsNoticeAnd => ' y ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Iniciar sesión';

  @override
  String get fieldEmailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingresa tu correo electrónico';

  @override
  String get fieldPasswordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get loginRememberMe => 'Recordarme';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginLoggingIn => 'Iniciando sesión...';

  @override
  String get passwordLengthError =>
      'La contraseña debe tener entre 8 y 16 caracteres.';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden.';

  @override
  String get signupCheckInput => 'Revisa los datos ingresados.';

  @override
  String get fieldConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Vuelve a ingresar tu contraseña';

  @override
  String get signupSigningUp => 'Registrando...';

  @override
  String get signupHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get passwordMethodEmailRequired => 'Ingresa tu correo electrónico';

  @override
  String get passwordResetTitle => 'Restablecer contraseña';

  @override
  String get passwordMethodDescription =>
      'Ingresa la dirección de correo electrónico donde quieres recibir el código para restablecer la contraseña.';

  @override
  String get emailAddressHint => 'Dirección de correo electrónico';

  @override
  String get passwordMethodSending => 'Enviando...';

  @override
  String get passwordMethodSendEmail => 'Enviar correo';

  @override
  String get passwordCodeTitle => 'Ingresa el código';

  @override
  String get passwordCodeDescription =>
      'Enviamos un código de recuperación a tu correo. Ingrésalo para continuar.';

  @override
  String get passwordCodeNoCode => '¿No recibiste el código?';

  @override
  String get passwordCodeResend => 'Reenviar código';

  @override
  String get passwordCodeVerifying => 'Verificando...';

  @override
  String get passwordNewTitle => 'Nueva contraseña';

  @override
  String get passwordNewDescription =>
      'Establece una nueva contraseña para tu cuenta.';

  @override
  String get fieldNewPasswordLabel => 'Nueva contraseña';

  @override
  String get newPasswordHint => 'Ingresa tu nueva contraseña';

  @override
  String get fieldConfirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get confirmNewPasswordHint => 'Vuelve a ingresar tu nueva contraseña';

  @override
  String get passwordNewSubmitting => 'Enviando...';

  @override
  String get passwordNewSubmit => 'Enviar';

  @override
  String get passwordCompleteTitle => 'Contraseña restablecida';

  @override
  String get passwordCompleteBody =>
      'Tu contraseña ha sido restablecida. Inicia sesión con tu nueva contraseña para continuar.';

  @override
  String get termsTitle => 'Términos de servicio';

  @override
  String get privacyTitle => 'Política de privacidad';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Establece una nueva contraseña para $email.';
  }

  @override
  String get selectComplete => 'Listo';

  @override
  String get onboardingLanguageTitle => '¿Cuál es tu idioma nativo?';

  @override
  String get onboardingReasonTitle => '¿Por qué estás aprendiendo un idioma?';

  @override
  String get onboardingReasonSubtitle =>
      'Adaptaremos tu aprendizaje a tus objetivos.';

  @override
  String get savingLabel => 'Guardando...';

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
