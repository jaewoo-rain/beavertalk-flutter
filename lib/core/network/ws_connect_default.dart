import 'package:web_socket_channel/web_socket_channel.dart';

/// Web / non-IO fallback: opens a plain [WebSocketChannel].
///
/// Browsers manage WebSocket ping/pong (and idle keep-alive) at the platform
/// level, and `dart:io`'s `pingInterval` isn't available here, so [pingInterval]
/// is accepted for a uniform signature but ignored. Normalcall is device-only
/// anyway (the controller bails on web before connecting), so this path is only
/// here to keep web builds compiling.
WebSocketChannel connectWs(String url, {Duration? pingInterval}) =>
    WebSocketChannel.connect(Uri.parse(url));
