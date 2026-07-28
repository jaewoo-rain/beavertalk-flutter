import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../components/organisms/bottom_sheet_subscription.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../core/i18n/learning_language_controller.dart';
import '../../core/i18n/locale_controller.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// My-page settings — Figma `screen/main_mypage_settings` (Dark `4085:30568`,
/// Light `4086:30700`).
///
/// This is the second half of the old one-page my page. The redesign split that
/// screen in two: [MyPageScreen] keeps the analysis cards, and everything
/// below them — Settings / Payment / Support, log out, delete account and the
/// version footer — moved here, reached from the gear in the my-page header.
///
/// The rows and their behaviour are carried over unchanged; only their home
/// moved.
class MyPageSettingsScreen extends ConsumerStatefulWidget {
  /// Creates the settings screen.
  const MyPageSettingsScreen({super.key});

  @override
  ConsumerState<MyPageSettingsScreen> createState() =>
      _MyPageSettingsScreenState();
}

class _MyPageSettingsScreenState extends ConsumerState<MyPageSettingsScreen> {
  bool _notification = true;

  /// User (UI) language id the user has picked locally, or null before any pick
  /// (then the member's saved language is shown). The two rows are:
  /// User Language (UI locale, editable) / Learning Language (call target).
  String? _userLangId;

  /// Display name for a language id (falls back to the first entry).
  String _langName(String id) => mockLanguages
      .firstWhere((l) => l.id == id, orElse: () => mockLanguages.first)
      .name;

  /// (멀티랭귀지 도그푸딩) 학습 언어 선택지 — 서버 target_language **코드**(커리큘럼
  /// 시드된 것만). 다른 언어가 시드되면 여기 한 줄 추가하면 된다.
  static const _learningLanguages = <MockLanguage>[
    MockLanguage('ko', '한국어', 'KR'),
    MockLanguage('ja', '日本語', 'JP'),
    MockLanguage('en', 'English', 'US'),
    MockLanguage('zh', '中文', 'CN'),
    MockLanguage('fr', 'Français', 'FR'),
    MockLanguage('vi', 'Tiếng Việt', 'VN'),
  ];

  /// Display name for a learning-language code (falls back to the first entry).
  String _learningName(String code) => _learningLanguages
      .firstWhere((l) => l.id == code, orElse: () => _learningLanguages.first)
      .name;

  /// Formats a date the way the sheets show it: `2026.06.20.`
  String _dateLabel(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}.';

  /// Formats USD cents as "$10" (shared with the avatar and checkout screens).
  String _money(int minor) =>
      formatUsd(minor, locale: Localizations.localeOf(context).toString());

  /// Opens the subscription sheet as a real bottom sheet over the screen.
  ///
  /// The three types are one flow, matching the Figma frames:
  /// manage (`3360:20267`) → 요금제 변경 → change-plan (`3360:20312`) →
  /// 구독 취소 → cancel (`3360:20357`). The sheet rebuilds in place via
  /// [StatefulBuilder] rather than stacking routes.
  ///
  /// Price and dates come from `GET /subscriptions` via
  /// [currentSubscriptionProvider]; 구독 취소 calls
  /// `POST /subscriptions/{id}/cancel`.
  Future<void> _openSubscriptionSheet(AppLocalizations l10n) {
    var type = SubscriptionSheetType.manage;
    return showModalBottomSheet<void>(
      context: context,
      // The sheet paints its own surface + rounded top; the route must not add
      // a Material behind it.
      backgroundColor: Colors.transparent,
      // Flutter defaults the barrier to black @ 54%; pin it to the app scrim.
      barrierColor: context.c.materialDim,
      // The sheets are tall — without this their footer buttons fall off.
      isScrollControlled: true,
      builder: (sheetCtx) => Consumer(
        builder: (sheetCtx, ref, _) => StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            void show(SubscriptionSheetType next) =>
                setSheetState(() => type = next);
            final sub = ref.watch(currentSubscriptionProvider);
            final end = sub?.endDate;
            // With no end_date the subscription is open-ended and the sentence
            // has nothing to say, so it is dropped rather than invented.
            final note = end == null
                ? null
                : l10n.subscriptionSwitchNote(_dateLabel(end));
            final price = sub?.price;
            return BottomSheetSubscription(
              type: type,
              plan: SubscriptionPlanInfo(
                name: l10n.proMembership,
                priceLine: price == null ? l10n.pricePerMonth : _money(price),
                nextBillingDate: end == null ? null : _dateLabel(end),
              ),
              benefits: [
                SubscriptionBenefit(l10n.benefitUnlimitedCalls),
                SubscriptionBenefit(l10n.benefitDetailedAnalysis),
                SubscriptionBenefit(l10n.benefitAllCharacters),
                SubscriptionBenefit(l10n.benefitNoAds),
              ],
              // 최근 결제 is the subscription's start date. 결제 수단 has no
              // server source, so that row is omitted rather than faked.
              paymentRows: [
                if (sub?.startDate != null)
                  (label: l10n.lastPayment, value: _dateLabel(sub!.startDate!)),
              ],
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
                SubscriptionSheetType.manage => () =>
                    show(SubscriptionSheetType.changePlan),
                SubscriptionSheetType.changePlan => () =>
                    show(SubscriptionSheetType.cancel),
                // Disabled when there is nothing active to cancel.
                SubscriptionSheetType.cancel => sub == null
                    ? null
                    : () => _cancelSubscription(sheetCtx, sub.id),
              },
              onSecondary: switch (type) {
                // Close the sheet first, then push from the screen's own
                // context (sheetCtx dies on pop).
                SubscriptionSheetType.manage => () {
                    Navigator.pop(sheetCtx);
                    Navigator.pushNamed(context, Routes.paymentHistory);
                  },
                SubscriptionSheetType.changePlan => () =>
                    show(SubscriptionSheetType.manage),
                SubscriptionSheetType.cancel => null,
              },
              onClose: () => Navigator.pop(sheetCtx),
            );
          },
        ),
      ),
    );
  }

  /// Cancels [subscribeId] (`POST /subscriptions/{id}/cancel`), closes the sheet
  /// and refreshes the subscription list.
  Future<void> _cancelSubscription(
      BuildContext sheetCtx, int subscribeId) async {
    try {
      await ref.read(subscriptionRepositoryProvider).cancel(subscribeId);
      // The cancel is a soft flag server-side, so the list is invalidated
      // rather than mutated locally.
      ref.invalidate(subscriptionsProvider);
      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
    } catch (e) {
      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is AppException
              ? e.message
              : AppLocalizations.of(context).somethingWentWrong),
        ),
      );
    }
  }

  /// Opens the language sheet for the **user (UI) language**, seeded with
  /// [currentId]; on confirm stores the pick locally and persists it
  /// (`PATCH /members/me`). Staged until 확인 so cancelling keeps the old value.
  Future<void> _pickUserLanguage(String currentId) async {
    var staged = currentId;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
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
    // Switch the app UI immediately (persisted); the backend save follows.
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

  /// Opens the **learning-language** sheet, seeded with [currentCode]. The
  /// normalcall socket sends the pick as `target_language` at call start.
  Future<void> _pickLearningLanguage(String currentCode) async {
    var staged = currentCode;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) => BottomSheetCountrySelect(
          title: AppLocalizations.of(sheetCtx).learningLanguage,
          items: [
            for (final l in _learningLanguages)
              CountryItem(code: l.id, name: l.name, countryCode: l.countryCode),
          ],
          value: staged,
          onChanged: (code) => setSheetState(() => staged = code),
          onConfirm: () => Navigator.of(sheetCtx).pop(staged),
          onClose: () => Navigator.of(sheetCtx).pop(),
        ),
      ),
    );
    if (picked == null || picked == currentCode || !mounted) return;
    await ref.read(learningLanguageProvider.notifier).setLanguage(picked);
  }

  /// Confirms and performs account deletion (backend delete + sign-out).
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
    final member = ref.watch(myProfileProvider).valueOrNull;

    // Effective user (UI) language id: the local pick, else the member's saved
    // language when it maps to a known language, else English.
    final memberLang = member?.language;
    final userLangId = _userLangId ??
        (mockLanguages.any((l) => l.id == memberLang) ? memberLang! : 'en');

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          // Figma shows a bare back arrow here — the gear that got us here is
          // the current screen, so there is no trailing action.
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s24,
                  AppSpacing.s20, AppSpacing.s24),
              children: [
                _section(l10n.settingsSection),
                const SizedBox(height: AppSpacing.s16),
                _group([
                  // User (UI) language — editable.
                  _navRow(
                    l10n.userLanguage,
                    _langName(userLangId),
                    onTap: () => _pickUserLanguage(userLangId),
                  ),
                  // Learning language — 시드된 언어 중 선택. 통화 시작 시
                  // target_language 로 실려 그 언어 코스로 진행된다.
                  _navRow(
                    l10n.learningLanguage,
                    _learningName(ref.watch(learningLanguageProvider)),
                    onTap: () => _pickLearningLanguage(
                        ref.read(learningLanguageProvider)),
                  ),
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
                            .copyWith(color: context.c.labelNormal),
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

  /// Section header (Body 1 SemiBold).
  Widget _section(String title) => Text(
        title,
        style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
      );

  /// Wraps a section's rows in an elevated grouping card.
  Widget _group(List<Widget> rows) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        decoration: BoxDecoration(
          color: context.c.backgroundSurfaceAlternative,
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
            (route == null ? null : () => Navigator.pushNamed(context, route)),
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
                style: AppType.body1.r.copyWith(color: context.c.labelNormal)),
            const SizedBox(width: AppSpacing.s4),
            Container(
              width: AppSpacing.s4,
              height: AppSpacing.s4,
              decoration: BoxDecoration(
                color: context.c.labelNormal,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s4),
            Text('v1.0.0',
                style: AppType.body1.r.copyWith(color: context.c.labelNormal)),
          ],
        ),
      );
}
