import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_scaffold.dart';

/// Temporary screen shown until the real screen is built.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('화면 준비 중',
                style: AppType.caption1.m.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 8),
            Text(name, style: AppType.title3.sb),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text('← 뒤로',
                  style: AppType.label1.r.copyWith(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
