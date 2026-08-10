import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/avatar_card.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/bottom_sheet.dart';
import '../../components/organisms/bottom_sheet_content.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/data/character_copy_overrides.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../features/subscription/domain/iap_service.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/review/data/audio_player.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import 'avatar_detail.dart';
import 'avatar_loading.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';

/// Change avatar — Figma `screen/main_change_avatar` (`2117:20355`).
///
/// Three server-driven sections: owned partners ([ownedCharactersProvider]),
/// limited-time discounts and the buyable catalog (both from
/// [charactersProvider]). The representative (in-use) character comes from
/// `members/me.character_id` ([myProfileProvider]).
///
/// Tapping a card pushes [AvatarDetailScreen] (Figma `Avatar-Detail`
/// `4024:1090`), which replaced the former `BottomSheetAvatar` modal. Its
/// actions are live: 구매하기 → `POST /characters/{id}/purchase`,
/// Use This → `PATCH /members/me {character_id}`.
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
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(title: l10n.changeAvatar, onBack: () => Navigator.pop(context)),
          Expanded(
            child: charactersAsync.when(
              // `screen/main_change_avatar_loading` (3490:4126) — the list's
              // own shape held with bars, not a spinner in an empty screen, so
              // nothing jumps when the characters land.
              loading: () => const AvatarLoading(),
              error: (e, _) => NetworkErrorView(
                message: e is AppException && e.fromServer ? e.message : null,
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
                          .copyWith(color: context.c.labelNormal),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    if (owned.isNotEmpty) ...[
                      _label(context, l10n.myPartnersOwned(owned.length)),
                      const SizedBox(height: AppSpacing.s12),
                      _ownedRow(context, owned, activeId),
                      const SizedBox(height: AppSpacing.s28),
                    ],
                    if (discounted.isNotEmpty) ...[
                      // Figma: 섹션 헤더 우측에 마감 카운트다운(🕐 16:54:23).
                      // 할인이 여러 건이면 **가장 먼저 끝나는** 것을 보여준다 — 섹션 전체가
                      // "한정"인 이유가 그 마감이기 때문.
                      _label(
                        context,
                        l10n.limitedDiscount,
                        trailingWidget: _earliestDeadline(discounted) == null
                            ? null
                            : _DiscountCountdown(
                                endsAt: _earliestDeadline(discounted)!),
                      ),
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
                      _label(context, l10n.availableForPurchase),
                      const SizedBox(height: AppSpacing.s12),
                      for (final c in buyable) ...[
                        _buyableCard(context, c),
                        const SizedBox(height: AppSpacing.s12),
                      ],
                    ],
                    if (owned.isEmpty && discounted.isEmpty && buyable.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.s40),
                        child: EmptyBlock(body: l10n.noCharactersToShow),
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
                onTap: () => _openDetail(
                  context,
                  isActive
                      ? AvatarDetailState.ownedUsed
                      : AvatarDetailState.ownedUnused,
                  c.name,
                  image,
                  characterId: c.id,
                  description: c.description,
                  backgroundStory: c.backgroundStory,
                  voiceUrl: c.voiceUrl,
                  tags: c.tags,
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
      // Real server tags (`CharacterSummary.tags`), joined for CardBox which
      // splits on `·`. This was `l10n.avatarTraits` — the constant string
      // "Warm · Calm · Soft" shown for every character regardless of its
      // actual traits. Null when the character has no tags, so the row is
      // omitted rather than rendering an empty strip.
      subtitle: c.tags.isEmpty ? null : c.tags.join('·'),
      price: _priceLabel(context, c.price),
      discountPrice: _priceLabel(context, c.effectivePrice),
      action: _buyButton(context, () => _openDetail(
            context,
            AvatarDetailState.unownedDiscount,
            c.name,
            image,
            characterId: c.id,
            productKey: c.productKey,
            description: c.description,
            backgroundStory: c.backgroundStory,
            voiceUrl: c.voiceUrl,
            tags: c.tags,
            price: _priceLabel(context, c.price),
            discountPrice: _priceLabel(context, c.effectivePrice),
            discountPercent: _discountPercent(c),
            effectivePriceMinor: c.effectivePrice,
          )),
    );
  }

  /// 할인 중인 캐릭터들 중 **가장 먼저 끝나는** 마감 시각. 마감이 하나도 없으면 null
  /// (= 서버가 active_discount 를 안 내려준 경우 — 카운트다운을 생략한다).
  DateTime? _earliestDeadline(List<Character> discounted) {
    DateTime? best;
    for (final c in discounted) {
      final e = c.discountEndsAt;
      if (e == null) continue;
      if (best == null || e.isBefore(best)) best = e;
    }
    return best;
  }

  /// Whole-percent discount off list price, e.g. 1000¢ → 500¢ = 50.
  ///
  /// The sheet cannot compute this itself — it receives prices as already
  /// formatted strings — so it is derived here from the raw cent fields.
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
      // Real server tags (`CharacterSummary.tags`), joined for CardBox which
      // splits on `·`. This was `l10n.avatarTraits` — the constant string
      // "Warm · Calm · Soft" shown for every character regardless of its
      // actual traits. Null when the character has no tags, so the row is
      // omitted rather than rendering an empty strip.
      subtitle: c.tags.isEmpty ? null : c.tags.join('·'),
      price: _catalogPrice(context, c),
      action: _buyButton(context, () => _openDetail(
            context,
            AvatarDetailState.unownedNormal,
            c.name,
            image,
            characterId: c.id,
            productKey: c.productKey,
            description: c.description,
            backgroundStory: c.backgroundStory,
            voiceUrl: c.voiceUrl,
            tags: c.tags,
            price: _catalogPrice(context, c),
            // Null for a free character: there is no amount to report back to
            // the server, and reporting 0 against a stale catalog price is how
            // a price-mismatch rejection would appear out of nowhere.
            effectivePriceMinor: _isFree(c) ? null : c.effectivePrice,
          )),
    );
  }

  /// Pushes the avatar detail screen, wired to the server.
  ///
  /// The confirm button means different things per state:
  /// - `unownedNormal` / `unownedDiscount` → 구매하기 → `POST /characters/{id}/purchase`
  /// - `ownedUnused` → Use This → `PATCH /members/me {character_id}`
  /// - `ownedUsed` → 닫기 only (already in use)
  ///
  /// [description]/[backgroundStory]/[voiceUrl]/[tags] come straight from the
  /// list response. The server puts them on `CharacterSummary` (and
  /// `OwnedCharacterOut`) precisely so a card can render without a
  /// per-character detail fetch — its schema docstring calls out the N+1 this
  /// avoids. An earlier revision here fetched `GET /characters/{id}` on every
  /// open for a description it already had; that request is gone.
  ///
  /// This used to be a `showModalBottomSheet` holding `BottomSheetAvatar`
  /// (375×487). Figma replaced that sheet with the full-page `Avatar-Detail`
  /// (`4024:1090`), so it is now a pushed route — the hero image needs the whole
  /// screen, which a bottom sheet cannot give it.
  void _openDetail(
    BuildContext context,
    AvatarDetailState state,
    String name,
    ImageProvider image, {
    required int characterId,
    // 스토어 상품 ID 슬러그. character_id 는 dev/prod 가 달라 결제에 쓸 수 없다.
    // 이미 보유한 캐릭터는 구매 경로(_purchase)를 타지 않으므로 넘기지 않는다 —
    // 그 화면의 액션은 '사용하기'뿐이다. 빈 값이 결제로 새면 _purchase 가 막는다.
    String productKey = '',
    String? description,
    String? backgroundStory,
    String? voiceUrl,
    List<String> tags = const [],
    String? price,
    String? discountPrice,
    int? discountPercent,
    // 화면에 실제로 보여준 가격(센트). 구매 시 서버에 신고해 금액 불일치를 막는다.
    int? effectivePriceMinor,
  }) {
    // Read from the pushing context: the route's own context is not built yet,
    // and the locale is the same either way.
    final locale = Localizations.localeOf(context).toString();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeCtx) => Consumer(
          builder: (routeCtx, ref, _) => _AvatarDetailRoute(
            state: state,
            name: name,
            imageProvider: image,
            tags: tags,
            // Two distinct server columns, two distinct slots: `description` is
            // the one-line catch-phrase, `background_story` the story
            // paragraph. Both used to collapse into the story slot — the
            // catch-phrase rendered there and the story was never fetched.
            //
            // Both go through the localized-copy override first: the server
            // stores these as Korean-only columns, so without this a German
            // user reads Korean prose. The server value is the fallback, so an
            // unmapped character still renders. Delete the override layer once
            // the server serves `character_i18n`.
            summary: characterSummaryFor(characterId, locale, description),
            description: characterStoryFor(characterId, locale, backgroundStory),
            voiceUrl: voiceUrl,
            price: price,
            discountPrice: discountPrice,
            discountPercent: discountPercent,
            onConfirm: switch (state) {
              AvatarDetailState.unownedNormal ||
              AvatarDetailState.unownedDiscount =>
                () => _purchase(
                    routeCtx, ref, characterId, productKey, effectivePriceMinor),
              AvatarDetailState.ownedUnused => () =>
                  _useCharacter(routeCtx, ref, characterId),
              // Already in use — the screen shows a single 닫기 footer.
              AvatarDetailState.ownedUsed => () => Navigator.pop(routeCtx),
            },
            onClose: () => Navigator.pop(routeCtx),
          ),
        ),
      ),
    );
  }

  /// Character purchase — IAP rail first, then server delivery.
  ///
  /// v2 §2-3: characters are **non-consumable IAP**. The (mock) store sheet
  /// decides the outcome on the [IapService] purchase stream; only a
  /// `purchased`/`restored` verdict reaches the server call below, which
  /// stands in for receipt validation until the real SDK lands (R1 — the
  /// server side travels by proposal). Outcome feedback, previously missing:
  /// success = result sheet, store failure = snackbar, user cancel = silence.
  ///
  /// [expectedMinor] 는 화면이 보여준 가격(센트)이다. 한정 할인이 탭과 서버 처리 사이에
  /// 끝나면 서버가 [PriceChangedFailure] 로 거절하므로, 사용자가 동의하지 않은 금액이
  /// 결제되는 일이 없다. 그때는 새 가격으로 다시 확인을 받는다.
  Future<void> _purchase(BuildContext routeCtx, WidgetRef ref, int id,
      String productKey, [int? expectedMinor]) async {
    final l10n = AppLocalizations.of(routeCtx);
    final iap = ref.read(iapServiceProvider);
    // Free characters never reach the store. There is no product to charge
    // for, so acquiring one is a server record and nothing else — routing
    // them through the store would only look for an id that was deliberately
    // never registered.
    if (IapProductIds.isFreeCharacter(id) || expectedMinor == 0) {
      await _deliver(routeCtx, ref, id, productKey, expectedMinor);
      return;
    }
    // Store products are keyed by slug, not by the server's primary key
    // (design doc §4-5).
    //
    // The server's own `product_key` wins whenever it sent one: the local
    // id→slug table is prod-numbered, so off prod it resolves to a *different*
    // character than the one on screen. The table is the fallback for servers
    // predating that field. Neither available means no registered store
    // product either, so there is nothing to buy — say so instead of sending
    // the store an id it has never seen.
    final productId = productKey.isNotEmpty
        ? IapProductIds.character(productKey)
        : IapProductIds.characterFor(id);
    if (productId == null) {
      ScaffoldMessenger.of(routeCtx)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.iapCharacterFailedBody)));
      return;
    }
    final product = IapProduct(
      id: productId,
      type: IapProductType.nonConsumable,
      // Store-localized in production (v2 §6-4: the store is the price
      // authority); until then the server-fed screen price stands in.
      localizedPrice:
          expectedMinor == null ? '' : _priceLabel(routeCtx, expectedMinor),
    );
    // Subscribe before firing — the mock resolves synchronously and a late
    // listener would miss the verdict.
    final verdictFuture = iap.purchases.firstWhere((p) =>
        p.productId == product.id && p.state != IapPurchaseState.pending);
    await iap.purchase(product);
    final verdict = await verdictFuture;
    switch (verdict.state) {
      case IapPurchaseState.canceled:
        // The member closed the store sheet — their call, no lecture.
        return;
      case IapPurchaseState.failed:
        if (routeCtx.mounted) {
          ScaffoldMessenger.of(routeCtx)
            ..clearSnackBars()
            ..showSnackBar(
                SnackBar(content: Text(l10n.iapCharacterFailedBody)));
        }
        return;
      case IapPurchaseState.pending:
      case IapPurchaseState.purchased:
      case IapPurchaseState.restored:
        break; // paid — deliver below.
    }
    // The store sheet was an async gap; the route may be gone.
    if (!routeCtx.mounted) return;
    await _deliver(routeCtx, ref, id, productKey, expectedMinor,
        verdict: verdict);
  }

  /// Records the acquisition on the server and closes the flow.
  ///
  /// Two callers, one delivery: the paid path runs it once the store says the
  /// money moved, the free path runs it directly because no money ever moves.
  /// Keeping it in one place is what stops the free path from quietly missing
  /// the cache invalidation or the success sheet.
  ///
  /// [verdict] is the store's answer, and is null exactly when no store was
  /// involved — a free character. That is why the receipt branch below is
  /// guarded on it rather than on [IapPurchase.hasReceipt] alone: a free
  /// acquisition has no receipt to verify and must take the server-record
  /// path, not be mistaken for an unverifiable paid one.
  ///
  /// [productKey] only travels so the price-changed retry can re-enter
  /// [_purchase] with the same slug it started from.
  Future<void> _deliver(
    BuildContext routeCtx,
    WidgetRef ref,
    int id,
    String productKey,
    int? expectedMinor, {
    IapPurchase? verdict,
  }) async {
    try {
      if (verdict != null && verdict.hasReceipt) {
        // 실영수증이 있다 → **서버가 스토어에 확인**하고 소유권을 준다. 앱 말만 믿고
        // 지급하면 "샀다"고 주장하는 요청으로 결제를 우회할 수 있다.
        // 같은 영수증이 여러 번 와도 서버가 멱등 처리한다(already_granted 도 성공).
        await ref.read(purchasesRemoteDataSourceProvider).verify(verdict);
      } else {
        // 목 레일 — 스토어 거래가 없어 검증할 영수증이 없다. 실 SDK 가 붙기 전까지는
        // 기존 전달 경로를 그대로 쓴다(가격 확인 포함).
        await ref
            .read(characterRepositoryProvider)
            .purchase(id, expectedPriceMinor: expectedMinor);
      }
      // The catalog's `is_owned` flips, the owned list gains a row, and the
      // server writes a payment in the same transaction — so the history is
      // stale too.
      ref.invalidate(charactersProvider);
      ref.invalidate(ownedCharactersProvider);
      ref.invalidate(paymentPageProvider);
      if (!routeCtx.mounted) return;
      // The detail route is about to pop — grab a context that survives it.
      final navCtx = Navigator.of(routeCtx, rootNavigator: true).context;
      Navigator.pop(routeCtx);
      _showPurchaseSuccessSheet(navCtx);
    } on PriceChangedFailure catch (e) {
      // 가격이 바뀌었다 — 목록을 새로 받아 화면을 실제 가격으로 되돌리고, 사용자에게
      // 새 가격으로 살지 다시 묻는다. 확인하면 그 가격으로 재요청한다.
      ref.invalidate(charactersProvider);
      if (!routeCtx.mounted) return;
      final l10n = AppLocalizations.of(routeCtx);
      final ok = await showDialogBasic<bool>(
        routeCtx,
        title: l10n.priceChangedTitle,
        description: l10n.priceChangedBody(_priceLabel(routeCtx, e.actualPrice)),
        primary: DialogAction(
          label: l10n.buy,
          onPressed: () => Navigator.pop(routeCtx, true),
        ),
        secondary: DialogAction(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(routeCtx, false),
        ),
      );
      if (ok == true && routeCtx.mounted) {
        await _purchase(routeCtx, ref, id, productKey, e.actualPrice);
      }
    } catch (e) {
      if (routeCtx.mounted) _reportDetailError(routeCtx, e);
    }
  }

  /// `iap_result` success sheet, shown over the character list after the
  /// detail route pops (v2 §4-4: character purchase feedback rides the
  /// existing screen — a sheet, not a dedicated result screen).
  void _showPurchaseSuccessSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      isScrollControlled: true,
      builder: (sheetCtx) => BottomSheetContent(
        title: l10n.iapCharacterSuccessTitle,
        body: l10n.iapCharacterSuccessBody,
        mark: SheetMarkTone.success,
        primaryAction: SheetAction(
          label: l10n.ctaContinue,
          onPressed: () => Navigator.pop(sheetCtx),
        ),
      ),
    );
  }

  /// `PATCH /members/me {character_id}` — makes [id] the in-use partner.
  Future<void> _useCharacter(
      BuildContext routeCtx, WidgetRef ref, int id) async {
    try {
      await ref.read(authRepositoryProvider).updateCharacter(id);
      // The active id is read from the profile, which drives the 사용 중 badge
      // and the home hero.
      ref.invalidate(myProfileProvider);
      if (routeCtx.mounted) Navigator.pop(routeCtx);
    } catch (e) {
      if (routeCtx.mounted) _reportDetailError(routeCtx, e);
    }
  }

  /// Pops the detail route and surfaces [e] — the messenger is captured before
  /// the pop, because after it the route's own context is dead.
  void _reportDetailError(BuildContext routeCtx, Object e) {
    final messenger = ScaffoldMessenger.maybeOf(routeCtx);
    final message = e is AppException ? e.message : null;
    if (routeCtx.mounted) Navigator.pop(routeCtx);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(content: Text(message ?? 'Something went wrong')),
    );
  }

  /// Formats USD cents as "$10"; 0 → "Free".
  ///
  /// "Free" is a *product* label, so it belongs here (a zero-priced character)
  /// and not in the shared [formatUsd], which renders 0 as "$0" for amounts
  /// like a month with no charges.
  String _priceLabel(BuildContext context, int minor) {
    if (minor <= 0) return AppLocalizations.of(context).priceFree;
    return formatUsd(minor, locale: Localizations.localeOf(context).toString());
  }

  /// Whether [c] costs nothing — either the server says so, or it is one of
  /// the characters the Free plan includes (Baba·Bibi, 대표 결정 2026-08-04).
  ///
  /// The client-side half of the test is deliberate: the catalog still ships a
  /// price for those two until the server drops it (서버 제안 별건), and until
  /// then the screen would offer to sell something that has no store product.
  bool _isFree(Character c) =>
      c.isFree || IapProductIds.isFreeCharacter(c.id);

  /// The price a catalog card shows — `Free` for the included characters.
  String _catalogPrice(BuildContext context, Character c) => _isFree(c)
      ? AppLocalizations.of(context).priceFree
      : _priceLabel(context, c.price);

  /// Network avatar when available, else a neutral placeholder.
  ///
  /// The fallback used to alternate on `id.isEven` between the beaver and
  /// **Judi** — a character the catalog no longer carries. On this screen that
  /// is doubly wrong: it is a list of characters to buy, so a stand-in face
  /// reads as "this is what BIBI looks like". One neutral image for all of them
  /// at least does not misattribute.
  ImageProvider _imageFor(String? url, int id) {
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return placeholderAvatar;
  }

  Widget _label(BuildContext context, String text,
          {String? trailing, Widget? trailingWidget}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    AppType.label1.m.copyWith(color: context.c.labelNormal)),
          ),
          if (trailingWidget != null)
            trailingWidget
          else if (trailing != null)
            Flexible(
              child: Text(trailing,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppType.label1.m.copyWith(color: context.c.accentForegroundRed)),
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

/// Route host for [AvatarDetailScreen] that owns the sample-voice player.
///
/// [AvatarDetailScreen] is presentation-only (every action is a callback), so
/// the player cannot live there — something has to outlive a single build and
/// be disposed when the route pops. This widget is that owner: it holds one
/// [ReviewAudioPlayer] for the life of the detail route and releases it in
/// [dispose], the same pattern `analysis.dart` and `record_list.dart` use.
///
/// When [voiceUrl] is null or unplayable the sample card is left inert
/// (`onPlaySample: null`) rather than showing a card that fails on tap.
class _AvatarDetailRoute extends StatefulWidget {
  const _AvatarDetailRoute({
    required this.state,
    required this.name,
    required this.imageProvider,
    required this.tags,
    required this.summary,
    required this.description,
    required this.voiceUrl,
    required this.price,
    required this.discountPrice,
    required this.discountPercent,
    required this.onConfirm,
    required this.onClose,
  });

  final AvatarDetailState state;
  final String name;
  final ImageProvider imageProvider;
  final List<String> tags;
  final String? summary;
  final String? description;
  final String? voiceUrl;
  final String? price;
  final String? discountPrice;
  final int? discountPercent;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  @override
  State<_AvatarDetailRoute> createState() => _AvatarDetailRouteState();
}

class _AvatarDetailRouteState extends State<_AvatarDetailRoute> {
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  /// True only for a URL the player can actually open — the same guard
  /// `analysis.dart` applies before handing a server string to the player.
  bool get _playable {
    final url = widget.voiceUrl;
    return url != null && url.isNotEmpty && url.startsWith('http');
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSample() async {
    try {
      await _player.playUrl(widget.voiceUrl!);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).somethingWentWrong),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AvatarDetailScreen(
      state: widget.state,
      name: widget.name,
      imageProvider: widget.imageProvider,
      tags: widget.tags,
      summary: widget.summary,
      description: widget.description,
      price: widget.price,
      discountPrice: widget.discountPrice,
      discountPercent: widget.discountPercent,
      onConfirm: widget.onConfirm,
      onClose: widget.onClose,
      onPlaySample: _playable ? _playSample : null,
    );
  }
}

/// 한정 할인 마감까지 남은 시간 — 섹션 헤더 우측에 `🕐 16:54:23` 로 초 단위 표시.
///
/// 자체 [Timer] 로 1초마다 자기만 다시 그린다(화면 전체 rebuild 아님). 마감에 닿으면
/// [charactersProvider] 를 무효화해 목록을 다시 받는다 — 서버가 그때부터
/// `effective_price == price` 를 주므로 할인 섹션이 스스로 사라진다. 클라가 가격을
/// 자체 판단하지 않고 **서버 응답만 믿는** 구조를 유지하려는 것.
class _DiscountCountdown extends ConsumerStatefulWidget {
  const _DiscountCountdown({required this.endsAt});

  final DateTime endsAt;

  @override
  ConsumerState<_DiscountCountdown> createState() => _DiscountCountdownState();
}

class _DiscountCountdownState extends ConsumerState<_DiscountCountdown> {
  Timer? _timer;
  late Duration _left;
  bool _expiredHandled = false;

  @override
  void initState() {
    super.initState();
    _left = widget.endsAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void didUpdateWidget(covariant _DiscountCountdown old) {
    super.didUpdateWidget(old);
    if (old.endsAt != widget.endsAt) {
      _expiredHandled = false;
      _tick();
    }
  }

  void _tick() {
    if (!mounted) return;
    final left = widget.endsAt.difference(DateTime.now());
    setState(() => _left = left);
    if (left.isNegative && !_expiredHandled) {
      _expiredHandled = true;
      _timer?.cancel();
      // 마감 순간 목록을 다시 받는다. 만료 판정은 서버가 한다(활성 조건 = 기간 내).
      ref.invalidate(charactersProvider);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// `16:54:23`, 하루가 넘으면 `3일 05:12:44`.
  static String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours % 24, m = d.inMinutes % 60, s = d.inSeconds % 60;
    final hhmmss = '${two(h)}:${two(m)}:${two(s)}';
    return d.inDays > 0 ? '${d.inDays}일 $hhmmss' : hhmmss;
  }

  @override
  Widget build(BuildContext context) {
    if (_left.isNegative) return const SizedBox.shrink();
    final color = context.c.accentForegroundRed;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.access_time, size: 16, color: color),
        const SizedBox(width: 4),
        Text(_fmt(_left),
            style: AppType.label1.m.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            )),
      ],
    );
  }
}
