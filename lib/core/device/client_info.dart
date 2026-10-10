
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 국적 분류 모델에 함께 가는 기기 값 — 통화 소켓 쿼리로 서버에 넘긴다(2026-10-10 · PM-DEC-495·499).
///
/// 서버(`core/client_info.py`)가 이 값들을 통화 끝 `/predict_long` 요청에 싣는다(모델팀 계약 3차 회신).
/// `client_type=app` 은 서버가 붙인다 — 여기서 보내지 않는다.
///
/// - `client_session`: 앱 설치당 UUID 하나. 같은 사용자의 반복 시도를 묶는다(앱을 지우면 새로 생긴다).
/// - `os` · `os_version` · `app_version` · `device_type`: 읽을 수 있을 때만. **모르는 값은 빼고 추측하지
///   않는다**(모델팀 「빈 값·추측값 금지」).
///
/// 앱 시작 때 [load] 를 한 번 부르고, 소켓 주소를 만들 때 [queryParameters] 를 붙인다. 읽기가
/// 끝나기 전이거나 실패하면 빈 맵이다 — 통화는 그대로 열린다(필드만 빠진다).
class ClientInfo {
  ClientInfo._(this._values);

  static ClientInfo _current = ClientInfo._(const {});

  /// 지금 쓸 값. [load] 전에는 비어 있다.
  static ClientInfo get current => _current;

  final Map<String, String> _values;

  /// 소켓 쿼리에 붙일 값(빈 값 없음).
  Map<String, String> get queryParameters => _values;

  @visibleForTesting
  static void debugSet(Map<String, String> values) =>
      _current = ClientInfo._(Map.unmodifiable(values));

  static const _sessionKey = 'bt:clientSession';

  /// 기기 값을 한 번 읽어 [current] 에 둔다. 실패한 항목은 빼고 나머지만 남긴다.
  static Future<void> load() async {
    final values = <String, String>{};
    void put(String key, String? value) {
      final v = value?.trim();
      if (v != null && v.isNotEmpty) values[key] = v;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      var session = prefs.getString(_sessionKey);
      if (session == null || session.isEmpty) {
        session = const Uuid().v4();
        await prefs.setString(_sessionKey, session);
      }
      put('client_session', session);
    } catch (e) {
      debugPrint('[client-info] session 읽기 실패 → 생략: $e');
    }

    // 웹 축소판(app.beavertalk.im)은 통화가 없어 빼도 된다 — dart:io 를 쓰지 않으려고 이 판정을 쓴다.
    final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final ios = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    if (android || ios) {
      put('os', android ? 'android' : 'ios');
      try {
        final device = DeviceInfoPlugin();
        if (android) {
          put('os_version', (await device.androidInfo).version.release);
        } else {
          put('os_version', (await device.iosInfo).systemVersion);
        }
      } catch (e) {
        debugPrint('[client-info] os_version 읽기 실패 → 생략: $e');
      }
    }

    try {
      final info = await PackageInfo.fromPlatform();
      put(
        'app_version',
        info.buildNumber.isEmpty ? info.version : '${info.version}+${info.buildNumber}',
      );
    } catch (e) {
      debugPrint('[client-info] app_version 읽기 실패 → 생략: $e');
    }

    put('device_type', deviceTypeFor(_shortestSideDp()));
    _current = ClientInfo._(Map.unmodifiable(values));
  }

  /// 화면 짧은 변(dp) → `phone` · `tablet`. 600 이상이면 태블릿(Android·iOS 관례). 모르면 null.
  @visibleForTesting
  static String? deviceTypeFor(double? shortestSideDp) {
    if (shortestSideDp == null || shortestSideDp <= 0) return null;
    return shortestSideDp >= 600 ? 'tablet' : 'phone';
  }

  static double? _shortestSideDp() {
    final views = PlatformDispatcher.instance.views;
    if (views.isEmpty) return null;
    final view = views.first;
    if (view.devicePixelRatio <= 0) return null;
    return view.physicalSize.shortestSide / view.devicePixelRatio;
  }
}
