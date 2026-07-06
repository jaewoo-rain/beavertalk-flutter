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
    final params = CallKitParams(
      id: p.callUuid,
      nameCaller: p.characterName ?? '비버 튜터',
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

  /// 현재 활성(표시/수락) 콜 목록을 반환한다. 콜드스타트에서 "이미 받은 콜"을
  /// 판별하는 데 쓴다. 실패 시 빈 리스트.
  Future<List<dynamic>> activeCalls() async {
    try {
      return await FlutterCallkitIncoming.activeCalls();
    } catch (_) {
      return const <dynamic>[];
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
