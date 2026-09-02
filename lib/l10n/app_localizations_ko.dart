// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get loginRequired => '로그인이 필요해요.';

  @override
  String get callWebNotSupported => '웹에서는 음성 통화를 지원하지 않아요. 앱에서 이용해 주세요.';

  @override
  String get micPermissionRequiredForCall =>
      '마이크 권한이 필요해요. 통화하려면 마이크를 허용해 주세요.';

  @override
  String get callErrorGeneric => '통화 중 오류가 발생했어요.';

  @override
  String get callNetworkError => '네트워크 오류가 발생했어요.';

  @override
  String get authInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않아요.';

  @override
  String get authEmailAlreadyRegistered => '이미 가입된 이메일입니다.';

  @override
  String get authConfirmEmailRequired => '이메일로 전송된 인증을 완료해주세요.';

  @override
  String get authResetCodeSent => '인증 코드를 이메일로 전송했어요.';

  @override
  String get authResetCodeInvalid => '인증 코드가 올바르지 않거나 만료되었어요.';

  @override
  String get authPasswordUpdated => '비밀번호가 재설정되었어요.';

  @override
  String get authAppleTokenMissing => '애플 로그인 토큰을 받지 못했어요.';

  @override
  String callEndedDuration(String duration) {
    return '통화 종료 $duration';
  }

  @override
  String get callRatingPrompt => '통화는 어떠셨나요?';

  @override
  String get ratingBad => '별로예요';

  @override
  String get ratingOkay => '괜찮아요';

  @override
  String get ratingGood => '좋아요';

  @override
  String get goHome => '홈으로';

  @override
  String get viewAnalysis => '분석 보기';

  @override
  String get loadingShort => '로딩 중…';

  @override
  String ratingSubmitFailed(String message) {
    return '평가 제출에 실패했습니다: $message';
  }

  @override
  String get callInfoNotFound => '통화 정보를 찾을 수 없어 분석을 건너뜁니다.';

  @override
  String get tabRecords => '기록';

  @override
  String get tabArchive => '보관함';

  @override
  String get callHistory => '통화 기록';

  @override
  String get conversationRecord => '대화 기록';

  @override
  String get noCallRecords => '아직 통화 기록이 없어요';

  @override
  String get noCallRecordsBody => 'AI와 첫 통화를 마치면\n여기에 기록이 표시돼요.';

  @override
  String get startCall => '통화 시작';

  @override
  String get recordsLoadError => '기록을 불러오지 못했어요';

  @override
  String get tryAgainLater => '잠시 후 다시 시도해 주세요.';

  @override
  String get retry => '다시 시도';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String get scheduleManagement => '일정 관리';

  @override
  String get alarms => '알람';

  @override
  String get addSchedule => '새 일정 추가';

  @override
  String get editSchedule => '일정 수정';

  @override
  String get somethingWentWrong => '문제가 발생했어요';

  @override
  String get alarmsLoadError => '알람을 불러오지 못했어요';

  @override
  String get charactersLoadError => '캐릭터를 불러오지 못했어요';

  @override
  String get noCharacters => '이용 가능한 캐릭터가 없어요';

  @override
  String get close => '닫기';

  @override
  String get repeat => '반복';

  @override
  String get callPartner => '통화 상대';

  @override
  String get quickStart => '빠른 시작';

  @override
  String get presetMorning => '아침 루틴';

  @override
  String get presetMorningSub => '평일 8:00';

  @override
  String get presetEvening => '저녁 정리';

  @override
  String get presetEveningSub => '매일 21:00';

  @override
  String get presetCustom => '직접 설정';

  @override
  String get presetCustomSub => '자유롭게';

  @override
  String alarmSummary(int count, int monthly) {
    return '주 $count회 · 한 달이면 $monthly번 통화하게 돼요';
  }

  @override
  String get alarmSummaryNone => '요일을 하나 이상 골라 주세요';

  @override
  String get partnerInUse => '사용 중';

  @override
  String get partnerOwned => '보유 중';

  @override
  String get am => '오전';

  @override
  String get pm => '오후';

  @override
  String get save => '저장';

  @override
  String get conversation => '대화';

  @override
  String get review => '복습하기';

  @override
  String get pronunciationChallenge => '발음 챌린지 도전하기';

  @override
  String get newExpressions => '새로 배운 표현';

  @override
  String get analysisResult => '분석 결과';

  @override
  String get noNewExpressions => '이번 대화에서는 새로운 표현이 없어요.';

  @override
  String get practice => '연습하기';

  @override
  String recentScore(int score) {
    return '최근 점수 $score%';
  }

  @override
  String callSequence(int count) {
    return '$count번째 통화';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name의 한마디';
  }

  @override
  String characterNoteFooter(String name) {
    return '통화 직후 $name가 남김';
  }

  @override
  String newExpressionsCount(int count) {
    return '새로 배운 표현 $count';
  }

  @override
  String get analysisLoadError => '분석 결과를 불러오지 못했어요.';

  @override
  String get standardAudioNotReady => '표준 발음 음성이 아직 준비되지 않았어요.';

  @override
  String get standardAudioPlayError => '표준 발음 음성을 재생하지 못했어요.';

  @override
  String get selectNativeLanguage => '모국어를 선택하세요';

  @override
  String get selectYourLanguage => '언어 선택';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get selectTime => '시간 선택';

  @override
  String get getStarted => '시작하기';

  @override
  String get permissionTitle => '원활한 이용을 위해\n권한을 허용해 주세요';

  @override
  String get permissionSubtitle => '필수 권한은 서비스 이용에 꼭 필요해요.';

  @override
  String get permissionMicTitle => '마이크 (필수)';

  @override
  String get permissionMicDesc => 'AI와 영어로 대화하기 위해 필요해요.';

  @override
  String get permissionNotifTitle => '알림 (선택)';

  @override
  String get permissionNotifDesc => '학습 리마인더와 통화 일정을 알려드려요.';

  @override
  String get micPermissionNeededTitle => '마이크 권한이 필요해요';

  @override
  String get micPermissionNeededBody =>
      'AI와 대화하려면 마이크 접근 권한을 허용해야 해요. 설정에서 권한을 켜주세요.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get connectionFailedTitle => '연결에 실패했어요';

  @override
  String get connectionFailedBody => '네트워크 연결을 확인한 후\n다시 시도해 주세요.';

  @override
  String get checkout => '결제';

  @override
  String get pay => '결제하기';

  @override
  String get orderSummary => '주문 요약';

  @override
  String get paymentMethod => '결제 수단';

  @override
  String get payMethodCard => '신용/체크카드';

  @override
  String get payMethodKakao => '카카오페이';

  @override
  String get productName => '말썽꾸러기 비버 아바타';

  @override
  String get productTrait => '프리미엄 캐릭터 · 평생 소장';

  @override
  String get amountItemPrice => '상품 가격';

  @override
  String get amountDiscount => '할인';

  @override
  String get amountTotal => '총액';

  @override
  String get paymentCompleteTitle => '결제 완료';

  @override
  String get paymentCompleteBody => '아바타가 컬렉션에 추가되었어요.';

  @override
  String get viewCollection => '컬렉션 보기';

  @override
  String get receiptItem => '상품';

  @override
  String get receiptAmount => '금액';

  @override
  String get receiptMethod => '결제 수단';

  @override
  String get receiptDate => '날짜';

  @override
  String get paymentFailedTitle => '결제에 실패했어요';

  @override
  String get paymentFailedBody => '결제를 처리하지 못했어요.\n다시 시도해 주세요.';

  @override
  String get freeCallEndingTitle => '무료 통화가 곧 끝나요';

  @override
  String get freeCallEndingBody => '구독하고 비버와 더 오래 대화해 보세요.';

  @override
  String get subscribe => '구독하기';

  @override
  String get endCall => '통화 종료';

  @override
  String get callEnded => '통화가 종료되었습니다.';

  @override
  String get connecting => '연결 중…';

  @override
  String get connectingHint => '보통 5초 이내에 연결돼요';

  @override
  String get callConnectFailed => '통화 연결에 실패했어요.';

  @override
  String get saveSentenceFailed => '문장을 저장하지 못했어요.';

  @override
  String get recordStartFailed => '녹음을 시작하지 못했어요.';

  @override
  String get recordTooShort => '녹음이 너무 짧아요. 다시 시도해 주세요.';

  @override
  String get gradingFailed => '채점에 실패했어요. 다시 시도해 주세요.';

  @override
  String get listenStandard => '표준 발음 듣기';

  @override
  String get saveSentence => '문장 저장';

  @override
  String get unsaveSentence => '저장한 문장 삭제';

  @override
  String get scoringPronunciation => '발음을 채점하는 중…';

  @override
  String get analyzingByWord => '단어별로 발음을 확인하고 있어요';

  @override
  String get analyzingTakingLonger => '조금만 더 걸리고 있어요';

  @override
  String get scanConnectionLost => '연결이 끊겼어요';

  @override
  String get noRecordingToPlay => '재생할 녹음이 없어요.';

  @override
  String get myRecordingPlayError => '녹음을 재생하지 못했어요.';

  @override
  String get next => '다음';

  @override
  String get endLearning => '학습 종료';

  @override
  String get navCalendar => '캘린더';

  @override
  String get navCall => '통화';

  @override
  String get navStats => '통계';

  @override
  String get myPage => '마이페이지';

  @override
  String get languageSaveFailed => '언어 설정을 저장하지 못했어요.';

  @override
  String get accountDeleteFailed => '계정을 삭제하지 못했어요.';

  @override
  String get changeAvatar => '아바타 변경';

  @override
  String get avatarIntro => '통화 상대에 따라 목소리와 난이도가 달라요.\n일부 상대는 유료일 수 있어요.';

  @override
  String myPartnersOwned(int count) {
    return '내 파트너 · $count개 보유';
  }

  @override
  String get limitedDiscount => '한정 할인';

  @override
  String get available => '이용 가능';

  @override
  String get inUse => '사용 중';

  @override
  String get owned => '보유 중';

  @override
  String get noCharactersToShow => '표시할 캐릭터가 없어요';

  @override
  String get buy => '구매';

  @override
  String get noSavedSentences => '저장한 문장이 아직 없어요.\n대화 기록에서 문장을 북마크해 보세요.';

  @override
  String get noAlarms => '등록된 알람이 없어요';

  @override
  String get noAlarmsBody => '학습 리마인더를 추가하면\n꾸준한 습관을 만들 수 있어요.';

  @override
  String get subscriptionManage => '구독 관리';

  @override
  String get changePlan => '요금제 변경';

  @override
  String get cancelSubscription => '구독 취소';

  @override
  String get benefitsInUse => '이용 중인 혜택';

  @override
  String get paymentInfo => '결제 정보';

  @override
  String get nextBillingDate => '다음 결제일';

  @override
  String get lostBenefitsTitle => '취소 시 사라지는 혜택';

  @override
  String get viewBillingHistory => '결제 내역 보기';

  @override
  String get keepUsingPro => 'Pro 계속 이용하기';

  @override
  String get proMembership => 'Pro 멤버십';

  @override
  String pricePerMonth(String price) {
    return '$price / 월';
  }

  @override
  String get benefitUnlimitedCalls => '무제한 통화';

  @override
  String get benefitDetailedAnalysis => '상세한 발음 및 문법 분석';

  @override
  String get benefitAllCharacters => '모든 캐릭터 이용 가능';

  @override
  String get benefitNoAds => '광고 없음';

  @override
  String get playSampleVoice => '샘플 음성 재생';

  @override
  String get useThisAvatar => '이걸로 선택';

  @override
  String get challengeTitle => '발음 챌린지';

  @override
  String get challengeIntro =>
      '구역 안의 카드를 한국어로 정확히 발음해서 통과하세요.\n마이크가 없나요? 화면을 탭해서도 플레이할 수 있어요.';

  @override
  String get challengeStart => '카메라 및 마이크 시작';

  @override
  String get challengePermissionNote => '전면 카메라와 마이크 접근 권한이 필요해요 (선택).';

  @override
  String get challengeLoadingTitle => '로딩 중…';

  @override
  String get challengeLoadingNote =>
      '처음 실행 시 한국어 음성 모델(약 82MB)을 다운로드해요.\n잠시만 기다려 주세요.';

  @override
  String get challengeSttFallback => '음성 인식을 사용할 수 없어 탭 입력으로 플레이했어요.';

  @override
  String get reasonTravelTitle => '여행하며 말하기';

  @override
  String get reasonTravelDesc => '현지인과 자신 있게 대화해요';

  @override
  String get reasonCareerTitle => '업무 및 커리어';

  @override
  String get reasonCareerDesc => '비즈니스 대화';

  @override
  String get reasonExamTitle => '시험 준비';

  @override
  String get reasonExamDesc => '말하기 시험을 준비해요';

  @override
  String get reasonDailyTitle => '일상 대화';

  @override
  String get reasonDailyDesc => '매일 쓰는 표현들';

  @override
  String get reasonFriendsTitle => '외국인 친구 사귀기';

  @override
  String get reasonFriendsDesc => '자연스러운 대화';

  @override
  String get reasonBrainTitle => '두뇌 자극';

  @override
  String get reasonBrainDesc => '기억력과 집중력 향상';

  @override
  String get challengeRecordToggle => '이번 플레이 녹화';

  @override
  String get challengeRecordHint => '공유할 수 있도록 플레이 영상을 저장해요 (무음).';

  @override
  String get settingsSection => '설정';

  @override
  String get paymentSection => '결제';

  @override
  String get supportSection => '고객지원';

  @override
  String get userLanguage => '사용자 언어';

  @override
  String get learningLanguage => '학습 언어';

  @override
  String get learningLanguageKorean => '한국어';

  @override
  String get notificationLabel => '알림';

  @override
  String get currentPlan => '현재 요금제';

  @override
  String get paymentHistory => '결제 내역';

  @override
  String get contactUs => '문의하기';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get logOut => '로그아웃';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountTitle => '계정을 삭제할까요?';

  @override
  String get deleteAccountBody => '계정과 데이터가 영구적으로 삭제되며 되돌릴 수 없어요.';

  @override
  String get delete => '삭제';

  @override
  String get share => '공유';

  @override
  String get accentSoundsLike => '회원님의 한국어 발음은';

  @override
  String get hintLabel => '힌트';

  @override
  String get nextHint => '다음 힌트';

  @override
  String get translateLabel => '번역';

  @override
  String get startRecording => '녹음 시작';

  @override
  String get stopRecording => '녹음 중지';

  @override
  String get back => '뒤로';

  @override
  String get onboardingNameTitle => '뭐라고 불러드릴까요?';

  @override
  String get onboardingNameSubtitle => 'AI 튜터가 회원님의 이름을 기억해요.';

  @override
  String get nameLabel => '이름';

  @override
  String get nameHint => '이름을 입력하세요';

  @override
  String get nameHelper => '실명이 아니어도 괜찮아요. 닉네임도 좋아요.';

  @override
  String get continueLabel => '계속';

  @override
  String get onboardingDoneTitle => '비버가 회원님의 전화를 기다리고 있어요';

  @override
  String get onboardingDoneSubtitle => '지금 바로 통화를 시작해 보세요';

  @override
  String get home => '홈';

  @override
  String get callNow => '지금 통화하기';

  @override
  String get pronunciation => '발음';

  @override
  String get fluency => '유창성';

  @override
  String get rhythm => '리듬';

  @override
  String get analysisTimeout => '예상보다 시간이 오래 걸리고 있어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get analysisFailed => '대화를 분석하지 못했어요. 다시 시도해 주세요.';

  @override
  String get analyzingConversation => '대화를 분석하는 중…';

  @override
  String get analyzingSubtitle => '잠시만 기다려 주세요';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get nativeLabel => '원어민';

  @override
  String get meLabel => '나';

  @override
  String get pronunciationPlayError => '발음 음성을 재생하지 못했어요.';

  @override
  String get savedExpressionsLoadError => '저장한 표현을 불러오지 못했어요.';

  @override
  String get mySavedExpressions => '내가 저장한 표현';

  @override
  String get avatarTraits => '따뜻함 · 차분함 · 부드러움';

  @override
  String get priceFree => '무료';

  @override
  String get loginGoogleTokenError => '구글 로그인 토큰을 가져오지 못했어요.';

  @override
  String get loginGoogleSignInFailed => '구글 로그인에 실패했어요.';

  @override
  String get loginAppleSignInFailed => '애플 로그인에 실패했어요.';

  @override
  String get loginFacebookSignInFailed => '페이스북 로그인에 실패했어요.';

  @override
  String get loginKakaoSignInFailed => '카카오 로그인에 실패했어요.';

  @override
  String get loginContinueWithKakao => '카카오로 계속하기';

  @override
  String get loginContinueWithGoogle => '구글로 계속하기';

  @override
  String get loginContinueWithFacebook => '페이스북으로 계속하기';

  @override
  String get loginContinueWithApple => '애플로 계속하기';

  @override
  String get loginContinueWithEmail => '이메일로 계속하기';

  @override
  String get loginOrDivider => '또는';

  @override
  String get loginNoAccount => '계정이 없으신가요?';

  @override
  String get signUp => '회원가입';

  @override
  String get loginTermsNoticePrefix => '계속 진행하면 ';

  @override
  String get loginTermsNoticeAnd => ' 및 ';

  @override
  String get loginTermsNoticeSuffix => '에 동의하게 됩니다.';

  @override
  String get loginLogIn => '로그인';

  @override
  String get fieldEmailLabel => '이메일';

  @override
  String get emailHint => '이메일을 입력하세요';

  @override
  String get fieldPasswordLabel => '비밀번호';

  @override
  String get passwordHint => '비밀번호를 입력하세요';

  @override
  String get loginRememberMe => '로그인 상태 유지';

  @override
  String get loginForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginLoggingIn => '로그인 중...';

  @override
  String get passwordLengthError => '비밀번호는 8~16자여야 해요.';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않아요.';

  @override
  String get signupCheckInput => '입력한 내용을 확인해 주세요.';

  @override
  String get fieldConfirmPasswordLabel => '비밀번호 확인';

  @override
  String get confirmPasswordHint => '비밀번호를 다시 입력하세요';

  @override
  String get signupSigningUp => '가입 중...';

  @override
  String get signupHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get passwordMethodEmailRequired => '이메일을 입력하세요';

  @override
  String get passwordResetTitle => '비밀번호 재설정';

  @override
  String get passwordMethodDescription => '비밀번호 재설정 코드를 받을 이메일 주소를 입력하세요.';

  @override
  String get emailAddressHint => '이메일 주소';

  @override
  String get passwordMethodSending => '전송 중...';

  @override
  String get passwordMethodSendEmail => '이메일 보내기';

  @override
  String get passwordCodeTitle => '코드 입력';

  @override
  String get passwordCodeDescription =>
      '이메일로 복구 코드를 보내드렸어요. 코드를 입력하고 계속 진행하세요.';

  @override
  String get passwordCodeNoCode => '코드를 받지 못하셨나요?';

  @override
  String get passwordCodeResend => '코드 재전송';

  @override
  String get passwordCodeVerifying => '확인 중...';

  @override
  String get passwordNewTitle => '새 비밀번호';

  @override
  String get passwordNewDescription => '계정의 새 비밀번호를 설정하세요.';

  @override
  String get fieldNewPasswordLabel => '새 비밀번호';

  @override
  String get newPasswordHint => '새 비밀번호를 입력하세요';

  @override
  String get fieldConfirmNewPasswordLabel => '새 비밀번호 확인';

  @override
  String get confirmNewPasswordHint => '새 비밀번호를 다시 입력하세요';

  @override
  String get passwordNewSubmitting => '제출 중...';

  @override
  String get passwordNewSubmit => '제출';

  @override
  String get passwordCompleteTitle => '비밀번호 재설정 완료';

  @override
  String get passwordCompleteBody => '비밀번호가 재설정되었어요. 새 비밀번호로 로그인해 계속 진행하세요.';

  @override
  String get termsTitle => '이용약관';

  @override
  String get privacyTitle => '개인정보처리방침';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email의 새 비밀번호를 설정하세요.';
  }

  @override
  String get selectComplete => '완료';

  @override
  String get onboardingLanguageTitle => '모국어가 무엇인가요?';

  @override
  String get onboardingReasonTitle => '언어를 배우는 이유가 무엇인가요?';

  @override
  String get onboardingReasonSubtitle => '목표에 맞춰 학습을 구성해드릴게요.';

  @override
  String get savingLabel => '저장 중...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => '이번 달 결제 금액';

  @override
  String get filterAll => '전체';

  @override
  String get filterSubscription => '구독';

  @override
  String get filterCharacter => '캐릭터';

  @override
  String get statusCompleted => '완료';

  @override
  String get lastPayment => '최근 결제';

  @override
  String subscriptionSwitchNote(String date) {
    return '$date까지 Pro 혜택을 계속 사용할 수 있고 그 이후 자동으로 무료 플랜으로 전환됩니다.';
  }

  @override
  String get freePlanCallLimit => '하루 1통화 · 5분 제한';

  @override
  String get freePlanBasicCharacters => '기본 캐릭터 사용 가능';

  @override
  String get availableForPurchase => '구매 가능';

  @override
  String get paymentsLoadError => '결제 내역을 불러오지 못했어요';

  @override
  String get noPayments => '아직 결제 내역이 없어요';

  @override
  String get morePaymentsExist => '이전 결제 내역은 아직 표시되지 않아요';

  @override
  String get undatedPayments => '날짜 없음';

  @override
  String get paymentLabelFallback => '결제';

  @override
  String learningPassed(int passed, int total) {
    return '$total문장 중 $passed개 통과';
  }

  @override
  String get hardestSound => '가장 어려웠던 소리';

  @override
  String get soundAccuracy => '소리별 정확도';

  @override
  String phonemeAttempts(int count) {
    return '음소 단위 · $count회 시도';
  }

  @override
  String get colSound => '소리';

  @override
  String get colAttempts => '시도';

  @override
  String get colCorrect => '정확';

  @override
  String get colAccuracy => '정확도';

  @override
  String get sentenceResults => '문장별 결과';

  @override
  String viewAllSentences(int count) {
    return '$count개 전체 보기';
  }

  @override
  String get colSentence => '문장';

  @override
  String get colPronunciation => '발음';

  @override
  String get colFluency => '유창';

  @override
  String get colRhythm => '리듬';

  @override
  String recentSessions(int count) {
    return '최근 $count세션';
  }

  @override
  String trendAverage(int score) {
    return '평균 $score';
  }

  @override
  String get today => '오늘';

  @override
  String get colDate => '날짜';

  @override
  String get colSentences => '문장';

  @override
  String get colScore => '점수';

  @override
  String get colChange => '변화';

  @override
  String dateToday(String date) {
    return '$date (오늘)';
  }

  @override
  String get accentAnalysis => '억양 분석';

  @override
  String get overallLevel => '종합 레벨';

  @override
  String get overallLevelSubtitle => '어휘·문법·표현';

  @override
  String get pronunciationAnalysis => '발음 분석';

  @override
  String get recentSessionsAverage => '최근 10세션 평균';

  @override
  String levelStage(int stage) {
    return '$stage단계';
  }

  @override
  String topPercent(int percent) {
    return '상위 $percent%';
  }

  @override
  String get allLearnersBasis => '전체 학습자 기준';

  @override
  String aheadOfLearners(int percent) {
    return '전체 학습자의 $percent%보다 앞서 있어요';
  }

  @override
  String get retakeLevelTest => '레벨 테스트 다시하기';

  @override
  String get practicePronunciation => '발음 학습하기';

  @override
  String get priceChangedTitle => '가격이 변경되었어요';

  @override
  String priceChangedBody(String price) {
    return '지금은 $price예요. 계속할까요?';
  }

  @override
  String get billingGroupPlanPurchases => '플랜과 구매';

  @override
  String get billingGroupInTheStore => '스토어에서';

  @override
  String get billingChangePlan => '플랜 변경';

  @override
  String get billingCompareAllPlans => '전체 플랜 비교';

  @override
  String get billingBuyACharacter => '캐릭터 구매';

  @override
  String get billingRestorePurchases => '구매 복원';

  @override
  String get billingPaymentHistory => '결제 내역';

  @override
  String get billingManageInTheStore => '스토어에서 관리';

  @override
  String get billingRefundHelp => '환불 안내';

  @override
  String get billingCancelSubscription => '구독 해지';

  @override
  String get billingResubscribe => '다시 구독하기';

  @override
  String get badgeCurrent => '사용 중';

  @override
  String get badgeTrial => '체험 중';

  @override
  String get badgeRenewing => '갱신 예정';

  @override
  String get badgePastDue => '결제 지연';

  @override
  String get badgePaused => '일시중지';

  @override
  String get badgeCanceling => '해지 예정';

  @override
  String get subscriptionTitle => '구독';

  @override
  String get plansTitle => '플랜';

  @override
  String get planFree => '무료';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Max 체험';

  @override
  String get freePlanPriceLine => '\$0.00 — 하루 한 번 통화';

  @override
  String pricePerMonthLine(String amount) {
    return '월 $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date까지 무료';
  }

  @override
  String get todaysCalls => '오늘의 통화';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit회 중 $used회 사용';
  }

  @override
  String get firstPaymentLabel => '첫 결제';

  @override
  String get nextPaymentLabel => '다음 결제';

  @override
  String get retryingUntilLabel => '재시도 기한';

  @override
  String get pausedSinceLabel => '일시중지 시작일';

  @override
  String planEndsLabel(String plan) {
    return '$plan 종료';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Pro로 무제한 통화';

  @override
  String bannerGoUnlimitedSub(String price) {
    return '무제한 통화 · 회당 15분 · 월 $price';
  }

  @override
  String get bannerMaxUpsellTitle => 'Max로 영상통화 시작';

  @override
  String bannerMaxUpsellSub(String price) {
    return '얼굴 보며 통화 · 월 $price';
  }

  @override
  String get bannerAnnualSwitchTitle => '연간 플랜으로 전환';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '연 $yearly · 월 $perMonth';
  }

  @override
  String get bannerPaymentFailedTitle => '결제가 되지 않았어요';

  @override
  String get bannerPaymentFailedSub => '스토어에서 결제 수단을 업데이트하면 Pro가 유지돼요';

  @override
  String get bannerPausedTitle => '플랜이 일시중지됐어요';

  @override
  String get bannerPausedSub => '결제가 완료되지 않았어요';

  @override
  String get noteRestoreHint => '다른 기기에서 이미 구독 중이신가요? 복원하면 이 기기에서도 이용할 수 있어요.';

  @override
  String get noteStoreHandled => '결제 수단, 플랜 변경, 해지는 스토어에서 처리돼요.';

  @override
  String get noteFairUse => '무제한 이용에는 공정 이용 정책이 적용돼요.';

  @override
  String noteTrialEnds(String date) {
    return '체험은 $date에 끝나요. 그 전에 스토어에서 해지하면 요금이 청구되지 않아요.';
  }

  @override
  String get noteGrace => '유예 기간에도 혜택은 계속 유지돼요. 해지는 앱에서 막지 않아요.';

  @override
  String get noteHold => '결제가 완료될 때까지 Pro가 일시중지돼요. 캐릭터와 학습 기록은 안전하게 보관돼요.';

  @override
  String noteEnding(String date) {
    return '플랜 종료가 예약됐어요. $date까지 혜택이 유지되고, 이후 무료 플랜으로 전환돼요. 언제든 다시 구독할 수 있어요.';
  }

  @override
  String get trialExpiredTitle => 'Max 체험이 끝났어요';

  @override
  String get trialExpiredSub => '지금은 무료 플랜이에요';

  @override
  String get seePlans => '플랜 보기';

  @override
  String get currentPlanTitle => '현재 플랜';

  @override
  String get badgeRecommended => '추천';

  @override
  String get perMonthUnit => '/월';

  @override
  String get planTaglinePro => '무제한 통화. 회당 15분.';

  @override
  String get planTaglineMax => '이제 얼굴을 보며 대화해요.';

  @override
  String get planTaglineFree => '하루 한 번, 무료 통화.';

  @override
  String get bulletProCalls => '원하는 만큼 음성통화';

  @override
  String get bulletProLength => '통화당 15분';

  @override
  String get bulletProScoring => '글자 단위 발음 채점';

  @override
  String get bulletProCorrections => '모국어에 맞춘 교정';

  @override
  String get bulletProBeaverCalls => '비버가 먼저 전화해요';

  @override
  String get bulletMaxVideo => '얼굴 보며 영상통화';

  @override
  String get bulletMaxEverything => 'Pro의 모든 기능 포함';

  @override
  String get bulletMaxCharacters => '모든 캐릭터 무제한';

  @override
  String get bulletMaxStudyBook => '내 수준에 맞춘 학습 노트';

  @override
  String get bulletMaxWeeklyReport => '발음 변화를 담은 주간 리포트';

  @override
  String get bulletFreeCall => '하루 한 번 5분 음성통화';

  @override
  String get bulletFreeCheck => '하루 한 번 발음 체크';

  @override
  String get bulletFreeAccent => '억양 체크 무제한';

  @override
  String get bulletFreeCharacter => '시작 캐릭터 1개';

  @override
  String get ctaGoUnlimited => '무제한으로 시작하기';

  @override
  String get ctaTurnOnVideo => '영상통화 켜기';

  @override
  String get noteCallLength => '통화는 회당 15분이에요.';

  @override
  String get paywallProTitle1 => '새벽 3시에도 깨어 있는';

  @override
  String get paywallProTitle2 => '나의 한국인 친구';

  @override
  String get paywallProSub => '무제한 통화. 회당 15분. 일 년 내내.';

  @override
  String get paywallLimitHeadline => 'Pro는 제한이 없어요.';

  @override
  String get limitBannerCallTitle => '오늘의 통화를 모두 썼어요';

  @override
  String get limitBannerCallSub => '무료 플랜은 하루 한 번 통화할 수 있어요';

  @override
  String get limitBannerCheckTitle => '오늘의 체크를 모두 썼어요';

  @override
  String get limitBannerCheckSub => '무료 플랜은 하루 한 번 체크할 수 있어요';

  @override
  String get bulletProCharactersForever => '구매한 캐릭터는 영원히 내 것';

  @override
  String get paywallMaxTitle => '이제 얼굴을 보며 대화해요.';

  @override
  String get paywallMaxSub => '영상통화, 모든 캐릭터, 그리고 내 수준에 맞춘 학습 노트까지.';

  @override
  String get planMonthly => '월간';

  @override
  String get planAnnual => '연간';

  @override
  String proMonthlyPriceLine(String price) {
    return '월 $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · 월 $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '월 $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '연 $yearly · 월 $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return '월 $price · 언제든 스토어에서 해지 가능';
  }

  @override
  String ctaCaptionMax(String price) {
    return '월 $price · 언제든 스토어에서 해지 가능';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7일 무료 체험 후 월 $price · 언제든 스토어에서 해지 가능';
  }

  @override
  String get ctaCaptionAutoRenew => '해지할 때까지 자동으로 갱신됩니다.';

  @override
  String get footerTerms => '이용약관';

  @override
  String get footerPrivacy => '개인정보 처리방침';

  @override
  String get noteMaxCharacters =>
      'Max로 잠금 해제된 캐릭터는 구독 중에 이용할 수 있어요. 직접 구매한 캐릭터는 계속 내 것이에요.';

  @override
  String get processingTitle => '구매를 확인하고 있어요';

  @override
  String get processingSub => '보통 몇 초면 끝나요.';

  @override
  String get successProTitle => 'Pro가 시작됐어요.';

  @override
  String get successProSub => '지금부터 무제한으로 통화할 수 있어요.';

  @override
  String get successProBenefit1 => '원하는 만큼 통화 — 회당 15분';

  @override
  String get successProBenefit2 => '발음 체크 무제한';

  @override
  String get successProBenefit3 => '모든 캐릭터와 단품 구매';

  @override
  String get successMaxTitle => '이제 얼굴이 보여요.';

  @override
  String get successMaxSub => '영상통화가 켜졌어요. 통화 중 영상 버튼을 눌러 보세요.';

  @override
  String get successMaxBenefit1 => '얼굴 보며 영상통화';

  @override
  String get successMaxBenefit2 => '모든 캐릭터 무제한, 신규 캐릭터 우선 제공';

  @override
  String get successMaxBenefit3 => '내 수준에 맞춘 학습 노트';

  @override
  String get ctaStartACall => '통화 시작하기';

  @override
  String get ctaStartAVideoCall => '영상통화 시작하기';

  @override
  String get ctaSeeYourSubscription => '내 구독 보기';

  @override
  String successProCaption(String price) {
    return '해지 전까지 매월 $price가 청구돼요. 관리와 해지는 언제든 스토어에서 할 수 있어요.';
  }

  @override
  String successMaxCaption(String price) {
    return '해지 전까지 매월 $price가 청구돼요. 관리와 해지는 언제든 스토어에서 할 수 있어요.';
  }

  @override
  String get plansErrorTitle => '플랜을 불러오지 못했어요';

  @override
  String get plansErrorSub => '스토어가 응답하지 않았어요.';

  @override
  String get ctaTryAgain => '다시 시도';

  @override
  String get plansErrorCaption => '요금은 청구되지 않았어요.';

  @override
  String get changePlanTitle => '플랜 변경';

  @override
  String get moveToMaxTitle => 'Max로 이동';

  @override
  String maxPriceShort(String price) {
    return '월 $price';
  }

  @override
  String get moveToMaxCardSub => '얼굴 보며 영상통화 · 모든 캐릭터 · 맞춤 학습 노트';

  @override
  String get whatHappensNow => '지금부터 이렇게 돼요';

  @override
  String get maxStartsLabel => 'Max 시작';

  @override
  String get immediately => '즉시';

  @override
  String get unusedProTime => '남은 Pro 기간';

  @override
  String get creditedTowardMax => 'Max 요금에서 차감';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Max로 전환';

  @override
  String get upgradeCaption =>
      '새 플랜이 바로 시작돼요. 남은 Pro 기간은 요금에서 차감되고, 이중 청구는 없어요.';

  @override
  String get moveToProTitle => 'Pro로 이동';

  @override
  String get moveToProSub => '오늘은 아무것도 바뀌지 않아요. 이미 결제한 달이 끝날 때까지 Max가 유지돼요.';

  @override
  String get maxRunsUntil => 'Max 유지 기한';

  @override
  String get proStarts => 'Pro 시작';

  @override
  String get whatYouKeep => '계속 유지되는 것';

  @override
  String get keepBenefitCalls => '무제한 음성통화, 회당 15분';

  @override
  String get keepBenefitCharacters => '구매한 캐릭터는 영원히 내 것';

  @override
  String downgradeWarning(String date) {
    return '영상통화와 Max 전용 캐릭터는 $date에 꺼져요.';
  }

  @override
  String get ctaSwitchToPro => 'Pro로 전환';

  @override
  String get ctaKeepMax => 'Max 유지하기';

  @override
  String get winbackSkip => '건너뛰기';

  @override
  String get winbackTitle => 'Pro 플랜이 끝났어요';

  @override
  String get winbackSub => '지금은 무료 플랜이에요 — 하루 한 번 통화할 수 있어요.';

  @override
  String get winbackQuestion => '떠나신 이유를 알려 주실래요?';

  @override
  String get winbackReasonExpensive => '가격이 부담돼요';

  @override
  String get winbackReasonUnused => '충분히 쓰지 않았어요';

  @override
  String get winbackReasonMissing => '필요한 기능이 없었어요';

  @override
  String get winbackReasonOtherApp => '다른 앱을 찾았어요';

  @override
  String get winbackReasonElse => '기타';

  @override
  String get ctaSend => '보내기';

  @override
  String get ctaNotNow => '다음에';

  @override
  String get winbackCaption => '이 설문으로 플랜이 복구되지는 않아요. 재구독은 스토어에서 할 수 있어요.';

  @override
  String get ctaContinue => '계속';

  @override
  String get ctaClose => '닫기';

  @override
  String get ovRestoreSuccessTitle => 'Pro가 돌아왔어요';

  @override
  String get ovRestoreSuccessBody => '구독을 찾아 이 기기에서 다시 켰어요.';

  @override
  String get ovRestoreEmptyTitle => '복원할 항목이 없어요';

  @override
  String get ovRestoreEmptyBody => '이 스토어 계정에 연결된 활성 구독이 없어요.';

  @override
  String get ovRestoreOtherTitle => '다른 계정의 플랜이에요';

  @override
  String get ovRestoreOtherBody => '이 구독은 이미 다른 BeaverTalk 계정에서 사용 중이에요.';

  @override
  String get ctaSignInThatAccount => '해당 계정으로 로그인';

  @override
  String get ctaGetHelp => '도움받기';

  @override
  String get ovCharacterOfferTitle => 'Pro는 아직 고민되나요?';

  @override
  String get ovCharacterOfferBody => '캐릭터 하나를 골라 평생 소장하세요. 구독도 갱신도 없는 단품 구매예요.';

  @override
  String get rowOneCharacter => '캐릭터 1개';

  @override
  String rowFromPrice(String price) {
    return '$price부터';
  }

  @override
  String get rowYoursForever => '평생 소장';

  @override
  String get rowNoRenewal => '갱신 없음';

  @override
  String get rowWorksOnFree => '무료 플랜에서도 사용';

  @override
  String get rowYes => '가능';

  @override
  String get ctaSeeCharacters => '캐릭터 보기';

  @override
  String get ovNotEligibleTitle => '해지할 구독이 없어요';

  @override
  String get ovNotEligibleBody => '지금은 무료 플랜이에요. 이 계정에는 활성 구독이 없어요.';

  @override
  String get ovCancelDownsellTitle => '떠나시기 전에';

  @override
  String get ovCancelDownsellBody => '해지는 스토어에서 진행돼요. 알아 두면 좋은 두 가지가 있어요.';

  @override
  String get rowPayYearlyInstead => '연간 결제로 바꾸면';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '월 $price';
  }

  @override
  String get rowCharactersYouBought => '구매한 캐릭터';

  @override
  String get rowProRunsUntil => 'Pro 유지 기한';

  @override
  String get ctaSwitchToYearly => '연간으로 전환';

  @override
  String get ctaContinueToStore => '스토어로 이동';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return '연간 결제로 $saved 아끼기';
  }

  @override
  String get ovAnnualSwitchBody => 'Pro를 두 달째 쓰고 계시네요. 연간 플랜이 더 저렴해요.';

  @override
  String get rowYouSave => '절약 금액';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => '연간';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => '월간으로 1년';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => '월간으로 전환';

  @override
  String ovMonthlySwitchBody(String date) {
    return '연간 플랜이 $date까지 유지돼요. 월간 결제는 그다음 날부터 시작돼요.';
  }

  @override
  String get rowMonthlyBillingStarts => '월간 결제 시작';

  @override
  String get rowMonthlyLabel => '월간';

  @override
  String get rowYearlyWorkedOut => '연간 환산 금액';

  @override
  String get ctaSwitchToMonthly => '월간으로 전환';

  @override
  String get ovRefundHelpTitle => '환불은 스토어에서 처리돼요';

  @override
  String get ovRefundHelpBody => '저희가 직접 환불해 드릴 수는 없어요. 모든 요청은 스토어에서 심사해요.';

  @override
  String get ctaGoToStore => '스토어로 가기';

  @override
  String get ovTrialEndingTitle => '체험이 내일 끝나요';

  @override
  String get ovTrialEndingBody => '해지하지 않으면 Max가 계속 유지돼요. 이렇게 진행돼요.';

  @override
  String get rowTrialEnds => '체험 종료';

  @override
  String get rowFirstCharge => '첫 청구';

  @override
  String get rowThenMonthly => '이후 매월';

  @override
  String get ctaCancelInStore => '스토어에서 해지';

  @override
  String get ovTrialStartTitle => 'Max 7일 무료 체험';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date까지 무료예요. 이후에는 스토어에서 해지하지 않으면 월 $price가 청구돼요.';
  }

  @override
  String get ctaStart7Days => '7일 무료로 시작';

  @override
  String get ovOtoTitle => '시작 전에 한 가지만 더';

  @override
  String get ovOtoBody => '좋은 선택이에요 — 무제한 통화가 지금 켜졌어요. 같은 Pro라도 연간 결제가 더 저렴해요.';

  @override
  String get ovFailedDeclinedTitle => '카드 결제가 거절됐어요';

  @override
  String get ovFailedDeclinedBody => '스토어에서 결제가 되지 않았어요. 요금은 청구되지 않았어요.';

  @override
  String get ctaUpdatePaymentMethod => '결제 수단 업데이트';

  @override
  String get ovFailedCanceledTitle => '결제가 취소됐어요';

  @override
  String get ovFailedCanceledBody => '아직 무료 플랜 그대로예요. 요금은 청구되지 않았어요.';

  @override
  String get ovFailedStoreTitle => '문제가 발생했어요';

  @override
  String get ovFailedStoreBody => '스토어에 연결하지 못했어요. 요금은 청구되지 않았어요.';

  @override
  String get ovAlreadyTitle => '이미 Pro를 쓰고 있어요';

  @override
  String get ovAlreadyBody => '이 스토어 계정에 활성 플랜이 있어요. 새로 구매할 필요가 없어요.';

  @override
  String get ctaSeeMySubscription => '내 구독 보기';

  @override
  String get subCancelTitle => '구독 해지';

  @override
  String subCancelBody(String date) {
    return 'Pro는 $date까지 유지돼요. 그 후 무료 플랜으로 전환돼요.';
  }

  @override
  String get subWhatYouLose => '잃게 되는 것';

  @override
  String get benefitCalls15 => '무제한 통화, 회당 15분';

  @override
  String get benefitScoring => '글자 단위 발음 채점';

  @override
  String get benefitEveryCharacter => '모든 캐릭터 무제한';

  @override
  String get ctaKeepPro => 'Pro 유지하기';

  @override
  String get subPaymentTitle => '결제 업데이트';

  @override
  String get subPaymentBody => '결제가 완료되지 않았어요. 유예 기간 동안 Pro는 계속 유지돼요.';

  @override
  String get subHowToFix => '해결 방법';

  @override
  String get fixStep1 => '스토어를 열고 결제 수단을 업데이트하세요';

  @override
  String get fixStep2 => '돌아오면 플랜이 자동으로 재개돼요';

  @override
  String get fixStep3 => '이중 청구는 없어요';

  @override
  String get subResubTitle => '다시 구독하기';

  @override
  String subResubBody(String date) {
    return 'Pro가 $date에 끝나요. 자동 갱신을 다시 켜면 그대로 유지돼요.';
  }

  @override
  String get subWhatYouKeep => '계속 유지되는 것';

  @override
  String get ctaTurnItBackOn => '다시 켜기';

  @override
  String get flTodayTitle => '오늘의 통화를 다 썼어요';

  @override
  String get flTodayBody => '끊긴 대화, 지금 바로 이어가요.';

  @override
  String get flCheckTitle => '오늘의 체크를 다 썼어요';

  @override
  String get flCheckBody => '무료 플랜은 하루 한 번 체크할 수 있어요. Pro는 무제한이에요.';

  @override
  String get flBenefitCalls => 'Pro로 무제한 통화 · 회당 15분';

  @override
  String get flBenefitChecks => 'Pro로 발음 체크 무제한';

  @override
  String flCaption(String price) {
    return '월 $price · 언제든 해지 가능';
  }

  @override
  String flUsage(String used, String limit) {
    return '$limit 중 $used 사용';
  }

  @override
  String get ctaMaybeTomorrow => '내일 다시 할게요';

  @override
  String get accountSection => '계정';

  @override
  String get nicknameLabel => '닉네임';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => '로그인 방식';

  @override
  String get joinedLabel => '가입일';

  @override
  String get editNicknameTitle => '닉네임 수정';

  @override
  String get nicknameRule => '2–12자 · 영문과 숫자만 가능해요';

  @override
  String get ctaSave => '저장';

  @override
  String get subscriptionRow => '구독';

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
  String get paywallLeaveTitle => '지금 나가면 구독할 수 없어요';

  @override
  String get paywallLeaveBody => '혜택은 결제 직후 바로 열려요. 마이페이지에서 언제든 다시 올 수 있어요.';

  @override
  String get ctaKeepLooking => '계속 볼게요';

  @override
  String get ctaLeaveAnyway => '그래도 나갈래요';

  @override
  String get iapCharacterSuccessTitle => '새 친구가 함께해요!';

  @override
  String get iapCharacterSuccessBody =>
      '이 캐릭터는 영원히 내 거예요. 플랜이 바뀌어도 그대로이고, 구매 복원으로 어떤 기기에서든 되찾을 수 있어요.';

  @override
  String get iapCharacterFailedBody => '구매가 완료되지 않았어요. 결제된 금액은 없으니 다시 시도해 주세요.';

  @override
  String get noAccentDataTitle => '아직 억양 데이터가 없어요';

  @override
  String get noAccentDataBody => '통화를 이어가면 억양 특징이 모여요.';

  @override
  String get noLevelYetTitle => '아직 레벨이 없어요';

  @override
  String get noLevelYetBody => '첫 통화를 마치면 레벨이 나와요.';

  @override
  String get noPronunciationDataTitle => '아직 발음 기록이 없어요';

  @override
  String get noPronunciationDataBody => '통화에서 말한 문장으로 발음을 분석해요.';

  @override
  String get noCharacterNote => '아직 남긴 말이 없어요';

  @override
  String get noPhonemesYet => '분석할 소리가 아직 없어요';

  @override
  String get noSentencesYet => '분석할 문장이 아직 없어요';

  @override
  String get takeLevelTest => '레벨 테스트 받기';

  @override
  String get reviewToSeeScore => '복습하면 발음 점수가 나와요';

  @override
  String get playAgain => '다시 하기';

  @override
  String get difficultySlow => '느리게';

  @override
  String get difficultyNormal => '보통';

  @override
  String get difficultyFast => '빠르게';

  @override
  String get difficultyLabel => '난이도';

  @override
  String get connected => '연결됨';

  @override
  String get unlockedWithMax => 'Max로 이용 가능';

  @override
  String get callModeSheetTitle => '어떻게 대화할까요?';

  @override
  String get callModeSheetSubtitle => '지금 통화에 바로 적용돼요';

  @override
  String get callModeFreeTalk => '자유 대화';

  @override
  String get callModeFreeTalkDesc => '교정 없이 편하게 이어가요';

  @override
  String get callModeStudy => '표현 학습';

  @override
  String get callModeStudyDesc => '표현을 하나씩 짚고 발음을 고쳐요';

  @override
  String get callModeChange => '대화 방식 바꾸기';

  @override
  String get callModeKeep => '닫기';

  @override
  String get callExitTitle => '통화를 끝낼까요?';

  @override
  String get callExitSubtitle => '지금 끝내도 오늘 통화 1회가 사용돼요';

  @override
  String get callExitKeep => '계속 통화하기';

  @override
  String get callExitConfirm => '통화 종료';

  @override
  String get callMicMute => '음소거';

  @override
  String get callMicUnmute => '음소거 해제';

  @override
  String get callPushToTalk => '꾹 눌러 말하기';

  @override
  String get callFreeEndedTitle => '무료 통화가 끝났어요';

  @override
  String get callFreeEndedCta => '구독하고 계속 대화하기';

  @override
  String get callKeepGoingTitle => '더 이어갈까요?';

  @override
  String get callKeepGoingSubtitle => '통화는 5분씩 이어져요. 그때마다 다시 여쭤볼게요.';

  @override
  String get articulationSelectedWord => '선택한 단어';

  @override
  String get articulationYouSaid => '내 발음';

  @override
  String get articulationTargetSound => '목표';

  @override
  String get reportEntry => '신고하기';

  @override
  String get reportTitle => '신고';

  @override
  String get reportPrompt => '어떤 문제가 있었나요?';

  @override
  String get reportGuide => 'AI 캐릭터와의 대화에서 불쾌했던 내용을 알려주세요. 접수된 신고는 모두 검토해요.';

  @override
  String get reportReasonSexual => '성적인 내용';

  @override
  String get reportReasonHate => '혐오 · 차별 표현';

  @override
  String get reportReasonViolence => '폭력적이거나 위협적인 내용';

  @override
  String get reportReasonSelfHarm => '자해를 부추기는 내용';

  @override
  String get reportReasonMisinfo => '잘못된 정보';

  @override
  String get reportReasonOther => '그 밖의 문제';

  @override
  String get reportDetailHint => '어떤 일이 있었는지 적어주세요 (선택)';

  @override
  String get reportSubmit => '신고 접수';

  @override
  String get reportDoneTitle => '신고가 접수되었어요';

  @override
  String get reportDoneBody => '검토 후 필요한 조치를 취할게요. 비버톡을 안전하게 지켜주셔서 고맙습니다.';

  @override
  String get reportFailed => '신고를 접수하지 못했어요. 다시 시도해주세요.';

  @override
  String get hwTitle => '숙제';

  @override
  String get hwJoinCodeTitle => '참여 코드를 입력하세요';

  @override
  String get hwJoinCodeSubtitle => '선생님이 알려준 6자리 코드예요';

  @override
  String get hwJoinCodeLabel => '참여 코드';

  @override
  String get hwJoinCodeHelp => '코드는 대소문자를 구분하지 않아요';

  @override
  String get hwJoinConfirmTitle => '이 반이 맞나요?';

  @override
  String get hwJoinConfirmSubtitle => '아니라면 코드를 다시 확인해 주세요';

  @override
  String get hwJoinFieldInstitution => '기관';

  @override
  String get hwJoinFieldTeacher => '선생님';

  @override
  String get hwJoinFieldLearners => '인원';

  @override
  String get hwJoinFieldTerm => '학기';

  @override
  String get hwJoinConfirmNote => '반 이름은 선생님이 쓴 그대로예요. 번역하지 않아요.';

  @override
  String get hwJoinConfirmYes => '네, 맞아요';

  @override
  String get hwJoinConfirmRetry => '코드 다시 입력';

  @override
  String get hwJoinProfileTitle => '반에서 쓸 이름을 알려주세요';

  @override
  String get hwJoinProfileSubtitle => '선생님이 출석부와 맞춰볼 이름이에요';

  @override
  String get hwJoinNameLabel => '이름';

  @override
  String get hwJoinNameHelp => '앱에서 쓰는 이름과 달라도 괜찮아요';

  @override
  String get hwJoinStudentNoLabel => '학번 (선택)';

  @override
  String get hwJoinStudentNoHelp => '선생님이 명단과 맞출 때 써요';

  @override
  String get hwJoinConsentTitle => '선생님에게 공유되는 것';

  @override
  String get hwJoinConsentSubtitle => '동의해야 반에 들어갈 수 있어요';

  @override
  String get hwJoinConsentSharedHeading => '선생님에게 공유돼요';

  @override
  String get hwJoinConsentShared1 => '반 이름 · 학번';

  @override
  String get hwJoinConsentShared2 => '숙제를 했는지 여부';

  @override
  String get hwJoinConsentShared3 => '통과한 문장 수 · 못 한 문장';

  @override
  String get hwJoinConsentShared4 => '과제 통화의 시간 · 요약';

  @override
  String get hwJoinConsentNotSharedHeading => '공유되지 않아요';

  @override
  String get hwJoinConsentNotShared1 => '이메일 · 전화번호';

  @override
  String get hwJoinConsentNotShared2 => '앱 이름 · 프로필 · 캐릭터';

  @override
  String get hwJoinConsentNotShared3 => '국적 · 모국어';

  @override
  String get hwJoinConsentNotShared4 => '반 밖에서 한 통화와 학습';

  @override
  String get hwJoinConsentNotShared5 => '구독 · 결제 정보';

  @override
  String get hwJoinConsentAgree => '위 내용에 동의합니다';

  @override
  String get hwJoinConsentCta => '동의하고 참여하기';

  @override
  String hwJoinDoneTitle(String className) {
    return '$className에 들어왔어요';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '숙제 $count개가 기다리고 있어요';
  }

  @override
  String get hwJoinDoneNoAssignment => '아직 받은 숙제가 없어요';

  @override
  String get hwJoinDoneNextDue => '가장 빠른 마감';

  @override
  String get hwJoinDoneRosterName => '반에서 쓸 이름';

  @override
  String get hwJoinDoneCta => '숙제 보러 가기';

  @override
  String get hwJoinErrorNotFound => '참여 코드를 찾을 수 없어요';

  @override
  String get hwJoinErrorNotFoundBody => '여섯 자리를 다시 확인해 주세요.';

  @override
  String get hwJoinErrorExpired => '기간이 지난 코드예요';

  @override
  String get hwJoinErrorExpiredBody => '선생님께 새 코드를 받아 주세요.';

  @override
  String get hwJoinErrorFull => '반 정원이 찼어요';

  @override
  String get hwJoinErrorFullBody => '선생님께 알려 주세요.';

  @override
  String get hwJoinFailed => '참여하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get hwSectionInProgress => '진행 중';

  @override
  String get hwSectionUpcoming => '예정';

  @override
  String get hwSectionDone => '완료';

  @override
  String get hwLeaveClassLink => '교실에서 나가기';

  @override
  String get hwListEmptyTitle => '받은 숙제가 없어요';

  @override
  String get hwListEmptyBody => '선생님이 숙제를 내면 여기에 보여요.';

  @override
  String get hwListFailed => '숙제를 불러오지 못했어요.';

  @override
  String get hwRetry => '다시 시도';

  @override
  String get hwBadgeDone => '완료';

  @override
  String get hwBadgeOverdue => '미제출';

  @override
  String hwBadgeOverdueDays(int days) {
    return '미제출 · $days일 지남';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => '오늘 마감';

  @override
  String get hwActivitySpeaking => '발음';

  @override
  String get hwActivityConversation => '회화';

  @override
  String get hwActivityWorkbook => '워크북';

  @override
  String hwChapterLabel(String chapter) {
    return 'Chapter $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => '나의 발음 점수를 확인해보세요';

  @override
  String get hwTaskConversationDesc => '배운 표현을 실제로 적용해봐요';

  @override
  String get hwTaskWorkbookDesc => '워크북에서 쓰면서 공부해요';

  @override
  String get hwCtaStudy => '학습하기';

  @override
  String get hwCtaResult => '학습결과';

  @override
  String get hwCtaDownload => '다운로드';

  @override
  String get hwSpeakingNoScore => '아직 발음을 하지 않았어요';

  @override
  String get hwWorkbookUnavailable => '워크북 파일이 아직 등록되지 않았어요.';

  @override
  String get hwDetailClosed => '마감된 과제예요. 더 이상 제출할 수 없어요.';

  @override
  String get hwLeaveTitle => '교실을 나갈까요?';

  @override
  String get hwLeaveBody => '선생님이 더 이상 숙제 결과를 볼 수 없어요.';

  @override
  String get hwLeaveConfirm => '나가기';

  @override
  String get hwLeaveCancel => '그대로 있기';

  @override
  String get hwLeaveFailed => '교실을 나가지 못했어요.';

  @override
  String get hwMyClass => '나의 수업';

  @override
  String get hwClassEmptyTitle => '아직 참여한 반이 없어요';

  @override
  String get hwClassEmptySubtitle => '선생님께 받은 코드를 입력해 보세요';

  @override
  String get hwClassEmptyCta => '참여 코드 입력';

  @override
  String get hwClassContinueCta => '이어서 하기';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '숙제 $count개가 내일 마감이에요';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return '미제출 숙제가 $count개 있어요';
  }

  @override
  String get hwSpeakingUnavailable => '아직 이 과제의 문장을 받아올 수 없어요.';

  @override
  String get hwBadgeClosed => '마감됨';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total문장 중 $passed문장 통과';
  }
}
