import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_box.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Conversation records — Figma `screen/record_list` (`2117:20307`).
///
/// Layout (top → bottom): a back-only GNB, a [SegmentedTabs] row (기록 / 보관)
/// where 보관 jumps to [Routes.recordsArchive], a "통화 기록" section label, then
/// the past calls from `GET /calls` ([callListProvider]) as [CardBox]es; tapping
/// one routes to [Routes.analysisLoading] with its `callId`, which polls status
/// and opens the analysis result.
class RecordListScreen extends ConsumerWidget {
  /// Creates the record list screen.
  const RecordListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(callListProvider);
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs (기록 active).
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20, 14, AppSpacing.s20, 14),
            child: SegmentedTabs(
              labels: [l10n.tabRecords, l10n.tabArchive],
              activeIndex: 0,
              onChanged: (i) {
                if (i == 1) {
                  Navigator.pushReplacementNamed(
                      context, Routes.recordsArchive);
                }
              },
            ),
          ),
          Expanded(
            child: calls.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (_, _) => _ErrorState(
                onRetry: () => ref.invalidate(callListProvider),
              ),
              data: (records) => records.isEmpty
                  ? const _EmptyState()
                  : _RecordList(records: records),
            ),
          ),
        ],
      ),
    );
  }
}

/// The populated list of past calls.
class _RecordList extends StatelessWidget {
  const _RecordList({required this.records});

  final List<CallSummary> records;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20, AppSpacing.s4, AppSpacing.s20, AppSpacing.s24),
      children: [
        Text(l10n.callHistory,
            style: AppType.body1.sb.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        for (var i = 0; i < records.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s12),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.pushNamed(
              context,
              Routes.analysisLoading,
              arguments: records[i].callId,
            ),
            child: CardBox(
              type: CardBoxType.record,
              // Blur-in while the remote character avatar loads (CardBox clips
              // this to a 64px circle).
              avatar: BlurUpImage(image: _avatarFor(records[i].character.imageUrl)),
              title: records[i].character.name,
              subtitle: _subtitleFor(l10n, records[i].summary),
              meta: [
                _formatDate(records[i].callDate),
                _formatDuration(l10n, records[i].totalTime),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// The character avatar, or the static beaver asset when there's no URL.
  ImageProvider _avatarFor(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    }
    return beaverImage;
  }

  String _subtitleFor(AppLocalizations l10n, String? summary) {
    if (summary != null && summary.trim().isNotEmpty) return summary;
    return l10n.conversationRecord;
  }

  /// `YYYY.MM.DD.` (e.g. `2026.01.01.`), or `-` when missing.
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y.$m.$d.';
  }

  /// `N min NN sec` from a duration in seconds, or `-` when missing.
  String _formatDuration(AppLocalizations l10n, int? totalSeconds) {
    if (totalSeconds == null) return '-';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return l10n.durationMinSec(minutes, seconds);
  }
}

/// Empty state shown when there are no past calls (mirrors
/// [Routes.recordsEmpty] copy, kept inline so the tabs stay visible).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.noCallRecords,
                    textAlign: TextAlign.center,
                    style: AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.noCallRecordsBody,
                    textAlign: TextAlign.center,
                    style:
                        AppType.label1.r.copyWith(color: AppColors.textSecondary),
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
        ),
      ),
    );
  }
}

/// Inline error state with a retry that re-runs [callListProvider].
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.recordsLoadError,
                    textAlign: TextAlign.center,
                    style: AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.tryAgainLater,
                    textAlign: TextAlign.center,
                    style:
                        AppType.label1.r.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.retry,
                    onPressed: onRetry,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
