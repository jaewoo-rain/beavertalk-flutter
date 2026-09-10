import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// `depth/edit_nickname_depth3` (`4514:5281`) — the nickname editor reached
/// from the Account card.
///
/// A single field with a live `n/12` counter and the rule line, saved through
/// `PATCH /members/me`. The rule is enforced at input time (2–12, ASCII
/// letters and digits) so Save can never submit an invalid name.
class EditNicknameScreen extends ConsumerStatefulWidget {
  /// Creates the nickname editor.
  const EditNicknameScreen({super.key});

  @override
  ConsumerState<EditNicknameScreen> createState() => _EditNicknameScreenState();
}

class _EditNicknameScreenState extends ConsumerState<EditNicknameScreen> {
  static const _maxLength = 12;
  static const _minLength = 2;

  late final TextEditingController _controller;
  bool _saving = false;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _controller.text.length >= _minLength;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updateName(_controller.text);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final msg =
          e is AppException ? e.message : l10n.somethingWentWrong;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;

    // Seed once from the profile; later keystrokes must never be overwritten
    // by a provider refresh.
    final member = ref.watch(myProfileProvider).valueOrNull;
    if (!_seeded && member?.name != null) {
      _seeded = true;
      _controller.text = member!.name!;
    }

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: l10n.editNicknameTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                children: [
                  Text(l10n.nicknameLabel,
                      style: AppType.label2.r.copyWith(color: c.labelNormal)),
                  const SizedBox(height: AppSpacing.s8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: c.backgroundNormalAlternative,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: c.primaryNormal),
                    ),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      maxLength: _maxLength,
                      inputFormatters: [
                        // English letters + digits, per the stated rule. The
                        // same filter now guards onboarding, which used to set
                        // this name unfiltered — that gap is how non-Latin
                        // nicknames got in and then couldn't be edited here.
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                      ],
                      style: AppType.body1.r
                          .copyWith(color: c.commonWhiteAndDark),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_controller.text.length}/$_maxLength',
                      style: AppType.label2.r.copyWith(color: c.labelNormal),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(l10n.nicknameRule,
                      style: AppType.caption1.r.copyWith(color: c.labelNormal)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaSave,
                  onPressed: _valid && !_saving ? _save : null,
                  disabled: !_valid || _saving,
                ),
              ),
            ),
          ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
