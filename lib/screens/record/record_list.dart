import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_box.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
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
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs (기록 active).
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: SegmentedTabs(
              labels: const ['기록', '보관'],
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Text('통화 기록',
            style: AppType.body1.sb.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        for (var i = 0; i < records.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.pushNamed(
              context,
              Routes.analysisLoading,
              arguments: records[i].callId,
            ),
            child: CardBox(
              type: CardBoxType.record,
              avatar: CircleAvatar(
                backgroundImage: _avatarFor(records[i].character.imageUrl),
              ),
              title: records[i].character.name,
              subtitle: _subtitleFor(records[i].summary),
              meta: [
                _formatDate(records[i].callDate),
                _formatDuration(records[i].totalTime),
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

  String _subtitleFor(String? summary) {
    if (summary != null && summary.trim().isNotEmpty) return summary;
    return '대화 기록';
  }

  /// `YYYY.MM.DD.` (e.g. `2026.01.01.`), or `-` when missing.
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y.$m.$d.';
  }

  /// `N분 N초` from a duration in seconds, or `-` when missing.
  String _formatDuration(int? totalSeconds) {
    if (totalSeconds == null) return '-';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes분 ${seconds.toString().padLeft(2, '0')}초';
  }
}

/// Empty state shown when there are no past calls (mirrors
/// [Routes.recordsEmpty] copy, kept inline so the tabs stay visible).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '아직 통화 기록이 없어요',
            textAlign: TextAlign.center,
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            'AI와 첫 통화를 마치면\n여기에 기록이 쌓여요.',
            textAlign: TextAlign.center,
            style:
                AppType.label1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: '통화하러 가기',
            onPressed: () =>
                Navigator.pushNamed(context, Routes.callLoading),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '기록을 불러오지 못했어요',
            textAlign: TextAlign.center,
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            '잠시 후 다시 시도해주세요.',
            textAlign: TextAlign.center,
            style:
                AppType.label1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: '다시 시도',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
