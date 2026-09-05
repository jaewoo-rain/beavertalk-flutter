// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get loginRequired => 'Anda perlu log masuk.';

  @override
  String get callWebNotSupported =>
      'Panggilan suara tidak disokong di web. Sila gunakan apl.';

  @override
  String get micPermissionRequiredForCall =>
      'Kebenaran mikrofon diperlukan. Benarkan mikrofon untuk membuat panggilan.';

  @override
  String get callErrorGeneric => 'Ralat berlaku semasa panggilan.';

  @override
  String get callNetworkError => 'Ralat rangkaian berlaku.';

  @override
  String get authInvalidCredentials => 'E-mel atau kata laluan tidak betul.';

  @override
  String get authEmailAlreadyRegistered => 'E-mel ini sudah didaftarkan.';

  @override
  String get authConfirmEmailRequired =>
      'Sila lengkapkan pengesahan yang dihantar ke e-mel anda.';

  @override
  String get authResetCodeSent =>
      'Kami telah menghantar kod pengesahan ke e-mel anda.';

  @override
  String get authResetCodeInvalid => 'Kod tidak betul atau telah tamat tempoh.';

  @override
  String get authPasswordUpdated => 'Kata laluan anda telah ditetapkan semula.';

  @override
  String get authAppleTokenMissing =>
      'Tidak dapat memperoleh token log masuk Apple.';

  @override
  String callEndedDuration(String duration) {
    return 'Panggilan berakhir $duration';
  }

  @override
  String get callRatingPrompt => 'Bagaimana panggilan anda?';

  @override
  String get ratingBad => 'Kurang baik';

  @override
  String get ratingOkay => 'Okey';

  @override
  String get ratingGood => 'Bagus';

  @override
  String get goHome => 'Laman Utama';

  @override
  String get viewAnalysis => 'Lihat Analisis';

  @override
  String get loadingShort => 'Memuatkan…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Gagal menghantar penilaian: $message';
  }

  @override
  String get callInfoNotFound =>
      'Maklumat panggilan tidak dijumpai, analisis dilangkau.';

  @override
  String get tabRecords => 'Rekod';

  @override
  String get tabArchive => 'Arkib';

  @override
  String get callHistory => 'Sejarah Panggilan';

  @override
  String get conversationRecord => 'Rekod perbualan';

  @override
  String get noCallRecords => 'Belum ada rekod panggilan';

  @override
  String get noCallRecordsBody =>
      'Selepas anda selesai panggilan pertama dengan AI,\nrekod anda akan dipaparkan di sini.';

  @override
  String get startCall => 'Mulakan Panggilan';

  @override
  String get recordsLoadError => 'Tidak dapat memuatkan rekod';

  @override
  String get tryAgainLater => 'Sila cuba lagi kemudian.';

  @override
  String get retry => 'Cuba Lagi';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes min $seconds saat';
  }

  @override
  String get scheduleManagement => 'Jadual';

  @override
  String get alarms => 'Penggera';

  @override
  String get addSchedule => 'Tambah Jadual';

  @override
  String get editSchedule => 'Edit Jadual';

  @override
  String get somethingWentWrong => 'Sesuatu tidak kena';

  @override
  String get alarmsLoadError => 'Tidak dapat memuatkan penggera';

  @override
  String get charactersLoadError => 'Tidak dapat memuatkan watak';

  @override
  String get noCharacters => 'Tiada watak tersedia';

  @override
  String get close => 'Tutup';

  @override
  String get repeat => 'Ulang';

  @override
  String get callPartner => 'Watak';

  @override
  String get quickStart => 'Mula pantas';

  @override
  String get presetMorning => 'Rutin pagi';

  @override
  String get presetMorningSub => 'Hari bekerja 8:00';

  @override
  String get presetEvening => 'Penutup malam';

  @override
  String get presetEveningSub => 'Setiap hari 21:00';

  @override
  String get presetCustom => 'Tersuai';

  @override
  String get presetCustomSub => 'Ikut anda';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× seminggu · $monthly panggilan sebulan';
  }

  @override
  String get alarmSummaryNone => 'Pilih sekurang-kurangnya satu hari';

  @override
  String get partnerInUse => 'Sedang digunakan';

  @override
  String get partnerOwned => 'Dimiliki';

  @override
  String get am => 'PG';

  @override
  String get pm => 'PTG';

  @override
  String get save => 'Simpan';

  @override
  String get conversation => 'Perbualan';

  @override
  String get review => 'Semakan';

  @override
  String get pronunciationChallenge => 'Cabaran Sebutan';

  @override
  String get newExpressions => 'Ungkapan Baharu';

  @override
  String get usedExpressions => 'Ungkapan yang anda guna';

  @override
  String get analysisResult => 'Keputusan Analisis';

  @override
  String get noNewExpressions =>
      'Tiada ungkapan baharu daripada perbualan ini.';

  @override
  String get practice => 'Latihan';

  @override
  String recentScore(int score) {
    return 'Skor terkini $score%';
  }

  @override
  String callSequence(int count) {
    return 'Panggilan ke-$count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Sepatah kata daripada $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Ditinggalkan $name sebaik selesai panggilan';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Ungkapan baharu $count';
  }

  @override
  String get analysisLoadError => 'Tidak dapat memuatkan keputusan analisis.';

  @override
  String get standardAudioNotReady => 'Audio sebutan piawai belum sedia lagi.';

  @override
  String get standardAudioPlayError =>
      'Tidak dapat memainkan audio sebutan piawai.';

  @override
  String get selectNativeLanguage => 'Pilih bahasa ibunda anda';

  @override
  String get selectYourLanguage => 'Pilih bahasa anda';

  @override
  String get confirm => 'Sahkan';

  @override
  String get cancel => 'Batal';

  @override
  String get selectTime => 'Pilih masa';

  @override
  String get getStarted => 'Mula';

  @override
  String get permissionTitle =>
      'Benarkan kebenaran\nuntuk pengalaman yang lancar';

  @override
  String get permissionSubtitle =>
      'Kebenaran yang diperlukan adalah penting untuk menggunakan perkhidmatan ini.';

  @override
  String get permissionMicTitle => 'Mikrofon (diperlukan)';

  @override
  String get permissionMicDesc =>
      'Diperlukan untuk bercakap dengan AI dalam bahasa Inggeris.';

  @override
  String get permissionNotifTitle => 'Pemberitahuan (pilihan)';

  @override
  String get permissionNotifDesc =>
      'Kami akan menghantar peringatan pembelajaran dan jadual panggilan.';

  @override
  String get micPermissionNeededTitle => 'Akses mikrofon diperlukan';

  @override
  String get micPermissionNeededBody =>
      'Untuk bercakap dengan AI, anda perlu membenarkan akses mikrofon. Sila aktifkannya dalam Tetapan.';

  @override
  String get openSettings => 'Buka Tetapan';

  @override
  String get connectionFailedTitle => 'Sambungan gagal';

  @override
  String get connectionFailedBody =>
      'Semak sambungan rangkaian anda\ndan cuba lagi.';

  @override
  String get checkout => 'Pembayaran';

  @override
  String get pay => 'Bayar';

  @override
  String get orderSummary => 'Ringkasan Pesanan';

  @override
  String get paymentMethod => 'Kaedah Pembayaran';

  @override
  String get payMethodCard => 'Kad Kredit / Debit';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Beaver yang Menjengkelkan';

  @override
  String get productTrait => 'Watak premium · Milik anda selamanya';

  @override
  String get amountItemPrice => 'Harga barang';

  @override
  String get amountDiscount => 'Diskaun';

  @override
  String get amountTotal => 'Jumlah';

  @override
  String get paymentCompleteTitle => 'Pembayaran selesai';

  @override
  String get paymentCompleteBody => 'Avatar telah ditambah ke koleksi anda.';

  @override
  String get viewCollection => 'Lihat Koleksi';

  @override
  String get receiptItem => 'Barang';

  @override
  String get receiptAmount => 'Jumlah';

  @override
  String get receiptMethod => 'Kaedah pembayaran';

  @override
  String get receiptDate => 'Tarikh';

  @override
  String get paymentFailedTitle => 'Pembayaran gagal';

  @override
  String get paymentFailedBody =>
      'Pembayaran anda tidak dapat diproses.\nSila cuba lagi.';

  @override
  String get freeCallEndingTitle => 'Panggilan percuma anda akan tamat';

  @override
  String get freeCallEndingBody =>
      'Langgan untuk bercakap dengan Beaver lebih lama.';

  @override
  String get subscribe => 'Langgan';

  @override
  String get endCall => 'Tamatkan Panggilan';

  @override
  String get callEnded => 'Panggilan telah tamat.';

  @override
  String get connecting => 'Menyambung…';

  @override
  String get connectingHint =>
      'Ini biasanya mengambil masa kurang daripada 5 saat';

  @override
  String get callConnectFailed => 'Tidak dapat menyambungkan panggilan.';

  @override
  String get saveSentenceFailed => 'Tidak dapat menyimpan ayat.';

  @override
  String get recordStartFailed => 'Tidak dapat memulakan rakaman.';

  @override
  String get recordTooShort => 'Rakaman itu terlalu pendek. Sila cuba lagi.';

  @override
  String get gradingFailed => 'Pemarkahan gagal. Sila cuba lagi.';

  @override
  String get listenStandard => 'Dengar sebutan piawai';

  @override
  String get saveSentence => 'Simpan ayat';

  @override
  String get unsaveSentence => 'Buang ayat tersimpan';

  @override
  String get scoringPronunciation => 'Menilai sebutan anda…';

  @override
  String get analyzingByWord =>
      'Menyemak sebutan anda perkataan demi perkataan';

  @override
  String get analyzingTakingLonger => 'Ini mengambil masa sedikit lebih lama';

  @override
  String get scanConnectionLost => 'Sambungan terputus';

  @override
  String get noRecordingToPlay => 'Tiada rakaman untuk dimainkan.';

  @override
  String get myRecordingPlayError => 'Tidak dapat memainkan rakaman anda.';

  @override
  String get next => 'Seterusnya';

  @override
  String get endLearning => 'Tamatkan Sesi';

  @override
  String get navCalendar => 'Kalendar';

  @override
  String get navCall => 'Panggilan';

  @override
  String get navStats => 'Statistik';

  @override
  String get myPage => 'Halaman Saya';

  @override
  String get languageSaveFailed => 'Tidak dapat menyimpan bahasa anda.';

  @override
  String get accountDeleteFailed => 'Tidak dapat memadam akaun anda.';

  @override
  String get changeAvatar => 'Tukar Avatar';

  @override
  String get avatarIntro =>
      'Suara dan tahap kesukaran berbeza mengikut rakan panggilan.\nSesetengah rakan mungkin memerlukan pembayaran.';

  @override
  String myPartnersOwned(int count) {
    return 'Rakan Saya · $count dimiliki';
  }

  @override
  String get limitedDiscount => 'Diskaun masa terhad';

  @override
  String get available => 'Tersedia';

  @override
  String get inUse => 'Sedang digunakan';

  @override
  String get owned => 'Dimiliki';

  @override
  String get noCharactersToShow => 'Tiada watak untuk dipaparkan';

  @override
  String get buy => 'Beli';

  @override
  String get noSavedSentences =>
      'Belum ada ayat tersimpan.\nTanda buku ayat daripada rekod perbualan anda.';

  @override
  String get noAlarms => 'Belum ada penggera';

  @override
  String get noAlarmsBody =>
      'Tambah peringatan pembelajaran\nuntuk membina tabiat yang konsisten.';

  @override
  String get subscriptionManage => 'Urus Langganan';

  @override
  String get changePlan => 'Tukar Pelan';

  @override
  String get cancelSubscription => 'Batal Langganan';

  @override
  String get benefitsInUse => 'Faedah anda';

  @override
  String get paymentInfo => 'Maklumat pembayaran';

  @override
  String get nextBillingDate => 'Tarikh bil seterusnya';

  @override
  String get lostBenefitsTitle =>
      'Faedah yang akan hilang jika anda membatalkan';

  @override
  String get viewBillingHistory => 'Lihat Sejarah Bil';

  @override
  String get keepUsingPro => 'Terus Guna Pro';

  @override
  String get proMembership => 'Keahlian Pro';

  @override
  String pricePerMonth(String price) {
    return '$price / bulan';
  }

  @override
  String get benefitUnlimitedCalls => 'Panggilan tanpa had';

  @override
  String get benefitDetailedAnalysis =>
      'Analisis sebutan & tatabahasa yang terperinci';

  @override
  String get benefitAllCharacters => 'Akses kepada semua watak';

  @override
  String get benefitNoAds => 'Tiada iklan';

  @override
  String get playSampleVoice => 'Mainkan sampel suara';

  @override
  String get useThisAvatar => 'Guna Ini';

  @override
  String get challengeTitle => 'Cabaran Sebutan';

  @override
  String get challengeIntro =>
      'Sebut setiap kad dalam zon dengan betul dalam bahasa Korea untuk melepasinya.\nTiada mikrofon? Anda juga boleh bermain dengan mengetik skrin.';

  @override
  String get challengeStart => 'Mulakan Kamera & Mikrofon';

  @override
  String get challengePermissionNote =>
      'Akses kamera depan dan mikrofon diperlukan (pilihan).';

  @override
  String get challengeLoadingTitle => 'Memuatkan…';

  @override
  String get challengeLoadingNote =>
      'Memuat turun model pertuturan Korea (~82MB) pada larian pertama.\nSila tunggu sebentar.';

  @override
  String get challengeSttFallback =>
      'Pengecaman suara tidak tersedia, jadi anda bermain dengan input ketik.';

  @override
  String get reasonTravelTitle => 'Bertutur semasa mengembara';

  @override
  String get reasonTravelDesc =>
      'Berbual dengan yakin bersama penduduk tempatan';

  @override
  String get reasonCareerTitle => 'Kerja & kerjaya';

  @override
  String get reasonCareerDesc => 'Perbualan perniagaan';

  @override
  String get reasonExamTitle => 'Persediaan ujian';

  @override
  String get reasonExamDesc => 'Bersedia untuk ujian pertuturan';

  @override
  String get reasonDailyTitle => 'Perbualan harian';

  @override
  String get reasonDailyDesc => 'Ungkapan yang anda gunakan setiap hari';

  @override
  String get reasonFriendsTitle => 'Berkawan dengan rakan asing';

  @override
  String get reasonFriendsDesc => 'Perbualan semula jadi';

  @override
  String get reasonBrainTitle => 'Rangsangan otak';

  @override
  String get reasonBrainDesc => 'Tingkatkan ingatan & fokus';

  @override
  String get challengeRecordToggle => 'Rakam sesi ini';

  @override
  String get challengeRecordHint =>
      'Menyimpan video permainan anda untuk dikongsi (tanpa bunyi).';

  @override
  String get settingsSection => 'Tetapan';

  @override
  String get paymentSection => 'Pembayaran';

  @override
  String get supportSection => 'Sokongan';

  @override
  String get userLanguage => 'Bahasa Pengguna';

  @override
  String get learningLanguage => 'Bahasa Pembelajaran';

  @override
  String get learningLanguageKorean => 'Bahasa Korea';

  @override
  String get notificationLabel => 'Pemberitahuan';

  @override
  String get currentPlan => 'Pelan Semasa';

  @override
  String get paymentHistory => 'Sejarah Pembayaran';

  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get termsOfService => 'Terma perkhidmatan';

  @override
  String get privacyPolicy => 'Dasar privasi';

  @override
  String get logOut => 'Log keluar';

  @override
  String get deleteAccount => 'Padam akaun';

  @override
  String get deleteAccountTitle => 'Padam akaun?';

  @override
  String get deleteAccountBody =>
      'Ini akan memadam akaun dan data anda secara kekal dan tidak boleh dibuat asal.';

  @override
  String get delete => 'Padam';

  @override
  String get share => 'Kongsi';

  @override
  String get accentSoundsLike => 'Loghat Korea anda kedengaran';

  @override
  String get hintLabel => 'Petunjuk';

  @override
  String get nextHint => 'Petunjuk seterusnya';

  @override
  String get translateLabel => 'Terjemah';

  @override
  String get startRecording => 'Mula rakam';

  @override
  String get stopRecording => 'Henti rakam';

  @override
  String get back => 'Kembali';

  @override
  String get onboardingNameTitle => 'Apa yang perlu kami panggil anda?';

  @override
  String get onboardingNameSubtitle =>
      'Tutor AI anda akan mengingati nama anda.';

  @override
  String get nameLabel => 'Nama anda';

  @override
  String get nameHint => 'Masukkan nama anda';

  @override
  String get nameHelper =>
      'Tidak semestinya nama sebenar anda — nama panggilan juga boleh.';

  @override
  String get continueLabel => 'Teruskan';

  @override
  String get onboardingDoneTitle => 'Beaver sedang menunggu panggilan anda';

  @override
  String get onboardingDoneSubtitle => 'Mulakan panggilan sekarang';

  @override
  String get home => 'Laman Utama';

  @override
  String get callNow => 'Panggil sekarang';

  @override
  String get pronunciation => 'Sebutan';

  @override
  String get fluency => 'Kelancaran';

  @override
  String get rhythm => 'Irama';

  @override
  String get analysisTimeout =>
      'Ini mengambil masa lebih lama daripada dijangka. Sila cuba lagi sebentar lagi.';

  @override
  String get analysisFailed =>
      'Kami tidak dapat menganalisis perbualan tersebut. Sila cuba lagi.';

  @override
  String get analyzingConversation => 'Menganalisis perbualan anda…';

  @override
  String get analyzingSubtitle => 'Ini hanya mengambil masa sebentar';

  @override
  String get tryAgain => 'Cuba lagi';

  @override
  String get nativeLabel => 'Penutur asli';

  @override
  String get meLabel => 'Saya';

  @override
  String get pronunciationPlayError => 'Tidak dapat memainkan audio sebutan.';

  @override
  String get savedExpressionsLoadError =>
      'Tidak dapat memuatkan ungkapan tersimpan anda.';

  @override
  String get mySavedExpressions => 'Ungkapan Tersimpan Saya';

  @override
  String get avatarTraits => 'Mesra · Tenang · Lembut';

  @override
  String get priceFree => 'Percuma';

  @override
  String get loginGoogleTokenError =>
      'Tidak dapat memperoleh token log masuk Google.';

  @override
  String get loginGoogleSignInFailed => 'Log masuk Google gagal.';

  @override
  String get loginAppleSignInFailed => 'Log masuk Apple gagal.';

  @override
  String get loginFacebookSignInFailed => 'Log masuk Facebook gagal.';

  @override
  String get loginKakaoSignInFailed => 'Log masuk Kakao gagal.';

  @override
  String get loginContinueWithKakao => 'Teruskan dengan Kakao';

  @override
  String get loginContinueWithGoogle => 'Teruskan dengan Google';

  @override
  String get loginContinueWithFacebook => 'Teruskan dengan Facebook';

  @override
  String get loginContinueWithApple => 'Teruskan dengan Apple';

  @override
  String get loginContinueWithEmail => 'Teruskan dengan e-mel';

  @override
  String get loginOrDivider => 'atau';

  @override
  String get loginNoAccount => 'Tiada akaun?';

  @override
  String get signUp => 'Daftar';

  @override
  String get loginTermsNoticePrefix =>
      'Dengan meneruskan, anda bersetuju dengan ';

  @override
  String get loginTermsNoticeAnd => ' dan ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Log masuk';

  @override
  String get fieldEmailLabel => 'E-mel';

  @override
  String get emailHint => 'Masukkan e-mel anda';

  @override
  String get fieldPasswordLabel => 'Kata laluan';

  @override
  String get passwordHint => 'Masukkan kata laluan anda';

  @override
  String get loginRememberMe => 'Ingat saya';

  @override
  String get loginForgotPassword => 'Lupa kata laluan?';

  @override
  String get loginLoggingIn => 'Sedang log masuk...';

  @override
  String get passwordLengthError => 'Kata laluan mesti 8–16 aksara.';

  @override
  String get passwordsDoNotMatch => 'Kata laluan tidak sepadan.';

  @override
  String get signupCheckInput => 'Sila semak input anda.';

  @override
  String get fieldConfirmPasswordLabel => 'Sahkan kata laluan';

  @override
  String get confirmPasswordHint => 'Masukkan semula kata laluan anda';

  @override
  String get signupSigningUp => 'Sedang mendaftar...';

  @override
  String get signupHaveAccount => 'Sudah mempunyai akaun?';

  @override
  String get passwordMethodEmailRequired => 'Masukkan e-mel anda';

  @override
  String get passwordResetTitle => 'Set semula kata laluan';

  @override
  String get passwordMethodDescription =>
      'Masukkan alamat e-mel yang anda ingin gunakan untuk menerima kod set semula kata laluan.';

  @override
  String get emailAddressHint => 'Alamat e-mel';

  @override
  String get passwordMethodSending => 'Menghantar...';

  @override
  String get passwordMethodSendEmail => 'Hantar e-mel';

  @override
  String get passwordCodeTitle => 'Masukkan kod';

  @override
  String get passwordCodeDescription =>
      'Kami telah menghantar kod pemulihan ke e-mel anda. Masukkannya untuk meneruskan.';

  @override
  String get passwordCodeNoCode => 'Tidak menerima kod?';

  @override
  String get passwordCodeResend => 'Hantar semula kod';

  @override
  String get passwordCodeVerifying => 'Mengesahkan...';

  @override
  String get passwordNewTitle => 'Kata laluan baharu';

  @override
  String get passwordNewDescription =>
      'Tetapkan kata laluan baharu untuk akaun anda.';

  @override
  String get fieldNewPasswordLabel => 'Kata laluan baharu';

  @override
  String get newPasswordHint => 'Masukkan kata laluan baharu anda';

  @override
  String get fieldConfirmNewPasswordLabel => 'Sahkan kata laluan baharu';

  @override
  String get confirmNewPasswordHint =>
      'Masukkan semula kata laluan baharu anda';

  @override
  String get passwordNewSubmitting => 'Menghantar...';

  @override
  String get passwordNewSubmit => 'Hantar';

  @override
  String get passwordCompleteTitle => 'Set semula kata laluan selesai';

  @override
  String get passwordCompleteBody =>
      'Kata laluan anda telah ditetapkan semula. Log masuk dengan kata laluan baharu anda untuk meneruskan.';

  @override
  String get termsTitle => 'Terma perkhidmatan';

  @override
  String get privacyTitle => 'Dasar privasi';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Tetapkan kata laluan baharu untuk $email.';
  }

  @override
  String get selectComplete => 'Selesai';

  @override
  String get onboardingLanguageTitle => 'Apakah bahasa ibunda anda?';

  @override
  String get onboardingReasonTitle => 'Mengapa anda belajar bahasa?';

  @override
  String get onboardingReasonSubtitle =>
      'Kami akan menyesuaikan pembelajaran anda mengikut matlamat anda.';

  @override
  String get savingLabel => 'Menyimpan...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Pembayaran bulan ini';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterSubscription => 'Langganan';

  @override
  String get filterCharacter => 'Watak';

  @override
  String get statusCompleted => 'Selesai';

  @override
  String get lastPayment => 'Pembayaran terakhir';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Anda boleh terus menggunakan manfaat Pro sehingga $date, selepas itu pelan anda bertukar ke Percuma secara automatik.';
  }

  @override
  String get freePlanCallLimit => '1 panggilan sehari · had 5 minit';

  @override
  String get freePlanBasicCharacters => 'Watak asas disertakan';

  @override
  String get availableForPurchase => 'Boleh dibeli';

  @override
  String get paymentsLoadError => 'Gagal memuatkan sejarah pembayaran';

  @override
  String get noPayments => 'Belum ada pembayaran';

  @override
  String get morePaymentsExist => 'Pembayaran lama belum dipaparkan';

  @override
  String get undatedPayments => 'Tiada tarikh';

  @override
  String get paymentLabelFallback => 'Pembayaran';

  @override
  String learningPassed(int passed, int total) {
    return '$passed daripada $total ayat lulus';
  }

  @override
  String get hardestSound => 'Bunyi paling sukar hari ini';

  @override
  String get soundAccuracy => 'Ketepatan mengikut bunyi';

  @override
  String phonemeAttempts(int count) {
    return 'Setiap fonem · $count percubaan';
  }

  @override
  String get colSound => 'Bunyi';

  @override
  String get colAttempts => 'Cuba';

  @override
  String get colCorrect => 'Betul';

  @override
  String get colAccuracy => 'Tepat';

  @override
  String get sentenceResults => 'Keputusan mengikut ayat';

  @override
  String viewAllSentences(int count) {
    return 'Lihat semua $count';
  }

  @override
  String get colSentence => 'Ayat';

  @override
  String get colPronunciation => 'Sebut.';

  @override
  String get colFluency => 'Lancar';

  @override
  String get colRhythm => 'Rentak';

  @override
  String recentSessions(int count) {
    return '$count sesi terakhir';
  }

  @override
  String trendAverage(int score) {
    return 'Purata $score';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get colDate => 'Tarikh';

  @override
  String get colSentences => 'Ayat';

  @override
  String get colScore => 'Skor';

  @override
  String get colChange => 'Ubah';

  @override
  String dateToday(String date) {
    return '$date (hari ini)';
  }

  @override
  String get accentAnalysis => 'Analisis loghat';

  @override
  String get overallLevel => 'Tahap keseluruhan';

  @override
  String get overallLevelSubtitle => 'Kosa kata · Tatabahasa · Ungkapan';

  @override
  String get pronunciationAnalysis => 'Analisis sebutan';

  @override
  String get recentSessionsAverage => 'Purata 10 sesi';

  @override
  String levelStage(int stage) {
    return 'Tahap $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Antara semua pelajar';

  @override
  String aheadOfLearners(int percent) {
    return 'Anda mendahului $percent% pelajar';
  }

  @override
  String get retakeLevelTest => 'Ulang ujian tahap';

  @override
  String get practicePronunciation => 'Latih sebutan';

  @override
  String get priceChangedTitle => 'Harga berubah';

  @override
  String priceChangedBody(String price) {
    return 'Item ini kini $price. Teruskan?';
  }

  @override
  String get billingGroupPlanPurchases => 'Pelan & pembelian';

  @override
  String get billingGroupInTheStore => 'Di kedai';

  @override
  String get billingChangePlan => 'Tukar pelan';

  @override
  String get billingCompareAllPlans => 'Bandingkan semua pelan';

  @override
  String get billingBuyACharacter => 'Beli watak';

  @override
  String get billingRestorePurchases => 'Pulihkan pembelian';

  @override
  String get billingPaymentHistory => 'Sejarah pembayaran';

  @override
  String get billingManageInTheStore => 'Urus di kedai';

  @override
  String get billingRefundHelp => 'Bantuan bayaran balik';

  @override
  String get billingCancelSubscription => 'Batal langganan';

  @override
  String get billingResubscribe => 'Langgan semula';

  @override
  String get badgeCurrent => 'Semasa';

  @override
  String get badgeTrial => 'Percubaan';

  @override
  String get badgeRenewing => 'Diperbaharui';

  @override
  String get badgePastDue => 'Tertunggak';

  @override
  String get badgePaused => 'Dijeda';

  @override
  String get badgeCanceling => 'Dibatalkan';

  @override
  String get subscriptionTitle => 'Langganan';

  @override
  String get plansTitle => 'Pelan';

  @override
  String get planFree => 'Percuma';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Percubaan Max';

  @override
  String get freePlanPriceLine => '\$0.00 — satu panggilan sehari';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount sebulan';
  }

  @override
  String freeUntilDate(String date) {
    return 'Percuma sehingga $date';
  }

  @override
  String get todaysCalls => 'Panggilan hari ini';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used daripada $limit digunakan';
  }

  @override
  String get firstPaymentLabel => 'Pembayaran pertama';

  @override
  String get nextPaymentLabel => 'Pembayaran seterusnya';

  @override
  String get retryingUntilLabel => 'Dicuba semula sehingga';

  @override
  String get pausedSinceLabel => 'Dijeda sejak';

  @override
  String planEndsLabel(String plan) {
    return '$plan tamat';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Tanpa had dengan Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Panggilan tanpa had · 15 minit setiap satu · $price sebulan';
  }

  @override
  String get bannerMaxUpsellTitle => 'Hidupkan video dengan Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Panggilan bersemuka · $price sebulan';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Tukar ke tahunan';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly setahun · $perMonth sebulan';
  }

  @override
  String get bannerPaymentFailedTitle => 'Pembayaran anda tidak berjaya';

  @override
  String get bannerPaymentFailedSub =>
      'Kemas kini pembayaran di kedai untuk kekalkan Pro';

  @override
  String get bannerPausedTitle => 'Pelan anda dijeda';

  @override
  String get bannerPausedSub => 'Pembayaran tidak pernah berjaya';

  @override
  String get noteRestoreHint =>
      'Sudah melanggan di peranti lain? Pulihkan untuk mengaktifkannya di peranti ini.';

  @override
  String get noteStoreHandled =>
      'Kaedah pembayaran, penukaran pelan dan pembatalan dikendalikan oleh kedai.';

  @override
  String get noteFairUse =>
      'Penggunaan tanpa had tertakluk kepada dasar penggunaan wajar kami.';

  @override
  String noteTrialEnds(String date) {
    return 'Percubaan anda tamat $date. Batal di kedai sebelum itu dan tiada caj dikenakan.';
  }

  @override
  String get noteGrace =>
      'Manfaat terus berjalan sepanjang tempoh tangguh. Pembatalan tidak pernah disekat dalam aplikasi.';

  @override
  String get noteHold =>
      'Pro dijeda sehingga pembayaran berjaya. Watak dan kemajuan anda selamat.';

  @override
  String noteEnding(String date) {
    return 'Pelan anda akan tamat. Manfaat berjalan sehingga $date, kemudian anda beralih ke Percuma. Anda boleh melanggan semula bila-bila masa.';
  }

  @override
  String get trialExpiredTitle => 'Percubaan Max anda telah tamat';

  @override
  String get trialExpiredSub => 'Anda kini di pelan Percuma';

  @override
  String get seePlans => 'Lihat pelan';

  @override
  String get currentPlanTitle => 'Pelan Semasa';

  @override
  String get badgeRecommended => 'Disyorkan';

  @override
  String get perMonthUnit => 'sebulan';

  @override
  String get planTaglinePro => 'Panggilan tanpa had. 15 minit setiap satu.';

  @override
  String get planTaglineMax => 'Kini anda boleh melihat mereka.';

  @override
  String get planTaglineFree => 'Satu panggilan sehari. Percuma.';

  @override
  String get bulletProCalls => 'Panggilan suara sekerap yang anda mahu';

  @override
  String get bulletProLength => '15 minit setiap panggilan';

  @override
  String get bulletProScoring => 'Sebutan dinilai huruf demi huruf';

  @override
  String get bulletProCorrections =>
      'Pembetulan disesuaikan dengan bahasa ibunda anda';

  @override
  String get bulletProBeaverCalls => 'Beaver menelefon anda dahulu';

  @override
  String get bulletMaxVideo => 'Panggilan video bersemuka';

  @override
  String get bulletMaxEverything => 'Semua yang ada dalam Pro';

  @override
  String get bulletMaxCharacters => 'Semua watak, tanpa had';

  @override
  String get bulletMaxStudyBook => 'Buku pembelajaran mengikut tahap anda';

  @override
  String get bulletMaxWeeklyReport =>
      'Laporan mingguan tentang perkembangan sebutan anda';

  @override
  String get bulletFreeCall => 'Satu panggilan suara 5 minit sehari';

  @override
  String get bulletFreeCheck => 'Satu semakan sebutan sehari';

  @override
  String get bulletFreeAccent => 'Semakan loghat tanpa had';

  @override
  String get bulletFreeCharacter => 'Satu watak untuk bermula';

  @override
  String get ctaGoUnlimited => 'Jadi tanpa had';

  @override
  String get ctaTurnOnVideo => 'Hidupkan video';

  @override
  String get noteCallLength => 'Setiap panggilan berdurasi 15 minit.';

  @override
  String get paywallProTitle1 => 'Kawan Korea anda';

  @override
  String get paywallProTitle2 => 'yang berjaga jam 3 pagi';

  @override
  String get paywallProSub =>
      'Panggilan tanpa had. 15 minit setiap satu. Sepanjang tahun.';

  @override
  String get paywallLimitHeadline => 'Pro menghapuskan had itu.';

  @override
  String get limitBannerCallTitle => 'Itu panggilan hari ini';

  @override
  String get limitBannerCallSub => 'Percuma memberi satu panggilan sehari';

  @override
  String get limitBannerCheckTitle => 'Itu semakan hari ini';

  @override
  String get limitBannerCheckSub => 'Percuma memberi satu semakan sehari';

  @override
  String get bulletProCharactersForever =>
      'Watak yang anda beli kekal milik anda selamanya';

  @override
  String get paywallMaxTitle => 'Kini anda boleh melihat mereka.';

  @override
  String get paywallMaxSub =>
      'Panggilan video, semua watak, dan buku pembelajaran yang dibuat mengikut tahap anda.';

  @override
  String get planMonthly => 'Bulanan';

  @override
  String get planAnnual => 'Tahunan';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price sebulan';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth sebulan';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price sebulan';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly setahun · $perMonth sebulan';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price sebulan · batal bila-bila masa di kedai';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price sebulan · batal bila-bila masa di kedai';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 hari percuma, kemudian $price sebulan · batal bila-bila masa di kedai';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'Diperbaharui secara automatik sehingga dibatalkan.';

  @override
  String get footerTerms => 'Terma';

  @override
  String get footerPrivacy => 'Privasi';

  @override
  String get noteMaxCharacters =>
      'Watak yang dibuka oleh Max tersedia selagi langganan anda aktif. Watak yang anda beli kekal milik anda.';

  @override
  String get processingTitle => 'Mengesahkan pembelian anda';

  @override
  String get processingSub => 'Ini biasanya mengambil beberapa saat.';

  @override
  String get successProTitle => 'Anda kini di Pro.';

  @override
  String get successProSub => 'Panggilan tanpa had, bermula sekarang.';

  @override
  String get successProBenefit1 =>
      'Telefon sekerap yang anda mahu — 15 minit setiap panggilan';

  @override
  String get successProBenefit2 => 'Semakan sebutan tanpa had';

  @override
  String get successProBenefit3 => 'Semua watak, serta pembelian sekali beli';

  @override
  String get successMaxTitle => 'Anda boleh melihat mereka sekarang.';

  @override
  String get successMaxSub =>
      'Panggilan video telah aktif. Ketik butang video dalam mana-mana panggilan.';

  @override
  String get successMaxBenefit1 => 'Panggilan video bersemuka';

  @override
  String get successMaxBenefit2 =>
      'Semua watak, tanpa had dan yang baharu dahulu';

  @override
  String get successMaxBenefit3 => 'Buku pembelajaran mengikut tahap anda';

  @override
  String get ctaStartACall => 'Mulakan panggilan';

  @override
  String get ctaStartAVideoCall => 'Mulakan panggilan video';

  @override
  String get ctaSeeYourSubscription => 'Lihat langganan anda';

  @override
  String successProCaption(String price) {
    return '$price dicaj setiap bulan sehingga anda batalkan. Urus atau batal bila-bila masa di kedai.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price dicaj setiap bulan sehingga anda batalkan. Urus atau batal bila-bila masa di kedai.';
  }

  @override
  String get plansErrorTitle => 'Tidak dapat memuatkan pelan';

  @override
  String get plansErrorSub => 'Kedai tidak memberi respons.';

  @override
  String get ctaTryAgain => 'Cuba lagi';

  @override
  String get plansErrorCaption => 'Tiada caj dikenakan.';

  @override
  String get changePlanTitle => 'Tukar Pelan';

  @override
  String get moveToMaxTitle => 'Beralih ke Max';

  @override
  String maxPriceShort(String price) {
    return '$price / bulan';
  }

  @override
  String get moveToMaxCardSub =>
      'Panggilan video bersemuka · semua watak · buku pembelajaran khas untuk anda';

  @override
  String get whatHappensNow => 'Apa yang berlaku sekarang';

  @override
  String get maxStartsLabel => 'Max bermula';

  @override
  String get immediately => 'Serta-merta';

  @override
  String get unusedProTime => 'Baki masa Pro';

  @override
  String get creditedTowardMax => 'Dikreditkan kepada Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Tukar ke Max';

  @override
  String get upgradeCaption =>
      'Pelan baharu anda bermula serta-merta. Baki masa Pro dikreditkan, tidak sekali-kali dicaj dua kali.';

  @override
  String get moveToProTitle => 'Beralih ke Pro';

  @override
  String get moveToProSub =>
      'Tiada apa yang berubah hari ini. Max berjalan hingga akhir bulan yang telah anda bayar.';

  @override
  String get maxRunsUntil => 'Max berjalan sehingga';

  @override
  String get proStarts => 'Pro bermula';

  @override
  String get whatYouKeep => 'Apa yang anda kekalkan';

  @override
  String get keepBenefitCalls =>
      'Panggilan suara tanpa had, 15 minit setiap satu';

  @override
  String get keepBenefitCharacters =>
      'Watak yang anda beli kekal milik anda selamanya';

  @override
  String downgradeWarning(String date) {
    return 'Panggilan video dan watak khas Max dimatikan pada $date.';
  }

  @override
  String get ctaSwitchToPro => 'Tukar ke Pro';

  @override
  String get ctaKeepMax => 'Kekalkan Max';

  @override
  String get winbackSkip => 'Langkau';

  @override
  String get winbackTitle => 'Pelan Pro anda telah tamat';

  @override
  String get winbackSub => 'Anda kini di Percuma — satu panggilan sehari.';

  @override
  String get winbackQuestion => 'Boleh beritahu kami sebab anda berhenti?';

  @override
  String get winbackReasonExpensive => 'Terlalu mahal';

  @override
  String get winbackReasonUnused => 'Saya tidak cukup menggunakannya';

  @override
  String get winbackReasonMissing => 'Tiada ciri yang saya perlukan';

  @override
  String get winbackReasonOtherApp => 'Saya jumpa aplikasi lain';

  @override
  String get winbackReasonElse => 'Sebab lain';

  @override
  String get ctaSend => 'Hantar';

  @override
  String get ctaNotNow => 'Bukan sekarang';

  @override
  String get winbackCaption =>
      'Ini tidak memulihkan pelan anda. Langgan semula di kedai.';

  @override
  String get ctaContinue => 'Teruskan';

  @override
  String get ctaClose => 'Tutup';

  @override
  String get ovRestoreSuccessTitle => 'Pro kembali';

  @override
  String get ovRestoreSuccessBody =>
      'Kami menemui langganan anda dan mengaktifkannya semula untuk peranti ini.';

  @override
  String get ovRestoreEmptyTitle => 'Tiada apa untuk dipulihkan';

  @override
  String get ovRestoreEmptyBody =>
      'Tiada langganan aktif dipautkan ke akaun kedai ini.';

  @override
  String get ovRestoreOtherTitle => 'Pelan itu milik akaun lain';

  @override
  String get ovRestoreOtherBody =>
      'Langganan ini sudah aktif pada akaun BeaverTalk yang berbeza.';

  @override
  String get ctaSignInThatAccount => 'Log masuk ke akaun itu';

  @override
  String get ctaGetHelp => 'Dapatkan bantuan';

  @override
  String get ovCharacterOfferTitle => 'Belum bersedia untuk Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Pilih satu watak dan miliki selamanya. Pembelian sekali sahaja — tiada langganan, tiada pembaharuan.';

  @override
  String get rowOneCharacter => 'Satu watak';

  @override
  String rowFromPrice(String price) {
    return 'dari $price';
  }

  @override
  String get rowYoursForever => 'Milik anda selamanya';

  @override
  String get rowNoRenewal => 'Tiada pembaharuan';

  @override
  String get rowWorksOnFree => 'Berfungsi di Percuma';

  @override
  String get rowYes => 'Ya';

  @override
  String get ctaSeeCharacters => 'Lihat watak';

  @override
  String get ovNotEligibleTitle => 'Tiada apa untuk dibatalkan';

  @override
  String get ovNotEligibleBody =>
      'Anda di pelan Percuma. Tiada langganan aktif pada akaun ini.';

  @override
  String get ovCancelDownsellTitle => 'Sebelum anda pergi';

  @override
  String get ovCancelDownsellBody =>
      'Pembatalan dibuat di kedai. Dua perkara yang patut anda tahu.';

  @override
  String get rowPayYearlyInstead => 'Bayar tahunan sahaja';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price sebulan';
  }

  @override
  String get rowCharactersYouBought => 'Watak yang anda beli';

  @override
  String get rowProRunsUntil => 'Pro berjalan sehingga';

  @override
  String get ctaSwitchToYearly => 'Tukar ke tahunan';

  @override
  String get ctaContinueToStore => 'Teruskan ke kedai';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Bayar tahunan, jimat $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Anda sudah dua bulan di Pro. Pelan tahunan lebih murah kiraannya.';

  @override
  String get rowYouSave => 'Anda jimat';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Tahunan';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Bulanan, selama setahun';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Tukar ke bulanan';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Pelan tahunan anda berjalan sehingga $date. Bil bulanan bermula sehari selepas itu.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Bil bulanan bermula';

  @override
  String get rowMonthlyLabel => 'Bulanan';

  @override
  String get rowYearlyWorkedOut => 'Tahunan bersamaan';

  @override
  String get ctaSwitchToMonthly => 'Tukar ke bulanan';

  @override
  String get ovRefundHelpTitle => 'Bayaran balik dikendalikan oleh kedai';

  @override
  String get ovRefundHelpBody =>
      'Kami tidak dapat membuat bayaran balik sendiri. Setiap permintaan disemak oleh kedai.';

  @override
  String get ctaGoToStore => 'Pergi ke kedai';

  @override
  String get ovTrialEndingTitle => 'Percubaan anda tamat esok';

  @override
  String get ovTrialEndingBody =>
      'Max terus berjalan melainkan anda batalkan. Ini yang akan berlaku.';

  @override
  String get rowTrialEnds => 'Percubaan tamat';

  @override
  String get rowFirstCharge => 'Caj pertama';

  @override
  String get rowThenMonthly => 'Kemudian setiap bulan';

  @override
  String get ctaCancelInStore => 'Batal di kedai';

  @override
  String get ovTrialStartTitle => '7 hari Max, percuma';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Percuma sehingga $date. Kemudian $price sebulan, melainkan anda batalkan di kedai.';
  }

  @override
  String get ctaStart7Days => 'Mula 7 hari percuma';

  @override
  String get ovOtoTitle => 'Satu perkara lagi sebelum anda mula';

  @override
  String get ovOtoBody =>
      'Pilihan bijak — panggilan tanpa had kini aktif. Pro yang sama lebih murah jika bayar tahunan.';

  @override
  String get ovFailedDeclinedTitle => 'Kad anda ditolak';

  @override
  String get ovFailedDeclinedBody =>
      'Kedai tidak dapat memproses pembayaran. Tiada caj dikenakan.';

  @override
  String get ctaUpdatePaymentMethod => 'Kemas kini kaedah pembayaran';

  @override
  String get ovFailedCanceledTitle => 'Pembayaran dibatalkan';

  @override
  String get ovFailedCanceledBody =>
      'Anda masih di Percuma. Tiada caj dikenakan.';

  @override
  String get ovFailedStoreTitle => 'Ada masalah berlaku';

  @override
  String get ovFailedStoreBody =>
      'Kami tidak dapat menghubungi kedai. Tiada caj dikenakan.';

  @override
  String get ovAlreadyTitle => 'Anda sudah di Pro';

  @override
  String get ovAlreadyBody =>
      'Akaun kedai ini mempunyai pelan aktif. Tiada apa yang perlu dibeli.';

  @override
  String get ctaSeeMySubscription => 'Lihat langganan saya';

  @override
  String get subCancelTitle => 'Batal langganan';

  @override
  String subCancelBody(String date) {
    return 'Pro berjalan sehingga $date. Selepas itu anda beralih ke Percuma.';
  }

  @override
  String get subWhatYouLose => 'Apa yang anda hilang';

  @override
  String get benefitCalls15 => 'Panggilan tanpa had, 15 minit setiap satu';

  @override
  String get benefitScoring => 'Sebutan dinilai huruf demi huruf';

  @override
  String get benefitEveryCharacter => 'Semua watak, tanpa had';

  @override
  String get ctaKeepPro => 'Kekalkan Pro';

  @override
  String get subPaymentTitle => 'Kemas kini pembayaran';

  @override
  String get subPaymentBody =>
      'Kami tidak dapat memproses pembayaran. Pro terus berjalan sepanjang tempoh tangguh.';

  @override
  String get subHowToFix => 'Cara membetulkannya';

  @override
  String get fixStep1 => 'Buka kedai dan kemas kini kaedah pembayaran anda';

  @override
  String get fixStep2 =>
      'Kembali semula — pelan anda disambung secara automatik';

  @override
  String get fixStep3 => 'Tiada caj dikenakan dua kali';

  @override
  String get subResubTitle => 'Langgan semula';

  @override
  String subResubBody(String date) {
    return 'Pro tamat pada $date. Hidupkan semula pembaharuan automatik dan tiada apa yang berubah.';
  }

  @override
  String get subWhatYouKeep => 'Apa yang anda kekalkan';

  @override
  String get ctaTurnItBackOn => 'Hidupkan semula';

  @override
  String get flTodayTitle => 'Itu panggilan hari ini';

  @override
  String get flTodayBody =>
      'Sambung dari tempat anda berhenti — sekarang juga.';

  @override
  String get flCheckTitle => 'Itu semakan hari ini';

  @override
  String get flCheckBody =>
      'Satu semakan sehari di Percuma. Pro menjadikannya tanpa had.';

  @override
  String get flBenefitCalls =>
      'Panggilan tanpa had dengan Pro · 15 minit setiap satu';

  @override
  String get flBenefitChecks => 'Semakan sebutan tanpa had dengan Pro';

  @override
  String flCaption(String price) {
    return '$price sebulan · batal bila-bila masa';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used daripada $limit digunakan';
  }

  @override
  String get ctaMaybeTomorrow => 'Mungkin esok';

  @override
  String get accountSection => 'Akaun';

  @override
  String get nicknameLabel => 'Nama panggilan';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Kaedah log masuk';

  @override
  String get joinedLabel => 'Menyertai';

  @override
  String get editNicknameTitle => 'Ubah Nama Panggilan';

  @override
  String get nicknameRule =>
      '2–12 aksara. Huruf dan nombor. Bahasa Inggeris sahaja';

  @override
  String get ctaSave => 'Simpan';

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
  String get paywallLeaveTitle => 'Jika keluar sekarang, anda tidak melanggan';

  @override
  String get paywallLeaveBody =>
      'Manfaat anda dibuka sejurus selepas pembayaran. Anda boleh kembali bila-bila masa dari Halaman saya.';

  @override
  String get ctaKeepLooking => 'Terus lihat';

  @override
  String get ctaLeaveAnyway => 'Keluar juga';

  @override
  String get iapCharacterSuccessTitle => 'Rakan baharu menyertai!';

  @override
  String get iapCharacterSuccessBody =>
      'Watak ini milik anda selamanya — kekal walaupun pelan berubah, dan Pulihkan pembelian membawanya kembali pada mana-mana peranti.';

  @override
  String get iapCharacterFailedBody =>
      'Pembelian tidak selesai. Tiada caj dikenakan — sila cuba lagi.';

  @override
  String get noAccentDataTitle => 'Belum ada data intonasi';

  @override
  String get noAccentDataBody =>
      'Teruskan berbual dan ciri intonasi anda akan terkumpul.';

  @override
  String get noLevelYetTitle => 'Belum ada tahap';

  @override
  String get noLevelYetBody =>
      'Selesaikan panggilan pertama anda untuk mendapat tahap.';

  @override
  String get noPronunciationDataTitle => 'Belum ada rekod sebutan';

  @override
  String get noPronunciationDataBody =>
      'Kami menganalisis sebutan daripada ayat yang anda tuturkan semasa panggilan.';

  @override
  String get noCharacterNote => 'Belum ada pesanan';

  @override
  String get noPhonemesYet => 'Belum ada bunyi untuk dianalisis';

  @override
  String get noSentencesYet => 'Belum ada ayat untuk dianalisis';

  @override
  String get takeLevelTest => 'Ambil ujian tahap';

  @override
  String get reviewToSeeScore => 'Ulang kaji untuk melihat skor sebutan anda';

  @override
  String get playAgain => 'Main semula';

  @override
  String get difficultySlow => 'Perlahan';

  @override
  String get difficultyNormal => 'Biasa';

  @override
  String get difficultyFast => 'Laju';

  @override
  String get difficultyLabel => 'Tahap kesukaran';

  @override
  String get connected => 'Disambungkan';

  @override
  String get unlockedWithMax => 'Tersedia dengan Max';

  @override
  String get callModeSheetTitle => 'Bagaimana anda mahu bercakap?';

  @override
  String get callModeSheetSubtitle =>
      'Berkuat kuasa serta-merta untuk panggilan ini';

  @override
  String get callModeFreeTalk => 'Sembang bebas';

  @override
  String get callModeFreeTalkDesc => 'Bercakap tanpa pembetulan';

  @override
  String get callModeStudy => 'Belajar';

  @override
  String get callModeStudyDesc => 'Pelajari satu ungkapan pada satu masa';

  @override
  String get callModeChange => 'Tukar mod';

  @override
  String get callModeKeep => 'Bukan sekarang';

  @override
  String get callExitTitle => 'Tamatkan panggilan ini?';

  @override
  String get callExitSubtitle =>
      'Menamatkan sekarang tetap menggunakan satu panggilan';

  @override
  String get callExitKeep => 'Teruskan bercakap';

  @override
  String get callExitConfirm => 'Tamatkan panggilan';

  @override
  String get callMicMute => 'Bisu';

  @override
  String get callMicUnmute => 'Nyahbisu';

  @override
  String get callPushToTalk => 'Tahan untuk bercakap';

  @override
  String get callFreeEndedTitle => 'Panggilan percuma anda telah tamat';

  @override
  String get callFreeEndedCta => 'Langgan dan teruskan bersembang';

  @override
  String get callKeepGoingTitle => 'Teruskan?';

  @override
  String get callKeepGoingSubtitle =>
      'Panggilan diteruskan setiap 5 minit. Kami akan bertanya setiap kali.';

  @override
  String get articulationSelectedWord => 'Perkataan dipilih';

  @override
  String get articulationYouSaid => 'Sebutan anda';

  @override
  String get articulationTargetSound => 'Sasaran';

  @override
  String get reportEntry => 'Lapor';

  @override
  String get reportTitle => 'Lapor';

  @override
  String get reportPrompt => 'Apakah masalahnya?';

  @override
  String get reportGuide =>
      'Beritahu kami kandungan watak AI yang membuat anda tidak selesa. Kami menyemak setiap laporan.';

  @override
  String get reportReasonSexual => 'Kandungan seksual';

  @override
  String get reportReasonHate => 'Kebencian atau diskriminasi';

  @override
  String get reportReasonViolence => 'Kandungan ganas atau mengancam';

  @override
  String get reportReasonSelfHarm => 'Menggalakkan mencederakan diri';

  @override
  String get reportReasonMisinfo => 'Maklumat palsu';

  @override
  String get reportReasonOther => 'Masalah lain';

  @override
  String get reportDetailHint => 'Terangkan apa yang berlaku (pilihan)';

  @override
  String get reportSubmit => 'Hantar laporan';

  @override
  String get reportDoneTitle => 'Laporan anda telah diterima';

  @override
  String get reportDoneBody =>
      'Kami akan menyemaknya dan mengambil tindakan jika perlu. Terima kasih kerana membantu memastikan BeaverTalk selamat.';

  @override
  String get reportFailed => 'Laporan tidak dapat dihantar. Sila cuba lagi.';

  @override
  String get hwTitle => 'Homework';

  @override
  String get hwJoinCodeTitle => 'Enter your class code';

  @override
  String get hwJoinCodeSubtitle => 'It is the 6-digit code from your teacher';

  @override
  String get hwJoinCodeLabel => 'Class code';

  @override
  String get hwJoinCodeHelp => 'The code is not case-sensitive';

  @override
  String get hwJoinConfirmTitle => 'Is this the right class?';

  @override
  String get hwJoinConfirmSubtitle => 'If not, check the code again';

  @override
  String get hwJoinFieldInstitution => 'Institution';

  @override
  String get hwJoinFieldTeacher => 'Teacher';

  @override
  String get hwJoinFieldLearners => 'Learners';

  @override
  String get hwJoinFieldTerm => 'Term';

  @override
  String get hwJoinConfirmNote =>
      'The class name is exactly as your teacher wrote it. We do not translate it.';

  @override
  String get hwJoinConfirmYes => 'Yes, that is it';

  @override
  String get hwJoinConfirmRetry => 'Re-enter code';

  @override
  String get hwJoinProfileTitle => 'What name will you use in class?';

  @override
  String get hwJoinProfileSubtitle =>
      'Your teacher matches this with the roster';

  @override
  String get hwJoinNameLabel => 'Name';

  @override
  String get hwJoinNameHelp => 'It can differ from your app name';

  @override
  String get hwJoinStudentNoLabel => 'Student ID (optional)';

  @override
  String get hwJoinStudentNoHelp => 'Your teacher uses it to match the roster';

  @override
  String get hwJoinConsentTitle => 'What your teacher sees';

  @override
  String get hwJoinConsentSubtitle => 'You must agree to join the class';

  @override
  String get hwJoinConsentSharedHeading => 'Shared with your teacher';

  @override
  String get hwJoinConsentShared1 => 'Class name and student ID';

  @override
  String get hwJoinConsentShared2 => 'Whether you did the homework';

  @override
  String get hwJoinConsentShared3 => 'Sentences passed and missed';

  @override
  String get hwJoinConsentShared4 => 'Assignment call length and summary';

  @override
  String get hwJoinConsentNotSharedHeading => 'Not shared';

  @override
  String get hwJoinConsentNotShared1 => 'Email and phone number';

  @override
  String get hwJoinConsentNotShared2 => 'App name, profile and character';

  @override
  String get hwJoinConsentNotShared3 => 'Nationality and first language';

  @override
  String get hwJoinConsentNotShared4 => 'Calls and study outside the class';

  @override
  String get hwJoinConsentNotShared5 => 'Subscription and payment details';

  @override
  String get hwJoinConsentAgree => 'I agree to the above';

  @override
  String get hwJoinConsentCta => 'Agree and join';

  @override
  String hwJoinDoneTitle(String className) {
    return 'You joined $className';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count assignments are waiting';
  }

  @override
  String get hwJoinDoneNoAssignment => 'No assignments yet';

  @override
  String get hwJoinDoneNextDue => 'Next due';

  @override
  String get hwJoinDoneRosterName => 'Your class name';

  @override
  String get hwJoinDoneCta => 'See homework';

  @override
  String get hwJoinErrorNotFound => 'We could not find that code';

  @override
  String get hwJoinErrorNotFoundBody => 'Please check the six digits again.';

  @override
  String get hwJoinErrorExpired => 'That code has expired';

  @override
  String get hwJoinErrorExpiredBody => 'Ask your teacher for a new code.';

  @override
  String get hwJoinErrorFull => 'The class is full';

  @override
  String get hwJoinErrorFullBody => 'Please let your teacher know.';

  @override
  String get hwJoinFailed => 'Could not join. Please try again in a moment.';

  @override
  String get hwSectionInProgress => 'In progress';

  @override
  String get hwSectionUpcoming => 'Upcoming';

  @override
  String get hwSectionDone => 'Done';

  @override
  String get hwLeaveClassLink => 'Leave the class';

  @override
  String get hwListEmptyTitle => 'No homework yet';

  @override
  String get hwListEmptyBody =>
      'It will show up here when your teacher assigns it.';

  @override
  String get hwListFailed => 'Could not load your homework.';

  @override
  String get hwRetry => 'Try again';

  @override
  String get hwBadgeDone => 'Done';

  @override
  String get hwBadgeOverdue => 'Not submitted';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Not submitted, ${days}d late';
  }

  @override
  String hwBadgeDday(int days) {
    return 'D-$days';
  }

  @override
  String get hwBadgeDueToday => 'Due today';

  @override
  String get hwActivitySpeaking => 'Speaking';

  @override
  String get hwActivityConversation => 'Conversation';

  @override
  String get hwActivityWorkbook => 'Workbook';

  @override
  String hwChapterLabel(String chapter) {
    return 'Chapter $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Check your pronunciation score';

  @override
  String get hwTaskConversationDesc => 'Use what you learned in a real talk';

  @override
  String get hwConversationOnce =>
      'Perbualan hanya boleh dibuat sekali bagi setiap kerja rumah.';

  @override
  String get hwTaskWorkbookDesc => 'Practice by writing in the workbook';

  @override
  String get hwCtaStudy => 'Start';

  @override
  String get hwCtaResult => 'See result';

  @override
  String get hwCtaDownload => 'Download';

  @override
  String get hwSpeakingNoScore => 'You have not done the speaking task yet';

  @override
  String get hwWorkbookUnavailable => 'The workbook file is not available yet.';

  @override
  String get hwDetailClosed =>
      'This assignment is closed. You can no longer submit.';

  @override
  String get hwLeaveTitle => 'Leave the class?';

  @override
  String get hwLeaveBody =>
      'Your teacher will no longer see your homework results.';

  @override
  String get hwLeaveConfirm => 'Leave';

  @override
  String get hwLeaveCancel => 'Stay';

  @override
  String get hwLeaveFailed => 'Could not leave the class.';

  @override
  String get hwMyClass => 'My class';

  @override
  String get hwClassEmptyTitle => 'You have not joined a class';

  @override
  String get hwClassEmptySubtitle => 'Enter the code your teacher gave you';

  @override
  String get hwClassEmptyCta => 'Enter class code';

  @override
  String get hwClassContinueCta => 'Continue';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count assignments are due tomorrow';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return 'You have $count unsubmitted assignments';
  }

  @override
  String get hwSpeakingUnavailable =>
      'The sentences for this assignment are not available yet.';

  @override
  String get hwBadgeClosed => 'Closed';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$passed of $total sentences passed';
  }
}
