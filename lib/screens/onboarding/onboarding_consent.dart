import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/checkbox.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/organisms/bottom_sheet.dart' as bt;
import '../../components/organisms/gnb.dart';
import '../../features/auth/domain/entities/member.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 가입 동의 항목 — [code] 는 서버 `member_consent.item` 과 같다(PM-DEC-735·736).
enum ConsentItem {
  age14('age14'),
  terms('terms'),
  privacyCollect('privacy_collect'),
  overseasTransfer('overseas_transfer');

  const ConsentItem(this.code);

  /// 서버 항목 코드.
  final String code;
}

/// 가입 동의 화면 — 온보딩 맨 앞(명세 `04_동의화면명세.md` §4 · PM-DEC-735·736).
///
/// AuthGate 가 `members/me.consentRequired` 일 때 홈·온보딩보다 먼저 띄운다. 소셜 가입은
/// `signup.dart` 를 거치지 않으므로 가입 화면이 아니라 여기서 받는다(이메일·소셜 5경로 공통).
///
/// - 필수 4개 + 전체 동의. 하나라도 꺼져 있으면 [동의하고 시작] 이 잠긴다.
/// - 버전은 앱이 정하지 않는다 — 서버가 준 [Member.consentVersions] 를 그대로 보낸다.
/// - 뒤로 가기(GNB·시스템)는 로그아웃 확인 시트다. 동의 없이 이탈한 계정은 지우지 않고
///   다음 로그인 때 이 화면이 다시 뜬다(PM-DEC-736 ②).
/// - 저장에 성공하면 프로필을 다시 읽는다 — AuthGate 가 온보딩 또는 홈으로 넘긴다.
class OnboardingConsentScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const OnboardingConsentScreen({super.key, required this.member});

  /// 지금 회원 — [Member.consentVersions] 를 보낸다.
  final Member member;

  @override
  ConsumerState<OnboardingConsentScreen> createState() =>
      _OnboardingConsentScreenState();
}

class _OnboardingConsentScreenState
    extends ConsumerState<OnboardingConsentScreen> {
  final Set<ConsentItem> _checked = {};
  bool _busy = false;

  bool get _allChecked => _checked.length == ConsentItem.values.length;

  void _toggle(ConsentItem item, bool on) => setState(() {
        on ? _checked.add(item) : _checked.remove(item);
      });

  void _toggleAll(bool on) => setState(() {
        _checked
          ..clear()
          ..addAll(on ? ConsentItem.values : const []);
      });

  Future<void> _submit() async {
    if (!_allChecked || _busy) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    setState(() => _busy = true);
    try {
      final versions = widget.member.consentVersions;
      // 서버가 버전을 안 줬으면(구서버) 보낼 것이 없다 — 이 화면이 뜰 일도 없다.
      if (versions.isEmpty) throw StateError('consent_versions 없음');
      String? appVersion;
      try {
        final info = await PackageInfo.fromPlatform();
        appVersion = '${info.version}+${info.buildNumber}';
      } catch (_) {
        // 기록용 칸이다 — 못 읽어도 동의 저장은 막지 않는다.
      }
      await ref.read(authRepositoryProvider).submitConsents(
            versions: versions,
            appVersion: appVersion,
            platform: defaultTargetPlatform.name,
            locale: locale,
          );
      // AuthGate 가 새 값(consentRequired=false)으로 다음 화면을 고른다.
      ref.invalidate(myProfileProvider);
    } catch (e) {
      debugPrint('[consent] 저장 실패: $e');
      // 409(문서 버전이 그 사이 바뀜)도 여기로 온다 — 프로필을 다시 읽어 새 버전을 받는다.
      ref.invalidate(myProfileProvider);
      if (!mounted) return;
      setState(() => _busy = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.consentSubmitFailed)));
    }
  }

  Future<void> _confirmLeave() async {
    final logout = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0x00000000),
      isScrollControlled: true,
      builder: (_) => const _LeaveSheet(),
    );
    if (logout != true || !mounted) return;
    await ref.read(authControllerProvider.notifier).logout();
  }

  void _view(ConsentItem item) {
    switch (item) {
      case ConsentItem.age14:
        return;
      case ConsentItem.terms:
        Navigator.of(context).pushNamed(Routes.terms);
      case ConsentItem.privacyCollect:
        _showSummary(const _CollectSummary());
      case ConsentItem.overseasTransfer:
        _showSummary(const _TransferSummary());
    }
  }

  Future<void> _showSummary(Widget body) => showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0x00000000),
        isScrollControlled: true,
        builder: (_) => _SummarySheet(body: body),
      );

  String _label(AppLocalizations l10n, ConsentItem item) => switch (item) {
        ConsentItem.age14 => l10n.consentAge14,
        ConsentItem.terms => l10n.consentTerms,
        ConsentItem.privacyCollect => l10n.consentPrivacyCollect,
        ConsentItem.overseasTransfer => l10n.consentOverseasTransfer,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: AppScaffold(
        background: c.backgroundNormalNormal,
        bottomBar: BottomCtaBar(
          child: SizedBox(
            width: double.infinity,
            child: Button(
              key: const ValueKey('consent-cta'),
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.consentCta,
              disabled: !_allChecked || _busy,
              onPressed: _submit,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gnb.main(onBack: _confirmLeave),
            Expanded(
              child: ContentColumn(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.s24,
                    bottom: AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.consentTitle,
                        style: AppType.title3.b.copyWith(color: c.labelStrong),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        l10n.consentSubtitle,
                        style: AppType.body2.r.copyWith(color: c.labelNormal),
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s16,
                          horizontal: AppSpacing.s16,
                        ),
                        decoration: BoxDecoration(
                          color: c.backgroundElevatedAlternative,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AppCheckbox(
                            key: const ValueKey('consent-all'),
                            value: _allChecked,
                            label: l10n.consentAgreeAll,
                            onChanged: _busy ? null : _toggleAll,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      for (final item in ConsentItem.values)
                        _ItemRow(
                          key: ValueKey('consent-${item.code}'),
                          label: _label(l10n, item),
                          value: _checked.contains(item),
                          onChanged: _busy ? null : (v) => _toggle(item, v),
                          onView: item == ConsentItem.age14
                              ? null
                              : () => _view(item),
                          viewLabel: l10n.consentView,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 항목 한 줄 — 체크 + (있으면) 보기. 문구가 길어 두 줄이 되어도 자르지 않는다(명세 §8-6).
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onView,
    required this.viewLabel,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onView;
  final String viewLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s8,
          horizontal: AppSpacing.s16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppCheckbox(
                  value: value,
                  label: label,
                  size: AppCheckboxSize.size20,
                  onChanged: onChanged,
                ),
              ),
            ),
            if (onView != null) ...[
              const SizedBox(width: AppSpacing.s8),
              Semantics(
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onView,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s8,
                      horizontal: AppSpacing.s4,
                    ),
                    child: Text(
                      viewLabel,
                      style: AppType.label1.m.copyWith(
                        color: c.labelNormal,
                        decoration: TextDecoration.underline,
                        decorationColor: c.labelNormal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 이탈 확인 시트 — pop(true) 이면 로그아웃.
class _LeaveSheet extends StatelessWidget {
  const _LeaveSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return bt.BottomSheet(
      layout: bt.BottomSheetLayout.twoButtonCol,
      primaryAction: bt.SheetAction(
        label: l10n.consentLeaveStay,
        onPressed: () => Navigator.of(context).pop(false),
      ),
      secondaryAction: bt.SheetAction(
        label: l10n.consentLeaveLogout,
        onPressed: () => Navigator.of(context).pop(true),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s8),
        child: Text(
          l10n.consentLeaveTitle,
          style: AppType.heading2.b.copyWith(color: context.c.labelStrong),
        ),
      ),
    );
  }
}

/// 요지 시트 틀 — 길면 시트 안에서 스크롤한다(화면 높이 70% 상한).
class _SummarySheet extends StatelessWidget {
  const _SummarySheet({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return bt.BottomSheet(
      layout: bt.BottomSheetLayout.singleButton,
      primaryAction: bt.SheetAction(
        label: l10n.confirm,
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: AppSpacing.s8),
          child: body,
        ),
      ),
    );
  }
}

TextStyle _sheetTitle(BuildContext context) =>
    AppType.heading2.b.copyWith(color: context.c.labelStrong);

TextStyle _sheetBody(BuildContext context) =>
    AppType.body2.r.copyWith(color: context.c.labelNormal);

/// 처리방침 전문 링크 — 시트를 닫지 않고 위에 연다.
class _PolicyLink extends StatelessWidget {
  const _PolicyLink();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Semantics(
      link: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pushNamed(Routes.privacy),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
          child: Text(
            l10n.privacyPolicy,
            style: AppType.label1.m.copyWith(
              color: c.primaryNormal,
              decoration: TextDecoration.underline,
              decorationColor: c.primaryNormal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 항목 3 요지 — 수집·이용(명세 §5-2).
class _CollectSummary extends StatelessWidget {
  const _CollectSummary();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final body = _sheetBody(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.consentCollectSheetTitle, style: _sheetTitle(context)),
        const SizedBox(height: AppSpacing.s12),
        for (final line in [
          l10n.consentCollectItems,
          l10n.consentCollectPurpose,
          l10n.consentCollectRetention,
          l10n.consentCollectRefuse,
        ]) ...[
          Text(line, style: body),
          const SizedBox(height: AppSpacing.s8),
        ],
        const _PolicyLink(),
      ],
    );
  }
}

/// 국외 이전 표 한 행. 회사명·연락처는 번역하지 않는다(명세 §6) — 코드 상수.
/// 나머지 칸은 arb 키다. 행을 늘리려면 arb 에 `consentTransferRow{N}*` 5키를 넣고 여기 한 줄을 더한다.
typedef _TransferRow = ({
  String recipient,
  String contact,
  String Function(AppLocalizations) country,
  String Function(AppLocalizations) items,
  String Function(AppLocalizations) purpose,
  String Function(AppLocalizations) when,
  String Function(AppLocalizations) retention,
});

const _googleDpo = 'support.google.com/cloud/contact/dpo';

/// 명세 §5-3 · 노션 처리방침 제7조 ①·①-2(2026-10-16 시행본) 중 앱에 해당하는 5행.
final List<_TransferRow> _transferRows = [
  (
    recipient: 'Google LLC',
    contact: _googleDpo,
    country: (l) => l.consentTransferRow1Country,
    items: (l) => l.consentTransferRow1Items,
    purpose: (l) => l.consentTransferRow1Purpose,
    when: (l) => l.consentTransferRow1When,
    retention: (l) => l.consentTransferRow1Retention,
  ),
  (
    recipient: 'Google LLC',
    contact: _googleDpo,
    country: (l) => l.consentTransferRow2Country,
    items: (l) => l.consentTransferRow2Items,
    purpose: (l) => l.consentTransferRow2Purpose,
    when: (l) => l.consentTransferRow2When,
    retention: (l) => l.consentTransferRow2Retention,
  ),
  (
    recipient: 'Google LLC',
    contact: _googleDpo,
    country: (l) => l.consentTransferRow3Country,
    items: (l) => l.consentTransferRow3Items,
    purpose: (l) => l.consentTransferRow3Purpose,
    when: (l) => l.consentTransferRow3When,
    retention: (l) => l.consentTransferRow3Retention,
  ),
  (
    recipient: 'Google LLC',
    contact: _googleDpo,
    country: (l) => l.consentTransferRow4Country,
    items: (l) => l.consentTransferRow4Items,
    purpose: (l) => l.consentTransferRow4Purpose,
    when: (l) => l.consentTransferRow4When,
    retention: (l) => l.consentTransferRow4Retention,
  ),
  (
    recipient: 'Apple Inc.',
    contact: 'apple.com/legal/privacy/contact',
    country: (l) => l.consentTransferRow5Country,
    items: (l) => l.consentTransferRow5Items,
    purpose: (l) => l.consentTransferRow5Purpose,
    when: (l) => l.consentTransferRow5When,
    retention: (l) => l.consentTransferRow5Retention,
  ),
];

/// 항목 4 요지 — 국외 이전(명세 §5-3). 표는 폰 폭에 맞게 행마다 카드 한 장으로 그린다.
class _TransferSummary extends StatelessWidget {
  const _TransferSummary();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final label = AppType.caption1.m.copyWith(color: c.labelNormal);
    final value = AppType.label1.r.copyWith(color: c.labelStrong);
    Widget cell(String k, String v) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(k, style: label),
              Text(v, style: value),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.consentTransferSheetTitle, style: _sheetTitle(context)),
        const SizedBox(height: AppSpacing.s12),
        for (final r in _transferRows)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.s8),
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: c.backgroundNormalAlternative,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cell(l10n.consentTransferColRecipient, '${r.recipient}\n${r.contact}'),
                cell(l10n.consentTransferColCountry, r.country(l10n)),
                cell(l10n.consentTransferColItems, r.items(l10n)),
                cell(l10n.consentTransferColPurpose, r.purpose(l10n)),
                cell(l10n.consentTransferColWhen, r.when(l10n)),
                cell(l10n.consentTransferColRetention, r.retention(l10n)),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.s4),
        Text(l10n.consentTransferRefuse, style: _sheetBody(context)),
        const _PolicyLink(),
      ],
    );
  }
}
