import 'package:web_socket_channel/web_socket_channel.dart';

// Pick the platform connector at compile time: the `dart:io` implementation
// (with a real transport-level pingInterval) on mobile/desktop, and the plain
// WebSocketChannel fallback on web. This conditional import keeps `dart:io` out
// of web builds while still giving native calls a heartbeat.
import 'ws_connect_default.dart'
    if (dart.library.io) 'ws_connect_io.dart' as impl;

/// Opens the normalcall WebSocket with an optional transport-level heartbeat.
///
/// On native platforms [pingInterval] enables `dart:io` ping/pong keep-alive +
/// half-open detection; on web it is ignored (the browser handles it). See the
/// two `ws_connect_*.dart` implementations.
WebSocketChannel connectNormalcallWs(String url, {Duration? pingInterval}) =>
    impl.connectWs(url, pingInterval: pingInterval);
