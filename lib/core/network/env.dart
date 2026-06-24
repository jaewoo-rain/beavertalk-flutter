import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime environment for the backend connection.
///
/// The base host resolves in priority order:
/// 1. `.env`'s `API_BASE_URL` (loaded in `main`) if present and non-empty,
/// 2. `--dart-define=API_BASE_URL=...` build-time override,
/// 3. a platform fallback (Android emulator `10.0.2.2`, else `localhost`).
///
/// The host is scheme-normalized (an `http://` prefix is added when missing)
/// and the `/api/v1` prefix is always appended, so callers use clean paths
/// like `/auth/login`.
abstract final class Env {
  /// Build-time override injected via `--dart-define`.
  static const String _override =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  /// API version prefix shared by every endpoint.
  static const String apiPrefix = '/api/v1';

  /// Android emulators reach the host machine via `10.0.2.2`; web/iOS use
  /// `localhost`.
  static String get _fallbackHost {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  /// `.env` value, or null when dotenv isn't loaded / the key is absent.
  static String? get _dotenvHost {
    // dotenv.maybeGet is safe even if load() never ran.
    final value = dotenv.maybeGet('API_BASE_URL');
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Final base URL including the `/api/v1` prefix.
  static String get apiBaseUrl {
    final host = _dotenvHost ??
        (_override.isNotEmpty ? _override : _fallbackHost);
    return '${_withScheme(_trimTrailingSlash(host))}$apiPrefix';
  }

  /// Adds an `http://` scheme when the value has none (e.g. a bare
  /// `175.123.55.182:8000`).
  static String _withScheme(String host) {
    if (host.startsWith('http://') || host.startsWith('https://')) return host;
    return 'http://$host';
  }

  static String _trimTrailingSlash(String host) =>
      host.endsWith('/') ? host.substring(0, host.length - 1) : host;
}
