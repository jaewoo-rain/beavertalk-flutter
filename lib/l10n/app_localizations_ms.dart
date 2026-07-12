// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

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
  String get analysisLoadError => 'Tidak dapat memuatkan keputusan analisis.';

  @override
  String get standardAudioNotReady => 'Audio sebutan piawai belum sedia lagi.';

  @override
  String get standardAudioPlayError =>
      'Tidak dapat memainkan audio sebutan piawai.';

  @override
  String get selectACountry => 'Pilih negara';

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
  String get pricePerMonth => '\$12.9 / bulan';

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
  String get loginContinueWithKakao => 'Teruskan dengan Kakao';

  @override
  String get loginContinueWithGoogle => 'Teruskan dengan Google';

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
}
