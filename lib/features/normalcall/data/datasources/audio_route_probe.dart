import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart';

/// "지금 소리가 어느 출력으로 나가는가" 를 네이티브에서 읽어 온다.
///
/// ## 왜 필요한가
///
/// barge-in 측정은 **같은 숫자라도 라우트에 따라 정반대 의미**가 된다. 스피커폰은
/// 마이크와 스피커가 음향적으로 결합된 최악 조건이고, 이어폰은 결합이 거의 없다.
/// 서버가 결과를 해석하려면 그 맥락이 값과 함께 와야 한다 — 세션 단위로는 안 된다.
/// 통화 도중에 이어폰을 뽑으면 그 순간부터 다른 조건이기 때문이다.
///
/// ## 못 읽으면 빈 문자열이다
///
/// ⚠ **기본값을 'speaker' 로 두면 안 된다.** 서버가 "못 읽음"과 "스피커였음"을
/// 구분해야 하는데, 추측으로 채우면 측정 못 한 기기가 전부 스피커폰 통계에 섞여
/// 에코 임계가 잘못된 모집단 위에서 정해진다. 모르면 모른다고 답하는 게 값이다.
class AudioRouteProbe {
  const AudioRouteProbe();

  /// 통화 경로가 이미 쓰고 있는 채널. Android 는 이번에 `getAudioRoute` 만 신설했고
  /// (나머지 메서드는 iOS 전용이라 Dart 쪽에서 막혀 있다), iOS 는 기존 채널에 추가했다.
  static const MethodChannel _channel = MethodChannel('beavertalk/audio');

  /// 서버 계약의 `platform` 값.
  static String get platformName {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        // 계약에 없는 플랫폼. 억지로 android/ios 로 우기지 않는다.
        return '';
    }
  }

  /// 현재 출력 라우트. 못 읽으면 `''`.
  ///
  /// 네이티브가 없거나(구버전 앱), 플랫폼이 라우트를 안 알려주거나, 예외가 나면
  /// 전부 `''` 로 떨어진다 — 어느 쪽이든 "모른다"가 맞는 답이다.
  static Future<String> currentRoute() async {
    if (kIsWeb) return '';
    try {
      final r = await _channel.invokeMethod<String>('getAudioRoute');
      return r ?? '';
    } catch (_) {
      return '';
    }
  }
}
