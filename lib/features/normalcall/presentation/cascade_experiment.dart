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

/// dev 전용 — **마이크를 아예 열지 않는다.**
///
/// ## 왜 이 스위치가 따로 필요한가 — 게이팅으로는 못 끈다
///
/// 통화 중 마이크 "게이팅"([NormalCallController._micGated])은 **Dart 스트림 리스너
/// 안에서 프레임을 버린다.** 즉 네이티브 레코더는 계속 돌고, 프레임은 **이미 플랫폼
/// 채널을 건너온 뒤** 버려진다. 원래 의도가 그랬다 — 오디오 세션·AEC 를 흔들지 않으려고.
///
/// ⇒ 그래서 **게이팅을 켜도 플랫폼 스레드 부하는 1바이트도 안 준다.** 서버가
///   `mic_always_open=false` 를 내려도 마찬가지다. 마이크가 왕복 지연의 원인인지
///   가리려면 **레코더 자체를 안 여는** 스위치가 있어야 한다.
///
/// ## 무엇을 재는 실험인가
///
/// 6분 통화에서 빈채널왕복이 선형으로 자라는데(4ms → 1,443ms) 우리 피드는 미완 0 이다
/// (한 건 보내고 응답 받고 다음). 즉 **쌓이는 큐는 우리 것이 아니다.** 플랫폼 스레드
/// 위에서 응답을 안 기다리고 계속 밀어 올리는 생산자가 후보이고, 마이크가 그 자리다 —
/// 실측 **초당 83프레임**(12,100프레임/145초)이 우리 피드(초당 1~5건)의 20~80배다.
///
/// 자동 대화([CascadeAutoTalk])는 STT 를 안 타므로 **마이크가 없어도 대화가 굴러간다.**
/// 그래서 이 실험이 성립한다.
///
/// ⛔ 켜면 **사람 목소리가 서버에 안 간다.** 계측 전용이다.
/// `--dart-define=MIC_OFF=true` + 디버그 빌드에서만 동작한다.
abstract final class CascadeMicOff {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐 = 제품 동작.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('MIC_OFF')` 였다. 컴파일 플래그라 **끄고 켤 때마다
  ///   APK 를 구워야 했고**, 그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다.
  ///   2026-08-14 에 그것 때문에 반나절을 태웠다(서버는 마이크를 열라는데 클라가 거부했고,
  ///   원인이 빌드 플래그라는 걸 화면에서 볼 방법이 없었다).
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  static bool get enabled => toggle.value && kDebugMode;
}

/// dev 전용 — 마이크는 열되 **플랫폼 에코 제거(AEC)만 끈다.**
///
/// ## 왜 이게 따로 필요한가 — [CascadeMicOff] 는 **한 번에 네 가지를 뺐다**
///
/// 마이크를 안 열면 다음이 **동시에** 빠진다:
///   ① 네이티브→Dart 프레임 전달(초당 83건)
///   ② AudioRecord 스레드 자체
///   ③ 플랫폼 AEC / VoiceProcessingIO
///   ④ 업링크 소켓 전송(초당 32KB)
///
/// 실측은 "마이크 파이프라인이 원인이다"까지만 말한다. **그중 무엇이 범인인지는
/// 아직 모른다.** 이 구분이 실제 처방을 가른다:
///
///   - 범인이 ①이면 → **프레임을 묶으면** 낫는다(싸다)
///   - 범인이 ③이면 → 묶어도 **아무 소용 없다.** 건수와 무관하게 오디오 HAL 이 무거운 것이다
///
/// ⛔ 그래서 묶기 수술(플러그인 벤더링 = 큰 작업) **전에** 이걸 먼저 잰다. 순서를 바꾸면
///   소용없을 수도 있는 수술에 큰 비용을 쓴다.
///
/// ⚠ 켜면 **에코가 안 걸린다** — 스피커폰에서는 비버가 자기 목소리에 끊길 수 있다.
/// 계측 전용이고, 그 자체가 이 실험의 알려진 부작용이다(측정을 무효로 만들지는 않는다 —
/// 우리가 보는 건 왕복 곡선이지 STT 품질이 아니다).
///
/// `--dart-define=MIC_NO_AEC=true` + 디버그 빌드에서만 동작한다.
abstract final class CascadeMicNoAec {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐 = 제품 동작.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('MIC_NO_AEC')` 였다. 컴파일 플래그라 **끄고 켤 때마다
  ///   APK 를 구워야 했고**, 그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다.
  ///   2026-08-14 에 그것 때문에 반나절을 태웠다(서버는 마이크를 열라는데 클라가 거부했고,
  ///   원인이 빌드 플래그라는 걸 화면에서 볼 방법이 없었다).
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  static bool get enabled => toggle.value && kDebugMode;
}

/// dev 전용 — 마이크는 열되 **업링크 전송만** 통화 내내 막는다.
///
/// ## 무엇을 가르나 — 넷 중 ④만 뺀다
///
/// [CascadeMicOff] 는 넷을 한꺼번에 뺐다(프레임 전달·AudioRecord 스레드·AEC·업링크).
/// 이 스위치는 **④ 업링크 소켓 전송만** 뺀다 — 프레임은 그대로 네이티브에서 Dart 로
/// 건너오고(①), 레코더도 AEC 도 그대로 돈다(②③).
///
///   - 곡선이 평평해지면 → 범인은 **업링크 전송**이다
///   - 그대로면 → 업링크는 무죄. ①②③ 중 하나다
///
/// ⭐ 벤더링이 필요 없다. 기존 반이중 게이트(`_micGated`)가 이미 **같은 자리에서**
///   프레임을 버리고 있으므로, 그 조건을 통화 내내 참으로 만들기만 하면 된다.
///
/// ⚠ 켜면 **사람 목소리가 서버에 안 간다**(자동 대화는 STT 를 안 타므로 대화는 굴러간다).
/// ⚠ `route_change.uplink_bytes` 가 0 으로 보고된다 — 실제로 안 보냈으니 맞는 값이다.
///
/// `--dart-define=MIC_ALWAYS_GATED=true` + 디버그 빌드에서만 동작한다.
abstract final class CascadeMicAlwaysGated {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐 = 제품 동작.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('MIC_ALWAYS_GATED')` 였다. 컴파일 플래그라 **끄고 켤 때마다
  ///   APK 를 구워야 했고**, 그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다.
  ///   2026-08-14 에 그것 때문에 반나절을 태웠다(서버는 마이크를 열라는데 클라가 거부했고,
  ///   원인이 빌드 플래그라는 걸 화면에서 볼 방법이 없었다).
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  static bool get enabled => toggle.value && kDebugMode;
}

/// dev 전용 — 마이크를 **파일로** 녹음한다(스트림 대신).
///
/// ## 마지막 갈림길 — ①과 ②를 가른다
///
/// 지금까지 넷 중 둘이 무죄로 지워졌다(③ AEC 81% · ④ 업링크 97% — 곡선이 그대로 섰다).
/// 남은 둘은 **①프레임당 채널 메시지**와 **②AudioRecord 스레드의 존재 자체**인데,
/// 이 둘은 마이크를 켜는 한 항상 같이 있어서 지금까지 못 갈랐다.
///
/// `toFile` 은 정확히 ①만 뺀다:
///   - AudioRecord 스레드·AEC·오디오 세션 → **그대로 돈다**(②③ 유지)
///   - 프레임당 채널 메시지 → **0건**(네이티브가 파일에 직접 쓴다)
///
/// 판정(미리 못박는다 — 나중에 합리화하지 않으려고):
///   - 기울기 ≤ 기준선의 30% → **① 확정.** 그때 벤더링 비용을 치른다
///   - 기울기 ≥ 80%          → **② 확정.** 묶기·백그라운드 큐가 전부 무의미하다.
///     ⭐ 이 경우 "벤더링을 안 해서 다행"이 결론이다
///   - 30~80%                → 부분 기여. 다시 설계한다
///
/// ⚠ 교란 점검: 이 통화 경로는 `setSubscriptionDuration` 을 **부르지 않는다**
///   (기본 `Duration.zero` = 진행 이벤트 없음). 80ms 로 켜는 곳은 복습 화면의
///   별도 레코더뿐이다. 즉 `toFile` 이면 마이크발 채널 메시지가 실제로 0 이 된다.
/// ⚠ 파일 쓰기라는 **새 부하**가 생긴다(디스크 I/O). 레코더 스레드 쪽이라 메인 큐와는
///   다른 축이지만, 대조군(네이티브 처리·elLag)이 두 판 모두 평평한지 확인해야 한다.
/// ⚠ 사람 목소리가 서버에 안 간다. 자동 대화는 STT 를 안 타므로 대화는 굴러간다.
///
/// `--dart-define=MIC_TO_FILE=true` + 디버그 빌드에서만 동작한다.
abstract final class CascadeMicToFile {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐 = 제품 동작.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('MIC_TO_FILE')` 였다. 컴파일 플래그라 **끄고 켤 때마다
  ///   APK 를 구워야 했고**, 그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다.
  ///   2026-08-14 에 그것 때문에 반나절을 태웠다(서버는 마이크를 열라는데 클라가 거부했고,
  ///   원인이 빌드 플래그라는 걸 화면에서 볼 방법이 없었다).
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  static bool get enabled => toggle.value && kDebugMode;
}

/// dev 전용 — **지터 쿠션이 자라지 않게 고정한다.**
///
/// 쿠션은 굶을 때마다 +150ms 씩 자라 상한 1.2초까지 간다. 그 값은 **모든 턴의 첫 소리에
/// 그대로 더해지므로**, 끊김을 줄이는 대신 응답이 굼떠 보이는 맞바꿈이다.
/// 이 토글은 그 맞바꿈의 **크기를 재기 위한 것**이다 — 성장을 끄면 끊김이 얼마나 늘어나는가.
///
/// ⛔ 성장만 끈다. **굶었다는 사실 자체는 그대로 센다** — 그게 이 실험의 측정값이다.
/// ⛔ 기본은 꺼짐 = 제품 동작(쿠션이 자란다).
abstract final class CascadeCushionGrowthOff {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('CUSHION_GROWTH_OFF')` 였다 — 켜려면 APK 를 구워야 했다.
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  static bool get enabled => toggle.value && kDebugMode;
}
