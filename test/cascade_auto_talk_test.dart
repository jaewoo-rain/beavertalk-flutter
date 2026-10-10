import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/cascade_auto_talk.dart';

/// dev 자동 대화 회귀.
///
/// ⚠ 이 도구는 **끊김 곡선 전용**이다. STT 가 안 타므로 응답시간 측정에 쓰면 안 된다 —
/// 그 구분이 흐려지면 잘못된 숫자로 서버를 고치게 된다.
void main() {
  // ⛔ 2026-08-14: dart-define 에서 **화면 토글**로 바뀌었다. 값이 아니라 **관계**를 고정하는
  //   규율은 그대로다 — 하드코딩하면 다른 판에서 깨진다(예전에 두 번 깼다).
  tearDown(() => CascadeAutoTalk.toggle.value = false);

  test('⛔ 기본은 꺼져 있다 — 켜 둔 채 잊는 것이 다음 사고다', () {
    expect(CascadeAutoTalk.toggle.value, isFalse);
    expect(CascadeAutoTalk.enabled, isFalse);
  });

  test('enabled 는 토글 **와** 디버그를 함께 요구한다', () {
    CascadeAutoTalk.toggle.value = true;
    expect(CascadeAutoTalk.enabled, kDebugMode);
  });

  test('⛔ 릴리즈에서는 토글을 켜도 안 돈다 — 실사용자에게 새면 안 된다', () {
    CascadeAutoTalk.toggle.value = true;
    if (!kDebugMode) expect(CascadeAutoTalk.enabled, isFalse);
  });

  test('토글을 되돌리면 즉시 꺼진다 — 리빌드 없이 끌 수 있어야 한다', () {
    CascadeAutoTalk.toggle.value = true;
    CascadeAutoTalk.toggle.value = false;
    expect(CascadeAutoTalk.enabled, isFalse);
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

    test('⭐ 6분 30초를 **넘겨야** 한다 — 사장님 체감이 그 지점부터다', () {
      // 7분이면 그 지점을 30초밖에 못 넘긴다 = 후반 증가율을 볼 구간이 없다.
      expect(CascadeAutoTalk.duration,
          greaterThan(const Duration(minutes: 6, seconds: 30)));
      expect(CascadeAutoTalk.duration, greaterThanOrEqualTo(const Duration(minutes: 10)));
    });
  });
}
