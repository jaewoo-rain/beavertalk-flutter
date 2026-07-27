import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
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

/// 부트스트랩 단계 하나를 격리 실행한다. 실패해도 **다음 단계는 계속 간다.**
///
/// 초기화 단계들은 서로 독립인데 한 줄로 이어 놓으면 앞의 부가 기능(부재중 배너 채널 등)
/// 하나가 throw 하는 순간 뒤의 필수 배선(FCM = 안드로이드 수신 전화)까지 함께 죽는다.
Future<void> _step(String name, Future<void> Function() run) async {
  try {
    await run();
  } catch (e, s) {
    if (kDebugMode) debugPrint('[push_bootstrap] $name 실패(계속 진행): $e\n$s');
  }
}

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
    // CallKit 이벤트 구독 + 재조정 루프를 **가장 먼저** 건다.
    //
    // 이 구독은 Supabase·Firebase·알림 채널 초기화에 의존하지 않는데, 예전엔
    // 그 뒤에 있었다. 플러그인의 이벤트 전달에는 버퍼가 없어서(`eventSink?(data)`),
    // 구독이 붙기 전에 도착한 accept는 그대로 소멸한다 — VoIP 푸시로 깨어난
    // 콜드스타트에서 정확히 그 창이 열려 있었다. 구독 공백을 최소화한다.
    // (수락 콜 자체는 네이티브 래치 + 재조정으로 한 번 더 방어한다.)
    //
    // 각 단계는 **독립적으로** 감싼다. 하나가 throw 하면 바깥 catch 로 빠져 그 뒤 단계가
    // 통째로 스킵되는데, 그 뒤에는 안드로이드의 FCM 배선(_initFcm)이 있다. 부재중 배너
    // 채널 초기화 같은 부가 기능의 실패가 **안드로이드 수신 전화를 통째로 죽이면 안 된다.**
    await _step('coordinator attach',
        () => container.read(incomingCallCoordinatorProvider).attach());
    // 부재중 배너 채널/권한 준비.
    await _step('missed-call notifier',
        () => container.read(missedCallNotifierProvider).init());
    // 저장된 알람 시각에 로컬로 전화를 띄우는 스케줄러 시작(앱 생존 중에만 동작).
    await _step('inbound scheduler',
        () => container.read(inboundCallSchedulerProvider).start());

    // 디바이스 토큰 등록을 **FCM 배선과 독립적으로, 그 前에** 시작한다.
    // iOS VoIP 등록은 PushKit 경로라 Firebase 가 전혀 필요 없다. 이전에는 이 등록이
    // _initFcm 깊숙이(FirebaseMessaging.onBackgroundMessage / requestPermission /
    // onForegroundMessage 뒤)에 있어서, 그 Firebase 호출들이 iOS 에서 throw/hang 하면
    // _initFcm 이 중단돼 등록까지 건너뛰었다 → member 의 device_token 이 0건이 되고
    // 잠금화면 예약전화(VoIP)가 오지 않았다. fire-and-forget 로 띄워 requestPermission
    // 권한 다이얼로그 대기 등이 등록을 막지 않게 한다(내부 폴링이 토큰을 기다린다).
    if (kDeviceRegistrationEnabled) {
      unawaited(
        container
            .read(deviceRegistrationControllerProvider)
            .start()
            .catchError((Object e, StackTrace s) {
          if (kDebugMode) debugPrint('[push_bootstrap] device 등록 실패(무시): $e');
        }),
      );
    }

    // ── 여기부터 FCM(밖에서 앱을 깨우는 트리거) 배선 ──
    // 위 로컬 트리거들과 동일한 CallKit 수신 화면을 재사용한다. Firebase 초기화도
    // 여기서 한다(수신 콜 처리를 막지 않도록 main 에서 옮겨 왔다).
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
    // Firebase 초기화(옵션 없이 → google-services.json / GoogleService-Info.plist).
    // main()에서 여기로 옮겼다: 이건 FCM 트리거에만 필요한데, main에서 await 하면
    // 콜드스타트마다 그만큼 수신 콜 처리(attach)가 밀린다.
    // (백그라운드/종료 경로는 별도 isolate에서 다시 initializeApp을 호출한다.)
    await Firebase.initializeApp();

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
        //
        // call_id가 비면(누락/빈 문자열 → DTO가 '' 폴백, payload dto :21-27) dedup을
        // 건너뛴다. ''를 그대로 등록하면 첫 푸시가 ''를 seen에 넣어버려, 이후 call_id
        // 없는 모든 콜이 영구히 조용히 버려진다 — 프로세스가 사는 동안 전화가 다시는
        // 울리지 않고 로그도 kDebugMode 밖엔 안 남는다. 중복 링 위험보다 전화를 통째로
        // 잃는 쪽이 훨씬 나쁘므로 이 경우엔 표시를 진행한다.
        final uuid = payload.callUuid;
        if (uuid.isNotEmpty) {
          if (!_fcmSeenCalls.add(uuid)) return;
          if (_fcmSeenCalls.length > 200) {
            _fcmSeenCalls
              ..clear()
              ..add(uuid);
          }
        }
        // fire-and-forget: 표시 실패가 스트림 구독을 끊지 않게 개별 catch.
        callkit.showIncoming(payload).catchError((Object e) {
          if (kDebugMode) debugPrint('[fcm] 포그라운드 수신 화면 표시 실패: $e');
        });
      } catch (e) {
        if (kDebugMode) debugPrint('[fcm] 포그라운드 메시지 파싱 실패: $e');
      }
    });

    // (device 토큰 등록은 initIncomingCallLocal 로 이동 — FCM 배선 실패와 무관하게
    //  실행되어야 iOS VoIP 등록이 보장된다.)

    // 토큰 확인: 디버그 로그로 확인(FCM 테스트용). iOS 는 APNs 미구성 시 getToken()이
    // throw/지연 할 수 있어 자체 try/catch 로 격리한다.
    try {
      final token = await fcm.getToken();
      if (kDebugMode) debugPrint('[fcm] token=$token');
      fcm.onTokenRefresh.listen((t) {
        if (kDebugMode) debugPrint('[fcm] token refreshed=$t');
      });
    } catch (e) {
      if (kDebugMode) debugPrint('[fcm] getToken 실패(무시): $e');
    }
  } catch (e, s) {
    // FCM 배선 실패가 로컬 트리거/앱 부팅을 막지 않도록 삼킨다.
    if (kDebugMode) debugPrint('[fcm] 초기화 실패(무시): $e\n$s');
  }
}
