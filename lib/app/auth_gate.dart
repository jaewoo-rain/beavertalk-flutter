import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/providers/auth_controller.dart';
import '../screens/home/home.dart';
import '../screens/onboarding/onboarding_language.dart';
import '../theme/app_colors.dart';

/// App entry point. Watches [authControllerProvider] and shows:
/// - [AuthStatus.unknown] → a loading splash while the token is read,
/// - [AuthStatus.authenticated] → the home screen,
/// - [AuthStatus.unauthenticated] → the onboarding/login flow.
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
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
        return const OnboardingLanguageScreen();
    }
  }
}

/// Minimal loading screen shown while the stored token is read.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
