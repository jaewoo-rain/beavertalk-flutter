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
  String get callDailyLimit => 'Ya usaste tu tiempo de aprendizaje de hoy.';

  @override
  String get callAlreadyInCall => 'Ya estás en una llamada.';

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
  String get callRatingBody =>
      'Tu valoración nos ayuda a conversar mejor la próxima vez.';

  @override
  String get callRatingSubmit => 'Enviar';

  @override
  String get callRatingSkip => 'Omitir';

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
  String get alarmAdd => 'Añadir alarma';

  @override
  String get alarmEdit => 'Editar alarma';

  @override
  String get alarmEveryDay => 'Todos los días';

  @override
  String get alarmWeekdays => 'Entre semana';

  @override
  String get alarmWeekend => 'Fines de semana';

  @override
  String get alarmNoRepeat => 'Nunca';

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
  String get alarmModeLearnSub => 'Practica expresiones del plan';

  @override
  String get alarmModeChatSub => 'Habla de lo que quieras';

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
  String get newExpressions => 'Expresiones nuevas';

  @override
  String get analysisPrepNote => 'Repasando la llamada de hoy.';

  @override
  String get analysisPrepNoteHint => 'En breve aparecerá aquí una nota';

  @override
  String get analysisPrepTitle =>
      'El castor está convirtiendo las expresiones de hoy en tarjetas';

  @override
  String get analysisPrepSub => 'Aparecerán aquí en cuanto estén listas.';

  @override
  String get analysisPrepStepSave => 'Guardar la conversación';

  @override
  String get analysisPrepStepCards => 'Crear tarjetas de expresiones';

  @override
  String get analysisPrepStateDone => 'Listo';

  @override
  String get analysisPrepStateWorking => 'En curso';

  @override
  String get analysisPrepStateWaiting => 'En espera';

  @override
  String get usedExpressions => 'Expresiones que usaste';

  @override
  String quizExpressionsCount(int count) {
    return 'Expresiones que aprendiste $count';
  }

  @override
  String get quizPassed => 'Acertaste';

  @override
  String get quizFailed => 'Repásala';

  @override
  String get quizPending => 'Sigue la próxima vez';

  @override
  String get analysisResult => 'Resultado del análisis';

  @override
  String get noNewExpressions =>
      'No hay expresiones nuevas en esta conversación.';

  @override
  String get practice => 'Practicar';

  @override
  String get analysisNativeLabel => 'Nativo';

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
  String get navCall => 'Llamada';

  @override
  String get homeCourseExpression => 'Expresiones';

  @override
  String get homeCourseFreetalk => 'Conversación';

  @override
  String homeExpressionsLeft(int count) {
    return 'Faltan $count expresiones para la conversación';
  }

  @override
  String get homeFreetalkNote => 'Usa lo aprendido y habla con libertad';

  @override
  String get homeTalkTitle => '¿Qué pasó hoy?';

  @override
  String get homeTalkNote => 'Conversa libremente y aprende sobre la marcha.';

  @override
  String get homeModeLearn => 'Aprender';

  @override
  String get homeModeTalk => 'Charlar';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días seguidos',
      one: '1 día seguido',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Calendario de aprendizaje';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días seguidos',
      one: 'día seguido',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mejor racha: $count días',
      one: 'Mejor racha: $count día',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Tiempo de llamada';

  @override
  String get streakMetricLearned => 'Expresiones';

  @override
  String get streakMetricWords => 'Palabras dichas';

  @override
  String streakCountValue(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'No hubo llamadas este día.';

  @override
  String get homeLevelPending => 'Nivel pendiente';

  @override
  String get homeNoLevelTitle => 'Aún no tienes un nivel';

  @override
  String get homeNoLevelNote => 'Completa tu primera llamada para obtenerlo';

  @override
  String get homeCurriculumPendingBadge => 'Próximamente';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'El plan de estudios de $language está en camino';
  }

  @override
  String get homeCurriculumPendingNote =>
      'En tus llamadas practicarás expresiones generales';

  @override
  String get myPage => 'Mi página';

  @override
  String get languageSaveFailed => 'No se pudo guardar tu idioma.';

  @override
  String get accountDeleteFailed => 'No se pudo eliminar tu cuenta.';

  @override
  String get changeAvatar => 'Cambiar avatar';

  @override
  String get avatarUseNow => 'Usar ahora';

  @override
  String get avatarPurchaseFailed => 'La compra no se completó';

  @override
  String avatarPromoTitle(int percent) {
    return 'Solo hoy · $percent % de descuento';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'Quedan $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'Quedan $days d $time';
  }

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
  String pricePerMonth(String price) {
    return '$price / mes';
  }

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
  String get challengeLoadingNote => 'Preparando la cámara y el micrófono.';

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
  String accentShareText(String country) {
    return 'Estoy aprendiendo coreano con BeaverTalk: ¡mi acento coreano suena a $country! 🦫 Descubre tu acento y aprende conmigo: https://beavertalk.im';
  }

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
  String get onboardingLevelTestCta => 'Hacer prueba de nivel';

  @override
  String get pronunciation => 'Pronunciación';

  @override
  String get fluency => 'Fluidez';

  @override
  String get rhythm => 'Ritmo';

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
  String get loginFacebookSignInFailed =>
      'Error al iniciar sesión con Facebook.';

  @override
  String get loginKakaoSignInFailed => 'Error al iniciar sesión con Kakao.';

  @override
  String get loginContinueWithKakao => 'Continuar con Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuar con Google';

  @override
  String get loginContinueWithFacebook => 'Continuar con Facebook';

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
  String get freePlanCallLimit => '5 min de llamadas al día';

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
  String get levelTestOncePerDay =>
      'Puedes hacer la prueba de nivel una vez al día. Inténtalo de nuevo mañana.';

  @override
  String get levelRetakeTitle => '¿Repetir la prueba de nivel?';

  @override
  String get levelRetakeBody =>
      'Si la repites, tu progreso vuelve a la primera lección de ese nivel, aunque obtengas el mismo nivel. Tus expresiones aprendidas y tu historial de llamadas se conservan.';

  @override
  String get levelRetakeKeep => 'Mantener mi progreso';

  @override
  String get levelRetakeConfirm => 'Repetir prueba';

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
  String get billingCompareAllPlans => 'Comparar planes';

  @override
  String get billingBuyACharacter => 'Comprar un personaje';

  @override
  String get billingRestorePurchases => 'Restaurar compras';

  @override
  String get billingRedeemCode => 'Canjear un código';

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
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => '15 minutos de videollamadas al día';

  @override
  String get premiumBulletAnalysis => 'Análisis completo de pronunciación';

  @override
  String get premiumBulletWeakSounds =>
      'Práctica de sonidos difíciles para tu idioma';

  @override
  String get noteCharactersSeparate =>
      'Los personajes se venden aparte. Los que compras son tuyos.';

  @override
  String get ctaGetPremium => 'Obtener Premium';

  @override
  String get planMaxTrial => 'Prueba de Premium';

  @override
  String get freePlanPriceLine => '\$0.00 — 5 minutos de llamadas al día';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount al mes';
  }

  @override
  String freeUntilDate(String date) {
    return 'Gratis hasta el $date';
  }

  @override
  String get todaysCalls => 'Tiempo de llamada de hoy';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used de $limit min usados';
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
  String get bannerMaxUpsellTitle => 'Habla cara a cara con Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Videollamadas · 15 minutos al día · $price al mes';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Cámbiate al plan anual';

  @override
  String get bannerPaymentFailedTitle => 'No pudimos procesar el pago';

  @override
  String get bannerPaymentFailedSub =>
      'Actualiza el pago en la tienda para conservar Premium';

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
  String noteTrialEnds(String date) {
    return 'Tu prueba termina el $date. Cancela antes en la tienda y no se te cobrará nada.';
  }

  @override
  String get noteGrace =>
      'Tus beneficios siguen activos durante el período de gracia. La cancelación nunca se bloquea en la app.';

  @override
  String get noteHold =>
      'Premium está en pausa hasta que se complete el pago. Tus personajes y tu progreso están a salvo.';

  @override
  String noteEnding(String date) {
    return 'Tu plan va a terminar. Los beneficios duran hasta el $date y luego pasas a Gratis. Puedes volver a suscribirte cuando quieras.';
  }

  @override
  String get trialExpiredTitle => 'Tu prueba de Premium terminó';

  @override
  String get trialExpiredSub => 'Ahora estás en Gratis';

  @override
  String get seePlans => 'Ver planes';

  @override
  String get currentPlanTitle => 'Plan actual';

  @override
  String get perMonthUnit => 'al mes';

  @override
  String get planTaglineMax => 'Ahora puedes verlos.';

  @override
  String get planTaglineFree => '5 minutos de llamadas al día. Invita la casa.';

  @override
  String get bulletProCorrections =>
      'Correcciones adaptadas a tu idioma nativo';

  @override
  String get bulletFreeCall => '5 minutos de llamadas de voz al día';

  @override
  String get bulletFreeCheck => 'Análisis completo en tus 3 primeras llamadas';

  @override
  String get bulletFreeCharacter => 'Dos personajes para empezar';

  @override
  String get ctaTurnOnVideo => 'Activar el video';

  @override
  String get noteCallLength =>
      'Premium: 15 minutos al día — dentro de ese tiempo, llama cuantas veces quieras.';

  @override
  String get paywallProTitle1 => 'Tu amigo coreano';

  @override
  String get paywallProTitle2 => 'que está despierto a las 3 a.m.';

  @override
  String get paywallLimitHeadline =>
      'Premium te da 15 minutos de llamadas al día.';

  @override
  String get limitBannerCallTitle => 'Ya usaste el tiempo de llamada de hoy';

  @override
  String get limitBannerCallSub => 'Gratis te da 5 minutos de llamadas al día';

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
  String paywallTutorCompare(String price) {
    return 'Una hora con un tutor cuesta \$25. Un mes de Premium cuesta $price.';
  }

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
  String get processingTitle => 'Confirmando tu compra';

  @override
  String get processingSub => 'Esto suele tardar unos segundos.';

  @override
  String get successProTitle => 'Ya estás en Premium.';

  @override
  String get successMaxTitle => 'Ahora puedes verlos.';

  @override
  String get successMaxSub =>
      'Las videollamadas están activadas. Toca el botón de video en cualquier llamada.';

  @override
  String get ctaStartAVideoCall => 'Iniciar una videollamada';

  @override
  String get ctaSeeYourSubscription => 'Ver tu suscripción';

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
  String get ctaKeepMax => 'Conservar Premium';

  @override
  String get winbackSkip => 'Omitir';

  @override
  String get winbackTitle => 'Tu plan Premium terminó';

  @override
  String get winbackSub =>
      'Ahora estás en Gratis — 5 minutos de llamadas al día.';

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
  String get ovRestoreSuccessTitle => 'Premium está de vuelta';

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
  String get ovCharacterOfferTitle => '¿Aún no estás listo para Premium?';

  @override
  String get ovCharacterOfferBody =>
      'Elige un personaje y quédatelo. Una compra única — sin suscripción, sin renovación.';

  @override
  String get rowOneCharacter => 'Un personaje';

  @override
  String rowFromPrice(String price) {
    return '$price cada uno';
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
  String get rowProRunsUntil => 'Premium sigue hasta el';

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
      'El plan anual sale más barato que pagar cada mes.';

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
      'Premium sigue activo salvo que canceles. Esto es lo que pasa.';

  @override
  String get rowTrialEnds => 'La prueba termina';

  @override
  String get rowFirstCharge => 'Primer cobro';

  @override
  String get rowThenMonthly => 'Luego mensual';

  @override
  String get ctaCancelInStore => 'Cancelar en la tienda';

  @override
  String get ovTrialStartTitle => '7 días de Premium, gratis';

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
      'Buena elección. El mismo Premium cuesta menos si pagas al año.';

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
  String get ovAlreadyTitle => 'Ya estás en Premium';

  @override
  String get ovAlreadyBody =>
      'Esta cuenta de la tienda ya tiene un plan activo. No hay nada que comprar.';

  @override
  String get ctaSeeMySubscription => 'Ver mi suscripción';

  @override
  String get subCancelTitle => 'Cancelar suscripción';

  @override
  String subCancelBody(String date) {
    return 'Premium sigue hasta el $date. Después pasas a Gratis.';
  }

  @override
  String get subWhatYouLose => 'Lo que pierdes';

  @override
  String get benefitScoring => 'Pronunciación puntuada letra por letra';

  @override
  String get benefitEveryMetric => 'Cada métrica, cada frase';

  @override
  String get subPaymentTitle => 'Actualizar pago';

  @override
  String get subPaymentBody =>
      'No pudimos procesar el pago. Premium sigue activo durante el período de gracia.';

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
    return 'Premium termina el $date. Reactiva la renovación automática y nada cambia.';
  }

  @override
  String get subWhatYouKeep => 'Lo que conservas';

  @override
  String get ctaTurnItBackOn => 'Volver a activarla';

  @override
  String get flTodayTitle => 'Ya usaste el tiempo de llamada de hoy';

  @override
  String get flTodayBody => 'Retoma donde lo dejaste — ahora mismo.';

  @override
  String get flCheckTitle => 'Esa fue la prueba de hoy';

  @override
  String get flCheckBody =>
      'Gratis incluye una revisión al día. Premium te da el análisis completo.';

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
  String get emailLabel => 'Correo';

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
  String get subscriptionRow => 'Suscripción';

  @override
  String get iapSuccessTitle => 'Compra completada';

  @override
  String iapSuccessBody(String name) {
    return 'El avatar $name es tuyo para siempre.\nSe aplica en cuanto se confirme el recibo.';
  }

  @override
  String get ctaGoHome => 'Ir al inicio';

  @override
  String get ctaUseNow => 'Usarlo ahora';

  @override
  String get iapFailTitle => 'El pago no se completó';

  @override
  String get iapFailBody => 'Puedes intentarlo de nuevo';

  @override
  String get paywallGuardTitle => 'Puedes seguir con el plan Gratis';

  @override
  String get paywallGuardBody =>
      'Sigues teniendo 5 minutos de llamadas al día.';

  @override
  String get ctaMaybeLater => 'Quizás más tarde';

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
  String get connected => 'Conectado';

  @override
  String get unlockedWithMax => 'Incluido en tu plan';

  @override
  String get fcEndedTitle => 'Tu llamada gratuita ha terminado';

  @override
  String get fcEndedBody =>
      'Las llamadas gratuitas duran hasta 5 minutos\nSuscríbete para seguir hablando más tiempo';

  @override
  String get ctaSubscribeKeepTalking => 'Suscribirse y seguir hablando';

  @override
  String get kgTitle => '¿Seguimos?';

  @override
  String get kgBody =>
      'Las llamadas continúan en tramos cortos.\nTe preguntaremos de nuevo cada vez.';

  @override
  String get pcEndedTitleToday => 'Terminemos la llamada de hoy.';

  @override
  String get pcEndedBodyToday =>
      'Repasa lo que hablamos y llámame otra vez mañana.';

  @override
  String get pcEndedTitle => 'Terminemos esta llamada.';

  @override
  String get pcEndedBody => 'Repasa lo que hablamos y llámame otra vez.';

  @override
  String get ctaKeepTalking => 'Seguir hablando';

  @override
  String get callModeSheetTitle => '¿Cómo quieres hablar?';

  @override
  String get callModeSheetSubtitle => 'Se aplica a esta llamada de inmediato';

  @override
  String get callModeFreeTalk => 'Charla libre';

  @override
  String get callModeFreeTalkDesc => 'Habla sin correcciones';

  @override
  String get callModeStudy => 'Estudio';

  @override
  String get callModeStudyDesc => 'Aprende una expresión a la vez';

  @override
  String get callModeChange => 'Cambiar modo';

  @override
  String get callModeKeep => 'Ahora no';

  @override
  String get callExitTitle => '¿Terminar la llamada?';

  @override
  String get callExitSubtitle =>
      'El tiempo que ya hablaste cuenta para hoy igualmente';

  @override
  String get callExitKeep => 'Seguir hablando';

  @override
  String get callExitConfirm => 'Finalizar llamada';

  @override
  String get callMicMute => 'Silenciar';

  @override
  String get callMicUnmute => 'Activar micrófono';

  @override
  String get callPushToTalk => 'Mantén para hablar';

  @override
  String get callFreeEndedTitle => 'Tu llamada gratuita terminó';

  @override
  String get callFreeEndedCta => 'Suscríbete y sigue hablando';

  @override
  String get callKeepGoingTitle => '¿Seguimos?';

  @override
  String get callKeepGoingSubtitle =>
      'Las llamadas continúan en tramos de 5 minutos. Te preguntaremos cada vez.';

  @override
  String get articulationSelectedWord => 'Palabra seleccionada';

  @override
  String get articulationYouSaid => 'Tu pronunciación';

  @override
  String get articulationTargetSound => 'Objetivo';

  @override
  String get reportEntry => 'Denunciar';

  @override
  String get reportTitle => 'Denunciar';

  @override
  String get reportPrompt => '¿Cuál fue el problema?';

  @override
  String get reportGuide =>
      'Cuéntanos qué contenido del personaje de IA te incomodó. Revisamos todas las denuncias.';

  @override
  String get reportReasonSexual => 'Contenido sexual';

  @override
  String get reportReasonHate => 'Odio o discriminación';

  @override
  String get reportReasonViolence => 'Contenido violento o amenazante';

  @override
  String get reportReasonSelfHarm => 'Fomenta la autolesión';

  @override
  String get reportReasonMisinfo => 'Información falsa';

  @override
  String get reportReasonOther => 'Otro problema';

  @override
  String get reportDetailHint => 'Describe lo que pasó (opcional)';

  @override
  String get reportSubmit => 'Enviar denuncia';

  @override
  String get reportDoneTitle => 'Recibimos tu denuncia';

  @override
  String get reportDoneBody =>
      'La revisaremos y tomaremos medidas si es necesario. Gracias por ayudar a mantener BeaverTalk seguro.';

  @override
  String get reportFailed =>
      'No se pudo enviar la denuncia. Inténtalo de nuevo.';

  @override
  String get hwTitle => 'Tareas';

  @override
  String get hwJoinCodeTitle => 'Introduce el código de tu clase';

  @override
  String get hwJoinCodeSubtitle =>
      'Es el código de 6 caracteres que te dio tu profesor';

  @override
  String get hwJoinCodeLabel => 'Código de clase';

  @override
  String get hwJoinCodeHelp =>
      'El código no distingue mayúsculas de minúsculas';

  @override
  String get hwJoinConfirmTitle => '¿Es esta la clase correcta?';

  @override
  String get hwJoinConfirmSubtitle => 'Si no, revisa el código otra vez';

  @override
  String get hwJoinFieldInstitution => 'Institución';

  @override
  String get hwJoinFieldTeacher => 'Profesor';

  @override
  String get hwJoinFieldLearners => 'Estudiantes';

  @override
  String get hwJoinFieldTerm => 'Periodo';

  @override
  String get hwJoinConfirmNote =>
      'El nombre de la clase aparece tal como lo escribió tu profesor. No lo traducimos.';

  @override
  String get hwJoinConfirmYes => 'Sí, es esta';

  @override
  String get hwJoinConfirmRetry => 'Volver a escribir el código';

  @override
  String get hwJoinProfileTitle => '¿Qué nombre usarás en clase?';

  @override
  String get hwJoinProfileSubtitle =>
      'Tu profesor lo compara con la lista de clase';

  @override
  String get hwJoinNameLabel => 'Nombre';

  @override
  String get hwJoinNameHelp => 'Puede ser distinto de tu nombre en la app';

  @override
  String get hwJoinStudentNoLabel => 'Número de estudiante (opcional)';

  @override
  String get hwJoinStudentNoHelp => 'Tu profesor lo usa para cotejar la lista';

  @override
  String get hwJoinConsentTitle => 'Lo que ve tu profesor';

  @override
  String get hwJoinConsentSubtitle => 'Debes aceptar para unirte a la clase';

  @override
  String get hwJoinConsentSharedHeading => 'Se comparte con tu profesor';

  @override
  String get hwJoinConsentShared1 =>
      'Nombre de la clase y número de estudiante';

  @override
  String get hwJoinConsentShared2 => 'Si hiciste la tarea';

  @override
  String get hwJoinConsentShared3 => 'Frases superadas y falladas';

  @override
  String get hwJoinConsentShared4 =>
      'Duración y resumen de la llamada de la tarea';

  @override
  String get hwJoinConsentNotSharedHeading => 'No se comparte';

  @override
  String get hwJoinConsentNotShared1 => 'Correo y número de teléfono';

  @override
  String get hwJoinConsentNotShared2 => 'Nombre en la app, perfil y personaje';

  @override
  String get hwJoinConsentNotShared3 => 'Nacionalidad e idioma materno';

  @override
  String get hwJoinConsentNotShared4 => 'Llamadas y estudio fuera de la clase';

  @override
  String get hwJoinConsentNotShared5 => 'Datos de suscripción y pago';

  @override
  String get hwJoinConsentAgree => 'Acepto lo anterior';

  @override
  String get hwJoinConsentCta => 'Aceptar y unirme';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Te uniste a $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'Te esperan $count tareas';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Aún no hay tareas';

  @override
  String get hwJoinDoneNextDue => 'Próxima entrega';

  @override
  String get hwJoinDoneRosterName => 'Tu nombre en la clase';

  @override
  String get hwJoinDoneCta => 'Ver tareas';

  @override
  String get hwJoinErrorNotFound => 'No encontramos ese código';

  @override
  String get hwJoinErrorNotFoundBody => 'Revisa de nuevo los seis dígitos.';

  @override
  String get hwJoinErrorExpired => 'Ese código ha caducado';

  @override
  String get hwJoinErrorExpiredBody => 'Pide un código nuevo a tu profesor.';

  @override
  String get hwJoinErrorFull => 'La clase está llena';

  @override
  String get hwJoinErrorFullBody => 'Avisa a tu profesor.';

  @override
  String get hwJoinFailed =>
      'No se pudo unir. Inténtalo de nuevo en un momento.';

  @override
  String get hwSectionInProgress => 'En curso';

  @override
  String get hwSectionUpcoming => 'Próximas';

  @override
  String get hwSectionDone => 'Hechas';

  @override
  String get hwLeaveClassLink => 'Salir de la clase';

  @override
  String get hwListEmptyTitle => 'Aún no hay tareas';

  @override
  String get hwListEmptyBody =>
      'Aparecerán aquí cuando tu profesor las asigne.';

  @override
  String get hwListFailed => 'No se pudieron cargar tus tareas.';

  @override
  String get hwRetry => 'Reintentar';

  @override
  String get hwBadgeDone => 'Hecha';

  @override
  String get hwBadgeOverdue => 'Sin entregar';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Sin entregar, $days d de retraso';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Vence hoy';

  @override
  String get hwActivitySpeaking => 'Expresión oral';

  @override
  String get hwActivityConversation => 'Conversación';

  @override
  String get hwActivityWorkbook => 'Cuaderno';

  @override
  String hwChapterLabel(String chapter) {
    return 'Capítulo $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Comprueba tu puntuación de pronunciación';

  @override
  String get hwTaskConversationDesc =>
      'Usa lo aprendido en una conversación real';

  @override
  String get hwConversationOnce =>
      'La conversación solo se puede hacer una vez por tarea.';

  @override
  String get hwTaskWorkbookDesc => 'Practica escribiendo en el cuaderno';

  @override
  String get hwCtaStudy => 'Empezar';

  @override
  String get hwCtaResult => 'Ver resultado';

  @override
  String get hwCtaDownload => 'Descargar';

  @override
  String get hwSpeakingNoScore =>
      'Todavía no has hecho la tarea de expresión oral';

  @override
  String get hwWorkbookUnavailable =>
      'El archivo del cuaderno aún no está disponible.';

  @override
  String get hwDetailClosed =>
      'Esta tarea está cerrada. Ya no puedes entregarla.';

  @override
  String get hwLeaveTitle => '¿Salir de la clase?';

  @override
  String get hwLeaveBody =>
      'Tu profesor dejará de ver los resultados de tus tareas.';

  @override
  String get hwLeaveConfirm => 'Salir';

  @override
  String get hwLeaveCancel => 'Quedarme';

  @override
  String get hwLeaveFailed => 'No se pudo salir de la clase.';

  @override
  String get hwMyClass => 'Mi clase';

  @override
  String get hwClassEmptyTitle => 'No te has unido a ninguna clase';

  @override
  String get hwClassEmptySubtitle =>
      'Introduce el código que te dio tu profesor';

  @override
  String get hwClassEmptyCta => 'Introducir código de clase';

  @override
  String get hwClassContinueCta => 'Continuar';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count tareas vencen mañana';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Tienes $count tareas sin entregar';
  }

  @override
  String get hwSpeakingUnavailable =>
      'Las frases de esta tarea aún no están disponibles.';

  @override
  String get hwBadgeClosed => 'Cerrada';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$passed de $total frases superadas';
  }

  @override
  String get challengeFirstWord => 'Primera palabra';

  @override
  String get challengeSeeAnalysis => 'Ver resultados';

  @override
  String get challengePaused => 'En pausa';

  @override
  String get challengePausedNote =>
      'El temporizador y la grabación se detuvieron.';

  @override
  String get challengeTimeLeft => 'Tiempo restante';

  @override
  String get challengeScoreLabel => 'Puntuación';

  @override
  String get challengeResume => 'Continuar';

  @override
  String get challengeBlockedTitle => 'No se puede usar la cámara';

  @override
  String get challengeBlockedNote =>
      'Activa el acceso a la cámara y al micrófono en Ajustes.';

  @override
  String get challengeGoBack => 'Volver';

  @override
  String get challengeOpenSettings => 'Abrir Ajustes';

  @override
  String get saveDone => 'Guardado en tu galería';

  @override
  String get saveFailed => 'No se pudo guardar';

  @override
  String get saveDeniedNote => 'Se necesita acceso a las fotos';

  @override
  String get callIncomingCallerFallback => 'Tutor Beaver';

  @override
  String get callIncomingHandle => 'Llamada en coreano';

  @override
  String get callMissedTitle => 'Llamada perdida';

  @override
  String get callMissedChannelDescription =>
      'Te avisa cuando pierdes una llamada de Beaver.';

  @override
  String callMissedBody(String name) {
    return '$name intentó llamarte';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Se necesita permiso de notificaciones para recibir llamadas.';

  @override
  String get callNotifPermissionRequired =>
      'Permite las notificaciones en Ajustes.';

  @override
  String get callHintLockedTitle =>
      'Las pistas no están disponibles en Estudio';

  @override
  String get wsTitle => 'Sonidos difíciles';

  @override
  String get wsToList => 'Volver a la lista';

  @override
  String get wsNext => 'Siguiente';

  @override
  String get wsRetry => 'Reintentar';

  @override
  String get wsDone => 'Listo';

  @override
  String get wsContinue => 'Seguir';

  @override
  String get wsQuit => 'Salir';

  @override
  String get wsRetryLater => 'Inténtalo de nuevo en un momento.';

  @override
  String get wsMissingTitle => 'No encontramos ese sonido';

  @override
  String get wsMissingBody => 'Vuelve a elegirlo en la lista.';

  @override
  String get wsListLoadFailed => 'No se pudo cargar la lista';

  @override
  String get wsLessonLoadFailed => 'No se pudo cargar la lección';

  @override
  String get wsNationalTitle => 'Sonidos difíciles para tu acento';

  @override
  String get wsNationalPending =>
      'Lo completaremos cuando analicemos tu acento';

  @override
  String get wsNationalPicked => 'Elegidos según tu análisis de acento';

  @override
  String get wsNationalEmptyBody =>
      'Haz algunas llamadas más y analizaremos tu acento.';

  @override
  String get wsMineTitle => 'Mis sonidos difíciles';

  @override
  String get wsMineSubtitle => 'Los sonidos con menor puntuación reciente';

  @override
  String get wsMineEmptyBody =>
      'Llama y repasa, y tus sonidos difíciles se irán acumulando.';

  @override
  String get wsNoDataYet => 'Aún no hay datos';

  @override
  String get wsGoToCall => 'Iniciar llamada';

  @override
  String get wsRule => 'Regla';

  @override
  String get wsRecommended => 'Recomendado';

  @override
  String get wsNotMeasured => 'Sin medir';

  @override
  String get wsStepUnderstand => 'Aprender';

  @override
  String get wsStepWords => 'Palabras';

  @override
  String get wsStepSentence => 'Frase';

  @override
  String get wsStepTest => 'Prueba';

  @override
  String get wsQuitTitle => '¿Dejar la práctica?';

  @override
  String get wsQuitBody => 'Si sales ahora, esta práctica no se guardará.';

  @override
  String get wsHowToSound => 'Cómo hacer el sonido';

  @override
  String get wsPracticeWords => 'Practicar palabras';

  @override
  String get wsPracticeSentence => 'Practicar la frase';

  @override
  String get wsPracticeAgain => 'Una vez más';

  @override
  String get wsStartTest => 'Hacer la prueba final';

  @override
  String get wsThisSentence => 'Esta frase';

  @override
  String get wsNoScoreNote =>
      'Este paso no se puntúa. Solo repite en voz alta.';

  @override
  String get wsListen => 'Escucha con atención';

  @override
  String get wsSayNow => 'Ahora repítelo';

  @override
  String get wsPracticeDone => 'Práctica completada';

  @override
  String get wsPaused => 'En pausa';

  @override
  String get wsAudioFailed =>
      'No se pudo cargar el audio. Lee el texto en voz alta.';

  @override
  String get wsReadAloud => 'Lee en voz alta la frase de abajo';

  @override
  String get wsTapToStart => 'Toca para empezar';

  @override
  String get wsTapWhenDone => 'Toca cuando termines';

  @override
  String get wsScoring => 'Puntuando';

  @override
  String get wsMicFailed => 'No se pudo abrir el micrófono.';

  @override
  String get wsMicPermissionBody =>
      'En esta prueba lees en voz alta, así que necesita el micrófono. Activa el acceso al micrófono en Ajustes.';

  @override
  String get wsNoSound => 'No oímos nada. ¿Lo intentas otra vez?';

  @override
  String get wsScoreFailed => 'No se pudo puntuar. Inténtalo de nuevo.';

  @override
  String get wsSomethingWrong => 'Algo salió mal.';

  @override
  String get wsLearnDone => 'Lección completada';

  @override
  String get wsRetest => 'Repetir prueba';

  @override
  String get wsFirstMeasure => 'Primera medición';

  @override
  String get wsFinalTest => 'Prueba final';

  @override
  String wsPoints(int score) {
    return '$score pts';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Antes $score pts';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Meta $score pts';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Meta · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return 'Acento de $country';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count palabras repetidas';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count fragmentos repetidos';
  }

  @override
  String get wsStartRecommended => 'Empezar con el sonido recomendado';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Empezar con $label';
  }

  @override
  String get wsPointsUnit => 'pts';

  @override
  String get wsEnterFromMypage => 'Practicar sonidos difíciles';

  @override
  String wsGoalOnly(int score) {
    return 'Meta $score';
  }

  @override
  String wsSoundOf(String label) {
    return 'Sonido $label';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Imagina esta forma cuando aparezca en una llamada.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return 'Sonidos que los hablantes de $country suelen pronunciar mal';
  }
}
