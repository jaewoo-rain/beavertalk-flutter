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
                      _label(l10n.available),
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
    final cards = <Widget>[];
    for (final c in owned) {
      final isActive = activeId != null && c.id == activeId;
      cards.add(
        Expanded(
          child: AvatarCard(
            name: c.name,
            statusLabel: isActive ? l10n.inUse : l10n.owned,
            active: isActive,
            imageProvider: _imageFor(c.imageUrl, c.id),
            onTap: () => _openSheet(
              context,
              isActive
                  ? BottomSheetAvatarState.ownedUsed
                  : BottomSheetAvatarState.ownedUnused,
              c.name,
              _imageFor(c.imageUrl, c.id),
            ),
          ),
        ),
      );
    }
    // Pad to a 3-column grid so cards keep their width.
    while (cards.length < 3) {
      cards.add(const Expanded(child: SizedBox()));
    }
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s12),
          cards[i],
        ],
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
      subtitle: 'Warm · Calm · Soft',
      price: _priceLabel(c.price),
      discountPrice: _priceLabel(c.effectivePrice),
      action: _buyButton(context, () => _openSheet(
            context,
            BottomSheetAvatarState.unownedDiscount,
            c.name,
            image,
            price: _priceLabel(c.price),
            discountPrice: _priceLabel(c.effectivePrice),
          )),
    );
  }

  /// A full-price (or free) buyable catalog character.
  Widget _buyableCard(BuildContext context, Character c) {
    final image = _imageFor(c.imageUrl, c.id);
    return CardBox(
      type: CardBoxType.purchase,
      avatar: BlurUpImage(image: image),
      title: c.name,
      subtitle: 'Warm · Calm · Soft',
      price: _priceLabel(c.price),
      action: _buyButton(context, () => _openSheet(
            context,
            BottomSheetAvatarState.unownedNormal,
            c.name,
            image,
            price: _priceLabel(c.price),
          )),
    );
  }

  /// Opens the avatar sheet. Purchase confirm is **not** wired — it just closes.
  void _openSheet(
    BuildContext context,
    BottomSheetAvatarState state,
    String name,
    ImageProvider image, {
    String? price,
    String? discountPrice,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => BottomSheetAvatar(
        state: state,
        name: name,
        imageProvider: image,
        // Tags are mock (server has no tags).
        tags: const ['Warm', 'Calm', 'Soft'],
        price: price,
        discountPrice: discountPrice,
        onConfirm: () => Navigator.pop(ctx),
        onClose: () => Navigator.pop(ctx),
      ).asModal(),
    );
  }

  /// Formats integer KRW as "₩4,900"; 0 → "Free".
  String _priceLabel(int krw) {
    if (krw <= 0) return 'Free';
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
          Text(text,
              style: AppType.label1.m.copyWith(color: AppColors.textSecondary)),
          if (trailing != null)
            Text(trailing,
                style: AppType.label1.m.copyWith(color: AppColors.error)),
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
