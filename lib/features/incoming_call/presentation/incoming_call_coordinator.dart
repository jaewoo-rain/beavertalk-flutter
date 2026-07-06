import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../app/navigation.dart';
import '../../../app/routes.dart';
import '../../normalcall/presentation/normalcall_controller.dart';
import '../data/models/incoming_call_payload_dto.dart';
import '../domain/entities/incoming_call_payload.dart';
import '../services/callkit_service.dart';
import '../services/missed_call_notifier.dart';

/// 로컬 트리거 데모의 기본 캐릭터 id(비비). 서버/알람에서 characterId를 못 받은
/// 경우의 폴백이기도 하다.
const int kDefaultInboundCharacterId = 1;

/// CallKit 수신 이벤트를 오케스트레이션하는 코디네이터(상태 없는 서비스 성격).
///
/// 책임:
/// - accept → extra.characterId 추출 → `appNavigatorKey`로 기존
///   `Routes.callLoading`(arguments: **int** characterId) 네비게이트. 그 뒤 실시간
///   통화는 normalcall 파이프라인이 그대로 처리(무변경 재사용).
/// - decline → 콜 종료.
/// - timeout(1분 미응답) → 부재중 배너.
/// - ended → dedup 정리.
///
/// 안전장치:
/// - **callUuid dedup**: 라이브 이벤트 + 콜드스타트 폴링 중복 진입 방지.
/// - **미인증 보류**: Supabase 세션이 없으면 통화 진입을 막고 콜을 종료.
/// - **이미 통화 중 가드**: normalcall phase가 진행 중이면 새 accept를 거절(endCall).
///
/// 참고: `flutter_callkit_incoming` 3.1.x의 [CallEvent]는 sealed 클래스라 이벤트별
/// 하위 타입(예: [CallEventActionCallAccept])으로 패턴 매칭한다.
class IncomingCallCoordinator {
  /// 코디네이터를 생성한다. [ref]로 normalcall phase를 읽는다.
  IncomingCallCoordinator({
    required this.ref,
    required this.callkit,
    required this.missedCall,
  });

  /// normalcall 상태 조회용 Riverpod ref(읽기 전용).
  final Ref ref;

  /// CallKit 래퍼.
  final CallkitService callkit;

  /// 부재중 배너 래퍼.
  final MissedCallNotifier missedCall;

  StreamSubscription<CallEvent?>? _sub;

  /// 이미 처리한 callUuid 집합(중복 진입 방지).
  final Set<String> _handledUuids = <String>{};

  bool _attached = false;

  /// 라이브 이벤트 구독을 시작하고 콜드스타트(이미 받은 콜)를 처리한다. 멱등.
  Future<void> attach() async {
    if (_attached) return;
    _attached = true;
    _sub = callkit.onEvent.listen(_onEvent);
    await _handleColdStart();
  }

  /// 구독을 해제한다(provider dispose에서 호출).
  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  /// 라이브 CallKit 이벤트 디스패처(sealed 타입 패턴 매칭).
  Future<void> _onEvent(CallEvent? event) async {
    if (event == null) return;
    switch (event) {
      case CallEventActionCallAccept(:final callKitParams):
        await _onAccept(_payloadFromParams(callKitParams));
      case CallEventActionCallDecline(:final callKitParams):
        await callkit.endCall(callKitParams.id);
      case CallEventActionCallTimeout(:final id):
        await _onTimeout(uuid: id, name: '비버');
      case CallEventActionCallEnded(:final callKitParams):
        // 세션 종료 → dedup에서 제거해 (동일 uuid의) 재수신 여지를 남긴다.
        _handledUuids.remove(callKitParams.id);
      default:
        break;
    }
  }

  /// accept 처리: 미인증/통화중/중복 가드 후 통화 로딩 화면으로 네비게이트.
  Future<void> _onAccept(IncomingCallPayload payload) async {
    final uuid = payload.callUuid.isEmpty ? null : payload.callUuid;

    // 중복 진입 방지(라이브 이벤트 + 콜드스타트 폴링).
    if (uuid != null) {
      if (_handledUuids.contains(uuid)) return;
      _handledUuids.add(uuid);
    }

    // 미인증이면 통화 진입 보류 + 콜 종료(로그인 유도는 후속 단계).
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      _log('accept 무시: 미인증 상태');
      if (uuid != null) await callkit.endCall(uuid);
      return;
    }

    // 이미 통화 중이면 새 수신을 거절(endCall).
    final phase = ref.read(normalCallControllerProvider).phase;
    final busy = phase == CallPhase.connecting ||
        phase == CallPhase.inCall ||
        phase == CallPhase.ending;
    if (busy) {
      _log('accept 거절: 이미 통화 중(phase=$phase)');
      if (uuid != null) await callkit.endCall(uuid);
      return;
    }

    _log('accept 수락 → callLoading(characterId=${payload.characterId})');
    _navigateToCall(payload.characterId);
  }

  /// 1분 미응답 처리: 부재중 배너 + dedup 정리.
  Future<void> _onTimeout({required String uuid, required String name}) async {
    _log('timeout → 부재중 배너($name)');
    await missedCall.showMissedCall(name: name);
    if (uuid.isNotEmpty) _handledUuids.remove(uuid);
  }

  /// `appNavigatorKey`로 통화 로딩 화면에 진입한다(arguments = int characterId).
  /// navigator가 아직 준비 안 됐으면 첫 프레임 이후로 미룬다(콜드스타트 대비).
  void _navigateToCall(int characterId) {
    void go() {
      appNavigatorKey.currentState?.pushNamed(
        Routes.callLoading,
        arguments: characterId,
      );
    }

    if (appNavigatorKey.currentState != null) {
      go();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => go());
    }
  }

  /// 콜드스타트: 앱이 종료돼 있다가 accept로 켜진 경우, 라이브 이벤트를 놓칠 수 있으므로
  /// 시작 시 activeCalls를 조회해 이미 수락된 콜을 소비한다. `isAccepted`가 아닌(표시/
  /// ringing) 항목은 건너뛴다. dedup으로 라이브 이벤트와 중복 진입을 막는다.
  Future<void> _handleColdStart() async {
    final calls = await callkit.activeCalls();
    if (calls.isEmpty) return;
    for (final call in calls) {
      if (call is! Map) continue;
      final accepted = call['isAccepted'] == true || call['accepted'] == true;
      if (!accepted) continue;
      await _onAccept(IncomingCallPayloadDto.fromMap(call));
    }
  }

  /// CallKit 콜 파라미터 → 도메인 페이로드(라이브 이벤트 경로).
  IncomingCallPayload _payloadFromParams(CallKitParams p) {
    return IncomingCallPayload(
      callUuid: p.id,
      characterId: IncomingCallPayloadDto.asInt(p.extra?['characterId']) ??
          kDefaultInboundCharacterId,
      characterName: p.nameCaller,
      avatarUrl: p.avatar,
    );
  }

  /// 디버그 트리거: 로컬로 수신 화면을 띄운다(푸시 대체).
  ///
  /// 실기기에서 개발용 버튼으로 호출해 "전화 오는 화면"을 확인하는 용도.
  Future<void> simulateIncomingCall({
    int characterId = kDefaultInboundCharacterId,
    String characterName = 'Annoying Beaver',
  }) async {
    // Android 14+ 전체화면 인텐트 / 알림 권한을 먼저 요청(최초 1회 팝업).
    await callkit.requestNotificationPermission();
    await callkit.requestFullIntentPermission();

    final payload = IncomingCallPayload(
      callUuid: const Uuid().v4(),
      characterId: characterId,
      characterName: characterName,
    );
    await callkit.showIncoming(payload);
  }

  void _log(String msg) {
    if (kDebugMode) debugPrint('[incoming_call] $msg');
  }
}
