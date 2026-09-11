import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/normalcall/domain/entities/call_hint.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// In-call hint card — Figma `card/hint` (`3229:56`), states `peek`/`full` ×
/// `suggestion=1|2|3`.
///
/// Controlled: the host owns [revealed] and [index] and reacts to callbacks.
/// - **peek** (`revealed == false`): shows only suggestion 1's Korean line plus
///   an expand affordance — the example detail stays hidden so the learner
///   recalls first. Tapping the card fires [onReveal].
/// - **full** (`revealed == true`): shows the "Hint" header, an `N/3` counter +
///   cycle control ([onCycle] advances 1→2→3, wrapping), and the current
///   example's Korean / romanization / native gloss.
///
/// **Both controls — speaker and bookmark — are always drawn**, in peek and in
/// full alike (Figma `card/hint` shows the speaker in both). They used to be
/// gated on their callback being non-null, which is why the speaker never once
/// appeared in the app: `call.dart` never passed [onSpeak]. A control that
/// belongs to the card must not vanish because its data hasn't arrived — the
/// host takes the tap and says why instead.
///
/// Tapping either control in **peek** does not expand the card: the buttons are
/// their own tap targets inside the card's [InkWell].
class HintCard extends StatelessWidget {
  const HintCard({
    super.key,
    required this.examples,
    required this.revealed,
    required this.index,
    required this.onReveal,
    required this.onCycle,
    this.onSpeak,
    this.bookmarked = false,
    this.onBookmarkTap,
  });

  /// The 1–3 example answers.
  final List<HintExample> examples;

  /// Whether the card is expanded (full) vs collapsed (peek).
  final bool revealed;

  /// Currently shown example index (host clamps/wraps).
  final int index;

  /// Fired when the learner first expands the card (peek → full).
  final VoidCallback onReveal;

  /// Fired to advance to the next example (wraps at the end).
  final VoidCallback onCycle;

  /// Plays the current example's audio. The button is drawn either way; a null
  /// callback only makes it inert (hosts pass one that explains the failure).
  final VoidCallback? onSpeak;

  /// Whether the **current** example is bookmarked (filled vs outline glyph).
  final bool bookmarked;

  /// Saves/unsaves the current example. Drawn either way, as with [onSpeak].
  final VoidCallback? onBookmarkTap;

  HintExample get _current =>
      examples[index.clamp(0, examples.length - 1)];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = Container(
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: revealed ? _full(context, l10n) : _peek(context),
    );

    // In peek the whole card is the reveal target; in full the card itself is
    // inert (its inner controls handle taps).
    if (revealed) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onReveal, child: card),
    );
  }

  Widget _peek(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16, AppSpacing.s12, AppSpacing.s12, AppSpacing.s12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              examples.first.korean,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          _speakButton(context),
          const SizedBox(width: AppSpacing.s8),
          _bookmarkButton(context, AppLocalizations.of(context)),
          const SizedBox(width: AppSpacing.s8),
          // Expand affordance: chevron-right rotated to point up (no chevron-up
          // asset). Decorative — the whole card is the tap target.
          Transform.rotate(
            angle: -math.pi / 2,
            child: AppIcons.chevronRight(
                size: 20, color: context.c.labelNormal),
          ),
        ],
      ),
    );
  }

  /// 정본 `card/hint · state=full` 은 **3행**이다 — 머리행 / 본문행 / 액션행.
  ///
  /// 종전에는 2행이었고 스피커·북마크가 본문 텍스트 **오른쪽에 인라인**으로
  /// 붙어 있었다. 그래서 한국어 줄이 길어지면 텍스트 폭이 버튼에 먹혀 일찍
  /// 줄바꿈됐다. 버튼을 제 행으로 내리면 본문이 카드 폭을 온전히 쓴다.
  Widget _full(BuildContext context, AppLocalizations l10n) {
    final ex = _current;
    return Padding(
      // 정본은 상 12 / 좌·우·하 14 다. 14 는 `AppSpacing` 에 없는 값이라
      // s16 을 쓴다 — 규약이 스케일 밖 숫자를 금한다(작업지시 §9).
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16, AppSpacing.s12, AppSpacing.s16, AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── row/top — 좌 [Hint] · 우 [사이클][N/3] ──────────
          Row(
            children: [
              // Non-flex: the short "Hint" label must not share flex with the
              // Spacer (that split the row 50/50 and shoved the counter/cycle
              // group left instead of pinning it to the right).
              Text(
                l10n.hintLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppType.caption2.sb.copyWith(color: context.c.accentActive),
              ),
              const Spacer(),
              if (examples.length > 1) ...[
                // 정본 순서는 [아이콘][N/3] 이다. 종전은 반대였다.
                Semantics(
                  button: true,
                  label: l10n.nextHint,
                  child: InkResponse(
                    onTap: onCycle,
                    radius: 18,
                    child: AppIcons.redo(
                        size: 16, color: context.c.labelNormal),
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Text('${index + 1}/${examples.length}',
                    style: AppType.caption2.r
                        .copyWith(color: context.c.labelNormal)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          // ── row/body — 텍스트만. 버튼은 아래 액션행으로 내려갔다 ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ex.korean,
                  style: AppType.body1.sb
                      .copyWith(color: context.c.labelStrong)),
              if (ex.roman != null && ex.roman!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(ex.roman!,
                    style: AppType.caption1.r
                        .copyWith(color: context.c.labelNormal)),
              ],
              if (ex.native.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(ex.native,
                    style: AppType.caption1.r
                        .copyWith(color: context.c.labelNormal)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          // ── 액션행 — 우측 정렬, [스피커][북마크] ────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _outlinedAction(
                context,
                semanticLabel: l10n.listenStandard,
                onTap: onSpeak,
                icon: AppIcons.volume(size: 20, color: context.c.labelNormal),
              ),
              const SizedBox(width: AppSpacing.s8),
              _outlinedAction(
                context,
                semanticLabel:
                    bookmarked ? l10n.unsaveSentence : l10n.saveSentence,
                onTap: onBookmarkTap,
                icon: bookmarked
                    ? AppIcons.bookmarkFill(
                        size: 20, color: context.c.primaryNormal)
                    : AppIcons.bookmarkLine(
                        size: 20, color: context.c.labelNormal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// `full` 의 액션 버튼 — **채움 없이 테두리만** 두른 32 원형.
  ///
  /// `peek` 의 [_speakButton]·[_bookmarkButton] 과 겉모습이 다르다. peek 은
  /// 정본이 안 바뀌었으므로 종전 채움 원을 그대로 둔다 — 두 경로를 한
  /// 위젯으로 합치면 peek 이 같이 변한다.
  Widget _outlinedAction(
    BuildContext context, {
    required String semanticLabel,
    required Widget icon,
    required VoidCallback? onTap,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(color: context.c.lineNeutral),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  /// Save/unsave the current example — same 32px circle as the speaker button,
  /// same glyph pair as `CardBookmark` so a saved hint reads identically to a
  /// saved sentence elsewhere in the app.
  Widget _bookmarkButton(BuildContext context, AppLocalizations l10n) {
    return Semantics(
      button: true,
      label: bookmarked ? l10n.unsaveSentence : l10n.saveSentence,
      child: Material(
        color: context.c.backgroundElevatedNormal,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onBookmarkTap,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: bookmarked
                  ? AppIcons.bookmarkFill(
                      size: 20, color: context.c.primaryNormal)
                  : AppIcons.bookmarkLine(
                      size: 20, color: context.c.labelStrong),
            ),
          ),
        ),
      ),
    );
  }

  Widget _speakButton(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).listenStandard,
      child: Material(
        color: context.c.backgroundElevatedNormal,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onSpeak,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: AppIcons.volume(size: 20, color: context.c.labelStrong),
            ),
          ),
        ),
      ),
    );
  }
}
