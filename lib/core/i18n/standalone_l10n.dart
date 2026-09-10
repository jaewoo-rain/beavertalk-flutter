import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import 'locale_controller.dart';

/// 위젯 트리 **밖에서** 쓰는 번역 접근자.
///
/// ## 왜 필요한가
///
/// 수신 전화·부재중 알림 문구는 `BuildContext` 가 없는 자리에서 만들어진다 —
/// FCM 백그라운드 핸들러, PushKit 콜드스타트, CallKit 이벤트 콜백. 그래서
/// `AppLocalizations.of(context)` 를 쓸 수 없고, 그 자리들이 통째로 한국어
/// 하드코딩으로 남아 있었다. 앱의 나머지는 30개 로케일 100% 번역인데 외국인
/// 학습자가 잠금화면에서 처음 보는 화면만 한국어였다.
///
/// `AppLocalizations.delegate.load()` 는 context 를 안 받는다. 로케일만 있으면
/// 되고, 로케일은 [LocaleController] 가 `SharedPreferences` 에 넣어 둔다.
///
/// ## 규칙
///
/// - **던지지 않는다.** 이 경로에서 던지면 전화가 통째로 죽는다. 무슨 일이
///   생기든 영어 인스턴스를 돌려준다.
/// - 언어코드만 비교한다 — `MaterialApp.localeResolutionCallback` 과 같은 규칙이다.
///   지역까지 따지면 `ko-KR` 저장값이 `ko` ARB 를 못 찾는다.
/// - 결과를 캐시한다. 알림 1건마다 prefs 를 다시 읽지 않는다.
abstract final class StandaloneL10n {
  /// [LocaleController] 가 쓰는 저장 키. 두 곳이 갈리면 조용히 영어가 된다.
  static const _prefKey = 'ui_locale';

  static AppLocalizations? _cached;
  static Locale? _cachedFor;

  /// iOS 네이티브가 읽는 미러 키. `SharedPreferences` 는 iOS 에서 `NSUserDefaults`
  /// 이고 키에 `flutter.` 접두가 붙는다 — `AppDelegate` 는 그 이름으로 읽는다.
  static const _mirrorCallerKey = 'call_caller_fallback';
  static const _mirrorHandleKey = 'call_handle';

  /// 저장된 언어의 번역본. 실패하면 영어다.
  static Future<AppLocalizations> load() async {
    final locale = await _resolveLocale();
    final cached = _cached;
    if (cached != null && _cachedFor == locale) return cached;
    try {
      final l10n = await AppLocalizations.delegate.load(locale);
      _cached = l10n;
      _cachedFor = locale;
      unawaited(_mirrorForNative(l10n));
      return l10n;
    } catch (_) {
      final fallback = await AppLocalizations.delegate.load(const Locale('en'));
      _cached = fallback;
      _cachedFor = const Locale('en');
      unawaited(_mirrorForNative(fallback));
      return fallback;
    }
  }

  /// 수신 화면 문구 2종을 네이티브가 읽을 수 있는 자리에 복사해 둔다.
  ///
  /// ## 왜 미러가 필요한가
  ///
  /// iOS 의 PushKit 핸들러는 **Dart 가 깨어나기 전에** CallKit 수신 화면을 띄운다
  /// (iOS 13+ 는 VoIP 푸시마다 즉시 통화를 보고하지 않으면 앱을 죽인다). 그래서
  /// 그 자리에서는 ARB 를 읽을 수 없고, 서버 페이로드에 `nameCaller`·`handle` 이
  /// 없으면 네이티브 리터럴로 떨어진다 — 그게 한국어였다.
  ///
  /// 값이 없으면 네이티브가 종전 리터럴로 떨어지므로 회귀가 아니다.
  static Future<void> _mirrorForNative(AppLocalizations l10n) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_mirrorCallerKey, l10n.callIncomingCallerFallback);
      await prefs.setString(_mirrorHandleKey, l10n.callIncomingHandle);
    } catch (_) {
      // 미러는 부가 기능이다. 실패해도 번역 자체는 이미 돌려줬다.
    }
  }

  /// 언어 선택이 바뀌면 캐시를 버린다. [LocaleController.setLanguage] 가 부른다.
  static void invalidate() {
    _cached = null;
    _cachedFor = null;
  }

  /// 저장값 → 지원되는 [Locale]. 없거나 지원 밖이면 영어다.
  static Future<Locale> _resolveLocale() async {
    String? code;
    try {
      final prefs = await SharedPreferences.getInstance();
      code = prefs.getString(_prefKey);
    } catch (_) {
      // prefs 를 못 열면 영어로 간다. 알림을 못 띄우는 것보다 낫다.
    }
    if (code == null || code.isEmpty) return const Locale('en');
    final want = LocaleController.localeFromCode(code);
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == want.languageCode) return supported;
    }
    return const Locale('en');
  }
}
