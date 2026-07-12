import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Empty conversation records — Figma `screen/record_empty` (`2117:20502`).
class RecordEmptyScreen extends StatelessWidget {
  /// Creates the empty-records screen.
  const RecordEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // Centered empty-state copy + CTA (Figma `2296:26201`).
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.noCallRecords,
                    textAlign: TextAlign.center,
                    style:
                        AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.noCallRecordsBody,
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.startCall,
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.callLoading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
