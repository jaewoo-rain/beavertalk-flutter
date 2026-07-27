import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/blur_up_image.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/avatar_card.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../features/review/data/audio_player.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import 'avatar_detail.dart';
import 'avatar_loading.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

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
                      _label(context, l10n.limitedDiscount),
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
                        child: Center(
                          child: Text(l10n.noCharactersToShow,
                              style: AppType.body2.r.copyWith(
                                  color: context.c.labelNormal)),
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
            description: c.description,
            backgroundStory: c.backgroundStory,
            voiceUrl: c.voiceUrl,
            tags: c.tags,
            price: _priceLabel(context, c.price),
            discountPrice: _priceLabel(context, c.effectivePrice),
            discountPercent: _discountPercent(c),
          )),
    );
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
      price: _priceLabel(context, c.price),
      action: _buyButton(context, () => _openDetail(
            context,
            AvatarDetailState.unownedNormal,
            c.name,
            image,
            characterId: c.id,
            description: c.description,
            backgroundStory: c.backgroundStory,
            voiceUrl: c.voiceUrl,
            tags: c.tags,
            price: _priceLabel(context, c.price),
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
    String? description,
    String? backgroundStory,
    String? voiceUrl,
    List<String> tags = const [],
    String? price,
    String? discountPrice,
    int? discountPercent,
  }) {
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
            summary: description,
            description: backgroundStory,
            voiceUrl: voiceUrl,
            price: price,
            discountPrice: discountPrice,
            discountPercent: discountPercent,
            onConfirm: switch (state) {
              AvatarDetailState.unownedNormal ||
              AvatarDetailState.unownedDiscount =>
                () => _purchase(routeCtx, ref, characterId),
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

  /// `POST /characters/{id}/purchase`, then refresh what the purchase changed.
  Future<void> _purchase(BuildContext routeCtx, WidgetRef ref, int id) async {
    try {
      await ref.read(characterRepositoryProvider).purchase(id);
      // The catalog's `is_owned` flips, the owned list gains a row, and the
      // server writes a payment in the same transaction — so the history is
      // stale too.
      ref.invalidate(charactersProvider);
      ref.invalidate(ownedCharactersProvider);
      ref.invalidate(paymentPageProvider);
      if (routeCtx.mounted) Navigator.pop(routeCtx);
    } catch (e) {
      if (routeCtx.mounted) _reportDetailError(routeCtx, e);
    }
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

  /// Network avatar when available, else a static asset (alternating fallback).
  ImageProvider _imageFor(String? url, int id) {
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return id.isEven ? judiImage : beaverImage;
  }

  Widget _label(BuildContext context, String text, {String? trailing}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    AppType.label1.m.copyWith(color: context.c.labelNormal)),
          ),
          if (trailing != null)
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
                  .copyWith(color: context.c.labelNormal)),
          const SizedBox(height: AppSpacing.s12),
          TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry)),
        ],
      ),
    );
  }
}
