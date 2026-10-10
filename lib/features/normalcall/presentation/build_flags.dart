import 'package:flutter/foundation.dart';

import 'cascade_auto_talk.dart';
import 'cascade_experiment.dart';

/// **이 APK 가 어떤 빌드인가**를 화면에 드러낸다.
///
/// ## 왜 필요한가 — 안 보이는 상태가 하루에 두 번 우리를 물었다
///
/// 2026-08-14: 서버는 `mic_always_open=on` 을 보냈는데 끼어들기가 한 번도 안 걸렸다.
/// 서버 로그에는 **기각 로그조차 없어서** 관문에 걸린 게 아니라 판정 자체가 안 돈 것이었다.
/// 원인은 폰에 깔린 APK 가 `ANDROID_VOICE_AUDIO` 없이 빌드된 것이었는데, **그걸 확인할
/// 방법이 화면에 없어서** 서버·클라가 반나절을 왕복했다. 사장님은 외부에 계셔서 USB 도 못 썼다.
///
/// 같은 계열 사고가 서버에서도 났다(설정한 적 없는 값을 아무도 모르고 있었다).
/// ⇒ **보이지 않는 상태**가 문제의 뿌리다. 한 줄로 그 계열을 닫는다.
///
/// ## ⛔ 규칙
/// - **실제 상수를 읽는다.** 문자열을 손으로 나열하지 않는다 — 그러면 플래그를 늘렸을 때
///   여기가 조용히 낡는다(오늘 우리가 당한 것과 같은 종류의 거짓말이 된다).
/// - `enabled` 가 아니라 **`flag`(dart-define 원값)** 을 보여준다. `enabled` 는 릴리즈에서
///   `kDebugMode` 때문에 false 로 접히는데, 그러면 "플래그를 줬는데 화면엔 off"가 되어
///   **정확히 우리가 없애려는 혼선**이 다시 생긴다. 접힌 경우는 `(무시됨)` 으로 따로 알린다.
abstract final class BuildFlags {
  /// 빌드 식별자. `--dart-define=BUILD_TAG=...` 로 넣는다.
  ///
  /// ⚠ 플래그만으로는 **언제 빌드한 것**을 못 가린다 — 같은 플래그 조합으로 하루에 여러 번
  /// 빌드하기 때문이다. 오늘 혼선의 절반이 그것이었다.
  /// 값이 `(미지정)` 이면 **우리 빌드 절차를 안 거친 APK** 라는 뜻이고, 그 자체가 정보다.
  static const String tag =
      String.fromEnvironment('BUILD_TAG', defaultValue: '(미지정)');

  /// [Android] 통화 용도 오디오는 **이제 항상 켜진다.** 컴파일 플래그를 없앴다.
  ///
  /// ⛔ 이건 실험 스위치가 아니라 **제품 설정**이었는데 플래그로 다뤄져서, 그게 빠진 APK 가
  ///   돌아다녔고 사장님 폰에 깔렸다. 「이 플래그가 없는 APK」라는 상태 자체를 없앴다.
  ///   끌 일이 생기면 **서버 env**(`CASCADE_MIC_ALWAYS_OPEN`) 로 끈다.
  static const bool androidVoiceAudio = true;

  /// 실험 토글 현재 상태. 개발자 도구 카드에 그대로 띄운다.
  ///
  /// ⛔ **런타임 값을 읽는다.** 예전엔 컴파일 플래그를 읽었고, 그래서 「지금 이 앱이 무슨
  ///   상태인가」를 알려면 APK 를 다시 구워야 했다.
  static String get summary {
    final parts = <String>[
      'AEC(통화오디오)=항상ON',
      '자동대화=${_on(CascadeAutoTalk.enabled)}',
      '마이크끔=${_on(CascadeMicOff.enabled)}',
      '파일녹음=${_on(CascadeMicToFile.enabled)}',
      '업링크차단=${_on(CascadeMicAlwaysGated.enabled)}',
      'AEC끔=${_on(CascadeMicNoAec.enabled)}',
      '쿠션성장끔=${_on(CascadeCushionGrowthOff.enabled)}',
    ];
    return parts.join(' · ');
  }

  /// 실험 토글이 **하나라도 켜져 있나.** 켜진 채 잊고 "왜 이상하지"가 되는 게 다음 사고다.
  static bool get anyExperimentOn =>
      CascadeAutoTalk.enabled ||
      CascadeMicOff.enabled ||
      CascadeMicToFile.enabled ||
      CascadeMicAlwaysGated.enabled ||
      CascadeMicNoAec.enabled ||
      CascadeCushionGrowthOff.enabled;

  /// ⭐ **마이크가 서버로 갈 수 있는 빌드인가.** 하나라도 켜져 있으면 사람 목소리가
  /// 서버에 **아예 안 간다** — 그러면 통화가 성립하지 않는다. 실험용 APK 를 실수로
  /// 깔았을 때 화면에서 바로 드러나야 한다.
  static bool get micReachesServer =>
      !CascadeMicOff.enabled &&
      !CascadeMicToFile.enabled &&
      !CascadeMicAlwaysGated.enabled;

  /// 끼어들기가 켜질 수 있는 빌드인가(나머지 두 조건은 통로·서버가 정한다).
  static bool get bargeInPossible => androidVoiceAudio && micReachesServer;

  static String _on(bool v) => v ? 'ON' : 'off';

  /// 디버그 빌드인가. 릴리즈면 실험 플래그가 전부 접힌다.
  static bool get isDebug => kDebugMode;
}
