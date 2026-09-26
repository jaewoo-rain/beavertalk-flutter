// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get loginRequired => 'คุณต้องเข้าสู่ระบบก่อน';

  @override
  String get callWebNotSupported => 'เว็บไม่รองรับการโทรด้วยเสียง โปรดใช้แอป';

  @override
  String get micPermissionRequiredForCall =>
      'ต้องอนุญาตไมโครโฟน โปรดอนุญาตไมโครโฟนเพื่อโทร';

  @override
  String get callErrorGeneric => 'เกิดข้อผิดพลาดระหว่างการโทร';

  @override
  String get callDailyLimit => 'ใช้เวลาเรียนของวันนี้หมดแล้ว';

  @override
  String get callAlreadyInCall => 'คุณอยู่ในสายอยู่แล้ว';

  @override
  String get callNetworkError => 'เกิดข้อผิดพลาดของเครือข่าย';

  @override
  String get authInvalidCredentials => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get authEmailAlreadyRegistered => 'อีเมลนี้ลงทะเบียนไว้แล้ว';

  @override
  String get authConfirmEmailRequired => 'โปรดยืนยันตามที่ส่งไปยังอีเมลของคุณ';

  @override
  String get authResetCodeSent => 'เราส่งรหัสยืนยันไปยังอีเมลของคุณแล้ว';

  @override
  String get authResetCodeInvalid => 'รหัสไม่ถูกต้องหรือหมดอายุแล้ว';

  @override
  String get authPasswordUpdated => 'รีเซ็ตรหัสผ่านเรียบร้อยแล้ว';

  @override
  String get authAppleTokenMissing =>
      'ไม่สามารถรับโทเค็นการเข้าสู่ระบบ Apple ได้';

  @override
  String callEndedDuration(String duration) {
    return 'จบการโทรแล้ว $duration';
  }

  @override
  String get callRatingPrompt => 'การโทรเป็นอย่างไรบ้าง?';

  @override
  String get callRatingBody => 'คะแนนของคุณช่วยให้การสนทนาครั้งหน้าดีขึ้น';

  @override
  String get callRatingSubmit => 'ส่ง';

  @override
  String get callRatingSkip => 'ข้าม';

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
  String get alarmAdd => 'เพิ่มนาฬิกาปลุก';

  @override
  String get alarmEdit => 'แก้ไขนาฬิกาปลุก';

  @override
  String get alarmEveryDay => 'ทุกวัน';

  @override
  String get alarmWeekdays => 'วันธรรมดา';

  @override
  String get alarmWeekend => 'วันหยุดสุดสัปดาห์';

  @override
  String get alarmNoRepeat => 'ไม่ทำซ้ำ';

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
  String get alarmModeLearnSub => 'ฝึกสำนวนในหลักสูตร';

  @override
  String get alarmModeChatSub => 'คุยได้ทุกเรื่อง';

  @override
  String get quickStart => 'เริ่มอย่างรวดเร็ว';

  @override
  String get presetMorning => 'กิจวัตรตอนเช้า';

  @override
  String get presetMorningSub => 'วันธรรมดา 8:00';

  @override
  String get presetEvening => 'ปิดท้ายตอนเย็น';

  @override
  String get presetEveningSub => 'ทุกวัน 21:00';

  @override
  String get presetCustom => 'กำหนดเอง';

  @override
  String get presetCustomSub => 'ตามใจคุณ';

  @override
  String alarmSummary(int count, int monthly) {
    return 'สัปดาห์ละ $count ครั้ง · เดือนละ $monthly สาย';
  }

  @override
  String get alarmSummaryNone => 'เลือกอย่างน้อยหนึ่งวัน';

  @override
  String get partnerInUse => 'กำลังใช้';

  @override
  String get partnerOwned => 'มีอยู่แล้ว';

  @override
  String get am => 'ก่อนเที่ยง';

  @override
  String get pm => 'หลังเที่ยง';

  @override
  String get save => 'บันทึก';

  @override
  String get conversation => 'บทสนทนา';

  @override
  String get newExpressions => 'สำนวนใหม่';

  @override
  String get analysisPrepNote => 'กำลังทบทวนการโทรวันนี้';

  @override
  String get analysisPrepNoteHint => 'อีกสักครู่ข้อความจะปรากฏที่นี่';

  @override
  String get analysisPrepTitle => 'บีเวอร์กำลังทำการ์ดจากสำนวนวันนี้';

  @override
  String get analysisPrepSub => 'เสร็จแล้วจะแสดงที่นี่ทันที';

  @override
  String get analysisPrepStepSave => 'บันทึกบทสนทนา';

  @override
  String get analysisPrepStepCards => 'สร้างการ์ดสำนวน';

  @override
  String get analysisPrepStateDone => 'เสร็จแล้ว';

  @override
  String get analysisPrepStateWorking => 'กำลังทำ';

  @override
  String get analysisPrepStateWaiting => 'รอ';

  @override
  String get usedExpressions => 'สำนวนที่คุณใช้';

  @override
  String quizExpressionsCount(int count) {
    return 'สำนวนที่เรียนครั้งนี้ $count';
  }

  @override
  String get quizPassed => 'ถูกต้อง';

  @override
  String get quizFailed => 'ทบทวนอีกครั้ง';

  @override
  String get quizPending => 'ทำต่อครั้งหน้า';

  @override
  String get analysisResult => 'ผลการวิเคราะห์';

  @override
  String get noNewExpressions => 'ไม่มีสำนวนใหม่จากบทสนทนานี้';

  @override
  String get practice => 'ฝึกฝน';

  @override
  String get analysisNativeLabel => 'เจ้าของภาษา';

  @override
  String recentScore(int score) {
    return 'คะแนนล่าสุด $score%';
  }

  @override
  String callSequence(int count) {
    return 'สายที่ $count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'คำพูดจาก $name';
  }

  @override
  String characterNoteFooter(String name) {
    return '$name ฝากไว้ทันทีหลังวางสาย';
  }

  @override
  String newExpressionsCount(int count) {
    return 'สำนวนใหม่ $count';
  }

  @override
  String get analysisLoadError => 'โหลดผลการวิเคราะห์ไม่สำเร็จ';

  @override
  String get standardAudioNotReady => 'เสียงออกเสียงมาตรฐานยังไม่พร้อม';

  @override
  String get standardAudioPlayError => 'เล่นเสียงออกเสียงมาตรฐานไม่สำเร็จ';

  @override
  String get selectNativeLanguage => 'เลือกภาษาแม่ของคุณ';

  @override
  String get selectYourLanguage => 'เลือกภาษาของคุณ';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get cancel => 'ยกเลิก';

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
  String get analyzingByWord => 'กำลังตรวจการออกเสียงทีละคำ';

  @override
  String get analyzingTakingLonger => 'ใช้เวลานานกว่าปกติเล็กน้อย';

  @override
  String get scanConnectionLost => 'การเชื่อมต่อหลุด';

  @override
  String get noRecordingToPlay => 'ไม่มีเสียงบันทึกให้เล่น';

  @override
  String get myRecordingPlayError => 'เล่นเสียงบันทึกของคุณไม่สำเร็จ';

  @override
  String get next => 'ถัดไป';

  @override
  String get endLearning => 'จบเซสชัน';

  @override
  String get navCall => 'โทร';

  @override
  String get homeCourseExpression => 'สำนวน';

  @override
  String get homeCourseFreetalk => 'การสนทนา';

  @override
  String homeExpressionsLeft(int count) {
    return 'เหลืออีก $count สำนวนก่อนการสนทนา';
  }

  @override
  String get homeFreetalkNote => 'ใช้สิ่งที่เรียนมาคุยได้อย่างอิสระ';

  @override
  String get homeTalkTitle => 'วันนี้มีอะไรเกิดขึ้นบ้าง?';

  @override
  String get homeTalkNote => 'คุยได้อย่างอิสระ แล้วเรียนไปพร้อมกัน';

  @override
  String get homeModeLearn => 'เรียน';

  @override
  String get homeModeTalk => 'คุย';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ติดต่อกัน $count วัน',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'ปฏิทินการเรียน';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'วันติดต่อกัน',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'สถิติสูงสุด $count วัน',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'เวลาโทร';

  @override
  String get streakMetricLearned => 'สำนวนที่เรียน';

  @override
  String get streakMetricWords => 'คำที่พูด';

  @override
  String streakCountValue(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String streakMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นาที',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'วันนี้ไม่มีการโทร';

  @override
  String get homeLevelPending => 'ยังไม่มีระดับ';

  @override
  String get homeNoLevelTitle => 'คุณยังไม่มีระดับ';

  @override
  String get homeNoLevelNote => 'จบสายแรกแล้วจะได้ระดับ';

  @override
  String get homeCurriculumPendingBadge => 'เร็วๆ นี้';

  @override
  String homeCurriculumPendingTitle(String language) {
    return 'หลักสูตร$languageกำลังเตรียมอยู่';
  }

  @override
  String get homeCurriculumPendingNote => 'คุณจะได้ฝึกสำนวนทั่วไปในการโทร';

  @override
  String get myPage => 'หน้าของฉัน';

  @override
  String get languageSaveFailed => 'บันทึกภาษาของคุณไม่สำเร็จ';

  @override
  String get accountDeleteFailed => 'ลบบัญชีของคุณไม่สำเร็จ';

  @override
  String get changeAvatar => 'เปลี่ยนอวาตาร์';

  @override
  String get avatarUseNow => 'ใช้เลย';

  @override
  String get avatarPurchaseFailed => 'การซื้อไม่สำเร็จ';

  @override
  String avatarPromoTitle(int percent) {
    return 'วันนี้เท่านั้น · ลด $percent%';
  }

  @override
  String avatarPromoLeft(String time) {
    return 'เหลือ $time';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return 'เหลือ $days วัน $time';
  }

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
  String pricePerMonth(String price) {
    return '$price / เดือน';
  }

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
  String get challengeLoadingNote => 'กำลังเตรียมกล้องและไมโครโฟน';

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
  String accentShareText(String country) {
    return 'กำลังเรียนภาษาเกาหลีกับ BeaverTalk — สำเนียงเกาหลีของฉันฟังดูเหมือน $country! 🦫 มาหาสำเนียงของคุณแล้วเรียนไปด้วยกัน: https://beavertalk.im';
  }

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
  String get onboardingLevelTestCta => 'ทำแบบทดสอบระดับ';

  @override
  String get pronunciation => 'การออกเสียง';

  @override
  String get fluency => 'ความคล่องแคล่ว';

  @override
  String get rhythm => 'จังหวะ';

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
  String get loginFacebookSignInFailed =>
      'ลงชื่อเข้าใช้ด้วย Facebook ไม่สำเร็จ';

  @override
  String get loginKakaoSignInFailed => 'ลงชื่อเข้าใช้ด้วย Kakao ไม่สำเร็จ';

  @override
  String get loginContinueWithKakao => 'ดำเนินการต่อด้วย Kakao';

  @override
  String get loginContinueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get loginContinueWithFacebook => 'ดำเนินการต่อด้วย Facebook';

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
  String get thisMonthPayment => 'ยอดชำระเดือนนี้';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterSubscription => 'สมาชิก';

  @override
  String get filterCharacter => 'ตัวละคร';

  @override
  String get statusCompleted => 'สำเร็จ';

  @override
  String get lastPayment => 'ชำระล่าสุด';

  @override
  String get freePlanCallLimit => 'โทรได้วันละ 5 นาที';

  @override
  String get freePlanBasicCharacters => 'รวมตัวละครพื้นฐาน';

  @override
  String get availableForPurchase => 'ซื้อได้';

  @override
  String get paymentsLoadError => 'โหลดประวัติการชำระเงินไม่สำเร็จ';

  @override
  String get noPayments => 'ยังไม่มีการชำระเงิน';

  @override
  String get morePaymentsExist => 'ยังไม่แสดงรายการชำระเงินก่อนหน้า';

  @override
  String get undatedPayments => 'ไม่มีวันที่';

  @override
  String get paymentLabelFallback => 'การชำระเงิน';

  @override
  String learningPassed(int passed, int total) {
    return 'ผ่าน $passed จาก $total ประโยค';
  }

  @override
  String get hardestSound => 'เสียงที่ยากที่สุดวันนี้';

  @override
  String get soundAccuracy => 'ความแม่นยำตามเสียง';

  @override
  String phonemeAttempts(int count) {
    return 'ต่อหน่วยเสียง · $count ครั้ง';
  }

  @override
  String get colSound => 'เสียง';

  @override
  String get colAttempts => 'ครั้ง';

  @override
  String get colCorrect => 'ถูก';

  @override
  String get colAccuracy => 'แม่นยำ';

  @override
  String get sentenceResults => 'ผลตามประโยค';

  @override
  String viewAllSentences(int count) {
    return 'ดูทั้ง $count รายการ';
  }

  @override
  String get colSentence => 'ประโยค';

  @override
  String get colPronunciation => 'ออกเสียง';

  @override
  String get colFluency => 'ลื่นไหล';

  @override
  String get colRhythm => 'จังหวะ';

  @override
  String recentSessions(int count) {
    return '$count เซสชันล่าสุด';
  }

  @override
  String trendAverage(int score) {
    return 'เฉลี่ย $score';
  }

  @override
  String get today => 'วันนี้';

  @override
  String get colDate => 'วันที่';

  @override
  String get colSentences => 'ประโยค';

  @override
  String get colScore => 'คะแนน';

  @override
  String get colChange => 'เปลี่ยน';

  @override
  String dateToday(String date) {
    return '$date (วันนี้)';
  }

  @override
  String get accentAnalysis => 'วิเคราะห์สำเนียง';

  @override
  String get overallLevel => 'ระดับรวม';

  @override
  String get overallLevelSubtitle => 'คำศัพท์ · ไวยากรณ์ · การแสดงออก';

  @override
  String get pronunciationAnalysis => 'วิเคราะห์การออกเสียง';

  @override
  String get recentSessionsAverage => 'เฉลี่ย 10 เซสชันล่าสุด';

  @override
  String levelStage(int stage) {
    return 'ระดับ $stage';
  }

  @override
  String topPercent(int percent) {
    return 'ท็อป $percent%';
  }

  @override
  String get allLearnersBasis => 'จากผู้เรียนทั้งหมด';

  @override
  String aheadOfLearners(int percent) {
    return 'คุณนำหน้าผู้เรียน $percent%';
  }

  @override
  String get retakeLevelTest => 'ทำแบบทดสอบระดับอีกครั้ง';

  @override
  String get levelTestOncePerDay =>
      'ทำแบบทดสอบระดับได้วันละครั้ง ลองใหม่อีกครั้งพรุ่งนี้';

  @override
  String get levelRetakeTitle => 'ทำแบบทดสอบระดับใหม่ไหม?';

  @override
  String get levelRetakeBody =>
      'ถ้าทำใหม่ ความคืบหน้าจะกลับไปที่บทเรียนแรกของระดับนั้น แม้จะได้ระดับเดิมก็ตาม สำนวนที่เรียนแล้วและประวัติการโทรยังอยู่';

  @override
  String get levelRetakeKeep => 'เก็บความคืบหน้าไว้';

  @override
  String get levelRetakeConfirm => 'ทำแบบทดสอบใหม่';

  @override
  String get practicePronunciation => 'ฝึกการออกเสียง';

  @override
  String get priceChangedTitle => 'ราคามีการเปลี่ยนแปลง';

  @override
  String priceChangedBody(String price) {
    return 'สินค้านี้ตอนนี้ราคา $price ต้องการดำเนินการต่อหรือไม่';
  }

  @override
  String get billingGroupPlanPurchases => 'แพ็กเกจและการซื้อ';

  @override
  String get billingGroupInTheStore => 'ในสโตร์';

  @override
  String get billingCompareAllPlans => 'เปรียบเทียบแพ็กเกจ';

  @override
  String get billingBuyACharacter => 'ซื้อตัวละคร';

  @override
  String get billingRestorePurchases => 'กู้คืนการซื้อ';

  @override
  String get billingRedeemCode => 'ใช้โค้ด';

  @override
  String get billingPaymentHistory => 'ประวัติการชำระเงิน';

  @override
  String get billingManageInTheStore => 'จัดการในสโตร์';

  @override
  String get billingRefundHelp => 'ความช่วยเหลือเรื่องการคืนเงิน';

  @override
  String get billingCancelSubscription => 'ยกเลิกการสมัครสมาชิก';

  @override
  String get billingResubscribe => 'สมัครใหม่อีกครั้ง';

  @override
  String get badgeCurrent => 'ปัจจุบัน';

  @override
  String get badgeTrial => 'ทดลองใช้';

  @override
  String get badgeRenewing => 'ต่ออายุอัตโนมัติ';

  @override
  String get badgePastDue => 'ค้างชำระ';

  @override
  String get badgePaused => 'หยุดชั่วคราว';

  @override
  String get badgeCanceling => 'กำลังจะยกเลิก';

  @override
  String get subscriptionTitle => 'การสมัครสมาชิก';

  @override
  String get plansTitle => 'แพ็กเกจ';

  @override
  String get planFree => 'ฟรี';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'วิดีโอคอลวันละ 15 นาที';

  @override
  String get premiumBulletAnalysis => 'วิเคราะห์การออกเสียงแบบเต็ม';

  @override
  String get premiumBulletWeakSounds => 'ฝึกเสียงที่ยังไม่แม่นสำหรับภาษาของคุณ';

  @override
  String get noteCharactersSeparate =>
      'ตัวละครขายแยกต่างหาก ตัวที่ซื้อแล้วเป็นของคุณ';

  @override
  String get ctaGetPremium => 'รับ Premium';

  @override
  String get planMaxTrial => 'ทดลองใช้ Premium';

  @override
  String get freePlanPriceLine => '\$0.00 — โทรได้วันละ 5 นาที';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount ต่อเดือน';
  }

  @override
  String freeUntilDate(String date) {
    return 'ฟรีถึง $date';
  }

  @override
  String get todaysCalls => 'เวลาโทรวันนี้';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return 'ใช้ไป $used จาก $limit นาที';
  }

  @override
  String get firstPaymentLabel => 'ชำระครั้งแรก';

  @override
  String get nextPaymentLabel => 'ชำระครั้งถัดไป';

  @override
  String get retryingUntilLabel => 'ลองใหม่จนถึง';

  @override
  String get pausedSinceLabel => 'หยุดชั่วคราวตั้งแต่';

  @override
  String planEndsLabel(String plan) {
    return '$plan สิ้นสุด';
  }

  @override
  String get bannerMaxUpsellTitle => 'คุยแบบเห็นหน้ากับ Premium';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'วิดีโอคอล · วันละ 15 นาที · เดือนละ $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'เปลี่ยนเป็นรายปี';

  @override
  String get bannerPaymentFailedTitle => 'เรียกเก็บเงินไม่สำเร็จ';

  @override
  String get bannerPaymentFailedSub =>
      'อัปเดตการชำระเงินในสโตร์เพื่อใช้ Premium ต่อ';

  @override
  String get bannerPausedTitle => 'แพ็กเกจของคุณถูกหยุดชั่วคราว';

  @override
  String get bannerPausedSub => 'การชำระเงินยังไม่สำเร็จ';

  @override
  String get noteRestoreHint =>
      'สมัครไว้บนอุปกรณ์อื่นแล้วใช่ไหม กู้คืนเพื่อใช้งานบนเครื่องนี้ได้เลย';

  @override
  String get noteStoreHandled =>
      'วิธีชำระเงิน การเปลี่ยนแพ็กเกจ และการยกเลิก จัดการผ่านสโตร์ทั้งหมด';

  @override
  String noteTrialEnds(String date) {
    return 'ช่วงทดลองใช้จะสิ้นสุด $date ยกเลิกในสโตร์ก่อนหน้านั้นแล้วจะไม่มีการเรียกเก็บเงิน';
  }

  @override
  String get noteGrace =>
      'สิทธิประโยชน์ยังใช้ได้ตลอดช่วงผ่อนผัน แอปจะไม่ขัดขวางการยกเลิกของคุณ';

  @override
  String get noteHold =>
      'Premium จะหยุดชั่วคราวจนกว่าการชำระเงินจะสำเร็จ ตัวละครและความคืบหน้าของคุณยังอยู่ครบ';

  @override
  String noteEnding(String date) {
    return 'แพ็กเกจของคุณกำลังจะสิ้นสุด สิทธิประโยชน์ใช้ได้ถึง $date จากนั้นจะเปลี่ยนเป็นแพ็กเกจฟรี สมัครใหม่ได้ทุกเมื่อ';
  }

  @override
  String get trialExpiredTitle => 'ช่วงทดลองใช้ Premium สิ้นสุดแล้ว';

  @override
  String get trialExpiredSub => 'ตอนนี้คุณอยู่ในแพ็กเกจฟรี';

  @override
  String get seePlans => 'ดูแพ็กเกจ';

  @override
  String get currentPlanTitle => 'แพ็กเกจปัจจุบัน';

  @override
  String get perMonthUnit => 'ต่อเดือน';

  @override
  String get planTaglineMax => 'ตอนนี้คุณเห็นหน้าพวกเขาได้แล้ว';

  @override
  String get planTaglineFree => 'โทรวันละ 5 นาที ฟรีไม่มีค่าใช้จ่าย';

  @override
  String get bulletProCorrections => 'แก้ไขให้ตรงกับภาษาแม่ของคุณ';

  @override
  String get bulletFreeCall => 'โทรด้วยเสียงวันละ 5 นาที';

  @override
  String get bulletFreeCheck => 'วิเคราะห์แบบเต็มสำหรับ 3 สายแรก';

  @override
  String get bulletFreeCharacter => 'ตัวละคร 2 ตัวสำหรับเริ่มต้น';

  @override
  String get ctaTurnOnVideo => 'เปิดวิดีโอคอล';

  @override
  String get noteCallLength =>
      'Premium: วันละ 15 นาที — ภายในเวลานี้โทรกี่ครั้งก็ได้';

  @override
  String get paywallProTitle1 => 'เพื่อนชาวเกาหลีของคุณ';

  @override
  String get paywallProTitle2 => 'ที่ยังตื่นอยู่ตอนตีสาม';

  @override
  String get paywallLimitHeadline => 'Premium โทรได้วันละ 15 นาที';

  @override
  String get limitBannerCallTitle => 'เวลาโทรของวันนี้หมดแล้ว';

  @override
  String get limitBannerCallSub => 'แพ็กเกจฟรีโทรได้วันละ 5 นาที';

  @override
  String get limitBannerCheckTitle => 'นั่นคือการตรวจของวันนี้';

  @override
  String get limitBannerCheckSub => 'แพ็กเกจฟรีตรวจได้วันละครั้ง';

  @override
  String get bulletProCharactersForever => 'ตัวละครที่ซื้อแล้วเป็นของคุณตลอดไป';

  @override
  String get paywallMaxTitle => 'ตอนนี้คุณเห็นหน้าพวกเขาได้แล้ว';

  @override
  String paywallTutorCompare(String price) {
    return 'เรียนกับติวเตอร์ 1 ชั่วโมงราคา \$25 ส่วน Premium 1 เดือนราคา $price';
  }

  @override
  String get planMonthly => 'รายเดือน';

  @override
  String get planAnnual => 'รายปี';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price ต่อเดือน';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth ต่อเดือน';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price ต่อเดือน';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly ต่อปี · $perMonth ต่อเดือน';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price ต่อเดือน · ยกเลิกได้ทุกเมื่อในสโตร์';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price ต่อเดือน · ยกเลิกได้ทุกเมื่อในสโตร์';
  }

  @override
  String ctaCaptionMaxYearly(String price) {
    return '$price ต่อปี · ยกเลิกได้ทุกเมื่อในสโตร์';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return 'ฟรี 7 วัน จากนั้น $price ต่อเดือน · ยกเลิกได้ทุกเมื่อในสโตร์';
  }

  @override
  String get ctaCaptionAutoRenew => 'ต่ออายุอัตโนมัติจนกว่าจะยกเลิก';

  @override
  String get footerTerms => 'ข้อกำหนด';

  @override
  String get footerPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get processingTitle => 'กำลังยืนยันการซื้อ';

  @override
  String get processingSub => 'ปกติใช้เวลาเพียงไม่กี่วินาที';

  @override
  String get successProTitle => 'คุณได้ Premium แล้ว';

  @override
  String get successMaxTitle => 'ตอนนี้คุณเห็นหน้าพวกเขาแล้ว';

  @override
  String get successMaxSub =>
      'วิดีโอคอลเปิดใช้งานแล้ว แตะปุ่มวิดีโอในการโทรครั้งไหนก็ได้';

  @override
  String get ctaStartAVideoCall => 'เริ่มวิดีโอคอล';

  @override
  String get ctaSeeYourSubscription => 'ดูการสมัครของคุณ';

  @override
  String successMaxCaption(String price) {
    return 'เรียกเก็บ $price ทุกเดือนจนกว่าคุณจะยกเลิก จัดการหรือยกเลิกได้ทุกเมื่อในสโตร์';
  }

  @override
  String get plansErrorTitle => 'โหลดแพ็กเกจไม่สำเร็จ';

  @override
  String get plansErrorSub => 'สโตร์ไม่ตอบสนอง';

  @override
  String get ctaTryAgain => 'ลองอีกครั้ง';

  @override
  String get plansErrorCaption => 'ไม่มีการเรียกเก็บเงินใด ๆ';

  @override
  String get ctaKeepMax => 'ใช้ Premium ต่อ';

  @override
  String get winbackSkip => 'ข้าม';

  @override
  String get winbackTitle => 'แพ็กเกจ Premium ของคุณสิ้นสุดแล้ว';

  @override
  String get winbackSub => 'ตอนนี้คุณอยู่ในแพ็กเกจฟรี — โทรได้วันละ 5 นาที';

  @override
  String get winbackQuestion => 'ช่วยบอกเราหน่อยได้ไหมว่าทำไมถึงเลิกใช้';

  @override
  String get winbackReasonExpensive => 'แพงเกินไป';

  @override
  String get winbackReasonUnused => 'ใช้ไม่คุ้ม';

  @override
  String get winbackReasonMissing => 'ขาดฟีเจอร์ที่ต้องการ';

  @override
  String get winbackReasonOtherApp => 'เจอแอปอื่น';

  @override
  String get winbackReasonElse => 'เหตุผลอื่น';

  @override
  String get ctaSend => 'ส่ง';

  @override
  String get ctaNotNow => 'ไว้ทีหลัง';

  @override
  String get winbackCaption =>
      'แบบสอบถามนี้ไม่ได้กู้คืนแพ็กเกจของคุณ สมัครใหม่ได้ในสโตร์';

  @override
  String get ctaContinue => 'ดำเนินการต่อ';

  @override
  String get ctaClose => 'ปิด';

  @override
  String get ovRestoreSuccessTitle => 'Premium กลับมาแล้ว';

  @override
  String get ovRestoreSuccessBody =>
      'เราพบการสมัครของคุณและเปิดใช้งานบนเครื่องนี้แล้ว';

  @override
  String get ovRestoreEmptyTitle => 'ไม่มีอะไรให้กู้คืน';

  @override
  String get ovRestoreEmptyBody =>
      'ไม่มีการสมัครที่ใช้งานอยู่ผูกกับบัญชีสโตร์นี้';

  @override
  String get ovRestoreOtherTitle => 'แพ็กเกจนี้เป็นของบัญชีอื่น';

  @override
  String get ovRestoreOtherBody =>
      'การสมัครนี้ใช้งานอยู่บนบัญชี BeaverTalk อื่นแล้ว';

  @override
  String get ctaSignInThatAccount => 'เข้าสู่ระบบบัญชีนั้น';

  @override
  String get ctaGetHelp => 'ขอความช่วยเหลือ';

  @override
  String get ovCharacterOfferTitle => 'ยังไม่พร้อมสำหรับ Premium ใช่ไหม';

  @override
  String get ovCharacterOfferBody =>
      'เลือกตัวละครหนึ่งตัวแล้วเก็บไว้เลย ซื้อครั้งเดียว — ไม่มีสมัครสมาชิก ไม่มีต่ออายุ';

  @override
  String get rowOneCharacter => 'ตัวละครหนึ่งตัว';

  @override
  String rowFromPrice(String price) {
    return 'ตัวละ $price';
  }

  @override
  String get rowYoursForever => 'เป็นของคุณตลอดไป';

  @override
  String get rowNoRenewal => 'ไม่มีต่ออายุ';

  @override
  String get rowWorksOnFree => 'ใช้ได้บนแพ็กเกจฟรี';

  @override
  String get rowYes => 'ได้';

  @override
  String get ctaSeeCharacters => 'ดูตัวละคร';

  @override
  String get ovNotEligibleTitle => 'ไม่มีอะไรให้ยกเลิก';

  @override
  String get ovNotEligibleBody =>
      'คุณอยู่ในแพ็กเกจฟรี บัญชีนี้ไม่มีการสมัครที่ใช้งานอยู่';

  @override
  String get ovCancelDownsellTitle => 'ก่อนคุณจะไป';

  @override
  String get ovCancelDownsellBody =>
      'การยกเลิกทำในสโตร์ มีสองเรื่องที่ควรรู้ไว้';

  @override
  String get rowPayYearlyInstead => 'จ่ายรายปีแทน';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price ต่อเดือน';
  }

  @override
  String get rowCharactersYouBought => 'ตัวละครที่คุณซื้อ';

  @override
  String get rowProRunsUntil => 'Premium ใช้ได้ถึง';

  @override
  String get ctaSwitchToYearly => 'เปลี่ยนเป็นรายปี';

  @override
  String get ctaContinueToStore => 'ไปที่สโตร์ต่อ';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'จ่ายรายปี ประหยัด $saved';
  }

  @override
  String get ovAnnualSwitchBody => 'แพ็กเกจรายปีถูกกว่าการจ่ายรายเดือน';

  @override
  String get rowYouSave => 'คุณประหยัด';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'รายปี';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'รายเดือนตลอดหนึ่งปี';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'เปลี่ยนเป็นรายเดือน';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'แพ็กเกจรายปีของคุณใช้ได้ถึง $date การเรียกเก็บรายเดือนเริ่มในวันถัดไป';
  }

  @override
  String get rowMonthlyBillingStarts => 'เริ่มเรียกเก็บรายเดือน';

  @override
  String get rowMonthlyLabel => 'รายเดือน';

  @override
  String get rowYearlyWorkedOut => 'รายปีคิดเป็น';

  @override
  String get ctaSwitchToMonthly => 'เปลี่ยนเป็นรายเดือน';

  @override
  String get ovRefundHelpTitle => 'การคืนเงินจัดการโดยสโตร์';

  @override
  String get ovRefundHelpBody =>
      'เราคืนเงินเองไม่ได้ ทุกคำขอจะได้รับการพิจารณาโดยสโตร์';

  @override
  String get ctaGoToStore => 'ไปที่สโตร์';

  @override
  String get ovTrialEndingTitle => 'ช่วงทดลองใช้สิ้นสุดพรุ่งนี้';

  @override
  String get ovTrialEndingBody =>
      'Premium จะใช้งานต่อเว้นแต่คุณจะยกเลิก นี่คือสิ่งที่จะเกิดขึ้น';

  @override
  String get rowTrialEnds => 'ทดลองใช้สิ้นสุด';

  @override
  String get rowFirstCharge => 'เรียกเก็บครั้งแรก';

  @override
  String get rowThenMonthly => 'จากนั้นทุกเดือน';

  @override
  String get ctaCancelInStore => 'ยกเลิกในสโตร์';

  @override
  String get ovTrialStartTitle => 'ใช้ Premium ฟรี 7 วัน';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'ฟรีถึง $date จากนั้น $price ต่อเดือน เว้นแต่คุณจะยกเลิกในสโตร์';
  }

  @override
  String get ctaStart7Days => 'เริ่มใช้ฟรี 7 วัน';

  @override
  String get ovOtoTitle => 'อีกเรื่องหนึ่งก่อนเริ่ม';

  @override
  String get ovOtoBody => 'เลือกได้ดี Premium เดียวกันจะถูกลงถ้าจ่ายรายปี';

  @override
  String get ovFailedDeclinedTitle => 'บัตรของคุณถูกปฏิเสธ';

  @override
  String get ovFailedDeclinedBody =>
      'สโตร์เรียกเก็บเงินไม่สำเร็จ ไม่มีการเรียกเก็บเงินใด ๆ';

  @override
  String get ctaUpdatePaymentMethod => 'อัปเดตวิธีชำระเงิน';

  @override
  String get ovFailedCanceledTitle => 'การชำระเงินถูกยกเลิก';

  @override
  String get ovFailedCanceledBody =>
      'คุณยังอยู่ในแพ็กเกจฟรี ไม่มีการเรียกเก็บเงินใด ๆ';

  @override
  String get ovFailedStoreTitle => 'เกิดข้อผิดพลาด';

  @override
  String get ovFailedStoreBody =>
      'เชื่อมต่อสโตร์ไม่ได้ ไม่มีการเรียกเก็บเงินใด ๆ';

  @override
  String get ovAlreadyTitle => 'คุณใช้ Premium อยู่แล้ว';

  @override
  String get ovAlreadyBody =>
      'บัญชีสโตร์นี้มีแพ็กเกจที่ใช้งานอยู่แล้ว ไม่มีอะไรต้องซื้อเพิ่ม';

  @override
  String get ctaSeeMySubscription => 'ดูการสมัครของฉัน';

  @override
  String get subCancelTitle => 'ยกเลิกการสมัครสมาชิก';

  @override
  String subCancelBody(String date) {
    return 'Premium ใช้ได้ถึง $date หลังจากนั้นคุณจะเปลี่ยนเป็นแพ็กเกจฟรี';
  }

  @override
  String get subWhatYouLose => 'สิ่งที่คุณจะเสียไป';

  @override
  String get benefitScoring => 'ให้คะแนนการออกเสียงทีละตัวอักษร';

  @override
  String get benefitEveryMetric => 'ทุกตัวชี้วัด ทุกประโยค';

  @override
  String get subPaymentTitle => 'อัปเดตการชำระเงิน';

  @override
  String get subPaymentBody =>
      'เรียกเก็บเงินไม่สำเร็จ Premium ยังใช้ได้ต่อในช่วงผ่อนผัน';

  @override
  String get subHowToFix => 'วิธีแก้ไข';

  @override
  String get fixStep1 => 'เปิดสโตร์แล้วอัปเดตวิธีชำระเงิน';

  @override
  String get fixStep2 => 'กลับมา — แพ็กเกจจะกลับมาใช้งานเองอัตโนมัติ';

  @override
  String get fixStep3 => 'ไม่มีการเรียกเก็บซ้ำ';

  @override
  String get subResubTitle => 'สมัครใหม่อีกครั้ง';

  @override
  String subResubBody(String date) {
    return 'Premium จะสิ้นสุดวันที่ $date เปิดต่ออายุอัตโนมัติอีกครั้งแล้วทุกอย่างจะเหมือนเดิม';
  }

  @override
  String get subWhatYouKeep => 'สิ่งที่คุณยังได้ใช้ต่อ';

  @override
  String get ctaTurnItBackOn => 'เปิดใช้อีกครั้ง';

  @override
  String get flTodayTitle => 'เวลาโทรของวันนี้หมดแล้ว';

  @override
  String get flTodayBody => 'คุยต่อจากที่ค้างไว้ — ได้เลยตอนนี้';

  @override
  String get flCheckTitle => 'นั่นคือการตรวจของวันนี้';

  @override
  String get flCheckBody =>
      'แพ็กเกจฟรีตรวจได้วันละ 1 ครั้ง Premium ให้ผลวิเคราะห์ครบทั้งหมด';

  @override
  String flCaption(String price) {
    return '$price ต่อเดือน · ยกเลิกได้ทุกเมื่อ';
  }

  @override
  String flUsage(String used, String limit) {
    return 'ใช้ไป $used จาก $limit';
  }

  @override
  String get ctaMaybeTomorrow => 'ไว้พรุ่งนี้';

  @override
  String get accountSection => 'บัญชี';

  @override
  String get nicknameLabel => 'ชื่อเล่น';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get loginMethodLabel => 'วิธีเข้าสู่ระบบ';

  @override
  String get joinedLabel => 'วันที่เข้าร่วม';

  @override
  String get editNicknameTitle => 'แก้ไขชื่อเล่น';

  @override
  String get nicknameRule =>
      '2–12 ตัวอักษร · ใช้ได้เฉพาะตัวอักษรภาษาอังกฤษและตัวเลข';

  @override
  String get ctaSave => 'บันทึก';

  @override
  String get subscriptionRow => 'การสมัครสมาชิก';

  @override
  String get iapSuccessTitle => 'ซื้อสำเร็จ';

  @override
  String iapSuccessBody(String name) {
    return 'อวาตาร์ $name เป็นของคุณตลอดไป\nจะใช้งานได้ทันทีเมื่อยืนยันใบเสร็จ';
  }

  @override
  String get ctaGoHome => 'ไปหน้าแรก';

  @override
  String get ctaUseNow => 'ใช้เลย';

  @override
  String get iapFailTitle => 'การชำระเงินไม่สำเร็จ';

  @override
  String get iapFailBody => 'คุณลองใหม่ได้';

  @override
  String get paywallGuardTitle => 'คุณใช้ฟรีต่อได้';

  @override
  String get paywallGuardBody => 'คุณยังโทรได้วันละ 5 นาทีเหมือนเดิม';

  @override
  String get ctaMaybeLater => 'ไว้ทีหลัง';

  @override
  String get iapCharacterSuccessTitle => 'เพื่อนใหม่มาร่วมแล้ว!';

  @override
  String get iapCharacterSuccessBody =>
      'ตัวละครนี้เป็นของคุณตลอดไป — คงอยู่แม้เปลี่ยนแพ็กเกจ และกู้คืนการซื้อได้ในทุกอุปกรณ์';

  @override
  String get iapCharacterFailedBody =>
      'การซื้อไม่สำเร็จ ไม่มีการเรียกเก็บเงิน โปรดลองอีกครั้ง';

  @override
  String get noAccentDataTitle => 'ยังไม่มีข้อมูลน้ำเสียง';

  @override
  String get noAccentDataBody => 'คุยต่อไปแล้วลักษณะน้ำเสียงจะค่อยๆ สะสม';

  @override
  String get noLevelYetTitle => 'ยังไม่มีระดับ';

  @override
  String get noLevelYetBody => 'จบการโทรครั้งแรกเพื่อรับระดับของคุณ';

  @override
  String get noPronunciationDataTitle => 'ยังไม่มีบันทึกการออกเสียง';

  @override
  String get noPronunciationDataBody =>
      'เราวิเคราะห์การออกเสียงจากประโยคที่คุณพูดในสาย';

  @override
  String get noCharacterNote => 'ยังไม่มีข้อความ';

  @override
  String get noPhonemesYet => 'ยังไม่มีเสียงให้วิเคราะห์';

  @override
  String get noSentencesYet => 'ยังไม่มีประโยคให้วิเคราะห์';

  @override
  String get takeLevelTest => 'ทำแบบทดสอบระดับ';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get difficultySlow => 'ช้า';

  @override
  String get difficultyNormal => 'ปกติ';

  @override
  String get difficultyFast => 'เร็ว';

  @override
  String get difficultyLabel => 'ระดับความยาก';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get unlockedWithMax => 'รวมอยู่ในแพ็กเกจของคุณ';

  @override
  String get fcEndedTitle => 'การโทรฟรีของคุณสิ้นสุดแล้ว';

  @override
  String get fcEndedBody =>
      'การโทรฟรีใช้ได้สูงสุด 5 นาที\nสมัครสมาชิกเพื่อคุยต่อได้นานขึ้น';

  @override
  String get ctaSubscribeKeepTalking => 'สมัครสมาชิกและคุยต่อ';

  @override
  String get kgTitle => 'คุยต่อไหม';

  @override
  String get kgBody => 'การโทรจะต่อไปเป็นช่วงสั้นๆ\nเราจะถามอีกครั้งทุกครั้ง';

  @override
  String get pcEndedTitleToday => 'วันนี้ขอจบการโทรไว้แค่นี้นะ';

  @override
  String get pcEndedBodyToday =>
      'ทบทวนสิ่งที่เราคุยกัน แล้วพรุ่งนี้โทรมาอีกนะ!';

  @override
  String get pcEndedTitle => 'ขอจบการโทรครั้งนี้ไว้แค่นี้นะ';

  @override
  String get pcEndedBody => 'ทบทวนสิ่งที่เราคุยกัน แล้วโทรมาอีกนะ!';

  @override
  String get ctaKeepTalking => 'คุยต่อ';

  @override
  String get callModeSheetTitle => 'อยากคุยแบบไหน';

  @override
  String get callModeSheetSubtitle => 'มีผลกับสายนี้ทันที';

  @override
  String get callModeFreeTalk => 'คุยอิสระ';

  @override
  String get callModeFreeTalkDesc => 'คุยสบาย ๆ ไม่มีการแก้';

  @override
  String get callModeStudy => 'เรียนรู้';

  @override
  String get callModeStudyDesc => 'เรียนทีละสำนวนและแก้การออกเสียง';

  @override
  String get callModeChange => 'เปลี่ยนโหมด';

  @override
  String get callModeKeep => 'ไว้ก่อน';

  @override
  String get callExitTitle => 'วางสายเลยไหม';

  @override
  String get callExitSubtitle =>
      'วางสายตอนนี้ เวลาที่คุยไปแล้วก็ยังนับรวมในวันนี้';

  @override
  String get callExitKeep => 'คุยต่อ';

  @override
  String get callExitConfirm => 'วางสาย';

  @override
  String get callMicMute => 'ปิดไมค์';

  @override
  String get callMicUnmute => 'เปิดไมค์';

  @override
  String get callPushToTalk => 'กดค้างเพื่อพูด';

  @override
  String get callFreeEndedTitle => 'สายฟรีของคุณหมดแล้ว';

  @override
  String get callFreeEndedCta => 'สมัครสมาชิกและคุยต่อ';

  @override
  String get callKeepGoingTitle => 'คุยต่อไหม';

  @override
  String get callKeepGoingSubtitle =>
      'สายจะต่อเนื่องครั้งละ 5 นาที เราจะถามใหม่ทุกครั้ง';

  @override
  String get articulationSelectedWord => 'คำที่เลือก';

  @override
  String get articulationYouSaid => 'การออกเสียงของคุณ';

  @override
  String get articulationTargetSound => 'เป้าหมาย';

  @override
  String get reportEntry => 'รายงาน';

  @override
  String get reportTitle => 'รายงาน';

  @override
  String get reportPrompt => 'เกิดปัญหาอะไรขึ้น?';

  @override
  String get reportGuide =>
      'บอกเราว่าเนื้อหาใดจากตัวละคร AI ที่ทำให้คุณรู้สึกไม่สบายใจ เราตรวจสอบทุกรายงาน';

  @override
  String get reportReasonSexual => 'เนื้อหาทางเพศ';

  @override
  String get reportReasonHate => 'ความเกลียดชังหรือการเลือกปฏิบัติ';

  @override
  String get reportReasonViolence => 'เนื้อหารุนแรงหรือข่มขู่';

  @override
  String get reportReasonSelfHarm => 'ส่งเสริมการทำร้ายตัวเอง';

  @override
  String get reportReasonMisinfo => 'ข้อมูลเท็จ';

  @override
  String get reportReasonOther => 'ปัญหาอื่น';

  @override
  String get reportDetailHint => 'อธิบายสิ่งที่เกิดขึ้น (ไม่บังคับ)';

  @override
  String get reportSubmit => 'ส่งรายงาน';

  @override
  String get reportDoneTitle => 'ได้รับรายงานของคุณแล้ว';

  @override
  String get reportDoneBody =>
      'เราจะตรวจสอบและดำเนินการหากจำเป็น ขอบคุณที่ช่วยให้ BeaverTalk ปลอดภัย';

  @override
  String get reportFailed => 'ส่งรายงานไม่สำเร็จ กรุณาลองอีกครั้ง';

  @override
  String get hwTitle => 'การบ้าน';

  @override
  String get hwJoinCodeTitle => 'กรอกรหัสชั้นเรียนของคุณ';

  @override
  String get hwJoinCodeSubtitle => 'เป็นรหัส 6 ตัวอักษรที่ครูให้คุณ';

  @override
  String get hwJoinCodeLabel => 'รหัสชั้นเรียน';

  @override
  String get hwJoinCodeHelp => 'รหัสไม่แยกตัวพิมพ์ใหญ่เล็ก';

  @override
  String get hwJoinConfirmTitle => 'ใช่ชั้นเรียนนี้ไหม';

  @override
  String get hwJoinConfirmSubtitle => 'ถ้าไม่ใช่ กรุณาตรวจสอบรหัสอีกครั้ง';

  @override
  String get hwJoinFieldInstitution => 'สถาบัน';

  @override
  String get hwJoinFieldTeacher => 'ครู';

  @override
  String get hwJoinFieldLearners => 'ผู้เรียน';

  @override
  String get hwJoinFieldTerm => 'ภาคเรียน';

  @override
  String get hwJoinConfirmNote =>
      'ชื่อชั้นเรียนแสดงตามที่ครูเขียนไว้ เราไม่แปลชื่อ';

  @override
  String get hwJoinConfirmYes => 'ใช่ อันนี้เลย';

  @override
  String get hwJoinConfirmRetry => 'กรอกรหัสใหม่';

  @override
  String get hwJoinProfileTitle => 'คุณจะใช้ชื่ออะไรในชั้นเรียน';

  @override
  String get hwJoinProfileSubtitle => 'ครูจะใช้เทียบกับรายชื่อ';

  @override
  String get hwJoinNameLabel => 'ชื่อ';

  @override
  String get hwJoinNameHelp => 'ต่างจากชื่อในแอปได้';

  @override
  String get hwJoinStudentNoLabel => 'รหัสนักเรียน (ไม่บังคับ)';

  @override
  String get hwJoinStudentNoHelp => 'ครูใช้เทียบกับรายชื่อ';

  @override
  String get hwJoinConsentTitle => 'สิ่งที่ครูเห็น';

  @override
  String get hwJoinConsentSubtitle => 'คุณต้องยินยอมเพื่อเข้าร่วมชั้นเรียน';

  @override
  String get hwJoinConsentSharedHeading => 'แชร์กับครู';

  @override
  String get hwJoinConsentShared1 => 'ชื่อชั้นเรียนและรหัสนักเรียน';

  @override
  String get hwJoinConsentShared2 => 'คุณทำการบ้านหรือไม่';

  @override
  String get hwJoinConsentShared3 => 'ประโยคที่ผ่านและไม่ผ่าน';

  @override
  String get hwJoinConsentShared4 => 'ความยาวและสรุปการโทรของการบ้าน';

  @override
  String get hwJoinConsentNotSharedHeading => 'ไม่แชร์';

  @override
  String get hwJoinConsentNotShared1 => 'อีเมลและหมายเลขโทรศัพท์';

  @override
  String get hwJoinConsentNotShared2 => 'ชื่อในแอป โปรไฟล์ และตัวละคร';

  @override
  String get hwJoinConsentNotShared3 => 'สัญชาติและภาษาแม่';

  @override
  String get hwJoinConsentNotShared4 => 'การโทรและการเรียนนอกชั้นเรียน';

  @override
  String get hwJoinConsentNotShared5 => 'ข้อมูลการสมัครสมาชิกและการชำระเงิน';

  @override
  String get hwJoinConsentAgree => 'ฉันยอมรับข้อความข้างต้น';

  @override
  String get hwJoinConsentCta => 'ยอมรับและเข้าร่วม';

  @override
  String hwJoinDoneTitle(String className) {
    return 'คุณเข้าร่วม $className แล้ว';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return 'มีการบ้าน $count ชิ้นรออยู่';
  }

  @override
  String get hwJoinDoneNoAssignment => 'ยังไม่มีการบ้าน';

  @override
  String get hwJoinDoneNextDue => 'กำหนดส่งถัดไป';

  @override
  String get hwJoinDoneRosterName => 'ชื่อของคุณในชั้นเรียน';

  @override
  String get hwJoinDoneCta => 'ดูการบ้าน';

  @override
  String get hwJoinErrorNotFound => 'ไม่พบรหัสนั้น';

  @override
  String get hwJoinErrorNotFoundBody => 'กรุณาตรวจสอบตัวเลขหกหลักอีกครั้ง';

  @override
  String get hwJoinErrorExpired => 'รหัสนั้นหมดอายุแล้ว';

  @override
  String get hwJoinErrorExpiredBody => 'ขอรหัสใหม่จากครูของคุณ';

  @override
  String get hwJoinErrorFull => 'ชั้นเรียนเต็มแล้ว';

  @override
  String get hwJoinErrorFullBody => 'กรุณาแจ้งครูของคุณ';

  @override
  String get hwJoinFailed => 'เข้าร่วมไม่สำเร็จ กรุณาลองใหม่อีกครั้ง';

  @override
  String get hwSectionInProgress => 'กำลังทำ';

  @override
  String get hwSectionUpcoming => 'กำลังจะถึง';

  @override
  String get hwSectionDone => 'เสร็จแล้ว';

  @override
  String get hwLeaveClassLink => 'ออกจากชั้นเรียน';

  @override
  String get hwListEmptyTitle => 'ยังไม่มีการบ้าน';

  @override
  String get hwListEmptyBody => 'จะแสดงที่นี่เมื่อครูมอบหมาย';

  @override
  String get hwListFailed => 'โหลดการบ้านไม่สำเร็จ';

  @override
  String get hwRetry => 'ลองอีกครั้ง';

  @override
  String get hwBadgeDone => 'เสร็จแล้ว';

  @override
  String get hwBadgeOverdue => 'ยังไม่ส่ง';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'ยังไม่ส่ง ช้า $days วัน';
  }

  @override
  String hwBadgeDday(int days) {
    return 'อีก $days วัน';
  }

  @override
  String get hwBadgeDueToday => 'ครบกำหนดวันนี้';

  @override
  String get hwActivitySpeaking => 'การพูด';

  @override
  String get hwActivityConversation => 'การสนทนา';

  @override
  String get hwActivityWorkbook => 'แบบฝึกหัด';

  @override
  String hwChapterLabel(String chapter) {
    return 'บทที่ $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'ตรวจคะแนนการออกเสียงของคุณ';

  @override
  String get hwTaskConversationDesc => 'ใช้สิ่งที่เรียนมาในการสนทนาจริง';

  @override
  String get hwConversationOnce => 'บทสนทนาทำได้ครั้งเดียวต่อการบ้านหนึ่งชิ้น';

  @override
  String get hwTaskWorkbookDesc => 'ฝึกด้วยการเขียนลงในแบบฝึกหัด';

  @override
  String get hwCtaStudy => 'เริ่ม';

  @override
  String get hwCtaResult => 'ดูผลลัพธ์';

  @override
  String get hwCtaDownload => 'ดาวน์โหลด';

  @override
  String get hwSpeakingNoScore => 'คุณยังไม่ได้ทำแบบฝึกการพูด';

  @override
  String get hwWorkbookUnavailable => 'ยังไม่มีไฟล์แบบฝึกหัด';

  @override
  String get hwDetailClosed => 'การบ้านนี้ปิดแล้ว คุณส่งไม่ได้อีก';

  @override
  String get hwLeaveTitle => 'ออกจากชั้นเรียนไหม';

  @override
  String get hwLeaveBody => 'ครูจะไม่เห็นผลการบ้านของคุณอีกต่อไป';

  @override
  String get hwLeaveConfirm => 'ออก';

  @override
  String get hwLeaveCancel => 'อยู่ต่อ';

  @override
  String get hwLeaveFailed => 'ออกจากชั้นเรียนไม่สำเร็จ';

  @override
  String get hwMyClass => 'ชั้นเรียนของฉัน';

  @override
  String get hwClassEmptyTitle => 'คุณยังไม่ได้เข้าร่วมชั้นเรียน';

  @override
  String get hwClassEmptySubtitle => 'กรอกรหัสที่ครูให้คุณ';

  @override
  String get hwClassEmptyCta => 'กรอกรหัสชั้นเรียน';

  @override
  String get hwClassContinueCta => 'ดำเนินการต่อ';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return 'มีการบ้าน $count ชิ้นครบกำหนดพรุ่งนี้';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'คุณมีการบ้านที่ยังไม่ส่ง $count ชิ้น';
  }

  @override
  String get hwSpeakingUnavailable => 'ยังไม่มีประโยคสำหรับการบ้านนี้';

  @override
  String get hwBadgeClosed => 'ปิดแล้ว';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return 'ผ่าน $passed จาก $total ประโยค';
  }

  @override
  String get challengeFirstWord => 'คำแรก';

  @override
  String get challengeSeeAnalysis => 'ดูผลลัพธ์';

  @override
  String get challengePaused => 'หยุดชั่วคราว';

  @override
  String get challengePausedNote => 'ตัวจับเวลาและการบันทึกหยุดพร้อมกัน';

  @override
  String get challengeTimeLeft => 'เวลาที่เหลือ';

  @override
  String get challengeScoreLabel => 'คะแนน';

  @override
  String get challengeResume => 'เล่นต่อ';

  @override
  String get challengeBlockedTitle => 'ใช้กล้องไม่ได้';

  @override
  String get challengeBlockedNote => 'เปิดสิทธิ์กล้องและไมโครโฟนในการตั้งค่า';

  @override
  String get challengeGoBack => 'กลับ';

  @override
  String get challengeOpenSettings => 'เปิดการตั้งค่า';

  @override
  String get saveDone => 'บันทึกลงแกลเลอรีแล้ว';

  @override
  String get saveFailed => 'บันทึกไม่สำเร็จ';

  @override
  String get saveDeniedNote => 'ต้องมีสิทธิ์เข้าถึงรูปภาพ';

  @override
  String get callIncomingCallerFallback => 'ติวเตอร์บีเวอร์';

  @override
  String get callIncomingHandle => 'สายภาษาเกาหลี';

  @override
  String get callMissedTitle => 'สายที่ไม่ได้รับ';

  @override
  String get callMissedChannelDescription =>
      'แจ้งเตือนเมื่อคุณพลาดสายจากบีเวอร์';

  @override
  String callMissedBody(String name) {
    return '$name โทรหาคุณ';
  }

  @override
  String get callBeaverFallbackName => 'บีเวอร์';

  @override
  String get callNotifPermissionRationale =>
      'ต้องอนุญาตการแจ้งเตือนเพื่อรับสาย';

  @override
  String get callNotifPermissionRequired =>
      'โปรดอนุญาตการแจ้งเตือนในการตั้งค่า';

  @override
  String get callHintLockedTitle => 'ไม่สามารถใช้คำใบ้ในโหมดเรียนรู้ได้';

  @override
  String get wsTitle => 'เสียงที่ยังไม่แม่น';

  @override
  String get wsToList => 'กลับไปรายการ';

  @override
  String get wsNext => 'ถัดไป';

  @override
  String get wsRetry => 'ลองอีกครั้ง';

  @override
  String get wsDone => 'เสร็จสิ้น';

  @override
  String get wsContinue => 'ไปต่อ';

  @override
  String get wsQuit => 'ออก';

  @override
  String get wsRetryLater => 'โปรดลองอีกครั้งในอีกสักครู่';

  @override
  String get wsMissingTitle => 'ไม่พบเสียงนั้น';

  @override
  String get wsMissingBody => 'โปรดเลือกจากรายการอีกครั้ง';

  @override
  String get wsListLoadFailed => 'โหลดรายการไม่สำเร็จ';

  @override
  String get wsLessonLoadFailed => 'โหลดบทเรียนไม่สำเร็จ';

  @override
  String get wsNationalTitle => 'เสียงที่ยังไม่แม่นตามสำเนียงของคุณ';

  @override
  String get wsNationalPending => 'จะเติมให้เมื่อวิเคราะห์สำเนียงของคุณเสร็จ';

  @override
  String get wsNationalPicked => 'เลือกจากผลวิเคราะห์สำเนียงของคุณ';

  @override
  String get wsNationalEmptyBody =>
      'โทรอีกสักสองสามครั้ง แล้วเราจะวิเคราะห์สำเนียงให้';

  @override
  String get wsMineTitle => 'เสียงที่ยังไม่แม่นของฉัน';

  @override
  String get wsMineSubtitle => 'เสียงที่ได้คะแนนต่ำสุดช่วงนี้';

  @override
  String get wsMineEmptyBody =>
      'โทรและทบทวน แล้วเสียงที่ยังไม่แม่นจะค่อยๆ สะสม';

  @override
  String get wsNoDataYet => 'ยังไม่มีข้อมูล';

  @override
  String get wsGoToCall => 'เริ่มการโทร';

  @override
  String get wsRule => 'กฎ';

  @override
  String get wsRecommended => 'แนะนำ';

  @override
  String get wsNotMeasured => 'ยังไม่ได้วัด';

  @override
  String get wsStepUnderstand => 'เข้าใจ';

  @override
  String get wsStepWords => 'คำศัพท์';

  @override
  String get wsStepSentence => 'ประโยค';

  @override
  String get wsStepTest => 'ทดสอบ';

  @override
  String get wsQuitTitle => 'หยุดฝึกไหม';

  @override
  String get wsQuitBody => 'ถ้าออกตอนนี้ การฝึกครั้งนี้จะไม่ถูกบันทึก';

  @override
  String get wsHowToSound => 'วิธีออกเสียง';

  @override
  String get wsPracticeWords => 'ฝึกคำศัพท์';

  @override
  String get wsPracticeSentence => 'ฝึกประโยค';

  @override
  String get wsPracticeAgain => 'อีกครั้ง';

  @override
  String get wsStartTest => 'ทำแบบทดสอบครั้งสุดท้าย';

  @override
  String get wsThisSentence => 'ประโยคนี้';

  @override
  String get wsNoScoreNote => 'ขั้นนี้ไม่มีคะแนน พูดตามสบายๆ ได้เลย';

  @override
  String get wsListen => 'ฟังให้ดี';

  @override
  String get wsSayNow => 'ตอนนี้พูดตาม';

  @override
  String get wsPracticeDone => 'ฝึกเสร็จแล้ว';

  @override
  String get wsPaused => 'หยุดชั่วคราว';

  @override
  String get wsAudioFailed => 'โหลดเสียงไม่สำเร็จ อ่านออกเสียงจากข้อความได้เลย';

  @override
  String get wsReadAloud => 'อ่านประโยคด้านล่างออกเสียง';

  @override
  String get wsTapToStart => 'แตะเพื่อเริ่ม';

  @override
  String get wsTapWhenDone => 'อ่านจบแล้วแตะ';

  @override
  String get wsScoring => 'กำลังให้คะแนน';

  @override
  String get wsMicFailed => 'เปิดไมโครโฟนไม่สำเร็จ';

  @override
  String get wsMicPermissionBody =>
      'แบบทดสอบนี้ต้องอ่านออกเสียง จึงต้องใช้ไมโครโฟน เปิดสิทธิ์เข้าถึงไมโครโฟนในการตั้งค่า';

  @override
  String get wsNoSound => 'ไม่ได้ยินเสียงเลย ลองพูดอีกครั้งไหม';

  @override
  String get wsScoreFailed => 'การให้คะแนนล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get wsSomethingWrong => 'เกิดข้อผิดพลาด';

  @override
  String get wsLearnDone => 'เรียนจบแล้ว';

  @override
  String get wsRetest => 'ทดสอบอีกครั้ง';

  @override
  String get wsFirstMeasure => 'การวัดครั้งแรก';

  @override
  String get wsFinalTest => 'ทดสอบครั้งสุดท้าย';

  @override
  String wsPoints(int score) {
    return '$score คะแนน';
  }

  @override
  String wsBeforePoints(int score) {
    return 'ก่อนเรียน $score คะแนน';
  }

  @override
  String wsGoalPoints(int score) {
    return 'เป้าหมาย $score คะแนน';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'เป้าหมาย · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return 'สำเนียง $country';
  }

  @override
  String wsWordsRepeated(int count) {
    return 'พูดตามคำศัพท์ $count คำ';
  }

  @override
  String wsChunksRepeated(int count) {
    return 'พูดตามประโยค $count ท่อน';
  }

  @override
  String get wsStartRecommended => 'เริ่มจากเสียงที่แนะนำ';

  @override
  String wsStartRecommendedWith(String label) {
    return 'เริ่มจาก $label';
  }

  @override
  String get wsPointsUnit => 'คะแนน';

  @override
  String get wsEnterFromMypage => 'ฝึกเสียงที่ยังไม่แม่น';

  @override
  String wsGoalOnly(int score) {
    return 'เป้าหมาย $score';
  }

  @override
  String wsSoundOf(String label) {
    return 'เสียง $label';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc ถ้าเจอเสียงนี้อีกตอนโทร ให้นึกถึงรูปปากแบบนี้';
  }

  @override
  String wsNationalSubtitle(String country) {
    return 'เสียงที่ผู้พูดจาก $country มักออกเสียงผิด';
  }
}
