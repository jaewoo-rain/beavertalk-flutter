import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    show AppLifecycleState, WidgetsBinding, WidgetsBindingObserver;
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../app/navigation.dart';
import '../../../app/routes.dart';
import '../../../mock/mock_data.dart' show characterName;
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
/// - accept → **CallKit 콜은 유지한 채** normalcall 세션(WS)을 즉시 시작하고,
///   통화 화면 진입은 병렬로 태운다.
/// - CallKit이 오디오 세션을 활성화하면(didActivate) 오디오 파이프라인을 붙인다.
/// - decline → 콜 종료. timeout(1분 미응답) → 부재중 배너.
/// - ended → **사용자의 실제 종료**로 보고 통화를 함께 내린다.
///
/// ## accept 수신 보장
///
/// 플러그인의 이벤트 전달에는 버퍼가 없다(`eventSink?(data)` 한 줄). Dart가 그
/// 순간 구독 중이 아니면 — 부팅 중이거나 프로세스가 얼어 있으면 — accept는 그대로
/// 소멸하고, CallKit만 연결된 채 타이머가 도는 상태가 된다("네이티브 통화 화면에서
/// 시간만 흐르고 앱은 아무것도 모름"). 그래서 수신 경로를 셋으로 둔다:
///
/// 1. **라이브 이벤트** — 빠른 경로.
/// 2. **네이티브 래치** — AppDelegate가 `onAccept`에서 걸어둔 값을 Dart가 당겨온다.
///    이벤트 유실과 무관하다.
/// 3. **주기 재조정** — 라이프사이클 전환 + 주기 타이머로 1·2를 다시 확인한다.
///
/// 셋 다 [_onAccept]로 수렴하고, callUuid dedup이 중복 소비를 막는다.
///
/// 안전장치:
/// - **미인증 보류**: Supabase 세션이 없으면 통화 진입을 막고 콜을 종료.
/// - **이미 통화 중 가드**: normalcall phase가 진행 중이면 새 accept를 거절(endCall).
///
/// 참고: `flutter_callkit_incoming` 3.1.x의 [CallEvent]는 sealed 클래스라 이벤트별
/// 하위 타입(예: [CallEventActionCallAccept])으로 패턴 매칭한다.
class IncomingCallCoordinator with WidgetsBindingObserver {
  /// 코디네이터를 생성한다. [ref]로 normalcall phase를 읽는다.
  IncomingCallCoordinator({
    required this.ref,
    required this.callkit,
    required this.missedCall,
  });

  // ── 재조정 타이밍(무한 대기 금지: 모두 상한 있음) ──

  /// 부팅 직후 집중 재조정 간격.
  static const Duration _coldStartPollInterval = Duration(milliseconds: 300);

  /// 부팅 직후 집중 재조정 창. 사용자가 전화를 받기까지는 현실적으로 5~10초가
  /// 걸리므로, 과거의 2.5초 창은 늘 그 전에 닫혀 있었다.
  static const Duration _coldStartWindow = Duration(seconds: 20);

  /// 상시 재조정 주기. 라이프사이클 전환만으로는 못 잡는 경우(잠금 상태에서 앱이
  /// 계속 백그라운드인 채 accept가 들어오는 경우)를 덮는다.
  static const Duration _reconcileInterval = Duration(seconds: 2);

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
  Timer? _reconcileTimer;

  /// 이미 처리한 callUuid 집합(중복 진입 방지).
  final Set<String> _handledUuids = <String>{};

  bool _attached = false;

  /// 재조정 재진입 가드(폴링·라이프사이클·타이머가 겹칠 수 있다).
  bool _reconciling = false;

  /// 현재 통화를 떠받치는 CallKit 콜의 uuid(없으면 null).
  ///
  /// `ended` 이벤트가 **이 콜**의 것일 때만 통화를 내리기 위해 필요하다. 통화 중에
  /// 두 번째 전화가 오면 그 콜을 endCall로 거절하는데, 그때도 `ended`가 오므로
  /// uuid를 구분하지 않으면 **진행 중이던 통화를 끊어버린다**.
  String? _activeUuid;

  /// [_activeUuid]가 활성 콜 목록에서 연속으로 안 보인 횟수(종료 재조정용).
  int _endMisses = 0;

  /// 종료로 확정하기 전 필요한 연속 미검출 횟수. accept 직후의 짧은 등록 레이스로
  /// 멀쩡한 통화를 끊지 않도록 한 번은 흘려보낸다.
  static const int _endMissesToConfirm = 2;

  /// 라이브 이벤트 구독 + 재조정 루프를 시작한다. 멱등.
  ///
  /// 라이브 이벤트 구독([_sub])은 즉시(동기적으로) 건다 — killed 상태에서 뒤늦게
  /// 오는 accept 이벤트를 놓치지 않기 위해. 콜드스타트 재조정은 최대
  /// [_coldStartWindow]까지 걸리므로 **fire-and-forget**으로 띄운다.
  Future<void> attach() async {
    if (_attached) return;
    _attached = true;
    _sub = callkit.onEvent.listen(_onEvent);
    WidgetsBinding.instance.addObserver(this);
    // 상시 재조정: 이벤트가 유실돼도 수락된 콜을 반드시 줍는다.
    _reconcileTimer = Timer.periodic(
      _reconcileInterval,
      (_) => unawaited(_reconcile()),
    );
    unawaited(_handleColdStart());
  }

  /// 구독을 해제한다(provider dispose에서 호출).
  void dispose() {
    _sub?.cancel();
    _sub = null;
    _reconcileTimer?.cancel();
    _reconcileTimer = null;
    if (_attached) WidgetsBinding.instance.removeObserver(this);
    _attached = false;
  }

  /// 앱이 다시 살아나는 순간마다 수락된 콜이 있는지 확인한다. 잠금 해제·CallKit
  /// 화면에서 앱으로 복귀 등 전이 시점이 유실된 accept를 줍기 가장 좋은 지점이다.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      unawaited(_reconcile());
    }
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
        // 타임아웃 이벤트엔 이름이 없어서(id만), 표시 시점에 기억해 둔 실제
        // 캐릭터명을 쓴다(없으면 '비버'로 폴백).
        await _onTimeout(uuid: id, name: callkit.nameFor(id) ?? '비버');
      case CallEventActionCallEnded(:final callKitParams):
        await _onEnded(callKitParams.id);
      case CallEventActionCallToggleAudioSession(:final isActive):
        // CallKit이 통화 오디오 세션을 활성화했다 = 마이크/스피커를 열 시점.
        // (네이티브 플래그가 진실이고 이건 지연 0의 빠른 경로다.)
        _log('CallKit 오디오 세션 ${isActive ? "활성" : "비활성"}');
        if (isActive) {
          ref.read(normalCallControllerProvider.notifier).onCallKitAudioReady();
        }
      default:
        break;
    }
  }

  /// accept 처리: 미인증/통화중/중복 가드 후 **CallKit 콜을 유지한 채** 통화 세션을
  /// 시작하고, 화면 진입은 병렬로 태운다.
  Future<void> _onAccept(IncomingCallPayload payload) async {
    final uuid = payload.callUuid.isEmpty ? null : payload.callUuid;

    // 중복 진입 방지(라이브 이벤트 + 네이티브 래치 + 주기 재조정).
    if (uuid != null) {
      if (_handledUuids.contains(uuid)) return;
      if (_handledUuids.length > 200) _handledUuids.clear();
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

    _log('accept 수락 → 세션 시작(characterId=${payload.characterId}, uuid=$uuid)');
    _activeUuid = uuid;

    // CallKit 콜은 대화가 끝날 때까지 **유지한다**.
    //
    // 과거엔 여기서 곧바로 endAllCalls()로 끊었다("CallKit은 벨 트리거 전용"). 그러면
    // 잠금화면 통화 UI가 사라지고, 백그라운드 프로세스를 붙잡아 둘 근거도, 통화
    // 오디오 세션을 활성화해 줄 주체도 함께 사라진다. 콜을 살려 두면 그 셋을 OS가
    // 보장하고, 오디오 세션 충돌(과거 P1의 원인으로 지목된 플러그인 자동 재구성)은
    // `configureAudioSession: false` + 네이티브 카테고리 소유로 따로 막는다.

    // 1단계: WS를 즉시 연결한다. 화면·오디오와 무관하게 서버가 오프닝 멘트를
    // 만들기 시작한다. 오디오는 CallKit의 didActivate 시점에 2단계로 붙는다.
    unawaited(
      ref
          .read(normalCallControllerProvider.notifier)
          .startFromIncoming(payload.characterId, callUuid: uuid),
    );

    // 화면 진입은 병렬(비차단). 잠금 상태에선 그려지지 않지만, 사용자가 잠금을
    // 풀면 통화 화면이 이미 떠 있다.
    unawaited(_navigateToCall(payload.characterId));
  }

  /// CallKit 콜 종료. `endAllCalls()`를 걷어낸 뒤로 이 이벤트는 **사용자의 실제
  /// 종료**(잠금화면 종료 버튼 등)를 뜻한다. 통화 파이프라인을 반드시 함께 내린다.
  ///
  /// 우리 쪽 [NormalCallController.hangUp]이 부른 endCall로도 이 이벤트가 오지만,
  /// hangUp은 이미 종료된 통화에 대해 teardown만 하고 빠지므로 안전하다.
  Future<void> _onEnded(String uuid) async {
    // 통화 중 두 번째 수신을 거절했을 때도 ended가 온다. **현재 통화의 콜**이 아니면
    // 건드리지 않는다 — 구분하지 않으면 진행 중이던 통화를 끊게 된다.
    // (네이티브 래치도 여기서 지우면 안 된다. 아직 소비되지 않은 다른 콜의 래치를
    //  날릴 수 있고, 네이티브는 이미 uuid가 맞을 때만 지운다.)
    if (uuid.isEmpty || uuid != _activeUuid) {
      _log('CallKit 콜 종료(uuid=$uuid) — 현재 통화 아님, 무시');
      return;
    }
    _activeUuid = null; // 같은 uuid로 ended가 두 번 와도 한 번만 처리
    _endMisses = 0;
    await callkit.clearPendingAcceptedCall();
    _log('CallKit 콜 종료(uuid=$uuid) → 통화 정리');
    await ref.read(normalCallControllerProvider.notifier).hangUp();
    // 주의: _handledUuids에서는 **지우지 않는다**. 종료 직후 activeCalls()가 이 콜을
    // 아직 accepted로 들고 있으면 재조정 루프가 통화를 되살려 버린다. 콜 uuid는 통화마다
    // 새로 발급되므로 남겨 둬도 다음 전화를 막지 않는다(200개 상한 있음).
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
  /// (최대 [_readyTimeout]). 타임아웃까지 준비 안 되면 안전하게 no-op(로그만) —
  /// 세션 자체는 화면과 무관하게 이미 돌고 있다.
  Future<void> _navigateToCall(int characterId) async {
    final ready = await _awaitNavigatorReady();
    final nav = appNavigatorKey.currentState;
    if (!ready || nav == null) {
      _log('네비게이션 실패: navigator 미준비(타임아웃 ${_readyTimeout.inSeconds}s)');
      return;
    }
    nav.pushNamed(Routes.callLoading, arguments: characterId);
  }

  /// 수락된 콜이 있는지 확인하고 있으면 소비한다. 소비했으면 true.
  ///
  /// 순서: (1) 네이티브 래치(iOS, 이벤트 유실과 무관) → (2) 활성 콜 목록의
  /// `isAccepted`(플랫폼 공통 폴백). 재진입 가드가 있어 겹쳐 호출해도 안전하다.
  Future<bool> _reconcile() async {
    if (_reconciling) return false;
    _reconciling = true;
    try {
      final pending = await callkit.pendingAcceptedCall();
      if (pending != null) {
        // 먼저 지우고 소비한다: 소비 중 예외가 나도 같은 래치를 무한 재시도하지
        // 않게 한다(dedup이 이중 소비를 막으므로 순서를 바꿀 이유가 없다).
        await callkit.clearPendingAcceptedCall();
        _log('네이티브 래치에서 accept 회수(uuid=${pending['id']})');
        await _onAccept(_payloadFromMap(pending));
        return true;
      }
      final calls = await callkit.activeCalls();
      for (final call in calls) {
        if (!call.isAccepted) continue; // 표시/ringing 상태는 소비하지 않음.
        if (call.id.isNotEmpty && _handledUuids.contains(call.id)) continue;
        _log('활성 콜 목록에서 accept 회수(uuid=${call.id})');
        _endMisses = 0;
        await _onAccept(_payloadFromParams(call));
        return true;
      }

      // 종료 재조정. `ended` 이벤트도 accept와 똑같이 버퍼가 없어 유실될 수 있으므로,
      // "통화 중이라고 믿는 콜이 CallKit 목록에서 사라졌는가"를 상태로 확인한다.
      // 유실되면 통화가 영원히 끝나지 않은 것처럼 남는다.
      //
      // 연속 [_endMissesToConfirm]회 확인 후에만 처리한다 — accept 직후 목록에
      // 아직 안 잡히는 짧은 레이스로 멀쩡한 통화를 끊지 않기 위해.
      final active = _activeUuid;
      if (active != null && !calls.any((c) => c.id == active)) {
        _endMisses++;
        if (_endMisses >= _endMissesToConfirm) {
          _log('활성 콜 소멸(uuid=$active) → 통화 종료 처리');
          await _onEnded(active);
          return true;
        }
      } else {
        _endMisses = 0;
      }
      return false;
    } catch (e) {
      _log('재조정 실패(무시): $e');
      return false;
    } finally {
      _reconciling = false;
    }
  }

  /// 콜드스타트: 앱이 종료(killed)돼 있다가 VoIP 푸시로 켜진 경우, 라이브 accept
  /// 이벤트는 구독([_sub])이 붙기 전에 발생해 **유실**될 수 있다(broadcast,
  /// 리플레이 없음). 부팅 직후 잠시 동안 집중적으로 재조정한다.
  ///
  /// 세션 복원만 기다리고 navigator는 기다리지 않는다 — 통화 세션의 시작은 화면과
  /// 무관하고, 네비게이션은 [_navigateToCall]이 자체적으로 준비를 기다린다.
  Future<void> _handleColdStart() async {
    await _awaitSessionRestored();
    final deadline = DateTime.now().add(_coldStartWindow);
    while (DateTime.now().isBefore(deadline)) {
      if (await _reconcile()) return;
      await Future<void>.delayed(_coldStartPollInterval);
    }
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

  /// CallKit 콜 파라미터 → 도메인 페이로드(라이브 이벤트 / 활성 콜 목록 경로).
  IncomingCallPayload _payloadFromParams(CallKitParams p) {
    final characterId =
        IncomingCallPayloadDto.asInt(p.extra?['characterId']) ??
            kDefaultInboundCharacterId;
    final name = p.nameCaller;
    return IncomingCallPayload(
      callUuid: p.id,
      characterId: characterId,
      characterName: (name == null || name.isEmpty)
          ? characterName(characterId)
          : name,
      imageUrl: p.avatar,
    );
  }

  /// 네이티브 래치(`getPendingAcceptedCall`) → 도메인 페이로드.
  ///
  /// 플랫폼 채널이 돌려주는 map은 `Map<Object?, Object?>`로 중첩되므로 extra를
  /// 느슨하게 읽는다.
  IncomingCallPayload _payloadFromMap(Map<String, dynamic> m) {
    final extra = m['extra'];
    final rawCharacterId =
        extra is Map ? extra['characterId'] : null;
    final characterId = IncomingCallPayloadDto.asInt(rawCharacterId) ??
        kDefaultInboundCharacterId;
    final name = m['nameCaller'] as String?;
    return IncomingCallPayload(
      callUuid: (m['id'] as String?) ?? '',
      characterId: characterId,
      characterName: (name == null || name.isEmpty)
          ? characterName(characterId)
          : name,
    );
  }

  /// 디버그 트리거: 로컬로 수신 화면을 띄운다(푸시 대체).
  ///
  /// 실기기에서 개발용 버튼으로 호출해 "전화 오는 화면"을 확인하는 용도.
  Future<void> simulateIncomingCall({
    int characterId = kDefaultInboundCharacterId,
    String? nameOverride,
  }) async {
    // Android 14+ 전체화면 인텐트 / 알림 권한을 먼저 요청(최초 1회 팝업).
    await callkit.requestNotificationPermission();
    await callkit.requestFullIntentPermission();

    final payload = IncomingCallPayload(
      callUuid: const Uuid().v4(),
      characterId: characterId,
      // Show the selected avatar's name (Bibi/Baba) instead of a fixed label.
      characterName: nameOverride ?? characterName(characterId),
    );
    await callkit.showIncoming(payload);
  }

  void _log(String msg) {
    if (kDebugMode) debugPrint('[incoming_call] $msg');
  }
}
