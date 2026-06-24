import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Runtime environment for the backend connection.
///
/// The base URL resolves in this order:
/// 1. `--dart-define=API_BASE_URL=...` if provided (no `/api/v1` suffix).
/// 2. Otherwise a platform fallback (Android emulator vs everything else).
///
/// The `/api/v1` prefix is always appended here, so callers use clean paths
/// like `/auth/login`.
abstract final class Env {
  /// Optional host override injected at build time, e.g.
  /// `--dart-define=API_BASE_URL=http://localhost:8000`.
  static const String _override =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  /// API version prefix shared by every endpoint.
  static const String apiPrefix = '/api/v1';

  /// Host the app talks to when no override is given.
  ///
  /// Android emulators reach the host machine via `10.0.2.2`; web/iOS use
  /// `localhost`.
  static String get _fallbackHost {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  /// Final base URL including the `/api/v1` prefix.
  static String get apiBaseUrl {
    final host = _override.isNotEmpty ? _override : _fallbackHost;
    // Trim a trailing slash so we don't produce `//api/v1`.
    final normalized = host.endsWith('/')
        ? host.substring(0, host.length - 1)
        : host;
    return '$normalized$apiPrefix';
  }
}
