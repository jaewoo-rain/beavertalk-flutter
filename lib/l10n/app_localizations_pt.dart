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
