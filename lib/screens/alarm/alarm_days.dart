import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../core/format/dates.dart';

/// 알람 요일 표기 — 칩 라벨과 요약 줄이 같은 표를 본다.
///
/// 데이터는 **일요일부터**(0=일 … 6=토)이고, 화면은 **월요일부터** 늘어놓는다
/// (Figma `Panel/Repeat` 월→일).
///
/// 라벨은 `intl` 의 **약칭**(`DateFormat.E`)이다 — 사장님 결정(2026-09-22):
/// 한 글자로 줄이면 같은 글자가 겹친다(fr `L M M J V S D`). 약칭을 그대로 두고
/// 칩이 모자라면 **줄을 바꾼다**(칩 줄은 `Wrap`).
/// ⛔ 예전의 하드코딩 `'Mo','Tu',…` 로 돌아가지 마라 — 30개 언어 전부에서 영어가 나왔다.
abstract final class AlarmDays {
  /// 화면 순서(월→일)의 데이터 인덱스.
  static const List<int> displayOrder = [1, 2, 3, 4, 5, 6, 0];

  /// 요일 약칭 7개 — **데이터 순서**(일→토). [locale] 은 앱 로케일.
  static List<String> shortLabels(String locale) {
    final f = DateFormat.E(locale);
    // 2026-09-20 은 일요일이다. 그날부터 7일을 찍으면 일→토 순이다.
    // 약칭에 숫자가 드는 언어가 있다(vi 「Th 2」). 숫자 체계는 아라비아로 통일한다.
    return [
      for (var i = 0; i < 7; i++) asciiDigits(f.format(DateTime(2026, 9, 20 + i))),
    ];
  }

  /// 요약 한 줄 — 「매일」·「평일」·「주말」·「반복 안 함」, 그 밖에는 약칭을 월→일로
  /// ` · ` 로 잇는다.
  static String summary(List<bool> days, AppLocalizations l10n, String locale) {
    final on = [for (var i = 0; i < 7; i++) if (days[i]) i];
    if (on.isEmpty) return l10n.alarmNoRepeat;
    if (on.length == 7) return l10n.alarmEveryDay;
    if (on.length == 5 && !days[0] && !days[6]) return l10n.alarmWeekdays;
    if (on.length == 2 && days[0] && days[6]) return l10n.alarmWeekend;
    final labels = shortLabels(locale);
    // ⛔ 공백으로 잇지 마라 — vi 약칭은 그 자체에 공백이 있다(「Th 2」). 공백으로 이으면
    //   「Th 2 Th 3 Th 7」 이 되어 요일 경계가 안 보인다. 앱의 구분자 관례(`·`)를 쓴다.
    return [for (final i in displayOrder) if (days[i]) labels[i]].join(' · ');
  }
}
