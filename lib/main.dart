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
import 'theme/app_color_tokens.dart';
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
      // Both modes are built from the Figma `Semantics` tokens
      // ([AppColorTokens]); a screen reads them via `context.c.<token>`.
      //
      // **`themeMode` is pinned to dark on purpose.** The token set is complete
      // in both modes, but the screens are still being mapped off the old
      // Dark-only [AppColors] palette — until that is finished, letting the OS
      // flip this to light would render half the app in the wrong mode. Lift
      // the pin (to `ThemeMode.system`, or a user setting) once the mapping is
      // done; see `docs/2026-07-17_0530_컬러토큰-Dark-Light-매핑.md`.
      theme: _theme(Brightness.light, AppColorTokens.light),
      darkTheme: _theme(Brightness.dark, AppColorTokens.dark),
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
      onGenerateRoute: onGenerateRoute,
    );
  }

  /// One [ThemeData] per mode, driven entirely by [tokens].
  ///
  /// The Material `ColorScheme` is filled in from the same tokens so that any
  /// stock widget (dialogs, pickers, text selection) lands in the right mode
  /// instead of Material's defaults — previously only `primary` and `surface`
  /// were passed, and only for dark.
  static ThemeData _theme(Brightness brightness, AppColorTokens tokens) {
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.backgroundNormalDeep,
      fontFamily: kFontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.primaryNormal,
        brightness: brightness,
        primary: tokens.primaryNormal,
        onPrimary: tokens.primaryOnPrimary,
        surface: tokens.backgroundNormalNormal,
        onSurface: tokens.labelStrong,
        error: tokens.statusNegative,
      ),
      // [AppType]'s styles carry no colour, so every uncoloured `Text` falls
      // through to here. Without this the app would inherit Material's own
      // body colour (a near-white in dark, near-black in light) instead of
      // `Label/Strong` — close enough to look right and wrong everywhere.
      textTheme: base.textTheme.apply(
        bodyColor: tokens.labelStrong,
        displayColor: tokens.labelStrong,
        fontFamily: kFontFamily,
      ),
      extensions: [tokens],
    );
  }
}
