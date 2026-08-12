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

  /// [Android 전용] 통화 용도 오디오 모드를 켜고 끈다.
  ///
  /// 켜야 플랫폼 AEC 가 참조할 다운링크가 생긴다. **켜면 같이 바뀌는 게 있다** —
  /// 볼륨 스트림이 미디어→통화로 넘어가고, 헤드셋이 없으면 기본 출력이 리시버로
  /// 빠지려 한다(네이티브가 스피커폰을 명시적으로 켜서 막는다).
  ///
  /// 반환은 [audioDiag] 와 같은 스냅샷 — **실제로 무엇이 적용됐는지**다.
  /// "켜라고 했다"와 "켜졌다"는 다르므로 호출자는 이걸 확인해야 한다.
  /// iOS/web 은 빈 Map(이 스위치는 Android 전용이다).
  static Future<Map<String, dynamic>> setVoiceCallMode(bool enable) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const {};
    try {
      final r = await _channel.invokeMapMethod<String, dynamic>(
        'setVoiceCallMode',
        <String, dynamic>{'enable': enable},
      );
      return r ?? const {};
    } catch (_) {
      return const {};
    }
  }

  /// [Android 전용] 오디오 상태 스냅샷: `mode`, `speakerphone`, `route`,
  /// `music_vol`/`voice_vol`(+ 각 max). AEC 를 바꾸면 같이 움직이는 값들이라
  /// 측정 전후로 찍어 둔다. 못 읽으면 빈 Map.
  static Future<Map<String, dynamic>> audioDiag() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const {};
    try {
      final r = await _channel.invokeMapMethod<String, dynamic>('getAudioDiag');
      return r ?? const {};
    } catch (_) {
      return const {};
    }
  }
}
