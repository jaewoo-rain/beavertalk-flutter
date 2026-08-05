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
  String get quickStart => 'Bắt đầu nhanh';

  @override
  String get presetMorning => 'Thói quen buổi sáng';

  @override
  String get presetMorningSub => 'Ngày thường 8:00';

  @override
  String get presetEvening => 'Khép lại buổi tối';

  @override
  String get presetEveningSub => 'Mỗi ngày 21:00';

  @override
  String get presetCustom => 'Tùy chỉnh';

  @override
  String get presetCustomSub => 'Theo ý bạn';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count lần/tuần · $monthly cuộc gọi mỗi tháng';
  }

  @override
  String get alarmSummaryNone => 'Hãy chọn ít nhất một ngày';

  @override
  String get partnerInUse => 'Đang dùng';

  @override
  String get partnerOwned => 'Đã sở hữu';

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
    return 'Cuộc gọi thứ $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Đôi lời từ $name';
  }

  @override
  String characterNoteFooter(String name) {
    return '$name để lại ngay sau cuộc gọi';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Cách diễn đạt mới $count';
  }

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
  String get analyzingByWord => 'Đang kiểm tra phát âm của bạn từng từ một';

  @override
  String get analyzingTakingLonger => 'Việc này mất lâu hơn một chút';

  @override
  String get scanConnectionLost => 'Mất kết nối';

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
  String pricePerMonth(String price) {
    return '$price / mo';
  }

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
  String get loginAppleSignInFailed => 'Đăng nhập Apple thất bại.';

  @override
  String get loginKakaoSignInFailed => 'Đăng nhập Kakao thất bại.';

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
  String get thisMonthPayment => 'Thanh toán tháng này';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterSubscription => 'Gói đăng ký';

  @override
  String get filterCharacter => 'Nhân vật';

  @override
  String get statusCompleted => 'Hoàn tất';

  @override
  String get lastPayment => 'Thanh toán gần nhất';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Bạn có thể tiếp tục dùng quyền lợi Pro đến $date, sau đó gói của bạn sẽ tự động chuyển sang Miễn phí.';
  }

  @override
  String get freePlanCallLimit => '1 cuộc gọi mỗi ngày · giới hạn 5 phút';

  @override
  String get freePlanBasicCharacters => 'Bao gồm nhân vật cơ bản';

  @override
  String get availableForPurchase => 'Có thể mua';

  @override
  String get paymentsLoadError => 'Không tải được lịch sử thanh toán';

  @override
  String get noPayments => 'Chưa có thanh toán nào';

  @override
  String get morePaymentsExist => 'Các thanh toán cũ hơn chưa được hiển thị';

  @override
  String get undatedPayments => 'Không có ngày';

  @override
  String get paymentLabelFallback => 'Thanh toán';

  @override
  String learningPassed(int passed, int total) {
    return 'Đạt $passed trên $total câu';
  }

  @override
  String get hardestSound => 'Âm khó nhất hôm nay';

  @override
  String get soundAccuracy => 'Độ chính xác theo âm';

  @override
  String phonemeAttempts(int count) {
    return 'Theo âm vị · $count lần thử';
  }

  @override
  String get colSound => 'Âm';

  @override
  String get colAttempts => 'Lần';

  @override
  String get colCorrect => 'Đúng';

  @override
  String get colAccuracy => 'Ch.xác';

  @override
  String get sentenceResults => 'Kết quả theo câu';

  @override
  String viewAllSentences(int count) {
    return 'Xem tất cả $count';
  }

  @override
  String get colSentence => 'Câu';

  @override
  String get colPronunciation => 'Ph.âm';

  @override
  String get colFluency => 'Trôi';

  @override
  String get colRhythm => 'Nhịp';

  @override
  String recentSessions(int count) {
    return '$count phiên gần nhất';
  }

  @override
  String trendAverage(int score) {
    return 'TB $score';
  }

  @override
  String get today => 'Hôm nay';

  @override
  String get colDate => 'Ngày';

  @override
  String get colSentences => 'Số câu';

  @override
  String get colScore => 'Điểm';

  @override
  String get colChange => 'Th.đổi';

  @override
  String dateToday(String date) {
    return '$date (hôm nay)';
  }

  @override
  String get accentAnalysis => 'Phân tích giọng';

  @override
  String get overallLevel => 'Cấp độ tổng thể';

  @override
  String get overallLevelSubtitle => 'Từ vựng · Ngữ pháp · Diễn đạt';

  @override
  String get pronunciationAnalysis => 'Phân tích phát âm';

  @override
  String get recentSessionsAverage => 'TB 10 phiên gần nhất';

  @override
  String levelStage(int stage) {
    return 'Cấp $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Trong tất cả người học';

  @override
  String aheadOfLearners(int percent) {
    return 'Bạn vượt $percent% người học';
  }

  @override
  String get retakeLevelTest => 'Làm lại bài kiểm tra cấp độ';

  @override
  String get practicePronunciation => 'Luyện phát âm';

  @override
  String get priceChangedTitle => 'Giá đã thay đổi';

  @override
  String priceChangedBody(String price) {
    return 'Mặt hàng này hiện là $price. Bạn có muốn tiếp tục?';
  }

  @override
  String get billingGroupPlanPurchases => 'Gói & mua hàng';

  @override
  String get billingGroupInTheStore => 'Trong cửa hàng';

  @override
  String get billingChangePlan => 'Đổi gói';

  @override
  String get billingCompareAllPlans => 'So sánh tất cả các gói';

  @override
  String get billingBuyACharacter => 'Mua nhân vật';

  @override
  String get billingRestorePurchases => 'Khôi phục mua hàng';

  @override
  String get billingPaymentHistory => 'Lịch sử thanh toán';

  @override
  String get billingManageInTheStore => 'Quản lý trong cửa hàng';

  @override
  String get billingRefundHelp => 'Hỗ trợ hoàn tiền';

  @override
  String get billingCancelSubscription => 'Hủy gói đăng ký';

  @override
  String get billingResubscribe => 'Đăng ký lại';

  @override
  String get badgeCurrent => 'Hiện tại';

  @override
  String get badgeTrial => 'Dùng thử';

  @override
  String get badgeRenewing => 'Sẽ gia hạn';

  @override
  String get badgePastDue => 'Trễ thanh toán';

  @override
  String get badgePaused => 'Tạm dừng';

  @override
  String get badgeCanceling => 'Sắp hủy';

  @override
  String get subscriptionTitle => 'Gói đăng ký';

  @override
  String get plansTitle => 'Các gói';

  @override
  String get planFree => 'Miễn phí';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Dùng thử Max';

  @override
  String get freePlanPriceLine => '\$0.00 — mỗi ngày một cuộc gọi';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount mỗi tháng';
  }

  @override
  String freeUntilDate(String date) {
    return 'Miễn phí đến $date';
  }

  @override
  String get todaysCalls => 'Cuộc gọi hôm nay';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'Đã dùng $used/$limit';
  }

  @override
  String get firstPaymentLabel => 'Thanh toán đầu tiên';

  @override
  String get nextPaymentLabel => 'Thanh toán tiếp theo';

  @override
  String get retryingUntilLabel => 'Thử lại đến';

  @override
  String get pausedSinceLabel => 'Tạm dừng từ';

  @override
  String planEndsLabel(String plan) {
    return '$plan kết thúc';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Gọi không giới hạn với Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Gọi không giới hạn · 15 phút mỗi cuộc · $price mỗi tháng';
  }

  @override
  String get bannerMaxUpsellTitle => 'Bật gọi video với Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Gọi mặt đối mặt · $price mỗi tháng';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Chuyển sang gói năm';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly mỗi năm · $perMonth mỗi tháng';
  }

  @override
  String get bannerPaymentFailedTitle => 'Chúng tôi không thể thu tiền';

  @override
  String get bannerPaymentFailedSub =>
      'Cập nhật thanh toán trong cửa hàng để giữ Pro';

  @override
  String get bannerPausedTitle => 'Gói của bạn đang tạm dừng';

  @override
  String get bannerPausedSub => 'Thanh toán chưa được thực hiện';

  @override
  String get noteRestoreHint =>
      'Đã đăng ký trên thiết bị khác? Khôi phục sẽ đưa gói về thiết bị này.';

  @override
  String get noteStoreHandled =>
      'Phương thức thanh toán, đổi gói và hủy gói đều do cửa hàng xử lý.';

  @override
  String get noteFairUse =>
      'Việc dùng không giới hạn tuân theo chính sách sử dụng hợp lý của chúng tôi.';

  @override
  String noteTrialEnds(String date) {
    return 'Bản dùng thử kết thúc $date. Hủy trong cửa hàng trước đó và bạn sẽ không bị tính phí.';
  }

  @override
  String get noteGrace =>
      'Quyền lợi vẫn hoạt động trong thời gian gia hạn. Ứng dụng không bao giờ cản trở việc hủy.';

  @override
  String get noteHold =>
      'Pro tạm dừng cho đến khi thanh toán thành công. Nhân vật và tiến trình của bạn vẫn an toàn.';

  @override
  String noteEnding(String date) {
    return 'Gói của bạn sẽ kết thúc. Quyền lợi kéo dài đến $date, sau đó bạn chuyển về gói Miễn phí. Bạn có thể đăng ký lại bất cứ lúc nào.';
  }

  @override
  String get trialExpiredTitle => 'Bản dùng thử Max đã kết thúc';

  @override
  String get trialExpiredSub => 'Bạn đang ở gói Miễn phí';

  @override
  String get seePlans => 'Xem các gói';

  @override
  String get currentPlanTitle => 'Gói hiện tại';

  @override
  String get badgeRecommended => 'Đề xuất';

  @override
  String get perMonthUnit => 'mỗi tháng';

  @override
  String get planTaglinePro => 'Gọi không giới hạn. 15 phút mỗi cuộc.';

  @override
  String get planTaglineMax => 'Giờ bạn có thể nhìn thấy họ.';

  @override
  String get planTaglineFree => 'Mỗi ngày một cuộc gọi. Hoàn toàn miễn phí.';

  @override
  String get bulletProCalls => 'Gọi thoại thoải mái, bao nhiêu tùy thích';

  @override
  String get bulletProLength => '15 phút mỗi cuộc gọi';

  @override
  String get bulletProScoring => 'Chấm điểm phát âm từng chữ cái';

  @override
  String get bulletProCorrections => 'Sửa lỗi theo tiếng mẹ đẻ của bạn';

  @override
  String get bulletProBeaverCalls => 'Hải ly gọi cho bạn trước';

  @override
  String get bulletMaxVideo => 'Gọi video mặt đối mặt';

  @override
  String get bulletMaxEverything => 'Mọi thứ trong Pro';

  @override
  String get bulletMaxCharacters => 'Mọi nhân vật, không giới hạn';

  @override
  String get bulletMaxStudyBook => 'Sổ tay học tập đúng trình độ của bạn';

  @override
  String get bulletMaxWeeklyReport => 'Báo cáo hằng tuần về tiến bộ phát âm';

  @override
  String get bulletFreeCall => 'Mỗi ngày một cuộc gọi thoại 5 phút';

  @override
  String get bulletFreeCheck => 'Mỗi ngày một lần kiểm tra phát âm';

  @override
  String get bulletFreeAccent => 'Kiểm tra ngữ điệu không giới hạn';

  @override
  String get bulletFreeCharacter => 'Một nhân vật khởi đầu';

  @override
  String get ctaGoUnlimited => 'Gọi không giới hạn';

  @override
  String get ctaTurnOnVideo => 'Bật gọi video';

  @override
  String get noteCallLength => 'Mỗi cuộc gọi kéo dài 15 phút.';

  @override
  String get paywallProTitle1 => 'Người bạn Hàn Quốc';

  @override
  String get paywallProTitle2 => 'thức cùng bạn lúc 3 giờ sáng';

  @override
  String get paywallProSub =>
      'Gọi không giới hạn. 15 phút mỗi cuộc. Quanh năm.';

  @override
  String get paywallLimitHeadline => 'Pro xóa bỏ giới hạn.';

  @override
  String get limitBannerCallTitle => 'Đó là cuộc gọi hôm nay';

  @override
  String get limitBannerCallSub => 'Gói Miễn phí cho bạn một cuộc gọi mỗi ngày';

  @override
  String get limitBannerCheckTitle => 'Đó là lần kiểm tra hôm nay';

  @override
  String get limitBannerCheckSub =>
      'Gói Miễn phí cho bạn một lần kiểm tra mỗi ngày';

  @override
  String get bulletProCharactersForever =>
      'Nhân vật bạn mua là của bạn mãi mãi';

  @override
  String get paywallMaxTitle => 'Giờ bạn có thể nhìn thấy họ.';

  @override
  String get paywallMaxSub =>
      'Gọi video, mọi nhân vật, và sổ tay học tập dành riêng cho trình độ của bạn.';

  @override
  String get planMonthly => 'Hằng tháng';

  @override
  String get planAnnual => 'Hằng năm';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price mỗi tháng';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth mỗi tháng';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price mỗi tháng';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly mỗi năm · $perMonth mỗi tháng';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price mỗi tháng · hủy bất cứ lúc nào trong cửa hàng';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price mỗi tháng · hủy bất cứ lúc nào trong cửa hàng';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return 'Miễn phí 7 ngày, sau đó $price mỗi tháng · hủy bất cứ lúc nào trong cửa hàng';
  }

  @override
  String get ctaCaptionAutoRenew => 'Tự động gia hạn cho đến khi bạn hủy.';

  @override
  String get footerTerms => 'Điều khoản';

  @override
  String get footerPrivacy => 'Quyền riêng tư';

  @override
  String get noteMaxCharacters =>
      'Nhân vật mở khóa bằng Max dùng được khi gói còn hiệu lực. Nhân vật bạn đã mua vẫn là của bạn.';

  @override
  String get processingTitle => 'Đang xác nhận giao dịch';

  @override
  String get processingSub => 'Thường chỉ mất vài giây.';

  @override
  String get successProTitle => 'Bạn đã có Pro.';

  @override
  String get successProSub => 'Gọi không giới hạn, bắt đầu ngay bây giờ.';

  @override
  String get successProBenefit1 => 'Gọi bao nhiêu tùy thích — 15 phút mỗi cuộc';

  @override
  String get successProBenefit2 => 'Kiểm tra phát âm không giới hạn';

  @override
  String get successProBenefit3 => 'Mọi nhân vật, cùng tùy chọn mua lẻ';

  @override
  String get successMaxTitle => 'Giờ bạn đã nhìn thấy họ.';

  @override
  String get successMaxSub =>
      'Gọi video đã bật. Nhấn nút video trong bất kỳ cuộc gọi nào.';

  @override
  String get successMaxBenefit1 => 'Gọi video mặt đối mặt';

  @override
  String get successMaxBenefit2 =>
      'Mọi nhân vật không giới hạn, nhân vật mới dùng trước';

  @override
  String get successMaxBenefit3 => 'Sổ tay học tập đúng trình độ của bạn';

  @override
  String get ctaStartACall => 'Bắt đầu cuộc gọi';

  @override
  String get ctaStartAVideoCall => 'Bắt đầu gọi video';

  @override
  String get ctaSeeYourSubscription => 'Xem gói đăng ký của bạn';

  @override
  String successProCaption(String price) {
    return '$price được tính hằng tháng cho đến khi bạn hủy. Quản lý hoặc hủy bất cứ lúc nào trong cửa hàng.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price được tính hằng tháng cho đến khi bạn hủy. Quản lý hoặc hủy bất cứ lúc nào trong cửa hàng.';
  }

  @override
  String get plansErrorTitle => 'Không tải được các gói';

  @override
  String get plansErrorSub => 'Cửa hàng không phản hồi.';

  @override
  String get ctaTryAgain => 'Thử lại';

  @override
  String get plansErrorCaption => 'Bạn chưa bị tính phí.';

  @override
  String get changePlanTitle => 'Đổi gói';

  @override
  String get moveToMaxTitle => 'Chuyển lên Max';

  @override
  String maxPriceShort(String price) {
    return '$price/tháng';
  }

  @override
  String get moveToMaxCardSub =>
      'Gọi video mặt đối mặt · mọi nhân vật · sổ tay học tập dành riêng cho bạn';

  @override
  String get whatHappensNow => 'Điều gì xảy ra tiếp theo';

  @override
  String get maxStartsLabel => 'Max bắt đầu';

  @override
  String get immediately => 'Ngay lập tức';

  @override
  String get unusedProTime => 'Thời gian Pro chưa dùng';

  @override
  String get creditedTowardMax => 'Được trừ vào phí Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Chuyển sang Max';

  @override
  String get upgradeCaption =>
      'Gói mới bắt đầu ngay. Thời gian Pro chưa dùng được trừ vào phí, không bao giờ tính hai lần.';

  @override
  String get moveToProTitle => 'Chuyển xuống Pro';

  @override
  String get moveToProSub =>
      'Hôm nay không có gì thay đổi. Max chạy đến hết tháng bạn đã thanh toán.';

  @override
  String get maxRunsUntil => 'Max hiệu lực đến';

  @override
  String get proStarts => 'Pro bắt đầu';

  @override
  String get whatYouKeep => 'Những gì bạn giữ lại';

  @override
  String get keepBenefitCalls => 'Gọi thoại không giới hạn, 15 phút mỗi cuộc';

  @override
  String get keepBenefitCharacters => 'Nhân vật bạn mua là của bạn mãi mãi';

  @override
  String downgradeWarning(String date) {
    return 'Gọi video và nhân vật riêng của Max sẽ tắt vào $date.';
  }

  @override
  String get ctaSwitchToPro => 'Chuyển sang Pro';

  @override
  String get ctaKeepMax => 'Giữ Max';

  @override
  String get winbackSkip => 'Bỏ qua';

  @override
  String get winbackTitle => 'Gói Pro của bạn đã kết thúc';

  @override
  String get winbackSub => 'Bạn đang ở gói Miễn phí — mỗi ngày một cuộc gọi.';

  @override
  String get winbackQuestion =>
      'Bạn có thể cho chúng tôi biết lý do rời đi không?';

  @override
  String get winbackReasonExpensive => 'Giá quá cao';

  @override
  String get winbackReasonUnused => 'Tôi không dùng đủ nhiều';

  @override
  String get winbackReasonMissing => 'Thiếu tính năng tôi cần';

  @override
  String get winbackReasonOtherApp => 'Tôi tìm được ứng dụng khác';

  @override
  String get winbackReasonElse => 'Lý do khác';

  @override
  String get ctaSend => 'Gửi';

  @override
  String get ctaNotNow => 'Để sau';

  @override
  String get winbackCaption =>
      'Việc này không khôi phục gói của bạn. Hãy đăng ký lại trong cửa hàng.';

  @override
  String get ctaContinue => 'Tiếp tục';

  @override
  String get ctaClose => 'Đóng';

  @override
  String get ovRestoreSuccessTitle => 'Pro đã trở lại';

  @override
  String get ovRestoreSuccessBody =>
      'Chúng tôi đã tìm thấy gói đăng ký của bạn và bật lại trên thiết bị này.';

  @override
  String get ovRestoreEmptyTitle => 'Không có gì để khôi phục';

  @override
  String get ovRestoreEmptyBody =>
      'Không có gói đăng ký nào đang hoạt động gắn với tài khoản cửa hàng này.';

  @override
  String get ovRestoreOtherTitle => 'Gói này thuộc về tài khoản khác';

  @override
  String get ovRestoreOtherBody =>
      'Gói đăng ký này đang hoạt động trên một tài khoản BeaverTalk khác.';

  @override
  String get ctaSignInThatAccount => 'Đăng nhập tài khoản đó';

  @override
  String get ctaGetHelp => 'Nhận trợ giúp';

  @override
  String get ovCharacterOfferTitle => 'Chưa sẵn sàng cho Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Chọn một nhân vật và giữ mãi. Mua một lần — không đăng ký, không gia hạn.';

  @override
  String get rowOneCharacter => 'Một nhân vật';

  @override
  String rowFromPrice(String price) {
    return 'từ $price';
  }

  @override
  String get rowYoursForever => 'Của bạn mãi mãi';

  @override
  String get rowNoRenewal => 'Không gia hạn';

  @override
  String get rowWorksOnFree => 'Dùng được trên gói Miễn phí';

  @override
  String get rowYes => 'Có';

  @override
  String get ctaSeeCharacters => 'Xem nhân vật';

  @override
  String get ovNotEligibleTitle => 'Không có gì để hủy';

  @override
  String get ovNotEligibleBody =>
      'Bạn đang ở gói Miễn phí. Tài khoản này không có gói đăng ký đang hoạt động.';

  @override
  String get ovCancelDownsellTitle => 'Trước khi bạn rời đi';

  @override
  String get ovCancelDownsellBody =>
      'Việc hủy diễn ra trong cửa hàng. Có hai điều đáng biết.';

  @override
  String get rowPayYearlyInstead => 'Trả theo năm thay vì';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price mỗi tháng';
  }

  @override
  String get rowCharactersYouBought => 'Nhân vật bạn đã mua';

  @override
  String get rowProRunsUntil => 'Pro hiệu lực đến';

  @override
  String get ctaSwitchToYearly => 'Chuyển sang gói năm';

  @override
  String get ctaContinueToStore => 'Tiếp tục đến cửa hàng';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Trả theo năm, tiết kiệm $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Bạn đã dùng Pro được hai tháng. Gói năm tính ra rẻ hơn.';

  @override
  String get rowYouSave => 'Bạn tiết kiệm';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Theo năm';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Theo tháng, trong một năm';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Chuyển sang gói tháng';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Gói năm của bạn hiệu lực đến $date. Thanh toán theo tháng bắt đầu từ ngày hôm sau.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Thanh toán theo tháng bắt đầu';

  @override
  String get rowMonthlyLabel => 'Theo tháng';

  @override
  String get rowYearlyWorkedOut => 'Gói năm tính ra là';

  @override
  String get ctaSwitchToMonthly => 'Chuyển sang gói tháng';

  @override
  String get ovRefundHelpTitle => 'Hoàn tiền do cửa hàng xử lý';

  @override
  String get ovRefundHelpBody =>
      'Chúng tôi không thể tự hoàn tiền. Mọi yêu cầu đều do cửa hàng xét duyệt.';

  @override
  String get ctaGoToStore => 'Đến cửa hàng';

  @override
  String get ovTrialEndingTitle => 'Bản dùng thử kết thúc vào ngày mai';

  @override
  String get ovTrialEndingBody =>
      'Max sẽ tiếp tục trừ khi bạn hủy. Đây là những gì sẽ diễn ra.';

  @override
  String get rowTrialEnds => 'Dùng thử kết thúc';

  @override
  String get rowFirstCharge => 'Lần thu phí đầu tiên';

  @override
  String get rowThenMonthly => 'Sau đó hằng tháng';

  @override
  String get ctaCancelInStore => 'Hủy trong cửa hàng';

  @override
  String get ovTrialStartTitle => '7 ngày dùng Max, miễn phí';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Miễn phí đến $date. Sau đó $price mỗi tháng, trừ khi bạn hủy trong cửa hàng.';
  }

  @override
  String get ctaStart7Days => 'Bắt đầu 7 ngày miễn phí';

  @override
  String get ovOtoTitle => 'Một điều nữa trước khi bắt đầu';

  @override
  String get ovOtoBody =>
      'Lựa chọn tốt — gọi không giới hạn đã bật ngay bây giờ. Cùng gói Pro nhưng trả theo năm sẽ rẻ hơn.';

  @override
  String get ovFailedDeclinedTitle => 'Thẻ của bạn bị từ chối';

  @override
  String get ovFailedDeclinedBody =>
      'Cửa hàng không thể thu tiền. Bạn chưa bị tính phí.';

  @override
  String get ctaUpdatePaymentMethod => 'Cập nhật phương thức thanh toán';

  @override
  String get ovFailedCanceledTitle => 'Thanh toán đã bị hủy';

  @override
  String get ovFailedCanceledBody =>
      'Bạn vẫn ở gói Miễn phí. Bạn chưa bị tính phí.';

  @override
  String get ovFailedStoreTitle => 'Đã có lỗi xảy ra';

  @override
  String get ovFailedStoreBody =>
      'Không kết nối được với cửa hàng. Bạn chưa bị tính phí.';

  @override
  String get ovAlreadyTitle => 'Bạn đã có Pro rồi';

  @override
  String get ovAlreadyBody =>
      'Tài khoản cửa hàng này đã có gói đang hoạt động. Không có gì cần mua thêm.';

  @override
  String get ctaSeeMySubscription => 'Xem gói đăng ký của tôi';

  @override
  String get subCancelTitle => 'Hủy gói đăng ký';

  @override
  String subCancelBody(String date) {
    return 'Pro hiệu lực đến $date. Sau đó bạn chuyển về gói Miễn phí.';
  }

  @override
  String get subWhatYouLose => 'Những gì bạn mất';

  @override
  String get benefitCalls15 => 'Gọi không giới hạn, 15 phút mỗi cuộc';

  @override
  String get benefitScoring => 'Chấm điểm phát âm từng chữ cái';

  @override
  String get benefitEveryCharacter => 'Mọi nhân vật, không giới hạn';

  @override
  String get ctaKeepPro => 'Giữ Pro';

  @override
  String get subPaymentTitle => 'Cập nhật thanh toán';

  @override
  String get subPaymentBody =>
      'Chúng tôi không thể thu tiền. Pro vẫn hoạt động trong thời gian gia hạn.';

  @override
  String get subHowToFix => 'Cách khắc phục';

  @override
  String get fixStep1 => 'Mở cửa hàng và cập nhật phương thức thanh toán';

  @override
  String get fixStep2 => 'Quay lại — gói của bạn tự động tiếp tục';

  @override
  String get fixStep3 => 'Không bao giờ bị tính phí hai lần';

  @override
  String get subResubTitle => 'Đăng ký lại';

  @override
  String subResubBody(String date) {
    return 'Pro kết thúc vào $date. Bật lại gia hạn tự động và mọi thứ giữ nguyên.';
  }

  @override
  String get subWhatYouKeep => 'Những gì bạn giữ lại';

  @override
  String get ctaTurnItBackOn => 'Bật lại';

  @override
  String get flTodayTitle => 'Đó là cuộc gọi hôm nay';

  @override
  String get flTodayBody => 'Tiếp tục từ chỗ bạn dừng lại — ngay bây giờ.';

  @override
  String get flCheckTitle => 'Đó là lần kiểm tra hôm nay';

  @override
  String get flCheckBody =>
      'Gói Miễn phí kiểm tra một lần mỗi ngày. Pro thì không giới hạn.';

  @override
  String get flBenefitCalls => 'Gọi không giới hạn với Pro · 15 phút mỗi cuộc';

  @override
  String get flBenefitChecks => 'Kiểm tra phát âm không giới hạn với Pro';

  @override
  String flCaption(String price) {
    return '$price mỗi tháng · hủy bất cứ lúc nào';
  }

  @override
  String flUsage(String used, String limit) {
    return 'Đã dùng $used/$limit';
  }

  @override
  String get ctaMaybeTomorrow => 'Để mai vậy';

  @override
  String get accountSection => 'Tài khoản';

  @override
  String get nicknameLabel => 'Biệt danh';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Phương thức đăng nhập';

  @override
  String get joinedLabel => 'Ngày tham gia';

  @override
  String get editNicknameTitle => 'Sửa biệt danh';

  @override
  String get nicknameRule => '2–12 ký tự · chỉ chữ cái tiếng Anh và số';

  @override
  String get ctaSave => 'Lưu';

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
  String get paywallLeaveTitle => 'Nếu rời đi bây giờ, bạn sẽ chưa đăng ký';

  @override
  String get paywallLeaveBody =>
      'Quyền lợi mở khóa ngay sau khi thanh toán. Bạn có thể quay lại bất cứ lúc nào từ Trang của tôi.';

  @override
  String get ctaKeepLooking => 'Xem tiếp';

  @override
  String get ctaLeaveAnyway => 'Vẫn rời đi';

  @override
  String get iapCharacterSuccessTitle => 'Một người bạn mới đã tham gia!';

  @override
  String get iapCharacterSuccessBody =>
      'Nhân vật này là của bạn mãi mãi — vẫn còn dù gói thay đổi, và Khôi phục mua hàng sẽ đưa nó trở lại trên mọi thiết bị.';

  @override
  String get iapCharacterFailedBody =>
      'Giao dịch chưa hoàn tất. Chưa bị trừ tiền — vui lòng thử lại.';
}
