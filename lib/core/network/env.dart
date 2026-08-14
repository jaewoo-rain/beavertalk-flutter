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

  /// 캐스케이드(STT→LLM→TTS) 전용 백엔드. **키가 없으면 [apiBaseUrl] 로 폴백한다.**
  ///
  /// ## 왜 통로마다 호스트가 갈리나
  ///
  /// 캐스케이드 라우터는 **demo-api 에만** 있다 — 서버가 `CASCADE_ENABLED`(기본 False)로
  /// 막고, 운영에는 라우터 자체가 없어 붙으면 **1008 로 닫힌다.** 그런데 WS 주소는
  /// [apiBaseUrl] 을 그대로 따라가므로, 그냥 두면 캐스케이드가 **운영으로 붙어 끊긴다.**
  ///
  /// ⛔ **라이브 통화는 운영 그대로 둔다.** 이건 캐스케이드 소켓 하나만 옮기는 장치다
  /// (사장님 결정 A안, 2026-08-12). [normalcallWsUrl]·[pronSttWsUrl] 은 이 값을 안 본다.
  ///
  /// ⭐ 토큰은 양쪽에서 통한다 — 두 백엔드가 **같은 Supabase 프로젝트**를 본다
  /// (`.env` 의 운영/테스트 SUPABASE_URL 이 동일). 그래서 호스트만 갈라도 인증이 안 깨진다.
  ///
  /// ⚠ 이 키는 `.env` 에 있고 `.env` 는 gitignore 다 — **새 워크트리에 안 따라온다.**
  /// 없으면 캐스케이드가 운영으로 붙어 즉시 끊긴다(에러는 "연결 실패"로만 보인다).
  /// CLAUDE.md R8 목록에 같이 적어 뒀다.
  static String get cascadeApiBaseUrl {
    final value = dotenv.maybeGet('CASCADE_API_BASE_URL')?.trim();
    if (value == null || value.isEmpty) return apiBaseUrl;
    return '${_withScheme(_trimTrailingSlash(value))}$apiPrefix';
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
