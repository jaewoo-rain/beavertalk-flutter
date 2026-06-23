import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'app/routes.dart';

void main() => runApp(const BeaverTalkApp());

/// App root. Starts at onboarding; the component gallery stays at `/gallery`.
class BeaverTalkApp extends StatelessWidget {
  const BeaverTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeaverTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: kFontFamily,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      initialRoute: Routes.onboarding,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
