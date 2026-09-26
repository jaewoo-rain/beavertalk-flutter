import '../../app/adaptive.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/layout/need_based_rows.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/molecules/card_loading.dart';
import '../../components/molecules/card_study.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_providers.dart'
    show authRepositoryProvider;
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'analysis.dart';
import 'level_up.dart';

/// Analysis loading — bridges 통화 종료 → 통화 분석.
///
/// Receives the int `callId` as route arguments, then polls
/// `repository.getStatus(callId)` every [_pollInterval] until the analysis is
/// `done` (→ fetch the result and replace with [Routes.analysis]) or `failed`
/// (→ inline error + retry/home). **There is no timeout** (2026-09-23 사장님 「그대로 둬
/// (로딩 중)」 · 원장 P29-a): past [_fastWindow] the screen stays in its loading state and
/// only slows its polling to [_slowInterval]. The 「오래 걸리고 있어요」 error was removed
/// on purpose — a stuck server analysis must be closed as `failed` by the server
/// (proposal S-a·S-b in `docs/2026-09-23_1741_analysis-preparing-flow-plan.md`).
/// The poll timer is cancelled on dispose and every async step guards against an
/// unmounted widget.
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
  /// How often to poll the status endpoint at first.
  static const Duration _pollInterval = Duration(milliseconds: 1500);

  /// How long to poll at [_pollInterval] before slowing down.
  static const Duration _fastWindow = Duration(seconds: 60);

  /// Polling interval after [_fastWindow] — the screen keeps waiting, just
  /// asks the server less often.
  static const Duration _slowInterval = Duration(seconds: 5);

  int? _callId;
  _LoadingPhase _phase = _LoadingPhase.polling;

  /// Latest status from the server — drives the waiting card's two steps.
  /// null until the first answer.
  CallAnalysisStatus? _status;

  /// 서버가 「LLM 결과가 아직 없다」(`ongoing` · `analyzing`)고 한 번이라도 답했는가.
  ///
  /// 09-26 사용자: 「screen/analysis__preparing 이거를 로딩 스켈레톤으로 쓰는 게 아니라 로딩
  /// 스켈레톤 이후에 만약 LLM 결과값이 없다면 이거를 띄워야해」. 그래서
  /// - false = 순수 스켈레톤(Figma `screen/analysis_loading` `3569:27500`) — 첫 답을 기다리는 중,
  ///   또는 첫 답이 바로 `done` 이라 결과를 받는 중(이미 분석된 지난 통화는 준비 중을 안 거친다)
  /// - true = 준비 중(Figma `screen/analysis__preparing` `6330:13219`) — `done` 이 올 때까지 조회
  /// 한 번 true 가 되면 분석 화면으로 넘어갈 때까지 되돌리지 않는다 — `done` 뒤 결과를 받는 사이에
  /// 스켈레톤으로 되돌아가 깜빡이지 않게.
  bool _llmPending = false;

  /// `unknown` 을 연달아 받은 횟수 — [_unknownLimit] 에 닿으면 끝낸다(QA F024).
  ///
  /// 서버는 없는 통화 · 남의 통화에 200 `{status: unknown}` 을 준다(ws_router `/status`). 예전엔
  /// 이것도 「계속 조회」라 지워진 통화 · 잘못된 id 로 들어오면 스켈레톤이 끝나지 않았다. 모르는
  /// 새 상태값도 `unknown` 으로 읽히므로 한 번에 끊지 않고 연속 [_unknownLimit] 회에만 끝낸다.
  int _unknownStreak = 0;
  static const int _unknownLimit = 3;
  String _errorMsg = '';

  Timer? _pollTimer;

  /// End of the fast-polling window; null once polling has slowed down.
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
    _unknownStreak = 0;
    _deadline = DateTime.now().add(_fastWindow);
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

    // Past the fast window: keep waiting (no error), poll less often.
    if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
      _deadline = null;
      _pollTimer?.cancel();
      _pollTimer = Timer.periodic(_slowInterval, (_) => _poll());
    }

    _busy = true;
    try {
      final status = await ref
          .read(normalcallRepositoryProvider)
          .getStatus(callId);
      if (!mounted || _navigated) return;
      final pending =
          status == CallAnalysisStatus.ongoing ||
          status == CallAnalysisStatus.analyzing;
      if (status != _status || (pending && !_llmPending)) {
        setState(() {
          _status = status;
          if (pending) _llmPending = true;
        });
      }
      _unknownStreak =
          status == CallAnalysisStatus.unknown ? _unknownStreak + 1 : 0;
      switch (status) {
        case CallAnalysisStatus.done:
          await _fetchResultAndGo(callId);
        case CallAnalysisStatus.failed:
          _fail(AppLocalizations.of(context).analysisFailed);
        case CallAnalysisStatus.unknown:
          if (_unknownStreak >= _unknownLimit) {
            _fail(AppLocalizations.of(context).callInfoNotFound);
          }
        case CallAnalysisStatus.ongoing:
        case CallAnalysisStatus.analyzing:
          // Keep polling.
          break;
      }
    } on AppException {
      // Transient network errors: keep polling — the screen stays loading.
    } finally {
      _busy = false;
    }
  }

  /// Fetches the full result and replaces this screen with the analysis screen.
  Future<void> _fetchResultAndGo(int callId) async {
    try {
      final result = await ref
          .read(normalcallRepositoryProvider)
          .getResult(callId);
      if (!mounted || _navigated) return;
      // 레벨이 올랐으면 분석 화면 **직전에 한 번** 축하 페이지(09-25 사장님 확정 V1 ·
      // Figma `screen/level_up` `6410:42174`). 확인 → 분석 화면. 못 물어보면 그냥 분석으로.
      final memberId = ref.read(myProfileProvider).valueOrNull?.memberId;
      final leveledUp = memberId == null
          ? null
          : await LevelUpCheck.newLevel(
              ref.read(authRepositoryProvider),
              memberId: memberId,
            );
      if (!mounted || _navigated) return;
      _navigated = true;
      _pollTimer?.cancel();
      // A short fade, not the default slide: the waiting screen already has
      // the analysis layout, so the hand-off should read as the same screen
      // filling in (Figma prototype `6330:13219` → `screen/analysis`, DISSOLVE).
      Route<void> analysisRoute() => PageRouteBuilder<void>(
        settings: RouteSettings(name: Routes.analysis, arguments: result),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => const AnalysisScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      );
      if (leveledUp == null) {
        Navigator.of(context).pushReplacement(analysisRoute());
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: Routes.levelUp),
            builder: (page) => LevelUpScreen(
              level: leveledUp,
              onConfirm: () =>
                  Navigator.of(page).pushReplacement(analysisRoute()),
            ),
          ),
        );
      }
    } on AppException catch (e) {
      _fail(_reason(e));
    }
  }

  /// The reason line for [e] — its message only when the server wrote it.
  /// The built-in fallbacks are hardcoded Korean, so showing them unconditionally
  /// leaks Korean into all 30 locales (see [AppException.fromServer]). Empty
  /// falls through to the view's own localized copy.
  String _reason(AppException e) => e.fromServer ? e.message : '';

  /// Stops polling and shows the retry UI with [message].
  void _fail(String message) {
    _pollTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _LoadingPhase.error;
      _errorMsg = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _LoadingPhase.error) {
      return AppScaffold(
        background: context.c.backgroundNormalNormal,
        // The error branch carries the same GNB as the polling branch below.
        // Without it the only way out was a CTA that left for 홈 — there was no
        // way back to wherever the user came from. With the GNB here, the
        // regional error needs no 홈으로 of its own. Keeps the title the polling
        // branch already defines rather than blanking it: same screen, same
        // header, so nothing shifts when the poll fails.
        body: Column(
          children: [
            Gnb.main(
              title: AppLocalizations.of(context).conversationRecord,
              onBack: () => Navigator.pop(context),
            ),
            // No padding wrapper: NetworkErrorView carries the standard 20
            // gutter itself, and the old 24 here would have stacked on top.
            Expanded(child: _error()),
          ],
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

  /// The analysis screen with every unknown value stubbed (`3569:27503`) — 순수 스켈레톤
  /// ([_llmPending] false)과 준비 중([_llmPending] true)이 같은 틀을 쓰고, 게이지 흐림 ·
  /// BabaNote · 새로 배운 표현 세 칸만 다르다(Figma 칸별 대조 · 디자인 세션 09-26).
  Widget _skeleton() {
    final l10n = AppLocalizations.of(context);
    final preparing = _llmPending;
    return ContentColumn(
      child: SingleChildScrollView(
        // Same padding as the analysis screen, so nothing shifts on hand-off.
        padding: const EdgeInsets.only(
          top: AppSpacing.s16,
          bottom: AppSpacing.s40,
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
                child: Skeleton.bar(width: 220, height: 14),
              ),
            ),

            const SizedBox(height: AppSpacing.s24),
            // 스켈레톤 · 준비 중 둘 다 inactive 를 불투명도 0.4 로 흐리게(09-24 결정 「분석 로딩 ·
            // 준비 게이지 = inactive + 0.4」 · Figma `analysis_loading` `3569:27508` · Tablet `5287:2272` ·
            // `analysis__preparing` `6330:13227` · Tablet `6330:51010`) — 비활성 학습 카드와 같은 결.
            // 결과가 오면 분석 화면으로 페이드 전환되며 정상(active · 1)으로 나타난다.
            Center(
              child: Opacity(
                opacity: 0.4,
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
            ),

            // ── Actions (3569:27509) ───────────────────────────────────
            const SizedBox(height: AppSpacing.s24),
            // `Card/Study` ×2, disabled — both need this call's learned
            // sentences, which arrive with the result.
            CardStudy.learn(title: l10n.practicePronunciation),
            const SizedBox(height: AppSpacing.s12),
            CardStudy.challenge(title: l10n.challengeTitle),

            // ── Section/BabaNote ──────────────────────────────────────
            // 준비 중(`6330:13219`): the note is written with the result, so its
            // slot says what is happening instead of shimmering. 순수 스켈레톤
            // (`3569:27512`): 아바타 자리 + 막대. The label stays a skeleton either
            // way: it needs the partner's name, which this screen does not have.
            ..._section(
              label: const Skeleton.bar(width: 90, height: 15),
              child: _card(
                child: !preparing
                    ? const _BabaNoteSkeleton()
                    : Row(
                        children: [
                          AppIcons.duoPreparing(size: 36),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.analysisPrepNote,
                                  style: AppType.body2.r.copyWith(
                                    color: context.c.labelNormal,
                                  ),
                                ),
                                const SizedBox(height: 6), // no s6 token
                                Text(
                                  l10n.analysisPrepNoteHint,
                                  style: AppType.caption1.r.copyWith(
                                    color: context.c.labelAlternative,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // ── Section/Expressions ─────────────────────────────────────
            // 준비 중(`6330:13219` Card/Preparing): the cards are what the LLM is
            // still writing, so this slot shows the beaver at work. 순수 스켈레톤
            // (`3569:27537`): 표현 카드 모양 한 장. When `done` lands the analysis
            // screen replaces this one with a fade, and the real cards take this spot.
            ..._section(
              // Countless here — the count is exactly what is still loading.
              label: Text(l10n.newExpressions, style: AppType.body2.m),
              child: preparing
                  ? AnalysisPreparingCard(
                      saved: _status == CallAnalysisStatus.analyzing,
                    )
                  : const CardLoading(),
            ),
          ],
        ),
      ),
    );
  }

  /// Mirrors the analysis screen's section rhythm (24 above, 8 under the label).
  List<Widget> _section({
    required Widget label,
    Widget? trailing,
    required Widget child,
  }) => [
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

  /// The shared network-error body, carrying [_errorMsg] as the reason.
  ///
  /// Retry is null when there is no `callId` — there is no request to re-run,
  /// so the button is hidden rather than shown. It used to render as 다시 시도
  /// and quietly navigate home instead, which is a different action under the
  /// wrong label.
  Widget _error() => NetworkErrorView(
    message: _errorMsg.isEmpty ? null : _errorMsg,
    onRetry: _callId == null ? null : _start,
  );
}

/// 순수 스켈레톤의 BabaNote 카드 안(Figma `3569:27512`) — 아바타 자리 32 + 막대 셋.
///
/// The frame gives the two skeleton slots the line boxes of the text they stand
/// in for — Body 38 (`3569:27517`) and Attribution 14 (`3569:27520`) — which is
/// what makes the card 90, exactly the loaded BabaNote's 88 + its 2px of extra
/// leading. Stacking the bars bare rendered 83.
class _BabaNoteSkeleton extends StatelessWidget {
  const _BabaNoteSkeleton();

  @override
  Widget build(BuildContext context) => const Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Skeleton.circle(size: 32),
      SizedBox(width: AppSpacing.s12),
      Expanded(
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
  );
}

/// `Card/Preparing` in the analysis waiting state (Figma `6330:13219`).
///
/// icon 80 · title · line · two steps. r16 · Surface/Alternative · padding
/// 28/20/20/20 · gap 12, centred. Public so the i18n harness can mount it.
class AnalysisPreparingCard extends StatelessWidget {
  /// Creates the card.
  const AnalysisPreparingCard({super.key, required this.saved});

  /// Step 1 (대화 저장) is done once the server reports `analyzing`; until then
  /// it is the step in progress and step 2 waits.
  final bool saved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        28,
        AppSpacing.s20,
        AppSpacing.s20,
      ),
      decoration: BoxDecoration(
        color: c.backgroundSurfaceAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          AppIcons.duoPreparing(size: 80),
          const SizedBox(height: AppSpacing.s12),
          Text(
            l10n.analysisPrepTitle,
            textAlign: TextAlign.center,
            style: AppType.headline2.b.copyWith(color: c.labelStrong),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            l10n.analysisPrepSub,
            textAlign: TextAlign.center,
            style: AppType.label2.r.copyWith(color: c.labelNeutral),
          ),
          const SizedBox(height: AppSpacing.s24), // 12 gap + 12 top of Steps
          _step(
            context,
            icon: saved
                ? AppIcons.duoCheck(size: 20)
                : AppIcons.aiSparkle(size: 20, color: c.labelNormal),
            label: l10n.analysisPrepStepSave,
            state: saved
                ? l10n.analysisPrepStateDone
                : l10n.analysisPrepStateWorking,
            stateColor: saved ? c.labelAlternative : c.primaryNormal,
          ),
          const SizedBox(height: AppSpacing.s12),
          _step(
            context,
            icon: AppIcons.aiSparkle(
              size: 20,
              color: saved ? c.labelNormal : c.labelAssistive,
            ),
            label: l10n.analysisPrepStepCards,
            state: saved
                ? l10n.analysisPrepStateWorking
                : l10n.analysisPrepStateWaiting,
            stateColor: saved ? c.primaryNormal : c.labelAlternative,
          ),
        ],
      ),
    );
  }

  /// One step row: icon 20 · 10 · label (fills) · state at the end.
  Widget _step(
    BuildContext context, {
    required Widget icon,
    required String label,
    required String state,
    required Color stateColor,
  }) => Row(
    children: [
      icon,
      const SizedBox(width: 10), // Figma gap, no token
      // 이름 · 상태는 필요 폭대로(`LabelValueRow`) — 상태를 고정 폭으로 두면 긴 언어 320 폭에서
      // 행이 0.8px 넘쳤다(09-24 i18n 게이트). 상태는 끝에 붙고, 넘치면 긴 쪽이 줄을 바꾼다.
      Expanded(
        child: LabelValueRow(
          gap: AppSpacing.s8,
          label: Text(
            label,
            style: AppType.label1.m.copyWith(color: context.c.labelNormal),
          ),
          value: Text(
            state,
            textAlign: TextAlign.end,
            style: AppType.label1.r.copyWith(color: stateColor),
          ),
        ),
      ),
    ],
  );
}
