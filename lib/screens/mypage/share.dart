import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';

/// Share profile — Figma `screen/mypage__share` (`2329:4893`). The
/// [DialogShareProfile] card over a [Dim] scrim; tapping the scrim closes it.
class ShareScreen extends StatelessWidget {
  /// Creates the share screen.
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Stack(
        children: [
          Positioned.fill(child: Dim(onTap: () => Navigator.pop(context))),
          Center(
            // 오버레이는 480 중앙 정렬(정본 규격).
            child: ContentColumn.narrow(
              child: DialogShareProfile(
                imageProvider: beaverImage,
                caption: l10n.accentSoundsLike,
                title: 'American',
                stats: const [
                  ProfileStat(label: 'American', value: 87),
                  ProfileStat(label: 'Korean', value: 7, active: false),
                  ProfileStat(label: 'China', value: 6, active: false),
                ],
                // Shares the rasterized accent card (PNG) + invite caption.
                shareText:
                    "I'm learning Korean with Beavertalk — my Korean accent "
                    'sounds American! 🦫 Come find your accent and learn with '
                    'me: https://beavertalk.im',
                onShared: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
