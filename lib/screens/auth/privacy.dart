import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import 'terms.dart';

/// Privacy-policy article screen.
///
/// Figma `screen/privacy_policy` (`2235:17392`). Same pattern as [TermsScreen]:
/// a [GnbType.main] header ("Privacy Policy", back = pop) over a scrollable
/// [LegalBody] of dummy clause sections. Static content only — no backend.
class PrivacyScreen extends StatelessWidget {
  /// Creates the privacy-policy screen.
  const PrivacyScreen({super.key});

  // TODO(legal): placeholder copy — replace with reviewed, localized policy.
  /// Dummy clauses rendered as (heading, body) pairs.
  static const List<(String, String)> _clauses = [
    (
      'Article 1 (Personal Data We Collect)',
      'BeaverTalk (the "Company") collects the following personal data to '
          'provide sign-up and the Service. Required: email address, password, '
          'nickname. Optional: learning goals, native language. Voice data and '
          'learning records may also be generated and collected while you use '
          'the Service.',
    ),
    (
      'Article 2 (Purpose of Collection and Use)',
      'The Company uses personal data for identity verification, personal '
          'identification, preventing fraudulent or unauthorized use by abusive '
          'members, confirming intent to sign up, handling complaints and '
          'inquiries, and delivering notices.',
    ),
    (
      'Article 3 (Retention and Use Period)',
      'In principle, the Company destroys personal data without delay once the '
          'purpose of collection and use has been achieved. However, where '
          'retention is required by applicable law, the Company keeps member '
          'information for the period prescribed by law.',
    ),
    (
      'Article 4 (Provision to Third Parties)',
      "The Company processes users' personal data only within the scope stated "
          'in this policy and does not process beyond the original scope or '
          "provide it to third parties without the user's prior consent.",
    ),
    (
      'Article 5 (User Rights)',
      'Users may view or correct their registered personal data at any time, '
          'and may withdraw consent to the collection and use of personal data '
          'by deleting their account.',
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
            title: 'Privacy Policy',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: LegalBody(clauses: _clauses)),
        ],
      ),
    );
  }
}
