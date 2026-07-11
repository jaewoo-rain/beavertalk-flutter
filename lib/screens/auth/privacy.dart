import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../features/legal/legal_body.dart';
import '../../features/legal/legal_texts.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

/// Privacy-Policy article screen.
///
/// Figma `screen/privacy_policy` (`2235:17392`) — a full-screen page, same
/// pattern as [TermsScreen]: [AppScaffold] with a [GnbType.main] header
/// ("Privacy policy", back = pop) over a scrollable [LegalBody] rendering the
/// [privacyMarkdown] document. Static content only; edit the copy in
/// `legal_texts.dart`.
class PrivacyScreen extends StatelessWidget {
  /// Creates the privacy-policy screen.
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.privacyTitle,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: LegalBody(data: privacyMarkdown)),
        ],
      ),
    );
  }
}
