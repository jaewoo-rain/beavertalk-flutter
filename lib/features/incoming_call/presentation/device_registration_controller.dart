import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/repositories/device_repository.dart';
import '../services/fcm_service.dart';

/// FCM 토큰을 서버(`POST /devices`)에 등록/삭제하는 컨트롤러.
///
/// 언제 등록하나:
/// - 시작 시 이미 로그인돼 있으면 1회 등록,
/// - **로그인**(auth state `signedIn`) 시 등록,
/// - **토큰 갱신**(FCM `onTokenRefresh`) 시 재등록,
/// - **로그아웃**(`signedOut`) 시 삭제.
///
/// 특징:
/// - **Android 전용**: FCM 토큰은 Android 경로. iOS 는 후속(APNs VoIP)이라 여기서 스킵.
/// - **미인증 보류**: 세션이 없으면 등록하지 않는다(서버가 Bearer 요구).
/// - **중복 억제**: 같은 FCM 토큰은 다시 POST 하지 않는다(in-memory).
/// - **무해한 실패**: 서버 `/devices` 미배포(404) 등은 try/catch 로 삼켜 앱에 영향 없음.
///   실제 활성화는 `kDeviceRegistrationEnabled` 플래그로 켠다(서버 배포 후 true).
class DeviceRegistrationController {
  DeviceRegistrationController({
    required this.repository,
    required this.fcm,
  });

  /// 토큰 등록/삭제 저장소.
  final DeviceRepository repository;

  /// FCM 토큰 조회/갱신 스트림 제공.
  final FcmService fcm;

  /// 서버 계약상 플랫폼 코드. iOS=VoIP(APNs PushKit), 그 외=Android FCM.
  String get _platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios_voip' : 'android_fcm';

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<CallEvent?>? _voipSub;
  StreamSubscription<AuthState>? _authSub;

  /// Native channel (AppDelegate) for the authoritative PushKit VoIP token —
  /// read straight from PKPushRegistry, bypassing the callkit plugin bridge.
  static const MethodChannel _audioChannel = MethodChannel('beavertalk/audio');

  /// 마지막으로 등록에 성공한 토큰(중복 POST 억제용).
  String? _lastRegistered;

  bool _started = false;

  /// 리스너를 붙이고, 이미 로그인돼 있으면 즉시 1회 등록한다. 멱등.
  Future<void> start() async {
    if (_started) return;
    final platform = defaultTargetPlatform;
    // Android=FCM, iOS=VoIP(APNs PushKit). 그 외(데스크톱/web)는 no-op.
    if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
      return;
    }
    _started = true;

    if (platform == TargetPlatform.iOS) {
      // iOS 토큰 소스는 FCM 이 아니라 PushKit VoIP 토큰이다. PushKit 이 준비되면
      // getDevicePushTokenVoIP() 로 조회되고, 갱신 시 이 이벤트가 온다.
      _voipSub = FlutterCallkitIncoming.onEvent.listen((event) {
        if (event is CallEventActionDidUpdateDevicePushTokenVoip) {
          _registerCurrent();
        }
      });
    } else {
      // 토큰 갱신 → 재등록.
      _tokenSub = fcm.onTokenRefresh.listen(_register);
    }

    // 로그인/로그아웃 반응. tokenRefreshed 도 등록 시도(같은 토큰이면 내부에서 스킵).
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((s) {
      switch (s.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          _registerCurrent();
        case AuthChangeEvent.signedOut:
          _unregister();
        default:
          break;
      }
    });

    await _registerCurrent();
  }

  /// 동시 폴링 방지(여러 트리거가 겹쳐도 폴 루프는 하나만).
  bool _polling = false;

  /// 현재 토큰을 조회해 등록을 시도한다(플랫폼별 소스).
  Future<void> _registerCurrent() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // PushKit VoIP 토큰은 **비동기로 늦게** 도착한다(앱 시작/로그인 시점엔 아직
      // null 인 경우가 많음). 1회만 조회하면 놓쳐서 등록이 영영 안 됐다(ios_voip
      // 0건). 짧게 폴링해 토큰이 준비되는 즉시 등록한다. didUpdate 이벤트도 이걸
      // 다시 부르므로 이중 안전. 이미 등록됐으면 _register 내부에서 스킵.
      if (_polling) return;
      _polling = true;
      try {
        for (var attempt = 0; attempt < 15; attempt++) {
          if (Supabase.instance.client.auth.currentSession == null) return;
          final token = await _readVoipToken();
          if (token != null && token.isNotEmpty) {
            await _register(token);
            return;
          }
          await Future<void>.delayed(const Duration(seconds: 1));
        }
      } finally {
        _polling = false;
      }
      return;
    }
    final token = await fcm.getToken();
    if (token != null) await _register(token);
  }

  /// iOS VoIP 토큰을 읽는다: 우선 native(PKPushRegistry 직접) → 실패 시 플러그인.
  /// native 경로가 브릿지 타이밍/유실 문제를 우회한다.
  Future<String?> _readVoipToken() async {
    try {
      final t = await _audioChannel.invokeMethod<String>('getVoipToken');
      if (t != null && t.isNotEmpty) return t;
    } catch (_) {}
    try {
      return await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    } catch (_) {}
    return null;
  }

  /// [token] 을 서버에 등록한다(미인증/중복이면 스킵).
  Future<void> _register(String token) async {
    if (Supabase.instance.client.auth.currentSession == null) return;
    if (token == _lastRegistered) return;
    try {
      await repository.register(platform: _platform, token: token);
      _lastRegistered = token;
      if (kDebugMode) {
        debugPrint('[devices] 등록 완료: ${token.substring(0, 12)}…');
      }
    } catch (e) {
      // 서버 미배포(404) 등 — 앱에 무해. 다음 기회(재로그인/갱신)에 재시도.
      if (kDebugMode) debugPrint('[devices] 등록 실패(무시): $e');
    }
  }

  /// 로그아웃 **직전**(세션이 아직 유효할 때) 명시 호출용. `signedOut` 리스너가 세션
  /// 소멸 **뒤** [_unregister] 를 부르면 `DELETE /devices` 가 401 로 실패하므로,
  /// `logout()` 은 `signOut()` 전에 이걸 먼저 불러 토큰을 확실히 삭제한다(멱등).
  Future<void> unregister() => _unregister();

  /// 로그아웃 시 마지막 토큰을 삭제한다.
  Future<void> _unregister() async {
    // 이번 세션에 등록한 토큰(_lastRegistered)이 비어 있으면(등록 스킵/실패) 실시간 FCM
    // 토큰을 조회해 삭제한다 — 로그아웃 시 이 기기 토큰이 확실히 서버에서 지워지도록.
    final token = _lastRegistered ?? await fcm.getToken();
    _lastRegistered = null;
    if (token == null) return;
    try {
      await repository.delete(token);
    } catch (_) {
      // 삭제 실패는 무시(서버 미배포/이미 삭제 등).
    }
  }

  /// 구독 해제(provider dispose).
  void dispose() {
    _tokenSub?.cancel();
    _voipSub?.cancel();
    _authSub?.cancel();
    _tokenSub = null;
    _voipSub = null;
    _authSub = null;
  }
}
