import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../features/legal/legal_urls.dart';
import '../../features/legal/legal_web_view.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// Terms-of-Use article screen.
///
/// Figma `screen/terms_of_service` (`2235:17306`) — a full-screen page:
/// [AppScaffold] with a [GnbType.main] header ("Terms of service", back = pop)
/// over the live document.
///
/// ★ 문안을 앱에 복제하지 않는다. 정본은 노션 「비버톡 > 법적 고지」 하나뿐이다.
///   예전에는 `legal_texts.dart` 사본을 렌더했는데, 웹만 갱신되고 앱은 구 문안
///   (구 주소·환불 조항 없음)을 계속 보여줬다.
///
/// ★★ **약관은 웹판과 앱판이 다르다.** 앱은 인앱결제·구독을 제공하므로 결제·
///    환불 조항이 있는 **앱판**을 띄워야 한다. `legal_urls.dart` 의
///    [kTermsOfUseUrl] 이 앱판을 가리킨다 — `beavertalk.im/terms` 로 바꾸면
///    결제 조항이 빠진 웹판으로 리다이렉트된다.
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
          const Expanded(child: LegalWebView(url: kTermsOfUseUrl)),
        ],
      ),
    );
  }
}
