// 잘림 감시 — 「넘침」이 아니라 「조용한 잘림」을 잡는다.
//
// ⛔ `i18n_overflow_test` 로는 이 결함을 못 잡는다. 그 시험은 `overflowed` ·
//   `RenderFlex` 만 실패로 보고, ellipsis 는 **성공으로 친다**(머릿말이
//   "must wrap/ellipsize, never overflow"다). 그래서 「초성 ㄲ」이 「초…」가 된
//   2026-09-21 결함은 그 시험을 정상으로 통과했다.
//
// 두 시험은 성격이 다르다.
//   넘침 = 화면 밖으로 나간다 → 보이지 않는다
//   잘림 = 화면 안에 있다     → **틀린 내용이 보인다**
// 뒤가 더 나쁘다. 잘린 금액·점수·이름은 빈 칸보다 나쁘다.
//
// 무엇을 검사하나: 화면에 실제로 그려진 TEXT 중 **잘리면 안 되는 것**이
// 잘렸는지 본다. 판정은 `TextPainter.didExceedMaxLines` 가 아니라 위젯이 실제로
// 쓴 `maxLines`·`overflow` 와 그려진 크기로 한다.
//
// ⚠ 산문까지 전부 검사하면 통화 요약·안내문이 죄다 걸려 소용이 없다. 그래서
//   **잘리면 안 되는 종류**(수치·식별자)만 본다 — 기준은 아래 `_mustNotTruncate`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/card_line.dart';
import 'package:beavertalk/components/molecules/level_progress.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/main.dart' show kMaxTextScale;
import 'package:beavertalk/theme/app_color_tokens.dart';

/// 이 문자열이 잘리면 **사실이 틀어지는가**.
///
/// 수치(금액·점수·비율·날짜)와 식별자(이름·라벨)가 대상이다. 산문은 아니다 —
/// 뜻이 줄어들 뿐 거짓이 되지 않는다.
bool _mustNotTruncate(String s) {
  if (s.trim().isEmpty) return false;
  // 숫자가 들어간 짧은 문자열 = 수치로 본다(「97 점」 · 「0 of 1」 · 날짜).
  final hasDigit = RegExp(r'[0-9]').hasMatch(s);
  if (hasDigit && s.length <= 40) return true;
  // 짧은 이름·라벨(공백 2개 이하)도 식별자로 본다.
  if (s.length <= 24 && s.trim().split(RegExp(r'\s+')).length <= 3) return true;
  return false;
}

/// 그려진 [Text] 가 한 줄로 잘리도록 설정돼 있는지.
bool _willTruncate(Text t) =>
    t.maxLines == 1 && t.overflow == TextOverflow.ellipsis;

Widget _host(Widget child, Locale locale, {double scale = 1.0}) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(extensions: const [AppColorTokens.light]),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: Center(child: SizedBox(width: 320, child: child)),
        ),
      ),
    );

void main() {
  // 길이가 가장 사나운 로케일 + 초단문 + RTL 을 함께 돌린다. 30개를 전부 돌리면
  // 느려지기만 하고 새로 걸리는 것이 없다(길이 순위가 이 안에 다 들어 있다).
  const locales = [
    Locale('fil'), Locale('fr'), Locale('hu'), Locale('my'),
    Locale('ar'), Locale('ur'), Locale('zh'), Locale('ko'),
  ];

  /// 한 위젯을 로케일마다 그려 보고, 잘리면 안 되는 텍스트가 잘리게 돼 있으면 모은다.
  Future<List<String>> sweep(
    WidgetTester tester,
    String name,
    Widget Function() build,
  ) async {
    final bad = <String>[];
    for (final locale in locales) {
      await tester.pumpWidget(_host(build(), locale));
      await tester.pump();
      for (final t in tester.widgetList<Text>(find.byType(Text))) {
        final s = t.data;
        if (s == null) continue;
        if (_willTruncate(t) && _mustNotTruncate(s)) {
          bad.add('${locale.languageCode} · $name: "$s"');
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    }
    return bad;
  }

  testWidgets('수치·식별자는 한 줄로 잘리게 두지 않는다', (tester) async {
    final bad = <String>[];

    // 결제 행 — 왼쪽 라벨, 오른쪽 금액. 금액이 잘리면 거짓이 된다.
    bad.addAll(await sweep(tester, 'CardLine/payment', () => const CardLine(
          type: CardLineType.payment,
          label: 'Talaan ng paggamit sa buwang ito',
          value: '1.790.000 ₫',
          status: 'Nabayaran na',
        )));

    // 설정 행 — 라벨/값 + 셰브론.
    bad.addAll(await sweep(tester, 'CardLine/defaultRow', () => const CardLine(
          type: CardLineType.defaultRow,
          label: 'Talaan ng paggamit sa buwang ito',
          value: '0 sa 1 ang nagamit na',
        )));

    bad.addAll(await sweep(tester, 'LevelProgress', () => const LevelProgress(
          level: 7,
          startLabel: 'Lefel 1 · Dechreuwr',
          endLabel: 'Lefel 13 · Uwch canolradd',
        )));

    if (bad.isNotEmpty) {
      fail(
        '잘리면 안 되는 문자열이 한 줄 + ellipsis 로 잡혀 있다 '
        '(${bad.length}건).\n잘린 값은 빈 값보다 나쁘다 — 사용자가 그것을 '
        '사실로 읽는다.\n${bad.join('\n')}',
      );
    }
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 상자가 글자를 자르는 경우 — **위 두 시험 어느 쪽도 못 잡는다.**
  //
  // 행 높이를 고정해 두면(`SizedBox(height: 56)`) 글자가 그 안에서 조용히
  // 잘린다. `maxLines`·`overflow` 는 멀쩡하니 잘림 시험이 못 보고, Flutter 가
  // 넘침 예외를 던지지도 않으니(`Text` 는 제 상자 안에서 스스로 클립한다)
  // 넘침 시험도 못 본다. 그래서 **그려진 높이를 직접 재는** 시험이 따로 있다.
  //
  // 2026-09-22 실기기(네팔어 · 글꼴 200%→상한)에서 설정 이메일이
  // `soardick@gmail.` 로, 가입일 라벨은 둘째 줄이 통째로 잘려 나왔다.
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('글꼴 배율 상한에서 행이 글자를 자르지 않는다', (tester) async {
    final bad = <String>[];

    /// 그려진 [Text] 가 필요한 높이보다 낮은 상자에 갇혔는지.
    void check(WidgetTester t, String where) {
      for (final el in t.elementList(find.byType(Text))) {
        final w = el.widget as Text;
        final s = w.data;
        if (s == null || s.trim().isEmpty) continue;
        // 한 줄로 자르기로 **명시한** 것은 여기서 볼 대상이 아니다(앞 시험 몫).
        if (w.maxLines == 1) continue;
        final box = el.renderObject! as RenderBox;
        final painter = TextPainter(
          text: TextSpan(text: s, style: w.style),
          textDirection: TextDirection.ltr,
          textScaler: MediaQuery.of(el).textScaler,
          maxLines: w.maxLines,
        )..layout(maxWidth: box.size.width);
        // 반올림 여유 1px.
        if (painter.height > box.size.height + 1) {
          bad.add(
            '$where: "$s" — 필요 ${painter.height.toStringAsFixed(1)}px / '
            '상자 ${box.size.height.toStringAsFixed(1)}px',
          );
        }
      }
    }

    for (final locale in locales) {
      await tester.pumpWidget(_host(
        const CardLine(
          type: CardLineType.defaultRow,
          label: 'Talaan ng paggamit sa buwang ito',
          value: 'soardick@gmail.com',
        ),
        locale,
        scale: kMaxTextScale,
      ));
      await tester.pump();
      check(tester, '${locale.languageCode} · CardLine/defaultRow');
      await tester.pumpWidget(const SizedBox.shrink());
    }

    if (bad.isNotEmpty) {
      fail(
        '고정 높이가 글자를 자르고 있다 (${bad.length}건).\n'
        '높이는 고정이 아니라 **하한**이어야 한다 '
        '(`BoxConstraints(minHeight: …)`).\n${bad.join('\n')}',
      );
    }
  });
}
