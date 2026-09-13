import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/pressable.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/hero_avatar.dart';
import '../../components/organisms/home_gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/normalcall/domain/entities/call_course.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../components/organisms/bottom_nav_bar.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../classroom/widgets/homework_home_banner.dart';

/// Home — the post-login landing screen. Figma `screen/home` (`2117:23988`).
///
/// Renders an [AppScaffold] over `Background/Normal/Normal` with:
/// - a top row holding a single trailing `person` [IconButton] that opens
///   [Routes.mypage],
/// - a centered hero: the large circular [beaverImage] avatar with a small
///   "change" badge pinned to its bottom-right, followed by the
///   [mockPartnerName] title ("Annoying Beaver"),
/// - a pinned [BottomNavBar] with three tabs (calendar / call (center) /
///   history). The center call tab starts active and navigates to
///   [Routes.callLoading].
class HomeScreen extends ConsumerWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  /// Diameter of the hero beaver avatar (Figma improved `2296:26379`).
  static const double _avatarSize = 120;

  /// Requests the mic permission, then enters the call flow. When permission is
  /// denied the call is blocked and the user is guided to settings/mic_denied.
  ///
  /// ⭐ **`auto` 코스로 건다**(사장님 결정 2026-09-13). 서버가 진도로 이번 통화의
  ///   코스(표현학습/프리토킹)를 정하고 `call_started.course` 로 알린다 — 위 학습 현황
  ///   블록이 그리는 «이번 통화»(`/cur/me`.`next_course`)와 **같은 판정**이다(서버가
  ///   그 필드를 «auto 로 걸면 정할 코스» 로 정의한다). 힌트 가림 등 코스별 UI 는
  ///   `call_started.course` 로 이미 갈린다.
  ///   ⛔ 여기만이다. 수신(알림) 통화·레벨테스트·숙제·기록 화면의 진입점은 종전 그대로
  ///     (`call_type` 미전송 = 서버 D11 라우팅).
  /// 캐릭터는 서버가 정한다(member.character_id) — 인자에 싣지 않는다.
  Future<void> _startCall(BuildContext context, WidgetRef ref) async {
    final status = await Permission.microphone.request();
    if (!context.mounted) return;
    if (!status.isGranted) {
      Navigator.pushNamed(context, Routes.permissionMicDenied);
      return;
    }
    if (!context.mounted) return;
    Navigator.pushNamed(
      context,
      Routes.callLoading,
      arguments: const CourseCallRequest(CallCourse.auto),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⭐ 통화가 끝나면 학습 현황을 **다시 읽는다.** 홈은 첫 라우트라 통화 내내 살아
    //   있고, [curMeProvider] 는 autoDispose 여도 홈이 붙들고 있어 안 버려진다 — 그러면
    //   통화로 진도가 바뀌어도 «이번 통화» 가 옛 값(예: 표현학습)을 그대로 보여 주고,
    //   다음 통화는 서버가 프리토킹으로 연다. 표시와 실제가 어긋나는 유일한 구멍이라
    //   여기서 막는다. 판정은 「통화 중이었다가 통화가 아니게 됐다」 한 가지다.
    ref.listen<CallPhase>(
      normalCallControllerProvider.select((s) => s.phase),
      (prev, next) {
        const live = {
          CallPhase.connecting,
          CallPhase.inCall,
          CallPhase.awaitingContinue,
          CallPhase.ending,
        };
        if (live.contains(prev) && !live.contains(next)) {
          ref.invalidate(curMeProvider);
        }
      },
    );
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: _buildHome(context, ref),
    );
  }

  /// 실제 홈 콘텐츠(헤더 + 히어로 + 하단 네비).
  Widget _buildHome(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Selected character (member `character_id`) drives the hero name + avatar.
    // Resolve the real catalog entry so the actual in-use character (e.g. Baba)
    // shows — never a hardcoded id→name guess.
    final selected = ref.watch(selectedCharacterProvider);
    final selectedUrl = selected?.imageUrl;
    final heroImage = (selectedUrl != null && selectedUrl.isNotEmpty)
        ? NetworkImage(selectedUrl) as ImageProvider
        : placeholderAvatar;
    // Loading until the **catalog** entry lands — not merely until the profile
    // does.
    //
    // The narrower `profile.isLoading && !profile.hasValue` left a real window
    // open: the profile can return while the catalog is still in flight, and in
    // that gap the screen fell back to the id-keyed mock — which showed a Baba
    // user Judi's face, and the name "Bibi". Both were confidently wrong for a
    // few hundred ms and then swapped. `selected == null` covers the whole
    // window, because `selected` is exactly "we know who the partner is".
    //
    // On failure `selected` stays null and this shimmers rather than resolving.
    // That is the intended trade: the previous behaviour asserted a partner the
    // user does not have.
    final heroLoading = selected == null;
    return Column(
      children: [
          // Header — GNB-style 56-tall bar, trailing profile icon → mypage.
          SizedBox(
            height: 56,
            child: ContentColumn(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Semantics(
                    button: true,
                    label: l10n.myPage,
                    child: Pressable(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.mypage),
                      // Figma `2296:26381` — a surface2 circle holding a muted
                      // (label/assistive) person, not a bare white glyph.
                      child: Container(
                        width: AppSpacing.s28,
                        height: AppSpacing.s28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.c.backgroundNormalAlternative,
                        ),
                        child: AppIcons.profile(
                          size: 20,
                          color: context.c.labelAssistive,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Hero — avatar + change badge + title, pinned near the top (Figma
          // body top 37), horizontally centered.
          Expanded(
            child: Column(
              children: [
                // 학습 현황 — Figma `Home/GNB`(`5925:26645`). 헤더 바로 아래
                // 붙고, 히어로와는 16 을 띄운다(정본 abs 100~192 · 히어로 208).
                //
                // 종전의 `SizedBox(height: 37)` 자리다. 그 37 은 히어로를 내리는
                // 여백일 뿐이었고, 이제 이 블록(92) + 간격 16 = 108 이 그 일을
                // 대신한다.
                //
                // 값은 서버가 준다 — `GET /cur/me`([curMeProvider]).
                //
                // ⛔ 아바타의 [heroLoading] 과 **겹치지 않는다.** 둘은 다른
                //   요청이라(캐릭터 카탈로그 vs 커리큘럼) 도착 시각이 다르고,
                //   하나로 묶으면 늦은 쪽이 빠른 쪽을 잡아 둔다.
                //
                // ★**404 는 실패가 아니다.** 커리큘럼이 아직 안 붙은 회원에게
                //   서버는 차시를 **안 주는 것**으로 답한다(실측 2026-09-12:
                //   레벨 Stage 1 인 계정이 `/cur/me` 에서 `NotFoundFailure`).
                //   그러니 그건 「레벨 미정」 변형 그대로다 — 빈 칸으로 두면
                //   커리큘럼 시작 전인 회원의 홈이 영영 비어 있게 된다.
                //
                // 그 밖의 실패는 **자리만 남기고 아무 말도 안 한다.** 셔머를 계속
                // 돌리면 「영영 안 끝나는 로딩」이 되고, 레벨미정으로 떨어뜨리면
                // 네트워크가 끊겼을 뿐인 사용자에게 레벨이 없다고 거짓말한다.
                // 높이를 유지하는 것은 아래 히어로가 안 튀게 하기 위해서다.
                ref.watch(curMeProvider).when(
                      loading: () => const HomeGnbSkeleton(),
                      error: (e, _) {
                        if (e is NotFoundFailure) {
                          return const HomeGnb(course: HomeCourse.noLevel);
                        }
                        // 조용히 삼키면 「블록이 왜 비었지」를 화면만 보고는
                        // 가릴 수 없다 — 이 화면에서 실제로 그 일을 겪었다.
                        debugPrint('홈 학습 현황 조회 실패 → 빈 칸: $e');
                        return const SizedBox(height: HomeGnb.height);
                      },
                      data: (me) => HomeGnb(course: HomeCourse.fromCurMe(me)),
                    ),
                const SizedBox(height: AppSpacing.s16),
                if (heroLoading)
                  // Same footprint as [HeroAvatar] so nothing shifts when the
                  // real image lands. Not tappable: there is nothing to change
                  // yet, and the avatar screen needs the profile anyway.
                  const SkeletonShimmer(
                    child: Skeleton.circle(size: _avatarSize),
                  )
                else
                  Pressable(
                    onTap: () => Navigator.pushNamed(context, Routes.avatar),
                    child: HeroAvatar(
                      imageProvider: heroImage,
                      size: _avatarSize,
                      onEditTap: () =>
                          Navigator.pushNamed(context, Routes.avatar),
                    ),
                  ),
                const SizedBox(height: AppSpacing.s16),
                // `skeleton/Annoying Beaver` (`3489:3919`) — the name is a
                // placeholder until the profile lands, because
                // [characterName] answers a null id with 'Bibi'. That is a
                // guess: a Baba user would read their partner as Bibi for as
                // long as the request takes, then watch it change. The box
                // keeps Title 3's 32 line-height so nothing shifts.
                SizedBox(
                  height: 32,
                  // Shares [heroLoading] with the avatar above so the two never
                  // disagree. The old `isLoading && !hasValue` released this
                  // the moment the profile returned, which is earlier than the
                  // catalog — and in that gap it printed "Bibi" to a Baba user.
                  child: heroLoading
                      ? const SkeletonShimmer(
                          child: Center(
                            child: Skeleton.bar(width: 170, height: 22),
                          ),
                        )
                      : Center(
                          child: Text(
                            // Non-null here by construction: [heroLoading] IS
                            // `selected == null`, so this branch only runs once
                            // the catalog entry is known. The old
                            // `?? characterName(id)` fallback is gone with it —
                            // that was the guess that printed "Bibi".
                            selected.name,
                            // Figma `2296:26390` — Title 3 / Bold (24px).
                            style:
                                AppType.title3.b.copyWith(color: context.c.labelStrong),
                          ),
                        ),
                ),
              ],
            ),
          ),
          // 숙제 진입 배너 — 하단 내비 바로 위(Figma `screen/main_home` y=588).
          // 급한 숙제가 없으면 스스로 사라진다.
          // ⛔ `Padding(horizontal: s20)` 이 아니라 [ContentColumn] 이다 — 같은 파일
          //   헤더(위 [ContentColumn])와 **같은 밴드**에 서야 한다. 고정 20 이면
          //   800dp 태블릿에서 헤더 100~700, 배너 20~780 으로 갈려 한 화면에 폭이
          //   세 개가 된다(하단 탭바는 또 375 캡이다).
          //   ⚠ 이 자리는 숙제 병합이 **새로 만든 블록**이라 충돌이 안 났고, 그래서
          //     폭 규칙 검열을 그냥 통과했다. 새 블록을 넣을 땐 밴드부터 확인하라.
          const ContentColumn(child: HomeworkHomeBanner()),
          const SizedBox(height: 18),
          // Bottom navigation — call tab is the center action.
          BottomNavBar(
            items: [
              BottomNavItem(
                key: 'calendar',
                icon: BottomNavGlyph.calendar,
                label: l10n.navCalendar,
              ),
              BottomNavItem(
                key: 'call',
                icon: BottomNavGlyph.call,
                label: l10n.navCall,
              ),
              BottomNavItem(
                key: 'history',
                icon: BottomNavGlyph.history,
                label: l10n.navStats,
              ),
            ],
            activeKey: 'call',
            onTap: (key) {
              switch (key) {
                case 'call': // center → start a call (mic permission first)
                  _startCall(context, ref);
                case 'calendar': // left → alarm settings (etc_alarm)
                  Navigator.pushNamed(context, Routes.alarms);
                case 'history': // right → conversation records (record_list)
                  Navigator.pushNamed(context, Routes.records);
              }
            },
          ),
        ],
    );
  }
}
