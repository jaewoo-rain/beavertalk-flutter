import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/bottom_sheet_country_select.dart' show countryFlag;
import '../../components/organisms/gnb.dart';
import '../../features/weak_sound/domain/entities/weak_sound_item.dart';
import '../../features/weak_sound/presentation/weak_sound_providers.dart';
import '../../features/weak_sound/presentation/widgets/weak_sound_card.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// 취약 발음 목록 — Figma `02 · screen/weak_sounds` (`6023:34471`).
///
/// 두 섹션이 같은 카드를 쓰지만 뜻이 다르다.
/// - **국적별**: 같은 나라 화자들의 통계. 내가 아직 안 재 본 소리도 들어온다(「측정 전」).
/// - **나의**: 내 통화 복습에서 실제로 낮게 나온 소리.
///
/// 억양 정보가 없거나 발음 기록이 없어도 화면은 뜬다(빈 섹션). 진입 버튼이 회원 상태에
/// 따라 실패하면 안 되기 때문이다.
class WeakSoundsScreen extends ConsumerWidget {
  const WeakSoundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final async = ref.watch(weakSoundListProvider);
    return Scaffold(
      backgroundColor: c.backgroundNormalNormal,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ⛔ `Gnb.sub` 를 쓰지 마라 — 그 변형은 **뒤로가기 화살표를 그리지 않는다**
            //    (gnb.dart `_buildSub`: 가운데 제목 + 선택적 상태 줄뿐). 마이페이지에서
            //    들어온 화면이라 돌아갈 길이 시스템 back 하나만 남는다.
            Gnb.main(
              title: l10n.wsTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s20),
                    child: EmptyBlock(
                      title: l10n.wsListLoadFailed,
                      body: l10n.wsRetryLater,
                      ctaText: l10n.wsRetry,
                      onCta: () => ref.invalidate(weakSoundListProvider),
                    ),
                  ),
                ),
                data: (list) => _Body(list: list),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.list});

  final WeakSoundList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommended = list.recommended;
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(weakSoundListProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s16,
          AppSpacing.s20,
          AppSpacing.s40,
        ),
        children: [
          if (list.national.country != null)
            _AccentSummary(country: list.national.country!),
          if (recommended != null) ...[
            const SizedBox(height: AppSpacing.s12),
            _RecommendCta(
              soundKey: recommended,
              label: _labelOf(list, recommended),
            ),
          ],
          const SizedBox(height: AppSpacing.s28),
          _Section(
            title: l10n.wsNationalTitle,
            subtitle: list.national.country == null
                ? l10n.wsNationalPending
                : '${list.national.country} 화자가 자주 틀리는 소리예요',
            items: list.national.items,
            recommended: recommended,
            emptyTitle: l10n.wsNoDataYet,
            emptyBody: l10n.wsNationalEmptyBody,
            emptyCtaText: l10n.wsGoToCall,
            onEmptyCta: () => _toHome(context),
          ),
          const SizedBox(height: AppSpacing.s28),
          _Section(
            title: l10n.wsMineTitle,
            subtitle: l10n.wsMineSubtitle,
            items: list.mine,
            recommended: recommended,
            // Figma E2 정본 문구. CTA 까지 있어야 「그래서 뭘 하라는 건데」가 풀린다.
            emptyTitle: l10n.wsNoDataYet,
            emptyBody: l10n.wsMineEmptyBody,
            emptyCtaText: l10n.wsGoToCall,
            onEmptyCta: () => _toHome(context),
          ),
        ],
      ),
    );
  }

  /// 추천 `sound_key` 의 표시 이름. 두 목록 어디에 있든 찾는다.
  static String _labelOf(WeakSoundList list, String key) {
    for (final i in [...list.national.items, ...list.mine]) {
      if (i.soundKey == key) return i.label;
    }
    return '';
  }
}

/// 빈 상태 CTA — 통화를 시작할 수 있는 홈으로 되돌린다.
///
/// 통화 화면으로 직접 밀지 않는다. 통화 시작은 플랜·코스·권한을 거치는 흐름이라
/// 중간에 끼어들면 그 조건을 건너뛴다.
void _toHome(BuildContext context) =>
    Navigator.of(context).popUntil((r) => r.isFirst);

/// 억양 요약 — 국기 + 「<국가> 억양」.
///
/// 퍼센트는 이 응답에 없다(마이페이지 억양 카드가 따로 들고 있다). Figma 는 84% 를
/// 그렸지만 **여기서 지어내지 않는다** — 두 화면이 다른 숫자를 보이면 어느 쪽이 맞는지
/// 알 방법이 없다.
class _AccentSummary extends StatelessWidget {
  const _AccentSummary({required this.country});

  final String country;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final iso = _isoOf(country);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundSurfaceAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        children: [
          if (iso != null)
            // 국기는 공용 헬퍼를 쓴다 — 플랫폼마다 안 뜨는 이모지 국기를 피하려고
            // SVG 자산으로 통일해 둔 것이다(36×24·r4).
            countryFlag(iso),
          if (iso != null) const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.wsAccentOf(country),
                  style: AppType.body1.b.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  l10n.wsNationalPicked,
                  style: AppType.label2.r.copyWith(color: c.labelNormal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 추천 소리로 바로 들어가는 주 CTA.
class _RecommendCta extends StatelessWidget {
  const _RecommendCta({required this.soundKey, required this.label});

  final String soundKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Button(
      type: BtnType.primaryFill,
      size: BtnSize.s60,
      text: label.isEmpty
          ? l10n.wsStartRecommended
          : l10n.wsStartRecommendedWith(label),
      onPressed: () => Navigator.of(context).pushNamed(
        Routes.weakSoundLearn,
        arguments: soundKey,
      ),
    );
  }
}

/// 제목 + 부제 + 카드 목록. 비면 [EmptyBlock].
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.emptyTitle,
    required this.emptyBody,
    this.recommended,
    this.emptyCtaText,
    this.onEmptyCta,
  });

  final String title;
  final String subtitle;
  final List<WeakSoundItem> items;
  final String? recommended;
  final String emptyTitle;
  final String emptyBody;

  /// 빈 상태 카드의 CTA. 없으면 안내문만 그린다(Figma `Empty/Card` type=no-cta).
  final String? emptyCtaText;
  final VoidCallback? onEmptyCta;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppType.headline1.b.copyWith(color: c.labelStrong)),
        const SizedBox(height: AppSpacing.s4),
        Text(subtitle, style: AppType.label2.r.copyWith(color: c.labelNormal)),
        const SizedBox(height: AppSpacing.s12),
        if (items.isEmpty)
          // ⛔ `EmptyBlock` 을 쓰지 마라 — 그건 **면이 없는** 블록이라(정의부 주석)
          //    카드 목록 사이에 끼면 글자만 허공에 떠 보인다(2026-09-21 사용자 지적).
          //    Figma E2 정본도 `Empty/Card` 다.
          EmptyCard(
            title: emptyTitle,
            body: emptyBody,
            ctaText: emptyCtaText,
            onCta: onEmptyCta,
          )
        else
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s8),
            WeakSoundCard(
              item: items[i],
              recommended: items[i].soundKey == recommended,
              // 「목표 80」 글자는 섹션 첫 장에만 — 매 카드에 반복하면 눈금이 묻힌다.
              showGoalLabel: i == 0,
              onTap: () => Navigator.of(context).pushNamed(
                Routes.weakSoundLearn,
                arguments: items[i].soundKey,
              ),
            ),
          ],
      ],
    );
  }
}

/// 영문 국가명 → ISO 2자리. 국기 렌더링에만 쓴다.
///
/// 서버는 목록 응답에 ISO 를 싣지 않는다(억양 테이블에 국가 **이름**만 있다). 여기 없는
/// 나라는 국기를 생략하고 이름만 보인다 — 엉뚱한 국기를 그리느니 없는 편이 낫다.
String? _isoOf(String country) => const {
      'Bangladesh': 'BD', 'Brazil': 'BR', 'Bulgaria': 'BG', 'Cambodia': 'KH',
      'Chile': 'CL', 'China': 'CN', 'Colombia': 'CO', 'France': 'FR',
      'Germany': 'DE', 'Hong Kong': 'HK', 'India': 'IN', 'Indonesia': 'ID',
      'Italy': 'IT', 'Japan': 'JP', 'Kazakhstan': 'KZ', 'Kyrgyzstan': 'KG',
      'Malaysia': 'MY', 'Mongolia': 'MN', 'Myanmar': 'MM', 'Nepal': 'NP',
      'Peru': 'PE', 'Philippines': 'PH', 'Romania': 'RO',
      'Russian Federation': 'RU', 'Russia': 'RU', 'Spain': 'ES',
      'Tajikistan': 'TJ', 'Thailand': 'TH', 'Turkey': 'TR',
      'Turkmenistan': 'TM', 'Ukraine': 'UA', 'United Kingdom': 'GB',
      'United States': 'US', 'Uzbekistan': 'UZ', 'Vietnam': 'VN',
    }[country];
