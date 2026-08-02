// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String callEndedDuration(String duration) {
    return 'Arama sona erdi $duration';
  }

  @override
  String get callRatingPrompt => 'Arama nasıldı?';

  @override
  String get ratingBad => 'İyi değildi';

  @override
  String get ratingOkay => 'Fena değil';

  @override
  String get ratingGood => 'İyi';

  @override
  String get goHome => 'Ana Sayfa';

  @override
  String get viewAnalysis => 'Analizi Görüntüle';

  @override
  String get loadingShort => 'Yükleniyor…';

  @override
  String ratingSubmitFailed(String message) {
    return 'Değerlendirme gönderilemedi: $message';
  }

  @override
  String get callInfoNotFound => 'Arama bilgisi bulunamadı, analiz atlanıyor.';

  @override
  String get tabRecords => 'Kayıtlar';

  @override
  String get tabArchive => 'Arşiv';

  @override
  String get callHistory => 'Arama Geçmişi';

  @override
  String get conversationRecord => 'Konuşma kaydı';

  @override
  String get noCallRecords => 'Henüz arama kaydı yok';

  @override
  String get noCallRecordsBody =>
      'Yapay zeka ile ilk aramanı tamamladığında,\nkayıtların burada görünecek.';

  @override
  String get startCall => 'Aramaya Başla';

  @override
  String get recordsLoadError => 'Kayıtlar yüklenemedi';

  @override
  String get tryAgainLater => 'Lütfen daha sonra tekrar deneyin.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String durationMinSec(int minutes, int seconds) {
    return '$minutes dk $seconds sn';
  }

  @override
  String get scheduleManagement => 'Program';

  @override
  String get alarms => 'Alarmlar';

  @override
  String get addSchedule => 'Program Ekle';

  @override
  String get editSchedule => 'Programı Düzenle';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti';

  @override
  String get alarmsLoadError => 'Alarmlar yüklenemedi';

  @override
  String get charactersLoadError => 'Karakterler yüklenemedi';

  @override
  String get noCharacters => 'Kullanılabilir karakter yok';

  @override
  String get close => 'Kapat';

  @override
  String get repeat => 'Tekrarla';

  @override
  String get callPartner => 'Karakter';

  @override
  String get quickStart => 'Hızlı başlangıç';

  @override
  String get presetMorning => 'Sabah rutini';

  @override
  String get presetMorningSub => 'Hafta içi 8:00';

  @override
  String get presetEvening => 'Akşam kapanışı';

  @override
  String get presetEveningSub => 'Her gün 21:00';

  @override
  String get presetCustom => 'Özel';

  @override
  String get presetCustomSub => 'Kendine göre';

  @override
  String alarmSummary(int count, int monthly) {
    return 'Haftada $count× · ayda $monthly görüşme';
  }

  @override
  String get alarmSummaryNone => 'En az bir gün seçin';

  @override
  String get partnerInUse => 'Kullanımda';

  @override
  String get partnerOwned => 'Sahip olunan';

  @override
  String get am => 'ÖÖ';

  @override
  String get pm => 'ÖS';

  @override
  String get save => 'Kaydet';

  @override
  String get conversation => 'Konuşma';

  @override
  String get review => 'İnceleme';

  @override
  String get pronunciationChallenge => 'Telaffuz Mücadelesi';

  @override
  String get newExpressions => 'Yeni İfadeler';

  @override
  String get analysisResult => 'Analiz Sonucu';

  @override
  String get noNewExpressions => 'Bu konuşmadan yeni ifade çıkmadı.';

  @override
  String get practice => 'Pratik';

  @override
  String recentScore(int score) {
    return 'Son puan $score%';
  }

  @override
  String callSequence(int count) {
    return '$count. görüşme';
  }

  @override
  String characterNoteTitle(String name) {
    return '$name bir şey söylüyor';
  }

  @override
  String characterNoteFooter(String name) {
    return 'Görüşmeden hemen sonra $name tarafından bırakıldı';
  }

  @override
  String newExpressionsCount(int count) {
    return 'Yeni ifadeler $count';
  }

  @override
  String get analysisLoadError => 'Analiz sonucu yüklenemedi.';

  @override
  String get standardAudioNotReady =>
      'Standart telaffuz sesi henüz hazır değil.';

  @override
  String get standardAudioPlayError => 'Standart telaffuz sesi oynatılamadı.';

  @override
  String get selectNativeLanguage => 'Ana dilinizi seçin';

  @override
  String get selectYourLanguage => 'Dilinizi seçin';

  @override
  String get confirm => 'Onayla';

  @override
  String get cancel => 'İptal';

  @override
  String get selectTime => 'Saat seçin';

  @override
  String get getStarted => 'Başla';

  @override
  String get permissionTitle =>
      'Sorunsuz bir deneyim için\nizinlere izin verin';

  @override
  String get permissionSubtitle =>
      'Hizmeti kullanmak için gerekli izinler zorunludur.';

  @override
  String get permissionMicTitle => 'Mikrofon (zorunlu)';

  @override
  String get permissionMicDesc =>
      'Yapay zeka ile İngilizce konuşmak için gereklidir.';

  @override
  String get permissionNotifTitle => 'Bildirimler (isteğe bağlı)';

  @override
  String get permissionNotifDesc =>
      'Öğrenme hatırlatmaları ve arama programlarını size göndereceğiz.';

  @override
  String get micPermissionNeededTitle => 'Mikrofon erişimi gerekiyor';

  @override
  String get micPermissionNeededBody =>
      'Yapay zeka ile konuşmak için mikrofon erişimine izin vermeniz gerekir. Lütfen Ayarlar\'dan etkinleştirin.';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get connectionFailedTitle => 'Bağlantı başarısız';

  @override
  String get connectionFailedBody =>
      'Ağ bağlantınızı kontrol edin\nve tekrar deneyin.';

  @override
  String get checkout => 'Ödeme';

  @override
  String get pay => 'Öde';

  @override
  String get orderSummary => 'Sipariş Özeti';

  @override
  String get paymentMethod => 'Ödeme Yöntemi';

  @override
  String get payMethodCard => 'Kredi / Banka Kartı';

  @override
  String get payMethodKakao => 'KakaoPay';

  @override
  String get productName => 'Sinir Bozucu Kunduz Avatarı';

  @override
  String get productTrait => 'Premium karakter · Sonsuza dek sizin';

  @override
  String get amountItemPrice => 'Ürün fiyatı';

  @override
  String get amountDiscount => 'İndirim';

  @override
  String get amountTotal => 'Toplam';

  @override
  String get paymentCompleteTitle => 'Ödeme tamamlandı';

  @override
  String get paymentCompleteBody => 'Avatar koleksiyonunuza eklendi.';

  @override
  String get viewCollection => 'Koleksiyonu Görüntüle';

  @override
  String get receiptItem => 'Ürün';

  @override
  String get receiptAmount => 'Tutar';

  @override
  String get receiptMethod => 'Ödeme yöntemi';

  @override
  String get receiptDate => 'Tarih';

  @override
  String get paymentFailedTitle => 'Ödeme başarısız';

  @override
  String get paymentFailedBody =>
      'Ödemeniz gerçekleştirilemedi.\nLütfen tekrar deneyin.';

  @override
  String get freeCallEndingTitle => 'Ücretsiz aramanız sona eriyor';

  @override
  String get freeCallEndingBody =>
      'Kunduz ile daha uzun konuşmak için abone olun.';

  @override
  String get subscribe => 'Abone Ol';

  @override
  String get endCall => 'Aramayı Sonlandır';

  @override
  String get callEnded => 'Arama sona erdi.';

  @override
  String get connecting => 'Bağlanıyor…';

  @override
  String get connectingHint => 'Bu genellikle 5 saniyeden az sürer';

  @override
  String get callConnectFailed => 'Arama bağlanamadı.';

  @override
  String get saveSentenceFailed => 'Cümle kaydedilemedi.';

  @override
  String get recordStartFailed => 'Kayıt başlatılamadı.';

  @override
  String get recordTooShort => 'Bu kayıt çok kısaydı. Lütfen tekrar deneyin.';

  @override
  String get gradingFailed => 'Puanlama başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get listenStandard => 'Standart telaffuzu dinle';

  @override
  String get saveSentence => 'Cümleyi kaydet';

  @override
  String get unsaveSentence => 'Kaydedilen cümleyi kaldır';

  @override
  String get scoringPronunciation => 'Telaffuzunuz puanlanıyor…';

  @override
  String get analyzingByWord => 'Telaffuzunuz kelime kelime kontrol ediliyor';

  @override
  String get analyzingTakingLonger => 'Bu biraz daha uzun sürüyor';

  @override
  String get scanConnectionLost => 'Bağlantı koptu';

  @override
  String get noRecordingToPlay => 'Oynatılacak kayıt yok.';

  @override
  String get myRecordingPlayError => 'Kaydınız oynatılamadı.';

  @override
  String get next => 'İleri';

  @override
  String get endLearning => 'Oturumu Bitir';

  @override
  String get navCalendar => 'Takvim';

  @override
  String get navCall => 'Arama';

  @override
  String get navStats => 'İstatistikler';

  @override
  String get myPage => 'Sayfam';

  @override
  String get languageSaveFailed => 'Diliniz kaydedilemedi.';

  @override
  String get accountDeleteFailed => 'Hesabınız silinemedi.';

  @override
  String get changeAvatar => 'Avatarı Değiştir';

  @override
  String get avatarIntro =>
      'Ses ve zorluk seviyesi arama partnerine göre değişir.\nBazı partnerler ücretli olabilir.';

  @override
  String myPartnersOwned(int count) {
    return 'Partnerlerim · $count adet';
  }

  @override
  String get limitedDiscount => 'Sınırlı süreli indirim';

  @override
  String get available => 'Kullanılabilir';

  @override
  String get inUse => 'Kullanımda';

  @override
  String get owned => 'Sahip olunan';

  @override
  String get noCharactersToShow => 'Gösterilecek karakter yok';

  @override
  String get buy => 'Satın Al';

  @override
  String get noSavedSentences =>
      'Henüz kaydedilen cümle yok.\nKonuşma kayıtlarınızdan cümleleri yer imlerine ekleyin.';

  @override
  String get noAlarms => 'Henüz alarm yok';

  @override
  String get noAlarmsBody =>
      'Tutarlı bir alışkanlık oluşturmak için\nbir öğrenme hatırlatıcısı ekleyin.';

  @override
  String get subscriptionManage => 'Aboneliği Yönet';

  @override
  String get changePlan => 'Planı Değiştir';

  @override
  String get cancelSubscription => 'Aboneliği İptal Et';

  @override
  String get benefitsInUse => 'Ayrıcalıklarınız';

  @override
  String get paymentInfo => 'Ödeme bilgileri';

  @override
  String get nextBillingDate => 'Sonraki fatura tarihi';

  @override
  String get lostBenefitsTitle => 'İptal ederseniz kaybedeceğiniz ayrıcalıklar';

  @override
  String get viewBillingHistory => 'Fatura Geçmişini Görüntüle';

  @override
  String get keepUsingPro => 'Pro Kullanmaya Devam Et';

  @override
  String get proMembership => 'Pro Üyelik';

  @override
  String get pricePerMonth => '\$12,9 / ay';

  @override
  String get benefitUnlimitedCalls => 'Sınırsız arama';

  @override
  String get benefitDetailedAnalysis =>
      'Detaylı telaffuz ve dil bilgisi analizi';

  @override
  String get benefitAllCharacters => 'Tüm karakterlere erişim';

  @override
  String get benefitNoAds => 'Reklamsız';

  @override
  String get playSampleVoice => 'Örnek sesi çal';

  @override
  String get useThisAvatar => 'Bunu Kullan';

  @override
  String get challengeTitle => 'Telaffuz Mücadelesi';

  @override
  String get challengeIntro =>
      'Bölgedeki her kartı Korece doğru telaffuz ederek geçin.\nMikrofonunuz mu yok? Ekrana dokunarak da oynayabilirsiniz.';

  @override
  String get challengeStart => 'Kamera ve Mikrofonu Başlat';

  @override
  String get challengePermissionNote =>
      'Ön kamera ve mikrofon erişimi gereklidir (isteğe bağlı).';

  @override
  String get challengeLoadingTitle => 'Yükleniyor…';

  @override
  String get challengeLoadingNote =>
      'İlk çalıştırmada Korece konuşma modeli indiriliyor (~82MB).\nLütfen bir süre bekleyin.';

  @override
  String get challengeSttFallback =>
      'Konuşma tanıma kullanılamadığı için dokunma girişiyle oynadınız.';

  @override
  String get reasonTravelTitle => 'Seyahat ederken konuşma';

  @override
  String get reasonTravelDesc => 'Yerel halkla kendinden emin sohbet edin';

  @override
  String get reasonCareerTitle => 'İş ve kariyer';

  @override
  String get reasonCareerDesc => 'İş görüşmesi konuşması';

  @override
  String get reasonExamTitle => 'Sınav hazırlığı';

  @override
  String get reasonExamDesc => 'Konuşma sınavlarına hazırlanın';

  @override
  String get reasonDailyTitle => 'Günlük konuşma';

  @override
  String get reasonDailyDesc => 'Her gün kullandığınız ifadeler';

  @override
  String get reasonFriendsTitle => 'Yabancı arkadaşlar edinme';

  @override
  String get reasonFriendsDesc => 'Doğal konuşma';

  @override
  String get reasonBrainTitle => 'Zihinsel uyarım';

  @override
  String get reasonBrainDesc => 'Hafızayı ve odaklanmayı güçlendirin';

  @override
  String get challengeRecordToggle => 'Bu oturumu kaydet';

  @override
  String get challengeRecordHint =>
      'Oyununuzun videosunu paylaşmak üzere kaydeder (sessiz).';

  @override
  String get settingsSection => 'Ayarlar';

  @override
  String get paymentSection => 'Ödeme';

  @override
  String get supportSection => 'Destek';

  @override
  String get userLanguage => 'Kullanıcı Dili';

  @override
  String get learningLanguage => 'Öğrenilen Dil';

  @override
  String get learningLanguageKorean => 'Korece';

  @override
  String get notificationLabel => 'Bildirim';

  @override
  String get currentPlan => 'Mevcut Plan';

  @override
  String get paymentHistory => 'Ödeme Geçmişi';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String get termsOfService => 'Kullanım şartları';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get logOut => 'Çıkış yap';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountTitle => 'Hesap silinsin mi?';

  @override
  String get deleteAccountBody =>
      'Bu işlem hesabınızı ve verilerinizi kalıcı olarak siler ve geri alınamaz.';

  @override
  String get delete => 'Sil';

  @override
  String get share => 'Paylaş';

  @override
  String get accentSoundsLike => 'Korece aksanınız şöyle geliyor';

  @override
  String get hintLabel => 'İpucu';

  @override
  String get nextHint => 'Sonraki ipucu';

  @override
  String get translateLabel => 'Çevir';

  @override
  String get startRecording => 'Kaydı başlat';

  @override
  String get stopRecording => 'Kaydı durdur';

  @override
  String get back => 'Geri';

  @override
  String get onboardingNameTitle => 'Sana nasıl hitap edelim?';

  @override
  String get onboardingNameSubtitle =>
      'Yapay zeka eğitmenin adını hatırlayacak.';

  @override
  String get nameLabel => 'Adınız';

  @override
  String get nameHint => 'Adınızı girin';

  @override
  String get nameHelper =>
      'Gerçek adınız olması gerekmez — bir takma ad da işe yarar.';

  @override
  String get continueLabel => 'Devam Et';

  @override
  String get onboardingDoneTitle => 'Kunduz aramanı bekliyor';

  @override
  String get onboardingDoneSubtitle => 'Hemen bir arama başlat';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get callNow => 'Şimdi ara';

  @override
  String get pronunciation => 'Telaffuz';

  @override
  String get fluency => 'Akıcılık';

  @override
  String get rhythm => 'Ritim';

  @override
  String get analysisTimeout =>
      'Bu beklenenden uzun sürüyor. Lütfen biraz sonra tekrar deneyin.';

  @override
  String get analysisFailed =>
      'Konuşmayı analiz edemedik. Lütfen tekrar deneyin.';

  @override
  String get analyzingConversation => 'Konuşmanız analiz ediliyor…';

  @override
  String get analyzingSubtitle => 'Bu sadece bir an sürecek';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get nativeLabel => 'Anadil';

  @override
  String get meLabel => 'Ben';

  @override
  String get pronunciationPlayError => 'Telaffuz sesi oynatılamadı.';

  @override
  String get savedExpressionsLoadError =>
      'Kaydedilen ifadeleriniz yüklenemedi.';

  @override
  String get mySavedExpressions => 'Kaydedilen İfadelerim';

  @override
  String get avatarTraits => 'Sıcak · Sakin · Yumuşak';

  @override
  String get priceFree => 'Ücretsiz';

  @override
  String get loginGoogleTokenError => 'Google giriş jetonu alınamadı.';

  @override
  String get loginGoogleSignInFailed => 'Google ile giriş başarısız oldu.';

  @override
  String get loginAppleSignInFailed => 'Apple ile giriş başarısız oldu.';

  @override
  String get loginKakaoSignInFailed => 'Kakao ile giriş başarısız oldu.';

  @override
  String get loginContinueWithKakao => 'Kakao ile devam et';

  @override
  String get loginContinueWithGoogle => 'Google ile devam et';

  @override
  String get loginContinueWithApple => 'Apple ile devam et';

  @override
  String get loginContinueWithEmail => 'E-posta ile devam et';

  @override
  String get loginOrDivider => 'veya';

  @override
  String get loginNoAccount => 'Hesabınız yok mu?';

  @override
  String get signUp => 'Kaydol';

  @override
  String get loginTermsNoticePrefix => 'Devam ederek ';

  @override
  String get loginTermsNoticeAnd => ' ve ';

  @override
  String get loginTermsNoticeSuffix => '\'nı kabul etmiş olursunuz.';

  @override
  String get loginLogIn => 'Giriş yap';

  @override
  String get fieldEmailLabel => 'E-posta';

  @override
  String get emailHint => 'E-postanızı girin';

  @override
  String get fieldPasswordLabel => 'Şifre';

  @override
  String get passwordHint => 'Şifrenizi girin';

  @override
  String get loginRememberMe => 'Beni hatırla';

  @override
  String get loginForgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get loginLoggingIn => 'Giriş yapılıyor...';

  @override
  String get passwordLengthError => 'Şifre 8-16 karakter olmalıdır.';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor.';

  @override
  String get signupCheckInput => 'Lütfen girdinizi kontrol edin.';

  @override
  String get fieldConfirmPasswordLabel => 'Şifreyi onayla';

  @override
  String get confirmPasswordHint => 'Şifrenizi tekrar girin';

  @override
  String get signupSigningUp => 'Kaydolunuyor...';

  @override
  String get signupHaveAccount => 'Zaten bir hesabınız var mı?';

  @override
  String get passwordMethodEmailRequired => 'E-postanızı girin';

  @override
  String get passwordResetTitle => 'Şifreyi sıfırla';

  @override
  String get passwordMethodDescription =>
      'Şifre sıfırlama kodunu almak istediğiniz e-posta adresini girin.';

  @override
  String get emailAddressHint => 'E-posta adresi';

  @override
  String get passwordMethodSending => 'Gönderiliyor...';

  @override
  String get passwordMethodSendEmail => 'E-posta gönder';

  @override
  String get passwordCodeTitle => 'Kodu girin';

  @override
  String get passwordCodeDescription =>
      'E-postanıza bir kurtarma kodu gönderdik. Devam etmek için girin.';

  @override
  String get passwordCodeNoCode => 'Kodu almadınız mı?';

  @override
  String get passwordCodeResend => 'Kodu yeniden gönder';

  @override
  String get passwordCodeVerifying => 'Doğrulanıyor...';

  @override
  String get passwordNewTitle => 'Yeni şifre';

  @override
  String get passwordNewDescription =>
      'Hesabınız için yeni bir şifre belirleyin.';

  @override
  String get fieldNewPasswordLabel => 'Yeni şifre';

  @override
  String get newPasswordHint => 'Yeni şifrenizi girin';

  @override
  String get fieldConfirmNewPasswordLabel => 'Yeni şifreyi onayla';

  @override
  String get confirmNewPasswordHint => 'Yeni şifrenizi tekrar girin';

  @override
  String get passwordNewSubmitting => 'Gönderiliyor...';

  @override
  String get passwordNewSubmit => 'Gönder';

  @override
  String get passwordCompleteTitle => 'Şifre sıfırlama tamamlandı';

  @override
  String get passwordCompleteBody =>
      'Şifreniz sıfırlandı. Devam etmek için yeni şifrenizle giriş yapın.';

  @override
  String get termsTitle => 'Kullanım şartları';

  @override
  String get privacyTitle => 'Gizlilik politikası';

  @override
  String passwordNewDescriptionEmail(String email) {
    return '$email için yeni bir şifre belirleyin.';
  }

  @override
  String get selectComplete => 'Tamam';

  @override
  String get onboardingLanguageTitle => 'Ana diliniz nedir?';

  @override
  String get onboardingReasonTitle => 'Neden bir dil öğreniyorsunuz?';

  @override
  String get onboardingReasonSubtitle =>
      'Öğrenmenizi hedeflerinize göre uyarlayacağız.';

  @override
  String get savingLabel => 'Kaydediliyor...';

  @override
  String get payMethodApple => 'Apple Pay';

  @override
  String get thisMonthPayment => 'Bu ayki ödeme';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterSubscription => 'Abonelik';

  @override
  String get filterCharacter => 'Karakter';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get lastPayment => 'Son ödeme';

  @override
  String subscriptionSwitchNote(String date) {
    return 'Pro avantajlarını $date tarihine kadar kullanmaya devam edebilirsiniz; ardından planınız otomatik olarak Ücretsiz\'e geçer.';
  }

  @override
  String get freePlanCallLimit => 'Günde 1 görüşme · 5 dk sınır';

  @override
  String get freePlanBasicCharacters => 'Temel karakterler dahil';

  @override
  String get availableForPurchase => 'Satın alınabilir';

  @override
  String get paymentsLoadError => 'Ödeme geçmişi yüklenemedi';

  @override
  String get noPayments => 'Henüz ödeme yok';

  @override
  String get morePaymentsExist => 'Daha eski ödemeler henüz gösterilmiyor';

  @override
  String get undatedPayments => 'Tarihsiz';

  @override
  String get paymentLabelFallback => 'Ödeme';

  @override
  String learningPassed(int passed, int total) {
    return '$total cümleden $passed tanesi geçti';
  }

  @override
  String get hardestSound => 'Bugünün en zor sesi';

  @override
  String get soundAccuracy => 'Sese göre doğruluk';

  @override
  String phonemeAttempts(int count) {
    return 'Ses birimi başına · $count deneme';
  }

  @override
  String get colSound => 'Ses';

  @override
  String get colAttempts => 'Den.';

  @override
  String get colCorrect => 'Doğru';

  @override
  String get colAccuracy => 'Doğr.';

  @override
  String get sentenceResults => 'Cümleye göre sonuçlar';

  @override
  String viewAllSentences(int count) {
    return '$count tanesini gör';
  }

  @override
  String get colSentence => 'Cümle';

  @override
  String get colPronunciation => 'Telaf.';

  @override
  String get colFluency => 'Akıc.';

  @override
  String get colRhythm => 'Ritim';

  @override
  String recentSessions(int count) {
    return 'Son $count oturum';
  }

  @override
  String trendAverage(int score) {
    return 'Ort. $score';
  }

  @override
  String get today => 'Bugün';

  @override
  String get colDate => 'Tarih';

  @override
  String get colSentences => 'Cümle';

  @override
  String get colScore => 'Puan';

  @override
  String get colChange => 'Değ.';

  @override
  String dateToday(String date) {
    return '$date (bugün)';
  }

  @override
  String get accentAnalysis => 'Aksan analizi';

  @override
  String get overallLevel => 'Genel seviye';

  @override
  String get overallLevelSubtitle => 'Kelime · Dilbilgisi · İfadeler';

  @override
  String get pronunciationAnalysis => 'Telaffuz analizi';

  @override
  String get recentSessionsAverage => 'Son 10 oturum ort.';

  @override
  String levelStage(int stage) {
    return '$stage. seviye';
  }

  @override
  String topPercent(int percent) {
    return 'İlk $percent%';
  }

  @override
  String get allLearnersBasis => 'Tüm öğrenciler arasında';

  @override
  String aheadOfLearners(int percent) {
    return 'Öğrencilerin $percent%\'inden öndesin';
  }

  @override
  String get retakeLevelTest => 'Seviye testini tekrarla';

  @override
  String get practicePronunciation => 'Telaffuz çalış';

  @override
  String get priceChangedTitle => 'Price changed';

  @override
  String priceChangedBody(String price) {
    return 'This item is now $price. Would you like to continue?';
  }
}
