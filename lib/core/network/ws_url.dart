import 'env.dart';

/// Rewrites [Env.apiBaseUrl] (already `…/api/v1`) from its HTTP scheme to the
/// WebSocket equivalent (`https→wss`, `http→ws`), leaving the `/api/v1` prefix
/// intact. Shared by every WS endpoint so no host is ever hardcoded.
String _wsBase() {
  final base = Env.apiBaseUrl;
  if (base.startsWith('https://')) {
    return base.replaceFirst('https://', 'wss://');
  }
  if (base.startsWith('http://')) {
    return base.replaceFirst('http://', 'ws://');
  }
  return base;
}

/// Builds the WebSocket URL for the normalcall live-conversation stream.
///
/// Appends `/calls/stream?token=<JWT>` to the WS base. The [token] is
/// percent-encoded so JWT padding characters (`=`, `.`, `+`, `/`) survive
/// transport.
///
/// Example: `https://host/api/v1` → `wss://host/api/v1/calls/stream?token=…`.
String normalcallWsUrl(String token) =>
    '${_wsBase()}/calls/stream?token=${Uri.encodeComponent(token)}';

/// Builds the WebSocket URL for the Pronunciation Challenge server-STT stream.
///
/// Appends `/pron/stt/ws?token=<Supabase access token>` to the WS base — the
/// same host/scheme handling as [normalcallWsUrl], so the STT socket follows the
/// app's configured backend with no separate constant. The token is required by
/// the server (missing/invalid → 1008 close, which the client degrades to tap
/// input).
///
/// Example: `https://host/api/v1` → `wss://host/api/v1/pron/stt/ws?token=…`.
String pronSttWsUrl(String token) =>
    '${_wsBase()}/pron/stt/ws?token=${Uri.encodeComponent(token)}';
