// 숫자는 **아라비아 숫자로 통일한다**(사장님 확정 2026-09-22 · 남은판단 P9).
//
// 이 시험이 지키는 것은 두 가지다.
//   ① 현지 숫자를 쓰는 세 로케일(ne·bn·my)의 날짜가 ASCII 로 나온다
//   ② 나머지 로케일의 글자는 **하나도 안 바뀐다**(월 이름까지 그대로여야 한다)
//
// ⛔ `-u-nu-latn` 로케일 확장으로 풀려고 하지 마라. Dart intl 이 무시한다 —
//   아래 마지막 시험이 그 사실을 박제한다. 표준 경로가 열리면 이 시험이 깨지고,
//   그때 `asciiDigits` 를 걷어내면 된다.
import 'package:beavertalk/core/format/dates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  // 실측으로 고른 목록이다(2026-09-22, 지원 30개 로케일 전부 확인).
  // 힌디·아랍어·태국어·크메르어는 글자만 현지 문자고 숫자는 이미 ASCII 다.
  const localDigitLocales = ['ne', 'bn', 'my'];
  const asciiDigitLocales = ['ko', 'en', 'hi', 'ar', 'ur', 'th', 'km', 'zh'];

  setUpAll(() async {
    for (final l in [...localDigitLocales, ...asciiDigitLocales]) {
      await initializeDateFormatting(l);
    }
  });

  test('현지 숫자 세 로케일의 날짜가 ASCII 로 나온다', () {
    final d = DateTime(2026, 9, 22);
    for (final loc in localDigitLocales) {
      final raw = DateFormat.yMMMd(loc).format(d);
      final out = asciiDigits(raw);

      // 전제가 깨지면 알려야 한다 — 그 로케일이 더는 현지 숫자를 안 쓰는 것이다.
      expect(RegExp(r'[0-9]').hasMatch(raw), isFalse,
          reason: '$loc 이 이미 ASCII 다($raw). 목록에서 빼도 된다');

      expect(out, contains('2026'), reason: '$loc: $raw → $out');
      expect(out, contains('22'), reason: '$loc: $raw → $out');
      // 바뀐 것은 숫자뿐이다 — 글자 수가 같아야 한다.
      expect(out.length, raw.length, reason: '$loc: 숫자 외에 손댔다');
    }
  });

  test('나머지 로케일은 한 글자도 안 바뀐다', () {
    final d = DateTime(2026, 9, 22);
    for (final loc in asciiDigitLocales) {
      final raw = DateFormat.yMMMd(loc).format(d);
      expect(asciiDigits(raw), raw, reason: '$loc 의 글자를 건드렸다');
    }
  });

  test('숫자가 아닌 글자는 건드리지 않는다', () {
    // 데바나가리 자음 ग(0x0917)은 숫자 구간(0x0966~0x096F) 밖이다.
    expect(asciiDigits('गणित २०२६'), 'गणित 2026');
    expect(asciiDigits(''), '');
    expect(asciiDigits('Jun 20, 2026'), 'Jun 20, 2026');
  });

  test('⛔ -u-nu-latn 은 Dart intl 에서 안 먹는다(이 시험이 깨지면 좋은 일이다)',
      () async {
    await initializeDateFormatting('ne-u-nu-latn');
    final out = DateFormat.yMMMd('ne-u-nu-latn').format(DateTime(2026, 9, 22));
    expect(RegExp(r'[0-9]').hasMatch(out), isFalse,
        reason: 'intl 이 -u-nu-latn 을 지원하기 시작했다 → asciiDigits 를 걷어내라');
  });
}
