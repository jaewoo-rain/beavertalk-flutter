// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get loginRequired => 'Anda perlu masuk.';

  @override
  String get callWebNotSupported =>
      'Panggilan suara tidak didukung di web. Gunakan aplikasi.';

  @override
  String get micPermissionRequiredForCall =>
      'Izin mikrofon diperlukan. Izinkan mikrofon untuk memulai panggilan.';

  @override
  String get callErrorGeneric => 'Terjadi kesalahan saat panggilan.';

  @override
  String get callNetworkError => 'Terjadi kesalahan jaringan.';

  @override
  String get authInvalidCredentials => 'Email atau kata sandi salah.';

  @override
  String get authEmailAlreadyRegistered => 'Email ini sudah terdaftar.';

  @override
  String get authConfirmEmailRequired =>
      'Selesaikan verifikasi yang dikirim ke email Anda.';

  @override
  String get authResetCodeSent =>
      'Kami telah mengirim kode verifikasi ke email Anda.';

  @override
  String get authResetCodeInvalid => 'Kode salah atau sudah kedaluwarsa.';

  @override
  String get authPasswordUpdated => 'Kata sandi Anda telah direset.';

  @override
  String get authAppleTokenMissing =>
      'Tidak bisa mendapatkan token masuk Apple.';

  @override
  String callEndedDuration(String duration) {
    return 'Panggilan berakhir $duration';
  }

  @override
  String get callRatingPrompt => 'Bagaimana panggilanmu?';

  @override
  String get ratingBad => 'Kurang bagus';

  @override
  String get ratingOkay => 'Lumayan';

  @override
  String get ratingGood => 'Bagus';

  @override
  String get goHome => 'Beranda';

  @override
  String get viewAnalysis => 'Lihat Analisis';

  @override
  String get loadingShort => 'Memuat…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Gagal mengirim penilaian: $message';
  }

  @override
  String get callInfoNotFound =>
      'Info panggilan tidak ditemukan, melewati analisis.';

  @override
  String get tabRecords => 'Rekaman';

  @override
  String get tabArchive => 'Arsip';

  @override
  String get callHistory => 'Riwayat Panggilan';

  @override
  String get conversationRecord => 'Rekaman percakapan';

  @override
  String get noCallRecords => 'Belum ada rekaman panggilan';

  @override
  String get noCallRecordsBody =>
      'Setelah kamu menyelesaikan panggilan pertama dengan AI,\nrekamanmu akan muncul di sini.';

  @override
  String get startCall => 'Mulai Panggilan';

  @override
  String get recordsLoadError => 'Tidak dapat memuat rekaman';

  @override
  String get tryAgainLater => 'Silakan coba lagi nanti.';

  @override
  String get retry => 'Coba Lagi';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes mnt $seconds dtk';
  }

  @override
  String get scheduleManagement => 'Jadwal';

  @override
  String get alarms => 'Alarm';

  @override
  String get addSchedule => 'Tambah Jadwal';

  @override
  String get editSchedule => 'Ubah Jadwal';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan';

  @override
  String get alarmsLoadError => 'Tidak dapat memuat alarm';

  @override
  String get charactersLoadError => 'Tidak dapat memuat karakter';

  @override
  String get noCharacters => 'Tidak ada karakter yang tersedia';

  @override
  String get close => 'Tutup';

  @override
  String get repeat => 'Ulangi';

  @override
  String get callPartner => 'Karakter';

  @override
  String get quickStart => 'Mulai cepat';

  @override
  String get presetMorning => 'Rutinitas pagi';

  @override
  String get presetMorningSub => 'Hari kerja 8:00';

  @override
  String get presetEvening => 'Penutup malam';

  @override
  String get presetEveningSub => 'Setiap hari 21:00';

  @override
  String get presetCustom => 'Kustom';

  @override
  String get presetCustomSub => 'Sesukamu';

  @override
  String alarmSummary(int count, int monthly) {
    return '$count× seminggu · $monthly panggilan sebulan';
  }

  @override
  String get alarmSummaryNone => 'Pilih setidaknya satu hari';

  @override
  String get partnerInUse => 'Sedang dipakai';

  @override
  String get partnerOwned => 'Dimiliki';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get save => 'Simpan';

  @override
  String get conversation => 'Percakapan';

  @override
  String get review => 'Ulasan';

  @override
  String get pronunciationChallenge => 'Tantangan Pengucapan';

  @override
  String get newExpressions => 'Ungkapan Baru';

  @override
  String get analysisResult => 'Hasil Analisis';

  @override
  String get noNewExpressions => 'Tidak ada ungkapan baru dari percakapan ini.';

  @override
  String get practice => 'Latihan';

  @override
  String recentScore(int score) {
    return 'Skor terbaru $score%';
  }

  @override
  String callSequence(int count) {
    return 'Panggilan ke-$count';
  }

  @override
  String characterNoteTitle(String name) {
    return 'Sepatah kata dari $name';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Ditinggalkan $name tepat setelah panggilan';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Ungkapan baru $count';
  }

  @override
  String get analysisLoadError => 'Tidak dapat memuat hasil analisis.';

  @override
  String get standardAudioNotReady => 'Audio pengucapan standar belum siap.';

  @override
  String get standardAudioPlayError =>
      'Tidak dapat memutar audio pengucapan standar.';

  @override
  String get selectNativeLanguage => 'Pilih bahasa ibu Anda';

  @override
  String get selectYourLanguage => 'Pilih bahasamu';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get cancel => 'Batal';

  @override
  String get selectTime => 'Pilih waktu';

  @override
  String get getStarted => 'Mulai';

  @override
  String get permissionTitle => 'Izinkan akses\nuntuk pengalaman yang lancar';

  @override
  String get permissionSubtitle =>
      'Izin yang diperlukan penting untuk menggunakan layanan.';

  @override
  String get permissionMicTitle => 'Mikrofon (wajib)';

  @override
  String get permissionMicDesc =>
      'Diperlukan untuk berbicara dengan AI dalam bahasa Korea.';

  @override
  String get permissionNotifTitle => 'Notifikasi (opsional)';

  @override
  String get permissionNotifDesc =>
      'Kami akan mengirim pengingat belajar dan jadwal panggilan.';

  @override
  String get micPermissionNeededTitle => 'Akses mikrofon diperlukan';

  @override
  String get micPermissionNeededBody =>
      'Untuk berbicara dengan AI, kamu perlu mengizinkan akses mikrofon. Silakan aktifkan di Pengaturan.';

  @override
  String get openSettings => 'Buka Pengaturan';

  @override
  String get connectionFailedTitle => 'Koneksi gagal';

  @override
  String get connectionFailedBody =>
      'Periksa koneksi jaringanmu\ndan coba lagi.';

  @override
  String get checkout => 'Pembayaran';

  @override
  String get pay => 'Bayar';

  @override
  String get orderSummary => 'Ringkasan Pesanan';

  @override
  String get paymentMethod => 'Metode Pembayaran';

  @override
  String get payMethodCard => 'Kartu Kredit / Debit';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Avatar Beaver Menyebalkan';

  @override
  String get productTrait => 'Karakter premium · Milikmu selamanya';

  @override
  String get amountItemPrice => 'Harga item';

  @override
  String get amountDiscount => 'Diskon';

  @override
  String get amountTotal => 'Total';

  @override
  String get paymentCompleteTitle => 'Pembayaran selesai';

  @override
  String get paymentCompleteBody => 'Avatar telah ditambahkan ke koleksimu.';

  @override
  String get viewCollection => 'Lihat Koleksi';

  @override
  String get receiptItem => 'Item';

  @override
  String get receiptAmount => 'Jumlah';

  @override
  String get receiptMethod => 'Metode pembayaran';

  @override
  String get receiptDate => 'Tanggal';

  @override
  String get paymentFailedTitle => 'Pembayaran gagal';

  @override
  String get paymentFailedBody =>
      'Pembayaranmu tidak dapat diproses.\nSilakan coba lagi.';

  @override
  String get freeCallEndingTitle => 'Panggilan gratismu akan berakhir';

  @override
  String get freeCallEndingBody =>
      'Berlangganan untuk berbicara lebih lama dengan Beaver.';

  @override
  String get subscribe => 'Berlangganan';

  @override
  String get endCall => 'Akhiri Panggilan';

  @override
  String get callEnded => 'Panggilan telah berakhir.';

  @override
  String get connecting => 'Menghubungkan…';

  @override
  String get connectingHint => 'Biasanya butuh kurang dari 5 detik';

  @override
  String get callConnectFailed => 'Tidak dapat menghubungkan panggilan.';

  @override
  String get saveSentenceFailed => 'Tidak dapat menyimpan kalimat.';

  @override
  String get recordStartFailed => 'Tidak dapat memulai perekaman.';

  @override
  String get recordTooShort => 'Rekaman itu terlalu pendek. Silakan coba lagi.';

  @override
  String get gradingFailed => 'Penilaian gagal. Silakan coba lagi.';

  @override
  String get listenStandard => 'Dengarkan pengucapan standar';

  @override
  String get saveSentence => 'Simpan kalimat';

  @override
  String get unsaveSentence => 'Hapus kalimat tersimpan';

  @override
  String get scoringPronunciation => 'Menilai pengucapanmu…';

  @override
  String get analyzingByWord => 'Memeriksa pelafalanmu kata demi kata';

  @override
  String get analyzingTakingLonger => 'Ini memakan waktu sedikit lebih lama';

  @override
  String get scanConnectionLost => 'Koneksi terputus';

  @override
  String get noRecordingToPlay => 'Tidak ada rekaman untuk diputar.';

  @override
  String get myRecordingPlayError => 'Tidak dapat memutar rekamanmu.';

  @override
  String get next => 'Lanjut';

  @override
  String get endLearning => 'Akhiri Sesi';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navCall => 'Panggilan';

  @override
  String get navStats => 'Statistik';

  @override
  String get myPage => 'Halamanku';

  @override
  String get languageSaveFailed => 'Tidak dapat menyimpan bahasamu.';

  @override
  String get accountDeleteFailed => 'Tidak dapat menghapus akunmu.';

  @override
  String get changeAvatar => 'Ganti Avatar';

  @override
  String get avatarIntro =>
      'Suara dan tingkat kesulitan berbeda tergantung lawan bicara.\nBeberapa lawan bicara mungkin memerlukan pembayaran.';

  @override
  String myPartnersOwned(int count) {
    return 'Partnerku · $count dimiliki';
  }

  @override
  String get limitedDiscount => 'Diskon waktu terbatas';

  @override
  String get available => 'Tersedia';

  @override
  String get inUse => 'Digunakan';

  @override
  String get owned => 'Dimiliki';

  @override
  String get noCharactersToShow => 'Tidak ada karakter untuk ditampilkan';

  @override
  String get buy => 'Beli';

  @override
  String get noSavedSentences =>
      'Belum ada kalimat tersimpan.\nTandai kalimat dari rekaman percakapanmu.';

  @override
  String get noAlarms => 'Belum ada alarm';

  @override
  String get noAlarmsBody =>
      'Tambahkan pengingat belajar\nuntuk membangun kebiasaan yang konsisten.';

  @override
  String get subscriptionManage => 'Kelola Langganan';

  @override
  String get changePlan => 'Ubah Paket';

  @override
  String get cancelSubscription => 'Batalkan Langganan';

  @override
  String get benefitsInUse => 'Manfaatmu';

  @override
  String get paymentInfo => 'Info pembayaran';

  @override
  String get nextBillingDate => 'Tanggal tagihan berikutnya';

  @override
  String get lostBenefitsTitle => 'Manfaat yang akan hilang jika kamu berhenti';

  @override
  String get viewBillingHistory => 'Lihat Riwayat Tagihan';

  @override
  String get keepUsingPro => 'Tetap Gunakan Pro';

  @override
  String get proMembership => 'Keanggotaan Pro';

  @override
  String pricePerMonth(String price) {
    return '$price / bulan';
  }

  @override
  String get benefitUnlimitedCalls => 'Panggilan tanpa batas';

  @override
  String get benefitDetailedAnalysis =>
      'Analisis pengucapan & tata bahasa terperinci';

  @override
  String get benefitAllCharacters => 'Akses ke semua karakter';

  @override
  String get benefitNoAds => 'Tanpa iklan';

  @override
  String get playSampleVoice => 'Putar contoh suara';

  @override
  String get useThisAvatar => 'Gunakan Ini';

  @override
  String get challengeTitle => 'Tantangan Pengucapan';

  @override
  String get challengeIntro =>
      'Ucapkan setiap kartu di zona dengan benar dalam bahasa Korea untuk menyelesaikannya.\nTidak ada mikrofon? Kamu juga bisa bermain dengan mengetuk layar.';

  @override
  String get challengeStart => 'Mulai Kamera & Mikrofon';

  @override
  String get challengePermissionNote =>
      'Akses kamera depan dan mikrofon diperlukan (opsional).';

  @override
  String get challengeLoadingTitle => 'Memuat…';

  @override
  String get challengeLoadingNote =>
      'Mengunduh model suara Korea (~82MB) saat pertama kali dijalankan.\nMohon tunggu sebentar.';

  @override
  String get challengeSttFallback =>
      'Pengenalan suara tidak tersedia, jadi kamu bermain dengan input ketuk.';

  @override
  String get reasonTravelTitle => 'Berbicara saat bepergian';

  @override
  String get reasonTravelDesc => 'Mengobrol percaya diri dengan penduduk lokal';

  @override
  String get reasonCareerTitle => 'Pekerjaan & karier';

  @override
  String get reasonCareerDesc => 'Percakapan bisnis';

  @override
  String get reasonExamTitle => 'Persiapan ujian';

  @override
  String get reasonExamDesc => 'Bersiap untuk tes berbicara';

  @override
  String get reasonDailyTitle => 'Percakapan sehari-hari';

  @override
  String get reasonDailyDesc => 'Ungkapan yang kamu pakai setiap hari';

  @override
  String get reasonFriendsTitle => 'Berteman dengan orang asing';

  @override
  String get reasonFriendsDesc => 'Percakapan yang alami';

  @override
  String get reasonBrainTitle => 'Stimulasi otak';

  @override
  String get reasonBrainDesc => 'Tingkatkan daya ingat & fokus';

  @override
  String get challengeRecordToggle => 'Rekam sesi ini';

  @override
  String get challengeRecordHint =>
      'Menyimpan video permainanmu untuk dibagikan (tanpa suara).';

  @override
  String get settingsSection => 'Pengaturan';

  @override
  String get paymentSection => 'Pembayaran';

  @override
  String get supportSection => 'Bantuan';

  @override
  String get userLanguage => 'Bahasa Pengguna';

  @override
  String get learningLanguage => 'Bahasa yang Dipelajari';

  @override
  String get learningLanguageKorean => 'Korea';

  @override
  String get notificationLabel => 'Notifikasi';

  @override
  String get currentPlan => 'Paket Saat Ini';

  @override
  String get paymentHistory => 'Riwayat Pembayaran';

  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get termsOfService => 'Ketentuan layanan';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get logOut => 'Keluar';

  @override
  String get deleteAccount => 'Hapus akun';

  @override
  String get deleteAccountTitle => 'Hapus akun?';

  @override
  String get deleteAccountBody =>
      'Ini menghapus akun dan datamu secara permanen dan tidak dapat dibatalkan.';

  @override
  String get delete => 'Hapus';

  @override
  String get share => 'Bagikan';

  @override
  String get accentSoundsLike => 'Aksen bahasa Koreamu terdengar';

  @override
  String get hintLabel => 'Petunjuk';

  @override
  String get nextHint => 'Petunjuk berikutnya';

  @override
  String get translateLabel => 'Terjemahkan';

  @override
  String get startRecording => 'Mulai merekam';

  @override
  String get stopRecording => 'Berhenti merekam';

  @override
  String get back => 'Kembali';

  @override
  String get onboardingNameTitle => 'Kami harus memanggilmu apa?';

  @override
  String get onboardingNameSubtitle => 'Tutor AI-mu akan mengingat namamu.';

  @override
  String get nameLabel => 'Namamu';

  @override
  String get nameHint => 'Masukkan namamu';

  @override
  String get nameHelper =>
      'Tidak harus nama aslimu — nama panggilan juga bisa.';

  @override
  String get continueLabel => 'Lanjutkan';

  @override
  String get onboardingDoneTitle => 'Beaver sedang menunggu panggilanmu';

  @override
  String get onboardingDoneSubtitle => 'Mulai panggilan sekarang juga';

  @override
  String get home => 'Beranda';

  @override
  String get callNow => 'Panggil sekarang';

  @override
  String get pronunciation => 'Pengucapan';

  @override
  String get fluency => 'Kelancaran';

  @override
  String get rhythm => 'Ritme';

  @override
  String get analysisTimeout =>
      'Ini memakan waktu lebih lama dari perkiraan. Silakan coba lagi sebentar lagi.';

  @override
  String get analysisFailed =>
      'Kami tidak dapat menganalisis percakapan. Silakan coba lagi.';

  @override
  String get analyzingConversation => 'Menganalisis percakapanmu…';

  @override
  String get analyzingSubtitle => 'Ini hanya butuh sebentar';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get nativeLabel => 'Penutur asli';

  @override
  String get meLabel => 'Saya';

  @override
  String get pronunciationPlayError => 'Tidak dapat memutar audio pengucapan.';

  @override
  String get savedExpressionsLoadError =>
      'Tidak dapat memuat ungkapan tersimpanmu.';

  @override
  String get mySavedExpressions => 'Ungkapan Tersimpanku';

  @override
  String get avatarTraits => 'Hangat · Tenang · Lembut';

  @override
  String get priceFree => 'Gratis';

  @override
  String get loginGoogleTokenError =>
      'Tidak dapat memperoleh token masuk Google.';

  @override
  String get loginGoogleSignInFailed => 'Masuk dengan Google gagal.';

  @override
  String get loginAppleSignInFailed => 'Masuk dengan Apple gagal.';

  @override
  String get loginFacebookSignInFailed => 'Masuk dengan Facebook gagal.';

  @override
  String get loginKakaoSignInFailed => 'Masuk dengan Kakao gagal.';

  @override
  String get loginContinueWithKakao => 'Lanjutkan dengan Kakao';

  @override
  String get loginContinueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get loginContinueWithFacebook => 'Lanjutkan dengan Facebook';

  @override
  String get loginContinueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get loginContinueWithEmail => 'Lanjutkan dengan email';

  @override
  String get loginOrDivider => 'atau';

  @override
  String get loginNoAccount => 'Belum punya akun?';

  @override
  String get signUp => 'Daftar';

  @override
  String get loginTermsNoticePrefix => 'Dengan melanjutkan, kamu menyetujui ';

  @override
  String get loginTermsNoticeAnd => ' dan ';

  @override
  String get loginTermsNoticeSuffix => '.';

  @override
  String get loginLogIn => 'Masuk';

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get emailHint => 'Masukkan emailmu';

  @override
  String get fieldPasswordLabel => 'Kata sandi';

  @override
  String get passwordHint => 'Masukkan kata sandimu';

  @override
  String get loginRememberMe => 'Ingat saya';

  @override
  String get loginForgotPassword => 'Lupa kata sandi?';

  @override
  String get loginLoggingIn => 'Sedang masuk...';

  @override
  String get passwordLengthError => 'Kata sandi harus 8–16 karakter.';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok.';

  @override
  String get signupCheckInput => 'Silakan periksa masukanmu.';

  @override
  String get fieldConfirmPasswordLabel => 'Konfirmasi kata sandi';

  @override
  String get confirmPasswordHint => 'Masukkan ulang kata sandimu';

  @override
  String get signupSigningUp => 'Sedang mendaftar...';

  @override
  String get signupHaveAccount => 'Sudah punya akun?';

  @override
  String get passwordMethodEmailRequired => 'Masukkan emailmu';

  @override
  String get passwordResetTitle => 'Atur ulang kata sandi';

  @override
  String get passwordMethodDescription =>
      'Masukkan alamat email tempat kamu ingin menerima kode atur ulang kata sandi.';

  @override
  String get emailAddressHint => 'Alamat email';

  @override
  String get passwordMethodSending => 'Mengirim...';

  @override
  String get passwordMethodSendEmail => 'Kirim email';

  @override
  String get passwordCodeTitle => 'Masukkan kode';

  @override
  String get passwordCodeDescription =>
      'Kami telah mengirim kode pemulihan ke emailmu. Masukkan untuk melanjutkan.';

  @override
  String get passwordCodeNoCode => 'Tidak menerima kode?';

  @override
  String get passwordCodeResend => 'Kirim ulang kode';

  @override
  String get passwordCodeVerifying => 'Memverifikasi...';

  @override
  String get passwordNewTitle => 'Kata sandi baru';

  @override
  String get passwordNewDescription => 'Atur kata sandi baru untuk akunmu.';

  @override
  String get fieldNewPasswordLabel => 'Kata sandi baru';

  @override
  String get newPasswordHint => 'Masukkan kata sandi barumu';

  @override
  String get fieldConfirmNewPasswordLabel => 'Konfirmasi kata sandi baru';

  @override
  String get confirmNewPasswordHint => 'Masukkan ulang kata sandi barumu';

  @override
  String get passwordNewSubmitting => 'Mengirim...';

  @override
  String get passwordNewSubmit => 'Kirim';

  @override
  String get passwordCompleteTitle => 'Atur ulang kata sandi selesai';

  @override
  String get passwordCompleteBody =>
      'Kata sandimu telah diatur ulang. Masuk dengan kata sandi barumu untuk melanjutkan.';

  @override
  String get termsTitle => 'Ketentuan layanan';

  @override
  String get privacyTitle => 'Kebijakan privasi';

  @override
  String passwordNewDescriptionEmail(String email) {
    return 'Atur kata sandi baru untuk $email.';
  }

  @override
  String get selectComplete => 'Selesai';

  @override
  String get onboardingLanguageTitle => 'Apa bahasa ibu Anda?';

  @override
  String get onboardingReasonTitle => 'Mengapa Anda belajar bahasa?';

  @override
  String get onboardingReasonSubtitle =>
      'Kami akan menyesuaikan pembelajaran Anda dengan tujuan Anda.';

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
  String get filterCharacter => 'Karakter';

  @override
  String get statusCompleted => 'Selesai';

  @override
  String get lastPayment => 'Pembayaran terakhir';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Kamu bisa terus memakai manfaat Pro sampai $date, setelah itu paketmu otomatis beralih ke Gratis.';
  }

  @override
  String get freePlanCallLimit => '1 panggilan per hari · batas 5 menit';

  @override
  String get freePlanBasicCharacters => 'Karakter dasar termasuk';

  @override
  String get availableForPurchase => 'Tersedia untuk dibeli';

  @override
  String get paymentsLoadError => 'Gagal memuat riwayat pembayaran';

  @override
  String get noPayments => 'Belum ada pembayaran';

  @override
  String get morePaymentsExist => 'Pembayaran lama belum ditampilkan';

  @override
  String get undatedPayments => 'Tanpa tanggal';

  @override
  String get paymentLabelFallback => 'Pembayaran';

  @override
  String learningPassed(int passed, int total) {
    return '$passed dari $total kalimat lulus';
  }

  @override
  String get hardestSound => 'Bunyi tersulit hari ini';

  @override
  String get soundAccuracy => 'Akurasi per bunyi';

  @override
  String phonemeAttempts(int count) {
    return 'Per fonem · $count percobaan';
  }

  @override
  String get colSound => 'Bunyi';

  @override
  String get colAttempts => 'Coba';

  @override
  String get colCorrect => 'Benar';

  @override
  String get colAccuracy => 'Akur.';

  @override
  String get sentenceResults => 'Hasil per kalimat';

  @override
  String viewAllSentences(int count) {
    return 'Lihat semua $count';
  }

  @override
  String get colSentence => 'Kalimat';

  @override
  String get colPronunciation => 'Lafal';

  @override
  String get colFluency => 'Lancar';

  @override
  String get colRhythm => 'Irama';

  @override
  String recentSessions(int count) {
    return '$count sesi terakhir';
  }

  @override
  String trendAverage(int score) {
    return 'Rata2 $score';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get colDate => 'Tanggal';

  @override
  String get colSentences => 'Kalimat';

  @override
  String get colScore => 'Skor';

  @override
  String get colChange => 'Ubah';

  @override
  String dateToday(String date) {
    return '$date (hari ini)';
  }

  @override
  String get accentAnalysis => 'Analisis aksen';

  @override
  String get overallLevel => 'Level keseluruhan';

  @override
  String get overallLevelSubtitle => 'Kosakata · Tata bahasa · Ekspresi';

  @override
  String get pronunciationAnalysis => 'Analisis pelafalan';

  @override
  String get recentSessionsAverage => 'Rata-rata 10 sesi';

  @override
  String levelStage(int stage) {
    return 'Level $stage';
  }

  @override
  String topPercent(int percent) {
    return 'Top $percent%';
  }

  @override
  String get allLearnersBasis => 'Di antara semua pelajar';

  @override
  String aheadOfLearners(int percent) {
    return 'Kamu unggul dari $percent% pelajar';
  }

  @override
  String get retakeLevelTest => 'Ulangi tes level';

  @override
  String get practicePronunciation => 'Latih pelafalan';

  @override
  String get priceChangedTitle => 'Harga berubah';

  @override
  String priceChangedBody(String price) {
    return 'Item ini sekarang $price. Lanjutkan?';
  }

  @override
  String get billingGroupPlanPurchases => 'Paket & pembelian';

  @override
  String get billingGroupInTheStore => 'Di toko';

  @override
  String get billingChangePlan => 'Ubah paket';

  @override
  String get billingCompareAllPlans => 'Bandingkan semua paket';

  @override
  String get billingBuyACharacter => 'Beli karakter';

  @override
  String get billingRestorePurchases => 'Pulihkan pembelian';

  @override
  String get billingPaymentHistory => 'Riwayat pembayaran';

  @override
  String get billingManageInTheStore => 'Kelola di toko';

  @override
  String get billingRefundHelp => 'Bantuan refund';

  @override
  String get billingCancelSubscription => 'Batalkan langganan';

  @override
  String get billingResubscribe => 'Berlangganan lagi';

  @override
  String get badgeCurrent => 'Saat ini';

  @override
  String get badgeTrial => 'Uji coba';

  @override
  String get badgeRenewing => 'Diperpanjang';

  @override
  String get badgePastDue => 'Tertunggak';

  @override
  String get badgePaused => 'Dijeda';

  @override
  String get badgeCanceling => 'Dibatalkan';

  @override
  String get subscriptionTitle => 'Langganan';

  @override
  String get plansTitle => 'Paket';

  @override
  String get planFree => 'Gratis';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Max';

  @override
  String get planMaxTrial => 'Uji coba Max';

  @override
  String get freePlanPriceLine => '\$0.00 — satu panggilan per hari';

  @override
  String pricePerMonthLine(String amount) {
    return '$amount per bulan';
  }

  @override
  String freeUntilDate(String date) {
    return 'Gratis sampai $date';
  }

  @override
  String get todaysCalls => 'Panggilan hari ini';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$used dari $limit terpakai';
  }

  @override
  String get firstPaymentLabel => 'Pembayaran pertama';

  @override
  String get nextPaymentLabel => 'Pembayaran berikutnya';

  @override
  String get retryingUntilLabel => 'Dicoba lagi sampai';

  @override
  String get pausedSinceLabel => 'Dijeda sejak';

  @override
  String planEndsLabel(String plan) {
    return '$plan berakhir';
  }

  @override
  String get bannerGoUnlimitedTitle => 'Tanpa batas dengan Pro';

  @override
  String bannerGoUnlimitedSub(String price) {
    return 'Panggilan tanpa batas · 15 menit per panggilan · $price per bulan';
  }

  @override
  String get bannerMaxUpsellTitle => 'Aktifkan video dengan Max';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Panggilan tatap muka · $price per bulan';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Beralih ke tahunan';

  @override
  String bannerAnnualSwitchSub(String yearly, String perMonth) {
    return '$yearly per tahun · $perMonth per bulan';
  }

  @override
  String get bannerPaymentFailedTitle => 'Pembayaranmu tidak berhasil';

  @override
  String get bannerPaymentFailedSub =>
      'Perbarui pembayaran di toko agar Pro tetap aktif';

  @override
  String get bannerPausedTitle => 'Paketmu dijeda';

  @override
  String get bannerPausedSub => 'Pembayaran tidak pernah berhasil';

  @override
  String get noteRestoreHint =>
      'Sudah berlangganan di perangkat lain? Pulihkan untuk mengaktifkannya di perangkat ini.';

  @override
  String get noteStoreHandled =>
      'Metode pembayaran, perubahan paket, dan pembatalan ditangani oleh toko.';

  @override
  String get noteFairUse =>
      'Penggunaan tanpa batas tunduk pada kebijakan penggunaan wajar kami.';

  @override
  String noteTrialEnds(String date) {
    return 'Uji cobamu berakhir $date. Batalkan di toko sebelum itu dan tidak ada tagihan.';
  }

  @override
  String get noteGrace =>
      'Manfaat tetap berjalan selama masa tenggang. Pembatalan tidak pernah dihalangi di aplikasi.';

  @override
  String get noteHold =>
      'Pro dijeda sampai pembayaran berhasil. Karakter dan progresmu aman.';

  @override
  String noteEnding(String date) {
    return 'Paketmu akan berakhir. Manfaat berjalan sampai $date, lalu kamu beralih ke Gratis. Kamu bisa berlangganan lagi kapan saja.';
  }

  @override
  String get trialExpiredTitle => 'Uji coba Max-mu berakhir';

  @override
  String get trialExpiredSub => 'Sekarang kamu di paket Gratis';

  @override
  String get seePlans => 'Lihat paket';

  @override
  String get currentPlanTitle => 'Paket Saat Ini';

  @override
  String get badgeRecommended => 'Direkomendasikan';

  @override
  String get perMonthUnit => 'per bulan';

  @override
  String get planTaglinePro => 'Panggilan tanpa batas. 15 menit per panggilan.';

  @override
  String get planTaglineMax => 'Sekarang kamu bisa melihat mereka.';

  @override
  String get planTaglineFree => 'Satu panggilan per hari. Gratis.';

  @override
  String get bulletProCalls => 'Panggilan suara sesering yang kamu mau';

  @override
  String get bulletProLength => '15 menit per panggilan';

  @override
  String get bulletProScoring => 'Pengucapan dinilai huruf demi huruf';

  @override
  String get bulletProCorrections =>
      'Koreksi yang disesuaikan dengan bahasa ibumu';

  @override
  String get bulletProBeaverCalls => 'Beaver meneleponmu lebih dulu';

  @override
  String get bulletMaxVideo => 'Panggilan video tatap muka';

  @override
  String get bulletMaxEverything => 'Semua yang ada di Pro';

  @override
  String get bulletMaxCharacters => 'Semua karakter, tanpa batas';

  @override
  String get bulletMaxStudyBook => 'Buku belajar yang sesuai dengan levelmu';

  @override
  String get bulletMaxWeeklyReport =>
      'Laporan mingguan tentang perkembangan pengucapanmu';

  @override
  String get bulletFreeCall => 'Satu panggilan suara 5 menit per hari';

  @override
  String get bulletFreeCheck => 'Satu cek pengucapan per hari';

  @override
  String get bulletFreeAccent => 'Cek aksen tanpa batas';

  @override
  String get bulletFreeCharacter => 'Satu karakter untuk memulai';

  @override
  String get ctaGoUnlimited => 'Tanpa batas sekarang';

  @override
  String get ctaTurnOnVideo => 'Aktifkan video';

  @override
  String get noteCallLength => 'Setiap panggilan berdurasi 15 menit.';

  @override
  String get paywallProTitle1 => 'Teman Koreamu';

  @override
  String get paywallProTitle2 => 'yang bangun jam 3 pagi';

  @override
  String get paywallProSub =>
      'Panggilan tanpa batas. 15 menit per panggilan. Sepanjang tahun.';

  @override
  String get paywallLimitHeadline => 'Pro menghapus batasnya.';

  @override
  String get limitBannerCallTitle => 'Itu panggilan hari ini';

  @override
  String get limitBannerCallSub => 'Gratis memberi satu panggilan per hari';

  @override
  String get limitBannerCheckTitle => 'Itu cek hari ini';

  @override
  String get limitBannerCheckSub => 'Gratis memberi satu cek per hari';

  @override
  String get bulletProCharactersForever =>
      'Karakter yang kamu beli jadi milikmu selamanya';

  @override
  String get paywallMaxTitle => 'Sekarang kamu bisa melihat mereka.';

  @override
  String get paywallMaxSub =>
      'Panggilan video, semua karakter, dan buku belajar yang dibuat sesuai levelmu.';

  @override
  String get planMonthly => 'Bulanan';

  @override
  String get planAnnual => 'Tahunan';

  @override
  String proMonthlyPriceLine(String price) {
    return '$price per bulan';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · $perMonth per bulan';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return '$price per bulan';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly per tahun · $perMonth per bulan';
  }

  @override
  String ctaCaptionPro(String price) {
    return '$price per bulan · batalkan kapan saja di toko';
  }

  @override
  String ctaCaptionMax(String price) {
    return '$price per bulan · batalkan kapan saja di toko';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 hari gratis, lalu $price per bulan · batalkan kapan saja di toko';
  }

  @override
  String get ctaCaptionAutoRenew => 'Diperpanjang otomatis sampai dibatalkan.';

  @override
  String get footerTerms => 'Ketentuan';

  @override
  String get footerPrivacy => 'Privasi';

  @override
  String get noteMaxCharacters =>
      'Karakter yang dibuka Max tersedia selama langgananmu aktif. Karakter yang kamu beli tetap milikmu.';

  @override
  String get processingTitle => 'Mengonfirmasi pembelianmu';

  @override
  String get processingSub => 'Biasanya hanya butuh beberapa detik.';

  @override
  String get successProTitle => 'Kamu sudah di Pro.';

  @override
  String get successProSub => 'Panggilan tanpa batas, mulai sekarang.';

  @override
  String get successProBenefit1 =>
      'Telepon sesering yang kamu mau — 15 menit per panggilan';

  @override
  String get successProBenefit2 => 'Cek pengucapan tanpa batas';

  @override
  String get successProBenefit3 => 'Semua karakter, plus pembelian satuan';

  @override
  String get successMaxTitle => 'Sekarang kamu bisa melihat mereka.';

  @override
  String get successMaxSub =>
      'Panggilan video aktif. Ketuk tombol video di panggilan mana pun.';

  @override
  String get successMaxBenefit1 => 'Panggilan video tatap muka';

  @override
  String get successMaxBenefit2 =>
      'Semua karakter, tanpa batas, dan yang baru lebih dulu';

  @override
  String get successMaxBenefit3 => 'Buku belajar yang sesuai dengan levelmu';

  @override
  String get ctaStartACall => 'Mulai panggilan';

  @override
  String get ctaStartAVideoCall => 'Mulai panggilan video';

  @override
  String get ctaSeeYourSubscription => 'Lihat langgananmu';

  @override
  String successProCaption(String price) {
    return '$price ditagih setiap bulan sampai kamu batalkan. Kelola atau batalkan kapan saja di toko.';
  }

  @override
  String successMaxCaption(String price) {
    return '$price ditagih setiap bulan sampai kamu batalkan. Kelola atau batalkan kapan saja di toko.';
  }

  @override
  String get plansErrorTitle => 'Tidak dapat memuat paket';

  @override
  String get plansErrorSub => 'Toko tidak merespons.';

  @override
  String get ctaTryAgain => 'Coba lagi';

  @override
  String get plansErrorCaption => 'Tidak ada tagihan.';

  @override
  String get changePlanTitle => 'Ubah Paket';

  @override
  String get moveToMaxTitle => 'Pindah ke Max';

  @override
  String maxPriceShort(String price) {
    return '$price / bln';
  }

  @override
  String get moveToMaxCardSub =>
      'Panggilan video tatap muka · semua karakter · buku belajar khusus untukmu';

  @override
  String get whatHappensNow => 'Apa yang terjadi sekarang';

  @override
  String get maxStartsLabel => 'Max dimulai';

  @override
  String get immediately => 'Segera';

  @override
  String get unusedProTime => 'Sisa waktu Pro';

  @override
  String get creditedTowardMax => 'Dikreditkan ke Max';

  @override
  String nextPaymentMaxValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String nextPaymentProValue(String price, String date) {
    return '$price · $date';
  }

  @override
  String get ctaSwitchToMax => 'Beralih ke Max';

  @override
  String get upgradeCaption =>
      'Paket barumu langsung aktif. Sisa waktu Pro dikreditkan, tidak pernah ditagih dua kali.';

  @override
  String get moveToProTitle => 'Pindah ke Pro';

  @override
  String get moveToProSub =>
      'Tidak ada yang berubah hari ini. Max berjalan sampai akhir bulan yang sudah kamu bayar.';

  @override
  String get maxRunsUntil => 'Max berjalan sampai';

  @override
  String get proStarts => 'Pro dimulai';

  @override
  String get whatYouKeep => 'Yang tetap kamu miliki';

  @override
  String get keepBenefitCalls =>
      'Panggilan suara tanpa batas, 15 menit per panggilan';

  @override
  String get keepBenefitCharacters =>
      'Karakter yang kamu beli jadi milikmu selamanya';

  @override
  String downgradeWarning(String date) {
    return 'Panggilan video dan karakter khusus Max nonaktif pada $date.';
  }

  @override
  String get ctaSwitchToPro => 'Beralih ke Pro';

  @override
  String get ctaKeepMax => 'Pertahankan Max';

  @override
  String get winbackSkip => 'Lewati';

  @override
  String get winbackTitle => 'Paket Pro-mu berakhir';

  @override
  String get winbackSub => 'Sekarang kamu di Gratis — satu panggilan per hari.';

  @override
  String get winbackQuestion => 'Boleh tahu kenapa kamu berhenti?';

  @override
  String get winbackReasonExpensive => 'Terlalu mahal';

  @override
  String get winbackReasonUnused => 'Jarang kupakai';

  @override
  String get winbackReasonMissing => 'Fitur yang kubutuhkan tidak ada';

  @override
  String get winbackReasonOtherApp => 'Aku menemukan aplikasi lain';

  @override
  String get winbackReasonElse => 'Alasan lain';

  @override
  String get ctaSend => 'Kirim';

  @override
  String get ctaNotNow => 'Nanti saja';

  @override
  String get winbackCaption =>
      'Ini tidak memulihkan paketmu. Berlangganan lagi di toko.';

  @override
  String get ctaContinue => 'Lanjutkan';

  @override
  String get ctaClose => 'Tutup';

  @override
  String get ovRestoreSuccessTitle => 'Pro kembali';

  @override
  String get ovRestoreSuccessBody =>
      'Kami menemukan langgananmu dan mengaktifkannya lagi di perangkat ini.';

  @override
  String get ovRestoreEmptyTitle => 'Tidak ada yang dipulihkan';

  @override
  String get ovRestoreEmptyBody =>
      'Tidak ada langganan aktif yang tertaut ke akun toko ini.';

  @override
  String get ovRestoreOtherTitle => 'Paket itu milik akun lain';

  @override
  String get ovRestoreOtherBody =>
      'Langganan ini sudah aktif di akun BeaverTalk yang berbeda.';

  @override
  String get ctaSignInThatAccount => 'Masuk ke akun itu';

  @override
  String get ctaGetHelp => 'Minta bantuan';

  @override
  String get ovCharacterOfferTitle => 'Belum siap untuk Pro?';

  @override
  String get ovCharacterOfferBody =>
      'Pilih satu karakter dan miliki selamanya. Pembelian satu kali — tanpa langganan, tanpa perpanjangan.';

  @override
  String get rowOneCharacter => 'Satu karakter';

  @override
  String rowFromPrice(String price) {
    return 'mulai $price';
  }

  @override
  String get rowYoursForever => 'Milikmu selamanya';

  @override
  String get rowNoRenewal => 'Tanpa perpanjangan';

  @override
  String get rowWorksOnFree => 'Berlaku di Gratis';

  @override
  String get rowYes => 'Ya';

  @override
  String get ctaSeeCharacters => 'Lihat karakter';

  @override
  String get ovNotEligibleTitle => 'Tidak ada yang dibatalkan';

  @override
  String get ovNotEligibleBody =>
      'Kamu di paket Gratis. Tidak ada langganan aktif di akun ini.';

  @override
  String get ovCancelDownsellTitle => 'Sebelum kamu pergi';

  @override
  String get ovCancelDownsellBody =>
      'Pembatalan dilakukan di toko. Dua hal yang perlu kamu tahu.';

  @override
  String get rowPayYearlyInstead => 'Bayar tahunan saja';

  @override
  String rowYearlyMonthEquiv(String price) {
    return '$price per bulan';
  }

  @override
  String get rowCharactersYouBought => 'Karakter yang kamu beli';

  @override
  String get rowProRunsUntil => 'Pro berjalan sampai';

  @override
  String get ctaSwitchToYearly => 'Beralih ke tahunan';

  @override
  String get ctaContinueToStore => 'Lanjutkan ke toko';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Bayar tahunan, hemat $saved';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Kamu sudah dua bulan di Pro. Paket tahunan jatuhnya lebih murah.';

  @override
  String get rowYouSave => 'Kamu hemat';

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
  String get ovMonthlySwitchTitle => 'Beralih ke bulanan';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Paket tahunanmu berjalan sampai $date. Tagihan bulanan dimulai sehari setelahnya.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Tagihan bulanan dimulai';

  @override
  String get rowMonthlyLabel => 'Bulanan';

  @override
  String get rowYearlyWorkedOut => 'Tahunan setara dengan';

  @override
  String get ctaSwitchToMonthly => 'Beralih ke bulanan';

  @override
  String get ovRefundHelpTitle => 'Refund ditangani oleh toko';

  @override
  String get ovRefundHelpBody =>
      'Kami tidak bisa memberikan refund sendiri. Setiap permintaan ditinjau oleh toko.';

  @override
  String get ctaGoToStore => 'Buka toko';

  @override
  String get ovTrialEndingTitle => 'Uji cobamu berakhir besok';

  @override
  String get ovTrialEndingBody =>
      'Max tetap berjalan kecuali kamu batalkan. Ini yang akan terjadi.';

  @override
  String get rowTrialEnds => 'Uji coba berakhir';

  @override
  String get rowFirstCharge => 'Tagihan pertama';

  @override
  String get rowThenMonthly => 'Lalu setiap bulan';

  @override
  String get ctaCancelInStore => 'Batalkan di toko';

  @override
  String get ovTrialStartTitle => '7 hari Max, gratis';

  @override
  String ovTrialStartBody(String price, String date) {
    return 'Gratis sampai $date. Setelah itu $price per bulan, kecuali kamu batalkan di toko.';
  }

  @override
  String get ctaStart7Days => 'Mulai 7 hari gratis';

  @override
  String get ovOtoTitle => 'Satu hal lagi sebelum kamu mulai';

  @override
  String get ovOtoBody =>
      'Pilihan tepat — panggilan tanpa batas sudah aktif. Pro yang sama lebih murah jika bayar tahunan.';

  @override
  String get ovFailedDeclinedTitle => 'Kartumu ditolak';

  @override
  String get ovFailedDeclinedBody =>
      'Toko tidak dapat memproses pembayaran. Tidak ada tagihan.';

  @override
  String get ctaUpdatePaymentMethod => 'Perbarui metode pembayaran';

  @override
  String get ovFailedCanceledTitle => 'Pembayaran dibatalkan';

  @override
  String get ovFailedCanceledBody => 'Kamu masih di Gratis. Tidak ada tagihan.';

  @override
  String get ovFailedStoreTitle => 'Terjadi kesalahan';

  @override
  String get ovFailedStoreBody =>
      'Kami tidak dapat menghubungi toko. Tidak ada tagihan.';

  @override
  String get ovAlreadyTitle => 'Kamu sudah di Pro';

  @override
  String get ovAlreadyBody =>
      'Akun toko ini punya paket aktif. Tidak ada yang perlu dibeli.';

  @override
  String get ctaSeeMySubscription => 'Lihat langgananku';

  @override
  String get subCancelTitle => 'Batalkan langganan';

  @override
  String subCancelBody(String date) {
    return 'Pro berjalan sampai $date. Setelah itu kamu beralih ke Gratis.';
  }

  @override
  String get subWhatYouLose => 'Yang akan hilang';

  @override
  String get benefitCalls15 => 'Panggilan tanpa batas, 15 menit per panggilan';

  @override
  String get benefitScoring => 'Pengucapan dinilai huruf demi huruf';

  @override
  String get benefitEveryCharacter => 'Semua karakter, tanpa batas';

  @override
  String get ctaKeepPro => 'Pertahankan Pro';

  @override
  String get subPaymentTitle => 'Perbarui pembayaran';

  @override
  String get subPaymentBody =>
      'Kami tidak dapat memproses pembayaran. Pro tetap berjalan selama masa tenggang.';

  @override
  String get subHowToFix => 'Cara memperbaikinya';

  @override
  String get fixStep1 => 'Buka toko dan perbarui metode pembayaranmu';

  @override
  String get fixStep2 => 'Kembali lagi — paketmu otomatis berlanjut';

  @override
  String get fixStep3 => 'Tidak ada tagihan ganda';

  @override
  String get subResubTitle => 'Berlangganan lagi';

  @override
  String subResubBody(String date) {
    return 'Pro berakhir pada $date. Aktifkan lagi perpanjangan otomatis dan tidak ada yang berubah.';
  }

  @override
  String get subWhatYouKeep => 'Yang tetap kamu miliki';

  @override
  String get ctaTurnItBackOn => 'Aktifkan lagi';

  @override
  String get flTodayTitle => 'Itu panggilan hari ini';

  @override
  String get flTodayBody => 'Lanjutkan dari terakhir kali — sekarang juga.';

  @override
  String get flCheckTitle => 'Itu cek hari ini';

  @override
  String get flCheckBody =>
      'Satu cek per hari di Gratis. Pro membuatnya tanpa batas.';

  @override
  String get flBenefitCalls =>
      'Panggilan tanpa batas dengan Pro · 15 menit per panggilan';

  @override
  String get flBenefitChecks => 'Cek pengucapan tanpa batas dengan Pro';

  @override
  String flCaption(String price) {
    return '$price per bulan · batalkan kapan saja';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used dari $limit terpakai';
  }

  @override
  String get ctaMaybeTomorrow => 'Mungkin besok';

  @override
  String get accountSection => 'Akun';

  @override
  String get nicknameLabel => 'Nama panggilan';

  @override
  String get emailLabel => 'Email';

  @override
  String get loginMethodLabel => 'Metode masuk';

  @override
  String get joinedLabel => 'Bergabung';

  @override
  String get editNicknameTitle => 'Ubah Nama Panggilan';

  @override
  String get nicknameRule =>
      '2–12 karakter. Huruf dan angka. Hanya bahasa Inggris';

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
  String get paywallLeaveTitle =>
      'Kalau keluar sekarang, kamu belum berlangganan';

  @override
  String get paywallLeaveBody =>
      'Manfaatmu terbuka langsung setelah pembayaran. Kamu bisa kembali kapan saja dari Halaman saya.';

  @override
  String get ctaKeepLooking => 'Lanjut lihat';

  @override
  String get ctaLeaveAnyway => 'Tetap keluar';

  @override
  String get iapCharacterSuccessTitle => 'Teman baru bergabung!';

  @override
  String get iapCharacterSuccessBody =>
      'Karakter ini milikmu selamanya — tetap ada meski paket berubah, dan Pulihkan pembelian mengembalikannya di perangkat mana pun.';

  @override
  String get iapCharacterFailedBody =>
      'Pembelian tidak berhasil. Tidak ada tagihan — silakan coba lagi.';

  @override
  String get noAccentDataTitle => 'Belum ada data intonasi';

  @override
  String get noAccentDataBody =>
      'Terus mengobrol agar pola intonasimu terkumpul.';

  @override
  String get noLevelYetTitle => 'Belum ada level';

  @override
  String get noLevelYetBody =>
      'Selesaikan panggilan pertamamu untuk mendapat level.';

  @override
  String get noPronunciationDataTitle => 'Belum ada rekaman pelafalan';

  @override
  String get noPronunciationDataBody =>
      'Kami menganalisis pelafalan dari kalimat yang kamu ucapkan saat menelepon.';

  @override
  String get noCharacterNote => 'Belum ada pesan';

  @override
  String get noPhonemesYet => 'Belum ada bunyi untuk dianalisis';

  @override
  String get noSentencesYet => 'Belum ada kalimat untuk dianalisis';

  @override
  String get takeLevelTest => 'Ikuti tes level';

  @override
  String get reviewToSeeScore => 'Ulas kembali untuk melihat skor pelafalanmu';

  @override
  String get playAgain => 'Main lagi';

  @override
  String get difficultySlow => 'Lambat';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Cepat';

  @override
  String get difficultyLabel => 'Tingkat kesulitan';

  @override
  String get connected => 'Terhubung';

  @override
  String get unlockedWithMax => 'Tersedia dengan Max';

  @override
  String get fcEndedTitle => 'Panggilan gratis kamu sudah berakhir';

  @override
  String get fcEndedBody =>
      'Panggilan gratis berlangsung hingga 5 menit\nBerlangganan untuk mengobrol lebih lama';

  @override
  String get ctaSubscribeKeepTalking => 'Berlangganan dan lanjut mengobrol';

  @override
  String get kgTitle => 'Lanjut?';

  @override
  String get kgBody =>
      'Panggilan berlanjut dalam sesi 5 menit.\nKami akan bertanya lagi setiap kali.';

  @override
  String get ctaKeepTalking => 'Lanjut mengobrol';
}
