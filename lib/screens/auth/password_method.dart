import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 1 — choose where the reset code is sent.
///
/// Figma `screen/auth_findpw_method` (`2117:19818`). A [GnbType.main] header
/// ("비밀번호 찾기"), a guidance line, an email entry field, and a primary
/// "이메일 전송" button that advances to [Routes.passwordCode].
///
/// Mock only: no real mail is sent — the button just navigates.
class PasswordMethodScreen extends StatefulWidget {
  /// Creates the password-method screen.
  const PasswordMethodScreen({super.key});

  @override
  State<PasswordMethodScreen> createState() => _PasswordMethodScreenState();
}

class _PasswordMethodScreenState extends State<PasswordMethodScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _send() => Navigator.of(context).pushNamed(Routes.passwordCode);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: '비밀번호 찾기',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '암호를 재설정하는 데 필요한 코드번호를\n'
                    '받으실 이메일 주소를 입력해 주세요',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  InputField(
                    controller: _email,
                    hintText: '이메일 주소',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon: const Icon(Icons.mail_outline),
                    onSubmitted: (_) => _send(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: '이메일 전송',
                      onPressed: _send,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
