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
  String pricePerMonth(String price) {
    return 'US$price / mês';
  }

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
  String get billingChangePlan => 'Mudar de plano';

  @override
  String get billingCompareAllPlans => 'Comparar todos os planos';

  @override
  String get billingBuyACharacter => 'Comprar um personagem';

  @override
  String get billingRestorePurchases => 'Restaurar compras';

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
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Teste do Max';

  @override
  String get freePlanPriceLine => '\$0.00 — uma ligação por dia';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount por mês';
  }

  @override
  String freeUntilDate(String date) {
    return 'Grátis até $date';
  }

  @override
  String get todaysCalls => 'Ligações de hoje';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used de $limit usadas';
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
  String get bannerGoUnlimitedTitle => 'Fique sem limites com o Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Ligações ilimitadas · 15 minutos cada · $price por mês';
  }

  @override
  String get bannerMaxUpsellTitle => 'Ative o vídeo com o Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Ligações cara a cara · $price por mês';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Mude para o anual';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly por ano · $perMonth por mês';
  }

  @override
  String get bannerPaymentFailedTitle =>
      'Não conseguimos processar o pagamento';

  @override
  String get bannerPaymentFailedSub =>
      'Atualize o pagamento na loja para manter o Pro';

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
  String get noteFairUse =>
      'O uso ilimitado está sujeito à nossa política de uso justo.';

  @override
  String noteTrialEnds(String date) {
    return 'Seu teste termina em $date. Cancele na loja antes disso e nada será cobrado.';
  }

  @override
  String get noteGrace =>
      'Seus benefícios continuam ativos durante o período de carência. O cancelamento nunca é bloqueado no app.';

  @override
  String get noteHold =>
      'O Pro fica pausado até o pagamento ser concluído. Seus personagens e seu progresso estão seguros.';

  @override
  String noteEnding(String date) {
    return 'Seu plano vai terminar. Os benefícios continuam até $date, depois você passa para o Grátis. Você pode assinar de novo quando quiser.';
  }

  @override
  String get trialExpiredTitle => 'Seu teste do Max terminou';

  @override
  String get trialExpiredSub => 'Agora você está no Grátis';

  @override
  String get seePlans => 'Ver planos';

  @override
  String get currentPlanTitle => 'Plano atual';

  @override
  String get badgeRecommended => 'Recomendado';

  @override
  String get perMonthUnit => 'por mês';

  @override
  String get planTaglinePro => 'Ligações ilimitadas. 15 minutos cada.';

  @override
  String get planTaglineMax => 'Agora você pode vê-los.';

  @override
  String get planTaglineFree => 'Uma ligação por dia. Por nossa conta.';

  @override
  String get bulletProCalls => 'Ligações de voz quantas vezes você quiser';

  @override
  String get bulletProLength => '15 minutos por ligação';

  @override
  String get bulletProScoring => 'Pronúncia avaliada letra por letra';

  @override
  String get bulletProCorrections =>
      'Correções voltadas para o seu idioma nativo';

  @override
  String get bulletProBeaverCalls => 'O Beaver liga para você primeiro';

  @override
  String get bulletMaxVideo => 'Videochamadas cara a cara';

  @override
  String get bulletMaxEverything => 'Tudo do Pro';

  @override
  String get bulletMaxCharacters => 'Todos os personagens, sem limites';

  @override
  String get bulletMaxStudyBook => 'Um livro de estudos feito para o seu nível';

  @override
  String get bulletMaxWeeklyReport =>
      'Um relatório semanal de como sua pronúncia está mudando';

  @override
  String get bulletFreeCall => 'Uma ligação de voz de 5 minutos por dia';

  @override
  String get bulletFreeCheck => 'Uma verificação de pronúncia por dia';

  @override
  String get bulletFreeAccent => 'Verificações de sotaque ilimitadas';

  @override
  String get bulletFreeCharacter => 'Um personagem para começar';

  @override
  String get ctaGoUnlimited => 'Ficar sem limites';

  @override
  String get ctaTurnOnVideo => 'Ativar o vídeo';

  @override
  String get noteCallLength => 'Cada ligação dura 15 minutos.';

  @override
  String get paywallProTitle1 => 'Seu amigo coreano';

  @override
  String get paywallProTitle2 => 'que está acordado às 3 da manhã';

  @override
  String get paywallProSub =>
      'Ligações ilimitadas. 15 minutos cada. O ano todo.';

  @override
  String get paywallLimitHeadline => 'O Pro remove o limite.';

  @override
  String get limitBannerCallTitle => 'Essa foi a ligação de hoje';

  @override
  String get limitBannerCallSub => 'O Grátis dá uma ligação por dia';

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
  String get paywallMaxSub =>
      'Videochamadas, todos os personagens e um livro de estudos feito para o seu nível.';

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
  String get noteMaxCharacters =>
      'Personagens desbloqueados pelo Max ficam disponíveis enquanto sua assinatura estiver ativa. Personagens comprados continuam sendo seus.';

  @override
  String get processingTitle => 'Confirmando sua compra';

  @override
  String get processingSub => 'Isso costuma levar alguns segundos.';

  @override
  String get successProTitle => 'Você está no Pro.';

  @override
  String get successProSub => 'Ligações ilimitadas a partir de agora.';

  @override
  String get successProBenefit1 =>
      'Ligue quantas vezes quiser — 15 minutos por ligação';

  @override
  String get successProBenefit2 => 'Verificações de pronúncia ilimitadas';

  @override
  String get successProBenefit3 =>
      'Todos os personagens, além de compras avulsas';

  @override
  String get successMaxTitle => 'Agora você pode vê-los.';

  @override
  String get successMaxSub =>
      'As videochamadas estão ativas. Toque no botão de vídeo em qualquer ligação.';

  @override
  String get successMaxBenefit1 => 'Videochamadas cara a cara';

  @override
  String get successMaxBenefit2 =>
      'Todos os personagens, sem limites e novidades primeiro';

  @override
  String get successMaxBenefit3 => 'Um livro de estudos feito para o seu nível';

  @override
  String get ctaStartACall => 'Iniciar uma ligação';

  @override
  String get ctaStartAVideoCall => 'Iniciar uma videochamada';

  @override
  String get ctaSeeYourSubscription => 'Ver sua assinatura';

  @override
  String successProCaption(String price) {
    return '$price são cobrados por mês até você cancelar. Gerencie ou cancele quando quiser na loja.';
  }

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
  String get changePlanTitle => 'Mudar de plano';

  @override
  String get moveToMaxTitle => 'Mudar para o Max';

  @override
  String maxPriceShort(String price) {
    return '$price/mês';
  }

  @override
  String get moveToMaxCardSub =>
      'Videochamadas cara a cara · todos os personagens · um livro de estudos feito para você';

  @override
  String get whatHappensNow => 'O que acontece agora';

  @override
  String get maxStartsLabel => 'O Max começa';

  @override
  String get immediately => 'Imediatamente';

  @override
  String get unusedProTime => 'Tempo não usado do Pro';

  @override
  String get creditedTowardMax => 'Creditado no Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Mudar para o Max';

  @override
  String get upgradeCaption =>
      'Seu novo plano começa na hora. O tempo não usado do Pro é creditado, nunca cobrado duas vezes.';

  @override
  String get moveToProTitle => 'Mudar para o Pro';

  @override
  String get moveToProSub =>
      'Nada muda hoje. O Max continua até o fim do mês que você já pagou.';

  @override
  String get maxRunsUntil => 'O Max continua até';

  @override
  String get proStarts => 'O Pro começa';

  @override
  String get whatYouKeep => 'O que você mantém';

  @override
  String get keepBenefitCalls => 'Ligações de voz ilimitadas, 15 minutos cada';

  @override
  String get keepBenefitCharacters =>
      'Personagens comprados são seus para sempre';

  @override
  String downgradeWarning(String date) {
    return 'As videochamadas e os personagens exclusivos do Max são desativados em $date.';
  }

  @override
  String get ctaSwitchToPro => 'Mudar para o Pro';

  @override
  String get ctaKeepMax => 'Manter o Max';

  @override
  String get winbackSkip => 'Pular';

  @override
  String get winbackTitle => 'Seu plano Pro terminou';

  @override
  String get winbackSub => 'Agora você está no Grátis — uma ligação por dia.';

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
  String get ovRestoreSuccessTitle => 'O Pro voltou';

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
  String get ovCharacterOfferTitle => 'Ainda não está pronto para o Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Escolha um personagem e fique com ele. Uma compra única — sem assinatura, sem renovação.';

  @override
  String get rowOneCharacter => 'Um personagem';

  @override
  String rowFromPrice(String price) {
    return 'a partir de $price';
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
  String get rowProRunsUntil => 'O Pro continua até';

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
      'Você está no Pro há dois meses. O plano anual sai mais barato.';

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
      'O Max continua a menos que você cancele. Veja o que acontece.';

  @override
  String get rowTrialEnds => 'O teste termina';

  @override
  String get rowFirstCharge => 'Primeira cobrança';

  @override
  String get rowThenMonthly => 'Depois, mensal';

  @override
  String get ctaCancelInStore => 'Cancelar na loja';

  @override
  String get ovTrialStartTitle => '7 dias de Max, grátis';

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
      'Boa escolha — as ligações ilimitadas já estão ativas. O mesmo Pro custa menos se você pagar por ano.';

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
  String get ovAlreadyTitle => 'Você já está no Pro';

  @override
  String get ovAlreadyBody =>
      'Esta conta da loja já tem um plano ativo. Não há nada para comprar.';

  @override
  String get ctaSeeMySubscription => 'Ver minha assinatura';

  @override
  String get subCancelTitle => 'Cancelar assinatura';

  @override
  String subCancelBody(String date) {
    return 'O Pro continua até $date. Depois disso, você passa para o Grátis.';
  }

  @override
  String get subWhatYouLose => 'O que você perde';

  @override
  String get benefitCalls15 => 'Ligações ilimitadas, 15 minutos cada';

  @override
  String get benefitScoring => 'Pronúncia avaliada letra por letra';

  @override
  String get benefitEveryCharacter => 'Todos os personagens, sem limites';

  @override
  String get ctaKeepPro => 'Manter o Pro';

  @override
  String get subPaymentTitle => 'Atualizar pagamento';

  @override
  String get subPaymentBody =>
      'Não conseguimos processar o pagamento. O Pro continua ativo durante o período de carência.';

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
    return 'O Pro termina em $date. Reative a renovação automática e nada muda.';
  }

  @override
  String get subWhatYouKeep => 'O que você mantém';

  @override
  String get ctaTurnItBackOn => 'Reativar';

  @override
  String get flTodayTitle => 'Essa foi a ligação de hoje';

  @override
  String get flTodayBody => 'Continue de onde parou — agora mesmo.';

  @override
  String get flCheckTitle => 'Essa foi a verificação de hoje';

  @override
  String get flCheckBody =>
      'Uma verificação por dia no Grátis. Com o Pro, é ilimitado.';

  @override
  String get flBenefitCalls =>
      'Ligações ilimitadas com o Pro · 15 minutos cada';

  @override
  String get flBenefitChecks =>
      'Verificações de pronúncia ilimitadas com o Pro';

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
  String get emailLabel => 'Email';

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
}
