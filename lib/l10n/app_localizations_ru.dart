// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Звонок завершён $duration';
  }

  @override
  String get callRatingPrompt => 'Как прошёл звонок?';

  @override
  String get ratingBad => 'Не очень';

  @override
  String get ratingOkay => 'Нормально';

  @override
  String get ratingGood => 'Отлично';

  @override
  String get goHome => 'Домой';

  @override
  String get viewAnalysis => 'Посмотреть анализ';

  @override
  String get loadingShort => 'Загрузка…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Не удалось отправить оценку: $message';
  }

  @override
  String get callInfoNotFound =>
      'Информация о звонке не найдена, анализ пропущен.';

  @override
  String get tabRecords => 'Записи';

  @override
  String get tabArchive => 'Архив';

  @override
  String get callHistory => 'История звонков';

  @override
  String get conversationRecord => 'Запись разговора';

  @override
  String get noCallRecords => 'Пока нет записей звонков';

  @override
  String get noCallRecordsBody =>
      'Как только вы завершите первый звонок с ИИ,\nваши записи появятся здесь.';

  @override
  String get startCall => 'Начать звонок';

  @override
  String get recordsLoadError => 'Не удалось загрузить записи';

  @override
  String get tryAgainLater => 'Пожалуйста, попробуйте позже.';

  @override
  String get retry => 'Повторить';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes мин $seconds сек';
  }

  @override
  String get scheduleManagement => 'Расписание';

  @override
  String get alarms => 'Будильники';

  @override
  String get addSchedule => 'Добавить расписание';

  @override
  String get editSchedule => 'Изменить расписание';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get alarmsLoadError => 'Не удалось загрузить будильники';

  @override
  String get charactersLoadError => 'Не удалось загрузить персонажей';

  @override
  String get noCharacters => 'Нет доступных персонажей';

  @override
  String get close => 'Закрыть';

  @override
  String get repeat => 'Повтор';

  @override
  String get callPartner => 'Персонаж';

  @override
  String get quickStart => 'Быстрый старт';

  @override
  String get presetMorning => 'Утренний режим';

  @override
  String get presetMorningSub => 'Будни 8:00';

  @override
  String get presetEvening => 'Вечернее завершение';

  @override
  String get presetEveningSub => 'Каждый день 21:00';

  @override
  String get presetCustom => 'Свой вариант';

  @override
  String get presetCustomSub => 'На ваш выбор';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× в неделю · $monthly звонков в месяц';
  }

  @override
  String get alarmSummaryNone => 'Выберите хотя бы один день';

  @override
  String get partnerInUse => 'Используется';

  @override
  String get partnerOwned => 'В наличии';

  @override
  String get am => 'ДП';

  @override
  String get pm => 'ПП';

  @override
  String get save => 'Сохранить';

  @override
  String get conversation => 'Разговор';

  @override
  String get review => 'Обзор';

  @override
  String get pronunciationChallenge => 'Испытание по произношению';

  @override
  String get newExpressions => 'Новые выражения';

  @override
  String get analysisResult => 'Результат анализа';

  @override
  String get noNewExpressions => 'В этом разговоре нет новых выражений.';

  @override
  String get practice => 'Практика';

  @override
  String recentScore(int score) {
    return 'Последний результат $score%';
  }

  @override
  String callSequence(int count) {
    return 'Звонок №$count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Пара слов от $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Оставлено $name сразу после звонка';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Новые выражения $count';
  }

  @override
  String get analysisLoadError => 'Не удалось загрузить результат анализа.';

  @override
  String get standardAudioNotReady => 'Эталонное произношение ещё не готово.';

  @override
  String get standardAudioPlayError =>
      'Не удалось воспроизвести эталонное произношение.';

  @override
  String get selectACountry => 'Выберите страну';

  @override
  String get selectYourLanguage => 'Выберите ваш язык';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get cancel => 'Отмена';

  @override
  String get selectTime => 'Выберите время';

  @override
  String get getStarted => 'Начать';

  @override
  String get permissionTitle => 'Разрешите доступ\nдля комфортной работы';

  @override
  String get permissionSubtitle =>
      'Необходимые разрешения обязательны для использования сервиса.';

  @override
  String get permissionMicTitle => 'Микрофон (обязательно)';

  @override
  String get permissionMicDesc => 'Нужен для общения с ИИ на английском.';

  @override
  String get permissionNotifTitle => 'Уведомления (по желанию)';

  @override
  String get permissionNotifDesc =>
      'Мы будем присылать напоминания об учёбе и расписание звонков.';

  @override
  String get micPermissionNeededTitle => 'Нужен доступ к микрофону';

  @override
  String get micPermissionNeededBody =>
      'Чтобы говорить с ИИ, разрешите доступ к микрофону. Включите его в настройках.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get connectionFailedTitle => 'Не удалось подключиться';

  @override
  String get connectionFailedBody =>
      'Проверьте подключение к сети\nи попробуйте снова.';

  @override
  String get checkout => 'Оформление заказа';

  @override
  String get pay => 'Оплатить';

  @override
  String get orderSummary => 'Сводка заказа';

  @override
  String get paymentMethod => 'Способ оплаты';

  @override
  String get payMethodCard => 'Кредитная / дебетовая карта';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Аватар «Надоедливый бобр»';

  @override
  String get productTrait => 'Премиум-персонаж · навсегда ваш';

  @override
  String get amountItemPrice => 'Цена товара';

  @override
  String get amountDiscount => 'Скидка';

  @override
  String get amountTotal => 'Итого';

  @override
  String get paymentCompleteTitle => 'Оплата завершена';

  @override
  String get paymentCompleteBody => 'Аватар добавлен в вашу коллекцию.';

  @override
  String get viewCollection => 'Посмотреть коллекцию';

  @override
  String get receiptItem => 'Товар';

  @override
  String get receiptAmount => 'Сумма';

  @override
  String get receiptMethod => 'Способ оплаты';

  @override
  String get receiptDate => 'Дата';

  @override
  String get paymentFailedTitle => 'Оплата не прошла';

  @override
  String get paymentFailedBody =>
      'Не удалось обработать платёж.\nПопробуйте ещё раз.';

  @override
  String get freeCallEndingTitle => 'Бесплатный звонок скоро закончится';

  @override
  String get freeCallEndingBody =>
      'Оформите подписку, чтобы дольше общаться с Бобром.';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get endCall => 'Завершить звонок';

  @override
  String get callEnded => 'Звонок завершён.';

  @override
  String get connecting => 'Подключение…';

  @override
  String get connectingHint => 'Обычно это занимает менее 5 секунд';

  @override
  String get callConnectFailed => 'Не удалось подключить звонок.';

  @override
  String get saveSentenceFailed => 'Не удалось сохранить предложение.';

  @override
  String get recordStartFailed => 'Не удалось начать запись.';

  @override
  String get recordTooShort => 'Запись слишком короткая. Попробуйте ещё раз.';

  @override
  String get gradingFailed =>
      'Не удалось оценить произношение. Попробуйте ещё раз.';

  @override
  String get listenStandard => 'Прослушать эталонное произношение';

  @override
  String get saveSentence => 'Сохранить предложение';

  @override
  String get unsaveSentence => 'Убрать из сохранённых';

  @override
  String get scoringPronunciation => 'Оцениваем ваше произношение…';

  @override
  String get analyzingByWord => 'Проверяем ваше произношение слово за словом';

  @override
  String get analyzingTakingLonger => 'Это займёт чуть больше времени';

  @override
  String get scanConnectionLost => 'Соединение потеряно';

  @override
  String get noRecordingToPlay => 'Нет записи для воспроизведения.';

  @override
  String get myRecordingPlayError => 'Не удалось воспроизвести вашу запись.';

  @override
  String get next => 'Далее';

  @override
  String get endLearning => 'Завершить занятие';

  @override
  String get navCalendar => 'Календарь';

  @override
  String get navCall => 'Звонок';

  @override
  String get navStats => 'Статистика';

  @override
  String get myPage => 'Профиль';

  @override
  String get languageSaveFailed => 'Не удалось сохранить язык.';

  @override
  String get accountDeleteFailed => 'Не удалось удалить аккаунт.';

  @override
  String get changeAvatar => 'Сменить аватар';

  @override
  String get avatarIntro =>
      'Голос и сложность зависят от собеседника.\nНекоторые персонажи могут быть платными.';

  @override
  String myPartnersOwned(int count) {
    return 'Мои персонажи · $count в коллекции';
  }

  @override
  String get limitedDiscount => 'Скидка на ограниченное время';

  @override
  String get available => 'Доступно';

  @override
  String get inUse => 'Используется';

  @override
  String get owned => 'В коллекции';

  @override
  String get noCharactersToShow => 'Нет персонажей для отображения';

  @override
  String get buy => 'Купить';

  @override
  String get noSavedSentences =>
      'Пока нет сохранённых предложений.\nОтмечайте предложения в записях разговоров.';

  @override
  String get noAlarms => 'Пока нет будильников';

  @override
  String get noAlarmsBody =>
      'Добавьте напоминание об учёбе,\nчтобы выработать привычку.';

  @override
  String get subscriptionManage => 'Управление подпиской';

  @override
  String get changePlan => 'Сменить план';

  @override
  String get cancelSubscription => 'Отменить подписку';

  @override
  String get benefitsInUse => 'Ваши преимущества';

  @override
  String get paymentInfo => 'Платёжная информация';

  @override
  String get nextBillingDate => 'Дата следующего списания';

  @override
  String get lostBenefitsTitle =>
      'Преимущества, которые вы потеряете при отмене';

  @override
  String get viewBillingHistory => 'История платежей';

  @override
  String get keepUsingPro => 'Остаться с Pro';

  @override
  String get proMembership => 'Pro-подписка';

  @override
  String get pricePerMonth => '\$12,9 / мес';

  @override
  String get benefitUnlimitedCalls => 'Неограниченные звонки';

  @override
  String get benefitDetailedAnalysis =>
      'Подробный анализ произношения и грамматики';

  @override
  String get benefitAllCharacters => 'Доступ ко всем персонажам';

  @override
  String get benefitNoAds => 'Без рекламы';

  @override
  String get playSampleVoice => 'Прослушать образец голоса';

  @override
  String get useThisAvatar => 'Использовать';

  @override
  String get challengeTitle => 'Испытание по произношению';

  @override
  String get challengeIntro =>
      'Правильно произносите каждую карточку в зоне на корейском, чтобы пройти её.\nНет микрофона? Можно играть, касаясь экрана.';

  @override
  String get challengeStart => 'Включить камеру и микрофон';

  @override
  String get challengePermissionNote =>
      'Требуется доступ к фронтальной камере и микрофону (по желанию).';

  @override
  String get challengeLoadingTitle => 'Загрузка…';

  @override
  String get challengeLoadingNote =>
      'При первом запуске загружается корейская речевая модель (~82 МБ).\nПожалуйста, подождите немного.';

  @override
  String get challengeSttFallback =>
      'Распознавание речи было недоступно, поэтому вы играли с помощью касаний.';

  @override
  String get reasonTravelTitle => 'Общение в путешествиях';

  @override
  String get reasonTravelDesc => 'Уверенно общайтесь с местными жителями';

  @override
  String get reasonCareerTitle => 'Работа и карьера';

  @override
  String get reasonCareerDesc => 'Деловое общение';

  @override
  String get reasonExamTitle => 'Подготовка к экзаменам';

  @override
  String get reasonExamDesc => 'Подготовка к устной части тестов';

  @override
  String get reasonDailyTitle => 'Повседневное общение';

  @override
  String get reasonDailyDesc => 'Выражения, которые вы используете каждый день';

  @override
  String get reasonFriendsTitle => 'Заводите иностранных друзей';

  @override
  String get reasonFriendsDesc => 'Естественное общение';

  @override
  String get reasonBrainTitle => 'Стимуляция мозга';

  @override
  String get reasonBrainDesc => 'Улучшайте память и концентрацию';

  @override
  String get challengeRecordToggle => 'Записать это прохождение';

  @override
  String get challengeRecordHint =>
      'Сохраняет видео вашей игры для обмена (без звука).';

  @override
  String get settingsSection => 'Настройки';

  @override
  String get paymentSection => 'Оплата';

  @override
  String get supportSection => 'Поддержка';

  @override
  String get userLanguage => 'Язык пользователя';

  @override
  String get learningLanguage => 'Изучаемый язык';

  @override
  String get learningLanguageKorean => 'Корейский';

  @override
  String get notificationLabel => 'Уведомления';

  @override
  String get currentPlan => 'Текущий план';

  @override
  String get paymentHistory => 'История платежей';

  @override
  String get contactUs => 'Связаться с нами';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get logOut => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountBody =>
      'Это навсегда удалит ваш аккаунт и данные, и действие нельзя будет отменить.';

  @override
  String get delete => 'Удалить';

  @override
  String get share => 'Поделиться';

  @override
  String get accentSoundsLike => 'Ваш корейский акцент звучит как';

  @override
  String get hintLabel => 'Подсказка';

  @override
  String get nextHint => 'Следующая подсказка';

  @override
  String get translateLabel => 'Перевод';

  @override
  String get startRecording => 'Начать запись';

  @override
  String get stopRecording => 'Остановить запись';

  @override
  String get back => 'Назад';

  @override
  String get onboardingNameTitle => 'Как к вам обращаться?';

  @override
  String get onboardingNameSubtitle => 'Ваш ИИ-репетитор запомнит ваше имя.';

  @override
  String get nameLabel => 'Ваше имя';

  @override
  String get nameHint => 'Введите имя';

  @override
  String get nameHelper =>
      'Не обязательно указывать настоящее имя — подойдёт и никнейм.';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get onboardingDoneTitle => 'Бобр ждёт вашего звонка';

  @override
  String get onboardingDoneSubtitle => 'Начните звонок прямо сейчас';

  @override
  String get home => 'Главная';

  @override
  String get callNow => 'Позвонить сейчас';

  @override
  String get pronunciation => 'Произношение';

  @override
  String get fluency => 'Беглость';

  @override
  String get rhythm => 'Ритм';

  @override
  String get analysisTimeout =>
      'Это занимает больше времени, чем обычно. Пожалуйста, попробуйте ещё раз чуть позже.';

  @override
  String get analysisFailed =>
      'Не удалось проанализировать разговор. Попробуйте ещё раз.';

  @override
  String get analyzingConversation => 'Анализируем ваш разговор…';

  @override
  String get analyzingSubtitle => 'Это займёт всего мгновение';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get nativeLabel => 'Носитель языка';

  @override
  String get meLabel => 'Я';

  @override
  String get pronunciationPlayError => 'Не удалось воспроизвести произношение.';

  @override
  String get savedExpressionsLoadError =>
      'Не удалось загрузить сохранённые выражения.';

  @override
  String get mySavedExpressions => 'Мои сохранённые выражения';

  @override
  String get avatarTraits => 'Тёплый · спокойный · мягкий';

  @override
  String get priceFree => 'Бесплатно';

  @override
  String get loginGoogleTokenError => 'Не удалось получить токен входа Google.';

  @override
  String get loginGoogleSignInFailed => 'Не удалось войти через Google.';

  @override
  String get loginAppleSignInFailed => 'Не удалось войти через Apple.';

  @override
  String get loginKakaoSignInFailed => 'Не удалось войти через Kakao.';

  @override
  String get loginContinueWithKakao => 'Продолжить с Kakao';

  @override
  String get loginContinueWithGoogle => 'Продолжить с Google';

  @override
  String get loginContinueWithApple => 'Продолжить с Apple';

  @override
  String get loginContinueWithEmail => 'Продолжить по эл. почте';

  @override
  String get loginOrDivider => 'или';

  @override
  String get loginNoAccount => 'Нет аккаунта?';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get loginTermsNoticePrefix => 'Продолжая, вы соглашаетесь с нашими ';

  @override
  String get loginTermsNoticeAnd => ' и ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Войти';

  @override
  String get fieldEmailLabel => 'Эл. почта';

  @override
  String get emailHint => 'Введите адрес эл. почты';

  @override
  String get fieldPasswordLabel => 'Пароль';

  @override
  String get passwordHint => 'Введите пароль';

  @override
  String get loginRememberMe => 'Запомнить меня';

  @override
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get loginLoggingIn => 'Выполняется вход...';

  @override
  String get passwordLengthError =>
      'Пароль должен содержать от 8 до 16 символов.';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают.';

  @override
  String get signupCheckInput => 'Пожалуйста, проверьте введённые данные.';

  @override
  String get fieldConfirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get confirmPasswordHint => 'Введите пароль ещё раз';

  @override
  String get signupSigningUp => 'Регистрация...';

  @override
  String get signupHaveAccount => 'Уже есть аккаунт?';

  @override
  String get passwordMethodEmailRequired => 'Введите адрес эл. почты';

  @override
  String get passwordResetTitle => 'Сброс пароля';

  @override
  String get passwordMethodDescription =>
      'Введите адрес эл. почты, на который хотите получить код для сброса пароля.';

  @override
  String get emailAddressHint => 'Адрес эл. почты';

  @override
  String get passwordMethodSending => 'Отправка...';

  @override
  String get passwordMethodSendEmail => 'Отправить письмо';

  @override
  String get passwordCodeTitle => 'Введите код';

  @override
  String get passwordCodeDescription =>
      'Мы отправили код восстановления на вашу эл. почту. Введите его, чтобы продолжить.';

  @override
  String get passwordCodeNoCode => 'Не получили код?';

  @override
  String get passwordCodeResend => 'Отправить код повторно';

  @override
  String get passwordCodeVerifying => 'Проверка...';

  @override
  String get passwordNewTitle => 'Новый пароль';

  @override
  String get passwordNewDescription =>
      'Задайте новый пароль для вашего аккаунта.';

  @override
  String get fieldNewPasswordLabel => 'Новый пароль';

  @override
  String get newPasswordHint => 'Введите новый пароль';

  @override
  String get fieldConfirmNewPasswordLabel => 'Подтвердите новый пароль';

  @override
  String get confirmNewPasswordHint => 'Введите новый пароль ещё раз';

  @override
  String get passwordNewSubmitting => 'Отправка...';

  @override
  String get passwordNewSubmit => 'Отправить';

  @override
  String get passwordCompleteTitle => 'Пароль сброшен';

  @override
  String get passwordCompleteBody =>
      'Ваш пароль был сброшен. Войдите с новым паролем, чтобы продолжить.';

  @override
  String get termsTitle => 'Условия использования';

  @override
  String get privacyTitle => 'Политика конфиденциальности';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Задайте новый пароль для $email.';
  }

  @override
  String get selectComplete => 'Готово';

  @override
  String get onboardingLanguageTitle => 'Какой ваш родной язык?';

  @override
  String get onboardingReasonTitle => 'Почему вы изучаете язык?';

  @override
  String get onboardingReasonSubtitle =>
      'Мы адаптируем обучение под ваши цели.';

  @override
  String get savingLabel => 'Сохранение...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Платёж в этом месяце';

  @override
  String get filterAll => 'Все';

  @override
  String get filterSubscription => 'Подписка';

  @override
  String get filterCharacter => 'Персонаж';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get lastPayment => 'Последний платёж';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Вы можете пользоваться преимуществами Pro до $date, после чего тариф автоматически сменится на бесплатный.';
  }

  @override
  String get freePlanCallLimit => '1 звонок в день · лимит 5 мин';

  @override
  String get freePlanBasicCharacters => 'Базовые персонажи включены';

  @override
  String get availableForPurchase => 'Доступно для покупки';

  @override
  String get paymentsLoadError => 'Не удалось загрузить историю платежей';

  @override
  String get noPayments => 'Платежей пока нет';

  @override
  String get morePaymentsExist => 'Более старые платежи пока не отображаются';

  @override
  String get undatedPayments => 'Без даты';

  @override
  String get paymentLabelFallback => 'Платёж';

  @override
  String learningPassed(int passed, int total) {
    return 'Пройдено $passed из $total предложений';
  }

  @override
  String get hardestSound => 'Самый трудный звук сегодня';

  @override
  String get soundAccuracy => 'Точность по звукам';

  @override
  String phonemeAttempts(int count) {
    return 'По фонемам · $count попыток';
  }

  @override
  String get colSound => 'Звук';

  @override
  String get colAttempts => 'Поп.';

  @override
  String get colCorrect => 'Верно';

  @override
  String get colAccuracy => 'Точн.';

  @override
  String get sentenceResults => 'Результаты по предложениям';

  @override
  String viewAllSentences(int count) {
    return 'Показать все $count';
  }

  @override
  String get colSentence => 'Предл.';

  @override
  String get colPronunciation => 'Произн.';

  @override
  String get colFluency => 'Бегл.';

  @override
  String get colRhythm => 'Ритм';

  @override
  String recentSessions(int count) {
    return 'Последние $count сессий';
  }

  @override
  String trendAverage(int score) {
    return 'Сред. $score';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get colDate => 'Дата';

  @override
  String get colSentences => 'Предл.';

  @override
  String get colScore => 'Балл';

  @override
  String get colChange => 'Изм.';

  @override
  String dateToday(String date) {
    return '$date (сегодня)';
  }

  @override
  String get accentAnalysis => 'Анализ акцента';

  @override
  String get overallLevel => 'Общий уровень';

  @override
  String get overallLevelSubtitle => 'Лексика · Грамматика · Выражения';

  @override
  String get pronunciationAnalysis => 'Анализ произношения';

  @override
  String get recentSessionsAverage => 'Среднее за 10 сессий';

  @override
  String levelStage(int stage) {
    return 'Уровень $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Топ $percent%';
  }

  @override
  String get allLearnersBasis => 'Среди всех учащихся';

  @override
  String aheadOfLearners(int percent) {
    return 'Вы опережаете $percent% учащихся';
  }

  @override
  String get retakeLevelTest => 'Пройти тест уровня заново';

  @override
  String get practicePronunciation => 'Тренировать произношение';

  @override
  String get priceChangedTitle => 'Price changed';

  @override
  String priceChangedBody(String price) {
    return 'This item is now $price. Would you like to continue?';
  }
}
