import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth_gate.dart';
import 'app/navigation.dart';
import 'app/push_bootstrap.dart';
import 'app/routes.dart';
import 'core/network/supabase_config.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env first (API_BASE_URL + Supabase keys). Optional — the app still
  // boots on the hardcoded fallbacks if the file is missing or fails to parse.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // No .env bundled / parse error → fall through to dart-define/platform
    // and the public Supabase fallback constants.
  }
  // Supabase persists + auto-refreshes its own session; the backend verifies
  // the issued access token. URL/key are public (env-or-fallback).
  await Supabase.initialize(
    url: SupabaseConfig.url,
    // The provided key is an `sb_publishable_...` key; pass it via the
    // non-deprecated `publishableKey` param (replaces `anonKey`).
    publishableKey: SupabaseConfig.anonKey,
  );
  // Own the Riverpod container explicitly so the incoming-call bootstrap and the
  // widget tree share the SAME providers (the coordinator's "already in a call"
  // guard must read the same normalcall state the screens use).
  final container = ProviderContainer();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BeaverTalkApp(),
    ),
  );
  // 인바운드 콜(비버가 거는 전화) 로컬 트리거 초기화. 앱 시작을 막지 않도록
  // fire-and-forget(+ 내부 try/catch, kInboundCallEnabled/!kIsWeb 가드).
  unawaited(initIncomingCallLocal(container));
}

/// App root. Enters through [AuthGate] (token → home/onboarding); the component
/// gallery stays at `/gallery`. Deep navigation uses [onGenerateRoute].
class BeaverTalkApp extends StatelessWidget {
  const BeaverTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeaverTalk',
      debugShowCheckedModeBanner: false,
      // Lets the 401 interceptor navigate without a BuildContext.
      navigatorKey: appNavigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: kFontFamily,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      home: const AuthGate(),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
