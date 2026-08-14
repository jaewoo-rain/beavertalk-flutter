import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/cascade_auto_talk.dart';

/// dev 자동 대화 회귀.
///
/// ⚠ 이 도구는 **끊김 곡선 전용**이다. STT 가 안 타므로 응답시간 측정에 쓰면 안 된다 —
/// 그 구분이 흐려지면 잘못된 숫자로 서버를 고치게 된다.
void main() {
  // ⚠ 이 스위트는 `--dart-define=AUTO_TALK=true` 로도 돈다. **플래그 값을 하드코딩하면
  //   그 판에서 깨진다**(한 번 깨뜨렸다). 값이 아니라 **관계**를 고정한다.
  const flagOn = bool.fromEnvironment('AUTO_TALK');

  test('⛔ dart-define 이 없으면 꺼져 있다 — 배포 빌드에 새면 안 된다', () {
    expect(CascadeAutoTalk.flag, flagOn);
    if (!flagOn) {
      expect(CascadeAutoTalk.enabled, isFalse);
      expect(CascadeAutoTalk.suppressed, isFalse);
    }
  });

  test('enabled 는 플래그 **와** 디버그를 함께 요구한다', () {
    expect(CascadeAutoTalk.enabled, flagOn && kDebugMode);
  });

  test('릴리즈에서 플래그만 켜면 suppressed 로 드러난다 — 조용한 실패 금지', () {
    expect(CascadeAutoTalk.suppressed, flagOn && !kDebugMode);
    // 두 술어는 절대 동시에 참일 수 없다 — 그러면 "돌면서 동시에 무시됨"이 된다.
    expect(CascadeAutoTalk.enabled && CascadeAutoTalk.suppressed, isFalse);
  });

  group('문장', () {
    test('⭐ 한국어와 영어가 섞여 있다 — 코드스위칭이 재려는 부하다', () {
      final hasKo = CascadeAutoTalk.lines.any(
          (l) => RegExp(r'[가-힣]').hasMatch(l));
      final hasEn = CascadeAutoTalk.lines.any(
          (l) => RegExp(r'[A-Za-z]').hasMatch(l));
      final hasMixed = CascadeAutoTalk.lines.any((l) =>
          RegExp(r'[가-힣]').hasMatch(l) && RegExp(r'[A-Za-z]').hasMatch(l));
      expect(hasKo, isTrue);
      expect(hasEn, isTrue);
      expect(hasMixed, isTrue, reason: '한 문장 안에서 섞여야 구간이 쪼개진다');
    });

    test('순환한다 — 6분을 채우려면 문장이 떨어지면 안 된다', () {
      final n = CascadeAutoTalk.lines.length;
      expect(CascadeAutoTalk.lineAt(0), CascadeAutoTalk.lineAt(n));
      expect(CascadeAutoTalk.lineAt(n * 5 + 3), CascadeAutoTalk.lines[3]);
    });

    test('빈 문장이 없다 — 서버가 빈 입력으로 LLM 을 부르면 안 된다', () {
      for (final l in CascadeAutoTalk.lines) {
        expect(l.trim(), isNotEmpty);
      }
    });
  });

  group('타이밍', () {
    test('간격이 매번 같지 않다 — 서버 박자와 맞아 한 구간만 재는 것을 피한다', () {
      final gaps = List.generate(8, (i) => CascadeAutoTalk.gapFor(i).inMilliseconds);
      expect(gaps.toSet().length, greaterThan(1));
    });

    test('간격은 항상 기본값 이상이다 — 비버 말과 겹치면 안 된다', () {
      for (var i = 0; i < 20; i++) {
        expect(CascadeAutoTalk.gapFor(i), greaterThanOrEqualTo(CascadeAutoTalk.gap));
      }
    });

    test('같은 번호는 같은 간격 — 재현 가능해야 비교가 성립한다', () {
      expect(CascadeAutoTalk.gapFor(7), CascadeAutoTalk.gapFor(7));
    });

    test('6분 곡선을 담을 만큼 길다', () {
      expect(CascadeAutoTalk.duration, greaterThanOrEqualTo(const Duration(minutes: 6)));
    });
  });
}
