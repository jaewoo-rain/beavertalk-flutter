import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
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

  @override
  Widget build(BuildContext context) {
    // Languages come from the real member (GET /members/me); show sensible
    // defaults until it loads.
    final member = ref.watch(myProfileProvider).valueOrNull;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () => Navigator.pushNamed(context, Routes.share),
              icon: AppIcons.share(color: AppColors.text),
              tooltip: '공유',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                _profileCard(),
                const SizedBox(height: 24),

                _section('Settings'),
                const SizedBox(height: 16),
                _group([
                  _navRow('User Language', member?.language ?? 'English(US)'),
                  _navRow('Learning Language', '한국어'),
                  CardLine(
                    type: CardLineType.defaultToggle,
                    label: 'Notification',
                    checked: _notification,
                    onChanged: (v) => setState(() => _notification = v),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: 24),

                _section('Payment'),
                const SizedBox(height: 16),
                _group([
                  _navRow('Current Plan', 'Pro', route: Routes.subscription),
                  _navRow('Payment History', '',
                      route: Routes.subscription, divider: false),
                ]),
                const SizedBox(height: 24),

                _section('Support'),
                const SizedBox(height: 16),
                _group([
                  _navRow('Contact Us', ''),
                  _navRow('Terms of service', '', route: Routes.terms),
                  _navRow('Privacy policy', '',
                      route: Routes.privacy, divider: false),
                ]),
                const SizedBox(height: 24),

                // log out — elevated button card.
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  onTap: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      'log out',
                      textAlign: TextAlign.center,
                      style: AppType.label1.r.copyWith(color: AppColors.text),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'delete account',
                    style:
                        AppType.body1.r.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
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
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.xs), // 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
                image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Korean accent sounds',
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'American',
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: 16),
          const ProgressBar(label: 'American', value: 87),
          const SizedBox(height: 16),
          const ProgressBar(label: 'Korean', value: 7, active: false),
          const SizedBox(height: 16),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm), // 12
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: rows),
      );

  /// A tappable label/value row with a trailing chevron.
  Widget _navRow(String label, String value,
          {String? route, bool divider = true}) =>
      InkWell(
        onTap:
            route == null ? null : () => Navigator.pushNamed(context, route),
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
            const SizedBox(width: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text('v1.0.0',
                style:
                    AppType.body1.r.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
}
