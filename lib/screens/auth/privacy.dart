import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
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
/// ("Privacy policy", back = pop) over the live document.
///
/// ★ 문안을 앱에 복제하지 않는다. 정본은 노션 「비버톡 > 법적 고지」 하나뿐이고
///   웹과 앱이 같은 페이지를 본다. 처리방침은 사업자 단위 문서라 웹·앱 공통이다.
///   URL 은 `legal_urls.dart` 에서만 관리한다.
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
          // 법률 문서는 700(정본 규격: 좌우 여백 55).
          const Expanded(
            child: ContentColumn.document(
              child: LegalWebView(url: kPrivacyPolicyUrl),
            ),
          ),
        ],
      ),
    );
  }
}
