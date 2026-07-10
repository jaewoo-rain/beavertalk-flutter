import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/hero_avatar.dart';
import '../../components/organisms/bottom_nav_bar.dart';
import '../../core/config/feature_flags.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/incoming_call/presentation/incoming_call_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Home — the post-login landing screen. Figma `screen/home` (`2117:23988`).
///
/// Renders an [AppScaffold] over [AppColors.surface] with:
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
    final characterId =
        ref.read(myProfileProvider).valueOrNull?.characterId ?? 1;
    if (!context.mounted) return;
    Navigator.pushNamed(
      context,
      Routes.callLoading,
      arguments: characterId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      background: AppColors.surface,
      body: Stack(
        children: [
          _buildHome(context, ref),
          // TODO(dev): 로컬 테스트용 임시 트리거 — 제거 예정.
          // 디버그 빌드에서만 보이는 작은 버튼. 누르면 로컬로 "전화 오는 화면"을 띄운다
          // (푸시 대체). 이 Positioned 블록만 지우면 흔적 없이 제거된다.
          if (kDebugMode && kInboundCallEnabled && !kIsWeb)
            Positioned(
              left: AppSpacing.s16,
              bottom: 96,
              child: Semantics(
                button: true,
                label: '개발용 전화 수신 테스트',
                child: FloatingActionButton.small(
                  heroTag: 'dev-incoming-call',
                  backgroundColor: AppColors.primary,
                  onPressed: () => ref
                      .read(incomingCallCoordinatorProvider)
                      .simulateIncomingCall(),
                  child: const Icon(Icons.phone_callback),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 실제 홈 콘텐츠(헤더 + 히어로 + 하단 네비).
  Widget _buildHome(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.mypage),
                      // Figma `2296:26381` — a surface2 circle holding a muted
                      // (label/assistive) person, not a bare white glyph.
                      child: Container(
                        width: AppSpacing.s28,
                        height: AppSpacing.s28,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface2,
                        ),
                        child: AppIcons.profile(
                          size: 20,
                          color: AppColors.labelAssistive,
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
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.avatar),
                  child: HeroAvatar(
                    imageProvider: beaverImage,
                    size: _avatarSize,
                    onEditTap: () =>
                        Navigator.pushNamed(context, Routes.avatar),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  mockPartnerName,
                  // Figma `2296:26390` — Title 3 / Bold (24px), updated from 32.
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
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
