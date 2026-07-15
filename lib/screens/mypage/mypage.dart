import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../components/organisms/bottom_sheet_subscription.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/i18n/locale_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// My page — Figma `screen/main_mypage` (`2296:26071`). A profile card (avatar +
/// accent breakdown), then Settings / Payment / Support sections whose rows are
/// grouped in elevated cards, then a log-out button + delete / version footer.
class MyPageScreen extends ConsumerStatefulWidget {
  /// Creates the my-page screen.
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  bool _notification = true;

  /// User (UI) language id the user has picked locally, or null before any pick
  /// (then the member's saved language is shown). Only the **user** language is
  /// selectable — the learning language is fixed to Korean (the app teaches
  /// Korean), so the two rows are: User Language (editable) / Learning Language
  /// (fixed).
  String? _userLangId;

  /// Display name for a language id (falls back to the first entry).
  String _langName(String id) => mockLanguages
      .firstWhere((l) => l.id == id, orElse: () => mockLanguages.first)
      .name;

  /// Stand-in subscription expiry for the change-plan / cancel note.
  ///
  /// Mock: no subscription expiry exists on Member or any DTO. Replace with the
  /// server value — and format it per locale — once the billing contract lands.
  static const _mockExpiry = '2026.06.20.';

  /// Opens the subscription sheet as a real bottom sheet over MyPage.
  ///
  /// Figma v2 `screen/mypage__sub_manage` (`3360:20267`) shows exactly this:
  /// MyPage still visible and dimmed, the sheet resting on top of it.
  ///
  /// It used to push [Routes.subscription] — a full-screen route that faked a
  /// sheet by bottom-anchoring the bare surface in an `Align`. That gave no
  /// scrim, no slide-up, no drag/tap-outside dismiss, and dead space above;
  /// and since every handler there was `Navigator.pop`, tapping 플랜 변경 or
  /// 결제내역 보기 just looked like going back.
  ///
  /// Uses [showModalBottomSheet] — the same call the language picker below
  /// makes — rather than `showDialog` + `asModal()`. Both overlay, but only the
  /// modal-sheet route slides up and drags to dismiss. It supplies the scrim
  /// itself, so the sheet widget is passed bare (no `asModal()`, which would
  /// paint a second [Dim] on top of the route's own barrier).
  ///
  /// The three types are one flow, matching the Figma frames:
  /// manage (`3360:20267`) → 요금제 변경 → change-plan (`3360:20312`) →
  /// 구독 취소 → cancel (`3360:20357`). The sheet rebuilds in place via
  /// [StatefulBuilder] rather than stacking routes, so the surface stays put and
  /// only its contents swap.
  ///
  /// ## Values are mock
  /// Plan name, price, dates, card and the expiry driving [_mockExpiry] are all
  /// stand-ins — there is no billing/subscription endpoint in the client. Only
  /// the copy is localized; swap [_mockExpiry] and the literals when the
  /// contract lands.
  Future<void> _openSubscriptionSheet(AppLocalizations l10n) {
    var type = SubscriptionSheetType.manage;
    return showModalBottomSheet<void>(
      context: context,
      // The sheet paints its own surface + rounded top; the route must not add
      // a Material behind it.
      backgroundColor: Colors.transparent,
      // Flutter defaults the barrier to black @ 54%; pin it to the app scrim so
      // every dim in the product is the same black @ 50%.
      barrierColor: AppColors.scrim,
      // The sheets are tall — without this they are capped at half the screen
      // and their footer buttons fall off.
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          void show(SubscriptionSheetType next) =>
              setSheetState(() => type = next);
          final note = l10n.subscriptionSwitchNote(_mockExpiry);
          return BottomSheetSubscription(
            type: type,
            plan: SubscriptionPlanInfo(
              name: l10n.proMembership,
              priceLine: l10n.pricePerMonth,
              nextBillingDate: '2026.07.01.',
            ),
            benefits: [
              SubscriptionBenefit(l10n.benefitUnlimitedCalls),
              SubscriptionBenefit(l10n.benefitDetailedAnalysis),
              SubscriptionBenefit(l10n.benefitAllCharacters),
              SubscriptionBenefit(l10n.benefitNoAds),
            ],
            // Figma `176:14577` type=manage carries a 결제 정보 section. The sheet
            // hides it when this list is empty (`bottom_sheet_subscription.dart:275`)
            // and the old screen passed nothing, so it never rendered at all.
            //
            // Labels come from l10n — hardcoding them left "결제 수단"/"최근 결제"
            // in Korean for all 30 locales.
            paymentRows: [
              (label: l10n.paymentMethod, value: 'Visa 1234'),
              (label: l10n.lastPayment, value: '2026.05.20.'),
            ],
            // Shown by change-plan and cancel only; the sheet ignores it for manage.
            note: note,
            planOptions: [
              SubscriptionPlanOption(
                name: 'Free',
                benefits: [
                  SubscriptionBenefit(l10n.freePlanCallLimit),
                  SubscriptionBenefit(l10n.freePlanBasicCharacters),
                ],
              ),
              SubscriptionPlanOption(
                name: 'Pro',
                priceLine: l10n.pricePerMonth,
                highlighted: true,
                active: true,
                benefits: [
                  SubscriptionBenefit(l10n.benefitUnlimitedCalls),
                  SubscriptionBenefit(l10n.benefitDetailedAnalysis),
                  SubscriptionBenefit(l10n.benefitAllCharacters),
                  SubscriptionBenefit(l10n.benefitNoAds),
                ],
              ),
            ],
            lostBenefits: [
              SubscriptionBenefit(l10n.benefitUnlimitedCalls),
              SubscriptionBenefit(l10n.benefitDetailedAnalysis),
              SubscriptionBenefit(l10n.benefitAllCharacters),
            ],
            onPrimary: switch (type) {
              // 요금제 변경 → the change-plan step.
              SubscriptionSheetType.manage => () =>
                  show(SubscriptionSheetType.changePlan),
              // 구독 취소 → the confirm step.
              SubscriptionSheetType.changePlan => () =>
                  show(SubscriptionSheetType.cancel),
              // Final 구독 취소. There is no cancellation endpoint in the client
              // (neither AuthRepository nor CharacterRepository exposes one), so
              // this can only close — it must not pretend the plan was cancelled.
              SubscriptionSheetType.cancel => () => Navigator.pop(sheetCtx),
            },
            onSecondary: switch (type) {
              // 결제내역 보기 → the history screen. Close the sheet first, then
              // push from the screen's own context (sheetCtx dies on pop).
              SubscriptionSheetType.manage => () {
                  Navigator.pop(sheetCtx);
                  Navigator.pushNamed(context, Routes.paymentHistory);
                },
              // Pro 계속 사용하기 → back to manage.
              SubscriptionSheetType.changePlan => () =>
                  show(SubscriptionSheetType.manage),
              // cancel has a single-button footer.
              SubscriptionSheetType.cancel => null,
            },
            onClose: () => Navigator.pop(sheetCtx),
          );
        },
      ),
    );
  }

  /// Opens the language bottom sheet for the **user (UI) language**, seeded with
  /// [currentId]; on confirm stores the pick locally and persists it to the
  /// backend (`PATCH /members/me`). Staged until "확인" so cancelling keeps the
  /// old value; a failed save is surfaced via a snackbar (local pick stays).
  Future<void> _pickUserLanguage(String currentId) async {
    var staged = currentId;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.scrim,
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) => BottomSheetCountrySelect(
          title: AppLocalizations.of(sheetCtx).selectYourLanguage,
          items: [
            for (final l in mockLanguages)
              CountryItem(code: l.id, name: l.name, countryCode: l.countryCode),
          ],
          value: staged,
          onChanged: (code) => setSheetState(() => staged = code),
          onConfirm: () => Navigator.of(sheetCtx).pop(staged),
          onClose: () => Navigator.of(sheetCtx).pop(),
        ),
      ),
    );
    if (picked == null || picked == currentId || !mounted) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _userLangId = picked);
    // Switch the app UI to the chosen language immediately (persisted); the
    // backend save follows.
    unawaited(ref.read(localeControllerProvider.notifier).setLanguage(picked));
    try {
      await ref.read(authControllerProvider.notifier).updateLanguage(picked);
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.languageSaveFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  /// Caption shared alongside the accent-card image (see [DialogShareProfile]).
  static const String _inviteText =
      "I'm learning Korean with Beavertalk — my Korean accent sounds "
      'American! 🦫 Come find your accent and learn with me: '
      'https://beavertalk.im';

  /// Confirms and performs account deletion. Shows a [DialogBasic] first; on
  /// confirm calls [AuthController.deleteAccount] (backend delete + sign-out).
  Future<void> _confirmDeleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialogBasic<bool>(
      context,
      title: l10n.deleteAccountTitle,
      description: l10n.deleteAccountBody,
      variant: DialogBasicVariant.twoHorizontal,
      primary: DialogAction(
          label: l10n.cancel,
          onPressed: () => Navigator.of(context).pop(false)),
      secondary: DialogAction(
          label: l10n.delete,
          onPressed: () => Navigator.of(context).pop(true)),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.accountDeleteFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Languages come from the real member (GET /members/me); show sensible
    // defaults until it loads.
    final member = ref.watch(myProfileProvider).valueOrNull;

    // Effective user (UI) language id: the local pick, else the member's saved
    // language when it maps to a known language, else English.
    final memberLang = member?.language;
    final userLangId = _userLangId ??
        (mockLanguages.any((l) => l.id == memberLang) ? memberLang! : 'en');

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () => showDialogShareProfile(
                context,
                imageProvider: beaverImage,
                caption: l10n.accentSoundsLike,
                title: 'American',
                stats: const [
                  ProfileStat(label: 'American', value: 87),
                  ProfileStat(label: 'Korean', value: 7, active: false),
                  ProfileStat(label: 'China', value: 6, active: false),
                ],
                // The dialog rasterizes the accent card and shares it as a PNG;
                // this text rides along as the caption.
                shareText: _inviteText,
                onShared: () {
                  if (mounted) Navigator.of(context).maybePop();
                },
              ),
              icon: AppIcons.share(color: AppColors.text),
              tooltip: l10n.share,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20, AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              children: [
                _profileCard(),
                const SizedBox(height: AppSpacing.s24),

                _section(l10n.settingsSection),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  // User (UI) language — editable.
                  _navRow(
                    l10n.userLanguage,
                    _langName(userLangId),
                    onTap: () => _pickUserLanguage(userLangId),
                  ),
                  // Learning language — fixed to Korean (the app teaches Korean).
                  _navRow(l10n.learningLanguage, l10n.learningLanguageKorean),
                  CardLine(
                    type: CardLineType.defaultToggle,
                    label: l10n.notificationLabel,
                    checked: _notification,
                    onChanged: (v) => setState(() => _notification = v),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: AppSpacing.s24),

                _section(l10n.paymentSection),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  _navRow(l10n.currentPlan, 'Pro',
                      onTap: () => _openSubscriptionSheet(l10n)),
                  // Was pointed at the subscription sheet — the same
                  // destination as 현재 요금제 — because the history screen
                  // didn't exist. It does now (Figma `2117:20206`).
                  _navRow(l10n.paymentHistory, '',
                      route: Routes.paymentHistory, divider: false),
                ]),
                const SizedBox(height: AppSpacing.s24),

                _section(l10n.supportSection),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  _navRow(l10n.contactUs, ''),
                  _navRow(l10n.termsOfService, '', route: Routes.terms),
                  _navRow(l10n.privacyPolicy, '',
                      route: Routes.privacy, divider: false),
                ]),
                const SizedBox(height: AppSpacing.s24),

                // log out — design-system secondary-fill Button (60).
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.logOut,
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(height: AppSpacing.s16),
                Center(
                  child: InkWell(
                    onTap: _confirmDeleteAccount,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
                      child: Text(
                        l10n.deleteAccount,
                        style: AppType.body1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                _version(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Profile card: 80px avatar, accent label, and three accent ProgressBars.
  Widget _profileCard() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s12, AppSpacing.s16, AppSpacing.s12, AppSpacing.s24),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.xs), // 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSpacing.s80,
              height: AppSpacing.s80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
                image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            l10n.accentSoundsLike,
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'American',
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'American', value: 87),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'Korean', value: 7, active: false),
          const SizedBox(height: AppSpacing.s16),
          const ProgressBar(label: 'China', value: 6, active: false),
        ],
      ),
    );
  }

  /// Section header (Body 1 SemiBold, white).
  Widget _section(String title) => Text(
        title,
        style: AppType.body1.sb.copyWith(color: AppColors.text),
      );

  /// Wraps a section's rows in an elevated grouping card.
  Widget _group(List<Widget> rows) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm), // 12
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: rows),
      );

  /// A tappable label/value row with a trailing chevron.
  ///
  /// Provide either a named [route] (pushed on tap) or a custom [onTap]; [onTap]
  /// takes precedence. With neither, the row is inert.
  Widget _navRow(String label, String value,
          {String? route, VoidCallback? onTap, bool divider = true}) =>
      InkWell(
        onTap: onTap ??
            (route == null
                ? null
                : () => Navigator.pushNamed(context, route)),
        child: CardLine(
          type: CardLineType.defaultRow,
          label: label,
          value: value.isEmpty ? null : value,
          showDivider: divider,
        ),
      );

  /// "Beavertalk • v1.0.0" footer.
  Widget _version() => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Beavertalk',
                style:
                    AppType.body1.r.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: AppSpacing.s4),
            Container(
              width: AppSpacing.s4,
              height: AppSpacing.s4,
              decoration: const BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s4),
            Text('v1.0.0',
                style:
                    AppType.body1.r.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
}
