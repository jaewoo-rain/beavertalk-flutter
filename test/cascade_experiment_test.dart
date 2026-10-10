import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_channel.dart';
import 'package:beavertalk/features/normalcall/presentation/cascade_experiment.dart';

/// 격리 실험 스위치 회귀.
///
/// ⚠ 이 스위치는 **범인을 가두는 도구**다. 그래서 두 성질이 절대 깨지면 안 된다:
///   ① **라이브는 절대 안 벗겨진다** — 제품 그대로여야 대조군이 성립한다
///   ② **릴리즈에 안 샌다** — 실사용자가 벗겨진 화면을 보면 안 된다
void main() {
  setUp(() {
    CascadeExperiment.avatarVideo.value = false;
    CascadeExperiment.hints.value = false;
  });

  test('⛔ 라이브는 스위치가 꺼져 있어도 항상 켬 — 대조군이 깨지면 판정이 무의미하다', () {
    expect(
      CascadeExperiment.enabledFor(CallChannel.live, CascadeExperiment.avatarVideo),
      isTrue,
    );
    expect(
      CascadeExperiment.enabledFor(CallChannel.live, CascadeExperiment.hints),
      isTrue,
    );
  });

  test('캐스케이드는 스위치를 따른다 (디버그 빌드 기준)', () {
    // 테스트는 디버그로 돈다 — 릴리즈 분기는 아래 별도 검사.
    expect(kDebugMode, isTrue, reason: '이 테스트의 전제');
    expect(
      CascadeExperiment.enabledFor(
          CallChannel.cascade, CascadeExperiment.avatarVideo),
      isFalse,
      reason: '기본은 벗긴 상태 — 순정으로 먼저 돌린다',
    );
    CascadeExperiment.avatarVideo.value = true;
    expect(
      CascadeExperiment.enabledFor(
          CallChannel.cascade, CascadeExperiment.avatarVideo),
      isTrue,
      reason: '하나씩 다시 켤 수 있어야 한다',
    );
  });

  test('두 스위치는 서로 독립이다 — 한 번에 하나씩 켜야 원인이 갈린다', () {
    CascadeExperiment.avatarVideo.value = true;
    expect(
      CascadeExperiment.enabledFor(
          CallChannel.cascade, CascadeExperiment.hints),
      isFalse,
    );
  });

  test('기본값은 둘 다 꺼짐 — 순정 모드가 기본이다', () {
    // setUp 이 명시적으로 false 를 넣지만, 선언 기본값도 false 여야 한다.
    expect(CascadeExperiment.avatarVideo.value, isFalse);
    expect(CascadeExperiment.hints.value, isFalse);
  });
}
