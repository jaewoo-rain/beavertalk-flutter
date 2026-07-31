import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/icons/app_icons.dart';
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
/// The wrap-up screen shown after a call ends: a "통화 종료" heading, the
/// [beaverImage] avatar, and a quick rating row (3 choices). Two pinned actions
/// close the flow — "대화 분석" (primary) submits the rating (best-effort) and
/// pushes [Routes.analysisLoading]; "홈으로" (secondary) → [Routes.home].
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
  // 👎 / 👍 / 👍👍 — bad = thumbs-down, ok = single thumbs-up, good = double
  // thumbs-up (the top satisfaction rating).
  bad(1, AppIcons.thumbsDown),
  ok(2, AppIcons.thumbsUp),
  good(3, AppIcons.thumbsUpDouble);

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
  /// Selected rating, or `null` until the user taps one.
  _Rating? _rating;

  /// Server call id from route arguments (string), parsed to int when valid.
  int? _callId;

  /// Max `call_id` that existed before this call (from the call screen). Used to
  /// recover [_callId] after a manual hang-up; null when unavailable.
  int? _baselineCallId;

  /// True while recovering [_callId] via `GET /calls` (disables the action).
  bool _recovering = false;

  /// Final call duration in whole seconds, from the call screen's live timer.
  int _durationSec = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
  Future<int?> _recoverCallId() async {
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

  void _rate(_Rating r) => setState(() => _rating = r);

  /// Submits the rating (best-effort) then moves to the analysis-loading
  /// screen. Rating is optional: if none was picked, the PATCH is skipped.
  /// A failed rating never blocks navigation.
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

    final rating = _rating;

    if (callId != null && rating != null) {
      try {
        await ref
            .read(normalcallRepositoryProvider)
            .submitRating(callId, rating.value);
      } on AppException catch (e) {
        // Best-effort: surface but don't block the analysis flow.
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).ratingSubmitFailed(e.message),
              ),
            ));
        }
      } catch (_) {
        // Swallow any other error — rating is non-critical.
      }
    }

    if (!mounted) return;
    if (callId == null) {
      // No valid call id → can't analyze; just go home.
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).callInfoNotFound)),
        );
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
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
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (r) => r.isFirst);
      },
      child: AppScaffold(
      background: context.c.backgroundNormalNormal,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      // Figma `2296:26290`: 3 groups — avatar/name/duration (top), rating
      // (middle), actions (bottom) — distributed space-between so they adapt to
      // any device height (was fixed-y Positioned under the old 812 frame).
      //
      // `spaceBetween` alone assumed the three groups always fit. On a 320×640
      // handset they do not once the copy is translated: French and Burmese
      // overflowed the column by 12–14px (caught by `i18n_overflow_test` after
      // its viewport was lowered from a 1400-tall canvas to a real phone).
      //
      // Same shape `payment_complete` already uses: scroll when the content is
      // taller than the viewport, and `minHeight` + `IntrinsicHeight` so that
      // when it *does* fit, `spaceBetween` still distributes across the full
      // height exactly as before. No visual change on roomy screens.
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20, AppSpacing.s48, AppSpacing.s20, AppSpacing.s24),
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
                  style: AppType.title3.b.copyWith(color: context.c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.callEndedDuration(_formatDuration(_durationSec)),
                  style:
                      AppType.body1.r.copyWith(color: context.c.labelNormal),
                ),
              ],
            ),
            // Rating prompt + 3 rating cards.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.callRatingPrompt,
                  style: AppType.headline1.r.copyWith(color: context.c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s32),
                Row(
                  children: [
                    _ratingCard(_Rating.bad),
                    const SizedBox(width: AppSpacing.s16),
                    _ratingCard(_Rating.ok),
                    const SizedBox(width: AppSpacing.s16),
                    _ratingCard(_Rating.good),
                  ],
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
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                    (route) => route.isFirst,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: _recovering ? l10n.loadingShort : l10n.viewAnalysis,
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

  /// One rating choice rendered as a Figma card (`2296:26302`): a 112-tall
  /// rounded box with a 56px circular icon chip; selected → primary border +
  /// primary-10 chip + primary glyph, otherwise neutral.
  Widget _ratingCard(_Rating r) {
    final selected = _rating == r;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: r.label(AppLocalizations.of(context)),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _rate(r),
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // radius/ml
              border: Border.all(
                color: selected ? context.c.primaryNormal : context.c.lineNeutral,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    selected ? context.c.primaryNormal10 : context.c.backgroundElevatedAlternative,
              ),
              alignment: Alignment.center,
              child: r.icon(
                size: 24,
                color: selected ? context.c.primaryNormal : context.c.labelNormal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
