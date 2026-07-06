import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../features/incoming_call/data/models/incoming_call_payload_dto.dart';
import '../features/incoming_call/services/callkit_service.dart';

/// 앱이 **백그라운드/종료** 상태일 때 도착한 FCM 메시지를 처리하는 최상위 핸들러.
///
/// 이 함수는 앱과 분리된 별도 isolate에서 실행된다. 그래서:
/// - Riverpod의 [ProviderContainer]에 접근할 수 없다 → [CallkitService]를 **직접 생성**한다.
/// - Firebase가 아직 초기화 안 됐을 수 있다 → [Firebase.initializeApp]을 먼저 호출한다.
/// - 트리 셰이킹/난독화로 제거되지 않도록 반드시 `@pragma('vm:entry-point')`를 단다.
///
/// 하는 일은 포그라운드 경로와 동일하다: FCM `data`(전부 String)를
/// [IncomingCallPayloadDto.fromMap]으로 도메인 페이로드에 매핑하고, 기존 CallKit
/// 수신 화면을 그대로 띄운다.
///
/// 등록은 `push_bootstrap.dart`의 `initIncomingCallLocal`에서
/// `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler)`로 한다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // 이 isolate에는 앱의 초기화가 전파되지 않으므로 Firebase를 다시 켠다
    // (옵션 없이 → android/app/google-services.json 자동 사용).
    await Firebase.initializeApp();

    // FCM data는 전부 String. 기존 DTO가 camel/snake·문자열/정수를 방어 파싱한다.
    final payload = IncomingCallPayloadDto.fromMap(message.data);

    // Riverpod 접근 불가 isolate이므로 서비스를 직접 만들어 수신 화면을 띄운다.
    await const CallkitService().showIncoming(payload);
  } catch (e, s) {
    // 백그라운드 처리 실패가 프로세스를 죽이지 않도록 삼킨다(트리거는 부가 기능).
    if (kDebugMode) {
      debugPrint('[fcm] 백그라운드 메시지 처리 실패(무시): $e\n$s');
    }
  }
}
