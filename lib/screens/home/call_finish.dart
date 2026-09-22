import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../core/error/app_exception.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Call finished — Figma `screen/call_finish` (`2117:19981`).
///
/// The wrap-up screen shown after a call ends: the partner avatar, name and
/// call duration, with two pinned actions — "대화 분석" (primary) pushes
/// [Routes.analysisLoading]; "홈으로" (secondary) → [Routes.home].
///
/// The quick rating (3 choices) is a **bottom sheet** that opens over this
/// screen on arrival — Figma `screen/call_finish__rating` (`6249:13158`). It
/// used to be an inline row here; the sheet keeps the wrap-up screen to the two
/// next steps and makes rating a one-tap, skippable question. Submit sends the
/// rating (best-effort, never blocks); Skip and a dim tap just close it.
///
/// The server call id arrives as the route's `arguments` (`String?`, set by
/// [CallScreen]; the WS `call_ended` carries it as a string) and is parsed to an
/// int before being forwarded to the analysis-loading flow.
class CallFinishScreen extends ConsumerStatefulWidget {
  /// Creates the call-finished screen.
  const CallFinishScreen({super.key});

  @override
  ConsumerState<CallFinishScreen> createState() => _CallFinishScreenState();
}

/// The user's quick rating of the call, carrying the backend int value
/// (ascending): bad=1, ok=2, good=3.
enum _Rating {
  // Figma `call_finish__rating`: thumbs-down / thumbs-up / heart-eyes — the
  // top rating is heart-eyes (was a double thumbs-up on the old inline row).
  bad(1, AppIcons.thumbsDown),
  ok(2, AppIcons.thumbsUp),
  good(3, AppIcons.heartEyes);

  const _Rating(this.value, this.icon);

  /// Backend rating value sent in `PATCH /calls/{id}` `{"rating": value}`.
  final int value;

  /// Glyph builder shown in the rating card.
  final AppIconBuilder icon;

  /// Localized accessible label.
  String label(AppLocalizations l10n) => switch (this) {
    _Rating.bad => l10n.ratingBad,
    _Rating.ok => l10n.ratingOkay,
    _Rating.good => l10n.ratingGood,
  };
}

class _CallFinishScreenState extends ConsumerState<CallFinishScreen> {
  /// Server call id from route arguments (string), parsed to int when valid.
  int? _callId;

  /// Max `call_id` that existed before this call (from the call screen). Used to
  /// recover [_callId] after a manual hang-up; null when unavailable.
  int? _baselineCallId;

  /// True while recovering [_callId] via `GET /calls` (disables the action).
  bool _recovering = false;

  /// Final call duration in whole seconds, from the call screen's live timer.
  int _durationSec = 0;

  /// Whether the rating sheet has been offered — once per screen, not on every
  /// dependency change.
  bool _ratingOffered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ratingOffered) {
      _ratingOffered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _offerRating();
      });
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ({String? callId, int elapsedSec, int? baselineCallId})) {
      final id = args.callId;
      _callId = id == null ? null : int.tryParse(id);
      _durationSec = args.elapsedSec;
      _baselineCallId = args.baselineCallId;
    } else if (args is ({String? callId, int elapsedSec})) {
      final id = args.callId;
      _callId = id == null ? null : int.tryParse(id);
      _durationSec = args.elapsedSec;
    } else if (args is String) {
      _callId = int.tryParse(args);
    } else if (args is int) {
      _callId = args;
    }
  }

  /// Recovers the just-finished call's id when it was a manual hang-up (no
  /// `call_ended`, so [_callId] is null). Polls `GET /calls` for an id greater
  /// than [_baselineCallId] — the server may lag finalizing the row, so retry a
  /// few times. Returns null if no new call appears.
  Future<int?> _recoverCallId() => _recovery ??= _pollCallId();

  /// The one in-flight recovery — shared by the rating sheet and 「대화 분석」 so
  /// a manual hang-up never polls twice (Submit, then tapping analysis within
  /// the ~3s window, used to start a second 5-attempt poll).
  Future<int?>? _recovery;

  Future<int?> _pollCallId() async {
    final repo = ref.read(normalcallRepositoryProvider);
    const attempts = 5;
    const gap = Duration(milliseconds: 600);
    final baseline = _baselineCallId;
    for (var i = 0; i < attempts; i++) {
      try {
        final latest = await repo.latestCallId();
        if (latest != null && (baseline == null || latest > baseline)) {
          return latest;
        }
      } catch (_) {
        // Transient (network/server) — fall through to retry.
      }
      if (i < attempts - 1) await Future<void>.delayed(gap);
    }
    return null;
  }

  /// Formats whole [seconds] as `mm:ss` (or `hh:mm:ss` past an hour).
  String _formatDuration(int seconds) {
    final s = (seconds % 60).toString().padLeft(2, '0');
    if (seconds >= 3600) {
      final h = (seconds ~/ 3600).toString().padLeft(2, '0');
      final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Opens the rating sheet; a chosen rating is sent in the background.
  Future<void> _offerRating() async {
    final picked = await showModalBottomSheet<_Rating>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      isScrollControlled: true,
      builder: (_) => const CallRatingSheet(),
    );
    if (picked != null && mounted) await _submitRating(picked);
  }

  /// Sends [rating] — best-effort: a failure is surfaced but never blocks.
  /// A manual hang-up has no call id yet, so it is recovered first.
  Future<void> _submitRating(_Rating rating) async {
    var callId = _callId;
    if (callId == null) {
      callId = await _recoverCallId();
      if (!mounted) return;
      if (callId != null) _callId = callId;
    }
    if (callId == null) return;
    try {
      await ref
          .read(normalcallRepositoryProvider)
          .submitRating(callId, rating.value);
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).ratingSubmitFailed(e.message),
              ),
            ),
          );
      }
    } catch (_) {
      // Swallow any other error — rating is non-critical.
    }
  }

  /// Moves to the analysis-loading screen (recovering the call id if needed).
  Future<void> _analyze() async {
    if (_recovering) return; // guard against double-taps during recovery

    var callId = _callId;

    // Manual hang-up gets no `call_ended`, so there's no call id yet. Recover it
    // from `GET /calls` (baseline-gated) before analyzing.
    if (callId == null) {
      setState(() => _recovering = true);
      callId = await _recoverCallId();
      if (!mounted) return;
      setState(() => _recovering = false);
      if (callId != null) _callId = callId;
    }

    if (!mounted) return;
    if (callId == null) {
      // No valid call id → can't analyze; just go home.
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).callInfoNotFound),
          ),
        );
      Navigator.of(context).popUntil((r) => r.isFirst);
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      Routes.analysisLoading,
      arguments: callId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedChar = ref.watch(selectedCharacterProvider);
    final selectedCharUrl = selectedChar?.imageUrl;
    // Was `characterImage(characterId)`, whose id map is stale: a BABA user
    // (id 1) fell to its `else` branch and this screen closed the call with
    // **Judi's** face — a character no longer in the catalog. Neutral
    // placeholder until the real image resolves.
    final partnerImage = (selectedCharUrl != null && selectedCharUrl.isNotEmpty)
        ? NetworkImage(selectedCharUrl) as ImageProvider
        : placeholderAvatar;
    // Terminal call screen: it is reached via pushReplacement, so the route
    // under it is whatever preceded the call (often a half-built AuthGate on a
    // cold-start-for-call). A raw system/gesture back would pop into that and
    // flash a black screen + throw. Intercept back and route home deterministically.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).popUntil((r) => r.isFirst);
      },
      child: AppScaffold(
        background: context.c.backgroundNormalNormal,
        statusVariant: StatusBarVariant.whiteTransparent,
        homeVariant: HomeIndicatorVariant.whiteTransparent,
        // Figma `3360:19277`: 2 groups — avatar/name/duration (top), actions
        // (bottom) — distributed space-between so they adapt to any device height.
        // The rating that used to sit between them is now a sheet (see class doc).
        //
        // `spaceBetween` alone assumed the three groups always fit. On a 320×640
        // handset they do not once the copy is translated: French and Burmese
        // overflowed the column by 12–14px (caught by `i18n_overflow_test` after
        // its viewport was lowered from a 1400-tall canvas to a real phone).
        //
        // Same shape the old `payment_complete` screen used: scroll when the content is
        // taller than the viewport, and `minHeight` + `IntrinsicHeight` so that
        // when it *does* fit, `spaceBetween` still distributes across the full
        // height exactly as before. No visual change on roomy screens.
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: ContentColumn(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.s48,
                    bottom: AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar + name + call duration.
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: AppSpacing.s120,
                            height: AppSpacing.s120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.c.backgroundNormalAlternative,
                              image: DecorationImage(
                                image: partnerImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          Text(
                            // Blank rather than a guessed name — see the same call in
                            // `call.dart`.
                            selectedChar?.name ?? '',
                            style: AppType.title3.b.copyWith(
                              color: context.c.labelStrong,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            l10n.callEndedDuration(
                              _formatDuration(_durationSec),
                            ),
                            style: AppType.body1.r.copyWith(
                              color: context.c.labelNormal,
                            ),
                          ),
                        ],
                      ),
                      // Actions — 홈으로 (secondary) / 대화 분석 바로가기 (primary).
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Button(
                            type: BtnType.secondaryFill,
                            size: BtnSize.s60,
                            text: l10n.goHome,
                            onPressed: () => Navigator.of(
                              context,
                            ).popUntil((r) => r.isFirst),
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          Button(
                            type: BtnType.primaryFill,
                            size: BtnSize.s60,
                            text: _recovering
                                ? l10n.loadingShort
                                : l10n.viewAnalysis,
                            disabled: _recovering,
                            onPressed: _analyze,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The call-rating sheet — Figma `BottomSheet/CallRating` in
/// `screen/call_finish__rating` (`6249:13158`). Pops the chosen [_Rating] on
/// Submit, `null` on Skip (and a dim tap).
class CallRatingSheet extends StatefulWidget {
  /// Creates the call-rating sheet.
  const CallRatingSheet({super.key});

  @override
  State<CallRatingSheet> createState() => _CallRatingSheetState();
}

class _CallRatingSheetState extends State<CallRatingSheet> {
  _Rating? _picked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomSheetContent(
      title: l10n.callRatingPrompt,
      body: l10n.callRatingBody,
      primaryAction: SheetAction(
        label: l10n.callRatingSubmit,
        // Nothing picked → Submit is the same as Skip; it never sends a guess.
        onPressed: () => Navigator.pop(context, _picked),
      ),
      secondaryAction: SheetAction(
        label: l10n.callRatingSkip,
        onPressed: () => Navigator.pop(context),
      ),
      // Three equal cards, icon only — no text competes for the row's width in
      // any locale. Each card still carries its label for screen readers.
      child: Row(
        children: [
          for (final r in _Rating.values) ...[
            if (r != _Rating.bad) const SizedBox(width: AppSpacing.s16),
            _card(context, r),
          ],
        ],
      ),
    );
  }

  /// One rating choice (Figma card 101×112, r20): a 56px icon disc;
  /// selected → primary border + primary-10 disc + primary glyph.
  Widget _card(BuildContext context, _Rating r) {
    final selected = _picked == r;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: r.label(AppLocalizations.of(context)),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _picked = r),
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // radius/ml
              border: Border.all(
                color: selected
                    ? context.c.primaryNormal
                    : context.c.lineNeutral,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? context.c.primaryNormal10
                    : context.c.backgroundElevatedAlternative,
              ),
              alignment: Alignment.center,
              child: r.icon(
                size: 24,
                color: selected
                    ? context.c.primaryNormal
                    : context.c.labelNormal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
