import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 3 — reset complete.
///
/// Figma `screen/auth_findpw_complete` (`2117:19851`). A title + guidance text,
/// the celebratory 3D key illustration (`assets/icons/3d/key.png`, the Figma
/// `3D/location` asset at node `2117:19858`), and a
/// primary "Log in" button that returns to the AuthGate root (which shows the
/// login flow while unauthenticated), so a successful re-login can redirect to
/// Home.
class PasswordCompleteScreen extends StatelessWidget {
  /// Creates the password-complete screen.
  const PasswordCompleteScreen({super.key});

  void _goLogin(BuildContext context) {
    // Return to the AuthGate root (shows the login flow while unauthenticated)
    // instead of removing it. Removing the root would leave a re-login unable to
    // redirect to Home, since AuthGate is what swaps to Home on authentication.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            // 안내 문구는 480으로 묶는다 — 태블릿에서 한 줄이 화면을
            // 가로지르면 눈이 다음 줄 첫 글자를 못 찾는다.
            child: ContentColumn.narrow(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.passwordCompleteTitle,
                    textAlign: TextAlign.center,
                    style: AppType.title2.b,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    l10n.passwordCompleteBody,
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                  const SizedBox(height: AppSpacing.s48),
                  // Figma `3D/location` key illustration (180×180), shown
                  // directly on the surface — no card, per node 2117:19858.
                  Image.asset(
                    'assets/icons/3d/key.png',
                    width: 180,
                    height: 180,
                  ),
                ],
              ),
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: 0, bottom: AppSpacing.s24),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.loginLogIn,
                onPressed: () => _goLogin(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
