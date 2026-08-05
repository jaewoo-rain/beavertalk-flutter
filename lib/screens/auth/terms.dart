import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../features/legal/legal_body.dart';
import '../../features/legal/legal_texts.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// Terms-of-Use article screen.
///
/// Figma `screen/terms_of_service` (`2235:17306`) — a full-screen page:
/// [AppScaffold] with a [GnbType.main] header ("Terms of service", back = pop)
/// over a scrollable [LegalBody] rendering the [termsMarkdown] document. Static
/// content only; edit the copy in `legal_texts.dart`.
class TermsScreen extends StatelessWidget {
  /// Creates the terms-of-service screen.
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.termsTitle,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: LegalBody(data: termsMarkdown)),
        ],
      ),
    );
  }
}
