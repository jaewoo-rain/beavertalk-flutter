import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// Microphone permission denied — Figma `screen/perm_mic_denied`
/// (`2117:20524`).
///
/// A dimmed permission screen with a centered [DialogBasic]
/// (`state=default` → [DialogBasicVariant.twoHorizontal]) explaining the denial.
/// The two secondary buttons are "닫기" (pops the dialog/screen) and
/// "설정으로 이동" (a mock — pops back; would deep-link to OS settings).
///
/// A muted-mic illustration (🔇 stand-in — mock) sits above the dialog as the
/// "빨강 X 일러스트" placeholder.
class MicDeniedScreen extends StatelessWidget {
  /// Creates the mic-denied screen.
  const MicDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Stack(
        children: [
          // Dim scrim over the (blank) underlying screen.
          const Dim(),
          // The permission dialog (Figma `2296:26216` — no illustration).
          Center(
            child: DialogBasic(
              title: l10n.micPermissionNeededTitle,
              description: l10n.micPermissionNeededBody,
              variant: DialogBasicVariant.twoHorizontal,
              primary: DialogAction(
                label: l10n.cancel,
                onPressed: () => Navigator.maybePop(context),
              ),
              secondary: DialogAction(
                label: l10n.openSettings,
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
