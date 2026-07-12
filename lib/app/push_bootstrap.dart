import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/feature_flags.dart';
import '../features/incoming_call/data/models/incoming_call_payload_dto.dart';
import '../features/incoming_call/presentation/incoming_call_providers.dart';
import '../features/normalcall/presentation/normalcall_controller.dart';
import 'fcm_background_handler.dart';

/// Pre-display dedup for FCM's at-least-once redelivery of the same call.
final Set<String> _fcmSeenCalls = <String>{};

/// 인바운드 콜(비버가 거는 전화)의 **로컬 단계** 초기화 진입점.
///
/// 이번 단계는 로컬 트리거만 다룬다 — FCM/Firebase background handler는 만들지 않는다.
/// 하는 일:
/// 1. 부재중 배너 플러그인 초기화([MissedCallNotifier.init]),
/// 2. CallKit 이벤트 코디네이터 attach(라이브 구독 + 콜드스타트 pending accept 처리).
///
/// 안전 규칙:
/// - `kInboundCallEnabled && !kIsWeb`일 때만 동작(그 외 완전 no-op).
/// - 전체를 try/catch로 감싸 어떤 실패도 **앱 시작을 막지 않는다**.
/// - [container]는 위젯 트리와 **동일한** [ProviderContainer]여야 한다(`main`에서
///   `UncontrolledProviderScope`로 공유). 그래야 코디네이터의 "이미 통화 중" 가드가
///   실제 화면이 쓰는 normalcall 상태를 읽는다.
Future<void> initIncomingCallLocal(ProviderContainer container) async {
  if (!kInboundCallEnabled || kIsWeb) return;
  try {
    // 부재중 배너 채널/권한 준비.
    await container.read(missedCallNotifierProvider).init();
    // CallKit 이벤트 구독 + 콜드스타트(이미 수락된 콜) 소비.
    await container.read(incomingCallCoordinatorProvider).attach();
    // 저장된 알람 시각에 로컬로 전화를 띄우는 스케줄러 시작(앱 생존 중에만 동작).
    await container.read(inboundCallSchedulerProvider).start();

    // ── 여기부터 FCM(밖에서 앱을 깨우는 트리거) 배선 ──
    // 위 로컬 트리거들과 동일한 CallKit 수신 화면을 재사용한다. Firebase.initializeApp은
    // main.dart(포그라운드 경로)와 background handler(별도 isolate)에서 각각 이미 호출된다.
    await _initFcm(container);
  } catch (e, s) {
    // 실패해도 앱은 정상 부팅되어야 한다(로컬 트리거는 부가 기능).
    if (kDebugMode) {
      debugPrint('[push_bootstrap] 인바운드 콜 로컬 초기화 실패(무시): $e\n$s');
    }
  }
}

/// FCM(밖에서 앱을 깨우는 푸시 트리거) 배선. [initIncomingCallLocal] 안에서만
/// 호출되므로 이미 `kInboundCallEnabled && !kIsWeb` 가드를 통과한 상태다.
///
/// 하는 일:
/// 1. 백그라운드/종료 상태 핸들러 등록(top-level [firebaseMessagingBackgroundHandler]),
/// 2. 알림 권한 요청,
/// 3. 포그라운드 메시지 구독 → FCM `data`를 CallKit 수신 화면으로,
/// 4. 토큰 조회/갱신을 **디버그 로그로만** 출력(지금은 서버 등록 대신 확인용).
///
/// 개별 실패가 앱 부팅/다른 트리거를 막지 않도록 자체 try/catch로 한 번 더 감싼다.
Future<void> _initFcm(ProviderContainer container) async {
  try {
    final fcm = container.read(fcmServiceProvider);
    final callkit = container.read(callkitServiceProvider);

    // 앱이 백그라운드/종료 상태일 때 도착하는 메시지는 별도 isolate의 top-level
    // 핸들러가 처리한다(등록은 반드시 앱 시작 시 1회).
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 알림 권한(Android 13+/iOS). 거부돼도 앱은 계속 동작.
    await fcm.requestPermission();

    // 포그라운드 메시지 → 로컬/백그라운드와 동일한 CallKit 수신 화면 표시.
    fcm.onForegroundMessage.listen((m) {
      try {
        // 로그아웃 상태에선 (토큰 삭제 실패 등으로) 스트레이/재전송 푸시가 와도
        // 수신 화면을 띄우지 않는다.
        if (Supabase.instance.client.auth.currentSession == null) return;
        final payload = IncomingCallPayloadDto.fromMap(m.data);
        // 이미 통화 중이면 라이브 통화 위에 두 번째 수신 화면을 쌓지 않는다.
        final phase = container.read(normalCallControllerProvider).phase;
        if (phase == CallPhase.connecting ||
            phase == CallPhase.inCall ||
            phase == CallPhase.ending) {
          return;
        }
        // FCM at-least-once 재전송으로 같은 콜이 여러 번 오면 한 번만 띄운다.
        if (!_fcmSeenCalls.add(payload.callUuid)) return;
        if (_fcmSeenCalls.length > 200) {
          _fcmSeenCalls
            ..clear()
            ..add(payload.callUuid);
        }
        // fire-and-forget: 표시 실패가 스트림 구독을 끊지 않게 개별 catch.
        callkit.showIncoming(payload).catchError((Object e) {
          if (kDebugMode) debugPrint('[fcm] 포그라운드 수신 화면 표시 실패: $e');
        });
      } catch (e) {
        if (kDebugMode) debugPrint('[fcm] 포그라운드 메시지 파싱 실패: $e');
      }
    });

    // 토큰 확인: 디버그 로그로 확인(FCM 테스트용).
    final token = await fcm.getToken();
    if (kDebugMode) debugPrint('[fcm] token=$token');
    fcm.onTokenRefresh.listen((t) {
      if (kDebugMode) debugPrint('[fcm] token refreshed=$t');
    });

    // 서버 `POST /devices`로 토큰 자동 등록. 배선은 항상 준비돼 있고, 서버가 배포되면
    // kDeviceRegistrationEnabled=true 로 켜면 로그인/토큰갱신 시 자동 등록된다.
    if (kDeviceRegistrationEnabled) {
      await container.read(deviceRegistrationControllerProvider).start();
    }
  } catch (e, s) {
    // FCM 배선 실패가 로컬 트리거/앱 부팅을 막지 않도록 삼킨다.
    if (kDebugMode) debugPrint('[fcm] 초기화 실패(무시): $e\n$s');
  }
}
