// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

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
  String get analysisLoadError => 'Tidak dapat memuat hasil analisis.';

  @override
  String get standardAudioNotReady => 'Audio pengucapan standar belum siap.';

  @override
  String get standardAudioPlayError =>
      'Tidak dapat memutar audio pengucapan standar.';

  @override
  String get selectACountry => 'Pilih negara';

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
  String get pricePerMonth => '\$12.9 / mo';

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
  String get loginContinueWithKakao => 'Lanjutkan dengan Kakao';

  @override
  String get loginContinueWithGoogle => 'Lanjutkan dengan Google';

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
