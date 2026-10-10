import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// 통화 화면 잠금 부품 — Figma `CallButton/Lock`(`6619:1818`) · `Call/LockRelease`(`6619:1863`).
///
/// 잠그기·풀기 **모두 길게 누르기**다(사용자 10-10 「잠금을 켤 때도 탭이 아니라 길게 누르는 걸로」).
/// 탭은 동작이 없다 — 손가락을 대는 순간 링이 차기 시작하고 [holdDuration] 이 다 차야 넘어간다.
/// 중간에 떼면 링이 비워지고 아무 일도 없다. 시간은 1초(PM-DEC-485 · 프로토타입과 같음).
const Duration holdDuration = Duration(seconds: 1);

/// 링 두께 = 지름의 5%(Figma `innerRadius 0.9`).
const double _ringStrokeRatio = 0.05;

/// 누르고 있는 동안 [progress] 0→1 을 [builder] 에 넘기고, 다 차면 [onCompleted] 를 부른다.
class _HoldToConfirm extends StatefulWidget {
  const _HoldToConfirm({required this.onCompleted, required this.builder});

  final VoidCallback onCompleted;
  final Widget Function(BuildContext context, double progress) builder;

  @override
  State<_HoldToConfirm> createState() => _HoldToConfirmState();
}

class _HoldToConfirmState extends State<_HoldToConfirm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: holdDuration)
        ..addStatusListener((s) {
          if (s != AnimationStatus.completed) return;
          _c.value = 0;
          widget.onCompleted();
        });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _start() => _c.forward(from: 0);

  void _release() {
    if (_c.isCompleted || _c.value == 0) return;
    _c.animateBack(0, duration: AppMotion.medium, curve: AppMotion.toggle);
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector 의 onLongPress 는 0.5초 뒤에야 시작한다 — 링이 손을 댄 순간부터 차야 해서
    // 포인터를 직접 본다.
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _start(),
      onPointerUp: (_) => _release(),
      onPointerCancel: (_) => _release(),
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => widget.builder(context, _c.value),
      ),
    );
  }
}

/// 12시 방향부터 시계 방향으로 차는 링. 트랙 `Line/Normal` · 진행 `Primary/Normal`.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * _ringStrokeRatio;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      paint..color = fill,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.track != track || old.fill != fill;
}

/// GNB 오른쪽 자물쇠 — `CallButton/Lock`. 상자 52(링 자리) 안에 원 40.
///
/// idle 은 원만, 누르는 중(holding)에는 원 둘레에 링 52 가 보인다.
class CallLockButton extends StatelessWidget {
  const CallLockButton({
    super.key,
    required this.onLocked,
    required this.semanticLabel,
  });

  /// 링이 다 찼을 때.
  final VoidCallback onLocked;

  /// 접근성 이름(「화면 잠금」).
  final String semanticLabel;

  /// 상자 크기(링 52). 원 40 은 그 가운데.
  static const double boxSize = 52;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: _HoldToConfirm(
        onCompleted: onLocked,
        builder: (context, progress) => SizedBox.square(
          dimension: boxSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (progress > 0)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RingPainter(
                      progress: progress,
                      track: c.lineNormal,
                      fill: c.primaryNormal,
                    ),
                  ),
                ),
              Container(
                width: AppSpacing.s40,
                height: AppSpacing.s40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.fillNormal,
                ),
                alignment: Alignment.center,
                // `Icon/Normal` = labelNormal(이 앱 토큰에는 Icon 이름이 없다 · call_toggle_button 과 같음).
                child: AppIcons.lock(
                  size: AppSpacing.s20,
                  color: c.labelNormal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 잠긴 화면 가운데 해제 버튼 — `Call/LockRelease`(202×148).
///
/// 링 96(트랙 상시) + 원 80 + 12 아래 알약 「길게 누르면 잠금이 풀려요」.
class CallLockRelease extends StatelessWidget {
  const CallLockRelease({
    super.key,
    required this.onUnlocked,
    required this.message,
    required this.semanticLabel,
  });

  final VoidCallback onUnlocked;

  /// 알약 문구.
  final String message;

  /// 접근성 이름(「잠금 해제」).
  final String semanticLabel;

  static const double _ring = 96;
  static const double _circle = AppSpacing.s80;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: semanticLabel,
          child: _HoldToConfirm(
            onCompleted: onUnlocked,
            builder: (context, progress) => SizedBox.square(
              dimension: _ring,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: progress,
                  track: c.lineNormal,
                  fill: c.primaryNormal,
                ),
                child: Center(
                  child: Container(
                    width: _circle,
                    height: _circle,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.backgroundElevatedAlternative,
                    ),
                    alignment: Alignment.center,
                    // `Icon/Strong` = labelStrong.
                    child: AppIcons.lock(
                      size: AppSpacing.s32,
                      color: c.labelStrong,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s8,
            horizontal: 14, // Figma 14(AppSpacing 토큰 없음)
          ),
          decoration: BoxDecoration(
            color: c.labelStrong,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: AppType.body1.b.copyWith(color: c.commonDarkAndWhite),
          ),
        ),
      ],
    );
  }
}
