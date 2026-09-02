import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/pressable.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/hero_avatar.dart';
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

  /// Requests the mic permission, then enters the call flow with the member's
  /// representative character id (falling back to `1` / 비비). When permission is
  /// denied the call is blocked and the user is guided to settings/mic_denied.
  Future<void> _startCall(BuildContext context, WidgetRef ref) async {
    final status = await Permission.microphone.request();
    if (!context.mounted) return;
    if (!status.isGranted) {
      Navigator.pushNamed(context, Routes.permissionMicDenied);
      return;
    }
    if (!context.mounted) return;
    // 캐릭터는 서버가 정한다(member.character_id) — 인자를 싣지 않는다.
    Navigator.pushNamed(context, Routes.callLoading);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: 14),
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
                const SizedBox(height: 37),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: HomeworkHomeBanner(),
          ),
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
