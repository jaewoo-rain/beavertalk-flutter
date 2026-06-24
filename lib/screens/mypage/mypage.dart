import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/card_line.dart';
import '../../components/molecules/hero_avatar.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// My page — Figma `screen/main_mypage` (`2235:4456`). Profile header (avatar +
/// name + accent breakdown), then Settings / Payment / Support sections built
/// from [CardLine]s, then log-out / delete / version.
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
    final profile = ref.watch(myProfileProvider);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () => Navigator.pushNamed(context, Routes.share),
              icon: const Icon(Icons.ios_share, color: AppColors.text),
              tooltip: '공유',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // Profile.
                Center(
                  child: Column(
                    children: [
                      const HeroAvatar(imageProvider: beaverImage, size: 96),
                      const SizedBox(height: 12),
                      Text('Your Korean accent sounds',
                          style: AppType.body2.r
                              .copyWith(color: AppColors.textSecondary)),
                      Text('American',
                          style: AppType.title3.b
                              .copyWith(color: AppColors.text)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const ProgressBar(label: 'American', value: 87),
                const SizedBox(height: 12),
                const ProgressBar(label: 'Korean', value: 7),
                const SizedBox(height: 12),
                const ProgressBar(label: 'China', value: 6),
                const SizedBox(height: 28),

                _section('Settings'),
                // Account rows driven by the real member (GET /members/me).
                _profileRows(profile),
                CardLine(
                  type: CardLineType.defaultToggle,
                  label: 'Notification',
                  checked: _notification,
                  onChanged: (v) => setState(() => _notification = v),
                ),
                const SizedBox(height: 28),

                _section('Payment'),
                _navRow('Current Plan', 'Pro', route: Routes.subscription),
                _navRow('Payment History', '', route: Routes.subscription),
                const SizedBox(height: 28),

                _section('Support'),
                _navRow('Contact Us', ''),
                _navRow('Terms of service', '', route: Routes.terms),
                _navRow('Privacy policy', '', route: Routes.privacy),
                const SizedBox(height: 28),

                Center(
                  child: InkWell(
                    onTap: () => ref
                        .read(authControllerProvider.notifier)
                        .logout(),
                    child: Text('log out',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('delete account',
                      style: AppType.label1.r
                          .copyWith(color: AppColors.textTertiary)),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('BeaverTalk v1.0.0',
                      style: AppType.caption1.r
                          .copyWith(color: AppColors.textTertiary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Account rows (Email + User Language) sourced from `GET /members/me`.
  /// Renders loading / error / data states via [AsyncValue.when].
  Widget _profileRows(AsyncValue<Member> profile) => profile.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        error: (e, _) => InkWell(
          onTap: () => ref.invalidate(myProfileProvider),
          child: CardLine(
            type: CardLineType.defaultRow,
            label: '내 정보를 불러오지 못했어요',
            value: '다시 시도',
          ),
        ),
        data: (member) => Column(
          children: [
            _navRow('Email', member.email ?? '-'),
            _navRow('User Language', member.language ?? 'English (US)'),
            _navRow('Learning Language', '한국어'),
          ],
        ),
      );

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(title,
            style: AppType.label1.m.copyWith(color: AppColors.textSecondary)),
      );

  Widget _navRow(String label, String value, {String? route}) => InkWell(
        onTap: route == null
            ? null
            : () => Navigator.pushNamed(context, route),
        child: CardLine(
          type: CardLineType.defaultRow,
          label: label,
          value: value.isEmpty ? null : value,
        ),
      );
}
