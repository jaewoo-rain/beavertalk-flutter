import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../components/atoms/badge.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/subscription/domain/iap_service.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart' show placeholderAvatar;
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// Whether this build may sell the character bundle (PM-DEC-144).
///
/// Off by default. The store product `bt_character_bundle` exists on both
/// stores, but the server does not know it yet (§24): a bundle bought before
/// the server catalog ships would be charged and then refused at
/// `POST /purchases/verify` (404 `UNKNOWN_PRODUCT`), granting nothing. Turn it
/// on with `--dart-define=CHARACTER_BUNDLE=true` once the server is deployed.
const kCharacterBundleEnabled =
    bool.fromEnvironment('CHARACTER_BUNDLE', defaultValue: false);

/// What the bundle sheet shows — every figure from the store.
class CharacterBundleOffer {
  /// Creates an offer.
  const CharacterBundleOffer({
    required this.product,
    required this.characters,
    required this.original,
    required this.percent,
  });

  /// The store product (`bt_character_bundle`), carrying the local price.
  final IapProduct product;

  /// The paid characters in the bundle, in catalog order.
  final List<Character> characters;

  /// The three single prices added up, in the same store currency.
  final String original;

  /// Saving against [original], or null when there is none to show.
  final int? percent;
}

/// The bundle, when this member may be offered it — otherwise null.
///
/// Offered only (DEC-PR-05 · PM-DEC-142):
/// - when this build sells it ([kCharacterBundleEnabled]);
/// - to a member who owns **none** of the paid characters — owning is having
///   bought (`isOwned`), not a subscription unlock;
/// - when the store answers for the bundle **and** each single, in one
///   currency — the struck price is the singles added up. A store that does
///   not answer hides the offer rather than quoting a made-up price.
final characterBundleOfferProvider =
    FutureProvider.autoDispose<CharacterBundleOffer?>((ref) async {
  if (!kCharacterBundleEnabled) return null;
  final characters = await ref.watch(charactersProvider.future);
  return buildCharacterBundleOffer(
    characters: characters,
    iap: ref.watch(iapServiceProvider),
  );
});

/// The rules behind [characterBundleOfferProvider], without the build flag.
@visibleForTesting
Future<CharacterBundleOffer?> buildCharacterBundleOffer({
  required List<Character> characters,
  required IapService iap,
}) async {
  final sold = IapProductIds.soldCharacters;
  final paid = [
    for (final c in characters)
      if (sold.contains(IapProductIds.characterForKey(c.productKey, c.id))) c,
  ];
  if (paid.length != sold.length) return null;
  if (paid.any((c) => c.isOwned)) return null;
  final List<IapProduct> products;
  try {
    products =
        await iap.getProducts({IapProductIds.characterBundle, ...sold});
  } catch (_) {
    return null;
  }
  final byId = {for (final p in products) p.id: p};
  final bundle = byId[IapProductIds.characterBundle];
  if (bundle == null || bundle.rawPrice <= 0 || bundle.localizedPrice.isEmpty) {
    return null;
  }
  var total = 0.0;
  for (final id in sold) {
    final single = byId[id];
    if (single == null ||
        single.rawPrice <= 0 ||
        single.currencyCode != bundle.currencyCode) {
      return null;
    }
    total += single.rawPrice;
  }
  final saved = ((1 - bundle.rawPrice / total) * 100).round();
  return CharacterBundleOffer(
    product: bundle,
    characters: paid,
    original: NumberFormat.simpleCurrency(name: bundle.currencyCode)
        .format(total),
    percent: saved > 0 ? saved : null,
  );
}

/// `BottomSheet/CharacterBundle` (`6438:4772`) — trio · badge · title · names
/// · price, then `Maybe later` over `Buy`.
///
/// Resolves true when the member tapped Buy.
Future<bool> showCharacterBundleSheet(
    BuildContext context, CharacterBundleOffer offer) async {
  final bought = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.c.materialDim,
    isScrollControlled: true,
    builder: (sheetCtx) => CharacterBundleSheet(
      offer: offer,
      onBuy: () => Navigator.pop(sheetCtx, true),
      onLater: () => Navigator.pop(sheetCtx, false),
    ),
  );
  return bought ?? false;
}

/// The sheet body of [showCharacterBundleSheet] — public so the i18n layout
/// gates can draw it without a modal route.
class CharacterBundleSheet extends StatelessWidget {
  /// Creates the sheet.
  const CharacterBundleSheet({
    super.key,
    required this.offer,
    required this.onBuy,
    required this.onLater,
  });

  /// What to show.
  final CharacterBundleOffer offer;

  /// `Buy`.
  final VoidCallback onBuy;

  /// `Maybe later`.
  final VoidCallback onLater;

  @override
  Widget build(BuildContext sheetCtx) {
      final l10n = AppLocalizations.of(sheetCtx);
      final c = sheetCtx.c;
      return BottomSheetContent(
        title: l10n.bundleTitle,
        body: offer.characters.map((x) => x.name).join(' · '),
        hero: Column(
          children: [
            _Trio(characters: offer.characters),
            if (offer.percent != null) ...[
              const SizedBox(height: 16),
              Center(
                child: Badge(
                  tone: BadgeTone.gold,
                  label: l10n.bundleOffBadge(offer.percent!),
                ),
              ),
            ],
          ],
        ),
        secondaryOnTop: true,
        primaryAction: SheetAction(
            label: l10n.buy, onPressed: () => onBuy()),
        secondaryAction: SheetAction(
            label: l10n.ctaMaybeLater,
            onPressed: () => onLater()),
        childGap: 16,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(offer.product.localizedPrice,
                style: AppType.headline1.b.copyWith(color: c.labelStrong)),
            Text(offer.original,
                style: AppType.label1.r.copyWith(
                  color: c.labelAssistive,
                  decoration: TextDecoration.lineThrough,
                )),
          ],
        ),
      );
  }
}

/// `Trio` — three 84 avatars, 68 apart (16 overlap).
class _Trio extends StatelessWidget {
  const _Trio({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    const size = 84.0;
    const step = 68.0;
    return Center(
      child: SizedBox(
        width: size + step * (characters.length - 1),
        height: size,
        child: Stack(
          children: [
            for (var i = 0; i < characters.length; i++)
              Positioned(
                left: step * i,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: c.backgroundNormalNormal, width: 3),
                    image: DecorationImage(
                      image: _imageOf(characters[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

ImageProvider _imageOf(Character c) {
  final url = c.imageUrl;
  return (url != null && url.isNotEmpty) ? NetworkImage(url) : placeholderAvatar;
}
