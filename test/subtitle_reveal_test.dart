import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// 자막 타자기 속도 + 마이크 게이트 사유 회귀.
///
/// 봉투 틱 = 25ms, 오디오 24kHz·16bit = 48,000 B/s → **틱당 1,200 B**.
void main() {
  group('① 다음 마커가 있으면 — 차분이 곧 정확한 길이다(추정 아님)', () {
    test('글자가 그 구간의 소리와 같이 끝난다', () {
      // 12,000 B = 10틱(250ms). 10글자면 1.0 자/틱 → 정확히 10틱에 끝난다.
      expect(revealRatePerTick(text: '0123456789', spanBytes: 12000), 1.0);
    });

    test('같은 글자수라도 구간이 길면 느려진다', () {
      final short = revealRatePerTick(text: '안녕하세요', spanBytes: 12000);
      final long = revealRatePerTick(text: '안녕하세요', spanBytes: 48000);
      expect(long, lessThan(short));
    });

    test('차분이 있으면 언어 기본값을 **안 쓴다** — 실측이 추정을 이긴다', () {
      // 한글인데도 언어 기본값(0.19)이 아니라 차분에서 나온 값이어야 한다.
      expect(revealRatePerTick(text: '안녕하세요', spanBytes: 6000), 1.0);
    });
  });

  group('② 다음 마커가 없으면 — 이 턴의 실측 비율로 추정, 짧은 쪽 편향', () {
    test('⛔ 추정은 짧은 쪽으로 틀린다 — 길게 틀리면 남은 글자를 한 번에 쏟는다', () {
      // 비율 10글자/12000B. 10글자면 추정 12000B=10틱인데, 편향 0.8 로 8틱에 끝낸다.
      final r = revealRatePerTick(
          text: '0123456789', charsPerByte: 10 / 12000);
      expect(r, greaterThan(1.0), reason: '편향 없으면 1.0 — 그보다 빨라야 한다');
      expect(r, closeTo(1.25, 0.001)); // 10글자 / 8틱
    });

    test('차분이 있으면 비율은 무시된다(① 우선)', () {
      final withSpan = revealRatePerTick(
          text: '0123456789', spanBytes: 12000, charsPerByte: 10 / 1200);
      expect(withSpan, 1.0);
    });
  });

  group('③ 아무 재료도 없을 때만 언어별 실측 기본값', () {
    // 근거: 한국어 6.3~8.5 자/초(중앙 7.7) → 0.19 자/틱, 영어 19.6 자/초 → 0.49 자/틱.
    test('⛔ 한글이 섞이면 느린 쪽 — 한글 1글자가 영문 3~4글자 소리다', () {
      expect(revealRatePerTick(text: '안녕하세요'), closeTo(0.19, 0.001));
      expect(revealRatePerTick(text: 'hello there'), closeTo(0.49, 0.001));
      expect(revealRatePerTick(text: 'my 한국어 study'), closeTo(0.19, 0.001));
    });

    test('빈 조각·0 구간은 즉시 끝난다(0으로 나누지 않는다)', () {
      expect(revealRatePerTick(text: ''), 1.0);
      final r = revealRatePerTick(text: 'abc', spanBytes: 0);
      expect(r.isFinite, isTrue);
    });

    test('구간이 한 틱보다 짧으면 기본값으로 떨어진다 — 무한대가 안 나온다', () {
      final r = revealRatePerTick(text: 'hello', spanBytes: 100); // 0.08틱
      expect(r.isFinite, isTrue);
      expect(r, closeTo(0.49, 0.001));
    });
  });

  group('마이크 게이트 사유 — 무엇이 막았는지 말한다', () {
    // ⚠ 이게 없으면 "끼어들기가 안 된다"에서 통로 문제인지 서버 정책인지 못 가른다.
    // ⛔ 2026-08-14: 셋째 관문(클라 컴파일 스위치 `ANDROID_VOICE_AUDIO`)을 **없앴다.**
    //   그게 빠진 APK 가 돌아다녀 반나절을 태웠기 때문이다 — 판단은 이제 서버 한 곳이다.
    test('라이브 통로가 먼저 막는다', () {
      expect(
        micGateReason(channelGates: true, serverMicAlwaysOpen: true),
        contains('라이브 통로'),
      );
    });

    test('⛔ 서버가 닫으라고 하면 그렇게 말한다 — 실기기에서 이 경우였다', () {
      expect(
        micGateReason(
            channelGates: false, serverMicAlwaysOpen: false),
        contains('mic_always_open=false'),
      );
    });

    test('⭐ 두 관문이 다 통과면 사유가 없다 = 열려 있어야 한다', () {
      // 예전엔 여기서 셋째 관문(AEC 스위치)이 걸려 '알 수 없음'이 안 나왔다.
      // 그 스위치를 없앴으므로 이 조합은 **열린 상태**여야 한다.
      expect(
        micGateReason(channelGates: false, serverMicAlwaysOpen: true),
        '알 수 없음',
      );
    });

    test('⛔ 클라가 서버 요청을 거부할 길이 없다 — 사유에 컴파일 스위치가 안 나온다', () {
      // 이 단언이 깨지면 누군가 클라 쪽 안전장치를 되살린 것이다. 그러면 「서버는 열라는데
      // 안 열린다」가 다시 생기고, 화면·로그 어디에도 안 드러난다.
      for (final gates in [true, false]) {
        for (final open in [true, false]) {
          expect(
            micGateReason(channelGates: gates, serverMicAlwaysOpen: open),
            isNot(contains('ANDROID_VOICE_AUDIO')),
          );
        }
      }
    });
  });
}
