// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Ligação encerrada em $duration';
  }

  @override
  String get callRatingPrompt => 'Como foi sua ligação?';

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
  String get review => 'Revisão';

  @override
  String get pronunciationChallenge => 'Desafio de Pronúncia';

  @override
  String get newExpressions => 'Novas expressões';

  @override
  String get analysisResult => 'Resultado da análise';

  @override
  String get noNewExpressions => 'Nenhuma expressão nova nesta conversa.';

  @override
  String get practice => 'Praticar';

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
  String get selectACountry => 'Selecione um país';

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
  String get myPage => 'Minha página';

  @override
  String get languageSaveFailed => 'Não foi possível salvar seu idioma.';

  @override
  String get accountDeleteFailed => 'Não foi possível excluir sua conta.';

  @override
  String get changeAvatar => 'Trocar avatar';

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
  String get changePlan => 'Alterar plano';

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
  String get keepUsingPro => 'Continuar com o Pro';

  @override
  String get proMembership => 'Assinatura Pro';

  @override
  String get pricePerMonth => 'US\$ 12,90 / mês';

  @override
  String get benefitUnlimitedCalls => 'Ligações ilimitadas';

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
  String get challengeLoadingNote =>
      'Baixando o modelo de fala em coreano (~82 MB) na primeira execução.\nAguarde um momento.';

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
  String get analysisTimeout =>
      'Isso está demorando mais do que o esperado. Tente novamente em instantes.';

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
  String get loginKakaoSignInFailed => 'Falha no login com o Kakao.';

  @override
  String get loginContinueWithKakao => 'Continuar com o Kakao';

  @override
  String get loginContinueWithGoogle => 'Continuar com o Google';

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
  String subscriptionSwitchNote(String date) {
    return 'Você pode continuar usando os benefícios Pro até $date; depois disso, seu plano muda automaticamente para o Gratuito.';
  }

  @override
  String get freePlanCallLimit => '1 chamada por dia · limite de 5 min';

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
  String get connected => 'Conectado';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get difficultySlow => 'Lento';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Rápido';
}
