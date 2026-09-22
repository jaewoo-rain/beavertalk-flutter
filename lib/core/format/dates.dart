import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-following date labels for the subscription surfaces.
///
/// These exist because three screens each grew their own
/// `DateFormat('MMM d, yyyy', 'en_US')` — an English date in 30 UI languages.
/// `GlobalMaterialLocalizations` (wired in `main.dart`) initializes intl's
/// date symbols for the active locale, so formatting by the ambient locale is
/// safe here.

/// 숫자를 **아라비아 숫자로 통일한다**(사장님 확정 2026-09-22 · 남은판단 P9).
///
/// `intl` 은 로케일의 기본 숫자 체계를 따른다. 그래서 날짜만 현지 숫자가 되고
/// (`ne` 「२०२६」), 점수·비율·카운터는 Dart 문자열 보간이라 ASCII 로 남아
/// **한 화면에 두 체계가 섞였다.**
///
/// 실측(2026-09-22, 지원 30개 로케일 전부) — 현지 숫자를 쓰는 언어는 **셋뿐**이다.
/// `ne`(데바나가리) · `bn`(벵골) · `my`(버마). 힌디·아랍어·태국어·크메르어는
/// 글자만 현지 문자고 숫자는 이미 아라비아 숫자다.
///
/// ⛔ 로케일 확장 `-u-nu-latn` 으로 풀려고 하지 마라. **Dart intl 이 무시한다**
///   (실측: `DateFormat.yMMMd('ne-u-nu-latn')` 이 그대로 「२०२६」을 냈다).
///   표준 경로가 막혀 있어서 결과 문자열을 직접 바꾸는 수밖에 없다.
///
/// 왜 ASCII 인가 — 학습자가 앱에서 배우는 한국어 숫자가 아라비아 숫자다. UI 만
/// 현지 숫자면 배우는 것과 보는 것이 갈린다.
String asciiDigits(String s) {
  // 세 문자의 0 코드포인트. 각 자리는 연속이라 0 과의 차이로 환산한다.
  const bases = <int>[
    0x0966, // DEVANAGARI DIGIT ZERO  — ne
    0x09E6, // BENGALI DIGIT ZERO     — bn
    0x1040, // MYANMAR DIGIT ZERO     — my
  ];
  // 흔한 경우(ASCII 만 있는 27개 로케일)에서 새 문자열을 만들지 않는다.
  var needs = false;
  for (final c in s.codeUnits) {
    for (final b in bases) {
      if (c >= b && c <= b + 9) {
        needs = true;
        break;
      }
    }
    if (needs) break;
  }
  if (!needs) return s;

  final out = StringBuffer();
  for (final c in s.codeUnits) {
    var done = false;
    for (final b in bases) {
      if (c >= b && c <= b + 9) {
        out.writeCharCode(0x30 + (c - b));
        done = true;
        break;
      }
    }
    if (!done) out.writeCharCode(c);
  }
  return out.toString();
}

/// `Jun 20, 2026` — the full form the manage screen and sheets use.
String localizedFullDate(BuildContext context, DateTime d) => asciiDigits(
      DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(d),
    );

/// `Jun 20` — the short form footnotes use.
String localizedShortDate(BuildContext context, DateTime d) => asciiDigits(
      DateFormat.MMMd(Localizations.localeOf(context).toString()).format(d),
    );
