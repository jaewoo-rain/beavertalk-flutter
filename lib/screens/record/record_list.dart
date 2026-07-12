import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/card_box.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/domain/entities/bookmark_sentence.dart';
import '../../features/bookmark/presentation/providers/bookmark_providers.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_args.dart';

/// Records screen with two in-page tabs — Figma `screen/record_list`
/// (`2117:20307`) and `screen/record_archive` (`2117:20332`).
///
/// A single page that owns the selected-tab state and swaps only the body
/// between the **기록**(call history) and **보관**(bookmarked sentences) tabs via
/// an [IndexedStack] — the two tabs were previously separate routes/screens that
/// replaced each other on tap, which reset scroll and re-fetched on every switch.
/// Both bodies stay alive here, so switching is instant and state is preserved.
class RecordListScreen extends ConsumerStatefulWidget {
  /// Creates the records screen, optionally starting on the 보관 tab.
  const RecordListScreen({super.key, this.initialTab = 0});

  /// Tab to show first: 0 = 기록(records), 1 = 보관(archive).
  final int initialTab;

  @override
  ConsumerState<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends ConsumerState<RecordListScreen> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs — pure in-page state, no navigation.
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 14, AppSpacing.s20, 14),
            child: SegmentedTabs(
              labels: [l10n.tabRecords, l10n.tabArchive],
              activeIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [
                _RecordsBody(),
                _ArchiveBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 기록 (call history) tab
// ─────────────────────────────────────────────────────────────────────────────

/// Body of the 기록 tab: past calls from `GET /calls` ([callListProvider]) as
/// [CardBox]es; tapping one routes to [Routes.analysisLoading] with its
/// `callId`, which polls status and opens the analysis result.
class _RecordsBody extends ConsumerWidget {
  const _RecordsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(callListProvider);
    return calls.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, _) => _RecordsError(
        onRetry: () => ref.invalidate(callListProvider),
      ),
      data: (records) => records.isEmpty
          ? const _RecordsEmpty()
          : _RecordList(records: records),
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
class _RecordsEmpty extends StatelessWidget {
  const _RecordsEmpty();

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
class _RecordsError extends StatelessWidget {
  const _RecordsError({required this.onRetry});

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

// ─────────────────────────────────────────────────────────────────────────────
// 보관 (archive) tab
// ─────────────────────────────────────────────────────────────────────────────

/// Body of the 보관 tab: every sentence the user bookmarked, backed by the
/// server ([bookmarkListProvider] → `GET /members/me/bookmarks`). Tapping a
/// saved sentence jumps **straight into that one sentence's review**
/// ([Routes.learningIntro] with a single-sentence [LearningArgs]); the speaker
/// plays its standard-pronunciation TTS; the bookmark glyph un-saves it
/// ([bookmarkToggleControllerProvider]), which refreshes the list.
class _ArchiveBody extends ConsumerStatefulWidget {
  const _ArchiveBody();

  @override
  ConsumerState<_ArchiveBody> createState() => _ArchiveBodyState();
}

class _ArchiveBodyState extends ConsumerState<_ArchiveBody> {
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Shows [message] as a snackbar.
  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Runs a mutation, surfacing any failure ([AppException]) as a snackbar.
  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    try {
      await action();
    } catch (e) {
      _snack(e is AppException ? e.message : l10n.somethingWentWrong);
    }
  }

  /// Un-saves a bookmarked sentence. The archive only lists bookmarked ones, so
  /// the tap always clears it (`is_bookmarked: false`); on success the controller
  /// invalidates the list and the row disappears.
  Future<void> _toggleOff(int sentenceId) => _run(() async {
        await ref
            .read(bookmarkToggleControllerProvider.notifier)
            .toggleBookmark(sentenceId, false);
        // Keep the shared in-memory store in sync so analysis/learning don't keep
        // showing this sentence as bookmarked after it's un-saved here.
        setBookmark(sentenceId, false);
      });

  /// Plays the sentence's standard-pronunciation audio: uses the existing
  /// [BookmarkSentence.voiceUrl] when present, otherwise fetches it on demand
  /// via `POST /sentences/{id}/tts` (idempotent server-side), then plays through
  /// the shared [ReviewAudioPlayer].
  Future<void> _speak(BookmarkSentence sentence) async {
    try {
      var url = sentence.voiceUrl;
      if (url == null || url.isEmpty) {
        url = await ref
            .read(reviewRepositoryProvider)
            .sentenceTtsUrl(sentence.sentenceId);
      }
      if (!mounted) return;
      if (url == null || !url.startsWith('http')) {
        _snack(AppLocalizations.of(context).standardAudioNotReady);
        return;
      }
      await _player.playUrl(url);
    } catch (_) {
      if (mounted) {
        _snack(AppLocalizations.of(context).pronunciationPlayError);
      }
    }
  }

  /// Opens the single-sentence review for [sentence]. The learning flow is typed
  /// on [MockSentence], so adapt the bookmarked sentence to it (text + id + audio
  /// only — review scores come from the API, not these placeholders), mirroring
  /// how the analysis screen bridges real data into the learning flow.
  void _review(BookmarkSentence sentence) {
    final bridged = MockSentence(
      id: sentence.sentenceId,
      korean: sentence.korean,
      native: sentence.native,
      charScores: const [],
      overall: 0,
      pronunciation: 0,
      fluency: 0,
      rhythm: 0,
      voiceUrl: sentence.voiceUrl,
      // Carry the saved state so the learning screen seeds its bookmark toggle as
      // ON. Archive rows are always bookmarked; without this the review screen
      // showed the sentence as un-bookmarked.
      bookmarked: sentence.isBookmarked,
    );
    Navigator.pushNamed(
      context,
      Routes.learningIntro,
      arguments: LearningArgs(sentences: [bridged]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ref.watch(bookmarkListProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => _ArchiveError(
            message:
                e is AppException ? e.message : l10n.savedExpressionsLoadError,
            onRetry: () => ref.invalidate(bookmarkListProvider),
          ),
          data: (saved) =>
              saved.isEmpty ? const _ArchiveEmpty() : _list(saved),
        );
  }

  /// The populated list of bookmarked sentences.
  Widget _list(List<BookmarkSentence> saved) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20, AppSpacing.s4, AppSpacing.s20, AppSpacing.s24),
      children: [
        Text(AppLocalizations.of(context).mySavedExpressions,
            style: AppType.body1.sb.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s8),
        for (var i = 0; i < saved.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s12),
          CardBookmark(
            korean: saved[i].korean,
            native: saved[i].native,
            bookmarked: saved[i].isBookmarked,
            onBookmarkTap: () => _toggleOff(saved[i].sentenceId),
            onSpeakerTap: () => _speak(saved[i]),
            onTap: () => _review(saved[i]),
          ),
        ],
      ],
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
          AppLocalizations.of(context).noSavedSentences,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// Inline error with a retry action (mirrors the alarm-list error state).
class _ArchiveError extends StatelessWidget {
  const _ArchiveError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context).retry)),
          ],
        ),
      ),
    );
  }
}
