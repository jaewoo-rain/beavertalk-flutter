import 'env.dart';

/// Builds the WebSocket URL for the normalcall live-conversation stream.
///
/// Reuses [Env.apiBaseUrl] (already `…/api/v1`), rewrites the HTTP scheme to its
/// WebSocket equivalent (`https→wss`, `http→ws`), then appends
/// `/calls/stream?token=<JWT>`. The [token] is percent-encoded so JWT padding
/// characters (`=`, `.`, `+`, `/`) survive transport.
///
/// Example: `https://host/api/v1` → `wss://host/api/v1/calls/stream?token=…`.
String normalcallWsUrl(String token) {
  final base = Env.apiBaseUrl;
  final wsBase = base.startsWith('https://')
      ? base.replaceFirst('https://', 'wss://')
      : base.startsWith('http://')
          ? base.replaceFirst('http://', 'ws://')
          : base;
  return '$wsBase/calls/stream?token=${Uri.encodeComponent(token)}';
}
