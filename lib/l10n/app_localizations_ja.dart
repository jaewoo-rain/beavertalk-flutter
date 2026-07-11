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
}
