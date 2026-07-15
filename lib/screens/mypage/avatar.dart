import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/avatar_card.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/bottom_sheet_avatar.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Change avatar — Figma `screen/main_change_avatar` (`2117:20355`).
///
/// Three server-driven sections: owned partners ([ownedCharactersProvider]),
/// limited-time discounts and the buyable catalog (both from
/// [charactersProvider]). The representative (in-use) character comes from
/// `members/me.character_id` ([myProfileProvider]).
///
/// Buy buttons keep their sheet UI but purchase (POST) is **not** wired here.
class AvatarScreen extends ConsumerWidget {
  /// Creates the avatar screen.
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final charactersAsync = ref.watch(charactersProvider);
    final ownedAsync = ref.watch(ownedCharactersProvider);
    final profileAsync = ref.watch(myProfileProvider);

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: l10n.changeAvatar, onBack: () => Navigator.pop(context)),
          Expanded(
            child: charactersAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => _ErrorState(
                message: e is AppException ? e.message : l10n.charactersLoadError,
                onRetry: () {
                  ref.invalidate(charactersProvider);
                  ref.invalidate(ownedCharactersProvider);
                },
              ),
              data: (characters) {
                // The in-use character id (null when none chosen yet).
                final activeId = profileAsync.maybeWhen(
                  data: (Member m) => m.characterId,
                  orElse: () => null,
                );
                final owned = ownedAsync.maybeWhen(
                  data: (list) => list,
                  orElse: () => const <OwnedCharacter>[],
                );
                final discounted =
                    characters.where((c) => c.hasDiscount).toList();
                final buyable = characters
                    .where((c) => !c.isOwned && !c.hasDiscount)
                    .toList();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20, AppSpacing.s8, AppSpacing.s20, AppSpacing.s24),
                  children: [
                    Text(
                      l10n.avatarIntro,
                      style: AppType.body2.r
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    if (owned.isNotEmpty) ...[
                      _label(l10n.myPartnersOwned(owned.length)),
                      const SizedBox(height: AppSpacing.s12),
                      _ownedRow(context, owned, activeId),
                      const SizedBox(height: AppSpacing.s28),
                    ],
                    if (discounted.isNotEmpty) ...[
                      _label(l10n.limitedDiscount),
                      const SizedBox(height: AppSpacing.s12),
                      for (final c in discounted) ...[
                        _discountCard(context, c),
                        const SizedBox(height: AppSpacing.s12),
                      ],
                      const SizedBox(height: AppSpacing.s16),
                    ],
                    if (buyable.isNotEmpty) ...[
                      // Figma `2117:20381` / v2 `3360:20447`: "구매 가능".
                      // This used to reuse `l10n.available` ("이용 가능"), which
                      // reads as "you can use these" — so unowned, paid
                      // characters looked selectable. That key belongs to the
                      // sheet's status chip; the section needs its own.
                      _label(l10n.availableForPurchase),
                      const SizedBox(height: AppSpacing.s12),
                      for (final c in buyable) ...[
                        _buyableCard(context, c),
                        const SizedBox(height: AppSpacing.s12),
                      ],
                    ],
                    if (owned.isEmpty && discounted.isEmpty && buyable.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.s40),
                        child: Center(
                          child: Text(l10n.noCharactersToShow,
                              style: AppType.body2.r.copyWith(
                                  color: AppColors.textSecondary)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Owned partners as a row of up to three [AvatarCard]s.
  Widget _ownedRow(
    BuildContext context,
    List<OwnedCharacter> owned,
    int? activeId,
  ) {
    final l10n = AppLocalizations.of(context);
    // Figma `2117:20366`: a left-aligned flex row of intrinsic-width cards with
    // a 16px gap — NOT a 3-column grid. The old code wrapped each card in
    // `Expanded` and padded with empty `Expanded`s to three, which stretched
    // cards to a third of the screen and overflowed once a 4th was owned.
    //
    // Wrap (rather than Row) is identical to the design for the 1–3 cards it
    // depicts, and simply flows onto a second line beyond that instead of
    // throwing a layout overflow.
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s16,
      children: [
        for (final c in owned)
          Builder(
            builder: (context) {
              final isActive = activeId != null && c.id == activeId;
              final image = _imageFor(c.imageUrl, c.id);
              return AvatarCard(
                name: c.name,
                statusLabel: isActive ? l10n.inUse : l10n.owned,
                active: isActive,
                imageProvider: image,
                onTap: () => _openSheet(
                  context,
                  isActive
                      ? BottomSheetAvatarState.ownedUsed
                      : BottomSheetAvatarState.ownedUnused,
                  c.name,
                  image,
                  characterId: c.id,
                ),
              );
            },
          ),
      ],
    );
  }

  /// A discounted catalog character.
  Widget _discountCard(BuildContext context, Character c) {
    final image = _imageFor(c.imageUrl, c.id);
    return CardBox(
      type: CardBoxType.purchaseDiscount,
      avatar: BlurUpImage(image: image),
      title: c.name,
      subtitle: AppLocalizations.of(context).avatarTraits,
      price: _priceLabel(context, c.price),
      discountPrice: _priceLabel(context, c.effectivePrice),
      action: _buyButton(context, () => _openSheet(
            context,
            BottomSheetAvatarState.unownedDiscount,
            c.name,
            image,
            characterId: c.id,
            price: _priceLabel(context, c.price),
            discountPrice: _priceLabel(context, c.effectivePrice),
            discountPercent: _discountPercent(c),
          )),
    );
  }

  /// Whole-percent discount off list price, e.g. 4900 → 2450 = 50.
  ///
  /// The sheet cannot compute this itself — it receives prices as already
  /// formatted strings — so it is derived here from the raw int KRW fields.
  /// Returns null when there is nothing sensible to show (no discount, or a
  /// zero list price), and the sheet then omits the badge.
  int? _discountPercent(Character c) {
    if (!c.hasDiscount || c.price <= 0) return null;
    final off = ((c.price - c.effectivePrice) / c.price * 100).round();
    return off <= 0 ? null : off;
  }

  /// A full-price (or free) buyable catalog character.
  Widget _buyableCard(BuildContext context, Character c) {
    final image = _imageFor(c.imageUrl, c.id);
    return CardBox(
      type: CardBoxType.purchase,
      avatar: BlurUpImage(image: image),
      title: c.name,
      subtitle: AppLocalizations.of(context).avatarTraits,
      price: _priceLabel(context, c.price),
      action: _buyButton(context, () => _openSheet(
            context,
            BottomSheetAvatarState.unownedNormal,
            c.name,
            image,
            characterId: c.id,
            price: _priceLabel(context, c.price),
          )),
    );
  }

  /// Opens the avatar sheet. Purchase confirm is **not** wired — it just closes
  /// (there is no purchase/setActive method on CharacterRepository).
  ///
  /// [characterId] drives the description fetch: the paragraph in Figma v2
  /// `3360:20576` comes from `GET /characters/{id}`, which the list endpoint
  /// behind this screen does not include. It resolves after the sheet is up, so
  /// the paragraph fades in rather than blocking the sheet on a request.
  void _openSheet(
    BuildContext context,
    BottomSheetAvatarState state,
    String name,
    ImageProvider image, {
    required int characterId,
    String? price,
    String? discountPrice,
    int? discountPercent,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          // Detail is best-effort: on error/loading the sheet renders without
          // the paragraph instead of showing a spinner or an error over a
          // purchase flow.
          final detail = ref.watch(characterDetailProvider(characterId));
          return BottomSheetAvatar(
            state: state,
            name: name,
            imageProvider: image,
            // Tags are mock (server has no tags).
            tags: const ['Warm', 'Calm', 'Soft'],
            description: detail.valueOrNull?.description,
            price: price,
            discountPrice: discountPrice,
            discountPercent: discountPercent,
            onConfirm: () => Navigator.pop(ctx),
            onClose: () => Navigator.pop(ctx),
          ).asModal();
        },
      ),
    );
  }

  /// Formats integer KRW as "₩4,900"; 0 → "Free".
  String _priceLabel(BuildContext context, int krw) {
    if (krw <= 0) return AppLocalizations.of(context).priceFree;
    final digits = krw.toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '₩$buf';
  }

  /// Network avatar when available, else a static asset (alternating fallback).
  ImageProvider _imageFor(String? url, int id) {
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return id.isEven ? judiImage : beaverImage;
  }

  Widget _label(String text, {String? trailing}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    AppType.label1.m.copyWith(color: AppColors.textSecondary)),
          ),
          if (trailing != null)
            Flexible(
              child: Text(trailing,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppType.label1.m.copyWith(color: AppColors.error)),
            ),
        ],
      );

  Widget _buyButton(BuildContext context, VoidCallback onTap) => Button(
        type: BtnType.secondaryFill,
        size: BtnSize.s36,
        text: AppLocalizations.of(context).buy,
        onPressed: onTap,
      );
}

/// Inline error with a retry action.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: AppType.body2.r
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s12),
          TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry)),
        ],
      ),
    );
  }
}
