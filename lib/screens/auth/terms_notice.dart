import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// 로그인·이메일 가입 화면 하단 안내 — 가입 동의는 이 안내와 링크한 약관·처리방침으로 받는다
/// (별도 동의 화면 없음 · 10-19 사용자 지시 · 문구는 `loginTermsNotice*`).
///
/// Bottom consent notice with tappable, underlined "Terms of Service" and
/// "Privacy Policy" links (Figma `hit/terms` / `hit/privacy` over node
/// `2117:19693`). Stateful so the [TapGestureRecognizer]s are disposed.
class TermsNotice extends StatefulWidget {
  const TermsNotice({super.key, required this.onTerms, required this.onPrivacy});

  /// Tapped on the "Terms of Service" link.
  final VoidCallback onTerms;

  /// Tapped on the "Privacy Policy" link.
  final VoidCallback onPrivacy;

  @override
  State<TermsNotice> createState() => TermsNoticeState();
}

class TermsNoticeState extends State<TermsNotice> {
  late final TapGestureRecognizer _termsTap =
      TapGestureRecognizer()..onTap = () => widget.onTerms();
  late final TapGestureRecognizer _privacyTap =
      TapGestureRecognizer()..onTap = () => widget.onPrivacy();

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 12pt caption keeps the notice compact so it fits without scrolling; the
    // login body stays in a SingleChildScrollView for longer localized text.
    final base = AppType.caption1.r.copyWith(color: context.c.labelNormal);
    // Links read as links: brighter (white) + underlined, mirroring Figma's
    // underlined `서비스 약관` / `개인정보 보호정책` spans.
    final link = AppType.caption1.r.copyWith(
      color: context.c.labelStrong,
      decoration: TextDecoration.underline,
      decorationColor: context.c.labelStrong,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: l10n.loginTermsNoticePrefix),
          TextSpan(
            text: l10n.termsOfService,
            style: link,
            recognizer: _termsTap,
          ),
          TextSpan(text: l10n.loginTermsNoticeAnd),
          TextSpan(
            text: l10n.privacyPolicy,
            style: link,
            recognizer: _privacyTap,
          ),
          TextSpan(text: l10n.loginTermsNoticeSuffix),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}

