import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/avatar_card.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/bottom_sheet_avatar.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Change avatar — Figma `screen/main_change_avatar` (`2117:20355`).
///
/// Owned partners as a row of [AvatarCard]s, then a limited-time discount and a
/// "구매 가능" list, each a purchasable [CardBox]. Tapping a buy button opens the
/// matching [BottomSheetAvatar].
class AvatarScreen extends StatelessWidget {
  /// Creates the avatar screen.
  const AvatarScreen({super.key});

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
        tags: const ['Warm', 'Calm', 'Soft'],
        price: price,
        discountPrice: discountPrice,
        onConfirm: () => Navigator.pop(ctx),
        onClose: () => Navigator.pop(ctx),
      ).asModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '아바타 변경', onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text('통화 상대에 따라 목소리와 난이도가 상이합니다.\n일부 통화 상대 이용은 결제가 필요할 수 있습니다.',
                    style: AppType.body2.r
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                _label('나의 통화 상대 · 보유 2'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AvatarCard(
                        name: 'Beaver',
                        statusLabel: '사용 중',
                        active: true,
                        imageProvider: beaverImage,
                        onTap: () => _openSheet(context,
                            BottomSheetAvatarState.ownedUsed, 'Beaver', beaverImage),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AvatarCard(
                        name: 'Beaver',
                        statusLabel: '보유 중',
                        imageProvider: beaverImage,
                        onTap: () => _openSheet(context,
                            BottomSheetAvatarState.ownedUnused, 'Beaver', beaverImage),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 28),
                _label('한정 할인 중', trailing: '⏰ 16:54:23'),
                const SizedBox(height: 12),
                CardBox(
                  type: CardBoxType.purchaseDiscount,
                  avatar: const CircleAvatar(backgroundImage: judiImage),
                  title: 'Judi',
                  subtitle: 'Warm · Calm · Soft',
                  price: '10\$',
                  discountPrice: '5\$',
                  action: _buyButton(() => _openSheet(
                      context, BottomSheetAvatarState.unownedDiscount, 'Judi', judiImage,
                      price: '10\$', discountPrice: '5\$')),
                ),
                const SizedBox(height: 28),
                _label('구매 가능'),
                const SizedBox(height: 12),
                for (var i = 0; i < 2; i++) ...[
                  CardBox(
                    type: CardBoxType.purchase,
                    avatar: const CircleAvatar(backgroundImage: judiImage),
                    title: 'Judi',
                    subtitle: 'Warm · Calm · Soft',
                    price: '10\$',
                    action: _buyButton(() => _openSheet(context,
                        BottomSheetAvatarState.unownedNormal, 'Judi', judiImage,
                        price: '10\$')),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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
