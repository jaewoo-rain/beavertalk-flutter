// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get loginRequired => '需要先登录。';

  @override
  String get callWebNotSupported => '网页版不支持语音通话，请使用应用。';

  @override
  String get micPermissionRequiredForCall => '需要麦克风权限。请允许麦克风后再通话。';

  @override
  String get callErrorGeneric => '通话过程中出现错误。';

  @override
  String get callNetworkError => '网络出现错误。';

  @override
  String get authInvalidCredentials => '邮箱或密码不正确。';

  @override
  String get authEmailAlreadyRegistered => '该邮箱已注册。';

  @override
  String get authConfirmEmailRequired => '请完成发送到你邮箱的验证。';

  @override
  String get authResetCodeSent => '验证码已发送到你的邮箱。';

  @override
  String get authResetCodeInvalid => '验证码不正确或已过期。';

  @override
  String get authPasswordUpdated => '密码已重置。';

  @override
  String get authAppleTokenMissing => '无法获取 Apple 登录令牌。';

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
  String get quickStart => '快速开始';

  @override
  String get presetMorning => '早晨习惯';

  @override
  String get presetMorningSub => '工作日 8:00';

  @override
  String get presetEvening => '晚间收尾';

  @override
  String get presetEveningSub => '每天 21:00';

  @override
  String get presetCustom => '自定义';

  @override
  String get presetCustomSub => '自由设置';

  @override
  String alarmSummary(int count, int monthly) {
    return '每周$count次 · 每月$monthly次通话';
  }

  @override
  String get alarmSummaryNone => '请至少选择一天';

  @override
  String get partnerInUse => '使用中';

  @override
  String get partnerOwned => '已拥有';

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
  String callSequence(int count) {
    return '第$count次通话';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name想说的话';
  }

  @override
  String characterNoteFooter(String name) {
    return '通话结束后由$name留下';
  }

  @override
  String newExpressionsCount(int count) {
    return '新学表达 $count';
  }

  @override
  String get analysisLoadError => '无法加载分析结果。';

  @override
  String get standardAudioNotReady => '标准发音音频尚未准备好。';

  @override
  String get standardAudioPlayError => '无法播放标准发音音频。';

  @override
  String get selectNativeLanguage => '选择你的母语';

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
  String get analyzingByWord => '正在逐词检查你的发音';

  @override
  String get analyzingTakingLonger => '这需要稍微久一点';

  @override
  String get scanConnectionLost => '连接已断开';

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
  String pricePerMonth(String price) {
    return '$price / 月';
  }

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
  String get loginAppleSignInFailed => 'Apple 登录失败。';

  @override
  String get loginFacebookSignInFailed => 'Facebook 登录失败。';

  @override
  String get loginKakaoSignInFailed => 'Kakao 登录失败。';

  @override
  String get loginContinueWithKakao => '使用 Kakao 继续';

  @override
  String get loginContinueWithGoogle => '使用 Google 继续';

  @override
  String get loginContinueWithFacebook => '使用 Facebook 继续';

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
  String get thisMonthPayment => '本月支付金额';

  @override
  String get filterAll => '全部';

  @override
  String get filterSubscription => '订阅';

  @override
  String get filterCharacter => '角色';

  @override
  String get statusCompleted => '已完成';

  @override
  String get lastPayment => '最近支付';

  @override
  String subscriptionSwitchNote(String date) {
    return '你可以在$date前继续使用 Pro 权益，之后套餐将自动切换为免费版。';
  }

  @override
  String get freePlanCallLimit => '每天1次通话 · 限时5分钟';

  @override
  String get freePlanBasicCharacters => '可使用基础角色';

  @override
  String get availableForPurchase => '可购买';

  @override
  String get paymentsLoadError => '无法加载支付记录';

  @override
  String get noPayments => '还没有支付记录';

  @override
  String get morePaymentsExist => '更早的支付记录暂未显示';

  @override
  String get undatedPayments => '无日期';

  @override
  String get paymentLabelFallback => '支付';

  @override
  String learningPassed(int passed, int total) {
    return '$total个句子中通过$passed个';
  }

  @override
  String get hardestSound => '今天最难的音';

  @override
  String get soundAccuracy => '各音准确度';

  @override
  String phonemeAttempts(int count) {
    return '按音素 · $count次尝试';
  }

  @override
  String get colSound => '音';

  @override
  String get colAttempts => '尝试';

  @override
  String get colCorrect => '正确';

  @override
  String get colAccuracy => '准确度';

  @override
  String get sentenceResults => '各句结果';

  @override
  String viewAllSentences(int count) {
    return '查看全部$count个';
  }

  @override
  String get colSentence => '句子';

  @override
  String get colPronunciation => '发音';

  @override
  String get colFluency => '流利';

  @override
  String get colRhythm => '节奏';

  @override
  String recentSessions(int count) {
    return '最近$count次';
  }

  @override
  String trendAverage(int score) {
    return '平均 $score';
  }

  @override
  String get today => '今天';

  @override
  String get colDate => '日期';

  @override
  String get colSentences => '句数';

  @override
  String get colScore => '分数';

  @override
  String get colChange => '变化';

  @override
  String dateToday(String date) {
    return '$date（今天）';
  }

  @override
  String get accentAnalysis => '口音分析';

  @override
  String get overallLevel => '综合等级';

  @override
  String get overallLevelSubtitle => '词汇·语法·表达';

  @override
  String get pronunciationAnalysis => '发音分析';

  @override
  String get recentSessionsAverage => '最近10次平均';

  @override
  String levelStage(int stage) {
    return '第$stage级';
  }

  @override
  String topPercent(int percent) {
    return '前$percent%';
  }

  @override
  String get allLearnersBasis => '全体学习者中';

  @override
  String aheadOfLearners(int percent) {
    return '你领先于$percent%的学习者';
  }

  @override
  String get retakeLevelTest => '重新测试等级';

  @override
  String get practicePronunciation => '练习发音';

  @override
  String get priceChangedTitle => '价格已变更';

  @override
  String priceChangedBody(String price) {
    return '此商品现价为$price。要继续吗?';
  }

  @override
  String get billingGroupPlanPurchases => '套餐与购买';

  @override
  String get billingGroupInTheStore => '在商店中';

  @override
  String get billingChangePlan => '更换套餐';

  @override
  String get billingCompareAllPlans => '对比全部套餐';

  @override
  String get billingBuyACharacter => '购买角色';

  @override
  String get billingRestorePurchases => '恢复购买';

  @override
  String get billingPaymentHistory => '付款记录';

  @override
  String get billingManageInTheStore => '在商店中管理';

  @override
  String get billingRefundHelp => '退款帮助';

  @override
  String get billingCancelSubscription => '取消订阅';

  @override
  String get billingResubscribe => '重新订阅';

  @override
  String get badgeCurrent => '当前';

  @override
  String get badgeTrial => '试用中';

  @override
  String get badgeRenewing => '自动续订';

  @override
  String get badgePastDue => '扣款失败';

  @override
  String get badgePaused => '已暂停';

  @override
  String get badgeCanceling => '即将取消';

  @override
  String get subscriptionTitle => '订阅';

  @override
  String get plansTitle => '套餐';

  @override
  String get planFree => '免费';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max 试用';

  @override
  String get freePlanPriceLine => '\$0.00 — 每天一次通话';

  @override
  String pricePerMonthLine(String amount) {
    return '每月 $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date前免费';
  }

  @override
  String get todaysCalls => '今日通话';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '已用 $used/$limit 次';
  }

  @override
  String get firstPaymentLabel => '首次付款';

  @override
  String get nextPaymentLabel => '下次付款';

  @override
  String get retryingUntilLabel => '重试截止';

  @override
  String get pausedSinceLabel => '暂停开始于';

  @override
  String planEndsLabel(String plan) {
    return '$plan 到期';
  }

  @override
  String get bannerGoUnlimitedTitle => '用 Pro 解锁无限通话';

  @override
  String bannerGoUnlimitedSub(String price) {
    return '通话不限次 · 每次 15 分钟 · 每月 $price';
  }

  @override
  String get bannerMaxUpsellTitle => '用 Max 开启视频通话';

  @override
  String bannerMaxUpsellSub(String price) {
    return '面对面通话 · 每月 $price';
  }

  @override
  String get bannerAnnualSwitchTitle => '换成年付';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '每年 $yearly · 折合每月 $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => '扣款没有成功';

  @override
  String get bannerPaymentFailedSub => '在商店中更新付款方式即可保住 Pro';

  @override
  String get bannerPausedTitle => '你的套餐已暂停';

  @override
  String get bannerPausedSub => '付款一直没有完成';

  @override
  String get noteRestoreHint => '已在其他设备上订阅？恢复购买即可在这台设备上继续使用。';

  @override
  String get noteStoreHandled => '付款方式、套餐变更和取消都由商店处理。';

  @override
  String get noteFairUse => '无限使用需遵守我们的合理使用政策。';

  @override
  String noteTrialEnds(String date) {
    return '试用将于$date结束。在此之前在商店中取消，就不会产生任何费用。';
  }

  @override
  String get noteGrace => '宽限期内权益照常可用。应用绝不会拦截你的取消操作。';

  @override
  String get noteHold => '付款完成前 Pro 会暂停。你的角色和学习进度都安然无恙。';

  @override
  String noteEnding(String date) {
    return '你的套餐即将结束。权益保留至$date，之后转为免费套餐。你随时可以重新订阅。';
  }

  @override
  String get trialExpiredTitle => '你的 Max 试用已结束';

  @override
  String get trialExpiredSub => '你现在是免费套餐';

  @override
  String get seePlans => '查看套餐';

  @override
  String get currentPlanTitle => '当前套餐';

  @override
  String get badgeRecommended => '推荐';

  @override
  String get perMonthUnit => '/月';

  @override
  String get planTaglinePro => '通话不限次。每次 15 分钟。';

  @override
  String get planTaglineMax => '现在可以看见对方了。';

  @override
  String get planTaglineFree => '每天一次通话，完全免费。';

  @override
  String get bulletProCalls => '语音通话，想打就打';

  @override
  String get bulletProLength => '每次通话 15 分钟';

  @override
  String get bulletProScoring => '逐字打分的发音评测';

  @override
  String get bulletProCorrections => '针对你母语的纠正';

  @override
  String get bulletProBeaverCalls => '海狸会主动给你打电话';

  @override
  String get bulletMaxVideo => '面对面视频通话';

  @override
  String get bulletMaxEverything => '包含 Pro 的全部功能';

  @override
  String get bulletMaxCharacters => '所有角色，不限使用';

  @override
  String get bulletMaxStudyBook => '匹配你水平的学习手册';

  @override
  String get bulletMaxWeeklyReport => '记录发音变化的每周报告';

  @override
  String get bulletFreeCall => '每天一次 5 分钟语音通话';

  @override
  String get bulletFreeCheck => '每天一次发音检测';

  @override
  String get bulletFreeAccent => '口音检测不限次';

  @override
  String get bulletFreeCharacter => '一个起步角色';

  @override
  String get ctaGoUnlimited => '解锁无限通话';

  @override
  String get ctaTurnOnVideo => '开启视频通话';

  @override
  String get noteCallLength => '每次通话 15 分钟。';

  @override
  String get paywallProTitle1 => '凌晨 3 点也在线的';

  @override
  String get paywallProTitle2 => '你的韩国朋友';

  @override
  String get paywallProSub => '通话不限次。每次 15 分钟。全年无休。';

  @override
  String get paywallLimitHeadline => 'Pro 帮你解除限制。';

  @override
  String get limitBannerCallTitle => '今天的通话用完了';

  @override
  String get limitBannerCallSub => '免费套餐每天可通话一次';

  @override
  String get limitBannerCheckTitle => '今天的检测用完了';

  @override
  String get limitBannerCheckSub => '免费套餐每天可检测一次';

  @override
  String get bulletProCharactersForever => '买下的角色永远属于你';

  @override
  String get paywallMaxTitle => '现在可以看见对方了。';

  @override
  String get paywallMaxSub => '视频通话、所有角色，还有专为你水平定制的学习手册。';

  @override
  String get planMonthly => '月付';

  @override
  String get planAnnual => '年付';

  @override
  String proMonthlyPriceLine(String price) {
    return '每月 $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · 折合每月 $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '每月 $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '每年 $yearly · 折合每月 $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return '每月 $price · 随时可在商店中取消';
  }

  @override
  String ctaCaptionMax(String price) {
    return '每月 $price · 随时可在商店中取消';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 天免费，之后 每月 $price · 随时可在商店中取消';
  }

  @override
  String get ctaCaptionAutoRenew => '在您取消前将自动续订。';

  @override
  String get footerTerms => '条款';

  @override
  String get footerPrivacy => '隐私';

  @override
  String get noteMaxCharacters => 'Max 解锁的角色在订阅有效期内可用。你买下的角色永远属于你。';

  @override
  String get processingTitle => '正在确认购买';

  @override
  String get processingSub => '通常只需几秒钟。';

  @override
  String get successProTitle => 'Pro 已开通。';

  @override
  String get successProSub => '从现在起，通话不限次。';

  @override
  String get successProBenefit1 => '想打就打 — 每次 15 分钟';

  @override
  String get successProBenefit2 => '发音检测不限次';

  @override
  String get successProBenefit3 => '所有角色，还可单独购买';

  @override
  String get successMaxTitle => '现在可以看见对方了。';

  @override
  String get successMaxSub => '视频通话已开启。在任意通话中点击视频按钮即可。';

  @override
  String get successMaxBenefit1 => '面对面视频通话';

  @override
  String get successMaxBenefit2 => '所有角色不限用，新角色抢先体验';

  @override
  String get successMaxBenefit3 => '匹配你水平的学习手册';

  @override
  String get ctaStartACall => '开始通话';

  @override
  String get ctaStartAVideoCall => '开始视频通话';

  @override
  String get ctaSeeYourSubscription => '查看我的订阅';

  @override
  String successProCaption(String price) {
    return '每月收取 $price，直到你取消为止。可随时在商店中管理或取消。';
  }

  @override
  String successMaxCaption(String price) {
    return '每月收取 $price，直到你取消为止。可随时在商店中管理或取消。';
  }

  @override
  String get plansErrorTitle => '套餐加载失败';

  @override
  String get plansErrorSub => '商店没有响应。';

  @override
  String get ctaTryAgain => '重试';

  @override
  String get plansErrorCaption => '没有产生任何扣款。';

  @override
  String get changePlanTitle => '更换套餐';

  @override
  String get moveToMaxTitle => '升级到 Max';

  @override
  String maxPriceShort(String price) {
    return '$price/月';
  }

  @override
  String get moveToMaxCardSub => '面对面视频通话 · 所有角色 · 为你定制的学习手册';

  @override
  String get whatHappensNow => '接下来会怎样';

  @override
  String get maxStartsLabel => 'Max 生效';

  @override
  String get immediately => '立即';

  @override
  String get unusedProTime => 'Pro 剩余时长';

  @override
  String get creditedTowardMax => '折抵 Max 费用';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => '切换到 Max';

  @override
  String get upgradeCaption => '新套餐立即生效。Pro 剩余时长会折抵费用，绝不重复扣款。';

  @override
  String get moveToProTitle => '换到 Pro';

  @override
  String get moveToProSub => '今天不会有任何变化。Max 会持续到你已付费的当月结束。';

  @override
  String get maxRunsUntil => 'Max 有效期至';

  @override
  String get proStarts => 'Pro 开始';

  @override
  String get whatYouKeep => '你保留的权益';

  @override
  String get keepBenefitCalls => '语音通话不限次，每次 15 分钟';

  @override
  String get keepBenefitCharacters => '买下的角色永远属于你';

  @override
  String downgradeWarning(String date) {
    return '视频通话和 Max 专属角色将于$date关闭。';
  }

  @override
  String get ctaSwitchToPro => '切换到 Pro';

  @override
  String get ctaKeepMax => '保留 Max';

  @override
  String get winbackSkip => '跳过';

  @override
  String get winbackTitle => '你的 Pro 套餐已结束';

  @override
  String get winbackSub => '你现在是免费套餐 — 每天一次通话。';

  @override
  String get winbackQuestion => '愿意告诉我们离开的原因吗？';

  @override
  String get winbackReasonExpensive => '价格太贵';

  @override
  String get winbackReasonUnused => '用得不够多';

  @override
  String get winbackReasonMissing => '缺少我需要的功能';

  @override
  String get winbackReasonOtherApp => '找到了别的应用';

  @override
  String get winbackReasonElse => '其他原因';

  @override
  String get ctaSend => '发送';

  @override
  String get ctaNotNow => '暂不';

  @override
  String get winbackCaption => '此问卷不会恢复你的套餐。请在商店中重新订阅。';

  @override
  String get ctaContinue => '继续';

  @override
  String get ctaClose => '关闭';

  @override
  String get ovRestoreSuccessTitle => 'Pro 回来了';

  @override
  String get ovRestoreSuccessBody => '我们找到了你的订阅，已在这台设备上重新开启。';

  @override
  String get ovRestoreEmptyTitle => '没有可恢复的内容';

  @override
  String get ovRestoreEmptyBody => '此商店账号下没有关联的有效订阅。';

  @override
  String get ovRestoreOtherTitle => '该套餐属于另一个账号';

  @override
  String get ovRestoreOtherBody => '此订阅已在另一个 BeaverTalk 账号上生效。';

  @override
  String get ctaSignInThatAccount => '登录那个账号';

  @override
  String get ctaGetHelp => '获取帮助';

  @override
  String get ovCharacterOfferTitle => '还没准备好订 Pro？';

  @override
  String get ovCharacterOfferBody => '挑一个角色永久拥有。一次性购买 — 没有订阅，也不会续费。';

  @override
  String get rowOneCharacter => '一个角色';

  @override
  String rowFromPrice(String price) {
    return '$price 起';
  }

  @override
  String get rowYoursForever => '永久拥有';

  @override
  String get rowNoRenewal => '无续费';

  @override
  String get rowWorksOnFree => '免费套餐可用';

  @override
  String get rowYes => '是';

  @override
  String get ctaSeeCharacters => '查看角色';

  @override
  String get ovNotEligibleTitle => '没有可取消的订阅';

  @override
  String get ovNotEligibleBody => '你目前是免费套餐。该账号下没有有效订阅。';

  @override
  String get ovCancelDownsellTitle => '在你离开之前';

  @override
  String get ovCancelDownsellBody => '取消需在商店中进行。有两件事值得了解。';

  @override
  String get rowPayYearlyInstead => '改为年付';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '折合每月 $price';
  }

  @override
  String get rowCharactersYouBought => '你买下的角色';

  @override
  String get rowProRunsUntil => 'Pro 有效期至';

  @override
  String get ctaSwitchToYearly => '换成年付';

  @override
  String get ctaContinueToStore => '继续前往商店';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return '改年付，省 $saved';
  }

  @override
  String get ovAnnualSwitchBody => '你已经用了两个月 Pro。年付套餐算下来更划算。';

  @override
  String get rowYouSave => '你省下';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => '年付';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => '月付满一年';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => '换成月付';

  @override
  String ovMonthlySwitchBody(String date) {
    return '你的年付套餐有效期至$date。月付账单从次日开始。';
  }

  @override
  String get rowMonthlyBillingStarts => '月付账单开始';

  @override
  String get rowMonthlyLabel => '月付';

  @override
  String get rowYearlyWorkedOut => '年付折合';

  @override
  String get ctaSwitchToMonthly => '换成月付';

  @override
  String get ovRefundHelpTitle => '退款由商店处理';

  @override
  String get ovRefundHelpBody => '我们无法自行退款。每一笔申请都由商店审核。';

  @override
  String get ctaGoToStore => '前往商店';

  @override
  String get ovTrialEndingTitle => '你的试用明天结束';

  @override
  String get ovTrialEndingBody => '不取消的话 Max 会继续。接下来是这样的。';

  @override
  String get rowTrialEnds => '试用结束';

  @override
  String get rowFirstCharge => '首次扣款';

  @override
  String get rowThenMonthly => '之后每月';

  @override
  String get ctaCancelInStore => '在商店中取消';

  @override
  String get ovTrialStartTitle => '免费体验 Max 7 天';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date前免费。之后每月 $price，除非你在商店中取消。';
  }

  @override
  String get ctaStart7Days => '免费试用 7 天';

  @override
  String get ovOtoTitle => '开始前还有一件事';

  @override
  String get ovOtoBody => '好选择 — 无限通话已经开启。同样的 Pro，年付更便宜。';

  @override
  String get ovFailedDeclinedTitle => '你的卡被拒绝了';

  @override
  String get ovFailedDeclinedBody => '商店没能完成扣款。没有产生任何费用。';

  @override
  String get ctaUpdatePaymentMethod => '更新付款方式';

  @override
  String get ovFailedCanceledTitle => '付款已取消';

  @override
  String get ovFailedCanceledBody => '你仍是免费套餐。没有产生任何费用。';

  @override
  String get ovFailedStoreTitle => '出了点问题';

  @override
  String get ovFailedStoreBody => '无法连接到商店。没有产生任何费用。';

  @override
  String get ovAlreadyTitle => '你已经在用 Pro 了';

  @override
  String get ovAlreadyBody => '此商店账号已有生效中的套餐，无需再购买。';

  @override
  String get ctaSeeMySubscription => '查看我的订阅';

  @override
  String get subCancelTitle => '取消订阅';

  @override
  String subCancelBody(String date) {
    return 'Pro 有效期至$date。之后你将转为免费套餐。';
  }

  @override
  String get subWhatYouLose => '你将失去';

  @override
  String get benefitCalls15 => '通话不限次，每次 15 分钟';

  @override
  String get benefitScoring => '逐字打分的发音评测';

  @override
  String get benefitEveryCharacter => '所有角色，不限使用';

  @override
  String get ctaKeepPro => '保留 Pro';

  @override
  String get subPaymentTitle => '更新付款';

  @override
  String get subPaymentBody => '扣款没有成功。宽限期内 Pro 会继续有效。';

  @override
  String get subHowToFix => '解决方法';

  @override
  String get fixStep1 => '打开商店，更新你的付款方式';

  @override
  String get fixStep2 => '回来后套餐会自动恢复';

  @override
  String get fixStep3 => '绝不重复扣款';

  @override
  String get subResubTitle => '重新订阅';

  @override
  String subResubBody(String date) {
    return 'Pro 将于$date结束。重新打开自动续订，一切照旧。';
  }

  @override
  String get subWhatYouKeep => '你保留的权益';

  @override
  String get ctaTurnItBackOn => '重新开启';

  @override
  String get flTodayTitle => '今天的通话用完了';

  @override
  String get flTodayBody => '从上次中断的地方，现在就继续。';

  @override
  String get flCheckTitle => '今天的检测用完了';

  @override
  String get flCheckBody => '免费套餐每天检测一次。Pro 则不限次。';

  @override
  String get flBenefitCalls => 'Pro 通话不限次 · 每次 15 分钟';

  @override
  String get flBenefitChecks => 'Pro 发音检测不限次';

  @override
  String flCaption(String price) {
    return '每月 $price · 随时可取消';
  }

  @override
  String flUsage(String used, String limit) {
    return '已用 $used/$limit';
  }

  @override
  String get ctaMaybeTomorrow => '明天再说';

  @override
  String get accountSection => '账户';

  @override
  String get nicknameLabel => '昵称';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => '登录方式';

  @override
  String get joinedLabel => '注册日期';

  @override
  String get editNicknameTitle => '编辑昵称';

  @override
  String get nicknameRule => '2–12 个字符 · 仅限英文字母和数字';

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
  String get paywallLeaveTitle => '现在离开将无法完成订阅';

  @override
  String get paywallLeaveBody => '权益在付款后立即解锁。你随时可以从我的页面回来。';

  @override
  String get ctaKeepLooking => '继续查看';

  @override
  String get ctaLeaveAnyway => '仍然离开';

  @override
  String get iapCharacterSuccessTitle => '新伙伴加入了!';

  @override
  String get iapCharacterSuccessBody =>
      '这个角色永远属于你——即使套餐变更也会保留,并可通过恢复购买在任何设备找回。';

  @override
  String get iapCharacterFailedBody => '购买未完成。没有产生任何扣款,请重试。';

  @override
  String get noAccentDataTitle => '还没有语调数据';

  @override
  String get noAccentDataBody => '继续通话就会积累语调特征。';

  @override
  String get noLevelYetTitle => '还没有等级';

  @override
  String get noLevelYetBody => '完成第一次通话后就会显示等级。';

  @override
  String get noPronunciationDataTitle => '还没有发音记录';

  @override
  String get noPronunciationDataBody => '我们会根据通话中说的句子分析发音。';

  @override
  String get noCharacterNote => '还没有留下的话';

  @override
  String get noPhonemesYet => '还没有可分析的发音';

  @override
  String get noSentencesYet => '还没有可分析的句子';

  @override
  String get takeLevelTest => '参加等级测试';

  @override
  String get reviewToSeeScore => '复习后就会出现发音分数';

  @override
  String get playAgain => '再玩一次';

  @override
  String get difficultySlow => '慢速';

  @override
  String get difficultyNormal => '正常';

  @override
  String get difficultyFast => '快速';

  @override
  String get difficultyLabel => '难度';

  @override
  String get connected => '已连接';

  @override
  String get unlockedWithMax => 'Max 可用';

  @override
  String get callModeSheetTitle => '你想怎么聊？';

  @override
  String get callModeSheetSubtitle => '立即应用于本次通话';

  @override
  String get callModeFreeTalk => '自由聊天';

  @override
  String get callModeFreeTalkDesc => '轻松交谈，不做纠正';

  @override
  String get callModeStudy => '表达学习';

  @override
  String get callModeStudyDesc => '逐句学习表达并纠正发音';

  @override
  String get callModeChange => '更改模式';

  @override
  String get callModeKeep => '关闭';

  @override
  String get callExitTitle => '要结束通话吗？';

  @override
  String get callExitSubtitle => '现在结束仍会消耗今天的一次通话';

  @override
  String get callExitKeep => '继续通话';

  @override
  String get callExitConfirm => '结束通话';

  @override
  String get callMicMute => '静音';

  @override
  String get callMicUnmute => '取消静音';

  @override
  String get callPushToTalk => '按住说话';

  @override
  String get callFreeEndedTitle => '免费通话已结束';

  @override
  String get callFreeEndedCta => '订阅并继续聊天';

  @override
  String get callKeepGoingTitle => '要继续吗？';

  @override
  String get callKeepGoingSubtitle => '通话以5分钟为一段继续。每次都会再询问你。';

  @override
  String get articulationSelectedWord => '所选单词';

  @override
  String get articulationYouSaid => '你的发音';

  @override
  String get articulationTargetSound => '目标';

  @override
  String get articulationListenNative => '听母语者发音';
}
