import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/routes.dart';
import '../../components/molecules/benefit_row.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../components/organisms/subscription_action_sheet.dart';
import '../../core/format/dates.dart';
import '../../core/store/store_subscription_link.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// The nineteen subscription overlays of spec §7, plus the two host-section
/// free-limit sheets of §7-1 — all presented through one entry point so the
/// close conventions cannot drift per sheet.
///
/// Close conventions (spec §7-2, completion criteria 4·5):
/// - dim tap closes (`isDismissible: true`, the framework barrier),
/// - the sheet body does nothing (sheets consume their own taps),
/// - X / `Not now` / `Close` close,
/// - **closing never changes subscription state** — no dismiss path below
///   carries a side effect; state transitions are store events (§1-5).
enum SubscriptionOverlay {
  /// `overlay/restore — 복원 성공` (`4514:4768`).
  restoreSuccess,

  /// `overlay/restore — 복원할 항목 없음` (`4514:4801`).
  restoreEmpty,

  /// `overlay/restore — 다른 계정에 연결됨` (`4514:4834`).
  restoreOtherAccount,

  /// `overlay/character_offer` (`4663:6353`).
  characterOffer,

  /// `overlay/not_eligible` (`4681:6457`).
  notEligible,

  /// `overlay/cancel_downsell` (`4514:4933`).
  cancelDownsell,

  /// `overlay/annual_switch` (`4514:4972`).
  annualSwitch,

  /// `overlay/monthly_switch` (`4653:6020`).
  monthlySwitch,

  /// `overlay/refund_help` (`4514:5011`).
  refundHelp,

  /// `overlay/cancel_subscription` (`4648:27305`) — Sub/cancel.
  cancelSubscription,

  /// `overlay/payment_update` (`4649:27428`) — Sub/payment-update.
  paymentUpdate,

  /// `overlay/resubscribe` (`4652:27467`) — Sub/resubscribe.
  resubscribe,

  /// `overlay/trial_ending` (`4514:5141`).
  trialEnding,

  /// `overlay/trial_start` (`4608:9884`).
  trialStart,

  /// `overlay/oto_annual` (`4658:27988`) — shown once, 0.8s after a fresh
  /// monthly purchase (spec §8-2).
  otoAnnual,

  /// `overlay/purchase_failed — 카드 거절·잔액` (`4514:5325`).
  purchaseFailedDeclined,

  /// `overlay/purchase_failed — 사용자 취소` (`4514:5364`).
  purchaseFailedCanceled,

  /// `overlay/purchase_failed — 스토어 오류` (`4514:5403`).
  purchaseFailedStore,

  /// `overlay/already_subscribed` (`4514:5442`).
  alreadySubscribed,

  /// `free_limit — 오늘 소진` (§7-1, host: call_finish). Copy sourced from the
  /// reassembly backup — reconfirm against the 04_통화 host section.
  freeLimitCall,

  /// `free_limit — 발음분석 소진` (§7-1, host: analysis).
  freeLimitCheck,
}

/// Shows [overlay] as a modal bottom sheet over the current screen.
///
/// [expiresAt] feeds the sheets that quote a date (server value); [usage] and
/// [scores] feed the free-limit sheets. Returns when the sheet closes.
Future<void> showSubscriptionOverlay(
  BuildContext context,
  SubscriptionOverlay overlay, {
  DateTime? expiresAt,
  SubscriptionTier retryTier = SubscriptionTier.pro,
  ({String used, String limit})? usage,
  Widget? avatar,
  String? characterName,
  String? lastTopic,
  List<SheetRowData>? scores,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    // Dim tap = close; pinned to the app scrim.
    barrierColor: context.c.materialDim,
    isScrollControlled: true,
    builder: (sheetCtx) => _OverlaySheet(
      overlay: overlay,
      expiresAt: expiresAt,
      retryTier: retryTier,
      usage: usage,
      avatar: avatar,
      characterName: characterName,
      lastTopic: lastTopic,
      scores: scores,
    ),
  );
}

class _OverlaySheet extends StatelessWidget {
  const _OverlaySheet({
    required this.overlay,
    this.expiresAt,
    this.retryTier = SubscriptionTier.pro,
    this.usage,
    this.avatar,
    this.characterName,
    this.lastTopic,
    this.scores,
  });

  final SubscriptionOverlay overlay;
  final DateTime? expiresAt;

  /// Which tier a `Try again` re-fires — the failed sheets keep the context
  /// of what was being bought.
  final SubscriptionTier retryTier;
  final ({String used, String limit})? usage;
  final Widget? avatar;
  final String? characterName;
  final String? lastTopic;
  final List<SheetRowData>? scores;

  String _date(BuildContext context, DateTime? d) =>
      d == null ? '—' : localizedFullDate(context, d);

  void _close(BuildContext context) => Navigator.pop(context);

  /// Close first, then act — so an overlay CTA never leaves the sheet behind.
  void _then(BuildContext context, VoidCallback act) {
    final navigator = Navigator.of(context);
    navigator.pop();
    act();
  }

  void _toStore(BuildContext context) {
    _then(context, () {
      launchUrl(
        StoreSubscriptionLink.forCurrentPlatform(),
        mode: LaunchMode.externalApplication,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // A root navigator reference that survives the sheet's own pop.
    final rootNav = Navigator.of(context, rootNavigator: true);

    void pushAfterClose(String route) =>
        _then(context, () => rootNav.pushNamed(route));

    switch (overlay) {
      case SubscriptionOverlay.restoreSuccess:
        return BottomSheetContent(
          title: l10n.ovRestoreSuccessTitle,
          body: l10n.ovRestoreSuccessBody,
          mark: SheetMarkTone.success,
          primaryAction:
              SheetAction(label: l10n.ctaContinue, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.restoreEmpty:
        return BottomSheetContent(
          title: l10n.ovRestoreEmptyTitle,
          body: l10n.ovRestoreEmptyBody,
          primaryAction: SheetAction(
              label: l10n.seePlans,
              onPressed: () => pushAfterClose(Routes.plansCompare)),
          secondaryAction:
              SheetAction(label: l10n.ctaClose, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.restoreOtherAccount:
        return BottomSheetContent(
          title: l10n.ovRestoreOtherTitle,
          body: l10n.ovRestoreOtherBody,
          primaryAction: SheetAction(
              label: l10n.ctaSignInThatAccount,
              onPressed: () => pushAfterClose(Routes.mypageSettings)),
          secondaryAction:
              SheetAction(label: l10n.ctaGetHelp, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.characterOffer:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovCharacterOfferTitle,
          body: l10n.ovCharacterOfferBody,
          rows: [
            SheetRowData(
                label: l10n.rowOneCharacter,
                value: l10n.rowFromPrice,
                highlighted: true),
            SheetRowData(label: l10n.rowYoursForever, value: l10n.rowNoRenewal),
            SheetRowData(label: l10n.rowWorksOnFree, value: l10n.rowYes),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaSeeCharacters,
              onPressed: () => pushAfterClose(Routes.avatar)),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.notEligible:
        return BottomSheetContent(
          title: l10n.ovNotEligibleTitle,
          body: l10n.ovNotEligibleBody,
          primaryAction: SheetAction(
              label: l10n.seePlans,
              onPressed: () => pushAfterClose(Routes.plansCompare)),
          secondaryAction:
              SheetAction(label: l10n.ctaClose, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.cancelDownsell:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovCancelDownsellTitle,
          body: l10n.ovCancelDownsellBody,
          rows: [
            SheetRowData(
                label: l10n.rowPayYearlyInstead,
                value: l10n.rowYearlyMonthEquiv,
                highlighted: true),
            SheetRowData(
                label: l10n.rowCharactersYouBought,
                value: l10n.rowYoursForever),
            SheetRowData(
                label: l10n.rowProRunsUntil, value: _date(context, expiresAt)),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaSwitchToYearly,
              // annual: true — this CTA existed to sell the yearly plan, but
              // the bare tier argument made processing buy monthly again.
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: (
                        tier: SubscriptionTier.pro,
                        annual: true
                      )))),
          secondaryAction: SheetAction(
              label: l10n.ctaContinueToStore,
              onPressed: () => _toStore(context)),
        );
      case SubscriptionOverlay.annualSwitch:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovAnnualSwitchTitle,
          body: l10n.ovAnnualSwitchBody,
          rows: [
            SheetRowData(
                label: l10n.rowYouSave,
                value: l10n.amountSaved,
                highlighted: true),
            SheetRowData(label: l10n.rowYearly, value: l10n.amountYearly),
            SheetRowData(
                label: l10n.rowMonthlyForYear,
                value: l10n.amountMonthlyForYear),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaSwitchToYearly,
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: (
                        tier: SubscriptionTier.pro,
                        annual: true
                      )))),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.monthlySwitch:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovMonthlySwitchTitle,
          body: l10n.ovMonthlySwitchBody(_date(context, expiresAt)),
          rows: [
            SheetRowData(
                label: l10n.rowMonthlyBillingStarts,
                value: _date(context, expiresAt),
                highlighted: true),
            SheetRowData(
                label: l10n.rowMonthlyLabel, value: l10n.proMonthlyPriceLine),
            SheetRowData(
                label: l10n.rowYearlyWorkedOut,
                value: l10n.rowYearlyMonthEquiv),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaSwitchToMonthly,
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: (
                        tier: SubscriptionTier.pro,
                        annual: false
                      )))),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.refundHelp:
        return BottomSheetContent(
          title: l10n.ovRefundHelpTitle,
          body: l10n.ovRefundHelpBody,
          primaryAction: SheetAction(
              label: l10n.ctaGoToStore, onPressed: () => _toStore(context)),
          secondaryAction:
              SheetAction(label: l10n.ctaClose, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.cancelSubscription:
        return SubscriptionActionSheet(
          variant: SubscriptionActionVariant.cancel,
          title: l10n.subCancelTitle,
          body: l10n.subCancelBody(_date(context, expiresAt)),
          blockTitle: l10n.subWhatYouLose,
          rows: [
            SubscriptionActionRow(l10n.benefitCalls15),
            SubscriptionActionRow(l10n.benefitScoring),
            SubscriptionActionRow(l10n.benefitEveryCharacter),
          ],
          primaryAction:
              SheetAction(label: l10n.ctaKeepPro, onPressed: () => _close(context)),
          secondaryAction: SheetAction(
              label: l10n.ctaContinueToStore,
              onPressed: () => _toStore(context)),
          onClose: () => _close(context),
        );
      case SubscriptionOverlay.paymentUpdate:
        return SubscriptionActionSheet(
          variant: SubscriptionActionVariant.paymentUpdate,
          title: l10n.subPaymentTitle,
          body: l10n.subPaymentBody,
          blockTitle: l10n.subHowToFix,
          rows: [
            SubscriptionActionRow(l10n.fixStep1),
            SubscriptionActionRow(l10n.fixStep2),
            SubscriptionActionRow(l10n.fixStep3),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaGoToStore, onPressed: () => _toStore(context)),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
          onClose: () => _close(context),
        );
      case SubscriptionOverlay.resubscribe:
        return SubscriptionActionSheet(
          variant: SubscriptionActionVariant.resubscribe,
          title: l10n.subResubTitle,
          body: l10n.subResubBody(_date(context, expiresAt)),
          blockTitle: l10n.subWhatYouKeep,
          rows: [
            SubscriptionActionRow(l10n.benefitCalls15),
            SubscriptionActionRow(l10n.benefitScoring),
            SubscriptionActionRow(l10n.benefitEveryCharacter),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaTurnItBackOn, onPressed: () => _toStore(context)),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
          onClose: () => _close(context),
        );
      case SubscriptionOverlay.trialEnding:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovTrialEndingTitle,
          body: l10n.ovTrialEndingBody,
          rows: [
            SheetRowData(
                label: l10n.rowTrialEnds,
                value: _date(context, expiresAt),
                highlighted: true),
            SheetRowData(
                label: l10n.rowFirstCharge,
                value: PlansCopy.maxPrice),
            SheetRowData(
                label: l10n.rowThenMonthly, value: PlansCopy.maxPrice),
          ],
          primaryAction:
              SheetAction(label: l10n.ctaKeepMax, onPressed: () => _close(context)),
          secondaryAction: SheetAction(
              label: l10n.ctaCancelInStore,
              onPressed: () => _toStore(context)),
        );
      case SubscriptionOverlay.trialStart:
        return BottomSheetContent(
          title: l10n.ovTrialStartTitle,
          body: l10n.ovTrialStartBody(_date(context, expiresAt)),
          primaryAction: SheetAction(
              label: l10n.ctaStart7Days,
              // The trial is a Max trial — without the argument the flow lands
              // on the Pro success screen (the tier-mislabel bug).
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: (
                        tier: SubscriptionTier.max,
                        annual: false
                      )))),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.otoAnnual:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.ovOtoTitle,
          body: l10n.ovOtoBody,
          rows: [
            SheetRowData(
                label: l10n.rowYouSave,
                value: l10n.amountSaved,
                highlighted: true),
            SheetRowData(label: l10n.rowYearly, value: l10n.amountYearly),
            SheetRowData(
                label: l10n.rowMonthlyForYear,
                value: l10n.amountMonthlyForYear),
          ],
          primaryAction: SheetAction(
              label: l10n.ctaSwitchToYearly,
              onPressed: () => _toStore(context)),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.purchaseFailedDeclined:
        return BottomSheetContent(
          title: l10n.ovFailedDeclinedTitle,
          body: l10n.ovFailedDeclinedBody,
          mark: SheetMarkTone.error,
          primaryAction: SheetAction(
              label: l10n.ctaUpdatePaymentMethod,
              onPressed: () => _toStore(context)),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.purchaseFailedCanceled:
        return BottomSheetContent(
          title: l10n.ovFailedCanceledTitle,
          body: l10n.ovFailedCanceledBody,
          primaryAction: SheetAction(
              label: l10n.ctaTryAgain,
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: retryTier))),
          secondaryAction:
              SheetAction(label: l10n.ctaNotNow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.purchaseFailedStore:
        return BottomSheetContent(
          title: l10n.ovFailedStoreTitle,
          body: l10n.ovFailedStoreBody,
          mark: SheetMarkTone.error,
          primaryAction: SheetAction(
              label: l10n.ctaTryAgain,
              onPressed: () => _then(
                  context,
                  () => rootNav.pushNamed(Routes.purchaseProcessing,
                      arguments: retryTier))),
          secondaryAction: SheetAction(
              label: l10n.billingRestorePurchases,
              onPressed: () => _then(context, () {
                    showSubscriptionOverlay(
                        rootNav.context, SubscriptionOverlay.restoreSuccess);
                  })),
        );
      case SubscriptionOverlay.alreadySubscribed:
        return BottomSheetContent(
          title: l10n.ovAlreadyTitle,
          body: l10n.ovAlreadyBody,
          primaryAction: SheetAction(
              label: l10n.ctaSeeMySubscription,
              onPressed: () => pushAfterClose(Routes.subscription)),
          secondaryAction:
              SheetAction(label: l10n.ctaClose, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.freeLimitCall:
        return BottomSheetContent(
          type: SheetContentType.preview,
          title: l10n.flTodayTitle,
          body: l10n.flTodayBody,
          preview: SheetPreviewData(
            avatar: avatar ?? const SizedBox.shrink(),
            name: characterName ?? '',
            topic: lastTopic ?? '',
            usage: usage == null
                ? ''
                : l10n.flUsage(usage!.used, usage!.limit),
          ),
          benefitLabel: l10n.flBenefitCalls,
          benefitTier: BenefitTier.pro,
          caption: l10n.flCaption,
          primaryAction: SheetAction(
              label: l10n.ctaGoUnlimited,
              onPressed: () => _then(context, () {
                    rootNav.pushNamed(Routes.paywallProLimit,
                        arguments: 'call');
                  })),
          secondaryAction: SheetAction(
              label: l10n.ctaMaybeTomorrow, onPressed: () => _close(context)),
        );
      case SubscriptionOverlay.freeLimitCheck:
        return BottomSheetContent(
          type: SheetContentType.rows,
          title: l10n.flCheckTitle,
          body: l10n.flCheckBody,
          rows: scores ?? const [],
          benefitLabel: l10n.flBenefitChecks,
          benefitTier: BenefitTier.pro,
          caption: l10n.flCaption,
          primaryAction: SheetAction(
              label: l10n.ctaGoUnlimited,
              onPressed: () => _then(context, () {
                    rootNav.pushNamed(Routes.paywallProLimit,
                        arguments: 'check');
                  })),
          secondaryAction: SheetAction(
              label: l10n.ctaMaybeTomorrow, onPressed: () => _close(context)),
        );
    }
  }
}

/// Display prices quoted inside sheets. TODO(iap): store catalog replaces
/// these (v2 §6-4).
abstract final class PlansCopy {
  static const maxPrice = r'$19.90';
}
