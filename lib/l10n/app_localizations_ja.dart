// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return '通話終了 $duration';
  }

  @override
  String get callRatingPrompt => '通話はいかがでしたか？';

  @override
  String get ratingBad => 'いまいち';

  @override
  String get ratingOkay => 'まあまあ';

  @override
  String get ratingGood => 'よかった';

  @override
  String get goHome => 'ホーム';

  @override
  String get viewAnalysis => '分析を見る';

  @override
  String get loadingShort => '読み込み中…';

  @override
  String ratingSubmitFailed(String message) {
    return '評価の送信に失敗しました: $message';
  }

  @override
  String get callInfoNotFound => '通話情報が見つからないため、分析をスキップします。';

  @override
  String get tabRecords => '記録';

  @override
  String get tabArchive => '保存済み';

  @override
  String get callHistory => '通話履歴';

  @override
  String get conversationRecord => '会話の記録';

  @override
  String get noCallRecords => '通話記録がまだありません';

  @override
  String get noCallRecordsBody => 'AIとの最初の通話を終えると、\nここに記録が表示されます。';

  @override
  String get startCall => '通話を始める';

  @override
  String get recordsLoadError => '記録を読み込めませんでした';

  @override
  String get tryAgainLater => 'しばらくしてからもう一度お試しください。';

  @override
  String get retry => '再試行';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String get scheduleManagement => 'スケジュール';

  @override
  String get alarms => 'アラーム';

  @override
  String get addSchedule => 'スケジュールを追加';

  @override
  String get editSchedule => 'スケジュールを編集';

  @override
  String get somethingWentWrong => '問題が発生しました';

  @override
  String get alarmsLoadError => 'アラームを読み込めませんでした';

  @override
  String get charactersLoadError => 'キャラクターを読み込めませんでした';

  @override
  String get noCharacters => '利用できるキャラクターがありません';

  @override
  String get close => '閉じる';

  @override
  String get repeat => '繰り返し';

  @override
  String get callPartner => 'キャラクター';

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
  String get am => '午前';

  @override
  String get pm => '午後';

  @override
  String get save => '保存';

  @override
  String get conversation => '会話';

  @override
  String get review => '復習';

  @override
  String get pronunciationChallenge => '発音チャレンジ';

  @override
  String get newExpressions => '新しい表現';

  @override
  String get analysisResult => '分析結果';

  @override
  String get noNewExpressions => 'この会話からの新しい表現はありません。';

  @override
  String get practice => '練習';

  @override
  String recentScore(int score) {
    return '最近のスコア $score%';
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
  String get analysisLoadError => '分析結果を読み込めませんでした。';

  @override
  String get standardAudioNotReady => 'お手本の発音音声はまだ準備できていません。';

  @override
  String get standardAudioPlayError => 'お手本の発音音声を再生できませんでした。';

  @override
  String get selectACountry => '国を選択';

  @override
  String get selectYourLanguage => '言語を選択';

  @override
  String get confirm => '確定';

  @override
  String get cancel => 'キャンセル';

  @override
  String get selectTime => '時間を選択';

  @override
  String get getStarted => 'はじめる';

  @override
  String get permissionTitle => '快適にご利用いただくため\n権限を許可してください';

  @override
  String get permissionSubtitle => '必要な権限はサービスの利用に不可欠です。';

  @override
  String get permissionMicTitle => 'マイク（必須）';

  @override
  String get permissionMicDesc => 'AIと会話するために必要です。';

  @override
  String get permissionNotifTitle => '通知（任意）';

  @override
  String get permissionNotifDesc => '学習リマインダーや通話スケジュールをお送りします。';

  @override
  String get micPermissionNeededTitle => 'マイクへのアクセスが必要です';

  @override
  String get micPermissionNeededBody =>
      'AIと話すには、マイクへのアクセスを許可する必要があります。設定で有効にしてください。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get connectionFailedTitle => '接続に失敗しました';

  @override
  String get connectionFailedBody => 'ネットワーク接続を確認して\nもう一度お試しください。';

  @override
  String get checkout => 'お支払い';

  @override
  String get pay => '支払う';

  @override
  String get orderSummary => '注文内容';

  @override
  String get paymentMethod => '支払い方法';

  @override
  String get payMethodCard => 'クレジット / デビットカード';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Annoying Beaver アバター';

  @override
  String get productTrait => 'プレミアムキャラクター · ずっとあなたのもの';

  @override
  String get amountItemPrice => '商品価格';

  @override
  String get amountDiscount => '割引';

  @override
  String get amountTotal => '合計';

  @override
  String get paymentCompleteTitle => '支払いが完了しました';

  @override
  String get paymentCompleteBody => 'アバターがコレクションに追加されました。';

  @override
  String get viewCollection => 'コレクションを見る';

  @override
  String get receiptItem => '商品';

  @override
  String get receiptAmount => '金額';

  @override
  String get receiptMethod => '支払い方法';

  @override
  String get receiptDate => '日付';

  @override
  String get paymentFailedTitle => '支払いに失敗しました';

  @override
  String get paymentFailedBody => 'お支払いを処理できませんでした。\nもう一度お試しください。';

  @override
  String get freeCallEndingTitle => '無料通話がまもなく終了します';

  @override
  String get freeCallEndingBody => '定期購入すると、ビーバーともっと長く話せます。';

  @override
  String get subscribe => '定期購入';

  @override
  String get endCall => '通話を終了';

  @override
  String get callEnded => '通話が終了しました。';

  @override
  String get connecting => '接続中…';

  @override
  String get connectingHint => '通常5秒以内に接続します';

  @override
  String get callConnectFailed => '通話に接続できませんでした。';

  @override
  String get saveSentenceFailed => '文を保存できませんでした。';

  @override
  String get recordStartFailed => '録音を開始できませんでした。';

  @override
  String get recordTooShort => '録音が短すぎます。もう一度お試しください。';

  @override
  String get gradingFailed => '採点に失敗しました。もう一度お試しください。';

  @override
  String get listenStandard => 'お手本の発音を聞く';

  @override
  String get saveSentence => '文を保存';

  @override
  String get unsaveSentence => '保存した文を削除';

  @override
  String get scoringPronunciation => '発音を採点しています…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => '再生する録音がありません。';

  @override
  String get myRecordingPlayError => '録音を再生できませんでした。';

  @override
  String get next => '次へ';

  @override
  String get endLearning => 'セッションを終了';

  @override
  String get navCalendar => 'カレンダー';

  @override
  String get navCall => '通話';

  @override
  String get navStats => '統計';

  @override
  String get myPage => 'マイページ';

  @override
  String get languageSaveFailed => '言語を保存できませんでした。';

  @override
  String get accountDeleteFailed => 'アカウントを削除できませんでした。';

  @override
  String get changeAvatar => 'アバターを変更';

  @override
  String get avatarIntro => '通話相手によって声や難易度が異なります。\n一部の相手は購入が必要な場合があります。';

  @override
  String myPartnersOwned(int count) {
    return 'マイパートナー · $count体所有';
  }

  @override
  String get limitedDiscount => '期間限定割引';

  @override
  String get available => '利用可能';

  @override
  String get inUse => '使用中';

  @override
  String get owned => '所有済み';

  @override
  String get noCharactersToShow => '表示するキャラクターがありません';

  @override
  String get buy => '購入';

  @override
  String get noSavedSentences => '保存した文がまだありません。\n会話の記録から文をブックマークしましょう。';

  @override
  String get noAlarms => 'アラームがまだありません';

  @override
  String get noAlarmsBody => '学習リマインダーを追加して\n習慣を作りましょう。';

  @override
  String get subscriptionManage => '定期購入の管理';

  @override
  String get changePlan => 'プランを変更';

  @override
  String get cancelSubscription => '定期購入を解約';

  @override
  String get benefitsInUse => '利用中の特典';

  @override
  String get paymentInfo => '支払い情報';

  @override
  String get nextBillingDate => '次回請求日';

  @override
  String get lostBenefitsTitle => '解約すると失う特典';

  @override
  String get viewBillingHistory => '請求履歴を見る';

  @override
  String get keepUsingPro => 'Proを続ける';

  @override
  String get proMembership => 'Pro メンバーシップ';

  @override
  String get pricePerMonth => '\$12.9 / 月';

  @override
  String get benefitUnlimitedCalls => '無制限の通話';

  @override
  String get benefitDetailedAnalysis => '詳細な発音・文法分析';

  @override
  String get benefitAllCharacters => 'すべてのキャラクターを利用可能';

  @override
  String get benefitNoAds => '広告なし';

  @override
  String get playSampleVoice => 'サンプル音声を再生';

  @override
  String get useThisAvatar => '使用する';

  @override
  String get challengeTitle => '発音チャレンジ';

  @override
  String get challengeIntro =>
      'ゾーン内のカードを韓国語で正しく発音してクリアしましょう。\nマイクがなくても、画面をタップしてプレイできます。';

  @override
  String get challengeStart => 'カメラとマイクを開始';

  @override
  String get challengePermissionNote => '前面カメラとマイクへのアクセスが必要です（任意）。';

  @override
  String get challengeLoadingTitle => '読み込み中…';

  @override
  String get challengeLoadingNote =>
      '初回は韓国語の音声モデル（約82MB）をダウンロードします。\n少々お待ちください。';

  @override
  String get challengeSttFallback => '音声認識が利用できなかったため、タップ入力でプレイしました。';

  @override
  String get reasonTravelTitle => '旅行で話す';

  @override
  String get reasonTravelDesc => '現地で自信を持って会話';

  @override
  String get reasonCareerTitle => '仕事・キャリア';

  @override
  String get reasonCareerDesc => 'ビジネス会話';

  @override
  String get reasonExamTitle => '試験対策';

  @override
  String get reasonExamDesc => 'スピーキング試験の準備';

  @override
  String get reasonDailyTitle => '日常会話';

  @override
  String get reasonDailyDesc => '毎日使う表現';

  @override
  String get reasonFriendsTitle => '外国人の友達を作る';

  @override
  String get reasonFriendsDesc => '自然な会話';

  @override
  String get reasonBrainTitle => '脳の活性化';

  @override
  String get reasonBrainDesc => '記憶力・集中力アップ';

  @override
  String get challengeRecordToggle => 'このプレイを録画';

  @override
  String get challengeRecordHint => 'プレイ動画を保存してシェアできます（無音）。';

  @override
  String get settingsSection => '設定';

  @override
  String get paymentSection => '決済';

  @override
  String get supportSection => 'サポート';

  @override
  String get userLanguage => '表示言語';

  @override
  String get learningLanguage => '学習言語';

  @override
  String get learningLanguageKorean => '韓国語';

  @override
  String get notificationLabel => '通知';

  @override
  String get currentPlan => '現在のプラン';

  @override
  String get paymentHistory => '支払い履歴';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get logOut => 'ログアウト';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountBody => 'アカウントとデータが完全に削除され、元に戻せません。';

  @override
  String get delete => '削除';

  @override
  String get share => 'シェア';

  @override
  String get accentSoundsLike => 'あなたの韓国語アクセントは';

  @override
  String get hintLabel => 'ヒント';

  @override
  String get nextHint => '次のヒント';

  @override
  String get translateLabel => '翻訳';

  @override
  String get startRecording => '録音を開始';

  @override
  String get stopRecording => '録音を停止';

  @override
  String get back => '戻る';

  @override
  String get onboardingNameTitle => '何とお呼びすればいいですか?';

  @override
  String get onboardingNameSubtitle => 'AIチューターがあなたの名前を覚えます。';

  @override
  String get nameLabel => 'お名前';

  @override
  String get nameHint => '名前を入力してください';

  @override
  String get nameHelper => '本名でなくても大丈夫です。ニックネームでもかまいません。';

  @override
  String get continueLabel => '続ける';

  @override
  String get onboardingDoneTitle => 'ビーバーがあなたの電話を待っています';

  @override
  String get onboardingDoneSubtitle => '今すぐ通話を始めましょう';

  @override
  String get home => 'ホーム';

  @override
  String get callNow => '今すぐ通話';

  @override
  String get pronunciation => '発音';

  @override
  String get fluency => '流暢さ';

  @override
  String get rhythm => 'リズム';

  @override
  String get analysisTimeout => '予想より時間がかかっています。しばらくしてからもう一度お試しください。';

  @override
  String get analysisFailed => '会話を分析できませんでした。もう一度お試しください。';

  @override
  String get analyzingConversation => '会話を分析しています…';

  @override
  String get analyzingSubtitle => '少しだけお待ちください';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get nativeLabel => 'ネイティブ';

  @override
  String get meLabel => '自分';

  @override
  String get pronunciationPlayError => '発音の音声を再生できませんでした。';

  @override
  String get savedExpressionsLoadError => '保存した表現を読み込めませんでした。';

  @override
  String get mySavedExpressions => '保存した表現';

  @override
  String get avatarTraits => '温かい・穏やか・優しい';

  @override
  String get priceFree => '無料';

  @override
  String get loginGoogleTokenError => 'Googleサインイントークンを取得できませんでした。';

  @override
  String get loginGoogleSignInFailed => 'Googleサインインに失敗しました。';

  @override
  String get loginAppleSignInFailed => 'Appleサインインに失敗しました。';

  @override
  String get loginKakaoSignInFailed => 'Kakaoサインインに失敗しました。';

  @override
  String get loginContinueWithKakao => 'Kakaoで続ける';

  @override
  String get loginContinueWithGoogle => 'Googleで続ける';

  @override
  String get loginContinueWithApple => 'Appleで続ける';

  @override
  String get loginContinueWithEmail => 'メールで続ける';

  @override
  String get loginOrDivider => 'または';

  @override
  String get loginNoAccount => 'アカウントをお持ちでないですか？';

  @override
  String get signUp => '新規登録';

  @override
  String get loginTermsNoticePrefix => '続行することで、';

  @override
  String get loginTermsNoticeAnd => 'および';

  @override
  String get loginTermsNoticeSuffix => 'に同意したものとみなされます。';

  @override
  String get loginLogIn => 'ログイン';

  @override
  String get fieldEmailLabel => 'メールアドレス';

  @override
  String get emailHint => 'メールアドレスを入力してください';

  @override
  String get fieldPasswordLabel => 'パスワード';

  @override
  String get passwordHint => 'パスワードを入力してください';

  @override
  String get loginRememberMe => 'ログイン情報を保存';

  @override
  String get loginForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get loginLoggingIn => 'ログイン中...';

  @override
  String get passwordLengthError => 'パスワードは8〜16文字で入力してください。';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません。';

  @override
  String get signupCheckInput => '入力内容をご確認ください。';

  @override
  String get fieldConfirmPasswordLabel => 'パスワード（確認）';

  @override
  String get confirmPasswordHint => 'パスワードを再入力してください';

  @override
  String get signupSigningUp => '登録中...';

  @override
  String get signupHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get passwordMethodEmailRequired => 'メールアドレスを入力してください';

  @override
  String get passwordResetTitle => 'パスワードの再設定';

  @override
  String get passwordMethodDescription => 'パスワード再設定コードを受け取るメールアドレスを入力してください。';

  @override
  String get emailAddressHint => 'メールアドレス';

  @override
  String get passwordMethodSending => '送信中...';

  @override
  String get passwordMethodSendEmail => 'メールを送信';

  @override
  String get passwordCodeTitle => 'コードを入力';

  @override
  String get passwordCodeDescription => 'メールに再設定コードを送信しました。コードを入力して続行してください。';

  @override
  String get passwordCodeNoCode => 'コードが届きませんか？';

  @override
  String get passwordCodeResend => 'コードを再送信';

  @override
  String get passwordCodeVerifying => '確認中...';

  @override
  String get passwordNewTitle => '新しいパスワード';

  @override
  String get passwordNewDescription => 'アカウントの新しいパスワードを設定してください。';

  @override
  String get fieldNewPasswordLabel => '新しいパスワード';

  @override
  String get newPasswordHint => '新しいパスワードを入力してください';

  @override
  String get fieldConfirmNewPasswordLabel => '新しいパスワード（確認）';

  @override
  String get confirmNewPasswordHint => '新しいパスワードを再入力してください';

  @override
  String get passwordNewSubmitting => '送信中...';

  @override
  String get passwordNewSubmit => '送信';

  @override
  String get passwordCompleteTitle => 'パスワードの再設定が完了しました';

  @override
  String get passwordCompleteBody => 'パスワードが再設定されました。新しいパスワードでログインして続行してください。';

  @override
  String get termsTitle => '利用規約';

  @override
  String get privacyTitle => 'プライバシーポリシー';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email の新しいパスワードを設定してください。';
  }

  @override
  String get selectComplete => '完了';

  @override
  String get onboardingLanguageTitle => '母国語は何ですか?';

  @override
  String get onboardingReasonTitle => 'なぜ言語を学んでいますか?';

  @override
  String get onboardingReasonSubtitle => '目標に合わせて学習をカスタマイズします。';

  @override
  String get savingLabel => '保存中...';

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
