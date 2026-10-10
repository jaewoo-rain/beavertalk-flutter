// 조음 시트의 로케일별 오버플로 감사.
//
// `i18n_overflow_test.dart` 는 **화면**만 훑는다(`home:` 에 위젯을 꽂는 구조라
// 모달을 못 태운다). 조음 시트는 모달 바텀시트여서 그 감사에서 통째로 빠져 있었다.
//
// 🔴 이 감사는 **오버플로만** 잡는다. 말줄임은 못 잡는다 — `Button` 이 말줄임으로
//    하드닝돼 있어 긴 번역이 들어와도 오버플로를 안 내고 조용히 잘린다.
//
// ⛔ **주행동에 문장형 라벨을 다시 넣지 마라**(2026-08-31 해소). 이 칸의 라벨
//    가용 폭은 실측 **127.8dp**(14px·w600 · 라틴 약 9자)뿐이다. 측정 이력 —
//      `listenStandard`(문장)          27/30 잘림
//      `articulationListenNative`(문장) 28/30 잘림
//      `nativeLabel` + 볼륨 아이콘       15/30 잘림  ← 낱말 하나로 줄여도 안 된다
//      볼륨 아이콘 단독                    0/30       ← 지금
//    라틴권은 「Muttersprachler」(213dp)·「Носитель языка」(199dp), 버마어는
//    269.8dp 라 **어떤 번역어도 한 줄에 안 들어간다.** 폭 배분을 바꿔도 못 푼다
//    (닫기를 hug 로 줄여 최대치를 줘도 예산은 126dp 남짓이다).
//    ⇒ 아이콘 전용으로 가고, 이름은 [Semantics] 가 댄다.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/pronunciation/domain/phoneme_diagram.dart';
import 'package:beavertalk/features/pronunciation/presentation/articulation_sheet.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

void main() {
  // 좁은 폰(iPhone SE 급). 가로 오버플로는 여기서 먼저 드러난다.
  const narrow = Size(320, 640);

  /// 시트를 한 번 띄우고, 레이아웃 중 보고된 오버플로 문구를 모아 돌려준다.
  Future<List<String>> pumpSheet(
    WidgetTester tester,
    Locale locale, {
    required ArticulationSheetData data,
  }) async {
    final captured = <String>[];
    final prev = FlutterError.onError;
    // 오버플로는 throw 가 아니라 FlutterError.onError 로 보고된다. 에셋 로드
    // 실패 같은 무관한 렌더 오류는 걸러야 이 감사가 제 주장만 검증한다.
    FlutterError.onError = (details) {
      final s = details.toString();
      if (s.contains('overflowed') || s.contains('RenderFlex')) {
        captured.add(
          s
              .split('\n')
              .firstWhere((l) => l.contains('overflowed'),
                  orElse: () => s.split('\n').first)
              .trim(),
        );
      }
    };
    try {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showArticulationSheet(
                    context,
                    data: data,
                    onPlayNative: () {},
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      // pumpAndSettle 을 쓰지 않는다 — 에셋 로드 실패가 섞이면 정착 판정이
      // 흔들린다. 시트 등장 애니메이션보다 넉넉한 고정 프레임으로 민다.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    } catch (_) {
      // 오버플로가 아닌 렌더 오류(에셋 번들 부재 등)는 이 감사의 관심사가 아니다.
    } finally {
      FlutterError.onError = prev;
    }
    tester.takeException();
    await tester.pumpWidget(const SizedBox.shrink());
    return captured;
  }

  testWidgets('조음 시트가 30개 로케일에서 안 넘친다 @ 320×640', (tester) async {
    tester.view.physicalSize = narrow;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // 두 컷(현재↔목표)이 한 컷보다 가로가 빡빡하므로 두 컷으로 잰다.
    final twoCut = ArticulationSheetData(
      word: '제나예요.',
      target: diagramForJamo('ㄹ', isCoda: true)!,
      current: diagramForJamo('ㄴ', isCoda: true)!,
    );
    // 한 컷은 현행 폴백(서버가 음소를 안 줄 때)이라 함께 잰다.
    final oneCut = ArticulationSheetData(
      word: '제나예요.',
      target: diagramForJamo('ㅈ', isCoda: false)!,
    );

    final overflows = <String>[];
    for (final locale in AppLocalizations.supportedLocales) {
      for (final entry in {'두 컷': twoCut, '한 컷': oneCut}.entries) {
        final hits = await pumpSheet(tester, locale, data: entry.value);
        if (hits.isNotEmpty) {
          overflows.add(
            '${locale.toLanguageTag()} · ${entry.key}: ${hits.first}',
          );
        }
      }
    }

    if (overflows.isNotEmpty) {
      fail('조음 시트 오버플로 ${overflows.length}건:\n${overflows.join('\n')}');
    }
  });
}
