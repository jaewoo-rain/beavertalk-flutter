import 'package:firebase_messaging/firebase_messaging.dart';

/// `firebase_messaging` 얇은 래퍼(상태 없음).
///
/// "밖에서 앱을 깨우는 트리거 = FCM"의 표면만 노출한다. 실제 수신 화면 표시는
/// 기존 [CallkitService]가 담당하고, 이 서비스는 (1) 알림 권한 요청, (2) 토큰
/// 조회/갱신, (3) 포그라운드 메시지 스트림만 감싼다.
///
/// 플러그인 정적 API를 감싸 (1) 테스트/교체 용이성, (2) 호출부에서 firebase 심볼을
/// 직접 다루지 않아도 되게 한다. 모든 사용처는 `kInboundCallEnabled && !kIsWeb`
/// 가드 안에서만 이 서비스에 접근해야 한다(웹/OFF 시 Firebase 미초기화).
class FcmService {
  /// 서비스를 생성한다(무상태). 내부적으로 [FirebaseMessaging.instance]를 사용한다.
  const FcmService();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// 알림 권한을 요청한다(Android 13+/iOS). Android는 CallKit 쪽에서도 요청하지만,
  /// FCM 표시 알림을 위해 여기서도 명시적으로 한 번 요청한다. 실패해도 던지지 않는다.
  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  /// 이 기기의 FCM 등록 토큰을 반환한다(서버가 이 기기로 푸시를 보낼 주소).
  /// 지금 단계에선 서버 등록 대신 로그로만 확인한다. 실패 시 null.
  Future<String?> getToken() => _messaging.getToken();

  /// 토큰이 갱신될 때마다 새 토큰을 흘려보내는 스트림. 앱 실행 중 재발급을 감지한다.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// 앱이 **포그라운드**일 때 도착하는 FCM 메시지 스트림. 백그라운드/종료 상태는
  /// top-level 핸들러([FirebaseMessaging.onBackgroundMessage])가 따로 처리한다.
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;
}
