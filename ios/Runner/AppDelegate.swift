import Flutter
import UIKit
import PushKit
import AVFoundation
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PKPushRegistryDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register for VoIP push. This is the iOS counterpart of the Android FCM
    // path: a scheduled inbound call can wake the app — even when killed — and
    // ring through CallKit. Android uses FCM; iOS must use PushKit + APNs VoIP.
    let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    voipRegistry.delegate = self
    voipRegistry.desiredPushTypes = [PKPushType.voIP]
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
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
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  // MARK: - In-call audio routing
  //
  // flutter_sound's voice-processing pins the session output to the receiver
  // (earpiece). We want: any headset/AirPods connected → use it; nothing
  // external → loudspeaker (not the earpiece). A single one-shot check races BT
  // HFP negotiation — AirPods attach a beat AFTER the session activates, and
  // once we force `.speaker` the current route reads as the speaker, hiding the
  // AirPods entirely. So we observe route changes for the whole call: when a new
  // device appears we drop the override so audio follows it; when it's removed
  // we fall back to the speaker. This is what makes AirPods connect reliably.
  private var callAudioRoutingActive = false

  private func startCallAudioRouting() {
    let session = AVAudioSession.sharedInstance()
    if !callAudioRoutingActive {
      callAudioRoutingActive = true
      NotificationCenter.default.addObserver(
        self, selector: #selector(handleAudioRouteChange(_:)),
        name: AVAudioSession.routeChangeNotification, object: session)
    }
    applyCallAudioRoute()
  }

  private func stopCallAudioRouting() {
    if callAudioRoutingActive {
      callAudioRoutingActive = false
      NotificationCenter.default.removeObserver(
        self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
  }

  /// Route the in-call audio to the best target.
  ///
  /// Order: (1) a Bluetooth headset (AirPods) — route BOTH mic and output to it
  /// via `setPreferredInput`, which is what actually makes AirPods work for a
  /// two-way call. We look at `availableInputs` (NOT `currentRoute`) because once
  /// a speaker override is forced the current route reads as the speaker and
  /// hides the headset. (2) wired/AirPlay output → keep it. (3) nothing external
  /// → loudspeaker instead of the receiver.
  private func applyCallAudioRoute() {
    let session = AVAudioSession.sharedInstance()
    // (1) Bluetooth/USB/car headset with a mic → prefer it for input+output.
    if let inputs = session.availableInputs,
       let mic = inputs.first(where: {
         $0.portType == .bluetoothHFP || $0.portType == .headsetMic ||
         $0.portType == .usbAudio || $0.portType == .carAudio
       }) {
      try? session.overrideOutputAudioPort(.none)
      try? session.setPreferredInput(mic)
      return
    }
    // (2) Wired headphones / A2DP / AirPlay (output-only) → keep that route.
    let wiredOut: Set<AVAudioSession.Port> = [.headphones, .bluetoothA2DP, .airPlay]
    if session.currentRoute.outputs.contains(where: { wiredOut.contains($0.portType) }) {
      try? session.setPreferredInput(nil)
      try? session.overrideOutputAudioPort(.none)
      return
    }
    // (3) Nothing external → loudspeaker.
    try? session.setPreferredInput(nil)
    try? session.overrideOutputAudioPort(.speaker)
  }

  @objc private func handleAudioRouteChange(_ note: Notification) {
    guard callAudioRoutingActive,
          let info = note.userInfo,
          let raw = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
          let reason = AVAudioSession.RouteChangeReason(rawValue: raw)
    else { return }
    // Only react to a device being added/removed (AirPods connect/disconnect).
    // Our own setPreferredInput/override fire .override/.routeConfigurationChange
    // — reacting to those would loop, so they are ignored.
    switch reason {
    case .newDeviceAvailable, .oldDeviceUnavailable:
      applyCallAudioRoute()
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
