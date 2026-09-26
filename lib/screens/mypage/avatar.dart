import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/banner.dart' as bn;
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/data/character_copy_overrides.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/subscription/domain/iap_service.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/character/data/character_tag_labels.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'avatar_loading.dart';

/// 파트너(아바타) 변경 — Figma `screen/main_change_avatar` (`6181:29249`, 09-22 개편).
///
/// 목록 화면 + 상세 화면(`Avatar-Detail`) 두 장을 **한 화면으로 합쳤다.**
/// ```
/// GNB 「아바타 변경」
/// [Baba][Bibi][Dudu🔒][Popo🔒][Rara🔒%]   ← 로스터 — GNB 아래 고정
/// ┌───────────── 무대(캐릭터 고유색 그라데이션) ─────────────┐
/// │ (얼굴)  Baba [Owned]  #태그 …  한 줄 소개               │   ← 안쪽만 스크롤
/// │ ▶ 샘플 음성   이야기 …                                  │
/// └──────────────────────────────────────────────────────────┘
/// [오늘만 50% 할인 · 16:54:23 남음]      ← 할인일 때만, CTA 바로 위에 떠 있다
/// $5.99                                  ← 미보유일 때만 — 가격은 버튼 **위** 한 줄(P3)
/// [ 구매 ] / [ Use This ]                ← 하단 고정
/// ```
///
/// 타일을 누르면 **무대만 바뀐다**(화면 이동 없음). 대표 캐릭터는 `members/me.character_id`.
///
/// CTA 상태(사장님 지시 2026-09-22):
/// | 상태 | CTA |
/// |---|---|
/// | 보유·사용 중 | 비활성 「Use This」 |
/// | 보유·미사용 | 「Use This」 → 대표로 지정 |
/// | 미보유 | 「구매」 + 위 줄 가격 |
/// | 미보유·할인 | 「구매」 + 위 줄 할인가 + 할인 배너 |
///
/// 가격은 **스토어 현지가**를 먼저 쓴다(`IapService.getProducts` · 사장님 결정 P3). 스토어가
/// 답하지 않으면 서버 USD 가격으로 떨어진다 — 결제창이 띄울 금액과 다른 통화를 화면이 먼저
/// 말하면 수치가 틀린 것과 같다.
class AvatarScreen extends ConsumerStatefulWidget {
  /// Creates the avatar screen.
  const AvatarScreen({super.key});

  @override
  ConsumerState<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends ConsumerState<AvatarScreen> {
  /// 무대에 올린 캐릭터. null 이면 대표 캐릭터(없으면 첫 캐릭터).
  int? _previewId;

  /// 방금 결제가 실패했다 — CTA 위에 실패 배너(Figma `iap_result__fail`)를 띄운다.
  bool _purchaseFailed = false;

  bool _busy = false;

  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  /// 스토어 현지가 — 상품 id → 표시 가격. 한 번 물은 상품은 다시 묻지 않는다.
  final Map<String, String?> _storePrices = {};

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final charactersAsync = ref.watch(charactersProvider);
    final activeId = ref.watch(myProfileProvider).maybeWhen(
          data: (Member m) => m.characterId,
          orElse: () => null,
        );

    return charactersAsync.when(
      // `screen/main_change_avatar_loading` (`6255:13815`) — 같은 배치를 막대로 든다.
      loading: () => const AvatarLoading(),
      error: (e, _) => AppScaffold(
        background: context.c.backgroundNormalNormal,
        body: Column(
          children: [
            Gnb.main(
                title: l10n.changeAvatar, onBack: () => Navigator.pop(context)),
            Expanded(
              child: NetworkErrorView(
                message: e is AppException && e.fromServer ? e.message : null,
                onRetry: () {
                  ref.invalidate(charactersProvider);
                  ref.invalidate(ownedCharactersProvider);
                },
              ),
            ),
          ],
        ),
      ),
      data: (characters) {
        if (characters.isEmpty) {
          return AppScaffold(
            background: context.c.backgroundNormalNormal,
            body: Column(
              children: [
                Gnb.main(
                    title: l10n.changeAvatar,
                    onBack: () => Navigator.pop(context)),
                Expanded(child: EmptyBlock(body: l10n.noCharactersToShow)),
              ],
            ),
          );
        }
        final shown = characters.firstWhere(
          (c) => c.id == (_previewId ?? activeId),
          orElse: () => characters.first,
        );
        return _screen(context, characters, shown, activeId);
      },
    );
  }

  bool _usable(Character c) => c.isUnlocked || _isFree(c);

  Widget _screen(
    BuildContext context,
    List<Character> characters,
    Character c,
    int? activeId,
  ) {
    final l10n = AppLocalizations.of(context);
    final surface = context.c.characterSurfaceFor(c.name);
    final discount = !_usable(c) && c.hasDiscount;
    final ends = c.discountEndsAt;
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      bottomBar: BottomCtaBar(child: _cta(context, c, activeId)),
      // 화면 바탕 = 캐릭터 고유색 → 바탕색 그라데이션(Figma 정지점 0 · 0.55 · 1).
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [surface, surface, context.c.backgroundNormalNormal],
            stops: const [0, 0.55, 1],
          ),
        ),
        child: Column(
          children: [
            Gnb.main(
                title: l10n.changeAvatar, onBack: () => Navigator.pop(context)),
            _Roster(
              characters: characters,
              shownId: c.id,
              isUsable: _usable,
              onTap: (x) => setState(() {
                _previewId = x.id;
                _purchaseFailed = false;
                unawaited(_player.stop());
              }),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    // 아래 98 — 떠 있는 배너가 이야기 끝줄을 가리지 않게(정본 Content 하단 98).
                    padding: const EdgeInsets.only(bottom: 98),
                    child: _Stage(
                      character: c,
                      usable: _usable(c),
                      inUse: c.id == activeId,
                      onPlaySample:
                          _playable(c.voiceUrl) ? () => _play(c) : null,
                    ),
                  ),
                  if (_purchaseFailed || (discount && ends != null))
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: ContentColumn(
                        child: _purchaseFailed
                            // Figma `iap_result__fail` — 토스트 대신 숙제 배너형(셰브런 없음).
                            ? bn.Banner(
                                tone: bn.BannerTone.elevated,
                                title: l10n.avatarPurchaseFailed,
                                leading: AppIcons.alert(
                                    size: 24, color: context.c.statusNegative),
                                showChevron: false,
                              )
                            : _PromoBanner(
                                percent: _discountPercent(c) ?? 0,
                                endsAt: ends!,
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 하단 고정 CTA — 미보유면 가격 한 줄을 버튼 **위**에 둔다(버튼 라벨에 가격을 넣으면
  /// 긴 언어에서 3줄이 되어 가격이 잘린다 · 사장님 결정 P3).
  Widget _cta(BuildContext context, Character c, int? activeId) {
    final l10n = AppLocalizations.of(context);
    if (_usable(c)) {
      final inUse = c.id == activeId;
      return SizedBox(
        width: double.infinity,
        child: Button(
          type: inUse ? BtnType.disabled : BtnType.primaryFill,
          size: BtnSize.s60,
          text: l10n.useThisAvatar,
          disabled: inUse || _busy,
          onPressed: inUse ? null : () => _useCharacter(c.id),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PriceLine(
          price: _shownPrice(context, c),
          // 정가 취소선은 **같은 통화일 때만** 그린다 — 스토어 현지가(예 ₩)와 서버 정가($)를
          // 나란히 두면 비교가 아니라 오해다.
          original: c.hasDiscount && _storePriceOf(c) == null
              ? _priceLabel(context, c.price)
              : null,
          percent: c.hasDiscount ? _discountPercent(c) : null,
        ),
        const SizedBox(height: AppSpacing.s8),
        Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: l10n.buy,
          disabled: _busy,
          onPressed: () => _purchase(c),
        ),
      ],
    );
  }

  // ── 가격 ───────────────────────────────────────────────────────────────

  String? _productIdOf(Character c) =>
      IapProductIds.characterForKey(c.productKey, c.id);

  /// 스토어가 준 현지가. 아직 안 물었으면 묻고 null(답이 오면 다시 그린다).
  String? _storePriceOf(Character c) {
    final id = _productIdOf(c);
    if (id == null || _isFree(c)) return null;
    if (!_storePrices.containsKey(id)) {
      _storePrices[id] = null;
      unawaited(_queryStorePrice(id));
    }
    return _storePrices[id];
  }

  Future<void> _queryStorePrice(String id) async {
    try {
      final products = await ref.read(iapServiceProvider).getProducts({id});
      final p = products.where((x) => x.id == id).firstOrNull;
      if (p == null || p.localizedPrice.isEmpty || !mounted) return;
      setState(() => _storePrices[id] = p.localizedPrice);
    } catch (_) {
      // 스토어가 안 되면 서버 가격으로 남는다 — 결제 시 스토어가 실제 금액을 다시 보인다.
    }
  }

  String _shownPrice(BuildContext context, Character c) {
    if (_isFree(c)) return AppLocalizations.of(context).priceFree;
    return _storePriceOf(c) ?? _priceLabel(context, c.effectivePrice);
  }

  // ── 동작 ───────────────────────────────────────────────────────────────

  bool _playable(String? url) =>
      url != null && url.isNotEmpty && url.startsWith('http');

  Future<void> _play(Character c) async {
    try {
      await _player.playUrl(c.voiceUrl!);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).somethingWentWrong)),
      );
    }
  }

  /// `PATCH /members/me {character_id}` — [id] 를 대표로. 화면에 머문다(버튼이 비활성으로 바뀐다).
  Future<void> _useCharacter(int id) async {
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).updateCharacter(id);
      ref.invalidate(myProfileProvider);
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// 캐릭터 구매 — IAP 레일 먼저, 그다음 서버 전달(옛 상세 화면의 흐름 그대로).
  ///
  /// v2 §2-3: 캐릭터는 비소모성 IAP 다. 스토어가 `purchased`/`restored` 로 답한 것만 서버에
  /// 간다. 취소는 조용히, 실패는 CTA 위 배너(Figma `iap_result__fail`)로 알린다.
  Future<void> _purchase(Character c, [int? priceOverride]) async {
    final expectedMinor =
        priceOverride ?? (_isFree(c) ? null : c.effectivePrice);
    setState(() {
      _busy = true;
      _purchaseFailed = false;
    });
    try {
      final iap = ref.read(iapServiceProvider);
      // 무료 캐릭터는 스토어를 타지 않는다 — 살 상품이 없다.
      if (IapProductIds.isFreeCharacter(c.id) || expectedMinor == 0) {
        await _deliver(c, expectedMinor);
        return;
      }
      // 스토어 상품은 서버 PK 가 아니라 슬러그로 찾는다(`characterForKey` — 접두 중복 방지 포함).
      final productId = _productIdOf(c);
      if (productId == null) {
        setState(() => _purchaseFailed = true);
        return;
      }
      final product = IapProduct(
        id: productId,
        type: IapProductType.nonConsumable,
        localizedPrice: _shownPrice(context, c),
      );
      // 먼저 듣고 나서 쏜다 — 목 레일은 동기로 답해서 늦게 들으면 놓친다.
      final verdictFuture = iap.purchases.firstWhere((p) =>
          p.productId == product.id && p.state != IapPurchaseState.pending);
      await iap.purchase(product);
      final verdict = await verdictFuture;
      switch (verdict.state) {
        case IapPurchaseState.canceled:
          return; // 본인이 닫았다 — 말하지 않는다.
        case IapPurchaseState.failed:
          if (mounted) setState(() => _purchaseFailed = true);
          return;
        case IapPurchaseState.pending:
        case IapPurchaseState.purchased:
        case IapPurchaseState.restored:
          break;
      }
      if (!mounted) return;
      await _deliver(c, expectedMinor, verdict: verdict);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// 서버에 소유를 기록하고 성공 시트를 띄운다.
  Future<void> _deliver(Character c, int? expectedMinor,
      {IapPurchase? verdict}) async {
    try {
      if (verdict != null && verdict.hasReceipt) {
        // 실영수증 → 서버가 스토어에 확인하고 지급한다(앱 말만 믿으면 결제를 우회할 수 있다).
        await ref.read(purchasesRemoteDataSourceProvider).verify(verdict);
      } else {
        await ref
            .read(characterRepositoryProvider)
            .purchase(c.id, expectedPriceMinor: expectedMinor);
      }
      ref.invalidate(charactersProvider);
      ref.invalidate(ownedCharactersProvider);
      ref.invalidate(paymentPageProvider);
      if (mounted) _showPurchaseSuccessSheet(c);
    } on PriceChangedFailure catch (e) {
      // 가격이 바뀌었다 — 새 가격으로 살지 다시 묻는다.
      ref.invalidate(charactersProvider);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final ok = await showDialogBasic<bool>(
        context,
        title: l10n.priceChangedTitle,
        description:
            l10n.priceChangedBody(_priceLabel(context, e.actualPrice)),
        // Figma 에 없는 창 — 원칙대로 취소 위 · 확정 동작(구매) 아래(09-24 app designer).
        actions: [
          DialogAction(
            label: l10n.cancel,
            onPressed: () => Navigator.pop(context, false),
          ),
          DialogAction(
            label: l10n.buy,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
      if (ok == true && mounted) await _purchase(c, e.actualPrice);
    } catch (e) {
      _snack(e);
    }
  }

  /// Figma `iap_result__success` — 결과 시트. 「홈으로」 위 · 「바로 사용하기」 아래(09-24 버튼 쌍
  /// 세로 확정 · Figma `BottomSheet` 두 버튼형 순서).
  void _showPurchaseSuccessSheet(Character c) {
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
        secondaryOnTop: true,
        primaryAction: SheetAction(
          label: l10n.avatarUseNow,
          onPressed: () {
            Navigator.pop(sheetCtx);
            unawaited(_useCharacter(c.id));
          },
        ),
        secondaryAction: SheetAction(
          label: l10n.goHome,
          onPressed: () {
            Navigator.pop(sheetCtx);
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
        ),
      ),
    );
  }

  void _snack(Object e) {
    if (!mounted) return;
    // 서버가 쓴 문구일 때만 그대로 — 앱 기본값은 한국어라 전 언어에 새어 나간다(QA F017).
    final message = e is AppException && e.fromServer
        ? e.message
        : AppLocalizations.of(context).somethingWentWrong;
    ScaffoldMessenger.maybeOf(context)
      ?..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// USD 센트 → 「$11.99」, 0 → 「무료」.
  String _priceLabel(BuildContext context, int minor) {
    if (minor <= 0) return AppLocalizations.of(context).priceFree;
    return formatUsd(minor,
        locale: Localizations.localeOf(context).toString());
  }

  /// 서버가 무료라 하거나, Free 요금제에 포함된 캐릭터(Baba·Bibi, 대표 결정 2026-08-04).
  bool _isFree(Character c) =>
      c.isFree || IapProductIds.isFreeCharacter(c.id);

  /// 할인율(정수 %). 할인이 없거나 정가가 0 이면 null.
  int? _discountPercent(Character c) {
    if (!c.hasDiscount || c.price <= 0) return null;
    final off = ((c.price - c.effectivePrice) / c.price * 100).round();
    return off <= 0 ? null : off;
  }
}

ImageProvider _imageOf(Character c) {
  final url = c.imageUrl;
  return (url != null && url.isNotEmpty) ? NetworkImage(url) : placeholderAvatar;
}

/// `Roster/Fixed` — GNB 아래 고정된 캐릭터 타일 줄(`Tile-Partner` 56·r14).
class _Roster extends StatelessWidget {
  const _Roster({
    required this.characters,
    required this.shownId,
    required this.isUsable,
    required this.onTap,
  });

  final List<Character> characters;
  final int shownId;
  final bool Function(Character) isUsable;
  final ValueChanged<Character> onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Row(
        children: [
          for (final c in characters) ...[
            if (c != characters.first) const SizedBox(width: 10),
            _Tile(
              character: c,
              selected: c.id == shownId,
              usable: isUsable(c),
              onTap: () => onTap(c),
            ),
          ],
        ],
      ),
    );
  }
}

/// `Tile-Partner` (`6181:4966`) — selected(테두리) · owned(✓ 배지) · locked(덮개 + 자물쇠 20),
/// 할인 중이면 오른쪽 위 `%` 배지.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.character,
    required this.selected,
    required this.usable,
    required this.onTap,
  });

  final Character character;
  final bool selected;
  final bool usable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final sale = !usable && character.hasDiscount;
    Widget badge(Color fill, Widget child) => Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: c.backgroundNormalNormal, width: 2),
          ),
          child: child,
        );
    return Semantics(
      button: true,
      selected: selected,
      label: character.name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: c.characterSurfaceFor(character.name),
                  borderRadius: BorderRadius.circular(14),
                  border: selected
                      ? Border.all(color: c.primaryHeavy, width: 1.5)
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(image: _imageOf(character), fit: BoxFit.cover),
                      if (!usable)
                        ColoredBox(
                          color: c.materialDimmer,
                          child: Center(
                            child:
                                AppIcons.lock(size: 20, color: c.staticWhite),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (usable && !selected)
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: badge(c.primaryHeavy,
                      AppIcons.check(size: 12, color: c.staticWhite)),
                ),
              if (sale)
                Positioned(
                  right: -5,
                  top: -5,
                  child: badge(
                    c.statusCautionary,
                    Text('%',
                        style:
                            AppType.caption2.b.copyWith(color: c.staticWhite)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 무대 — 얼굴 140 · 이름 + 상태 배지 · 태그 · 한 줄 소개, 그 아래 샘플 음성 · 이야기.
class _Stage extends StatelessWidget {
  const _Stage({
    required this.character,
    required this.usable,
    required this.inUse,
    required this.onPlaySample,
  });

  final Character character;
  final bool usable;
  final bool inUse;
  final VoidCallback? onPlaySample;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final locale = Localizations.localeOf(context).toString();
    // 서버 칼럼이 한국어뿐이라 현지화 사본을 먼저 본다(없으면 서버 값).
    final summary =
        characterSummaryFor(character.id, locale, character.description);
    final story =
        characterStoryFor(character.id, locale, character.backgroundStory);
    return ContentColumn(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: _imageOf(character), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          // 이름 + 배지 — Wrap: 긴 배지(「구매 가능」 번역)가 한 줄에 안 들어가면 내려간다.
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s4,
            children: [
              // 이름 28 → 20(Heading 2 · 사용자 지시 09-22).
              Text(character.name,
                  style: AppType.heading2.b.copyWith(color: c.labelStrong)),
              _badge(context, l10n),
            ],
          ),
          if (character.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in character.tags)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.backgroundNormalAlternative,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // 서버 태그는 영문 한 벌 — UI 언어로 옮긴다(QA F054 · 임시표, 서버 i18n 전).
                    child: Text(
                        localizedCharacterTag(
                          t,
                          Localizations.localeOf(context).languageCode,
                        ),
                        style:
                            AppType.caption1.r.copyWith(color: c.labelNormal)),
                  ),
              ],
            ),
          ],
          if (summary != null) ...[
            const SizedBox(height: 6),
            Text(summary,
                textAlign: TextAlign.center,
                style: AppType.label1.b.copyWith(color: c.labelStrong)),
          ],
          const SizedBox(height: 36),
          Material(
            color: c.backgroundElevatedAlternative,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPlaySample,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    AppIcons.volume(size: 24, color: c.labelStrong),
                    const SizedBox(width: 10),
                    // 동작 이름이라 자르지 않는다 — 길면 줄을 바꾼다.
                    Expanded(
                      child: Text(l10n.playSampleVoice,
                          style:
                              AppType.label1.m.copyWith(color: c.labelStrong)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (story != null) ...[
            const SizedBox(height: 16),
            Text(story,
                style: AppType.label1.r.copyWith(color: c.labelNeutral)),
          ],
        ],
      ),
    );
  }

  /// 상태 배지 — 보유(하늘 틴트) · 구독으로 열림(보라) · 미보유(중립).
  /// ⛔ 구독으로 열린 캐릭터에 「Owned」 를 쓰지 않는다 — 해지하면 닫힌다.
  Widget _badge(BuildContext context, AppLocalizations l10n) {
    final c = context.c;
    final subscription = character.isSubscriptionUnlocked;
    final (Color bg, Color fg, String text) = usable && !subscription
        ? (c.accentBackgroundLightBlue10, c.accentForegroundLightBlue,
            inUse ? l10n.inUse : l10n.owned)
        : subscription
            ? (c.accentBackgroundViolet.withValues(alpha: 0.1),
                c.accentForegroundViolet, l10n.unlockedWithMax)
            : (c.backgroundNormalAlternative, c.labelNormal,
                l10n.availableForPurchase);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: AppType.caption1.sb.copyWith(color: fg)),
    );
  }
}

/// CTA 위 가격 한 줄 — 가격(굵게) · 할인이면 정가 취소선 · -N%.
class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.price, this.original, this.percent});

  final String price;
  final String? original;
  final int? percent;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    // 수치라 자르지 않는다. Wrap 이라 폭이 모자라면 줄을 바꾼다.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s8,
      children: [
        if (original != null)
          Text(original!,
              style: AppType.label1.r.copyWith(
                color: c.labelAssistive,
                decoration: TextDecoration.lineThrough,
              )),
        Text(price,
            style: AppType.headline1.b.copyWith(color: c.labelStrong)),
        if (percent != null)
          Text('-$percent%',
              style: AppType.label1.sb.copyWith(color: c.statusNegative)),
      ],
    );
  }
}

/// `Banner-Promo` (`6181:4946`) — 주의색 14% 틴트 면 · 「오늘만 N% 할인」 + 시계 · 남은 시간.
///
/// 1초마다 자기만 다시 그린다. 마감에 닿으면 카탈로그를 다시 받는다 — 만료 판정은 서버가 한다.
class _PromoBanner extends ConsumerStatefulWidget {
  const _PromoBanner({required this.percent, required this.endsAt});

  final int percent;
  final DateTime endsAt;

  @override
  ConsumerState<_PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends ConsumerState<_PromoBanner> {
  Timer? _timer;
  late Duration _left = widget.endsAt.difference(DateTime.now());
  bool _expiredHandled = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    final left = widget.endsAt.difference(DateTime.now());
    setState(() => _left = left);
    if (left.isNegative && !_expiredHandled) {
      _expiredHandled = true;
      _timer?.cancel();
      ref.invalidate(charactersProvider);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 남은 시간 문구. ⛔ 「일」 을 박지 마라 — 예전 카운트다운이 전 언어에서 한국어였다.
  String _remaining(AppLocalizations l10n) {
    String two(int n) => n.toString().padLeft(2, '0');
    final d = _left;
    final hms =
        '${two(d.inHours % 24)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
    return d.inDays > 0
        ? l10n.avatarPromoLeftDays(d.inDays, hms)
        : l10n.avatarPromoLeft(hms);
  }

  @override
  Widget build(BuildContext context) {
    if (_left.isNegative) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      // 틴트는 **별도 층**이다 — 알파 내장 토큰을 면 색에 바로 쓰면 검게 나오는 사고가
      // Figma 에서 있었다. 면(떠 있는 면) 위에 주의색 14% 를 얹는다.
      foregroundDecoration: BoxDecoration(
        color: c.statusCautionary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.avatarPromoTitle(widget.percent),
              style: AppType.label1.b.copyWith(color: c.labelStrong)),
          const SizedBox(height: 8),
          Row(
            children: [
              AppIcons.clock(size: 16, color: c.labelStrong),
              const SizedBox(width: 4),
              // 남은 시간은 수치다 — 자르지 않는다(Flexible 이되 줄을 바꾼다).
              Flexible(
                child: Text(
                  _remaining(l10n),
                  style: AppType.label2.b.copyWith(
                    color: c.labelStrong,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
