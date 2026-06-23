import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
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
                  _BeaverAvatar(size: _avatarSize),
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
              if (key == 'call') {
                Navigator.pushNamed(context, Routes.callLoading);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// The circular beaver avatar with a small "change" badge at its bottom-right.
class _BeaverAvatar extends StatelessWidget {
  const _BeaverAvatar({required this.size});

  /// Avatar diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The avatar — large circle filled with the beaver image.
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface2,
              image: const DecorationImage(
                image: beaverImage,
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.primary24,
                  blurRadius: 40,
                ),
              ],
            ),
          ),
          // Change badge — primary pill with an edit glyph, pinned bottom-right.
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 3),
              ),
              child: const Icon(
                Icons.autorenew,
                size: 22,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
