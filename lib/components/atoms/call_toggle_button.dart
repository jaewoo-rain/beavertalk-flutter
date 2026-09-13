import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../icons/app_icons.dart';

/// 통화 푸터의 원형 on/off 토글 — Figma `btn/hint`(`3226:13`) ·
/// `btn/subtitle`(`3226:18`) 의 공통 아톰. 실측 2026-09-13.
///
/// | | on | off |
/// |---|---|---|
/// | 면 | [activeFill] | `Fill/Alternative` |
/// | 글리프 | [activeGlyph] | `Icon/Normal`(= `labelNormal`) |
///
/// 크기는 [size] 가 정한다 — 정본 변형이 40·56 둘이고 `footer/main_call` 은 56 을
/// 쓴다. 글리프는 56 에서 28, 40 에서 24다(정본 실측).
///
/// ## off 가 테두리에서 **면**으로 바뀌었다
/// 종전 off 는 투명 + 1px `Line/Neutral` 테두리였다. 정본이 옅은 면
/// (`Fill/Alternative`)으로 바꿨다 — 테두리만 있던 버튼은 통화 화면의 어두운
/// 배경에서 거의 안 보였다. 보간은 **면끼리** 이어지므로 켜고 끌 때 테두리가
/// 나타났다 사라지는 일도 없어졌다.
///
/// 두 인스턴스는 [activeFill]·[activeGlyph] 만 다르다. Controlled — [active] 를
/// 넘기고 [onChanged] 를 처리한다.
class CallToggleButton extends StatelessWidget {
  const CallToggleButton({
    super.key,
    required this.icon,
    required this.active,
    required this.activeFill,
    required this.semanticLabel,
    this.onChanged,
    this.activeGlyph,
    this.size = 56,
  });

  /// Glyph builder (e.g. `AppIcons.lightbulb`, `AppIcons.cc`).
  final AppIconBuilder icon;

  /// Whether the toggle is currently on.
  final bool active;

  /// Fill color when [active] (hint → `hintAccent`, subtitle → `surface2`).
  final Color activeFill;

  /// Accessibility label (e.g. 'Hint', 'Subtitle').
  final String semanticLabel;

  /// Called with the *toggled* value when tapped.
  final ValueChanged<bool>? onChanged;

  /// Glyph colour while [active]. Defaults to `staticWhite`, which is right on a
  /// saturated [activeFill] (hint → orange). Pass a theme-adaptive colour when
  /// the fill itself flips with the theme (subtitle → `Background/Alternative`,
  /// which is light in Light mode and would swallow a white glyph).
  final Color? activeGlyph;

  /// 지름. 정본 변형은 40·56 이고 `footer/main_call` 은 **56** 이다.
  final double size;

  /// 글리프 크기 — 정본이 56→28, 40→24 로 준다.
  double get _iconSize => size >= 56 ? 28 : 24;

  @override
  Widget build(BuildContext context) {
    // ⚠ 채움을 `active ? activeFill : ...` 로 **미리 접지 마라.** 그러면 끌 때
    //   목표색이 그 순간 확정돼 보간이 한 프레임에 끝난다. 아래에서 양 끝 색을
    //   그대로 두고 t 로만 섞는다.
    //
    // off 글리프는 `Icon/Normal` 인데 이 앱 토큰에는 그 이름이 없다.
    // `labelNormal` 이 Light 에서 #333333 로 같은 값이라 그것을 쓴다(홈 학습
    // 현황 블록도 같은 매핑이다).
    final Color glyph = active
        ? (activeGlyph ?? context.c.staticWhite)
        : context.c.labelNormal;

    // 채움·테두리·글리프를 한 프레임에 갈면 잉크 물결만 남고 상태 변화가 안
    // 읽힌다. [Material.color] 는 암시적 애니메이션이 없으므로 색을 직접
    // 보간해서 넣는다.
    return Semantics(
      button: true,
      toggled: active,
      label: semanticLabel,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: active ? 1 : 0),
        duration: AppMotion.medium,
        curve: AppMotion.toggle,
        builder: (context, t, _) {
          // off 도 면이다 — 투명이 아니라 `Fill/Alternative` 에서 출발한다.
          final Color fillNow =
              Color.lerp(context.c.fillAlternative, activeFill, t)!;
          return Material(
            color: fillNow,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onChanged == null ? null : () => onChanged!(!active),
              child: SizedBox(
                width: size,
                height: size,
                child: Center(
                  child: AnimatedGlyphColor(
                    color: glyph,
                    builder: (c) => icon(size: _iconSize, color: c),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
