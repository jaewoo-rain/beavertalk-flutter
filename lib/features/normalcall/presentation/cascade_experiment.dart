import 'package:flutter/foundation.dart';

import '../domain/entities/call_channel.dart';

/// 캐스케이드 **격리 실험** 스위치 — 디버그 빌드 전용.
///
/// ## 왜 있나
///
/// 안드로이드에서만 통화가 길어질수록 재생이 끊긴다(iOS 는 멀쩡하다 — 사장님 확인).
/// Dart 코드는 양쪽이 같으므로 **원인은 안드로이드 네이티브 쪽**이고, 안드로이드 플랫폼
/// (UI) 스레드에 있는 것은 MethodChannel 핸들러 · **플랫폼 뷰(SurfaceView)** ·
/// **ExoPlayer 콜백**이다. 실측이 그쪽을 가리킨다: 네이티브 핸들러 자체는 0~3ms 로
/// 평평한데 왕복만 3초까지 커진다 = **네이티브에 닿기 전에** 시간이 쓰인다.
///
/// ⇒ 캐스케이드를 **순정으로 벗겨** 곡선이 평평해지는지 보고, 그다음 **하나씩 다시 켜서**
///   어느 것이 곡선을 세우는지 가둔다. 고치는 게 아니라 **범인을 가두는 도구**다.
///
/// ## ⛔ 라이브는 절대 안 벗긴다
///
/// 라이브는 **제품 그대로**여야 비교가 성립한다. 같은 통화에서 두 통로를 대조하는 것이
/// 이번 판정의 핵심이다.
///
/// ## 릴리즈 안전
///
/// 판정은 [enabledFor] 한 곳에서만 한다. 릴리즈에서는 **항상 켬**을 돌려주므로,
/// 나중에 서버가 통로를 내려주더라도 실사용자가 벗겨진 화면을 보는 일이 없다.
class CascadeExperiment {
  const CascadeExperiment._();

  /// 아바타 영상(ExoPlayer/SurfaceView). **기본 꺼짐** — 제1 용의자다.
  static final ValueNotifier<bool> avatarVideo = ValueNotifier<bool>(false);

  /// 힌트 카드. **기본 꺼짐.**
  static final ValueNotifier<bool> hints = ValueNotifier<bool>(false);

  /// 이 통로에서 그 기능을 켤 것인가.
  ///
  /// - 릴리즈: 항상 true(실험 스위치가 제품에 새지 않는다)
  /// - 라이브 통로: 항상 true(제품 그대로 — 대조군이다)
  /// - 캐스케이드 + 디버그: 스위치를 따른다
  static bool enabledFor(CallChannel channel, ValueNotifier<bool> flag) {
    if (!kDebugMode) return true;
    if (!channel.isCascade) return true;
    return flag.value;
  }
}
