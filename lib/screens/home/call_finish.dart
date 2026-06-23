import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/rating_button.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Call finished — Figma `screen/call_finish` (`2117:19981`).
///
/// The wrap-up screen shown after a call ends: a "통화 종료" heading, the
/// [beaverImage] avatar, and a quick rating row (thumbs up / down). Two pinned
/// actions close the flow — "대화 분석" (primary) → [Routes.analysis] and
/// "홈으로" (secondary) → [Routes.home].
///
/// Stateful only to hold the locally-selected rating (mock; no backend).
class CallFinishScreen extends StatefulWidget {
  /// Creates the call-finished screen.
  const CallFinishScreen({super.key});

  @override
  State<CallFinishScreen> createState() => _CallFinishScreenState();
}

/// The user's quick rating of the call.
enum _Rating { up, down }

class _CallFinishScreenState extends State<CallFinishScreen> {
  /// Selected rating, or `null` until the user taps one.
  _Rating? _rating;

  void _rate(_Rating r) => setState(() => _rating = r);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.bg,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '통화 종료',
                    style: AppType.title3.b.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface2,
                      image: DecorationImage(
                        image: beaverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '이번 대화는 어땠나요?',
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingButton(
                        icon: Icons.thumb_up_alt_outlined,
                        selected: _rating == _Rating.up,
                        onTap: () => _rate(_Rating.up),
                        label: '좋아요',
                      ),
                      const SizedBox(width: 16),
                      RatingButton(
                        icon: Icons.thumb_down_alt_outlined,
                        selected: _rating == _Rating.down,
                        onTap: () => _rate(_Rating.down),
                        label: '아쉬워요',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Pinned actions — 대화 분석 (primary) / 홈으로 (secondary).
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: '대화 분석',
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.analysis),
                ),
                const SizedBox(height: 12),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: '홈으로',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                    (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
