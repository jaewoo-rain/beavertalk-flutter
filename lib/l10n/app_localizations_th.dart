// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'จบการโทรแล้ว $duration';
  }

  @override
  String get callRatingPrompt => 'การโทรเป็นอย่างไรบ้าง?';

  @override
  String get ratingBad => 'ไม่ค่อยดี';

  @override
  String get ratingOkay => 'พอใช้';

  @override
  String get ratingGood => 'ดีมาก';

  @override
  String get goHome => 'หน้าหลัก';

  @override
  String get viewAnalysis => 'ดูผลวิเคราะห์';

  @override
  String get loadingShort => 'กำลังโหลด…';

  @override
  String ratingSubmitFailed(String message) {
    return 'ส่งคะแนนไม่สำเร็จ: $message';
  }

  @override
  String get callInfoNotFound => 'ไม่พบข้อมูลการโทร จึงข้ามการวิเคราะห์';

  @override
  String get tabRecords => 'บันทึก';

  @override
  String get tabArchive => 'ที่บันทึกไว้';

  @override
  String get callHistory => 'ประวัติการโทร';

  @override
  String get conversationRecord => 'บันทึกบทสนทนา';

  @override
  String get noCallRecords => 'ยังไม่มีบันทึกการโทร';

  @override
  String get noCallRecordsBody =>
      'เมื่อคุณโทรคุยกับ AI ครั้งแรกเสร็จ\nบันทึกจะปรากฏที่นี่';

  @override
  String get startCall => 'เริ่มการโทร';

  @override
  String get recordsLoadError => 'โหลดบันทึกไม่สำเร็จ';

  @override
  String get tryAgainLater => 'โปรดลองอีกครั้งในภายหลัง';

  @override
  String get retry => 'ลองใหม่';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes นาที $seconds วินาที';
  }

  @override
  String get scheduleManagement => 'ตารางเวลา';

  @override
  String get alarms => 'การเตือน';

  @override
  String get addSchedule => 'เพิ่มตารางเวลา';

  @override
  String get editSchedule => 'แก้ไขตารางเวลา';

  @override
  String get somethingWentWrong => 'เกิดข้อผิดพลาดบางอย่าง';

  @override
  String get alarmsLoadError => 'โหลดการเตือนไม่สำเร็จ';

  @override
  String get charactersLoadError => 'โหลดตัวละครไม่สำเร็จ';

  @override
  String get noCharacters => 'ไม่มีตัวละครให้ใช้งาน';

  @override
  String get close => 'ปิด';

  @override
  String get repeat => 'ทำซ้ำ';

  @override
  String get callPartner => 'ตัวละคร';

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
  String get am => 'ก่อนเที่ยง';

  @override
  String get pm => 'หลังเที่ยง';

  @override
  String get save => 'บันทึก';

  @override
  String get conversation => 'บทสนทนา';

  @override
  String get review => 'ทบทวน';

  @override
  String get pronunciationChallenge => 'ท้าทายการออกเสียง';

  @override
  String get newExpressions => 'สำนวนใหม่';

  @override
  String get analysisResult => 'ผลการวิเคราะห์';

  @override
  String get noNewExpressions => 'ไม่มีสำนวนใหม่จากบทสนทนานี้';

  @override
  String get practice => 'ฝึกฝน';

  @override
  String recentScore(int score) {
    return 'คะแนนล่าสุด $score%';
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
  String get analysisLoadError => 'โหลดผลการวิเคราะห์ไม่สำเร็จ';

  @override
  String get standardAudioNotReady => 'เสียงออกเสียงมาตรฐานยังไม่พร้อม';

  @override
  String get standardAudioPlayError => 'เล่นเสียงออกเสียงมาตรฐานไม่สำเร็จ';

  @override
  String get selectACountry => 'เลือกประเทศ';

  @override
  String get selectYourLanguage => 'เลือกภาษาของคุณ';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get selectTime => 'เลือกเวลา';

  @override
  String get getStarted => 'เริ่มต้นใช้งาน';

  @override
  String get permissionTitle =>
      'อนุญาตสิทธิ์การเข้าถึง\nเพื่อประสบการณ์ที่ราบรื่น';

  @override
  String get permissionSubtitle =>
      'สิทธิ์ที่จำเป็นเหล่านี้จำเป็นต่อการใช้บริการ';

  @override
  String get permissionMicTitle => 'ไมโครโฟน (จำเป็น)';

  @override
  String get permissionMicDesc => 'จำเป็นสำหรับการพูดคุยกับ AI เป็นภาษาเกาหลี';

  @override
  String get permissionNotifTitle => 'การแจ้งเตือน (ไม่บังคับ)';

  @override
  String get permissionNotifDesc =>
      'เราจะส่งการเตือนการเรียนและตารางการโทรให้คุณ';

  @override
  String get micPermissionNeededTitle => 'ต้องอนุญาตการเข้าถึงไมโครโฟน';

  @override
  String get micPermissionNeededBody =>
      'หากต้องการพูดคุยกับ AI คุณต้องอนุญาตการเข้าถึงไมโครโฟน โปรดเปิดใช้งานในการตั้งค่า';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get connectionFailedTitle => 'เชื่อมต่อไม่สำเร็จ';

  @override
  String get connectionFailedBody =>
      'ตรวจสอบการเชื่อมต่อเครือข่ายของคุณ\nแล้วลองอีกครั้ง';

  @override
  String get checkout => 'ชำระเงิน';

  @override
  String get pay => 'จ่ายเงิน';

  @override
  String get orderSummary => 'สรุปคำสั่งซื้อ';

  @override
  String get paymentMethod => 'วิธีการชำระเงิน';

  @override
  String get payMethodCard => 'บัตรเครดิต / เดบิต';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'อวาตาร์ Annoying Beaver';

  @override
  String get productTrait => 'ตัวละครพรีเมียม · เป็นของคุณตลอดไป';

  @override
  String get amountItemPrice => 'ราคาสินค้า';

  @override
  String get amountDiscount => 'ส่วนลด';

  @override
  String get amountTotal => 'รวมทั้งหมด';

  @override
  String get paymentCompleteTitle => 'ชำระเงินสำเร็จ';

  @override
  String get paymentCompleteBody => 'เพิ่มอวาตาร์เข้าคอลเลกชันของคุณแล้ว';

  @override
  String get viewCollection => 'ดูคอลเลกชัน';

  @override
  String get receiptItem => 'รายการ';

  @override
  String get receiptAmount => 'จำนวนเงิน';

  @override
  String get receiptMethod => 'วิธีการชำระเงิน';

  @override
  String get receiptDate => 'วันที่';

  @override
  String get paymentFailedTitle => 'ชำระเงินไม่สำเร็จ';

  @override
  String get paymentFailedBody =>
      'ไม่สามารถดำเนินการชำระเงินของคุณได้\nโปรดลองอีกครั้ง';

  @override
  String get freeCallEndingTitle => 'การโทรฟรีของคุณกำลังจะสิ้นสุด';

  @override
  String get freeCallEndingBody => 'สมัครสมาชิกเพื่อคุยกับ Beaver ได้นานขึ้น';

  @override
  String get subscribe => 'สมัครสมาชิก';

  @override
  String get endCall => 'วางสาย';

  @override
  String get callEnded => 'การโทรสิ้นสุดแล้ว';

  @override
  String get connecting => 'กำลังเชื่อมต่อ…';

  @override
  String get connectingHint => 'โดยปกติใช้เวลาไม่ถึง 5 วินาที';

  @override
  String get callConnectFailed => 'เชื่อมต่อการโทรไม่สำเร็จ';

  @override
  String get saveSentenceFailed => 'บันทึกประโยคไม่สำเร็จ';

  @override
  String get recordStartFailed => 'เริ่มการบันทึกเสียงไม่สำเร็จ';

  @override
  String get recordTooShort => 'การบันทึกนั้นสั้นเกินไป โปรดลองอีกครั้ง';

  @override
  String get gradingFailed => 'การให้คะแนนล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get listenStandard => 'ฟังการออกเสียงมาตรฐาน';

  @override
  String get saveSentence => 'บันทึกประโยค';

  @override
  String get unsaveSentence => 'ลบประโยคที่บันทึกไว้';

  @override
  String get scoringPronunciation => 'กำลังให้คะแนนการออกเสียงของคุณ…';

  @override
  String get analyzingByWord => 'Checking your pronunciation word by word';

  @override
  String get analyzingTakingLonger => 'This is taking a little longer';

  @override
  String get scanConnectionLost => 'Connection lost';

  @override
  String get noRecordingToPlay => 'ไม่มีเสียงบันทึกให้เล่น';

  @override
  String get myRecordingPlayError => 'เล่นเสียงบันทึกของคุณไม่สำเร็จ';

  @override
  String get next => 'ถัดไป';

  @override
  String get endLearning => 'จบเซสชัน';

  @override
  String get navCalendar => 'ปฏิทิน';

  @override
  String get navCall => 'โทร';

  @override
  String get navStats => 'สถิติ';

  @override
  String get myPage => 'หน้าของฉัน';

  @override
  String get languageSaveFailed => 'บันทึกภาษาของคุณไม่สำเร็จ';

  @override
  String get accountDeleteFailed => 'ลบบัญชีของคุณไม่สำเร็จ';

  @override
  String get changeAvatar => 'เปลี่ยนอวาตาร์';

  @override
  String get avatarIntro =>
      'เสียงและระดับความยากแตกต่างกันไปตามคู่สนทนา\nคู่สนทนาบางรายอาจต้องชำระเงิน';

  @override
  String myPartnersOwned(int count) {
    return 'คู่สนทนาของฉัน · เป็นเจ้าของ $count ราย';
  }

  @override
  String get limitedDiscount => 'ส่วนลดในระยะเวลาจำกัด';

  @override
  String get available => 'พร้อมใช้งาน';

  @override
  String get inUse => 'กำลังใช้งาน';

  @override
  String get owned => 'เป็นเจ้าของแล้ว';

  @override
  String get noCharactersToShow => 'ไม่มีตัวละครให้แสดง';

  @override
  String get buy => 'ซื้อ';

  @override
  String get noSavedSentences =>
      'ยังไม่มีประโยคที่บันทึกไว้\nบุ๊กมาร์กประโยคจากบันทึกบทสนทนาของคุณ';

  @override
  String get noAlarms => 'ยังไม่มีการเตือน';

  @override
  String get noAlarmsBody =>
      'เพิ่มการเตือนการเรียน\nเพื่อสร้างนิสัยที่สม่ำเสมอ';

  @override
  String get subscriptionManage => 'จัดการการสมัครสมาชิก';

  @override
  String get changePlan => 'เปลี่ยนแพ็กเกจ';

  @override
  String get cancelSubscription => 'ยกเลิกการสมัครสมาชิก';

  @override
  String get benefitsInUse => 'สิทธิประโยชน์ของคุณ';

  @override
  String get paymentInfo => 'ข้อมูลการชำระเงิน';

  @override
  String get nextBillingDate => 'วันเรียกเก็บเงินครั้งถัดไป';

  @override
  String get lostBenefitsTitle => 'สิทธิประโยชน์ที่คุณจะเสียหากยกเลิก';

  @override
  String get viewBillingHistory => 'ดูประวัติการเรียกเก็บเงิน';

  @override
  String get keepUsingPro => 'ใช้ Pro ต่อไป';

  @override
  String get proMembership => 'สมาชิก Pro';

  @override
  String get pricePerMonth => '\$12.9 / mo';

  @override
  String get benefitUnlimitedCalls => 'โทรได้ไม่จำกัด';

  @override
  String get benefitDetailedAnalysis =>
      'วิเคราะห์การออกเสียงและไวยากรณ์อย่างละเอียด';

  @override
  String get benefitAllCharacters => 'เข้าถึงตัวละครทั้งหมด';

  @override
  String get benefitNoAds => 'ไม่มีโฆษณา';

  @override
  String get playSampleVoice => 'เล่นเสียงตัวอย่าง';

  @override
  String get useThisAvatar => 'ใช้ตัวนี้';

  @override
  String get challengeTitle => 'ท้าทายการออกเสียง';

  @override
  String get challengeIntro =>
      'ออกเสียงการ์ดแต่ละใบในโซนเป็นภาษาเกาหลีให้ถูกต้องเพื่อผ่านด่าน\nไม่มีไมค์? คุณเล่นได้ด้วยการแตะหน้าจอเช่นกัน';

  @override
  String get challengeStart => 'เริ่มกล้องและไมค์';

  @override
  String get challengePermissionNote =>
      'จำเป็นต้องเข้าถึงกล้องหน้าและไมค์ (ไม่บังคับ)';

  @override
  String get challengeLoadingTitle => 'กำลังโหลด…';

  @override
  String get challengeLoadingNote =>
      'กำลังดาวน์โหลดโมเดลเสียงภาษาเกาหลี (~82MB) ในการรันครั้งแรก\nโปรดรอสักครู่';

  @override
  String get challengeSttFallback =>
      'ระบบรู้จำเสียงไม่พร้อมใช้งาน คุณจึงเล่นด้วยการแตะแทน';

  @override
  String get reasonTravelTitle => 'พูดคุยระหว่างเดินทาง';

  @override
  String get reasonTravelDesc => 'คุยกับคนท้องถิ่นอย่างมั่นใจ';

  @override
  String get reasonCareerTitle => 'งานและอาชีพ';

  @override
  String get reasonCareerDesc => 'บทสนทนาทางธุรกิจ';

  @override
  String get reasonExamTitle => 'เตรียมสอบ';

  @override
  String get reasonExamDesc => 'เตรียมตัวสอบพูด';

  @override
  String get reasonDailyTitle => 'บทสนทนาในชีวิตประจำวัน';

  @override
  String get reasonDailyDesc => 'สำนวนที่คุณใช้ทุกวัน';

  @override
  String get reasonFriendsTitle => 'หาเพื่อนชาวต่างชาติ';

  @override
  String get reasonFriendsDesc => 'บทสนทนาที่เป็นธรรมชาติ';

  @override
  String get reasonBrainTitle => 'กระตุ้นสมอง';

  @override
  String get reasonBrainDesc => 'เพิ่มความจำและสมาธิ';

  @override
  String get challengeRecordToggle => 'บันทึกวิดีโอรอบนี้';

  @override
  String get challengeRecordHint =>
      'บันทึกวิดีโอการเล่นของคุณเพื่อแชร์ (ไม่มีเสียง)';

  @override
  String get settingsSection => 'การตั้งค่า';

  @override
  String get paymentSection => 'การชำระเงิน';

  @override
  String get supportSection => 'ฝ่ายสนับสนุน';

  @override
  String get userLanguage => 'ภาษาผู้ใช้';

  @override
  String get learningLanguage => 'ภาษาที่เรียน';

  @override
  String get learningLanguageKorean => 'ภาษาเกาหลี';

  @override
  String get notificationLabel => 'การแจ้งเตือน';

  @override
  String get currentPlan => 'แพ็กเกจปัจจุบัน';

  @override
  String get paymentHistory => 'ประวัติการชำระเงิน';

  @override
  String get contactUs => 'ติดต่อเรา';

  @override
  String get termsOfService => 'ข้อกำหนดในการให้บริการ';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get logOut => 'ออกจากระบบ';

  @override
  String get deleteAccount => 'ลบบัญชี';

  @override
  String get deleteAccountTitle => 'ลบบัญชีใช่ไหม?';

  @override
  String get deleteAccountBody =>
      'การดำเนินการนี้จะลบบัญชีและข้อมูลของคุณอย่างถาวรและไม่สามารถกู้คืนได้';

  @override
  String get delete => 'ลบ';

  @override
  String get share => 'แชร์';

  @override
  String get accentSoundsLike => 'สำเนียงภาษาเกาหลีของคุณฟังดู';

  @override
  String get hintLabel => 'คำใบ้';

  @override
  String get nextHint => 'คำใบ้ถัดไป';

  @override
  String get translateLabel => 'แปล';

  @override
  String get startRecording => 'เริ่มบันทึกเสียง';

  @override
  String get stopRecording => 'หยุดบันทึกเสียง';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get onboardingNameTitle => 'เราควรเรียกคุณว่าอะไรดี?';

  @override
  String get onboardingNameSubtitle => 'ติวเตอร์ AI ของคุณจะจดจำชื่อของคุณ';

  @override
  String get nameLabel => 'ชื่อของคุณ';

  @override
  String get nameHint => 'กรอกชื่อของคุณ';

  @override
  String get nameHelper => 'ไม่จำเป็นต้องเป็นชื่อจริง — ใช้ชื่อเล่นก็ได้';

  @override
  String get continueLabel => 'ดำเนินการต่อ';

  @override
  String get onboardingDoneTitle => 'Beaver กำลังรอสายจากคุณ';

  @override
  String get onboardingDoneSubtitle => 'เริ่มการโทรเลยตอนนี้';

  @override
  String get home => 'หน้าหลัก';

  @override
  String get callNow => 'โทรเลย';

  @override
  String get pronunciation => 'การออกเสียง';

  @override
  String get fluency => 'ความคล่องแคล่ว';

  @override
  String get rhythm => 'จังหวะ';

  @override
  String get analysisTimeout =>
      'ใช้เวลานานกว่าที่คาดไว้ โปรดลองอีกครั้งในอีกสักครู่';

  @override
  String get analysisFailed =>
      'เราไม่สามารถวิเคราะห์บทสนทนาได้ โปรดลองอีกครั้ง';

  @override
  String get analyzingConversation => 'กำลังวิเคราะห์บทสนทนาของคุณ…';

  @override
  String get analyzingSubtitle => 'ใช้เวลาเพียงครู่เดียว';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get nativeLabel => 'เจ้าของภาษา';

  @override
  String get meLabel => 'ฉัน';

  @override
  String get pronunciationPlayError => 'เล่นเสียงการออกเสียงไม่สำเร็จ';

  @override
  String get savedExpressionsLoadError =>
      'โหลดสำนวนที่บันทึกไว้ของคุณไม่สำเร็จ';

  @override
  String get mySavedExpressions => 'สำนวนที่ฉันบันทึกไว้';

  @override
  String get avatarTraits => 'อบอุ่น · สงบ · อ่อนโยน';

  @override
  String get priceFree => 'ฟรี';

  @override
  String get loginGoogleTokenError =>
      'รับโทเค็นการลงชื่อเข้าใช้ Google ไม่สำเร็จ';

  @override
  String get loginGoogleSignInFailed => 'ลงชื่อเข้าใช้ด้วย Google ไม่สำเร็จ';

  @override
  String get loginAppleSignInFailed => 'ลงชื่อเข้าใช้ด้วย Apple ไม่สำเร็จ';

  @override
  String get loginKakaoSignInFailed => 'ลงชื่อเข้าใช้ด้วย Kakao ไม่สำเร็จ';

  @override
  String get loginContinueWithKakao => 'ดำเนินการต่อด้วย Kakao';

  @override
  String get loginContinueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get loginContinueWithApple => 'ดำเนินการต่อด้วย Apple';

  @override
  String get loginContinueWithEmail => 'ดำเนินการต่อด้วยอีเมล';

  @override
  String get loginOrDivider => 'หรือ';

  @override
  String get loginNoAccount => 'ยังไม่มีบัญชีใช่ไหม?';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get loginTermsNoticePrefix => 'การดำเนินการต่อ แสดงว่าคุณยอมรับ';

  @override
  String get loginTermsNoticeAnd => ' และ ';

  @override
  String get loginTermsNoticeSuffix => ' ของเรา';

  @override
  String get loginLogIn => 'เข้าสู่ระบบ';

  @override
  String get fieldEmailLabel => 'อีเมล';

  @override
  String get emailHint => 'กรอกอีเมลของคุณ';

  @override
  String get fieldPasswordLabel => 'รหัสผ่าน';

  @override
  String get passwordHint => 'กรอกรหัสผ่านของคุณ';

  @override
  String get loginRememberMe => 'จดจำฉันไว้';

  @override
  String get loginForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get loginLoggingIn => 'กำลังเข้าสู่ระบบ...';

  @override
  String get passwordLengthError => 'รหัสผ่านต้องมี 8–16 ตัวอักษร';

  @override
  String get passwordsDoNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get signupCheckInput => 'โปรดตรวจสอบข้อมูลที่กรอก';

  @override
  String get fieldConfirmPasswordLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get confirmPasswordHint => 'กรอกรหัสผ่านของคุณอีกครั้ง';

  @override
  String get signupSigningUp => 'กำลังสมัครสมาชิก...';

  @override
  String get signupHaveAccount => 'มีบัญชีอยู่แล้วใช่ไหม?';

  @override
  String get passwordMethodEmailRequired => 'กรอกอีเมลของคุณ';

  @override
  String get passwordResetTitle => 'รีเซ็ตรหัสผ่าน';

  @override
  String get passwordMethodDescription =>
      'กรอกอีเมลที่คุณต้องการรับรหัสสำหรับรีเซ็ตรหัสผ่าน';

  @override
  String get emailAddressHint => 'ที่อยู่อีเมล';

  @override
  String get passwordMethodSending => 'กำลังส่ง...';

  @override
  String get passwordMethodSendEmail => 'ส่งอีเมล';

  @override
  String get passwordCodeTitle => 'กรอกรหัส';

  @override
  String get passwordCodeDescription =>
      'เราได้ส่งรหัสกู้คืนไปยังอีเมลของคุณแล้ว กรอกรหัสเพื่อดำเนินการต่อ';

  @override
  String get passwordCodeNoCode => 'ไม่ได้รับรหัสใช่ไหม?';

  @override
  String get passwordCodeResend => 'ส่งรหัสอีกครั้ง';

  @override
  String get passwordCodeVerifying => 'กำลังตรวจสอบ...';

  @override
  String get passwordNewTitle => 'รหัสผ่านใหม่';

  @override
  String get passwordNewDescription => 'ตั้งรหัสผ่านใหม่สำหรับบัญชีของคุณ';

  @override
  String get fieldNewPasswordLabel => 'รหัสผ่านใหม่';

  @override
  String get newPasswordHint => 'กรอกรหัสผ่านใหม่ของคุณ';

  @override
  String get fieldConfirmNewPasswordLabel => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get confirmNewPasswordHint => 'กรอกรหัสผ่านใหม่ของคุณอีกครั้ง';

  @override
  String get passwordNewSubmitting => 'กำลังส่ง...';

  @override
  String get passwordNewSubmit => 'ส่ง';

  @override
  String get passwordCompleteTitle => 'รีเซ็ตรหัสผ่านสำเร็จ';

  @override
  String get passwordCompleteBody =>
      'รหัสผ่านของคุณถูกรีเซ็ตแล้ว เข้าสู่ระบบด้วยรหัสผ่านใหม่ของคุณเพื่อดำเนินการต่อ';

  @override
  String get termsTitle => 'ข้อกำหนดในการให้บริการ';

  @override
  String get privacyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'ตั้งรหัสผ่านใหม่สำหรับ $email';
  }

  @override
  String get selectComplete => 'เสร็จสิ้น';

  @override
  String get onboardingLanguageTitle => 'ภาษาแม่ของคุณคืออะไร';

  @override
  String get onboardingReasonTitle => 'ทำไมคุณถึงเรียนภาษา';

  @override
  String get onboardingReasonSubtitle =>
      'เราจะปรับการเรียนรู้ให้เหมาะกับเป้าหมายของคุณ';

  @override
  String get savingLabel => 'กำลังบันทึก...';

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
  String get availableForPurchase => 'ซื้อได้';

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
