import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 3 — reset complete.
///
/// Figma `screen/auth_findpw_complete` (`2117:19851`). A title + guidance text,
/// a celebratory key illustration (🔑 stand-in for the Figma 3D asset), and a
/// primary "로그인" button that routes to [Routes.login], clearing the recovery
/// flow from the back stack.
class PasswordCompleteScreen extends StatelessWidget {
  /// Creates the password-complete screen.
  const PasswordCompleteScreen({super.key});

  void _goLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '비밀번호 재설정 완료',
                    textAlign: TextAlign.center,
                    style: AppType.title2.b,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '새로운 비밀번호로 재설정 되었습니다.\n'
                    '신규 비밀번호를 입력하셔서 로그인을 진행하세요',
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 40),
                  // Celebratory illustration — emoji stand-in for the Figma
                  // 3D "location/key" asset (mock; no asset bundled).
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🔑', style: TextStyle(fontSize: 88)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: '로그인',
                      onPressed: () => _goLogin(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
