import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 윈백 설문 사유 — 화면의 다섯 줄과 같은 순서.
enum WinbackReason { expensive, unused, missing, otherApp, other }

/// `depth/winback_survey` (`4514:5615`) — the exit survey after a lapse.
///
/// Skip bar instead of a GNB; five single-select reasons. **Opened by
/// `WinbackTrigger` once after an expiry is detected** (PM-DEC-034).
///
/// Pops with the picked [WinbackReason] on `Send` and with `null` on `Skip` /
/// `Not now` — the caller decides what follows: 「Too expensive」 → the win-back
/// offer sheet over home, anything else → home (PM-DEC-035·036). Nothing here
/// touches subscription state — the caption says so out loud.
class WinbackSurveyScreen extends StatefulWidget {
  /// Creates the winback survey.
  const WinbackSurveyScreen({super.key});

  @override
  State<WinbackSurveyScreen> createState() => _WinbackSurveyScreenState();
}

class _WinbackSurveyScreenState extends State<WinbackSurveyScreen> {
  /// 고른 사유. **기본 선택 없음**(PM-DEC-042) — 기본이 「Too expensive」 면 그냥 누른 Send 가
  /// 전부 오퍼로 몰리고 사유 데이터가 왜곡된다. 고르기 전에는 Send 가 꺼져 있다.
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final reasons = [
      l10n.winbackReasonExpensive,
      l10n.winbackReasonUnused,
      l10n.winbackReasonMissing,
      l10n.winbackReasonOtherApp,
      l10n.winbackReasonElse,
    ];
    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Align(
              alignment: Alignment.centerRight,
              child: ContentColumn(
                // 버튼 역할을 알린다 — 글자만 있는 탭 영역이라 스크린리더가 「Skip」 을
                // 그냥 글자로 읽었다(QA F060).
                child: Semantics(
                  button: true,
                  child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Text(l10n.winbackSkip,
                        style: AppType.body1.sb
                            .copyWith(color: c.labelNormal)),
                  ),
                ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                children: [
                  Text(l10n.winbackTitle,
                      style: AppType.title3.sb.copyWith(color: c.labelStrong)),
                  const SizedBox(height: AppSpacing.s8),
                  Text(l10n.winbackSub,
                      style: AppType.body2.r.copyWith(color: c.labelNormal)),
                  const SizedBox(height: AppSpacing.s24),
                  Text(l10n.winbackQuestion,
                      style: AppType.body1.sb.copyWith(color: c.labelStrong)),
                  const SizedBox(height: AppSpacing.s16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: c.backgroundSurfaceAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < reasons.length; i++)
                          _ReasonRow(
                            label: reasons[i],
                            selected: _selected == i,
                            last: i == reasons.length - 1,
                            onTap: () => setState(() => _selected = i),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.ctaSend,
                    // TODO(server): submit the reason once an endpoint exists.
                    disabled: _selected == null,
                    onPressed: () =>
                        Navigator.pop(context, WinbackReason.values[_selected!]),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Button(
                    type: BtnType.secondaryFill,
                    size: BtnSize.s60,
                    text: l10n.ctaNotNow,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.winbackCaption,
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal),
                  ),
                ],
              ),
            ),
          ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// One 56px single-select row with the 22px radio, last row divider-free.
class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.label,
    required this.selected,
    required this.last,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    // 단일 선택 목록의 한 줄 — 선택됨/안 됨과 「여럿 중 하나」 를 스크린리더에 알린다.
    // 색 원만으로 선택을 보여 TalkBack·VoiceOver 는 무엇을 골랐는지 알 수 없었다(QA F060).
    return Semantics(
      container: true,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      selected: selected,
      child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // 높이 하한. 해지 사유는 문장이라 로케일에 따라 두 줄이 된다
        // (hu 「Nem használtam eleget」: 필요 66 / 상자 55.5, 320dp·배율 1.1).
        // 고정으로 두면 둘째 줄이 사라져 무슨 사유를 고르는지 모르게 된다.
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: last
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: c.lineAlternative, width: 0.5),
                ),
              ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style:
                      AppType.label1.r.copyWith(color: c.commonWhiteAndDark)),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: selected
                  ? BoxDecoration(
                      shape: BoxShape.circle, color: c.primaryNormal)
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.backgroundNormalAlternative,
                      border: Border.all(color: c.labelAlternative),
                    ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.primaryOnPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
