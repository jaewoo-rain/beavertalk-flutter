import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../features/normalcall/domain/entities/call_channel.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/molecules/level_progress.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/domain/entities/accent_breakdown.dart';
import '../../features/auth/domain/entities/level_summary.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/domain/entities/pron_summary.dart';
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
/// 서버가 값을 못 줄 때 쓰는 표시 기본값.
///
/// 예전엔 여기 레벨 7·상위 45%·발음 98점 같은 **디자인 목업 숫자**가 들어 있었고
/// 화면이 그걸 그대로 그렸다 — 누구에게나 같은 가짜 수치가 보였다. 이제 값은 전부
/// 서버에서 오고, 여기 남은 건 서버가 굳이 내려줄 필요 없는 스케일 상한뿐이다.
/// (서버가 level_max 를 주면 그 값이 이긴다.)
abstract final class _Fallback {
  static const int levelMax = 13;
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
    // 종합 레벨(GET /members/me/profile) — 로딩 중/실패면 빈 카드로 그린다.
    // 여기서 에러 화면을 띄우지 않는 이유: 카드 3개가 각자 독립이라 하나가 실패해도
    // 나머지는 보여주는 편이 낫다.
    final level = ref.watch(myLevelProvider).valueOrNull;
    // 발음 최근 10세션 평균(GET /calls/pronunciation-summary).
    final pron = ref.watch(pronunciationSummaryProvider).valueOrNull;
    // 사용자가 고른 캐릭터의 실제 이미지. 카탈로그가 아직 안 왔거나 image_url 이
    // 비어 있으면 정적 비버로 폴백한다 — id→이미지 추측 매핑은 쓰지 않는다
    // (환경마다 character_id 가 달라 남의 얼굴이 뜬 전례가 있다).
    final charUrl = ref.watch(selectedCharacterProvider)?.imageUrl;
    final ImageProvider avatar =
        (charUrl != null && charUrl.isNotEmpty) ? NetworkImage(charUrl) : beaverImage;

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
                _accentCard(context, l10n, accentStats, avatar),
                const SizedBox(height: AppSpacing.s24),
                _levelCard(context, ref, l10n, level),
                const SizedBox(height: AppSpacing.s24),
                _pronunciationCard(context, l10n, pron, recentCalls),
                if (kDebugMode) ...[
                  const SizedBox(height: AppSpacing.s24),
                  _devToolsCard(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 개발자 도구 (디버그 빌드 전용) ──────────────────────────────────────

  /// 제품 플로우에서 도달할 수 없는 dev 화면들의 **유일한 진입점**.
  ///
  /// ⛔ `kDebugMode` 로만 그린다. 릴리즈 빌드에서는 이 카드가 트리에 아예 안 들어가고,
  ///   Dart 컴파일러가 `kDebugMode` 를 상수로 접어 코드째 제거한다. 실사용자가 닿을 수 없다.
  ///
  /// 마이페이지 스크롤 맨 아래에 둔 이유: 이미 아는 화면이라 찾기 쉽고, 끝까지 내려야
  /// 보이니 실수로 눌릴 일이 적다. **숨겨진 제스처(로고 롱프레스 같은 것)는 일부러 피했다** —
  /// 못 찾으면 없는 것과 같고, 그러면 측정이 통째로 막힌다.
  ///
  /// 여기 오기 전까지 `Routes.gallery` 는 라우트만 있고 도달할 UI 가 없어 사실상 죽어
  /// 있었다. dev 진입점을 새로 만드는 김에 같이 살렸다 — 다음 dev 도구도 갈 자리가 생긴다.
  Widget _devToolsCard(BuildContext context) => _card(
        context,
        header: _cardHeader(
          context,
          title: '개발자 도구',
          subtitle: '디버그 빌드에만 보입니다',
        ),
        children: [
          _devRow(
            context,
            title: '캐스케이드 통화 (테스트 서버)',
            description: '실험 통로입니다 — 소켓만 데모 서버로 붙고, 일반 통화(라이브)는 '
                '운영 서버 그대로입니다. '
                '⚠ 두 서버가 같은 DB 를 쓰므로 이 통화도 실서비스 데이터에 그대로 쌓입니다. '
                '통화 후 분석이 정상 동작하는지는 아직 확인되지 않았습니다.',
            route: Routes.callLoading,
            arguments: CallChannel.cascade,
          ),
          _devRow(
            context,
            title: '취소 배관 리그',
            description: '끼어들기(audio_cancel) 수신부터 소리가 실제로 멎기까지 몇 ms 걸리는지 '
                '반복 측정합니다. 서버 없이 클라 안에서 프레임을 주입합니다.',
            route: Routes.cancelRig,
          ),
          _devRow(
            context,
            title: '에코 측정 리그',
            description: '스피커폰·이어폰에서 비버 소리가 마이크로 얼마나 되돌아오는지 잽니다. '
                '서버 에코 임계값을 정하는 실측 도구입니다.',
            route: Routes.echoRig,
          ),
          _devRow(
            context,
            title: '컴포넌트 갤러리',
            description: '디자인 시스템 컴포넌트 미리보기.',
            route: Routes.gallery,
          ),
        ],
      );

  /// dev 도구 한 줄. 제목 + 무엇을 하는 화면인지 한 줄.
  ///
  /// 계측 도구 진입점이라 꾸밀 이유가 없다 — 눈에 띄고 뭔지 읽히면 그걸로 끝이다.
  Widget _devRow(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
    Object? arguments,
  }) =>
      InkWell(
        onTap: () =>
            Navigator.pushNamed(context, route, arguments: arguments),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded: 설명이 길어 두 줄 이상으로 접히므로 Row 안에서 폭을 받아야
              // 한다. 고정폭이나 double.infinity 를 쓰면 오버플로가 난다.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: AppType.body1.sb
                            .copyWith(color: context.c.labelStrong)),
                    const SizedBox(height: AppSpacing.s4),
                    Text(description,
                        style: AppType.label1.r
                            .copyWith(color: context.c.labelNormal)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s4),
                child: AppIcons.chevronRight(
                    size: 20, color: context.c.labelAssistive),
              ),
            ],
          ),
        ),
      );

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
    ImageProvider avatar,
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
              imageProvider: avatar,
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
        children: stats.isEmpty
            // `screen/main_mypage__null_all` (4849:8301): the header and its
            // share action stay, the body says why it is blank. The old shape
            // drew the avatar over a lone em dash, which reads as a value the
            // server returned rather than as "nothing yet".
            ? [
                EmptyBlock(
                  title: l10n.noAccentDataTitle,
                  body: l10n.noAccentDataBody,
                  scale: EmptyScale.card,
                ),
              ]
            : [
          Center(
            child: Container(
              width: AppSpacing.s80,
              height: AppSpacing.s80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.c.backgroundElevatedAlternative,
                image: DecorationImage(image: avatar, fit: BoxFit.cover),
              ),
            ),
          ),
          Text(
            l10n.accentSoundsLike,
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: context.c.labelNormal),
          ),
          Text(
            stats.first.label,
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
  Widget _levelCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    LevelSummary? level,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.overallLevel,
          subtitle: l10n.overallLevelSubtitle,
        ),
        children: level?.level == null
            // `screen/main_mypage__null_all` (4849:8307). The stage used to read
            // "—" with the rail drawn empty beneath it, which looks like a
            // level of zero rather than a level not taken yet. The CTA is
            // 레벨 테스트 **받기** here, not 다시하기 (§4-6) — a user who has
            // never tested cannot re-take.
            ? [
                EmptyBlock(
                  title: l10n.noLevelYetTitle,
                  body: l10n.noLevelYetBody,
                  ctaText: l10n.takeLevelTest,
                  onCta: () => _startLevelTest(context, ref),
                  ctaSize: BtnSize.s60,
                  // Matches the populated card's button — see its comment.
                  ctaType: BtnType.secondaryElevated,
                  scale: EmptyScale.card,
                ),
              ]
            : [
          // Both sides are flexible: at 320dp "Stage 7" + "Among all learners"
          // exceeds the 240pt card interior in the wordier locales. The stage
          // ellipsizes (it is short and numeric) and the caption wraps rather
          // than being cut, so no locale loses the sentence.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                // 레벨 미확정(레벨테스트 전)이면 숫자를 지어내지 않고 "—" 를 둔다.
                // 예전엔 목업 값 7 이 그대로 떠서 테스트도 안 본 사용자에게
                // "7단계" 가 보였다.
                child: Text(
                  level?.level == null
                      ? '—'
                      : l10n.levelStage(level!.level!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppType.title2.b.copyWith(color: context.c.labelStrong),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              // 상위 % 는 값이 있을 때만 — 없는 백분위를 0% 로 그리면 거짓이 된다.
              if (level?.topPercent != null)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.topPercent(level!.topPercent!),
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
            // level=null 이면 마커를 숨긴다(컴포넌트 계약) — 레일만 보인다.
            level: level?.level,
            maxLevel: level?.maxLevel ?? _Fallback.levelMax,
            startLabel: l10n.levelStage(1),
            endLabel: l10n.levelStage(level?.maxLevel ?? _Fallback.levelMax),
          ),
          if (level?.aheadOfPercent != null)
            _aheadLine(context, l10n, level!.aheadOfPercent!),
          Button(
            // Elevated, not Fill: the card is `Background/Surface/Alternative`,
            // which in Dark is the same #252932 that `secondaryFill` paints —
            // the button vanished into the card. Figma's button instance binds
            // `Background/Elevated/Normal` (#2F3340 dark / #F7F7FB light), one
            // step above the card, which is exactly `secondaryElevated`.
            type: BtnType.secondaryElevated,
            size: BtnSize.s60,
            text: l10n.retakeLevelTest,
            onPressed: () => _startLevelTest(context, ref),
          ),
        ],
      );

  /// 발음 분석 — the existing gauge component under a titled header.
  Widget _pronunciationCard(
    BuildContext context,
    AppLocalizations l10n,
    PronSummary? pron,
    List<CallSummary>? recentCalls,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.pronunciationAnalysis,
          subtitle: l10n.recentSessionsAverage,
        ),
        children: !(pron?.hasData ?? false)
            // `screen/main_mypage__null_all` (4849:8313) replaces the gauge
            // outright rather than showing it at `-%`. Note this supersedes the
            // work order's §4-5 line about a mypage gauge hint: the frame has
            // no gauge here to hang a hint on. The hint survives on analysis,
            // where the gauge does stay.
            ? [
                EmptyBlock(
                  title: l10n.noPronunciationDataTitle,
                  body: l10n.noPronunciationDataBody,
                  ctaText: l10n.practicePronunciation,
                  onCta: () => _openRecentAnalysis(context, recentCalls),
                  ctaSize: BtnSize.s60,
                  ctaType: BtnType.secondaryElevated,
                  scale: EmptyScale.card,
                ),
              ]
            : [
          // 최근 10세션 평균. 점수가 없으면(발음 챌린지를 아직 안 했거나 통화가
          // 없으면) inactive 상태로 게이지가 `-%` 를 그린다 — 0% 로 그리면
          // "0점을 받았다"로 읽혀서 없는 것과 나쁜 것이 구별되지 않는다.
          PronunciationResult(
            state: (pron?.hasData ?? false)
                ? PronunciationState.active
                : PronunciationState.inactive,
            score: pron?.totalScore ?? 0,
            metrics: [
              PronunciationMetric(
                  label: l10n.pronunciation, value: _pct(pron?.pronunciation)),
              PronunciationMetric(
                  label: l10n.fluency, value: _pct(pron?.fluency)),
              PronunciationMetric(
                  label: l10n.rhythm, value: _pct(pron?.rhythm)),
            ],
          ),
          Button(
            // Same reason as 레벨 테스트 다시하기 above — see that comment.
            type: BtnType.secondaryElevated,
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
  /// 레벨테스트 다시하기 — **서버에 요청한 뒤에** 통화 화면으로 넘어간다.
  ///
  /// 예전엔 그냥 통화 화면으로 밀기만 해서 일반 통화가 열렸다. 레벨 배정을 다시
  /// 받으려면 서버가 레벨을 비워야 다음 통화가 레벨테스트로 라우팅된다(D11).
  /// 학습 기록(체크판)은 지워지지 않는다 — 레벨만 다시 받는 것이다.
  ///
  /// 하루 1회 제한은 통화 시작 시점에 서버가 검사한다. 즉 이 요청이 성공해도
  /// 오늘 이미 레벨테스트를 했다면 통화 화면에서 DAILY_LIMIT 로 막힌다.
  /// ⚠ **실패하면 통화로 넘어가지 않는다.** 예전엔 예외를 삼키고 그대로 이동했는데,
  /// 서버에 이 API 가 아직 없던 동안(404) 레벨이 안 지워진 채 **일반 통화**가 열렸다.
  /// 사용자 눈에는 "레벨테스트를 눌렀는데 그냥 대화가 시작됨" 으로 보였고 원인이
  /// 드러나지 않았다. 조용한 폴백보다 명확한 실패가 낫다.
  Future<void> _startLevelTest(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(authRepositoryProvider).retakeLevelTest();
    } catch (e) {
      if (!context.mounted) return;
      final msg = e is AppException ? e.message : l10n.tryAgainLater;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
      return; // 레벨이 안 지워졌으므로 통화를 열면 일반 통화가 된다
    }
    // 카드가 "레벨 미확정" 으로 돌아가도록 다시 읽는다.
    ref.invalidate(myLevelProvider);
    if (!context.mounted) return;
    Navigator.pushNamed(context, Routes.callLoading);
  }

  /// 0~100 점수 → "96%". 값이 없으면 "-%" (0% 로 그리면 0점으로 읽힌다).
  static String _pct(double? v) => v == null ? '-%' : '${v.round()}%';

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
