import 'package:flutter/material.dart';

import '../../../components/atoms/button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../domain/phoneme_diagram.dart';

/// 발음 교정 시트에 실을 내용 한 벌.
///
/// [current] 는 **학습자가 실제로 낸 소리**다. 서버 채점(`ReviewFeedback`)은 글자
/// 단위까지만 주므로 이 값은 음소 인식이 붙어야 채워진다. 없으면 시트는 목표 도해
/// 한 컷만 보여준다 — 무엇으로 잘못 냈는지를 모르면서 두 컷을 그리면 도해가
/// 거짓말을 한다.
class ArticulationSheetData {
  /// Creates the payload for one correction sheet.
  const ArticulationSheetData({
    required this.word,
    required this.target,
    this.current,
    this.description,
    this.cues = const <String>[],
  });

  /// 사용자가 고른 단어(어절). 헤더에 그대로 실린다.
  final String word;

  /// 목표 발음의 도해.
  final PhonemeDiagram target;

  /// 실제 발음의 도해. null 이면 한 컷만 그린다.
  final PhonemeDiagram? current;

  /// 왜 그렇게 들렸는지 — 한두 문장. null 이면 문단을 아예 안 그린다.
  ///
  /// 지금은 비어 있다. 이 문장은 **어느 음소를 어떻게 틀렸는지**를 알아야 쓸 수
  /// 있는데, 서버 채점은 글자 단위까지만 준다. 음소 인식이 붙기 전까지 도해가
  /// 설명을 대신한다 — 없는 근거로 문장을 지어내지 않는다.
  final String? description;

  /// 교정 포인트 태그.
  final List<String> cues;
}

/// 발음 교정 바텀시트를 띄운다.
///
/// 배리어·배경 규약은 통화 화면 시트와 맞춘다(투명 배경 + `materialDim`).
/// [onPlayNative] 가 null 이면 주행동 버튼을 감춘다 — 누를 수 없는 버튼을 두면
/// 눌러도 아무 일 없는 자리가 생긴다.
Future<void> showArticulationSheet(
  BuildContext context, {
  required ArticulationSheetData data,
  VoidCallback? onPlayNative,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.c.materialDim,
    isScrollControlled: true,
    builder: (sheetCtx) => _ArticulationSheet(
      data: data,
      onPlayNative: onPlayNative,
    ),
  );
}

class _ArticulationSheet extends StatelessWidget {
  const _ArticulationSheet({required this.data, this.onPlayNative});

  final ArticulationSheetData data;
  final VoidCallback? onPlayNative;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: c.backgroundElevatedAlternative,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.s24),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s12,
          AppSpacing.s20,
          AppSpacing.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.lineNeutral,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            _wordHeader(context, l10n),
            const SizedBox(height: AppSpacing.s20),
            _diagrams(context, l10n),
            if (data.description != null) ...[
              const SizedBox(height: AppSpacing.s16),
              Text(
                data.description!,
                style: AppType.label2.r.copyWith(color: c.labelNeutral),
              ),
            ],
            if (data.cues.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s12),
              Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s8,
                children: [for (final cue in data.cues) _tag(context, cue)],
              ),
            ],
            const SizedBox(height: AppSpacing.s20),
            _actions(context, l10n),
          ],
        ),
      ),
    );
  }

  /// 선택한 단어 — 판정 색은 **도트와 배경 틴트로만** 낸다. 라벨을 상태색으로 칠하면
  /// 대비가 떨어지고, 색 하나가 두 가지 뜻(판정·강조)을 겸하게 된다.
  Widget _wordHeader(BuildContext context, AppLocalizations l10n) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: c.statusNegative6,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: c.statusNegative,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Flexible(
            child: Text(
              '${l10n.articulationSelectedWord} · ${data.word}',
              style: AppType.label2.b.copyWith(color: c.labelNormal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 현재와 목표 두 컷. [ArticulationSheetData.current] 가 없으면 목표 한 컷만.
  Widget _diagrams(BuildContext context, AppLocalizations l10n) {
    final current = data.current;
    if (current == null) {
      return Center(
        child: _column(
          context,
          caption: l10n.articulationTargetSound,
          diagram: data.target,
          emphasised: true,
          width: 168,
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _column(
            context,
            caption: l10n.articulationYouSaid,
            diagram: current,
            emphasised: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s48),
          child: Text(
            '→',
            style: AppType.headline1.b
                .copyWith(color: context.c.labelAlternative),
          ),
        ),
        Expanded(
          child: _column(
            context,
            caption: l10n.articulationTargetSound,
            diagram: data.target,
            emphasised: true,
          ),
        ),
      ],
    );
  }

  Widget _column(
    BuildContext context, {
    required String caption,
    required PhonemeDiagram diagram,
    required bool emphasised,
    double? width,
  }) {
    final c = context.c;
    final labelColour = emphasised ? c.primaryHeavy : c.labelAlternative;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          caption,
          style: (emphasised ? AppType.label2.b : AppType.label2.r)
              .copyWith(color: labelColour),
        ),
        const SizedBox(height: AppSpacing.s8),
        // 도해는 그림 자체가 다크 카드라 라운드만 준다 — 배경을 또 깔 필요가 없다.
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.s12),
          child: Image.asset(
            diagram.asset,
            width: width,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          diagram.jamo,
          style: (emphasised ? AppType.label2.b : AppType.label2.r)
              .copyWith(color: labelColour),
        ),
      ],
    );
  }

  Widget _tag(BuildContext context, String text) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: c.primaryNormal10,
        borderRadius: BorderRadius.circular(AppSpacing.s8),
      ),
      child: Text(
        text,
        style: AppType.label2.b.copyWith(color: c.primaryHeavy),
      ),
    );
  }

  Widget _actions(BuildContext context, AppLocalizations l10n) {
    final close = Button(
      type: BtnType.secondaryFill,
      text: l10n.close,
      onPressed: () => Navigator.of(context).pop(),
    );
    if (onPlayNative == null) return close;
    return Row(
      children: [
        Expanded(flex: 2, child: close),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          flex: 3,
          child: Button(
            type: BtnType.primaryFill,
            text: l10n.listenStandard,
            onPressed: onPlayNative,
          ),
        ),
      ],
    );
  }
}
