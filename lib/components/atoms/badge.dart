import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// Face/label colour pairing of a [Badge] — the Figma `tone=*` variant
/// (`Badge` `4204:551`).
///
/// Every pair keeps the face-vs-text token split (work order §1-2): faces come
/// from `Status/*` / alpha tokens, text from `*/Foreground` or the label ramp.
enum BadgeTone {
  /// Grey pill — `Current` on the Free manage screen.
  neutral,

  /// Mint on a mint-14 face — `Renewing`.
  brand,

  /// Solid gold face, black label — the Max tier chip.
  gold,

  /// Gold-tinted face, orange label — `Trial`.
  goldSubtle,

  /// Green on a green-4 face — success states.
  positive,

  /// Red on a red-6 face — `Past due` / `Paused`.
  negative,
}

/// Status pill — Figma `Badge` (`4204:551`), measured 2026-08-03.
///
/// A min-26px-high pill, 10px side padding, Caption 1 SemiBold label. Purely
/// presentational: mapping a `SubscriptionBadge` domain value to a tone and an
/// l10n label is the screen's job, not this atom's.
class Badge extends StatelessWidget {
  /// Creates a badge.
  const Badge({super.key, required this.tone, required this.label});

  /// Colour pairing; see [BadgeTone].
  final BadgeTone tone;

  /// Pill text. Comes from l10n at the call site — never hardcoded copy.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (Color bg, Color fg) = switch (tone) {
      BadgeTone.neutral => (c.backgroundElevatedNormal, c.labelNormal),
      BadgeTone.brand => (c.primaryNormal14, c.primaryNormal),
      BadgeTone.gold => (c.statusCautionary, c.staticBlack),
      BadgeTone.goldSubtle =>
        (c.statusCautionarySurface, c.accentForegroundOrange),
      // The Figma variant paints this label `Status/Positive`. In Dark that is
      // the same value as `Accent/Foreground/Green`, but in Light it is a face
      // colour that fails contrast as text (1.82:1) — the exact trap work
      // order §1-2 calls out. Foreground token, deliberately.
      BadgeTone.positive => (c.statusPositive4, c.accentForegroundGreen),
      BadgeTone.negative => (c.statusNegative6, c.accentForegroundRed),
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
      ),
      // ⛔ `Container` 의 `alignment:` 를 쓰지 마라 — **폭을 꽉 채운다.**
      //   그 인자는 자식을 `Align` 으로 감싸는데, `Align` 은 폭 제약이 있으면
      //   최대치까지 늘어난다. `Row(mainAxisSize: min)` 안에서는 가로 제약이
      //   없어 hug 처럼 보이지만, `Wrap` 처럼 폭을 주는 부모에 넣으면 알약이
      //   화면을 가로지른다(홈 학습 현황에서 실제로 났다, 2026-09-13).
      //
      //   `widthFactor: 1` 이 그 차이다 — 가로는 내용만큼(hug), 세로는
      //   `minHeight` 26 까지 늘어나 글자를 가운데 둔다.
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        // 폭이 모자라면 **줄바꿈한다** — 자르지 않는다. `Text` 의 기본 거동이다.
        // `maxLines: 1` + 줄임표를 붙였다가 되돌렸다(2026-09-13): 배지가 나르는
        // 것은 차시 코드·상태처럼 **잘리면 뜻이 사라지는 짧은 말**이라, 자리를
        // 못 만들면 줄을 늘리는 편이 맞다.
        child: Text(label, style: AppType.caption1.sb.copyWith(color: fg)),
      ),
    );
  }
}
