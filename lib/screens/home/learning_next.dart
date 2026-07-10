import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/atoms/record_circle_button.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 2 — Figma `screen/learning_next` (`2117:20110`).
///
/// Shows the just-scored attempt from the real [ReviewFeedback] in
/// [LearningArgs.feedback]: the sentence rendered **per character** colored by
/// its 상/중/하 grade (상 → [AppColors.success], 중 → [AppColors.warning], 하 →
/// [AppColors.error]; falls back to score thresholds when the grade is unknown),
/// the native translation, Native / Me playback, then a retry/next control row.
///
/// - "Me" plays the user's recorded WAV ([LearningArgs.recordedWav]).
/// - "Native" plays [ReviewFeedback.voiceUrl] when present (best-effort; a
///   storage key that isn't directly playable just shows a message).
/// - 다시하기 → pop back to re-record the same sentence.
/// - → next → next sentence's intro, or [Routes.learningMain] when last.
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningNextScreen extends ConsumerStatefulWidget {
  /// Creates the learning comparison screen.
  const LearningNextScreen({super.key});

  @override
  ConsumerState<LearningNextScreen> createState() => _LearningNextScreenState();
}

class _LearningNextScreenState extends ConsumerState<LearningNextScreen> {
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  /// Cached standard-pronunciation URL for the current sentence (fetched once).
  String? _nativeUrl;
  bool _loadingNative = false;

  /// Guards the one-time seeding of the shared bookmark store from this
  /// sentence's server flag ([MockSentence.bookmarked]).
  bool _seededBookmark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededBookmark) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LearningArgs) {
      _seededBookmark = true;
      final s = args.current;
      if (s.bookmarked && !bookmarkedSentenceIds.value.contains(s.id)) {
        bookmarkedSentenceIds.value = {...bookmarkedSentenceIds.value, s.id};
      }
    }
  }

  /// Toggles the current sentence's bookmark. Flips the shared in-memory store
  /// first for instant, cross-screen UI (mirrors the analysis screen), then
  /// persists via [bookmarkToggleControllerProvider]
  /// (`PATCH /sentences/{id}/bookmark`, mirrors record_archive). Reverts the
  /// local flip and surfaces a message if the server call fails.
  Future<void> _toggleBookmark(int sentenceId) async {
    final l10n = AppLocalizations.of(context);
    final willSave = !bookmarkedSentenceIds.value.contains(sentenceId);
    toggleBookmark(sentenceId);
    try {
      await ref
          .read(bookmarkToggleControllerProvider.notifier)
          .toggleBookmark(sentenceId, willSave);
    } catch (e) {
      toggleBookmark(sentenceId); // revert on failure
      _snack(e is AppException ? e.message : l10n.saveSentenceFailed);
    }
  }

  /// Color for a character by grade, falling back to score thresholds when the
  /// grade is unknown/missing.
  static Color _gradeColor(CharScore cs) {
    switch (cs.grade) {
      case CharGrade.high:
        return AppColors.success;
      case CharGrade.medium:
        return AppColors.warning;
      case CharGrade.low:
        return AppColors.error;
      case CharGrade.unknown:
        if (cs.score >= 85) return AppColors.success;
        if (cs.score >= 70) return AppColors.warning;
        return AppColors.error;
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playMe(LearningArgs args) async {
    final l10n = AppLocalizations.of(context);
    final wav = args.recordedWav;
    if (wav == null || wav.isEmpty) {
      _snack(l10n.noRecordingToPlay);
      return;
    }
    try {
      await _player.playBytes(wav);
    } catch (_) {
      _snack(l10n.myRecordingPlayError);
    }
  }

  /// Plays the sentence's standard (native) pronunciation via server on-demand
  /// TTS (`POST /sentences/{id}/tts`), cached after the first fetch.
  ///
  /// Note: the review feedback's `voiceUrl` is the user's own recording, not the
  /// native audio — so the standard pronunciation must come from the sentence's
  /// TTS, keyed by [sentenceId].
  Future<void> _playNative(int sentenceId) async {
    if (_loadingNative) return;
    final l10n = AppLocalizations.of(context);
    var url = _nativeUrl;
    if (url == null || !url.startsWith('http')) {
      setState(() => _loadingNative = true);
      try {
        url = await ref
            .read(reviewRepositoryProvider)
            .sentenceTtsUrl(sentenceId);
        _nativeUrl = url;
      } on AppException catch (e) {
        _snack(e.message);
        return;
      } catch (_) {
        _snack(l10n.standardAudioPlayError);
        return;
      } finally {
        if (mounted) setState(() => _loadingNative = false);
      }
    }
    if (url == null || !url.startsWith('http')) {
      _snack(l10n.standardAudioNotReady);
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack(l10n.standardAudioPlayError);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as LearningArgs;
    final feedback = args.feedback;
    final sentence = args.current;
    final native = feedback?.native ?? sentence.native;

    return AppScaffold(
      background: AppColors.surface2,
      body: Column(
        children: [
          Gnb.main2(
            progress: GnbProgress(current: args.step, total: args.total),
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s16),
                // Speaker / bookmark utility row — top (Figma body top 16).
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top speaker plays the standard (native) pronunciation —
                      // same source as the "Native" button below. Best-effort:
                      // shows a snackbar when the server has no playable URL.
                      Semantics(
                        button: true,
                        label: l10n.listenStandard,
                        child: GestureDetector(
                          onTap: () => _playNative(sentence.id),
                          behavior: HitTestBehavior.opaque,
                          child: AppIcons.volume(size: 32, color: AppColors.text),
                        ),
                      ),
                      // Bookmark (문장 저장) — toggles the current sentence's
                      // saved state; reflects it live via the shared store.
                      ValueListenableBuilder<Set<int>>(
                        valueListenable: bookmarkedSentenceIds,
                        builder: (context, ids, _) {
                          final saved = ids.contains(sentence.id);
                          return Semantics(
                            button: true,
                            label: saved ? l10n.unsaveSentence : l10n.saveSentence,
                            child: GestureDetector(
                              onTap: () => _toggleBookmark(sentence.id),
                              behavior: HitTestBehavior.opaque,
                              child: saved
                                  ? AppIcons.bookmarkFill(
                                      size: 32, color: AppColors.text)
                                  : AppIcons.bookmarkLine(
                                      size: 32, color: AppColors.text),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Per-character scored sentence + translation — centred in the
                // flexible middle (Figma body top 246).
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ScoredSentence(
                            charScores: feedback?.charScores ?? const [],
                            fallbackText: sentence.korean,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            native,
                            textAlign: TextAlign.center,
                            style: AppType.body1.sb.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Native / Me playback buttons (Figma top 478).
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          type: BtnType.secondaryWhite,
                          size: BtnSize.s44,
                          text: 'Native',
                          leftIcon: AppIcons.volume(size: 20),
                          onPressed: () => _playNative(sentence.id),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Button(
                          type: BtnType.secondaryWhite,
                          size: BtnSize.s44,
                          text: 'Me',
                          leftIcon: AppIcons.volume(size: 20),
                          onPressed: () => _playMe(args),
                        ),
                      ),
                    ],
                  ),
                ),
                // Native/Me → controls gap (Figma 36; no AppSpacing token).
                const SizedBox(height: 36),
                // Retry (white circle, centred) + next (arrow) control cluster.
                // The bottom inset comes from the shared [BottomCtaBar] (OS
                // gesture-bar inset on native, a guaranteed 24px floor on
                // web/desktop), so the cluster sits at the same inset as other
                // screens instead of hand-rolling the home-indicator fallback.
                BottomCtaBar(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 56),
                        const SizedBox(width: AppSpacing.s24),
                        RecordCircleButton(
                          icon: AppIcons.redo,
                          semanticLabel: l10n.retry,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(
                            // More sentences left → record the next one directly;
                            // the score screen (learning_main) shows only once,
                            // after the whole review sequence is done.
                            onPressed: () => args.hasNext
                                ? Navigator.pushNamed(
                                    context,
                                    Routes.learningIntro,
                                    arguments: args.next(),
                                  )
                                : Navigator.pushNamed(
                                    context,
                                    Routes.learningMain,
                                    arguments: args,
                                  ),
                            icon: AppIcons.arrowForward(
                              size: 32,
                              color: AppColors.green700,
                            ),
                            iconSize: 32,
                            color: AppColors.green700,
                            tooltip: l10n.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the sentence character-by-character, each tinted by its grade.
/// Falls back to a plain (un-tinted) sentence when no char scores exist.
class _ScoredSentence extends StatelessWidget {
  const _ScoredSentence({required this.charScores, required this.fallbackText});

  final List<CharScore> charScores;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final base = AppType.heading2.sb;
    if (charScores.isEmpty) {
      return Text(
        fallbackText,
        textAlign: TextAlign.center,
        style: base.copyWith(color: AppColors.text),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (final cs in charScores)
            TextSpan(
              text: cs.char,
              style: base.copyWith(
                color: _LearningNextScreenState._gradeColor(cs),
              ),
            ),
        ],
      ),
    );
  }
}
