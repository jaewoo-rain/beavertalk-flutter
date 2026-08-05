import Flutter
import UIKit
import PushKit
import AVFoundation
import CallKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate,
  PKPushRegistryDelegate, CallkitIncomingAppDelegate {
  // MUST be an instance property, not a local in didFinishLaunching: PKPushRegistry
  // has to be retained for the app's lifetime. As a local it is deallocated the
  // moment the method returns, so `pushRegistry(_:didUpdate:)` never fires and the
  // VoIP token is never obtained — which is why `device_token` had ZERO ios_voip
  // rows and scheduled calls never rang on iOS.
  private var voipRegistry: PKPushRegistry?
  // Captured in pushRegistry(didUpdate:) and exposed to Dart via getVoipToken.
  private var voipTokenHex: String?

  // ── Accept delivery guarantee ─────────────────────────────────────────────
  // The plugin ships accept/audio-session events over an EventChannel with NO
  // buffering — `eventSink?(data)`, a single optional-chained call. If Dart is
  // not subscribed at that exact instant (still booting, or the process was
  // frozen), the event is gone for good: CallKit connects the call and runs its
  // timer while the app never learns it was answered. That is exactly the
  // "native call screen counts up but nothing happens" symptom.
  //
  // So we ALSO latch the state here, natively, and let Dart PULL it whenever it
  // is ready. Events stay the fast path; these are the source of truth.
  private var pendingAcceptedCall: [String: Any]?
  private var callAudioSessionActive = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register for VoIP push. This is the iOS counterpart of the Android FCM
    // path: a scheduled inbound call can wake the app — even when killed — and
    // ring through CallKit. Android uses FCM; iOS must use PushKit + APNs VoIP.
    ensureVoipRegistry()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Idempotently create + retain the PKPushRegistry and request the VoIP token.
  /// Called from BOTH didFinishLaunching and the implicit-engine init so the
  /// registry is guaranteed to exist regardless of launch path.
  private func ensureVoipRegistry() {
    guard voipRegistry == nil else { return }
    let registry = PKPushRegistry(queue: DispatchQueue.main)
    registry.delegate = self
    registry.desiredPushTypes = [PKPushType.voIP]
    voipRegistry = registry
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Belt-and-suspenders: guarantee the VoIP registry exists even if the
    // didFinishLaunching path differs under the implicit-engine lifecycle.
    ensureVoipRegistry()
    // Speakerphone routing for in-call audio. flutter_sound's voice-processing
    // pins the session output to the earpiece(receiver); Dart calls this after
    // the mic pipeline is up to force the loudspeaker — unless a headset/AirPods
    // is connected, in which case we clear the override and keep that route.
    if let messenger = engineBridge.pluginRegistry
      .registrar(forPlugin: "BeaverAudioRoute")?.messenger() {
      let channel = FlutterMethodChannel(
        name: "beavertalk/audio", binaryMessenger: messenger)
      channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "routeToSpeaker":
          // Start-of-call: evaluate once (accurate before any override) and
          // observe route changes for the rest of the call.
          self?.startCallAudioRouting()
          result(nil)
        case "stopCallAudioRouting":
          // End-of-call: stop observing and clear the override.
          self?.stopCallAudioRouting()
          result(nil)
        case "getAudioRoute":
          // barge-in 진행도 보고에 "비버 오디오가 어느 출력으로 나가던 중이었나"를 싣는다.
          // isHeadsetConnected 는 bool 이라 스피커/유선/BT/USB 를 못 가른다 — 서버가
          // 해석하려면 분류가 필요하다. 기존 bool 은 VPIO 활성화 판단에 계속 쓰이므로
          // 그대로 두고 여기에 별도로 낸다.
          result(self?.currentAudioRoute() ?? "")
        case "isHeadsetConnected":
          // Dart asks before opening the recorder so it can disable voice
          // processing when a headset is present (see below).
          result(self?.isHeadsetConnected() ?? false)
        case "logAudioState":
          let tag = (call.arguments as? [String: Any])?["tag"] as? String ?? "?"
          self?.logAudioState(tag)
          result(nil)
        case "getVoipToken":
          // Authoritative VoIP token straight from PKPushRegistry — bypasses the
          // callkit plugin bridge (which can drop the token if didUpdate fires
          // before the plugin's sharedInstance exists). Returns nil if PushKit
          // has not issued a token yet.
          result(self?.currentVoipTokenHex())
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    // CallKit state bridge — the pull side of the accept-delivery guarantee.
    // `incoming_call_coordinator` polls these instead of trusting the plugin's
    // unbuffered event stream.
    if let messenger = engineBridge.pluginRegistry
      .registrar(forPlugin: "BeaverCallkitBridge")?.messenger() {
      let channel = FlutterMethodChannel(
        name: "beavertalk/callkit", binaryMessenger: messenger)
      channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "getPendingAcceptedCall":
          // The accepted call latched in onAccept, or nil. Dart consumes it and
          // then calls clearPendingAcceptedCall.
          result(self?.pendingAcceptedCall)
        case "clearPendingAcceptedCall":
          self?.pendingAcceptedCall = nil
          result(nil)
        case "isCallAudioSessionActive":
          // True between CallKit's didActivate and didDeactivate. Dart starts the
          // mic/playback on this rather than guessing with a fixed delay.
          result(self?.callAudioSessionActive ?? false)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  // MARK: - CallkitIncomingAppDelegate
  //
  // Adopting this protocol changes one contract: the plugin auto-fulfills the
  // CallKit action ONLY when the app delegate does NOT adopt it (see
  // SwiftFlutterCallkitIncomingPlugin `provider(_:perform:)`, the `else` branch).
  // Now that we adopt it, fulfilling is OUR job — miss it and the answer action
  // never completes, i.e. the call never connects at all.
  // `onTimeOut` is the exception: the plugin fulfills that one itself.

  func onAccept(_ call: Call, _ action: CXAnswerCallAction) {
    // Put OUR category in place before CallKit activates the session. The plugin's
    // own configureAudioSession is disabled (see `configureAudioSession: false`)
    // because it forces `.allowBluetoothA2DP` — an output-only profile that breaks
    // the Bluetooth HFP mic — plus mode `.default` instead of `.voiceChat`, and
    // re-applies the whole thing 1200ms later, right on top of our mic startup.
    configureCallAudioCategory()
    pendingAcceptedCall = [
      "id": call.data.uuid,
      "nameCaller": call.data.nameCaller,
      "extra": call.data.extra,
    ]
    NSLog("[callkit] onAccept latched id=%@", call.data.uuid)
    logAudioState("callkit/onAccept")
    action.fulfill()
  }

  func onDecline(_ call: Call, _ action: CXEndCallAction) {
    clearPendingIfMatches(call.data.uuid)
    action.fulfill()
  }

  func onEnd(_ call: Call, _ action: CXEndCallAction) {
    clearPendingIfMatches(call.data.uuid)
    callAudioSessionActive = false
    action.fulfill()
  }

  func onTimeOut(_ call: Call) {
    clearPendingIfMatches(call.data.uuid)
  }

  func didActivateAudioSession(_ audioSession: AVAudioSession) {
    callAudioSessionActive = true
    logAudioState("callkit/didActivate")
  }

  func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
    callAudioSessionActive = false
    logAudioState("callkit/didDeactivate")
  }

  func providerDidReset() {
    pendingAcceptedCall = nil
    callAudioSessionActive = false
  }

  /// Drops the latched accept when it refers to the call being ended, so a stale
  /// entry can never re-trigger a conversation after the user hung up.
  private func clearPendingIfMatches(_ uuid: String) {
    if (pendingAcceptedCall?["id"] as? String) == uuid {
      pendingAcceptedCall = nil
    }
  }

  /// Current PushKit VoIP token as a hex string, or nil if none yet. Prefers the
  /// value captured in `didUpdate`, else queries the registry directly.
  private func currentVoipTokenHex() -> String? {
    if let t = voipTokenHex, !t.isEmpty { return t }
    guard let data = voipRegistry?.pushToken(for: .voIP) else { return nil }
    return data.map { String(format: "%02x", $0) }.joined()
  }

  // MARK: - In-call audio routing
  //
  // The goal: AirPods/headset connected → use it (both mic and output); nothing
  // external → loudspeaker (not the earpiece).
  //
  // We OWN the category once, at call start (after flutter_sound's recorder has
  // configured the session): `.playAndRecord` + `.voiceChat` +
  // `[.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker]`. iOS then routes
  // to a connected BT headset when present (allowBluetooth) and otherwise
  // DEFAULTS to the speaker (defaultToSpeaker). Both are category-level, so they
  // survive Control Center WITHOUT any re-application — unlike an
  // `overrideOutputAudioPort(.speaker)`, which Control Center resets.
  //
  // CRITICAL: do NOT re-apply setCategory/setActive reactively (on interruptions
  // or generic route changes). Doing so tears down flutter_sound's live audio
  // units and drops the call (observed: Control Center killed the call). We only
  // observe real headset connect/disconnect and steer the mic with the light
  // `setPreferredInput` — which does not disturb an ongoing session.
  private var callAudioRoutingActive = false

  private func startCallAudioRouting() {
    let session = AVAudioSession.sharedInstance()
    if !callAudioRoutingActive {
      callAudioRoutingActive = true
      NotificationCenter.default.addObserver(
        self, selector: #selector(handleAudioRouteChange(_:)),
        name: AVAudioSession.routeChangeNotification, object: session)
    }
    configureCallAudioCategory()
    // Activation has exactly one owner. On the CallKit path the system activates
    // the session (didActivate) and re-activating underneath it disturbs the live
    // call; only the home path — no CallKit call involved — activates it here.
    if !callAudioSessionActive {
      try? session.setActive(true)
    }
    steerInputToHeadset()
  }

  /// Dumps the live audio-session state to the system log.
  ///
  /// Dart's own logging is compiled out of release builds, and the lock-screen
  /// call flow can ONLY be exercised from a TestFlight (release) build — so
  /// without this a failed call gives us nothing to go on. NSLog survives release
  /// and is readable in Console.app / `idevicesyslog`, filtered on "[audio]".
  private func logAudioState(_ tag: String) {
    let s = AVAudioSession.sharedInstance()
    let outs = s.currentRoute.outputs.map { $0.portType.rawValue }
      .joined(separator: ",")
    let ins = s.currentRoute.inputs.map { $0.portType.rawValue }
      .joined(separator: ",")
    let avail = (s.availableInputs ?? []).map { $0.portType.rawValue }
      .joined(separator: ",")
    NSLog(
      "[audio] %@ | category=%@ mode=%@ opts=%lu | out=[%@] in=[%@] avail=[%@] | callkitSession=%@",
      tag, s.category.rawValue, s.mode.rawValue,
      UInt(s.categoryOptions.rawValue), outs, ins, avail,
      callAudioSessionActive ? "ACTIVE" : "inactive")
  }

  /// Category/mode for a call. Never touches `setActive` — see startCallAudioRouting.
  ///
  /// NO .allowBluetoothA2DP: A2DP is output-only (no mic), and allowing it lets
  /// iOS route call output over A2DP, breaking the BT mic (HFP) path — the user's
  /// voice stops being captured. `.allowBluetooth` = HFP carries mic + speaker.
  private func configureCallAudioCategory() {
    try? AVAudioSession.sharedInstance().setCategory(
      .playAndRecord, mode: .voiceChat,
      options: [.allowBluetooth, .defaultToSpeaker])
  }

  private func stopCallAudioRouting() {
    if callAudioRoutingActive {
      callAudioRoutingActive = false
      NotificationCenter.default.removeObserver(
        self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    try? AVAudioSession.sharedInstance().setPreferredInput(nil)
  }

  /// Steer the mic to a Bluetooth/wired headset when one is connected; otherwise
  /// leave the built-in mic (output already follows the category default). Light
  /// touch — `setPreferredInput` only, no setCategory/setActive — so it does not
  /// disrupt a live call.
  private func steerInputToHeadset() {
    let session = AVAudioSession.sharedInstance()
    let mic = session.availableInputs?.first(where: {
      $0.portType == .bluetoothHFP || $0.portType == .headsetMic ||
      $0.portType == .usbAudio || $0.portType == .carAudio
    })
    try? session.setPreferredInput(mic)  // nil → back to the built-in mic
  }

  /// True when a Bluetooth/wired/USB/car headset is connected (as input or
  /// output). Dart calls this before opening the recorder: with a headset we
  /// disable flutter_sound's voice processing (VoiceProcessingIO), which on iOS
  /// refuses to use the Bluetooth HFP mic — so the user's voice was never
  /// captured over AirPods. A plain recorder follows the session route and uses
  /// the BT mic. Voice processing is only needed for the loudspeaker case (echo
  /// cancellation), where no headset is present.
  /// 지금 실제로 소리가 나가는 출력의 종류. 서버 계약 문자열로 낸다.
  ///
  /// ⚠ 모르면 빈 문자열이다. "speaker" 로 떨어뜨리면 서버가 "못 읽음"과 "스피커였음"을
  ///   구분하지 못해, 측정 못 한 기기가 전부 스피커폰 통계에 섞인다.
  private func currentAudioRoute() -> String {
    let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
    guard let port = outputs.first else { return "" }
    // speaker / headset 두 값만. 서버는 이 값을 분류표가 아니라 **그룹 키**로 쓴다 —
    // 같은 라우트엔 항상 같은 문자열이면 되고, 세분화하면 오히려 "라우트가 바뀌었다"는
    // 신호가 희석된다. (A2DP/HFP 구분은 나중 단계에서 AEC 정책 때문에 필요해진다.)
    //
    // ⚠ builtInReceiver(리시버)는 "receiver" 라는 **제3의 값**이다. 스피커폰도 헤드셋도
    //   아니라 둘 중 아무 데나 넣으면 틀린 값이 되고, 그렇다고 빈 문자열도 아니다 —
    //   빈 값은 서버가 "라우트 불명"으로 읽어 "이어폰을 꽂았다 빼며 재측정하라"는 처방을
    //   낸다. 아는데 모른다고 하면 측정하는 사람이 헛수고한다.
    switch port.portType {
    case .builtInSpeaker: return "speaker"
    case .builtInReceiver: return "receiver"
    case .headphones, .headsetMic, .bluetoothA2DP, .bluetoothLE,
         .bluetoothHFP, .usbAudio, .carAudio: return "headset"
    default: return ""
    }
  }

  private func isHeadsetConnected() -> Bool {
    let session = AVAudioSession.sharedInstance()
    let inPorts: Set<AVAudioSession.Port> = [
      .bluetoothHFP, .headsetMic, .usbAudio, .carAudio,
    ]
    if let inputs = session.availableInputs,
       inputs.contains(where: { inPorts.contains($0.portType) }) {
      return true
    }
    let outPorts: Set<AVAudioSession.Port> = [
      .headphones, .bluetoothA2DP, .bluetoothHFP, .bluetoothLE,
      .airPlay, .usbAudio, .carAudio,
    ]
    return session.currentRoute.outputs.contains { outPorts.contains($0.portType) }
  }

  @objc private func handleAudioRouteChange(_ note: Notification) {
    guard callAudioRoutingActive,
          let info = note.userInfo,
          let raw = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
          let reason = AVAudioSession.RouteChangeReason(rawValue: raw)
    else { return }
    // React ONLY to a headset being physically added/removed (AirPods connect/
    // disconnect). Ignore Control Center / overrides / config changes — reacting
    // there (re-activating the session) drops the live call.
    switch reason {
    case .newDeviceAvailable, .oldDeviceUnavailable:
      steerInputToHeadset()
    default:
      break
    }
  }

  // VoIP token → hand to the plugin, which surfaces it to Flutter via
  // getDevicePushTokenVoIP() / the actionDidUpdateDevicePushTokenVoip event so
  // DeviceRegistrationController can POST it to /devices (platform ios_voip).
  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate credentials: PKPushCredentials,
    for type: PKPushType
  ) {
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    voipTokenHex = token
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didInvalidatePushTokenFor type: PKPushType
  ) {
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  // Incoming VoIP push → immediately report a CallKit incoming call. iOS 13+
  // REQUIRES every VoIP push to report a call here (or it kills the app), so we
  // ring synchronously from the native payload rather than routing through Dart.
  // Accept/decline still flow to Flutter via FlutterCallkitIncoming.onEvent, so
  // the existing incoming_call_coordinator handles them unchanged.
  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType,
    completion: @escaping () -> Void
  ) {
    guard type == .voIP else { completion(); return }
    let dict = payload.dictionaryPayload
    let id = dict["id"] as? String ?? UUID().uuidString
    let nameCaller = dict["nameCaller"] as? String ?? "비버 튜터"
    let handle = dict["handle"] as? String ?? "한국어 통화"
    let isVideo = dict["isVideo"] as? Bool ?? false
    let data = flutter_callkit_incoming.Data(
      id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
    // We own the audio session category (configureCallAudioCategory). Leaving the
    // plugin's own configuration on would re-add .allowBluetoothA2DP and mode
    // .default, and re-apply them 1200ms after answer — on top of our mic startup.
    data.configureAudioSession = false
    if let extra = dict["extra"] as? [String: Any] {
      data.extra = NSDictionary(dictionary: extra)
    }
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(
      data, fromPushKit: true
    ) {
      completion()
    }
  }
}
