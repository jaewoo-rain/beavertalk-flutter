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
    // NO .allowBluetoothA2DP: A2DP is output-only (no mic), and allowing it lets
    // iOS route call output over A2DP, breaking the BT mic (HFP) path — the user's
    // voice stops being captured. `.allowBluetooth` = HFP carries mic + speaker.
    try? session.setCategory(.playAndRecord, mode: .voiceChat,
        options: [.allowBluetooth, .defaultToSpeaker])
    try? session.setActive(true)
    steerInputToHeadset()
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
