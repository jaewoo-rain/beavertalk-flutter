import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/auth_gate.dart';
import 'app/navigation.dart';
import 'app/routes.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';

void main() => runApp(const ProviderScope(child: BeaverTalkApp()));

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
