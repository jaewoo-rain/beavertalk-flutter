import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Terms-of-service article screen.
///
/// Figma `screen/terms_of_service` (`2235:17306`). A [GnbType.main] header
/// ("Terms of Service", back = pop) over a scrollable body of dummy clause
/// sections. Static content only — no backend.
class TermsScreen extends StatelessWidget {
  /// Creates the terms-of-service screen.
  const TermsScreen({super.key});

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
            title: 'Terms of Service',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(child: LegalBody(clauses: _clauses)),
        ],
      ),
    );
  }
}

/// Scrollable legal-document body: a column of `(heading, body)` clause blocks.
///
/// Shared between [TermsScreen] and the privacy screen — both follow the Figma
/// `Body` layout (20px side padding, 16px between clauses, 8px heading→body).
class LegalBody extends StatelessWidget {
  /// Creates a legal body for the given [clauses].
  const LegalBody({super.key, required this.clauses});

  /// `(heading, body)` pairs rendered top-to-bottom.
  final List<(String, String)> clauses;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.spacing20,
          AppSpacing.spacing16, AppSpacing.spacing20, AppSpacing.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < clauses.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.spacing16),
            Text(clauses[i].$1, style: AppType.body2.r),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              clauses[i].$2,
              style:
                  AppType.label1.r.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
