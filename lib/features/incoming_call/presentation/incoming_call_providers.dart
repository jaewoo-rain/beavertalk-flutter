import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/callkit_service.dart';
import '../services/missed_call_notifier.dart';
import 'incoming_call_coordinator.dart';

/// CallKit 래퍼(무상태) DI.
final callkitServiceProvider = Provider<CallkitService>((ref) {
  return const CallkitService();
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
