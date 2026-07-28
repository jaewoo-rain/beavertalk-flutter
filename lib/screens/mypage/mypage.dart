import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/level_progress.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/domain/entities/accent_breakdown.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Design-time values for the two cards the server has no source for yet.
///
/// **These are Figma numbers, not live data.** The redesign added a 종합 레벨
/// card and a 발음 분석 card; the backend exposes neither a level percentile nor
/// a recent-sessions score aggregate today, and this pass is UI-only by
/// instruction. Wiring them later means replacing exactly this block:
///
/// - level → `GET /members/me`.`korean_level` (already exists server-side,
///   1–13; the Flutter `Member` entity does not parse it yet).
/// - percentile → no server field exists; needs a new one.
/// - the pronunciation gauge → a recent-sessions aggregate endpoint, or a
///   client fold over `GET /calls/{id}/result`.`score_average`.
abstract final class _DesignSample {
  static const int level = 7;
  static const int levelMax = 13;
  static const int topPercent = 45;
  static const int aheadOfPercent = 55;
  static const double pronunciationScore = 98;
  static const double pronunciation = 96;
  static const double fluency = 91;
  static const double rhythm = 91;
}

/// My page — Figma `screen/main_mypage` (Dark `3360:20181`, Light `3703:46474`).
///
/// The redesign turned this screen into an **analysis dashboard**: three cards
/// (억양 분석 · 종합 레벨 · 발음 분석) and nothing else. Everything that used to
/// live below them — Settings / Payment / Support, log out, delete account,
/// version — moved to [Routes.mypageSettings], reached from the gear that
/// replaced the old share icon in the header.
///
/// Sharing did not disappear with that icon: it moved *into* the accent card,
/// whose header now carries its own share button (Figma component
/// `Dialog-ShareProfile-new`, state=mypage → state=share).
class MyPageScreen extends ConsumerWidget {
  /// Creates the my-page screen.
  const MyPageScreen({super.key});

  /// Caption shared alongside the accent-card image (see [DialogShareProfile]).
  static const String _inviteText =
      "I'm learning Korean with Beavertalk — my Korean accent sounds "
      'American! 🦫 Come find your accent and learn with me: '
      'https://beavertalk.im';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Accent (nationality) breakdown from GET /members/me/profile. Empty until
    // it loads or when the member has no classification yet.
    final accentStats =
        ref.watch(myAccentProvider).valueOrNull?.stats ?? const <AccentStat>[];
    // Watched, not read on tap: `callListProvider` is autoDispose, so a bare
    // `ref.read` inside the button handler would find it uninitialised and the
    // 발음 학습하기 CTA would always take the records fallback. Watching it here
    // starts the fetch while the screen is open so the newest call id is ready.
    final recentCalls = ref.watch(callListProvider).valueOrNull?.items;

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.mypageSettings),
              icon: AppIcons.settings(color: context.c.labelStrong),
              tooltip: l10n.settingsSection,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s24,
                  AppSpacing.s20, AppSpacing.s24),
              children: [
                _accentCard(context, l10n, accentStats),
                const SizedBox(height: AppSpacing.s24),
                _levelCard(context, l10n),
                const SizedBox(height: AppSpacing.s24),
                _pronunciationCard(context, l10n, recentCalls),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Cards ──────────────────────────────────────────────────────────────

  /// 억양 분석 — the accent breakdown, with the share action in its header.
  ///
  /// The body (avatar → caption → top accent → one [ProgressBar] per stat) is
  /// the old profile card unchanged; the redesign only wrapped it in a titled
  /// header and moved sharing here from the app bar.
  Widget _accentCard(
    BuildContext context,
    AppLocalizations l10n,
    List<AccentStat> stats,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.accentAnalysis,
          subtitle: l10n.recentSessionsAverage,
          action: InkWell(
            onTap: () => showDialogShareProfile(
              context,
              imageProvider: beaverImage,
              caption: l10n.accentSoundsLike,
              title: stats.isEmpty ? '—' : stats.first.label,
              stats: [
                for (var i = 0; i < stats.length; i++)
                  ProfileStat(
                    label: stats[i].label,
                    value: stats[i].percent.toDouble(),
                    active: i == 0,
                  ),
              ],
              // The dialog rasterizes the accent card and shares it as a PNG;
              // this text rides along as the caption.
              shareText: _inviteText,
              onShared: () => Navigator.of(context).maybePop(),
            ),
            child: AppIcons.share(color: context.c.labelNormal),
          ),
        ),
        children: [
          Center(
            child: Container(
              width: AppSpacing.s80,
              height: AppSpacing.s80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.c.backgroundElevatedAlternative,
                image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
              ),
            ),
          ),
          Text(
            l10n.accentSoundsLike,
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: context.c.labelNormal),
          ),
          Text(
            stats.isEmpty ? '—' : stats.first.label,
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: context.c.labelStrong),
          ),
          for (var i = 0; i < stats.length; i++)
            ProgressBar(
              label: stats[i].label,
              value: stats[i].percent.toDouble(),
              active: i == 0,
            ),
        ],
      );

  /// 종합 레벨 — stage, percentile and the 1→13 gradient scale.
  Widget _levelCard(BuildContext context, AppLocalizations l10n) => _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.overallLevel,
          subtitle: l10n.overallLevelSubtitle,
        ),
        children: [
          // Both sides are flexible: at 320dp "Stage 7" + "Among all learners"
          // exceeds the 240pt card interior in the wordier locales. The stage
          // ellipsizes (it is short and numeric) and the caption wraps rather
          // than being cut, so no locale loses the sentence.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l10n.levelStage(_DesignSample.level),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppType.title2.b.copyWith(color: context.c.labelStrong),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.topPercent(_DesignSample.topPercent),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.title3.b
                          .copyWith(color: context.c.primaryNormal),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      l10n.allLearnersBasis,
                      textAlign: TextAlign.end,
                      style: AppType.body1.r
                          .copyWith(color: context.c.labelNormal),
                    ),
                  ],
                ),
              ),
            ],
          ),
          LevelProgress(
            level: _DesignSample.level,
            maxLevel: _DesignSample.levelMax,
            startLabel: l10n.levelStage(1),
            endLabel: l10n.levelStage(_DesignSample.levelMax),
          ),
          _aheadLine(context, l10n, _DesignSample.aheadOfPercent),
          Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.retakeLevelTest,
            onPressed: () => _startLevelTest(context),
          ),
        ],
      );

  /// 발음 분석 — the existing gauge component under a titled header.
  Widget _pronunciationCard(
    BuildContext context,
    AppLocalizations l10n,
    List<CallSummary>? recentCalls,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.pronunciationAnalysis,
          subtitle: l10n.recentSessionsAverage,
        ),
        children: [
          PronunciationResult(
            score: _DesignSample.pronunciationScore,
            metrics: [
              PronunciationMetric(
                  label: l10n.pronunciation,
                  value: '${_DesignSample.pronunciation.round()}%'),
              PronunciationMetric(
                  label: l10n.fluency,
                  value: '${_DesignSample.fluency.round()}%'),
              PronunciationMetric(
                  label: l10n.rhythm,
                  value: '${_DesignSample.rhythm.round()}%'),
            ],
          ),
          Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.practicePronunciation,
            onPressed: () => _openRecentAnalysis(context, recentCalls),
          ),
        ],
      );

  // ── Card chrome ────────────────────────────────────────────────────────

  /// The analysis-card shell — Figma `Dialog-ShareProfile` frame: radius 8,
  /// padding 20/20/24/20, `Background/Surface/Alternative`, 16 between rows.
  Widget _card(
    BuildContext context, {
    required Widget header,
    required List<Widget> children,
  }) =>
      Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20, AppSpacing.s20, AppSpacing.s20, AppSpacing.s24),
        decoration: BoxDecoration(
          color: context.c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs), // 8
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            header,
            for (final child in children) ...[
              const SizedBox(height: AppSpacing.s16),
              child,
            ],
          ],
        ),
      );

  /// Card header: `title` in `Primary/Heavy` SemiBold, `subtitle` in
  /// `Label/Normal` Regular, and an optional trailing [action] pushed to the
  /// far end (only the accent card has one).
  Widget _cardHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? action,
  }) =>
      Row(
        children: [
          // Expanded (not Flexible + Spacer): with both the text group and a
          // Spacer flexible, each would only get half the free width and the
          // titles would overflow at 320dp in the wordier locales.
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body1.sb
                        .copyWith(color: context.c.primaryHeavy),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Flexible(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppType.body1.r.copyWith(color: context.c.labelNormal),
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.s8),
            action,
          ],
        ],
      );

  /// "전체 학습자의 **55%**보다 앞서 있어요" — the percentage is emphasised in
  /// `Label/Strong` inside an otherwise `Label/Normal` sentence.
  ///
  /// The emphasis is applied by locating the formatted `NN%` token in the
  /// localized sentence; if a translation words it differently and the token is
  /// absent, the line renders flat rather than mis-splitting.
  Widget _aheadLine(BuildContext context, AppLocalizations l10n, int percent) {
    final sentence = l10n.aheadOfLearners(percent);
    final token = '$percent%';
    final base = AppType.label1.r.copyWith(color: context.c.labelNormal);
    final index = sentence.indexOf(token);
    if (index < 0) return Text(sentence, style: base);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: sentence.substring(0, index)),
          TextSpan(
            text: token,
            style: base.copyWith(color: context.c.labelStrong),
          ),
          TextSpan(text: sentence.substring(index + token.length)),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────

  /// 레벨 테스트 다시하기 → the call flow.
  ///
  /// There is no dedicated level-test screen: the app has one call entry point
  /// ([Routes.callLoading]) and the server decides whether a call counts as a
  /// level test. Onboarding's 바로 통화하기 goes to the same place.
  void _startLevelTest(BuildContext context) =>
      Navigator.pushNamed(context, Routes.callLoading);

  /// 발음 학습하기 → the most recent call's analysis.
  ///
  /// Figma points at `screen/analysis`, which in the app cannot be entered
  /// directly — it renders a `CallResult` handed to it by
  /// [Routes.analysisLoading], which in turn needs a `callId`. The id comes
  /// from [recentCalls]; with no calls yet (or the list still loading) this
  /// falls back to the records screen, where the same analysis is one tap away.
  ///
  /// **Not simply the newest call.** A call that was cut before anyone spoke
  /// lands in the list with `totalTime` 0 and never gets analysed, so aiming at
  /// `first` blindly drops the user on "분석 결과를 불러오지 못했어요" — observed on
  /// device. The newest call with a non-zero duration is the newest one that
  /// can actually have a result.
  void _openRecentAnalysis(
      BuildContext context, List<CallSummary>? recentCalls) {
    if (recentCalls == null || recentCalls.isEmpty) {
      Navigator.pushNamed(context, Routes.records);
      return;
    }
    final analysable = recentCalls
        .where((c) => (c.totalTime ?? 0) > 0)
        .firstOrNull;
    if (analysable == null) {
      Navigator.pushNamed(context, Routes.records);
      return;
    }
    Navigator.pushNamed(context, Routes.analysisLoading,
        arguments: analysable.callId);
  }
}
