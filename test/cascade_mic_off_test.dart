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
/// ⛔ 값을 하드코딩하지 않는다. 이 스위트는 `--dart-define=MIC_OFF=true` 로도 도는데
///   (실험판 빌드가 실제로 그렇게 돈다), 하드코딩하면 그 판에서 깨진다 —
///   AUTO_TALK·CASCADE_BARGE_IN 에서 실제로 두 번 깼다. **관계**를 검사한다.
void main() {
  group('MIC_OFF 은 플래그와 디버그모드의 곱이다', () {
    test('켜졌다면 플래그가 켜져 있다 — 플래그 없이 저절로 켜지지 않는다', () {
      if (CascadeMicOff.enabled) expect(CascadeMicOff.flag, isTrue);
    });

    test('플래그가 꺼져 있으면 동작도 억제도 없다', () {
      if (!CascadeMicOff.flag) {
        expect(CascadeMicOff.enabled, isFalse);
        expect(CascadeMicOff.suppressed, isFalse);
      }
    });

    test('플래그가 켜지면 동작하거나 억제되거나 **둘 중 하나**다 — 조용히 사라지지 않는다', () {
      if (CascadeMicOff.flag) {
        expect(CascadeMicOff.enabled != CascadeMicOff.suppressed, isTrue);
        expect(CascadeMicOff.enabled, kDebugMode);
      }
    });

    test('⛔ 릴리즈에서는 절대 동작하지 않는다 — 실사용자 마이크가 죽으면 안 된다', () {
      if (!kDebugMode) expect(CascadeMicOff.enabled, isFalse);
    });
  });
}
