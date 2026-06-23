import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Terms-of-service article screen.
///
/// Figma `screen/terms_of_service` (`2235:17306`). A [GnbType.main] header
/// ("이용약관", back = pop) over a scrollable body of dummy clause sections.
/// Static content only — no backend.
class TermsScreen extends StatelessWidget {
  /// Creates the terms-of-service screen.
  const TermsScreen({super.key});

  /// Dummy clauses rendered as (heading, body) pairs.
  static const List<(String, String)> _clauses = [
    (
      '제1조 (목적)',
      '이 약관은 BeaverTalk(이하 "회사")가 제공하는 회화 학습 서비스(이하 "서비스")의 '
          '이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 '
          '규정함을 목적으로 합니다.',
    ),
    (
      '제2조 (정의)',
      '이 약관에서 사용하는 용어의 정의는 다음과 같습니다. "이용자"란 이 약관에 따라 회사가 '
          '제공하는 서비스를 받는 회원 및 비회원을 말합니다. "회원"이란 회사에 개인정보를 제공하여 '
          '회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며 서비스를 계속 이용할 수 있는 '
          '자를 말합니다.',
    ),
    (
      '제3조 (약관의 효력 및 변경)',
      '회사는 이 약관의 내용을 이용자가 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다. '
          '회사는 관련 법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있으며, 개정 시 적용일자 '
          '및 개정사유를 명시하여 사전에 공지합니다.',
    ),
    (
      '제4조 (서비스의 제공 및 변경)',
      '회사는 회원에게 회화 학습, 발음 분석, 학습 기록 관리 등의 서비스를 제공합니다. 회사는 '
          '서비스의 내용 및 제공일자를 변경할 수 있으며, 변경되는 서비스의 내용과 제공일자를 명시하여 '
          '사전에 공지합니다.',
    ),
    (
      '제5조 (서비스 이용의 제한)',
      '회사는 천재지변, 비상사태, 설비의 장애 또는 이용의 폭주 등으로 정상적인 서비스 제공이 '
          '어려운 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.',
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
            title: '이용약관',
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < clauses.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            Text(clauses[i].$1, style: AppType.body2.r),
            const SizedBox(height: 8),
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
