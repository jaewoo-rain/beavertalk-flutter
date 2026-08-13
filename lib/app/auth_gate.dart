import 'package:flutter/material.dart';
import '../theme/app_color_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/app_exception.dart';
import '../features/auth/presentation/providers/auth_controller.dart';
import '../features/auth/presentation/providers/my_profile_provider.dart';
import '../l10n/app_localizations.dart';
import '../screens/auth/login.dart';
import '../screens/home/home.dart';
import '../screens/onboarding/onboarding_language.dart';

/// App entry point. Watches [authControllerProvider] and routes:
/// - [AuthStatus.unknown] → loading splash while the token is read,
/// - [AuthStatus.unauthenticated] → language picker first (until a language is
///   captured in the draft), then the login screen,
/// - [AuthStatus.authenticated] → reads `members/me`:
///   - loading → splash,
///   - `onboardingCompleted == true` → home,
///   - `onboardingCompleted == false` → onboarding (language 1/3 → name 2/3 →
///     reason 3/3 → done),
///   - error → the session-expiry path clears auth back to login.
///
/// Deep navigation still goes through `onGenerateRoute` via
/// `Navigator.pushNamed`, so the existing routes are untouched.
class AuthGate extends ConsumerStatefulWidget {
  /// Creates the auth gate.
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Kick off the token check once after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(authControllerProvider);
    switch (status) {
      case AuthStatus.unknown:
        return const _Splash();
      case AuthStatus.unauthenticated:
        // The login screen prompts for the language via a bottom sheet on first
        // entry (Figma `auth_login__sheet`) instead of a full-screen step.
        return const LoginScreen();
      case AuthStatus.authenticated:
        return _authenticatedView();
    }
  }

  /// Authenticated: gate on `members/me.onboardingCompleted`.
  Widget _authenticatedView() {
    final profile = ref.watch(myProfileProvider);
    return profile.when(
      loading: () => const _Splash(),
      error: (error, stack) {
        // Only a genuine auth failure should clear the session. A transient
        // NetworkFailure/ServerFailure (offline, backend 500) must NOT sign the
        // user out — otherwise reopening the app offline destroys a valid
        // session. For non-auth errors, show a retry instead of bouncing.
        if (error is UnauthorizedFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authControllerProvider.notifier).onSessionExpired();
          });
          return const _Splash();
        }
        return _ProfileError(onRetry: () => ref.invalidate(myProfileProvider));
      },
      // Onboarding starts at the native-language step (1/3); it then pushes
      // name (2/3) → reason (3/3) → done.
      data: (member) => member.onboardingCompleted
          ? const HomeScreen()
          : const OnboardingLanguageScreen(),
    );
  }
}

/// Splash background — Figma `Splash & logo` (160:58332). This is
/// `Background/Normal/Normal` from the **dark** palette; the splash is dark in
/// both themes (there is one splash design), so it is a literal here rather
/// than a `context.c` lookup. The Figma frame centres the wordmark; we show the
/// mascot instead so the launch screen reads like the launcher icon.
const Color _kSplashBackground = Color(0xFF181A20);

/// Mascot diameter on the splash, matching the native launch image (160dp).
const double _kSplashMascotSize = 160;

/// Clearance between the mascot's edge and the loading ring.
const double _kSplashRingGap = 10;

/// Loading-ring stroke width.
const double _kSplashRingStroke = 3;

/// Loading-ring colour — `Primary/Normal` from the **dark** palette, a literal
/// for the same reason as [_kSplashBackground]. The light palette's primary
/// (#007A55) would all but vanish against #181A20.
const Color _kSplashRing = Color(0xFF00FFB2);

/// Loading screen shown while the stored token / profile is read.
///
/// The mascot and background match the native launch screen exactly — same
/// colour, same 160 diameter — so the hand-off from the OS splash to the first
/// Flutter frame is invisible. Keep that pair in step with the
/// `flutter_native_splash` block in pubspec.yaml.
///
/// What the native splash *cannot* do is move: on Android 11 and below the OS
/// paints a still bitmap, so a slow `members/me` reads as a frozen screen. The
/// ring only spins once Flutter is up, which is exactly the stretch where the
/// wait is ours and worth signalling.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _kSplashBackground,
      body: Center(
        child: SizedBox.square(
          dimension: _kSplashMascotSize + _kSplashRingGap * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fills the square, so the ring sits _kSplashRingGap outside the
              // mascot on every side.
              CircularProgressIndicator(
                strokeWidth: _kSplashRingStroke,
                color: _kSplashRing,
              ),
              Image(
                image: AssetImage('assets/images/splash_mascot.png'),
                width: _kSplashMascotSize,
                height: _kSplashMascotSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when `members/me` fails for a NON-auth reason (offline / server error).
/// The session is left intact; the user can retry instead of being signed out.
class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.backgroundNormalDeep,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, color: context.c.labelNormal),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).connectionFailedTitle,
              style: TextStyle(color: context.c.labelStrong),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}
