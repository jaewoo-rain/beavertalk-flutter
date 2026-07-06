import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/feature_flags.dart';
import '../features/incoming_call/presentation/incoming_call_providers.dart';

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
  } catch (e, s) {
    // 실패해도 앱은 정상 부팅되어야 한다(로컬 트리거는 부가 기능).
    if (kDebugMode) {
      debugPrint('[push_bootstrap] 인바운드 콜 로컬 초기화 실패(무시): $e\n$s');
    }
  }
}
