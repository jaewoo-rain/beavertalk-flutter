import 'package:flutter/services.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';

/// 재생 엔진의 **즉시 폐기(flush)** 를 호출하는 얇은 어댑터.
///
/// ## 왜 어댑터를 두나
///
/// barge-in 은 "비버를 끊는" 동작이고, 그러려면 이미 큐에 든 오디오를 버려야 한다.
/// 유일한 다른 중단 수단인 `release()` 는 트랙을 죽이고 스레드까지 내리므로,
/// 턴마다 일어나는 barge-in 에 쓰기엔 재기동 비용이 크다.
/// 그래서 플러그인에 `clear()` 를 신설했고([FlutterPcmSound.clear]), 이 클래스는
/// 그 호출을 **실패해도 재생을 죽이지 않는 형태로** 감싼다.
///
/// 플러그인 API 가 없던 시절에는 여기서 메서드채널을 직접 두드렸다. 지금은 정식
/// API 를 부르므로 채널 이름이 갈릴 위험이 없다.
///
/// ## 실패를 삼키되, 숨기지는 않는다
///
/// 네이티브가 `clear` 를 모르거나(구버전 플러그인) 예외를 던지면
/// [ClearResult.unsupported] 를 돌려준다. 앱은 계속 돌지만 호출부는 **폐기가 실제로
/// 됐는지**를 반환값으로 구분할 수 있다 — 여기서 조용히 성공한 척하면
/// "끊었는데 안 끊긴다"가 원인 불명의 증상으로만 남는다.
class PcmPlaybackControl {
  const PcmPlaybackControl();

  /// 대기 큐 + 트랙 내부 버퍼를 비운다. 트랙 자체는 살려 둔다(재기동 비용 회피).
  ///
  /// 반환값은 **폐기한 입력 프레임 수**다. 이 숫자가 진행도 보고의 정확도를 좌우한다 —
  /// "엔진에 아직 안 나간 채로 남아 있던 양"을 알아야 "실제로 나간 양"이 나온다.
  /// 추정으로 대체하면 안 되는 값이라, 네이티브가 못 주면 [ClearResult.framesDiscarded]
  /// 를 null 로 둬서 **호출부가 폴백을 쓴다는 사실을 알 수 있게** 한다.
  static Future<ClearResult> clear() async {
    try {
      final raw = await FlutterPcmSound.clearDetailed();
      return ClearResult(
        ok: true,
        framesDiscarded: raw.framesDiscarded,
        halResidualMs: raw.halResidualMs,
        halResidualKnown: raw.halResidualKnown,
        writeInFlight: raw.writeInFlight,
      );
    } on MissingPluginException {
      return ClearResult.unsupported;
    } on PlatformException {
      return ClearResult.unsupported;
    } catch (_) {
      // 진단 경로가 재생을 죽이면 안 된다.
      return ClearResult.unsupported;
    }
  }
}

/// [PcmPlaybackControl.clear] 의 결과.
class ClearResult {
  const ClearResult({
    required this.ok,
    required this.framesDiscarded,
    this.halResidualMs = 0,
    this.halResidualKnown = false,
    this.writeInFlight = false,
  });

  /// 네이티브가 실제로 큐를 비웠는가. false 면 Dart 링버퍼만 비워진 상태이므로
  /// 스피커에서는 남은 오디오가 계속 나온다 — 호출부가 로그로 드러내야 한다.
  final bool ok;

  /// 폐기한 입력 프레임 수. null 이면 네이티브가 알려주지 않은 것.
  final int? framesDiscarded;

  /// flush 이후에도 **HAL/믹서에 남아 스피커에서 계속 울리는** 잔량(ms).
  ///
  /// `flush()` 는 AudioTrack 버퍼만 비운다. 이미 하드웨어 파이프라인으로 넘어간 오디오는
  /// 못 지운다. 그래서 "flush 완료 = 무음"이 아니고, 이 값을 더해야 실제 정지 시각이 된다.
  final int halResidualMs;

  /// 위 값이 **측정된 것인지**. false 면 0 은 "잔량 없음"이 아니라 **모름**이다.
  /// 호출부는 이 구분을 리포트에 그대로 실어야 한다 — 모름을 0 으로 섞으면 지연이
  /// 실제보다 좋아 보인다.
  final bool halResidualKnown;

  /// 폐기 시점에 재생 스레드가 실오디오 `write()` 안에 있었는가.
  ///
  /// true 면 그 데이터가 우리 flush **뒤에** 트랙으로 들어가 잠깐 더 울리고, 재생
  /// 스레드가 스스로 회수할 때까지 진짜 무음이 아니다. 그 회수는 이 호출이 반환한
  /// 뒤에 일어나므로 여기서 기다릴 수 없다 — 대신 보고값을 **하한**으로 표시해야 한다.
  final bool writeInFlight;

  static const ClearResult unsupported =
      ClearResult(ok: false, framesDiscarded: null);
}
