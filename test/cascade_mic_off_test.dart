import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/cascade_experiment.dart';

/// MIC_OFF 실험 스위치 회귀.
///
/// ## 왜 있나 — **게이팅으로는 마이크를 못 끈다**
///
/// 통화 중 마이크 게이팅은 Dart 스트림 리스너 안에서 프레임을 버린다. 네이티브
/// 레코더는 계속 돌고 프레임은 이미 플랫폼 채널을 건너온 뒤 버려진다(원래 의도가
/// 그랬다 — 오디오 세션·AEC 를 흔들지 않으려고). 그래서 서버가 `mic_always_open=false`
/// 를 내려도 **플랫폼 스레드 부하는 안 준다.** 마이크가 왕복 지연의 원인인지 가리려면
/// 레코더 자체를 안 여는 스위치가 있어야 하고, 그게 이 스위치다.
///
/// ⛔ 2026-08-14: dart-define 에서 **화면 토글**로 바뀌었다. 컴파일 플래그일 때는 끄고 켤 때마다
///   APK 를 구워야 했고, 그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다.
void main() {
  final all = <String, ({ValueNotifier<bool> toggle, bool Function() enabled})>{
    'MIC_OFF': (toggle: CascadeMicOff.toggle, enabled: () => CascadeMicOff.enabled),
    'MIC_TO_FILE': (
      toggle: CascadeMicToFile.toggle,
      enabled: () => CascadeMicToFile.enabled
    ),
    'MIC_ALWAYS_GATED': (
      toggle: CascadeMicAlwaysGated.toggle,
      enabled: () => CascadeMicAlwaysGated.enabled
    ),
    'MIC_NO_AEC': (
      toggle: CascadeMicNoAec.toggle,
      enabled: () => CascadeMicNoAec.enabled
    ),
    'CUSHION_GROWTH_OFF': (
      toggle: CascadeCushionGrowthOff.toggle,
      enabled: () => CascadeCushionGrowthOff.enabled
    ),
  };

  tearDown(() {
    for (final e in all.values) {
      e.toggle.value = false;
    }
  });

  for (final entry in all.entries) {
    group(entry.key, () {
      final t = entry.value;

      test('⛔ 기본은 꺼져 있다 — 제품 동작이 기본이다', () {
        expect(t.toggle.value, isFalse);
        expect(t.enabled(), isFalse);
      });

      test('enabled 는 토글 **와** 디버그를 함께 요구한다', () {
        t.toggle.value = true;
        expect(t.enabled(), kDebugMode);
      });

      test('⛔ 릴리즈에서는 토글을 켜도 안 돈다 — 실사용자에게 새면 안 된다', () {
        t.toggle.value = true;
        if (!kDebugMode) expect(t.enabled(), isFalse);
      });

      test('되돌리면 즉시 꺼진다 — 리빌드 없이 끌 수 있어야 한다', () {
        t.toggle.value = true;
        t.toggle.value = false;
        expect(t.enabled(), isFalse);
      });
    });
  }

  test('⭐ 토글끼리 독립이다 — 하나를 켜도 다른 게 켜지지 않는다', () {
    CascadeMicOff.toggle.value = true;
    expect(CascadeMicToFile.enabled, isFalse);
    expect(CascadeMicAlwaysGated.enabled, isFalse);
    expect(CascadeMicNoAec.enabled, isFalse);
    expect(CascadeCushionGrowthOff.enabled, isFalse);
  });
}
