import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Public Supabase connection config.
///
/// The URL and anon/publishable key are **public** values (safe to embed and
/// commit in a client). They resolve from `.env` (`SUPABASE_URL` /
/// `SUPABASE_ANON_KEY`) when present, otherwise fall back to the hardcoded
/// constants so the app still boots without a bundled `.env`.
abstract final class SupabaseConfig {
  /// Hardcoded public project URL fallback.
  static const String _fallbackUrl =
      'https://ppllscbfdvebsmdatpnc.supabase.co';

  /// Hardcoded public anon/publishable key fallback.
  static const String _fallbackAnonKey =
      'sb_publishable_aCuUS0Bn4GpETaNgv-U-gQ_aucT8ZDS';

  /// Project URL — `.env`'s `SUPABASE_URL`, else the public fallback.
  static String get url {
    final value = dotenv.maybeGet('SUPABASE_URL')?.trim();
    return (value == null || value.isEmpty) ? _fallbackUrl : value;
  }

  /// Anon/publishable key — `.env`'s `SUPABASE_ANON_KEY`, else the fallback.
  static String get anonKey {
    final value = dotenv.maybeGet('SUPABASE_ANON_KEY')?.trim();
    return (value == null || value.isEmpty) ? _fallbackAnonKey : value;
  }
}
