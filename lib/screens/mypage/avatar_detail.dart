import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Purchase / selection state of an [AvatarDetailScreen].
///
/// Maps 1:1 to the Figma `Avatar-Detail` component set (`4024:1090`), which
/// carries the same four `state` variants the retired `BottomSheet-Avatar`
/// (`176:13383`) had:
/// - [unownedNormal] — `state=unowned-normal`: not owned, full price. Price row
///   shown; bottom = 닫기 + 구매하기.
/// - [unownedDiscount] — `state=unowned-discount`: not owned, on sale. Adds a
///   `-N%` marker next to the name and a struck-through original price followed
///   by the sale price; bottom = 닫기 + 구매하기.
/// - [ownedUnused] — `state=owned-unused`: owned but not the active avatar. No
///   price row; bottom = single Use This (primary).
/// - [ownedUsed] — `state=owned-used`: owned and in use. No price row; bottom =
///   single 닫기 (secondary).
///
/// 여기에 **구독 축 2값**이 더 붙는다([subscriptionUnused] / [subscriptionUsed]).
/// Figma 에는 없는 상태다 — 서버가 소유(`is_owned`)와 접근(`is_unlocked`)을 분리하면서
/// 생겼다. Max 회원의 미구매 캐릭터는 **쓸 수는 있지만 산 것이 아니므로**, 기존 네 값
/// 중 어느 것으로도 그릴 수 없다: `owned*` 로 그리면 "Owned" 배지가 떠서 샀다고
/// 오해시킨 뒤 해지 때 뺏는 꼴이 되고, `unowned*` 로 그리면 잠긴 채로 남는다.
enum AvatarDetailState {
  /// Not owned, full price; price row + two-button footer (close + buy).
  unownedNormal,

  /// Not owned, discounted; `-N%` marker + sale price; two-button footer.
  unownedDiscount,

  /// Owned, not active; single Use This (primary) footer.
  ownedUnused,

  /// Owned and active; single 닫기 (secondary) footer.
  ownedUsed,

  /// 구독(Max)으로 열렸고 대표 캐릭터가 아님 — 배지는 "Max 이용 중", 가격 행 유지,
  /// 푸터 = 구매하기(outline) + 사용하기(primary).
  ///
  /// 구매 버튼이 남는 게 요점이다: Max 회원도 해지 후를 대비해 영구 구매를 할 수 있어야
  /// 하고, 서버가 그 흐름을 막지 않는다.
  subscriptionUnused,

  /// 구독(Max)으로 열렸고 지금 쓰는 중 — 푸터 = 닫기(outline) + 구매하기(primary).
  ///
  /// 소유 축에 `ownedUsed` 가 있는 것과 같은 이유로 필요하다. 구독으로 열린 캐릭터도
  /// **대표 캐릭터가 될 수 있다** — 서버가 `PATCH /members/me {character_id}` 에
  /// 소유 검증을 걸지 않고, 통화도 `MemberCharacter` 행 없이 구독만으로 허용한다.
  subscriptionUsed,
}

/// AvatarDetailScreen — full-page avatar detail, measured 1:1 from Figma
/// `Avatar-Detail` (`4024:1090`).
///
/// Replaces the former 375×487 `BottomSheetAvatar` modal with a pushed 375×812
/// screen. Composition (top → bottom):
/// 1. A [Gnb.main] with a back arrow, no title (per Figma) and a trailing share
///    action ([onShare]); [onClose] drives the back arrow.
/// 2. A scrolling body:
///    - a full-bleed [heroHeight]-tall hero image ([imageProvider] / [hero]),
///    - a 20-gutter content column (16 top, 24 bottom, 10 between items):
///      name + status badge (+ discount marker), trait chips, [summary],
///      the price row (unowned states only), the sample-voice card, a 1px
///      `Line/Alternative` divider, then the [description] story paragraph.
/// 3. A [BottomCtaBar] holding the per-state footer buttons, pinned outside the
///    scroll area by [AppScaffold.bottomBar].
///
/// This widget is presentation-only: every action is a callback, so the same
/// widget serves the gallery demo and the server-wired screen.
///
/// The status badge follows the state: unowned → "Available to purchase" on a
/// neutral chip; owned → "Owned" in `Accent/Foreground/Light Blue` on an
/// `Accent/Background/Light Blue-10` chip. (The retired sheet hardcoded
/// `Color(0xFF3DC2FF)` here because it read the Atomic `Light Blue/60` swatch;
/// Figma now binds the semantic accent token, which already exists in the
/// Flutter token layer.)
class AvatarDetailScreen extends StatelessWidget {
  /// Creates the avatar detail screen.
  const AvatarDetailScreen({
    super.key,
    required this.state,
    required this.name,
    this.imageProvider,
    this.hero,
    this.tags = const [],
    this.summary,
    this.description,
    this.price,
    this.discountPrice,
    this.discountPercent,
    this.onConfirm,
    this.onPurchase,
    this.onClose,
    this.onPlaySample,
    this.onShare,
  });

  /// Purchase / selection state; drives the badge, price row and footer.
  final AvatarDetailState state;

  /// Avatar display name (e.g. "Baba"), rendered Heading 2 Medium.
  final String name;

  /// Image for the full-bleed hero. Ignored when [hero] is set.
  final ImageProvider<Object>? imageProvider;

  /// Custom hero widget; takes precedence over [imageProvider].
  final Widget? hero;

  /// Trait chips shown under the name (e.g. `['Savage', 'Blunt', 'Tsundere']`).
  final List<String> tags;

  /// One-line catch-phrase under the chips (Label 1 SemiBold).
  final String? summary;

  /// Long-form story paragraph (Label 1 Regular). Omitted when null.
  ///
  /// Deliberately lighter than [summary]: the catch-phrase is the one line that
  /// should carry weight, and a whole paragraph set in SemiBold reads as one
  /// long emphasis with nothing left to contrast against.
  final String? description;

  /// Price label (e.g. "$10"). For [AvatarDetailState.unownedDiscount] this
  /// is the struck-through original price. Only shown for unowned states.
  final String? price;

  /// Discounted price, rendered in `Status/Negative`. Only used for
  /// [AvatarDetailState.unownedDiscount].
  final String? discountPrice;

  /// Discount percentage shown next to the name (e.g. `40` → "-40%").
  ///
  /// Must be supplied by the caller: [price]/[discountPrice] arrive
  /// pre-formatted as display strings, so the rate cannot be derived here.
  /// When null the marker is omitted rather than guessing a rate.
  final int? discountPercent;

  /// Primary action: 구매하기 (unowned) or Use This (owned-unused / subscription).
  final VoidCallback? onConfirm;

  /// 구매하기 — **구독 상태 전용**. 그 두 상태는 "사용하기"와 "구매하기"를 동시에
  /// 제공해야 해서 액션이 둘이다(다른 상태는 [onConfirm] 하나로 충분하다).
  final VoidCallback? onPurchase;

  /// Back / 닫기 action — the GNB arrow and the secondary footer button.
  final VoidCallback? onClose;

  /// Tap on the sample-voice card.
  final VoidCallback? onPlaySample;

  /// Tap on the GNB share action. When null the slot stays empty.
  final VoidCallback? onShare;

  /// Hero height (Figma 320 on the 375-wide reference frame).
  static const double heroHeight = 320;

  /// Gap between content-column items (Figma 10).
  static const double _gap = 10;

  /// 할인 레이아웃(정가 취소선 + 할인가)을 쓸 상태인가.
  ///
  /// 소유 축은 값 하나로 할인을 구분하지만(`unownedDiscount`), 구독 축까지 그렇게 하면
  /// 값이 두 배가 된다. 구독 상태는 **할인가가 실제로 넘어왔는지**로 판단한다 — 화면에
  /// 그릴 재료가 있느냐가 기준이라 결과는 같고 enum 은 안 늘어난다.
  bool get _isDiscount =>
      state == AvatarDetailState.unownedDiscount ||
      (_isSubscription && discountPrice != null);

  bool get _isOwned =>
      state == AvatarDetailState.ownedUnused ||
      state == AvatarDetailState.ownedUsed;

  /// 구독으로 열린 상태 — 소유가 **아니다.** "Owned" 배지가 뜨면 안 되고 가격 행과
  /// 구매 버튼은 남아야 한다.
  bool get _isSubscription =>
      state == AvatarDetailState.subscriptionUnused ||
      state == AvatarDetailState.subscriptionUsed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      bottomBar: BottomCtaBar(child: _footer(context, l10n)),
      body: Column(
        children: [
          Gnb.main(onBack: onClose, trailing: _shareAction(context, l10n)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _heroImage(context),
                  ContentColumn(
                    padding: const EdgeInsets.only(top: AppSpacing.s16, bottom: AppSpacing.s24),
                    child: _content(context, l10n),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Trailing GNB share button, or an empty balancing slot when [onShare] is
  /// null (the GNB's own fallback spacer keeps the title centred).
  Widget? _shareAction(BuildContext context, AppLocalizations l10n) {
    if (onShare == null) return null;
    return Semantics(
      button: true,
      label: l10n.share,
      child: InkResponse(
        onTap: onShare,
        radius: 24,
        child: SizedBox(
          width: 28,
          height: 28,
          child: AppIcons.share(size: 24, color: context.c.labelStrong),
        ),
      ),
    );
  }

  Widget _heroImage(BuildContext context) {
    if (hero != null) {
      return SizedBox(height: heroHeight, child: hero);
    }
    if (imageProvider != null) {
      return SizedBox(
        height: heroHeight,
        child: Image(image: imageProvider!, fit: BoxFit.cover),
      );
    }
    // Figma `hero/placeholder`: flat `Background/Elevated/Normal` with the
    // avatar glyph centred — used while the image is missing or failed.
    return SizedBox(
      height: heroHeight,
      child: ColoredBox(
        color: context.c.backgroundElevatedNormal,
        child: Center(
          child: AppIcons.profile(color: context.c.labelDisabled, size: 48),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, AppLocalizations l10n) {
    final priceRow = _priceRow(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nameRow(context, l10n),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: _gap),
          Wrap(
            spacing: _gap,
            runSpacing: AppSpacing.s8,
            children: [for (final t in tags) _tagChip(context, t)],
          ),
        ],
        if (summary != null) ...[
          const SizedBox(height: _gap),
          Text(
            summary!,
            style: AppType.label1.sb.copyWith(color: context.c.labelStrong),
          ),
        ],
        if (priceRow != null) ...[
          const SizedBox(height: _gap),
          priceRow,
        ],
        const SizedBox(height: _gap),
        _sampleVoiceCard(context, l10n),
        const SizedBox(height: _gap),
        Divider(height: 1, thickness: 1, color: context.c.lineAlternative),
        if (description != null) ...[
          const SizedBox(height: _gap),
          Text(
            description!,
            // Regular, not SemiBold: the story is body copy. Only [summary]
            // above carries emphasis.
            style: AppType.label1.r.copyWith(color: context.c.labelStrong),
          ),
        ],
      ],
    );
  }

  /// Name + status badge (+ discount marker).
  ///
  /// A [Wrap], not a [Row]. At the 375 reference width all three sit on one
  /// line exactly as Figma draws them, but at 320dp the discount state has to
  /// fit `name` + a translated "Available to purchase" + `-N%`, which overflows
  /// a single line in nearly every locale (caught by `i18n_overflow_test`).
  /// Wrap degrades to a second line instead of overflowing, and each child
  /// still gets the line width as a loose bound, so a long name ellipsizes
  /// rather than overflowing once it owns its line.
  Widget _nameRow(BuildContext context, AppLocalizations l10n) {
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppType.heading2.m.copyWith(color: context.c.labelStrong),
        ),
        _statusBadge(context, l10n),
        // Omitted when the caller didn't supply a rate — better no marker than
        // a wrong one.
        if (_isDiscount && discountPercent != null)
          Text(
            '-$discountPercent%',
            style:
                AppType.label1.sb.copyWith(color: context.c.statusNegative),
          ),
      ],
    );
  }

  /// Status chip — "Available to purchase" (neutral) / "Owned" (light-blue) /
  /// "Included with Max" (violet).
  ///
  /// ⛔ 구독으로 열린 캐릭터에 **"Owned" 를 쓰면 안 된다.** 산 게 아니라 구독이 열어준
  /// 것이라 해지하면 닫힌다 — 소유 배지를 띄우면 샀다고 오해시킨 뒤 뺏는 꼴이 된다.
  /// 그래서 색까지 소유(light blue)와 갈라 놓았다. 한눈에 다른 상태로 읽혀야 한다.
  Widget _statusBadge(BuildContext context, AppLocalizations l10n) {
    final owned = _isOwned;
    final subscription = _isSubscription;
    final tinted = owned || subscription;
    final fg = owned
        ? context.c.accentForegroundLightBlue
        : subscription
            ? context.c.accentForegroundViolet
            : context.c.labelNormal;
    final bg = owned
        ? context.c.accentBackgroundLightBlue10
        : subscription
            // 소유 칩과 같은 10% 틴트 구조, 색만 다르다. Violet 계열에는 10% 토큰이
            // 없어 같은 값을 알파로 낮춰 쓴다.
            ? context.c.accentBackgroundViolet.withValues(alpha: 0.1)
            : context.c.backgroundNormalAlternative;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: tinted
            ? null
            : Border.all(color: context.c.backgroundNormalAlternative),
      ),
      child: Text(
        owned
            ? l10n.owned
            : subscription
                ? l10n.unlockedWithMax
                : l10n.availableForPurchase,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.caption1.sb.copyWith(color: fg),
      ),
    );
  }

  /// Trait chip (secondary_outline size 24): surface2 fill, secondary label.
  Widget _tagChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
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
        // 카드 **안쪽** 패딩이다 — 화면 여백이 아니므로 폭을 따라가지 않는다.
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s20, vertical: AppSpacing.s16),
          child: Row(
            children: [
              AppIcons.volume(size: 24, color: context.c.labelStrong),
              const SizedBox(width: AppSpacing.s8),
              Flexible(
                child: Text(
                  l10n.playSampleVoice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppType.label1.m.copyWith(color: context.c.labelStrong),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Price row — unowned states only (owned states have nothing to buy).
  ///
  /// Returns null when there is nothing to render, so the caller can drop the
  /// preceding gap too instead of leaving a blank band.
  Widget? _priceRow(BuildContext context) {
    if (_isOwned) return null;
    if (price == null && discountPrice == null) return null;
    if (_isDiscount) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (price != null)
            Text(
              price!,
              style: AppType.body1.sb.copyWith(
                color: context.c.labelNormal,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          if (discountPrice != null) ...[
            const SizedBox(width: _gap),
            Text(
              discountPrice!,
              style: AppType.body1.sb
                  .copyWith(color: context.c.statusNegative),
            ),
          ],
        ],
      );
    }
    return Text(
      price ?? '',
      style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
    );
  }

  // ── Footer buttons (60-size), per state ──────────────────────────────────

  /// Footer wrapper that forces full gutter width (335 on the 375 frame).
  ///
  /// [BottomCtaBar] passes a loose constraint, so a bare [Button] would hug its
  /// label and float centred — verified on device, where "Use This" rendered
  /// ~260px wide instead of spanning the gutters. The retired sheet only avoided
  /// this because its parent [Column] stretched its children.
  Widget _footer(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: _footerButtons(context, l10n),
    );
  }

  Widget _footerButtons(BuildContext context, AppLocalizations l10n) {
    switch (state) {
      case AvatarDetailState.unownedNormal:
      case AvatarDetailState.unownedDiscount:
        return _twoButtons(
          leadingType: BtnType.secondaryOutline,
          leadingText: l10n.close,
          onLeading: onClose,
          trailingText: l10n.buy,
          onTrailing: onConfirm,
        );
      case AvatarDetailState.ownedUnused:
        return Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: l10n.useThisAvatar,
          onPressed: onConfirm,
        );
      case AvatarDetailState.ownedUsed:
        return Button(
          type: BtnType.secondaryWhite,
          size: BtnSize.s60,
          text: l10n.close,
          onPressed: onClose,
        );
      // 구독 축은 둘 다 **두 버튼**이다. 하나로 줄이면 둘 중 하나가 사라지는데, 어느
      // 쪽을 없애도 손해다: 사용하기가 없으면 애초의 버그(선택 불가)로 돌아가고,
      // 구매하기가 없으면 해지 후에도 남길 방법이 화면에서 사라진다.
      case AvatarDetailState.subscriptionUnused:
        return _twoButtons(
          leadingType: BtnType.secondaryOutline,
          leadingText: l10n.buy,
          onLeading: onPurchase,
          trailingText: l10n.useThisAvatar,
          onTrailing: onConfirm,
        );
      case AvatarDetailState.subscriptionUsed:
        // 이미 쓰는 중이라 "사용하기"는 할 일이 없다 — 남는 건 영구 구매뿐이다.
        return _twoButtons(
          leadingType: BtnType.secondaryOutline,
          leadingText: l10n.close,
          onLeading: onClose,
          trailingText: l10n.buy,
          onTrailing: onPurchase,
        );
    }
  }

  /// 좌(보조) + 우(주) 2버튼 푸터 — `unowned*` 가 쓰는 것과 같은 배치.
  Widget _twoButtons({
    required BtnType leadingType,
    required String leadingText,
    required VoidCallback? onLeading,
    required String trailingText,
    required VoidCallback? onTrailing,
  }) {
    return Row(
      children: [
        Expanded(
          child: Button(
            type: leadingType,
            size: BtnSize.s60,
            text: leadingText,
            onPressed: onLeading,
          ),
        ),
        const SizedBox(width: _gap),
        Expanded(
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: trailingText,
            onPressed: onTrailing,
          ),
        ),
      ],
    );
  }
}

/// Gallery demo: a state switcher over the real [AvatarDetailScreen].
///
/// The screen is full-page (it brings its own [AppScaffold]), so the demo swaps
/// the whole page rather than stacking four of them.
class AvatarDetailDemo extends StatefulWidget {
  /// Creates the demo.
  const AvatarDetailDemo({super.key});

  @override
  State<AvatarDetailDemo> createState() => _AvatarDetailDemoState();
}

class _AvatarDetailDemoState extends State<AvatarDetailDemo> {
  static const _states = <(String, AvatarDetailState)>[
    ('unowned-normal', AvatarDetailState.unownedNormal),
    ('unowned-discount', AvatarDetailState.unownedDiscount),
    ('owned-unused', AvatarDetailState.ownedUnused),
    ('owned-used', AvatarDetailState.ownedUsed),
    // 구독 축 — Figma 에는 없다. 서버가 소유와 접근을 나누면서 생긴 상태라,
    // 실물을 눈으로 확인할 곳이 갤러리밖에 없다.
    ('subscription-unused', AvatarDetailState.subscriptionUnused),
    ('subscription-used', AvatarDetailState.subscriptionUsed),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final (label, state) = _states[_index];
    return Column(
      children: [
        ColoredBox(
          color: context.c.backgroundNormalDeep,
          child: ContentColumn(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppType.label2.sb
                        .copyWith(color: context.c.labelNormal),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(
                      () => _index = (_index + 1) % _states.length),
                  child: Text(
                    'next state',
                    style: AppType.label2.sb
                        .copyWith(color: context.c.primaryNormal),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: AvatarDetailScreen(
            state: state,
            name: 'Baba',
            tags: const ['Savage', 'Blunt', 'Tsundere'],
            summary: 'A sharp-tongued master who will laugh in your face the '
                'second you mess up.',
            description:
                'Baba, a beaver famous for his flawless dams, could not hold '
                'back when a tourist used butchered Korean. "Where are you '
                'going with that pronunciation?" he snapped. His brutal '
                'tutoring quickly became legendary, as every student he '
                'scolded improved at lightning speed.',
            price: r'$10',
            discountPrice:
                state == AvatarDetailState.unownedDiscount ? r'$5' : null,
            discountPercent:
                state == AvatarDetailState.unownedDiscount ? 50 : null,
            onConfirm: () {},
            onPurchase: () {},
            onClose: () {},
            onPlaySample: () {},
            onShare: () {},
          ),
        ),
      ],
    );
  }
}
