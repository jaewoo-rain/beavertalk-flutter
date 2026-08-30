// 조음 시트의 로케일별 오버플로 감사.
//
// `i18n_overflow_test.dart` 는 **화면**만 훑는다(`home:` 에 위젯을 꽂는 구조라
// 모달을 못 태운다). 조음 시트는 모달 바텀시트여서 그 감사에서 통째로 빠져 있었다.
//
// 🔴 이 감사는 **오버플로만** 잡는다. 말줄임은 못 잡는다 — `Button` 이 말줄임으로
//    하드닝돼 있어 긴 번역이 들어와도 오버플로를 안 내고 조용히 잘린다.
//    실측(2026-08-30·375dp) — 주행동 라벨의 가용 폭은 **127.8dp**(14px·w600)뿐이고
//    이는 라틴 문자 **9자** 남짓이다. 「Voz nativa」(142dp)조차 넘는다.
//    그래서 `articulationListenNative` 는 ko·zh 를 뺀 28/30 로케일에서 잘린다.
//    바꾸기 전 `listenStandard` 도 27/30 이 잘렸으므로 **이번 라벨 교체가 만든 결함이 아니라
//    Actions 행의 폭 배분(close flex 2 : CTA flex 3)이 원래 갖고 있던 현지화 결함이다.**
//    고치려면 폭 배분이나 버튼 배치를 바꿔야 하고 그건 시안 변경이다 — 핸드오프 참조.
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
