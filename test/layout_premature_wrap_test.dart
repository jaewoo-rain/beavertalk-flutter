// 이른 줄바꿈 감시 — 「칸이 남아 보이는데 글자가 줄바꿈된다」를 기계로 잡는다.
//
// 2026-09-24 사장님 지적: 설정 화면 이메일 `bt.qa.free0924@example.` / `com`.
// 라벨 「Email」은 짧은데 `_infoRow` 가 라벨:값을 2:3 으로 고정 분할해, 값은
// 60% 안에서만 흐르고 라벨 칸 40% 는 대부분 비어 있었다.
//
// 뿌리는 R11 과 같다 — 유연 칸이 **필요가 아니라 비율로** 폭을 나눈다.
//   · Flexible/Expanded 가 둘 이상이면 몫은 flex 비율로 정해지고, 한 칸이 남겨도
//     다른 칸이 가져가지 못한다(Flexible 은 남긴 폭을 행 끝에 버린다).
//
// 잡는 것(가로 RenderFlex, flex 자식 둘 이상):
//   [확정] 한 flex 칸의 글자가 **여러 줄**인데, 다른 flex 칸이 자기 몫보다
//          좁은 글자만 담아 **여유가 8px 넘게** 남고, 그 여유를 받으면 한 줄에 들어간다.
//   [잠재] 한 flex 칸이 몫보다 24px 넘게 여유가 남고, 옆 flex 칸은 몫을 꽉 채운다.
//          지금 데이터로는 안 넘쳐도, 값이 길어지면(이메일·이름·번역) 줄바꿈된다.
//
// ⛔ **게이트다**(09-24 정식 등록). [확정]이 하나라도 있으면 실패한다. [잠재]는 보고만 한다.
//   고치는 법: 라벨·값 행은 `LabelValueRow`, 가운데 제목 머리는 `CenteredTitleRow`
//   (lib/components/layout/need_based_rows.dart). 버튼 쌍은 가로에 두지 않는다 — 항상 세로
//   `StackedButtonPair`(09-24 사장님 확정 · lib/components/molecules/stacked_button_pair.dart).
//   균등 격자가 **Figma 의도**인 행만 `FigmaEqualColumns(figmaNode: …)` 로 감싸 건너뛴다 —
//   노드 ID 가 근거다. 근거 없이 감싸서 통과시키지 마라.
//   출처: 통합 담당 세션 전수조사 `40_배포베타_하네스/_output/2026-09-23_앱브랜치정리/`.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/layout/need_based_rows.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

import 'support/i18n_screens.dart';

String _owner(RenderObject ro) {
  final creator = ro.debugCreator;
  if (creator is! DebugCreator) return '?';
  final names = <String>[];
  const skip = {
    'Padding', 'Row', 'Column', 'Flex', 'Center', 'Flexible', 'Expanded',
    'SizedBox', 'Container', 'DecoratedBox', 'Align', 'ConstrainedBox',
    'DefaultTextStyle', 'MediaQuery', 'Semantics', 'Builder', 'InkWell',
    'GestureDetector', 'Material', 'Text', 'RichText', 'Wrap', 'LayoutBuilder',
  };
  creator.element.visitAncestorElements((a) {
    final n = a.widget.runtimeType.toString();
    if (n.startsWith('_') || skip.contains(n)) return true;
    names.add(n);
    return names.length < 3;
  });
  return names.join('<');
}

/// Figma 균등 격자로 표시된 행인가([FigmaEqualColumns] 안).
bool _inEqualGrid(RenderObject ro) {
  final creator = ro.debugCreator;
  if (creator is! DebugCreator) return false;
  var found = false;
  creator.element.visitAncestorElements((a) {
    if (a.widget is FigmaEqualColumns) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

List<RenderParagraph> _paragraphs(RenderObject r) {
  final out = <RenderParagraph>[];
  void walk(RenderObject x) {
    if (x is RenderParagraph) out.add(x);
    x.visitChildren(walk);
  }
  walk(r);
  return out;
}

void main() {
  const locales = [Locale('en'), Locale('ko'), Locale('ja'), Locale('de'), Locale('ru')];
  const widths = [320.0, 360.0];

  testWidgets('칸이 남는데 글자가 줄바꿈되는 행이 없다', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final confirmed = <String, Set<String>>{};
    final potential = <String, Set<String>>{};

    for (final w in widths) {
      tester.view.physicalSize = Size(w, 780);
      for (final locale in locales) {
        for (final entry in i18nScreens().entries) {
          try {
            await tester.pumpWidget(ProviderScope(
              child: MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: entry.value(),
              ),
            ));
            await tester.pump(const Duration(milliseconds: 32));
          } catch (_) {}
          tester.takeException();

          void visit(RenderObject ro) {
            if (ro is RenderFlex &&
                ro.direction == Axis.horizontal &&
                ro.hasSize &&
                !_inEqualGrid(ro)) {
              final flexKids = <RenderBox>[];
              ro.visitChildren((c) {
                final pd = c.parentData;
                if (c is RenderBox && c.hasSize && pd is FlexParentData && (pd.flex ?? 0) > 0) {
                  flexKids.add(c);
                }
              });
              if (flexKids.length >= 2) {
                // 칸마다: 차지한 폭 · 글자가 한 줄일 때 필요한 폭 · 여러 줄인가
                final info = flexKids.map((c) {
                  final paras = _paragraphs(c);
                  final need = c.getMaxIntrinsicWidth(double.infinity);
                  final multi = paras.any((p) => p.hasSize && p.getMaxIntrinsicWidth(double.infinity) > p.size.width + 0.5);
                  final pd = c.parentData! as FlexParentData;
                  // Flexible(느슨)은 자기 폭이 곧 쓴 폭이라 몫을 따로 구한다.
                  return (box: c, need: need, multi: multi, fit: pd.fit, flex: pd.flex ?? 1,
                      text: paras.map((p) => p.text.toPlainText()).join(' '));
                }).toList();
                // 몫(allocation): flex 칸들이 나눠 가진 폭 = 행 폭 − 고정 칸 폭
                var fixed = 0.0;
                ro.visitChildren((c) {
                  final pd = c.parentData;
                  if (c is RenderBox && c.hasSize && !(pd is FlexParentData && (pd.flex ?? 0) > 0)) {
                    fixed += c.size.width;
                  }
                });
                final totalFlex = info.fold<int>(0, (a, b) => a + b.flex);
                final space = ro.size.width - fixed;
                double share(int flex) => space * flex / totalFlex;

                for (final a in info) {
                  final slackA = share(a.flex) - a.need;
                  for (final b in info) {
                    if (identical(a, b)) continue;
                    final key = '${_owner(ro)} "${a.text.length > 24 ? a.text.substring(0, 24) : a.text}" ↔ "${b.text.length > 24 ? b.text.substring(0, 24) : b.text}"';
                    if (b.multi && slackA > 8 && b.need <= b.box.size.width + slackA) {
                      confirmed.putIfAbsent(key, () => {}).add('${entry.key}@${locale.languageCode}/${w.toInt()} 여유${slackA.toStringAsFixed(0)}');
                    } else if (slackA > 24 && b.need > share(b.flex) - 1 && b.text.isNotEmpty) {
                      potential.putIfAbsent(key, () => {}).add('${entry.key}@${locale.languageCode}/${w.toInt()}');
                    }
                  }
                }
              }
            }
            ro.visitChildren(visit);
          }

          visit(tester.binding.renderViews.first);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    }

    String fmt(Map<String, Set<String>> m) {
      final lines = <String>[];
      m.forEach((k, v) {
        final l = v.toList()..sort();
        lines.add('  $k — ${l.length}건 · ${l.take(6).join(', ')}${l.length > 6 ? ' …' : ''}');
      });
      lines.sort();
      return lines.join('\n');
    }

    // ⚠ build/ 에 쓰지 않는다 — build/ 가 있으면 custom_lint 가 죽는다(R9 게이트 순서).
    final report = '[확정] ${confirmed.length}곳\n${fmt(confirmed)}\n\n'
        '[잠재] ${potential.length}곳\n${fmt(potential)}\n';
    File('${Directory.systemTemp.path}/premature_wrap_report.txt')
        .writeAsStringSync(report);
    expect(confirmed, isEmpty,
        reason: '칸이 남는데 글자가 줄을 바꾸는 행이 있다(R11). 보고:\n$report');
  });
}
