import 'dart:async';

import 'package:flutter/foundation.dart';
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

  // ── 콜드스타트 복구 타이밍(무한 대기 금지: 모두 상한 있음) ──

  /// accepted 콜 재폴링 간격.
  static const Duration _coldStartPollInterval = Duration(milliseconds: 250);

  /// accepted 콜 재폴링 최대 횟수(250ms × 10 = 최대 ~2.5s).
  static const int _coldStartMaxPolls = 10;

  /// 준비 게이팅(세션 복원/navigator) 폴링 간격.
  static const Duration _readyPollInterval = Duration(milliseconds: 100);

  /// 준비 게이팅 최대 대기(세션·navigator 각각 최대 ~5s).
  static const Duration _readyTimeout = Duration(seconds: 5);

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
  ///
  /// 라이브 이벤트 구독([_sub])은 즉시(동기적으로) 건다 — killed 상태에서 뒤늦게
  /// 오는 accept 이벤트를 놓치지 않기 위해.
  /// 콜드스타트 복구([_handleColdStart])는 accepted 콜을 최대 ~2.5s 재폴링하고
  /// 세션/네비게이터 준비를 최대 ~5s 대기하므로, 이를 **await 하면** 부트스트랩
  /// (스케줄러/FCM 초기화)이 그만큼 지연된다. 따라서 **fire-and-forget**으로 띄운다.
  Future<void> attach() async {
    if (_attached) return;
    _attached = true;
    _sub = callkit.onEvent.listen(_onEvent);
    // 부트스트랩을 막지 않도록 콜드스타트 복구는 비차단으로 실행.
    unawaited(_handleColdStart());
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

    // P1(오디오 무음 방지): 수락된 CallKit 콜을 즉시 종료해 OS 통화 오디오 세션
    // (iOS AVAudioSession / Android MODE_IN_COMMUNICATION·AudioFocus) 점유를 푼다.
    // 오디오는 normalcall 파이프라인이 온전히 소유해야 하는데, 수락 상태의 CallKit
    // 콜이 세션을 붙잡고 있으면 녹음/재생이 무음이 된다. CallKit은 "벨/수신 UI
    // 트리거 전용"으로 둔다. endAllCalls로 스케줄러+FCM 중복 전화의 잔여 링도 정리.
    //
    // 주의: 이 endAllCalls는 곧이어 CallEventActionCallEnded를 유발한다. 그건
    // **우리가 종료시킨 것**이므로 ended 핸들러에서 normalcall을 hangUp 하면 안 된다
    // (방금 시작한 통화를 끊게 됨). 현재 ended 핸들러는 dedup 제거만 하므로 그대로 둔다.
    await callkit.endAllCalls();

    await _navigateToCall(payload.characterId);
  }

  /// 1분 미응답 처리: 부재중 배너 + dedup 정리.
  Future<void> _onTimeout({required String uuid, required String name}) async {
    _log('timeout → 부재중 배너($name)');
    await missedCall.showMissedCall(name: name);
    if (uuid.isNotEmpty) _handledUuids.remove(uuid);
  }

  /// `appNavigatorKey`로 통화 로딩 화면에 진입한다(arguments = int characterId).
  ///
  /// navigator가 아직 준비 안 됐으면(콜드스타트 부팅 직후) **준비될 때까지 폴링**한다
  /// (최대 [_readyTimeout]). 과거엔 postFrame 1회만 재시도해 그때도 null이면 조용히
  /// 네비게이션이 유실됐다. 타임아웃까지 준비 안 되면 안전하게 no-op(로그만).
  Future<void> _navigateToCall(int characterId) async {
    final ready = await _awaitNavigatorReady();
    final nav = appNavigatorKey.currentState;
    if (!ready || nav == null) {
      _log('네비게이션 실패: navigator 미준비(타임아웃 ${_readyTimeout.inSeconds}s)');
      return;
    }
    nav.pushNamed(Routes.callLoading, arguments: characterId);
  }

  /// 콜드스타트: 앱이 종료(killed)돼 있다가 accept로 켜진 경우, 라이브 accept 이벤트는
  /// 구독([_sub])이 붙기 전에 발생해 **유실**될 수 있다(broadcast, 리플레이 없음).
  /// 그래서 시작 시 `activeCalls()`를 조회해 **이미 수락된 콜을 소비**한다.
  ///
  /// 처리 순서:
  /// 1. accepted 콜을 짧은 간격으로 **재폴링**(부팅 직후 아직 `isAccepted`가 안 찍힌
  ///    레이스 흡수). 못 찾으면 조용히 종료(= 콜드스타트 대상 없음).
  /// 2. 소비 전 **세션 복원 + navigator 준비**를 짧게 대기(게이팅). 세션 복원 전
  ///    "미인증 오탐"과 navigator 미준비 네비 유실을 막는다.
  /// 3. `_onAccept`로 소비(dedup·미인증·통화중 가드는 그 안에서 재확인).
  Future<void> _handleColdStart() async {
    // 1) accepted 콜 재폴링.
    final accepted = await _pollForAcceptedCall();
    if (accepted == null) return; // 콜드스타트로 소비할 pending accept 없음.

    _log('콜드스타트: accepted 콜 발견(id=${accepted.id}) → 준비 대기 후 소비');

    // 2) 준비 게이팅(각각 타임아웃 있음). 세션이 끝내 없으면 _onAccept가 안전하게
    //    endCall 처리하므로 여기서는 대기만 하고 결과로 분기하지 않는다.
    await _awaitSessionRestored();
    await _awaitNavigatorReady();

    // 3) 소비(라이브 경로와 동일하게 CallKitParams → 페이로드 변환).
    await _onAccept(_payloadFromParams(accepted));
  }

  /// `activeCalls()`를 [_coldStartPollInterval] 간격으로 최대 [_coldStartMaxPolls]회
  /// 재폴링해 **아직 dedup되지 않은 accepted 콜**을 찾는다. 없으면 null.
  ///
  /// 부팅 직후엔 콜이 등록/수락 표시되기까지 짧은 레이스가 있어 1회 조회로는 놓친다.
  Future<CallKitParams?> _pollForAcceptedCall() async {
    for (var attempt = 0; attempt < _coldStartMaxPolls; attempt++) {
      final calls = await callkit.activeCalls();
      for (final call in calls) {
        if (!call.isAccepted) continue; // 표시/ringing 상태는 소비하지 않음.
        // 라이브 이벤트가 이미 처리한 콜이면 중복 진입 방지.
        if (call.id.isNotEmpty && _handledUuids.contains(call.id)) continue;
        return call;
      }
      // 마지막 시도 뒤에는 대기하지 않는다.
      if (attempt < _coldStartMaxPolls - 1) {
        await Future<void>.delayed(_coldStartPollInterval);
      }
    }
    return null;
  }

  /// Supabase 세션 복원이 끝날 때까지(=`currentSession != null`) 최대 [_readyTimeout]
  /// 대기한다. 복원되면 true, 타임아웃이면 false. 무한 대기 금지.
  Future<bool> _awaitSessionRestored() =>
      _pollUntil(() => Supabase.instance.client.auth.currentSession != null);

  /// navigator가 준비될 때까지(`appNavigatorKey.currentState != null`) 최대
  /// [_readyTimeout] 대기한다. 준비되면 true, 타임아웃이면 false. 무한 대기 금지.
  Future<bool> _awaitNavigatorReady() =>
      _pollUntil(() => appNavigatorKey.currentState != null);

  /// [ready]가 true가 될 때까지 [_readyPollInterval] 간격으로 폴링한다(최대
  /// [_readyTimeout]). 조건 충족 시 true, 타임아웃 시 false.
  Future<bool> _pollUntil(bool Function() ready) async {
    final deadline = DateTime.now().add(_readyTimeout);
    while (true) {
      if (ready()) return true;
      if (!DateTime.now().isBefore(deadline)) return false;
      await Future<void>.delayed(_readyPollInterval);
    }
  }

  /// CallKit 콜 파라미터 → 도메인 페이로드(라이브 이벤트 경로).
  IncomingCallPayload _payloadFromParams(CallKitParams p) {
    return IncomingCallPayload(
      callUuid: p.id,
      characterId: IncomingCallPayloadDto.asInt(p.extra?['characterId']) ??
          kDefaultInboundCharacterId,
      characterName: p.nameCaller,
      imageUrl: p.avatar,
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
