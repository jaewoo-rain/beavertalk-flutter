import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 잠금화면 위 통화(비번 없이 받기)를 다루는 네이티브 채널 래퍼.
///
/// ## 왜 필요한가
///
/// 수신 화면([CallkitIncomingActivity])은 원래부터 키가드 위에 뜬다. 문제는 **수락한
/// 뒤**다 — 플러그인이 `MainActivity`를 앞으로 불러오는데, 거기엔 그 창 플래그가 없어
/// 키가드가 앞을 막고 비번을 요구했다. 오디오·소켓·네비게이션은 전부 멀쩡했고 막는 건
/// 그것뿐이었다.
///
/// 그래서 이 기능의 본체는 Dart 가 아니라 `MainActivity`에 있다. 판정을 네이티브에서
/// 하는 이유는 타이밍이다: Flutter 엔진이 뜨고 채널이 붙기를 기다리면 그 사이 키가드가
/// 한 번 깜빡인다. 액티비티는 인텐트만 보고 즉시 결정할 수 있다.
///
/// Dart 쪽 책임은 **끝낼 때 한 번** 뿐이다 — 통화가 끝났음을 알리고, 앱 안으로
/// 이동할지 잠금화면으로 돌아갈지 답을 받는다.
///
/// ## 보안상 중요한 점
///
/// 이 모드가 켜져 있는 동안에는 `MainActivity` 전체가 키가드 위에 있다. 통화 화면 밖으로
/// 나가면 그대로 **잠금 우회**가 된다. 그래서 통화가 끝나는 모든 경로(정상 종료·에러·
/// 취소)가 예외 없이 [exitIfLocked] 를 먼저 거쳐야 한다. 한 경로라도 빠뜨리면 잠금화면
/// 위에 홈 화면이 남는다.
class LockscreenCallService {
  /// 무상태 래퍼.
  const LockscreenCallService();

  static const MethodChannel _channel = MethodChannel('beavertalk/lockscreen');

  /// 안드로이드 전용 기능이다. iOS 는 CallKit 이 잠금화면 통화 UI 를 직접 제공하고,
  /// 웹/데스크톱엔 키가드 개념이 없다.
  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// 지금 통화가 잠긴 화면에서 수락된 것인가.
  ///
  /// 화면 쪽에서 "잠금 통화용 UI"를 따로 보여줄 때 쓴다. 종료 분기에는 쓰지 말 것 —
  /// 그건 [exitIfLocked] 가 종료 시점에 다시 판정한다.
  Future<bool> get isLockscreenCall async {
    if (!_supported) return false;
    try {
      return await _channel.invokeMethod<bool>('isLockscreenCall') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// 잠금화면 통화를 끝낸다.
  ///
  /// 반환값이 **true 면 앱이 뒤로 보내졌다** — 호출자는 화면 전환을 하면 안 된다
  /// (잠금화면 위로 다른 화면이 올라온다).
  ///
  /// false 인 경우는 두 가지다: 애초에 잠금화면 통화가 아니었거나, 통화 중에 사용자가
  /// 스스로 잠금을 풀었거나. 둘 다 **평소대로 통화 요약 화면으로 가면 된다** — 잠금을
  /// 푼 사용자를 잠금화면으로 돌려보내는 건 엉뚱하다.
  ///
  /// 실패해도 false 를 돌려준다. 채널이 없는 환경(테스트·다른 플랫폼)에서 통화 종료
  /// 흐름이 예외로 끊기면 안 된다 — 최악이라도 "그냥 앱 안에 남는" 쪽으로 떨어진다.
  Future<bool> exitIfLocked() async {
    if (!_supported) return false;
    try {
      return await _channel.invokeMethod<bool>('exitIfLocked') ?? false;
    } catch (_) {
      return false;
    }
  }
}
