import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/callkit_service.dart';
import '../services/fcm_service.dart';
import '../services/missed_call_notifier.dart';
import 'inbound_call_scheduler.dart';
import 'incoming_call_coordinator.dart';

/// CallKit 래퍼(무상태) DI.
final callkitServiceProvider = Provider<CallkitService>((ref) {
  return const CallkitService();
});

/// FCM 래퍼(무상태) DI. 밖에서 앱을 깨우는 푸시 트리거의 표면(권한/토큰/포그라운드
/// 메시지)을 노출한다. `kInboundCallEnabled && !kIsWeb`에서 Firebase 초기화 후에만
/// 실제로 사용된다.
final fcmServiceProvider = Provider<FcmService>((ref) {
  return const FcmService();
});

/// 부재중 배너 래퍼 DI.
final missedCallNotifierProvider = Provider<MissedCallNotifier>((ref) {
  return MissedCallNotifier();
});

/// 인바운드 콜 코디네이터 DI(앱 스코프). 구독 해제를 위해 dispose를 연결한다.
final incomingCallCoordinatorProvider =
    Provider<IncomingCallCoordinator>((ref) {
  final coordinator = IncomingCallCoordinator(
    ref: ref,
    callkit: ref.watch(callkitServiceProvider),
    missedCall: ref.watch(missedCallNotifierProvider),
  );
  ref.onDispose(coordinator.dispose);
  return coordinator;
});

/// 알람 시간 연동 스케줄러 DI(앱 스코프). 저장된 알람 시각에 로컬로 전화를 띄운다.
/// 구독 해제를 위해 stop을 dispose에 연결한다.
final inboundCallSchedulerProvider = Provider<InboundCallScheduler>((ref) {
  final scheduler = InboundCallScheduler(
    ref: ref,
    callkit: ref.watch(callkitServiceProvider),
  );
  ref.onDispose(scheduler.stop);
  return scheduler;
});
