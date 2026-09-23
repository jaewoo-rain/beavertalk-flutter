// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get loginRequired => 'Giriş yapmanız gerekiyor.';

  @override
  String get callWebNotSupported =>
      'Sesli aramalar web\'de desteklenmiyor. Lütfen uygulamayı kullanın.';

  @override
  String get micPermissionRequiredForCall =>
      'Mikrofon izni gerekiyor. Arama yapmak için mikrofona izin verin.';

  @override
  String get callErrorGeneric => 'Arama sırasında bir hata oluştu.';

  @override
  String get callDailyLimit => 'Bugünkü öğrenme süreni doldurdun.';

  @override
  String get callAlreadyInCall => 'Zaten bir aramadasın.';

  @override
  String get callNetworkError => 'Ağ hatası oluştu.';

  @override
  String get authInvalidCredentials => 'E-posta veya şifre hatalı.';

  @override
  String get authEmailAlreadyRegistered => 'Bu e-posta zaten kayıtlı.';

  @override
  String get authConfirmEmailRequired =>
      'E-postanıza gönderilen doğrulamayı tamamlayın.';

  @override
  String get authResetCodeSent => 'Doğrulama kodunu e-postanıza gönderdik.';

  @override
  String get authResetCodeInvalid => 'Kod hatalı veya süresi dolmuş.';

  @override
  String get authPasswordUpdated => 'Şifreniz sıfırlandı.';

  @override
  String get authAppleTokenMissing => 'Apple giriş jetonu alınamadı.';

  @override
  String callEndedDuration(String duration) {
    return 'Arama sona erdi $duration';
  }

  @override
  String get callRatingPrompt => 'Arama nasıldı?';

  @override
  String get callRatingBody =>
      'Puanın bir dahaki sefere daha iyi konuşmamıza yardımcı olur.';

  @override
  String get callRatingSubmit => 'Gönder';

  @override
  String get callRatingSkip => 'Atla';

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
  String get alarmAdd => 'Alarm ekle';

  @override
  String get alarmEdit => 'Alarmı düzenle';

  @override
  String get alarmEveryDay => 'Her gün';

  @override
  String get alarmWeekdays => 'Hafta içi';

  @override
  String get alarmWeekend => 'Hafta sonu';

  @override
  String get alarmNoRepeat => 'Tekrar yok';

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
  String get alarmModeLearnSub => 'Müfredattaki ifadeleri çalış';

  @override
  String get alarmModeChatSub => 'Her şey hakkında konuş';

  @override
  String alarmRowSummary(String days, String mode) {
    return '$days, $mode';
  }

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
  String get newExpressions => 'Yeni İfadeler';

  @override
  String get analysisPrepNote => 'Bugünkü görüşme gözden geçiriliyor.';

  @override
  String get analysisPrepNoteHint => 'Birazdan burada bir not görünecek';

  @override
  String get analysisPrepTitle => 'Kunduz bugünkü ifadeleri karta dönüştürüyor';

  @override
  String get analysisPrepSub => 'Hazır olunca tam burada görünecek.';

  @override
  String get analysisPrepStepSave => 'Konuşmayı kaydetme';

  @override
  String get analysisPrepStepCards => 'İfade kartları hazırlama';

  @override
  String get analysisPrepStateDone => 'Tamam';

  @override
  String get analysisPrepStateWorking => 'Sürüyor';

  @override
  String get analysisPrepStateWaiting => 'Bekliyor';

  @override
  String get usedExpressions => 'Kullandığın ifadeler';

  @override
  String quizExpressionsCount(int count) {
    return 'Öğrendiğin ifadeler $count';
  }

  @override
  String get quizPassed => 'Bildin';

  @override
  String get quizFailed => 'Tekrar bak';

  @override
  String get quizPending => 'Bir dahaki sefere devam';

  @override
  String get analysisResult => 'Analiz Sonucu';

  @override
  String get noNewExpressions => 'Bu konuşmadan yeni ifade çıkmadı.';

  @override
  String get practice => 'Pratik';

  @override
  String get analysisNativeLabel => 'Yerli';

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
  String get homeCourseExpression => 'İfadeler';

  @override
  String get homeCourseFreetalk => 'Diyalog';

  @override
  String homeExpressionsLeft(int count) {
    return 'Diyaloğa $count ifade kaldı';
  }

  @override
  String get homeFreetalkNote => 'Öğrendiklerini kullanarak serbestçe konuş';

  @override
  String get homeTalkTitle => 'Bugün neler oldu?';

  @override
  String get homeTalkNote => 'Serbestçe sohbet et, konuşurken öğren.';

  @override
  String get homeModeLearn => 'Öğren';

  @override
  String get homeModeTalk => 'Sohbet';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün üst üste',
    );
    return '$_temp0';
  }

  @override
  String get streakCalendarTitle => 'Öğrenme takvimi';

  @override
  String streakDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'gün üst üste',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En iyi seri: $count gün',
    );
    return '$_temp0';
  }

  @override
  String get streakMetricCallTime => 'Arama süresi';

  @override
  String get streakMetricLearned => 'İfadeler';

  @override
  String get streakMetricWords => 'Söylenen kelimeler';

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
      other: '$count dk',
    );
    return '$_temp0';
  }

  @override
  String get streakNoCallsThatDay => 'Bu gün arama yok.';

  @override
  String get homeLevelPending => 'Seviye belirsiz';

  @override
  String get homeNoLevelTitle => 'Henüz bir seviyen yok';

  @override
  String get homeNoLevelNote => 'İlk aramanı tamamla, seviyen belirlensin';

  @override
  String get homeCurriculumPendingBadge => 'Yakında';

  @override
  String homeCurriculumPendingTitle(String language) {
    return '$language müfredatı hazırlanıyor';
  }

  @override
  String get homeCurriculumPendingNote =>
      'Aramalarında genel ifadeler çalışacaksın';

  @override
  String get myPage => 'Sayfam';

  @override
  String get languageSaveFailed => 'Diliniz kaydedilemedi.';

  @override
  String get accountDeleteFailed => 'Hesabınız silinemedi.';

  @override
  String get changeAvatar => 'Avatarı Değiştir';

  @override
  String get avatarUseNow => 'Şimdi kullan';

  @override
  String get avatarPurchaseFailed => 'Satın alma tamamlanmadı';

  @override
  String avatarPromoTitle(int percent) {
    return 'Sadece bugün · %$percent indirim';
  }

  @override
  String avatarPromoLeft(String time) {
    return '$time kaldı';
  }

  @override
  String avatarPromoLeftDays(int days, String time) {
    return '$days g $time kaldı';
  }

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
  String pricePerMonth(String price) {
    return '$price / ay';
  }

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
  String get challengeLoadingNote => 'Kamera ve mikrofon hazırlanıyor.';

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
  String get loginFacebookSignInFailed => 'Facebook ile giriş başarısız oldu.';

  @override
  String get loginKakaoSignInFailed => 'Kakao ile giriş başarısız oldu.';

  @override
  String get loginContinueWithKakao => 'Kakao ile devam et';

  @override
  String get loginContinueWithGoogle => 'Google ile devam et';

  @override
  String get loginContinueWithFacebook => 'Facebook ile devam et';

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
  String get freePlanCallLimit => 'Günde 5 dk görüşme';

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
  String get priceChangedTitle => 'Fiyat değişti';

  @override
  String priceChangedBody(String price) {
    return 'Bu ürün artık $price. Devam etmek ister misin?';
  }

  @override
  String get billingGroupPlanPurchases => 'Plan ve satın alımlar';

  @override
  String get billingGroupInTheStore => 'Mağazada';

  @override
  String get billingCompareAllPlans => 'Planları karşılaştır';

  @override
  String get billingBuyACharacter => 'Karakter satın al';

  @override
  String get billingRestorePurchases => 'Satın alımları geri yükle';

  @override
  String get billingRedeemCode => 'Kod kullan';

  @override
  String get billingPaymentHistory => 'Ödeme geçmişi';

  @override
  String get billingManageInTheStore => 'Mağazada yönet';

  @override
  String get billingRefundHelp => 'İade yardımı';

  @override
  String get billingCancelSubscription => 'Aboneliği iptal et';

  @override
  String get billingResubscribe => 'Yeniden abone ol';

  @override
  String get badgeCurrent => 'Mevcut';

  @override
  String get badgeTrial => 'Deneme';

  @override
  String get badgeRenewing => 'Yenileniyor';

  @override
  String get badgePastDue => 'Ödeme gecikti';

  @override
  String get badgePaused => 'Duraklatıldı';

  @override
  String get badgeCanceling => 'İptal ediliyor';

  @override
  String get subscriptionTitle => 'Abonelik';

  @override
  String get plansTitle => 'Planlar';

  @override
  String get planFree => 'Free';

  @override
  String get planPro => 'Pro';

  @override
  String get planMax => 'Premium';

  @override
  String get premiumBulletVideo => 'Günde 15 dakika görüntülü arama';

  @override
  String get premiumBulletAnalysis => 'Tam telaffuz analizi';

  @override
  String get premiumBulletWeakSounds => 'Dilin için zayıf ses alıştırmaları';

  @override
  String get noteCharactersSeparate =>
      'Karakterler ayrı satılır. Satın aldıkların senin kalır.';

  @override
  String get ctaGetPremium => 'Premium al';

  @override
  String get planMaxTrial => 'Premium deneme';

  @override
  String get freePlanPriceLine => '\$0.00 — günde 5 dakika arama';

  @override
  String pricePerMonthLine(String amount) {
    return 'Aylık $amount';
  }

  @override
  String freeUntilDate(String date) {
    return '$date tarihine kadar ücretsiz';
  }

  @override
  String get todaysCalls => 'Bugünkü arama süresi';

  @override
  String callsUsedOfLimit(int used, int limit) {
    return '$limit dakikanın $used dakikası kullanıldı';
  }

  @override
  String get firstPaymentLabel => 'İlk ödeme';

  @override
  String get nextPaymentLabel => 'Sonraki ödeme';

  @override
  String get retryingUntilLabel => 'Şu tarihe kadar yeniden denenecek';

  @override
  String get pausedSinceLabel => 'Duraklatılma tarihi';

  @override
  String planEndsLabel(String plan) {
    return '$plan sona eriyor';
  }

  @override
  String get bannerMaxUpsellTitle => 'Premium ile yüz yüze konuş';

  @override
  String bannerMaxUpsellSub(String price) {
    return 'Görüntülü arama · günde 15 dakika · aylık $price';
  }

  @override
  String get bannerAnnualSwitchTitle => 'Yıllık plana geç';

  @override
  String get bannerPaymentFailedTitle => 'Ödemeyi alamadık';

  @override
  String get bannerPaymentFailedSub =>
      'Premium\'u korumak için mağazadan ödeme yöntemini güncelle';

  @override
  String get bannerPausedTitle => 'Planın duraklatıldı';

  @override
  String get bannerPausedSub => 'Ödeme gerçekleşmedi';

  @override
  String get noteRestoreHint =>
      'Başka bir cihazda zaten abone misin? Geri yükleme aboneliği bu cihaza getirir.';

  @override
  String get noteStoreHandled =>
      'Ödeme yöntemi, plan değişiklikleri ve iptal işlemleri mağaza üzerinden yapılır.';

  @override
  String noteTrialEnds(String date) {
    return 'Denemen $date tarihinde bitiyor. Öncesinde mağazadan iptal edersen hiçbir ücret alınmaz.';
  }

  @override
  String get noteGrace =>
      'Ek süre boyunca avantajların devam eder. İptal, uygulama içinde asla engellenmez.';

  @override
  String get noteHold =>
      'Ödeme gerçekleşene kadar Premium duraklatıldı. Karakterlerin ve ilerlemen güvende.';

  @override
  String noteEnding(String date) {
    return 'Planın sona erecek şekilde ayarlandı. Avantajların $date tarihine kadar sürer, sonra Free\'ye geçersin. İstediğin zaman yeniden abone olabilirsin.';
  }

  @override
  String get trialExpiredTitle => 'Premium denemen sona erdi';

  @override
  String get trialExpiredSub => 'Artık Free plandasın';

  @override
  String get seePlans => 'Planları gör';

  @override
  String get currentPlanTitle => 'Mevcut Plan';

  @override
  String get perMonthUnit => 'aylık';

  @override
  String get planTaglineMax => 'Artık onları görebilirsin.';

  @override
  String get planTaglineFree => 'Günde 5 dakika arama. Bizden.';

  @override
  String get bulletProCorrections => 'Ana diline göre düzeltmeler';

  @override
  String get bulletFreeCall => 'Günde 5 dakika sesli arama';

  @override
  String get bulletFreeCheck => 'İlk 3 araman için tam analiz';

  @override
  String get bulletFreeCharacter => 'Başlangıç için iki karakter';

  @override
  String get ctaTurnOnVideo => 'Videoyu aç';

  @override
  String get noteCallLength =>
      'Premium: günde 15 dakika — bu süre içinde istediğin kadar arayabilirsin.';

  @override
  String get paywallProTitle1 => 'Gece 3\'te bile ayakta olan';

  @override
  String get paywallProTitle2 => 'Koreli arkadaşın';

  @override
  String get paywallLimitHeadline =>
      'Premium ile günde 15 dakika arama yapabilirsin.';

  @override
  String get limitBannerCallTitle => 'Bugünkü arama süren doldu';

  @override
  String get limitBannerCallSub => 'Free günde 5 dakika arama verir';

  @override
  String get limitBannerCheckTitle => 'Bugünkü kontrolün buydu';

  @override
  String get limitBannerCheckSub => 'Free günde bir kontrol verir';

  @override
  String get bulletProCharactersForever =>
      'Satın aldığın karakterler sonsuza dek senin';

  @override
  String get paywallMaxTitle => 'Artık onları görebilirsin.';

  @override
  String paywallTutorCompare(String price) {
    return 'Bir öğretmenle bir saat \$25. Bir aylık Premium $price.';
  }

  @override
  String get planMonthly => 'Aylık';

  @override
  String get planAnnual => 'Yıllık';

  @override
  String proMonthlyPriceLine(String price) {
    return 'Aylık $price';
  }

  @override
  String proAnnualPriceLine(String yearly, String perMonth) {
    return '$yearly · aylık $perMonth';
  }

  @override
  String maxMonthlyPriceLine(String price) {
    return 'Aylık $price';
  }

  @override
  String maxAnnualPriceLine(String yearly, String perMonth) {
    return 'Yılda $yearly · aylık $perMonth';
  }

  @override
  String ctaCaptionPro(String price) {
    return 'Aylık $price · istediğin zaman mağazadan iptal et';
  }

  @override
  String ctaCaptionMax(String price) {
    return 'Aylık $price · istediğin zaman mağazadan iptal et';
  }

  @override
  String ctaCaptionMaxTrial(String price) {
    return '7 gün ücretsiz, sonra Aylık $price · istediğin zaman mağazadan iptal et';
  }

  @override
  String get ctaCaptionAutoRenew =>
      'İptal edene kadar otomatik olarak yenilenir.';

  @override
  String get footerTerms => 'Koşullar';

  @override
  String get footerPrivacy => 'Gizlilik';

  @override
  String get processingTitle => 'Satın alma onaylanıyor';

  @override
  String get processingSub => 'Bu genellikle birkaç saniye sürer.';

  @override
  String get successProTitle => 'Artık Premium\'dasın.';

  @override
  String get successMaxTitle => 'Artık onları görebilirsin.';

  @override
  String get successMaxSub =>
      'Görüntülü aramalar açık. Herhangi bir aramada video düğmesine dokun.';

  @override
  String get ctaStartAVideoCall => 'Görüntülü arama başlat';

  @override
  String get ctaSeeYourSubscription => 'Aboneliğini gör';

  @override
  String successMaxCaption(String price) {
    return 'İptal edene kadar aylık $price tahsil edilir. İstediğin zaman mağazadan yönet veya iptal et.';
  }

  @override
  String get plansErrorTitle => 'Planları yükleyemedik';

  @override
  String get plansErrorSub => 'Mağaza yanıt vermedi.';

  @override
  String get ctaTryAgain => 'Tekrar dene';

  @override
  String get plansErrorCaption => 'Hiçbir ücret alınmadı.';

  @override
  String get ctaKeepMax => 'Premium\'da kal';

  @override
  String get winbackSkip => 'Atla';

  @override
  String get winbackTitle => 'Premium planın sona erdi';

  @override
  String get winbackSub => 'Artık Free\'desin — günde 5 dakika arama.';

  @override
  String get winbackQuestion => 'Neden ayrıldığını söyler misin?';

  @override
  String get winbackReasonExpensive => 'Çok pahalı';

  @override
  String get winbackReasonUnused => 'Yeterince kullanmıyordum';

  @override
  String get winbackReasonMissing => 'İhtiyacım olan bir özellik eksikti';

  @override
  String get winbackReasonOtherApp => 'Başka bir uygulama buldum';

  @override
  String get winbackReasonElse => 'Başka bir neden';

  @override
  String get ctaSend => 'Gönder';

  @override
  String get ctaNotNow => 'Şimdi değil';

  @override
  String get winbackCaption =>
      'Bu, planını geri getirmez. Mağazadan yeniden abone olabilirsin.';

  @override
  String get ctaContinue => 'Devam et';

  @override
  String get ctaClose => 'Kapat';

  @override
  String get ovRestoreSuccessTitle => 'Premium geri döndü';

  @override
  String get ovRestoreSuccessBody =>
      'Aboneliğini bulduk ve bu cihazda yeniden etkinleştirdik.';

  @override
  String get ovRestoreEmptyTitle => 'Geri yüklenecek bir şey yok';

  @override
  String get ovRestoreEmptyBody =>
      'Bu mağaza hesabına bağlı etkin bir abonelik yok.';

  @override
  String get ovRestoreOtherTitle => 'Bu plan başka bir hesaba ait';

  @override
  String get ovRestoreOtherBody =>
      'Bu abonelik zaten farklı bir BeaverTalk hesabında etkin.';

  @override
  String get ctaSignInThatAccount => 'O hesapla giriş yap';

  @override
  String get ctaGetHelp => 'Yardım al';

  @override
  String get ovCharacterOfferTitle => 'Premium için hazır değil misin?';

  @override
  String get ovCharacterOfferBody =>
      'Bir karakter seç, senin olsun. Tek seferlik satın alma — abonelik yok, yenileme yok.';

  @override
  String get rowOneCharacter => 'Bir karakter';

  @override
  String rowFromPrice(String price) {
    return 'tanesi $price';
  }

  @override
  String get rowYoursForever => 'Sonsuza dek senin';

  @override
  String get rowNoRenewal => 'Yenileme yok';

  @override
  String get rowWorksOnFree => 'Free\'de çalışır';

  @override
  String get rowYes => 'Evet';

  @override
  String get ctaSeeCharacters => 'Karakterleri gör';

  @override
  String get ovNotEligibleTitle => 'İptal edilecek bir şey yok';

  @override
  String get ovNotEligibleBody =>
      'Free plandasın. Bu hesapta etkin bir abonelik yok.';

  @override
  String get ovCancelDownsellTitle => 'Gitmeden önce';

  @override
  String get ovCancelDownsellBody =>
      'İptal mağazada yapılır. Bilmen gereken iki şey var.';

  @override
  String get rowPayYearlyInstead => 'Bunun yerine yıllık öde';

  @override
  String rowYearlyMonthEquiv(String price) {
    return 'Aylık $price';
  }

  @override
  String get rowCharactersYouBought => 'Satın aldığın karakterler';

  @override
  String get rowProRunsUntil => 'Premium şu tarihe kadar sürer';

  @override
  String get ctaSwitchToYearly => 'Yıllığa geç';

  @override
  String get ctaContinueToStore => 'Mağazaya devam et';

  @override
  String ovAnnualSwitchTitle(String saved) {
    return 'Yıllık öde, $saved kazan';
  }

  @override
  String get ovAnnualSwitchBody =>
      'Yıllık plan, aylık ödemekten daha ucuza gelir.';

  @override
  String get rowYouSave => 'Tasarrufun';

  @override
  String amountSaved(String price) {
    return '$price';
  }

  @override
  String get rowYearly => 'Yıllık';

  @override
  String amountYearly(String price) {
    return '$price';
  }

  @override
  String get rowMonthlyForYear => 'Bir yıl boyunca aylık';

  @override
  String amountMonthlyForYear(String price) {
    return '$price';
  }

  @override
  String get ovMonthlySwitchTitle => 'Aylığa geç';

  @override
  String ovMonthlySwitchBody(String date) {
    return 'Yıllık planın $date tarihine kadar sürüyor. Aylık faturalandırma ertesi gün başlar.';
  }

  @override
  String get rowMonthlyBillingStarts => 'Aylık faturalandırma başlar';

  @override
  String get rowMonthlyLabel => 'Aylık';

  @override
  String get rowYearlyWorkedOut => 'Yıllık plan şuna denk geliyordu';

  @override
  String get ctaSwitchToMonthly => 'Aylığa geç';

  @override
  String get ovRefundHelpTitle => 'İadeler mağaza tarafından yapılır';

  @override
  String get ovRefundHelpBody =>
      'İadeleri kendimiz yapamayız. Her talep mağaza tarafından incelenir.';

  @override
  String get ctaGoToStore => 'Mağazaya git';

  @override
  String get ovTrialEndingTitle => 'Denemen yarın bitiyor';

  @override
  String get ovTrialEndingBody =>
      'İptal etmezsen Premium devam eder. Olacaklar şöyle.';

  @override
  String get rowTrialEnds => 'Deneme bitişi';

  @override
  String get rowFirstCharge => 'İlk ücret';

  @override
  String get rowThenMonthly => 'Sonrasında aylık';

  @override
  String get ctaCancelInStore => 'Mağazadan iptal et';

  @override
  String get ovTrialStartTitle => '7 gün Premium, ücretsiz';

  @override
  String ovTrialStartBody(String price, String date) {
    return '$date tarihine kadar ücretsiz. Sonrasında mağazadan iptal etmezsen aylık $price.';
  }

  @override
  String get ctaStart7Days => '7 gün ücretsiz başla';

  @override
  String get ovOtoTitle => 'Başlamadan önce son bir şey';

  @override
  String get ovOtoBody => 'İyi seçim. Aynı Premium yıllık ödersen daha ucuz.';

  @override
  String get ovFailedDeclinedTitle => 'Kartın reddedildi';

  @override
  String get ovFailedDeclinedBody =>
      'Mağaza ödemeyi alamadı. Hiçbir ücret alınmadı.';

  @override
  String get ctaUpdatePaymentMethod => 'Ödeme yöntemini güncelle';

  @override
  String get ovFailedCanceledTitle => 'Ödeme iptal edildi';

  @override
  String get ovFailedCanceledBody => 'Hâlâ Free\'desin. Hiçbir ücret alınmadı.';

  @override
  String get ovFailedStoreTitle => 'Bir şeyler ters gitti';

  @override
  String get ovFailedStoreBody => 'Mağazaya ulaşamadık. Hiçbir ücret alınmadı.';

  @override
  String get ovAlreadyTitle => 'Zaten Premium\'dasın';

  @override
  String get ovAlreadyBody =>
      'Bu mağaza hesabının etkin bir planı var. Satın alınacak bir şey yok.';

  @override
  String get ctaSeeMySubscription => 'Aboneliğimi gör';

  @override
  String get subCancelTitle => 'Aboneliği iptal et';

  @override
  String subCancelBody(String date) {
    return 'Premium $date tarihine kadar sürer. Sonrasında Free\'ye geçersin.';
  }

  @override
  String get subWhatYouLose => 'Kaybedeceklerin';

  @override
  String get benefitScoring => 'Harf harf puanlanan telaffuz';

  @override
  String get benefitEveryMetric => 'Her ölçüt, her cümle';

  @override
  String get subPaymentTitle => 'Ödemeyi güncelle';

  @override
  String get subPaymentBody =>
      'Ödemeyi alamadık. Ek süre boyunca Premium çalışmaya devam eder.';

  @override
  String get subHowToFix => 'Nasıl düzeltilir';

  @override
  String get fixStep1 => 'Mağazayı aç ve ödeme yöntemini güncelle';

  @override
  String get fixStep2 => 'Geri dön — planın otomatik olarak devam eder';

  @override
  String get fixStep3 => 'Hiçbir ücret iki kez alınmaz';

  @override
  String get subResubTitle => 'Yeniden abone ol';

  @override
  String subResubBody(String date) {
    return 'Premium $date tarihinde bitiyor. Otomatik yenilemeyi tekrar aç, hiçbir şey değişmesin.';
  }

  @override
  String get subWhatYouKeep => 'Sende kalanlar';

  @override
  String get ctaTurnItBackOn => 'Yeniden aç';

  @override
  String get flTodayTitle => 'Bugünkü arama süren doldu';

  @override
  String get flTodayBody => 'Kaldığın yerden devam et — hemen şimdi.';

  @override
  String get flCheckTitle => 'Bugünkü kontrolün buydu';

  @override
  String get flCheckBody =>
      'Free\'de günde bir kontrol var. Premium sana tam analizi verir.';

  @override
  String flCaption(String price) {
    return 'Aylık $price · istediğin zaman iptal et';
  }

  @override
  String flUsage(String used, String limit) {
    return '$used/$limit kullanıldı';
  }

  @override
  String get ctaMaybeTomorrow => 'Belki yarın';

  @override
  String get accountSection => 'Hesap';

  @override
  String get nicknameLabel => 'Takma ad';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get loginMethodLabel => 'Giriş yöntemi';

  @override
  String get joinedLabel => 'Katılma tarihi';

  @override
  String get editNicknameTitle => 'Takma Adı Düzenle';

  @override
  String get nicknameRule => '2–12 karakter. Harf ve rakam. Yalnızca İngilizce';

  @override
  String get ctaSave => 'Kaydet';

  @override
  String get subscriptionRow => 'Abonelik';

  @override
  String get iapSuccessTitle => 'Satın alma tamamlandı';

  @override
  String iapSuccessBody(String name) {
    return '$name avatarı sonsuza dek senin.\nMakbuz onaylanır onaylanmaz uygulanır.';
  }

  @override
  String get ctaGoHome => 'Ana sayfaya';

  @override
  String get ctaUseNow => 'Hemen kullan';

  @override
  String get iapFailTitle => 'Ödeme tamamlanmadı';

  @override
  String get iapFailBody => 'Tekrar deneyebilirsin';

  @override
  String get paywallLeaveTitle => 'Şimdi çıkarsan abone olamazsın';

  @override
  String get paywallLeaveBody =>
      'Avantajların ödemeden hemen sonra açılır. Sayfam üzerinden istediğin zaman geri dönebilirsin.';

  @override
  String get ctaKeepLooking => 'Bakmaya devam et';

  @override
  String get ctaLeaveAnyway => 'Yine de çık';

  @override
  String get iapCharacterSuccessTitle => 'Yeni bir arkadaş katıldı!';

  @override
  String get iapCharacterSuccessBody =>
      'Bu karakter sonsuza dek senin — plan değişse bile kalır ve Satın alımları geri yükle ile her cihazda geri gelir.';

  @override
  String get iapCharacterFailedBody =>
      'Satın alma tamamlanamadı. Ücret alınmadı — lütfen tekrar dene.';

  @override
  String get noAccentDataTitle => 'Henüz tonlama verisi yok';

  @override
  String get noAccentDataBody =>
      'Konuşmaya devam ettikçe tonlama özellikleriniz birikir.';

  @override
  String get noLevelYetTitle => 'Henüz seviye yok';

  @override
  String get noLevelYetBody =>
      'İlk aramanızı tamamlayın, seviyeniz belirlensin.';

  @override
  String get noPronunciationDataTitle => 'Henüz telaffuz kaydı yok';

  @override
  String get noPronunciationDataBody =>
      'Aramada söylediğiniz cümlelerden telaffuzunuzu analiz ediyoruz.';

  @override
  String get noCharacterNote => 'Henüz bırakılan bir söz yok';

  @override
  String get noPhonemesYet => 'Analiz edilecek ses henüz yok';

  @override
  String get noSentencesYet => 'Analiz edilecek cümle henüz yok';

  @override
  String get takeLevelTest => 'Seviye testine gir';

  @override
  String get reviewToSeeScore => 'Tekrar edince telaffuz puanınız çıkar';

  @override
  String get playAgain => 'Tekrar oyna';

  @override
  String get difficultySlow => 'Yavaş';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyFast => 'Hızlı';

  @override
  String get difficultyLabel => 'Zorluk';

  @override
  String get connected => 'Bağlandı';

  @override
  String get unlockedWithMax => 'Planına dahil';

  @override
  String get fcEndedTitle => 'Ücretsiz görüşmen sona erdi';

  @override
  String get fcEndedBody =>
      'Ücretsiz görüşmeler en fazla 5 dakika sürer\nDaha uzun konuşmak için abone ol';

  @override
  String get ctaSubscribeKeepTalking => 'Abone ol ve konuşmaya devam et';

  @override
  String get kgTitle => 'Devam edelim mi?';

  @override
  String get kgBody =>
      'Aramalar kısa bölümler hâlinde devam eder.\nHer seferinde yeniden soracağız.';

  @override
  String get pcEndedTitleToday => 'Bugünkü aramayı burada bitirelim.';

  @override
  String get pcEndedBodyToday => 'Konuştuklarımızı tekrar et, yarın yine ara!';

  @override
  String get pcEndedTitle => 'Bu aramayı burada bitirelim.';

  @override
  String get pcEndedBody => 'Konuştuklarımızı tekrar et, yine ara!';

  @override
  String get ctaKeepTalking => 'Konuşmaya devam et';

  @override
  String get callModeSheetTitle => 'Nasıl konuşmak istersin?';

  @override
  String get callModeSheetSubtitle => 'Bu aramaya hemen uygulanır';

  @override
  String get callModeFreeTalk => 'Serbest sohbet';

  @override
  String get callModeFreeTalkDesc => 'Düzeltme olmadan konuş';

  @override
  String get callModeStudy => 'Çalışma';

  @override
  String get callModeStudyDesc => 'Her seferinde bir ifade öğren';

  @override
  String get callModeChange => 'Modu değiştir';

  @override
  String get callModeKeep => 'Şimdi değil';

  @override
  String get callExitTitle => 'Arama sonlandırılsın mı?';

  @override
  String get callExitSubtitle =>
      'Şimdi bitirsen de konuştuğun süre bugüne sayılır';

  @override
  String get callExitKeep => 'Konuşmaya devam et';

  @override
  String get callExitConfirm => 'Aramayı bitir';

  @override
  String get callMicMute => 'Sesi kapat';

  @override
  String get callMicUnmute => 'Sesi aç';

  @override
  String get callPushToTalk => 'Konuşmak için basılı tut';

  @override
  String get callFreeEndedTitle => 'Ücretsiz aramanız sona erdi';

  @override
  String get callFreeEndedCta => 'Abone ol ve konuşmaya devam et';

  @override
  String get callKeepGoingTitle => 'Devam edelim mi?';

  @override
  String get callKeepGoingSubtitle =>
      'Aramalar 5 dakikalık bölümler hâlinde sürer. Her seferinde tekrar soracağız.';

  @override
  String get articulationSelectedWord => 'Seçilen kelime';

  @override
  String get articulationYouSaid => 'Telaffuzunuz';

  @override
  String get articulationTargetSound => 'Hedef';

  @override
  String get reportEntry => 'Bildir';

  @override
  String get reportTitle => 'Bildir';

  @override
  String get reportPrompt => 'Sorun neydi?';

  @override
  String get reportGuide =>
      'Yapay zeka karakterinin hangi içeriğinin sizi rahatsız ettiğini bize bildirin. Her bildirimi inceliyoruz.';

  @override
  String get reportReasonSexual => 'Cinsel içerik';

  @override
  String get reportReasonHate => 'Nefret veya ayrımcılık';

  @override
  String get reportReasonViolence => 'Şiddet içeren veya tehdit edici içerik';

  @override
  String get reportReasonSelfHarm => 'Kendine zarar vermeyi teşvik ediyor';

  @override
  String get reportReasonMisinfo => 'Yanlış bilgi';

  @override
  String get reportReasonOther => 'Başka bir sorun';

  @override
  String get reportDetailHint => 'Ne olduğunu yazın (isteğe bağlı)';

  @override
  String get reportSubmit => 'Bildirimi gönder';

  @override
  String get reportDoneTitle => 'Bildiriminiz alındı';

  @override
  String get reportDoneBody =>
      'İnceleyip gerekirse işlem yapacağız. BeaverTalk\'ı güvende tuttuğunuz için teşekkürler.';

  @override
  String get reportFailed => 'Bildirim gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get hwTitle => 'Ödev';

  @override
  String get hwJoinCodeTitle => 'Sınıf kodunu gir';

  @override
  String get hwJoinCodeSubtitle => 'Öğretmeninin verdiği 6 haneli koddur';

  @override
  String get hwJoinCodeLabel => 'Sınıf kodu';

  @override
  String get hwJoinCodeHelp => 'Kod büyük küçük harfe duyarlı değildir';

  @override
  String get hwJoinConfirmTitle => 'Doğru sınıf bu mu?';

  @override
  String get hwJoinConfirmSubtitle => 'Değilse kodu tekrar kontrol et';

  @override
  String get hwJoinFieldInstitution => 'Kurum';

  @override
  String get hwJoinFieldTeacher => 'Öğretmen';

  @override
  String get hwJoinFieldLearners => 'Öğrenciler';

  @override
  String get hwJoinFieldTerm => 'Dönem';

  @override
  String get hwJoinConfirmNote =>
      'Sınıf adı öğretmeninin yazdığı gibi görünür. Çevirmiyoruz.';

  @override
  String get hwJoinConfirmYes => 'Evet, bu';

  @override
  String get hwJoinConfirmRetry => 'Kodu yeniden gir';

  @override
  String get hwJoinProfileTitle => 'Sınıfta hangi adı kullanacaksın?';

  @override
  String get hwJoinProfileSubtitle =>
      'Öğretmenin bunu sınıf listesiyle eşleştirir';

  @override
  String get hwJoinNameLabel => 'Ad';

  @override
  String get hwJoinNameHelp => 'Uygulamadaki adından farklı olabilir';

  @override
  String get hwJoinStudentNoLabel => 'Öğrenci numarası (isteğe bağlı)';

  @override
  String get hwJoinStudentNoHelp =>
      'Öğretmenin sınıf listesini eşleştirmek için kullanır';

  @override
  String get hwJoinConsentTitle => 'Öğretmeninin gördükleri';

  @override
  String get hwJoinConsentSubtitle => 'Sınıfa katılmak için onay vermelisin';

  @override
  String get hwJoinConsentSharedHeading => 'Öğretmeninle paylaşılır';

  @override
  String get hwJoinConsentShared1 => 'Sınıf adı ve öğrenci numarası';

  @override
  String get hwJoinConsentShared2 => 'Ödevi yapıp yapmadığın';

  @override
  String get hwJoinConsentShared3 => 'Geçilen ve kaçırılan cümleler';

  @override
  String get hwJoinConsentShared4 => 'Ödev görüşmesinin süresi ve özeti';

  @override
  String get hwJoinConsentNotSharedHeading => 'Paylaşılmaz';

  @override
  String get hwJoinConsentNotShared1 => 'E-posta ve telefon numarası';

  @override
  String get hwJoinConsentNotShared2 => 'Uygulama adı, profil ve karakter';

  @override
  String get hwJoinConsentNotShared3 => 'Uyruk ve ana dil';

  @override
  String get hwJoinConsentNotShared4 => 'Sınıf dışındaki görüşmeler ve çalışma';

  @override
  String get hwJoinConsentNotShared5 => 'Abonelik ve ödeme bilgileri';

  @override
  String get hwJoinConsentAgree => 'Yukarıdakileri kabul ediyorum';

  @override
  String get hwJoinConsentCta => 'Kabul et ve katıl';

  @override
  String hwJoinDoneTitle(String className) {
    return '$className sınıfına katıldın';
  }

  @override
  String hwJoinDoneSubtitle(int count) {
    return '$count ödev seni bekliyor';
  }

  @override
  String get hwJoinDoneNoAssignment => 'Henüz ödev yok';

  @override
  String get hwJoinDoneNextDue => 'Sonraki teslim';

  @override
  String get hwJoinDoneRosterName => 'Sınıftaki adın';

  @override
  String get hwJoinDoneCta => 'Ödevleri gör';

  @override
  String get hwJoinErrorNotFound => 'Bu kodu bulamadık';

  @override
  String get hwJoinErrorNotFoundBody => 'Lütfen altı haneyi tekrar kontrol et.';

  @override
  String get hwJoinErrorExpired => 'Bu kodun süresi doldu';

  @override
  String get hwJoinErrorExpiredBody => 'Öğretmeninden yeni bir kod iste.';

  @override
  String get hwJoinErrorFull => 'Sınıf dolu';

  @override
  String get hwJoinErrorFullBody => 'Lütfen öğretmenine haber ver.';

  @override
  String get hwJoinFailed => 'Katılınamadı. Birazdan tekrar dene.';

  @override
  String get hwSectionInProgress => 'Devam eden';

  @override
  String get hwSectionUpcoming => 'Yaklaşan';

  @override
  String get hwSectionDone => 'Bitti';

  @override
  String get hwLeaveClassLink => 'Sınıftan ayrıl';

  @override
  String get hwListEmptyTitle => 'Henüz ödev yok';

  @override
  String get hwListEmptyBody => 'Öğretmenin ödev verdiğinde burada görünecek.';

  @override
  String get hwListFailed => 'Ödevlerin yüklenemedi.';

  @override
  String get hwRetry => 'Tekrar dene';

  @override
  String get hwBadgeDone => 'Bitti';

  @override
  String get hwBadgeOverdue => 'Teslim edilmedi';

  @override
  String hwBadgeOverdueDays(int days) {
    return 'Teslim edilmedi, $days gün gecikme';
  }

  @override
  String hwBadgeDday(int days) {
    return 'S-$days';
  }

  @override
  String get hwBadgeDueToday => 'Bugün teslim';

  @override
  String get hwActivitySpeaking => 'Konuşma';

  @override
  String get hwActivityConversation => 'Diyalog';

  @override
  String get hwActivityWorkbook => 'Çalışma kitabı';

  @override
  String hwChapterLabel(String chapter) {
    return 'Bölüm $chapter';
  }

  @override
  String get hwTaskSpeakingDesc => 'Telaffuz puanını kontrol et';

  @override
  String get hwTaskConversationDesc =>
      'Öğrendiklerini gerçek bir konuşmada kullan';

  @override
  String get hwConversationOnce =>
      'Konuşma her ödev için yalnızca bir kez yapılabilir.';

  @override
  String get hwTaskWorkbookDesc => 'Çalışma kitabına yazarak pratik yap';

  @override
  String get hwCtaStudy => 'Başla';

  @override
  String get hwCtaResult => 'Sonucu gör';

  @override
  String get hwCtaDownload => 'İndir';

  @override
  String get hwSpeakingNoScore => 'Konuşma görevini henüz yapmadın';

  @override
  String get hwWorkbookUnavailable =>
      'Çalışma kitabı dosyası henüz hazır değil.';

  @override
  String get hwDetailClosed => 'Bu ödev kapandı. Artık teslim edemezsin.';

  @override
  String get hwLeaveTitle => 'Sınıftan ayrılınsın mı?';

  @override
  String get hwLeaveBody => 'Öğretmenin artık ödev sonuçlarını göremeyecek.';

  @override
  String get hwLeaveConfirm => 'Ayrıl';

  @override
  String get hwLeaveCancel => 'Kal';

  @override
  String get hwLeaveFailed => 'Sınıftan ayrılınamadı.';

  @override
  String get hwMyClass => 'Sınıfım';

  @override
  String get hwClassEmptyTitle => 'Henüz bir sınıfa katılmadın';

  @override
  String get hwClassEmptySubtitle => 'Öğretmeninin verdiği kodu gir';

  @override
  String get hwClassEmptyCta => 'Sınıf kodunu gir';

  @override
  String get hwClassContinueCta => 'Devam';

  @override
  String hwHomeBannerDueTomorrow(int count) {
    return '$count ödevin yarın teslim';
  }

  @override
  String hwHomeBannerOverdue(int count) {
    return '$count teslim edilmemiş ödevin var';
  }

  @override
  String get hwSpeakingUnavailable => 'Bu ödevin cümleleri henüz hazır değil.';

  @override
  String get hwBadgeClosed => 'Kapandı';

  @override
  String hwSpeakingProgress(int passed, int total) {
    return '$total cümleden $passed tanesi geçti';
  }

  @override
  String get challengeFirstWord => 'İlk kelime';

  @override
  String get challengeSeeAnalysis => 'Sonuçları gör';

  @override
  String get challengePaused => 'Duraklatıldı';

  @override
  String get challengePausedNote => 'Sayaç ve kayıt birlikte durdu.';

  @override
  String get challengeTimeLeft => 'Kalan süre';

  @override
  String get challengeScoreLabel => 'Puan';

  @override
  String get challengeResume => 'Devam et';

  @override
  String get challengeBlockedTitle => 'Kamera kullanılamıyor';

  @override
  String get challengeBlockedNote =>
      'Ayarlar’dan kamera ve mikrofon erişimini aç.';

  @override
  String get challengeGoBack => 'Geri dön';

  @override
  String get challengeOpenSettings => 'Ayarları aç';

  @override
  String get saveDone => 'Galeriye kaydedildi';

  @override
  String get saveFailed => 'Kaydedilemedi';

  @override
  String get saveDeniedNote => 'Fotoğraf erişimi gerekli';

  @override
  String get callIncomingCallerFallback => 'Beaver Öğretmen';

  @override
  String get callIncomingHandle => 'Korece görüşme';

  @override
  String get callMissedTitle => 'Cevapsız arama';

  @override
  String get callMissedChannelDescription =>
      'Beaver aramalarını kaçırdığında haber verir.';

  @override
  String callMissedBody(String name) {
    return '$name seni aramaya çalıştı';
  }

  @override
  String get callBeaverFallbackName => 'Beaver';

  @override
  String get callNotifPermissionRationale =>
      'Aramaları almak için bildirim izni gerekiyor.';

  @override
  String get callNotifPermissionRequired =>
      'Ayarlardan bildirimlere izin verin.';

  @override
  String get callHintLockedTitle => 'Çalışma modunda ipucu kullanılamaz';

  @override
  String get wsTitle => 'Zayıf sesler';

  @override
  String get wsToList => 'Listeye dön';

  @override
  String get wsNext => 'İleri';

  @override
  String get wsRetry => 'Tekrar dene';

  @override
  String get wsDone => 'Bitti';

  @override
  String get wsContinue => 'Devam et';

  @override
  String get wsQuit => 'Çık';

  @override
  String get wsRetryLater => 'Lütfen biraz sonra tekrar deneyin.';

  @override
  String get wsMissingTitle => 'O sesi bulamadık';

  @override
  String get wsMissingBody => 'Lütfen listeden tekrar seçin.';

  @override
  String get wsListLoadFailed => 'Liste yüklenemedi';

  @override
  String get wsLessonLoadFailed => 'Ders yüklenemedi';

  @override
  String get wsNationalTitle => 'Aksanınıza göre zayıf sesler';

  @override
  String get wsNationalPending =>
      'Aksanınız analiz edilince burayı dolduracağız';

  @override
  String get wsNationalPicked => 'Aksan analizinize göre seçildi';

  @override
  String get wsNationalEmptyBody =>
      'Birkaç arama daha yapın, aksanınızı analiz edelim.';

  @override
  String get wsMineTitle => 'Zayıf seslerim';

  @override
  String get wsMineSubtitle => 'Son zamanlarda en düşük puan aldığınız sesler';

  @override
  String get wsMineEmptyBody =>
      'Arama yapıp tekrar edin, zayıf sesleriniz birikecek.';

  @override
  String get wsNoDataYet => 'Henüz veri yok';

  @override
  String get wsGoToCall => 'Arama başlat';

  @override
  String get wsRule => 'Kural';

  @override
  String get wsRecommended => 'Önerilen';

  @override
  String get wsNotMeasured => 'Ölçülmedi';

  @override
  String get wsStepUnderstand => 'Anlama';

  @override
  String get wsStepWords => 'Kelimeler';

  @override
  String get wsStepSentence => 'Cümle';

  @override
  String get wsStepTest => 'Test';

  @override
  String get wsQuitTitle => 'Alıştırmayı bırakalım mı?';

  @override
  String get wsQuitBody => 'Şimdi çıkarsanız bu alıştırma kaydedilmez.';

  @override
  String get wsHowToSound => 'Ses nasıl çıkarılır';

  @override
  String get wsPracticeWords => 'Kelimeleri çalış';

  @override
  String get wsPracticeSentence => 'Cümleyi çalış';

  @override
  String get wsStartTest => 'Testi başlat';

  @override
  String get wsThisSentence => 'Bu cümle';

  @override
  String get wsNoScoreNote => 'Bu adım puanlanmaz. Rahatça tekrar edin.';

  @override
  String get wsListen => 'Dikkatle dinleyin';

  @override
  String get wsSayNow => 'Şimdi siz söyleyin';

  @override
  String get wsPracticeDone => 'Alıştırma tamamlandı';

  @override
  String get wsPaused => 'Duraklatıldı';

  @override
  String get wsAudioFailed => 'Ses yüklenemedi. Yazıya bakıp sesli okuyun.';

  @override
  String get wsReadAloud => 'Aşağıdaki cümleyi sesli okuyun';

  @override
  String get wsTapToStart => 'Başlamak için dokunun';

  @override
  String get wsTapWhenDone => 'Bitirince dokunun';

  @override
  String get wsScoring => 'Puanlanıyor';

  @override
  String get wsMicFailed => 'Mikrofon açılamadı.';

  @override
  String get wsMicPermissionBody =>
      'Bu testte sesli okursun, bu yüzden mikrofon gerekir. Ayarlar\'dan mikrofon erişimini aç.';

  @override
  String get wsNoSound => 'Hiçbir şey duymadık. Tekrar deneyelim mi?';

  @override
  String get wsScoreFailed => 'Puanlama başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get wsSomethingWrong => 'Bir sorun oluştu.';

  @override
  String get wsLearnDone => 'Ders tamamlandı';

  @override
  String get wsRetest => 'Yeniden test';

  @override
  String get wsFirstMeasure => 'İlk ölçüm';

  @override
  String get wsFinalTest => 'Son test';

  @override
  String wsPoints(int score) {
    return '$score puan';
  }

  @override
  String wsBeforePoints(int score) {
    return 'Önce $score puan';
  }

  @override
  String wsGoalPoints(int score) {
    return 'Hedef $score puan';
  }

  @override
  String wsGoalPrefix(String desc) {
    return 'Hedef · $desc';
  }

  @override
  String wsAccentOf(String country) {
    return '$country aksanı';
  }

  @override
  String wsWordsRepeated(int count) {
    return '$count kelime tekrar edildi';
  }

  @override
  String wsChunksRepeated(int count) {
    return '$count parça tekrar edildi';
  }

  @override
  String get wsStartRecommended => 'Önerilen sesle başla';

  @override
  String wsStartRecommendedWith(String label) {
    return '$label ile başla';
  }

  @override
  String get wsPointsUnit => 'puan';

  @override
  String get wsEnterFromMypage => 'Zayıf sesleri çalış';

  @override
  String wsGoalOnly(int score) {
    return 'Hedef $score';
  }

  @override
  String wsSoundOf(String label) {
    return '$label sesi';
  }

  @override
  String wsResultTip(String desc) {
    return '$desc. Bir aramada karşınıza çıkınca bu şekli gözünüzde canlandırın.';
  }

  @override
  String wsNationalSubtitle(String country) {
    return '$country – konuşanların sık yanlış söylediği sesler';
  }
}
