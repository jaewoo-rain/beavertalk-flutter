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
/// `suggestion=1|2|3`. 실측 2026-09-12.
///
/// Controlled: the host owns [revealed] and [index] and reacts to callbacks.
/// - **peek** (`revealed == false`): 머리행(`Hint` + 사이클) 아래 한국어 한 줄과
///   펼치기 버튼만. 예문 상세는 감춰 둔다 — 먼저 떠올려 보게 하는 것이 목적이다.
/// - **full** (`revealed == true`): 머리행 + 본문(한국어·로마자·모국어 + 스피커)
///   + 저장 행.
///
/// ## 두 상태가 머리행을 공유한다
/// `Hint` 라벨과 `N/3` 사이클은 **양쪽이 같다.** 종전 peek 에는 머리행이 아예
/// 없어서 접힌 상태에서는 예문이 몇 개인지도, 지금 몇 번째인지도 알 수 없었다.
/// 그래서 peek 은 언제나 첫 예문만 보여 줬는데, 이제 **현재 예문**을 보여 준다
/// (정본이 `suggestion=1|2|3 × peek` 을 전부 그린다).
///
/// ## peek 에서 스피커·북마크가 빠졌다
/// 접힌 카드는 「무슨 문장인지 힐끗 본다」는 한 가지 일만 한다. 듣기·저장은
/// 문장을 펼쳐 본 뒤의 행동이라 full 로 내렸다 — 종전에는 70px 한 줄에 버튼이
/// 셋(스피커·북마크·펼치기) 붙어 정작 문장이 들어갈 폭을 먹고 있었다.
///
/// ## 카드 자체가 탭 타깃인 것은 peek 뿐이다
/// full 에서는 카드가 무반응이고 안쪽 버튼이 각자 탭을 받는다. peek 에서 사이클·
/// 펼치기 버튼을 눌러도 바깥 [InkWell] 이 아니라 그 버튼이 먼저 먹는다.
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

  /// 정본 패딩 — `AppSpacing` 스케일 밖이라 토큰이 없다.
  ///
  /// Figma 변수 `padding/v/12` · `padding/h/14` · `padding/v/10` · `padding/h/12`
  /// 를 그대로 쓴다. 스페이싱 스케일(4·8·12·16…)과 **별개인 패딩 컬렉션**이고,
  /// 같은 앱의 `Header/GNB` 도 `vertical: 14` 를 생으로 쓴다.
  static const EdgeInsets _fullPadding = EdgeInsets.fromLTRB(14, 12, 14, 14);
  static const EdgeInsets _peekPadding = EdgeInsets.fromLTRB(14, 10, 12, 10);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = Container(
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      padding: revealed ? _fullPadding : _peekPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _topRow(context, l10n),
          const SizedBox(height: AppSpacing.s8),
          revealed ? _fullBody(context, l10n) : _peekBody(context),
          if (revealed) ...[
            const SizedBox(height: AppSpacing.s8),
            _saveRow(context, l10n),
          ],
        ],
      ),
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

  /// `row/top` — 좌 `Hint` · 우 사이클 버튼. peek·full 공통이다.
  Widget _topRow(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        // Non-flex: the short "Hint" label must not share flex with the
        // Spacer (that split the row 50/50 and shoved the counter/cycle
        // group left instead of pinning it to the right).
        Text(
          l10n.hintLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppType.caption2.b.copyWith(color: context.c.accentActive),
        ),
        const Spacer(),
        // 예문이 하나뿐이면 셀 것도 돌릴 것도 없다.
        if (examples.length > 1)
          Semantics(
            button: true,
            // 정본은 아이콘과 `N/3` 을 **버튼 하나**로 묶는다. 안쪽 `Text` 가 제
            // 시맨틱 노드를 만들면 이 라벨이 가려지므로 자식을 덮고 하나로 읽힌다.
            //
            // 개수를 라벨에 **같이 넣는다.** 그냥 덮기만 하면 「2/3」이 시맨틱
            // 트리에서 사라져 스크린리더가 몇 번째인지 못 읽는다. 화면에 쓰는
            // 문구가 아니라 읽어 주는 문장이라 새 l10n 키를 만들지 않는다.
            container: true,
            excludeSemantics: true,
            label: '${l10n.nextHint} ${index + 1}/${examples.length}',
            child: InkResponse(
              onTap: onCycle,
              radius: 18,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcons.redo(size: 16, color: context.c.labelNormal),
                  const SizedBox(width: AppSpacing.s4),
                  Text(
                    '${index + 1}/${examples.length}',
                    style: AppType.caption2.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// `row/body · state=full` — 한국어·로마자·모국어 + 스피커.
  Widget _fullBody(BuildContext context, AppLocalizations l10n) {
    final ex = _current;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ex.korean,
                  style:
                      AppType.body1.b.copyWith(color: context.c.labelStrong)),
              if (ex.roman != null && ex.roman!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(ex.roman!,
                    style: AppType.caption1.r
                        .copyWith(color: context.c.labelNeutral)),
              ],
              if (ex.native.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(ex.native,
                    style: AppType.caption1.r
                        .copyWith(color: context.c.labelNeutral)),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        _speakButton(context, l10n),
      ],
    );
  }

  /// `row/body · state=peek` — 한국어 한 줄 + 펼치기 버튼.
  Widget _peekBody(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            // 종전엔 `examples.first` 였다 — 사이클을 돌리고 접으면 1번으로
            // 되돌아가 보여, 접힌 카드가 지금 몇 번째인지 거짓말을 했다.
            _current.korean,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.body1.b.copyWith(color: context.c.labelStrong),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        _expandButton(context),
      ],
    );
  }

  /// 저장 행 — 아이콘 + 라벨, **좌측 정렬**. full 에만 있다.
  ///
  /// 종전엔 32 원형 아이콘 버튼이었다. 글리프만으로는 무슨 뜻인지 안 읽혀
  /// 정본이 라벨을 붙였다. 라벨은 상태와 무관하게 `저장`(동작 이름)이고,
  /// 담겼는지는 **글리프와 색**이 말한다.
  Widget _saveRow(BuildContext context, AppLocalizations l10n) {
    final c = context.c;
    final tint = bookmarked ? c.primaryNormal : c.labelAlternative;
    return Semantics(
      button: true,
      // 행 전체가 버튼 **하나**다. `container` 없이는 안쪽 `Text('저장')` 이 제
      // 시맨틱 노드를 따로 만들어, 스크린리더가 「저장」과 「문장 저장」을 두 번
      // 읽고 `bySemanticsLabel` 도 라벨을 못 찾는다.
      container: true,
      excludeSemantics: true,
      label: bookmarked ? l10n.unsaveSentence : l10n.saveSentence,
      child: InkWell(
        onTap: onBookmarkTap,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            bookmarked
                ? AppIcons.bookmarkFill(size: 16, color: tint)
                : AppIcons.bookmarkLine(size: 16, color: tint),
            const SizedBox(width: AppSpacing.s4),
            Text(l10n.save,
                style: AppType.caption1.r.copyWith(color: tint)),
          ],
        ),
      ),
    );
  }

  /// `btn/speak` — 32 원형, **채움 없이 테두리만**.
  Widget _speakButton(BuildContext context, AppLocalizations l10n) {
    return Semantics(
      button: true,
      label: l10n.listenStandard,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(color: context.c.lineNeutral),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onSpeak,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child:
                  AppIcons.volume(size: 20, color: context.c.labelNormal),
            ),
          ),
        ),
      ),
    );
  }

  /// `btn/expand` — 26 원형, 글리프 14. 면도 테두리도 없다.
  ///
  /// 카드 전체가 이미 펼치기 타깃이라 이 버튼은 **어포던스**다. 그래도 탭을
  /// 받는 것은, 글리프를 보고 여기를 정확히 누르는 사람이 헛손질하지 않게
  /// 하려는 것이다(같은 [onReveal] 로 간다).
  ///
  /// ⛔ **시맨틱 라벨을 붙이지 않는다.** 펼치기는 카드 [InkWell] 이 이미 맡고
  ///   있어서 여기에 라벨을 주면 같은 동작이 버튼 둘로 읽힌다. 실제로
  ///   `hintLabel`("Hint")을 붙였다가 통화 화면의 **힌트 토글과 라벨이 겹쳐**
  ///   `bySemanticsLabel('Hint')` 가 둘을 집었다.
  Widget _expandButton(BuildContext context) {
    return InkResponse(
      onTap: onReveal,
      radius: 18,
      child: SizedBox(
        width: 26,
        height: 26,
        child: Center(
          // chevron-up 자산이 없어 chevron-right 를 세운다.
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: AppIcons.chevronRight(
                size: 14, color: context.c.labelNormal),
          ),
        ),
      ),
    );
  }
}
