import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Builds the WebSocket URL for the Pronunciation Challenge server STT.
///
/// ## Why this is NOT `Env.apiBaseUrl`
/// The STT streaming endpoint (`/api/v1/pron/stt/ws`, Google Cloud
/// Speech-to-Text) lives on the **web backend** (`beavertalk-web-api…run.app`),
/// not the app backend (`beavertalk-app-demo-api…`, auth/members/level). So it
/// resolves from its own origin constant, mirroring the web game's
/// `STT_PROD_WS_ORIGIN` (`app/public/pronunciation-challenge.html`).
///
/// **`API_BASE_URL` 의 스킴만 https→wss 로 바꿔 쓰면 안 된다.** 그 호스트(app 백엔드)에
/// 같은 경로로 WS 핸드셰이크를 걸면 403 이 돌아온다 — 그 라우트가 없다. web 백엔드는
/// 같은 요청에 101(Switching Protocols)을 준다. 두 서비스는 별개다.
///
/// Resolution order for the origin (host + scheme, no path):
/// 1. `--dart-define=PRON_STT_WS_ORIGIN=…` build-time override,
/// 2. `.env`'s `PRON_STT_WS_ORIGIN` (loaded in `main`),
/// 3. the production web backend (default below).
///
/// `.env` 는 gitignore 라 새로 클론한 환경·CI 는 3번(아래 상수)으로 떨어진다. 그래서
/// 상수도 항상 실제 주소와 맞춰 둔다 — 둘 중 하나만 고치면 "내 기기에선 되는데" 가 된다.
///
/// The value may use any of `wss://h`, `ws://h`, `https://h`, `http://h`, or a
/// bare `host:port`; it is normalized to a `ws`/`wss` scheme. For local device
/// testing point it at the PC LAN IP, e.g.
/// `--dart-define=PRON_STT_WS_ORIGIN=ws://192.168.0.30:8080`.
String pronSttWsUrl() {
  final origin = _resolveOrigin();
  final normalized = _toWsScheme(_trimTrailingSlash(origin));
  return '$normalized$_wsPath';
}

/// Path appended to the resolved origin. Must match the web backend router
/// (`routers/pron_stt.py` → `prefix="/api/v1/pron/stt"`, `@router.websocket("/ws")`).
const String _wsPath = '/api/v1/pron/stt/ws';

/// Production web backend (Cloud Run). STT deployment there is gated on the
/// service having `stt_key.json` + `STT_GCP_KEY_PATH`; until then the app
/// connect fails and the screen degrades to tap input.
///
/// ⚠ **리전이 틀려 있었다** — `us-central1` 로 박혀 있었는데 서비스는
/// `asia-northeast3` 에 있다. 그 주소는 Cloud Run 이 아니라 구글의 404 페이지를
/// 돌려주는(= 그런 서비스 없음) 죽은 호스트였고, [SttService] 는 연결 실패를 절대
/// 던지지 않고 탭 입력으로 조용히 폴백하므로 **게임은 도는데 말해도 반응이 없는**
/// 상태가 오래 안 드러났다. 주소를 바꿀 땐 실제로 WS 핸드셰이크가 101 인지 확인할 것.
const String _prodOrigin =
    'wss://beavertalk-web-api-333511894671.asia-northeast3.run.app';

const String _defineOrigin =
    String.fromEnvironment('PRON_STT_WS_ORIGIN', defaultValue: '');

/// dart-define wins; `.env` is read at call time (kept out of the `const` so a
/// missing dotenv never throws). Falls back to prod.
String _resolveOrigin() {
  if (_defineOrigin.isNotEmpty) return _defineOrigin;
  final env = dotenv.maybeGet('PRON_STT_WS_ORIGIN')?.trim();
  if (env != null && env.isNotEmpty) return env;
  return _prodOrigin;
}

/// Normalizes any scheme to its WebSocket equivalent (`https→wss`, `http→ws`),
/// keeps `ws`/`wss`, and assumes `wss` for a bare host.
String _toWsScheme(String origin) {
  if (origin.startsWith('wss://') || origin.startsWith('ws://')) return origin;
  if (origin.startsWith('https://')) {
    return origin.replaceFirst('https://', 'wss://');
  }
  if (origin.startsWith('http://')) return origin.replaceFirst('http://', 'ws://');
  return 'wss://$origin';
}

String _trimTrailingSlash(String s) =>
    s.endsWith('/') ? s.substring(0, s.length - 1) : s;
