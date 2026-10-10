// 행 끝의 죽은 공간 감시 — 「요소가 한쪽으로 몰려 있다」를 기계로 잡는다.
//
// 2026-09-22~23 사장님이 하나씩 지적한 결함이 전부 같은 모양이었다.
//   · 마이페이지 카드 머리 — 제목·부제가 Flexible 둘이라 행이 반반 갈리고 부제가 줄바꿈
//   · 알람 시트 머리 — 가운데 제목이 Flexible 이라 왼쪽으로 밀려 「취소」에 붙음
//   · 알람 설정 행 — 라벨·값·셰브런이 오른쪽 끝에 붙지 않고 가운데에 몰림
//
// 공통점: **늘어나라고 둔 칸(flex 자식)이 있는데도 행 끝에 빈 공간이 남는다.**
// `Flexible`(느슨)은 필요한 만큼만 차지하므로, 몫이 남아도 아무도 안 가져가
// 행 끝에 버려진다. 늘어나는 칸을 둔 목적 자체가 그 공간을 먹는 것이라,
// 그런데도 공간이 남으면 거의 항상 결함이다.
//
// 잡는 조건(전부 만족):
//   ① 가로 RenderFlex, mainAxisAlignment == start
//   ② 느슨한 flex 자식(`Flexible`)이 하나 이상
//   ③ flex 자식이 둘 이상이거나, 느슨한 flex 자식 **뒤에** 고정 자식(값·셰브런·토글)이 있음
//      — 오른쪽 끝에 붙어야 할 것이 있다는 뜻
//   ④ 행 끝의 빈 공간 > 16px
//
// ⚠ 시험 폰트는 글자를 실제보다 **넓게** 잰다. 그래서 여기서 나오는 빈 공간은
//   실기기에서 **더 크다** — 오탐 방향이 아니라 놓침 방향이다. 여기서 잡히면 진짜다.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';

import 'support/i18n_screens.dart';

/// 이 RenderFlex 를 만든 **앱 위젯** 이름 몇 개(프레임워크 위젯은 건너뛴다).
String _owner(RenderObject ro) {
  final creator = ro.debugCreator;
  if (creator is! DebugCreator) return '?';
  final names = <String>[];
  creator.element.visitAncestorElements((a) {
    final n = a.widget.runtimeType.toString();
    const skip = {
      'Padding', 'Row', 'Column', 'Flex', 'Center', 'Flexible', 'Expanded',
      'SizedBox', 'Container', 'DecoratedBox', 'Align', 'Stack', 'ConstrainedBox',
      'DefaultTextStyle', 'MediaQuery', 'Semantics', 'RepaintBoundary',
      'Directionality', 'Builder', 'InkWell', 'GestureDetector', 'Material',
      'AnimatedContainer', 'ClipRRect', 'Positioned', 'Wrap', 'IntrinsicHeight',
      'LayoutBuilder', 'Opacity', 'Listener', 'RawGestureDetector',
      'DefaultSelectionStyle', 'IgnorePointer', 'ExcludeSemantics',
      'MergeSemantics', 'KeyedSubtree', 'AnimatedBuilder', 'Transform',
      'CustomPaint', 'Theme', 'IconTheme', 'MouseRegion', 'ColoredBox',
      'AnimatedDefaultTextStyle', 'PhysicalModel', 'PhysicalShape', 'Ink',
      'Actions', 'Focus', 'Shortcuts', 'FocusScope', 'SafeArea',
      'StretchEffect', 'ClipRect', 'KeepAlive', 'AutomaticKeepAlive',
      'IndexedSemantics', 'AnimatedPhysicalModel', 'Scrollable', 'Viewport',
      'SingleChildScrollView', 'ListView', 'SliverList', 'Scrollbar',
      'RawScrollbar', 'GlowingOverscrollIndicator', 'ScrollConfiguration',
      'PrimaryScrollController', 'AnimatedSize', 'Pressable', 'ContentColumn',
      'TextFieldTapRegion', 'TapRegion', 'Offstage', 'Visibility',
      'ScrollNotificationObserver', 'SliverPadding', 'SizeChangedLayoutNotifier',
    };
    if (n.startsWith('_') || skip.contains(n) || n.startsWith('NotificationListener')) {
      return true;
    }
    names.add(n);
    return names.length < 4;
  });
  return names.join('<');
}

/// 행 끝 빈 공간이 **Figma 대로인** 곳. 추가하려면 Figma 노드와 근거를 반드시 적는다.
/// 「고치기 귀찮다」는 사유가 아니다 — 근거 없는 추가는 이 시험을 끄는 것과 같다.
const _allowed = <String, String>{
  // screen/record_list `3360:83` Top Navigation: primaryAxisAlignItems=MIN, 버튼 둘 HUG
  // (x 20·90) — 탭은 왼쪽에 붙고 나머지는 비어 있는 것이 디자인이다.
  'SegmentedTabs': 'Figma 3360:83 MIN·HUG',
  // plans_compare `4514:5226` card/free: 배지 「Current」는 제목 바로 옆, 가격은 바깥 행의
  // 오른쪽 끝. 걸리는 것은 제목+배지 안쪽 행이라 뒤가 비는 것이 맞다.
  'PlanSummaryCard': 'Figma 4514:5226 배지=제목 옆',
};

void main() {
  // 짧은 글자·긴 글자를 섞는다. ko·ja 는 시험 폰트 폭이 실제와 가깝다.
  const locales = [Locale('en'), Locale('ko'), Locale('ja')];
  const size = Size(360, 780);

  testWidgets('늘어나는 칸이 있는데 행 끝에 빈 공간이 남지 않는다', (tester) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final found = <String, Set<String>>{}; // 위치 → 화면들
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
              ro.mainAxisAlignment == MainAxisAlignment.start) {
            var used = 0.0;
            var flexCount = 0;
            var sawLoose = false;
            var anchorAfterLoose = false;
            var looseCount = 0;
            ro.visitChildren((c) {
              if (c is! RenderBox || !c.hasSize) return;
              used += c.size.width;
              final pd = c.parentData;
              final flex = pd is FlexParentData ? (pd.flex ?? 0) : 0;
              if (flex > 0) {
                flexCount++;
                if (pd is FlexParentData && pd.fit == FlexFit.loose) {
                  sawLoose = true;
                  looseCount++;
                }
              } else if (sawLoose && c.size.width > 0) {
                anchorAfterLoose = true;
              }
            });
            final free = ro.size.width - used;
            final ownerChain = _owner(ro);
            if (looseCount > 0 &&
                (flexCount >= 2 || anchorAfterLoose) &&
                free > 16 &&
                !_allowed.containsKey(ownerChain.split('<').first)) {
              // 행 안 글자와 칸 구성을 붙인다 — 어느 행인지 바로 찾게.
              final texts = <String>[];
              void collect(RenderObject r) {
                if (r is RenderParagraph) texts.add(r.text.toPlainText());
                r.visitChildren(collect);
              }
              collect(ro);
              final kinds = <String>[];
              ro.visitChildren((c) {
                final pd = c.parentData;
                final flex = pd is FlexParentData ? (pd.flex ?? 0) : 0;
                final fit = pd is FlexParentData ? pd.fit : null;
                final w = c is RenderBox && c.hasSize ? c.size.width.toStringAsFixed(0) : '?';
                kinds.add(flex > 0
                    ? (fit == FlexFit.loose ? 'Flexible($flex)$w' : 'Expanded($flex)$w')
                    : 'fixed$w');
              });
              final owner = '$ownerChain [${kinds.join(' ')}] "${texts.take(3).join(' | ')}"';
              found.putIfAbsent(owner, () => {}).add(entry.key);
              found[owner]!.add('__${free.toStringAsFixed(0)}');
            }
          }
          ro.visitChildren(visit);
        }

        final root = tester.binding.renderViews.first;
        visit(root);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }

    if (found.isNotEmpty) {
      final lines = <String>[];
      found.forEach((owner, set) {
        final gaps = set.where((s) => s.startsWith('__')).map((s) => s.substring(2));
        final screens = set.where((s) => !s.startsWith('__')).toList()..sort();
        final maxGap = gaps.map(double.parse).fold<double>(0, (a, b) => a > b ? a : b);
        lines.add('  $owner — 최대 ${maxGap.toStringAsFixed(0)}px · ${screens.join(', ')}');
      });
      lines.sort();
      final f = File('build/dead_space_report.txt');
      f.parent.createSync(recursive: true);
      f.writeAsStringSync('${lines.join('\n')}\n');
      fail('늘어나는 칸이 있는데 행 끝에 빈 공간이 남는 행 ${found.length}곳:\n'
          '${lines.join('\n')}\n\n'
          '고치는 법: 끝에 붙어야 할 것 앞의 칸을 `Expanded` 로(몫을 꽉 채운다), '
          '또는 둘이 나란히 흐르면 `Wrap`. `Flexible` 은 필요한 만큼만 먹고 나머지를 버린다.');
    }
  });
}
