import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Mobile/desktop (`dart:io`) connector with a transport-level heartbeat.
///
/// [pingInterval] is forwarded to `dart:io`'s `WebSocket.pingInterval`, which:
/// - sends protocol-level PING frames whenever the socket is otherwise idle
///   (keeps proxies/LBs from idle-closing a silent call — the "1분 끊김"), and
/// - closes the socket if the peer doesn't answer with a PONG within the
///   interval, so a silently dropped (half-open) connection is *detected*
///   instead of leaving the call frozen. That close surfaces via the channel's
///   `onError`/`onDone`, which the controller already recovers from.
WebSocketChannel connectWs(String url, {Duration? pingInterval}) =>
    IOWebSocketChannel.connect(Uri.parse(url), pingInterval: pingInterval);
