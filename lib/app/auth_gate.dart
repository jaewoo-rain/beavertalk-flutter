import 'package:flutter/material.dart';
import '../theme/app_color_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/app_exception.dart';
import '../features/auth/domain/entities/member.dart';
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
  ///
  /// Deliberately NOT written with `AsyncValue.when`. `when` defaults to
  /// `skipLoadingOnRefresh: true`, which means that while a *refresh* is in
  /// flight it reports the PREVIOUS state — and a previous state can be the 401
  /// from the session we just signed out of. `_clearUserScopedState()`
  /// invalidates this provider on sign-out while the gate is still watching it,
  /// so a `GET /members/me` fires with the session already gone; the resulting
  /// `AsyncError(UnauthorizedFailure)` sticks around because this provider is
  /// not autoDispose. On the NEXT login `when` handed that stale error to the
  /// error branch below, which called `onSessionExpired()` — from `authenticated`
  /// state, so its guard didn't stop it — and signed the fresh session straight
  /// back out. Re-login was impossible until the app was killed.
  ///
  /// So: while loading (refresh included) we never draw a conclusion from the
  /// previous state. Previous *data* still renders (no splash flash when e.g.
  /// MyPage changes the language and invalidates this); a previous *error* is
  /// treated as "not known yet".
  Widget _authenticatedView() {
    final profile = ref.watch(myProfileProvider);

    if (profile.isLoading) {
      final previous = profile.valueOrNull;
      return previous != null ? _routeFor(previous) : const _Splash();
    }

    if (profile.hasError) {
      final error = profile.error!;
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
    }

    return _routeFor(profile.requireValue);
  }

  /// Onboarding starts at the native-language step (1/3); it then pushes
  /// name (2/3) → reason (3/3) → done.
  Widget _routeFor(Member member) => member.onboardingCompleted
      ? const HomeScreen()
      : const OnboardingLanguageScreen();
}

/// Mascot diameter on the splash, matching the native launch image (160dp).
const double _kSplashMascotSize = 160;

/// Clearance between the mascot's edge and the loading ring.
const double _kSplashRingGap = 10;

/// Loading-ring stroke width.
const double _kSplashRingStroke = 3;

/// Loading screen shown while the stored token / profile is read.
///
/// The mascot and background match the native launch screen exactly — same
/// colour, same 160 diameter — so the hand-off from the OS splash to the first
/// Flutter frame is invisible. Keep that pair in step with the
/// `flutter_native_splash` block in pubspec.yaml: `color` there must equal the
/// light `Background/Normal/Normal`, `color_dark` the dark one.
///
/// Both colours come from `context.c` rather than literals. They used to be
/// hard-coded to the dark palette because there was one splash design, but the
/// native launch screen now follows the system appearance, and a Flutter frame
/// that stayed dark would flash against a light launch screen at exactly the
/// hand-off this widget exists to hide.
///
/// The ring has to travel with the background, not just the mascot: dark's
/// `Primary/Normal` (#00FFB2) on light's #F1F1F5 is barely legible, and light's
/// (#007A55) all but vanishes on #181A20. Reading both from the same token set
/// keeps them paired.
///
/// What the native splash *cannot* do is move: on Android 11 and below the OS
/// paints a still bitmap, so a slow `members/me` reads as a frozen screen. The
/// ring only spins once Flutter is up, which is exactly the stretch where the
/// wait is ours and worth signalling.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.backgroundNormalNormal,
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
                color: context.c.primaryNormal,
              ),
              const Image(
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
