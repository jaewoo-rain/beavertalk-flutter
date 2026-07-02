import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_args.dart';

/// Archived (보관) sentences — Figma `screen/record_archive` (`2117:20332`).
///
/// The 보관 tab lists every sentence the user bookmarked (즐겨찾기) in the 대화
/// 기록 detail. Unlike 기록 (which opens a whole call's analysis), tapping a
/// saved sentence jumps **straight into that one sentence's review** —
/// [Routes.learningIntro] with a single-sentence [LearningArgs]. The bookmark
/// glyph un-saves it.
class RecordArchiveScreen extends StatelessWidget {
  /// Creates the archive screen.
  const RecordArchiveScreen({super.key});

  void _review(BuildContext context, MockSentence sentence) {
    Navigator.pushNamed(
      context,
      Routes.learningIntro,
      arguments: LearningArgs(sentences: [sentence]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs (보관 active).
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s20, 14, AppSpacing.s20, 14),
            child: SegmentedTabs(
              labels: const ['기록', '보관'],
              activeIndex: 1,
              onChanged: (i) {
                if (i == 0) {
                  Navigator.pushReplacementNamed(context, Routes.records);
                }
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Set<int>>(
              valueListenable: bookmarkedSentenceIds,
              builder: (context, ids, _) {
                final saved = mockSentences
                    .where((s) => ids.contains(s.id))
                    .toList(growable: false);
                if (saved.isEmpty) return const _ArchiveEmpty();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20, AppSpacing.s4, AppSpacing.s20, AppSpacing.s24),
                  children: [
                    Text('저장한 문장',
                        style: AppType.body1.sb
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s12),
                    for (var i = 0; i < saved.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.s16),
                      CardBookmark(
                        korean: saved[i].korean,
                        native: saved[i].native,
                        bookmarked: true,
                        onBookmarkTap: () => toggleBookmark(saved[i].id),
                        onTap: () => _review(context, saved[i]),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when no sentence has been bookmarked yet.
class _ArchiveEmpty extends StatelessWidget {
  const _ArchiveEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s40),
        child: Text(
          '저장한 문장이 없어요.\n대화 기록에서 문장을 즐겨찾기 해보세요.',
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
