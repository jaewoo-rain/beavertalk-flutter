import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// `flutter_local_notifications` 얇은 래퍼 — 상단바 "부재중 전화" 배너 담당.
///
/// 1분 미응답(`Event.actionCallTimeout`) 시 코디네이터가 [showMissedCall]을 호출한다.
/// 데모용으로 즉시([showNow])/N초 뒤([scheduleInSeconds]) 표시도 제공한다.
class MissedCallNotifier {
  /// 래퍼를 생성한다.
  MissedCallNotifier();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inited = false;

  /// 부재중 알림 채널 id/이름(Android 8+는 채널 필수).
  static const String _channelId = 'missed_call_channel';
  static const String _channelName = '부재중 전화';
  static const String _channelDesc = '받지 못한 비버의 전화를 알려줘요.';

  /// 부재중 배너 알림 id(항상 같은 값으로 덮어써 쌓이지 않게).
  static const int _missedCallId = 9001;

  /// 데모용 예약 알림 타이머 핸들. [scheduleInSeconds] 재호출 시 이전 예약을 대체.
  Timer? _scheduleTimer;

  /// 플러그인 초기화 + 채널 생성 + 알림 권한 요청(멱등: 여러 번 불러도 1회만).
  Future<void> init() async {
    if (_inited) return;
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS 권한은 첫 실행 시 팝업으로 요청(로컬 단계라 별도 배선 없음).
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Android 13+ 알림 권한.
    await androidImpl?.requestNotificationsPermission();
    // 채널 선등록(중요도 max — 상단바 헤드업).
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.max,
      ),
    );

    // iOS 권한.
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);

    _inited = true;
  }

  /// 배너 상세(채널 + 중요도/우선순위).
  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          ticker: '부재중 전화',
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// "부재중 전화 / {name}이 전화했어요" 배너를 띄운다.
  Future<void> showMissedCall({required String name}) async {
    await _plugin.show(
      _missedCallId,
      '부재중 전화',
      '$name이 전화했어요',
      _details,
    );
  }

  /// 데모: 지금 즉시 부재중 배너를 띄운다.
  Future<void> showNow() => showMissedCall(name: '비버');

  /// 데모: [seconds]초 뒤 부재중 배너를 띄운다.
  ///
  /// 주의 — 이 로컬 단계에선 **앱이 살아있는 동안만** 동작하는 Dart [Timer] 기반이다
  /// (예약 알림 '개념 확인'용). 앱 종료 후에도 정확히 울리는 진짜 예약은 서버 스케줄러
  /// 또는 OS 예약(zonedSchedule + timezone)이 필요하며 후속 단계에서 다룬다.
  Future<void> scheduleInSeconds(int seconds) async {
    _scheduleTimer?.cancel();
    _scheduleTimer = Timer(Duration(seconds: seconds), () {
      unawaited(showNow());
    });
  }

  /// 예약된 데모 타이머를 취소한다.
  void cancelScheduled() {
    _scheduleTimer?.cancel();
    _scheduleTimer = null;
  }
}
