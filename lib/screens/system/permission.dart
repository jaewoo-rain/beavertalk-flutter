import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/icons/app_icons.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Permission request — Figma `screen/perm_request` (`2117:20385`).
///
/// A header (title + guidance) over a list of permission rows (마이크 필수 /
/// 알림 선택), each a `surfaceElevated` card with a 56×56 `primary-10` icon
/// tile and a title + description column. A pinned full-width "권한 허용" primary
/// button routes to [Routes.home] in this mock.
class PermissionScreen extends StatelessWidget {
  /// Creates the permission request screen.
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      homeVariant: HomeIndicatorVariant.subTransparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s32, AppSpacing.s20, AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.permissionTitle, style: AppType.title3.b),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.permissionSubtitle,
                  style: AppType.label1.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // ── Permission rows ──
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s20, AppSpacing.s8, AppSpacing.s20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PermRow(
                      icon: AppIcons.mic,
                      title: l10n.permissionMicTitle,
                      description: l10n.permissionMicDesc,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _PermRow(
                      icon: AppIcons.volume,
                      title: l10n.permissionNotifTitle,
                      description: l10n.permissionNotifDesc,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s12, AppSpacing.s20, AppSpacing.s24),
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.getStarted,
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.home, (r) => r.isFirst),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single permission row (Figma `perm-row/*`): a 56×56 `primary-10` icon tile
/// (radius 28, primary icon) + a title (`Body 2 Medium`) over a description
/// (`Label 2 Regular`, secondary). Fill `surfaceElevated`, radius 16.
class _PermRow extends StatelessWidget {
  const _PermRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final AppIconBuilder icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary10,
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: icon(size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppType.body2.m),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  description,
                  style: AppType.label2.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
