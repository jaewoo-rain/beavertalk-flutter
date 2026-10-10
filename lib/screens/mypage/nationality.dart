import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../components/organisms/nationality_list.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 마이페이지 › 설정 › Account 「Nationality」 → 국적 변경 화면. Figma `depth/mypage_nationality`
/// (`6645:59501` · 변경 후 `6648:16757` · 미선택 `6645:59517` · 태블릿 `6645:59766`).
///
/// 제목 · 활용 안내 · 검색창 · 「Current」(현재 국적 · 미선택이면 묶음째 없음) · 「All countries」 · 목록 ·
/// 하단 「Save」. Save 는 현재 값에서 바뀌어야 켜진다. 누르면 **저장만** 하고 설정으로 돌아간다 —
/// 국적 분류 모델로는 다음 통화가 끝날 때 서버가 그 통화 녹음에 붙여 보낸다(PM-DEC-498).
/// 국적을 지우는(「Not set」 으로 되돌리는) 길은 두지 않는다(PM-DEC-502 · 철회는 문의 메일).
class MyPageNationalityScreen extends ConsumerStatefulWidget {
  const MyPageNationalityScreen({super.key});

  @override
  ConsumerState<MyPageNationalityScreen> createState() =>
      _MyPageNationalityScreenState();
}

class _MyPageNationalityScreenState
    extends ConsumerState<MyPageNationalityScreen> {
  String? _selected;
  String _query = '';
  bool _saving = false;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updateActualNationality(_selected!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final msg = e is AppException && e.fromServer
          ? e.message
          : l10n.somethingWentWrong;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final current = ref.watch(myProfileProvider).valueOrNull?.actualNationality;
    final currentName = countryNameFor(current);
    // 고르기 전에는 현재 국적이 선택 표시다(Figma 「Current」 행 체크).
    final shown = _selected ?? current;
    final canSave = _selected != null && _selected != current && !_saving;
    final countries = filterCountries(_query);
    final gap = nationalityRowGap(MediaQuery.sizeOf(context).width);
    // 「Current」 는 검색 중에는 숨긴다 — 결과 목록과 같은 나라가 두 번 보인다.
    final showCurrent = currentName != null && _query.trim().isEmpty;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.nationalityLabel,
          style: AppType.title3.b.copyWith(color: c.labelStrong),
        ),
        const SizedBox(height: AppSpacing.s16),
        NationalityUsageNotice(l10n.nationalityUsageNotice),
        const SizedBox(height: AppSpacing.s16),
        NationalitySearchField(
          hintText: l10n.nationalitySearchHint,
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: AppSpacing.s16),
        if (showCurrent) ...[
          NationalitySectionLabel(l10n.nationalityCurrent),
          const SizedBox(height: AppSpacing.s16),
          NationalityRow(
            iso: current!,
            name: currentName,
            selected: shown == current,
            onSelect: () => setState(() => _selected = current),
          ),
          const SizedBox(height: AppSpacing.s16),
        ],
        NationalitySectionLabel(l10n.nationalityAllCountries),
        const SizedBox(height: AppSpacing.s16),
        if (countries.isEmpty) NationalitySearchEmpty(l10n.nationalitySearchEmpty),
      ],
    );

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(onBack: () => Navigator.pop(context)),
          Expanded(
            child: ContentColumn(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: AppSpacing.s8, bottom: AppSpacing.s24),
                itemCount: countries.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return header;
                  final (iso, name) = countries[i - 1];
                  return Padding(
                    padding: EdgeInsets.only(top: i == 1 ? 0 : gap),
                    child: NationalityRow(
                      iso: iso,
                      name: name,
                      // 「Current」 묶음이 있으면 아래 목록에서는 체크하지 않는다 — 같은 나라에
                      // 체크가 두 개 생긴다. 새로 고른 나라는 목록에서 체크한다.
                      selected: _selected == iso ||
                          (_selected == null && !showCurrent && current == iso),
                      onSelect: () => setState(() => _selected = iso),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaSave,
                  onPressed: canSave ? _save : null,
                  disabled: !canSave,
                ),
              ),
            ),
          ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
