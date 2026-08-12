// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginRequired => 'Necesitas iniciar sesión.';

  @override
  String get callWebNotSupported =>
      'Las llamadas de voz no funcionan en la web. Usa la app.';

  @override
  String get micPermissionRequiredForCall =>
      'Se necesita acceso al micrófono. Permite el micrófono para llamar.';

  @override
  String get callErrorGeneric => 'Se produjo un error durante la llamada.';

  @override
  String get callNetworkError => 'Se produjo un error de red.';

  @override
  String get authInvalidCredentials =>
      'El correo o la contraseña no son correctos.';

  @override
  String get authEmailAlreadyRegistered => 'Este correo ya está registrado.';

  @override
  String get authConfirmEmailRequired =>
      'Completa la verificación enviada a tu correo.';

  @override
  String get authResetCodeSent =>
      'Te enviamos un código de verificación por correo.';

  @override
  String get authResetCodeInvalid => 'El código no es correcto o ha caducado.';

  @override
  String get authPasswordUpdated => 'Tu contraseña se ha restablecido.';

  @override
  String get authAppleTokenMissing =>
      'No se pudo obtener el token de inicio de sesión de Apple.';

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
  String get quickStart => 'Inicio rápido';

  @override
  String get presetMorning => 'Rutina matutina';

  @override
  String get presetMorningSub => 'Días laborables 8:00';

  @override
  String get presetEvening => 'Cierre del día';

  @override
  String get presetEveningSub => 'Todos los días 21:00';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get presetCustomSub => 'A tu manera';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× por semana · $monthly llamadas al mes';
  }

  @override
  String get alarmSummaryNone => 'Elige al menos un día';

  @override
  String get partnerInUse => 'En uso';

  @override
  String get partnerOwned => 'En posesión';

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
    return 'Llamada n.º $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Unas palabras de $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Dejado por $name justo después de la llamada';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Expresiones nuevas $count';
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
  String get selectNativeLanguage => 'Selecciona tu idioma nativo';

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
  String get analyzingByWord =>
      'Revisando tu pronunciación palabra por palabra';

  @override
  String get analyzingTakingLonger => 'Esto está tardando un poco más';

  @override
  String get scanConnectionLost => 'Conexión perdida';

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
  String pricePerMonth(String price) {
    return '$price / mes';
  }

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
  String get loginAppleSignInFailed => 'Error al iniciar sesión con Apple.';

  @override
  String get loginKakaoSignInFailed => 'Error al iniciar sesión con Kakao.';

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
  String get thisMonthPayment => 'Pago de este mes';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterSubscription => 'Suscripción';

  @override
  String get filterCharacter => 'Personaje';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get lastPayment => 'Último pago';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Puedes seguir usando las ventajas Pro hasta el $date; después, tu plan cambiará automáticamente a Gratis.';
  }

  @override
  String get freePlanCallLimit => '1 llamada al día · límite de 5 min';

  @override
  String get freePlanBasicCharacters => 'Personajes básicos incluidos';

  @override
  String get availableForPurchase => 'Disponible para comprar';

  @override
  String get paymentsLoadError => 'No se pudo cargar el historial de pagos';

  @override
  String get noPayments => 'Aún no hay pagos';

  @override
  String get morePaymentsExist => 'Los pagos anteriores aún no se muestran';

  @override
  String get undatedPayments => 'Sin fecha';

  @override
  String get paymentLabelFallback => 'Pago';

  @override
  String learningPassed(int passed, int total) {
    return '$passed de $total frases superadas';
  }

  @override
  String get hardestSound => 'Sonido más difícil de hoy';

  @override
  String get soundAccuracy => 'Precisión por sonido';

  @override
  String phonemeAttempts(int count) {
    return 'Por fonema · $count intentos';
  }

  @override
  String get colSound => 'Sonido';

  @override
  String get colAttempts => 'Int.';

  @override
  String get colCorrect => 'Acier.';

  @override
  String get colAccuracy => 'Prec.';

  @override
  String get sentenceResults => 'Resultados por frase';

  @override
  String viewAllSentences(int count) {
    return 'Ver las $count';
  }

  @override
  String get colSentence => 'Frase';

  @override
  String get colPronunciation => 'Pron.';

  @override
  String get colFluency => 'Flui.';

  @override
  String get colRhythm => 'Ritmo';

  @override
  String recentSessions(int count) {
    return 'Últimas $count sesiones';
  }

  @override
  String trendAverage(int score) {
    return 'Prom. $score';
  }

  @override
  String get today => 'Hoy';

  @override
  String get colDate => 'Fecha';

  @override
  String get colSentences => 'Frases';

  @override
  String get colScore => 'Punt.';

  @override
  String get colChange => 'Camb.';

  @override
  String dateToday(String date) {
    return '$date (hoy)';
  }

  @override
  String get accentAnalysis => 'Análisis de acento';

  @override
  String get overallLevel => 'Nivel general';

  @override
  String get overallLevelSubtitle => 'Vocabulario · Gramática · Expresiones';

  @override
  String get pronunciationAnalysis => 'Análisis de pronunciación';

  @override
  String get recentSessionsAverage => 'Media de 10 sesiones';

  @override
  String levelStage(int stage) {
    return 'Nivel $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Entre todos los estudiantes';

  @override
  String aheadOfLearners(int percent) {
    return 'Superas al $percent% de los estudiantes';
  }

  @override
  String get retakeLevelTest => 'Repetir prueba de nivel';

  @override
  String get practicePronunciation => 'Practicar pronunciación';

  @override
  String get priceChangedTitle => 'El precio cambió';

  @override
  String priceChangedBody(String price) {
    return 'Este artículo ahora cuesta $price. ¿Quieres continuar?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plan y compras';

  @override
  String get billingGroupInTheStore => 'En la tienda';

  @override
  String get billingChangePlan => 'Cambiar de plan';

  @override
  String get billingCompareAllPlans => 'Comparar todos los planes';

  @override
  String get billingBuyACharacter => 'Comprar un personaje';

  @override
  String get billingRestorePurchases => 'Restaurar compras';

  @override
  String get billingPaymentHistory => 'Historial de pagos';

  @override
  String get billingManageInTheStore => 'Gestionar en la tienda';

  @override
  String get billingRefundHelp => 'Ayuda con reembolsos';

  @override
  String get billingCancelSubscription => 'Cancelar suscripción';

  @override
  String get billingResubscribe => 'Volver a suscribirse';

  @override
  String get badgeCurrent => 'Actual';

  @override
  String get badgeTrial => 'Prueba';

  @override
  String get badgeRenewing => 'Se renueva';

  @override
  String get badgePastDue => 'Pago vencido';

  @override
  String get badgePaused => 'En pausa';

  @override
  String get badgeCanceling => 'Finalizando';

  @override
  String get subscriptionTitle => 'Suscripción';

  @override
  String get plansTitle => 'Planes';

  @override
  String get planFree => 'Gratis';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Prueba de Max';

  @override
  String get freePlanPriceLine => '\$0.00 — una llamada al día';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount al mes';
  }

  @override
  String freeUntilDate(String date) {
    return 'Gratis hasta el $date';
  }

  @override
  String get todaysCalls => 'Llamadas de hoy';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used de $limit usadas';
  }

  @override
  String get firstPaymentLabel => 'Primer pago';

  @override
  String get nextPaymentLabel => 'Próximo pago';

  @override
  String get retryingUntilLabel => 'Reintentando hasta el';

  @override
  String get pausedSinceLabel => 'En pausa desde';

  @override
  String planEndsLabel(String plan) {
    return '$plan termina';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pasa a ilimitado con Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Llamadas ilimitadas · 15 minutos cada una · $price al mes';
  }

  @override
  String get bannerMaxUpsellTitle => 'Activa el video con Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Llamadas cara a cara · $price al mes';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Cámbiate al plan anual';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly al año · $perMonth al mes';
  }

  @override
  String get bannerPaymentFailedTitle => 'No pudimos procesar el pago';

  @override
  String get bannerPaymentFailedSub =>
      'Actualiza el pago en la tienda para conservar Pro';

  @override
  String get bannerPausedTitle => 'Tu plan está en pausa';

  @override
  String get bannerPausedSub => 'El pago no se llegó a realizar';

  @override
  String get noteRestoreHint =>
      '¿Ya tienes una suscripción en otro dispositivo? Restaurar la trae a este.';

  @override
  String get noteStoreHandled =>
      'El método de pago, los cambios de plan y la cancelación se gestionan en la tienda.';

  @override
  String get noteFairUse =>
      'El uso ilimitado está sujeto a nuestra política de uso razonable.';

  @override
  String noteTrialEnds(String date) {
    return 'Tu prueba termina el $date. Cancela antes en la tienda y no se te cobrará nada.';
  }

  @override
  String get noteGrace =>
      'Tus beneficios siguen activos durante el período de gracia. La cancelación nunca se bloquea en la app.';

  @override
  String get noteHold =>
      'Pro está en pausa hasta que se complete el pago. Tus personajes y tu progreso están a salvo.';

  @override
  String noteEnding(String date) {
    return 'Tu plan va a terminar. Los beneficios duran hasta el $date y luego pasas a Gratis. Puedes volver a suscribirte cuando quieras.';
  }

  @override
  String get trialExpiredTitle => 'Tu prueba de Max terminó';

  @override
  String get trialExpiredSub => 'Ahora estás en Gratis';

  @override
  String get seePlans => 'Ver planes';

  @override
  String get currentPlanTitle => 'Plan actual';

  @override
  String get badgeRecommended => 'Recomendado';

  @override
  String get perMonthUnit => 'al mes';

  @override
  String get planTaglinePro => 'Llamadas ilimitadas. 15 minutos cada una.';

  @override
  String get planTaglineMax => 'Ahora puedes verlos.';

  @override
  String get planTaglineFree => 'Una llamada al día. Invita la casa.';

  @override
  String get bulletProCalls => 'Llamadas de voz, tantas como quieras';

  @override
  String get bulletProLength => '15 minutos por llamada';

  @override
  String get bulletProScoring => 'Pronunciación puntuada letra por letra';

  @override
  String get bulletProCorrections =>
      'Correcciones adaptadas a tu idioma nativo';

  @override
  String get bulletProBeaverCalls => 'Beaver te llama primero';

  @override
  String get bulletMaxVideo => 'Videollamadas cara a cara';

  @override
  String get bulletMaxEverything => 'Todo lo de Pro';

  @override
  String get bulletMaxCharacters => 'Todos los personajes, sin límites';

  @override
  String get bulletMaxStudyBook =>
      'Un cuaderno de estudio a la medida de tu nivel';

  @override
  String get bulletMaxWeeklyReport =>
      'Un informe semanal de cómo cambia tu pronunciación';

  @override
  String get bulletFreeCall => 'Una llamada de voz de 5 minutos al día';

  @override
  String get bulletFreeCheck => 'Una prueba de pronunciación al día';

  @override
  String get bulletFreeAccent => 'Pruebas de acento ilimitadas';

  @override
  String get bulletFreeCharacter => 'Un personaje para empezar';

  @override
  String get ctaGoUnlimited => 'Pasar a ilimitado';

  @override
  String get ctaTurnOnVideo => 'Activar el video';

  @override
  String get noteCallLength => 'Cada llamada dura 15 minutos.';

  @override
  String get paywallProTitle1 => 'Tu amigo coreano';

  @override
  String get paywallProTitle2 => 'que está despierto a las 3 a.m.';

  @override
  String get paywallProSub =>
      'Llamadas ilimitadas. 15 minutos cada una. Todo el año.';

  @override
  String get paywallLimitHeadline => 'Pro elimina el límite.';

  @override
  String get limitBannerCallTitle => 'Esa fue la llamada de hoy';

  @override
  String get limitBannerCallSub => 'Gratis te da una llamada al día';

  @override
  String get limitBannerCheckTitle => 'Esa fue la prueba de hoy';

  @override
  String get limitBannerCheckSub => 'Gratis te da una prueba al día';

  @override
  String get bulletProCharactersForever =>
      'Los personajes que compras son tuyos para siempre';

  @override
  String get paywallMaxTitle => 'Ahora puedes verlos.';

  @override
  String get paywallMaxSub =>
      'Videollamadas, todos los personajes y un cuaderno de estudio hecho para tu nivel.';

  @override
  String get planMonthly => 'Mensual';

  @override
  String get planAnnual => 'Anual';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price al mes';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth al mes';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price al mes';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly al año · $perMonth al mes';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price al mes · cancela cuando quieras en la tienda';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price al mes · cancela cuando quieras en la tienda';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 días gratis, luego $price al mes · cancela cuando quieras en la tienda';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Se renueva automáticamente hasta que lo canceles.';

  @override
  String get footerTerms => 'Términos';

  @override
  String get footerPrivacy => 'Privacidad';

  @override
  String get noteMaxCharacters =>
      'Los personajes desbloqueados con Max están disponibles mientras tu suscripción esté activa. Los personajes que compraste siguen siendo tuyos.';

  @override
  String get processingTitle => 'Confirmando tu compra';

  @override
  String get processingSub => 'Esto suele tardar unos segundos.';

  @override
  String get successProTitle => 'Ya estás en Pro.';

  @override
  String get successProSub => 'Llamadas ilimitadas, desde ahora mismo.';

  @override
  String get successProBenefit1 =>
      'Llama tanto como quieras — 15 minutos por llamada';

  @override
  String get successProBenefit2 => 'Pruebas de pronunciación ilimitadas';

  @override
  String get successProBenefit3 => 'Todos los personajes, más compras únicas';

  @override
  String get successMaxTitle => 'Ahora puedes verlos.';

  @override
  String get successMaxSub =>
      'Las videollamadas están activadas. Toca el botón de video en cualquier llamada.';

  @override
  String get successMaxBenefit1 => 'Videollamadas cara a cara';

  @override
  String get successMaxBenefit2 =>
      'Todos los personajes, sin límites y los nuevos primero';

  @override
  String get successMaxBenefit3 =>
      'Un cuaderno de estudio a la medida de tu nivel';

  @override
  String get ctaStartACall => 'Iniciar una llamada';

  @override
  String get ctaStartAVideoCall => 'Iniciar una videollamada';

  @override
  String get ctaSeeYourSubscription => 'Ver tu suscripción';

  @override
  String successProCaption(String price) {
    return 'Se cobran $price al mes hasta que canceles. Gestiona o cancela cuando quieras en la tienda.';
  }

  @override
  String successMaxCaption(String price) {
    return 'Se cobran $price al mes hasta que canceles. Gestiona o cancela cuando quieras en la tienda.';
  }

  @override
  String get plansErrorTitle => 'No pudimos cargar los planes';

  @override
  String get plansErrorSub => 'La tienda no respondió.';

  @override
  String get ctaTryAgain => 'Reintentar';

  @override
  String get plansErrorCaption => 'No se cobró nada.';

  @override
  String get changePlanTitle => 'Cambiar de plan';

  @override
  String get moveToMaxTitle => 'Pasar a Max';

  @override
  String maxPriceShort(String price) {
    return '$price/mes';
  }

  @override
  String get moveToMaxCardSub =>
      'Videollamadas cara a cara · todos los personajes · un cuaderno de estudio hecho para ti';

  @override
  String get whatHappensNow => 'Qué pasa ahora';

  @override
  String get maxStartsLabel => 'Max empieza';

  @override
  String get immediately => 'De inmediato';

  @override
  String get unusedProTime => 'Tiempo de Pro sin usar';

  @override
  String get creditedTowardMax => 'Se abona a Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Cambiar a Max';

  @override
  String get upgradeCaption =>
      'Tu nuevo plan empieza de inmediato. El tiempo de Pro sin usar se abona; nunca se cobra dos veces.';

  @override
  String get moveToProTitle => 'Pasar a Pro';

  @override
  String get moveToProSub =>
      'Hoy no cambia nada. Max sigue hasta el final del mes que ya pagaste.';

  @override
  String get maxRunsUntil => 'Max sigue hasta el';

  @override
  String get proStarts => 'Pro empieza';

  @override
  String get whatYouKeep => 'Lo que conservas';

  @override
  String get keepBenefitCalls =>
      'Llamadas de voz ilimitadas, 15 minutos cada una';

  @override
  String get keepBenefitCharacters =>
      'Los personajes que compraste son tuyos para siempre';

  @override
  String downgradeWarning(String date) {
    return 'Las videollamadas y los personajes exclusivos de Max se desactivan el $date.';
  }

  @override
  String get ctaSwitchToPro => 'Cambiar a Pro';

  @override
  String get ctaKeepMax => 'Conservar Max';

  @override
  String get winbackSkip => 'Omitir';

  @override
  String get winbackTitle => 'Tu plan Pro terminó';

  @override
  String get winbackSub => 'Ahora estás en Gratis — una llamada al día.';

  @override
  String get winbackQuestion => '¿Nos cuentas por qué te fuiste?';

  @override
  String get winbackReasonExpensive => 'Demasiado caro';

  @override
  String get winbackReasonUnused => 'No lo usaba lo suficiente';

  @override
  String get winbackReasonMissing => 'Faltaba una función que necesitaba';

  @override
  String get winbackReasonOtherApp => 'Encontré otra app';

  @override
  String get winbackReasonElse => 'Otra cosa';

  @override
  String get ctaSend => 'Enviar';

  @override
  String get ctaNotNow => 'Ahora no';

  @override
  String get winbackCaption =>
      'Esto no restaura tu plan. Vuelve a suscribirte en la tienda.';

  @override
  String get ctaContinue => 'Continuar';

  @override
  String get ctaClose => 'Cerrar';

  @override
  String get ovRestoreSuccessTitle => 'Pro está de vuelta';

  @override
  String get ovRestoreSuccessBody =>
      'Encontramos tu suscripción y la reactivamos en este dispositivo.';

  @override
  String get ovRestoreEmptyTitle => 'Nada que restaurar';

  @override
  String get ovRestoreEmptyBody =>
      'No hay ninguna suscripción activa vinculada a esta cuenta de la tienda.';

  @override
  String get ovRestoreOtherTitle => 'Ese plan pertenece a otra cuenta';

  @override
  String get ovRestoreOtherBody =>
      'Esta suscripción ya está activa en otra cuenta de BeaverTalk.';

  @override
  String get ctaSignInThatAccount => 'Iniciar sesión con esa cuenta';

  @override
  String get ctaGetHelp => 'Obtener ayuda';

  @override
  String get ovCharacterOfferTitle => '¿Aún no estás listo para Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Elige un personaje y quédatelo. Una compra única — sin suscripción, sin renovación.';

  @override
  String get rowOneCharacter => 'Un personaje';

  @override
  String rowFromPrice(String price) {
    return 'desde $price';
  }

  @override
  String get rowYoursForever => 'Tuyo para siempre';

  @override
  String get rowNoRenewal => 'Sin renovación';

  @override
  String get rowWorksOnFree => 'Funciona con Gratis';

  @override
  String get rowYes => 'Sí';

  @override
  String get ctaSeeCharacters => 'Ver personajes';

  @override
  String get ovNotEligibleTitle => 'Nada que cancelar';

  @override
  String get ovNotEligibleBody =>
      'Estás en Gratis. No hay ninguna suscripción activa en esta cuenta.';

  @override
  String get ovCancelDownsellTitle => 'Antes de irte';

  @override
  String get ovCancelDownsellBody =>
      'La cancelación se hace en la tienda. Dos cosas que conviene saber.';

  @override
  String get rowPayYearlyInstead => 'Paga una vez al año';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price al mes';
  }

  @override
  String get rowCharactersYouBought => 'Personajes que compraste';

  @override
  String get rowProRunsUntil => 'Pro sigue hasta el';

  @override
  String get ctaSwitchToYearly => 'Cambiar a anual';

  @override
  String get ctaContinueToStore => 'Continuar a la tienda';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Paga anual y ahorra $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Llevas dos meses en Pro. El plan anual sale más barato.';

  @override
  String get rowYouSave => 'Ahorras';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Anual';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Mensual, durante un año';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Cambiar a mensual';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Tu plan anual dura hasta el $date. La facturación mensual empieza el día siguiente.';
  }

  @override
  String get rowMonthlyBillingStarts => 'La facturación mensual empieza';

  @override
  String get rowMonthlyLabel => 'Mensual';

  @override
  String get rowYearlyWorkedOut => 'El anual salía a';

  @override
  String get ctaSwitchToMonthly => 'Cambiar a mensual';

  @override
  String get ovRefundHelpTitle => 'Los reembolsos se gestionan en la tienda';

  @override
  String get ovRefundHelpBody =>
      'No podemos emitir reembolsos nosotros mismos. La tienda revisa cada solicitud.';

  @override
  String get ctaGoToStore => 'Ir a la tienda';

  @override
  String get ovTrialEndingTitle => 'Tu prueba termina mañana';

  @override
  String get ovTrialEndingBody =>
      'Max sigue activo salvo que canceles. Esto es lo que pasa.';

  @override
  String get rowTrialEnds => 'La prueba termina';

  @override
  String get rowFirstCharge => 'Primer cobro';

  @override
  String get rowThenMonthly => 'Luego mensual';

  @override
  String get ctaCancelInStore => 'Cancelar en la tienda';

  @override
  String get ovTrialStartTitle => '7 días de Max, gratis';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Gratis hasta el $date. Después, $price al mes, salvo que canceles en la tienda.';
  }

  @override
  String get ctaStart7Days => 'Empezar 7 días gratis';

  @override
  String get ovOtoTitle => 'Una cosa más antes de empezar';

  @override
  String get ovOtoBody =>
      'Buena decisión — las llamadas ilimitadas ya están activas. El mismo Pro cuesta menos si pagas anual.';

  @override
  String get ovFailedDeclinedTitle => 'Tu tarjeta fue rechazada';

  @override
  String get ovFailedDeclinedBody =>
      'La tienda no pudo procesar el pago. No se cobró nada.';

  @override
  String get ctaUpdatePaymentMethod => 'Actualizar método de pago';

  @override
  String get ovFailedCanceledTitle => 'Pago cancelado';

  @override
  String get ovFailedCanceledBody => 'Sigues en Gratis. No se cobró nada.';

  @override
  String get ovFailedStoreTitle => 'Algo salió mal';

  @override
  String get ovFailedStoreBody =>
      'No pudimos conectar con la tienda. No se cobró nada.';

  @override
  String get ovAlreadyTitle => 'Ya estás en Pro';

  @override
  String get ovAlreadyBody =>
      'Esta cuenta de la tienda ya tiene un plan activo. No hay nada que comprar.';

  @override
  String get ctaSeeMySubscription => 'Ver mi suscripción';

  @override
  String get subCancelTitle => 'Cancelar suscripción';

  @override
  String subCancelBody(String date) {
    return 'Pro sigue hasta el $date. Después pasas a Gratis.';
  }

  @override
  String get subWhatYouLose => 'Lo que pierdes';

  @override
  String get benefitCalls15 => 'Llamadas ilimitadas, 15 minutos cada una';

  @override
  String get benefitScoring => 'Pronunciación puntuada letra por letra';

  @override
  String get benefitEveryCharacter => 'Todos los personajes, sin límites';

  @override
  String get ctaKeepPro => 'Conservar Pro';

  @override
  String get subPaymentTitle => 'Actualizar pago';

  @override
  String get subPaymentBody =>
      'No pudimos procesar el pago. Pro sigue activo durante el período de gracia.';

  @override
  String get subHowToFix => 'Cómo solucionarlo';

  @override
  String get fixStep1 => 'Abre la tienda y actualiza tu método de pago';

  @override
  String get fixStep2 => 'Vuelve — tu plan se reanuda automáticamente';

  @override
  String get fixStep3 => 'Nada se cobra dos veces';

  @override
  String get subResubTitle => 'Volver a suscribirse';

  @override
  String subResubBody(String date) {
    return 'Pro termina el $date. Reactiva la renovación automática y nada cambia.';
  }

  @override
  String get subWhatYouKeep => 'Lo que conservas';

  @override
  String get ctaTurnItBackOn => 'Volver a activarla';

  @override
  String get flTodayTitle => 'Esa fue la llamada de hoy';

  @override
  String get flTodayBody => 'Retoma donde lo dejaste — ahora mismo.';

  @override
  String get flCheckTitle => 'Esa fue la prueba de hoy';

  @override
  String get flCheckBody =>
      'Una prueba al día en Gratis. Con Pro es ilimitado.';

  @override
  String get flBenefitCalls =>
      'Llamadas ilimitadas con Pro · 15 minutos cada una';

  @override
  String get flBenefitChecks => 'Pruebas de pronunciación ilimitadas con Pro';

  @override
  String flCaption(String price) {
    return '$price al mes · cancela cuando quieras';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used de $limit usados';
  }

  @override
  String get ctaMaybeTomorrow => 'Quizá mañana';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Método de inicio de sesión';

  @override
  String get joinedLabel => 'Fecha de registro';

  @override
  String get editNicknameTitle => 'Editar apodo';

  @override
  String get nicknameRule => '2–12 caracteres. Letras y números. Solo inglés';

  @override
  String get ctaSave => 'Guardar';

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
  String get paywallLeaveTitle => 'Si sales ahora, no estarás suscrito';

  @override
  String get paywallLeaveBody =>
      'Tus beneficios se desbloquean justo después del pago. Puedes volver cuando quieras desde Mi página.';

  @override
  String get ctaKeepLooking => 'Seguir viendo';

  @override
  String get ctaLeaveAnyway => 'Salir de todos modos';

  @override
  String get iapCharacterSuccessTitle => '¡Un nuevo amigo se une!';

  @override
  String get iapCharacterSuccessBody =>
      'Este personaje es tuyo para siempre: se queda aunque cambies de plan, y Restaurar compras lo recupera en cualquier dispositivo.';

  @override
  String get iapCharacterFailedBody =>
      'La compra no se completó. No se cobró nada; inténtalo de nuevo.';

  @override
  String get noAccentDataTitle => 'Aún no hay datos de entonación';

  @override
  String get noAccentDataBody =>
      'Sigue hablando y se irán acumulando los rasgos de tu entonación.';

  @override
  String get noLevelYetTitle => 'Aún no hay nivel';

  @override
  String get noLevelYetBody =>
      'Termina tu primera llamada para obtener tu nivel.';

  @override
  String get noPronunciationDataTitle =>
      'Aún no hay registros de pronunciación';

  @override
  String get noPronunciationDataBody =>
      'Analizamos tu pronunciación a partir de las frases que dices en las llamadas.';

  @override
  String get noCharacterNote => 'Aún no ha dicho nada';

  @override
  String get noPhonemesYet => 'Aún no hay sonidos que analizar';

  @override
  String get noSentencesYet => 'Aún no hay frases que analizar';

  @override
  String get takeLevelTest => 'Hacer prueba de nivel';

  @override
  String get reviewToSeeScore =>
      'Repasa para ver tu puntuación de pronunciación';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get difficultySlow => 'Lento';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Rápido';

  @override
  String get difficultyLabel => 'Dificultad';

  @override
  String get unlockedWithMax => 'Disponible con Max';
}
