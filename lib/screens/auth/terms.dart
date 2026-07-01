import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Terms-of-service article screen.
///
/// Figma `screen/terms_of_service` (`2235:17306`) — a **full-screen page**:
/// [AppScaffold] (status bar + home indicator) with a [GnbType.main] header
/// ("Terms of service", back = pop) over a scrollable [LegalBody] — a bold
/// section heading followed by dummy `(heading, body)` clause blocks. Static
/// content only; no backend.
class TermsScreen extends StatelessWidget {
  /// Creates the terms-of-service screen.
  const TermsScreen({super.key});

  /// Bold section heading above the clauses (Figma Headline 1).
  // TODO(i18n): localize
  static const String _sectionTitle = 'Service Agreement';

  // TODO(legal): placeholder copy — replace with reviewed, localized terms.
  /// Dummy clauses rendered as (heading, body) pairs.
  static const List<(String, String)> _clauses = [
    (
      'Article 1 (Purpose)',
      'These terms govern the rights, obligations, and responsibilities '
          'between BeaverTalk (the "Company") and users in connection with the '
          'conversation-learning service (the "Service") provided by the '
          'Company, along with other necessary matters.',
    ),
    (
      'Article 2 (Definitions)',
      'The terms used herein are defined as follows. A "User" is a member or '
          'non-member who uses the Service provided by the Company under these '
          'terms. A "Member" is a person who has registered by providing '
          'personal information to the Company and may continuously use the '
          "Service and receive the Company's information.",
    ),
    (
      'Article 3 (Effect and Amendment of Terms)',
      'The Company posts these terms on the initial service screen so users '
          'can easily review them. The Company may amend these terms within the '
          'limits of applicable law, and will announce the effective date and '
          'reason for any amendment in advance.',
    ),
    (
      'Article 4 (Provision and Changes to the Service)',
      'The Company provides members with services such as conversation '
          'learning, pronunciation analysis, and learning-record management. '
          'The Company may change the content and delivery date of the Service, '
          'and will announce such changes in advance.',
    ),
    (
      'Article 5 (Restrictions on Use)',
      'The Company may restrict or suspend all or part of the Service when '
          'normal provision is difficult due to natural disasters, emergencies, '
          'equipment failures, or a surge in usage.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            // TODO(i18n): localize
            title: 'Terms of service',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: LegalBody(sectionTitle: _sectionTitle, clauses: _clauses),
          ),
        ],
      ),
    );
  }
}

/// Scrollable legal-document body: a bold section heading over a column of
/// `(heading, body)` clause blocks.
///
/// Shared between [TermsScreen] and the privacy screen — both follow the Figma
/// `Body` layout: 20px side padding, 16px top; section heading in Headline 1
/// (18, white); each clause is a 15px heading (white) + 8px gap + 14px body
/// (secondary), with 16px between blocks. Adaptive: wraps and scrolls as the
/// localized copy grows.
class LegalBody extends StatelessWidget {
  /// Creates a legal body with a [sectionTitle] above the [clauses].
  const LegalBody({
    super.key,
    required this.sectionTitle,
    required this.clauses,
  });

  /// Bold section heading shown above the clauses.
  final String sectionTitle;

  /// `(heading, body)` pairs rendered top-to-bottom.
  final List<(String, String)> clauses;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Figma Body: 20px side padding, 16px top. Bottom padding lets long,
      // localized copy scroll clear of the home indicator.
      padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
          AppSpacing.s16, AppSpacing.s20, AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section heading — Figma Headline 1 / SemiBold 18, white.
          Text(
            sectionTitle,
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          // 16px before each block (incl. after the section heading); 8px
          // between a clause heading and its body.
          for (final (heading, body) in clauses) ...[
            const SizedBox(height: AppSpacing.s16),
            Text(
              heading,
              style: AppType.body2.r.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              body,
              style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
