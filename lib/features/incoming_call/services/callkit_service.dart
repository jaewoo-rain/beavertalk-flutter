import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../domain/entities/incoming_call_payload.dart';

/// `flutter_callkit_incoming` 얇은 래퍼(상태 없음).
///
/// 수신 화면(전화 오는 UI) 표시/종료/조회와 이벤트 스트림만 노출한다. 이번 단계는
/// **로컬 트리거**라서 여기서 직접 [showIncoming]을 호출하지만, 나중에 푸시가 붙어도
/// 표시 로직은 동일하게 이 서비스를 재사용한다.
///
/// 플러그인 정적 메서드를 감싸 (1) 테스트/교체 용이성, (2) 파라미터(잠금화면 표시,
/// 벨소리, 1분 타임아웃 등) 일원화를 얻는다.
class CallkitService {
  /// 서비스를 생성한다(무상태).
  const CallkitService();

  /// uuid→표시 이름. 타임아웃 이벤트엔 이름이 없어서(id만), 표시 시점에 기억해
  /// 부재중 배너가 실제 캐릭터명을 쓰게 한다. 200개 상한으로 무한 증가 방지.
  static final Map<String, String> _names = <String, String>{};

  /// 표시 시점에 기억해 둔 [uuid]의 caller 이름(없으면 null).
  String? nameFor(String uuid) => _names[uuid];

  /// CallKit 이벤트 스트림(accept/decline/timeout/ended…). 코디네이터가 구독한다.
  Stream<CallEvent?> get onEvent => FlutterCallkitIncoming.onEvent;

  /// 수신 화면을 띄운다.
  ///
  /// [durationMs]가 지나도록 받지 않으면 네이티브 CallKit이 자동으로 타임아웃시켜
  /// `Event.actionCallTimeout`을 발생시킨다(기본 60초 = 1분 미응답 → 부재중).
  Future<void> showIncoming(
    IncomingCallPayload p, {
    int durationMs = 60000,
  }) async {
    final nameCaller = p.characterName ?? '비버 튜터';
    if (_names.length > 200) _names.clear();
    _names[p.callUuid] = nameCaller;
    final params = CallKitParams(
      id: p.callUuid,
      nameCaller: nameCaller,
      appName: 'BeaverTalk',
      avatar: p.imageUrl,
      handle: '한국어 통화',
      // 0 = 음성 통화(1 = 영상). 이번 단계는 음성만.
      type: 0,
      // 네이티브 타임아웃(ms). 이 시간 안에 받지 않으면 actionCallTimeout.
      duration: durationMs,
      // accept 시 이벤트 body의 extra로 되돌아온다 → characterId 회수용.
      extra: <String, dynamic>{'characterId': p.characterId},
      // Android 부재중 알림 문구(플러그인 자체 배너). 별도 배너는
      // missed_call_notifier가 담당하지만, 플랫폼 기본 표기도 켜 둔다.
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: '부재중 전화',
      ),
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        // 심플하게 검정 배경. (색은 여기만 바꾸면 됨: 배경/버튼/글자)
        backgroundColor: '#000000',
        actionColor: '#4CAF50', // 받기 버튼 강조색(검정 배경 대비 유지)
        textColor: '#ffffff', // 검정 배경 위 글자는 흰색이어야 보임

        textAccept: 'Accept',
        textDecline: 'Decline',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
        // 잠금화면 위 전체화면(full-screen intent)으로 표시.
        isShowFullLockedScreen: true,
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: false,
        ringtonePath: 'system_ringtone_default',
        // 오디오 세션 카테고리는 AppDelegate(configureCallAudioCategory)가 소유한다.
        // 이걸 켜 두면 플러그인이 accept 시점과 그 1200ms 뒤에 세션을
        // `[.allowBluetoothA2DP, .duckOthers, .allowBluetooth]` + mode `.default`로
        // 다시 구성한다. A2DP는 출력 전용(마이크 없음)이라 BT 마이크(HFP) 경로가
        // 깨지고, 1200ms 재구성은 우리 마이크 기동 한복판에 떨어진다.
        configureAudioSession: false,
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// [uuid] 콜 하나를 종료한다(거절/정리/이미-통화중 거절 등).
  Future<void> endCall(String uuid) async {
    try {
      await FlutterCallkitIncoming.endCall(uuid);
    } catch (_) {
      // 이미 종료된 콜이면 무시.
    }
  }

  /// 진행 중인 모든 CallKit 콜을 종료한다.
  Future<void> endAllCalls() async {
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (_) {}
  }

  // 참고: `setCallConnected`는 일부러 쓰지 않는다. 수락된 수신 콜은 CallKit이
  // 이미 연결 상태로 두고(잠금화면 타이머가 그래서 흐른다), 플러그인의
  // `didActivate` 처리는 `answerCall.hasConnected`가 true면 **조기 반환**해
  // 오디오 세션 이벤트를 보내지 않는다. 굳이 호출해 그 경로를 밟을 이유가 없다.

  // ── 네이티브 CallKit 상태 브릿지(iOS 전용) ──────────────────────────────
  //
  // 플러그인의 이벤트 전달은 버퍼가 없다(`eventSink?(data)`). Dart가 그 순간
  // 구독 중이 아니면 accept 이벤트는 그대로 소멸하고, CallKit만 연결된 채
  // 타이머가 도는 상태가 된다. 그래서 AppDelegate가 accept를 네이티브에
  // 걸어두고(래치), Dart는 준비되는 대로 **당겨온다**. 이벤트는 빠른 경로일
  // 뿐이고 진실은 여기에 있다.

  static const MethodChannel _bridge = MethodChannel('beavertalk/callkit');

  /// 네이티브에 걸려 있는 "수락된 콜"(없으면 null). 소비 후 반드시
  /// [clearPendingAcceptedCall]로 지운다.
  Future<Map<String, dynamic>?> pendingAcceptedCall() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return null;
    try {
      final res = await _bridge.invokeMapMethod<String, dynamic>(
        'getPendingAcceptedCall',
      );
      return res;
    } catch (_) {
      return null;
    }
  }

  /// 소비한 래치를 지운다(같은 콜을 두 번 소비하지 않도록).
  Future<void> clearPendingAcceptedCall() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _bridge.invokeMethod<void>('clearPendingAcceptedCall');
    } catch (_) {}
  }

  /// CallKit이 오디오 세션을 활성화한 상태인지(didActivate ~ didDeactivate).
  /// 오디오 파이프라인을 언제 열지 판단하는 신호다. iOS 외에는 항상 false.
  Future<bool> isCallAudioSessionActive() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return false;
    try {
      return await _bridge.invokeMethod<bool>('isCallAudioSessionActive') ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// 현재 활성(표시/수락) 콜 목록을 반환한다. 콜드스타트에서 "이미 받은 콜"을
  /// 판별하는 데 쓴다. 실패 시 빈 리스트.
  ///
  /// 플러그인(`flutter_callkit_incoming` 3.1.3)의 실제 반환 타입은
  /// **`List<CallKitParams>`**(객체)다. 각 원소의 [CallKitParams.isAccepted]로
  /// "이미 수락된 콜"인지 판별한다(과거엔 `List<dynamic>`으로 느슨히 선언해
  /// 코디네이터에서 `is! Map` 오판정으로 폴백이 죽어 있었다 → 타입을 좁혀 재발 방지).
  Future<List<CallKitParams>> activeCalls() async {
    try {
      return await FlutterCallkitIncoming.activeCalls();
    } catch (_) {
      return const <CallKitParams>[];
    }
  }

  /// Android 14+ 전체화면 인텐트(잠금화면 위 표시) 권한을 요청한다. 실패해도 무시.
  Future<void> requestFullIntentPermission() async {
    try {
      await FlutterCallkitIncoming.requestFullIntentPermission();
    } catch (_) {}
  }

  /// 알림 권한(Android 13+/iOS)을 요청한다. 실패해도 무시.
  Future<void> requestNotificationPermission() async {
    try {
      await FlutterCallkitIncoming.requestNotificationPermission({
        'rationaleMessagePermission': '전화 수신 알림을 받으려면 알림 권한이 필요해요.',
        'postNotificationMessageRequired': '설정에서 알림 권한을 허용해 주세요.',
      });
    } catch (_) {}
  }
}
