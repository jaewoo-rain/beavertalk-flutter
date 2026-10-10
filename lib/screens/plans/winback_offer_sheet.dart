import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:url_launcher/url_launcher.dart';

import '../../app/adaptive.dart';
import '../../app/routes.dart';
import '../../components/atoms/badge.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../core/store/store_subscription_link.dart';
import '../../features/subscription/domain/iap_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// 윈백 오퍼 시트 — Figma `BottomSheet/Winback`(`6438:4129`) · 모바일 `screen/winback_offer`
/// (`6192:30463`) · 태블릿 `6268:44613`.
///
/// 만료 뒤 첫 실행에 뜨는 윈백 설문에서 「너무 비싸요」를 고르고 보내면 홈 위에 뜬다
/// (PM-DEC-034 · 가치 사다리 완성안 §8-4 「비쌈 → 윈백 오퍼」).
///
/// ⛔ **금액을 적지 않는다**(09-26 사용자 결정 A). 앱은 스토어 윈백 오퍼의 값·자격을 알 수 없다
///   (`in_app_purchase` 로 오퍼 조회 불가). 첫 달 금액을 앱이 계산해 적으면 오퍼를 못 받는 회원에게도
///   그 값이 보인다 — App Review 3.1.2 허위 가격. 그래서 금액 줄·「Then … a month」 를 빼고 배지
///   「50% off your first month」 만 둔다(정본도 같이 고쳐짐 · 시트 높이 520 → 434).
///
/// 「Get 50% off」
/// - iOS: 스토어 구독 화면으로 보낸다 — 애플이 윈백 오퍼 자격을 판정해 보여 준다(PM-DEC-035).
/// - 안드로이드: Play 는 이탈 구독자 할인을 스토어 화면에서 자동 적용하지 않아 정가가 보인다 —
///   앱이 윈백 오퍼 토큰을 붙여 결제창을 직접 연다(결제 처리 화면 · [WinbackPurchase] ·
///   PM-DEC-049). 오퍼를 못 열면 스토어 화면으로 폴백한다.
/// 「Maybe later」 · 딤 → 닫기(홈).
class WinbackOfferSheet extends StatelessWidget {
  /// Creates the sheet. [onGetOffer] / [onLater] are wired by
  /// [showWinbackOfferSheet]; tests pass their own.
  const WinbackOfferSheet({
    super.key,
    required this.onGetOffer,
    required this.onLater,
  });

  /// 「Get 50% off」 — primary, bottom.
  final VoidCallback onGetOffer;

  /// 「Maybe later」 — secondary, top.
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Container(
      // 루트 면 Background/Normal/Normal · 모서리 위 20(정본 실측 — 공용 BottomSheet 의
      // Elevated/Alternative · 24 와 다르다).
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          // Sheet/Handle 36×4 · 완전 둥근 · Background/Elevated/Normal.
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Body — 좌우 20 · 간격 16 · 가운데.
          ContentColumn(
            gutter: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcons.duoReturn(size: 56),
                const SizedBox(height: 16),
                Badge(tone: BadgeTone.gold, label: l10n.winbackOfferBadge),
                const SizedBox(height: 16),
                Text(
                  l10n.winbackOfferTitle,
                  textAlign: TextAlign.center,
                  style: AppType.headline1.b.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: 16),
                // Benefits — 폭 335(콘텐츠 폭) · 행 간격 12 · 아이콘 20 + 간격 12 + 글자.
                // 문구는 페이월 Premium 불릿과 같은 키다 — 같은 약속을 두 번 번역하지 않는다.
                _Benefit(icon: AppIcons.duoVideo(), text: l10n.premiumBulletVideo),
                const SizedBox(height: 12),
                _Benefit(icon: AppIcons.duoChart(), text: l10n.premiumBulletAnalysis),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // CTA — 공용 BottomSheet two-button-col 과 같은 배치: 위 12 · 좌우 20 · 보조 위 ·
          // 주요 아래 · 60 높이 · 간격 12.
          ContentColumn(
            gutter: 20,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaMaybeLater,
                  onPressed: onLater,
                ),
                const SizedBox(height: 12),
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaGetHalfOff,
                  onPressed: onGetOffer,
                ),
              ],
            ),
          ),
          // 실제 OS 제스처 바 여백(정본의 HomeIndicator 34 자리 — 공용 시트와 같은 처리).
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20, height: 20, child: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppType.label1.r.copyWith(color: context.c.commonWhiteAndDark),
          ),
        ),
      ],
    );
  }
}

/// 윈백 오퍼 시트를 띄운다. 「Get 50% off」 → 안드로이드는 결제 처리 화면(오퍼 토큰),
/// 그 밖은 스토어 구독 화면 · 「Maybe later」 · 딤 → 닫기.
Future<void> showWinbackOfferSheet(BuildContext context) {
  final navigator = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.c.materialDim,
    isScrollControlled: true,
    builder: (sheetCtx) => WinbackOfferSheet(
      onLater: () => Navigator.of(sheetCtx).pop(),
      onGetOffer: () {
        Navigator.of(sheetCtx).pop();
        if (winbackUsesInAppOffer) {
          unawaited(navigator.pushNamed(
            Routes.purchaseProcessing,
            arguments: const WinbackPurchase(),
          ));
        } else {
          unawaited(openStoreSubscriptions());
        }
      },
    ),
  );
}

/// 「Get 50% off」 가 앱 안에서 오퍼 결제창을 여는가 — 안드로이드만(PM-DEC-049).
@visibleForTesting
bool get winbackUsesInAppOffer =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// 스토어의 구독 관리 화면을 연다(실패는 삼킨다 — 열 곳이 없으면 할 수 있는 게 없다).
Future<void> openStoreSubscriptions() => launchUrl(
      StoreSubscriptionLink.forCurrentPlatform(),
      mode: LaunchMode.externalApplication,
    ).then<void>((_) {}).catchError((Object _) {});
