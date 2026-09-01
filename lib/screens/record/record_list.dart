import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/card_box.dart';
import '../../components/molecules/card_box_loading.dart';
import '../../components/molecules/card_loading.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/domain/entities/bookmark_sentence.dart';
import '../../features/bookmark/presentation/providers/bookmark_providers.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_args.dart';
import '../system/network_error.dart';

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
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs — pure in-page state, no navigation.
          ContentColumn(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: SegmentedTabs(
              labels: [l10n.tabRecords, l10n.tabArchive],
              activeIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [_RecordsBody(), _ArchiveBody()],
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
      loading: () => const _RecordsLoading(),
      // Stays inside the tab body: the tab bar above keeps working, so a failed
      // 기록 fetch does not also cost the user access to 보관함.
      // Server reason only when the server actually wrote one; otherwise the
      // view falls back to its own localized copy. AppException's built-in
      // fallbacks are hardcoded Korean (see AppException.fromServer).
      error: (e, _) => NetworkErrorView(
        message: e is AppException && e.fromServer ? e.message : null,
        onRetry: () => ref.invalidate(callListProvider),
      ),
      data: (state) => state.items.isEmpty
          ? _recordsEmpty(context)
          : _RecordList(
              state: state,
              onLoadMore: () => ref.read(callListProvider.notifier).loadMore(),
            ),
    );
  }
}

/// 기록 tab while `GET /calls` is in flight — Figma `screen/record_list_loading`
/// (`3489:3921`).
///
/// Deliberately mirrors [_RecordList]: same padding, same 통화 기록 label (it is
/// static, so it renders for real), then five [CardBoxLoading] rows at the same
/// 88 height and 12 gap as the [CardBox]es that replace them. Five is the
/// design's count — it fills the viewport without implying how many calls the
/// user actually has.
class _RecordsLoading extends StatelessWidget {
  const _RecordsLoading();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SkeletonShimmer(
      child: ContentColumn(
        child: ListView(
          padding: const EdgeInsets.only(
            top: AppSpacing.s4,
            bottom: AppSpacing.s24,
          ),
          children: [
            Text(
              l10n.callHistory,
              style: AppType.body1.sb.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: 8),
            const AdaptiveTiles(
              stackedGap: AppSpacing.s12,
              children: [
                CardBoxLoading(),
                CardBoxLoading(),
                CardBoxLoading(),
                CardBoxLoading(),
                CardBoxLoading(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The populated list of past calls. Grows via infinite scroll: nearing the
/// bottom triggers [onLoadMore], which appends the next page (guarded in the
/// notifier), with a spinner while a page is in flight.
class _RecordList extends StatelessWidget {
  const _RecordList({required this.state, required this.onLoadMore});

  final CallListState state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = state.items;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        // Prefetch before the very bottom so the next page is ready in time.
        if (state.hasMore &&
            !state.isLoadingMore &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 320) {
          onLoadMore();
        }
        return false;
      },
      child: ContentColumn(
        child: ListView(
          padding: const EdgeInsets.only(
            top: AppSpacing.s4,
            bottom: AppSpacing.s24,
          ),
          children: [
            Text(
              l10n.callHistory,
              style: AppType.body1.sb.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: 8),
            AdaptiveTiles(
              stackedGap: AppSpacing.s12,
              children: [
                for (final record in records)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.analysisLoading,
                      arguments: record.callId,
                    ),
                    child: CardBox(
                      type: CardBoxType.record,
                      // Blur-in while the remote character avatar loads
                      // (CardBox clips this to a 64px circle).
                      avatar: BlurUpImage(
                        image: _avatarFor(record.character.imageUrl),
                      ),
                      title: record.character.name,
                      subtitle: _subtitleFor(l10n, record.summary),
                      meta: [
                        _formatDate(record.callDate),
                        _formatDuration(l10n, record.totalTime),
                      ],
                    ),
                  ),
              ],
            ),
            if (state.isLoadingMore) ...[
              const SizedBox(height: AppSpacing.s16),
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          ],
        ),
      ),
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
Widget _recordsEmpty(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return EmptyScreen(
    title: l10n.noCallRecords,
    body: l10n.noCallRecordsBody,
    ctaText: l10n.startCall,
    onCta: () => Navigator.pushNamed(context, Routes.callLoading),
  );
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      // voice_url 은 비공개 버킷 '키'로 올 수 있다(비-http). 그때도 /tts 로 재요청해
      // 재생 가능한 signed URL 을 받는다(연습 화면 learning_intro 와 동일 처리).
      if (url == null || !url.startsWith('http')) {
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
      // One sentence, practiced on its own → the sentence result
      // (`learning_main__word`). Same as the default, but stated: this is the
      // half of the pair that decides the ending, and it should not be silent
      // about it.
      arguments: LearningArgs(
        sentences: [bridged],
        origin: LearningOrigin.sentence,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(bookmarkListProvider)
        .when(
          loading: () => const _ArchiveLoading(),
          error: (e, _) => NetworkErrorView(
            message: e is AppException && e.fromServer ? e.message : null,
            onRetry: () => ref.invalidate(bookmarkListProvider),
          ),
          data: (saved) => saved.isEmpty
              ? EmptyScreen(body: l10n.noSavedSentences)
              : _list(saved),
        );
  }

  /// The populated list of bookmarked sentences.
  Widget _list(List<BookmarkSentence> saved) {
    return ContentColumn(
      child: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.s4,
          bottom: AppSpacing.s24,
        ),
        children: [
          Text(
            AppLocalizations.of(context).mySavedExpressions,
            style: AppType.body1.sb.copyWith(color: context.c.labelNormal),
          ),
          const SizedBox(height: AppSpacing.s8),
          AdaptiveTiles(
            stackedGap: AppSpacing.s12,
            children: [
              for (final item in saved)
                CardBookmark(
                  korean: item.korean,
                  native: item.native,
                  bookmarked: item.isBookmarked,
                  onBookmarkTap: () => _toggleOff(item.sentenceId),
                  onSpeakerTap: () => _speak(item),
                  // The frame's archive cards carry the same 연습하기 button as
                  // the analysis ones (`I3360:115;176:15497`); this tab was
                  // dropping it, which cost the archive its only visible way
                  // into practice (the whole-card tap does the same thing, but
                  // nothing said so) and left the card 12px shorter than
                  // [CardLoading] reserves for it.
                  actionText: AppLocalizations.of(context).practice,
                  onAction: () => _review(item),
                  onTap: () => _review(item),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 보관함 tab while `GET /members/me/bookmarks` is in flight — Figma
/// `screen/record_archive_loading` (`3489:4197`).
///
/// Mirrors `_ArchiveBodyState._list`: same padding, the static 나의 저장 표현
/// label for real, then three [CardLoading]s — which Figma builds to
/// [CardBookmark]'s exact 136 height so the swap costs no reflow.
class _ArchiveLoading extends StatelessWidget {
  const _ArchiveLoading();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
    child: ContentColumn(
      child: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.s4,
          bottom: AppSpacing.s24,
        ),
        children: [
          Text(
            AppLocalizations.of(context).mySavedExpressions,
            style: AppType.body1.sb.copyWith(color: context.c.labelNormal),
          ),
          const SizedBox(height: AppSpacing.s8),
          const AdaptiveTiles(
            stackedGap: AppSpacing.s12,
            children: [CardLoading(), CardLoading(), CardLoading()],
          ),
        ],
      ),
    ),
  );
}
