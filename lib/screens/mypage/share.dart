import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';

/// Share profile — Figma `screen/mypage__share` (`2329:4893`). The
/// [DialogShareProfile] card over a [Dim] scrim; tapping the scrim closes it.
class ShareScreen extends StatelessWidget {
  /// Creates the share screen.
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Stack(
        children: [
          Positioned.fill(child: Dim(onTap: () => Navigator.pop(context))),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DialogShareProfile(
                imageProvider: beaverImage,
                caption: 'Your Korean accent sounds',
                title: 'American',
                stats: const [
                  ProfileStat(label: 'American', value: 87),
                  ProfileStat(label: 'Korean', value: 7, active: false),
                  ProfileStat(label: 'China', value: 6, active: false),
                ],
                onShare: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
