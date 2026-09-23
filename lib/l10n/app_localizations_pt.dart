// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginRequired => 'Você precisa entrar.';

  @override
  String get callWebNotSupported =>
      'Chamadas de voz não são suportadas na web. Use o app.';

  @override
  String get micPermissionRequiredForCall =>
      'É necessário acesso ao microfone. Permita o microfone para ligar.';

  @override
  String get callErrorGeneric => 'Ocorreu um erro durante a chamada.';

  @override
  String get callDailyLimit => 'Você já usou o tempo de estudo de hoje.';

  @override
  String get callAlreadyInCall => 'Você já está em uma chamada.';

  @override
  String get callNetworkError => 'Ocorreu um erro de rede.';

  @override
  String get authInvalidCredentials => 'E-mail ou senha incorretos.';

  @override
  String get authEmailAlreadyRegistered => 'Este e-mail já está cadastrado.';

  @override
  String get authConfirmEmailRequired =>
      'Conclua a verificação enviada para o seu e-mail.';

  @override
  String get authResetCodeSent =>
      'Enviamos um código de verificação para o seu e-mail.';

  @override
  String get authResetCodeInvalid => 'O código está incorreto ou expirou.';

  @override
  String get authPasswordUpdated => 'Sua senha foi redefinida.';

  @override
  String get authAppleTokenMissing =>
      'Não foi possível obter o token de login da Apple.';

  @override
  String callEndedDuration(String duration) {
    return 'Ligação encerrada em $duration';
  }

  @override
  String get callRatingPrompt => 'Como foi sua ligação?';

  @override
  String get callRatingBody =>
      'Sua avaliação nos ajuda a conversar melhor da próxima vez.';

  @override
  String get callRatingSubmit => 'Enviar';

  @override
  String get callRatingSkip => 'Pular';

  @override
  String get ratingBad => 'Não gostei';

  @override
  String get ratingOkay => 'Ok';

  @override
  String get ratingGood => 'Boa';

  @override
  String get goHome => 'Início';

  @override
  String get viewAnalysis => 'Ver análise';

  @override
  String get loadingShort => 'Carregando…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Não foi possível enviar sua avaliação: $message';
  }

  @override
  String get callInfoNotFound =>
      'Informações da ligação não encontradas; análise ignorada.';

  @override
  String get tabRecords => 'Registros';

  @override
  String get tabArchive => 'Arquivo';

  @override
  String get callHistory => 'Histórico de ligações';

  @override
  String get conversationRecord => 'Registro da conversa';

  @override
  String get noCallRecords => 'Nenhuma ligação registrada ainda';

  @override
  String get noCallRecordsBody =>
      'Assim que você concluir sua primeira ligação com a IA,\nseus registros aparecerão aqui.';

  @override
  String get startCall => 'Iniciar ligação';

  @override
  String get recordsLoadError => 'Não foi possível carregar os registros';

  @override
  String get tryAgainLater => 'Tente novamente mais tarde.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds seg';
  }

  @override
  String get scheduleManagement => 'Agenda';

  @override
  String get alarms => 'Alarmes';

  @override
  String get alarmAdd => 'Adicionar alarme';

  @override
  String get alarmEdit => 'Editar alarme';

  @override
  String get alarmEveryDay => 'Todos os dias';

  @override
  String get alarmWeekdays => 'Dias úteis';

  @override
  String get alarmWeekend => 'Fins de semana';

  @override
  String get alarmNoRepeat => 'Nunca';

  @override
  String get addSchedule => 'Adicionar horário';

  @override
  String get editSchedule => 'Editar horário';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get alarmsLoadError => 'Não foi possível carregar os alarmes';

  @override
  String get charactersLoadError => 'Não foi possível carregar os personagens';

  @override
  String get noCharacters => 'Nenhum personagem disponível';

  @override
  String get close => 'Fechar';

  @override
  String get repeat => 'Repetir';

  @override
  String get callPartner => 'Personagem';

  @override
  String get alarmModeLearnSub => 'Pratique expressões do currículo';

  @override
  String get alarmModeChatSub => 'Converse sobre qualquer coisa';

  @override
  String alarmRowSummary(String days, String mode) {
    return '$days, $mode';
  }

  @override
  String get quickStart => 'Início rápido';

  @override
  String get presetMorning => 'Rotina da manhã';

  @override
  String get presetMorningSub => 'Dias úteis 8:00';

  @override
  String get presetEvening => 'Fim de dia';

  @override
  String get presetEveningSub => 'Todos os dias 21:00';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get presetCustomSub => 'Do seu jeito';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× por semana · $monthly chamadas por mês';
  }

  @override
  String get alarmSummaryNone => 'Escolha pelo menos um dia';

  @override
  String get partnerInUse => 'Em uso';

  @override
  String get partnerOwned => 'Adquirido';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'Salvar';

  @override
  String get conversation => 'Conversa';

  @override
  String get newExpressions => 'Novas expressões';

  @override
  String get analysisPrepNote => 'Revendo a chamada de hoje.';

  @override
  String get analysisPrepNoteHint => 'Em breve uma mensagem vai aparecer aqui';

  @override
  String get analysisPrepTitle =>
      'O castor está transformando as expressões de hoje em cartões';

  @override
  String get analysisPrepSub => 'Vão aparecer aqui assim que ficarem prontos.';

  @override
  String get analysisPrepStepSave => 'Salvar a conversa';

  @override
  String get analysisPrepStepCards => 'Criar cartões de expressões';

  @override
  String get analysisPrepStateDone => 'Pronto';

  @override
  String get analysisPrepStateWorking => 'Em andamento';

  @override
  String get analysisPrepStateWaiting => 'Aguardando';

  @override
  String get usedExpressions => 'Expressões que você usou';

  @override
  String quizExpressionsCount(int count) {
    return 'Expressões que você aprendeu $count';
  }

  @override
  String get quizPassed => 'Acertou';

  @override
  String get quizFailed => 'Revise de novo';

  @override
  String get quizPending => 'Continue na próxima vez';

  @override
  String get analysisResult => 'Resultado da análise';

  @override
  String get noNewExpressions => 'Nenhuma expressão nova nesta conversa.';

  @override
  String get practice => 'Praticar';

  @override
  String get analysisNativeLabel => 'Nativo';

  @override
  String recentScore(int score) {
    return 'Pontuação recente $score%';
  }

  @override
  String callSequence(int count) {
    return 'Chamada n.º $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Uma palavra de $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Deixado por $name logo após a chamada';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Novas expressões $count';
  }

  @override
  String get analysisLoadError =>
      'Não foi possível carregar o resultado da análise.';

  @override
  String get standardAudioNotReady =>
      'O áudio da pronúncia padrão ainda não está pronto.';

  @override
  String get standardAudioPlayError =>
      'Não foi possível reproduzir o áudio da pronúncia padrão.';

  @override
  String get selectNativeLanguage => 'Selecione o seu idioma nativo';

  @override
  String get selectYourLanguage => 'Selecione seu idioma';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get selectTime => 'Selecionar horário';

  @override
  String get getStarted => 'Começar';

  @override
  String get permissionTitle =>
      'Permita os acessos\npara uma experiência tranquila';

  @override
  String get permissionSubtitle =>
      'As permissões necessárias são essenciais para usar o serviço.';

  @override
  String get permissionMicTitle => 'Microfone (obrigatório)';

  @override
  String get permissionMicDesc => 'Necessário para falar com a IA em inglês.';

  @override
  String get permissionNotifTitle => 'Notificações (opcional)';

  @override
  String get permissionNotifDesc =>
      'Enviaremos lembretes de estudo e horários de ligação.';

  @override
  String get micPermissionNeededTitle => 'Acesso ao microfone necessário';

  @override
  String get micPermissionNeededBody =>
      'Para falar com a IA, você precisa permitir o acesso ao microfone. Ative-o nas Configurações.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get connectionFailedTitle => 'Falha na conexão';

  @override
  String get connectionFailedBody =>
      'Verifique sua conexão de rede\ne tente novamente.';

  @override
  String get checkout => 'Finalizar compra';

  @override
  String get pay => 'Pagar';

  @override
  String get orderSummary => 'Resumo do pedido';

  @override
  String get paymentMethod => 'Forma de pagamento';

  @override
  String get payMethodCard => 'Cartão de crédito / débito';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Castor Irritante';

  @override
  String get productTrait => 'Personagem premium · Seu para sempre';

  @override
  String get amountItemPrice => 'Preço do item';

  @override
  String get amountDiscount => 'Desconto';

  @override
  String get amountTotal => 'Total';

  @override
  String get paymentCompleteTitle => 'Pagamento concluído';

  @override
  String get paymentCompleteBody => 'O avatar foi adicionado à sua coleção.';

  @override
  String get viewCollection => 'Ver coleção';

  @override
  String get receiptItem => 'Item';

  @override
  String get receiptAmount => 'Valor';

  @override
  String get receiptMethod => 'Forma de pagamento';

  @override
  String get receiptDate => 'Data';

  @override
  String get paymentFailedTitle => 'Falha no pagamento';

  @override
  String get paymentFailedBody =>
      'Não foi possível processar seu pagamento.\nTente novamente.';

  @override
  String get freeCallEndingTitle => 'Sua ligação gratuita está terminando';

  @override
  String get freeCallEndingBody =>
      'Assine para falar com o Castor por mais tempo.';

  @override
  String get subscribe => 'Assinar';

  @override
  String get endCall => 'Encerrar ligação';

  @override
  String get callEnded => 'A ligação foi encerrada.';

  @override
  String get connecting => 'Conectando…';

  @override
  String get connectingHint => 'Isso geralmente leva menos de 5 segundos';

  @override
  String get callConnectFailed => 'Não foi possível conectar a ligação.';

  @override
  String get saveSentenceFailed => 'Não foi possível salvar a frase.';

  @override
  String get recordStartFailed => 'Não foi possível iniciar a gravação.';

  @override
  String get recordTooShort =>
      'Essa gravação foi muito curta. Tente novamente.';

  @override
  String get gradingFailed => 'Falha ao pontuar. Tente novamente.';

  @override
  String get listenStandard => 'Ouvir pronúncia padrão';

  @override
  String get saveSentence => 'Salvar frase';

  @override
  String get unsaveSentence => 'Remover frase salva';

  @override
  String get scoringPronunciation => 'Avaliando sua pronúncia…';

  @override
  String get analyzingByWord => 'Verificando sua pronúncia palavra por palavra';

  @override
  String get analyzingTakingLonger => 'Isso está demorando um pouco mais';

  @override
  String get scanConnectionLost => 'Conexão perdida';

  @override
  String get noRecordingToPlay => 'Nenhuma gravação para reproduzir.';

  @override
  String get myRecordingPlayError =>
      'Não foi possível reproduzir sua gravação.';

  @override
  String get next => 'Próximo';

  @override
  String get endLearning => 'Encerrar sessão';

  @override
  String get navCalendar => 'Calendário';

  @override
  String get navCall => 'Ligação';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get homeCourseExpression => 'Expressões';

  @override
  String get homeCourseFreetalk => 'Conversa';

  @override
  String homeExpressionsLeft(int count) {
    return 'Faltam $count expressões para a conversa';
  }

  @override
  String get homeFreetalkNote => 'Use o que aprendeu e converse livremente';

  @override
  String get homeTalkTitle => 'O que aconteceu hoje?';

  @override
  String get homeTalkNote => 'Converse à vontade e aprenda no caminho.';

  @override
  String get homeModeLearn => 'Aprender';

  @override
  String get homeModeTalk => 'Conversar';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias seguidos',
      one: '1 dia seguido',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Calendário de estudo';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias seguidos',
      one: 'dia seguido',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recorde: $count dias',
      one: 'Recorde: $count dia',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Tempo de chamada';

  @override
  String get streakMetricLearned => 'Expressões';

  @override
  String get streakMetricWords => 'Palavras faladas';

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
  String get streakNoCallsThatDay => 'Nenhuma chamada neste dia.';

  @override
  String get homeLevelPending => 'Nível pendente';

  @override
  String get homeNoLevelTitle => 'Você ainda não tem um nível';

  @override
  String get homeNoLevelNote => 'Conclua sua primeira chamada para receber um';

  @override
  String get homeCurriculumPendingBadge => 'Em breve';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'O currículo de $language está a caminho';
  }

  @override
  String get homeCurriculumPendingNote =>
      'Nas chamadas, você vai praticar expressões gerais';

  @override
  String get myPage => 'Minha página';

  @override
  String get languageSaveFailed => 'Não foi possível salvar seu idioma.';

  @override
  String get accountDeleteFailed => 'Não foi possível excluir sua conta.';

  @override
  String get changeAvatar => 'Trocar avatar';

  @override
  String get avatarUseNow => 'Usar agora';

  @override
  String get avatarPurchaseFailed => 'A compra não foi concluída';

  @override
  String avatarPromoTitle(int percent) {
    return 'Só hoje · $percent% de desconto';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'Faltam $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'Faltam $days d $time';
  }

  @override
  String get avatarIntro =>
      'A voz e a dificuldade variam conforme o parceiro de ligação.\nAlguns parceiros podem exigir pagamento.';

  @override
  String myPartnersOwned(int count) {
    return 'Meus parceiros · $count adquiridos';
  }

  @override
  String get limitedDiscount => 'Desconto por tempo limitado';

  @override
  String get available => 'Disponível';

  @override
  String get inUse => 'Em uso';

  @override
  String get owned => 'Adquirido';

  @override
  String get noCharactersToShow => 'Nenhum personagem para mostrar';

  @override
  String get buy => 'Comprar';

  @override
  String get noSavedSentences =>
      'Nenhuma frase salva ainda.\nSalve frases a partir dos registros de suas conversas.';

  @override
  String get noAlarms => 'Nenhum alarme ainda';

  @override
  String get noAlarmsBody =>
      'Adicione um lembrete de estudo\npara criar um hábito consistente.';

  @override
  String get subscriptionManage => 'Gerenciar assinatura';

  @override
  String get cancelSubscription => 'Cancelar assinatura';

  @override
  String get benefitsInUse => 'Seus benefícios';

  @override
  String get paymentInfo => 'Informações de pagamento';

  @override
  String get nextBillingDate => 'Próxima data de cobrança';

  @override
  String get lostBenefitsTitle => 'Benefícios que você perderá ao cancelar';

  @override
  String get viewBillingHistory => 'Ver histórico de cobranças';

  @override
  String pricePerMonth(String price) {
    return '$price / mês';
  }

  @override
  String get benefitDetailedAnalysis =>
      'Análise detalhada de pronúncia e gramática';

  @override
  String get benefitAllCharacters => 'Acesso a todos os personagens';

  @override
  String get benefitNoAds => 'Sem anúncios';

  @override
  String get playSampleVoice => 'Ouvir amostra de voz';

  @override
  String get useThisAvatar => 'Usar este';

  @override
  String get challengeTitle => 'Desafio de Pronúncia';

  @override
  String get challengeIntro =>
      'Pronuncie corretamente em coreano cada carta na zona para eliminá-la.\nSem microfone? Você também pode jogar tocando na tela.';

  @override
  String get challengeStart => 'Ativar câmera e microfone';

  @override
  String get challengePermissionNote =>
      'É necessário acesso à câmera frontal e ao microfone (opcional).';

  @override
  String get challengeLoadingTitle => 'Carregando…';

  @override
  String get challengeLoadingNote => 'Preparando a câmera e o microfone.';

  @override
  String get challengeSttFallback =>
      'O reconhecimento de fala não estava disponível, então você jogou com toques na tela.';

  @override
  String get reasonTravelTitle => 'Falar durante viagens';

  @override
  String get reasonTravelDesc =>
      'Converse com confiança com os moradores locais';

  @override
  String get reasonCareerTitle => 'Trabalho e carreira';

  @override
  String get reasonCareerDesc => 'Conversas de negócios';

  @override
  String get reasonExamTitle => 'Preparação para provas';

  @override
  String get reasonExamDesc => 'Prepare-se para testes de fala';

  @override
  String get reasonDailyTitle => 'Conversas do dia a dia';

  @override
  String get reasonDailyDesc => 'Expressões que você usa todos os dias';

  @override
  String get reasonFriendsTitle => 'Fazer amigos estrangeiros';

  @override
  String get reasonFriendsDesc => 'Conversa natural';

  @override
  String get reasonBrainTitle => 'Estímulo cerebral';

  @override
  String get reasonBrainDesc => 'Melhore memória e foco';

  @override
  String get challengeRecordToggle => 'Gravar esta partida';

  @override
  String get challengeRecordHint =>
      'Salva um vídeo da sua jogatina para compartilhar (sem áudio).';

  @override
  String get settingsSection => 'Configurações';

  @override
  String get paymentSection => 'Pagamento';

  @override
  String get supportSection => 'Suporte';

  @override
  String get userLanguage => 'Idioma do usuário';

  @override
  String get learningLanguage => 'Idioma de aprendizado';

  @override
  String get learningLanguageKorean => 'Coreano';

  @override
  String get notificationLabel => 'Notificação';

  @override
  String get currentPlan => 'Plano atual';

  @override
  String get paymentHistory => 'Histórico de pagamentos';

  @override
  String get contactUs => 'Fale conosco';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get logOut => 'Sair';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountTitle => 'Excluir conta?';

  @override
  String get deleteAccountBody =>
      'Isso exclui permanentemente sua conta e seus dados e não pode ser desfeito.';

  @override
  String get delete => 'Excluir';

  @override
  String get share => 'Compartilhar';

  @override
  String get accentSoundsLike => 'Seu sotaque em coreano soa';

  @override
  String get hintLabel => 'Dica';

  @override
  String get nextHint => 'Próxima dica';

  @override
  String get translateLabel => 'Traduzir';

  @override
  String get startRecording => 'Iniciar gravação';

  @override
  String get stopRecording => 'Parar gravação';

  @override
  String get back => 'Voltar';

  @override
  String get onboardingNameTitle => 'Como devemos te chamar?';

  @override
  String get onboardingNameSubtitle =>
      'Seu tutor de IA vai lembrar do seu nome.';

  @override
  String get nameLabel => 'Seu nome';

  @override
  String get nameHint => 'Digite seu nome';

  @override
  String get nameHelper =>
      'Não precisa ser seu nome verdadeiro — um apelido também serve.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get onboardingDoneTitle => 'O Castor está esperando sua ligação';

  @override
  String get onboardingDoneSubtitle => 'Inicie uma ligação agora mesmo';

  @override
  String get home => 'Início';

  @override
  String get callNow => 'Ligar agora';

  @override
  String get pronunciation => 'Pronúncia';

  @override
  String get fluency => 'Fluência';

  @override
  String get rhythm => 'Ritmo';

  @override
  String get analysisFailed =>
      'Não conseguimos analisar a conversa. Tente novamente.';

  @override
  String get analyzingConversation => 'Analisando sua conversa…';

  @override
  String get analyzingSubtitle => 'Isso levará apenas um instante';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get nativeLabel => 'Nativo';

  @override
  String get meLabel => 'Eu';

  @override
  String get pronunciationPlayError =>
      'Não foi possível reproduzir o áudio da pronúncia.';

  @override
  String get savedExpressionsLoadError =>
      'Não foi possível carregar suas expressões salvas.';

  @override
  String get mySavedExpressions => 'Minhas expressões salvas';

  @override
  String get avatarTraits => 'Caloroso · Calmo · Suave';

  @override
  String get priceFree => 'Grátis';

  @override
  String get loginGoogleTokenError =>
      'Não foi possível obter um token de login do Google.';

  @override
  String get loginGoogleSignInFailed => 'Falha no login com o Google.';

  @override
  String get loginAppleSignInFailed => 'Falha no login com o Apple.';

  @override
  String get loginFacebookSignInFailed => 'Falha no login com o Facebook.';

  @override
  String get loginKakaoSignInFailed => 'Falha no login com o Kakao.';

  @override
  String get loginContinueWithKakao => 'Continuar com o Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuar com o Google';

  @override
  String get loginContinueWithFacebook => 'Continuar com o Facebook';

  @override
  String get loginContinueWithApple => 'Continuar com a Apple';

  @override
  String get loginContinueWithEmail => 'Continuar com e-mail';

  @override
  String get loginOrDivider => 'ou';

  @override
  String get loginNoAccount => 'Não tem uma conta?';

  @override
  String get signUp => 'Cadastre-se';

  @override
  String get loginTermsNoticePrefix =>
      'Ao continuar, você concorda com nossos ';

  @override
  String get loginTermsNoticeAnd => ' e ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Entrar';

  @override
  String get fieldEmailLabel => 'E-mail';

  @override
  String get emailHint => 'Digite seu e-mail';

  @override
  String get fieldPasswordLabel => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get loginRememberMe => 'Lembrar de mim';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String get loginLoggingIn => 'Entrando...';

  @override
  String get passwordLengthError => 'A senha deve ter de 8 a 16 caracteres.';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem.';

  @override
  String get signupCheckInput => 'Verifique os dados informados.';

  @override
  String get fieldConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get confirmPasswordHint => 'Digite sua senha novamente';

  @override
  String get signupSigningUp => 'Cadastrando...';

  @override
  String get signupHaveAccount => 'Já tem uma conta?';

  @override
  String get passwordMethodEmailRequired => 'Digite seu e-mail';

  @override
  String get passwordResetTitle => 'Redefinir senha';

  @override
  String get passwordMethodDescription =>
      'Digite o endereço de e-mail onde deseja receber o código de redefinição de senha.';

  @override
  String get emailAddressHint => 'Endereço de e-mail';

  @override
  String get passwordMethodSending => 'Enviando...';

  @override
  String get passwordMethodSendEmail => 'Enviar e-mail';

  @override
  String get passwordCodeTitle => 'Digite o código';

  @override
  String get passwordCodeDescription =>
      'Enviamos um código de recuperação para seu e-mail. Digite-o para continuar.';

  @override
  String get passwordCodeNoCode => 'Não recebeu o código?';

  @override
  String get passwordCodeResend => 'Reenviar código';

  @override
  String get passwordCodeVerifying => 'Verificando...';

  @override
  String get passwordNewTitle => 'Nova senha';

  @override
  String get passwordNewDescription => 'Defina uma nova senha para sua conta.';

  @override
  String get fieldNewPasswordLabel => 'Nova senha';

  @override
  String get newPasswordHint => 'Digite sua nova senha';

  @override
  String get fieldConfirmNewPasswordLabel => 'Confirmar nova senha';

  @override
  String get confirmNewPasswordHint => 'Digite sua nova senha novamente';

  @override
  String get passwordNewSubmitting => 'Enviando...';

  @override
  String get passwordNewSubmit => 'Enviar';

  @override
  String get passwordCompleteTitle => 'Senha redefinida com sucesso';

  @override
  String get passwordCompleteBody =>
      'Sua senha foi redefinida. Faça login com sua nova senha para continuar.';

  @override
  String get termsTitle => 'Termos de serviço';

  @override
  String get privacyTitle => 'Política de privacidade';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Defina uma nova senha para $email.';
  }

  @override
  String get selectComplete => 'Concluído';

  @override
  String get onboardingLanguageTitle => 'Qual é o seu idioma nativo?';

  @override
  String get onboardingReasonTitle => 'Por que você está aprendendo um idioma?';

  @override
  String get onboardingReasonSubtitle =>
      'Vamos adaptar seu aprendizado aos seus objetivos.';

  @override
  String get savingLabel => 'Salvando...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Pagamento deste mês';

  @override
  String get filterAll => 'Tudo';

  @override
  String get filterSubscription => 'Assinatura';

  @override
  String get filterCharacter => 'Personagem';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get lastPayment => 'Último pagamento';

  @override
  String get freePlanCallLimit => '5 min de chamadas por dia';

  @override
  String get freePlanBasicCharacters => 'Personagens básicos incluídos';

  @override
  String get availableForPurchase => 'Disponível para compra';

  @override
  String get paymentsLoadError =>
      'Não foi possível carregar o histórico de pagamentos';

  @override
  String get noPayments => 'Ainda não há pagamentos';

  @override
  String get morePaymentsExist =>
      'Pagamentos anteriores ainda não são exibidos';

  @override
  String get undatedPayments => 'Sem data';

  @override
  String get paymentLabelFallback => 'Pagamento';

  @override
  String learningPassed(int passed, int total) {
    return '$passed de $total frases aprovadas';
  }

  @override
  String get hardestSound => 'Som mais difícil de hoje';

  @override
  String get soundAccuracy => 'Precisão por som';

  @override
  String phonemeAttempts(int count) {
    return 'Por fonema · $count tentativas';
  }

  @override
  String get colSound => 'Som';

  @override
  String get colAttempts => 'Tent.';

  @override
  String get colCorrect => 'Cert.';

  @override
  String get colAccuracy => 'Prec.';

  @override
  String get sentenceResults => 'Resultados por frase';

  @override
  String viewAllSentences(int count) {
    return 'Ver todas as $count';
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
    return 'Últimas $count sessões';
  }

  @override
  String trendAverage(int score) {
    return 'Méd. $score';
  }

  @override
  String get today => 'Hoje';

  @override
  String get colDate => 'Data';

  @override
  String get colSentences => 'Frases';

  @override
  String get colScore => 'Pont.';

  @override
  String get colChange => 'Var.';

  @override
  String dateToday(String date) {
    return '$date (hoje)';
  }

  @override
  String get accentAnalysis => 'Análise de sotaque';

  @override
  String get overallLevel => 'Nível geral';

  @override
  String get overallLevelSubtitle => 'Vocabulário · Gramática · Expressões';

  @override
  String get pronunciationAnalysis => 'Análise de pronúncia';

  @override
  String get recentSessionsAverage => 'Média das 10 sessões';

  @override
  String levelStage(int stage) {
    return 'Nível $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Entre todos os alunos';

  @override
  String aheadOfLearners(int percent) {
    return 'Você está à frente de $percent% dos alunos';
  }

  @override
  String get retakeLevelTest => 'Refazer teste de nível';

  @override
  String get practicePronunciation => 'Praticar pronúncia';

  @override
  String get priceChangedTitle => 'O preço mudou';

  @override
  String priceChangedBody(String price) {
    return 'Este item agora custa $price. Deseja continuar?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plano e compras';

  @override
  String get billingGroupInTheStore => 'Na loja';

  @override
  String get billingCompareAllPlans => 'Comparar planos';

  @override
  String get billingBuyACharacter => 'Comprar um personagem';

  @override
  String get billingRestorePurchases => 'Restaurar compras';

  @override
  String get billingRedeemCode => 'Resgatar um código';

  @override
  String get billingPaymentHistory => 'Histórico de pagamentos';

  @override
  String get billingManageInTheStore => 'Gerenciar na loja';

  @override
  String get billingRefundHelp => 'Ajuda com reembolsos';

  @override
  String get billingCancelSubscription => 'Cancelar assinatura';

  @override
  String get billingResubscribe => 'Assinar novamente';

  @override
  String get badgeCurrent => 'Atual';

  @override
  String get badgeTrial => 'Teste';

  @override
  String get badgeRenewing => 'Renovando';

  @override
  String get badgePastDue => 'Pagamento atrasado';

  @override
  String get badgePaused => 'Pausado';

  @override
  String get badgeCanceling => 'Encerrando';

  @override
  String get subscriptionTitle => 'Assinatura';

  @override
  String get plansTitle => 'Planos';

  @override
  String get planFree => 'Grátis';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => '15 minutos de videochamadas por dia';

  @override
  String get premiumBulletAnalysis => 'Análise completa da pronúncia';

  @override
  String get premiumBulletWeakSounds =>
      'Treino de sons difíceis para o seu idioma';

  @override
  String get noteCharactersSeparate =>
      'Os personagens são vendidos à parte. Os que você compra são seus.';

  @override
  String get ctaGetPremium => 'Assinar Premium';

  @override
  String get planMaxTrial => 'Teste do Premium';

  @override
  String get freePlanPriceLine => '\$0.00 — 5 minutos de ligação por dia';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount por mês';
  }

  @override
  String freeUntilDate(String date) {
    return 'Grátis até $date';
  }

  @override
  String get todaysCalls => 'Tempo de ligação de hoje';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used de $limit min usados';
  }

  @override
  String get firstPaymentLabel => 'Primeiro pagamento';

  @override
  String get nextPaymentLabel => 'Próximo pagamento';

  @override
  String get retryingUntilLabel => 'Tentando novamente até';

  @override
  String get pausedSinceLabel => 'Pausado desde';

  @override
  String planEndsLabel(String plan) {
    return '$plan termina';
  }

  @override
  String get bannerMaxUpsellTitle => 'Converse cara a cara com o Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Videochamadas · 15 minutos por dia · $price por mês';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Mude para o anual';

  @override
  String get bannerPaymentFailedTitle =>
      'Não conseguimos processar o pagamento';

  @override
  String get bannerPaymentFailedSub =>
      'Atualize o pagamento na loja para manter o Premium';

  @override
  String get bannerPausedTitle => 'Seu plano está pausado';

  @override
  String get bannerPausedSub => 'O pagamento não foi concluído';

  @override
  String get noteRestoreHint =>
      'Já assina em outro dispositivo? Restaurar traz a assinatura para este.';

  @override
  String get noteStoreHandled =>
      'Forma de pagamento, mudanças de plano e cancelamento são gerenciados pela loja.';

  @override
  String noteTrialEnds(String date) {
    return 'Seu teste termina em $date. Cancele na loja antes disso e nada será cobrado.';
  }

  @override
  String get noteGrace =>
      'Seus benefícios continuam ativos durante o período de carência. O cancelamento nunca é bloqueado no app.';

  @override
  String get noteHold =>
      'O Premium fica pausado até o pagamento ser concluído. Seus personagens e seu progresso estão seguros.';

  @override
  String noteEnding(String date) {
    return 'Seu plano vai terminar. Os benefícios continuam até $date, depois você passa para o Grátis. Você pode assinar de novo quando quiser.';
  }

  @override
  String get trialExpiredTitle => 'Seu teste do Premium terminou';

  @override
  String get trialExpiredSub => 'Agora você está no Grátis';

  @override
  String get seePlans => 'Ver planos';

  @override
  String get currentPlanTitle => 'Plano atual';

  @override
  String get perMonthUnit => 'por mês';

  @override
  String get planTaglineMax => 'Agora você pode vê-los.';

  @override
  String get planTaglineFree =>
      '5 minutos de ligação por dia. Por nossa conta.';

  @override
  String get bulletProCorrections =>
      'Correções voltadas para o seu idioma nativo';

  @override
  String get bulletFreeCall => '5 minutos de ligação de voz por dia';

  @override
  String get bulletFreeCheck =>
      'Análise completa nas suas 3 primeiras chamadas';

  @override
  String get bulletFreeCharacter => 'Dois personagens para começar';

  @override
  String get ctaTurnOnVideo => 'Ativar o vídeo';

  @override
  String get noteCallLength =>
      'Premium: 15 minutos por dia — dentro desse tempo, ligue quantas vezes quiser.';

  @override
  String get paywallProTitle1 => 'Seu amigo coreano';

  @override
  String get paywallProTitle2 => 'que está acordado às 3 da manhã';

  @override
  String get paywallLimitHeadline =>
      'O Premium dá 15 minutos de chamadas por dia.';

  @override
  String get limitBannerCallTitle => 'Acabou o tempo de ligação de hoje';

  @override
  String get limitBannerCallSub => 'O Grátis dá 5 minutos de ligação por dia';

  @override
  String get limitBannerCheckTitle => 'Essa foi a verificação de hoje';

  @override
  String get limitBannerCheckSub => 'O Grátis dá uma verificação por dia';

  @override
  String get bulletProCharactersForever =>
      'Personagens comprados são seus para sempre';

  @override
  String get paywallMaxTitle => 'Agora você pode vê-los.';

  @override
  String paywallTutorCompare(String price) {
    return 'Uma hora com um tutor custa \$25. Um mês de Premium custa $price.';
  }

  @override
  String get planMonthly => 'Mensal';

  @override
  String get planAnnual => 'Anual';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price por mês';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth por mês';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price por mês';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly por ano · $perMonth por mês';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price por mês · cancele quando quiser na loja';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price por mês · cancele quando quiser na loja';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 dias grátis, depois $price por mês · cancele quando quiser na loja';
  }

  @override
  String get ctaCaptionAutoRenew => 'Renova automaticamente até você cancelar.';

  @override
  String get footerTerms => 'Termos';

  @override
  String get footerPrivacy => 'Privacidade';

  @override
  String get processingTitle => 'Confirmando sua compra';

  @override
  String get processingSub => 'Isso costuma levar alguns segundos.';

  @override
  String get successProTitle => 'Você está no Premium.';

  @override
  String get successMaxTitle => 'Agora você pode vê-los.';

  @override
  String get successMaxSub =>
      'As videochamadas estão ativas. Toque no botão de vídeo em qualquer ligação.';

  @override
  String get ctaStartAVideoCall => 'Iniciar uma videochamada';

  @override
  String get ctaSeeYourSubscription => 'Ver sua assinatura';

  @override
  String successMaxCaption(String price) {
    return '$price são cobrados por mês até você cancelar. Gerencie ou cancele quando quiser na loja.';
  }

  @override
  String get plansErrorTitle => 'Não foi possível carregar os planos';

  @override
  String get plansErrorSub => 'A loja não respondeu.';

  @override
  String get ctaTryAgain => 'Tentar novamente';

  @override
  String get plansErrorCaption => 'Nada foi cobrado.';

  @override
  String get ctaKeepMax => 'Manter o Premium';

  @override
  String get winbackSkip => 'Pular';

  @override
  String get winbackTitle => 'Seu plano Premium terminou';

  @override
  String get winbackSub =>
      'Agora você está no Grátis — 5 minutos de ligação por dia.';

  @override
  String get winbackQuestion => 'Quer nos contar por que você saiu?';

  @override
  String get winbackReasonExpensive => 'Muito caro';

  @override
  String get winbackReasonUnused => 'Eu não estava usando o suficiente';

  @override
  String get winbackReasonMissing => 'Faltava um recurso de que eu precisava';

  @override
  String get winbackReasonOtherApp => 'Encontrei outro app';

  @override
  String get winbackReasonElse => 'Outro motivo';

  @override
  String get ctaSend => 'Enviar';

  @override
  String get ctaNotNow => 'Agora não';

  @override
  String get winbackCaption =>
      'Isso não restaura seu plano. Assine de novo na loja.';

  @override
  String get ctaContinue => 'Continuar';

  @override
  String get ctaClose => 'Fechar';

  @override
  String get ovRestoreSuccessTitle => 'O Premium voltou';

  @override
  String get ovRestoreSuccessBody =>
      'Encontramos sua assinatura e a reativamos neste dispositivo.';

  @override
  String get ovRestoreEmptyTitle => 'Nada para restaurar';

  @override
  String get ovRestoreEmptyBody =>
      'Nenhuma assinatura ativa está vinculada a esta conta da loja.';

  @override
  String get ovRestoreOtherTitle => 'Esse plano pertence a outra conta';

  @override
  String get ovRestoreOtherBody =>
      'Esta assinatura já está ativa em outra conta do BeaverTalk.';

  @override
  String get ctaSignInThatAccount => 'Entrar nessa conta';

  @override
  String get ctaGetHelp => 'Obter ajuda';

  @override
  String get ovCharacterOfferTitle => 'Ainda não está pronto para o Premium?';

  @override
  String get ovCharacterOfferBody =>
      'Escolha um personagem e fique com ele. Uma compra única — sem assinatura, sem renovação.';

  @override
  String get rowOneCharacter => 'Um personagem';

  @override
  String rowFromPrice(String price) {
    return '$price cada';
  }

  @override
  String get rowYoursForever => 'Seu para sempre';

  @override
  String get rowNoRenewal => 'Sem renovação';

  @override
  String get rowWorksOnFree => 'Funciona no Grátis';

  @override
  String get rowYes => 'Sim';

  @override
  String get ctaSeeCharacters => 'Ver personagens';

  @override
  String get ovNotEligibleTitle => 'Nada para cancelar';

  @override
  String get ovNotEligibleBody =>
      'Você está no Grátis. Não há assinatura ativa nesta conta.';

  @override
  String get ovCancelDownsellTitle => 'Antes de você ir';

  @override
  String get ovCancelDownsellBody =>
      'O cancelamento é feito na loja. Duas coisas que vale a pena saber.';

  @override
  String get rowPayYearlyInstead => 'Pague uma vez por ano';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price por mês';
  }

  @override
  String get rowCharactersYouBought => 'Personagens comprados';

  @override
  String get rowProRunsUntil => 'O Premium continua até';

  @override
  String get ctaSwitchToYearly => 'Mudar para o anual';

  @override
  String get ctaContinueToStore => 'Continuar para a loja';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Pague por ano e economize $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'O plano anual sai mais barato do que pagar todo mês.';

  @override
  String get rowYouSave => 'Você economiza';

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
  String get rowMonthlyForYear => 'Mensal, por um ano';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Mudar para o mensal';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Seu plano anual vai até $date. A cobrança mensal começa no dia seguinte.';
  }

  @override
  String get rowMonthlyBillingStarts => 'A cobrança mensal começa';

  @override
  String get rowMonthlyLabel => 'Mensal';

  @override
  String get rowYearlyWorkedOut => 'O anual saía por';

  @override
  String get ctaSwitchToMonthly => 'Mudar para o mensal';

  @override
  String get ovRefundHelpTitle => 'Os reembolsos são gerenciados pela loja';

  @override
  String get ovRefundHelpBody =>
      'Não podemos emitir reembolsos por conta própria. Cada solicitação é analisada pela loja.';

  @override
  String get ctaGoToStore => 'Ir para a loja';

  @override
  String get ovTrialEndingTitle => 'Seu teste termina amanhã';

  @override
  String get ovTrialEndingBody =>
      'O Premium continua a menos que você cancele. Veja o que acontece.';

  @override
  String get rowTrialEnds => 'O teste termina';

  @override
  String get rowFirstCharge => 'Primeira cobrança';

  @override
  String get rowThenMonthly => 'Depois, mensal';

  @override
  String get ctaCancelInStore => 'Cancelar na loja';

  @override
  String get ovTrialStartTitle => '7 dias de Premium, grátis';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Grátis até $date. Depois, $price por mês, a menos que você cancele na loja.';
  }

  @override
  String get ctaStart7Days => 'Começar 7 dias grátis';

  @override
  String get ovOtoTitle => 'Só mais uma coisa antes de começar';

  @override
  String get ovOtoBody =>
      'Boa escolha. O mesmo Premium custa menos se você pagar por ano.';

  @override
  String get ovFailedDeclinedTitle => 'Seu cartão foi recusado';

  @override
  String get ovFailedDeclinedBody =>
      'A loja não conseguiu processar o pagamento. Nada foi cobrado.';

  @override
  String get ctaUpdatePaymentMethod => 'Atualizar forma de pagamento';

  @override
  String get ovFailedCanceledTitle => 'Pagamento cancelado';

  @override
  String get ovFailedCanceledBody =>
      'Você continua no Grátis. Nada foi cobrado.';

  @override
  String get ovFailedStoreTitle => 'Algo deu errado';

  @override
  String get ovFailedStoreBody =>
      'Não conseguimos acessar a loja. Nada foi cobrado.';

  @override
  String get ovAlreadyTitle => 'Você já está no Premium';

  @override
  String get ovAlreadyBody =>
      'Esta conta da loja já tem um plano ativo. Não há nada para comprar.';

  @override
  String get ctaSeeMySubscription => 'Ver minha assinatura';

  @override
  String get subCancelTitle => 'Cancelar assinatura';

  @override
  String subCancelBody(String date) {
    return 'O Premium continua até $date. Depois disso, você passa para o Grátis.';
  }

  @override
  String get subWhatYouLose => 'O que você perde';

  @override
  String get benefitScoring => 'Pronúncia avaliada letra por letra';

  @override
  String get benefitEveryMetric => 'Cada métrica, cada frase';

  @override
  String get subPaymentTitle => 'Atualizar pagamento';

  @override
  String get subPaymentBody =>
      'Não conseguimos processar o pagamento. O Premium continua ativo durante o período de carência.';

  @override
  String get subHowToFix => 'Como resolver';

  @override
  String get fixStep1 => 'Abra a loja e atualize sua forma de pagamento';

  @override
  String get fixStep2 => 'Volte — seu plano é retomado automaticamente';

  @override
  String get fixStep3 => 'Nada é cobrado duas vezes';

  @override
  String get subResubTitle => 'Assinar novamente';

  @override
  String subResubBody(String date) {
    return 'O Premium termina em $date. Reative a renovação automática e nada muda.';
  }

  @override
  String get subWhatYouKeep => 'O que você mantém';

  @override
  String get ctaTurnItBackOn => 'Reativar';

  @override
  String get flTodayTitle => 'Acabou o tempo de ligação de hoje';

  @override
  String get flTodayBody => 'Continue de onde parou — agora mesmo.';

  @override
  String get flCheckTitle => 'Essa foi a verificação de hoje';

  @override
  String get flCheckBody =>
      'O Grátis inclui uma verificação por dia. O Premium mostra a análise completa.';

  @override
  String flCaption(String price) {
    return '$price por mês · cancele quando quiser';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used de $limit usados';
  }

  @override
  String get ctaMaybeTomorrow => 'Talvez amanhã';

  @override
  String get accountSection => 'Conta';

  @override
  String get nicknameLabel => 'Apelido';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get loginMethodLabel => 'Método de login';

  @override
  String get joinedLabel => 'Cadastro';

  @override
  String get editNicknameTitle => 'Editar apelido';

  @override
  String get nicknameRule =>
      '2–12 caracteres. Letras e números. Somente inglês';

  @override
  String get ctaSave => 'Salvar';

  @override
  String get subscriptionRow => 'Assinatura';

  @override
  String get iapSuccessTitle => 'Compra concluída';

  @override
  String iapSuccessBody(String name) {
    return 'O avatar $name é seu para sempre.\nAplicado assim que o recibo for confirmado.';
  }

  @override
  String get ctaGoHome => 'Ir para o início';

  @override
  String get ctaUseNow => 'Usar agora';

  @override
  String get iapFailTitle => 'O pagamento não foi concluído';

  @override
  String get iapFailBody => 'Você pode tentar de novo';

  @override
  String get paywallLeaveTitle => 'Se sair agora, você não estará assinando';

  @override
  String get paywallLeaveBody =>
      'Seus benefícios são liberados logo após o pagamento. Você pode voltar quando quiser pela Minha página.';

  @override
  String get ctaKeepLooking => 'Continuar vendo';

  @override
  String get ctaLeaveAnyway => 'Sair mesmo assim';

  @override
  String get iapCharacterSuccessTitle => 'Um novo amigo se juntou a você!';

  @override
  String get iapCharacterSuccessBody =>
      'Este personagem é seu para sempre — permanece mesmo se o plano mudar, e Restaurar compras o traz de volta em qualquer aparelho.';

  @override
  String get iapCharacterFailedBody =>
      'A compra não foi concluída. Nada foi cobrado — tente novamente.';

  @override
  String get noAccentDataTitle => 'Ainda sem dados de entonação';

  @override
  String get noAccentDataBody =>
      'Continue conversando e as características da sua entonação vão se acumular.';

  @override
  String get noLevelYetTitle => 'Ainda sem nível';

  @override
  String get noLevelYetBody =>
      'Conclua sua primeira chamada para obter seu nível.';

  @override
  String get noPronunciationDataTitle => 'Ainda sem registros de pronúncia';

  @override
  String get noPronunciationDataBody =>
      'Analisamos sua pronúncia a partir das frases que você diz nas chamadas.';

  @override
  String get noCharacterNote => 'Ainda nada foi dito';

  @override
  String get noPhonemesYet => 'Ainda não há sons para analisar';

  @override
  String get noSentencesYet => 'Ainda não há frases para analisar';

  @override
  String get takeLevelTest => 'Fazer teste de nível';

  @override
  String get reviewToSeeScore => 'Revise para ver sua pontuação de pronúncia';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get difficultySlow => 'Lento';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Rápido';

  @override
  String get difficultyLabel => 'Dificuldade';

  @override
  String get connected => 'Conectado';

  @override
  String get unlockedWithMax => 'Incluído no seu plano';

  @override
  String get fcEndedTitle => 'A sua chamada gratuita terminou';

  @override
  String get fcEndedBody =>
      'As chamadas gratuitas duram até 5 minutos\nAssine para continuar a conversar por mais tempo';

  @override
  String get ctaSubscribeKeepTalking => 'Assinar e continuar a conversar';

  @override
  String get kgTitle => 'Continuar?';

  @override
  String get kgBody =>
      'As chamadas continuam em trechos curtos.\nVamos perguntar de novo a cada vez.';

  @override
  String get pcEndedTitleToday => 'Vamos encerrar a chamada de hoje.';

  @override
  String get pcEndedBodyToday =>
      'Revise o que conversamos e me ligue de novo amanhã!';

  @override
  String get pcEndedTitle => 'Vamos encerrar esta chamada.';

  @override
  String get pcEndedBody => 'Revise o que conversamos e me ligue de novo!';

  @override
  String get ctaKeepTalking => 'Continuar a conversar';

  @override
  String get callModeSheetTitle => 'Como você quer conversar?';

  @override
  String get callModeSheetSubtitle => 'Aplica-se a esta chamada imediatamente';

  @override
  String get callModeFreeTalk => 'Conversa livre';

  @override
  String get callModeFreeTalkDesc => 'Fale sem correções';

  @override
  String get callModeStudy => 'Estudo';

  @override
  String get callModeStudyDesc => 'Aprenda uma expressão de cada vez';

  @override
  String get callModeChange => 'Mudar modo';

  @override
  String get callModeKeep => 'Agora não';

  @override
  String get callExitTitle => 'Encerrar esta chamada?';

  @override
  String get callExitSubtitle =>
      'O tempo que você já falou conta para hoje mesmo assim';

  @override
  String get callExitKeep => 'Continuar falando';

  @override
  String get callExitConfirm => 'Encerrar chamada';

  @override
  String get callMicMute => 'Silenciar';

  @override
  String get callMicUnmute => 'Reativar microfone';

  @override
  String get callPushToTalk => 'Segure para falar';

  @override
  String get callFreeEndedTitle => 'Sua chamada gratuita terminou';

  @override
  String get callFreeEndedCta => 'Assine e continue conversando';

  @override
  String get callKeepGoingTitle => 'Vamos continuar?';

  @override
  String get callKeepGoingSubtitle =>
      'As chamadas seguem em blocos de 5 minutos. Vamos perguntar a cada vez.';

  @override
  String get articulationSelectedWord => 'Palavra selecionada';

  @override
  String get articulationYouSaid => 'Sua pronúncia';

  @override
  String get articulationTargetSound => 'Alvo';

  @override
  String get reportEntry => 'Denunciar';

  @override
  String get reportTitle => 'Denunciar';

  @override
  String get reportPrompt => 'Qual foi o problema?';

  @override
  String get reportGuide =>
      'Conte qual conteúdo do personagem de IA deixou você desconfortável. Analisamos todas as denúncias.';

  @override
  String get reportReasonSexual => 'Conteúdo sexual';

  @override
  String get reportReasonHate => 'Ódio ou discriminação';

  @override
  String get reportReasonViolence => 'Conteúdo violento ou ameaçador';

  @override
  String get reportReasonSelfHarm => 'Incentiva a automutilação';

  @override
  String get reportReasonMisinfo => 'Informação falsa';

  @override
  String get reportReasonOther => 'Outro problema';

  @override
  String get reportDetailHint => 'Descreva o que aconteceu (opcional)';

  @override
  String get reportSubmit => 'Enviar denúncia';

  @override
  String get reportDoneTitle => 'Sua denúncia foi recebida';

  @override
  String get reportDoneBody =>
      'Vamos analisar e tomar as medidas necessárias. Obrigado por ajudar a manter o BeaverTalk seguro.';

  @override
  String get reportFailed =>
      'Não foi possível enviar a denúncia. Tente novamente.';

  @override
  String get hwTitle => 'Tarefas';

  @override
  String get hwJoinCodeTitle => 'Digite o código da sua turma';

  @override
  String get hwJoinCodeSubtitle =>
      'É o código de 6 dígitos que seu professor deu';

  @override
  String get hwJoinCodeLabel => 'Código da turma';

  @override
  String get hwJoinCodeHelp =>
      'O código não diferencia maiúsculas de minúsculas';

  @override
  String get hwJoinConfirmTitle => 'É esta a turma certa?';

  @override
  String get hwJoinConfirmSubtitle => 'Se não for, confira o código de novo';

  @override
  String get hwJoinFieldInstitution => 'Instituição';

  @override
  String get hwJoinFieldTeacher => 'Professor';

  @override
  String get hwJoinFieldLearners => 'Alunos';

  @override
  String get hwJoinFieldTerm => 'Período';

  @override
  String get hwJoinConfirmNote =>
      'O nome da turma aparece exatamente como o professor escreveu. Não traduzimos.';

  @override
  String get hwJoinConfirmYes => 'Sim, é esta';

  @override
  String get hwJoinConfirmRetry => 'Digitar o código de novo';

  @override
  String get hwJoinProfileTitle => 'Que nome você vai usar na turma?';

  @override
  String get hwJoinProfileSubtitle =>
      'Seu professor compara com a lista da turma';

  @override
  String get hwJoinNameLabel => 'Nome';

  @override
  String get hwJoinNameHelp => 'Pode ser diferente do nome no app';

  @override
  String get hwJoinStudentNoLabel => 'Matrícula (opcional)';

  @override
  String get hwJoinStudentNoHelp => 'Seu professor usa para conferir a lista';

  @override
  String get hwJoinConsentTitle => 'O que seu professor vê';

  @override
  String get hwJoinConsentSubtitle =>
      'Você precisa concordar para entrar na turma';

  @override
  String get hwJoinConsentSharedHeading => 'Compartilhado com seu professor';

  @override
  String get hwJoinConsentShared1 => 'Nome da turma e matrícula';

  @override
  String get hwJoinConsentShared2 => 'Se você fez a tarefa';

  @override
  String get hwJoinConsentShared3 => 'Frases aprovadas e erradas';

  @override
  String get hwJoinConsentShared4 => 'Duração e resumo da chamada da tarefa';

  @override
  String get hwJoinConsentNotSharedHeading => 'Não compartilhado';

  @override
  String get hwJoinConsentNotShared1 => 'E-mail e telefone';

  @override
  String get hwJoinConsentNotShared2 => 'Nome no app, perfil e personagem';

  @override
  String get hwJoinConsentNotShared3 => 'Nacionalidade e língua materna';

  @override
  String get hwJoinConsentNotShared4 => 'Chamadas e estudo fora da turma';

  @override
  String get hwJoinConsentNotShared5 => 'Dados de assinatura e pagamento';

  @override
  String get hwJoinConsentAgree => 'Concordo com o acima';

  @override
  String get hwJoinConsentCta => 'Concordar e entrar';

  @override
  String hwJoinDoneTitle(String className) {
    return 'Você entrou em $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count tarefas estão esperando';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Ainda não há tarefas';

  @override
  String get hwJoinDoneNextDue => 'Próximo prazo';

  @override
  String get hwJoinDoneRosterName => 'Seu nome na turma';

  @override
  String get hwJoinDoneCta => 'Ver tarefas';

  @override
  String get hwJoinErrorNotFound => 'Não encontramos esse código';

  @override
  String get hwJoinErrorNotFoundBody => 'Confira os seis dígitos novamente.';

  @override
  String get hwJoinErrorExpired => 'Esse código expirou';

  @override
  String get hwJoinErrorExpiredBody => 'Peça um código novo ao seu professor.';

  @override
  String get hwJoinErrorFull => 'A turma está cheia';

  @override
  String get hwJoinErrorFullBody => 'Avise seu professor.';

  @override
  String get hwJoinFailed =>
      'Não foi possível entrar. Tente de novo em instantes.';

  @override
  String get hwSectionInProgress => 'Em andamento';

  @override
  String get hwSectionUpcoming => 'A seguir';

  @override
  String get hwSectionDone => 'Concluídas';

  @override
  String get hwLeaveClassLink => 'Sair da turma';

  @override
  String get hwListEmptyTitle => 'Ainda não há tarefas';

  @override
  String get hwListEmptyBody =>
      'Vão aparecer aqui quando seu professor passar.';

  @override
  String get hwListFailed => 'Não foi possível carregar suas tarefas.';

  @override
  String get hwRetry => 'Tentar de novo';

  @override
  String get hwBadgeDone => 'Concluída';

  @override
  String get hwBadgeOverdue => 'Não entregue';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Não entregue, $days d de atraso';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Vence hoje';

  @override
  String get hwActivitySpeaking => 'Fala';

  @override
  String get hwActivityConversation => 'Conversa';

  @override
  String get hwActivityWorkbook => 'Caderno';

  @override
  String hwChapterLabel(String chapter) {
    return 'Capítulo $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Confira sua nota de pronúncia';

  @override
  String get hwTaskConversationDesc => 'Use o que aprendeu numa conversa real';

  @override
  String get hwConversationOnce =>
      'A conversa só pode ser feita uma vez por tarefa.';

  @override
  String get hwTaskWorkbookDesc => 'Pratique escrevendo no caderno';

  @override
  String get hwCtaStudy => 'Começar';

  @override
  String get hwCtaResult => 'Ver resultado';

  @override
  String get hwCtaDownload => 'Baixar';

  @override
  String get hwSpeakingNoScore => 'Você ainda não fez a tarefa de fala';

  @override
  String get hwWorkbookUnavailable =>
      'O arquivo do caderno ainda não está disponível.';

  @override
  String get hwDetailClosed =>
      'Esta tarefa está encerrada. Você não pode mais entregar.';

  @override
  String get hwLeaveTitle => 'Sair da turma?';

  @override
  String get hwLeaveBody =>
      'Seu professor deixará de ver os resultados das suas tarefas.';

  @override
  String get hwLeaveConfirm => 'Sair';

  @override
  String get hwLeaveCancel => 'Ficar';

  @override
  String get hwLeaveFailed => 'Não foi possível sair da turma.';

  @override
  String get hwMyClass => 'Minha turma';

  @override
  String get hwClassEmptyTitle => 'Você não entrou em nenhuma turma';

  @override
  String get hwClassEmptySubtitle => 'Digite o código que seu professor deu';

  @override
  String get hwClassEmptyCta => 'Digitar código da turma';

  @override
  String get hwClassContinueCta => 'Continuar';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count tarefas vencem amanhã';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'Você tem $count tarefas não entregues';
  }

  @override
  String get hwSpeakingUnavailable =>
      'As frases desta tarefa ainda não estão disponíveis.';

  @override
  String get hwBadgeClosed => 'Encerrada';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$passed de $total frases aprovadas';
  }

  @override
  String get challengeFirstWord => 'Primeira palavra';

  @override
  String get challengeSeeAnalysis => 'Ver resultados';

  @override
  String get challengePaused => 'Pausado';

  @override
  String get challengePausedNote => 'O cronômetro e a gravação pararam juntos.';

  @override
  String get challengeTimeLeft => 'Tempo restante';

  @override
  String get challengeScoreLabel => 'Pontuação';

  @override
  String get challengeResume => 'Continuar';

  @override
  String get challengeBlockedTitle => 'Não é possível usar a câmera';

  @override
  String get challengeBlockedNote =>
      'Ative o acesso à câmera e ao microfone nos Ajustes.';

  @override
  String get challengeGoBack => 'Voltar';

  @override
  String get challengeOpenSettings => 'Abrir Ajustes';

  @override
  String get saveDone => 'Salvo na sua galeria';

  @override
  String get saveFailed => 'Não foi possível salvar';

  @override
  String get saveDeniedNote => 'É necessário acesso às fotos';

  @override
  String get callIncomingCallerFallback => 'Tutor Beaver';

  @override
  String get callIncomingHandle => 'Chamada em coreano';

  @override
  String get callMissedTitle => 'Chamada perdida';

  @override
  String get callMissedChannelDescription =>
      'Avisa quando você perde uma chamada do Beaver.';

  @override
  String callMissedBody(String name) {
    return '$name tentou ligar para você';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'É preciso permitir notificações para receber chamadas.';

  @override
  String get callNotifPermissionRequired =>
      'Permita as notificações nos Ajustes.';

  @override
  String get callHintLockedTitle =>
      'As dicas não estão disponíveis no modo Estudo';

  @override
  String get wsTitle => 'Sons difíceis';

  @override
  String get wsToList => 'Voltar à lista';

  @override
  String get wsNext => 'Próximo';

  @override
  String get wsRetry => 'Tentar de novo';

  @override
  String get wsDone => 'Concluir';

  @override
  String get wsContinue => 'Continuar';

  @override
  String get wsQuit => 'Sair';

  @override
  String get wsRetryLater => 'Tente novamente em instantes.';

  @override
  String get wsMissingTitle => 'Não encontramos esse som';

  @override
  String get wsMissingBody => 'Escolha de novo na lista.';

  @override
  String get wsListLoadFailed => 'Não foi possível carregar a lista';

  @override
  String get wsLessonLoadFailed => 'Não foi possível carregar a lição';

  @override
  String get wsNationalTitle => 'Sons difíceis para seu sotaque';

  @override
  String get wsNationalPending =>
      'Vamos preencher quando seu sotaque for analisado';

  @override
  String get wsNationalPicked => 'Escolhido pela análise do seu sotaque';

  @override
  String get wsNationalEmptyBody =>
      'Faça mais algumas ligações para analisarmos seu sotaque.';

  @override
  String get wsMineTitle => 'Meus sons difíceis';

  @override
  String get wsMineSubtitle => 'Sons com a menor pontuação recente';

  @override
  String get wsMineEmptyBody =>
      'Ligue e revise para acumular seus sons difíceis.';

  @override
  String get wsNoDataYet => 'Ainda sem dados';

  @override
  String get wsGoToCall => 'Iniciar ligação';

  @override
  String get wsRule => 'Regra';

  @override
  String get wsRecommended => 'Recomendado';

  @override
  String get wsNotMeasured => 'Sem medição';

  @override
  String get wsStepUnderstand => 'Entender';

  @override
  String get wsStepWords => 'Palavras';

  @override
  String get wsStepSentence => 'Frase';

  @override
  String get wsStepTest => 'Teste';

  @override
  String get wsQuitTitle => 'Parar de praticar?';

  @override
  String get wsQuitBody => 'Se sair agora, esta prática não será salva.';

  @override
  String get wsHowToSound => 'Como fazer o som';

  @override
  String get wsPracticeWords => 'Praticar palavras';

  @override
  String get wsPracticeSentence => 'Praticar a frase';

  @override
  String get wsStartTest => 'Começar o teste';

  @override
  String get wsThisSentence => 'Esta frase';

  @override
  String get wsNoScoreNote =>
      'Esta etapa não tem pontuação. Fale junto sem pressa.';

  @override
  String get wsListen => 'Ouça com atenção';

  @override
  String get wsSayNow => 'Agora fale você';

  @override
  String get wsPracticeDone => 'Prática concluída';

  @override
  String get wsPaused => 'Pausado';

  @override
  String get wsAudioFailed =>
      'Não foi possível carregar o áudio. Leia o texto em voz alta.';

  @override
  String get wsReadAloud => 'Leia a frase abaixo em voz alta';

  @override
  String get wsTapToStart => 'Toque para começar';

  @override
  String get wsTapWhenDone => 'Toque quando terminar';

  @override
  String get wsScoring => 'Pontuando';

  @override
  String get wsMicFailed => 'Não foi possível abrir o microfone.';

  @override
  String get wsMicPermissionBody =>
      'Este teste é feito em voz alta, então precisa do microfone. Ative o acesso ao microfone nos Ajustes.';

  @override
  String get wsNoSound => 'Não ouvimos nada. Tentar de novo?';

  @override
  String get wsScoreFailed => 'Falha ao pontuar. Tente novamente.';

  @override
  String get wsSomethingWrong => 'Algo deu errado.';

  @override
  String get wsLearnDone => 'Lição concluída';

  @override
  String get wsRetest => 'Testar de novo';

  @override
  String get wsFirstMeasure => 'Primeira medição';

  @override
  String get wsFinalTest => 'Teste final';

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
    return 'Sotaque $country';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count palavras repetidas';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count trechos repetidos';
  }

  @override
  String get wsStartRecommended => 'Começar pelo som recomendado';

  @override
  String wsStartRecommendedWith(String label) {
    return 'Começar por $label';
  }

  @override
  String get wsPointsUnit => 'pts';

  @override
  String get wsEnterFromMypage => 'Praticar sons difíceis';

  @override
  String wsGoalOnly(int score) {
    return 'Meta $score';
  }

  @override
  String wsSoundOf(String label) {
    return 'Som $label';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Imagine esse formato quando o som aparecer numa ligação.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country – sons que os falantes costumam errar';
  }
}
