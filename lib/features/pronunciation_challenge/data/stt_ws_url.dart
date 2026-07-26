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
/// Resolution order for the origin (host + scheme, no path):
/// 1. `--dart-define=PRON_STT_WS_ORIGIN=…` build-time override,
/// 2. `.env`'s `PRON_STT_WS_ORIGIN` (loaded in `main`),
/// 3. the production web backend (default below).
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
const String _prodOrigin =
    'wss://beavertalk-web-api-333511894671.us-central1.run.app';

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
