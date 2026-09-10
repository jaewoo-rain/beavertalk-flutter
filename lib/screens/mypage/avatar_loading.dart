import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../components/atoms/skeleton.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// AvatarLoading — what `AvatarScreen` shows while the characters land, Figma
/// `screen/main_change_avatar_loading` (`3490:4126`).
///
/// The frame is not a separate screen: it is the real one with **only the
/// server's words** swapped for bars. So the intro paragraph and the 한정 할인 중
/// / 구매 가능 section labels are still real text here — they are static, and
/// blanking them would make the screen say less than it already knows.
///
/// The one label that *is* a bar is 나의 통화 상대: this app spells it
/// `myPartnersOwned` — "내 파트너 · {count}개 보유" — which bakes the count into the
/// string, so it cannot be shown without inventing a number. The frame splits
/// label from count and can keep the label; we cannot, and adding a second key
/// just to fill a 300ms gap is not worth a copy fork.
///
/// The quantities it draws (two owned, one discounted, two buyable) are the
/// frame's guess, not a claim: the response replaces the list wholesale.
///
/// Metrics come from [CardBox] itself (radius 8, padding 10, 64 avatar → 84
/// high), not from a second reading of the frame — a skeleton that measures the
/// design independently is exactly how `Card-Loading` ended up reserving 136 for
/// a 116 card.
class AvatarLoading extends StatelessWidget {
  /// Creates the change-avatar loading screen.
  const AvatarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SkeletonShimmer(
      child: ContentColumn(
        child: ListView(
          padding: const EdgeInsets.only(top: AppSpacing.s8, bottom: AppSpacing.s24),
          children: [
            Text(
              l10n.avatarIntro,
              style: AppType.body2.r.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s24),
            // 나의 통화 상대 · <count> (`3490:4133`, 131 wide all in).
            const SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Skeleton.bar(width: 131, height: 14),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            const _OwnedRow(),
            const SizedBox(height: AppSpacing.s28),
            _label(context, l10n.limitedDiscount),
            const SizedBox(height: AppSpacing.s12),
            const _CharacterCard(),
            const SizedBox(height: AppSpacing.s16),
            _label(context, l10n.availableForPurchase),
            const SizedBox(height: AppSpacing.s12),
            const _CharacterCard(),
            const SizedBox(height: AppSpacing.s12),
            const _CharacterCard(),
          ],
        ),
      ),
    );
  }

  /// The real screen's section label, same style — these are static strings, so
  /// they are not a promise about the response.
  Widget _label(BuildContext context, String text) => Text(
        text,
        style: AppType.label1.m.copyWith(color: context.c.labelNormal),
      );
}

/// Two 80×128 avatar slots at the real row's 16 gap (`3490:4137`).
class _OwnedRow extends StatelessWidget {
  const _OwnedRow();

  @override
  Widget build(BuildContext context) => const Wrap(
        spacing: AppSpacing.s16,
        runSpacing: AppSpacing.s16,
        children: [_AvatarSlot(), _AvatarSlot()],
      );
}

/// One `AvatarCard` slot (`3490:4403`): the 64 circle at the frame's y=32 over a
/// name bar. The 사용 중 / 보유 중 badge is deliberately absent — which badge a
/// slot carries is exactly what the response decides.
class _AvatarSlot extends StatelessWidget {
  const _AvatarSlot();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 80,
        height: 128,
        child: Column(
          children: [
            SizedBox(height: 32),
            Skeleton.circle(size: 64),
            SizedBox(height: 4),
            SizedBox(
              height: 20,
              child: Center(child: Skeleton.bar(width: 40, height: 14)),
            ),
          ],
        ),
      );
}

/// One `Card-Box` character row (`3490:4429`) at [CardBox]'s own box: radius 8,
/// 10 padding, a 64 avatar and 84 high. Inside, the frame's three lines — name
/// (29), tags (101) and price (46) — at y 0 / 24 / 44, plus the buy button's
/// 47×36 slot.
class _CharacterCard extends StatelessWidget {
  const _CharacterCard();

  @override
  Widget build(BuildContext context) => Container(
        height: 84,
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        padding: const EdgeInsets.all(10),
        child: const Row(
          children: [
            Skeleton.circle(size: 64),
            SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Skeleton.bar(width: 29, height: 14),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 16,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Skeleton.bar(width: 101, height: 14),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Skeleton.bar(width: 46, height: 14),
                    ),
                  ),
                ],
              ),
            ),
            Skeleton.box(width: 47, height: 36),
          ],
        ),
      );
}
