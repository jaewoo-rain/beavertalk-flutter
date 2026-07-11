import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../alarm/domain/entities/alarm.dart';
import '../../alarm/presentation/providers/alarm_list_controller.dart';
import '../../../mock/mock_data.dart' show characterName;
import '../../normalcall/presentation/normalcall_controller.dart';
import '../domain/entities/incoming_call_payload.dart';
import '../services/callkit_service.dart';

/// 저장된 **알람 시간**이 되면 로컬로 전화(수신 화면)를 띄우는 스케줄러.
///
/// 서버 푸시(FCM/VoIP) 없이 동작하는 **로컬 단계**의 자동 트리거다. `simulateIncomingCall`
/// (디버그 버튼)을 대체해, 알람의 요일·시각이 현재와 맞으면 그 알람의 캐릭터로
/// [CallkitService.showIncoming]을 호출한다.
///
/// ## 한계(중요)
/// Dart 타이머 기반이라 **앱 프로세스가 살아 있을 때만**(포그라운드/백그라운드) 동작한다.
/// 앱을 완전히 종료하면 울리지 않는다(iOS 백그라운드도 타이머가 정지됨). "앱이 꺼져
/// 있어도 정시에" 울리려면 서버 푸시(FCM/APNs VoIP)가 필요하다 — 후속 단계.
///
/// ## 동작
/// - [_checkInterval]마다 현재 시각을 확인(±간격만큼 오차 가능).
/// - 활성 알람 중 오늘 요일 + `hour:minute`가 일치하고, **이번 분에 아직 안 울린** 것을
///   찾아 전화 표시. 같은 분 중복 발사는 [_firedKeys]로 막는다.
/// - 미인증이거나 이미 통화 중이면 건너뛴다.
class InboundCallScheduler {
  /// [ref]로 알람 목록/통화 상태를 읽고, [callkit]으로 수신 화면을 띄운다.
  InboundCallScheduler({required this.ref, required this.callkit});

  /// 알람 목록/normalcall 상태 조회용 ref.
  final Ref ref;

  /// CallKit 래퍼.
  final CallkitService callkit;

  /// 현재 시각 확인 주기. 60초보다 짧아야 특정 분을 놓치지 않는다.
  static const Duration _checkInterval = Duration(seconds: 20);

  Timer? _timer;
  bool _started = false;

  /// 이번 분에 이미 울린 알람 키(`alarmId:yyyy-M-d:H:m`) — 같은 분 중복 발사 방지.
  final Set<String> _firedKeys = <String>{};

  /// 스케줄러를 시작한다(멱등). 권한을 미리 요청하고, 주기 체크를 건다.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    // 잠금화면 위 표시 + 알림 권한을 미리 확보(최초 1회 팝업).
    await callkit.requestNotificationPermission();
    await callkit.requestFullIntentPermission();
    // 알람 목록이 아직 안 불러와졌으면 로드를 시작시켜 둔다.
    ref.read(alarmListControllerProvider);
    _timer = Timer.periodic(_checkInterval, (_) => _tick());
    _tick();
  }

  /// 스케줄러를 멈춘다(provider dispose에서 호출).
  void stop() {
    _timer?.cancel();
    _timer = null;
    _started = false;
    _firedKeys.clear();
  }

  /// 주기 체크: 지금 울려야 할 알람이 있으면 전화를 띄운다.
  Future<void> _tick() async {
    // 로그인 안 돼 있으면 알람 조회 자체가 불가 → 스킵.
    if (Supabase.instance.client.auth.currentSession == null) return;

    // 이미 통화 중이면 새 전화를 띄우지 않는다.
    final phase = ref.read(normalCallControllerProvider).phase;
    if (phase == CallPhase.connecting ||
        phase == CallPhase.inCall ||
        phase == CallPhase.ending) {
      return;
    }

    // 캐시된 알람 목록(없으면 이번 tick은 로드만 유도하고 종료).
    // `.value`는 로드 실패(예: 알람 조회 401) 시 에러를 **재던져** 20초마다
    // unhandled exception을 낸다. `.valueOrNull`은 에러/로딩 시 null → tick 스킵.
    final alarms = ref.read(alarmListControllerProvider).valueOrNull;
    if (alarms == null || alarms.isEmpty) return;

    final now = DateTime.now();
    // Alarm.days 인덱스는 0=일 … 6=토. Dart weekday는 월=1 … 일=7 → 일요일만 0으로.
    final dayIndex = now.weekday == DateTime.sunday ? 0 : now.weekday;

    for (final a in alarms) {
      if (!a.active || a.id == null) continue;
      if (dayIndex < 0 || dayIndex >= a.days.length) continue;
      if (!a.days[dayIndex]) continue;
      if (a.hour24 != now.hour || a.minute != now.minute) continue;

      final key = '${a.id}:${now.year}-${now.month}-${now.day}:'
          '${now.hour}:${now.minute}';
      if (_firedKeys.contains(key)) continue;
      _firedKeys.add(key);
      _pruneFiredKeys();

      await _ring(a);
    }
  }

  /// 알람의 캐릭터 정보로 수신 화면을 띄운다.
  Future<void> _ring(Alarm a) async {
    if (kDebugMode) {
      debugPrint('[inbound_scheduler] 알람 발사 → '
          'characterId=${a.characterId} (${a.characterName ?? '?'})');
    }
    final payload = IncomingCallPayload(
      callUuid: const Uuid().v4(),
      characterId: a.characterId,
      // Server name when present, else the selected avatar's name (Bibi/Baba).
      characterName: a.characterName ?? characterName(a.characterId),
      imageUrl: a.imageUrl,
    );
    await callkit.showIncoming(payload);
  }

  /// 발사 키 세트가 무한히 커지지 않도록 오래된 것을 정리(간단히 상한만 둔다).
  void _pruneFiredKeys() {
    if (_firedKeys.length > 200) _firedKeys.clear();
  }
}
