import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime environment for the backend connection.
///
/// The base host resolves in priority order:
/// 1. `.env`'s `API_BASE_URL` (loaded in `main`) if present and non-empty,
/// 2. `--dart-define=API_BASE_URL=...` build-time override,
/// 3. a platform fallback (Android emulator `10.0.2.2`, else `localhost`).
///
/// The host is scheme-normalized (an `http://` prefix is added when missing)
/// and the `/api/v1` prefix is always appended, so callers use clean paths
/// like `/auth/login`.
abstract final class Env {
  /// Build-time override injected via `--dart-define`.
  static const String _override =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  /// API version prefix shared by every endpoint.
  static const String apiPrefix = '/api/v1';

  /// Android emulators reach the host machine via `10.0.2.2`; web/iOS use
  /// `localhost`.
  static String get _fallbackHost {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  /// `.env` 값을 **던지지 않고** 읽는다. 없거나 비었으면 null 이다.
  ///
  /// 🔴 `dotenv.maybeGet` 은 이름과 달리 안전하지 않다 — `env` 게터를 거치므로
  ///    load() 전이면 `NotInitializedError` 를 던진다.
  ///
  /// ⛔ 이 헬퍼는 **[b2bApiBaseUrl] 전용**이다. 기존 키에 씌우면 위젯 테스트에서
  ///    dio 가 실제로 만들어져 초기화 안 된 Supabase 를 건드린다(위 [_dotenvHost]).
  ///    숙제 진입점은 화면을 그리는 판단에 이 값을 쓰므로 던지면 안 된다.
  static String? _dotenvValue(String key) {
    if (!dotenv.isInitialized) return null;
    final value = dotenv.maybeGet(key);
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// `.env` value, or null when the key is absent.
  ///
  /// ⛔ **`_dotenvValue` 로 바꾸지 마라.** `maybeGet` 은 load() 전이면 던지는데,
  ///    위젯 테스트가 그 예외 덕에 네트워크를 안 내보내고 있다. 가드를 씌우면
  ///    dio 가 실제로 만들어지고 `AuthInterceptor` 가 초기화 안 된 Supabase 를
  ///    건드려 **테스트가 통째로 깨진다**(2026-09-03 실측: 3건). 우연이지만
  ///    지금은 이것이 유일한 차단막이다 — 걷어내려면 인터셉터부터 고쳐야 한다.
  static String? get _dotenvHost {
    final value = dotenv.maybeGet('API_BASE_URL');
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Final base URL including the `/api/v1` prefix.
  static String get apiBaseUrl {
    final host = _dotenvHost ??
        (_override.isNotEmpty ? _override : _fallbackHost);
    return '${_withScheme(_trimTrailingSlash(host))}$apiPrefix';
  }

  /// [apiBaseUrl] 에서 `/api/v1` 을 뗀 **루트**. 서버의 `/__dev/*` 도구는 여기 붙는다
  /// (`main.py` 가 라우터 밖에서 `@app.post("/__dev/…")` 로 연다 — API_PREFIX 를 안 탄다).
  ///
  /// dio 는 요청 경로가 절대 URL 이면 `baseUrl` 을 무시하므로, 호출부는 이걸로 절대 URL 을
  /// 만들어 보낸다. 인증 인터셉터는 경로를 안 보고 Bearer 를 붙인다.
  static String get apiRootUrl => stripApiPrefix(apiBaseUrl);

  /// [base] 끝의 [apiPrefix] 를 뗀다. 없으면 그대로. 순수 함수 — dotenv 없이 시험한다.
  static String stripApiPrefix(String base) => base.endsWith(apiPrefix)
      ? base.substring(0, base.length - apiPrefix.length)
      : base;

  /// 캐스케이드(STT→LLM→TTS) 전용 백엔드. **키가 없으면 [apiBaseUrl] 로 폴백한다.**
  ///
  /// ## 왜 통로마다 호스트가 갈리나
  ///
  /// 캐스케이드 라우터는 **demo-api 에만** 있다 — 서버가 `CASCADE_ENABLED`(기본 False)로
  /// 막고, 운영에는 라우터 자체가 없어 붙으면 **1008 로 닫힌다.** 그런데 WS 주소는
  /// [apiBaseUrl] 을 그대로 따라가므로, 그냥 두면 캐스케이드가 **운영으로 붙어 끊긴다.**
  ///
  /// ⛔ **라이브 통화는 운영 그대로 둔다.** 이건 캐스케이드 소켓 하나만 옮기는 장치다
  /// (사장님 결정 A안, 2026-08-12). [normalcallWsUrl]·[pronSttWsUrl] 은 이 값을 안 본다.
  ///
  /// ⭐ 토큰은 양쪽에서 통한다 — 두 백엔드가 **같은 Supabase 프로젝트**를 본다
  /// (`.env` 의 운영/테스트 SUPABASE_URL 이 동일). 그래서 호스트만 갈라도 인증이 안 깨진다.
  ///
  /// ⚠ 이 키는 `.env` 에 있고 `.env` 는 gitignore 다 — **새 워크트리에 안 따라온다.**
  /// 없으면 캐스케이드가 운영으로 붙어 즉시 끊긴다(에러는 "연결 실패"로만 보인다).
  /// CLAUDE.md R8 목록에 같이 적어 뒀다.
  static String get cascadeApiBaseUrl {
    final value = dotenv.maybeGet('CASCADE_API_BASE_URL')?.trim();
    if (value == null || value.isEmpty) return apiBaseUrl;
    return '${_withScheme(_trimTrailingSlash(value))}$apiPrefix';
  }

  /// 발음 챌린지 STT 소켓 전담 백엔드. **비어 있으면 [apiBaseUrl] 을 그대로 쓴다.**
  ///
  /// ## 왜 이 스위치가 필요한가
  ///
  /// 2026-09-08 실측: `/api/v1/pron/stt/ws` 로 실제 WebSocket 핸드셰이크를 보내면
  /// `beavertalk-web-api` 만 **101 Switching Protocols** 를 준다. 앱 백엔드 둘
  /// (`app-api`·`app-demo-api`) 은 **403** 이다 — 라우트가 없다.
  /// 그래서 주소가 [apiBaseUrl] 을 따라가는 현재 설정에서는 소켓이 영영 열리지 않고
  /// 4초 뒤 타임아웃 → 조용히 탭 입력으로 내려앉는다.
  ///
  /// ⚠ **HTTP GET 으로는 이 판별이 안 된다.** FastAPI 의 WebSocket 라우트는 GET 에
  /// 항상 404 를 준다. 앱 서버의 `/calls/stream` 이 401 을 주는 건 인증 미들웨어가
  /// 라우팅보다 먼저 걸리기 때문이지 라우트 유무의 근거가 아니다. 판별하려면
  /// `Upgrade: websocket` 핸드셰이크를 실제로 보내고 상태줄을 봐야 한다.
  ///
  /// ⛔ **기본값을 웹 백엔드로 바꾸지 않았다.** STT 를 앱 서버로 옮긴 것은 「토큰
  /// 필수 = 과금 방어」 결정이었고(`test/ws_url_test.dart` 머리주석), 웹 백엔드는
  /// 인증이 없어 토큰 없이도 핸드셰이크가 통과한다. 호스트를 되돌리는 것은 그 결정을
  /// 뒤집는 일이라 코드가 임의로 할 수 없다. 이 키는 **결정이 내려졌을 때 코드 수정
  /// 없이 꽂는 자리**다.
  ///
  /// ⚠ 이 키는 `.env` 에 있고 `.env` 는 gitignore 다 — 새 워크트리에 안 따라온다.
  static String get pronSttBaseUrl {
    final value = dotenv.maybeGet('PRON_STT_BASE_URL')?.trim();
    if (value == null || value.isEmpty) return apiBaseUrl;
    return '${_withScheme(_trimTrailingSlash(value))}$apiPrefix';
  }

  /// B2B 교실·과제 전담 백엔드. **비어 있으면 숙제 기능이 통째로 꺼진다.**
  ///
  /// ## 왜 호스트가 갈리나
  ///
  /// 교실 도메인은 2026-09-02 결정으로 별도 서비스(`beavertalk-b2b-api`)로 분리됐다.
  /// [apiBaseUrl] 이 보는 앱 서버에는 `/classrooms/*` 경로가 **하나도 없다** — 그냥
  /// 두면 참여·과제·제출이 전부 404 다. 실기기에서 참여코드가 「코드를 찾을 수
  /// 없어요」로 뜬 것이 이 때문이었다(코드 문제가 아니었다).
  ///
  /// ⭐ 토큰은 양쪽에서 통한다 — 두 백엔드가 **같은 Supabase 프로젝트·같은 DB** 를
  /// 본다. 그래서 호스트만 갈라도 인증이 안 깨진다([cascadeApiBaseUrl] 과 같은 사정).
  ///
  /// ⚠ [cascadeApiBaseUrl] 과 달리 [apiBaseUrl] 로 **폴백하지 않는다.** 폴백하면
  /// 없는 경로를 두드려 404 를 「반이 없다」로 오독하게 된다. 비면 `null` 을 주고
  /// 숙제 진입점(홈 배너·마이페이지 수업 카드)이 조용히 사라진다.
  ///
  /// ⚠ 이 키는 `.env` 에 있고 `.env` 는 gitignore 다 — **새 워크트리·새 기기에
  /// 안 따라온다.** 2026-09-09 실기기(iOS) 사고가 이것이었다: 맥에서 빌드한
  /// 아이폰 앱의 `.env` 가 9/2 분리 이전 사본이라 이 키만 없었고, 다른 기능은
  /// 전부 멀쩡한 채 참여코드 화면만 죽었다.
  ///
  /// ⭐ 그래서 `--dart-define=B2B_API_BASE_URL=...` 도 받는다. `.env` 를 못 옮기는
  /// 빌드(CI·다른 기기)에서 유일하게 쓸 수 있는 통로다. 우선순위는 [apiBaseUrl] 과
  /// 같다 — `.env` 가 먼저고, 없으면 dart-define 이다.
  static String? get b2bApiBaseUrl {
    final value = _dotenvValue('B2B_API_BASE_URL') ??
        (_b2bOverride.isNotEmpty ? _b2bOverride : null);
    if (value == null) return null;
    return '${_withScheme(_trimTrailingSlash(value))}$apiPrefix';
  }

  /// B2B 호스트의 빌드타임 주입값. `.env` 가 없을 때만 쓰인다.
  static const String _b2bOverride =
      String.fromEnvironment('B2B_API_BASE_URL', defaultValue: '');

  /// 숙제 기능을 켤 수 있는가. 화면은 이 값만 보고 진입점을 그린다.
  static bool get hasB2bApi => b2bApiBaseUrl != null;

  /// Adds an `http://` scheme when the value has none (e.g. a bare
  /// `175.123.55.182:8000`).
  static String _withScheme(String host) {
    if (host.startsWith('http://') || host.startsWith('https://')) return host;
    return 'http://$host';
  }

  static String _trimTrailingSlash(String host) =>
      host.endsWith('/') ? host.substring(0, host.length - 1) : host;
}
