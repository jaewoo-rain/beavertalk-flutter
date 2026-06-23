import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import 'terms.dart';

/// Privacy-policy article screen.
///
/// Figma `screen/privacy_policy` (`2235:17392`). Same pattern as [TermsScreen]:
/// a [GnbType.main] header ("개인정보처리방침", back = pop) over a scrollable
/// [LegalBody] of dummy clause sections. Static content only — no backend.
class PrivacyScreen extends StatelessWidget {
  /// Creates the privacy-policy screen.
  const PrivacyScreen({super.key});

  /// Dummy clauses rendered as (heading, body) pairs.
  static const List<(String, String)> _clauses = [
    (
      '제1조 (개인정보의 수집 항목)',
      'BeaverTalk(이하 "회사")는 회원가입, 서비스 제공을 위해 다음의 개인정보를 수집합니다. '
          '필수항목: 이메일 주소, 비밀번호, 닉네임. 선택항목: 학습 목적, 모국어. 또한 서비스 '
          '이용 과정에서 음성 데이터 및 학습 기록이 생성·수집될 수 있습니다.',
    ),
    (
      '제2조 (개인정보의 수집 및 이용목적)',
      '회사는 회원제 서비스 이용에 따른 본인확인, 개인식별, 불량회원의 부정 이용방지와 비인가 '
          '사용 방지, 가입의사 확인, 불만처리 등 민원처리, 고지사항 전달을 위하여 개인정보를 '
          '이용합니다.',
    ),
    (
      '제3조 (개인정보의 보유 및 이용기간)',
      '회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 '
          '파기합니다. 다만 관련 법령에 의하여 보존할 필요가 있는 경우 회사는 법령에서 정한 '
          '기간 동안 회원정보를 보관합니다.',
    ),
    (
      '제4조 (개인정보의 제3자 제공)',
      '회사는 이용자의 개인정보를 본 방침에서 명시한 범위 내에서만 처리하며, 이용자의 사전 동의 '
          '없이는 본래의 범위를 초과하여 처리하거나 제3자에게 제공하지 않습니다.',
    ),
    (
      '제5조 (이용자의 권리)',
      '이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며, 회원 탈퇴를 '
          '통해 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.',
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
            title: '개인정보처리방침',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(child: LegalBody(clauses: _clauses)),
        ],
      ),
    );
  }
}
