import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';

/// 숙제 상세의 과제 카드 — Figma `숙제/TaskCard`(`5672:5290`) 실측.
///
/// r12 · `Background/Elevated/Alternative` · 패딩 16/20 · 간격 10 · 세로 스택.
/// 높이는 내용이 정한다(발음 카드는 결과 게이지가 들어가 380 까지 커진다).
///
/// 골격은 넷이다 — 머리(아이콘+이름+배지) · 설명 · 결과 · CTA.
/// [description] 과 [result] 는 상태에 따라 빠진다. 끝낸 과제는 설명 대신 결과를
/// 보여주고 CTA 가 「학습결과」로 바뀐다.
class CardTask extends StatelessWidget {
  /// 카드를 만든다.
  const CardTask({
    super.key,
    required this.icon,
    required this.title,
    required this.ctaLabel,
    required this.ctaType,
    this.badge,
    this.description,
    this.result,
    this.ctaRightIcon,
    this.ctaDisabled = false,
    this.onCta,
  });

  /// 유형 아이콘 — 발음 `AppIcons.soundWave` · 회화 `chat` · 워크북 `book`.
  ///
  /// 20px 로 그려지며 색은 카드가 정한다(`Icon/Strong` = [AppColorTokens.labelStrong]).
  final Widget Function({double size, required Color color}) icon;

  /// 유형 이름.
  final String title;

  /// CTA 문안. 정본은 셋뿐이다 — `학습하기` · `학습결과` · `다운로드`.
  final String ctaLabel;

  /// CTA 스타일. 미완료는 primary, 완료·워크북은 secondary 다.
  final BtnType ctaType;

  /// 상태 배지. 완료 과제에만 붙는다.
  final Widget? badge;

  /// 한 줄 설명.
  final String? description;

  /// 결과 위젯(발음 결과 게이지 등).
  final Widget? result;

  /// CTA 오른쪽 아이콘 — 워크북이 앱 밖으로 나간다는 신호(`external-link`).
  final Widget? ctaRightIcon;

  /// CTA 를 회색으로 잠근다.
  ///
  /// `onCta: null` 만으로는 부족하다 — [Button] 은 콜백이 없어도 **색을 그대로**
  /// 칠한다. 눌리는 척하는 버튼이 되므로 잠글 때는 이 값을 켜라.
  final bool ctaDisabled;

  /// CTA 탭.
  final VoidCallback? onCta;

  /// 스택 간격 — Figma `space/10`.
  ///
  /// [AppSpacing] 사다리에 10 이 없다(2·4·8·12·…). 사다리에 없는 값을
  /// 새로 만들면 오염되므로 이 카드 안에서만 쓰는 상수로 둔다.
  static const double _gap = 10;

  @override
  Widget build(BuildContext context) {
    final c = context.c;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s16,
        horizontal: AppSpacing.s20,
      ),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              children: [
                icon(size: 20, color: c.labelStrong),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body1.m.copyWith(color: c.labelStrong),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: AppSpacing.s8),
                  badge!,
                ],
              ],
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: _gap),
            Text(
              description!,
              style: AppType.caption1.r.copyWith(color: c.labelNormal),
            ),
          ],
          if (result != null) ...[const SizedBox(height: _gap), result!],
          const SizedBox(height: _gap),
          Button(
            type: ctaType,
            size: BtnSize.s60,
            text: ctaLabel,
            rightIcon: ctaRightIcon,
            disabled: ctaDisabled,
            onPressed: onCta,
          ),
        ],
      ),
    );
  }
}
