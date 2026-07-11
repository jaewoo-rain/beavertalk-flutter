import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/i18n/locale_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// My page — Figma `screen/main_mypage` (`2296:26071`). A profile card (avatar +
/// accent breakdown), then Settings / Payment / Support sections whose rows are
/// grouped in elevated cards, then a log-out button + delete / version footer.
class MyPageScreen extends ConsumerStatefulWidget {
  /// Creates the my-page screen.
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  bool _notification = true;

  /// User (UI) language id the user has picked locally, or null before any pick
  /// (then the member's saved language is shown). Only the **user** language is
  /// selectable — the learning language is fixed to Korean (the app teaches
  /// Korean), so the two rows are: User Language (editable) / Learning Language
  /// (fixed).
  String? _userLangId;

  /// Display name for a language id (falls back to the first entry).
  String _langName(String id) => mockLanguages
      .firstWhere((l) => l.id == id, orElse: () => mockLanguages.first)
      .name;

  /// Opens the language bottom sheet for the **user (UI) language**, seeded with
  /// [currentId]; on confirm stores the pick locally and persists it to the
  /// backend (`PATCH /members/me`). Staged until "확인" so cancelling keeps the
  /// old value; a failed save is surfaced via a snackbar (local pick stays).
  Future<void> _pickUserLanguage(String currentId) async {
    var staged = currentId;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) => BottomSheetCountrySelect(
          title: AppLocalizations.of(sheetCtx).selectYourLanguage,
          items: [
            for (final l in mockLanguages)
              CountryItem(code: l.id, name: l.name, countryCode: l.countryCode),
          ],
          value: staged,
          onChanged: (code) => setSheetState(() => staged = code),
          onConfirm: () => Navigator.of(sheetCtx).pop(staged),
          onClose: () => Navigator.of(sheetCtx).pop(),
        ),
      ),
    );
    if (picked == null || picked == currentId || !mounted) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _userLangId = picked);
    // Switch the app UI to the chosen language immediately (persisted); the
    // backend save follows.
    unawaited(ref.read(localeControllerProvider.notifier).setLanguage(picked));
    try {
      await ref.read(authControllerProvider.notifier).updateLanguage(picked);
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.languageSaveFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  /// Caption shared alongside the accent-card image (see [DialogShareProfile]).
  static const String _inviteText =
      "I'm learning Korean with Beavertalk — my Korean accent sounds "
      'American! 🦫 Come find your accent and learn with me: '
      'https://beavertalk.im';

  /// Confirms and performs account deletion. Shows a [DialogBasic] first; on
  /// confirm calls [AuthController.deleteAccount] (backend delete + sign-out).
  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialogBasic<bool>(
      context,
      title: 'Delete account?',
      description:
          'This permanently deletes your account and data and cannot be undone.',
      variant: DialogBasicVariant.twoHorizontal,
      primary:
          DialogAction(label: 'Cancel', onPressed: () => Navigator.of(context).pop(false)),
      secondary:
          DialogAction(label: 'Delete', onPressed: () => Navigator.of(context).pop(true)),
    );
    if (confirmed != true || !mounted) return;
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.accountDeleteFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Languages come from the real member (GET /members/me); show sensible
    // defaults until it loads.
    final member = ref.watch(myProfileProvider).valueOrNull;

    // Effective user (UI) language id: the local pick, else the member's saved
    // language when it maps to a known language, else English.
    final memberLang = member?.language;
    final userLangId = _userLangId ??
        (mockLanguages.any((l) => l.id == memberLang) ? memberLang! : 'en');

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () => showDialogShareProfile(
                context,
                imageProvider: beaverImage,
                caption: 'Your Korean accent sounds',
                title: 'American',
                stats: const [
                  ProfileStat(label: 'American', value: 87),
                  ProfileStat(label: 'Korean', value: 7, active: false),
                  ProfileStat(label: 'China', value: 6, active: false),
                ],
                // The dialog rasterizes the accent card and shares it as a PNG;
                // this text rides along as the caption.
                shareText: _inviteText,
                onShared: () {
                  if (mounted) Navigator.of(context).maybePop();
                },
              ),
              icon: AppIcons.share(color: AppColors.text),
              tooltip: 'Share',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20, AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              children: [
                _profileCard(),
                const SizedBox(height: AppSpacing.s24),

                _section('Settings'),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  // User (UI) language — editable.
                  _navRow(
                    'User Language',
                    _langName(userLangId),
                    onTap: () => _pickUserLanguage(userLangId),
                  ),
                  // Learning language — fixed to Korean (the app teaches Korean).
                  _navRow('Learning Language', 'Korean'),
                  CardLine(
                    type: CardLineType.defaultToggle,
                    label: 'Notification',
                    checked: _notification,
                    onChanged: (v) => setState(() => _notification = v),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: AppSpacing.s24),

                _section('Payment'),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  _navRow('Current Plan', 'Pro', route: Routes.subscription),
                  _navRow('Payment History', '',
                      route: Routes.subscription, divider: false),
                ]),
                const SizedBox(height: AppSpacing.s24),

                _section('Support'),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  _navRow('Contact Us', ''),
                  _navRow('Terms of service', '', route: Routes.terms),
                  _navRow('Privacy policy', '',
                      route: Routes.privacy, divider: false),
                ]),
                const SizedBox(height: AppSpacing.s24),

                // log out — design-system secondary-fill Button (60).
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: 'log out',
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(height: AppSpacing.s16),
                Center(
                  child: InkWell(
                    onTap: _confirmDeleteAccount,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
                      child: Text(
                        'delete account',
                        style: AppType.body1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                _version(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Profile card: 80px avatar, accent label, and three accent ProgressBars.
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s12, AppSpacing.s16, AppSpacing.s12, AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.xs), // 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSpacing.s80,
              height: AppSpacing.s80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
                image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Your Korean accent sounds',
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'American',
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'American', value: 87),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'Korean', value: 7, active: false),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'China', value: 6, active: false),
        ],
      ),
    );
  }

  /// Section header (Body 1 SemiBold, white).
  Widget _section(String title) => Text(
        title,
        style: AppType.body1.sb.copyWith(color: AppColors.text),
      );

  /// Wraps a section's rows in an elevated grouping card.
  Widget _group(List<Widget> rows) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm), // 12
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: rows),
      );

  /// A tappable label/value row with a trailing chevron.
  ///
  /// Provide either a named [route] (pushed on tap) or a custom [onTap]; [onTap]
  /// takes precedence. With neither, the row is inert.
  Widget _navRow(String label, String value,
          {String? route, VoidCallback? onTap, bool divider = true}) =>
      InkWell(
        onTap: onTap ??
            (route == null
                ? null
                : () => Navigator.pushNamed(context, route)),
        child: CardLine(
          type: CardLineType.defaultRow,
          label: label,
          value: value.isEmpty ? null : value,
          showDivider: divider,
        ),
      );

  /// "Beavertalk • v1.0.0" footer.
  Widget _version() => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Beavertalk',
                style:
                    AppType.body1.r.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: AppSpacing.s4),
            Container(
              width: AppSpacing.s4,
              height: AppSpacing.s4,
              decoration: const BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s4),
            Text('v1.0.0',
                style:
                    AppType.body1.r.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
}
