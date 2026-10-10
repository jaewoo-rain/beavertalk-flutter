import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_timezone/flutter_timezone.dart';

/// 기기의 시간대 — 서버가 「오늘」의 경계(기기 로컬 자정)를 잡는 입력.
///
/// 서버 `premium` 브랜치(09-23) §3: 하루 예산(Free 5분 · Premium 15분)·연속일·달력이
/// 전부 이 값으로 날짜를 자른다. 안 보내면 서버는 UTC 로 자르고, 한국 사용자는 **오전 9시에
/// 날짜가 바뀐다.** 우선순위는 `tz`(IANA) → `tz_offset_min` → UTC.
///
/// ⛔ **세 곳에 같은 값을 보내라** — WS `start` · `GET /calls/daily-status` ·
///   `GET /stats/calendar`. 하나만 다르면 「달력엔 어제인데 통화는 오늘로 셌다」 가 된다.
///   그래서 이 한 곳에서만 읽는다.
/// ⚠ 오프셋 **키 이름**은 곳마다 다르다(서버 dev 실측 09-24): WS `start`·달력은
///   `tz_offset_min`, `daily-status` 는 `tz_offset`(+ 필수 `date`). [params] 는 앞의 둘 전용이다.
///
/// ⚠ `DateTime.now().timeZoneName` 은 IANA 가 아니다(`KST` 같은 약칭). 그래서 플러그인을 쓴다.
abstract final class DeviceTimezone {
  /// IANA 존 이름(`Asia/Seoul`). 플랫폼이 못 주면(웹 일부·테스트) null.
  ///
  /// 캐시하지 않는다 — 여행 중 기기 시간대가 바뀔 수 있고, 호출은 싸다.
  static Future<String?> iana() async {
    try {
      final id = (await FlutterTimezone.getLocalTimezone()).identifier;
      if (!looksLikeIana(id)) {
        // 구형·사용자 지정 안드로이드는 `GMT+09:00` 같은 오프셋 문자열을 준다. 서버는 IANA 가
        // 아닌 tz 를 422 로 거절한다(서버 회신 09-29 §3-1) — 알람 저장이 실패한다. 모르는 값은
        // 싣지 않는다(키가 없으면 서버는 미지정으로 다룬다 · tz_offset_min 폴백).
        debugPrint('[tz] IANA 가 아닌 시간대 — 보내지 않는다: $id');
        return null;
      }
      return id;
    } catch (e) {
      debugPrint('[tz] IANA 조회 실패 — tz_offset_min 만 보낸다: $e');
      return null;
    }
  }

  /// IANA 존 이름 모양인가 — `Area/Location`(`Asia/Seoul` · `America/Argentina/Buenos_Aires`
  /// · `Etc/GMT+9`) 또는 `UTC`·`GMT`. `GMT+09:00`·`KST`·빈 문자열은 아니다.
  static bool looksLikeIana(String id) =>
      id == 'UTC' || id == 'GMT' || _ianaShape.hasMatch(id);

  static final _ianaShape =
      RegExp(r'^[A-Za-z][A-Za-z_\-]*(/[A-Za-z0-9][A-Za-z0-9_+\-]*)+$');

  /// UTC 기준 분(동쪽 +). `tz` 가 없거나 서버가 이름을 못 알아볼 때의 폴백.
  static int offsetMinutes([DateTime? now]) =>
      (now ?? DateTime.now()).timeZoneOffset.inMinutes;

  /// 쿼리·프레임에 그대로 펼칠 두 키. `tz` 를 모르면 그 키는 빠진다.
  static Future<Map<String, Object>> params() async {
    final tz = await iana();
    return {
      'tz': ?tz,
      'tz_offset_min': offsetMinutes(),
    };
  }
}
