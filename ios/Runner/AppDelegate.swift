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
  // Earlier attempts used `overrideOutputAudioPort(.speaker)`. Two problems:
  //   1. An override is NOT sticky — pulling Control Center / any interruption
  //      resets it, dropping speaker back to the receiver.
  //   2. flutter_sound's recorder re-sets the session CATEGORY when it starts,
  //      often WITHOUT `.allowBluetooth`, so AirPods never appear in the route
  //      and no amount of setPreferredInput can reach them.
  //
  // The fix is to own the category, not an override: `.playAndRecord` +
  // `.voiceChat` + `[.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker]`.
  // With these options iOS routes to a connected BT headset when present and
  // otherwise DEFAULTS to the speaker — both behaviours are category-level and
  // survive Control Center. We re-assert it on every route change / interruption
  // (debounced against our own re-apply) so flutter_sound can't quietly drop it.
  private var callAudioRoutingActive = false
  private var lastRouteApply = Date(timeIntervalSince1970: 0)

  private func startCallAudioRouting() {
    let session = AVAudioSession.sharedInstance()
    if !callAudioRoutingActive {
      callAudioRoutingActive = true
      NotificationCenter.default.addObserver(
        self, selector: #selector(handleAudioRouteChange(_:)),
        name: AVAudioSession.routeChangeNotification, object: session)
      NotificationCenter.default.addObserver(
        self, selector: #selector(handleAudioInterruption(_:)),
        name: AVAudioSession.interruptionNotification, object: session)
    }
    applyCallAudioRoute()
  }

  private func stopCallAudioRouting() {
    if callAudioRoutingActive {
      callAudioRoutingActive = false
      NotificationCenter.default.removeObserver(
        self, name: AVAudioSession.routeChangeNotification, object: nil)
      NotificationCenter.default.removeObserver(
        self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
  }

  /// Own the category so routing is sticky: BT headset when present, else the
  /// loudspeaker. Idempotent — only re-applies when the live category/options
  /// don't already match, so repeated calls don't glitch the audio or loop.
  private func applyCallAudioRoute() {
    let session = AVAudioSession.sharedInstance()
    let wanted: AVAudioSession.CategoryOptions =
      [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker]
    lastRouteApply = Date()
    if session.category != .playAndRecord ||
       !session.categoryOptions.isSuperset(of: wanted) {
      try? session.setCategory(.playAndRecord, mode: .voiceChat, options: wanted)
    }
    try? session.setActive(true)
  }

  @objc private func handleAudioRouteChange(_ note: Notification) {
    guard callAudioRoutingActive else { return }
    // Debounce: ignore the route change our own setCategory/setActive just fired,
    // otherwise we'd re-apply in a loop.
    if Date().timeIntervalSince(lastRouteApply) < 0.5 { return }
    applyCallAudioRoute()
  }

  @objc private func handleAudioInterruption(_ note: Notification) {
    guard callAudioRoutingActive,
          let info = note.userInfo,
          let raw = info[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: raw)
    else { return }
    // When an interruption (Control Center, a system sound, etc.) ends, the
    // route/override may have been reset — re-assert our category.
    if type == .ended { applyCallAudioRoute() }
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
