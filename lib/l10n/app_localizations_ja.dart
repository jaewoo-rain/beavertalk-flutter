// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get loginRequired => 'ログインが必要です。';

  @override
  String get callWebNotSupported => 'ウェブでは音声通話をご利用いただけません。アプリからご利用ください。';

  @override
  String get micPermissionRequiredForCall => 'マイクの許可が必要です。通話するにはマイクを許可してください。';

  @override
  String get callErrorGeneric => '通話中にエラーが発生しました。';

  @override
  String get callNetworkError => 'ネットワークエラーが発生しました。';

  @override
  String get authInvalidCredentials => 'メールアドレスまたはパスワードが正しくありません。';

  @override
  String get authEmailAlreadyRegistered => 'このメールアドレスは既に登録されています。';

  @override
  String get authConfirmEmailRequired => 'メールに送信された認証を完了してください。';

  @override
  String get authResetCodeSent => '認証コードをメールに送信しました。';

  @override
  String get authResetCodeInvalid => '認証コードが正しくないか、有効期限が切れています。';

  @override
  String get authPasswordUpdated => 'パスワードを再設定しました。';

  @override
  String get authAppleTokenMissing => 'Appleサインインのトークンを取得できませんでした。';

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
  String get quickStart => 'クイックスタート';

  @override
  String get presetMorning => '朝のルーティン';

  @override
  String get presetMorningSub => '平日 8:00';

  @override
  String get presetEvening => '夜のまとめ';

  @override
  String get presetEveningSub => '毎日 21:00';

  @override
  String get presetCustom => 'カスタム';

  @override
  String get presetCustomSub => '自由に設定';

  @override
  String alarmSummary(int count, int monthly) {
    return '週$count回 · 月$monthly回の通話';
  }

  @override
  String get alarmSummaryNone => '曜日を1つ以上選んでください';

  @override
  String get partnerInUse => '使用中';

  @override
  String get partnerOwned => '保有中';

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
    return '$count回目の通話';
  }

  @override
  String characterNoteTitle(String name) {
    return '$nameからひとこと';
  }

  @override
  String characterNoteFooter(String name) {
    return '通話直後に$nameが残しました';
  }

  @override
  String newExpressionsCount(int count) {
    return '新しい表現 $count';
  }

  @override
  String get analysisLoadError => '分析結果を読み込めませんでした。';

  @override
  String get standardAudioNotReady => 'お手本の発音音声はまだ準備できていません。';

  @override
  String get standardAudioPlayError => 'お手本の発音音声を再生できませんでした。';

  @override
  String get selectNativeLanguage => '母国語を選択してください';

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
  String get analyzingByWord => '発音を単語ごとに確認しています';

  @override
  String get analyzingTakingLonger => 'もう少し時間がかかっています';

  @override
  String get scanConnectionLost => '接続が切れました';

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
  String pricePerMonth(String price) {
    return '$price / 月';
  }

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
  String get loginFacebookSignInFailed => 'Facebookサインインに失敗しました。';

  @override
  String get loginKakaoSignInFailed => 'Kakaoサインインに失敗しました。';

  @override
  String get loginContinueWithKakao => 'Kakaoで続ける';

  @override
  String get loginContinueWithGoogle => 'Googleで続ける';

  @override
  String get loginContinueWithFacebook => 'Facebookで続ける';

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
  String get thisMonthPayment => '今月の決済金額';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterSubscription => 'サブスク';

  @override
  String get filterCharacter => 'キャラクター';

  @override
  String get statusCompleted => '完了';

  @override
  String get lastPayment => '最近の決済';

  @override
  String subscriptionSwitchNote(String date) {
    return '$dateまでPro特典を引き続きご利用いただけます。その後は自動的に無料プランに切り替わります。';
  }

  @override
  String get freePlanCallLimit => '1日1通話 · 5分制限';

  @override
  String get freePlanBasicCharacters => '基本キャラクター利用可';

  @override
  String get availableForPurchase => '購入可能';

  @override
  String get paymentsLoadError => '決済履歴を読み込めませんでした';

  @override
  String get noPayments => 'まだ決済履歴がありません';

  @override
  String get morePaymentsExist => '以前の決済履歴はまだ表示されません';

  @override
  String get undatedPayments => '日付なし';

  @override
  String get paymentLabelFallback => '決済';

  @override
  String learningPassed(int passed, int total) {
    return '$total文中$passed文が合格';
  }

  @override
  String get hardestSound => '今日いちばん難しかった音';

  @override
  String get soundAccuracy => '音別の正確度';

  @override
  String phonemeAttempts(int count) {
    return '音素単位 · $count回の試行';
  }

  @override
  String get colSound => '音';

  @override
  String get colAttempts => '試行';

  @override
  String get colCorrect => '正解';

  @override
  String get colAccuracy => '正確度';

  @override
  String get sentenceResults => '文ごとの結果';

  @override
  String viewAllSentences(int count) {
    return '$count件すべて見る';
  }

  @override
  String get colSentence => '文';

  @override
  String get colPronunciation => '発音';

  @override
  String get colFluency => '流暢';

  @override
  String get colRhythm => 'リズム';

  @override
  String recentSessions(int count) {
    return '直近$countセッション';
  }

  @override
  String trendAverage(int score) {
    return '平均 $score';
  }

  @override
  String get today => '今日';

  @override
  String get colDate => '日付';

  @override
  String get colSentences => '文数';

  @override
  String get colScore => 'スコア';

  @override
  String get colChange => '変化';

  @override
  String dateToday(String date) {
    return '$date（今日）';
  }

  @override
  String get accentAnalysis => 'アクセント分析';

  @override
  String get overallLevel => '総合レベル';

  @override
  String get overallLevelSubtitle => '語彙・文法・表現';

  @override
  String get pronunciationAnalysis => '発音分析';

  @override
  String get recentSessionsAverage => '直近10セッション平均';

  @override
  String levelStage(int stage) {
    return 'レベル$stage';
  }

  @override
  String topPercent(int percent) {
    return '上位$percent%';
  }

  @override
  String get allLearnersBasis => '全学習者基準';

  @override
  String aheadOfLearners(int percent) {
    return '全学習者の$percent%より進んでいます';
  }

  @override
  String get retakeLevelTest => 'レベルテストを再受験';

  @override
  String get practicePronunciation => '発音を学習する';

  @override
  String get priceChangedTitle => '価格が変更されました';

  @override
  String priceChangedBody(String price) {
    return 'この商品は現在$priceです。続けますか?';
  }

  @override
  String get billingGroupPlanPurchases => 'プランと購入';

  @override
  String get billingGroupInTheStore => 'ストアで';

  @override
  String get billingChangePlan => 'プランを変更';

  @override
  String get billingCompareAllPlans => '全プランを比較';

  @override
  String get billingBuyACharacter => 'キャラクターを購入';

  @override
  String get billingRestorePurchases => '購入を復元';

  @override
  String get billingPaymentHistory => '支払い履歴';

  @override
  String get billingManageInTheStore => 'ストアで管理';

  @override
  String get billingRefundHelp => '返金について';

  @override
  String get billingCancelSubscription => 'サブスクリプションを解約';

  @override
  String get billingResubscribe => '再登録する';

  @override
  String get badgeCurrent => '利用中';

  @override
  String get badgeTrial => '体験中';

  @override
  String get badgeRenewing => '更新予定';

  @override
  String get badgePastDue => '支払い遅延';

  @override
  String get badgePaused => '一時停止中';

  @override
  String get badgeCanceling => '解約予定';

  @override
  String get subscriptionTitle => 'サブスクリプション';

  @override
  String get plansTitle => 'プラン';

  @override
  String get planFree => '無料';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max体験';

  @override
  String get freePlanPriceLine => '\$0.00 — 1日1回の通話';

  @override
  String pricePerMonthLine(String amount) {
    return '月額$amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$dateまで無料';
  }

  @override
  String get todaysCalls => '今日の通話';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit回中$used回使用';
  }

  @override
  String get firstPaymentLabel => '初回の支払い';

  @override
  String get nextPaymentLabel => '次回の支払い';

  @override
  String get retryingUntilLabel => '再試行期限';

  @override
  String get pausedSinceLabel => '一時停止の開始日';

  @override
  String planEndsLabel(String plan) {
    return '$plan終了';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Proで無制限に';

  @override
  String bannerGoUnlimitedSub(String price) {
    return '通話無制限 · 1回15分 · 月額$price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Maxでビデオ通話を';

  @override
  String bannerMaxUpsellSub(String price) {
    return '顔を見ながら通話 · 月額$price';
  }

  @override
  String get bannerAnnualSwitchTitle => '年間プランに切り替え';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '年額$yearly · 月あたり$perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => 'お支払いができませんでした';

  @override
  String get bannerPaymentFailedSub => 'ストアで支払い方法を更新するとProを継続できます';

  @override
  String get bannerPausedTitle => 'プランが一時停止中です';

  @override
  String get bannerPausedSub => 'お支払いが完了しませんでした';

  @override
  String get noteRestoreHint => '別の端末で登録済みですか？復元するとこの端末でも利用できます。';

  @override
  String get noteStoreHandled => '支払い方法・プラン変更・解約はストアで行われます。';

  @override
  String get noteFairUse => '無制限のご利用にはフェアユースポリシーが適用されます。';

  @override
  String noteTrialEnds(String date) {
    return '体験は$dateに終了します。それまでにストアで解約すれば料金はかかりません。';
  }

  @override
  String get noteGrace => '猶予期間中も特典は継続します。解約をアプリが妨げることはありません。';

  @override
  String get noteHold => 'お支払いが完了するまでProは一時停止されます。キャラクターと学習記録は安全に保管されます。';

  @override
  String noteEnding(String date) {
    return 'プランの終了が予定されています。特典は$dateまで有効で、その後は無料プランに移行します。いつでも再登録できます。';
  }

  @override
  String get trialExpiredTitle => 'Max体験が終了しました';

  @override
  String get trialExpiredSub => '現在は無料プランです';

  @override
  String get seePlans => 'プランを見る';

  @override
  String get currentPlanTitle => '現在のプラン';

  @override
  String get badgeRecommended => 'おすすめ';

  @override
  String get perMonthUnit => '/月';

  @override
  String get planTaglinePro => '通話無制限。1回15分。';

  @override
  String get planTaglineMax => '顔を見ながら話せます。';

  @override
  String get planTaglineFree => '1日1回、無料で通話。';

  @override
  String get bulletProCalls => '音声通話が使い放題';

  @override
  String get bulletProLength => '1回の通話は15分';

  @override
  String get bulletProScoring => '一文字ずつ発音を採点';

  @override
  String get bulletProCorrections => '母語に合わせた添削';

  @override
  String get bulletProBeaverCalls => 'ビーバーから電話がかかってくる';

  @override
  String get bulletMaxVideo => '顔を見ながらビデオ通話';

  @override
  String get bulletMaxEverything => 'Proの全機能を含む';

  @override
  String get bulletMaxCharacters => '全キャラクター使い放題';

  @override
  String get bulletMaxStudyBook => 'レベルに合わせたスタディブック';

  @override
  String get bulletMaxWeeklyReport => '発音の変化がわかる週間レポート';

  @override
  String get bulletFreeCall => '1日1回、5分の音声通話';

  @override
  String get bulletFreeCheck => '1日1回の発音チェック';

  @override
  String get bulletFreeAccent => 'アクセントチェック無制限';

  @override
  String get bulletFreeCharacter => 'スタートキャラクター1体';

  @override
  String get ctaGoUnlimited => '無制限にする';

  @override
  String get ctaTurnOnVideo => 'ビデオ通話を始める';

  @override
  String get noteCallLength => '通話は1回15分です。';

  @override
  String get paywallProTitle1 => '深夜3時でも起きている';

  @override
  String get paywallProTitle2 => 'あなたの韓国人の友だち';

  @override
  String get paywallProSub => '通話無制限。1回15分。一年中いつでも。';

  @override
  String get paywallLimitHeadline => 'Proなら制限がなくなります。';

  @override
  String get limitBannerCallTitle => '今日の通話は終わりました';

  @override
  String get limitBannerCallSub => '無料プランは1日1回の通話です';

  @override
  String get limitBannerCheckTitle => '今日のチェックは終わりました';

  @override
  String get limitBannerCheckSub => '無料プランは1日1回のチェックです';

  @override
  String get bulletProCharactersForever => '購入したキャラクターはずっとあなたのもの';

  @override
  String get paywallMaxTitle => '顔を見ながら話せます。';

  @override
  String get paywallMaxSub => 'ビデオ通話、全キャラクター、そしてレベルに合わせたスタディブックまで。';

  @override
  String get planMonthly => '月間';

  @override
  String get planAnnual => '年間';

  @override
  String proMonthlyPriceLine(String price) {
    return '月額$price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · 月あたり$perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '月額$price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '年額$yearly · 月あたり$perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return '月額$price · ストアでいつでも解約できます';
  }

  @override
  String ctaCaptionMax(String price) {
    return '月額$price · ストアでいつでも解約できます';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7日間無料、その後 月額$price · ストアでいつでも解約できます';
  }

  @override
  String get ctaCaptionAutoRenew => '解約するまで自動更新されます。';

  @override
  String get footerTerms => '利用規約';

  @override
  String get footerPrivacy => 'プライバシー';

  @override
  String get noteMaxCharacters =>
      'Maxで解放されたキャラクターはサブスクリプション中に利用できます。購入したキャラクターはずっとあなたのものです。';

  @override
  String get processingTitle => '購入を確認しています';

  @override
  String get processingSub => '通常は数秒で完了します。';

  @override
  String get successProTitle => 'Proが始まりました。';

  @override
  String get successProSub => '今から通話が無制限です。';

  @override
  String get successProBenefit1 => '好きなだけ通話 — 1回15分';

  @override
  String get successProBenefit2 => '発音チェック無制限';

  @override
  String get successProBenefit3 => '全キャラクターと単品購入';

  @override
  String get successMaxTitle => '顔が見えるようになりました。';

  @override
  String get successMaxSub => 'ビデオ通話が有効になりました。通話中にビデオボタンをタップしてください。';

  @override
  String get successMaxBenefit1 => '顔を見ながらビデオ通話';

  @override
  String get successMaxBenefit2 => '全キャラクター無制限、新キャラクターは先行提供';

  @override
  String get successMaxBenefit3 => 'レベルに合わせたスタディブック';

  @override
  String get ctaStartACall => '通話を始める';

  @override
  String get ctaStartAVideoCall => 'ビデオ通話を始める';

  @override
  String get ctaSeeYourSubscription => 'サブスクリプションを見る';

  @override
  String successProCaption(String price) {
    return '解約するまで毎月$priceが請求されます。管理・解約はいつでもストアで行えます。';
  }

  @override
  String successMaxCaption(String price) {
    return '解約するまで毎月$priceが請求されます。管理・解約はいつでもストアで行えます。';
  }

  @override
  String get plansErrorTitle => 'プランを読み込めませんでした';

  @override
  String get plansErrorSub => 'ストアから応答がありませんでした。';

  @override
  String get ctaTryAgain => 'もう一度試す';

  @override
  String get plansErrorCaption => '料金は請求されていません。';

  @override
  String get changePlanTitle => 'プラン変更';

  @override
  String get moveToMaxTitle => 'Maxへ移行';

  @override
  String maxPriceShort(String price) {
    return '月額$price';
  }

  @override
  String get moveToMaxCardSub => '顔を見ながらビデオ通話 · 全キャラクター · あなた専用のスタディブック';

  @override
  String get whatHappensNow => 'この後の流れ';

  @override
  String get maxStartsLabel => 'Max開始';

  @override
  String get immediately => 'すぐに';

  @override
  String get unusedProTime => '未使用のPro期間';

  @override
  String get creditedTowardMax => 'Max料金に充当';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Maxに切り替える';

  @override
  String get upgradeCaption => '新しいプランはすぐに始まります。未使用のPro期間は充当され、二重請求はありません。';

  @override
  String get moveToProTitle => 'Proへ移行';

  @override
  String get moveToProSub => '今日は何も変わりません。お支払い済みの月末までMaxが継続します。';

  @override
  String get maxRunsUntil => 'Maxの有効期限';

  @override
  String get proStarts => 'Pro開始';

  @override
  String get whatYouKeep => '引き続き使えるもの';

  @override
  String get keepBenefitCalls => '音声通話無制限、1回15分';

  @override
  String get keepBenefitCharacters => '購入したキャラクターはずっとあなたのもの';

  @override
  String downgradeWarning(String date) {
    return 'ビデオ通話とMax限定キャラクターは$dateに無効になります。';
  }

  @override
  String get ctaSwitchToPro => 'Proに切り替える';

  @override
  String get ctaKeepMax => 'Maxを続ける';

  @override
  String get winbackSkip => 'スキップ';

  @override
  String get winbackTitle => 'Proプランが終了しました';

  @override
  String get winbackSub => '現在は無料プラン — 1日1回の通話です。';

  @override
  String get winbackQuestion => 'よろしければ、やめた理由を教えてください。';

  @override
  String get winbackReasonExpensive => '料金が高い';

  @override
  String get winbackReasonUnused => 'あまり使っていなかった';

  @override
  String get winbackReasonMissing => '必要な機能がなかった';

  @override
  String get winbackReasonOtherApp => '他のアプリを見つけた';

  @override
  String get winbackReasonElse => 'その他';

  @override
  String get ctaSend => '送信';

  @override
  String get ctaNotNow => '今はしない';

  @override
  String get winbackCaption => 'この回答でプランは復元されません。再登録はストアで行えます。';

  @override
  String get ctaContinue => '続ける';

  @override
  String get ctaClose => '閉じる';

  @override
  String get ovRestoreSuccessTitle => 'Proが戻りました';

  @override
  String get ovRestoreSuccessBody => 'サブスクリプションが見つかり、この端末で再び有効にしました。';

  @override
  String get ovRestoreEmptyTitle => '復元するものがありません';

  @override
  String get ovRestoreEmptyBody => 'このストアアカウントに有効なサブスクリプションはありません。';

  @override
  String get ovRestoreOtherTitle => '別のアカウントのプランです';

  @override
  String get ovRestoreOtherBody => 'このサブスクリプションは別のBeaverTalkアカウントで有効になっています。';

  @override
  String get ctaSignInThatAccount => 'そのアカウントでログイン';

  @override
  String get ctaGetHelp => 'ヘルプを見る';

  @override
  String get ovCharacterOfferTitle => 'Proはまだ迷っていますか？';

  @override
  String get ovCharacterOfferBody =>
      'キャラクターを1体選んでずっと使えます。サブスクリプションも更新もない単品購入です。';

  @override
  String get rowOneCharacter => 'キャラクター1体';

  @override
  String rowFromPrice(String price) {
    return '$priceから';
  }

  @override
  String get rowYoursForever => 'ずっとあなたのもの';

  @override
  String get rowNoRenewal => '更新なし';

  @override
  String get rowWorksOnFree => '無料プランでも使える';

  @override
  String get rowYes => 'はい';

  @override
  String get ctaSeeCharacters => 'キャラクターを見る';

  @override
  String get ovNotEligibleTitle => '解約するものがありません';

  @override
  String get ovNotEligibleBody => '現在は無料プランです。このアカウントに有効なサブスクリプションはありません。';

  @override
  String get ovCancelDownsellTitle => '解約の前に';

  @override
  String get ovCancelDownsellBody => '解約はストアで行います。知っておきたいことが2つあります。';

  @override
  String get rowPayYearlyInstead => '年払いに変えると';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '月あたり$price';
  }

  @override
  String get rowCharactersYouBought => '購入したキャラクター';

  @override
  String get rowProRunsUntil => 'Proの有効期限';

  @override
  String get ctaSwitchToYearly => '年払いに切り替える';

  @override
  String get ctaContinueToStore => 'ストアへ進む';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return '年払いで$savedお得に';
  }

  @override
  String get ovAnnualSwitchBody => 'Proを2か月ご利用中ですね。年間プランのほうが割安です。';

  @override
  String get rowYouSave => '節約額';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => '年間';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => '月払いで1年';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => '月払いに切り替え';

  @override
  String ovMonthlySwitchBody(String date) {
    return '年間プランは$dateまで有効です。月払いはその翌日から始まります。';
  }

  @override
  String get rowMonthlyBillingStarts => '月払い開始';

  @override
  String get rowMonthlyLabel => '月間';

  @override
  String get rowYearlyWorkedOut => '年間プランの月換算';

  @override
  String get ctaSwitchToMonthly => '月払いに切り替える';

  @override
  String get ovRefundHelpTitle => '返金はストアが対応します';

  @override
  String get ovRefundHelpBody => '当社が直接返金することはできません。すべてのリクエストはストアが審査します。';

  @override
  String get ctaGoToStore => 'ストアへ行く';

  @override
  String get ovTrialEndingTitle => '体験は明日終了します';

  @override
  String get ovTrialEndingBody => '解約しない限りMaxは継続します。この後の流れです。';

  @override
  String get rowTrialEnds => '体験終了';

  @override
  String get rowFirstCharge => '初回請求';

  @override
  String get rowThenMonthly => '以降は毎月';

  @override
  String get ctaCancelInStore => 'ストアで解約';

  @override
  String get ovTrialStartTitle => 'Maxを7日間無料で';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$dateまで無料です。その後はストアで解約しない限り月額$priceです。';
  }

  @override
  String get ctaStart7Days => '7日間無料で始める';

  @override
  String get ovOtoTitle => '始める前にもうひとつ';

  @override
  String get ovOtoBody => 'いい選択です — 通話無制限が今有効になりました。同じProでも年払いのほうが割安です。';

  @override
  String get ovFailedDeclinedTitle => 'カードが拒否されました';

  @override
  String get ovFailedDeclinedBody => 'ストアで支払いができませんでした。料金は請求されていません。';

  @override
  String get ctaUpdatePaymentMethod => '支払い方法を更新';

  @override
  String get ovFailedCanceledTitle => '支払いがキャンセルされました';

  @override
  String get ovFailedCanceledBody => '無料プランのままです。料金は請求されていません。';

  @override
  String get ovFailedStoreTitle => '問題が発生しました';

  @override
  String get ovFailedStoreBody => 'ストアに接続できませんでした。料金は請求されていません。';

  @override
  String get ovAlreadyTitle => 'すでにProをご利用中です';

  @override
  String get ovAlreadyBody => 'このストアアカウントには有効なプランがあります。新たに購入するものはありません。';

  @override
  String get ctaSeeMySubscription => 'サブスクリプションを見る';

  @override
  String get subCancelTitle => 'サブスクリプションを解約';

  @override
  String subCancelBody(String date) {
    return 'Proは$dateまで有効です。その後は無料プランに移行します。';
  }

  @override
  String get subWhatYouLose => '失うもの';

  @override
  String get benefitCalls15 => '通話無制限、1回15分';

  @override
  String get benefitScoring => '一文字ずつ発音を採点';

  @override
  String get benefitEveryCharacter => '全キャラクター使い放題';

  @override
  String get ctaKeepPro => 'Proを続ける';

  @override
  String get subPaymentTitle => '支払いを更新';

  @override
  String get subPaymentBody => 'お支払いができませんでした。猶予期間中はProが継続します。';

  @override
  String get subHowToFix => '解決方法';

  @override
  String get fixStep1 => 'ストアを開いて支払い方法を更新する';

  @override
  String get fixStep2 => '戻ってくると、プランは自動的に再開します';

  @override
  String get fixStep3 => '二重請求はありません';

  @override
  String get subResubTitle => '再登録する';

  @override
  String subResubBody(String date) {
    return 'Proは$dateに終了します。自動更新を再びオンにすれば、そのまま続きます。';
  }

  @override
  String get subWhatYouKeep => '引き続き使えるもの';

  @override
  String get ctaTurnItBackOn => '再びオンにする';

  @override
  String get flTodayTitle => '今日の通話は終わりました';

  @override
  String get flTodayBody => '続きから、今すぐ再開しましょう。';

  @override
  String get flCheckTitle => '今日のチェックは終わりました';

  @override
  String get flCheckBody => '無料プランは1日1回のチェックです。Proなら無制限です。';

  @override
  String get flBenefitCalls => 'Proで通話無制限 · 1回15分';

  @override
  String get flBenefitChecks => 'Proで発音チェック無制限';

  @override
  String flCaption(String price) {
    return '月額$price · いつでも解約できます';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit中$used使用';
  }

  @override
  String get ctaMaybeTomorrow => 'また明日にします';

  @override
  String get accountSection => 'アカウント';

  @override
  String get nicknameLabel => 'ニックネーム';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'ログイン方法';

  @override
  String get joinedLabel => '登録日';

  @override
  String get editNicknameTitle => 'ニックネームを編集';

  @override
  String get nicknameRule => '2〜12文字 · 英字と数字のみ使えます';

  @override
  String get ctaSave => '保存';

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
  String get paywallLeaveTitle => '今離れると、購読は開始されません';

  @override
  String get paywallLeaveBody => '特典は決済直後に利用できます。マイページからいつでも戻れます。';

  @override
  String get ctaKeepLooking => '続けて見る';

  @override
  String get ctaLeaveAnyway => 'それでも離れる';

  @override
  String get iapCharacterSuccessTitle => '新しい友だちが仲間入り!';

  @override
  String get iapCharacterSuccessBody =>
      'このキャラクターはずっとあなたのもの。プランが変わっても残り、購入の復元でどの端末でも戻せます。';

  @override
  String get iapCharacterFailedBody => '購入が完了しませんでした。請求は発生していません。もう一度お試しください。';

  @override
  String get noAccentDataTitle => 'まだイントネーションのデータがありません';

  @override
  String get noAccentDataBody => '通話を続けるとイントネーションの特徴が集まります。';

  @override
  String get noLevelYetTitle => 'まだレベルがありません';

  @override
  String get noLevelYetBody => '最初の通話を終えるとレベルが出ます。';

  @override
  String get noPronunciationDataTitle => 'まだ発音の記録がありません';

  @override
  String get noPronunciationDataBody => '通話で話した文から発音を分析します。';

  @override
  String get noCharacterNote => 'まだ残した言葉がありません';

  @override
  String get noPhonemesYet => '分析する音がまだありません';

  @override
  String get noSentencesYet => '分析する文がまだありません';

  @override
  String get takeLevelTest => 'レベルテストを受ける';

  @override
  String get reviewToSeeScore => '復習すると発音スコアが出ます';

  @override
  String get playAgain => 'もう一度';

  @override
  String get difficultySlow => 'ゆっくり';

  @override
  String get difficultyNormal => 'ふつう';

  @override
  String get difficultyFast => 'はやく';

  @override
  String get difficultyLabel => '難易度';

  @override
  String get connected => '接続済み';

  @override
  String get unlockedWithMax => 'Max で利用可能';

  @override
  String get callModeSheetTitle => 'どのように話しますか？';

  @override
  String get callModeSheetSubtitle => 'この通話にすぐ反映されます';

  @override
  String get callModeFreeTalk => 'フリートーク';

  @override
  String get callModeFreeTalkDesc => '訂正なしで気軽に話す';

  @override
  String get callModeStudy => '表現学習';

  @override
  String get callModeStudyDesc => '表現を一つずつ学び発音を直す';

  @override
  String get callModeChange => '話し方を変える';

  @override
  String get callModeKeep => '閉じる';

  @override
  String get callExitTitle => '通話を終了しますか？';

  @override
  String get callExitSubtitle => '今終了しても本日の通話1回が消費されます';

  @override
  String get callExitKeep => '通話を続ける';

  @override
  String get callExitConfirm => '通話終了';

  @override
  String get callMicMute => 'ミュート';

  @override
  String get callMicUnmute => 'ミュート解除';

  @override
  String get callPushToTalk => '押しながら話す';

  @override
  String get callFreeEndedTitle => '無料通話が終了しました';

  @override
  String get callFreeEndedCta => '登録して会話を続ける';

  @override
  String get callKeepGoingTitle => '続けますか？';

  @override
  String get callKeepGoingSubtitle => '通話は5分ごとに続きます。そのたびにお伺いします。';
}
