import 'package:flutter/material.dart';
import '../theme/app_color_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/app_exception.dart';
import '../features/auth/presentation/providers/auth_controller.dart';
import '../features/auth/presentation/providers/my_profile_provider.dart';
import '../screens/auth/login.dart';
import '../screens/home/home.dart';
import '../screens/onboarding/onboarding_language.dart';
import '../theme/app_colors.dart';

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

/// Minimal loading screen shown while the stored token / profile is read.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.backgroundNormalDeep,
      body: Center(
        child: CircularProgressIndicator(color: context.c.primaryNormal),
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
            const Text(
              '연결에 문제가 있어요',
              style: TextStyle(color: AppColors.text),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
