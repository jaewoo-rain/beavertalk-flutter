// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Đã kết thúc cuộc gọi $duration';
  }

  @override
  String get callRatingPrompt => 'Cuộc gọi của bạn thế nào?';

  @override
  String get ratingBad => 'Chưa tốt lắm';

  @override
  String get ratingOkay => 'Ổn';

  @override
  String get ratingGood => 'Tốt';

  @override
  String get goHome => 'Trang chủ';

  @override
  String get viewAnalysis => 'Xem phân tích';

  @override
  String get loadingShort => 'Đang tải…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Gửi đánh giá thất bại: $message';
  }

  @override
  String get callInfoNotFound =>
      'Không tìm thấy thông tin cuộc gọi, bỏ qua phân tích.';

  @override
  String get tabRecords => 'Bản ghi';

  @override
  String get tabArchive => 'Đã lưu';

  @override
  String get callHistory => 'Lịch sử cuộc gọi';

  @override
  String get conversationRecord => 'Bản ghi hội thoại';

  @override
  String get noCallRecords => 'Chưa có bản ghi cuộc gọi nào';

  @override
  String get noCallRecordsBody =>
      'Sau khi bạn hoàn thành cuộc gọi đầu tiên với AI,\nbản ghi sẽ xuất hiện ở đây.';

  @override
  String get startCall => 'Bắt đầu cuộc gọi';

  @override
  String get recordsLoadError => 'Không thể tải bản ghi';

  @override
  String get tryAgainLater => 'Vui lòng thử lại sau.';

  @override
  String get retry => 'Thử lại';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes phút $seconds giây';
  }

  @override
  String get scheduleManagement => 'Lịch';

  @override
  String get alarms => 'Báo thức';

  @override
  String get addSchedule => 'Thêm lịch';

  @override
  String get editSchedule => 'Chỉnh sửa lịch';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get alarmsLoadError => 'Không thể tải báo thức';

  @override
  String get charactersLoadError => 'Không thể tải nhân vật';

  @override
  String get noCharacters => 'Không có nhân vật nào';

  @override
  String get close => 'Đóng';

  @override
  String get repeat => 'Lặp lại';

  @override
  String get callPartner => 'Nhân vật';

  @override
  String get am => 'SA';

  @override
  String get pm => 'CH';

  @override
  String get save => 'Lưu';

  @override
  String get conversation => 'Hội thoại';

  @override
  String get review => 'Ôn tập';

  @override
  String get pronunciationChallenge => 'Thử thách phát âm';

  @override
  String get newExpressions => 'Cách diễn đạt mới';

  @override
  String get analysisResult => 'Kết quả phân tích';

  @override
  String get noNewExpressions =>
      'Không có cách diễn đạt mới nào từ cuộc hội thoại này.';

  @override
  String get practice => 'Luyện tập';

  @override
  String recentScore(int score) {
    return 'Điểm gần đây $score%';
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
  String get oneFixTitle => 'One thing to fix today';

  @override
  String streakBadge(int count) {
    return '$count calls in a row';
  }

  @override
  String get firstTimeTitle => 'A first this time';

  @override
  String newExpressionsCount(int count) {
    return 'New expressions $count';
  }

  @override
  String expressionsTotal(int count) {
    return '$count total';
  }

  @override
  String get nextCallTitle => 'To try on your next call';

  @override
  String get nextCallFooter => 'Shown on your next call\'s start screen';

  @override
  String get analysisLoadError => 'Không thể tải kết quả phân tích.';

  @override
  String get standardAudioNotReady => 'Âm thanh phát âm chuẩn chưa sẵn sàng.';

  @override
  String get standardAudioPlayError => 'Không thể phát âm thanh phát âm chuẩn.';

  @override
  String get selectACountry => 'Chọn quốc gia';

  @override
  String get selectYourLanguage => 'Chọn ngôn ngữ của bạn';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy';

  @override
  String get selectTime => 'Chọn thời gian';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get permissionTitle =>
      'Cho phép quyền truy cập\nđể có trải nghiệm mượt mà';

  @override
  String get permissionSubtitle =>
      'Các quyền cần thiết là bắt buộc để sử dụng dịch vụ.';

  @override
  String get permissionMicTitle => 'Micrô (bắt buộc)';

  @override
  String get permissionMicDesc =>
      'Cần thiết để trò chuyện với AI bằng tiếng Anh.';

  @override
  String get permissionNotifTitle => 'Thông báo (tùy chọn)';

  @override
  String get permissionNotifDesc =>
      'Chúng tôi sẽ gửi lời nhắc học tập và lịch cuộc gọi.';

  @override
  String get micPermissionNeededTitle => 'Cần quyền truy cập micrô';

  @override
  String get micPermissionNeededBody =>
      'Để trò chuyện với AI, bạn cần cho phép truy cập micrô. Vui lòng bật quyền này trong Cài đặt.';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get connectionFailedTitle => 'Kết nối thất bại';

  @override
  String get connectionFailedBody =>
      'Kiểm tra kết nối mạng của bạn\nvà thử lại.';

  @override
  String get checkout => 'Thanh toán';

  @override
  String get pay => 'Trả tiền';

  @override
  String get orderSummary => 'Tóm tắt đơn hàng';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get payMethodCard => 'Thẻ tín dụng / ghi nợ';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Beaver phiền phức';

  @override
  String get productTrait => 'Nhân vật cao cấp · Của bạn mãi mãi';

  @override
  String get amountItemPrice => 'Giá sản phẩm';

  @override
  String get amountDiscount => 'Giảm giá';

  @override
  String get amountTotal => 'Tổng cộng';

  @override
  String get paymentCompleteTitle => 'Thanh toán hoàn tất';

  @override
  String get paymentCompleteBody =>
      'Avatar đã được thêm vào bộ sưu tập của bạn.';

  @override
  String get viewCollection => 'Xem bộ sưu tập';

  @override
  String get receiptItem => 'Sản phẩm';

  @override
  String get receiptAmount => 'Số tiền';

  @override
  String get receiptMethod => 'Phương thức thanh toán';

  @override
  String get receiptDate => 'Ngày';

  @override
  String get paymentFailedTitle => 'Thanh toán thất bại';

  @override
  String get paymentFailedBody =>
      'Không thể xử lý thanh toán của bạn.\nVui lòng thử lại.';

  @override
  String get freeCallEndingTitle => 'Cuộc gọi miễn phí của bạn sắp kết thúc';

  @override
  String get freeCallEndingBody => 'Đăng ký để trò chuyện với Beaver lâu hơn.';

  @override
  String get subscribe => 'Đăng ký';

  @override
  String get endCall => 'Kết thúc cuộc gọi';

  @override
  String get callEnded => 'Cuộc gọi đã kết thúc.';

  @override
  String get connecting => 'Đang kết nối…';

  @override
  String get connectingHint => 'Việc này thường mất chưa đến 5 giây';

  @override
  String get callConnectFailed => 'Không thể kết nối cuộc gọi.';

  @override
  String get saveSentenceFailed => 'Không thể lưu câu.';

  @override
  String get recordStartFailed => 'Không thể bắt đầu ghi âm.';

  @override
  String get recordTooShort => 'Bản ghi âm quá ngắn. Vui lòng thử lại.';

  @override
  String get gradingFailed => 'Chấm điểm thất bại. Vui lòng thử lại.';

  @override
  String get listenStandard => 'Nghe phát âm chuẩn';

  @override
  String get saveSentence => 'Lưu câu';

  @override
  String get unsaveSentence => 'Bỏ lưu câu';

  @override
  String get scoringPronunciation => 'Đang chấm điểm phát âm của bạn…';

  @override
  String get noRecordingToPlay => 'Không có bản ghi âm để phát.';

  @override
  String get myRecordingPlayError => 'Không thể phát bản ghi âm của bạn.';

  @override
  String get next => 'Tiếp theo';

  @override
  String get endLearning => 'Kết thúc phiên';

  @override
  String get navCalendar => 'Lịch';

  @override
  String get navCall => 'Cuộc gọi';

  @override
  String get navStats => 'Thống kê';

  @override
  String get myPage => 'Trang của tôi';

  @override
  String get languageSaveFailed => 'Không thể lưu ngôn ngữ của bạn.';

  @override
  String get accountDeleteFailed => 'Không thể xóa tài khoản của bạn.';

  @override
  String get changeAvatar => 'Đổi avatar';

  @override
  String get avatarIntro =>
      'Giọng nói và độ khó khác nhau tùy theo đối tác gọi.\nMột số đối tác có thể yêu cầu thanh toán.';

  @override
  String myPartnersOwned(int count) {
    return 'Đối tác của tôi · Sở hữu $count';
  }

  @override
  String get limitedDiscount => 'Giảm giá có thời hạn';

  @override
  String get available => 'Có sẵn';

  @override
  String get inUse => 'Đang dùng';

  @override
  String get owned => 'Đã sở hữu';

  @override
  String get noCharactersToShow => 'Không có nhân vật nào để hiển thị';

  @override
  String get buy => 'Mua';

  @override
  String get noSavedSentences =>
      'Chưa có câu nào được lưu.\nHãy đánh dấu các câu từ bản ghi hội thoại của bạn.';

  @override
  String get noAlarms => 'Chưa có báo thức nào';

  @override
  String get noAlarmsBody =>
      'Thêm lời nhắc học tập\nđể xây dựng thói quen đều đặn.';

  @override
  String get subscriptionManage => 'Quản lý đăng ký';

  @override
  String get changePlan => 'Đổi gói';

  @override
  String get cancelSubscription => 'Hủy đăng ký';

  @override
  String get benefitsInUse => 'Quyền lợi của bạn';

  @override
  String get paymentInfo => 'Thông tin thanh toán';

  @override
  String get nextBillingDate => 'Ngày thanh toán tiếp theo';

  @override
  String get lostBenefitsTitle => 'Quyền lợi bạn sẽ mất nếu hủy';

  @override
  String get viewBillingHistory => 'Xem lịch sử thanh toán';

  @override
  String get keepUsingPro => 'Tiếp tục dùng Pro';

  @override
  String get proMembership => 'Thành viên Pro';

  @override
  String get pricePerMonth => '\$12.9 / mo';

  @override
  String get benefitUnlimitedCalls => 'Cuộc gọi không giới hạn';

  @override
  String get benefitDetailedAnalysis => 'Phân tích phát âm & ngữ pháp chi tiết';

  @override
  String get benefitAllCharacters => 'Truy cập tất cả nhân vật';

  @override
  String get benefitNoAds => 'Không quảng cáo';

  @override
  String get playSampleVoice => 'Phát giọng mẫu';

  @override
  String get useThisAvatar => 'Dùng cái này';

  @override
  String get challengeTitle => 'Thử thách phát âm';

  @override
  String get challengeIntro =>
      'Phát âm đúng từng thẻ trong khu vực bằng tiếng Hàn để vượt qua.\nKhông có micrô? Bạn cũng có thể chơi bằng cách chạm vào màn hình.';

  @override
  String get challengeStart => 'Bật camera & micrô';

  @override
  String get challengePermissionNote =>
      'Cần quyền truy cập camera trước và micrô (tùy chọn).';

  @override
  String get challengeLoadingTitle => 'Đang tải…';

  @override
  String get challengeLoadingNote =>
      'Đang tải mô hình giọng nói tiếng Hàn (~82MB) trong lần chạy đầu tiên.\nVui lòng chờ một lát.';

  @override
  String get challengeSttFallback =>
      'Nhận dạng giọng nói không khả dụng, nên bạn đã chơi bằng cách chạm.';

  @override
  String get reasonTravelTitle => 'Nói chuyện khi đi du lịch';

  @override
  String get reasonTravelDesc => 'Tự tin trò chuyện với người bản địa';

  @override
  String get reasonCareerTitle => 'Công việc & sự nghiệp';

  @override
  String get reasonCareerDesc => 'Hội thoại công việc';

  @override
  String get reasonExamTitle => 'Ôn thi';

  @override
  String get reasonExamDesc => 'Chuẩn bị cho các bài thi nói';

  @override
  String get reasonDailyTitle => 'Hội thoại hằng ngày';

  @override
  String get reasonDailyDesc => 'Những cách diễn đạt bạn dùng mỗi ngày';

  @override
  String get reasonFriendsTitle => 'Kết bạn với người nước ngoài';

  @override
  String get reasonFriendsDesc => 'Hội thoại tự nhiên';

  @override
  String get reasonBrainTitle => 'Kích thích não bộ';

  @override
  String get reasonBrainDesc => 'Tăng cường trí nhớ & sự tập trung';

  @override
  String get challengeRecordToggle => 'Ghi lại lượt chơi này';

  @override
  String get challengeRecordHint =>
      'Lưu video lượt chơi của bạn để chia sẻ (không tiếng).';

  @override
  String get settingsSection => 'Cài đặt';

  @override
  String get paymentSection => 'Thanh toán';

  @override
  String get supportSection => 'Hỗ trợ';

  @override
  String get userLanguage => 'Ngôn ngữ hiển thị';

  @override
  String get learningLanguage => 'Ngôn ngữ học';

  @override
  String get learningLanguageKorean => 'Tiếng Hàn';

  @override
  String get notificationLabel => 'Thông báo';

  @override
  String get currentPlan => 'Gói hiện tại';

  @override
  String get paymentHistory => 'Lịch sử thanh toán';

  @override
  String get contactUs => 'Liên hệ với chúng tôi';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get deleteAccountTitle => 'Xóa tài khoản?';

  @override
  String get deleteAccountBody =>
      'Thao tác này sẽ xóa vĩnh viễn tài khoản và dữ liệu của bạn và không thể hoàn tác.';

  @override
  String get delete => 'Xóa';

  @override
  String get share => 'Chia sẻ';

  @override
  String get accentSoundsLike => 'Giọng tiếng Hàn của bạn nghe như';

  @override
  String get hintLabel => 'Gợi ý';

  @override
  String get nextHint => 'Gợi ý tiếp theo';

  @override
  String get translateLabel => 'Dịch';

  @override
  String get startRecording => 'Bắt đầu ghi âm';

  @override
  String get stopRecording => 'Dừng ghi âm';

  @override
  String get back => 'Quay lại';

  @override
  String get onboardingNameTitle => 'Chúng tôi nên gọi bạn là gì?';

  @override
  String get onboardingNameSubtitle => 'Gia sư AI của bạn sẽ ghi nhớ tên bạn.';

  @override
  String get nameLabel => 'Tên của bạn';

  @override
  String get nameHint => 'Nhập tên của bạn';

  @override
  String get nameHelper =>
      'Không nhất thiết phải là tên thật — biệt danh cũng được.';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get onboardingDoneTitle => 'Beaver đang chờ cuộc gọi của bạn';

  @override
  String get onboardingDoneSubtitle => 'Bắt đầu cuộc gọi ngay bây giờ';

  @override
  String get home => 'Trang chủ';

  @override
  String get callNow => 'Gọi ngay';

  @override
  String get pronunciation => 'Phát âm';

  @override
  String get fluency => 'Độ trôi chảy';

  @override
  String get rhythm => 'Nhịp điệu';

  @override
  String get analysisTimeout =>
      'Việc này đang mất nhiều thời gian hơn dự kiến. Vui lòng thử lại sau giây lát.';

  @override
  String get analysisFailed =>
      'Chúng tôi không thể phân tích cuộc hội thoại. Vui lòng thử lại.';

  @override
  String get analyzingConversation => 'Đang phân tích cuộc hội thoại của bạn…';

  @override
  String get analyzingSubtitle => 'Việc này chỉ mất một chút thời gian';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get nativeLabel => 'Bản ngữ';

  @override
  String get meLabel => 'Tôi';

  @override
  String get pronunciationPlayError => 'Không thể phát âm thanh phát âm.';

  @override
  String get savedExpressionsLoadError =>
      'Không thể tải các cách diễn đạt đã lưu của bạn.';

  @override
  String get mySavedExpressions => 'Cách diễn đạt đã lưu của tôi';

  @override
  String get avatarTraits => 'Ấm áp · Điềm tĩnh · Dịu dàng';

  @override
  String get priceFree => 'Miễn phí';

  @override
  String get loginGoogleTokenError => 'Không thể lấy mã đăng nhập Google.';

  @override
  String get loginGoogleSignInFailed => 'Đăng nhập Google thất bại.';

  @override
  String get loginContinueWithKakao => 'Tiếp tục với Kakao';

  @override
  String get loginContinueWithGoogle => 'Tiếp tục với Google';

  @override
  String get loginContinueWithApple => 'Tiếp tục với Apple';

  @override
  String get loginContinueWithEmail => 'Tiếp tục với email';

  @override
  String get loginOrDivider => 'hoặc';

  @override
  String get loginNoAccount => 'Chưa có tài khoản?';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get loginTermsNoticePrefix => 'Bằng cách tiếp tục, bạn đồng ý với ';

  @override
  String get loginTermsNoticeAnd => ' và ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Đăng nhập';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Nhập email của bạn';

  @override
  String get fieldPasswordLabel => 'Mật khẩu';

  @override
  String get passwordHint => 'Nhập mật khẩu của bạn';

  @override
  String get loginRememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get loginForgotPassword => 'Quên mật khẩu?';

  @override
  String get loginLoggingIn => 'Đang đăng nhập...';

  @override
  String get passwordLengthError => 'Mật khẩu phải có 8–16 ký tự.';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp.';

  @override
  String get signupCheckInput => 'Vui lòng kiểm tra lại thông tin bạn nhập.';

  @override
  String get fieldConfirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get confirmPasswordHint => 'Nhập lại mật khẩu của bạn';

  @override
  String get signupSigningUp => 'Đang đăng ký...';

  @override
  String get signupHaveAccount => 'Đã có tài khoản?';

  @override
  String get passwordMethodEmailRequired => 'Nhập email của bạn';

  @override
  String get passwordResetTitle => 'Đặt lại mật khẩu';

  @override
  String get passwordMethodDescription =>
      'Nhập địa chỉ email bạn muốn nhận mã đặt lại mật khẩu.';

  @override
  String get emailAddressHint => 'Địa chỉ email';

  @override
  String get passwordMethodSending => 'Đang gửi...';

  @override
  String get passwordMethodSendEmail => 'Gửi email';

  @override
  String get passwordCodeTitle => 'Nhập mã';

  @override
  String get passwordCodeDescription =>
      'Chúng tôi đã gửi mã khôi phục đến email của bạn. Nhập mã để tiếp tục.';

  @override
  String get passwordCodeNoCode => 'Không nhận được mã?';

  @override
  String get passwordCodeResend => 'Gửi lại mã';

  @override
  String get passwordCodeVerifying => 'Đang xác minh...';

  @override
  String get passwordNewTitle => 'Mật khẩu mới';

  @override
  String get passwordNewDescription =>
      'Đặt mật khẩu mới cho tài khoản của bạn.';

  @override
  String get fieldNewPasswordLabel => 'Mật khẩu mới';

  @override
  String get newPasswordHint => 'Nhập mật khẩu mới của bạn';

  @override
  String get fieldConfirmNewPasswordLabel => 'Xác nhận mật khẩu mới';

  @override
  String get confirmNewPasswordHint => 'Nhập lại mật khẩu mới của bạn';

  @override
  String get passwordNewSubmitting => 'Đang gửi...';

  @override
  String get passwordNewSubmit => 'Gửi';

  @override
  String get passwordCompleteTitle => 'Đặt lại mật khẩu hoàn tất';

  @override
  String get passwordCompleteBody =>
      'Mật khẩu của bạn đã được đặt lại. Đăng nhập bằng mật khẩu mới để tiếp tục.';

  @override
  String get termsTitle => 'Điều khoản dịch vụ';

  @override
  String get privacyTitle => 'Chính sách bảo mật';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Đặt mật khẩu mới cho $email.';
  }

  @override
  String get selectComplete => 'Xong';

  @override
  String get onboardingLanguageTitle => 'Tiếng mẹ đẻ của bạn là gì?';

  @override
  String get onboardingReasonTitle => 'Tại sao bạn học ngôn ngữ?';

  @override
  String get onboardingReasonSubtitle =>
      'Chúng tôi sẽ điều chỉnh việc học theo mục tiêu của bạn.';

  @override
  String get savingLabel => 'Đang lưu...';

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
}
