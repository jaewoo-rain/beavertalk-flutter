import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/rating_button.dart';
import '../../core/error/app_exception.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Call finished — Figma `screen/call_finish` (`2117:19981`).
///
/// The wrap-up screen shown after a call ends: a "통화 종료" heading, the
/// [beaverImage] avatar, and a quick rating row (3 choices). Two pinned actions
/// close the flow — "대화 분석" (primary) submits the rating (best-effort) and
/// pushes [Routes.analysisLoading]; "홈으로" (secondary) → [Routes.home].
///
/// The server call id arrives as the route's `arguments` (`String?`, set by
/// [CallScreen]; the WS `call_ended` carries it as a string) and is parsed to an
/// int before being forwarded to the analysis-loading flow.
class CallFinishScreen extends ConsumerStatefulWidget {
  /// Creates the call-finished screen.
  const CallFinishScreen({super.key});

  @override
  ConsumerState<CallFinishScreen> createState() => _CallFinishScreenState();
}

/// The user's quick rating of the call, carrying the backend int value
/// (ascending): 아쉬워요=1, 괜찮아요=2, 좋아요=3.
enum _Rating {
  bad(1, '아쉬워요', Icons.sentiment_dissatisfied_outlined),
  ok(2, '괜찮아요', Icons.sentiment_neutral_outlined),
  good(3, '좋아요', Icons.sentiment_satisfied_alt_outlined);

  const _Rating(this.value, this.label, this.icon);

  /// Backend rating value sent in `PATCH /calls/{id}` `{"rating": value}`.
  final int value;

  /// Accessible / on-screen label.
  final String label;

  /// Glyph shown in the [RatingButton].
  final IconData icon;
}

class _CallFinishScreenState extends ConsumerState<CallFinishScreen> {
  /// Selected rating, or `null` until the user taps one.
  _Rating? _rating;

  /// Server call id from route arguments (string), parsed to int when valid.
  int? _callId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _callId = int.tryParse(args);
    } else if (args is int) {
      _callId = args;
    }
  }

  void _rate(_Rating r) => setState(() => _rating = r);

  /// Submits the rating (best-effort) then moves to the analysis-loading
  /// screen. Rating is optional: if none was picked, the PATCH is skipped.
  /// A failed rating never blocks navigation.
  Future<void> _analyze() async {
    final callId = _callId;
    final rating = _rating;

    if (callId != null && rating != null) {
      try {
        await ref
            .read(normalcallRepositoryProvider)
            .submitRating(callId, rating.value);
      } on AppException catch (e) {
        // Best-effort: surface but don't block the analysis flow.
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text('평가 전송 실패: ${e.message}')));
        }
      } catch (_) {
        // Swallow any other error — rating is non-critical.
      }
    }

    if (!mounted) return;
    if (callId == null) {
      // No valid call id → can't analyze; just go home.
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('통화 정보를 찾을 수 없어 분석을 건너뜁니다.')),
        );
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false);
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      Routes.analysisLoading,
      arguments: callId,
    );
  }

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
                      for (final r in _Rating.values) ...[
                        if (r != _Rating.values.first)
                          const SizedBox(width: 16),
                        RatingButton(
                          icon: r.icon,
                          selected: _rating == r,
                          onTap: () => _rate(r),
                          label: r.label,
                        ),
                      ],
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
                  onPressed: _analyze,
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
