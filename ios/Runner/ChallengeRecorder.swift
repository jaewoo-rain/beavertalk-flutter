import Flutter
import ReplayKit
import UIKit

/// 발음 챌린지 화면 녹화 — iOS 판.
///
/// Dart 쪽 `ChallengeRecorder` 가 쓰는 `beavertalk/challenge_recorder`
/// MethodChannel 의 iOS 구현이다. Android 는 `MediaProjection` 으로 화면을
/// 미러링하지만 iOS 는 **ReplayKit 인앱 녹화**(`RPScreenRecorder`)를 쓴다.
///
/// ## 브로드캐스트 익스텐션이 필요 없다
/// ReplayKit 에는 두 가지 경로가 있고 자주 혼동된다.
///  * **브로드캐스트 업로드 익스텐션** — 다른 앱까지 포함해 화면 전체를 송출한다.
///    별도 타깃·App Group·엔타이틀먼트가 필요하다.
///  * **인앱 녹화**(`startRecording` / `stopRecording(withOutput:)`) — **이 앱이
///    그린 것만** 잡는다. 타깃도 엔타이틀먼트도 필요 없다.
///
/// 우리가 원하는 건 카메라 배경 + 게임 캔버스, 즉 이 앱이 그린 화면뿐이므로
/// 인앱 녹화가 정확히 맞다. Flutter 의 카메라 미리보기는 `FlutterTexture` 로
/// Flutter 렌더 표면에 합성되므로 앱 콘텐츠에 포함될 것으로 본다 — 다만
/// **실기기 미검증이다**(맥이 없어 빌드·실행을 못 했다). 첫 iOS 런에서
/// 확인해야 할 두 가지: ① 카메라 배경이 클립에 찍히는가, ② ReplayKit 이
/// `AVAudioSession` 을 건드려 STT 마이크 캡처를 끊지 않는가.
///
/// `stopRecording(withOutput:)` 은 iOS 14+ 다. 이 앱의 배포 타깃은 15.0 이라
/// 조건 없이 쓸 수 있다.
///
/// ## 무음인 이유는 Android 와 같다
/// `isMicrophoneEnabled = false` 로 못 박는다. 마이크는 STT 캡처가 쥐고 있고,
/// iOS 의 `AVAudioSession` 은 깨끗한 동시 소유자를 하나만 허용한다. 여기서
/// 마이크를 켜면 게임 입력 자체가 죽는다 — 클립에 목소리를 넣는 것보다
/// 게임이 도는 쪽이 먼저다.
///
/// 모든 실패는 `false` / `nil` 로 되돌아간다. 녹화는 없어도 되는 덤이고,
/// 실패해도 게임은 계속 플레이된다.
final class ChallengeRecorder {

  private static let channelName = "beavertalk/challenge_recorder"
  private static let fileName = "beavertalk_challenge.mp4"

  /// 진행 중인 녹화가 쓸 출력 파일. `stop` 이 끝나면 비운다.
  private var outputURL: URL?

  /// `start` 가 성공해 캡처가 도는 중인지. `RPScreenRecorder.isRecording` 은
  /// 시스템이 중간에 끊으면 우리가 모르는 사이 false 가 되므로, 우리 쪽 의도도
  /// 따로 들고 있는다.
  private var started = false

  /// 채널을 연결한다. `AppDelegate` 의 didFinishLaunching 에서 한 번 부른다.
  func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: ChallengeRecorder.channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(nil)
        return
      }
      switch call.method {
      case "start":
        self.start(result: result)
      case "stop":
        self.stop(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func start(result: @escaping FlutterResult) {
    let recorder = RPScreenRecorder.shared()
    // 이미 돌고 있으면 두 번 켜지 않는다(Dart 쪽도 막지만 여기서도 막는다).
    if started || recorder.isRecording {
      result(false)
      return
    }
    // 통화 중·AirPlay·시뮬레이터 등에서는 애초에 불가능하다.
    guard recorder.isAvailable else {
      NSLog("ChallengeRecorder: RPScreenRecorder 사용 불가 → 클립 없음")
      result(false)
      return
    }
    // 마이크는 STT 가 쥔다. 여기서 켜면 게임 입력이 죽는다.
    recorder.isMicrophoneEnabled = false
    recorder.isCameraEnabled = false

    recorder.startRecording { [weak self] error in
      // 권한 거부·시스템 거절 모두 여기로 온다.
      DispatchQueue.main.async {
        guard let self = self else {
          result(false)
          return
        }
        if let error = error {
          NSLog("ChallengeRecorder.start 실패 → 클립 없음: \(error.localizedDescription)")
          self.started = false
          result(false)
          return
        }
        self.started = true
        result(true)
      }
    }
  }

  private func stop(result: @escaping FlutterResult) {
    let recorder = RPScreenRecorder.shared()
    guard started else {
      result(nil)
      return
    }
    started = false

    // ReplayKit 은 출력 경로에 파일이 이미 있으면 실패한다. 매번 지우고 쓴다.
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent(ChallengeRecorder.fileName)
    try? FileManager.default.removeItem(at: url)
    outputURL = url

    recorder.stopRecording(withOutput: url) { [weak self] error in
      DispatchQueue.main.async {
        self?.outputURL = nil
        if let error = error {
          NSLog("ChallengeRecorder.stop 실패: \(error.localizedDescription)")
          result(nil)
          return
        }
        // Android 판과 같은 판정 — 잘린 빈 파일도 exists() 는 통과하므로
        // 최소 크기를 함께 본다.
        let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
        let size = (attrs?[.size] as? NSNumber)?.int64Value ?? 0
        guard size > 4096 else {
          NSLog("ChallengeRecorder.stop: 산출 파일이 너무 작다(\(size)B) → 클립 없음")
          result(nil)
          return
        }
        result(url.path)
      }
    }
  }
}
