import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/domain/entities/bookmark_sentence.dart';
import '../../features/bookmark/presentation/providers/bookmark_providers.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_args.dart';

/// Archived (보관) sentences — Figma `screen/record_archive` (`2117:20332`).
///
/// The 보관 tab lists every sentence the user bookmarked, backed by the server
/// ([bookmarkListProvider] → `GET /members/me/bookmarks`). Tapping a saved
/// sentence jumps **straight into that one sentence's review**
/// ([Routes.learningIntro] with a single-sentence [LearningArgs]); the speaker
/// plays its standard-pronunciation TTS; the bookmark glyph un-saves it
/// ([bookmarkToggleControllerProvider]), which refreshes the list.
class RecordArchiveScreen extends ConsumerStatefulWidget {
  /// Creates the archive screen.
  const RecordArchiveScreen({super.key});

  @override
  ConsumerState<RecordArchiveScreen> createState() =>
      _RecordArchiveScreenState();
}

class _RecordArchiveScreenState extends ConsumerState<RecordArchiveScreen> {
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
    try {
      await action();
    } catch (e) {
      _snack(e is AppException ? e.message : 'Something went wrong.');
    }
  }

  /// Un-saves a bookmarked sentence. The archive only lists bookmarked ones, so
  /// the tap always clears it (`is_bookmarked: false`); on success the controller
  /// invalidates the list and the row disappears.
  Future<void> _toggleOff(int sentenceId) => _run(() => ref
      .read(bookmarkToggleControllerProvider.notifier)
      .toggleBookmark(sentenceId, false));

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
        _snack("Standard pronunciation audio isn't ready yet.");
        return;
      }
      await _player.playUrl(url);
    } catch (_) {
      if (mounted) _snack("Couldn't play the pronunciation audio.");
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
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // Records / Archive tabs (Archive active).
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 14, AppSpacing.s20, 14),
            child: SegmentedTabs(
              labels: [l10n.tabRecords, l10n.tabArchive],
              activeIndex: 1,
              onChanged: (i) {
                if (i == 0) {
                  Navigator.pushReplacementNamed(context, Routes.records);
                }
              },
            ),
          ),
          Expanded(
            child: ref.watch(bookmarkListProvider).when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => _ErrorState(
                    message: e is AppException
                        ? e.message
                        : "Couldn't load your saved expressions.",
                    onRetry: () => ref.invalidate(bookmarkListProvider),
                  ),
                  data: (saved) =>
                      saved.isEmpty ? const _ArchiveEmpty() : _list(saved),
                ),
          ),
        ],
      ),
    );
  }

  /// The populated list of bookmarked sentences.
  Widget _list(List<BookmarkSentence> saved) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20, AppSpacing.s4, AppSpacing.s20, AppSpacing.s24),
      children: [
        Text('My Saved Expressions',
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
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

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
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
