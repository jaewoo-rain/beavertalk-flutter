import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth_gate.dart';
import 'app/navigation.dart';
import 'app/push_bootstrap.dart';
import 'app/routes.dart';
import 'core/i18n/locale_controller.dart';
import 'core/network/supabase_config.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_color_tokens.dart';
import 'theme/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 세로 고정. 정본 프레임이 폰 375×812·태블릿 810×1080 전부 세로이고, 가로
  // 상자로 그려 둔 화면이 하나도 없다.
  //
  // 잠금은 **세 곳에 걸려 있다.** 예전에는 여기 한 곳뿐이었고 「한 주인이 둘보다
  // 낫다」고 적혀 있었는데, 실측해 보니 그 한 주인이 두 경우에서 무시당했다:
  //
  //   1. 여기(런타임) — 폰과 Android 15 이하 태블릿을 덮는다.
  //   2. `AndroidManifest.xml` 의 `screenOrientation="portrait"` + Android 16
  //      대화면 opt-out 속성 — targetSdk 36 은 600dp 이상 화면에서 방향 제한을
  //      통째로 무시한다. 런타임 호출도 같이 무시된다.
  //   3. `ios/Runner/Info.plist` — `UIRequiresFullScreen` 이 없으면 iOS 가 앱을
  //      멀티태스킹 지원으로 보고 이 호출을 무시한다(iPad 가 가로로 돌아갔다).
  //
  // 매니페스트 잠금이 액티비티를 재생성해 `MainActivity` 의 MediaProjection
  // 녹화(`beavertalk/challenge_recorder`)를 끊을 걱정은 없다 — 창이 세로로
  // 고정되면 회전 자체가 일어나지 않고, `configChanges` 가 이미
  // `orientation|screenSize|smallestScreenSize|screenLayout` 을 잡고 있다.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
  // Firebase 초기화는 여기서 하지 않는다 — `_initFcm` 안으로 옮겼다.
  //
  // Firebase는 **안드로이드의 FCM 트리거**에만 필요하고 iOS의 VoIP/CallKit 경로와는
  // 무관한데, 여기서 await 하면 콜드스타트마다 그 시간만큼 `attach()`(수신 콜 처리)가
  // 밀린다. VoIP 푸시로 깨어난 앱은 사용자가 이미 전화를 받고 있는 상태라 그 지연이
  // 곧 "비버가 늦게 말하는" 시간이 된다. FCM 배선이 필요할 때 그 안에서 초기화한다.
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
      // Follows the OS light/dark setting. The dark pin is gone: Stage 3 removed
      // the last `AppColors` literals (the mapping was 855 → 0), and the Light
      // audit — a 9-screen on-device sweep — found no white-glyph-goes-black
      // breakage. There is no in-app theme toggle because the design has none;
      // if one is wanted later, add a stored setting and drive `themeMode` from
      // it. See `docs/2026-07-18_0053_컬러-전수조사.md`.
      theme: _theme(Brightness.light, AppColorTokens.light),
      darkTheme: _theme(Brightness.dark, AppColorTokens.dark),
      themeMode: ThemeMode.system,
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
      // Pin the platform so iOS renders the SAME Material design as Android —
      // page transitions, scroll physics(글로우), text selection, etc. Without
      // this, Material auto-adapts on iOS (Cupertino slide + bounce scroll) and
      // the app diverges from the Android design it was built against.
      platform: TargetPlatform.android,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.backgroundNormalDeep,
      fontFamily: kFontFamily,
      // 바텀시트는 전폭이다(정본 규격: 「전폭 유지. 하단 정렬. 내부만 콘텐츠
      // 컬럼으로 패딩」).
      //
      // Material 3 의 기본 `BottomSheetThemeData.constraints` 가 `maxWidth:
      // 640` 이라, 우리 코드에서 캡을 다 걷어냈는데도 태블릿에서 시트만 640으로
      // 좁아지고 좌우에 배경이 비쳤다(에뮬레이터 800dp 실측: 시트 폭 640.0).
      // 빈 제약으로 덮어 그 캡을 없앤다.
      bottomSheetTheme: const BottomSheetThemeData(
        constraints: BoxConstraints(),
      ),
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
