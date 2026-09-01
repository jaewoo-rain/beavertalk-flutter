// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get loginRequired => 'Необходимо войти в аккаунт.';

  @override
  String get callWebNotSupported =>
      'Голосовые звонки не поддерживаются в вебе. Используйте приложение.';

  @override
  String get micPermissionRequiredForCall =>
      'Требуется доступ к микрофону. Разрешите микрофон, чтобы позвонить.';

  @override
  String get callErrorGeneric => 'Во время звонка произошла ошибка.';

  @override
  String get callNetworkError => 'Произошла сетевая ошибка.';

  @override
  String get authInvalidCredentials =>
      'Неверный адрес электронной почты или пароль.';

  @override
  String get authEmailAlreadyRegistered => 'Эта почта уже зарегистрирована.';

  @override
  String get authConfirmEmailRequired =>
      'Завершите подтверждение, отправленное на вашу почту.';

  @override
  String get authResetCodeSent =>
      'Мы отправили код подтверждения на вашу почту.';

  @override
  String get authResetCodeInvalid => 'Код неверен или истёк.';

  @override
  String get authPasswordUpdated => 'Пароль сброшен.';

  @override
  String get authAppleTokenMissing => 'Не удалось получить токен входа Apple.';

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
  String get selectNativeLanguage => 'Выберите ваш родной язык';

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
  String pricePerMonth(String price) {
    return '$price / мес';
  }

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
  String get loginFacebookSignInFailed => 'Не удалось войти через Facebook.';

  @override
  String get loginKakaoSignInFailed => 'Не удалось войти через Kakao.';

  @override
  String get loginContinueWithKakao => 'Продолжить с Kakao';

  @override
  String get loginContinueWithGoogle => 'Продолжить с Google';

  @override
  String get loginContinueWithFacebook => 'Продолжить с Facebook';

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
  String get priceChangedTitle => 'Цена изменилась';

  @override
  String priceChangedBody(String price) {
    return 'Теперь этот товар стоит $price. Продолжить?';
  }

  @override
  String get billingGroupPlanPurchases => 'План и покупки';

  @override
  String get billingGroupInTheStore => 'В магазине';

  @override
  String get billingChangePlan => 'Сменить план';

  @override
  String get billingCompareAllPlans => 'Сравнить все планы';

  @override
  String get billingBuyACharacter => 'Купить персонажа';

  @override
  String get billingRestorePurchases => 'Восстановить покупки';

  @override
  String get billingPaymentHistory => 'История платежей';

  @override
  String get billingManageInTheStore => 'Управлять в магазине';

  @override
  String get billingRefundHelp => 'Помощь с возвратом';

  @override
  String get billingCancelSubscription => 'Отменить подписку';

  @override
  String get billingResubscribe => 'Возобновить подписку';

  @override
  String get badgeCurrent => 'Текущий';

  @override
  String get badgeTrial => 'Пробный период';

  @override
  String get badgeRenewing => 'Продлевается';

  @override
  String get badgePastDue => 'Просрочен';

  @override
  String get badgePaused => 'Приостановлен';

  @override
  String get badgeCanceling => 'Отменяется';

  @override
  String get subscriptionTitle => 'Подписка';

  @override
  String get plansTitle => 'Планы';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Пробный Max';

  @override
  String get freePlanPriceLine => '\$0.00 — один звонок в день';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount в месяц';
  }

  @override
  String freeUntilDate(String date) {
    return 'Бесплатно до $date';
  }

  @override
  String get todaysCalls => 'Звонки сегодня';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'Использовано $used из $limit';
  }

  @override
  String get firstPaymentLabel => 'Первый платёж';

  @override
  String get nextPaymentLabel => 'Следующий платёж';

  @override
  String get retryingUntilLabel => 'Повтор попыток до';

  @override
  String get pausedSinceLabel => 'Приостановлен с';

  @override
  String planEndsLabel(String plan) {
    return '$plan заканчивается';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Безлимит с Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Безлимитные звонки · по 15 минут · $price в месяц';
  }

  @override
  String get bannerMaxUpsellTitle => 'Включите видео с Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Звонки лицом к лицу · $price в месяц';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Перейдите на годовой план';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly в год · $perMonth в месяц';
  }

  @override
  String get bannerPaymentFailedTitle => 'Не удалось списать оплату';

  @override
  String get bannerPaymentFailedSub =>
      'Обновите способ оплаты в магазине, чтобы сохранить Pro';

  @override
  String get bannerPausedTitle => 'Ваш план приостановлен';

  @override
  String get bannerPausedSub => 'Платёж так и не прошёл';

  @override
  String get noteRestoreHint =>
      'Уже подписаны на другом устройстве? Восстановление вернёт подписку на этом.';

  @override
  String get noteStoreHandled =>
      'Способ оплаты, смена плана и отмена выполняются в магазине.';

  @override
  String get noteFairUse =>
      'Безлимитное использование регулируется нашей политикой добросовестного использования.';

  @override
  String noteTrialEnds(String date) {
    return 'Пробный период заканчивается $date. Отмените в магазине до этого — и ничего не спишется.';
  }

  @override
  String get noteGrace =>
      'Все преимущества сохраняются в течение льготного периода. Отмена никогда не блокируется в приложении.';

  @override
  String get noteHold =>
      'Pro приостановлен, пока не пройдёт платёж. Ваши персонажи и прогресс в безопасности.';

  @override
  String noteEnding(String date) {
    return 'Ваш план завершается. Преимущества действуют до $date, затем вы перейдёте на Free. Подписку можно возобновить в любой момент.';
  }

  @override
  String get trialExpiredTitle => 'Пробный период Max закончился';

  @override
  String get trialExpiredSub => 'Теперь вы на Free';

  @override
  String get seePlans => 'Посмотреть планы';

  @override
  String get currentPlanTitle => 'Текущий план';

  @override
  String get badgeRecommended => 'Рекомендуем';

  @override
  String get perMonthUnit => 'в месяц';

  @override
  String get planTaglinePro => 'Безлимитные звонки. По 15 минут.';

  @override
  String get planTaglineMax => 'Теперь вы можете их видеть.';

  @override
  String get planTaglineFree => 'Один звонок в день. Бесплатно.';

  @override
  String get bulletProCalls => 'Голосовые звонки без ограничений';

  @override
  String get bulletProLength => '15 минут на звонок';

  @override
  String get bulletProScoring => 'Оценка произношения по каждой букве';

  @override
  String get bulletProCorrections =>
      'Исправления с учётом вашего родного языка';

  @override
  String get bulletProBeaverCalls => 'Бивер звонит вам первым';

  @override
  String get bulletMaxVideo => 'Видеозвонки лицом к лицу';

  @override
  String get bulletMaxEverything => 'Всё из Pro';

  @override
  String get bulletMaxCharacters => 'Все персонажи, без ограничений';

  @override
  String get bulletMaxStudyBook => 'Учебник, подобранный под ваш уровень';

  @override
  String get bulletMaxWeeklyReport =>
      'Еженедельный отчёт о том, как меняется ваше произношение';

  @override
  String get bulletFreeCall => 'Один 5-минутный голосовой звонок в день';

  @override
  String get bulletFreeCheck => 'Одна проверка произношения в день';

  @override
  String get bulletFreeAccent => 'Проверки акцента без ограничений';

  @override
  String get bulletFreeCharacter => 'Один персонаж для начала';

  @override
  String get ctaGoUnlimited => 'Перейти на безлимит';

  @override
  String get ctaTurnOnVideo => 'Включить видео';

  @override
  String get noteCallLength => 'Каждый звонок длится 15 минут.';

  @override
  String get paywallProTitle1 => 'Ваш корейский друг,';

  @override
  String get paywallProTitle2 => 'который не спит в 3 часа ночи';

  @override
  String get paywallProSub => 'Безлимитные звонки. По 15 минут. Круглый год.';

  @override
  String get paywallLimitHeadline => 'Pro снимает лимит.';

  @override
  String get limitBannerCallTitle => 'Это был звонок на сегодня';

  @override
  String get limitBannerCallSub => 'Free даёт один звонок в день';

  @override
  String get limitBannerCheckTitle => 'Это была проверка на сегодня';

  @override
  String get limitBannerCheckSub => 'Free даёт одну проверку в день';

  @override
  String get bulletProCharactersForever =>
      'Купленные персонажи остаются с вами навсегда';

  @override
  String get paywallMaxTitle => 'Теперь вы можете их видеть.';

  @override
  String get paywallMaxSub =>
      'Видеозвонки, все персонажи и учебник, созданный под ваш уровень.';

  @override
  String get planMonthly => 'Помесячно';

  @override
  String get planAnnual => 'Годовой';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price в месяц';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth в месяц';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price в месяц';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly в год · $perMonth в месяц';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price в месяц · отмена в магазине в любой момент';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price в месяц · отмена в магазине в любой момент';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 дней бесплатно, затем $price в месяц · отмена в магазине в любой момент';
  }

  @override
  String get ctaCaptionAutoRenew => 'Продлевается автоматически до отмены.';

  @override
  String get footerTerms => 'Условия';

  @override
  String get footerPrivacy => 'Конфиденциальность';

  @override
  String get noteMaxCharacters =>
      'Персонажи, открытые с Max, доступны, пока активна подписка. Купленные персонажи остаются вашими.';

  @override
  String get processingTitle => 'Подтверждаем покупку';

  @override
  String get processingSub => 'Обычно это занимает несколько секунд.';

  @override
  String get successProTitle => 'Вы на Pro.';

  @override
  String get successProSub => 'Безлимитные звонки — прямо сейчас.';

  @override
  String get successProBenefit1 =>
      'Звоните сколько хотите — по 15 минут на звонок';

  @override
  String get successProBenefit2 => 'Безлимитные проверки произношения';

  @override
  String get successProBenefit3 => 'Все персонажи плюс разовые покупки';

  @override
  String get successMaxTitle => 'Теперь вы их видите.';

  @override
  String get successMaxSub =>
      'Видеозвонки включены. Нажмите кнопку видео в любом звонке.';

  @override
  String get successMaxBenefit1 => 'Видеозвонки лицом к лицу';

  @override
  String get successMaxBenefit2 =>
      'Все персонажи без ограничений, новые — первыми';

  @override
  String get successMaxBenefit3 => 'Учебник, подобранный под ваш уровень';

  @override
  String get ctaStartACall => 'Начать звонок';

  @override
  String get ctaStartAVideoCall => 'Начать видеозвонок';

  @override
  String get ctaSeeYourSubscription => 'Посмотреть подписку';

  @override
  String successProCaption(String price) {
    return '$price списывается ежемесячно до отмены. Управление и отмена — в магазине в любой момент.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price списывается ежемесячно до отмены. Управление и отмена — в магазине в любой момент.';
  }

  @override
  String get plansErrorTitle => 'Не удалось загрузить планы';

  @override
  String get plansErrorSub => 'Магазин не ответил.';

  @override
  String get ctaTryAgain => 'Попробовать снова';

  @override
  String get plansErrorCaption => 'Ничего не списано.';

  @override
  String get changePlanTitle => 'Смена плана';

  @override
  String get moveToMaxTitle => 'Переход на Max';

  @override
  String maxPriceShort(String price) {
    return '$price / мес.';
  }

  @override
  String get moveToMaxCardSub =>
      'Видеозвонки лицом к лицу · все персонажи · учебник, созданный для вас';

  @override
  String get whatHappensNow => 'Что будет дальше';

  @override
  String get maxStartsLabel => 'Max начинается';

  @override
  String get immediately => 'Сразу';

  @override
  String get unusedProTime => 'Неиспользованное время Pro';

  @override
  String get creditedTowardMax => 'Зачтётся в счёт Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Перейти на Max';

  @override
  String get upgradeCaption =>
      'Новый план начинается сразу. Неиспользованное время Pro зачитывается — двойных списаний нет.';

  @override
  String get moveToProTitle => 'Переход на Pro';

  @override
  String get moveToProSub =>
      'Сегодня ничего не меняется. Max действует до конца уже оплаченного месяца.';

  @override
  String get maxRunsUntil => 'Max действует до';

  @override
  String get proStarts => 'Pro начинается';

  @override
  String get whatYouKeep => 'Что у вас останется';

  @override
  String get keepBenefitCalls => 'Безлимитные голосовые звонки по 15 минут';

  @override
  String get keepBenefitCharacters =>
      'Купленные персонажи остаются с вами навсегда';

  @override
  String downgradeWarning(String date) {
    return 'Видеозвонки и персонажи, доступные только в Max, отключатся $date.';
  }

  @override
  String get ctaSwitchToPro => 'Перейти на Pro';

  @override
  String get ctaKeepMax => 'Оставить Max';

  @override
  String get winbackSkip => 'Пропустить';

  @override
  String get winbackTitle => 'Ваш план Pro закончился';

  @override
  String get winbackSub => 'Теперь вы на Free — один звонок в день.';

  @override
  String get winbackQuestion => 'Расскажете, почему вы ушли?';

  @override
  String get winbackReasonExpensive => 'Слишком дорого';

  @override
  String get winbackReasonUnused => 'Мало пользовался(ась)';

  @override
  String get winbackReasonMissing => 'Не хватало нужной функции';

  @override
  String get winbackReasonOtherApp => 'Нашёл(ла) другое приложение';

  @override
  String get winbackReasonElse => 'Другое';

  @override
  String get ctaSend => 'Отправить';

  @override
  String get ctaNotNow => 'Не сейчас';

  @override
  String get winbackCaption =>
      'Это не восстановит ваш план. Подписку можно возобновить в магазине.';

  @override
  String get ctaContinue => 'Продолжить';

  @override
  String get ctaClose => 'Закрыть';

  @override
  String get ovRestoreSuccessTitle => 'Pro снова с вами';

  @override
  String get ovRestoreSuccessBody =>
      'Мы нашли вашу подписку и снова включили её на этом устройстве.';

  @override
  String get ovRestoreEmptyTitle => 'Восстанавливать нечего';

  @override
  String get ovRestoreEmptyBody =>
      'С этим аккаунтом магазина не связана активная подписка.';

  @override
  String get ovRestoreOtherTitle => 'Этот план привязан к другому аккаунту';

  @override
  String get ovRestoreOtherBody =>
      'Эта подписка уже активна в другом аккаунте BeaverTalk.';

  @override
  String get ctaSignInThatAccount => 'Войти в тот аккаунт';

  @override
  String get ctaGetHelp => 'Получить помощь';

  @override
  String get ovCharacterOfferTitle => 'Не готовы к Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Выберите одного персонажа — и он ваш. Разовая покупка: без подписки и без продлений.';

  @override
  String get rowOneCharacter => 'Один персонаж';

  @override
  String rowFromPrice(String price) {
    return 'от $price';
  }

  @override
  String get rowYoursForever => 'Ваш навсегда';

  @override
  String get rowNoRenewal => 'Без продления';

  @override
  String get rowWorksOnFree => 'Работает на Free';

  @override
  String get rowYes => 'Да';

  @override
  String get ctaSeeCharacters => 'Посмотреть персонажей';

  @override
  String get ovNotEligibleTitle => 'Отменять нечего';

  @override
  String get ovNotEligibleBody =>
      'Вы на Free. На этом аккаунте нет активной подписки.';

  @override
  String get ovCancelDownsellTitle => 'Прежде чем уйти';

  @override
  String get ovCancelDownsellBody =>
      'Отмена выполняется в магазине. Две вещи, которые стоит знать.';

  @override
  String get rowPayYearlyInstead => 'Платите раз в год';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price в месяц';
  }

  @override
  String get rowCharactersYouBought => 'Купленные персонажи';

  @override
  String get rowProRunsUntil => 'Pro действует до';

  @override
  String get ctaSwitchToYearly => 'Перейти на годовой';

  @override
  String get ctaContinueToStore => 'Перейти в магазин';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Платите раз в год — экономия $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Вы на Pro уже два месяца. Годовой план выходит дешевле.';

  @override
  String get rowYouSave => 'Вы экономите';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Годовой';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Помесячно за год';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Переход на помесячную оплату';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Ваш годовой план действует до $date. Помесячная оплата начнётся на следующий день.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Помесячная оплата начнётся';

  @override
  String get rowMonthlyLabel => 'Помесячно';

  @override
  String get rowYearlyWorkedOut => 'Годовой выходил по';

  @override
  String get ctaSwitchToMonthly => 'Перейти на помесячный';

  @override
  String get ovRefundHelpTitle => 'Возвраты оформляет магазин';

  @override
  String get ovRefundHelpBody =>
      'Мы не можем оформить возврат сами. Каждый запрос рассматривает магазин.';

  @override
  String get ctaGoToStore => 'Перейти в магазин';

  @override
  String get ovTrialEndingTitle => 'Пробный период заканчивается завтра';

  @override
  String get ovTrialEndingBody =>
      'Max продолжит работать, если не отменить. Вот что произойдёт.';

  @override
  String get rowTrialEnds => 'Пробный период заканчивается';

  @override
  String get rowFirstCharge => 'Первое списание';

  @override
  String get rowThenMonthly => 'Затем ежемесячно';

  @override
  String get ctaCancelInStore => 'Отменить в магазине';

  @override
  String get ovTrialStartTitle => '7 дней Max бесплатно';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Бесплатно до $date. Затем $price в месяц, если не отменить в магазине.';
  }

  @override
  String get ctaStart7Days => 'Начать 7 дней бесплатно';

  @override
  String get ovOtoTitle => 'Ещё кое-что перед началом';

  @override
  String get ovOtoBody =>
      'Отличный выбор — безлимитные звонки уже включены. Тот же Pro обойдётся дешевле при оплате за год.';

  @override
  String get ovFailedDeclinedTitle => 'Ваша карта отклонена';

  @override
  String get ovFailedDeclinedBody =>
      'Магазин не смог провести платёж. Ничего не списано.';

  @override
  String get ctaUpdatePaymentMethod => 'Обновить способ оплаты';

  @override
  String get ovFailedCanceledTitle => 'Платёж отменён';

  @override
  String get ovFailedCanceledBody =>
      'Вы по-прежнему на Free. Ничего не списано.';

  @override
  String get ovFailedStoreTitle => 'Что-то пошло не так';

  @override
  String get ovFailedStoreBody =>
      'Не удалось связаться с магазином. Ничего не списано.';

  @override
  String get ovAlreadyTitle => 'Вы уже на Pro';

  @override
  String get ovAlreadyBody =>
      'У этого аккаунта магазина уже есть активный план. Покупать нечего.';

  @override
  String get ctaSeeMySubscription => 'Моя подписка';

  @override
  String get subCancelTitle => 'Отмена подписки';

  @override
  String subCancelBody(String date) {
    return 'Pro действует до $date. После этого вы перейдёте на Free.';
  }

  @override
  String get subWhatYouLose => 'Что вы потеряете';

  @override
  String get benefitCalls15 => 'Безлимитные звонки по 15 минут';

  @override
  String get benefitScoring => 'Оценка произношения по каждой букве';

  @override
  String get benefitEveryCharacter => 'Все персонажи, без ограничений';

  @override
  String get ctaKeepPro => 'Оставить Pro';

  @override
  String get subPaymentTitle => 'Обновление оплаты';

  @override
  String get subPaymentBody =>
      'Не удалось списать оплату. Pro продолжает работать в течение льготного периода.';

  @override
  String get subHowToFix => 'Как это исправить';

  @override
  String get fixStep1 => 'Откройте магазин и обновите способ оплаты';

  @override
  String get fixStep2 => 'Вернитесь — план возобновится автоматически';

  @override
  String get fixStep3 => 'Двойных списаний не будет';

  @override
  String get subResubTitle => 'Возобновление подписки';

  @override
  String subResubBody(String date) {
    return 'Pro заканчивается $date. Включите автопродление снова — и ничего не изменится.';
  }

  @override
  String get subWhatYouKeep => 'Что у вас останется';

  @override
  String get ctaTurnItBackOn => 'Включить снова';

  @override
  String get flTodayTitle => 'Это был звонок на сегодня';

  @override
  String get flTodayBody => 'Продолжите с того же места — прямо сейчас.';

  @override
  String get flCheckTitle => 'Это была проверка на сегодня';

  @override
  String get flCheckBody =>
      'На Free — одна проверка в день. Pro делает их безлимитными.';

  @override
  String get flBenefitCalls => 'Безлимитные звонки с Pro · по 15 минут';

  @override
  String get flBenefitChecks => 'Безлимитные проверки произношения с Pro';

  @override
  String flCaption(String price) {
    return '$price в месяц · отмена в любой момент';
  }

  @override
  String flUsage(String used, String limit) {
    return 'Использовано $used из $limit';
  }

  @override
  String get ctaMaybeTomorrow => 'Может, завтра';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get nicknameLabel => 'Никнейм';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Способ входа';

  @override
  String get joinedLabel => 'Дата регистрации';

  @override
  String get editNicknameTitle => 'Изменить никнейм';

  @override
  String get nicknameRule => '2–12 символов. Буквы и цифры. Только английские';

  @override
  String get ctaSave => 'Сохранить';

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
  String get paywallLeaveTitle => 'Если уйдёте сейчас, подписка не оформится';

  @override
  String get paywallLeaveBody =>
      'Преимущества открываются сразу после оплаты. Вернуться можно в любой момент со страницы Моя страница.';

  @override
  String get ctaKeepLooking => 'Продолжить просмотр';

  @override
  String get ctaLeaveAnyway => 'Всё равно уйти';

  @override
  String get iapCharacterSuccessTitle => 'К вам присоединился новый друг!';

  @override
  String get iapCharacterSuccessBody =>
      'Этот персонаж ваш навсегда — он останется даже при смене плана, а «Восстановить покупки» вернёт его на любом устройстве.';

  @override
  String get iapCharacterFailedBody =>
      'Покупка не прошла. Деньги не списаны — попробуйте ещё раз.';

  @override
  String get noAccentDataTitle => 'Данных об интонации пока нет';

  @override
  String get noAccentDataBody =>
      'Продолжайте общаться — особенности вашей интонации накопятся.';

  @override
  String get noLevelYetTitle => 'Уровня пока нет';

  @override
  String get noLevelYetBody =>
      'Завершите первый звонок, чтобы узнать свой уровень.';

  @override
  String get noPronunciationDataTitle => 'Записей о произношении пока нет';

  @override
  String get noPronunciationDataBody =>
      'Мы анализируем произношение по фразам, которые вы говорите во время звонка.';

  @override
  String get noCharacterNote => 'Пока ничего не сказано';

  @override
  String get noPhonemesYet => 'Пока нет звуков для анализа';

  @override
  String get noSentencesYet => 'Пока нет предложений для анализа';

  @override
  String get takeLevelTest => 'Пройти тест уровня';

  @override
  String get reviewToSeeScore => 'Повторите, чтобы увидеть оценку произношения';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get difficultySlow => 'Медленно';

  @override
  String get difficultyNormal => 'Обычно';

  @override
  String get difficultyFast => 'Быстро';

  @override
  String get difficultyLabel => 'Сложность';

  @override
  String get connected => 'Подключено';

  @override
  String get unlockedWithMax => 'Доступно с Max';

  @override
  String get callModeSheetTitle => 'Как хочешь говорить?';

  @override
  String get callModeSheetSubtitle => 'Применится к этому звонку сразу';

  @override
  String get callModeFreeTalk => 'Свободный разговор';

  @override
  String get callModeFreeTalkDesc => 'Говори без исправлений';

  @override
  String get callModeStudy => 'Изучение';

  @override
  String get callModeStudyDesc => 'Учи по одному выражению за раз';

  @override
  String get callModeChange => 'Сменить режим';

  @override
  String get callModeKeep => 'Не сейчас';

  @override
  String get callExitTitle => 'Завершить звонок?';

  @override
  String get callExitSubtitle =>
      'Завершение сейчас всё равно использует один звонок';

  @override
  String get callExitKeep => 'Продолжить разговор';

  @override
  String get callExitConfirm => 'Завершить звонок';

  @override
  String get callMicMute => 'Выключить микрофон';

  @override
  String get callMicUnmute => 'Включить микрофон';

  @override
  String get callPushToTalk => 'Удерживай, чтобы говорить';

  @override
  String get callFreeEndedTitle => 'Бесплатный звонок закончился';

  @override
  String get callFreeEndedCta => 'Оформить подписку и продолжить';

  @override
  String get callKeepGoingTitle => 'Продолжим?';

  @override
  String get callKeepGoingSubtitle =>
      'Звонки идут отрезками по 5 минут. Мы будем спрашивать каждый раз.';

  @override
  String get articulationSelectedWord => 'Выбранное слово';

  @override
  String get articulationYouSaid => 'Ваше произношение';

  @override
  String get articulationTargetSound => 'Цель';

  @override
  String get reportEntry => 'Пожаловаться';

  @override
  String get reportTitle => 'Жалоба';

  @override
  String get reportPrompt => 'В чём была проблема?';

  @override
  String get reportGuide =>
      'Расскажите, какой контент ИИ-персонажа вас смутил. Мы рассматриваем каждую жалобу.';

  @override
  String get reportReasonSexual => 'Сексуальный контент';

  @override
  String get reportReasonHate => 'Ненависть или дискриминация';

  @override
  String get reportReasonViolence => 'Насилие или угрозы';

  @override
  String get reportReasonSelfHarm => 'Побуждение к самоповреждению';

  @override
  String get reportReasonMisinfo => 'Ложная информация';

  @override
  String get reportReasonOther => 'Другая проблема';

  @override
  String get reportDetailHint => 'Опишите, что произошло (необязательно)';

  @override
  String get reportSubmit => 'Отправить жалобу';

  @override
  String get reportDoneTitle => 'Жалоба принята';

  @override
  String get reportDoneBody =>
      'Мы рассмотрим её и примем меры при необходимости. Спасибо, что помогаете сохранять BeaverTalk безопасным.';

  @override
  String get reportFailed => 'Не удалось отправить жалобу. Попробуйте ещё раз.';
}
