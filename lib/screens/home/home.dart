import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/hero_avatar.dart';
import '../../components/organisms/bottom_nav_bar.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
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

  /// Diameter of the hero beaver avatar (large circle).
  static const double _avatarSize = 200;

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
      body: Column(
        children: [
          // Top bar — trailing person button → mypage.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.mypage),
                  icon: const Icon(Icons.person_outline),
                  color: AppColors.text,
                  iconSize: 28,
                  tooltip: '마이페이지',
                ),
              ],
            ),
          ),
          // Hero — avatar + change badge + title, centered.
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, Routes.avatar),
                    child: HeroAvatar(
                      imageProvider: beaverImage,
                      size: _avatarSize,
                      onEditTap: () =>
                          Navigator.pushNamed(context, Routes.avatar),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    mockPartnerName,
                    style: AppType.title2.b.copyWith(color: AppColors.text),
                  ),
                ],
              ),
            ),
          ),
          // Bottom navigation — call tab is the center action.
          BottomNavBar(
            items: const [
              BottomNavItem(
                key: 'calendar',
                icon: BottomNavGlyph.calendar,
                label: '달력',
              ),
              BottomNavItem(
                key: 'call',
                icon: BottomNavGlyph.call,
                label: '통화',
              ),
              BottomNavItem(
                key: 'history',
                icon: BottomNavGlyph.history,
                label: '통계',
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
      ),
    );
  }
}
