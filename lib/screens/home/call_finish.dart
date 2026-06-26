import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/icons/app_icons.dart';
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
  // Figma `2296:26278` shows 👎 / 👍 / 👍 (card 2·3 both thumbs-up — appears to
  // be a design placeholder; replicated 1:1 for now).
  bad(1, '아쉬워요', AppIcons.thumbsDown),
  ok(2, '괜찮아요', AppIcons.thumbsUp),
  good(3, '좋아요', AppIcons.thumbsUp);

  const _Rating(this.value, this.label, this.icon);

  /// Backend rating value sent in `PATCH /calls/{id}` `{"rating": value}`.
  final int value;

  /// Accessible label.
  final String label;

  /// Glyph builder shown in the rating card.
  final AppIconBuilder icon;
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
      background: AppColors.surface,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      // Figma `2296:26290` exact layout: 3 groups pinned at body-relative
      // y = 50 / 339 / 598 (left/right inset 20), not space-between, so the
      // gaps stay pixel-exact regardless of text metrics.
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            // Avatar + name + call duration.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface2,
                    image: DecorationImage(
                      image: beaverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  mockPartnerName,
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  // TODO(server): call duration not passed to this screen yet —
                  // placeholder. Wire when the API provides the call length.
                  '통화 종료 05:00',
                  style:
                      AppType.body1.r.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Positioned(
            top: 339,
            left: 20,
            right: 20,
            // Rating prompt + 3 rating cards.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '통화는 어떠셨나요?',
                  style: AppType.body1.r.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _ratingCard(_Rating.bad),
                    const SizedBox(width: 16),
                    _ratingCard(_Rating.ok),
                    const SizedBox(width: 16),
                    _ratingCard(_Rating.good),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 598,
            left: 20,
            right: 20,
            // Actions — 홈으로 (secondary) / 대화 분석 바로가기 (primary).
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 16),
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: '대화 분석 바로가기',
                  onPressed: _analyze,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// One rating choice rendered as a Figma card (`2296:26302`): a 112-tall
  /// rounded box with a 56px circular icon chip; selected → primary border +
  /// primary-10 chip + primary glyph, otherwise neutral.
  Widget _ratingCard(_Rating r) {
    final selected = _rating == r;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: r.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _rate(r),
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // radius/ml
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    selected ? AppColors.primary10 : AppColors.surfaceElevated,
              ),
              alignment: Alignment.center,
              child: r.icon(
                size: 24,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
