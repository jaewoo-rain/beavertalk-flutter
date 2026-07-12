import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth_gate.dart';
import 'app/navigation.dart';
import 'app/push_bootstrap.dart';
import 'app/routes.dart';
import 'core/config/feature_flags.dart';
import 'core/i18n/locale_controller.dart';
import 'core/network/supabase_config.dart';
import 'l10n/app_localizations.dart';
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
  // FCM(밖에서 앱을 깨우는 트리거)의 **포그라운드 경로**를 위해 Firebase를 여기서
  // 1회 초기화한다(옵션 없이 → android/app/google-services.json 자동 사용). 웹은
  // 옵션 없는 initializeApp이 실패하므로 제외하고, 기능 플래그로도 가드한다.
  // (백그라운드/종료 경로는 별도 isolate에서 다시 initializeApp을 호출한다.)
  if (kInboundCallEnabled && !kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // 초기화 실패가 앱 부팅을 막지 않게 삼킨다(푸시 트리거는 부가 기능).
      if (kDebugMode) debugPrint('[fcm] Firebase.initializeApp 실패(무시): $e');
    }
  }
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
class BeaverTalkApp extends ConsumerWidget {
  const BeaverTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // i18n (gen-l10n). The UI locale follows the user's selected native language
    // ([localeControllerProvider], persisted); any language without a matching
    // `app_<code>.arb` (or an unfilled key) falls back to the English template.
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp(
      title: 'BeaverTalk',
      debugShowCheckedModeBanner: false,
      // Lets the 401 interceptor navigate without a BuildContext.
      navigatorKey: appNavigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      // Match the selected language by its languageCode; anything without a
      // translation (no app_<code>.arb) falls back cleanly to English rather
      // than to whatever happens to be first in supportedLocales.
      localeResolutionCallback: (want, supported) {
        if (want != null) {
          for (final s in supported) {
            if (s.languageCode == want.languageCode) return s;
          }
        }
        return const Locale('en');
      },
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
