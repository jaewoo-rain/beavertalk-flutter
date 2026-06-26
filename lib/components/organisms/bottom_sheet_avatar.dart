import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../chrome/home_indicator.dart';

/// Purchase / selection state of a [BottomSheetAvatar].
///
/// Maps 1:1 to the Figma `BottomSheet-Avatar` component set (`176:13383`):
/// - [unownedNormal] — `state=unowned-normal`: avatar not owned, shown at full
///   price. Bottom = 닫기 + 구매하기 (two buttons).
/// - [unownedDiscount] — `state=unowned-discount`: not owned, on sale. Adds a
///   red `-50%` ([AppColors.error]) badge next to the name and shows a
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
/// A bottom-anchored 375-wide sheet on [AppColors.surfaceElevated] with a top
/// [AppRadius.lg] corner radius. Composition (top → bottom):
/// 1. A header bar (구독/아바타 title row — `GNB type=sub-2`, 14×20 padding) with
///    a trailing close (✕) tap target wired to [onClose].
/// 2. A body (`0 20` horizontal padding, 24 gap) containing:
///    - an avatar row: a 72×72 circular image ([imageProvider] / [avatar]) +
///      an info column (name in Body 1 Medium white, a status badge, and an
///      optional `-50%` discount label for [BottomSheetAvatarState.unownedDiscount]),
///      then a tag-chip row ([tags]).
///    - a 1px [AppColors.borderSubtle] divider.
///    - a "샘플 목소리 듣기" sample-voice card (surface2, r8, volume glyph + label).
///    - a [description] paragraph (Label 1 Medium white).
///    - a price row: a plain [price] for non-discount states; for
///      [BottomSheetAvatarState.unownedDiscount] the [price] is struck-through in
///      [AppColors.textSecondary] followed by [discountPrice] in
///      [AppColors.error] SemiBold.
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

  /// Discounted price (e.g. "5\$"), rendered in [AppColors.error] SemiBold.
  /// Only used for [BottomSheetAvatarState.unownedDiscount].
  final String? discountPrice;

  /// Primary action: 구매하기 (unowned) or 변경하기 (owned-unused).
  final VoidCallback? onConfirm;

  /// Close / dismiss action: the header ✕, the 닫기 button and the scrim.
  final VoidCallback? onClose;

  /// Tap on the "샘플 목소리 듣기" card.
  final VoidCallback? onPlaySample;

  /// Logical sheet width from Figma.
  static const double width = 375;

  /// `Atomic/Light Blue/60` — the owned-badge accent. No semantic token exists
  /// for this hue, so a raw hex is used here (reported in the handoff).
  static const Color _ownedBadgeColor = Color(0xFF3DC2FF);

  bool get _isDiscount => state == BottomSheetAvatarState.unownedDiscount;
  bool get _isOwned =>
      state == BottomSheetAvatarState.ownedUnused ||
      state == BottomSheetAvatarState.ownedUsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _avatarBlock(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _footer(),
          const HomeIndicator(
            variant: HomeIndicatorVariant.subTransparent,
          ),
        ],
      ),
    );
  }

  // ── Header (GNB sub-2: blank title, trailing close) ──────────────────────
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 28, height: 28), // leading spacer (opacity 0)
          const Spacer(),
          Semantics(
            button: true,
            label: '닫기',
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
  Widget _avatarBlock() {
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
                child: _buildAvatar(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _infoColumn()),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: AppColors.borderSubtle),
        const SizedBox(height: 10),
        _sampleVoiceCard(),
        if (description != null) ...[
          const SizedBox(height: 10),
          Text(
            description!,
            style: AppType.label1.m.copyWith(color: AppColors.text),
          ),
        ],
        const SizedBox(height: 10),
        _priceRow(),
      ],
    );
  }

  Widget _buildAvatar() {
    if (avatar != null) return avatar!;
    if (imageProvider != null) {
      return Image(image: imageProvider!, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: AppColors.surface2,
      child: AppIcons.profile(color: AppColors.textTertiary, size: 36),
    );
  }

  Widget _infoColumn() {
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
            _statusBadge(),
            if (_isDiscount) ...[
              const SizedBox(width: 12),
              Text(
                '-50%',
                style: AppType.label1.m.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [for (final t in tags) _tagChip(t)],
          ),
        ],
      ],
    );
  }

  /// Status chip — "구매 가능" (neutral) for unowned, "보유" (light-blue) for owned.
  Widget _statusBadge() {
    final owned = _isOwned;
    final fg = owned ? _ownedBadgeColor : AppColors.textSecondary;
    final bg = owned
        ? _ownedBadgeColor.withValues(alpha: 0.1)
        : AppColors.surface2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: owned ? null : Border.all(color: AppColors.surface2),
      ),
      child: Text(
        owned ? '보유' : '구매 가능',
        style: AppType.caption1.sb.copyWith(color: fg),
      ),
    );
  }

  /// Trait chip (secondary_outline size 24): surface2 fill, textSecondary label.
  Widget _tagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppType.caption1.r.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _sampleVoiceCard() {
    return Material(
      color: AppColors.surface2,
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
              Text(
                '샘플 목소리 듣기',
                style: AppType.label1.m.copyWith(color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow() {
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
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          if (discountPrice != null) ...[
            const SizedBox(width: 10),
            Text(
              discountPrice!,
              style: AppType.body1.sb.copyWith(color: AppColors.error),
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
  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: _footerButtons(),
    );
  }

  Widget _footerButtons() {
    switch (state) {
      case BottomSheetAvatarState.unownedNormal:
      case BottomSheetAvatarState.unownedDiscount:
        return Row(
          children: [
            Expanded(
              child: Button(
                type: BtnType.secondaryOutline,
                size: BtnSize.s60,
                text: '닫기',
                onPressed: onClose,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '구매하기',
                onPressed: onConfirm,
              ),
            ),
          ],
        );
      case BottomSheetAvatarState.ownedUnused:
        return Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: '변경하기',
          onPressed: onConfirm,
        );
      case BottomSheetAvatarState.ownedUsed:
        return Button(
          type: BtnType.secondaryWhite,
          size: BtnSize.s60,
          text: '닫기',
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
      color: AppColors.bg,
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
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              // Bottom-aligned sheet inside a fixed-height stage.
              SizedBox(
                height: 560,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: ColoredBox(color: AppColors.scrim),
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
