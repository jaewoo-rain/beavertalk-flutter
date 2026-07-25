import Flutter
import UIKit
import PushKit
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
