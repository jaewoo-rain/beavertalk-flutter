import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/hero_avatar.dart';
import '../../components/organisms/bottom_nav_bar.dart';
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
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  /// Diameter of the hero beaver avatar (large circle).
  static const double _avatarSize = 200;

  @override
  Widget build(BuildContext context) {
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
                case 'call': // center → start a call
                  Navigator.pushNamed(context, Routes.callLoading);
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
