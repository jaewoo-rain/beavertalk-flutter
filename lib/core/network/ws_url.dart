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

/// 캐스케이드(STT→LLM→TTS) 통화 스트림의 WS 주소.
///
/// `/cascade/stream?token=<JWT>` — [normalcallWsUrl] 과 **같은 호스트·같은 토큰**이다
/// (서버도 둘 다 `verify_token` 으로 Supabase 액세스 토큰을 본다). 그래서 통로를
/// 바꾸는 데 토큰 경로 변경이 따라붙지 않는다.
///
/// ⚠ 서버 라우터가 **dev 전용**이다(`ENV != prod` 일 때만 include). prod 백엔드에
/// 대고 부르면 소켓이 안 열린다.
String cascadeWsUrl(String token) =>
    '${_wsBase()}/cascade/stream?token=${Uri.encodeComponent(token)}';

/// 통화 통로에 맞는 WS 주소를 고른다.
///
/// 통로 분기를 **한 식**으로 모아 둔 자리다. 컨트롤러 안에 삼항식으로 흩어 두면 어느
/// 통로로 붙는지가 테스트에서 안 보인다 — 여기 있으면 두 분기를 그대로 검사할 수 있다.
String callStreamWsUrl({required String token, required bool cascade}) =>
    cascade ? cascadeWsUrl(token) : normalcallWsUrl(token);

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
