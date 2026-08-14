import 'env.dart';

/// Rewrites [Env.apiBaseUrl] (already `…/api/v1`) from its HTTP scheme to the
/// WebSocket equivalent (`https→wss`, `http→ws`), leaving the `/api/v1` prefix
/// intact. Shared by every WS endpoint so no host is ever hardcoded.
String _wsBase([String? httpBase]) {
  final base = httpBase ?? Env.apiBaseUrl;
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
/// ⛔ **호스트가 라이브와 다를 수 있다.** 캐스케이드 라우터는 demo-api 에만 있어
/// (`CASCADE_ENABLED` 기본 False, 운영엔 라우터 자체가 없어 1008 close),
/// `.env` 의 `CASCADE_API_BASE_URL` 이 있으면 그쪽으로 붙는다. 없으면 [normalcallWsUrl]
/// 과 같은 호스트로 폴백한다 — 즉 **키가 없는 환경의 동작은 종전과 같다.**
/// 토큰은 두 백엔드가 같은 Supabase 프로젝트를 봐서 양쪽에서 통한다.
String cascadeWsUrl(String token) =>
    '${_wsBase(Env.cascadeApiBaseUrl)}/cascade/stream?token=${Uri.encodeComponent(token)}';

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
