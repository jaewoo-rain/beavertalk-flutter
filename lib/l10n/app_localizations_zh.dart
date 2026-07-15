// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return '通话结束 $duration';
  }

  @override
  String get callRatingPrompt => '这次通话怎么样？';

  @override
  String get ratingBad => '不太好';

  @override
  String get ratingOkay => '还行';

  @override
  String get ratingGood => '很好';

  @override
  String get goHome => '首页';

  @override
  String get viewAnalysis => '查看分析';

  @override
  String get loadingShort => '加载中…';

  @override
  String ratingSubmitFailed(String message) {
    return '评分提交失败：$message';
  }

  @override
  String get callInfoNotFound => '未找到通话信息，跳过分析。';

  @override
  String get tabRecords => '记录';

  @override
  String get tabArchive => '收藏';

  @override
  String get callHistory => '通话记录';

  @override
  String get conversationRecord => '对话记录';

  @override
  String get noCallRecords => '还没有通话记录';

  @override
  String get noCallRecordsBody => '完成与 AI 的第一次通话后，\n你的记录会显示在这里。';

  @override
  String get startCall => '开始通话';

  @override
  String get recordsLoadError => '无法加载记录';

  @override
  String get tryAgainLater => '请稍后再试。';

  @override
  String get retry => '重试';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes 分 $seconds 秒';
  }

  @override
  String get scheduleManagement => '日程';

  @override
  String get alarms => '闹钟';

  @override
  String get addSchedule => '添加日程';

  @override
  String get editSchedule => '编辑日程';

  @override
  String get somethingWentWrong => '出了点问题';

  @override
  String get alarmsLoadError => '无法加载闹钟';

  @override
  String get charactersLoadError => '无法加载角色';

  @override
  String get noCharacters => '暂无可用角色';

  @override
  String get close => '关闭';

  @override
  String get repeat => '重复';

  @override
  String get callPartner => '角色';

  @override
  String get am => '上午';

  @override
  String get pm => '下午';

  @override
  String get save => '保存';

  @override
  String get conversation => '对话';

  @override
  String get review => '复习';

  @override
  String get pronunciationChallenge => '发音挑战';

  @override
  String get newExpressions => '新表达';

  @override
  String get analysisResult => '分析结果';

  @override
  String get noNewExpressions => '这次对话没有新的表达。';

  @override
  String get practice => '练习';

  @override
  String recentScore(int score) {
    return '最近得分 $score%';
  }

  @override
  String get analysisLoadError => '无法加载分析结果。';

  @override
  String get standardAudioNotReady => '标准发音音频尚未准备好。';

  @override
  String get standardAudioPlayError => '无法播放标准发音音频。';

  @override
  String get selectACountry => '选择国家';

  @override
  String get selectYourLanguage => '选择你的语言';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get selectTime => '选择时间';

  @override
  String get getStarted => '开始使用';

  @override
  String get permissionTitle => '为了流畅的体验\n请允许相关权限';

  @override
  String get permissionSubtitle => '所需权限是使用本服务的必要条件。';

  @override
  String get permissionMicTitle => '麦克风（必需）';

  @override
  String get permissionMicDesc => '与 AI 用韩语对话时需要。';

  @override
  String get permissionNotifTitle => '通知（可选）';

  @override
  String get permissionNotifDesc => '我们会发送学习提醒和通话日程。';

  @override
  String get micPermissionNeededTitle => '需要麦克风权限';

  @override
  String get micPermissionNeededBody => '要与 AI 对话，你需要允许麦克风权限。请在设置中开启。';

  @override
  String get openSettings => '打开设置';

  @override
  String get connectionFailedTitle => '连接失败';

  @override
  String get connectionFailedBody => '请检查你的网络连接\n后重试。';

  @override
  String get checkout => '结账';

  @override
  String get pay => '支付';

  @override
  String get orderSummary => '订单摘要';

  @override
  String get paymentMethod => '支付方式';

  @override
  String get payMethodCard => '信用卡 / 借记卡';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Annoying Beaver 头像';

  @override
  String get productTrait => '高级角色 · 永久拥有';

  @override
  String get amountItemPrice => '商品价格';

  @override
  String get amountDiscount => '折扣';

  @override
  String get amountTotal => '合计';

  @override
  String get paymentCompleteTitle => '支付完成';

  @override
  String get paymentCompleteBody => '头像已添加到你的收藏。';

  @override
  String get viewCollection => '查看收藏';

  @override
  String get receiptItem => '商品';

  @override
  String get receiptAmount => '金额';

  @override
  String get receiptMethod => '支付方式';

  @override
  String get receiptDate => '日期';

  @override
  String get paymentFailedTitle => '支付失败';

  @override
  String get paymentFailedBody => '无法处理你的支付。\n请重试。';

  @override
  String get freeCallEndingTitle => '你的免费通话即将结束';

  @override
  String get freeCallEndingBody => '订阅后即可与 Beaver 聊更久。';

  @override
  String get subscribe => '订阅';

  @override
  String get endCall => '结束通话';

  @override
  String get callEnded => '通话已结束。';

  @override
  String get connecting => '连接中…';

  @override
  String get connectingHint => '通常不到 5 秒即可连接';

  @override
  String get callConnectFailed => '无法接通通话。';

  @override
  String get saveSentenceFailed => '无法保存句子。';

  @override
  String get recordStartFailed => '无法开始录音。';

  @override
  String get recordTooShort => '录音太短了。请重试。';

  @override
  String get gradingFailed => '评分失败。请重试。';

  @override
  String get listenStandard => '听标准发音';

  @override
  String get saveSentence => '保存句子';

  @override
  String get unsaveSentence => '移除已保存的句子';

  @override
  String get scoringPronunciation => '正在为你的发音评分…';

  @override
  String get noRecordingToPlay => '没有可播放的录音。';

  @override
  String get myRecordingPlayError => '无法播放你的录音。';

  @override
  String get next => '下一个';

  @override
  String get endLearning => '结束本次学习';

  @override
  String get navCalendar => '日历';

  @override
  String get navCall => '通话';

  @override
  String get navStats => '统计';

  @override
  String get myPage => '我的';

  @override
  String get languageSaveFailed => '无法保存你的语言。';

  @override
  String get accountDeleteFailed => '无法删除你的账号。';

  @override
  String get changeAvatar => '更换头像';

  @override
  String get avatarIntro => '不同通话对象的声音和难度各不相同。\n部分对象可能需要付费。';

  @override
  String myPartnersOwned(int count) {
    return '我的伙伴 · 已拥有 $count 个';
  }

  @override
  String get limitedDiscount => '限时折扣';

  @override
  String get available => '可用';

  @override
  String get inUse => '使用中';

  @override
  String get owned => '已拥有';

  @override
  String get noCharactersToShow => '没有可显示的角色';

  @override
  String get buy => '购买';

  @override
  String get noSavedSentences => '还没有保存的句子。\n在对话记录中收藏你喜欢的句子吧。';

  @override
  String get noAlarms => '还没有闹钟';

  @override
  String get noAlarmsBody => '添加一个学习提醒\n养成坚持的习惯吧。';

  @override
  String get subscriptionManage => '管理订阅';

  @override
  String get changePlan => '更改套餐';

  @override
  String get cancelSubscription => '取消订阅';

  @override
  String get benefitsInUse => '你的权益';

  @override
  String get paymentInfo => '支付信息';

  @override
  String get nextBillingDate => '下次扣款日期';

  @override
  String get lostBenefitsTitle => '取消后你将失去的权益';

  @override
  String get viewBillingHistory => '查看账单记录';

  @override
  String get keepUsingPro => '继续使用 Pro';

  @override
  String get proMembership => 'Pro 会员';

  @override
  String get pricePerMonth => '\$12.9 / mo';

  @override
  String get benefitUnlimitedCalls => '无限通话';

  @override
  String get benefitDetailedAnalysis => '详细的发音与语法分析';

  @override
  String get benefitAllCharacters => '可使用所有角色';

  @override
  String get benefitNoAds => '无广告';

  @override
  String get playSampleVoice => '播放示例声音';

  @override
  String get useThisAvatar => '使用此角色';

  @override
  String get challengeTitle => '发音挑战';

  @override
  String get challengeIntro => '用韩语正确读出区域内的每张卡片即可过关。\n没有麦克风？你也可以点击屏幕来玩。';

  @override
  String get challengeStart => '开启相机和麦克风';

  @override
  String get challengePermissionNote => '需要前置相机和麦克风权限（可选）。';

  @override
  String get challengeLoadingTitle => '加载中…';

  @override
  String get challengeLoadingNote => '首次运行会下载韩语语音模型（约 82MB）。\n请稍候片刻。';

  @override
  String get challengeSttFallback => '语音识别不可用，因此你使用了点击输入来游玩。';

  @override
  String get reasonTravelTitle => '旅行中开口说';

  @override
  String get reasonTravelDesc => '自信地与当地人交流';

  @override
  String get reasonCareerTitle => '工作与职业';

  @override
  String get reasonCareerDesc => '商务对话';

  @override
  String get reasonExamTitle => '考试备考';

  @override
  String get reasonExamDesc => '准备口语考试';

  @override
  String get reasonDailyTitle => '日常对话';

  @override
  String get reasonDailyDesc => '每天都用得上的表达';

  @override
  String get reasonFriendsTitle => '结交外国朋友';

  @override
  String get reasonFriendsDesc => '自然的对话';

  @override
  String get reasonBrainTitle => '活跃大脑';

  @override
  String get reasonBrainDesc => '提升记忆力与专注力';

  @override
  String get challengeRecordToggle => '录制本次游玩';

  @override
  String get challengeRecordHint => '保存一段游玩视频用于分享（无声）。';

  @override
  String get settingsSection => '设置';

  @override
  String get paymentSection => '支付';

  @override
  String get supportSection => '支持';

  @override
  String get userLanguage => '显示语言';

  @override
  String get learningLanguage => '学习语言';

  @override
  String get learningLanguageKorean => '韩语';

  @override
  String get notificationLabel => '通知';

  @override
  String get currentPlan => '当前套餐';

  @override
  String get paymentHistory => '支付记录';

  @override
  String get contactUs => '联系我们';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get logOut => '退出登录';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get deleteAccountTitle => '要删除账号吗？';

  @override
  String get deleteAccountBody => '此操作将永久删除你的账号和数据，且无法撤销。';

  @override
  String get delete => '删除';

  @override
  String get share => '分享';

  @override
  String get accentSoundsLike => '你的韩语口音听起来';

  @override
  String get hintLabel => '提示';

  @override
  String get nextHint => '下一个提示';

  @override
  String get translateLabel => '翻译';

  @override
  String get startRecording => '开始录音';

  @override
  String get stopRecording => '停止录音';

  @override
  String get back => '返回';

  @override
  String get onboardingNameTitle => '我们该怎么称呼你？';

  @override
  String get onboardingNameSubtitle => '你的 AI 导师会记住你的名字。';

  @override
  String get nameLabel => '你的名字';

  @override
  String get nameHint => '请输入你的名字';

  @override
  String get nameHelper => '不一定要用真名——用昵称也可以。';

  @override
  String get continueLabel => '继续';

  @override
  String get onboardingDoneTitle => 'Beaver 正在等你来电';

  @override
  String get onboardingDoneSubtitle => '现在就开始通话吧';

  @override
  String get home => '首页';

  @override
  String get callNow => '立即通话';

  @override
  String get pronunciation => '发音';

  @override
  String get fluency => '流利度';

  @override
  String get rhythm => '语调节奏';

  @override
  String get analysisTimeout => '这次花的时间比预期长。请稍后再试。';

  @override
  String get analysisFailed => '我们无法分析这次对话。请重试。';

  @override
  String get analyzingConversation => '正在分析你的对话…';

  @override
  String get analyzingSubtitle => '只需稍等片刻';

  @override
  String get tryAgain => '再试一次';

  @override
  String get nativeLabel => '母语者';

  @override
  String get meLabel => '我';

  @override
  String get pronunciationPlayError => '无法播放发音音频。';

  @override
  String get savedExpressionsLoadError => '无法加载你保存的表达。';

  @override
  String get mySavedExpressions => '我保存的表达';

  @override
  String get avatarTraits => '温暖 · 沉稳 · 温柔';

  @override
  String get priceFree => '免费';

  @override
  String get loginGoogleTokenError => '无法获取 Google 登录令牌。';

  @override
  String get loginGoogleSignInFailed => 'Google 登录失败。';

  @override
  String get loginContinueWithKakao => '使用 Kakao 继续';

  @override
  String get loginContinueWithGoogle => '使用 Google 继续';

  @override
  String get loginContinueWithApple => '使用 Apple 继续';

  @override
  String get loginContinueWithEmail => '使用邮箱继续';

  @override
  String get loginOrDivider => '或';

  @override
  String get loginNoAccount => '还没有账号？';

  @override
  String get signUp => '注册';

  @override
  String get loginTermsNoticePrefix => '继续即表示你同意我们的';

  @override
  String get loginTermsNoticeAnd => '和';

  @override
  String get loginTermsNoticeSuffix => '。';

  @override
  String get loginLogIn => '登录';

  @override
  String get fieldEmailLabel => '邮箱';

  @override
  String get emailHint => '请输入你的邮箱';

  @override
  String get fieldPasswordLabel => '密码';

  @override
  String get passwordHint => '请输入你的密码';

  @override
  String get loginRememberMe => '记住我';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginLoggingIn => '正在登录...';

  @override
  String get passwordLengthError => '密码必须为 8–16 个字符。';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致。';

  @override
  String get signupCheckInput => '请检查你的输入。';

  @override
  String get fieldConfirmPasswordLabel => '确认密码';

  @override
  String get confirmPasswordHint => '请再次输入你的密码';

  @override
  String get signupSigningUp => '正在注册...';

  @override
  String get signupHaveAccount => '已经有账号了？';

  @override
  String get passwordMethodEmailRequired => '请输入你的邮箱';

  @override
  String get passwordResetTitle => '重置密码';

  @override
  String get passwordMethodDescription => '请输入你希望接收密码重置验证码的邮箱地址。';

  @override
  String get emailAddressHint => '邮箱地址';

  @override
  String get passwordMethodSending => '正在发送...';

  @override
  String get passwordMethodSendEmail => '发送邮件';

  @override
  String get passwordCodeTitle => '输入验证码';

  @override
  String get passwordCodeDescription => '我们已将恢复验证码发送到你的邮箱。请输入以继续。';

  @override
  String get passwordCodeNoCode => '没有收到验证码？';

  @override
  String get passwordCodeResend => '重新发送验证码';

  @override
  String get passwordCodeVerifying => '正在验证...';

  @override
  String get passwordNewTitle => '新密码';

  @override
  String get passwordNewDescription => '为你的账号设置一个新密码。';

  @override
  String get fieldNewPasswordLabel => '新密码';

  @override
  String get newPasswordHint => '请输入你的新密码';

  @override
  String get fieldConfirmNewPasswordLabel => '确认新密码';

  @override
  String get confirmNewPasswordHint => '请再次输入你的新密码';

  @override
  String get passwordNewSubmitting => '正在提交...';

  @override
  String get passwordNewSubmit => '提交';

  @override
  String get passwordCompleteTitle => '密码重置完成';

  @override
  String get passwordCompleteBody => '你的密码已重置。请使用新密码登录以继续。';

  @override
  String get termsTitle => '服务条款';

  @override
  String get privacyTitle => '隐私政策';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '为 $email 设置一个新密码。';
  }

  @override
  String get selectComplete => '完成';

  @override
  String get onboardingLanguageTitle => '你的母语是什么？';

  @override
  String get onboardingReasonTitle => '你为什么要学习一门语言？';

  @override
  String get onboardingReasonSubtitle => '我们会根据你的目标定制学习内容。';

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
}
