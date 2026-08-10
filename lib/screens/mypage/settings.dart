import 'dart:async';

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/badge.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/dates.dart';
import '../../core/i18n/locale_controller.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
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

  /// First subtag of a language id, lowercased (`ko-KR` → `ko`).
  ///
  /// The server stores ISO 639-1 (`ko`) — it normalizes on write and backfilled
  /// the old BCP-47 rows, because the prompt's mother-tongue table is keyed by
  /// ISO 639-1 and `ko-KR` silently fell back to English. `mockLanguages` still
  /// uses `ko-KR` for Korean (the only hyphenated id of the 32), so compare
  /// heads rather than whole ids.
  static String _langHead(String v) => v.split('-').first.toLowerCase();

  /// Display name for a learning-language code (falls back to the first entry).
  String _learningName(String code) => _learningLanguages
      .firstWhere((l) => l.id == code, orElse: () => _learningLanguages.first)
      .name;

  // The legacy modal subscription sheet (manage → change-plan → cancel, the
  // old Figma `3360:20267…` flow) lived here until the P2 redesign. The
  // Subscription row navigates to `Routes.subscription` — the manage screen —
  // and cancellation moves to the store per work order v2. The legacy
  // `BottomSheetSubscription` organism was deleted once its last (gallery)
  // usage went.

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
      // 서버에는 ISO 639-1 로 보낸다 — UI 는 'ko-KR' 을 쓰지만 서버의 모국어 라벨 표는
      // 'ko' 만 안다(서버도 정규화하지만 보내는 쪽에서 맞춘다).
      await ref
          .read(authControllerProvider.notifier)
          .updateLanguage(_langHead(picked));
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.languageSaveFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  /// Opens the **learning-language** sheet, seeded with [currentCode]. On
  /// confirm saves to the server (`PATCH /members/me` `target_language`).
  ///
  /// 예전엔 SharedPreferences 에만 저장하고 통화 시작 시 소켓이 실어 보냈는데, 그 값의
  /// 복원이 비동기라 **복원 전에 통화가 시작되면 기본 'ko' 가 나갔다**(잠금화면 수신통화가
  /// 그 구간). 앱을 지우면 선택도 사라졌다. 이제 서버(member.target_language)가 단일
  /// 소스이고 통화 소켓은 이 값을 보내지 않는다.
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
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(authControllerProvider.notifier).updateTargetLanguage(picked);
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException ? e.message : l10n.languageSaveFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
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
    final matchedUiLang = mockLanguages.where(
        (l) => memberLang != null && _langHead(l.id) == _langHead(memberLang));
    final userLangId =
        _userLangId ?? (matchedUiLang.isEmpty ? 'en' : matchedUiLang.first.id);

    // Learning language comes straight from the server (member.target_language).
    // No local copy: the call reads the same column, so what is shown here is
    // exactly what the next call will teach. Falls back to 'ko' while loading or
    // when the saved code is not one of the seeded languages.
    final memberTarget = member?.targetLanguage;
    final learningLangId = _learningLanguages.any((l) => l.id == memberTarget)
        ? memberTarget!
        : 'ko';

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
                // Account — Figma `section/Account` (4514:4691), all four
                // rows: Nickname (chevron → editor), Email, Login Method
                // badge, Joined.
                _section(l10n.accountSection),
                const SizedBox(height: AppSpacing.s16),
                _group(_accountRows(l10n, member)),
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
                  // Learning language — 시드된 언어 중 선택. 값은 서버
                  // (member.target_language)가 소유한다. 통화 시작 시 서버가 이
                  // 컬럼을 읽어 그 언어 코스로 진행한다(소켓은 안 보낸다).
                  _navRow(
                    l10n.learningLanguage,
                    _learningName(learningLangId),
                    onTap: () => _pickLearningLanguage(learningLangId),
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
                  // Three rows, matching Figma `depth/main_mypage_settings`
                  // (`4514:4684`): Subscription / Current Plan / Payment
                  // History.
                  //
                  // Subscription and Current Plan are deliberately separate
                  // destinations. The first opens the state-driven manage
                  // screen; the second opens the plan comparison. They were
                  // folded into one Current Plan row for a while, and the cost
                  // was that [Routes.plansCompare] lost its entry point here —
                  // the only way left to reach it was one level deeper, from
                  // inside the manage screen.
                  _navRow(l10n.subscriptionRow, '',
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.subscription)),
                  _navRow(l10n.currentPlan, _planLabel(l10n),
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.plansCompare)),
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

  /// The Current-plan value, derived from the resolved status — never
  /// hardcoded. This is where "bought Max, still says Pro" showed up: the row
  /// used to carry a literal `'Pro'`.
  String _planLabel(AppLocalizations l10n) {
    final status = ref.watch(subscriptionStatusProvider);
    if (!status.grantsPaidAccess) return l10n.planFree;
    return status.tier == SubscriptionTier.max ? l10n.planMax : l10n.planPro;
  }

  /// The Account card's rows, in Figma order, with the divider rule the
  /// design uses: **between rows only — the last one has none.**
  ///
  /// Rows are built as a list first so that rule survives a row dropping out.
  /// It did drop out: with Login Method and Joined both missing, Email became
  /// the last row and kept a dangling stroke under it.
  List<Widget> _accountRows(AppLocalizations l10n, Member? member) {
    // The sign-in provider is a Supabase fact, not a server column — the API's
    // `MemberRead` has no `login_method`, which is why this row never showed.
    final provider = ref.watch(signInProviderProvider);
    final joined = member?.createdAt;

    final rows = <Widget Function(bool last)>[
      (last) => _navRow(
            l10n.nicknameLabel,
            member?.name ?? '',
            route: Routes.editNickname,
            divider: !last,
          ),
      (last) => _infoRow(l10n.fieldEmailLabel, member?.email ?? '—',
          divider: !last),
      if (provider != null && provider.isNotEmpty)
        (last) => _loginMethodRow(l10n, provider, divider: !last),
      if (joined != null)
        (last) => _infoRow(l10n.joinedLabel, localizedFullDate(context, joined),
            divider: !last),
    ];
    return [
      for (var i = 0; i < rows.length; i++) rows[i](i == rows.length - 1),
    ];
  }

  /// A read-only label/value row — the Account card's Email row has no
  /// chevron, which [CardLine] always draws, hence this local twin with the
  /// same metrics (56 row, 12/8 padding, 0.5 divider).
  Widget _infoRow(String label, String value, {bool divider = true}) =>
      Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: divider
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: context.c.lineAlternative, width: 0.5)))
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 2:3, not 1:1 — an even split truncated `device2026@te…` while
            // the short label sat on dead space. Both stay flexible so a long
            // label (es `Fecha de registro`) shrinks instead of overflowing;
            // an unbounded label is what blew the 320px sweep open.
            Flexible(
              flex: 2,
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppType.body1.r.copyWith(color: context.c.labelStrong)),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style:
                      AppType.body1.r.copyWith(color: context.c.labelNormal)),
            ),
          ],
        ),
      );

  /// Login-method row — label + positive Badge, per the Account card design.
  Widget _loginMethodRow(AppLocalizations l10n, String method,
      {bool divider = true}) {
    final label = switch (method.toLowerCase()) {
      'google' => 'Google',
      'kakao' => 'Kakao',
      'apple' => 'Apple',
      'email' => l10n.fieldEmailLabel,
      _ => method,
    };
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: divider
          ? BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: context.c.lineAlternative, width: 0.5)))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(l10n.loginMethodLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.body1.r.copyWith(color: context.c.labelStrong)),
          ),
          const SizedBox(width: 8),
          Badge(tone: BadgeTone.positive, label: label),
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
