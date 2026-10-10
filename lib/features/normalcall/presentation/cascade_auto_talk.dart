import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// dev 전용 **자동 대화** — 마이크 없이 통화를 6분 이상 채운다.
///
/// ## 왜 있나
///
/// 우리가 쫓는 증상은 **시간이 갈수록 심해진다**(빈채널왕복 4ms → 2128ms). 곡선을 보려면
/// 6분을 채워야 하는데, 지금은 사람이 6분을 직접 말해야만 데이터가 나온다. 그게 병목이다.
/// 에뮬레이터에는 마이크가 없으므로(`AUDIO_DEVICE_NONE`) 글자를 직접 주입한다.
///
/// 서버가 이미 받는다: `{"type":"__test_say","text":"…"}` → `stream.feed_test(text)`.
/// **LLM·TTS·오디오 송출은 실제로 돈다** — 재생 경로가 그대로 살아 있다. 그게 측정 대상이다.
///
/// ## ⛔ 이 실험으로 잴 수 **없는** 것
///
/// **STT 자체가 안 돈다.** 침묵 대기(800ms)도, STT 인식 지연(188ms)도 이 경로엔 없다.
/// ⇒ **응답시간 측정용이 아니다. 끊김 곡선 전용이다.** 보고서에 이 구분을 반드시 적는다.
///
/// ## 켜는 법
///
/// 마이페이지 → 개발자 도구의 **화면 토글**로 켠다(기본 OFF).
/// ⚠ 추가로 [kDebugMode] 도 요구한다 — 배포 빌드에 새지 않게. 릴리즈에서는 그 토글이
///   **화면에 아예 안 그려지므로** 켜질 경로 자체가 없다.
abstract final class CascadeAutoTalk {
  /// 화면 토글(마이페이지 → 개발자 도구). **기본 꺼짐 = 제품 동작.**
  ///
  /// ⛔ 예전엔 `bool.fromEnvironment('AUTO_TALK')` 였다. 컴파일 플래그라 켤 때마다 APK 를
  ///   구워야 했고, 그래서 폰에 깔린 게 어느 빌드인지 화면에서 볼 수 없었다.
  static final ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

  /// 실제로 도는가.
  static bool get enabled => toggle.value && kDebugMode;

  /// 비버 발화가 끝난 뒤 이만큼 쉬고 다음 문장을 던진다.
  ///
  /// ⛔ 고정 주기 타이머로 쏘지 않는다. 비버 말과 겹치면 대기열·취소 경로가 섞여
  ///   **무엇을 재는지 흐려진다.** 발화 종료(턴 종료 + 오디오 배수 + 행오버)에만 건다.
  static const Duration gap = Duration(seconds: 2);

  /// 이만큼 지나면 스스로 끊는다.
  ///
  /// ⚠ 7분이었다. 그런데 사장님 체감이 **6분 30초부터 다시 끊긴다**라, 7분이면 그 지점을
  /// 30초밖에 못 넘긴다 — 후반 증가율을 볼 구간이 사실상 없다. 12분으로 올린다.
  /// (서버 `NORMAL_CALL_DURATION_S=900` 이 열려 있을 때만 여기까지 간다. 무료 플랜 상한이
  ///  걸린 환경에서는 서버가 300초에서 먼저 끊으므로 이 값과 무관하게 짧게 끝난다.)
  static const Duration duration = Duration(minutes: 12);

  /// 돌려 쓸 문장.
  ///
  /// ⭐ 한국어·영어를 **섞는다.** 실제 통화가 코드스위칭이고, TTS 가 언어별로 구간을
  /// 쪼개는 것이 우리가 재려는 부하다(구간 수가 늘면 마커·자막·송출 호출이 같이 는다).
  static const List<String> lines = [
    '안녕하세요, 오늘 날씨가 좋네요.',
    'Can you teach me how to order coffee in Korean?',
    '저는 어제 친구랑 영화를 봤어요. It was really fun.',
    'What does 반갑습니다 mean?',
    '한국 음식 중에서 what do you recommend for a beginner?',
    'I want to practice 존댓말 with you.',
    '주말에 보통 뭐 하세요?',
    'Could you say that again more slowly? 천천히 부탁해요.',
  ];

  /// [i] 번째 문장(순환).
  static String lineAt(int i) => lines[i % lines.length];

  /// 다음 문장까지의 대기 — 매번 같은 간격이면 서버 타이밍과 **박자가 맞아** 특정
  /// 구간만 반복 측정될 수 있다. 조금 흔들어 준다.
  static Duration gapFor(int i) =>
      gap + Duration(milliseconds: (math.Random(i).nextDouble() * 800).round());
}
