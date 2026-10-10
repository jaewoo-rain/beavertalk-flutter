import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../components/organisms/nationality_list.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 2/4 — **실제 국적**(모국어와 별개). Figma `screen/onborading_nationality`
/// (`6645:58395` · 선택 후 `6645:58412` · 태블릿 `6645:58672`).
///
/// 제목 · 부제 · 활용 안내 · 검색창 · 「전체 국가 (알파벳순)」 · 국가 목록(국기 + 영어명) · 「다음으로」.
/// 처음엔 미선택이고, 고르기 전에는 「다음으로」 가 비활성이다(사용자 10-10). 고른 값은 초안에만 담고
/// 서버 저장은 마지막 단계(목적 4/4)에서 한 번에 한다. 국적 분류 모델로는 이후 통화가 끝날 때 서버가
/// 그 통화 녹음에 붙여 보낸다(PM-DEC-498).
class OnboardingNationalityScreen extends ConsumerStatefulWidget {
  const OnboardingNationalityScreen({super.key});

  @override
  ConsumerState<OnboardingNationalityScreen> createState() =>
      _OnboardingNationalityScreenState();
}

class _OnboardingNationalityScreenState
    extends ConsumerState<OnboardingNationalityScreen> {
  /// 뒤로 왔다가 다시 들어와도 고른 값이 남는다(초안에서 시작).
  late String? _selected = ref.read(signupDraftProvider).actualNationality;
  String _query = '';

  void _next() {
    ref.read(signupDraftProvider.notifier).setActualNationality(_selected!);
    Navigator.pushNamed(context, Routes.onboardingName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final countries = filterCountries(_query);
    final gap = nationalityRowGap(MediaQuery.sizeOf(context).width);

    // 위에 고정: 제목~검색창(사용자 10-10 「검색창을 상단에 고정해두고 그 아래부터 스크롤」).
    // 아래만 스크롤: 라벨 + 국가 행(249줄을 한 번에 그리지 않게 builder).
    final pinned = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.nationalityTitle,
          style: AppType.title3.b.copyWith(color: c.labelStrong),
        ),
        const SizedBox(height: 6), // Figma 32 → 38(AppSpacing 토큰 없음)
        Text(
          l10n.nationalitySubtitle,
          style: AppType.body2.r.copyWith(color: c.labelNeutral),
        ),
        const SizedBox(height: 6), // Figma 60 → 66
        NationalityUsageNotice(l10n.nationalityUsageNotice),
        const SizedBox(height: AppSpacing.s16),
        NationalitySearchField(
          hintText: l10n.nationalitySearchHint,
          onChanged: (v) => setState(() => _query = v),
        ),
      ],
    );
    final listHead = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NationalitySectionLabel(l10n.nationalityAllCountries),
        const SizedBox(height: AppSpacing.s16),
        if (countries.isEmpty) NationalitySearchEmpty(l10n.nationalitySearchEmpty),
      ],
    );

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 2, total: 4),
            onBack: () => Navigator.pop(context),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s16),
            child: pinned,
          ),
          Expanded(
            child: ContentColumn(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: AppSpacing.s16, bottom: AppSpacing.s24),
                itemCount: countries.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return listHead;
                  final (iso, name) = countries[i - 1];
                  return Padding(
                    padding: EdgeInsets.only(top: i == 1 ? 0 : gap),
                    child: NationalityRow(
                      iso: iso,
                      name: name,
                      selected: _selected == iso,
                      onSelect: () => setState(() => _selected = iso),
                    ),
                  );
                },
              ),
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: AppSpacing.s12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.continueLabel,
                disabled: _selected == null,
                onPressed: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
