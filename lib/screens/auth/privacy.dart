import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../features/legal/legal_urls.dart';
import '../../features/legal/legal_web_view.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// Privacy-Policy article screen.
///
/// Figma `screen/privacy_policy` (`2235:17392`) — a full-screen page, same
/// pattern as [TermsScreen]: [AppScaffold] with a [GnbType.main] header
/// ("Privacy policy", back = pop) over the live document at
/// beavertalk.im/policy.
///
/// ★ 문안을 앱에 복제하지 않는다. 정본은 `beavertalkweb` 저장소의
///   `app/src/content/legal/policy.ko.ts` 하나뿐이다.
class PrivacyScreen extends StatelessWidget {
  /// Creates the privacy-policy screen.
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.privacyTitle,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: LegalWebView(url: kPrivacyPolicyUrl)),
        ],
      ),
    );
  }
}
