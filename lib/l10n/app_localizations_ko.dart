// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

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
  String get scheduleManagement => '일정';

  @override
  String get alarms => '알람';

  @override
  String get addSchedule => '일정 추가';

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
  String get callPartner => '캐릭터';

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
  String get selectACountry => '국가 선택';

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
  String get noAlarms => '아직 알람이 없어요';

  @override
  String get noAlarmsBody => '학습 리마인더를 추가해서\n꾸준한 습관을 만들어 보세요.';

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
  String get pricePerMonth => '\$12.9 / 월';

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
  String get loginContinueWithKakao => '카카오로 계속하기';

  @override
  String get loginContinueWithGoogle => '구글로 계속하기';

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
}
