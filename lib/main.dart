import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth_gate.dart';
import 'app/navigation.dart';
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
  runApp(const ProviderScope(child: BeaverTalkApp()));
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
