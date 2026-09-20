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
    final c = context.c;
    final async = ref.watch(weakSoundListProvider);
    return Scaffold(
      backgroundColor: c.backgroundNormalNormal,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Gnb.sub(title: '취약 발음'),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s20),
                    child: EmptyBlock(
                      title: '목록을 불러오지 못했어요',
                      body: '잠시 후 다시 시도해 주세요.',
                      ctaText: '다시 시도',
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
            title: '국적별 취약 발음',
            subtitle: list.national.country == null
                ? '억양 분석이 끝나면 채워져요'
                : '${list.national.country} 화자가 자주 틀리는 소리예요',
            items: list.national.items,
            recommended: recommended,
            emptyTitle: '아직 통계가 없어요',
            emptyBody: '통화를 더 하면 억양을 분석해 알려드려요.',
          ),
          const SizedBox(height: AppSpacing.s28),
          _Section(
            title: '나의 취약 발음',
            subtitle: '최근 통화에서 정확도가 낮은 소리예요',
            items: list.mine,
            recommended: recommended,
            // Figma E2 — 표본 부족. 「없다」가 아니라 「아직 모은 게 없다」로 쓴다.
            emptyTitle: '아직 모은 발음이 부족해요',
            emptyBody: '통화하고 복습하면 내 취약 발음이 쌓여요.',
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
                  '$country 억양',
                  style: AppType.body1.b.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  '억양 분석 결과를 바탕으로 골랐어요',
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
  Widget build(BuildContext context) => Button(
        type: BtnType.primaryFill,
        size: BtnSize.s60,
        text: label.isEmpty ? '추천 소리부터 학습' : '추천 소리부터 학습 · $label',
        onPressed: () => Navigator.of(context).pushNamed(
          Routes.weakSoundLearn,
          arguments: soundKey,
        ),
      );
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
  });

  final String title;
  final String subtitle;
  final List<WeakSoundItem> items;
  final String? recommended;
  final String emptyTitle;
  final String emptyBody;

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
          EmptyBlock(
            title: emptyTitle,
            body: emptyBody,
            scale: EmptyScale.card,
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
