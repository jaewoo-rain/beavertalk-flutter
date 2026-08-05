import 'package:flutter/services.dart';

/// 재생 엔진의 **즉시 폐기(flush)** 를 호출하는 얇은 어댑터.
///
/// ## 왜 여기에 있나 (임시 경계)
///
/// barge-in 은 "비버를 끊는" 동작이고, 그러려면 이미 큐에 든 오디오를 버려야 한다.
/// 그런데 `flutter_pcm_sound` 의 메서드채널에는 지금
/// `setLogLevel / setup / feed / setFeedThreshold / release / getStats` 뿐이고
/// **flush/clear 가 없다**. 유일한 중단 수단인 `release()` 는 트랙을 죽이고
/// 스레드까지 내리므로 barge-in 마다 쓰기엔 재기동 비용이 크다.
///
/// 플러그인(`packages/flutter_pcm_sound`) 의 네이티브·Dart API 는 **bt-front 소유**라
/// 여기서 직접 추가할 수 없다. 그래서 정식 API 가 생길 때까지 **같은 메서드채널에
/// `clear` 를 직접 invoke** 하는 어댑터를 앱 쪽에 둔다.
///
/// 플러그인에 `FlutterPcmSound.clear()` 가 생기면 [clear] 본문 한 줄만 그쪽으로
/// 바꾸면 된다. 호출부는 손대지 않는다.
///
/// ## 없는 메서드를 불러도 안전하다
///
/// 네이티브가 아직 `clear` 를 모르면 [MissingPluginException] 이 나는데, 그걸 여기서
/// 삼키고 [ClearResult.unsupported] 를 돌려준다. 즉 **네이티브 작업이 끝나기 전에도
/// 앱은 정상 동작**하고, 호출부는 "폐기가 실제로 됐는지"를 반환값으로 구분할 수 있다.
class PcmPlaybackControl {
  const PcmPlaybackControl();

  /// 플러그인이 이미 쓰고 있는 채널. 이름이 갈리면 서로 다른 엔진을 만지게 되므로
  /// 반드시 플러그인과 같은 문자열이어야 한다.
  static const MethodChannel _channel =
      MethodChannel('flutter_pcm_sound/methods');

  /// 대기 큐 + 트랙 내부 버퍼를 비운다. 트랙 자체는 살려 둔다(재기동 비용 회피).
  ///
  /// 반환값은 **폐기한 입력 프레임 수**다. 이 숫자가 진행도 보고의 정확도를 좌우한다 —
  /// "엔진에 아직 안 나간 채로 남아 있던 양"을 알아야 "실제로 나간 양"이 나온다.
  /// 추정으로 대체하면 안 되는 값이라, 네이티브가 못 주면 [ClearResult.framesDiscarded]
  /// 를 null 로 둬서 **호출부가 폴백을 쓴다는 사실을 알 수 있게** 한다.
  static Future<ClearResult> clear() async {
    try {
      final res = await _channel.invokeMethod<dynamic>('clear');
      if (res is int) return ClearResult(ok: true, framesDiscarded: res);
      if (res is Map) {
        final v = res['frames_discarded'];
        return ClearResult(
          ok: true,
          framesDiscarded: v is num ? v.toInt() : null,
        );
      }
      // 구현은 됐는데 값을 안 주는 경우(void 반환) — 폐기는 믿고, 잔량은 모른다.
      return const ClearResult(ok: true, framesDiscarded: null);
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
  const ClearResult({required this.ok, required this.framesDiscarded});

  /// 네이티브가 실제로 큐를 비웠는가. false 면 Dart 링버퍼만 비워진 상태이므로
  /// 스피커에서는 남은 오디오가 계속 나온다 — 호출부가 로그로 드러내야 한다.
  final bool ok;

  /// 폐기한 입력 프레임 수. null 이면 네이티브가 알려주지 않은 것.
  final int? framesDiscarded;

  static const ClearResult unsupported =
      ClearResult(ok: false, framesDiscarded: null);
}
