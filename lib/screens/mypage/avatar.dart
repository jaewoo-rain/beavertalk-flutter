import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
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
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
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
    final charactersAsync = ref.watch(charactersProvider);
    final ownedAsync = ref.watch(ownedCharactersProvider);
    final profileAsync = ref.watch(myProfileProvider);

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '아바타 변경', onBack: () => Navigator.pop(context)),
          Expanded(
            child: charactersAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => _ErrorState(
                message: e is AppException ? e.message : '캐릭터를 불러오지 못했어요',
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
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text(
                      '통화 상대에 따라 목소리와 난이도가 상이합니다.\n'
                      '일부 통화 상대 이용은 결제가 필요할 수 있습니다.',
                      style: AppType.body2.r
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    if (owned.isNotEmpty) ...[
                      _label('나의 통화 상대 · 보유 ${owned.length}'),
                      const SizedBox(height: 12),
                      _ownedRow(context, owned, activeId),
                      const SizedBox(height: 28),
                    ],
                    if (discounted.isNotEmpty) ...[
                      _label('한정 할인 중'),
                      const SizedBox(height: 12),
                      for (final c in discounted) ...[
                        _discountCard(context, c),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 16),
                    ],
                    if (buyable.isNotEmpty) ...[
                      _label('구매 가능'),
                      const SizedBox(height: 12),
                      for (final c in buyable) ...[
                        _buyableCard(context, c),
                        const SizedBox(height: 12),
                      ],
                    ],
                    if (owned.isEmpty && discounted.isEmpty && buyable.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text('표시할 캐릭터가 없어요',
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
    final cards = <Widget>[];
    for (final c in owned) {
      final isActive = activeId != null && c.id == activeId;
      cards.add(
        Expanded(
          child: AvatarCard(
            name: c.name,
            statusLabel: isActive ? '사용 중' : '보유 중',
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
          if (i > 0) const SizedBox(width: 12),
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
      avatar: CircleAvatar(backgroundImage: image),
      title: c.name,
      subtitle: 'Warm · Calm · Soft',
      price: _priceLabel(c.price),
      discountPrice: _priceLabel(c.effectivePrice),
      action: _buyButton(() => _openSheet(
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
      avatar: CircleAvatar(backgroundImage: image),
      title: c.name,
      subtitle: 'Warm · Calm · Soft',
      price: _priceLabel(c.price),
      action: _buyButton(() => _openSheet(
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

  /// Formats integer KRW as "₩4,900"; 0 → "무료".
  String _priceLabel(int krw) {
    if (krw <= 0) return '무료';
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

  Widget _buyButton(VoidCallback onTap) => Button(
        type: BtnType.secondaryFill,
        size: BtnSize.s36,
        text: '구매',
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
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
