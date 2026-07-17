import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';

/// Purchase / selection state of a [BottomSheetAvatar].
///
/// Maps 1:1 to the Figma `BottomSheet-Avatar` component set (`176:13383`):
/// - [unownedNormal] — `state=unowned-normal`: avatar not owned, shown at full
///   price. Bottom = 닫기 + 구매하기 (two buttons).
/// - [unownedDiscount] — `state=unowned-discount`: not owned, on sale. Adds a
///   red `-50%` (`Accent/Foreground/Red`) badge next to the name and shows a
///   struck-through original price plus a red discounted price. Bottom = 닫기 +
///   구매하기.
/// - [ownedUnused] — `state=owned-unused`: owned but not the active avatar.
///   Name badge reads "보유" in light-blue. Bottom = single 변경하기 (primary).
/// - [ownedUsed] — `state=owned-used`: owned and currently in use. Bottom =
///   single 닫기 (secondary).
enum BottomSheetAvatarState {
  /// Not owned, full price; two-button footer (close + buy).
  unownedNormal,

  /// Not owned, discounted; `-50%` badge + sale price; two-button footer.
  unownedDiscount,

  /// Owned, not active; single 변경하기 (primary) footer.
  ownedUnused,

  /// Owned and active; single 닫기 (secondary) footer.
  ownedUsed,
}

/// BottomSheetAvatar — avatar purchase / selection sheet, measured 1:1 from
/// Figma `BottomSheet-Avatar` (`176:13383`).
///
/// A bottom-anchored 375-wide sheet on `Background/Elevated/Alternative` with a top
/// [AppRadius.lg] corner radius. Composition (top → bottom):
/// 1. A header bar (구독/아바타 title row — `GNB type=sub-2`, 14×20 padding) with
///    a trailing close (✕) tap target wired to [onClose].
/// 2. A body (`0 20` horizontal padding, 24 gap) containing:
///    - an avatar row: a 72×72 circular image ([imageProvider] / [avatar]) +
///      an info column (name in Body 1 Medium white, a status badge, and an
///      optional `-50%` discount label for [BottomSheetAvatarState.unownedDiscount]),
///      then a tag-chip row ([tags]).
///    - a 1px `Line/Alternative` divider.
///    - a "샘플 목소리 듣기" sample-voice card (surface2, r8, volume glyph + label).
///    - a [description] paragraph (Label 1 Medium white).
///    - a price row: a plain [price] for non-discount states; for
///      [BottomSheetAvatarState.unownedDiscount] the [price] is struck-through in
///      `Label/Normal` followed by [discountPrice] in
///      `Accent/Foreground/Red` SemiBold.
/// 3. A footer built from [Button] (60-size), then a [HomeIndicator]
///    (`sub-transparent`).
///
/// The status badge text follows the state: unowned → "구매 가능" on a neutral
/// chip; owned → "보유" in light-blue `#3DC2FF` on a 10%-tint chip (this blue is
/// `Atomic/Light Blue/60`, which has no semantic token — see [_ownedBadgeColor]).
///
/// This widget renders only the sheet surface (no scrim). Use
/// [BottomSheetAvatar.modal] to get the full overlay (Dim + sheet) for a
/// [Stack].
class BottomSheetAvatar extends StatelessWidget {
  /// Creates the avatar sheet surface.
  const BottomSheetAvatar({
    super.key,
    required this.state,
    required this.name,
    this.imageProvider,
    this.avatar,
    this.tags = const [],
    this.description,
    this.price,
    this.discountPrice,
    this.discountPercent,
    this.onConfirm,
    this.onClose,
    this.onPlaySample,
  });

  /// Purchase / selection state; drives the badge, price layout and footer.
  final BottomSheetAvatarState state;

  /// Avatar display name (e.g. "Judi"), rendered Body 1 Medium white.
  final String name;

  /// Image for the 72×72 circular avatar. Ignored when [avatar] is set.
  final ImageProvider<Object>? imageProvider;

  /// Custom avatar widget; takes precedence over [imageProvider]. Clipped to a
  /// 72×72 circle.
  final Widget? avatar;

  /// Trait chips shown under the name (e.g. `['Warm', 'Calm', 'Soft']`).
  final List<String> tags;

  /// Long-form description paragraph (Label 1 Medium white). When null the
  /// paragraph is omitted.
  final String? description;

  /// Price label (e.g. "10\$"). For [BottomSheetAvatarState.unownedDiscount]
  /// this is rendered struck-through as the original price.
  final String? price;

  /// Discounted price (e.g. "5\$"), rendered in `Accent/Foreground/Red` SemiBold.
  /// Only used for [BottomSheetAvatarState.unownedDiscount].
  final String? discountPrice;

  /// Discount percentage shown next to the name (e.g. `40` → "-40%").
  ///
  /// Must be supplied by the caller: [price] and [discountPrice] arrive
  /// pre-formatted as display strings, so the rate cannot be derived here.
  /// This was previously a hardcoded `'-50%'` literal, which silently
  /// mislabelled every discount that was not exactly half off.
  ///
  /// When null the badge is omitted rather than guessing a rate.
  final int? discountPercent;

  /// Primary action: 구매하기 (unowned) or 변경하기 (owned-unused).
  final VoidCallback? onConfirm;

  /// Close / dismiss action: the header ✕, the 닫기 button and the scrim.
  final VoidCallback? onClose;

  /// Tap on the "샘플 목소리 듣기" card.
  final VoidCallback? onPlaySample;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double maxWidth = 430;

  /// `Atomic/Light Blue/60` — the owned-badge accent. No semantic token exists
  /// for this hue, so a raw hex is used here (reported in the handoff).
  static const Color _ownedBadgeColor = Color(0xFF3DC2FF);

  bool get _isDiscount => state == BottomSheetAvatarState.unownedDiscount;
  bool get _isOwned =>
      state == BottomSheetAvatarState.ownedUnused ||
      state == BottomSheetAvatarState.ownedUsed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context, l10n),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _avatarBlock(context, l10n),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _footer(context, l10n),
          // Bottom safe-area inset — clears the real OS gesture bar (replaces
          // the former embedded fake HomeIndicator).
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Header (GNB sub-2: blank title, trailing close) ──────────────────────
  Widget _header(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 28, height: 28), // leading spacer (opacity 0)
          const Spacer(),
          Semantics(
            button: true,
            label: l10n.close,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 28,
                height: 28,
                child: AppIcons.close(size: 24, color: AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Avatar block: row + divider + sample card + description + price ───────
  Widget _avatarBlock(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 72,
                height: 72,
                child: _buildAvatar(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _infoColumn(context, l10n)),
          ],
        ),
        const SizedBox(height: 10),
        Divider(height: 1, thickness: 1, color: context.c.lineAlternative),
        const SizedBox(height: 10),
        _sampleVoiceCard(context, l10n),
        if (description != null) ...[
          const SizedBox(height: 10),
          Text(
            description!,
            style: AppType.label1.m.copyWith(color: AppColors.text),
          ),
        ],
        const SizedBox(height: 10),
        _priceRow(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (avatar != null) return avatar!;
    if (imageProvider != null) {
      return Image(image: imageProvider!, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: context.c.backgroundNormalAlternative,
      child: AppIcons.profile(color: AppColors.textTertiary, size: 36),
    );
  }

  Widget _infoColumn(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                name,
                style: AppType.body1.m.copyWith(color: AppColors.text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            // Non-flex (as in the original): only [name] is Flexible so it
            // absorbs slack and the badge stays adjacent right after it. Wrapping
            // the badge in Flexible too made the two share the row 50/50, opening
            // a gap between the name and the badge.
            _statusBadge(context, l10n),
            // Omitted when the caller didn't supply a rate — better no badge
            // than a wrong one (this was hardcoded '-50%' before).
            if (_isDiscount && discountPercent != null) ...[
              const SizedBox(width: 12),
              Text(
                '-$discountPercent%',
                style: AppType.label1.m.copyWith(color: context.c.accentForegroundRed),
              ),
            ],
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [for (final t in tags) _tagChip(context, t)],
          ),
        ],
      ],
    );
  }

  /// Status chip — "Available" (neutral) for unowned, "Owned" (light-blue) for owned.
  Widget _statusBadge(BuildContext context, AppLocalizations l10n) {
    final owned = _isOwned;
    final fg = owned ? _ownedBadgeColor : context.c.labelNormal;
    final bg = owned
        ? _ownedBadgeColor.withValues(alpha: 0.1)
        : context.c.backgroundNormalAlternative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: owned ? null : Border.all(color: context.c.backgroundNormalAlternative),
      ),
      child: Text(
        // Figma v2 `3360:20576`: the unowned chip reads "구매 가능", the same
        // wording as the catalog section — not "이용 가능" (`l10n.available`),
        // which claims the character is usable when it has not been bought.
        owned ? l10n.owned : l10n.availableForPurchase,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.caption1.sb.copyWith(color: fg),
      ),
    );
  }

  /// Trait chip (secondary_outline size 24): surface2 fill, textSecondary label.
  Widget _tagChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppType.caption1.r.copyWith(color: context.c.labelNormal),
      ),
    );
  }

  Widget _sampleVoiceCard(BuildContext context, AppLocalizations l10n) {
    return Material(
      color: context.c.backgroundNormalAlternative,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPlaySample,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcons.volume(size: 24, color: AppColors.text),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  l10n.playSampleVoice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.label1.m.copyWith(color: AppColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(BuildContext context) {
    if (price == null && discountPrice == null) {
      return const SizedBox.shrink();
    }
    if (_isDiscount) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (price != null)
            Text(
              price!,
              style: AppType.body1.r.copyWith(
                color: context.c.labelNormal,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          if (discountPrice != null) ...[
            const SizedBox(width: 10),
            Text(
              discountPrice!,
              style: AppType.body1.sb.copyWith(color: context.c.accentForegroundRed),
            ),
          ],
        ],
      );
    }
    return Text(
      price ?? '',
      style: AppType.body1.r.copyWith(color: AppColors.text),
    );
  }

  // ── Footer buttons (60-size), per state ──────────────────────────────────
  Widget _footer(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: _footerButtons(context, l10n),
    );
  }

  Widget _footerButtons(BuildContext context, AppLocalizations l10n) {
    switch (state) {
      case BottomSheetAvatarState.unownedNormal:
      case BottomSheetAvatarState.unownedDiscount:
        return Row(
          children: [
            Expanded(
              child: Button(
                type: BtnType.secondaryOutline,
                size: BtnSize.s60,
                text: l10n.close,
                onPressed: onClose,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.buy,
                onPressed: onConfirm,
              ),
            ),
          ],
        );
      case BottomSheetAvatarState.ownedUnused:
        return Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: l10n.useThisAvatar,
          onPressed: onConfirm,
        );
      case BottomSheetAvatarState.ownedUsed:
        return Button(
          type: BtnType.secondaryWhite,
          size: BtnSize.s60,
          text: l10n.close,
          onPressed: onClose,
        );
    }
  }

  /// Full modal overlay: a [Dim] scrim with the sheet bottom-anchored, sized to
  /// fill a [Stack]. Tapping the scrim invokes [onClose].
  Widget asModal() {
    return Dim(
      onTap: onClose,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(child: this),
      ),
    );
  }
}

/// Gallery demo: every [BottomSheetAvatarState], each bottom-anchored over a
/// dim backdrop in a [Stack].
class BottomSheetAvatarDemo extends StatelessWidget {
  /// Creates the demo.
  const BottomSheetAvatarDemo({super.key});

  static const _states = <(String, BottomSheetAvatarState)>[
    ('unowned-normal', BottomSheetAvatarState.unownedNormal),
    ('unowned-discount', BottomSheetAvatarState.unownedDiscount),
    ('owned-unused', BottomSheetAvatarState.ownedUnused),
    ('owned-used', BottomSheetAvatarState.ownedUsed),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final (label, state) in _states) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: AppType.label2.sb
                        .copyWith(color: context.c.labelNormal),
                  ),
                ),
              ),
              // Bottom-aligned sheet inside a fixed-height stage.
              SizedBox(
                height: 560,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: context.c.materialDim),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomSheetAvatar(
                        state: state,
                        name: 'Judi',
                        tags: const ['Warm', 'Calm', 'Soft'],
                        description:
                            '따뜻하고 부드러운 목소리의 쥬디입니다. 감정이 풍부한 자연스러운 대화 '
                            '스타일로 고급 학습자에게 인기 있는 캐릭터입니다.',
                        price: '10\$',
                        discountPrice:
                            state == BottomSheetAvatarState.unownedDiscount
                                ? '5\$'
                                : null,
                        onConfirm: () {},
                        onClose: () {},
                        onPlaySample: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
