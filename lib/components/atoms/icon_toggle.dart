import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_motion.dart';
import '../icons/app_icons.dart';

/// IconToggle — 켜짐/꺼짐 글리프를 부드럽게 갈아 끼우는 아이콘 토글.
///
/// 북마크(line↔fill)·알람 같은 아이콘 토글은 원래 글리프를 **즉시** 바꿔 껐다
/// 켠 티가 안 났다. 여기서는 세 가지가 한 번에 움직인다 —
///
/// * 글리프 **교차 페이드** — off 가 사라지는 동안 on 이 올라온다.
/// * **팝** — 전환 한가운데서 최대 +24% 로 부풀었다 제자리로 돌아온다.
///   `sin(t·π)` 라 켤 때와 끌 때가 대칭이고, 끝값이 정확히 1 이라 잔여 스케일이
///   남지 않는다.
/// * **색 보간** — [offColor]→[onColor] 를 같은 곡선으로 섞는다.
///
/// 위젯은 [size]×[size] 를 그대로 차지한다. 팝은 `Transform` 이라 레이아웃을
/// 건드리지 않는다 — 눌린 자리에서 아이콘이 밀리면 그건 토글이 아니라 결함이다.
class IconToggle extends StatelessWidget {
  /// Creates an animated two-glyph icon toggle.
  const IconToggle({
    super.key,
    required this.value,
    required this.onIcon,
    required this.offIcon,
    required this.onColor,
    required this.offColor,
    this.size = 24,
    this.duration = AppMotion.medium,
    this.semanticLabel,
    this.onTap,
  });

  /// Whether the toggle is on (renders [onIcon]).
  final bool value;

  /// Glyph shown when [value] is true (e.g. `AppIcons.bookmarkFill`).
  final AppIconBuilder onIcon;

  /// Glyph shown when [value] is false (e.g. `AppIcons.bookmarkLine`).
  final AppIconBuilder offIcon;

  /// Glyph colour when on.
  final Color onColor;

  /// Glyph colour when off.
  final Color offColor;

  /// Glyph box size (both axes).
  final double size;

  /// Transition length. 기본은 [AppMotion.medium] — 앱의 두방향 상태 전환과
  /// 같은 값이라 북마크만 따로 놀지 않는다.
  final Duration duration;

  /// Accessible label; when null the caller supplies its own [Semantics].
  final String? semanticLabel;

  /// Tap handler. Null 이면 표시 전용이고 히트 테스트도 붙지 않는다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget glyph = TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value ? 1 : 0),
      duration: duration,
      curve: AppMotion.toggle,
      builder: (context, t, _) {
        final color = Color.lerp(offColor, onColor, t)!;
        return Transform.scale(
          scale: 1 + 0.24 * math.sin(t * math.pi),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(opacity: 1 - t, child: offIcon(size: size, color: color)),
                Opacity(opacity: t, child: onIcon(size: size, color: color)),
              ],
            ),
          ),
        );
      },
    );

    if (onTap != null) {
      glyph = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: glyph,
      );
    }
    if (semanticLabel == null) return glyph;
    return Semantics(button: onTap != null, label: semanticLabel, child: glyph);
  }
}

/// Gallery demo — tap either glyph to watch the transition.
class IconToggleDemo extends StatefulWidget {
  /// Creates the demo.
  const IconToggleDemo({super.key});

  @override
  State<IconToggleDemo> createState() => _IconToggleDemoState();
}

class _IconToggleDemoState extends State<IconToggleDemo> {
  bool _bookmark = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconToggle(
            value: _bookmark,
            onIcon: AppIcons.bookmarkFill,
            offIcon: AppIcons.bookmarkLine,
            onColor: Colors.green,
            offColor: Colors.grey,
            size: 32,
            onTap: () => setState(() => _bookmark = !_bookmark),
          ),
        ],
      ),
    );
  }
}
