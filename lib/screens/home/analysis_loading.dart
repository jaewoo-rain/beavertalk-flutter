import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/molecules/card_loading.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Analysis loading — bridges 통화 종료 → 통화 분석.
///
/// Receives the int `callId` as route arguments, then polls
/// `repository.getStatus(callId)` every [_pollInterval] until the analysis is
/// `done` (→ fetch the result and replace with [Routes.analysis]) or `failed`
/// (→ inline error + retry/home). Polling is capped at [_timeout]; a timeout
/// shows the same retry UI. The poll timer is cancelled on dispose and every
/// async step guards against an unmounted widget.
///
/// The waiting state is a **skeleton of the analysis screen** (Figma
/// `screen/analysis_loading`, `3569:27500`) — same GNB, gauge, buttons and
/// section order as [Routes.analysis], with each not-yet-known value as a
/// [Skeleton]. The screen it is about to become is already laid out, so nothing
/// jumps when the result lands.
///
/// **Where this departs from the frame, and why.** The frame draws the call meta
/// ("Baba · 1월 2일 · 10분 37초 · 3번째 통화"), the partner avatar and the
/// "Baba의 한마디" label as real content while it waits. This screen cannot:
/// `call_finish` hands it a bare `callId` and nothing else, and the partner and
/// call sequence are fields the server does not send even *after* the result
/// arrives. Those three slots are skeletons here rather than invented text. The
/// label that is static — 새로 배운 표현 — renders for real, as the frame has it.
class AnalysisLoadingScreen extends ConsumerStatefulWidget {
  /// Creates the analysis-loading screen.
  const AnalysisLoadingScreen({super.key});

  @override
  ConsumerState<AnalysisLoadingScreen> createState() =>
      _AnalysisLoadingScreenState();
}

/// What the loading screen is currently showing.
enum _LoadingPhase { polling, error }

class _AnalysisLoadingScreenState extends ConsumerState<AnalysisLoadingScreen> {
  /// How often to poll the status endpoint.
  static const Duration _pollInterval = Duration(milliseconds: 1500);

  /// Give up after this long and show the retry UI.
  static const Duration _timeout = Duration(seconds: 60);

  int? _callId;
  _LoadingPhase _phase = _LoadingPhase.polling;
  String _errorMsg = '';

  Timer? _pollTimer;
  DateTime? _deadline;

  /// Prevents overlapping polls and double navigation.
  bool _busy = false;
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_callId != null) return; // capture once
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      _callId = args;
      _start();
    } else {
      // Shouldn't happen (call_finish always passes an int), but fail safe.
      _phase = _LoadingPhase.error;
      _errorMsg = AppLocalizations.of(context).callInfoNotFound;
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// (Re)starts the polling cycle from a fresh deadline.
  void _start() {
    _pollTimer?.cancel();
    _deadline = DateTime.now().add(_timeout);
    setState(() {
      _phase = _LoadingPhase.polling;
      _errorMsg = '';
    });
    // Poll immediately, then on an interval.
    _poll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    if (_busy || _navigated || !mounted) return;
    final callId = _callId;
    if (callId == null) return;

    // Timeout check.
    if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
      _fail(AppLocalizations.of(context).analysisTimeout);
      return;
    }

    _busy = true;
    try {
      final status =
          await ref.read(normalcallRepositoryProvider).getStatus(callId);
      if (!mounted || _navigated) return;
      switch (status) {
        case CallAnalysisStatus.done:
          await _fetchResultAndGo(callId);
        case CallAnalysisStatus.failed:
          _fail(AppLocalizations.of(context).analysisFailed);
        case CallAnalysisStatus.ongoing:
        case CallAnalysisStatus.analyzing:
        case CallAnalysisStatus.unknown:
          // Keep polling.
          break;
      }
    } on AppException catch (e) {
      // Transient network errors: keep polling until the timeout, but if we're
      // already past the deadline, surface the message.
      if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
        _fail(e.message);
      }
    } finally {
      _busy = false;
    }
  }

  /// Fetches the full result and replaces this screen with the analysis screen.
  Future<void> _fetchResultAndGo(int callId) async {
    try {
      final result =
          await ref.read(normalcallRepositoryProvider).getResult(callId);
      if (!mounted || _navigated) return;
      _navigated = true;
      _pollTimer?.cancel();
      Navigator.pushReplacementNamed(
        context,
        Routes.analysis,
        arguments: result,
      );
    } on AppException catch (e) {
      _fail(e.message);
    }
  }

  /// Stops polling and shows the retry UI with [message].
  void _fail(String message) {
    _pollTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _LoadingPhase.error;
      _errorMsg = message;
    });
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    if (_phase == _LoadingPhase.error) {
      return AppScaffold(
        background: context.c.backgroundNormalNormal,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: _error(),
        ),
      );
    }
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: AppLocalizations.of(context).conversationRecord,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(child: SkeletonShimmer(child: _skeleton())),
        ],
      ),
    );
  }

  /// The analysis screen with every unknown value stubbed (`3569:27503`).
  Widget _skeleton() {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      // Same padding as the analysis screen, so nothing shifts on hand-off.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s16,
        AppSpacing.s20,
        AppSpacing.s40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── CallHeader (3569:27504) ────────────────────────────────
          // Both lines are skeletons: the frame shows real meta here, but see
          // the class doc — this screen has only a call id. The boxes keep the
          // heights of the text they stand in for, so the gauge lands where it
          // will sit once the result arrives.
          const SizedBox(
            height: 28,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Skeleton.bar(width: 210, height: 20),
            ),
          ),
          const SizedBox(height: 6), // no s6 token
          const SizedBox(
            height: 18,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Skeleton.bar(width: 200, height: 12),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          Center(
            child: PronunciationResult(
              state: PronunciationState.inactive,
              score: 0,
              metrics: [
                PronunciationMetric(label: l10n.pronunciation, value: '-%'),
                PronunciationMetric(label: l10n.fluency, value: '-%'),
                PronunciationMetric(label: l10n.rhythm, value: '-%'),
              ],
            ),
          ),

          // ── Actions (3569:27509) ───────────────────────────────────
          const SizedBox(height: AppSpacing.s24),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.review,
            // Nothing to practice until the result lands.
            disabled: true,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.s12),
          Button(
            type: BtnType.primaryOutline,
            size: BtnSize.s60,
            text: l10n.pronunciationChallenge,
            // The challenge needs nothing from this call, so it stays live.
            onPressed: () =>
                Navigator.pushNamed(context, Routes.pronunciationChallenge),
          ),

          // ── Section/BabaNote (3569:27512) ──────────────────────────
          ..._section(
            // A skeleton, not "…의 한마디": the label needs the partner's name.
            label: const Skeleton.bar(width: 90, height: 15),
            child: _card(
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton.circle(size: 32),
                  SizedBox(width: AppSpacing.s12),
                  Expanded(
                    // The frame gives the two skeleton slots the line boxes of
                    // the text they stand in for — Body 38 (`3569:27517`) and
                    // Attribution 14 (`3569:27520`) — which is what makes the
                    // card 90, exactly the loaded BabaNote's 88 + its 2px of
                    // extra leading. Stacking the bars bare rendered 83.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Skeleton.bar(width: 255, height: 12),
                              SizedBox(height: 6),
                              Skeleton.bar(width: 150, height: 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        SizedBox(
                          height: 14,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Skeleton.bar(width: 110, height: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Section/Expressions (3569:27534) ───────────────────────
          ..._section(
            // Countless here — the frame's label is 새로 배운 표현 with no number,
            // since the count is exactly what is still loading.
            label: Text(l10n.newExpressions, style: AppType.body2.m),
            // One card, as the frame draws (`3569:27537` holds a single
            // `Card/Expression-1`). It used to stack three; that promised a
            // count the response hasn't given yet.
            child: const CardLoading(),
          ),
        ],
      ),
    );
  }

  /// Mirrors the analysis screen's section rhythm (24 above, 8 under the label).
  List<Widget> _section({
    required Widget label,
    Widget? trailing,
    required Widget child,
  }) =>
      [
        const SizedBox(height: AppSpacing.s24),
        Row(
          children: [
            Expanded(
              child: Align(alignment: Alignment.centerLeft, child: label),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s8),
              trailing,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ];

  /// The shared card shell (#1F222A, r12, p16).
  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: child,
      );

  Widget _error() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: context.c.labelNormal,
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.analysisLoadError,
            style: AppType.heading2.sb.copyWith(color: context.c.labelStrong),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            _errorMsg,
            style: AppType.body1.r.copyWith(color: context.c.labelNormal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s28),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.tryAgain,
            onPressed: _callId == null ? _goHome : _start,
          ),
          const SizedBox(height: AppSpacing.s12),
          Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.home,
            onPressed: _goHome,
          ),
        ],
      ),
    );
  }
}
